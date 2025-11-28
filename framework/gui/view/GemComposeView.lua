autoImport("WrapListCtrl")
autoImport("GemCell")
autoImport("GemCombineCell")
GemComposeView = class("GemComposeView", BaseView)
GemComposeView.ViewType = UIViewType.NormalLayer
GemComposeViewMode = {
  Default = 0,
  SameName = 0,
  RandomProf = 1,
  CurrentProf = 2
}
GemComposeViewModeCostZeny = {
  [GemComposeViewMode.SameName] = GameConfig.Gem.SameNameCost,
  [GemComposeViewMode.RandomProf] = GameConfig.Gem.ThreeCostZeny,
  [GemComposeViewMode.CurrentProf] = GameConfig.Gem.FiveCostZeny
}
GemComposeViewModeTitle = {
  [GemComposeViewMode.SameName] = Table_NpcFunction[10028].NameZh,
  [GemComposeViewMode.RandomProf] = Table_NpcFunction[10026].NameZh,
  [GemComposeViewMode.CurrentProf] = Table_NpcFunction[10027].NameZh
}
GemComposeViewModeLeadLabel = {
  [GemComposeViewMode.SameName] = ZhString.Gem_ComposeSameNameTip,
  [GemComposeViewMode.RandomProf] = ZhString.Gem_Compose3to1Tip,
  [GemComposeViewMode.CurrentProf] = ZhString.Gem_Compose5to1Tip
}
GemComposeViewModeHelpId = {
  [GemComposeViewMode.SameName] = 1005,
  [GemComposeViewMode.RandomProf] = 1003,
  [GemComposeViewMode.CurrentProf] = 1004
}
GemComposeViewModeMixingGroupAllowed = {
  [GemComposeViewMode.SameName] = true,
  [GemComposeViewMode.RandomProf] = false,
  [GemComposeViewMode.CurrentProf] = false
}
local tempTable, gemProxyIns, tickManager = {}
local costLabelColor = LuaColor.New(0.37254901960784315, 0.37254901960784315, 0.37254901960784315, 1)

function GemComposeView:Init()
  if not gemProxyIns then
    gemProxyIns = GemProxy.Instance
  end
  if not tickManager then
    tickManager = TimeTickManager.Me()
  end
  self.mode = self.viewdata.viewdata and self.viewdata.viewdata.mode
  if not self.mode then
    self.mode = GemComposeViewMode.Default
  end
  self:AddEvents()
  self:InitData()
  self:InitLeft()
  self:InitRight()
end

function GemComposeView:AddEvents()
  self:AddListenEvt(MyselfEvent.ZenyChange, self.UpdateCostLabelColor)
  self:AddListenEvt(ItemEvent.GemUpdate, self.OnGemUpdate)
  self:AddListenEvt(ServiceEvent.ItemGemDataUpdateItemCmd, self.OnGemDataUpdate)
  self:AddListenEvt(ServiceUserProxy.RecvLogin, self.CloseSelf)
end

function GemComposeView:InitData()
  self.selectedMaterialData = {}
  self.multiComposeMaterialData = {}
end

local skipAnimTipOffset = {90, -75}

function GemComposeView:InitRight()
  self.skipBtnSp = self:FindComponent("SkipBtn", UISprite)
  self:AddButtonEvent("SkipBtn", function()
    TipManager.Instance:ShowSkipAnimationTip(SKIPTYPE.GemFunction, self.skipBtnSp, NGUIUtil.AnchorSide.Right, skipAnimTipOffset)
  end)
  self.effectContainer = self:FindGO("EffectContainer")
  self.titleLabel = self:FindComponent("TitleLabel", UILabel)
  self.mainLabel = self:FindComponent("MainLabel", UILabel)
  self.costLabel = self:FindComponent("CostLabel", UILabel)
  self.material3GO = self:FindGO("3Material")
  self.material5GO = self:FindGO("5Material")
  self.multiCompose3GO = self:FindGO("3MultiComposePanel")
  self.multiCompose5GO = self:FindGO("5MultiComposePanel")
  local composeBtn = self:FindGO("ComposeBtn")
  self:AddClickEvent(composeBtn, function()
    if not self.isComposeBtnActive then
      return
    end
    self:TryCompose()
  end)
  self.composeBtnBgSp = composeBtn:GetComponent(UISprite)
  self.composeBtnLabel = self:FindComponent("Label", UILabel, composeBtn)
