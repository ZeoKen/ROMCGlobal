autoImport("WrapListCtrl")
autoImport("GemCell")
autoImport("GemCombineCell")
autoImport("GemExhibitChooseCell")
autoImport("ItemTipGemExhibitCell")
autoImport("GemUpdateAttrCell")
autoImport("GemDecomposeRewardCell")
GemFunctionPage = class("GemFunctionPage", SubView)
GemFunctionState = {
  SameName = 0,
  RandomProf = 1,
  CurrentProf = 2,
  Sculpt = 3,
  Smelt = 4,
  UpdateAttr = 5,
  Decompose = 6
}
local Gem_ShopId, Gem_ShopType = 1, 3248
local GemFunctionState = GemFunctionState
local NoEffectGemState = {
  [GemFunctionState.Decompose] = 1,
  [GemFunctionState.UpdateAttr] = 1
}
local containEmbeddedGemState = {
  [GemFunctionState.Sculpt] = 1,
  [GemFunctionState.UpdateAttr] = 1
}
local Entrance_State = {
  Gem = {
    SameName = GemFunctionState.SameName,
    UpdateAttr = GemFunctionState.UpdateAttr,
    Decompose = GemFunctionState.Decompose,
    Smelt = GemFunctionState.Smelt
  },
  Npc = {
    RandomProf = GemFunctionState.RandomProf,
    CurrentProf = GemFunctionState.CurrentProf,
    Sculpt = GemFunctionState.Sculpt
  }
}
local _GetEntranceState = function(from_npc)
  return from_npc and Entrance_State.Npc or Entrance_State.Gem
end
local _GetEntranceDefaultState = function(from_npc)
  return from_npc and GemFunctionState.RandomProf or GemFunctionState.UpdateAttr
end
local GemFunctionTitle = {
  [GemFunctionState.RandomProf] = Table_NpcFunction[10026].NameZh,
  [GemFunctionState.CurrentProf] = Table_NpcFunction[10027].NameZh,
  [GemFunctionState.SameName] = Table_NpcFunction[10028].NameZh,
  [GemFunctionState.Sculpt] = Table_NpcFunction[10033].NameZh,
  [GemFunctionState.Smelt] = Table_NpcFunction[10037].NameZh,
  [GemFunctionState.UpdateAttr] = ZhString.Gem_UpdateAttr,
  [GemFunctionState.Decompose] = ZhString.Gem_Decompose
}
GemFunctionHelpId = {
  [GemFunctionState.RandomProf] = 1003,
  [GemFunctionState.CurrentProf] = 1004,
  [GemFunctionState.SameName] = 1005,
  [GemFunctionState.Sculpt] = 1009,
  [GemFunctionState.Smelt] = 1010,
  [GemFunctionState.UpdateAttr] = 1012
}
local GemFunctionCostZeny = {
  [GemFunctionState.RandomProf] = GameConfig.Gem.ThreeCostZeny,
  [GemFunctionState.CurrentProf] = GameConfig.Gem.FiveCostZeny,
  [GemFunctionState.SameName] = GameConfig.Gem.SameNameCost,
  [GemFunctionState.Smelt] = GameConfig.Gem.SmeltCostZeny
}
local GemFunctionMainLabel = {
  [GemFunctionState.RandomProf] = ZhString.Gem_Compose3to1Tip,
  [GemFunctionState.CurrentProf] = ZhString.Gem_Compose5to1Tip,
  [GemFunctionState.SameName] = ZhString.Gem_ComposeSameNameTip,
  [GemFunctionState.Sculpt] = ZhString.Gem_SculptMainTip,
  [GemFunctionState.Smelt] = ZhString.Gem_SmeltTipWithoutTarget,
  [GemFunctionState.Decompose] = ZhString.Gem_DecomposeNoTargetCellTip,
  [GemFunctionState.UpdateAttr] = ZhString.Gem_UpdateAttrNoTargetCellTip
}
local GemFunctionCtrl = {
  TargetSelect = {
    [GemFunctionState.Smelt] = true
  },
  MaterialSelect = {
    [GemFunctionState.RandomProf] = true,
    [GemFunctionState.CurrentProf] = true,
    [GemFunctionState.SameName] = true,
    [GemFunctionState.Sculpt] = true,
    [GemFunctionState.Decompose] = true,
    [GemFunctionState.UpdateAttr] = true
  },
  ComposeCtrl = {
    [GemFunctionState.RandomProf] = true,
    [GemFunctionState.CurrentProf] = true,
    [GemFunctionState.SameName] = true
  },
  SculptCtrl = {
    [GemFunctionState.Sculpt] = true
  },
  SmeltCtrl = {
    [GemFunctionState.Smelt] = true
  },
  DecomposeCtrl = {
    [GemFunctionState.Decompose] = true
  },
  UpdateAttrCtrl = {
    [GemFunctionState.UpdateAttr] = true
  }
}
local tempTable, gemProxyIns, tickManager = {}
local smeltQualitiesToShow = {3, 4}
local _UpdateAttrQualities = {3, 4}
local _BtnSprite = {
  Yellow = "com_btn_2",
  Blue = "com_btn_1",
  Grey = "com_btn_13"
}
local multiComposeClickDisablePredicate = function(gemCell, self)
  if GemProxy.CheckIsFavorite(gemCell.data) and self.pageState ~= GemFunctionState.UpdateAttr then
    return true
  end
  if gemCell.selectedCount > 0 then
    return false
  end
  local flag
  if self.pageState == GemFunctionState.UpdateAttr then
    local quality = GemProxy.GetSkillQualityFromItemData(gemCell.data)
    if quality == 1 or quality == 2 then
      flag = true
    end
  elseif self.pageState ~= GemFunctionState.SameName then
    local _, compareData = next(self.multiFunctionMaterialData)
    flag = gemCell.data and compareData and gemProxyIns:GetSkillQualityGroupFromItemData(gemCell.data) ~= gemProxyIns:GetSkillQualityGroupFromItemData(compareData)
    if self.pageState == GemFunctionState.CurrentProf and not flag and self.targetProfession and ProfessionProxy.IsHero(self.targetProfession) then
      local quality = GemProxy.GetSkillQualityFromItemData(gemCell.data)
      if quality == 1 or quality == 2 then
        flag = true
      end
    end
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
  if self.pageState == GemFunctionState.SameName then
    flag = gemCell.data and gemCell.selectedCount == 0 and 0 < #self.selectedMaterialData and gemCell.data.staticData.id ~= self.selectedMaterialData[1].staticData.id
  else
    flag = gemCell.data and 0 < #self.selectedMaterialData and gemProxyIns:GetSkillQualityGroupFromItemData(gemCell.data) ~= gemProxyIns:GetSkillQualityGroupFromItemData(self.selectedMaterialData[1])
    if self.pageState == GemFunctionState.CurrentProf and not flag and self.targetProfession and ProfessionProxy.IsHero(self.targetProfession) then
      local quality = GemProxy.GetSkillQualityFromItemData(gemCell.data)
      if quality == 1 or quality == 2 then
        flag = true
      end
    end
  end
  return flag
end
local smeltClickDisablePredicate = function(gemCell, self)
  if GemProxy.CheckIsFavorite(gemCell.data) then
    return true
  end
  if gemCell.selectedCount > 0 then
    return false
  end
  local isDifferentGroup = gemCell.data and self.targetGemStaticId and gemProxyIns:GetSkillQualityGroupFromItemData(gemCell.data) ~= gemProxyIns:GetSkillQualityGroupByStaticId(self.targetGemStaticId)
  return isDifferentGroup
end

function GemFunctionPage:Init(npc_entrance)
  self.entrances = _GetEntranceState(npc_entrance)
  if not gemProxyIns then
    gemProxyIns = GemProxy.Instance
  end
  if not tickManager then
    tickManager = TimeTickManager.Me()
  end
  self:ReLoadPerferb("view/GemFunctionPage")
  self.trans:SetParent(self.container.pageContainer.transform, false)
  self:AddEvents()
  self:InitData()
  self:InitTabs()
  self:InitRight()
  self:InitLeft()
  self.pageState = _GetEntranceDefaultState(npc_entrance)
  self:ResetQualityFilterByPageState()
end

function GemFunctionPage:AddEvents()
  self:AddDispatcherEvt(MyselfEvent.ZenyChange, self.UpdateCostLabelColor)
  self:AddDispatcherEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddDispatcherEvt(ItemEvent.GemDataUpdate, self.OnGemDataUpdate)
  self:AddDispatcherEvt(GemEvent.ProfessionChanged, self.OnProfessionChanged)
  self:AddDispatcherEvt(GemEvent.ChooseTargetProfession, self.OnChooseTargetProfession)
  self:AddDispatcherEvt(ItemEvent.GemUpdate, self.OnGemUpdate)
end

function GemFunctionPage:OnProfessionChanged()
  self:ResetDecompose()
  self.curSkillProfessionFilterPopData = GemProxy.Instance:GetCurNewProfessionFilterData()
  local curProfressionName = GemProxy.Instance:GetCurProfressionName()
  if self.TargetSelect.activeInHierarchy then
    self.professionFilterLab.text = curProfressionName
    self:UpdateTargetSelectList()
  elseif self.MaterialSelect.activeInHierarchy then
    self.curProfessionFilterLab.text = curProfressionName
    self:UpdateMaterialSelectList()
  end
  self:SwitchMultiFunction(self.isMultiActive)
end

function GemFunctionPage:OnChooseTargetProfession(classId)
  self.targetProfession = classId
  local className = ProfessionProxy.GetProfessionName(self.targetProfession, MyselfProxy.Instance:GetMySex())
  self.targetProfessionLab.text = ZhString.Gem_FixedTargetPro .. " " .. "[c][000000]" .. className .. "[-][/c]"
  self.targetProfessionBg.width = 100 + self.targetProfessionLab.width
  local skillConfig = Table_Class[self.targetProfession]
  IconManager:SetProfessionIcon(skillConfig.icon, self.targetProfessionIcon)
  self:SwitchMultiFunction(self.isMultiActive)
  self:ResetDecompose()
end

