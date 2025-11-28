autoImport("EquipNewChooseBord")
autoImport("MaterialItemNewCell")
autoImport("AncientRandomAttrCell")
AncientRandomBord = class("AncientRandomBord", CoreView)
AncientRandomBord_Event = {
  ClickTargetCell = "AncientRandomBord_Event_ClickTargetCell",
  DoRefine = "AncientRandomBord_Event_DoRefine"
}
local DEFAULT_MATERIAL_SEARCH_BAGTYPES, REFINE_MATERIAL_SEARCH_BAGTYPES, REPAIR_MATERIAL_SEARCH_BAGTYPES, LOTTERY_REPAIR_MATERIAL_CFG, EQUIP_REPAIR_MATERIAL_CFG
local itemTipOffset, tempTable, tempArr = {-370, 0}, {}, {}
local resultTickId = 788

function AncientRandomBord:ctor(go)
  AncientRandomBord.super.ctor(self, go)
  if not DEFAULT_MATERIAL_SEARCH_BAGTYPES then
    DEFAULT_MATERIAL_SEARCH_BAGTYPES = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.default or {1, 9}
    REFINE_MATERIAL_SEARCH_BAGTYPES = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.refine or DEFAULT_MATERIAL_SEARCH_BAGTYPES
  end
  self:Init()
end

function AncientRandomBord:Init()
  self:InitData()
  self:InitBord()
  self:InitChooseBords()
  ServiceItemProxy.Instance:CallQueryLotteryHeadItemCmd()
end

function AncientRandomBord:InitData()
  self.maxRefineLv = 0
  self.refine_MaterialIsFull = false
  self.refine_cost_Rob = 0
  self.refine_lackMats = {}
  self.islottery = false
  self.refine_npcguid = nil
  self.safeRefine_selectEquipIds = {}
end

function AncientRandomBord:InitBord()
  self.tipStick = self:FindComponent("TipStick", UIWidget)
  self.emptyBord = self:FindGO("EmptyBord")
  self.effContainerRq = self:FindComponent("EffectContainer", ChangeRqByTex)
  self.itemName = self:FindComponent("ItemName", UILabel)
  local targetCellGO = self:FindGO("TargetCell")
  self:AddClickEvent(targetCellGO, function()
    self:ClickTargetCell()
  end)
  self.targetCellContent = self:FindGO("TargetCellContent")
  self.targetAddIcon = self:FindGO("AddIcon", targetCellGO)
  self.targetCellIcon = self:FindComponent("Icon", UISprite, self.targetCellContent)
  self.refineBord = self:FindGO("RefineBord")
  self.refineAttr = self:FindGO("RefineAttr", self.refineBord)
  self.attrTable = self:FindComponent("AttrTable", UIGrid, self.refineAttr)
  self.attrListctrl = UIGridListCtrl.new(self.attrTable, AncientRandomAttrCell, "AncientRandomAttrCell")
  self.attrListctrl:AddEventListener(MouseEvent.MouseClick, self.OnClickAncientRandomAttrCell, self)
  self.refineUnFull = self:FindGO("RefineUnFull", self.refineBord)
  self.refineMatLabel = self:FindGO("RefineMatLabel", self.refineBord)
  self.refineMatCtl = ListCtrl.new(self:FindComponent("RefineMatGrid", UIGrid), MaterialItemNewCell, "MaterialItemNewCell")
  self.refineMatCtl:AddEventListener(MouseEvent.MouseClick, self.ClickRefineMatItem, self)
  self.refineTipCt = self:FindGO("RefineTipCt", self.refineBord)
  if self.refineTipCt then
    self.refineModelTip = self:FindComponent("RefineModelTip", UILabel, self.refineTipCt)
  end
  self.refineFull = self:FindGO("RefineFull", self.refineBord)
  self.refineFull_label = self.refineFull:GetComponent(UILabel)
  self.refineCtrls = self:FindGO("RefineCtrls")
  self.refineButton = self:FindGO("RefineBtn", self.refineBord)
  self:AddClickEvent(self.refineButton, function()
    self:ClickRefine()
  end)
  self.priceNumLabel = self:FindComponent("PriceNum", UILabel)
end

