autoImport("EquipChooseBord")
autoImport("ItemNewCell")
autoImport("EnchantNewAttrCell")
autoImport("EnchantNewCell")
autoImport("MaterialItemNewCell")
EnchantThirdAttrResetView = class("EnchantThirdAttrResetView", BaseView)
EnchantThirdAttrResetView.ViewType = UIViewType.NormalLayer
autoImport("EnchantCombineView")
autoImport("EnchantNewCombineView")
EnchantThirdAttrResetView.BrotherView = EnchantNewCombineView
EnchantThirdAttrResetView.ViewMaskAdaption = {all = 1}
EnchantThirdAttrResetView.EquipChooseControl = EquipChooseBord
local arrayClear, arrayPushBack = TableUtility.ArrayClear, TableUtility.ArrayPushBack
local bagIns, lotteryIns, shopIns, tickManager, pictureMgr
local destroyAndClearTable = ReusableTable.DestroyAndClearTable
local createTable = ReusableTable.CreateTable
local enchantPackageCheck = {
  2,
  20,
  1
}
local bg3TexName = "Equipmentopen_bg_bottom_16"
local enchantNewCell_PrefabPath = "cell/EnchantCell"
local enchantMatPackageCheck = GameConfig.PackageMaterialCheck.enchant
local fixedCostTipOffset = {-210, 180}
local inactiveLabelColor = LuaColor.New(0.9372549019607843, 0.9372549019607843, 0.9372549019607843)
local inactiveLabelEffectColor = LuaColor.New(0.5019607843137255, 0.5019607843137255, 0.5019607843137255)
local activeLabelEffectColor = LuaColor.New(0.6862745098039216, 0.3764705882352941, 0.10588235294117647)
local againActiveLabelEffectColor = LuaColor.New(0.6862745098039216, 0.3764705882352941, 0.10588235294117647)
local actionBtnLabs
local seniorEnchantType = EnchantType.Senior
local getCellData = function(index, isReusable)
  local cellData = isReusable and createTable() or {}
  cellData.index = index
  return cellData
end
local optionalBtnIntervalTime = 1
local resetClickTime

function EnchantThirdAttrResetView:Init()
  self:InitData()
  self:FindObjs()
  self:InitView()
  self:AddListenEvts()
  self:AddEvts()
end

function EnchantThirdAttrResetView:InitData()
  actionBtnLabs = {
    ZhString.EnchantThirdAttrReset_ActionBtnDesc,
    ZhString.EnchantThirdAttrReset_ActionBtnAgainDesc
  }
  bagIns, lotteryIns, shopIns, pictureMgr = BagProxy.Instance, LotteryProxy.Instance, HappyShopProxy.Instance, PictureManager.Instance
  tickManager = TimeTickManager.Me()
  self.tipData = {}
  self.isCombine = self.viewdata.viewdata and self.viewdata.viewdata.isCombine
end

