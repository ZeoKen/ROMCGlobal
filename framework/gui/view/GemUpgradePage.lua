autoImport("WrapListCtrl")
autoImport("GemCell")
autoImport("GemUpgradeInfoCell")
GemUpgradePage = class("GemUpgradePage", SubView)
GemUpgradePageMode = {SetTargetCell = 1, SetMaterial = 2}
local tempArr, infoArr, bagIns
local isSortOrderDescending = true

function GemUpgradePage:Init()
  self:ReLoadPerferb("view/GemUpgradePage")
  self.trans:SetParent(self.container.pageContainer.transform, false)
  self:AddEvents()
  self:InitData()
  self:InitLeft()
  self:InitRight()
  self:InitHelpButton()
end

function GemUpgradePage:AddEvents()
  self:AddDispatcherEvt(ItemEvent.GemDataUpdate, self.OnGemDataUpdate)
  self:AddDispatcherEvt(ItemEvent.GemUpdate, self.OnGemUpdate)
end

function GemUpgradePage:InitData()
  if not tempArr then
    tempArr = {}
  end
  if not infoArr then
    infoArr = {}
  end
  if not bagIns then
    bagIns = BagProxy.Instance
  end
  self.selectedMaterialData = {}
end

function GemUpgradePage:InitLeft()
  self.noneTip = self:FindGO("NoneTip")
  self.normalStick = self:FindComponent("NormalStick", UIWidget)
  self.itemContainer = self:FindGO("ItemContainer")
  self.listCtrl = WrapListCtrl.new(self.itemContainer, GemCell, "GemCell", WrapListCtrl_Dir.Vertical, 5, 102, true)
  self.listCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickListCell, self)
  self.listCtrl:AddEventListener(MouseEvent.LongPress, self.OnLongPressListCell, self)
  self.listCtrl:AddEventListener(ItemEvent.GemDelete, self.OnGemDelete, self)
  self.listCells = self.listCtrl:GetCells()
  for _, cell in pairs(self.listCells) do
    cell:SetShowDeleteIcon(true)
  end
  self.attributeLvSortOrderTrans = self:FindGO("SortOrder").transform
  isSortOrderDescending = true
  self:AddButtonEvent("AttributeLvSort", function()
    isSortOrderDescending = not isSortOrderDescending
    local tempV3 = LuaGeometry.GetTempVector3(LuaGameObject.GetLocalEulerAngles(self.attributeLvSortOrderTrans))
    tempV3.z = (tempV3.z + 180) % 360
    self.attributeLvSortOrderTrans.localEulerAngles = tempV3
    self:UpdateList()
  end)
  self:TryInitFilterPopOfView("AttributeFilterPop", function()
    self:UpdateList()
  end, GemAttributeFilter)
  GemProxy.TryAddFavoriteFilterToFilterPop(self.AttributeFilterPop)
end

local skipTipOffset = {-90, -75}

