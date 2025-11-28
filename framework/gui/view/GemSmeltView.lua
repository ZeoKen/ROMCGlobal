autoImport("WrapListCtrl")
autoImport("GemCell")
autoImport("GemExhibitChooseCell")
autoImport("ItemTipGemExhibitCell")
autoImport("GemCombineCell")
autoImport("GemFunctionPage")
GemSmeltView = class("GemSmeltView", BaseView)
GemSmeltView.ViewType = UIViewType.NormalLayer
local qualitiesToShow = {3, 4}
local tempTable, gemProxyIns = {}
local costLabelColor = LuaColor.New(0.37254901960784315, 0.37254901960784315, 0.37254901960784315, 1)

function GemSmeltView:Init()
  if not gemProxyIns then
    gemProxyIns = GemProxy.Instance
  end
  self:AddEvents()
  self:InitData()
  self:InitRight()
  self:InitTargetSelect()
  self:InitMaterialSelect()
  self:RegistShowGeneralHelpByHelpID(GemFunctionHelpId[GemFunctionState.Smelt], self:FindGO("HelpButton"))
end

function GemSmeltView:AddEvents()
  self:AddListenEvt(MyselfEvent.ZenyChange, self.UpdateCostLabelColor)
  self:AddListenEvt(ItemEvent.GemUpdate, self.OnGemUpdate)
  self:AddListenEvt(ServiceEvent.ItemGemDataUpdateItemCmd, self.OnGemDataUpdate)
  self:AddListenEvt(ServiceUserProxy.RecvLogin, self.CloseSelf)
end

function GemSmeltView:InitData()
  self.selectedMaterialData = {}
  self.multiSmeltMaterialData = {}
  local funcStateId, param, index = GemProxy.BannedQualityFuncStateId
  if FunctionNpcFunc.Me():CheckSingleFuncForbidState(funcStateId) then
    param = Table_FuncState[funcStateId] and Table_FuncState[funcStateId].Param
    if param then
      for i = 1, #param do
        index = TableUtility.ArrayFindIndex(qualitiesToShow, param[i])
        if 0 < index then
          table.remove(qualitiesToShow, index)
        end
      end
    end
  end
end

local skipAnimTipOffset = {90, -75}

function GemSmeltView:InitRight()
  self.skipBtnSp = self:FindComponent("SkipBtn", UISprite)
  self:AddButtonEvent("SkipBtn", function()
    TipManager.Instance:ShowSkipAnimationTip(SKIPTYPE.GemFunction, self.skipBtnSp, NGUIUtil.AnchorSide.Right, skipAnimTipOffset)
  end)
  self.effectContainer = self:FindGO("EffectContainer")
  self.gemLabel = self:FindComponent("GemLabel", UILabel)
  self.mainLabel = self:FindComponent("MainLabel", UILabel)
  local titleLabel = self:FindComponent("TitleLabel", UILabel)
  titleLabel.text = Table_NpcFunction[10037].NameZh
  self.targetCell = self:FindGO("FakeGemCell")
  self.targetCellBgSp = self:FindComponent("GemBg", UISprite)
  self.targetCellSp = self:FindComponent("GemIcon", UISprite)
  self.targetCellQualitySp = self:FindComponent("GemQuality", UISprite)
  self.targetCellNameLabel = self:FindComponent("GemMicroNameLabel", UILabel)
  self:AddButtonEvent("TargetCell", function()
    self:OnClickTargetCell()
  end)
  self.costLabel = self:FindComponent("CostLabel", UILabel, self.costGO)
  local smeltBtn = self:FindGO("SmeltBtn")
  self:AddClickEvent(smeltBtn, function()
    if not self.isSmeltBtnActive then
      return
    end
    self:TrySmelt()
  end)
  self.smeltBtnBgSp = smeltBtn:GetComponent(UISprite)
  self.smeltBtnLabel = self:FindComponent("Label", UILabel, smeltBtn)
  self:InitSmeltMaterial()