function GemFunctionPage:InitData()
  self.doFunc = {}
  self.curSkillProfessionFilterPopData = {}
  self.selectedMaterialData = {}
  self.multiFunctionMaterialData = {}
  self.sculptCostConfig = GameConfig.Gem.CarveCost[1]
  local funcStateId, param, index = GemProxy.BannedQualityFuncStateId
  if FunctionNpcFunc.Me():CheckSingleFuncForbidState(funcStateId) then
    param = Table_FuncState[funcStateId] and Table_FuncState[funcStateId].Param
    if param then
      for i = 1, #param do
        index = TableUtility.ArrayFindIndex(smeltQualitiesToShow, param[i])
        if 0 < index then
          table.remove(smeltQualitiesToShow, index)
        end
      end
    end
  end
end

function GemFunctionPage:InitTabs()
  self.tabGOs = {}
  self.tabIconSps = {}
  self.funcTabGrid = self:FindComponent("FuncBtnTabs", UIGrid)
  local tabGO, longPress
  for name, state in pairs(GemFunctionState) do
    tabGO = self:FindGO(name .. "Tab", self.funcTabGrid.gameObject)
    if tabGO then
      tabGO:SetActive(nil ~= self.entrances[name])
      self:AddClickEvent(tabGO, function(go)
        self:UpdatePageState(state)
      end)
      self.tabGOs[state] = tabGO
      self.tabIconSps[state] = self:FindComponent("Icon", UISprite, tabGO)
      longPress = tabGO:GetComponent(UILongPress)
      
      function longPress.pressEvent(obj, pressState)
        self:PassEvent(TipLongPressEvent.GemFunctionPage, {pressState, state})
      end
    end
    self.doFunc[state] = self[name]
  end
  self.funcTabGrid:Reposition()
  self:AddEventListener(TipLongPressEvent.GemFunctionPage, self.OnTabLongPress, self)
end

local skipAnimTipOffset = {90, -75}

function GemFunctionPage:InitRight()
  self.gemShopBtn = self:FindGO("GemShopBtn")
  self:AddClickEvent(self.gemShopBtn, function()
    HappyShopProxy.Instance:InitShop(nil, Gem_ShopId, Gem_ShopType)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.HappyShop
    })
  end)
  self.helpBtn = self:FindGO("HelpBtn")
  self.skipBtnSp = self:FindComponent("SkipBtn", UISprite)
  self:AddClickEvent(self.skipBtnSp.gameObject, function()
    TipManager.Instance:ShowSkipAnimationTip(SKIPTYPE.GemFunction, self.skipBtnSp, NGUIUtil.AnchorSide.Right, skipAnimTipOffset)
  end)
  self.autoSelectLab = self:FindComponent("AutoSelect", UILabel)
  self.autoSelectLab.text = ZhString.Gem_QuickSelect
  self:AddClickEvent(self.autoSelectLab.gameObject, function()
    self:AutoChooseGem()
  end)
  self.decomposeAllLab = self:FindComponent("DecomposeAllLab", UILabel)
  self.decomposeAllLab.text = ZhString.Gem_AllAdd
  self.decomposeAllToggle = self:FindComponent("DecomposeAllToggle", UIToggle)
  EventDelegate.Add(self.decomposeAllToggle.onChange, function()
    self:OnClickDecomposeAll()
  end)
  self.titleLabel = self:FindComponent("TitleLabel", UILabel)
  self.effectContainer = self:FindGO("EffectContainer")
  self.needGemSps = {}
  local needGemGO
  for i = 1, 3 do
    needGemGO = self:FindGO("NeedGem" .. i)
    self.needGemSps[i] = self:FindComponent("IconSprite", UISprite, needGemGO)
    self:AddClickEvent(needGemGO, function()
      self:OnClickNeedGem(i)
    end)
  end
  self:InitDecompose()
  self:InitUpdateAttr()
end

function GemFunctionPage:InitLeft()
  self:InitMaterialSelect()
  self:InitTargetSelect()
  self.normalStick = self:FindComponent("NormalStick", UIWidget)
end

function GemFunctionPage:InitSkillQualityFilter()
  local obsoleteSkillClassFilterPopObj = self:FindGO("SkillClassFilterPop")
  if obsoleteSkillClassFilterPopObj then
    self:Hide(obsoleteSkillClassFilterPopObj)
  end
  self.curSkillClassFilterPopData = 0
  local qualityTabRoot = self:FindGO("FunctionSkillQualityTabRoot")
  self:Show(qualityTabRoot)
  for togName, tableData in pairs(GemProxy.QualityTogs) do
    self[togName] = self:FindComponent(togName, UIToggle, qualityTabRoot)
    self[togName .. "lab1"] = self:FindComponent("Label1", UILabel, self[togName].gameObject)
    self[togName .. "lab1"].text = tableData.value
    self[togName .. "lab2"] = self:FindComponent("Label2", UILabel, self[togName].gameObject)
    self[togName .. "lab2"].text = tableData.value
    self:AddClickEvent(self[togName].gameObject, function()
      local key = GemProxy.QualityTogs[togName].key
      if self.curSkillClassFilterPopData == key then
        return
      end
      self:ResetDecompose()
      if key == 0 then
        self.curSkillClassFilterPopData = self.pageState == GemFunctionState.UpdateAttr and _UpdateAttrQualities or 0
      else
        self.curSkillClassFilterPopData = key
      end
      self:UpdateMaterialSelectList()
      self:UpdateProfSelectCells()
      self:UpdateAutoSelect()
    end)
  end
end

function GemFunctionPage:UpdateProfSelectCells()
  if self.pageState == GemFunctionState.RandomProf or self.pageState == GemFunctionState.CurrentProf and self.materialSelectCells then
    local selectedReference = self.isMultiActive and self.multiFunctionMaterialData or self.selectedMaterialData
    local clickDisablePredicate = self.isMultiActive and multiComposeClickDisablePredicate or singleComposeClickDisablePredicate
    for _, cell in pairs(self.materialSelectCells) do
      cell:SetShowDeleteIcon(true)
      cell:SetMultiSelectStyle(GemCell.MultiSelectStyle.HideSelectedCount)
      cell:SetMultiSelectModel(selectedReference)
      cell:SetClickDisablePredicate(clickDisablePredicate, self)
      cell:UpdateDeleteIcon()
    end
  end
end

function GemFunctionPage:UpdateAutoSelect()
  local hasDatas = #self.materialSelectCtrl:GetDatas() > 0
  local showOnRandom = self.pageState == GemFunctionState.RandomProf and self.curSkillClassFilterPopData ~= 0 and hasDatas
  local showOnDecompose = self.pageState == GemFunctionState.Decompose and hasDatas
  self.autoSelectLab.gameObject:SetActive(showOnRandom)
end

function GemFunctionPage:InitProfessionFilter()
  local obsoleteSkillProfessionFilterPop = self:FindGO("SkillProfessionFilterPop")
  if obsoleteSkillProfessionFilterPop then
    self:Hide(obsoleteSkillProfessionFilterPop)
  end
  self.professionTipStick = self:FindComponent("FunctionProfessionTipStick", UIWidget)
  self.curProfessionFilterLab = self:FindComponent("FunctionCurProfessionFilterLab", UILabel)
  self:AddClickEvent(self.curProfessionFilterLab.gameObject, function()
    TipManager.Instance:SetGemProfessionTip(NewGemSkillProfessionData, self.professionTipStick)
  end)
end

function GemFunctionPage:InitMaterialSelect()
  self:InitSkillQualityFilter()
  self:InitProfessionFilter()
  self.materialFilterParent = self:FindGO("FilterCtrl", self.MaterialSelect)
  self.materialContainer = self:FindGO("ItemContainer", self.MaterialSelect)
  self.materialSelectCtrl = WrapListCtrl.new(self.materialContainer, GemCell, "GemCell", WrapListCtrl_Dir.Vertical, 5, 100, true)
  self.materialSelectCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickMaterialSelectCell, self)
  self.materialSelectCtrl:AddEventListener(MouseEvent.LongPress, self.OnLongPressMaterialSelectCell, self)
  self.materialSelectCtrl:AddEventListener(ItemEvent.GemDelete, self.OnGemDelete, self)
  self.materialSelectCells = self.materialSelectCtrl:GetCells()
  for _, cell in pairs(self.materialSelectCells) do
    cell:SetShowDeleteIcon(true)
    cell:SetMultiSelectStyle(GemCell.MultiSelectStyle.HideSelectedCount)
  end
end

function GemFunctionPage:InitUpdateAttr()
  self.updateAttrTitle = self:FindComponent("UpdateAttrTitle", UILabel)
  self.updateAttrTitle.text = ZhString.Gem_UpdateAttr
  self.fixedCostLabel = self:FindComponent("FixedCostLabel", UILabel)
  self.fixedCostLabel.text = ZhString.GemUpdateAttr_Cost
  self.updateAttrIsStarLab = self:FindComponent("UpdateAttrIsStar", UILabel)
  self.updateAttrIsStarLab.text = ZhString.GemUpdateAttr_IsStar
  self.updateAttrCostItemRoot = self:FindGO("UpdateAttrCostItemRoot")
  self.updateAttrScrollView = self:FindComponent("UpdateAttrScrollView", UIScrollView)
  self.updateAttrTable = self:FindComponent("UpdateAttrTable", UITable, self.updateAttrScrollView.gameObject)
  self.updateAttrCtl = UIGridListCtrl.new(self.updateAttrTable, GemUpdateAttrCell, "GemUpdateAttrCell")
  self.updateAttrCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickUpdateAttrCell, self)
  self.updateAttrBg = self:FindGO("UpdateAttrBg")
  self:Hide(self.updateAttrBg)
  self.updateAttrCostRoot = self:FindGO("UpdateAttrCostRoot")
  self.updateAttrTip = self:FindComponent("UpdateAttrTip", UILabel)
  self.updateAttrTip.text = ZhString.GemUpdateAttr_Tip
end

