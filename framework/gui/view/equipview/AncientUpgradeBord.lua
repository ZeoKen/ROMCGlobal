autoImport("EquipNewChooseBord")
autoImport("MaterialItemNewCell")
autoImport("AncientUpgradeAttrCell")
AncientUpgradeBord = class("AncientUpgradeBord", CoreView)
AncientUpgradeBord_Event = {
  ClickTargetCell = "AncientUpgradeBord_Event_ClickTargetCell",
  DoRefine = "AncientUpgradeBord_Event_DoRefine"
}
local DEFAULT_MATERIAL_SEARCH_BAGTYPES, REFINE_MATERIAL_SEARCH_BAGTYPES, REPAIR_MATERIAL_SEARCH_BAGTYPES, LOTTERY_REPAIR_MATERIAL_CFG, EQUIP_REPAIR_MATERIAL_CFG
local itemTipOffset, tempTable, tempArr = {-370, 0}, {}, {}
local resultTickId = 788

function AncientUpgradeBord:ctor(go)
  AncientUpgradeBord.super.ctor(self, go)
  if not DEFAULT_MATERIAL_SEARCH_BAGTYPES then
    DEFAULT_MATERIAL_SEARCH_BAGTYPES = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.default or {1, 9}
    REFINE_MATERIAL_SEARCH_BAGTYPES = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.refine or DEFAULT_MATERIAL_SEARCH_BAGTYPES
  end
  self:Init()
end

function AncientUpgradeBord:Init()
  self:InitData()
  self:FindObjs()
  self:AddEvts()
  self:InitChooseBords()
  ServiceItemProxy.Instance:CallQueryLotteryHeadItemCmd()
end

function AncientUpgradeBord:InitData()
  self.refine_MaterialIsFull = false
  self.refine_cost_Rob = 0
  self.refine_lackMats = {}
  self.islottery = false
  self.refine_npcguid = nil
  self.safeRefine_selectEquipIds = {}
end

function AncientUpgradeBord:FindObjs()
  self.tipStick = self:FindComponent("TipStick", UIWidget)
  self.emptyBord = self:FindGO("EmptyBord")
  self.effContainerRq = self:FindComponent("EffectContainer", ChangeRqByTex)
  self.effectContainer = self:FindGO("EffectContainer")
  self.select1 = self:FindGO("select1")
  self.itemName = self:FindComponent("ItemName", UILabel)
  self.targetCellGO = self:FindGO("TargetCell", self.select1)
  self.targetCellContent = self:FindGO("TargetCellContent")
  self.targetAddIcon = self:FindGO("AddIcon", self.targetCellGO)
  self.targetCellIcon = self:FindComponent("Icon", UISprite, self.targetCellContent)
  self.refineBord = self:FindGO("RefineBord")
  self.refineAttr = self:FindGO("RefineAttr", self.refineBord)
  self.attrTable = self:FindComponent("AttrTable", UIGrid, self.refineAttr)
  self.attrListctrl = UIGridListCtrl.new(self.attrTable, AncientUpgradeAttrCell, "AncientUpgradeAttrCell")
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
  self.select2 = self:FindGO("select2")
  self.addItemInButton = self:FindGO("AddItemInButton", self.select2)
  self.addItemOutButton = self:FindGO("AddItemOutButton", self.select2)
  self.targetInGo = self:FindGO("TargetInCell", self.select2)
  self.targetOutGo = self:FindGO("TargetOutCell", self.select2)
  self.targetInCellIcon = self:FindComponent("ItemSprite", UISprite, self.targetInGo)
  self.targetOutCellIcon = self:FindComponent("ItemSprite", UISprite, self.targetOutGo)
end

function AncientUpgradeBord:AddEvts()
  self:AddClickEvent(self.targetCellGO, function()
    self:ClickTargetCell()
  end)
  self:AddClickEvent(self.targetInGo, function(go)
    self:ClickTargetCell()
  end)
  self:AddClickEvent(self.targetOutGo, function(go)
  end)
end

function AncientUpgradeBord:ClickTargetInItem()
  if self.clickDisabled then
    return
  end
  self.targetInData = nil
  self:UpdateMainBoard()
  self:ShowChooseBord(self:GetEnchantInChooseDatas(), true)
  self.chooseSymbol:SetActive(true)
  self.chooseSymbol.transform.position = self.addItemInButton.transform.position
end

function AncientUpgradeBord:ClickTargetOutItem()
  if self.clickDisabled then
    return
  end
  self.targetOutData = nil
  self:UpdateMainBoard()
  if not self.targetInData then
    return
  end
  self:ShowChooseBord(self:GetEnchantOutChooseDatas(), false)
  self.chooseSymbol:SetActive(true)
  self.chooseSymbol.transform.position = self.addItemOutButton.transform.position