function AncientRandomBord:ClickTargetCell()
  TipManager.CloseTip()
  self:SetTargetItem()
  if self.chooseBord then
    self.chooseBord:Hide()
  end
  if not self.itemData then
    self.materialchooseBord:Hide()
  end
  self:PassEvent(AncientRandomBord_Event.ClickTargetCell, self)
end

function AncientRandomBord:ClickRefineMatItem(cellctl)
  if cellctl and cellctl.data then
    if cellctl.data.id == MaterialItemCell.MaterialType.Material then
      self:ShowItemInfoTip(cellctl)
    else
      self:ShowChooseRefineMaterialBord()
    end
  end
end

function AncientRandomBord:ShowItemInfoTip(cell)
  if not self.ShowTip then
    if not self.tipdata then
      self.tipdata = {
        callback = function()
          self.ShowTip = false
        end
      }
    end
    self.tipdata.itemdata = cell.data
    self.tipdata.ignoreBounds = cell.gameObject
    self:ShowItemTip(self.tipdata, self.tipStick, NGUIUtil.AnchorSide.Left, itemTipOffset)
  else
    self:ShowItemTip()
  end
end

function AncientRandomBord:ShowChooseRefineMaterialBord()
  local nowData = self.itemData
  if nowData == nil then
    return
  end
  local datas = BlackSmithProxy.Instance:GetMaterialEquips_ByVID(nowData, REFINE_MATERIAL_SEARCH_BAGTYPES, nil, nil, nil, true)
  local refinelv = nowData.equipInfo.refinelv
  local costId, needNum = BlackSmithProxy.Instance:GetSafeRefineCostEquip(nowData, refinelv + 1, self.islottery)
  local ownNum = 0
  local matAllDatas = {}
  for i = 1, #datas do
    if datas[i].id == nowData.id then
      if 1 < datas[i].num then
        local cpyData = datas[i]:Clone()
        cpyData.num = cpyData.num - 1
        table.insert(matAllDatas, datas[i]:Clone())
        ownNum = ownNum + cpyData.num
      end
    else
      ownNum = ownNum + datas[i].num
      table.insert(matAllDatas, datas[i]:Clone())
    end
  end
  if needNum > ownNum and self:TryOpenQuickBuyView(costId, needNum - ownNum) then
    return
  end
  if self.materialchooseBord.gameObject.activeInHierarchy then
    self.materialchooseBord:Hide()
  else
    self.materialchooseBord:Show()
    self.materialchooseBord:ResetDatas(matAllDatas)
    self.materialchooseBord:SetUseItemNum(true)
    self.materialchooseBord:SetChooseReference(self.safeRefine_selectEquipIds)
  end
end

function AncientRandomBord:ClickRefine()
  local nowData = self.itemData
  if nowData then
    self:DoRefine(nowData)
  else
    MsgManager.ShowMsgByIDTable(216)
  end
end

function AncientRandomBord:DoRefine(nowData)
  local equipInfo = nowData.equipInfo
  if BagProxy.Instance:CheckBagIsFull(BagProxy.BagType.MainBag) then
    MsgManager.ShowMsgByIDTable(3101)
    return
  end
  if MyselfProxy.Instance:GetROB() < self.refine_cost_Rob then
    MsgManager.ShowMsgByIDTable(1)
    return
  end
  if #self.refine_lackMats > 0 and QuickBuyProxy.Instance:TryOpenView(self.refine_lackMats) then
    return
  end
  if not self.refine_MaterialIsFull then
    MsgManager.ShowMsgByIDTable(8)
    return
  end
  ServiceItemProxy.Instance:CallRefreshEquipAttrCmd(nowData.id, self.onSelectCell.data.id, self.onSelectFormula.id)
  self:PassEvent(AncientRandomBord_Event.DoRefine, self)
end

function AncientRandomBord:Refresh()
  local nowData = self.itemData
  local flag = nowData ~= nil
  self.targetCellContent:SetActive(flag)
  self.targetAddIcon:SetActive(not flag)
  self.itemName.gameObject:SetActive(flag)
  self.emptyBord:SetActive(not flag)
  self.materialchooseBord:Hide()
  if nowData ~= nil then
    local succ = IconManager:SetItemIcon(nowData.staticData.Icon, self.targetCellIcon)
    if not succ then
      IconManager:SetItemIcon("item_45001", self.targetCellIcon)
    end
    self.itemName.text = nowData:GetName(nil, true)
    self.islottery = LotteryProxy.Instance:IsLotteryEquip(nowData.staticData.id)
    self.refineBord:SetActive(true)
    self:UpdateRefineInfo()
  else
    self.refineBord:SetActive(false)
  end
