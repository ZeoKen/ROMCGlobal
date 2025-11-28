autoImport("EquipChooseCell")
autoImport("PersonalArtifactRefreshAttributeCell")
PersonalArtifactRefreshView = class("PersonalArtifactRefreshView", BaseView)
PersonalArtifactRefreshView.ViewType = UIViewType.NormalLayer
local buttonsTimeTickId = 9
local bagIns, tickManager, equipPackageCheck, costPackageCheck

function PersonalArtifactRefreshView:Init()
  if not bagIns then
    bagIns = BagProxy.Instance
    tickManager = TimeTickManager.Me()
    equipPackageCheck = {
      BagProxy.BagType.RoleEquip,
      BagProxy.BagType.PersonalArtifact
    }
    costPackageCheck = GameConfig.PackageMaterialCheck.equip_remould or GameConfig.PackageMaterialCheck.default
  end
  self:InitData()
  self:InitLeft()
  self:InitRight()
  self:RegistShowGeneralHelpByHelpID(35042, self:FindGO("HelpButton"))
  self:AddEvents()
end

function PersonalArtifactRefreshView:InitData()
  self.tipData = {
    funcConfig = _EmptyTable
  }
  self.cachedTargetAttrMap = {}
  self.clickButtonEnabled = true
end

function PersonalArtifactRefreshView:InitLeft()
  self.leftNoneTip = self:FindGO("LeftNoneTip")
  self.equipListCtl = ListCtrl.new(self:FindComponent("EquipGrid", UIGrid), EquipChooseCell, "PersonalArtifactRefreshChooseCell")
  self.equipListCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickEquip, self)
  self.equipListCtl:AddEventListener(EquipChooseCellEvent.ClickItemIcon, self.OnClickEquip, self)
  self.equipListCells = self.equipListCtl:GetCells()
  self.normalStick = self:FindComponent("NormalStick", UIWidget)
end

function PersonalArtifactRefreshView:InitRight()
  self.rightNoneTip = self:FindGO("RightNoneTip")
  self.attrGrid = self:FindComponent("AttriGrid", UIGrid)
  self.attrListCtl = ListCtrl.new(self.attrGrid, PersonalArtifactRefreshAttributeCell, "PersonalArtifactRefreshAttributeCell")
  self.attrListCells = self.attrListCtl:GetCells()
  self.costItemSp = self:FindComponent("CostItem", UISprite)
  self.costLabel = self:FindComponent("CostLabel", UILabel)
  self.costAddBtn = self:FindGO("CostAddBtn")
  self.HCostItemSp = self:FindComponent("HCostItem", UISprite)
  self.HCostLabel = self:FindComponent("HCostLabel", UILabel)
  self.HCostAddBtn = self:FindGO("HCostAddBtn")
  self.ctrlParent = self:FindGO("Ctrls")
  self.refreshCtrl = self:FindGO("RefreshCtrl")
  self.saveCtrl = self:FindGO("SaveCtrl")
  self.refreshBtnSp = self:FindComponent("RefreshBtn", UIMultiSprite)
  self.HRefreshBtnSp = self:FindComponent("HRefreshBtn", UIMultiSprite)
  self.advancedToggle = self:FindComponent("AdvancedToggle", UIToggle)
  self.advancedCollider = self:FindComponent("AdvancedToggle", BoxCollider)
  EventDelegate.Add(self.advancedToggle.onChange, function()
    self:UpdateCost()
  end)
end