end

function GemSmeltView:InitSmeltMaterial()
  self.material3GO = self:FindGO("3Material")
  self.multiSmelt3GO = self:FindGO("3MultiSmeltPanel")
  self:AddButtonEvent("ExpandBtn", function()
    self:SwitchMultiSmelt(true)
  end)
  self:AddButtonEvent("ShrinkBtn", function()
    self:SwitchMultiSmelt(false)
  end)
  local materialCellObj = self:LoadPreferb("cell/GemCombine3Cell", self:FindGO("MaterialPanel", self.material3GO))
  self.materialCombineCell = GemCombine3Cell.new(materialCellObj)
  self.materialCombineCell:AddEventListener(MouseEvent.MouseClick, self.OnClickMaterialCell, self)
  self.materialCombineCell:AddEventListener(ItemEvent.GemDelete, self.OnClickMaterialCell, self)
  local multiSmeltTable = self:FindComponent("Table", UITable, self.multiSmelt3GO)
  self.multiSmeltScrollView = multiSmeltTable.transform.parent:GetComponent(UIScrollView)
  self.multiSmeltListCtrl = UIGridListCtrl.new(multiSmeltTable, GemCombine3Cell, "GemCombine3Cell")
  self.multiSmeltListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickMultiSmeltCell, self)
  self.multiSmeltListCtrl:AddEventListener(ItemEvent.GemDelete, self.OnClickMultiSmeltCell, self)
  self.maxMaterialCount = 3
end

function GemSmeltView:InitTargetSelect()
  self.normalStick = self:FindComponent("NormalStick", UIWidget)
  self.targetSelectGO = self:FindGO("TargetSelect")
  self:AddButtonEvent("CloseTargetSelectBtn", function()
    self.targetSelectGO:SetActive(false)
  end)
  self:TryInitFilterPopOfView("SkillProfessionFilterPop", function()
    self:UpdateTargetSelectList()
  end, GemSkillProfessionFilter, GemSkillProfessionFilterData)
  for _, id in pairs(GameConfig.Gem.NoSmeltProfs) do
    if Table_Class[id] then
      self.SkillProfessionFilterPop:RemoveItem(ProfessionProxy.GetProfessionName(id, MyselfProxy.Instance:GetMySex()))
    end
  end
  self.targetContainer = self:FindGO("TargetContainer", self.targetSelectGO)
  self.targetSelectCtrl = WrapListCtrl.new(self.targetContainer, GemExhibitChooseCell, "GemExhibitChooseCell", WrapListCtrl_Dir.Vertical)
  self.targetSelectCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickExhibitChooseCell, self)
  self.targetSelectCtrl:AddEventListener(GemExhibitChooseCellEvent.ClickGem, self.OnClickExhibitChooseGem, self)
  self.targetSelectCells = self.targetSelectCtrl:GetCells()
  self.exhibitTip = ItemTipGemExhibitCell.new(self:FindGO("ExhibitTipContainer"))
  for _, cell in pairs(self.targetSelectCells) do
    self.exhibitTip:AddCloseCompTarget(cell)
  end
end

function GemSmeltView:InitMaterialSelect()
  self.materialSelectGO = self:FindGO("MaterialSelect")
  self:AddButtonEvent("CloseMaterialSelectBtn", function()
    self.materialSelectGO:SetActive(false)
  end)
  self.materialContainer = self:FindGO("MaterialContainer", self.materialSelectGO)
  self.materialSelectCtrl = WrapListCtrl.new(self.materialContainer, GemCell, "GemCell", WrapListCtrl_Dir.Vertical, 5, 102, true)
  self.materialSelectCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickMaterialSelectCell, self)
  self.materialSelectCtrl:AddEventListener(MouseEvent.LongPress, self.OnLongPressMaterialSelectCell, self)
  self.materialSelectCtrl:AddEventListener(ItemEvent.GemDelete, self.OnGemDelete, self)
  self.materialSelectCells = self.materialSelectCtrl:GetCells()
  for _, cell in pairs(self.materialSelectCells) do
    cell:SetShowDeleteIcon(true)
    cell:SetMultiSelectStyle(GemCell.MultiSelectStyle.HideSelectedCount)
  end
