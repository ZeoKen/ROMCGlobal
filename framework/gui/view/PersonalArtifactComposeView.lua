autoImport("PersonalArtifactFormulaFatherCell")
PersonalArtifactComposeView = class("PersonalArtifactComposeView", BaseView)
PersonalArtifactComposeView.ViewType = UIViewType.NormalLayer
local artifactIns, bagIns

function PersonalArtifactComposeView:Init()
  if not artifactIns then
    artifactIns = PersonalArtifactProxy.Instance
    bagIns = BagProxy.Instance
  end
  self:InitLeft()
  self:InitRight()
  self:RegistShowGeneralHelpByHelpID(35043, self:FindGO("HelpButton"))
  self:AddEvents()
  self.tipData = {
    funcConfig = _EmptyTable,
    hideGetPath = true
  }
end

function PersonalArtifactComposeView:InitLeft()
  self.formulaTable = self:FindComponent("FormulaTable", UITable)
  self.formulaListCtl = ListCtrl.new(self.formulaTable, PersonalArtifactFormulaFatherCell, "PersonalArtifactFormulaFatherCell")
  self.formulaListCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickFormula, self)
  self.formulaListCtl:AddEventListener(EquipChooseCellEvent.ClickItemIcon, self.OnClickFormulaIcon, self)
  self.formulaListCells = self.formulaListCtl:GetCells()
  self.normalStick = self:FindComponent("NormalStick", UIWidget)
end

function PersonalArtifactComposeView:InitRight()
  self.skipBtnSp = self:FindComponent("SkipBtn", UISprite)
  self:InitCells()
  self.effectContainer = self:FindGO("EffectContainer")
  self.costItemSp = self:FindComponent("CostItem", UISprite)
  self.costLabel = self:FindComponent("CostLabel", UILabel)
end

function PersonalArtifactComposeView:InitCells()
  local targetCellParent = self:FindGO("TargetCell")
  local targetC = self:LoadPreferb("cell/BagItemCell", targetCellParent)
  self.targetCell = BagItemCell.new(targetC)
  self.targetCell:GetBgSprite()
  self.targetCell:SetData(BagItemEmptyType.Empty)
  self:AddClickEvent(targetCellParent, function()
    local data = self.targetItemData
    if not BagItemCell.CheckData(data) then
      return
    end
    self:ShowItemTip(data)
  end)
  self.materialCells = {}
  local go, itemCell
  for i = 1, 6 do
    go = self:FindGO("MaterialCell" .. i)
    itemCell = self:LoadPreferb("cell/BagItemCell", go)
    self.materialCells[i] = BagItemCell.new(itemCell)
    self.materialCells[i]:SetData(BagItemEmptyType.Empty)
    self.materialCells[i]:HideNum()
    self:AddClickEvent(go, function()
      self:OnClickMaterialCell(i)
    end)
  end
end

local skipTipOffset = {90, -75}

function PersonalArtifactComposeView:AddEvents()
  self:AddButtonEvent("SkipBtn", function()
    TipManager.Instance:ShowSkipAnimationTip(SKIPTYPE.PersonalArtifactCompose, self.skipBtnSp, NGUIUtil.AnchorSide.Right, skipTipOffset)
  end)
  self:AddButtonEvent("ComposeBtn", function()
    if self.isComposing then
      return
    end
    if not FunctionUnLockFunc.Me():CheckCanOpen(GameConfig.SystemOpen_MenuId.PersonalArtifactAttr) then
      MsgManager.ShowMsgByID(41404)
      return
    end
    if not BagItemCell.CheckData(self.targetItemData) then
      MsgManager.FloatMsg("", ZhString.PersonalArtifact_NoFormulaTip)
      return
    end
    if not self:CheckMaterials() then
      MsgManager.ShowMsgByID(41338)
      return
    end
    if not self:CheckCostItem() then
      MsgManager.ShowMsgByIDTable(25418, self.costItemId and Table_Item[self.costItemId].NameZh)
      return
    end
    if bagIns:CheckBagIsFull(BagProxy.BagType.PersonalArtifact) then
      MsgManager.ShowMsgByID(41339)
      return
    end
    local items = ReusableTable.CreateArray()
    local materialData, datas, cost, cloneData = self:_GetMaterialDataFromTargetFormulaData()
    for i = 1, #materialData do
      datas, cost = self:_GetMaterialsByIndexOfTargetFormulaData(i), materialData[i][2]
      cloneData = datas[1]:Clone()
      cloneData:SetItemNum(cost)
      TableUtility.ArrayPushBack(items, cloneData)
    end
    self:TryPlayEffectThenCall(function(self)
      PersonalArtifactProxy.CallCompose(self.targetItemData.staticData.id, items)
      ReusableTable.DestroyAndClearArray(items)
      self.isComposing = nil
    end)
  end)
  self:AddListenEvt(MyselfEvent.ZenyChange, self.UpdateCostLabelColor)
  self:AddListenEvt(ItemEvent.PersonalArtifactUpdate, self.OnPersonalArtifactUpdate)
  self:AddListenEvt(ServiceUserProxy.RecvLogin, self.CloseSelf)