end

function GemComposeView:InitLeft()
  self.leftGO = self:FindGO("Left")
  self.normalStick = self:FindComponent("NormalStick", UIWidget)
  self:AddButtonEvent("CloseLeftBtn", function()
    self.leftGO:SetActive(false)
  end)
  local updateList = function()
    self:UpdateList()
  end
  self:TryInitFilterPopOfView("SkillClassFilterPop", updateList, GemSkillQualityFilter, GemSkillQualityFilterData)
  self:TryInitFilterPopOfView("SkillProfessionFilterPop", updateList, GemSkillProfessionFilter, GemSkillProfessionFilterData)
  GemProxy.TryAddFavoriteFilterToFilterPop(self.SkillClassFilterPop)
  GemProxy.TryRemoveBannedProfessionsFromFilter(self.SkillProfessionFilterPop)
  self.itemContainer = self:FindGO("ItemContainer", self.leftGO)
  self.listCtrl = WrapListCtrl.new(self.itemContainer, GemCell, "GemCell", WrapListCtrl_Dir.Vertical, 5, 102, true)
  self.listCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickListCell, self)
  self.listCtrl:AddEventListener(MouseEvent.LongPress, self.OnLongPressListCell, self)
  self.listCtrl:AddEventListener(ItemEvent.GemDelete, self.OnGemDelete, self)
  self.listCells = self.listCtrl:GetCells()
  for _, cell in pairs(self.listCells) do
    cell:SetShowDeleteIcon(true)
    cell:SetMultiSelectStyle(GemCell.MultiSelectStyle.HideSelectedCount)
  end
  self.leftGO:SetActive(false)
end

function GemComposeView:OnEnter()
  GemComposeView.super.OnEnter(self)
  self:UpdateMode()
end

function GemComposeView:OnExit()
  tickManager:ClearTick(self)
  GemComposeView.super.OnExit(self)
end

function GemComposeView:OnClickMaterialCell(cellCtl)
  self.leftGO:SetActive(true)
  if self.isComposing then
    return
  end
  local data = cellCtl.data
  TableUtility.ArrayRemoveByPredicate(self.selectedMaterialData, function(item)
    return BagItemCell.CheckData(data) and data.id == item.id
  end)
  self:UpdateSelectedMaterial()
  self:UpdateList(true)
end

function GemComposeView:OnClickMultiComposeCell(cellCtl)
  self.leftGO:SetActive(true)
  if self.isComposing then
    return
  end
  local index = cellCtl.indexInTable
  if index then
    self.multiComposeMaterialData[index] = nil
  else
    LogUtility.Error("Cannot get indexInTable of GemCell")
    return
  end
  self.chooseMultiComposeCellIndex = index
  self.multiComposeMaterialData[index] = nil
  self:UpdateMultiComposeMaterial()
  self:UpdateList(true)
  cellCtl.chooseSymbol:SetActive(true)
end

function GemComposeView:OnClickListCell(cellCtl)
  if self.isComposing then
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
  if data.num > cellCtl.selectedCount then
    local cloneData = data:Clone()
    cloneData:SetItemNum(1)
    cloneData.gemSkillData = data.gemSkillData
    if self.curMultiComposeGO.activeSelf and self.chooseMultiComposeCellIndex then
      self.multiComposeMaterialData[self.chooseMultiComposeCellIndex] = cloneData
      self:UpdateMultiComposeMaterial()
      self:SetMultiComposeCellChooseToFirstEmpty()
      self:UpdateList(true)
    elseif #self.selectedMaterialData < self.maxMaterialCount then
      TableUtility.ArrayPushBack(self.selectedMaterialData, cloneData)
      self:UpdateSelectedMaterial()
      self:UpdateList(true)
    end
  end
  cellCtl:TryClearNewTag()