end

function AncientRandomBord:UpdateRefineFullLabel()
  if not self.refineFull then
    return
  end
  self.refineFull:SetActive(false)
  self.refineUnFull:SetActive(true)
  self.refineCtrls:SetActive(true)
  if self.onSelectCell.valueMaxed or self.onSelectFormula == nil then
    self.refineUnFull:SetActive(false)
    self.refineCtrls:SetActive(false)
    self.refineFull:SetActive(true)
    self.refineFull_label.text = ZhString.AncientRandom_Maxed
  end
end

function AncientRandomBord:UpdateRefineTip()
  if not self.refineTipCt then
    return
  end
  local nowData = self.itemData
  if nowData == nil then
    self.refineTipCt.gameObject:SetActive(false)
    return
  end
  self.refineTipCt.gameObject:SetActive(true)
  local refinelv = nowData.equipInfo.refinelv
  if refinelv >= self.maxRefineLv then
    self.refineModelTip.text = ZhString.EquipRefineBord_RefineTip_Full
  else
    local isNormalMode = self.refineMode == EquipRefineBord_RefineMode.Normal
    local safeClamp_min, safeClamp_max = BlackSmithProxy.Instance:GetSafeRefineClamp(self.islottery, nowData.equipInfo)
    local temp = ZhString.EquipRefineBord_RefineTip_DefiniteSuccess
    if not BranchMgr.IsChina() then
      temp = ZhString.EquipRefineBord_RefineTip_DefiniteSuccess:gsub("%%", "%%%%")
    end
    self.refineModelTip.text = string.format(temp, safeClamp_min)
    if refinelv >= safeClamp_min - 1 and refinelv < safeClamp_max then
      if not self.forbiddenRefineMode then
        self.refineModelTip.text = isNormalMode and ZhString.EquipRefineBord_RefineTip_ChooseNormal or ZhString.EquipRefineBord_RefineTip_ChooseNormal2
      end
    elseif refinelv >= safeClamp_max then
      if isNormalMode then
        self.refineTipCt.gameObject:SetActive(false)
      elseif not self.forbiddenRefineMode then
        self.refineModelTip.text = ZhString.EquipRefineBord_RefineTip_ChooseNormal3
      end
    end
  end
end

function AncientRandomBord:UpdateRefineMaterials(refreshSelectedEquips)
  self.onSelectFormula = nil
  local nowData = self.itemData
  local nowCell = self.onSelectCell
  if nowData == nil or nowCell == nil then
    self.refineMatCtl:ResetDatas(_EmptyTable)
    return
  end
  self.onSelectFormula = self.onSelectCell.formula
  if self.onSelectCell.valueMaxed or self.onSelectFormula == nil then
    return
  end
  self.refine_MaterialIsFull = true
  TableUtility.ArrayClear(tempArr)
  local costItems = tempArr
  TableUtility.ArrayClear(self.refine_lackMats)
  self.refine_cost_Rob = 0
  local bcItems = self.onSelectFormula.Materials
  for i = 1, #bcItems do
    local data = bcItems[i]
    local r_id = data[1]
    local r_num = data[2]
    local bagNum = 0
    if r_id == 100 then
      self.refine_cost_Rob = r_num
      bagNum = MyselfProxy.Instance:GetROB()
    else
      local items = BagProxy.Instance:GetMaterialItems_ByItemId(r_id, REFINE_MATERIAL_SEARCH_BAGTYPES)
      for j = 1, #items do
        bagNum = bagNum + items[j].num
      end
    end
    local itemData = ItemData.new(MaterialItemCell.MaterialType.Material, r_id)
    itemData.num = bagNum
    itemData.neednum = r_num
    table.insert(costItems, itemData)
    if bagNum < itemData.neednum then
      table.insert(self.refine_lackMats, self:GetLackItem(r_id, itemData.neednum - bagNum))
      if self.refine_MaterialIsFull then
        self.refine_MaterialIsFull = false
      end
    end
  end
  self.refineMatCtl:ResetDatas(costItems)
  local aaa = nowData.equipInfo.randomEffectBaodi
  aaa = aaa and aaa[nowCell.data.id]
  aaa = aaa and aaa[self.onSelectFormula.id] or 0
  aaa = (self.onSelectFormula.Guarantee or 0) - aaa
  self.priceNumLabel.text = string.format(ZhString.AncientRandom_youcan, aaa)