end

function PersonalArtifactComposeView:OnEnter()
  PersonalArtifactComposeView.super.OnEnter(self)
  self:UpdateFormulaList()
  if #self.formulaListCells > 0 then
    local childCells = self.formulaListCells[1].childCells
    if childCells and 0 < #childCells then
      self:OnClickFormula(childCells[1])
    end
  end
end

function PersonalArtifactComposeView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  PersonalArtifactComposeView.super.OnExit(self)
end

function PersonalArtifactComposeView:OnClickFormula(cell)
  if self.lastClickedFormulaCell then
    self.lastClickedFormulaCell:SetChoose(false)
  end
  if not cell then
    return
  end
  cell:SetChoose(true)
  self.lastClickedFormulaCell = cell
  self:UpdateTargetCell(cell.data)
end

function PersonalArtifactComposeView:OnClickFormulaIcon(data)
  self:ShowItemTip(data)
end

function PersonalArtifactComposeView:OnClickMaterialCell(index)
  if not BagItemCell.CheckData(self.targetItemData) then
    return
  end
  local cell = self.materialCells[index]
  if not cell or not BagItemCell.CheckData(cell.data) then
    return
  end
  self.chooseMaterialCellIndex = index
  local data = self.materialCells[index].data
  if BagItemCell.CheckData(data) then
    local mats = self:_GetMaterialsByIndexOfTargetFormulaData(index)
    self:ShowItemTip(0 < #mats and mats[1] or data.staticData.id)
  end
end

function PersonalArtifactComposeView:OnPersonalArtifactUpdate()
  self:UpdateTargetCell(self.targetItemData and self.targetItemData.staticData.id)
  self:UpdateFormulaList()
end

function PersonalArtifactComposeView:UpdateFormulaList()
  self.formulaListCtl:ResetDatas(artifactIns:GetAllFormulaItemIds())
  self.lastClickedFormulaCell = nil
end

function PersonalArtifactComposeView:UpdateTargetCell(itemId)
  TipManager.CloseTip()
  if not itemId then
    LogUtility.Warning("Cannot get item id when updating targetcell!")
    return
  end
  self.targetItemData = self.targetItemData or ItemData.new()
  self.targetItemData:ResetData("target", itemId)
  self.targetCell:SetData(self.targetItemData)
  self.targetCell:SetItemQualityBG(self.targetItemData.staticData.Quality)
  self.targetFormulaData = Table_PersonalArtifactCompose[itemId]
  self.costItemId, self.cost = self:_GetCostDataFromTargetFormulaData()
  if self.costItemId then
    IconManager:SetItemIcon(Table_Item[self.costItemId].Icon, self.costItemSp)
  end
  self.costLabel.text = tostring(self.cost)
  self:UpdateMaterialCells()
end

function PersonalArtifactComposeView:UpdateMaterialCells()
  local materialData, cell = self:_GetMaterialDataFromTargetFormulaData(), true
  for i = 1, #materialData do
    cell = self.materialCells[i]
    if type(cell.data) == "table" then
      cell.data:ResetData("material", materialData[i][1])
      cell:SetData(cell.data)
    else
      cell:SetData(ItemData.new("material", materialData[i][1]))
    end
    self.materialCells[i]:SetIconGrey(not self:_CheckMaterial(i))
  end
  for i = #materialData + 1, 6 do
    self.materialCells[i]:SetData(BagItemEmptyType.Empty)
  end
  if Table_Item[self.costItemId] then
    IconManager:SetItemIcon(Table_Item[self.costItemId].Icon, self.costItemSp)
  end
  self:UpdateCostLabelColor()
end

function PersonalArtifactComposeView:CheckMaterials()
  local materialData, rslt = self:_GetMaterialDataFromTargetFormulaData(), true
  for i = 1, #materialData do
    rslt = rslt and self:_CheckMaterial(i)
  end
  return rslt
end

function PersonalArtifactComposeView:_CheckMaterial(index)
  local datas = self:_GetMaterialsByIndexOfTargetFormulaData(index)
  if #datas == 0 then
    return false
  end
  local sum = 0
  for i = 1, #datas do
    sum = sum + (datas[i].num or 0)
  end
  return sum >= self:_GetMaterialDataFromTargetFormulaData()[index][2]
end

function PersonalArtifactComposeView:CheckCostItem()
  if not self.costItemId then
    LogUtility.Warning("Cannot get id of cost item while checking")
    return false
  end
  return HappyShopProxy.Instance:GetItemNum(self.costItemId) >= (self.cost or math.huge)
end

function PersonalArtifactComposeView:TryPlayEffectThenCall(func)
  self.isComposing = true
  if LocalSaveProxy.Instance:GetSkipAnimation(SKIPTYPE.PersonalArtifactCompose) then
    func(self)
  else
    TimeTickManager.Me():CreateOnceDelayTick(4000, func, self)
  end
end

local tryAddFakeDataToItemData = function(item)
  if not item:IsPersonalArtifact() then
    return
  end
  item.personalArtifactData = PersonalArtifactData.new(item.staticData.id)
  if item.personalArtifactData.isInited then
    item.personalArtifactData:SetFakeData()
  end
end
local tipOffset = {0, 0}

function PersonalArtifactComposeView:ShowItemTip(data, isPersonalArtifact)
  if not self.fakeItemData then
    self.fakeItemData = ItemData.new()
  end
  if type(data) == "number" then
    self.fakeItemData:ResetData("TipData", data)
  elseif type(data) == "table" then
    self.fakeItemData:ResetData("TipData", data.staticData.id)
  else
    TipManager.CloseTip()
    return
  end
  tryAddFakeDataToItemData(self.fakeItemData)
  self.tipData.itemdata = self.fakeItemData
  tipOffset[1] = isPersonalArtifact and 190 or -80
  local tip = TipManager.Instance:ShowItemFloatTip(self.tipData, self.normalStick, NGUIUtil.AnchorSide.Right, tipOffset)
  if isPersonalArtifact then
    tip:AddIgnoreBounds(self.formulaTable)
  else
    for i = 1, #self.materialCells do
      tip:AddIgnoreBounds(self.materialCells[i].gameObject)
    end
    tip:AddIgnoreBounds(self.targetCell.gameObject)
  end
end

local costLabelColor = LuaColor.New(0.37254901960784315, 0.37254901960784315, 0.37254901960784315, 1)

function PersonalArtifactComposeView:UpdateCostLabelColor()
  self.costLabel.color = not self:CheckCostItem() and ColorUtil.Red or costLabelColor
end

function PersonalArtifactComposeView:_GetMaterialDataFromTargetFormulaData()
  return self.targetFormulaData and self.targetFormulaData.CostFlagments
end

function PersonalArtifactComposeView:_GetCostDataFromTargetFormulaData()
  if not self.targetFormulaData then
    LogUtility.Error("Cannot get formula data when updating targetcell!")
    return
  end
  local costData = self.targetFormulaData.CostItems[1]
  if costData then
    return costData[1], costData[2]
  else
    return
  end
end

function PersonalArtifactComposeView:_GetMaterialsByIndexOfTargetFormulaData(index)
  local materialData = self:_GetMaterialDataFromTargetFormulaData()
  if not materialData or index > #materialData then
    LogUtilty.ErrorFormat("Cannot get material data when index = {0}", index)
    return _EmptyTable
  end
  return PersonalArtifactProxy.GetFragmentItemDatasByStaticId(materialData[index][1])
end