end

function GemComposeView:OnLongPressListCell(param)
  local isPressing, cellCtl = param[1], param[2]
  if isPressing and cellCtl then
    self:ShowGemTip(cellCtl.gameObject, cellCtl.data)
    self.isClickOnListCtrlDisabled = true
  end
end

function GemComposeView:OnGemDelete(cellCtl)
  if self.curMultiComposeGO.activeSelf then
    TableUtility.TableRemoveByPredicate(self.multiComposeMaterialData, function(index, item)
      return not cellCtl:CheckDataIsNilOrEmpty() and cellCtl.data.id == item.id
    end)
    self:UpdateMultiComposeMaterial()
    if self.chooseMultiComposeCellIndex then
      self:SetMultiComposeCellChoose(self.chooseMultiComposeCellIndex)
    else
      self:SetMultiComposeCellChooseToFirstEmpty()
    end
    self:UpdateList(true)
  else
    self:OnClickMaterialCell(cellCtl)
  end
end

function GemComposeView:UpdateMode()
  self.helpId = GemComposeViewModeHelpId[self.mode]
  local helpID = helpId or 1005
  self:RegistShowGeneralHelpByHelpID(helpID, self:FindGO("HelpButton"))
  self.material5GO:SetActive(false)
  self.material3GO:SetActive(false)
  self.multiCompose3GO:SetActive(false)
  self.multiCompose5GO:SetActive(false)
  local isCurrentProf = self.mode == GemComposeViewMode.CurrentProf
  self.curMaterialGO = isCurrentProf and self.material5GO or self.material3GO
  local curMaterialPanel = self:FindGO("MaterialPanel", self.curMaterialGO)
  local curMaterialCellName = isCurrentProf and "GemCombine5Cell" or "GemCombine3Cell"
  local curMaterialCellObj = self:LoadPreferb("cell/" .. curMaterialCellName, curMaterialPanel)
  self.curMaterialCombineCell = _G[curMaterialCellName].new(curMaterialCellObj)
  self.curMaterialCombineCell:AddEventListener(MouseEvent.MouseClick, self.OnClickMaterialCell, self)
  self.curMaterialCombineCell:AddEventListener(ItemEvent.GemDelete, self.OnClickMaterialCell, self)
  self.curMultiComposeGO = isCurrentProf and self.multiCompose5GO or self.multiCompose3GO
  local expandBtn = self:FindGO("ExpandBtn", self.curMaterialGO)
  self:AddClickEvent(expandBtn, function()
    self:SwitchMultiCompose(true)
  end)
  local shrinkBtn = self:FindGO("ShrinkBtn", self.curMultiComposeGO)
  self:AddClickEvent(shrinkBtn, function()
    self:SwitchMultiCompose(false)
  end)
  local multiComposeTable = self:FindComponent("Table", UITable, self.curMultiComposeGO)
  self.multiComposeScrollView = multiComposeTable.transform.parent:GetComponent(UIScrollView)
  self.curMultiComposeListCtrl = UIGridListCtrl.new(multiComposeTable, _G[curMaterialCellName], curMaterialCellName)
  self.curMultiComposeListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickMultiComposeCell, self)
  self.curMultiComposeListCtrl:AddEventListener(ItemEvent.GemDelete, self.OnClickMultiComposeCell, self)
  self.maxMaterialCount = isCurrentProf and 5 or 3
  self:SwitchMultiCompose(false)
  self.mainLabel.text = GemComposeViewModeLeadLabel[self.mode]
  self.titleLabel.text = GemComposeViewModeTitle[self.mode]
  local exEffectName = self.effectName
  self.effectName = self.mode ~= GemComposeViewMode.SameName and EffectMap.UI.GemViewSynthetic or EffectMap.UI.GemViewReset
  if exEffectName ~= self.effectName then
    if self.backEffect then
      self.backEffect:Stop()
    end
    if self.foreEffect then
      self.foreEffect:Stop()
    end
    self:PlayUIEffectAction("ronghe_1", false, function(obj, args, assetEffect)
      self.backEffect = assetEffect
    end)
  end
