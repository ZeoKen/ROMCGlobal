local enchantPackageCheck = {2, 1}
autoImport("RefineTransferAttributeCell")
autoImport("EquipNewChooseBord")
autoImport("EquipChooseBord")
autoImport("ItemNewCell")
EnchantTransferView = class("EnchantTransferView", BaseView)
EnchantTransferView.ViewType = UIViewType.NormalLayer
autoImport("EnchantCombineView")
autoImport("EnchantNewCombineView")
EnchantTransferView.BrotherView = EnchantNewCombineView
EnchantTransferView.ViewMaskAdaption = {all = 1}
EnchantTransferView.PreviewPartName = "EnchantPreview"
EnchantTransferView.PreviewPartCellName = "EnchantNewTransferAttributeCell"
EnchantTransferView.PreviewPartLocalPosY = -135
EnchantTransferView.CostItemIds = {
  GameConfig.MoneyId.Zeny,
  135
}
EnchantTransferView.EquipChooseControl = EquipChooseBord
local bg3TexName = "Equipmentopen_bg_bottom_08"
local WORKTIP_FORMAT = "[c][9a9da2]%s:%s(%s)[-][/c]"
local COMBINE_FORMAT = "%s:%s"
local _ArrayClear, _ArrayPushBack, _ArrayFindIndex = TableUtility.ArrayClear, TableUtility.ArrayPushBack, TableUtility.ArrayFindIndex
local bagIns, lotteryIns, shopIns, tickManager
local forEachRoleEquipAndBagEquipItemsByPredicate = function(func, predicate, ...)
  if not func then
    return
  end
  local equipEquips, equip = bagIns.roleEquip:GetItems() or _EmptyTable
  for i = 1, #equipEquips do
    equip = equipEquips[i]
    if not predicate or predicate(equip, ...) then
      func(equip)
    end
  end
  local bagEquips = bagIns:GetBagEquipItems()
  for i = 1, #bagEquips do
    equip = bagEquips[i]
    if not predicate or predicate(equip, ...) then
      func(equip)
    end
  end
end
local nextGenTargetInPredicate = function(equip)
  return equip:HasEnchant() and GameConfig.Lottery.TransferFilter[equip.staticData.Type] == nil
end
local lotteryHeadIdPredicate = function(id)
  local headIds = lotteryIns:GetLotteryHeadIds()
  return headIds ~= nil and 0 < _ArrayFindIndex(headIds, id)
end
local headwearTargetInPredicate = function(equip)
  return lotteryHeadIdPredicate(equip.staticData.id) and equip:HasEnchant()
end
local nextGenTargetOutPredicate = function(equip, compareTarget)
  return not equip:CanTrade() and equip.equipInfo:IsNextGen() and equip.equipInfo:CanEnchant() and EnchantTransferView.CheckIsSameType(equip, compareTarget) and equip.id ~= compareTarget.id
end
local headwearTargetOutPredicate = function(equip, compareTarget)
  return lotteryHeadIdPredicate(equip.staticData.id) and equip.equipInfo:CanEnchant() and compareTarget.staticData.Type == equip.staticData.Type and equip.id ~= compareTarget.id
end

function EnchantTransferView:Init()
  if not bagIns then
    bagIns, lotteryIns, shopIns = BagProxy.Instance, LotteryProxy.Instance, HappyShopProxy.Instance
    tickManager = TimeTickManager.Me()
  end
  self:InitData()
  self:FindObjs()
  self:InitView()
  self:AddListenEvts()
  self:AddEvts()
end

function EnchantTransferView:InitData()
  self.isCombine = self.viewdata.viewdata and self.viewdata.viewdata.isCombine
  self.isNextGen = self:GetNextGen()
  self.tipData = {}
  self.isCombine = self.viewdata.viewdata and self.viewdata.viewdata.isCombine
  self.m_helpId = 1590
end