end

function GemSmeltView:OnEnter()
  GemSmeltView.super.OnEnter(self)
  self.exhibitTip:SetActive(false)
  self.targetSelectGO:SetActive(false)
  self.materialSelectGO:SetActive(false)
  self:SwitchMultiSmelt(false)
  self:SetItemToSmelt()
  if not self.backEffect then
    self:PlayUIEffect(EffectMap.UI.GemViewSynthetic, self.effectContainer, false, function(obj, args, assetEffect)
      self.backEffect = assetEffect
      self.backEffect:ResetAction("ronghe_1", 0, true)
    end)
  else
    self.backEffect:ResetAction("ronghe_1", 0, true)
  end
end

function GemSmeltView:OnExit()
  self.multiSmeltListCtrl:Destroy()
  TimeTickManager.Me():ClearTick(self)
  GemSmeltView.super.OnExit(self)
end

function GemSmeltView:OnClickTargetCell()
  self.materialSelectGO:SetActive(false)
  self.targetSelectGO:SetActive(true)
  self:UpdateTargetSelectList()
end

function GemSmeltView:OnClickExhibitChooseCell(cellCtl)
  local data = cellCtl and cellCtl.data
  self.targetSelectGO:SetActive(false)
  self:SetItemToSmelt(data)
  self.exhibitTip:SetActive(false)
  self.materialSelectGO:SetActive(true)
  self:UpdateMaterialSelectList()
end

function GemSmeltView:OnClickExhibitChooseGem(cellCtl)
  local data = cellCtl and cellCtl.data
  if not data then
    return
  end
  self.exhibitTip:SetActive(true)
  self.exhibitTip:SetData(data)
end

function GemSmeltView:OnClickMaterialCell(cellCtl)
  if not self.targetGemStaticId then
    MsgManager.FloatMsg(nil, ZhString.Gem_SmeltNoTargetCellTip)
    return
  end
  if self.isSmelting then
    return
  end
  self.targetSelectGO:SetActive(false)
  self.materialSelectGO:SetActive(true)
  local data = cellCtl.data
  TableUtility.ArrayRemoveByPredicate(self.selectedMaterialData, function(item)
    return BagItemCell.CheckData(data) and data.id == item.id
  end)
  self:UpdateSelectedMaterial()
  self:UpdateMaterialSelectList(true)
end

function GemSmeltView:OnClickMultiSmeltCell(cellCtl)
  if not self.targetGemStaticId then
    MsgManager.FloatMsg(nil, ZhString.Gem_SmeltNoTargetCellTip)
    return
  end
  if self.isSmelting then
    return
  end
  self.targetSelectGO:SetActive(false)
  self.materialSelectGO:SetActive(true)
  local index = cellCtl.indexInTable
  if index then
    self.multiSmeltMaterialData[index] = nil
  else
    LogUtility.Error("Cannot get indexInTable of GemCell")
    return
  end
  self.chooseMultiSmeltCellIndex = index
  self.multiSmeltMaterialData[index] = nil
  self:UpdateMultiSmeltMaterial()
  self:UpdateMaterialSelectList(true)
  cellCtl.chooseSymbol:SetActive(true)
end

function GemSmeltView:OnClickMaterialSelectCell(cellCtl)
  if self.isSmelting then
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
  for _, cell in pairs(self.materialSelectCells) do
    cell:SetChoose(data and data.id or 0)
  end
  if data.staticData.id == self.targetGemStaticId then
    MsgManager.ConfirmMsgByID(36012, function()
      self:_OnClickMaterialSelectCell(cellCtl)
    end)
  else
    self:_OnClickMaterialSelectCell(cellCtl)
  end