end

local comparer = function(l, r)
  local comp1 = GemProxy.PredicateComparer(l, r, GemProxy.CheckIsFavorite)
  if comp1 ~= nil then
    return comp1
  end
  return GemProxy.BasicComparer(l, r)
end

function GemComposeView:UpdateList(noResetPos)
  if not self.leftGO.activeInHierarchy then
    return
  end
  local gems = GemProxy.GetSkillItemDataByFilterDatasOfView(self)
  GemProxy.RemoveEmbedded(gems)
  table.sort(gems, comparer)
  self.listCtrl:ResetDatas(gems, not noResetPos)
end

function GemComposeView:UpdateSelectedMaterial()
  TipManager.CloseTip()
  TableUtility.TableClear(tempTable)
  TableUtility.ArrayShallowCopy(tempTable, self.selectedMaterialData)
  for i = #self.selectedMaterialData + 1, self.maxMaterialCount do
    TableUtility.ArrayPushBack(tempTable, BagItemEmptyType.Empty)
  end
  self.curMaterialCombineCell:SetData(tempTable)
  local cells = self.curMaterialCombineCell:GetCells()
  for _, cell in pairs(cells) do
    cell:SetShowNewTag(false)
    if not cell:CheckDataIsNilOrEmpty() then
      cell:ForceShowDeleteIcon()
    end
  end
  self:CheckComposeReady()
end

function GemComposeView:UpdateMultiComposeMaterial()
  TipManager.CloseTip()
  self.curMultiComposeListCtrl:ResetDatas(self:ReUnitMultiComposeData())
  local combineCells = self.curMultiComposeListCtrl:GetCells()
  for _, combineCell in pairs(combineCells) do
    combineCell:SetShowNewTag(false)
    combineCell:SetCheckTipEnablePredicate(self:GetCheckTipEnablePredicate())
    combineCell:ForceShowDeleteIcon()
  end
  self:CheckComposeReady()
end

function GemComposeView:SetCost(cost)
  if type(cost) ~= "number" then
    LogUtility.Error("Invalid argument while calling SetCostLabel!")
    return
  end
  self.cost = cost
  self.costLabel.text = StringUtil.NumThousandFormat(cost)
  self:UpdateCostLabelColor()
end

function GemComposeView:UpdateCostLabelColor()
  self.costLabel.color = not self:CheckZeny() and ColorUtil.Red or costLabelColor
end

local multiComposeClickDisablePredicate = function(gemCell, self)
  if GemProxy.CheckIsFavorite(gemCell.data) then
    return true
  end
  if gemCell.selectedCount > 0 then
    return false
  end
  local flag
  if self.mode ~= GemComposeViewMode.SameName then
    local _, compareData = next(self.multiComposeMaterialData)
    flag = gemCell.data and compareData and gemProxyIns:GetSkillQualityGroupFromItemData(gemCell.data) ~= gemProxyIns:GetSkillQualityGroupFromItemData(compareData)
  end
  return flag
end
local singleComposeClickDisablePredicate = function(gemCell, self)
  if GemProxy.CheckIsFavorite(gemCell.data) then
    return true
  end
  if gemCell.selectedCount > 0 then
    return false
  end
  local flag
  if self.mode == GemComposeViewMode.SameName then
    flag = gemCell.data and gemCell.selectedCount == 0 and 0 < #self.selectedMaterialData and gemCell.data.staticData.id ~= self.selectedMaterialData[1].staticData.id
  else
    flag = gemCell.data and 0 < #self.selectedMaterialData and gemProxyIns:GetSkillQualityGroupFromItemData(gemCell.data) ~= gemProxyIns:GetSkillQualityGroupFromItemData(self.selectedMaterialData[1])
  end
  return flag
end