function GemUpgradePage:InitRight()
  self.effectContainer = self:FindGO("EffectContainer")
  local skipBtnSp = self:FindComponent("SkipBtn", UISprite)
  self:AddButtonEvent("SkipBtn", function()
    TipManager.Instance:ShowSkipAnimationTip(SKIPTYPE.GemUpgrade, skipBtnSp, NGUIUtil.AnchorSide.Left, skipTipOffset)
  end)
  self.targetCellChooseSymbol = self:FindGO("TargetCellIconChoose")
  local targetCellGO = self:FindGO("TargetCell")
  self:LoadPreferb_ByFullPath(ResourcePathHelper.UICell("GemCell"), targetCellGO)
  self.targetCell = GemCell.new(targetCellGO)
  self.targetCell:HideNum()
  self.targetCell:SetShowBagSlot(true)
  self.targetCell:SetShowNewTag(false)
  self.targetCell:SetShowEmbeddedTip(false)
  self.targetCell:AddEventListener(MouseEvent.MouseClick, self.OnClickTargetCell, self)
  self.isBtnsEnabled = true
  self:AddButtonEvent("AutoBtn", function()
    self:DelayedEnableBtnsAfterAction(self.TryAutoAddMaterial)
  end)
  self:AddButtonEvent("UpgradeBtn", function()
    self:DelayedEnableBtnsAfterAction(self.TryUpgrade)
  end)
  self.infoDownChooseSymbol = self:FindGO("InfoDownChoose")
  local infoTable = self:FindComponent("InfoTable", UITable)
  self.infoListCtrl = UIGridListCtrl.new(infoTable, GemUpgradeInfoCell, "GemUpgradeInfoCell")
  local expRoot = self:FindGO("Exp")
  self.gemLvLabel = self:FindComponent("LvLabel", UILabel, expRoot)
  self.maxLabelGO = self:FindGO("MaxLabel", expRoot)
  if self.maxLabelGO then
    self:Hide(self.maxLabelGO)
  end
  self.expSlider = self:FindComponent("ExpSlider", UISlider, expRoot)
  self.expExpectedSlider = self:FindComponent("ExpExpectedSlider", UISlider, expRoot)
  self.expLabel = self:FindComponent("ExpLabel", UILabel, expRoot)
  self.goBtn = self:FindGO("GoBtn", expRoot)
  if self.goBtn then
    self:Hide(self.goBtn)
  end
  local grid = self:FindComponent("Grid", UIGrid)
  self.materialScrollView = grid.transform.parent:GetComponent(UIScrollView)
  self.materialListCtrl = UIGridListCtrl.new(grid, GemCell, "GemCell")
  self.materialListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickMaterialCell, self)
  self.materialListCtrl:AddEventListener(ItemEvent.GemDelete, self.OnClickMaterialCell, self)
  self.leadLabel = self:FindGO("LeadLabel")
end

function GemUpgradePage:InitHelpButton()
  local go = self:FindGO("HelpBtn")
  local help_id = GemProxy.Instance:CheckGemSpeedUpOpen() and 1011 or 1007
  self:TryOpenHelpViewById(help_id, nil, go)
end

function GemUpgradePage:OnEnter()
  GemUpgradePage.super.OnEnter(self)
  self.parentViewData = self.viewdata.viewdata and self.viewdata.viewdata.data
  if self.parentViewData and type(self.parentViewData) == "table" then
    self:SetTargetCell(self.parentViewData)
    self:OnClickMaterialCell()
  else
    self:OnActivate()
  end
end

function GemUpgradePage:OnActivate()
  if not self.backEffect then
    self:PlayUIEffect(EffectMap.UI.GemViewUpgrade, self.effectContainer, false, function(obj, args, assetEffect)
      self.backEffect = assetEffect
      self.backEffect:ResetAction("shengji_1", 0, true)
    end)
  else
    self.backEffect:ResetAction("shengji_1", 0, true)
  end
  if self.parentViewData then
    self.parentViewData = nil
    return
  end
  self.leadLabel:SetActive(true)
  self:SwitchMode(GemUpgradePageMode.SetTargetCell)
  self:SetTargetCell()
  self:ClearMaterialList()
  self:UpdateList()
end

function GemUpgradePage:OnDeactivate()
  TipManager.CloseTip()
end

function GemUpgradePage:OnExit()
  TimeTickManager.Me():ClearTick(self)
  GemUpgradePage.super.OnExit(self)
end

function GemUpgradePage:OnClickTargetCell()
  if self.mode == GemUpgradePageMode.SetTargetCell then
    return
  end
  self:OnActivate()
  self:UpdateList()
end

function GemUpgradePage:OnClickListCell(cellCtl)
  if self.isMax and self.mode == GemUpgradePageMode.SetMaterial then
    local msgid = #self.selectedMaterialData > 0 and 36017 or 36018
    MsgManager.ShowMsgByID(msgid)
    return
  end
  if self.isClickOnListCtrlDisabled then
    self.isClickOnListCtrlDisabled = nil
    return
  end
  if cellCtl:CheckDataIsNilOrEmpty() then
    return
  end
  local data = cellCtl and cellCtl.data
  for _, cell in pairs(self.listCells) do
    cell:SetChoose(data and data.id or 0)
  end
  if self.mode == GemUpgradePageMode.SetTargetCell then
    self:SetTargetCell(data)
    self:ClearMaterialList()
    self:SwitchMode(GemUpgradePageMode.SetMaterial)
  elseif self.mode == GemUpgradePageMode.SetMaterial and #self.selectedMaterialData < 20 then
    if cellCtl.selectedCount < data.num then
      TableUtility.ArrayPushBack(self.selectedMaterialData, self:GetAttributeGemCloneData(data, 1))
    end
    self:UpdateSelectedMaterial()
  end
  self:UpdateList(true)
  cellCtl:TryClearNewTag()