end

function AncientRandomBord:UpdateRefineInfo()
  local nowData = self.itemData
  if nowData == nil then
    return
  end
  local equipInfo = nowData.equipInfo
  local list = equipInfo:GetRandomEffectList()
  if not list or not next(list) then
    self.attrListctrl:ResetDatas(_EmptyTable)
    return
  else
    for i = 1, #list do
      list[i].nowData = nowData
    end
    self.attrListctrl:ResetDatas(list)
    local cells = self.attrListctrl:GetCells()
    if self.onSelectCell == nil then
      self:OnClickAncientRandomAttrCell(cells[1])
    else
      self:OnClickAncientRandomAttrCell(self.onSelectCell)
    end
  end
  return
end

function AncientRandomBord:TryOpenQuickBuyView(id, count)
  local lackItem = self:GetUniqueTempLackItem(id, count)
  return QuickBuyProxy.Instance:TryOpenView(self:GetUniqueTempArrayWithElement(lackItem))
end

function AncientRandomBord:GetLackItem(id, count)
  return {id = id, count = count}
end

function AncientRandomBord:GetUniqueTempLackItem(id, count)
  TableUtility.TableClear(tempTable)
  tempTable.id = id
  tempTable.count = count
  return tempTable
end

function AncientRandomBord:GetUniqueTempArrayWithElement(element1, ...)
  TableUtility.ArrayClear(tempArr)
  if element1 == nil then
    return
  end
  local arrayPushBack = TableUtility.ArrayPushBack
  arrayPushBack(tempArr, element1)
  local element
  for i = 1, select("#", ...) do
    element = select(i, ...)
    arrayPushBack(tempArr, element)
  end
  return tempArr
end

function AncientRandomBord:InitChooseBords()
  local chooseContainer = self:FindGO("ChooseContainer")
  self.chooseBord = EquipNewChooseBord.new(chooseContainer)
  self.materialchooseBord = EquipNewCountChooseBord.new(chooseContainer)
  self.materialchooseBord:Hide()
  self.materialchooseBord:AddEventListener(EquipChooseCellEvent.CountChooseChange, self.OnCountChooseChange, self)
  self:HideAllChooseBord()
end

function AncientRandomBord:OnCountChooseChange(cell)
  if not cell then
    return
  end
  local data, chooseCount = cell.data, cell.chooseCount
  if data and chooseCount then
    local leftCount
    if self.safeRefine_selectEquipIds and self.safeRefineNeedNum then
      leftCount = self.safeRefineNeedNum
      for i = 1, #self.safeRefine_selectEquipIds do
        if self.safeRefine_selectEquipIds[i].id ~= data.id then
          leftCount = leftCount - self.safeRefine_selectEquipIds[i].num
        end
      end
    end
    if leftCount and chooseCount > leftCount then
      MsgManager.ShowMsgByIDTable(542)
      cell:SetChooseCount(leftCount)
      return
    end
    local matData, index
    for i = 1, #self.safeRefine_selectEquipIds do
      local d = self.safeRefine_selectEquipIds[i]
      if type(d) == "table" and d.id == data.id then
        matData = d
        index = i
        break
      end
    end
    if matData then
      if chooseCount == 0 then
        table.remove(self.safeRefine_selectEquipIds, index)
      else
        matData.num = chooseCount
      end
    elseif 0 < chooseCount then
      matData = data:Clone()
      matData.num = chooseCount
      table.insert(self.safeRefine_selectEquipIds, matData)
    end
  end
  self:UpdateRefineMaterials()
  self.materialchooseBord:SetChooseReference(self.safeRefine_selectEquipIds)
end