function GemComposeView:SwitchMultiCompose(isActive)
  isActive = isActive or false
  self.curMultiComposeGO:SetActive(isActive)
  self.curMaterialGO:SetActive(not isActive)
  if isActive then
    for _, cell in pairs(self.listCells) do
      cell:SetMultiSelectModel(self.multiComposeMaterialData)
      cell:SetClickDisablePredicate(multiComposeClickDisablePredicate, self)
    end
    TableUtility.TableClear(self.multiComposeMaterialData)
    for i = 1, self.maxMaterialCount do
      self.multiComposeMaterialData[i] = self.selectedMaterialData[i]
    end
    self:UpdateMultiComposeMaterial()
    self:SetMultiComposeCellChooseToFirstEmpty()
    TableUtility.ArrayClear(self.selectedMaterialData)
  else
    self:SetCost(GemComposeViewModeCostZeny[self.mode])
    for _, cell in pairs(self.listCells) do
      cell:SetMultiSelectModel(self.selectedMaterialData)
      cell:SetClickDisablePredicate(singleComposeClickDisablePredicate, self)
    end
    TableUtility.ArrayClear(self.selectedMaterialData)
    for i = 1, self.maxMaterialCount do
      if self.multiComposeMaterialData[i] then
        TableUtility.ArrayPushBack(self.selectedMaterialData, self.multiComposeMaterialData[i])
      end
    end
    self:UpdateSelectedMaterial()
    TableUtility.TableClear(self.multiComposeMaterialData)
  end
  self:UpdateList()
end

function GemComposeView:OnGemUpdate()
  if self.curMultiComposeGO.activeSelf then
    local data, realData, index, isArranged
    for i = 1, self:GetMaxMultiComposeCellCount() do
      data = self.multiComposeMaterialData[i]
      if data then
        realData = BagProxy.Instance:GetItemByGuid(data.id, SceneItem_pb.EPACKTYPE_GEM_SKILL)
        if not realData or GemProxy.CheckIsFavorite(realData) then
          self.multiComposeMaterialData[i] = nil
        end
      end
    end
    TableUtility.TableClear(tempTable)
    for i = 1, self:GetMaxMultiComposeCellCount() do
      data = self.multiComposeMaterialData[i]
      if data then
        TableUtility.ArrayPushBack(tempTable, data)
      end
    end
    TableUtility.TableClear(self.multiComposeMaterialData)
    if self.mode == GemComposeViewMode.SameName then
      local arrangedRowCount = 0
      for i = 1, #tempTable do
        data = tempTable[i]
        isArranged = false
        for j = 1, arrangedRowCount do
          if GemProxy.CheckIsSameName(data, self.multiComposeMaterialData[self.maxMaterialCount * (j - 1) + 1]) then
            for k = 2, self.maxMaterialCount do
              index = self.maxMaterialCount * (j - 1) + k
              if not self.multiComposeMaterialData[index] then
                self.multiComposeMaterialData[index] = data
                isArranged = true
                break
              end
            end
          end
          if isArranged then
            break
          end
        end
        if not isArranged then
          if arrangedRowCount < GemProxy.MultiComposeRowCount then
            self.multiComposeMaterialData[self.maxMaterialCount * arrangedRowCount + 1] = data
            arrangedRowCount = arrangedRowCount + 1
          else
            break
          end
        end
      end
    else
      TableUtility.ArrayShallowCopy(self.multiComposeMaterialData, tempTable)
    end
    self:UpdateMultiComposeMaterial()
    self:SetMultiComposeCellChooseToFirstEmpty()
  else
    TableUtility.ArrayClear(self.selectedMaterialData)
    self:UpdateSelectedMaterial()
  end
  self:UpdateList()
end

function GemComposeView:OnGemDataUpdate(note)
  TipManager.CloseTip()
  gemProxyIns:ShowNewGemResults(note.body and note.body.items)
end