function EnchantThirdAttrResetView:FindObjs()
  self.mainBoard = self:FindGO("MainBoard")
  self.mainBoardTrans = self.mainBoard.transform
  self.closeButton = self:FindGO("CloseButton")
  self.title = self:FindComponent("Title", UILabel, self.mainBoard)
  self.title.text = ZhString.EnchantThirdAttrReset_Title
  self.actionBgSp = self:FindComponent("ActionBtn", UIMultiSprite, self.mainBoard)
  self.actionLabel = self:FindComponent("ActionLabel", UILabel, self.actionBgSp.gameObject)
  self.actionLabel.text = actionBtnLabs[1]
  self.emptyTip = self:FindComponent("EmptyTip", UILabel, self.mainBoard)
  self.emptyTip.text = ZhString.EnchantThirdAttrReset_EmptyTip
  local choosePanel = self:FindGO("ChoosePanel")
  self.chooseContainer = self:FindGO("ChooseContainer", choosePanel)
  self.targetCellObj = self:FindGO("TargetCell", self.mainBoard)
  self.bg3Tex = self:FindComponent("Bg3", UITexture, self.targetCellObj)
  self.targetCellAddIcon = self:FindGO("TargetCellAddIcon", self.targetCellObj)
  self.targetCellContent = self:FindGO("TargetCellContent", self.targetCellObj)
  self.targetIcon = self:FindComponent("Icon", UISprite, self.targetCellContent)
  self.removeTargetObj = self:FindGO("DeleteIcon", self.targetCellContent)
  self.actionBoard = self:FindGO("ActionBoard", self.mainBoard)
  self.targetName = self:FindComponent("ItemName", UILabel, self.actionBoard)
  self.enchantNoneTip = self:FindComponent("EnchantNoneTip", UILabel, self.actionBoard)
  self.enchantNoneTip.text = ZhString.EnchantAttrUp_EnchantNoneTip
  self.enchantCellParent = self:FindGO("EnchantCellParent", self.actionBoard)
  self.fixedCostGrid = self:FindComponent("FixedCostGrid", UIGrid, self.actionBoard)
  self.tenPullsTog = self:FindComponent("TenPullsTog", UIToggle, self.mainBoard)
  self.tenPullsTog.value = false
  self.enchantResult = self:FindGO("EnchantResult", choosePanel)
  local enchantResultTitle = self:FindComponent("Title", UILabel, self.enchantResult)
  enchantResultTitle.text = ZhString.EnchantThirdAttrReset_ResultTitle
  self:Hide(self.enchantResult)
  self.enchantResetResultGrid = self:FindComponent("ResultGrid", UIGrid, self.enchantResult)
  self.saveBtn = self:FindGO("SaveBtn", self.enchantResult)
  self.quitBtn = self:FindGO("QuitBtn", self.enchantResult)
  self.effContainer = self:FindGO("EffectContainer")
  self:PlayUIEffect(EffectMap.UI.EquipEnchant_Bg, self:FindGO("TargetCell"), nil, function(obj, args, assetEffect)
    local effect = assetEffect
    local ps = effect.effectObj:GetComponentsInChildren(ParticleSystem, true)
    for i = 1, #ps do
      ps[i].gameObject:SetActive(false)
      ps[i].gameObject:SetActive(true)
    end
  end)
end

function EnchantThirdAttrResetView:checkChooseBoardValid(itemdata)
  return itemdata:CheckThirdAttrResetValid()
end

function EnchantThirdAttrResetView:GetChooseBordDataFunc()
  self.chooseBoardData = self.chooseBoardData or {}
  arrayClear(self.chooseBoardData)
  local items, equipInfo
  for i = 1, #enchantPackageCheck do
    items = bagIns.bagMap[enchantPackageCheck[i]]:GetItems()
    if items then
      for j = 1, #items do
        equipInfo = items[j] and items[j].equipInfo
        if equipInfo and equipInfo:CanEnchant() then
          arrayPushBack(self.chooseBoardData, items[j])
        end
      end
    end
  end
  table.sort(self.chooseBoardData, function(l, r)
    local lValid = l:CheckThirdAttrResetValid() and 1 or 0
    local rValid = r:CheckThirdAttrResetValid() and 1 or 0
    if lValid == rValid then
      if l.bagtype == r.bagtype then
        return l.staticData.id > r.staticData.id
      else
        return l.bagtype > r.bagtype
      end
    else
      return lValid > rValid
    end
  end)
  return self.chooseBoardData
end

function EnchantThirdAttrResetView:InitView()
  self.mainBoardTrans.localPosition = LuaGeometry.GetTempVector3(self.isCombine and 289 or 289)
  self.closeButton:SetActive(not self.isCombine)
  self.targetChooseBord = self.EquipChooseControl.new(self.chooseContainer, function()
    return self:GetChooseBordDataFunc()
  end)
  self.targetChooseBord:SetFilterPopData(GameConfig.EquipChooseFilter)
  self.targetChooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.OnClickChooseBordCell, self)
  self.targetChooseBord.needSetCheckValidFuncOnShow = true
  self.targetChooseBord:Show(true, nil, nil, self.checkChooseBoardValid, self, ZhString.EnchantThirdAttrReset_InValid)
  self.enchantInfoBord = EnchantInfoBord.new(self.chooseContainer)
  self.enchantInfoBord:Hide()
  self.enchantScrollView = self:FindGO("EnchantCellScrollView"):GetComponent(UIScrollView)
  self.enchantCell = EnchantNewCell.new(self:LoadPreferb(enchantNewCell_PrefabPath, self.enchantScrollView.gameObject))
  self.enchantCell:UpdateThirdAttrBg(true)
  self.enchantCell:HideBG()
  self.fixedCostCtl = ListCtrl.new(self.fixedCostGrid, MaterialItemCell, "MaterialItemCell")
  self.fixedCostCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickFixedCostItemTip, self)
  self.tipData = {
    itemdata = nil,
    funcConfig = _EmptyTable,
    ignoreBounds = {
      self.fixedCostGrid.gameObject
    }
  }
  self.fixedCostItemDatas = {}
  self.enchantResetResultCtl = ListCtrl.new(self.enchantResetResultGrid, EnchantNewAttrCell, "EnchantNewAttrCell")
  self.enchantResetResultCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickResetResult, self)