function EnchantTransferView:FindObjs()
  self.content = self:FindGO("Content")
  self.mainBoard = self:FindGO("MainBoard", self.content)
  self.mainBoardTrans = self.mainBoard.transform
  self.closeButton = self:FindGO("CloseButton")
  self.title = self:FindComponent("Title", UILabel)
  self.transferIconTex = self:FindComponent("TransferIcon", UITexture)
  self.costSps, self.costLabels, self.costAddBtnSps = {}, {}, {}
  local go
  for i = 1, 2 do
    go = self:FindGO("CostCtrl" .. i)
    self.costSps[i] = go:GetComponent(UISprite)
    self.costLabels[i] = self:FindComponent("CostLabel", UILabel, go)
    self.costAddBtnSps[i] = self:FindComponent("AddBtn", UISprite, go)
    go:SetActive(not self.isCombine)
  end
  self.priceIndicator = self:FindGO("PriceIndicator")
  self.priceSp = self:FindComponent("PriceIcon", UISprite)
  self.priceNumLabel = self:FindComponent("PriceNum", UILabel)
  self.addItemInButton = self:FindGO("AddItemInButton")
  self.addItemOutButton = self:FindGO("AddItemOutButton")
  self.targetInGo = self:FindGO("TargetInCell")
  self.targetOutGo = self:FindGO("TargetOutCell")
  self.transferSuccessGo = self:FindGO("TransferSuccessCell")
  self.chooseContainer = self:FindGO("ChooseContainer")
  self.tipLabel = self:FindComponent("Tip", UILabel)
  self.effContainer = self:FindGO("EffectContainer")
  self.helpBtn = self:FindGO("HelpButton")
  self.bg3Tex = self:FindComponent("Bg3", UITexture)
  self.actionBtn = self:FindGO("ActionBtn")
  self.actionBtn_Collider = self.actionBtn:GetComponent(BoxCollider)
  self.actionBgSp = self.actionBtn:GetComponent(UIMultiSprite)
  self.actionLabel = self:FindComponent("ActionLabel", UILabel, self.actionBtn)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.effectContainer = self:FindGO("EffectContainer")
  self.previewPart = self:FindGO("EnchantPreview")
  self.previewTitleLabel = self:FindComponent("PreviewTitle", UILabel, self.previewPart)
  self.previewAttriTable = self:FindComponent("Table", UITable, self.previewPart)
  self.previewNoneTip = self:FindGO("EnchantNoneTip", self.previewPart)
  self.previewSV = self:FindGO("ScrollView", self.previewPart):GetComponent(UIScrollView)
  self.targetPreviewPart = self:FindGO("TargetPreview")
  self.targetPreviewTitleLabel = self:FindComponent("TargetTitle", UILabel, self.targetPreviewPart)
  self.targetPreviewAttriTable = self:FindComponent("Table", UITable, self.targetPreviewPart)
  self.targetPreviewNoneTip = self:FindGO("EnchantNoneTip", self.targetPreviewPart)
  self.targetPreviewSV = self:FindGO("ScrollView", self.targetPreviewPart):GetComponent(UIScrollView)
  self.arrow = self:FindGO("Arrow")
  self.resultSuccess = self:FindGO("Successful", self.mainBoard)
  self.resultCandidateTween = self.resultSuccess:GetComponent(TweenAlpha)
end

function EnchantTransferView:InitView()
  self:InitCostCtrl()
  self.helpBtn:SetActive(self.isNextGen)
  self.mainBoardTrans.localPosition = LuaGeometry.GetTempVector3(self.isCombine and 289 or 289)
  self.closeButton:SetActive(not self.isCombine)
  self.chooseBord = self.EquipChooseControl.new(self.chooseContainer)
  self.chooseBord:SetFilterPopData(GameConfig.EquipChooseFilter)
  self.chooseBord:Hide()
  self.transferSuccessCell = ItemNewCell.new(self.transferSuccessGo)
  self.previewAttriCtl = ListCtrl.new(self.previewAttriTable, _G[self.PreviewPartCellName], self.PreviewPartCellName)
  self.previewAttriCells = self.previewAttriCtl:GetCells()
  self.targetPreviewAttrCtl = ListCtrl.new(self.targetPreviewAttriTable, _G[self.PreviewPartCellName], self.PreviewPartCellName)
  self.targetPreviewAttrCells = self.targetPreviewAttrCtl:GetCells()
  if not self.isNextGen then
    ServiceItemProxy.Instance:CallQueryLotteryHeadItemCmd()
  end