function GemFunctionPage:OnClickUpdateAttrCell(cell)
  local data = cell and cell.data
  if not data then
    return
  end
  if self.curUpdateAttrCell then
    self.curUpdateAttrCell:SetSelected(false)
  end
  self.curUpdateAttrCell = cell
  self.curUpdateAttrCell:SetSelected(true)
  self:UpdateCurrentAttrTip()
end

function GemFunctionPage:InitDecompose()
  self.decomposeSelectMaterials = {}
  self.decomposeSelectMaterialCount = 0
  self.decomposeTitle = self:FindComponent("DecomposeTitleLab", UILabel)
  self.decomposeTitle.text = ZhString.Gem_DecomposeTitle
  self.decomposeCostIcon = self:FindComponent("DecomposeCostIcon", UISprite)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.decomposeCostIcon)
  self.decomposeCost = self:FindComponent("DecomposeCostLab", UILabel)
  self.decomposeCostLab = self:FindComponent("DecomposeFixedCostLab", UILabel)
  self.decomposeCostLab.text = ZhString.GemDecompose_Cost
  self.decomposeMaterialContainer = self:FindGO("DecomposeMaterialContainer")
  self.decomposeMaterialCtrl = WrapListCtrl.new(self.decomposeMaterialContainer, GemCell, "GemCell", WrapListCtrl_Dir.Vertical, 5, 100, true)
  self.decomposeMaterialCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickDecomposeMaterialCell, self)
  self.decomposeMaterialCtrl:AddEventListener(ItemEvent.GemDelete, self.OnClickDecomposeMaterialCell, self)
  local decomposeRewardGrid = self:FindComponent("DecomposeRewardGrid", UIGrid)
  self.decomposeRewardList = UIGridListCtrl.new(decomposeRewardGrid, GemDecomposeRewardCell, "GemDecomposeRewardCell")
  self.emptyRewardBg = self:FindGO("EmptyRewardBg")
end

function GemFunctionPage:OnClickDecomposeMaterialCell(cell)
  self:DelItemToDecompose(cell.data)
end

function GemFunctionPage:InitTargetProfessionFilter()
  local targetProfessionFilterPop = self:FindGO("TargetProfessionFilterPop")
  if targetProfessionFilterPop then
    self:Hide(targetProfessionFilterPop)
  end
  self.targetProfessionTipStick = self:FindComponent("ProfessionTipStick", UIWidget)
  self.professionFilterLab = self:FindComponent("ProfessionFilterLab", UILabel)
  self:AddClickEvent(self.professionFilterLab.gameObject, function()
    TipManager.Instance:SetGemProfessionTip(NewGemSkillProfessionData, self.targetProfessionTipStick)
  end)
end

function GemFunctionPage:InitTargetSelect()
  self:InitTargetProfessionFilter()
  self.targetContainer = self:FindGO("TargetContainer", self.TargetSelect)
  self.targetSelectCtrl = WrapListCtrl.new(self.targetContainer, GemExhibitChooseCell, "GemExhibitChooseCell", WrapListCtrl_Dir.Vertical)
  self.targetSelectCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickExhibitChooseCell, self)
  self.targetSelectCtrl:AddEventListener(GemExhibitChooseCellEvent.ClickGem, self.OnClickExhibitChooseGem, self)
  self.targetSelectCells = self.targetSelectCtrl:GetCells()
  self.targetExhibitTip = ItemTipGemExhibitCell.new(self:FindGO("ExhibitTipContainer"))
  for _, cell in pairs(self.targetSelectCells) do
    self.targetExhibitTip:AddCloseCompTarget(cell)
  end
end

function GemFunctionPage:OnActivate()
  self.targetExhibitTip:SetActive(false)
  self:UpdatePage()
end

function GemFunctionPage:OnDeactivate()
  TipManager.CloseTip()
end

function GemFunctionPage:OnExit()
  tickManager:ClearTick(self)
  if self.curMaterialCombineCell then
    self.curMaterialCombineCell:OnCellDestroy()
  end
  GemFunctionPage.super.OnExit(self)
end

function GemFunctionPage:OnClickFakeGemCell()
  self.MaterialSelect:SetActive(false)
  self.TargetSelect:SetActive(true)
  self:UpdateTargetSelectList()
end

function GemFunctionPage:OnClickMaterialCell(cellCtl)
  if self.pageState == GemFunctionState.Smelt and not self.targetGemStaticId then
    MsgManager.FloatMsg(nil, ZhString.Gem_SmeltNoTargetCellTip)
    return
  end
  if self.isWorking then
    return
  end
  self.TargetSelect:SetActive(false)
  self.MaterialSelect:SetActive(true)
  local data = cellCtl.data
  TableUtility.ArrayRemoveByPredicate(self.selectedMaterialData, function(item)
    return BagItemCell.CheckData(data) and data.id == item.id
  end)
  self:UpdateSelectedMaterial()
  self:UpdateMaterialSelectList(true)
end

function GemFunctionPage:OnClickMultiFunctionCell(cellCtl)
  if self.pageState == GemFunctionState.Smelt and not self.targetGemStaticId then
    MsgManager.FloatMsg(nil, ZhString.Gem_SmeltNoTargetCellTip)
    return
  end
  if self.isWorking then
    return
  end
  self.TargetSelect:SetActive(false)
  self.MaterialSelect:SetActive(true)
  local index = cellCtl.indexInTable
  if index then
    self.multiFunctionMaterialData[index] = nil
  else
    LogUtility.Error("Cannot get indexInTable of GemCell")
    return
  end
  self.chooseMultiFunctionCellIndex = index
  self.multiFunctionMaterialData[index] = nil
  self:UpdateMultiFunctionMaterial()
  self:UpdateMaterialSelectList(true)
  cellCtl.chooseSymbol:SetActive(true)
end

function GemFunctionPage:OnClickExhibitChooseCell(cellCtl)
  local data = cellCtl and cellCtl.data
  self.TargetSelect:SetActive(false)
  self:SetItemToSmelt(data)
  self.targetExhibitTip:SetActive(false)
  self.MaterialSelect:SetActive(true)
  self:UpdateMaterialSelectList()
end

function GemFunctionPage:OnClickExhibitChooseGem(cellCtl)
  local data = cellCtl and cellCtl.data
  if not data then
    return
  end
  self.targetExhibitTip:SetActive(true)
  self.targetExhibitTip:SetData(data)
end

function GemFunctionPage:OnClickNeedGem(index)
  self.selectedSculpt = index
  self.chooseSymbol:SetActive(index ~= nil and 0 < index)
  if self.chooseSymbol.activeSelf then
    self.chooseSymbol.transform.position = LuaGeometry.GetTempVector3(LuaGameObject.GetPosition(self.needGemSps[index].transform))
  end
end

function GemFunctionPage:OnClickMaterialSelectCell(cellCtl)
  if self.isWorking then
    return
  end
  if self.isClickOnMaterialSelectCtrlDisabled then
    self.isClickOnMaterialSelectCtrlDisabled = nil
    return
  end
  if cellCtl:CheckDataIsNilOrEmpty() then
    return
  end
  local data = cellCtl and cellCtl.data
  for _, cell in pairs(self.materialSelectCells) do
    cell:SetChoose(data and data.id or 0)
  end
  self.curUpdateAttrCell = nil
  if self.pageState == GemFunctionState.Sculpt then
    self:SetItemToSculpt(data)
    TipManager.CloseTip()
  elseif self.pageState == GemFunctionState.Smelt then
    if data.staticData.id == self.targetGemStaticId then
      MsgManager.ConfirmMsgByID(36012, function()
        self:_OnClickMaterialSelectCell(cellCtl)
      end)
    else
      self:_OnClickMaterialSelectCell(cellCtl)
    end
  elseif self.pageState == GemFunctionState.Decompose then
    self:SetItemToDecompose(data)
  elseif self.pageState == GemFunctionState.UpdateAttr then
    self:SetItemToUpdateAttr(data)
  else
    self:_OnClickMaterialSelectCell(cellCtl)
  end
  cellCtl:TryClearNewTag()
end

function GemFunctionPage:_OnClickMaterialSelectCell(cellCtl)
  local data = cellCtl and cellCtl.data
  if data.num > cellCtl.selectedCount then
    local cloneData = data:Clone()
    cloneData:SetItemNum(1)
    cloneData.gemSkillData = data.gemSkillData
    if self.curMultiFunctionGO and self.curMultiFunctionGO.activeSelf and self.chooseMultiFunctionCellIndex then
      self.multiFunctionMaterialData[self.chooseMultiFunctionCellIndex] = cloneData
      self:UpdateMultiFunctionMaterial()
      self:SetMultiFunctionCellChooseToFirstEmpty()
      self:UpdateMaterialSelectList(true)
    elseif #self.selectedMaterialData < self.maxMaterialCount then
      TableUtility.ArrayPushBack(self.selectedMaterialData, cloneData)
      self:UpdateSelectedMaterial()
      self:UpdateMaterialSelectList(true)
    end
  end
end

function GemFunctionPage:_OnClickMaterialSelectCell_NewState(cellCtl)
  local data = cellCtl and cellCtl.data
  if data.num > cellCtl.selectedCount then
    local cloneData = data:Clone()
    cloneData:SetItemNum(1)
    cloneData.gemSkillData = data.gemSkillData
    if #self.selectedMaterialData < self.maxMaterialCount then
      TableUtility.ArrayPushBack(self.selectedMaterialData, cloneData)
      self:UpdateSelectedMaterial()
      self:UpdateMaterialSelectList(true)
    end
  end
end

function GemFunctionPage:OnLongPressMaterialSelectCell(param)
  local isPressing, cellCtl = param[1], param[2]
  if isPressing and cellCtl then
    self:ShowGemTip(cellCtl.gameObject, cellCtl.data)
    self.isClickOnMaterialSelectCtrlDisabled = true
  end
end

function GemFunctionPage:OnTabLongPress(param)
  local isPressing, state = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, GemFunctionTitle[state], false, self.tabIconSps[state])
end