function GemComposeView:TryCompose()
  if not self:CheckZeny() then
    MsgManager.ShowMsgByID(1)
    return
  end
  if self.mode == GemComposeViewMode.CurrentProf and not gemProxyIns:CheckIsMyProfessionAvailable() then
    MsgManager.ShowMsgByID(36007)
    return
  end
  local myProf = MyselfProxy.Instance:GetMyProfession()
  local _, certainMaterial = next(self.curMultiComposeGO.activeSelf and self.multiComposeMaterialData or self.selectedMaterialData)
  local isMaterial4S = certainMaterial and gemProxyIns:GetSkillQualityGroupByStaticId(certainMaterial.staticData.id) == 2
  if isMaterial4S then
    if ProfessionProxy.GetJobDepth(myProf) == 5 then
      if self.mode == GemComposeViewMode.CurrentProf and not gemProxyIns:GetAllGemIdsBySkillQualityGroupAndProfession(2, myProf) then
        MsgManager.ShowMsgByID(36014)
        return
      end
    elseif self.mode ~= GemComposeViewMode.SameName then
      MsgManager.ShowMsgByID(36013)
      return
    end
  end
  FunctionSecurity.Me():NormalOperation(self.Compose, self)
end

function GemComposeView:Compose()
  self.isComposing = true
  local delayedTime = 1000
  if LocalSaveProxy.Instance:GetSkipAnimation(SKIPTYPE.GemFunction) then
    self:SendComposeMessage()
  else
    if self.foreEffect then
      self.foreEffect:Stop()
    end
    local actionName = "ronghe_2"
    self:PlayUIEffectAction(actionName, true, function(obj, args, assetEffect)
      self.foreEffect = assetEffect
    end)
    if self.backEffect then
      self.backEffect:ResetAction(actionName, 0, true)
    end
    delayedTime = 4000
    tickManager:CreateOnceDelayTick(delayedTime, self.SendComposeMessage, self, 1)
  end
  self:SetComposeBtnActive(false)
  tickManager:CreateOnceDelayTick(delayedTime + 800, self.CheckComposeReady, self, 2)
end

function GemComposeView:SendComposeMessage()
  local data = self.curMultiComposeGO.activeSelf and self.multiComposeMaterialData or self.selectedMaterialData
  if self.mode == GemComposeViewMode.SameName then
    GemProxy.CallSkillSameNameCompose(data)
  elseif self.mode == GemComposeViewMode.RandomProf then
    GemProxy.CallSkill3to1Compose(data)
  elseif self.mode == GemComposeViewMode.CurrentProf then
    GemProxy.CallSkill5to1Compose(data)
  end
  self.isComposing = nil
end

function GemComposeView:CheckZeny()
  return MyselfProxy.Instance:GetROB() >= (self.cost or math.huge)
end

function GemComposeView:CheckComposeReady()
  local isReady, rowCount = false
  if self.curMultiComposeGO.activeSelf then
    local multiComposeListCells = self.curMultiComposeListCtrl:GetCells()
    for _, cell in pairs(multiComposeListCells) do
      rowCount = rowCount or 0
      if cell:GetCheckTipEnabled() then
        rowCount = rowCount + 1
      end
    end
    if rowCount and 0 < rowCount then
      isReady = true
    end
  else
    isReady = #self.selectedMaterialData == self.maxMaterialCount
    if isReady and self.mode == GemComposeViewMode.SameName then
      for i = 2, #self.selectedMaterialData do
        isReady = isReady and GemProxy.CheckIsSameName(self.selectedMaterialData[i], self.selectedMaterialData[1])
      end
    end
  end
  self:UpdateMainLabel(isReady)
  self:SetComposeBtnActive(isReady)
  rowCount = rowCount or isReady and 1 or 0
  self:SetCost(GemComposeViewModeCostZeny[self.mode] * rowCount)
end

