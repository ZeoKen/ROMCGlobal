autoImport("PersonalArtifactExchangeItemCell")
autoImport("MaterialSelectItemCell")
autoImport("EquipChooseBord")
PersonalArtifactExchangeView = class("PersonalArtifactExchangeView", BaseView)
PersonalArtifactExchangeView.ViewType = UIViewType.NormalLayer
local bagIns, tickManager, bagType

function PersonalArtifactExchangeView:Init()
  if not bagIns then
    bagIns = BagProxy.Instance
    tickManager = TimeTickManager.Me()
    bagType = BagProxy.BagType.PersonalArtifactFragment
  end
  self:AddEvents()
  self:InitData()
  self:InitRight()
  self:InitTargetSelect()
  self:InitMaterialSelect()
end

function PersonalArtifactExchangeView:AddEvents()
  self:AddListenEvt(MyselfEvent.ZenyChange, self.UpdateCostLabelColor)
  self:AddListenEvt(ItemEvent.PersonalArtifactUpdate, self.OnPersonalArtifactUpdate)
  self:AddListenEvt(ServiceUserProxy.RecvLogin, self.CloseSelf)
end

function PersonalArtifactExchangeView:InitData()
  self.selectedMaterialData = {}
  self.maxMaterialCount = 5
  self.tipData = {
    funcConfig = _EmptyTable
  }
end

local skipAnimTipOffset = {90, -75}

function PersonalArtifactExchangeView:InitRight()
  self.skipBtnSp = self:FindComponent("SkipBtn", UISprite)
  self:AddButtonEvent("SkipBtn", function()
    TipManager.Instance:ShowSkipAnimationTip(SKIPTYPE.PersonalArtifactExchange, self.skipBtnSp, NGUIUtil.AnchorSide.Right, skipAnimTipOffset)
  end)
  self.effectContainer = self:FindGO("EffectContainer")
  self.normalStick = self:FindComponent("NormalStick", UIWidget)
  self.mainLabel = self:FindComponent("MainLabel", UILabel)
  local titleLabel = self:FindComponent("TitleLabel", UILabel)
  titleLabel.text = Table_NpcFunction[11004].NameZh
  local itemCell = self:LoadPreferb("cell/BagItemCell", self:FindGO("TargetCell"))
  self.targetCell = BagItemCell.new(itemCell)
  self:AddClickEvent(itemCell, function()
    self:OnClickTargetCell()
  end)
  local longPress = itemCell:GetComponent(UILongPress)
  longPress.pressTime = 0.5
  
  function longPress.pressEvent(obj, isPressing)
    if not isPressing then
      return
    end
    self:ShowItemTip(self.targetCell.data, 30)
    self.isClickOnTargetCellDisabled = true
  end
  
  self.targetCellItemPart = self:FindGO("Common_ItemCell", itemCell)
  self.costSprite = self:FindComponent("CostSprite", UISprite)
  self.costLabel = self:FindComponent("CostLabel", UILabel)
  local exchangeBtn = self:FindGO("ExchangeBtn")
  self:AddClickEvent(exchangeBtn, function()
    self:TryExchange()
  end)
  self.exchangeBtnBgSp = exchangeBtn:GetComponent(UISprite)
  self.exchangeBtnLabel = self:FindComponent("Label", UILabel, exchangeBtn)
  self.materialGO = self:FindGO("5Material")
  self.materialListCtrl = ListCtrl.new(self:FindComponent("Grid", UIGrid, self.materialGO), MaterialSelectItemCell, "MaterialSelectItemCell")
  self.materialListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickMaterialCell, self)
  self.materialListCtrl:AddEventListener(ItemEvent.ItemDeselect, self.OnClickMaterialCell, self)
end

function PersonalArtifactExchangeView:InitTargetSelect()
  self.targetSelectBord = EquipChooseBord.new(self:FindGO("ChooseContainer"))
  self.targetSelectBord:SetBordTitle(ZhString.PersonalArtifact_ChooseFragmentBordTitle)
  self.targetSelectBord:Hide()
end