function AncientRandomBord:ShowChooseRefineMaterialBord()
  local nowData = self.itemData
  if nowData == nil then
    return
  end
  local datas = BlackSmithProxy.Instance:GetMaterialEquips_ByVID(nowData, REFINE_MATERIAL_SEARCH_BAGTYPES, nil, nil, nil, true)
  local refinelv = nowData.equipInfo.refinelv
  local costId, needNum = BlackSmithProxy.Instance:GetSafeRefineCostEquip(nowData, refinelv + 1, self.islottery)
  local ownNum = 0
  local matAllDatas = {}
  for i = 1, #datas do
    if datas[i].id == nowData.id then
      if 1 < datas[i].num then
        local cpyData = datas[i]:Clone()
        cpyData.num = cpyData.num - 1
        table.insert(matAllDatas, datas[i]:Clone())
        ownNum = ownNum + cpyData.num
      end
    else
      ownNum = ownNum + datas[i].num
      table.insert(matAllDatas, datas[i]:Clone())
    end
  end
  if needNum > ownNum and self:TryOpenQuickBuyView(costId, needNum - ownNum) then
    return
  end
  if self.materialchooseBord.gameObject.activeInHierarchy then
    self.materialchooseBord:Hide()
  else
    self.materialchooseBord:Show()
    self.materialchooseBord:ResetDatas(matAllDatas)
    self.materialchooseBord:SetUseItemNum(true)
    self.materialchooseBord:SetChooseReference(self.safeRefine_selectEquipIds)
  end
end

function AncientRandomBord:GetNowItemData()
  return self.itemData
end

function AncientRandomBord:SetTargetItem(itemData)
  self.itemData = itemData
  self.onSelectCell = nil
  self:Refresh()
end

function AncientRandomBord:SetNpcguid(npcguid)
  self.refine_npcguid = npcguid
end

function AncientRandomBord:SetMaxRefineLv(maxRefinelv)
  self.outset_maxrefine = maxRefinelv
end

function AncientRandomBord:HideAllChooseBord()
  self.chooseBord:Hide()
  self.materialchooseBord:Hide()
end

function AncientRandomBord:ShowTempResult(result)
  if not self.resultSuccess then
    self.resultSuccess = self:FindGO("Successful")
  end
  if not self.resultFailed then
    self.resultFailed = self:FindGO("Failed")
  end
  local resultCandidateTween_Success = self.resultSuccess:GetComponent(TweenAlpha)
  local resultCandidateTween_Failed = self.resultFailed:GetComponent(TweenAlpha)
  resultCandidateTween_Success:ResetToBeginning()
  resultCandidateTween_Failed:ResetToBeginning()
  self.resultSuccess:SetActive(false)
  self.resultFailed:SetActive(false)
  self.resultCandidate = result == true and self.resultSuccess or self.resultFailed
  self.resultCandidateTween = self.resultCandidate:GetComponent(TweenAlpha)
  if self.resultCandidate then
    TimeTickManager.Me():ClearTick(self, resultTickId)
    self.resultCandidate:SetActive(true)
    self.resultCandidateTween:PlayForward()
    TimeTickManager.Me():CreateOnceDelayTick(2000, function(self)
      self.resultCandidateTween:PlayReverse()
    end, self, resultTickId)
    self:PlayEffect()
  end
end

function AncientRandomBord:PlayEffect()
  self:PlayUIEffect(EffectMap.UI.ForgingSuccess_Old, self.effContainerRq.gameObject, true, self.ForgingSuccessEffectHandle, self)
end

function AncientRandomBord.ForgingSuccessEffectHandle(effectHandle, owner)
  if owner then
    owner.effContainerRq:AddChild(effectHandle.gameObject)
  end
end

function AncientRandomBord:OnExit()
  TimeTickManager.Me():ClearTick(self)
  if self.chooseBord and self.chooseBord.datas then
    for _, data in pairs(self.chooseBord.datas) do
      if data.isShowRedTip then
        data.isShowRedTip = nil
      end
    end
  end
end

function AncientRandomBord:OnEnter()
  self.onSelectCell = nil
  self:UpdateRefineMaterials(true)
end

function AncientRandomBord:OnClickAncientRandomAttrCell(cell)
  local cells = self.attrListctrl:GetCells()
  for i = 1, #cells do
    cells[i]:setIsSelected(false)
  end
  cell:setIsSelected(true)
  self.onSelectCell = cell
  self:UpdateRefineMaterials(true)
  self:UpdateRefineFullLabel()
  self:UpdateRefineTip()
end