end

function EnchantThirdAttrResetView:OnClickResetResult(cell)
  local index = cell.refreshIndex
  self.chooseResetResultIndex = cell.refreshIndex
  self:UpdateEnchantAttrRefreshIndex()
end

function EnchantThirdAttrResetView:UpdateEnchantAttrRefreshIndex()
  local cells = self.enchantResetResultCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChooseId(self.chooseResetResultIndex)
  end
end

function EnchantThirdAttrResetView:OnClickFixedCostItemTip(cell)
  local data = cell.data
  if not BagItemCell.CheckData(data) then
    return
  end
  self.tipData.itemdata = data
  EnchantThirdAttrResetView.super.ShowItemTip(self, self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, fixedCostTipOffset)
end

function EnchantThirdAttrResetView:OnClickChooseBordCell(data)
  self:SetTargetCell(data)
end

function EnchantThirdAttrResetView:SetTargetCell(data)
  if not BagItemCell.CheckData(data) and data.staticData ~= nil then
    data = nil
  end
  local curEnchantItemId = data and data.id or nil
  EnchantEquipUtil.Instance:SetCurrentEnchantId(curEnchantItemId)
  self.targetData = data
  self.targetName.text = data:GetName()
  self:UpdateViewByTargetCell()
  if data then
    self:sendNotification(ItemEvent.EquipChooseSuccess, data)
  end
end

function EnchantThirdAttrResetView:HasTarget()
  return nil ~= self.targetData and nil ~= self.targetData.staticData
end

function EnchantThirdAttrResetView:OnRemoveTarget()
  self.targetData = nil
  self:UpdateViewByTargetCell()
  self.targetChooseBord:Show(true, nil, nil, self.checkChooseBoardValid, self, ZhString.EnchantThirdAttrReset_InValid)
  self.targetChooseBord:SetChoose(nil)
  self:Hide(self.enchantResult)
  self.enchantInfoBord:Hide()
end

local iconScale = 1

function EnchantThirdAttrResetView:UpdateViewByTargetCell()
  if not self:HasTarget() then
    self:Hide(self.actionBoard)
    self:Hide(self.targetCellContent)
    self:Show(self.emptyTip)
    self:Show(self.targetCellAddIcon)
    self:SetActionBtnActive(false)
    return
  end
  self:Hide(self.emptyTip)
  self:Hide(self.targetCellAddIcon)
  self:Show(self.actionBoard)
  self:Show(self.targetCellContent)
  IconManager:SetItemIcon(self.targetData.staticData.Icon, self.targetIcon)
  self.targetIcon:MakePixelPerfect()
  self.targetIcon.transform.localScale = LuaGeometry.GetTempVector3(iconScale, iconScale, iconScale)
  self:updateTargetEnchantInfo()
  self:updateFixedCostItems()
  self:SetActionBtnActive()
  self:_UpdateEnchantResult()
  self.targetChooseBord:Hide()
  self.enchantInfoBord:Hide()
end

function EnchantThirdAttrResetView:HasRefreshAttr()
  if not self:HasTarget() then
    return
  end
  if self.targetData:HasCacheEnchantRefreshAttr() then
    return true
  end
  return false
end