end

function GemSmeltView:_OnClickMaterialSelectCell(cellCtl)
  local data = cellCtl.data
  if data.num > cellCtl.selectedCount then
    local cloneData = data:Clone()
    cloneData:SetItemNum(1)
    cloneData.gemSkillData = data.gemSkillData
    if self.multiSmelt3GO.activeSelf and self.chooseMultiSmeltCellIndex then
      self.multiSmeltMaterialData[self.chooseMultiSmeltCellIndex] = cloneData
      self:UpdateMultiSmeltMaterial()
      self:UpdateMaterialSelectList(true)
      self:SetMultiSmeltCellChooseToFirstEmpty()
    elseif #self.selectedMaterialData < self.maxMaterialCount then
      TableUtility.ArrayPushBack(self.selectedMaterialData, cloneData)
      self:UpdateSelectedMaterial()
      self:UpdateMaterialSelectList(true)
    end
  end
  cellCtl:TryClearNewTag()
end

function GemSmeltView:OnLongPressMaterialSelectCell(param)
  local isPressing, cellCtl = param[1], param[2]
  if isPressing and cellCtl then
    self:ShowGemTip(cellCtl.gameObject, cellCtl.data)
    self.isClickOnListCtrlDisabled = true
  end
end

function GemSmeltView:OnGemUpdate()
  if self.multiSmelt3GO.activeSelf then
    local data, realData
    for i = 1, self:GetMaxMultiSmeltCellCount() do
      data = self.multiSmeltMaterialData[i]
      if data then
        realData = BagProxy.Instance:GetItemByGuid(data.id, SceneItem_pb.EPACKTYPE_GEM_SKILL)
        if not realData or GemProxy.CheckIsFavorite(realData) then
          self.multiSmeltMaterialData[i] = nil
        end
      end
    end
    TableUtility.TableClear(tempTable)
    for i = 1, self:GetMaxMultiSmeltCellCount() do
      data = self.multiSmeltMaterialData[i]
      if data then
        TableUtility.ArrayPushBack(tempTable, data)
      end
    end
    TableUtility.TableClear(self.multiSmeltMaterialData)
    TableUtility.ArrayShallowCopy(self.multiSmeltMaterialData, tempTable)
    self:UpdateMultiSmeltMaterial()
    self:SetMultiSmeltCellChooseToFirstEmpty()
  else
    TableUtility.ArrayClear(self.selectedMaterialData)
    self:UpdateSelectedMaterial()
  end
  self:UpdateMaterialSelectList()
end

function GemSmeltView:OnGemDataUpdate(note)
  TipManager.CloseTip()
  self.exhibitTip:SetActive(false)
  gemProxyIns:ShowNewGemResults(note.body and note.body.items)
end

function GemSmeltView:OnGemDelete(cellCtl)
  if self.multiSmelt3GO.activeSelf then
    TableUtility.TableRemoveByPredicate(self.multiSmeltMaterialData, function(index, item)
      return not cellCtl:CheckDataIsNilOrEmpty() and cellCtl.data.id == item.id
    end)
    self:UpdateMultiSmeltMaterial()
    self:UpdateMaterialSelectList(true)
    if self.chooseMultiSmeltCellIndex then
      self:SetMultiSmeltCellChoose(self.chooseMultiSmeltCellIndex)
    else
      self:SetMultiSmeltCellChooseToFirstEmpty()
    end
  else
    self:OnClickMaterialCell(cellCtl)
  end
end

function GemSmeltView:SetItemToSmelt(data)
  self.mainLabel.text = data == nil and ZhString.Gem_SmeltTipWithoutTarget or ZhString.Gem_SmeltTipWithTarget
  self:SetSmeltBtnActive(data ~= nil)
  local oldTargetGemStaticId = self.targetGemStaticId
  self:SetTargetCellData(data)
  if not data then
    return
  end
  if self.targetGemStaticId ~= oldTargetGemStaticId then
    TableUtility.ArrayClear(self.selectedMaterialData)
    self:UpdateSelectedMaterial()
    TableUtility.TableClear(self.multiSmeltMaterialData)
    self:UpdateMultiSmeltMaterial()
  end