function GemFunctionPage:OnGemDelete(cellCtl)
  if self.curMultiFunctionGO and self.curMultiFunctionGO.activeSelf then
    TableUtility.TableRemoveByPredicate(self.multiFunctionMaterialData, function(index, item)
      return not cellCtl:CheckDataIsNilOrEmpty() and cellCtl.data.id == item.id
    end)
    self:UpdateMultiFunctionMaterial()
    if self.chooseMultiFunctionCellIndex then
      self:SetMultiFunctionCellChoose(self.chooseMultiFunctionCellIndex)
    else
      self:SetMultiFunctionCellChooseToFirstEmpty()
    end
    self:UpdateMaterialSelectList(true)
  else
    self:OnClickMaterialCell(cellCtl)
  end
end

function GemFunctionPage:OnGemUpdate()
  if not self.gameObject.activeInHierarchy then
    return
  end
  if self.pageState == GemFunctionState.Sculpt then
    TipManager.CloseTip()
    self:UpdateMaterialSelectList(true)
    if self.targetCell.data then
      local guid = self.targetCell.data.id
      local newTarget = BagProxy.Instance:GetItemByGuid(guid, SceneItem_pb.EPACKTYPE_GEM_SKILL)
      self:SetItemToSculpt(newTarget)
    end
    return
  end
  if self.curMultiFunctionGO and self.curMultiFunctionGO.activeSelf then
    local data, realData, index, isArranged
    for i = 1, self:GetMaxMultiFunctionCellCount() do
      data = self.multiFunctionMaterialData[i]
      if data then
        realData = BagProxy.Instance:GetItemByGuid(data.id, SceneItem_pb.EPACKTYPE_GEM_SKILL)
        if not realData or GemProxy.CheckIsFavorite(realData) then
          self.multiFunctionMaterialData[i] = nil
        end
      end
    end
    TableUtility.TableClear(tempTable)
    for i = 1, self:GetMaxMultiFunctionCellCount() do
      data = self.multiFunctionMaterialData[i]
      if data then
        TableUtility.ArrayPushBack(tempTable, data)
      end
    end
    TableUtility.TableClear(self.multiFunctionMaterialData)
    if self.pageState == GemFunctionState.SameName then
      local arrangedRowCount = 0
      for i = 1, #tempTable do
        data = tempTable[i]
        isArranged = false
        for j = 1, arrangedRowCount do
          if GemProxy.CheckIsSameName(data, self.multiFunctionMaterialData[self.maxMaterialCount * (j - 1) + 1]) then
            for k = 2, self.maxMaterialCount do
              index = self.maxMaterialCount * (j - 1) + k
              if not self.multiFunctionMaterialData[index] then
                self.multiFunctionMaterialData[index] = data
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
            self.multiFunctionMaterialData[self.maxMaterialCount * arrangedRowCount + 1] = data
            arrangedRowCount = arrangedRowCount + 1
          else
            break
          end
        end
      end
    else
      TableUtility.ArrayShallowCopy(self.multiFunctionMaterialData, tempTable)
    end
    self:UpdateMultiFunctionMaterial()
    self:SetMultiFunctionCellChooseToFirstEmpty()
  else
    TableUtility.ArrayClear(self.selectedMaterialData)
    self:UpdateSelectedMaterial()
  end
  self:UpdateMaterialSelectList()
  if self.pageState == GemFunctionState.UpdateAttr or self.pageState == GemFunctionState.Decompose then
    self:UpdatePage()
  end
end

function GemFunctionPage:OnItemUpdate()
  if not self.gameObject.activeInHierarchy then
    return
  end
  self:UpdateSculptCost()
  self:UpdateCurrentAttrTip()
end

function GemFunctionPage:OnGemDataUpdate(server_items)
  if not self.gameObject.activeInHierarchy then
    return
  end
  TipManager.CloseTip()
  self.targetExhibitTip:SetActive(false)
  gemProxyIns:ShowNewGemResults(server_items)
end

function GemFunctionPage:UpdatePage()
  if not self.pageState then
    return
  end
  TableUtility.TableClear(self.selectedMaterialData)
  TableUtility.TableClear(self.multiFunctionMaterialData)
  local title_str = GemFunctionTitle[self.pageState]
  if title_str and nil == NoEffectGemState[self.pageState] then
    self:Show(self.titleLabel)
    self.titleLabel.text = title_str
  else
    self:Hide(self.titleLabel)
  end
  self.helpId = GemFunctionHelpId[self.pageState]
  if self.helpId then
    self:Show(self.helpBtn)
    self:TryOpenHelpViewById(self.helpId, nil, self.helpBtn)
  else
    self:Hide(self.helpBtn)
  end
  self.materialFilterParent:SetActive(self.pageState ~= GemFunctionState.Smelt)
  self:SetCurrentTabIconColor()
  local _find = string.find
  for name, state_cfg in pairs(GemFunctionCtrl) do
    self[name] = self[name] or self:FindGO(name)
    if state_cfg[self.pageState] then
      self[name]:SetActive(true)
      if _find(name, "Ctrl") then
        self.curCtrl = self[name]
      end
    else
      self[name]:SetActive(false)
    end
  end
  self:UpdateAutoSelect()
  self.mainLabel = self:FindComponent("MainLabel", UILabel, self.curCtrl)
  self.mainLabel.text = GemFunctionMainLabel[self.pageState]
  self.costGO = self:FindGO("Cost", self.curCtrl)
  self.costLabel = self:FindComponent("CostLabel", UILabel, self.costGO)
  if self.costGO and GemFunctionCostZeny[self.pageState] then
    self.smeltCostIcon = self:FindComponent("Sprite", UISprite, self.costGO)
    IconManager:SetItemIcon(Table_Item[100].Icon, self.smeltCostIcon)
  end
  self.sculptWorkbench = self:FindGO("SculptWorkbench", self.curCtrl)
  self.chooseSymbol = self.sculptWorkbench and self:FindGO("ChooseSymbol", self.sculptWorkbench)
  self:SetFunctionBtnActive()
  self.curSkillProfessionFilterPopData = GemProxy.Instance:GetCurNewProfessionFilterData()
  local curProfressionName = GemProxy.Instance:GetCurProfressionName()
  if self.TargetSelect.activeInHierarchy then
    self.professionFilterLab.text = curProfressionName
    self:UpdateTargetSelectList()
  elseif self.MaterialSelect.activeInHierarchy then
    self.curProfessionFilterLab.text = curProfressionName
    self:UpdateMaterialSelectList()
  end
  self:ResetCurCtrl()
end

function GemFunctionPage:UpdatePageState(state)
  if not state or state == self.pageState then
    return
  end
  self.pageState = state
  self:ResetUpdateAttr()
  self:ResetQualityFilterByPageState()
  self:UpdatePage()
end

function GemFunctionPage:ResetUpdateAttr()
  if self.pageState == GemFunctionState.UpdateAttr then
    self.curUpdateAttrCell = nil
    self.curUpdateAttrItemData = nil
    TableUtility.TableClear(self.decomposeSelectMaterials)
    self.decomposeSelectMaterialCount = 0
    self:UpdateDecomposeSelectMaterials()
  end
end

function GemFunctionPage:ResetQualityFilterByPageState()
  if not self.pageState then
    return
  end
  if self.pageState == GemFunctionState.UpdateAttr then
    if self.curSkillClassFilterPopData == 0 or type(self.curSkillClassFilterPopData) == "number" and 0 == TableUtil.ArrayIndexOf(_UpdateAttrQualities, self.curSkillClassFilterPopData) then
      self.curSkillClassFilterPopData = _UpdateAttrQualities
      self.AllTab:Set(true)
    end
    self:Hide(self.ATab)
    self:Hide(self.BTab)
  else
    if self.curSkillClassFilterPopData == _UpdateAttrQualities then
      self.curSkillClassFilterPopData = 0
      self.AllTab:Set(true)
    end
    self:Show(self.ATab)
    self:Show(self.BTab)
  end
end

function GemFunctionPage:ResetCurCtrl()
  self:ResetTargetCell()
  self:ResetRightMaterialGO()
  self:UpdateEffect()
end

function GemFunctionPage:UpdateEffect()
  if nil ~= NoEffectGemState[self.pageState] then
    self:Hide(self.effectContainer)
    self:Hide(self.skipBtnSp)
    return
  end
  self:Show(self.skipBtnSp)
  self:Show(self.effectContainer)
  local exEffectName = self.effectName
  self.effectName = self.pageState == GemFunctionState.SameName and EffectMap.UI.GemViewReset or EffectMap.UI.GemViewSynthetic
  if exEffectName ~= self.effectName then
    if self.backEffect then
      self.backEffect:Stop()
    end
    if self.foreEffect then
      self.foreEffect:Stop()
    end
    self:PlayUIEffect(self.effectName, self.effectContainer, false, function(obj, args, assetEffect)
      self.backEffect = assetEffect
      self.backEffect:ResetAction("ronghe_1", 0, true)
    end)
  elseif self.backEffect then
    self.backEffect:ResetAction("ronghe_1", 0, true)
  end
end

function GemFunctionPage:ResetTargetCell()
  self.targetCellGO = self:FindGO("TargetCell", self.curCtrl)
  self.fakeGemCell = self:FindGO("FakeGemCell", self.curCtrl)
  if not self.targetCellGO then
    self.targetCell = nil
    return
  end
  if self.fakeGemCell then
    self.fakeGemCellBgSp = self:FindComponent("GemBg", UISprite, self.fakeGemCell)
    self.fakeGemCellSp = self:FindComponent("GemIcon", UISprite, self.fakeGemCell)
    self.fakeGemCellQualitySp = self:FindComponent("GemQuality", UISprite, self.fakeGemCell)
    self.fakeGemCellNameLabel = self:FindComponent("GemMicroNameLabel", UILabel, self.fakeGemCell)
    self:AddClickEvent(self.targetCellGO, function()
      self:OnClickFakeGemCell()
    end)
  else
    local c = self:FindGO("GemCell", self.targetCellGO)
    if not c then
      self:LoadPreferb_ByFullPath(ResourcePathHelper.UICell("GemCell"), self.targetCellGO)
    end
    self.targetCell = GemCell.new(self.targetCellGO)
    self.targetCell:SetData()
    self.targetCell:SetShowBagSlot(true)
    self.targetCell:SetShowNewTag(false)
    self.targetCell:SetShowEmbeddedTip(false)
  end
  self.gemLabel = self:FindComponent("GemLabel", UILabel, self.curCtrl)