function EnchantThirdAttrResetView:SetActionBtnActive(active)
  if active == false then
    self.actionBgSp.gameObject:SetActive(active)
    self.tenPullsTog.gameObject:SetActive(false)
    return
  else
    self.actionBgSp.gameObject:SetActive(true)
    self.tenPullsTog.gameObject:SetActive(true)
  end
  local hasRefreshAttr = self:HasRefreshAttr()
  if active == nil then
    local costEnough = self.resetCostEnough
    if costEnough and not hasRefreshAttr then
      self.actionBgSp.CurrentState = hasRefreshAttr and 2 or 1
      self.actionLabel.color = ColorUtil.NGUIWhite
      self.actionLabel.effectColor = hasRefreshAttr and againActiveLabelEffectColor or activeLabelEffectColor
    else
      self.actionBgSp.CurrentState = 0
      self.actionLabel.color = inactiveLabelColor
      self.actionLabel.effectColor = inactiveLabelEffectColor
    end
    self.actionLabel.text = hasRefreshAttr and actionBtnLabs[2] or actionBtnLabs[1]
  end
end

function EnchantThirdAttrResetView:getEnchantCellDataFromEnchantInfo(enchantInfo, index, isReusable)
  if enchantInfo and self:HasTarget() then
    local attrs = enchantInfo.enchantAttrs
    if attrs and 0 < #attrs then
      local cellData = getCellData(index, isReusable)
      cellData.enchantAttrList = attrs
      cellData.combineEffectList = enchantInfo.combineEffectlist
      cellData.thirdAttrType = enchantInfo:GetThirdAttrType()
      return cellData
    end
  end
end

function EnchantThirdAttrResetView:updateTargetEnchantInfo()
  local hasEnchant = self.targetData:HasEnchant()
  self.enchantNoneTip.gameObject:SetActive(not hasEnchant)
  if hasEnchant then
    local data = self:getEnchantCellDataFromEnchantInfo(self.targetData.enchantInfo, nil, true)
    self.enchantCell:SetData(data)
    destroyAndClearTable(data)
  else
    self.enchantCell:SetData(nil)
  end
  self.enchantScrollView:ResetPosition()
end

function EnchantThirdAttrResetView:updateFixedCostItems()
  if not self:HasTarget() then
    return
  end
  arrayClear(self.fixedCostItemDatas)
  local type = self.targetData.staticData.Type
  local cost_config = ItemUtil.GetEnchantResetCost(type)
  if not cost_config then
    return
  end
  self.resetCostEnough = true
  for i = 1, #cost_config do
    local itemCostData = ItemData.new(MaterialItemCell.MaterialType.Material, cost_config[i][1])
    if cost_config[i][1] == GameConfig.MoneyId.Zeny then
      itemCostData.num = MyselfProxy.Instance:GetROB()
    elseif cost_config[i][1] == GameConfig.MoneyId.Lottery then
      itemCostData.num = MyselfProxy.Instance:GetLottery()
    else
      itemCostData.num = bagIns:GetItemNumByStaticID(cost_config[i][1], enchantMatPackageCheck)
    end
    itemCostData.discount = 100
    local times = self.tenPullsTog.value and 10 or 1
    itemCostData.neednum = cost_config[i][2] * times
    arrayPushBack(self.fixedCostItemDatas, itemCostData)
    if itemCostData.num < itemCostData.neednum then
      self.resetCostEnough = false
    end
  end
  self.fixedCostCtl:ResetDatas(self.fixedCostItemDatas)
end

function EnchantThirdAttrResetView:AddListenEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.OnItemUpdate)
end

function EnchantThirdAttrResetView:OnItemUpdate()
  self:UpdateViewByTargetCell()
  if self.manualOption and self.enchantResult.activeSelf then
    self:Hide(self.enchantResult)
    self.manualOption = nil
    self:SetActionBtnActive()
  end
end

function EnchantThirdAttrResetView:_UpdateEnchantResult()
  local hasCacheEnchantRefreshAttr = self.targetData:HasCacheEnchantRefreshAttr()
  if not hasCacheEnchantRefreshAttr then
    return
  end
  self.targetChooseBord:Hide()
  self.enchantInfoBord:Hide()
  self:Show(self.enchantResult)
  local cache_refresh_attr = self.targetData:GetCacheEnchantRefreshAttr()
  self.enchantResetResultCtl:ResetDatas(cache_refresh_attr)
  self.enchantResetResultCtl:ResetPosition()
  self.chooseResetResultIndex = cache_refresh_attr[1].refreshIndex
  self:UpdateEnchantAttrRefreshIndex()
  self:SetActionBtnActive()
end