end

function GemUpgradePage:OnClickMaterialCell(cellCtl)
  if not self.targetCell.data then
    return
  end
  self:SwitchMode(GemUpgradePageMode.SetMaterial)
  TableUtility.ArrayRemoveByPredicate(self.selectedMaterialData, function(item)
    local data = cellCtl and cellCtl.data
    return BagItemCell.CheckData(data) and data.id == item.id
  end)
  self:UpdateSelectedMaterial()
  self:UpdateList(true)
end

function GemUpgradePage:OnGemDelete(cellCtl)
  self:OnClickMaterialCell(cellCtl)
end

function GemUpgradePage:OnLongPressListCell(param)
  local isPressing, cellCtl = param[1], param[2]
  if isPressing and cellCtl then
    self:ShowGemTip(cellCtl.gameObject, cellCtl.data)
    self.isClickOnListCtrlDisabled = true
  end
end

function GemUpgradePage:OnGemDataUpdate(server_items)
  if not self.gameObject.activeInHierarchy then
    return
  end
  TipManager.CloseTip()
  self:ClearMaterialList()
  local items = server_items
  if items and items[1] then
    GemProxy.Instance:ShowNewGemResults(items)
    self.targetItemIdToRefresh = items[1].base.guid
  else
    local targetData = self.targetCell.data
    if targetData.gemAttrData:IsMax() then
      self.targetItemIdToRefresh = nil
    else
      self.targetItemIdToRefresh = targetData.id
    end
  end
end

function GemUpgradePage:OnGemUpdate()
  self:SetTargetCellByGuid(self.targetItemIdToRefresh)
  self:UpdateList(true)
end

local comparer = function(l, r)
  local comp1 = GemProxy.PredicateComparer(l, r, GemProxy.CheckIsEmbedded)
  if comp1 ~= nil then
    return comp1
  end
  local comp2 = GemProxy.PredicateComparer(l, r, GemProxy.CheckIsFavorite)
  if comp2 ~= nil then
    return comp2
  end
  return GemProxy.GetAttributeItemDataLevelComparer(isSortOrderDescending)(l, r)
end
local clickDisablePredicate = function(gemCell, self)
  return self.mode == GemUpgradePageMode.SetMaterial and (GemProxy.CheckIsFavorite(gemCell.data) or GemProxy.CheckContainsGemAttrData(gemCell.data) and GemProxy.CheckContainsGemAttrData(self.targetCell.data) and gemCell.data.gemAttrData.type ~= self.targetCell.data.gemAttrData.type)
end