function PersonalArtifactExchangeView:InitMaterialSelect()
  self.materialSelectGO = self:FindGO("MaterialSelect")
  self:AddButtonEvent("CloseMaterialSelectBtn", function()
    self.materialSelectGO:SetActive(false)
  end)
  self.materialContainer = self:FindGO("MaterialContainer", self.materialSelectGO)
  self.materialSelectCtrl = WrapListCtrl.new(self.materialContainer, PersonalArtifactExchangeItemCell, "BagItemCell", WrapListCtrl_Dir.Vertical, 5, 102, true)
  self.materialSelectCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickMaterialSelectCell, self)
  self.materialSelectCtrl:AddEventListener(MouseEvent.LongPress, self.OnLongPressMaterialSelectCell, self)
  self.materialSelectCells = self.materialSelectCtrl:GetCells()
end

function PersonalArtifactExchangeView:OnEnter()
  PersonalArtifactExchangeView.super.OnEnter(self)
  self:SetItemToExchange()
  self:UpdateSelectedMaterial()
  self:OnClickTargetCell()
  if not self.backEffect then
    self:PlayUIEffect(EffectMap.UI.GemViewSynthetic, self.effectContainer, false, function(obj, args, assetEffect)
      self.backEffect = assetEffect
      self.backEffect:ResetAction("ronghe_1", 0, true)
    end)
  else
    self.backEffect:ResetAction("ronghe_1", 0, true)
  end
  self:SetExchangeBtnActive(false)
end

function PersonalArtifactExchangeView:OnExit()
  tickManager:ClearTick(self)
  PersonalArtifactExchangeView.super.OnExit(self)
end

function PersonalArtifactExchangeView:OnClickTargetCell()
  if self.isClickOnTargetCellDisabled then
    self.isClickOnTargetCellDisabled = nil
    return
  end
  self.materialSelectGO:SetActive(false)
  self.candidates = self.candidates or {}
  if not next(self.candidates) then
    for id, data in pairs(GameConfig.PersonalArtifact.ExchangeItem) do
      if data.quality > 0 then
        TableUtility.ArrayPushBack(self.candidates, ItemData.new("TargetSelect" .. id, id))
      end
    end
  end
  table.sort(self.candidates, function(l, r)
    return l.id < r.id
  end)
  if #self.candidates > 1 then
    self.targetSelectBord:Set_CheckValidFunc()
    self.targetSelectBord:UpdateChooseInfo(self.candidates)
    self.targetSelectBord:Show(nil, self.OnClickTargetSelectCell, self)
    self.targetSelectBord.chooseCtl:ResetPosition()
  elseif #self.candidates == 1 then
    self:OnClickTargetSelectCell(self.candidates[1])
  else
    LogUtility.Warning("There is no candidates for exchanging")
  end
end

function PersonalArtifactExchangeView:OnClickTargetSelectCell(data)
  self.materialSelectGO:SetActive(true)
  self.targetSelectBord:Hide()
  self:SetItemToExchange(data)
end

function PersonalArtifactExchangeView:OnClickMaterialCell(cellCtl)
  if not self.targetFragmentStaticId then
    MsgManager.ShowMsgByID(41332)
    return
  end
  if self.isExchanging then
    return
  end
  self.targetSelectBord:Hide()
  self.materialSelectGO:SetActive(true)
  local data = cellCtl.data
  TableUtility.ArrayRemoveByPredicate(self.selectedMaterialData, function(item)
    return BagItemCell.CheckData(data) and data.id == item.id
  end)
  self:UpdateSelectedMaterial()
  self:UpdateMaterialSelectList()
end

function PersonalArtifactExchangeView:OnClickMaterialSelectCell(cellCtl)
  if self.isExchanging then
    return
  end
  if self.isClickOnListCtrlDisabled then
    self.isClickOnListCtrlDisabled = nil
    return
  end
  local data = cellCtl and cellCtl.data
  if not data then
    return
  end
  for _, cell in pairs(self.materialSelectCells) do
    cell:SetChooseId(data and data.id or 0)
  end
  if #self.selectedMaterialData < self.maxMaterialCount then
    if 0 < self:GetUnselectedCountByStaticId(data.id) then
      local cloneData = data:Clone()
      cloneData:SetItemNum(1)
      TableUtility.ArrayPushBack(self.selectedMaterialData, cloneData)
    end
    self:UpdateSelectedMaterial()
    self:UpdateMaterialSelectList()
  end