end

function EnchantTransferView:UpdateTransferCost()
  local itemid, num = self:GetTransferCostForDisplay()
  local iconName = Table_Item[itemid] and Table_Item[itemid].Icon or ""
  IconManager:SetItemIcon(iconName, self.priceSp)
  self.priceNum = num or 0
  self:UpdatePrice()
end

function EnchantTransferView:InitCostCtrl()
  for i = 1, #self.CostItemIds do
    local staticId = self.CostItemIds[i]
    IconManager:SetItemIcon(Table_Item[staticId].Icon, self.costSps[i])
    local isMoney = staticId == GameConfig.MoneyId.Zeny or staticId == GameConfig.MoneyId.Lottery
    self.costAddBtnSps[i].alpha = isMoney and 1 or 0.5
    if isMoney then
      self:AddClickEvent(self.costAddBtnSps[i].gameObject, function()
        if staticId == GameConfig.MoneyId.Zeny then
          FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_Zeny)
        elseif staticId == GameConfig.MoneyId.Lottery then
          FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_ROB)
        end
      end)
    end
  end
  for i = #self.CostItemIds + 1, 2 do
    self.costSps[i].gameObject:SetActive(false)
  end
  self:UpdateCostCtrls()
end

function EnchantTransferView:AddListenEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddListenEvt(MyselfEvent.ZenyChange, self.OnZenyChange)
  self:AddListenEvt(ServiceEvent.ItemEnchantTransItemCmd, self.OnHeadwearTransfer)
  self:AddListenEvt(ServiceEvent.ItemEquipEnchantTransferItemCmd, self.OnNextGenTransfer)
  self:AddListenEvt(ServiceEvent.ItemQueryLotteryHeadItemCmd, self.ClickTargetInItem)
end

function EnchantTransferView:AddEvts()
  self:AddClickEvent(self.addItemInButton, function(go)
    self:ClickTargetInItem()
  end)
  self:AddClickEvent(self.addItemOutButton, function(go)
    self:ClickTargetOutItem()
  end)
  self:AddClickEvent(self.targetInGo, function(go)
    self:ClickTargetInItem()
  end)
  self:AddClickEvent(self.targetOutGo, function(go)
    self:ClickTargetOutItem()
  end)
  self:AddClickEvent(self.actionBtn, function()
    self:ClickTransfer()
  end)
  self:AddClickEvent(self.confirmBtn, function()
    self:ResetTransferSuccess()
  end)
  if self.previewBgLongPress then
    function self.previewBgLongPress.pressEvent(longPress, isPressing)
      if self.transferSuccess then
        return
      end
      if isPressing then
        self.swipeBeginPosX = LuaGameObject.GetMousePosition()
      else
        if not self.swipeBeginPosX then
          return
        end
        local endPosX = LuaGameObject.GetMousePosition()
        local delta = endPosX - self.swipeBeginPosX
        if math.abs(delta) > 5 then
          if 0 < delta then
            self:TryChangeToPrev()
          elseif delta < 0 then
            self:TryChangeToNext()
          end
        end
        self.swipeBeginPosX = nil
      end
    end
  end
  if self.previewLineSwitchIn then
    self:AddClickEvent(self.previewLineSwitchIn, function()
      self.isPreviewingTargetIn = true
      self:_UpdatePreview()
    end)
  end
  if self.previewLineSwitchOut then
    self:AddClickEvent(self.previewLineSwitchOut, function()
      self.isPreviewingTargetIn = false
      self:_UpdatePreview()
    end)
  end