end

function AncientUpgradeBord:ClickTargetCell()
  TipManager.CloseTip()
  self:SetTargetItem()
  if self.chooseBord then
    self.chooseBord:Hide()
  end
  if not self.itemData then
    self.materialchooseBord:Hide()
  end
  self:PassEvent(AncientUpgradeBord_Event.ClickTargetCell, self)
end

function AncientUpgradeBord:ClickRefineMatItem(cellctl)
  if cellctl and cellctl.data then
    if cellctl.data.id == MaterialItemCell.MaterialType.Material then
      self:ShowItemInfoTip(cellctl)
    else
      self:ShowChooseRefineMaterialBord()
    end
  end
end

function AncientUpgradeBord:UpdateMainBoard()
  local hasInData, hasOutData = self.targetInData ~= nil, self.targetOutData ~= nil
  self.addItemInButton:SetActive(not hasInData)
  self.addItemOutButton:SetActive(not hasOutData)
  self.targetInGo:SetActive(hasInData)
  self.targetOutGo:SetActive(hasOutData)
  self.tipLabel.gameObject:SetActive(not hasInData or not hasOutData)
  self.tipLabel.text = self:GetTargetInOutTipText()
  self.previewPart:SetActive(hasInData and hasOutData)
  self:SetActionBtnActive(self.targetInData and self.targetOutData and self:CheckCost())
end

function AncientUpgradeBord:GetTargetInOutTipText()
  return ZhString.AncientUpgrade_ChooseTargetInFirst
end

function AncientUpgradeBord:ShowItemInfoTip(cell)
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

function AncientUpgradeBord:ShowChooseRefineMaterialBord()
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

function AncientUpgradeBord:ClickRefine()
  if self.clickDisabled then
    return
  end
  local nowData = self.itemData
  if nowData then
    self:DoRefine(nowData)
  else
    MsgManager.ShowMsgByIDTable(216)
  end
end

function AncientUpgradeBord:DoRefine(nowData)
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
  self.clickDisabled = true
  self:PlayUIEffect(EffectMap.UI.EnchantTransfer, self.effectContainer, true)
  TimeTickManager.Me():CreateOnceDelayTick(800, function()
    ServiceItemProxy.Instance:CallEquipPromote(nowData.id)
    self:PassEvent(AncientUpgradeBord_Event.DoRefine, self)
  end, self)
end

function AncientUpgradeBord:Refresh(checkCond)
  if checkCond then
    local equipInfo = self.itemData and self.itemData.equipInfo
    if not equipInfo or not equipInfo:CanAncientUpgrade() then
      self.itemData = nil
    end
  end
  local nowData = self.itemData
  local flag = nowData ~= nil
  self.targetCellContent:SetActive(flag)
  self.targetAddIcon:SetActive(not flag)
  self.itemName.gameObject:SetActive(flag)
  self.emptyBord:SetActive(not flag)
  self.refineBord:SetActive(flag)
  self.select1:SetActive(not flag)
  self.select2:SetActive(flag)
  self.materialchooseBord:Hide()
  if nowData ~= nil then
    local succ = IconManager:SetItemIcon(nowData.staticData.Icon, self.targetInCellIcon)
    if not succ then
      IconManager:SetItemIcon("item_45001", self.targetInCellIcon)
    end
    local up_statidData = Table_Item[nowData.staticData.id + 1]
    succ = up_statidData and IconManager:SetItemIcon(up_statidData.Icon, self.targetOutCellIcon)
    if not succ then
      IconManager:SetItemIcon("item_45001", self.targetOutCellIcon)
    end
    self.itemName.text = nowData:GetName(nil, true)
    self.islottery = LotteryProxy.Instance:IsLotteryEquip(nowData.staticData.id)
    self:UpdateRefineInfo()
  end
end

function AncientUpgradeBord:UpdateRefineFullLabel()
end

function AncientUpgradeBord:UpdateRefineTip()
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
  if false then
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

function AncientUpgradeBord:UpdateRefineMaterials(refreshSelectedEquips)
  local nowData = self.itemData
  if nowData == nil then
    self.refineMatCtl:ResetDatas(_EmptyTable)
    return
  end
  self.refine_MaterialIsFull = true
  TableUtility.ArrayClear(tempArr)
  local costItems = tempArr
  TableUtility.ArrayClear(self.refine_lackMats)
  self.refine_cost_Rob = 0
  local bcItems = GameConfig.EquipPromote.cost
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
  self.priceNumLabel.text = ""
end

function AncientUpgradeBord:UpdateRefineInfo()
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
    local effects = BagProxy.Instance:GetStaticEquipRandomEffectData(equipInfo.equipData.id + 1)
    for i = 1, #effects do
      local effect = effects[i]
      if effect.GroupID == 2 and (effect.AttrType[1] == "NpcDamPer" or effect.AttrType[1] == "NpcResPer") then
        list[#list + 1] = {
          new = true,
          id = effect.id
        }
        break
      end
    end
    self.attrListctrl:ResetDatas(list)
  end
  self:OnClickAncientUpgradeAttrCell()