end

function PersonalArtifactExchangeView:OnLongPressMaterialSelectCell(param)
  local isPressing, cellCtl = param[1], param[2]
  if isPressing and cellCtl and cellCtl.data then
    self:ShowItemTip(bagIns:GetItemByGuid(cellCtl.data.id))
    self.isClickOnListCtrlDisabled = true
  end
end

function PersonalArtifactExchangeView:OnPersonalArtifactUpdate()
  TableUtility.ArrayClear(self.selectedMaterialData)
  self:UpdateSelectedMaterial()
  self:UpdateMaterialSelectList(true)
end

function PersonalArtifactExchangeView:SetItemToExchange(data)
  self.mainLabel.text = data == nil and ZhString.PersonalArtifact_ExchangeTipWithoutTarget or ZhString.PersonalArtifact_ExchangeTipWithTarget
  local oldTargetFragmentStaticId = self.targetFragmentStaticId
  self:SetTargetCellData(data)
  if not data then
    return
  end
  if self.targetFragmentStaticId ~= oldTargetFragmentStaticId then
    self:OnPersonalArtifactUpdate()
  end
end

local comparer = function(l, r)
  return l.staticData.id < r.staticData.id
end

function PersonalArtifactExchangeView:UpdateMaterialSelectList(resetAll)
  if not self.materialSelectGO.activeInHierarchy then
    return
  end
  if not self.targetFragmentStaticId then
    LogUtility.Error("Cannot get materials when target fragment is nil")
    self.materialSelectGO:SetActive(false)
    return
  end
  if resetAll or not self.materialSelectDatas then
    self.materialSelectDatas = {}
    local sId, fakeItem
    for i = 1, #self.targetQualityFragmentIds do
      sId = self.targetQualityFragmentIds[i]
      fakeItem = ItemData.new("Material", sId)
      fakeItem:SetItemNum(PersonalArtifactProxy.GetFragmentItemNumByStaticId(sId))
      TableUtility.ArrayPushBack(self.materialSelectDatas, fakeItem)
    end
    table.sort(self.materialSelectDatas, comparer)
  end
  for _, item in pairs(self.materialSelectDatas) do
    item:SetItemNum(self:GetUnselectedCountByStaticId(item.id))
  end
  self.materialSelectCtrl:ResetDatas(self.materialSelectDatas, resetAll)
end

function PersonalArtifactExchangeView:UpdateSelectedMaterial()
  TipManager.CloseTip()
  local tempArr = ReusableTable.CreateArray()
  TableUtility.ArrayShallowCopy(tempArr, self.selectedMaterialData)
  for i = #self.selectedMaterialData + 1, self.maxMaterialCount do
    TableUtility.ArrayPushBack(tempArr, BagItemEmptyType.Empty)
  end
  self.materialListCtrl:ResetDatas(tempArr)
  for _, cell in pairs(self.materialListCtrl:GetCells()) do
    if cell.data ~= BagItemEmptyType.Empty then
      cell:TrySetShowDeselect(true)
    end
  end
  ReusableTable.DestroyAndClearArray(tempArr)
  self:CheckExchangeReady()
end

function PersonalArtifactExchangeView:CheckExchangeReady()
  local isReady = #self.selectedMaterialData == self.maxMaterialCount
  self:SetExchangeBtnActive(isReady)
  self:SetCost(GameConfig.PersonalArtifact.ExchangeCostItemId, isReady and GameConfig.PersonalArtifact.ExchangeCostItemCount or 0)
end

function PersonalArtifactExchangeView:TryExchange()
  if not self.isExchangeBtnActive then
    return
  end
  if not self.targetFragmentStaticId then
    MsgManager.ShowMsgByID(41332)
    return
  end
  if not self:CheckCostItem() then
    MsgManager.ShowMsgByIDTable(25418, Table_Item[self.costItemId].NameZh)
    return
  end
  if bagIns:CheckBagIsFull(BagProxy.BagType.MainBag) then
    MsgManager.ShowMsgByID(989)
    return
  end
  self:TryPlayEffectThenCall(self._Exchange)