end

function EnchantTransferView:OnEnter()
  EnchantTransferView.super.OnEnter(self)
  self:UpdateTransferCost()
  local npcData = self.viewdata.viewdata and self.viewdata.viewdata.npcdata
  if npcData then
    self:CameraFocusOnNpc(npcData.assetRole.completeTransform)
  else
    self:CameraRotateToMe()
  end
  self:ResetTransferSuccess()
  local curEnchantId = EnchantEquipUtil.Instance:GetCurEnchantId()
  if curEnchantId then
    local item = bagIns:GetItemByGuid(curEnchantId, enchantPackageCheck)
    if item and nextGenTargetInPredicate(item) then
      self.isChoosingTargetIn = true
      self:OnChooseItem(item)
      return
    end
  end
  self:ClickTargetInItem()
end

function EnchantTransferView:OnExit()
  self:CameraReset()
  tickManager:ClearTick(self)
  EnchantTransferView.super.OnExit(self)
end

function EnchantTransferView:OnChooseItem(data)
  if self.isChoosingTargetIn then
    self.targetInData = data
    local curEnchantItemId = data and data.id or nil
    EnchantEquipUtil.Instance:SetCurrentEnchantId(curEnchantItemId)
    self:UpdateCellData(self.targetInGo, data)
    self.targetOutData = nil
  else
    self.targetOutData = data
    self:UpdateCellData(self.targetOutGo, data)
    self:sendNotification(ItemEvent.EquipChooseSuccess, data)
  end
  self.chooseBord:Hide()
  self:UpdateMainBoard()
  self:UpdatePreview()
  self.isChoosingTargetIn = nil
  if not self.isChoosingTargetIn and not self.targetOutData then
    self:ClickTargetOutItem()
  end
end

function EnchantTransferView:OnItemUpdate()
  self:UpdateCostCtrls()
  if self.transferSuccess then
    tickManager:CreateOnceDelayTick(33, function(self)
      self:SuccessUpdate()
    end, self)
  else
    self:UpdateMainBoard()
  end
end

function EnchantTransferView:SuccessUpdate()
  self.transferSuccessCell:SetData(self.transferSuccessCell.data)
end

function EnchantTransferView:OnZenyChange()
  self:UpdateCostCtrls()
end

function EnchantTransferView:OnHeadwearTransfer(note)
  if note.body.success then
    self:SetTransferSuccess()
  end
end

function EnchantTransferView:OnNextGenTransfer(note)
  if note.body.success then
    self:SetTransferSuccess()
  end
end

function EnchantTransferView:SetTransferSuccess()
  xdlog("转移结束")
  tickManager:ClearTick(self, 999)
  tickManager:CreateOnceDelayTick(2500, function(self)
    self.clickDisabled = nil
  end, self, 999)
  self.priceIndicator:SetActive(false)
  self.chooseSymbol:SetActive(false)
  self.actionBtn:SetActive(false)
  self.confirmBtn:SetActive(true)
  if self.previewLineBg then
    self.previewLineBg:SetActive(false)
  end
  if self.previewLineIndicator then
    self.previewLineIndicator.gameObject:SetActive(false)
  end
  self.transferSuccess = true
  self:UpdatePreview()
  self:UpdatePreviewResult()
  self:ResetPreviewName()
end

function EnchantTransferView:ResetTransferSuccess()
  self.transferSuccess = nil
  self.transferSuccessGo:SetActive(false)
  self.targetInData = nil
  self.targetOutData = nil
  self.chooseSymbol:SetActive(true)
  self.chooseSymbol.transform.position = self.addItemInButton.transform.position
  self.confirmBtn:SetActive(false)
  if self.previewLineBg then
    self.previewLineBg:SetActive(true)
  end
  if self.previewLineIndicator then
    self.previewLineIndicator.gameObject:SetActive(true)
  end
  self.clickDisabled = nil
  self.chooseBord:SetChoose()
  self:ClickTargetInItem()
  self:sendNotification(ItemEvent.EquipChooseSuccess)