end

function GemFunctionPage:ResetRightMaterialGO()
  local material3GO = self:FindGO("3Material", self.curCtrl)
  local material5GO = self:FindGO("5Material", self.curCtrl)
  self.material5GO_TargetRoot = self:FindGO("5ProfessionTargetRoot")
  self.targetProfessionLab = self:FindComponent("TargetProfessionLab", UILabel, self.material5GO_TargetRoot)
  self.targetProfessionBg = self:FindComponent("Bg", UISprite, self.targetProfessionLab.gameObject)
  self.targetProfessionIcon = self:FindComponent("TargetSkillIcon", UISprite, self.material5GO_TargetRoot)
  self.targetProfessionColider = self:FindComponent("TargetSkillIconColider", UISprite, self.material5GO_TargetRoot)
  self.targetProfessionStick = self:FindComponent("TargetProfessionTipStick", UIWidget)
  self:AddClickEvent(self.targetProfessionColider.gameObject, function()
    GemProxy.Instance:SetTargetProChooseFlag()
    TipManager.Instance:SetGemProfessionTip(NewGemSkillProfessionData, self.targetProfessionStick)
  end)
  local multiFunction3GO = self:FindGO("3MultiFunctionPanel", self.curCtrl)
  local multiFunction5GO = self:FindGO("5MultiFunctionPanel", self.curCtrl)
  if material3GO then
    material3GO:SetActive(false)
    multiFunction3GO:SetActive(false)
  end
  if material5GO then
    material5GO:SetActive(false)
    multiFunction5GO:SetActive(false)
  end
  local isCurrentProf = self.pageState == GemFunctionState.CurrentProf
  if isCurrentProf then
    self.curMaterialGO = material5GO
    self.targetProfession = GemProxy.Instance:GetMyFirstProfession()
    GemProxy.Instance:SetCurTargetProfession(self.targetProfession)
    if self.targetProfession then
      local className = ProfessionProxy.GetProfessionName(self.targetProfession, MyselfProxy.Instance:GetMySex())
      self.targetProfessionLab.text = ZhString.Gem_FixedTargetPro .. " " .. "[c][000000]" .. className .. "[-][/c]"
      local skillConfig = Table_Class[self.targetProfession]
      self:Show(self.targetProfessionIcon)
      IconManager:SetProfessionIcon(skillConfig.icon, self.targetProfessionIcon)
    else
      self:Hide(self.targetProfessionIcon)
      self.targetProfessionLab.text = ZhString.Gem_FixedTargetPro .. " " .. ZhString.GemTodoTargetProfession
    end
    self.targetProfessionBg.width = 100 + self.targetProfessionLab.width
    self.curMultiFunctionGO = multiFunction5GO
  else
    self.curMaterialGO = material3GO
    self.curMultiFunctionGO = multiFunction3GO
  end
  local curMaterialCellName = isCurrentProf and "GemCombine5Cell" or "GemCombine3Cell"
  self.maxMaterialCount = isCurrentProf and 5 or 3
  if self.curMaterialGO then
    local curMaterialCellObj = self:FindGO(curMaterialCellName, self.curMaterialGO)
    if curMaterialCellObj then
      GameObject.DestroyImmediate(curMaterialCellObj)
    end
    curMaterialCellObj = self:LoadPreferb("cell/" .. curMaterialCellName, self:FindGO("MaterialPanel", self.curMaterialGO))
    self.curMaterialCombineCell = _G[curMaterialCellName].new(curMaterialCellObj)
    self.curMaterialCombineCell:AddEventListener(MouseEvent.MouseClick, self.OnClickMaterialCell, self)
    self.curMaterialCombineCell:AddEventListener(ItemEvent.GemDelete, self.OnClickMaterialCell, self)
    self:AddClickEvent(self:FindGO("ExpandBtn", self.curMaterialGO), function()
      self:SwitchMultiFunction(true)
    end)
  end
  if self.curMultiFunctionGO then
    self:AddClickEvent(self:FindGO("ShrinkBtn", self.curMultiFunctionGO), function()
      self:SwitchMultiFunction(false)
    end)
    local multiFunctionTable = self:FindComponent("Table", UITable, self.curMultiFunctionGO)
    GameObjectUtil.Instance:DestroyAllChildren(multiFunctionTable.gameObject)
    self.multiFunctionScrollView = multiFunctionTable.transform.parent:GetComponent(UIScrollView)
    self.curMultiFunctionListCtrl = UIGridListCtrl.new(multiFunctionTable, _G[curMaterialCellName], curMaterialCellName)
    self.curMultiFunctionListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickMultiFunctionCell, self)
    self.curMultiFunctionListCtrl:AddEventListener(ItemEvent.GemDelete, self.OnClickMultiFunctionCell, self)
    self:SwitchMultiFunction(false)
  end
  if self.pageState == GemFunctionState.Sculpt then
    self:SetItemToSculpt()
  elseif self.pageState == GemFunctionState.Smelt then
    self:SetItemToSmelt()
  elseif self.pageState == GemFunctionState.Decompose then
    self:ResetDecompose()
  elseif self.pageState == GemFunctionState.UpdateAttr then
    self:SetItemToUpdateAttr(self.curUpdateAttrItemData)
  end
end

local targetSelectComparer = function(l, r)
  if l.Quality ~= r.Quality then
    return l.Quality > r.Quality
  end
  return l.id < r.id
end

function GemFunctionPage:UpdateTargetSelectList()
  local staticDataArr = ReusableTable.CreateArray()
  local p = GemProxy.Instance:GetCurNewProfessionFilterData()
  local isProfessionFilterExist = p and type(p) == "table" and next(p)
  for _, data in pairs(Table_GemRate) do
    if TableUtility.ArrayFindIndex(smeltQualitiesToShow, data.Quality) > 0 and not EquipUtil.CheckEquipIsForbiddenByFuncState(data.id) and (not isProfessionFilterExist or gemProxyIns:CheckIfSkillGemHasSameProfessions(data.id, p)) then
      TableUtility.ArrayPushBack(staticDataArr, data)
    end
  end
  table.sort(staticDataArr, targetSelectComparer)
  self.targetSelectCtrl:ResetDatas(staticDataArr, true)
  ReusableTable.DestroyAndClearArray(staticDataArr)
end

local materialSelectComparer = function(l, r)
  local comp1 = GemProxy.PredicateComparer(l, r, GemProxy.CheckIsFavorite)
  if comp1 ~= nil then
    return comp1
  end
  local comp2 = GemProxy.PredicateComparer(l, r, GemProxy.CheckIsEmbedded)
  if comp2 ~= nil then
    return comp2
  end
  return GemProxy.BasicComparer(l, r)
end

function GemFunctionPage:UpdateMaterialSelectList(noResetPos)
  local gems
  if self.pageState == GemFunctionState.Smelt then
    if not self.MaterialSelect.activeSelf then
      return
    end
    if not self.targetGemStaticId then
      LogUtility.Error("Cannot get materials when targetGem is nil")
      return
    end
    gems = GemProxy.GetSkillItemDataByQualityAndProfession(smeltQualitiesToShow, Table_GemRate[self.targetGemStaticId].ClassType)
  else
    gems = GemProxy.GetSkillItemDataByFilterDatasOfView(self)
  end
  if not containEmbeddedGemState[self.pageState] then
    GemProxy.RemoveEmbedded(gems)
  end
  table.sort(gems, materialSelectComparer)
  local isDecompose = self.pageState == GemFunctionState.Decompose
  for _, cell in pairs(self.materialSelectCells) do
    cell:SetShowDeleteIcon(not isDecompose)
  end
  self.materialSelectCtrl:ResetDatas(gems, not noResetPos)
end

function GemFunctionPage:UpdateSelectedMaterial()
  if self.pageState == GemFunctionState.Sculpt then
    return
  end
  self.targetExhibitTip:SetActive(false)
  if not self.curMaterialCombineCell then
    return
  end
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
  self:CheckFunctionReady()
end

function GemFunctionPage:UpdateMultiFunctionMaterial()
  if self.pageState == GemFunctionState.Sculpt then
    return
  end
  TipManager.CloseTip()
  self.targetExhibitTip:SetActive(false)
  self.curMultiFunctionListCtrl:ResetDatas(self:ReUnitMultiFunctionData())
  local combineCells = self.curMultiFunctionListCtrl:GetCells()
  for _, combineCell in pairs(combineCells) do
    combineCell:SetShowNewTag(false)
    combineCell:SetCheckTipEnablePredicate(self:GetCheckTipEnablePredicate())
    combineCell:ForceShowDeleteIcon()
  end
  self:CheckFunctionReady()
end

local costLabelColor = LuaColor.New(0.37254901960784315, 0.37254901960784315, 0.37254901960784315, 1)

function GemFunctionPage:UpdateCostLabelColor()
  if not self.costLabel then
    return
  end
  self.costLabel.color = not self:CheckZeny() and ColorUtil.Red or costLabelColor
end

function GemFunctionPage:UpdateSculptCost()
  if self.pageState ~= GemFunctionState.Sculpt then
    return
  end
  if not self.costGO.activeInHierarchy then
    return
  end
  local costStaticId, costNum = self.sculptCostConfig[1], self.sculptCostConfig[2]
  IconManager:SetItemIcon(Table_Item[costStaticId].Icon, self:FindComponent("Sprite", UISprite, self.costGO))
  local realNum = BagProxy.Instance:GetItemNumByStaticID(costStaticId) or 0
  self.costLabel.text = string.format(ZhString.Gem_CountLabelFormat, realNum, costNum)
  self.costLabel.color = costNum > realNum and ColorUtil.Red or costLabelColor
end