function EnchantThirdAttrResetView:AddEvts()
  self:AddClickEvent(self.targetCellObj, function()
    if self:HasTarget() then
      return
    end
    if self.targetChooseBord:ActiveSelf() then
      return
    end
    self.enchantInfoBord:Hide()
    self.targetChooseBord:Show(true, nil, nil, self.checkChooseBoardValid, self, ZhString.EnchantThirdAttrReset_InValid)
  end)
  self:AddClickEvent(self.removeTargetObj, function()
    self:OnRemoveTarget()
  end)
  self:AddClickEvent(self.actionBgSp.gameObject, function()
    self:OnClickActionBtn()
  end)
  self:AddClickEvent(self.saveBtn, function()
    self:_OptionAttrResult(true)
  end)
  self:AddClickEvent(self.quitBtn, function()
    self:_OptionAttrResult(false)
  end)
  self:AddClickEvent(self.tenPullsTog.gameObject, function()
    self:updateFixedCostItems()
    self:SetActionBtnActive()
  end)
  self:AddButtonEvent("EnchantInfoBtn", function()
    local curType = self.targetData and self.targetData.staticData.Type or nil
    local _data = {equipType = curType}
    self.enchantInfoBord:Show()
    self.enchantInfoBord:UpdateView(_data)
  end)
  TipsView.Me():TryShowGeneralHelpByHelpId(33, self:FindGO("HelpButton"))
end

function EnchantThirdAttrResetView:_OptionAttrResult(save)
  if resetClickTime and UnityUnscaledTime - resetClickTime < optionalBtnIntervalTime then
    MsgManager.ShowMsgByID(49)
    return
  end
  if not self.chooseResetResultIndex then
    return
  end
  if not self:HasTarget() then
    return
  end
  local itemid = self.targetData.id
  helplog("[附魔Debug] CallProcessEnchantRefreshAttr save|itemid|index ", save, itemid, self.chooseResetResultIndex)
  self.manualOption = true
  ServiceItemProxy.Instance:CallProcessEnchantRefreshAttr(save, itemid, self.chooseResetResultIndex)
end

function EnchantThirdAttrResetView:OnClickActionBtn()
  if not self:HasTarget() then
    return
  end
  if self:HasRefreshAttr() then
    return
  end
  if not self.resetCostEnough then
    MsgManager.ShowMsgByID(8)
    return
  end
  if resetClickTime and UnityUnscaledTime - resetClickTime < optionalBtnIntervalTime then
    return
  end
  local _actionFunc = function()
    FunctionSecurity.Me():EnchantingEquip(function(self)
      ServiceItemProxy.Instance:CallEnchantRefreshAttr(self.targetData.id, self.tenPullsTog.value)
      resetClickTime = UnityUnscaledTime
      self:PlayUIEffect(EffectMap.UI.EquipReplaceNew, self.effContainer, true)
      self:PlayUISound(AudioMap.UI.EnchantThireResetSuc)
    end, self)
  end
  if self:HasGoodRefreshAttr() then
    MsgManager.ConfirmMsgByID(4301, function()
      _actionFunc()
    end)
  elseif self:HasRefreshAttr() then
    if LocalSaveProxy.Instance:GetDontShowAgain(4300) then
      _actionFunc()
    else
      MsgManager.DontAgainConfirmMsgByID(4300, function()
        _actionFunc()
      end)
    end
  else
    _actionFunc()
  end
end

function EnchantThirdAttrResetView:HasGoodRefreshAttr()
  if not self:HasTarget() then
    return
  end
  if self.targetData:HasGoodEnchantRefreshAttr() then
    return true
  end
  return false
end

function EnchantThirdAttrResetView:OnEnter()
  EnchantThirdAttrResetView.super.OnEnter(self)
  local nnpc = self.viewdata.viewdata and self.viewdata.viewdata.npcdata
  if nnpc then
    self:CameraFocusOnNpc(nnpc.assetRole.completeTransform)
  else
    self:CameraRotateToMe()
  end
  local curEnchantId = EnchantEquipUtil.Instance:GetCurEnchantId()
  if curEnchantId then
    local item = bagIns:GetItemByGuid(curEnchantId, enchantPackageCheck)
    if item and self:checkChooseBoardValid(item) then
      self:SetTargetCell(item)
      return
    end
  end
  self:UpdateViewByTargetCell()
end

function EnchantThirdAttrResetView:OnExit()
  self:CameraReset()
  EnchantThirdAttrResetView.super.OnExit(self)
end