end

function EnchantTransferView:DoTransfer()
  self:PlayUIEffect(EffectMap.UI.EnchantTransfer2, self.targetPreviewPart, true)
  if self.resultSuccess then
    tickManager:ClearTick(self, 2)
    self.resultSuccess:SetActive(true)
    self.resultCandidateTween:ResetToBeginning()
    self.resultCandidateTween:PlayForward()
    tickManager:CreateOnceDelayTick(2000, function(self)
      self.resultCandidateTween:PlayReverse()
    end, self, 2)
  end
  if self.isNextGen then
    return self:_NextGenTransfer()
  else
    return self:_HeadwearTransfer()
  end
end

function EnchantTransferView:_NextGenTransfer()
  ServiceItemProxy.Instance:CallEquipEnchantTransferItemCmd(self.targetInData.id, self.targetOutData.id)
end

function EnchantTransferView:_HeadwearTransfer()
  local action = function()
    ServiceItemProxy.Instance:CallEnchantTransItemCmd(self.targetInData.id, self.targetOutData.id)
  end
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(291)
  if not dont then
    MsgManager.DontAgainConfirmMsgByID(291, action)
  else
    action()
  end
end

function EnchantTransferView:UpdateMainBoard()
  local hasInData, hasOutData = self.targetInData ~= nil, self.targetOutData ~= nil
  self.addItemInButton:SetActive(not hasInData)
  self.addItemOutButton:SetActive(not hasOutData)
  self.targetInGo:SetActive(hasInData)
  self.targetOutGo:SetActive(hasOutData)
  self.tipLabel.gameObject:SetActive(not hasInData or not hasOutData)
  self.tipLabel.text = hasInData and self:GetTargetOutTipText() or self:GetTargetInTipText()
  self.previewNoneTip:SetActive(not hasInData)
  self.targetPreviewNoneTip:SetActive(not hasInData)
  if not hasInData then
    self.previewAttriCtl:RemoveAll()
  end
  if not hasOutData then
    self.targetPreviewAttrCtl:RemoveAll()
  end
  self.targetPreviewNoneTip:SetActive(not hasOutData)
  self.arrow:SetActive(hasInData and hasOutData)
  self.priceIndicator:SetActive(hasInData and hasOutData)
  self:SetActionBtnActive(self.targetInData and self.targetOutData and self:CheckCost())
  self.actionBtn:SetActive(hasInData and hasOutData)
end

function EnchantTransferView:UpdatePrice()
  if self:CheckCost() then
    self.priceNumLabel.text = self.priceNum
  else
    self.priceNumLabel.text = string.format("[c][fb725f]%s[-][/c]", self.priceNum)
  end
end

function EnchantTransferView:UpdateCostCtrls()
  for i = 1, #self.CostItemIds do
    self.costLabels[i].text = StringUtil.NumThousandFormat(shopIns:GetItemNum(self.CostItemIds[i])) or 0
  end
end

function EnchantTransferView:UpdateCellData(parent, data)
  local itemSp = self:FindComponent("ItemSprite", UISprite, parent)
  local succ = IconManager:SetItemIcon(data.staticData.Icon, itemSp)
  if not succ then
    IconManager:SetItemIcon("item_45001", itemSp)
  end
  itemSp:MakePixelPerfect()
  local scale = 1
  itemSp.transform.localScale = LuaGeometry.GetTempVector3(scale, scale, scale)
  local attrLabel, attr = self:FindComponent("AttrLabel", UILabel, parent), self:GetTargetAttrText(data)
  attrLabel.gameObject:SetActive(not StringUtil.IsEmpty(attr))
  attrLabel.text = attr
end

function EnchantTransferView:UpdateFakePreviewTitle()
  self.previewTitleLabel.text = self.targetOutData.staticData.NameZh
end