function GemFunctionPage:SwitchMultiFunction(isMultiActive)
  if not self.curMultiFunctionGO then
    return
  end
  self.isMultiActive = isMultiActive or false
  self.curMultiFunctionGO:SetActive(self.isMultiActive)
  self.material5GO_TargetRoot:SetActive(self.pageState == GemFunctionState.CurrentProf)
  self.curMaterialGO:SetActive(not self.isMultiActive)
  if self.isMultiActive then
    for _, cell in pairs(self.materialSelectCells) do
      cell:SetMultiSelectModel(self.multiFunctionMaterialData)
      cell:SetClickDisablePredicate(self.pageState == GemFunctionState.Smelt and smeltClickDisablePredicate or multiComposeClickDisablePredicate, self)
    end
    TableUtility.TableClear(self.multiFunctionMaterialData)
    for i = 1, self.maxMaterialCount do
      self.multiFunctionMaterialData[i] = self.selectedMaterialData[i]
    end
    self:UpdateMultiFunctionMaterial()
    self:SetMultiFunctionCellChooseToFirstEmpty()
    TableUtility.ArrayClear(self.selectedMaterialData)
  else
    self:SetCost(GemFunctionCostZeny[self.pageState])
    for _, cell in pairs(self.materialSelectCells) do
      cell:SetMultiSelectModel(self.selectedMaterialData)
      cell:SetClickDisablePredicate(self.pageState == GemFunctionState.Smelt and smeltClickDisablePredicate or singleComposeClickDisablePredicate, self)
    end
    TableUtility.ArrayClear(self.selectedMaterialData)
    for i = 1, self.maxMaterialCount do
      if self.multiFunctionMaterialData[i] then
        TableUtility.ArrayPushBack(self.selectedMaterialData, self.multiFunctionMaterialData[i])
      end
    end
    self:UpdateSelectedMaterial()
    TableUtility.TableClear(self.multiFunctionMaterialData)
  end
  self:UpdateMaterialSelectList()
end

function GemFunctionPage:OnClickDecomposeAll()
  if self.pageState ~= GemFunctionState.Decompose then
    return
  end
  if self.decomposeAllToggle.value then
    local maxCount = GameConfig.GemNew and GameConfig.GemNew.MaxDecomposeCount or 50
    local datas = self.materialSelectCtrl:GetDatas() or _EmptyTable
    local addedCount = 0
    for i = 1, #datas do
      local gemDatas = datas[i]
      if gemDatas then
        for j = 1, #gemDatas do
          if maxCount <= self.decomposeSelectMaterialCount then
            break
          end
          if self.decomposeSelectMaterials[gemDatas[j].id] then
          elseif GemProxy.CheckIsFavorite(gemDatas[j]) then
          else
            local hasStars = false
            if gemDatas[j].gemSkillData and gemDatas[j].gemSkillData.GetStarCounts then
              local goldStars, silverStars = gemDatas[j].gemSkillData:GetStarCounts()
              if 0 < goldStars or 0 < silverStars then
                hasStars = true
              end
            end
            if not hasStars then
              self:AddItemToDecompose(gemDatas[j])
              addedCount = addedCount + 1
            end
          end
        end
      end
    end
    self:SetFunctionBtnActive(0 < addedCount)
    if addedCount == 0 then
      MsgManager.ShowMsg(nil, ZhString.Gem_AllAddTip, 1)
      self.decomposeAllToggle.value = false
    end
  else
    self:ResetDecompose()
    self:SetFunctionBtnActive(false)
  end
end

function GemFunctionPage:AutoChooseGem()
  if self.curSkillClassFilterPopData == 0 then
    return
  end
  local max_num = self.isMultiActive and 30 or 3
  local material_cell
  local auto_click_num = 0
  for i = 1, #self.materialSelectCells do
    material_cell = self.materialSelectCells[i]
    if material_cell.data and not material_cell.cellInvalid then
      self:OnClickMaterialSelectCell(material_cell)
      auto_click_num = auto_click_num + 1
      if max_num <= auto_click_num then
        break
      end
    end
  end
end

function GemFunctionPage:TryPlayEffectThenCall(func)
  self.isWorking = true
  local delayedTime = 1000
  if LocalSaveProxy.Instance:GetSkipAnimation(SKIPTYPE.GemFunction) then
    func(self)
  else
    self:PlayUISound(AudioMap.UI.Gem)
    if self.foreEffect then
      self.foreEffect:Stop()
    end
    local actionName = "ronghe_2"
    self:PlayUIEffect(self.effectName, self.effectContainer, true, function(obj, args, assetEffect)
      self.foreEffect = assetEffect
      self.foreEffect:ResetAction(actionName, 0, true)
    end)
    if self.backEffect then
      self.backEffect:ResetAction(actionName, 0, true)
    end
    delayedTime = 4000
    tickManager:CreateOnceDelayTick(delayedTime, func, self, 1)
  end
  self:SetFunctionBtnActive(false)
  tickManager:CreateOnceDelayTick(delayedTime + 800, self.RestoreAfterAction, self, 2)
end

function GemFunctionPage:RestoreAfterAction()
  self.isWorking = nil
  if self.pageState == GemFunctionState.Sculpt then
    self:SetFunctionBtnActive(true)
  else
    self:CheckFunctionReady()
  end
end

function GemFunctionPage:TryUpdateComposeMainLabel(isReady)
  if self.curMultiFunctionGO.activeSelf then
    return
  end
  if self.pageState == GemFunctionState.SameName then
    self.mainLabel.text = isReady and self.selectedMaterialData[1] and self.selectedMaterialData[1]:GetName() or GemFunctionMainLabel[self.pageState]
  elseif self.pageState == GemFunctionState.RandomProf then
    local quality, weight = GemProxy.GetMaxQualityWeightOf3to1Compose(self.selectedMaterialData)
    self.mainLabel.text = isReady and quality and weight and string.format(ZhString.Gem_QualityComposeTip, quality, weight) or GemFunctionMainLabel[self.pageState]
  elseif self.pageState == GemFunctionState.CurrentProf then
    local quality, weight = GemProxy.GetMaxQualityWeightOf5to1Compose(self.selectedMaterialData)
    self.mainLabel.text = isReady and quality and weight and string.format(ZhString.Gem_QualityComposeTip, quality, weight) or GemFunctionMainLabel[self.pageState]
  end
end

function GemFunctionPage:TryDoFunction()
  if not self.isFunctionBtnActive then
    return
  end
  local call = self.doFunc[self.pageState]
  if call then
    call(self)
  end
end

function GemFunctionPage:RandomProf()
  if self:CheckMaterial4S() and ProfessionProxy.GetJobDepth(MyselfProxy.Instance:GetMyProfession()) ~= 5 then
    MsgManager.ShowMsgByID(36013)
    return
  end
  self:Compose(function(data)
    GemProxy.CallSkill3to1Compose(data)
  end)
end