end

local clickDisablePredicate = function(gemCell, self)
  if GemProxy.CheckIsFavorite(gemCell.data) then
    return true
  end
  if gemCell.selectedCount > 0 then
    return false
  end
  local isDifferentGroup = gemCell.data and self.targetGemStaticId and gemProxyIns:GetSkillQualityGroupFromItemData(gemCell.data) ~= gemProxyIns:GetSkillQualityGroupByStaticId(self.targetGemStaticId)
  return isDifferentGroup
end

function GemSmeltView:SwitchMultiSmelt(isActive)
  isActive = isActive or false
  self.multiSmelt3GO:SetActive(isActive)
  self.material3GO:SetActive(not isActive)
  if isActive then
    for _, cell in pairs(self.materialSelectCells) do
      cell:SetMultiSelectModel(self.multiSmeltMaterialData)
      cell:SetClickDisablePredicate(clickDisablePredicate, self)
    end
    TableUtility.TableClear(self.multiSmeltMaterialData)
    for i = 1, self.maxMaterialCount do
      self.multiSmeltMaterialData[i] = self.selectedMaterialData[i]
    end
    self:UpdateMultiSmeltMaterial()
    self:SetMultiSmeltCellChooseToFirstEmpty()
    TableUtility.ArrayClear(self.selectedMaterialData)
  else
    self:SetCost(GameConfig.Gem.SmeltCostZeny)
    for _, cell in pairs(self.materialSelectCells) do
      cell:SetMultiSelectModel(self.selectedMaterialData)
      cell:SetClickDisablePredicate(clickDisablePredicate, self)
    end
    TableUtility.ArrayClear(self.selectedMaterialData)
    for i = 1, self.maxMaterialCount do
      if self.multiSmeltMaterialData[i] then
        TableUtility.ArrayPushBack(self.selectedMaterialData, self.multiSmeltMaterialData[i])
      end
    end
    self:UpdateSelectedMaterial()
    TableUtility.TableClear(self.multiSmeltMaterialData)
  end
  self:UpdateMaterialSelectList()
end

local targetSelectComparer = function(l, r)
  if l.Quality ~= r.Quality then
    return l.Quality > r.Quality
  end
  return l.id < r.id
end

function GemSmeltView:UpdateTargetSelectList()
  if not self.targetSelectGO.activeInHierarchy then
    return
  end
  local staticDataArr = ReusableTable.CreateArray()
  local p = self.curSkillProfessionFilterPopData
  local isProfessionFilterExist = p and type(p) == "table" and next(p)
  for _, data in pairs(Table_GemRate) do
    if TableUtility.ArrayFindIndex(qualitiesToShow, data.Quality) > 0 and (not isProfessionFilterExist or gemProxyIns:CheckIfSkillGemHasSameProfessions(data.id, p)) then
      TableUtility.ArrayPushBack(staticDataArr, data)
    end
  end
  table.sort(staticDataArr, targetSelectComparer)
  self.targetSelectCtrl:ResetDatas(staticDataArr, true)
  ReusableTable.DestroyAndClearArray(staticDataArr)
end

local comparer = function(l, r)
  local comp1 = GemProxy.PredicateComparer(l, r, GemProxy.CheckIsFavorite)
  if comp1 ~= nil then
    return comp1
  end
  return GemProxy.BasicComparer(l, r)
end

function GemSmeltView:UpdateMaterialSelectList(noResetPos)
  if not self.materialSelectGO.activeInHierarchy then
    return
  end
  if not self.targetGemStaticId then
    LogUtility.Error("Cannot get materials when targetGem is nil")
    self.materialSelectGO:SetActive(false)
    return
  end
  local gems = GemProxy.GetSkillItemDataByQualityAndProfession(qualitiesToShow, Table_GemRate[self.targetGemStaticId].ClassType)
  GemProxy.RemoveEmbedded(gems)
  table.sort(gems, comparer)
  self.materialSelectCtrl:ResetDatas(gems, not noResetPos)