end

function AncientUpgradeBord:TryOpenQuickBuyView(id, count)
  local lackItem = self:GetUniqueTempLackItem(id, count)
  return QuickBuyProxy.Instance:TryOpenView(self:GetUniqueTempArrayWithElement(lackItem))
end

function AncientUpgradeBord:GetLackItem(id, count)
  return {id = id, count = count}
end

function AncientUpgradeBord:GetUniqueTempLackItem(id, count)
  TableUtility.TableClear(tempTable)
  tempTable.id = id
  tempTable.count = count
  return tempTable
end

function AncientUpgradeBord:GetUniqueTempArrayWithElement(element1, ...)
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

function AncientUpgradeBord:InitChooseBords()
  local chooseContainer = self:FindGO("ChooseContainer")
  self.chooseBord = EquipNewChooseBord.new(chooseContainer)
  self.materialchooseBord = EquipNewCountChooseBord.new(chooseContainer)
  self.materialchooseBord:Hide()
  self.materialchooseBord:AddEventListener(EquipChooseCellEvent.CountChooseChange, self.OnCountChooseChange, self)
  self:HideAllChooseBord()
end

function AncientUpgradeBord:OnCountChooseChange(cell)
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

function AncientUpgradeBord:ShowChooseRefineMaterialBord()
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

function AncientUpgradeBord:GetNowItemData()
  return self.itemData
end

function AncientUpgradeBord:SetTargetItem(itemData)
  self.itemData = itemData
  self:Refresh(true)
end

function AncientUpgradeBord:SetNpcguid(npcguid)
  self.refine_npcguid = npcguid
end

function AncientUpgradeBord:HideAllChooseBord()
  self.chooseBord:Hide()
  self.materialchooseBord:Hide()
end

function AncientUpgradeBord:ShowTempResult(result)
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
  TimeTickManager.Me():ClearTick(self, 999)
  TimeTickManager.Me():CreateOnceDelayTick(2500, function(self)
    self.clickDisabled = nil
  end, self, 999)
end

function AncientUpgradeBord:PlayEffect()
  self:PlayUIEffect(EffectMap.UI.ForgingSuccess, self.effContainerRq.gameObject, true, self.ForgingSuccessEffectHandle, self)
end

function AncientUpgradeBord.ForgingSuccessEffectHandle(effectHandle, owner)
  if owner then
    owner.effContainerRq:AddChild(effectHandle.gameObject)
  end
end

function AncientUpgradeBord:OnExit()
  TimeTickManager.Me():ClearTick(self)
  if self.chooseBord and self.chooseBord.datas then
    for _, data in pairs(self.chooseBord.datas) do
      if data.isShowRedTip then
        data.isShowRedTip = nil
      end
    end
  end
end

function AncientUpgradeBord:OnEnter()
  self.onSelectCell = nil
  self:UpdateRefineMaterials(true)
end

function AncientUpgradeBord:OnClickAncientUpgradeAttrCell(cell)
  self.onSelectCell = cell
  self:UpdateRefineMaterials(true)
  self:UpdateRefineFullLabel()
  self:UpdateRefineTip()
end

function AncientUpgradeBord:OnChooseItem(data)
  if self.isChoosingTargetIn then
    self.targetInData = data
    local curEnchantItemId = data and data.id or nil
    EnchantEquipUtil.Instance:SetCurrentEnchantId(curEnchantItemId)
    self:UpdateCellData(self.targetInGo, data)
    self.targetOutData = nil
  else
    self.targetOutData = data
    self:UpdateCellData(self.targetOutGo, data)
  end
  self.chooseBord:Hide()
  self:UpdateMainBoard()
  if not self.isChoosingTargetIn then
    self:UpdatePreview()
  end
  self.isChoosingTargetIn = nil
end

function AncientUpgradeBord:UpdateCellData(parent, data)
  local itemSp = self:FindComponent("ItemSprite", UISprite, parent)
  local succ = IconManager:SetItemIcon(data.staticData.Icon, itemSp)
  if not succ then
    IconManager:SetItemIcon("item_45001", itemSp)
  end
  itemSp:MakePixelPerfect()
  local scale = 0.8
  itemSp.transform.localScale = LuaGeometry.GetTempVector3(scale, scale, scale)
  local attrLabel, attr = self:FindComponent("AttrLabel", UILabel, parent), self:GetTargetAttrText(data)
  attrLabel.gameObject:SetActive(not StringUtil.IsEmpty(attr))
  attrLabel.text = attr
end