function GemFunctionPage:Decompose()
  if not self.decomposeCostZeny then
    return
  end
  if MyselfProxy.Instance:GetROB() < self.decomposeCostZeny then
    MsgManager.ShowMsgByID(1)
    return
  end
  local todo_decompose_guid = ReusableTable.CreateArray()
  for k, v in pairs(self.decomposeSelectMaterials) do
    todo_decompose_guid[#todo_decompose_guid + 1] = v.id
  end
  ServiceItemProxy.Instance:CallDecomposeGemItemCmd(todo_decompose_guid)
  ReusableTable.DestroyAndClearArray(todo_decompose_guid)
end

function GemFunctionPage:UpdateAttr()
  if self.updateAttrLackOf then
    MsgManager.ShowMsgByID(8)
    return
  end
  if not self.curUpdateAttrItemData then
    return
  end
  local curAttrData = self.curUpdateAttrCell and self.curUpdateAttrCell.data
  if not curAttrData then
    return
  end
  local buff_id, param_id = curAttrData.buffId, curAttrData.paramId
  ServiceItemProxy.Instance:CallUpgradeGemItemCmd(self.curUpdateAttrItemData.id, buff_id, param_id)
end

function GemFunctionPage:CurrentProf()
  if not gemProxyIns:CheckIsMyProfessionAvailable() then
    MsgManager.ShowMsgByID(36007)
    return
  end
  if self:CheckMaterial4S() then
    local myProf = MyselfProxy.Instance:GetMyProfession()
    if ProfessionProxy.GetJobDepth(myProf) == 5 then
      if not gemProxyIns:GetAllGemIdsBySkillQualityGroupAndProfession(2, myProf) then
        MsgManager.ShowMsgByID(36014)
        return
      end
    else
      MsgManager.ShowMsgByID(36013)
      return
    end
  end
  local pro = self.targetProfession
  if not pro then
    return
  end
  local remainder = pro % 10
  if remainder ~= 5 then
    pro = pro - remainder + 5
  end
  self:Compose(function(data)
    GemProxy.CallSkill5to1Compose(data, pro)
  end)
end

function GemFunctionPage:SameName()
  self:Compose(function(data)
    GemProxy.CallSkillSameNameCompose(data)
  end)
end

function GemFunctionPage:Compose(callFunc)
  if not callFunc or not self:CheckZeny() then
    MsgManager.ShowMsgByID(1)
    return
  end
  FunctionSecurity.Me():NormalOperation(function(self)
    self:TryPlayEffectThenCall(function(self)
      callFunc(self.curMultiFunctionGO.activeSelf and self.multiFunctionMaterialData or self.selectedMaterialData)
      self.isWorking = nil
    end)
  end, self)
end

function GemFunctionPage:Sculpt()
  local itemData = self.targetCell.data
  if not itemData then
    MsgManager.FloatMsg(nil, ZhString.Gem_SculptNoTargetCellTip)
    return
  end
  local skillData = itemData.gemSkillData
  if not skillData or not next(skillData) then
    LogUtility.Error("Cannot sculpt gem while skillData is nil")
    return
  end
  if GemProxy.CheckSkillDataIsSculpted(skillData) then
    local sculptData = skillData:GetSculptData()
    MsgManager.ConfirmMsgByID(36009, function()
      if GemProxy.CheckIsFavorite(itemData) then
        MsgManager.FloatMsg(nil, ZhString.Gem_ResetSculptIsFavoriteTip)
        return
      end
      GemProxy.CallSculpt(itemData.id, sculptData[1].type, sculptData[1].pos, true)
    end)
    return
  end
  if not self.selectedSculpt then
    MsgManager.FloatMsg(nil, ZhString.Gem_SculptNoSelectedSculptTip)
    return
  end
  local realNum = BagProxy.Instance:GetItemNumByStaticID(self.sculptCostConfig[1]) or 0
  if realNum < self.sculptCostConfig[2] then
    MsgManager.ShowMsgByID(3554, Table_Item[self.sculptCostConfig[1]].NameZh)
    return
  end
  if GemProxy.CheckIsFavorite(itemData) then
    MsgManager.FloatMsg(nil, ZhString.Gem_SculptIsFavoriteTip)
    return
  end
  local selectedType = skillData.needAttributeGemTypes[self.selectedSculpt]
  MsgManager.ConfirmMsgByID(36010, function()
    FunctionSecurity.Me():NormalOperation(function(self)
      self:TryPlayEffectThenCall(function(self)
        GemProxy.CallSculpt(itemData.id, selectedType, self.selectedSculpt)
      end)
    end, self)
  end, nil, nil, ZhString["Gem_SkillDescNeedGemType" .. selectedType])
end

function GemFunctionPage:Smelt()
  if not self.targetGemStaticId then
    MsgManager.FloatMsg(nil, ZhString.Gem_SmeltNoTargetCellTip)
    return
  end
  if not self:CheckZeny() then
    MsgManager.ShowMsgByID(1)
    return
  end
  FunctionSecurity.Me():NormalOperation(function(self)
    self:TryPlayEffectThenCall(self._Smelt)
  end, self)
end

function GemFunctionPage:_Smelt()
  GemProxy.CallSmelt(self.targetGemStaticId, self.curMultiFunctionGO.activeSelf and self.multiFunctionMaterialData or self.selectedMaterialData)
  self.isWorking = nil
end

function GemFunctionPage:CheckZeny()
  return MyselfProxy.Instance:GetROB() >= (self.cost or math.huge)
end

function GemFunctionPage:CheckMaterial4S()
  local _, certainMaterial = next(self.curMultiFunctionGO.activeSelf and self.multiFunctionMaterialData or self.selectedMaterialData)
  return certainMaterial and gemProxyIns:GetSkillQualityGroupByStaticId(certainMaterial.staticData.id) == 2 or false
end

function GemFunctionPage:CheckFunctionReady()
  if self.pageState == GemFunctionState.Sculpt then
    return
  end
  if not self.curMultiFunctionGO then
    return
  end
  local isReady, rowCount = false
  if self.curMultiFunctionGO.activeSelf then
    for _, cell in pairs(self.curMultiFunctionListCtrl:GetCells()) do
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
    if isReady then
      if self.pageState == GemFunctionState.SameName then
        for i = 2, #self.selectedMaterialData do
          isReady = isReady and GemProxy.CheckIsSameName(self.selectedMaterialData[i], self.selectedMaterialData[1])
        end
      elseif self.pageState == GemFunctionState.CurrentProf then
        isReady = isReady and nil ~= self.targetProfession
      end
    end
  end
  self:TryUpdateComposeMainLabel(isReady)
  self:SetFunctionBtnActive(isReady)
  rowCount = rowCount or isReady and 1 or 0
  local function_cost_zeny = GemFunctionCostZeny[self.pageState]
  if function_cost_zeny then
    self:SetCost(function_cost_zeny * rowCount)
  end
end

function GemFunctionPage:SetCost(cost)
  if not cost then
    return
  end
  self.cost = cost
  self.costLabel.text = cost and StringUtil.NumThousandFormat(cost) or ""
  self:UpdateCostLabelColor()
end

local inactiveTabIconColor, activeTabIconColor = LuaColor.New(0.592156862745098, 0.6862745098039216, 0.9333333333333333, 1), LuaColor.New(0.12549019607843137, 0.4588235294117647, 0.7490196078431373, 1)

function GemFunctionPage:SetCurrentTabIconColor()
  for _, sp in pairs(self.tabIconSps) do
    sp.color = inactiveTabIconColor
  end
  local icon = self:FindComponent("Icon", UISprite, self.tabGOs[self.pageState])
  if icon then
    icon.color = activeTabIconColor
  end
end

function GemFunctionPage:SetFunctionBtnActive(isActive)
  self.isFunctionBtnActive = isActive and true or false
  self.functionBtn = self:FindGO("FunctionBtn", self.curCtrl)
  self.functionBtnBgSp = self.functionBtn:GetComponent(UISprite)
  self.functionBtnLabel = self:FindComponent("Label", UILabel, self.functionBtn)
  if isActive then
    self:AddClickEvent(self.functionBtn, function()
      self:TryDoFunction()
    end)
    local isUpdateAttr = self.pageState == GemFunctionState.UpdateAttr
    self.functionBtnBgSp.spriteName = isUpdateAttr and _BtnSprite.Yellow or _BtnSprite.Blue
    self.functionBtnLabel.effectColor = isUpdateAttr and ColorUtil.ButtonLabelOrange or ColorUtil.ButtonLabelBlue
  else
    self.functionBtnBgSp.spriteName = _BtnSprite.Grey
    self.functionBtnLabel.effectColor = ColorUtil.NGUIGray
  end
end

function GemFunctionPage:SetItemToDecompose(data)
  if self.pageState ~= GemFunctionState.Decompose then
    return
  end
  if self.decomposeSelectMaterialCount >= (GameConfig.GemNew.MaxDecomposeCount or 50) then
    MsgManager.ShowMsgByID(244)
    return
  end
  self.mainLabel.gameObject:SetActive(data == nil)
  self:SetFunctionBtnActive(data ~= nil)
  self.functionBtnLabel.text = ZhString.GemDecompose_BtnLab
  self:AddItemToDecompose(data)
end

function GemFunctionPage:UpdateDecomposeMaterials()
  local cells = self.decomposeMaterialCtrl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetShowNewTag(false)
    if not cell:CheckDataIsNilOrEmpty() then
      cell:ForceShowDeleteIcon()
    end
  end
  self:UpdateDecomposeSelectMaterials()
end

function GemFunctionPage:UpdateDecomposeSelectMaterials()
  for _, cell in pairs(self.materialSelectCells) do
    cell:SetMultiSelectModel(self.decomposeSelectMaterials)
    cell:SetClickDisablePredicate(multiComposeClickDisablePredicate, self)
  end
end

function GemFunctionPage:UpdateDecomposeRewardCost()
  self:CalcDecomposeReward()
  self:CalDecomposeCost()
end

function GemFunctionPage:AddItemToDecompose(data)
  if not data then
    return
  end
  if self.decomposeSelectMaterials[data.id] then
    return
  end
  self.decomposeSelectMaterials[data.id] = data
  self.decomposeSelectMaterialCount = self.decomposeSelectMaterialCount + 1
  self.decomposeMaterialCtrl:ResetDatas(TableUtil.HashToArray(self.decomposeSelectMaterials), true)
  self:UpdateDecomposeMaterials()
  self:CalcDecomposeReward()
  self:CalDecomposeCost()
end

function GemFunctionPage:DelItemToDecompose(data)
  if not data then
    return
  end
  if not self.decomposeSelectMaterials[data.id] then
    return
  end
  self.decomposeSelectMaterials[data.id] = nil
  self.decomposeSelectMaterialCount = self.decomposeSelectMaterialCount - 1
  self.decomposeMaterialCtrl:ResetDatas(TableUtil.HashToArray(self.decomposeSelectMaterials))
  self:UpdateDecomposeMaterials()
  self:UpdateDecomposeRewardCost()
  if nil == next(self.decomposeSelectMaterials) then
    self:ResetDecompose()
  end
end

function GemFunctionPage:ResetDecompose()
  TableUtility.TableClear(self.decomposeSelectMaterials)
  self.decomposeSelectMaterialCount = 0
  self.decomposeAllToggle.value = false
  self:UpdateDecomposeSelectMaterials()
  self.decomposeMaterialCtrl:ResetDatas(self.decomposeSelectMaterials, true)
  self:UpdateDecomposeRewardCost()
end

function GemFunctionPage:CalcDecomposeReward()
  if not next(self.decomposeSelectMaterials) then
    self.decomposeRewardList:ResetDatas(_EmptyTable)
    self:Show(self.emptyRewardBg)
    if not self.decomposeEmptyRewardCell then
      local obj = self:LoadPreferb("cell/GemDecomposeRewardCell", self.emptyRewardBg)
      obj.transform.localPosition = LuaGeometry.Const_V3_zero
      obj.transform.localScale = LuaGeometry.Const_V3_one
      self.decomposeEmptyRewardCell = GemDecomposeRewardCell.new(obj)
    end
    self.decomposeEmptyRewardCell:SetData(nil)
    return
  end
  self:Hide(self.emptyRewardBg)
  local decomposeRewardMap = {}
  local config = GameConfig.GemNew.DecomposeReward
  if not config then
    return
  end
  local quality, config_reward_id, config_reward_num
  for _, data in pairs(self.decomposeSelectMaterials) do
    quality = data.gemSkillData.quality
    if config[quality] then
      config_reward_id = config[quality][1]
      config_reward_num = config[quality][2]
      local num = decomposeRewardMap[config_reward_id]
      if not num then
        num = 0
        decomposeRewardMap[config_reward_id] = num
      end
      decomposeRewardMap[config_reward_id] = num + config_reward_num
    end
  end
  local rewards = {}
  for k, v in pairs(decomposeRewardMap) do
    local itemData = ItemData.new("GemDecomposeReward", k)
    itemData:SetItemNum(v)
    rewards[#rewards + 1] = itemData
  end
  self.decomposeRewardList:ResetDatas(rewards)
end

function GemFunctionPage:CalDecomposeCost()
  local cost = GameConfig.GemNew.DecomposeZeny
  self.decomposeCostZeny = cost * self.decomposeSelectMaterialCount
  self.decomposeCost.text = tostring(self.decomposeCostZeny)
end

function GemFunctionPage:SetItemToUpdateAttr(data)
  if self.pageState ~= GemFunctionState.UpdateAttr then
    return
  end
  self.mainLabel.gameObject:SetActive(data == nil)
  self.targetCell:SetData(data)
  self:InitialUpdateAttrCost(data)
end

function GemFunctionPage:InitialUpdateAttrCost(data)
  self.curUpdateAttrItemData = data
  self:SetFunctionBtnActive(data ~= nil)
  self.updateAttrBg:SetActive(data ~= nil)
  self.updateAttrCostRoot:SetActive(data ~= nil)
  self.updateAttrScrollView.gameObject:SetActive(data ~= nil)
  self.updateAttrIsStarLab.gameObject:SetActive(data ~= nil)
  self.updateAttrTip.gameObject:SetActive(data == nil)
  if not self.curUpdateAttrItemData then
    return
  end
  local skillData = self.curUpdateAttrItemData.gemSkillData
  if not skillData then
    return
  end
  self.updateAttrCtl:ResetDatas(skillData:GetEffectDescData())
  self.updateAttrCtl:ResetPosition()
  local cell = self.curUpdateAttrCell or self.updateAttrCtl:GetCells()[1]
  if cell then
    self:OnClickUpdateAttrCell(cell)
  end
end

function GemFunctionPage:UpdateCurrentAttrTip()
  if self.pageState ~= GemFunctionState.UpdateAttr then
    return
  end
  local data = self.curUpdateAttrCell and self.curUpdateAttrCell.data
  if not data then
    return
  end
  if data.goldStarCount and data.goldStarCount > 0 then
    self:Show(self.updateAttrIsStarLab)
    self:SetFunctionBtnActive(false)
    if self.updateAttrCostItemCell then
      self:Hide(self.updateAttrCostItemCell)
    end
  else
    self:SetFunctionBtnActive(true)
    self:Hide(self.updateAttrIsStarLab)
    local quality = self.curUpdateAttrItemData.gemSkillData.quality
    local costConfig = GameConfig.GemNew.UpgradeCost and GameConfig.GemNew.UpgradeCost[quality]
    if not costConfig then
      return
    end
    local starCount = self.curUpdateAttrItemData.gemSkillData:GetStarCounts()
    costConfig = costConfig[starCount]
    if not costConfig then
      return
    end
    costConfig = data.paramId == 0 and costConfig.BuffCost or costConfig.ParamCost
    if not costConfig or not next(costConfig) then
      return
    end
    local costId = costConfig[1][1]
    local costNum = costConfig[1][2]
    if not self.updateAttrCostItemCell then
      local obj = self:LoadPreferb("cell/BagItemCell", self.updateAttrCostItemRoot)
      obj.transform.localPosition = LuaGeometry.Const_V3_zero
      obj.transform.localScale = LuaGeometry.Const_V3_one
      self.updateAttrCostItemCell = BagItemCell.new(obj)
    end
    self:Show(self.updateAttrCostItemCell)
    self:AddClickEvent(self.updateAttrCostItemCell.gameObject, function()
      self:ClickRewardItem(self.updateAttrCostItemCell.gameObject)
    end)
    self.updateAttrCostItemData = ItemData.new("GemUpdateAttr", costId)
    self.updateAttrCostItemCell:SetData(self.updateAttrCostItemData)
    local ownNum = BagProxy.Instance:GetItemNumByStaticID(costId, GameConfig.PackageMaterialCheck.gem_upgrade)
    self.updateAttrLackOf = costNum > ownNum
    local formatStr = self.updateAttrLackOf and "[c][FF0000]%d[-][/c]/%d" or "%d/%d"
    self.updateAttrCostItemCell:UpdateNumLabel(string.format(formatStr, ownNum, costNum))
  end
end

function GemFunctionPage:ClickRewardItem(cellctl)
  if cellctl and cellctl ~= self.chooseReward then
    local stick = cellctl.gameObject:GetComponent(UIWidget)
    if self.curUpdateAttrItemData then
      local callback = function()
        self:CancelChooseReward()
      end
      local sdata = {
        itemdata = self.updateAttrCostItemData,
        funcConfig = {},
        callback = callback,
        ignoreBounds = {
          cellctl.gameObject
        }
      }
      TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-250, 0})
    end
    self.chooseReward = cellctl
  else
    self:CancelChooseReward()
  end