end

function GemSmeltView:UpdateSelectedMaterial()
  TipManager.CloseTip()
  self.exhibitTip:SetActive(false)
  TableUtility.TableClear(tempTable)
  TableUtility.ArrayShallowCopy(tempTable, self.selectedMaterialData)
  for i = #self.selectedMaterialData + 1, self.maxMaterialCount do
    TableUtility.ArrayPushBack(tempTable, BagItemEmptyType.Empty)
  end
  self.materialCombineCell:SetData(tempTable)
  local cells = self.materialCombineCell:GetCells()
  for _, cell in pairs(cells) do
    cell:SetShowNewTag(false)
    if not cell:CheckDataIsNilOrEmpty() then
      cell:ForceShowDeleteIcon()
    end
  end
  self:CheckSmeltReady()
end

function GemSmeltView:UpdateMultiSmeltMaterial()
  TipManager.CloseTip()
  self.exhibitTip:SetActive(false)
  self.multiSmeltListCtrl:ResetDatas(self:ReUnitMultiSmeltData())
  local combineCells = self.multiSmeltListCtrl:GetCells()
  for _, combineCell in pairs(combineCells) do
    combineCell:SetShowNewTag(false)
    combineCell:SetCheckTipEnablePredicate(GemProxy.CheckComposeDataGroup)
    combineCell:ForceShowDeleteIcon()
  end
  self:CheckSmeltReady()
end

function GemSmeltView:CheckSmeltReady()
  local isReady, rowCount = false
  if self.multiSmelt3GO.activeSelf then
    local multiSmeltListCells = self.multiSmeltListCtrl:GetCells()
    for _, cell in pairs(multiSmeltListCells) do
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
  end
  self:SetSmeltBtnActive(isReady)
  rowCount = rowCount or isReady and 1 or 0
  self:SetCost(GameConfig.Gem.SmeltCostZeny * rowCount)
end

function GemSmeltView:TrySmelt()
  if not self.isSmeltBtnActive then
    return
  end
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

function GemSmeltView:_Smelt()
  GemProxy.CallSmelt(self.targetGemStaticId, self.multiSmelt3GO.activeSelf and self.multiSmeltMaterialData or self.selectedMaterialData)
  self.isSmelting = nil
end

function GemSmeltView:TryPlayEffectThenCall(func)
  self.isSmelting = true
  local delayedTime = 1000
  if LocalSaveProxy.Instance:GetSkipAnimation(SKIPTYPE.GemFunction) then
    func(self)
  else
    if self.foreEffect then
      self.foreEffect:Stop()
    end
    local actionName = "ronghe_2"
    self:PlayUIEffect(EffectMap.UI.GemViewSynthetic, self.effectContainer, true, function(obj, args, assetEffect)
      self.foreEffect = assetEffect
      self.foreEffect:ResetAction(actionName, 0, true)
    end)
    if self.backEffect then
      self.backEffect:ResetAction(actionName, 0, true)
    end
    delayedTime = 4000
    TimeTickManager.Me():CreateOnceDelayTick(delayedTime, func, self, 1)
  end
  self:SetSmeltBtnActive(false)
  TimeTickManager.Me():CreateOnceDelayTick(delayedTime + 800, self.CheckSmeltReady, self, 2)
end

function GemSmeltView:GetMultiSmeltCell(index)
  index = index or 0
  local row, col = GemProxy.GetRowAndColFromIndexAndColumnCount(index, self.maxMaterialCount)
  local combineCells = self.multiSmeltListCtrl:GetCells()
  if combineCells and combineCells[row] then
    return combineCells[row]:GetCell(col)
  end
end