function PersonalArtifactRefreshView:AddEvents()
  local tryRefreshFunc = function(isH)
    if not self.clickButtonEnabled then
      return
    end
    if not self:CheckRefresh(isH) then
      return
    end
    if self:CheckAttrsAllMax() then
      MsgManager.ShowMsgByID(41399)
      return
    end
    self:SetButtonsEnabled(false)
    tickManager:CreateOnceDelayTick(500, function(self)
      self:SetButtonsEnabled(true)
    end, self, buttonsTimeTickId)
    local t
    if isH then
      t = self:GetAdvancedToggleValue() and SceneItem_pb.PERSONALARTIFACT_REMOULD_TYPE_PAY_TEN or SceneItem_pb.PERSONALARTIFACT_REMOULD_TYPE_PAY
    else
      t = SceneItem_pb.PERSONALARTIFACT_REMOULD_TYPE_FREE
    end
    ServiceItemProxy.Instance:CallPersonalArtifactRemouldItemCmd(self.targetItem.id, t)
  end
  self:AddButtonEvent("RefreshBtn", function()
    tryRefreshFunc(false)
  end)
  self:AddButtonEvent("HRefreshBtn", function()
    tryRefreshFunc(true)
  end)
  self:AddButtonEvent("SaveBtn", function()
    if not self.clickButtonEnabled then
      return
    end
    if not self.targetItem then
      LogUtility.Error("Cannot get target item while saving!")
      return
    end
    ServiceItemProxy.Instance:CallPersonalArtifactAttrSaveItemCmd(self.targetItem.id, true)
  end)
  
  function self.cancelSavingFunc()
    ServiceItemProxy.Instance:CallPersonalArtifactAttrSaveItemCmd(self.targetItem.id, false)
  end
  
  self:AddButtonEvent("CancelBtn", function()
    if not self.clickButtonEnabled then
      return
    end
    if not self.targetItem then
      LogUtility.Error("Cannot get target item while cancelling save!")
      return
    end
    if self:CheckHasBetterAttrToSave() then
      MsgManager.ConfirmMsgByID(41342, self.cancelSavingFunc)
    else
      self.cancelSavingFunc()
    end
  end)
  self:AddClickEvent(self.costAddBtn, function()
    if not self.clickButtonEnabled then
      return
    end
    local id = GameConfig.PersonalArtifact.ShopID
    if not id then
      return
    end
    HappyShopProxy.Instance:InitShop(nil, 1, id)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.HappyShop
    })
  end)
  self:AddClickEvent(self.HCostAddBtn, function()
    if not self.clickButtonEnabled then
      return
    end
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TShop, FunctionNewRecharge.InnerTab.Shop_Normal1)
  end)
  self:AddListenEvt(MyselfEvent.ZenyChange, self.UpdateCostWidgets)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateCostWidgets)
  self:AddListenEvt(ItemEvent.PersonalArtifactUpdate, self.OnPersonalArtifactUpdate)
  self:AddListenEvt(ServiceUserProxy.RecvLogin, self.CloseSelf)
end

function PersonalArtifactRefreshView:OnEnter()
  PersonalArtifactRefreshView.super.OnEnter(self)
  self:OnPersonalArtifactUpdate()
  self.advancedToggle.value = false
  if #self.equipListCells > 0 then
    self.clickButtonEnabled = true
    self:OnClickEquip(self.equipListCells[1])
    tickManager:CreateOnceDelayTick(33, function(self)
      self.attrGrid:Reposition()
    end, self, 1)
  end
end

function PersonalArtifactRefreshView:OnExit()
  tickManager:ClearTick(self)
  PersonalArtifactRefreshView.super.OnExit(self)
  TimeLimitShopProxy.Instance:viewPopUp()
end

function PersonalArtifactRefreshView:OnClickEquip(cellCtl)
  if not self.clickButtonEnabled then
    return
  end
  local id = cellCtl and cellCtl.data.id
  if self.targetItem and id == self.targetItem.id then
    return
  end
  self:SetTargetItem(cellCtl.data)
  self:UpdateEquipList()
end

function PersonalArtifactRefreshView:OnPersonalArtifactUpdate()
  self:SetTargetItem(self.targetItem)
  self:UpdateEquipList()
end

function PersonalArtifactRefreshView:SetTargetItem(itemData)
  local hasItem = itemData ~= nil
  local isSameTarget = self.targetItem ~= nil and hasItem and self.targetItem.id == itemData.id
  self.rightNoneTip:SetActive(not hasItem)
  self.attrGrid.gameObject:SetActive(hasItem)
  self.ctrlParent:SetActive(hasItem)
  self.targetItem = itemData
  local paData = itemData and itemData.personalArtifactData
  self.advancedToggle.gameObject:SetActive(paData ~= nil and not next(paData.candidateAttrs) and paData:GetAdvancedAttrCount(GameConfig.PersonalArtifact.RemouldAdvanceTenCondition) >= 1)
  self:UpdateAttriList(paData, isSameTarget)
  self:UpdateCost()
end

local addPersonalArtifact = function(datas, bagType)
  local bag = bagIns:GetBagByType(bagType)
  local bagItems, item = bag and bag:GetItems()
  if bagItems then
    for i = 1, #bagItems do
      item = bagItems[i]
      if item:IsRarePersonalArtifact() and not bagIns:CheckIsFavorite(item, bagType) then
        TableUtility.ArrayPushBack(datas, item)
      end
    end
  end
end
local equipSortFunc = function(l, r)
  if l.equiped ~= r.equiped then
    return l.equiped > r.equiped
  end
  local lRefreshed, rRefreshed = l.personalArtifactData:IsRefreshed() and 1 or 0, r.personalArtifactData:IsRefreshed() and 1 or 0
  if lRefreshed ~= rRefreshed then
    return lRefreshed > rRefreshed
  end
  local lQuality, rQuality = l.staticData.Quality, r.staticData.Quality
  if lQuality ~= rQuality then
    return lQuality > rQuality
  end
  local lSId, rSId = l.staticData.id, r.staticData.id
  if lSId ~= rSId then
    return lSId < rSId
  end
  return l.id < r.id