function GemUpgradePage:UpdateList(noResetPos)
  local gems = GemProxy.GetAttributeItemDataByFilterDatasOfView(self)
  table.sort(gems, comparer)
  local multiSelectStyle
  if self.mode == GemUpgradePageMode.SetTargetCell then
    multiSelectStyle = GemCell.MultiSelectStyle.None
  elseif self.mode == GemUpgradePageMode.SetMaterial then
    GemProxy.RemoveEmbedded(gems)
    self:RemoveOneTargetCellItemFromItemDatas(gems)
    multiSelectStyle = GemCell.MultiSelectStyle.ShowSelectedCount
  end
  for _, gCell in pairs(self.listCells) do
    gCell:SetMultiSelectStyle(multiSelectStyle)
    gCell:SetMultiSelectModel(self.mode == GemUpgradePageMode.SetMaterial and self.selectedMaterialData or nil)
    gCell:SetClickDisablePredicate(self.mode == GemUpgradePageMode.SetMaterial and clickDisablePredicate or nil, self)
  end
  self.noneTip:SetActive(#gems <= 0)
  self.itemContainer:SetActive(0 < #gems)
  self.listCtrl:ResetDatas(gems, not noResetPos)
end

function GemUpgradePage:SetTargetCell(data)
  TipManager.CloseTip()
  if not GemProxy.CheckContainsGemAttrData(data) then
    data = nil
  end
  self.targetCell:SetData(data)
  self:UpdateGemExpInfo()
  self.leadLabel:SetActive(data == nil)
end

function GemUpgradePage:SetTargetCellByGuid(guid)
  local item = guid and bagIns:GetItemByGuid(guid, SceneItem_pb.EPACKTYPE_GEM_ATTR)
  self:SetTargetCell(item)
  return item ~= nil
end

function GemUpgradePage:UpdateGemExpInfo()
  local targetData = self.targetCell.data
  local beforeAttrData = targetData and targetData.gemAttrData
  local afterAttrData, infoElement
  TableUtility.ArrayClear(infoArr)
  self.extra_exp = GemProxy.Instance:GetExtraExp(#self.selectedMaterialData) or 0
  if GemProxy.CheckIsGemAttrData(beforeAttrData) then
    afterAttrData = self:GetGemAttrDataOfAfterUpdate(beforeAttrData, self.extra_exp)
    infoArr[1] = {
      key = ZhString.Gem_UpgradeInfoLvLabel,
      beforeData = string.format(ZhString.Gem_UpgradeLvLabelFormat, beforeAttrData.lv),
      afterData = string.format(ZhString.Gem_UpgradeLvLabelFormat, afterAttrData.lv)
    }
    for i = 1, #beforeAttrData.propDescs do
      infoElement = {}
      infoElement.key = beforeAttrData.propDescs[i]
      infoElement.beforeData = beforeAttrData.valueDescs[i]
      infoElement.afterData = afterAttrData.valueDescs[i]
      if infoElement.afterData then
        TableUtility.ArrayPushBack(infoArr, infoElement)
      end
    end
  end
  self.infoListCtrl:ResetDatas(infoArr)
  self:UpdateExpSlider(beforeAttrData, afterAttrData)
end

function GemUpgradePage:UpdateExpSlider(beforeAttrData, afterAttrData)
  self.gemLvLabel.text = beforeAttrData and string.format(ZhString.Gem_UpgradeLvLabelFormat, beforeAttrData.lv) or ""
  self.isMax = beforeAttrData ~= nil and afterAttrData ~= nil and afterAttrData:IsMax()
  if not beforeAttrData or not afterAttrData then
    self.expLabel.text = ""
    self.expSlider.value = 0
    self.expExpectedSlider.value = 0
    return
  end
  local expToNextLv = beforeAttrData:GetExpForNextLevel()
  self.expSlider.value = expToNextLv ~= 0 and math.clamp(beforeAttrData.exp / expToNextLv, 0, 1) or 1
  local expDelta = afterAttrData:GetTotalExp() - beforeAttrData:GetTotalExp()
  local expDeltaFromCurLv = beforeAttrData.exp + expDelta - self.extra_exp
  local expLabelStr
  if 0 < expDelta then
    if 0 < self.extra_exp then
      expLabelStr = string.format(ZhString.Gem_UpgradeExpLabelUpgradeFormat_Extra, self.extra_exp, expDeltaFromCurLv, expToNextLv)
    else
      expLabelStr = string.format(ZhString.Gem_UpgradeExpLabelUpgradeFormat, expDeltaFromCurLv, expToNextLv)
    end
  else
    expLabelStr = string.format(ZhString.Gem_UpgradeExpLabelCommonFormat, beforeAttrData.exp, expToNextLv)
  end
  if self.isMax then
    local expAll = beforeAttrData:GetExpAll()
    expLabelStr = string.format(ZhString.Gem_UpgradeExpLabelCommonFormat, expAll, expAll)
    self.expLabel.text = expLabelStr .. ZhString.Gem_UpgradeMaxLv
  else
    self.expLabel.text = expLabelStr
  end
  self.expExpectedSlider.value = expToNextLv ~= 0 and math.clamp((expDeltaFromCurLv + self.extra_exp) / expToNextLv, 0, 1) or 1
end

function GemUpgradePage:UpdateSelectedMaterial()
  TipManager.CloseTip()
  TableUtility.ArrayClear(tempArr)
  TableUtility.ArrayShallowCopy(tempArr, self.selectedMaterialData)
  for i = #self.selectedMaterialData + 1, 20 do
    TableUtility.ArrayPushBack(tempArr, BagItemEmptyType.Empty)
  end
  self.materialListCtrl:ResetDatas(tempArr)
  local cells = self.materialListCtrl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetShowNewTag(false)
    if not cell:CheckDataIsNilOrEmpty() then
      cell:ForceShowDeleteIcon()
    end
  end
  self.materialScrollView:ResetPosition()
  self:UpdateGemExpInfo()
end

function GemUpgradePage:ClearMaterialList()
  TableUtility.ArrayClear(self.selectedMaterialData)
  self:UpdateSelectedMaterial()
end

local tempAfterAttrData

function GemUpgradePage:GetGemAttrDataOfAfterUpdate(beforeAttrData, extra_exp)
  if not GemProxy.CheckIsGemAttrData(beforeAttrData) then
    LogUtility.Error("You're trying to get after update gemAttrData from a non-GemAttrData!")
    return
  end
  tempAfterAttrData = tempAfterAttrData or GemAttrData.new("fake", beforeAttrData)
  tempAfterAttrData:SetData(beforeAttrData)
  extra_exp = extra_exp or 0
  tempAfterAttrData:SetTotalExp(extra_exp + beforeAttrData:GetTotalExp() + GemProxy.GetExpSumFromAttributeItemDatas(self.selectedMaterialData))
  return tempAfterAttrData
end

function GemUpgradePage:ShowGemTip(cellGO, data)
  local tip = GemCell.ShowGemTip(cellGO, data, self.normalStick)
  if not tip then
    return
  end
  tip:AddIgnoreBounds(self.itemContainer)
end

function GemUpgradePage:RemoveOneTargetCellItemFromItemDatas(gems)
  if not self.targetCell or not self.targetCell.data then
    return
  end
  local id, gem = self.targetCell.data.id
  for i = 1, #gems do
    gem = gems[i]
    if id == gem.id then
      local realData = bagIns:GetItemByGuid(id)
      if realData and 1 < realData.num then
        gems[i] = self:GetAttributeGemCloneData(gem, realData.num - 1)
        break
      end
      table.remove(gems, i)
      break
    end
  end
end

function GemUpgradePage:TryAutoAddMaterial()
  local targetData = self.targetCell.data
  if not GemProxy.CheckContainsGemAttrData(targetData) then
    MsgManager.FloatMsg(nil, ZhString.Gem_UpgradeNoTargetCellTip)
    return
  end
  self:SwitchMode(GemUpgradePageMode.SetMaterial)
  local beforeAttrData = targetData.gemAttrData
  if self.isMax and self.mode == GemUpgradePageMode.SetMaterial then
    local msgid = #self.selectedMaterialData > 0 and 36017 or 36018
    MsgManager.ShowMsgByID(msgid)
    return
  end
  local gems = GemProxy.GetAttributeItemDataByType(targetData.gemAttrData.type) or {}
  GemProxy.RemoveEmbedded(gems)
  GemProxy.RemoveFavorite(gems)
  self:RemoveOneTargetCellItemFromItemDatas(gems)
  table.sort(gems, function(l, r)
    local lSameName = l.staticData.id == targetData.staticData.id and 1 or 0
    local rSameName = r.staticData.id == targetData.staticData.id and 1 or 0
    if lSameName ~= rSameName then
      return lSameName < rSameName
    end
    return GemProxy.AttributeLevelDescendingComparer(l, r)
  end)
  TableUtility.ArrayClear(self.selectedMaterialData)
  local afterAttrData, data
  for i = #gems, 1, -1 do
    data = gems[i]
    if data then
      for j = 1, data.num do
        if #self.selectedMaterialData >= 20 then
          break
        end
        afterAttrData = self:GetGemAttrDataOfAfterUpdate(beforeAttrData)
        if afterAttrData:IsMax() then
          break
        end
        TableUtility.ArrayPushBack(self.selectedMaterialData, self:GetAttributeGemCloneData(data, 1))
      end
    end
  end
  self:UpdateSelectedMaterial()
  self:UpdateList()
end

function GemUpgradePage:TryUpgrade()
  if not self.targetCell.data or not GemProxy.CheckContainsGemAttrData(self.targetCell.data) then
    MsgManager.FloatMsg(nil, ZhString.Gem_UpgradeNoTargetCellTip)
    return
  end
  if self.isMax and self.mode == GemUpgradePageMode.SetMaterial and self.selectedMaterialData and #self.selectedMaterialData == 0 then
    MsgManager.ShowMsgByID(36018)
    return
  end
  if not self.selectedMaterialData or #self.selectedMaterialData <= 0 then
    MsgManager.FloatMsg(nil, ZhString.Gem_UpgradeNoMaterialTip)
    return
  end
  if self.targetCell.data.gemAttrData:IsMax() then
    MsgManager.FloatMsg(nil, ZhString.Gem_UpgradeMaxLevelTip)
    return
  end
  local afterAttrData = self:GetGemAttrDataOfAfterUpdate(self.targetCell.data.gemAttrData)
  if afterAttrData and afterAttrData:IsOverflow() then
    MsgManager.ConfirmMsgByID(25952, function()
      self:_Upgrade()
    end)
    return
  end
  self:_Upgrade()
end

function GemUpgradePage:_Upgrade()
  local gemToUpgradeGuid = self.targetCell.data.id
  if LocalSaveProxy.Instance:GetSkipAnimation(SKIPTYPE.GemUpgrade) then
    GemProxy.CallAttributeUpgrade(gemToUpgradeGuid, self.selectedMaterialData)
  else
    self:PlayUISound(AudioMap.UI.Gem)
    if self.foreEffect then
      self.foreEffect:Stop()
    end
    local actionName = "shengji_2"
    self:PlayUIEffect(EffectMap.UI.GemViewUpgrade, self.effectContainer, true, function(obj, args, assetEffect)
      self.foreEffect = assetEffect
      self.foreEffect:ResetAction(actionName, 0, true)
    end)
    if self.backEffect then
      self.backEffect:ResetAction(actionName, 0, true)
    end
    self.delayedEnableButtonTime = 4200
    TimeTickManager.Me():CreateOnceDelayTick(self.delayedEnableButtonTime, function(self)
      GemProxy.CallAttributeUpgrade(gemToUpgradeGuid, self.selectedMaterialData)
    end, self, 1)
  end
end

function GemUpgradePage:SwitchMode(mode)
  if not mode then
    return
  end
  if self.mode ~= mode then
    for _, cell in pairs(self.listCells) do
      cell:SetChoose()
    end
  end
  self.mode = mode
  self:UpdateMode()
end

function GemUpgradePage:UpdateMode()
  self.targetCellChooseSymbol:SetActive(self.mode == GemUpgradePageMode.SetTargetCell)
  self.infoDownChooseSymbol:SetActive(self.mode == GemUpgradePageMode.SetMaterial)
end

function GemUpgradePage:GetAttributeGemCloneData(itemData, num)
  if not itemData then
    return
  end
  if not GemProxy.CheckContainsGemAttrData(itemData) then
    return
  end
  local cloneData = itemData:Clone()
  cloneData.gemAttrData = itemData.gemAttrData
  if num then
    cloneData:SetItemNum(num)
  end
  cloneData.isNew = false
  return cloneData
end

function GemUpgradePage:DelayedEnableBtnsAfterAction(action)
  if not self.isBtnsEnabled then
    return
  end
  self.isBtnsEnabled = false
  action(self)
  local delayTime = self.delayedEnableButtonTime or 400
  TimeTickManager.Me():CreateOnceDelayTick(delayTime, function(self)
    self.isBtnsEnabled = true
    self.delayedEnableButtonTime = 400
  end, self, 0)
end

function GemUpgradePage:AddButtonEvent(name, event)
  GemUpgradePage.super.super.AddButtonEvent(self, name, event)
end