function GemSmeltView:SetMultiSmeltCellChoose(newIndex)
  if not self.multiSmelt3GO.activeSelf then
    return
  end
  self.chooseMultiSmeltCellIndex = newIndex
  local newChooseCell = self:GetMultiSmeltCell(self.chooseMultiSmeltCellIndex)
  if newChooseCell then
    newChooseCell.chooseSymbol:SetActive(true)
  else
    self.chooseMultiSmeltCellIndex = nil
  end
end

function GemSmeltView:SetMultiSmeltCellChooseToFirstEmpty()
  if not self.multiSmelt3GO.activeSelf then
    return
  end
  local newIndex
  for i = 1, self:GetMaxMultiSmeltCellCount() do
    if not self.multiSmeltMaterialData[i] then
      newIndex = i
      break
    end
  end
  if newIndex then
    local row, col = GemProxy.GetRowAndColFromIndexAndColumnCount(newIndex, self.maxMaterialCount)
    self.multiSmeltScrollView:SetDragAmount(0, math.clamp((row - 3) / (GemProxy.MultiComposeRowCount - 3), 0, 1), false)
  end
  self:SetMultiSmeltCellChoose(newIndex)
end

function GemSmeltView:ShowGemTip(cellGO, data)
  local tip = GemCell.ShowGemTip(cellGO, data, self.normalStick)
  if not tip then
    return
  end
  tip:AddIgnoreBounds(self.materialContainer)
end

function GemSmeltView:ReUnitMultiSmeltData()
  TableUtility.TableClear(tempTable)
  for i = 1, GemProxy.MultiComposeRowCount do
    for j = 1, self.maxMaterialCount do
      tempTable[i] = tempTable[i] or {}
      tempTable[i][j] = self.multiSmeltMaterialData[self.maxMaterialCount * (i - 1) + j] or BagItemEmptyType.Empty
    end
  end
  return tempTable
end

function GemSmeltView:SetTargetCellData(data)
  self.targetCell:SetActive(data ~= nil)
  self.targetGemStaticId = data and data.id
  local itemStaticData = data and Table_Item[data.id]
  self.gemLabel.text = data and itemStaticData and itemStaticData.NameZh or ""
  if not data then
    return
  end
  local success = IconManager:SetItemIcon(itemStaticData.Icon, self.targetCellSp)
  if success then
    self.targetCellSp:MakePixelPerfect()
  end
  success = IconManager:SetUIIcon(GemCell.SkillBgSpriteNames[data.Quality] or GemCell.AttrBgSpriteName, self.targetCellBgSp)
  if success then
    self.targetCellBgSp:MakePixelPerfect()
  end
  self.targetCellQualitySp.spriteName = GemCell.SkillQualitySpriteNames[data.Quality]
  self.targetCellNameLabel.text = string.sub(itemStaticData.NameZh, 1, 6)
end

function GemSmeltView:SetSmeltBtnActive(isActive)
  isActive = isActive and true or false
  self.isSmeltBtnActive = isActive
  self.smeltBtnBgSp.spriteName = isActive and "com_btn_1" or "com_btn_13"
  self.smeltBtnLabel.effectColor = isActive and ColorUtil.ButtonLabelBlue or ColorUtil.NGUIGray
end

function GemSmeltView:SetCost(cost)
  if type(cost) ~= "number" then
    LogUtility.Error("Invalid argument while calling SetCost!")
    return
  end
  self.cost = cost
  self.costLabel.text = StringUtil.NumThousandFormat(cost)
  self:UpdateCostLabelColor()
end

function GemSmeltView:UpdateCostLabelColor()
  self.costLabel.color = not self:CheckZeny() and ColorUtil.Red or costLabelColor
end

function GemSmeltView:CheckZeny()
  return MyselfProxy.Instance:GetROB() >= (self.cost or math.huge)
end

function GemSmeltView:GetMaxMultiSmeltCellCount()
  return GemProxy.GetMaxMultiFunctionCellCount(self.maxMaterialCount)
end