end

function PersonalArtifactExchangeView:_Exchange()
  PersonalArtifactProxy.CallExchange(self.targetFragmentStaticId, self.selectedMaterialData)
  self.isExchanging = nil
end

function PersonalArtifactExchangeView:TryPlayEffectThenCall(func)
  self.isExchanging = true
  local delayedTime = 1000
  if self.foreEffect then
    self.foreEffect:Stop()
  end
  if LocalSaveProxy.Instance:GetSkipAnimation(SKIPTYPE.PersonalArtifactExchange) then
    func(self)
  else
    local actionName = "ronghe_2"
    self:PlayUIEffect(EffectMap.UI.GemViewSynthetic, self.effectContainer, true, function(obj, args, assetEffect)
      self.foreEffect = assetEffect
      self.foreEffect:ResetAction(actionName, 0, true)
    end)
    if self.backEffect then
      self.backEffect:ResetAction(actionName, 0, true)
    end
    delayedTime = 4000
    tickManager:CreateOnceDelayTick(delayedTime, func, self, 1)
  end
  self:SetExchangeBtnActive(false)
  tickManager:CreateOnceDelayTick(delayedTime + 800, self.CheckExchangeReady, self, 2)
end

local tipOffset = {0, 0}

function PersonalArtifactExchangeView:ShowItemTip(itemData, tipOffsetX)
  if not itemData then
    TipManager.CloseTip()
    return
  end
  self.tipData.itemdata = itemData
  tipOffset[1] = tipOffsetX or 180
  TipManager.Instance:ShowItemFloatTip(self.tipData, self.normalStick, NGUIUtil.AnchorSide.Right, tipOffset)
end

function PersonalArtifactExchangeView:SetTargetCellData(data)
  self.targetCellItemPart:SetActive(data ~= nil)
  self.targetFragmentStaticId = data and data.staticData.id
  if not self.targetFragmentStaticId then
    return
  end
  self.targetCell:SetData(data)
  self.targetQualityFragmentIds = PersonalArtifactProxy.Instance:GetFragmentItemIdsByQuality(data.staticData.Quality)
end

function PersonalArtifactExchangeView:SetExchangeBtnActive(isActive)
  isActive = isActive and true or false
  self.isExchangeBtnActive = isActive
  self.exchangeBtnBgSp.spriteName = isActive and "com_btn_1" or "com_btn_13"
  self.exchangeBtnLabel.effectColor = isActive and ColorUtil.ButtonLabelBlue or ColorUtil.NGUIGray
end

function PersonalArtifactExchangeView:SetCost(itemId, cost)
  if type(itemId) ~= "number" or type(cost) ~= "number" then
    LogUtility.Error("Invalid argument while calling SetCost!")
    return
  end
  self.costItemId = itemId
  self.cost = cost
  IconManager:SetItemIcon(Table_Item[itemId].Icon, self.costSprite)
  self.costLabel.text = StringUtil.NumThousandFormat(cost)
  self:UpdateCostLabelColor()
end

local costLabelColor = LuaColor.New(0.37254901960784315, 0.37254901960784315, 0.37254901960784315, 1)

function PersonalArtifactExchangeView:UpdateCostLabelColor()
  self.costLabel.color = not self:CheckCostItem() and ColorUtil.Red or costLabelColor
end

function PersonalArtifactExchangeView:CheckCostItem()
  if not self.costItemId then
    LogUtility.Warning("Cannot get id of cost item while checking")
    return
  end
  return HappyShopProxy.Instance:GetItemNum(self.costItemId) >= (self.cost or math.huge)
end

function PersonalArtifactExchangeView:GetSelectedCountByStaticId(sId)
  local count = 0
  for _, selected in pairs(self.selectedMaterialData) do
    if selected.staticData.id == sId then
      count = count + 1
    end
  end
  return count
end

function PersonalArtifactExchangeView:GetUnselectedCountByStaticId(sId)
  return PersonalArtifactProxy.GetFragmentItemNumByStaticId(sId) - self:GetSelectedCountByStaticId(sId)
end