end

function PersonalArtifactRefreshView:UpdateEquipList()
  local datas = ReusableTable.CreateArray()
  for i = 1, #equipPackageCheck do
    addPersonalArtifact(datas, equipPackageCheck[i])
  end
  table.sort(datas, equipSortFunc)
  self.equipListCtl:ResetDatas(datas)
  self.leftNoneTip:SetActive(#datas == 0)
  ReusableTable.DestroyAndClearArray(datas)
  for _, cell in pairs(self.equipListCells) do
    cell:Set_CheckValidFunc(function()
      return true
    end)
    cell:SetChooseId(self.targetItem and self.targetItem.id or 0)
  end
end

function PersonalArtifactRefreshView:UpdateCost()
  self.costLabel.text = "0"
  self.costAddBtn:SetActive(false)
  self.HCostLabel.text = "0"
  self.HCostAddBtn:SetActive(false)
  local tItemId = self.targetItem and self.targetItem.staticData.id
  if not tItemId then
    return
  end
  local sData = Table_PersonalArtifactCompose[tItemId]
  local data, HData = sData.RefreshCost[1], sData[self:GetAdvancedToggleValue() and "RefreshCostAdvanceTen" or "RefreshCostAdvance"][1]
  self.costItemId, self.cost = data[1], data[2]
  self.HCostItemId, self.HCost = HData[1], HData[2]
  if self.costItemId then
    IconManager:SetItemIcon(Table_Item[self.costItemId].Icon, self.costItemSp)
    self.costItemSp:MakePixelPerfect()
  end
  local _, myCostCount = self:CheckCostItem()
  self.costLabel.text = string.format("%s/%s", myCostCount, self.cost)
  if self.HCostItemId then
    IconManager:SetItemIcon(Table_Item[self.HCostItemId].Icon, self.HCostItemSp)
    self.HCostItemSp:MakePixelPerfect()
  end
  local _, myHCostCount = self:CheckHCostItem()
  self.HCostLabel.text = string.format("%s/%s", myHCostCount, self.HCost)
  self:UpdateCostWidgets()
end

local tempAttrData = {isUniqueEffect = true}

function PersonalArtifactRefreshView:UpdateAttriList(paData, isSameTarget)
  local datas, isShowRefreshAnim = ReusableTable.CreateArray()
  if paData then
    local attrs, isToSave = paData.attrs, next(paData.candidateAttrs) ~= nil
    if isToSave then
      if not paData:HasBetterAttrToSave() then
        helplog("There is no better attr for this personal artifact. Cancel saving.")
        MsgManager.ShowMsgByID(43107)
        self.cancelSavingFunc()
        self:SetButtonsEnabled(false)
        self.buttonsDisabledWithoutBetterRefreshAttr = true
        self:CacheAttrs(paData, true)
        isSameTarget = false
      end
    elseif self.buttonsDisabledWithoutBetterRefreshAttr then
      self:SetButtonsEnabled(true)
      self.buttonsDisabledWithoutBetterRefreshAttr = nil
    end
    self:SetSaveMode(isToSave)
    for i = 1, #attrs do
      TableUtility.ArrayPushBack(datas, attrs[i])
    end
    if paData.percentage then
      tempAttrData.personalArtifactData = paData
      TableUtility.ArrayPushBack(datas, tempAttrData)
    end
    if isSameTarget then
      isShowRefreshAnim = not self:CheckAttrsSameFromCache(attrs) and self.nameOfLastEventButton ~= "CancelBtn"
    else
      self:CacheAttrs(paData)
    end
  else
    self:SetSaveMode(false)
    LogUtility.Warning("You're trying to refresh a personal artifact without personalArtifactData!!!")
    TableUtility.TableClear(self.cachedTargetAttrMap)
  end
  self.attrListCtl:ResetDatas(datas)
  ReusableTable.DestroyAndClearArray(datas)
  for _, cell in pairs(self.attrListCells) do
    if self.isSaveMode then
      cell:TryCompareAttributes(paData.candidateAttrs)
    elseif isShowRefreshAnim then
      self:SetButtonsEnabled(false)
      tickManager:ClearTick(self, buttonsTimeTickId)
      cell:TryShowRefreshAnim(self.cachedTargetAttrMap, function(self)
        self:CacheAttrs(self.targetItem.personalArtifactData)
        tickManager:CreateOnceDelayTick(100, function(owner)
          owner:SetButtonsEnabled(true)
        end, self, buttonsTimeTickId)
      end, self)
    end
  end
end

local costLabelColor = LuaColor.New(0.37254901960784315, 0.37254901960784315, 0.37254901960784315, 1)

function PersonalArtifactRefreshView:UpdateCostWidgets()
  local lackCost = not self:CheckCostItem()
  local lackHCost = not self:CheckHCostItem()
  self.costLabel.color = lackCost and ColorUtil.Red or costLabelColor
  self.costAddBtn:SetActive(lackCost)
  self.HCostLabel.color = lackHCost and ColorUtil.Red or costLabelColor
  self.HCostAddBtn:SetActive(lackHCost)
end

local _checkItem = function(itemId, cost)
  local myCount = bagIns:GetItemNumByStaticID(itemId, costPackageCheck)
  return myCount >= (cost or math.huge), myCount
end

function PersonalArtifactRefreshView:CheckCostItem()
  if not self.costItemId then
    LogUtility.Warning("Cannot get id of cost item while checking")
    return false
  end
  return _checkItem(self.costItemId, self.cost)
end

function PersonalArtifactRefreshView:CheckHCostItem()
  if not self.HCostItemId then
    LogUtility.Warning("Cannot get id of Hcost item while checking")
    return false
  end
  return _checkItem(self.HCostItemId, self.HCost)
end

function PersonalArtifactRefreshView:CheckRefresh(isH)
  if not self.targetItem then
    MsgManager.FloatMsg("", ZhString.PersonalArtifact_NoRefreshTargetTip)
    return false
  end
  local checkCostItemFunc = isH and self.CheckHCostItem or self.CheckCostItem
  local costItemId = isH and self.HCostItemId or self.costItemId
  if not checkCostItemFunc(self) then
    MsgManager.ShowMsgByIDTable(25418, costItemId and Table_Item[costItemId].NameZh)
    return false
  end
  return true
end

function PersonalArtifactRefreshView:CheckHasBetterAttrToSave()
  if not self.isSaveMode or not self.targetItem then
    return
  end
  local paData = self.targetItem.personalArtifactData
  if not paData then
    return
  end
  return paData:HasBetterAttrToSave()
end

function PersonalArtifactRefreshView:CheckAttrsAllMax()
  local paData = self.targetItem.personalArtifactData
  if not paData then
    return
  end
  return paData:AreAttrsAllMax()
end

function PersonalArtifactRefreshView:CheckAttrsSameFromCache(attrs)
  if type(attrs) ~= "table" or not next(attrs) then
    return false
  end
  local isSame = true
  for i = 1, #attrs do
    isSame = isSame and self.cachedTargetAttrMap[attrs[i].id] == attrs[i].value
  end
  return isSame
end

local tipOffset = {190, 0}

function PersonalArtifactRefreshView:ShowItemTip(item)
  if not item then
    TipManager.CloseTip()
    return
  end
  self.tipData.itemdata = item
  TipManager.Instance:ShowItemFloatTip(self.tipData, self.normalStick, NGUIUtil.AnchorSide.Right, tipOffset)
end

function PersonalArtifactRefreshView:SetSaveMode(isSave)
  isSave = isSave and true or false
  self.isSaveMode = isSave
  self.refreshCtrl:SetActive(not isSave)
  self.saveCtrl:SetActive(isSave)
  self.advancedCollider.enabled = not isSave
end

function PersonalArtifactRefreshView:CacheAttrs(personalArtifactData, isCandidate)
  if type(personalArtifactData) ~= "table" then
    return
  end
  TableUtility.TableClear(self.cachedTargetAttrMap)
  local attrs = isCandidate and personalArtifactData.candidateAttrs or personalArtifactData.attrs
  if not attrs then
    return
  end
  for i = 1, #attrs do
    self.cachedTargetAttrMap[attrs[i].id] = attrs[i].value
  end
end

function PersonalArtifactRefreshView:SetButtonsEnabled(enabled)
  enabled = enabled and true or false
  self.clickButtonEnabled = enabled
  self.advancedCollider.enabled = enabled
end

function PersonalArtifactRefreshView:GetAdvancedToggleValue()
  return self.advancedToggle.gameObject.activeSelf and self.advancedToggle.value
end

function PersonalArtifactRefreshView:AddCloseButtonEvent()
  self:AddButtonEvent("CloseButton", function()
    if not self.clickButtonEnabled then
      return
    end
    self:CloseSelf()
  end)
end

function PersonalArtifactRefreshView:AddButtonEvent(name, event, hideType)
  PersonalArtifactRefreshView.super.AddButtonEvent(self, name, function()
    self.nameOfLastEventButton = name
    event()
  end, hideType)
end