end

function GemFunctionPage:CancelChooseReward()
  self.chooseReward = nil
  self:ShowItemTip()
end

function GemFunctionPage:SetItemToSculpt(data)
  if self.pageState ~= GemFunctionState.Sculpt then
    return
  end
  self.mainLabel.gameObject:SetActive(data == nil)
  self.sculptWorkbench:SetActive(data ~= nil)
  self:SetFunctionBtnActive(data ~= nil)
  self.targetCell:SetData(data)
  if not data then
    return
  end
  self.gemLabel.text = data.staticData.NameZh
  if not GemProxy.CheckContainsGemSkillData(data) then
    LogUtility.Error("Cannot find GemSkillData while updating item to sculpt")
    return
  end
  local needGem, pos = data.gemSkillData.needAttributeGemTypes
  local tempArr = ReusableTable.CreateArray()
  TableUtility.ArrayShallowCopy(tempArr, needGem)
  local isSculpted = GemProxy.CheckSkillDataIsSculpted(data.gemSkillData)
  if isSculpted then
    local sculptData = data.gemSkillData:GetSculptData()
    if next(sculptData) then
      pos = sculptData[1].pos
      tempArr[pos] = 0
    end
  end
  for i = 1, #self.needGemSps do
    self.needGemSps[i].spriteName = GemProxy.SculptNeedGemSpriteNames[tempArr[i]]
    self.needGemSps[i]:MakePixelPerfect()
  end
  self.costGO:SetActive(not isSculpted)
  self:UpdateSculptCost()
  self.functionBtnLabel.text = isSculpted and ZhString.Gem_ResetSculpt or ZhString.Gem_Sculpt
  ReusableTable.DestroyAndClearArray(tempArr)
end

function GemFunctionPage:SetItemToSmelt(data)
  if self.pageState ~= GemFunctionState.Smelt then
    return
  end
  self.mainLabel.text = data == nil and ZhString.Gem_SmeltTipWithoutTarget or ZhString.Gem_SmeltTipWithTarget
  self:SetFunctionBtnActive(data ~= nil)
  local oldTargetGemStaticId = self.targetGemStaticId
  self:SetFakeGemCellData(data)
  if not data then
    return
  end
  if self.targetGemStaticId ~= oldTargetGemStaticId then
    TableUtility.ArrayClear(self.selectedMaterialData)
    self:UpdateSelectedMaterial()
    TableUtility.TableClear(self.multiFunctionMaterialData)
    self:UpdateMultiFunctionMaterial()
  end
end

function GemFunctionPage:SetFakeGemCellData(data)
  self.fakeGemCell:SetActive(data ~= nil)
  self.targetGemStaticId = data and data.id
  local itemStaticData = data and Table_Item[data.id]
  self.gemLabel.text = data and itemStaticData and itemStaticData.NameZh or ""
  if not data then
    return
  end
  local success = IconManager:SetItemIcon(itemStaticData.Icon, self.fakeGemCellSp)
  if success then
    self.fakeGemCellSp:MakePixelPerfect()
  end
  success = IconManager:SetUIIcon(GemCell.SkillBgSpriteNames[data.Quality] or GemCell.AttrBgSpriteName, self.fakeGemCellBgSp)
  if success then
    self.fakeGemCellBgSp:MakePixelPerfect()
  end
  self.fakeGemCellQualitySp.spriteName = GemCell.SkillQualitySpriteNames[data.Quality]
  self.fakeGemCellNameLabel.text = string.sub(itemStaticData.NameZh, 1, 6)
end

function GemFunctionPage:GetMultiFunctionCell(index)
  index = index or 0
  local row, col = GemProxy.GetRowAndColFromIndexAndColumnCount(index, self.maxMaterialCount)
  local combineCells = self.curMultiFunctionListCtrl:GetCells()
  if combineCells and combineCells[row] then
    return combineCells[row]:GetCell(col)
  end
end

function GemFunctionPage:SetMultiFunctionCellChoose(newIndex)
  if not self.curMultiFunctionGO.activeSelf then
    return
  end
  self.chooseMultiFunctionCellIndex = newIndex
  local newChooseCell = self:GetMultiFunctionCell(self.chooseMultiFunctionCellIndex)
  if newChooseCell then
    newChooseCell.chooseSymbol:SetActive(true)
  else
    self.chooseMultiFunctionCellIndex = nil
  end
end

function GemFunctionPage:SetMultiFunctionCellChooseToFirstEmpty()
  if not self.curMultiFunctionGO.activeSelf then
    return
  end
  local newIndex
  for i = 1, self:GetMaxMultiFunctionCellCount() do
    if not self.multiFunctionMaterialData[i] then
      newIndex = i
      break
    end
  end
  if newIndex then
    local row, col = GemProxy.GetRowAndColFromIndexAndColumnCount(newIndex, self.maxMaterialCount)
    self.multiFunctionScrollView:SetDragAmount(0, math.clamp((row - 3) / (GemProxy.MultiComposeRowCount - 3), 0, 1), false)
  end
  self:SetMultiFunctionCellChoose(newIndex)
end

function GemFunctionPage:ShowGemTip(cellGO, data)
  local tip = GemCell.ShowGemTip(cellGO, data, self.normalStick)
  if not tip then
    return
  end
  tip:AddIgnoreBounds(self.materialContainer)
end

function GemFunctionPage:ReUnitMultiFunctionData()
  TableUtility.TableClear(tempTable)
  for i = 1, GemProxy.MultiComposeRowCount do
    for j = 1, self.maxMaterialCount do
      tempTable[i] = tempTable[i] or {}
      tempTable[i][j] = self.multiFunctionMaterialData[self.maxMaterialCount * (i - 1) + j] or BagItemEmptyType.Empty
    end
  end
  return tempTable
end

function GemFunctionPage:GetCheckTipEnablePredicate()
  return self.pageState == GemFunctionState.SameName and GemProxy.CheckComposeDataGroupIsSameName or GemProxy.CheckComposeDataGroup
end

function GemFunctionPage:GetMaxMultiFunctionCellCount()
  return GemProxy.GetMaxMultiFunctionCellCount(self.maxMaterialCount)
end