function EnchantTransferView:ResetPreviewName()
  self.previewTitleLabel.text = ZhString.EnchantTransferView_TargetInName
  self.targetPreviewTitleLabel.text = ZhString.EnchantTransferView_TargetOutName
end

function EnchantTransferView:GetTargetAttrText(data)
  return ""
end

function EnchantTransferView:SetTransferIcon(isActive)
  if self.transferIconTexName then
    PictureManager.Instance:UnLoadUI(self.transferIconTexName, self.transferIconTex)
  end
  self.transferIconTexName = "Equipmentopen_icon_transfer"
  if isActive then
    self.transferIconTexName = self.transferIconTexName .. "_activate"
  end
  PictureManager.Instance:SetUI(self.transferIconTexName, self.transferIconTex)
end

function EnchantTransferView:GetAttrPreviewData(name, value, isPercent)
  local t = ReusableTable.CreateTable()
  t.name = name
  t.value = value and string.format(isPercent and "+%s%%" or "+%s", value)
  return t
end

function EnchantTransferView:UpdatePreview()
  self.isPreviewingTargetIn = true
  self:_UpdatePreview()
end

function EnchantTransferView:_UpdatePreview()
  self.previewTitleLabel.text = self.targetInData and self.targetInData:GetName() or ZhString.EnchantTransferView_TargetInName
  local clickTarget = self.isPreviewingTargetIn and self.addItemInButton or self.addItemOutButton
  self.chooseSymbol.transform.position = clickTarget.transform.position
  self.chooseSymbol:SetActive(not self.targetInData or not self.targetOutData)
  local datas = ReusableTable.CreateArray()
  local previewingData = self.targetInData and bagIns:GetItemByGuid(self.targetInData.id)
  local enchantInfo = previewingData and previewingData.enchantInfo
  local attri = enchantInfo and enchantInfo:GetEnchantAttrs()
  if attri and 0 < #attri then
    for i = 1, #attri do
      _ArrayPushBack(datas, self:GetAttrPreviewData(attri[i].name, attri[i].value, attri[i].propVO and attri[i].propVO.isPercent))
    end
    local combineEffects, combineEffect, buffData = enchantInfo:GetCombineEffects()
    for i = 1, #combineEffects do
      combineEffect = combineEffects[i]
      buffData = combineEffect and combineEffect.buffData
      if buffData then
        _ArrayPushBack(datas, self:GetAttrPreviewData(combineEffect.isWork and string.format(COMBINE_FORMAT, buffData.BuffName, ItemUtil.GetBuffDesc(buffData.BuffDesc, enchantInfo.quench)) or string.format(WORKTIP_FORMAT, buffData.BuffName, ItemUtil.GetBuffDesc(buffData.BuffDesc, enchantInfo.quench), combineEffect.WorkTip)))
      end
    end
  end
  self.previewNoneTip:SetActive(#datas == 0)
  self.previewAttriCtl:ResetDatas(datas)
  self.previewSV:ResetPosition()
  TableUtility.ArrayClear(datas)
  self.targetPreviewTitleLabel.text = self.targetOutData and self.targetOutData:GetName() or ZhString.EnchantTransferView_TargetOutName
  previewingData = self.targetOutData and bagIns:GetItemByGuid(self.targetOutData.id)
  enchantInfo = previewingData and previewingData.enchantInfo
  attri = enchantInfo and enchantInfo:GetEnchantAttrs()
  if attri and 0 < #attri then
    for i = 1, #attri do
      _ArrayPushBack(datas, self:GetAttrPreviewData(attri[i].name, attri[i].value, attri[i].propVO and attri[i].propVO.isPercent))
    end
    local combineEffects, combineEffect, buffData = enchantInfo:GetCombineEffects()
    for i = 1, #combineEffects do
      combineEffect = combineEffects[i]
      buffData = combineEffect and combineEffect.buffData
      if buffData then
        _ArrayPushBack(datas, self:GetAttrPreviewData(combineEffect.isWork and string.format(COMBINE_FORMAT, buffData.BuffName, ItemUtil.GetBuffDesc(buffData.BuffDesc, enchantInfo.quench)) or string.format(WORKTIP_FORMAT, buffData.BuffName, ItemUtil.GetBuffDesc(buffData.BuffDesc, enchantInfo.quench), combineEffect.WorkTip)))
      end
    end
  end
  self.targetPreviewNoneTip:SetActive(#datas == 0)
  self.targetPreviewAttrCtl:ResetDatas(datas)
  self.targetPreviewSV:ResetPosition()
  for _, t in pairs(datas) do
    ReusableTable.DestroyAndClearTable(t)
  end
  ReusableTable.DestroyAndClearArray(datas)
end

function EnchantTransferView:UpdatePreviewResult()
  local tempData = {}
  local cells = self.previewAttriCtl:GetCells()
  for i = 1, #cells do
    _ArrayPushBack(tempData, cells[i].data)
  end
  self.targetPreviewAttrCtl:ResetDatas(tempData)
  self.targetPreviewSV:ResetPosition()
  self.targetPreviewNoneTip:SetActive(false)
  self.previewNoneTip:SetActive(true)
  self.previewAttriCtl:RemoveAll()
  self.previewSV:ResetPosition()
end

function EnchantTransferView:TryChangeToPrev()
  if self.isPreviewingTargetIn then
    return
  end
  self:ChangePreview()
end

function EnchantTransferView:TryChangeToNext()
  if not self.isPreviewingTargetIn then
    return
  end
  self:ChangePreview()
end

function EnchantTransferView:ChangePreview()
  self.isPreviewingTargetIn = not self.isPreviewingTargetIn
  self:_UpdatePreview()
end

function EnchantTransferView:GetTargetInPredicate()
  return self.isNextGen and nextGenTargetInPredicate or headwearTargetInPredicate
end

function EnchantTransferView:GetEnchantInChooseDatas()
  self.enchantInDatas = self.enchantInDatas or {}
  _ArrayClear(self.enchantInDatas)
  forEachRoleEquipAndBagEquipItemsByPredicate(function(equip)
    _ArrayPushBack(self.enchantInDatas, equip)
  end, self:GetTargetInPredicate())
  return self.enchantInDatas
end

function EnchantTransferView:ClickTargetInItem()
  if self.clickDisabled then
    return
  end
  self.targetInData = nil
  self:UpdateMainBoard()
  self.chooseBord:SetChoose()
  self:ShowChooseBord(self:GetEnchantInChooseDatas(), true)
  self.chooseSymbol:SetActive(true)
  self.chooseSymbol.transform.position = self.addItemInButton.transform.position
  self:ResetPreviewName()
end

function EnchantTransferView:GetTargetOutPredicate()
  return self.isNextGen and nextGenTargetOutPredicate or headwearTargetOutPredicate
end

function EnchantTransferView:GetEnchantOutChooseDatas()
  self.enchantOutDatas = self.enchantOutDatas or {}
  _ArrayClear(self.enchantOutDatas)
  forEachRoleEquipAndBagEquipItemsByPredicate(function(equip)
    _ArrayPushBack(self.enchantOutDatas, equip)
  end, self:GetTargetOutPredicate(), self.targetInData)
  return self.enchantOutDatas
end

function EnchantTransferView:ClickTargetOutItem()
  if self.clickDisabled then
    return
  end
  self.targetOutData = nil
  self.chooseBord:SetChoose()
  self:UpdateMainBoard()
  if not self.targetInData then
    return
  end
  self:ShowChooseBord(self:GetEnchantOutChooseDatas(), false)
  self.chooseSymbol:SetActive(true)
  self.chooseSymbol.transform.position = self.addItemOutButton.transform.position
  self.targetPreviewTitleLabel.text = ZhString.EnchantTransferView_TargetOutName
  self:sendNotification(ItemEvent.EquipChooseSuccess)
end

function EnchantTransferView:ShowChooseBord(data, isTargetIn)
  if not data then
    return
  end
  self.isChoosingTargetIn = isTargetIn
  self.chooseBord:ResetDatas(data, true)
  self.chooseBord:Show(nil, self.OnChooseItem, self)
  local targetData = isTargetIn and self.targetInData or self.targetOutData
  if targetData then
    self.chooseBord:SetChoose(targetData)
  end
end

function EnchantTransferView:ClickTransfer()
  if not self.targetInData then
    return
  end
  if not self.targetOutData then
    return
  end
  if self.clickDisabled then
    return
  end
  if not self:CheckCost() then
    local itemId = self:GetTransferCostForDisplay()
    MsgManager.ShowMsgByIDTable(25418, Table_Item[itemId].NameZh)
    return
  end
  self:TryPlayEffectThenCall(self.DoTransfer)
end

function EnchantTransferView:TryPlayEffectThenCall(func)
  self.clickDisabled = true
  self:SetActionBtnActive(false)
  self:PlayUIEffect(EffectMap.UI.RefineTransfer, self.effectContainer, true)
  self:PlayUISound(AudioMap.UI.EnchantTransferSuc)
  tickManager:CreateOnceDelayTick(800, func, self)
end

function EnchantTransferView:SetActionBtnActive(isActive)
  self.actionBtnActive = isActive and true or false
  self.actionBtn_Collider.enabled = self.actionBtnActive
  self:UpdateActionBtnActive()
end

local inactiveLabelColor, activeLabelEffectColor, inactiveLabelEffectColor = LuaColor.New(0.9372549019607843, 0.9372549019607843, 0.9372549019607843), LuaColor.New(0.6862745098039216, 0.3764705882352941, 0.10588235294117647), LuaColor.New(0.5019607843137255, 0.5019607843137255, 0.5019607843137255)

function EnchantTransferView:UpdateActionBtnActive()
  local isActive = self.actionBtnActive
  self.actionBgSp.CurrentState = isActive and 1 or 0
  self.actionLabel.color = isActive and ColorUtil.NGUIWhite or inactiveLabelColor
  self.actionLabel.effectColor = isActive and activeLabelEffectColor or inactiveLabelEffectColor
  self:UpdatePrice()
end

function EnchantTransferView:GetNextGen()
  return self.viewdata.viewdata and self.viewdata.viewdata.isnew or false
end

function EnchantTransferView:GetTransferCost()
  return self.isNextGen and GameConfig.Equip.EnchantTransferItemCost or GameConfig.Lottery.TransferCost
end

function EnchantTransferView:GetTransferCostForDisplay()
  local cfg = self:GetTransferCost()
  if cfg.itemid then
    return cfg.itemid, cfg.num
  elseif type(cfg[1]) == "table" then
    return cfg[1][1], cfg[1][2]
  end
end

function EnchantTransferView:GetTargetInTipText()
  return ZhString.EnchantTransferView_ChooseTargetInFirst
end

function EnchantTransferView:GetTargetOutTipText()
  return ZhString.EnchantTransferView_ChooseTargetOutFirst
end

local _checkCost = function(itemid, num)
  return num <= shopIns:GetItemNum(itemid)
end

function EnchantTransferView:CheckCost()
  local cfg = self:GetTransferCost()
  if cfg.itemid then
    return _checkCost(cfg.itemid, cfg.num)
  elseif type(cfg[1]) == "table" then
    local enough, pair = true
    for i = 1, #cfg do
      pair = cfg[i]
      enough = enough and _checkCost(pair[1], pair[2])
      if not enough then
        break
      end
    end
    return enough
  end
end

local getTransferType = function(equip)
  local cfg = GameConfig.Equip.EquipTransferType
  if not equip or not cfg then
    return
  end
  return cfg[equip.staticData.Type]
end

function EnchantTransferView.CheckIsSameType(equip1, equip2)
  local t1, t2 = getTransferType(equip1), getTransferType(equip2)
  return t1 ~= nil and t1 == t2
end