function GemComposeView:UpdateMainLabel(isReady)
  if not isReady then
    self.mainLabel.text = ""
    return
  end
  if self.curMultiComposeGO.activeSelf then
    return
  end
  if self.mode == GemComposeViewMode.SameName then
    self.mainLabel.text = self.selectedMaterialData[1] and self.selectedMaterialData[1]:GetName()
  elseif self.mode == GemComposeViewMode.RandomProf then
    local quality, weight = GemProxy.GetMaxQualityWeightOf3to1Compose(self.selectedMaterialData)
    self.mainLabel.text = quality and weight and string.format(ZhString.Gem_QualityComposeTip, quality, weight) or ""
  elseif self.mode == GemComposeViewMode.CurrentProf then
    local quality, weight = GemProxy.GetMaxQualityWeightOf5to1Compose(self.selectedMaterialData)
    self.mainLabel.text = quality and weight and string.format(ZhString.Gem_QualityComposeTip, quality, weight) or ""
  end
end

function GemComposeView:PlayUIEffectAction(actionName, once, callback, callbackArgs)
  self:PlayUIEffect(self.effectName, self.effectContainer, once, function(obj, args, assetEffect)
    if obj ~= nil and actionName then
      assetEffect:ResetAction(actionName, 0, true)
      if callback then
        callback(obj, args, assetEffect)
      end
    end
  end, callbackArgs)
end

function GemComposeView:ShowGemTip(cellGO, data)
  local tip = GemCell.ShowGemTip(cellGO, data, self.normalStick)
  if not tip then
    return
  end
  tip:AddIgnoreBounds(self.itemContainer)
end

function GemComposeView:ReUnitMultiComposeData()
  TableUtility.TableClear(tempTable)
  for i = 1, GemProxy.MultiComposeRowCount do
    for j = 1, self.maxMaterialCount do
      tempTable[i] = tempTable[i] or {}
      tempTable[i][j] = self.multiComposeMaterialData[self.maxMaterialCount * (i - 1) + j] or BagItemEmptyType.Empty
    end
  end
  return tempTable
end

function GemComposeView:SetComposeBtnActive(isActive)
  isActive = isActive and true or false
  self.isComposeBtnActive = isActive
  self.composeBtnBgSp.spriteName = isActive and "com_btn_1" or "com_btn_13"
  self.composeBtnLabel.effectColor = isActive and ColorUtil.ButtonLabelBlue or ColorUtil.NGUIGray
end

function GemComposeView:GetMultiComposeCell(index)
  index = index or 0
  local row, col = GemProxy.GetRowAndColFromIndexAndColumnCount(index, self.maxMaterialCount)
  local combineCells = self.curMultiComposeListCtrl:GetCells()
  if combineCells and combineCells[row] then
    return combineCells[row]:GetCell(col)
  end
end

function GemComposeView:SetMultiComposeCellChoose(newIndex)
  if not self.curMultiComposeGO.activeSelf then
    return
  end
  self.chooseMultiComposeCellIndex = newIndex
  local newChooseCell = self:GetMultiComposeCell(self.chooseMultiComposeCellIndex)
  if newChooseCell then
    newChooseCell.chooseSymbol:SetActive(true)
  else
    self.chooseMultiComposeCellIndex = nil
  end
end

function GemComposeView:SetMultiComposeCellChooseToFirstEmpty()
  if not self.curMultiComposeGO.activeSelf then
    return
  end
  local newIndex
  for i = 1, self:GetMaxMultiComposeCellCount() do
    if not self.multiComposeMaterialData[i] then
      newIndex = i
      break
    end
  end
  if newIndex then
    local row, col = GemProxy.GetRowAndColFromIndexAndColumnCount(newIndex, self.maxMaterialCount)
    self.multiComposeScrollView:SetDragAmount(0, math.clamp((row - 3) / (GemProxy.MultiComposeRowCount - 3), 0, 1), false)
  end
  self:SetMultiComposeCellChoose(newIndex)
end

function GemComposeView:GetCheckTipEnablePredicate()
  return self.mode == GemComposeViewMode.SameName and GemProxy.CheckComposeDataGroupIsSameName or GemProxy.CheckComposeDataGroup
end

function GemComposeView:GetMaxMultiComposeCellCount()
  return GemProxy.GetMaxMultiFunctionCellCount(self.maxMaterialCount)
end
