autoImport("EquipNewChooseBord")
autoImport("MaterialChooseBord")
autoImport("EquipRepairMatCell")
autoImport("BaseItemNewCell")
autoImport("MaterialItemNewCell")
EquipRefineBord = class("EquipRefineBord", CoreView)
EquipRefineBord_RefineMode = {Normal = 1, Safe = 2}
EquipRefineBord_Event = {
  ClickTargetCell = "EquipRefineBord_Event_ClickTargetCell",
  ClickMatCell = "EquipRefineBord_Event_ClickMatCell",
  DoRefine = "EquipRefineBord_Event_DoRefine",
  DoRepair = "EquipRefineBord_Event_DoRepair"
}
local DEFAULT_MATERIAL_SEARCH_BAGTYPES, REFINE_MATERIAL_SEARCH_BAGTYPES, REPAIR_MATERIAL_SEARCH_BAGTYPES, LOTTERY_REPAIR_MATERIAL_CFG, EQUIP_REPAIR_MATERIAL_CFG
local itemTipOffset, tempTable, tempArr = {-370, 0}, {}, {}
local resultTickId = 788

function EquipRefineBord:ctor(go, isFashion)
  EquipRefineBord.super.ctor(self, go)
  if not DEFAULT_MATERIAL_SEARCH_BAGTYPES then
    DEFAULT_MATERIAL_SEARCH_BAGTYPES = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.default or {1, 9}
    REFINE_MATERIAL_SEARCH_BAGTYPES = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.refine or DEFAULT_MATERIAL_SEARCH_BAGTYPES
    REPAIR_MATERIAL_SEARCH_BAGTYPES = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.repair or DEFAULT_MATERIAL_SEARCH_BAGTYPES
    LOTTERY_REPAIR_MATERIAL_CFG = GameConfig.Lottery.repair_material
    EQUIP_REPAIR_MATERIAL_CFG = GameConfig.Lottery.repair_EquipMaterial
  end
  self:Init(isFashion)
end

function EquipRefineBord:Init(isFashion)
  self:InitData(isFashion)
  self:InitBord()
  self:InitChooseBords()
  ServiceItemProxy.Instance:CallQueryLotteryHeadItemCmd()
end

function EquipRefineBord:InitData(isFashion)
  self.refineMode = EquipRefineBord_RefineMode.Normal
  self.maxRefineLv = 0
  self.refine_MaterialIsFull = false
  self.refine_cost_Rob = 0
  self.refine_lackMats = {}
  self.islottery = false
  self.isFashion = isFashion
  self.refine_npcguid = nil
  self.safeRefine_selectEquipIds = {}
  self.repair_matdata = nil
end

function EquipRefineBord:InitBord()
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
  self.currentRefineLevel = self:FindComponent("CurrentRefineLevel", UILabel, self.refineAttr)
  self.nextRefineLevel = self:FindComponent("NextRefineLevel", UILabel, self.refineAttr)
  self.refineEffect = self:FindComponent("RefineEffect", UILabel, self.refineAttr)
  self.nowEffect = self:FindComponent("NowEffect", UILabel, self.refineAttr)
  self.nextEffect = self:FindComponent("NextEffect", UILabel, self.refineAttr)
  self.refineArrow1 = self:FindGO("RefineArrow1")
  self.refineArrow2 = self:FindGO("RefineArrow2")
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
  self.safeRefineButton = self:FindGO("SafeRefineBtn", self.refineBord)
  self:AddClickEvent(self.safeRefineButton, function()
    self:ClickRefine()
  end)
  self.safeRefineToggle = self:FindGO("SafeRefineToggle")
  self.safeRefineToggleCheckmark = self:FindGO("Checkmark", self.safeRefineToggle)
  self:AddClickEvent(self.safeRefineToggle, function()
    if self.refineMode == EquipRefineBord_RefineMode.Safe then
      self:ChangeRefineMode(EquipRefineBord_RefineMode.Normal, true)
    elseif self.refineMode == EquipRefineBord_RefineMode.Normal then
      self:ChangeRefineMode(EquipRefineBord_RefineMode.Safe, true)
    end
  end)
  self.priceTable = self:FindComponent("PriceIndicator", UITable)
  self.priceIcon = self:FindComponent("PriceIcon", UISprite)
  self.priceNumLabel = self:FindComponent("PriceNum", UILabel)
  self.originalPriceNumLabel = self:FindComponent("OriginalPriceNum", UILabel)
  self.repairBord = self:FindGO("RepairBord")
  self.repairEffect = self:FindComponent("RefineEffect", UILabel, self.repairBord)
  self.repairRefineLevel = self:FindComponent("RefineLevel", UILabel, self.repairBord)
  self.repairNextEffect = self:FindComponent("NextEffect", UILabel, self.repairBord)
  local matItemGO = self:FindGO("MatItem", self.repairBord)
  self:LoadPreferb_ByFullPath(ResourcePathHelper.UICell("ItemNewCell"), matItemGO)
  self.repair_matCell = EquipRepairMatCell.new(matItemGO)
  self.repair_matCell:AddEventListener(MouseEvent.MouseClick, self.ClickRepairMatCell, self)
  self:AddButtonEvent("RepairBtn", function()
    self:ClickRepair()
  end)
  self.repairTipBord = self:FindGO("RepairTipBord")
  if self.repairTipBord then
    self.repairTip_Label = self:FindComponent("RepairTip", UILabel, self.repairTipBord)
  end
end

function EquipRefineBord:ClickTargetCell()
  TipManager.CloseTip()
  self:SetTargetItem()
  if self.chooseBord then
    self.chooseBord:Hide()
  end
  if not self.itemData and self.materialchooseBord then
    self.materialchooseBord:Hide()
  end
  self:PassEvent(EquipRefineBord_Event.ClickTargetCell, self)
end

function EquipRefineBord:ChangeRefineMode(refineMode, fromClickEvent)
  local nowData = self.itemData
  if nowData == nil then
    return
  end
  if fromClickEvent and self.forbiddenRefineMode then
    return
  end
  self.refineMode = refineMode
  self:UpdateRefineFullLabel()
  self:UpdateRefineTip()
  self:UpdateRefineMaterials(true)
  self:UpdateRefineModeUI()
end

function EquipRefineBord:UpdateRefineModeUI()
  local nowData = self.itemData
  if nowData == nil then
    return
  end
  local isSafe = self.refineMode == EquipRefineBord_RefineMode.Safe
  self.safeRefineToggleCheckmark:SetActive(isSafe)
  self.refineButton:SetActive(not isSafe)
  self.safeRefineButton:SetActive(isSafe)
end

function EquipRefineBord:ClickRefineMatItem(cellctl)
  if cellctl and cellctl.data then
    if cellctl.data.id == MaterialItemCell.MaterialType.Material then
      self:ShowItemInfoTip(cellctl)
    else
      self:ShowChooseRefineMaterialBord()
    end
  end
end

function EquipRefineBord:ShowItemInfoTip(cell)
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

function EquipRefineBord:ClickRefine()
  local nowData = self.itemData
  if nowData then
    if nowData.equipInfo.refinelv >= 4 then
      TableUtility.TableClear(tempTable)
      tempTable.itemData = nowData
      FunctionSecurity.Me():RefineEquip(function()
        self:DoRefine(nowData)
      end, tempTable)
    else
      self:DoRefine(nowData)
    end
  else
    MsgManager.ShowMsgByIDTable(216)
  end
end

function EquipRefineBord:DoRefine(nowData)
  local equipInfo = nowData.equipInfo
  if equipInfo.refinelv >= self.maxRefineLv then
    MsgManager.ShowMsgByIDTable(217)
    return
  end
  if equipInfo.damage then
    MsgManager.ShowMsgByIDTable(228)
    return
  end
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
  if self.refineMode == EquipRefineBord_RefineMode.Safe then
    local selectSafeEquipIds
    if 0 < #self.safeRefine_selectEquipIds then
      selectSafeEquipIds = {}
      for i = 1, #self.safeRefine_selectEquipIds do
        selectSafeEquipIds[i] = self.safeRefine_selectEquipIds[i]:ExportServerItemInfo()
      end
      if FunctionItemFunc.RecoverEquips(self.safeRefine_selectEquipIds) then
        return
      end
    end
    local composeIDs = BlackSmithProxy.Instance:GetComposeIDsByItemData(nowData, true)
    local composeId = composeIDs and composeIDs[1]
    ServiceItemProxy.Instance:CallEquipRefine(nowData.id, composeId, nil, nil, self.refine_npcguid, true, selectSafeEquipIds)
    self:PassEvent(EquipRefineBord_Event.DoRefine, self)
    self:sendNotification(HomeEvent.WorkbenchStartWork)
  else
    ServiceItemProxy.Instance:CallEquipRefine(nowData.id, self.composeID, nil, nil, self.refine_npcguid, false)
    self:PassEvent(EquipRefineBord_Event.DoRefine, self)
    self:sendNotification(HomeEvent.WorkbenchStartWork)
  end
end

local Func_GetLotteryHeadwearRepairMat = function(itemStaticId)
  local sData = Table_HeadwearRepair[itemStaticId]
  if not sData then
    return
  end
  return sData.HeadID, sData.RepairNum
end
local _qualityRepairMatMap = {}
local Func_GetLotteryEquipRepairMatByQuality = function(quality)
  if not next(_qualityRepairMatMap) then
    local repairMat, q
    for id, cfg in pairs(LOTTERY_REPAIR_MATERIAL_CFG) do
      for i = 1, #cfg do
        q = cfg[i].quality
        repairMat = _qualityRepairMatMap[q] or {}
        repairMat[id] = cfg[i].count
        _qualityRepairMatMap[q] = repairMat
      end
    end
  end
  return _qualityRepairMatMap[quality]
end
local _itemTypeRepairMatMap = {}
local Func_GetEquipRepairMatByType = function(t)
  if not next(_itemTypeRepairMatMap) then
    local repairMat, t1
    for id, cfg in pairs(EQUIP_REPAIR_MATERIAL_CFG) do
      for i = 1, #cfg do
        t1 = cfg[i].type
        repairMat = _itemTypeRepairMatMap[t1] or {}
        repairMat[id] = cfg[i].count
        _itemTypeRepairMatMap[t1] = repairMat
      end
    end
  end
  return _itemTypeRepairMatMap[t]
end

function EquipRefineBord:ClickRepairMatCell(cell)
  local nowData = self.itemData
  if nowData == nil then
    return
  end
  if nowData.equipInfo:IsNextGen() then
    self:ShowItemInfoTip(self.repair_matCell)
    return
  end
  local datas = BlackSmithProxy.Instance:GetMaterialEquips_ByVID(nowData, REPAIR_MATERIAL_SEARCH_BAGTYPES, nil, nil, nil, true)
  local newDatas = {}
  for i = #datas, 1, -1 do
    if datas[i].id == nowData.id then
      if 1 < datas[i].num then
        local newData = datas[i]:Clone()
        newData.num = newData.num - 1
        table.insert(newDatas, 1, newData)
      end
    else
      table.insert(newDatas, 1, datas[i]:Clone())
    end
  end
  datas = newDatas
  local lotteryIDs = LotteryProxy.Instance:GetLotteryHeadIds()
  if lotteryIDs and 0 ~= TableUtility.ArrayFindIndex(lotteryIDs, nowData.staticData.id) then
    local lotteryRepairMatMap = Func_GetLotteryEquipRepairMatByQuality(nowData.staticData.Quality)
    if lotteryRepairMatMap then
      for repairMatId, _ in pairs(lotteryRepairMatMap) do
        local own = BagProxy.Instance:GetItemsByStaticID(repairMatId)
        if own then
          for i = 1, #own do
            TableUtility.ArrayPushFront(datas, own[i])
          end
        end
      end
    end
  end
  local normalLackEquipId
  if #datas == 0 then
    normalLackEquipId = self.repair_matdata.staticData.id
  end
  local lotteryRMatId, lotteryRNeednum = Func_GetLotteryHeadwearRepairMat(nowData.staticData.id)
  if lotteryRMatId then
    local items = BagProxy.Instance:GetItemsByStaticID(lotteryRMatId)
    if items then
      for i = 1, #items do
        if not TableUtility.ArrayFindByPredicate(datas, function(item)
          return item.id == items[i].id
        end) then
          TableUtility.ArrayPushFront(datas, items[i])
        end
      end
    end
  end
  local equipRepairMatMap, hasEquipRMat = Func_GetEquipRepairMatByType(nowData.staticData.Type)
  if equipRepairMatMap then
    for repairMatId, _ in pairs(equipRepairMatMap) do
      local own = BagProxy.Instance:GetItemsByStaticID(repairMatId)
      if own then
        for i = 1, #own do
          TableUtility.ArrayPushFront(datas, own[i])
          hasEquipRMat = true
        end
      end
    end
  end
  if normalLackEquipId and not lotteryRMatId and not hasEquipRMat then
    self:TryOpenQuickBuyView(normalLackEquipId, 1)
    return
  end
  if lotteryRMatId and normalLackEquipId and (not next(datas) or datas[1].staticData.id == lotteryRMatId and lotteryRNeednum > datas[1].num) then
    MsgManager.FloatMsg("", string.format(ZhString.EquipRefineBord_RepairNeedMaterialTip, lotteryRMatId, lotteryRMatId, lotteryRNeednum))
    return
  end
  if lotteryRMatId or equipRepairMatMap then
    if self.chooseBord.datas then
      for _, data in pairs(self.chooseBord.datas) do
        if data.isShowRedTip then
          data.isShowRedTip = nil
        end
      end
    end
    for i = 1, #datas do
      if datas[i].staticData.id == nowData.staticData.id then
        datas[i].isShowRedTip = true
        break
      end
    end
  end
  self.chooseBord:ResetDatas(datas, true)
  self.chooseBord:Show(nil, self._RepairChooseFunc, self, self._MaterialChooseValidFunc, self, ZhString.EquipRefineBord_InvalidRepairMatTip)
  self.chooseBord:SetChoose(self.repair_matdata)
  self.chooseBord:SetBordTitle(ZhString.EquipRefineBord_ChooseMat)
end

local Func_IsLotteryHeadwearRepairMat = function(staticId)
  return nil ~= TableUtility.TableFindByPredicate(Table_HeadwearRepair, function(k, v)
    return v.HeadID == staticId
  end)
end
local callEquipRepair = function(self, itemData, matData)
  local matId = matData.id
  local realMatData = matId and BagProxy.Instance:GetItemByGuid(matId)
  if BagProxy.Instance:CheckIsFavorite(realMatData) then
    MsgManager.ShowMsgByIDTable(233)
    return
  end
  ServiceItemProxy.Instance:CallEquipRepair(itemData.id, nil, matId)
  self:PassEvent(EquipRefineBord_Event.DoRepair, self)
  self.chooseBord:Hide()
end

function EquipRefineBord:ClickRepair()
  local nowData = self.itemData
  if nowData == nil then
    MsgManager.ShowMsgByIDTable(224)
    return
  end
  local matdata = self.repair_matdata
  if not matdata then
    return
  end
  local matSId = matdata.staticData.id
  if matdata.id == "None" and self:TryOpenQuickBuyView(matSId, self.repair_matCell.needNum or 1) then
    return
  end
  if LOTTERY_REPAIR_MATERIAL_CFG[matSId] or Func_IsLotteryHeadwearRepairMat(matSId) then
    local lotteryRMatId, lotteryRNeedNum = Func_GetLotteryHeadwearRepairMat(nowData.staticData.id)
    if lotteryRMatId then
      if lotteryRNeedNum > matdata.num then
        MsgManager.FloatMsg("", string.format(ZhString.EquipRefineBord_RepairNeedMaterialTip, lotteryRMatId, lotteryRMatId, lotteryRNeedNum))
        return
      end
    elseif BagProxy.Instance:GetItemNumByStaticID(matSId, REPAIR_MATERIAL_SEARCH_BAGTYPES) <= 0 and self:TryOpenQuickBuyView(matSId, 1) then
      return
    end
    callEquipRepair(self, nowData, matdata)
    return
  elseif EQUIP_REPAIR_MATERIAL_CFG[matSId] then
    local nowDataType, typeCfg = nowData.staticData.Type
    for _, element in pairs(EQUIP_REPAIR_MATERIAL_CFG[matSId]) do
      if nowDataType == element.type then
        typeCfg = element
      end
    end
    if not typeCfg then
      return
    end
    if BagProxy.Instance:GetItemNumByStaticID(matSId, REPAIR_MATERIAL_SEARCH_BAGTYPES) < typeCfg.count and self:TryOpenQuickBuyView(matSId, 1) then
      return
    end
    callEquipRepair(self, nowData, matdata)
    return
  elseif nowData.equipInfo:IsNextGen() then
    local matNum = BagProxy.Instance:GetItemNumByStaticID(matSId, REPAIR_MATERIAL_SEARCH_BAGTYPES)
    if matNum < self.repair_matCell.needNum then
      if self:TryOpenQuickBuyView(matSId, self.repair_matCell.needNum - matNum) then
        return
      end
    else
      callEquipRepair(self, nowData, matdata)
    end
    return
  end
  local matRefinelv = matdata.equipInfo.refinelv
  local tipRefinelv = GameConfig.EquipRefine.repair_stuff_msg_lv or 4
  local maxRevinelv = GameConfig.EquipRefine.repair_stuff_max_lv or 6
  if matRefinelv > maxRevinelv then
    MsgManager.ShowMsgByIDTable(241)
    return
  end
  if FunctionItemFunc.RecoverEquips(self:GetUniqueTempArrayWithElement(matdata)) then
    return
  end
  if matRefinelv >= tipRefinelv and matRefinelv <= maxRevinelv then
    MsgManager.ConfirmMsgByID(934, function()
      callEquipRepair(self, nowData, matdata)
    end, nil, nil, matRefinelv)
  else
    callEquipRepair(self, nowData, matdata)
  end
end

function EquipRefineBord:Refresh()
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
    if nowData.equipInfo.damage then
      self.refineBord:SetActive(false)
      self:UpdateRepairInfo()
      self.repairBord:SetActive(true)
    else
      self.refineBord:SetActive(true)
      self:UpdateRefineInfo()
      self.repairBord:SetActive(false)
    end
  else
    self.refineBord:SetActive(false)
    self.repairBord:SetActive(false)
  end
end

function EquipRefineBord:UpdateRefineFullLabel()
  if not self.refineFull then
    return
  end
  self.refineFull:SetActive(false)
  self.refineUnFull:SetActive(true)
  self.refineCtrls:SetActive(true)
  local nowData = self.itemData
  local refinelv = nowData.equipInfo.refinelv
  local safeClamp_min, safeClamp_max = BlackSmithProxy.Instance:GetSafeRefineClamp(self.islottery, nowData.equipInfo)
  if refinelv >= self.maxRefineLv then
    self.refineUnFull:SetActive(false)
    self.refineCtrls:SetActive(false)
    self.refineFull:SetActive(true)
    self.refineFull_label.text = ZhString.EquipRefineBord_RefineTip_Full
  elseif self.refineMode == EquipRefineBord_RefineMode.Safe and refinelv >= safeClamp_max then
    self.refineUnFull:SetActive(false)
    self.refineCtrls:SetActive(false)
    self.refineFull:SetActive(true)
    self.refineFull_label.text = string.format(ZhString.EquipRefineBord_TopSafeRefine, safeClamp_max)
  end
end

function EquipRefineBord:UpdateRefineTip()
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

function EquipRefineBord:Refresh_safeRefine_selectEquips(needNum)
  TableUtility.ArrayClear(self.safeRefine_selectEquipIds)
  if not self.itemData then
    return 0
  end
  self.safeRefineNeedNum = needNum
  local leftNeedNum = needNum
  local datas = BlackSmithProxy.Instance:GetMaterialEquips_ByVID(self.itemData, REFINE_MATERIAL_SEARCH_BAGTYPES, nil, nil, nil, true)
  for i = 1, #datas do
    local cloneData
    if datas[i].id == self.itemData.id then
      if 1 < datas[i].num then
        cloneData = datas[i]:Clone()
        cloneData.num = cloneData.num - 1
      end
    else
      cloneData = datas[i]:Clone()
    end
    if cloneData then
      table.insert(self.safeRefine_selectEquipIds, cloneData)
      if leftNeedNum < cloneData.num then
        cloneData.num = leftNeedNum
        leftNeedNum = 0
      else
        leftNeedNum = leftNeedNum - cloneData.num
      end
    end
    if leftNeedNum <= 0 then
      break
    end
  end
  return needNum - leftNeedNum
end

function EquipRefineBord:UpdateRefineMaterials(refreshSelectedEquips)
  local nowData = self.itemData
  if nowData == nil then
    self.refineMatCtl:ResetDatas(_EmptyTable)
    return
  end
  local isSafeMode = self.refineMode == EquipRefineBord_RefineMode.Safe
  local composeIDs = BlackSmithProxy.Instance:GetComposeIDsByItemData(nowData, isSafeMode)
  self.composeID = composeIDs and composeIDs[1]
  local composeData = self.composeID and Table_Compose[self.composeID]
  if composeData == nil then
    errorLog("Refine Not Have ComposeData")
    return
  end
  self.refine_MaterialIsFull = true
  self.discount = nil
  TableUtility.ArrayClear(tempArr)
  local costItems = tempArr
  local safeClamp_min, safeClamp_max = BlackSmithProxy.Instance:GetSafeRefineClamp(self.islottery, nowData.equipInfo)
  local isRealSafe = nowData.equipInfo.refinelv >= safeClamp_min - 1
  local ds = BlackSmithProxy.Instance:GetEquipOptDiscounts(isSafeMode and isRealSafe and ActivityCmd_pb.GACTIVITY_SAFE_REFINE or ActivityCmd_pb.GACTIVITY_NORMAL_REFINE)
  self.discount = not self.islottery and ds and ds[1] or nil
  TableUtility.ArrayClear(self.refine_lackMats)
  if isSafeMode then
    local refinelv = nowData.equipInfo.refinelv
    if safeClamp_max <= refinelv then
      self.refineMatCtl:ResetDatas(costItems)
      return
    end
    local costId, needNum = BlackSmithProxy.Instance:GetSafeRefineCostEquip(nowData, refinelv + 1, self.islottery)
    if costId and 0 < needNum then
      local isEquip = ItemData.CheckIsEquip(costId)
      local showNum
      if isEquip then
        if refreshSelectedEquips then
          showNum = self:Refresh_safeRefine_selectEquips(needNum)
        else
          showNum = 0
          for i = 1, #self.safeRefine_selectEquipIds do
            showNum = showNum + self.safeRefine_selectEquipIds[i].num
          end
        end
      else
        showNum = HappyShopProxy.Instance:GetItemNum(costId)
      end
      local itemData = ItemData.new(MaterialItemCell.MaterialType[isEquip and "MaterialItem" or "Material"], costId)
      itemData.num = showNum
      itemData.neednum = needNum
      itemData.cardSlotNum = 0
      itemData.discount = self.discount
      table.insert(costItems, itemData)
      if needNum > showNum then
        self.refine_MaterialIsFull = false
      end
    end
  end
  local bcItems = composeData.BeCostItem
  for i = 1, #bcItems do
    local data = bcItems[i]
    local items = BagProxy.Instance:GetMaterialItems_ByItemId(data.id, REFINE_MATERIAL_SEARCH_BAGTYPES)
    local bagNum = 0
    for j = 1, #items do
      bagNum = bagNum + items[j].num
    end
    local itemData = ItemData.new(MaterialItemCell.MaterialType.Material, data.id)
    itemData.num = bagNum
    itemData.neednum = data.num
    if isSafeMode and isRealSafe and self.discount then
      itemData.neednum = math.floor(itemData.neednum * (self.discount / 100))
      itemData.discount = self.discount
    end
    table.insert(costItems, itemData)
    if bagNum < itemData.neednum then
      table.insert(self.refine_lackMats, self:GetLackItem(data.id, itemData.neednum - bagNum))
      if self.refine_MaterialIsFull then
        self.refine_MaterialIsFull = false
      end
    end
  end
  self.refineMatCtl:ResetDatas(costItems)
  local realDiscount = self.discount or HomeManager.Me():TryGetHomeWorkbenchDiscount("Refine")
  self.refine_cost_Rob = math.floor(composeData.ROB * realDiscount / 100 + 0.01)
  IconManager:SetItemIcon(Table_Item[GameConfig.MoneyId.Zeny].Icon, self.priceIcon)
  if self.refine_cost_Rob <= MyselfProxy.Instance:GetROB() then
    self.priceNumLabel.text = self.refine_cost_Rob
  else
    self.priceNumLabel.text = string.format("[c][fb725f]%s[-][/c]", self.refine_cost_Rob)
  end
  self.originalPriceNumLabel.text = composeData.ROB
  self.originalPriceNumLabel.gameObject:SetActive(not math.Approximately(realDiscount, 100))
  TimeTickManager.Me():CreateOnceDelayTick(33, function(self)
    self.priceTable:Reposition()
  end, self)
end

function EquipRefineBord:UpdateRefineInfo()
  local nowData = self.itemData
  if nowData == nil then
    return
  end
  local equipInfo = nowData.equipInfo
  local currentLv = equipInfo.refinelv
  self.maxRefineLv = BlackSmithProxy.Instance:MaxRefineLevelByData(nowData.staticData)
  if self.outset_maxrefine and self.outset_maxrefine < self.maxRefineLv then
    self.maxRefineLv = self.outset_maxrefine
  end
  self:SetForbiddenRefineMode(nowData)
  self.safeRefineToggle:SetActive(self.forbiddenRefineMode == nil)
  if self.forbiddenRefineMode == EquipRefineBord_RefineMode.Safe then
    self:ChangeRefineMode(EquipRefineBord_RefineMode.Normal)
  elseif self.forbiddenRefineMode == EquipRefineBord_RefineMode.Normal then
    self:ChangeRefineMode(EquipRefineBord_RefineMode.Safe)
  else
    self:UpdateRefineFullLabel()
    self:UpdateRefineTip()
    self:UpdateRefineModeUI()
  end
  local isMax = currentLv >= self.maxRefineLv
  self.refineArrow1:SetActive(not isMax)
  self.refineArrow2:SetActive(not isMax)
  local proName, now, next = ItemUtil.GetRefineAttrPreview(equipInfo)
  if not StringUtil.IsEmpty(proName) then
    self.refineEffect.text = proName
  end
  if isMax then
    self.currentRefineLevel.text = ""
    self.nextRefineLevel.text = string.format("[c][2d2c47]+%s[-][/c]", currentLv)
    self.nowEffect.text = ""
    self.nextEffect.text = string.format("[c][2d2c47]%s[-][/c]", now)
    return
  end
  self.currentRefineLevel.text = string.format("+%s", currentLv)
  self.nextRefineLevel.text = string.format("+%s", currentLv + 1)
  self.nowEffect.text = now
  self.nextEffect.text = next
  self:UpdateRefineMaterials(true)
end

function EquipRefineBord:SetForbiddenRefineMode(nowData)
  self.forbiddenRefineMode = nil
  if nowData then
    local safeClamp_min, safeClamp_max = BlackSmithProxy.Instance:GetSafeRefineClamp(self.islottery, nowData.equipInfo)
    if safeClamp_max <= nowData.equipInfo.refinelv or nowData.equipInfo.refinelv < safeClamp_min - 1 then
      self.forbiddenRefineMode = EquipRefineBord_RefineMode.Safe
    end
  end
end

function EquipRefineBord:UpdateRepairMaterial(itemData)
  local nowData = self.itemData
  if nowData.equipInfo:IsNextGen() then
    return self:UpdateNextGenRepairMaterial()
  end
  local repairItemMatID, neednum, materialEquipsCount
  if itemData == nil then
    local repairMats = BlackSmithProxy.Instance:GetMaterialEquips_ByVID(nowData, REPAIR_MATERIAL_SEARCH_BAGTYPES, nil, nil, nil, true)
    materialEquipsCount = 0
    for i = #repairMats, 1, -1 do
      if repairMats[i].id == nowData.id then
        if repairMats[i].num == 1 then
          table.remove(repairMats, i)
        else
          materialEquipsCount = materialEquipsCount + repairMats[i].num - 1
        end
      else
        materialEquipsCount = materialEquipsCount + repairMats[i].num
      end
    end
    local lotteryIDs = LotteryProxy.Instance:GetLotteryHeadIds()
    if lotteryIDs and 0 ~= TableUtility.ArrayFindIndex(lotteryIDs, nowData.staticData.id) then
      local lotteryRepairMatMap = Func_GetLotteryEquipRepairMatByQuality(nowData.staticData.Quality)
      if lotteryRepairMatMap then
        for repairMatId, _ in pairs(lotteryRepairMatMap) do
          local items = BagProxy.Instance:GetItemsByStaticID(repairMatId)
          if items then
            for i = 1, #items do
              local newItem
              if items[i].id == nowData.id then
                if 1 < items[i].num then
                  newItem = items[i]:Clone()
                  newItem.num = newItem.num - 1
                end
              else
                newItem = items[i]:Clone()
              end
              if newItem then
                TableUtility.ArrayPushFront(repairMats, newItem)
              end
            end
          end
        end
      end
    end
    repairItemMatID, neednum = Func_GetLotteryHeadwearRepairMat(nowData.staticData.id)
    if repairItemMatID then
      local items = BagProxy.Instance:GetItemsByStaticID(repairItemMatID)
      if items and next(items) then
        for i = 1, #items do
          TableUtility.ArrayPushFront(repairMats, items[i])
        end
      else
        TableUtility.ArrayPushFront(repairMats, ItemData.new("Advanced", repairItemMatID))
      end
    end
    local equipRepairMatMap = Func_GetEquipRepairMatByType(nowData.staticData.Type)
    if equipRepairMatMap then
      for repairMatId, _ in pairs(equipRepairMatMap) do
        local items = BagProxy.Instance:GetItemsByStaticID(repairMatId)
        if items and next(items) then
          for i = 1, #items do
            TableUtility.ArrayPushFront(repairMats, items[i])
          end
        end
      end
    end
    self.repair_matdata = repairMats and repairMats[1]
  else
    self.repair_matdata = itemData
    local sId, nowSData = itemData.staticData.id, nowData and nowData.staticData
    if Func_IsLotteryHeadwearRepairMat(sId) then
      _, neednum = Func_GetLotteryHeadwearRepairMat(nowSData.id)
    elseif EQUIP_REPAIR_MATERIAL_CFG[sId] then
      neednum = _itemTypeRepairMatMap[nowSData.Type][sId]
    end
  end
  if self.repair_matdata == nil then
    self.repair_matdata = ItemData.new("None", BlackSmithProxy.GetMinCostMaterialID(nowData.staticData.id))
  end
  self.repair_matCell:SetData(self.repair_matdata)
  self.repair_matCell:SetNeedNum(neednum or 1)
  if self.isFashion then
    self.repair_matCell:SetShowRedTip(neednum ~= nil and materialEquipsCount ~= nil and 0 < materialEquipsCount)
  end
  if self.repairTipBord then
    if self.repair_matdata.equipInfo then
      self.repairTipBord:SetActive(true)
      self.repairTip_Label.text = string.format(ZhString.EquipRefineBord_RepairTip, string.gsub(nowData.staticData.NameZh, "%[%d+%]", ""))
    else
      self.repairTipBord:SetActive(false)
    end
  end
end

function EquipRefineBord:UpdateNextGenRepairMaterial()
  if self.repairTipBord then
    self.repairTipBord:SetActive(false)
  end
  local nowData = self.itemData
  local repairCfg = nowData.equipInfo.equipData.NewEquipRepair
  if repairCfg and repairCfg[1] then
    local repairMatId, repairMatNeedCount = repairCfg[1][1], repairCfg[1][2]
    local curNum = BagProxy.Instance:GetItemNumByStaticID(repairMatId, REPAIR_MATERIAL_SEARCH_BAGTYPES)
    self.repair_matdata = ItemData.new(0 < curNum and MaterialItemCell.MaterialType.Material or "None", repairMatId)
    self.repair_matdata.num = curNum
    self.repair_matCell:SetData(self.repair_matdata)
    self.repair_matCell:SetNeedNum(repairMatNeedCount)
  else
    LogUtility.WarningFormat("Cannot find NewEquipRepair of equipment {0}", nowData.staticData.id)
  end
end

function EquipRefineBord:UpdateRepairInfo()
  local nowData = self.itemData
  local refineEffect = nowData.equipInfo.equipData.RefineEffect
  local effectName, effectAddValue = next(refineEffect)
  if effectName and effectAddValue then
    local proName, addvalue = GameConfig.EquipEffect[effectName], effectAddValue * nowData.equipInfo.refinelv
    local pro, isPercent = Game.Config_PropName[effectName], false
    if pro then
      isPercent = pro.IsPercent == 1
    end
    self.repairEffect.text = proName
    self.repairRefineLevel.text = string.format(ZhString.EquipRefineBord_DamageTip, nowData.equipInfo.refinelv)
    if isPercent then
      addvalue = addvalue * 100
      self.repairNextEffect.text = string.format("+%s", tostring(addvalue) .. "%")
    else
      self.repairNextEffect.text = string.format("+%s", addvalue)
    end
  end
  self:UpdateRepairMaterial()
end

function EquipRefineBord:TryOpenQuickBuyView(id, count)
  local lackItem = self:GetUniqueTempLackItem(id, count)
  return QuickBuyProxy.Instance:TryOpenView(self:GetUniqueTempArrayWithElement(lackItem))
end

function EquipRefineBord:GetLackItem(id, count)
  return {id = id, count = count}
end

function EquipRefineBord:GetUniqueTempLackItem(id, count)
  TableUtility.TableClear(tempTable)
  tempTable.id = id
  tempTable.count = count
  return tempTable
end

function EquipRefineBord:GetUniqueTempArrayWithElement(element1, ...)
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

function EquipRefineBord:InitChooseBords()
  local chooseContainer = self:FindGO("ChooseContainer")
  self.chooseBord = EquipNewChooseBord.new(chooseContainer)
  self.materialchooseBord = EquipNewCountChooseBord.new(chooseContainer)
  self.materialchooseBord:Hide()
  self.materialchooseBord:AddEventListener(EquipChooseCellEvent.CountChooseChange, self.OnCountChooseChange, self)
  self:HideAllChooseBord()
end

function EquipRefineBord:OnCountChooseChange(cell)
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

function EquipRefineBord:_MaterialChooseValidFunc(data)
  if LOTTERY_REPAIR_MATERIAL_CFG[data.staticData.id] or Func_IsLotteryHeadwearRepairMat(data.staticData.id) then
    return true
  elseif EQUIP_REPAIR_MATERIAL_CFG[data.staticData.id] then
    return true
  end
  if data.equipInfo then
    local limitlv = GameConfig.EquipRefine.repair_stuff_max_lv or 6
    return limitlv >= data.equipInfo.refinelv
  end
  return false
end

function EquipRefineBord:ShowChooseRefineMaterialBord()
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

function EquipRefineBord:_RepairChooseFunc(data)
  if nil == data or nil == data.staticData then
    return
  end
  local sId = data.staticData.id
  local isRepairItemMat = nil ~= LOTTERY_REPAIR_MATERIAL_CFG[sId] or nil ~= Func_IsLotteryHeadwearRepairMat(sId) or nil ~= EQUIP_REPAIR_MATERIAL_CFG(sId)
  if not isRepairItemMat and nil == data.equipInfo then
    return
  end
  local _RepairChoose_ConfirmCall = function()
    self.chooseBord:Hide()
  end
  local _RepairChoose_CancelCall = function()
    self.chooseBord:SetChoose(self.repair_matdata)
  end
  if not isRepairItemMat and FunctionItemFunc.RecoverEquips(self:GetUniqueTempArrayWithElement(data), _RepairChoose_ConfirmCall, _RepairChoose_CancelCall) then
    return
  end
  self:UpdateRepairMaterial(data)
  self.chooseBord:Hide()
end

function EquipRefineBord:GetNowItemData()
  return self.itemData
end

function EquipRefineBord:SetTargetItem(itemData)
  self.itemData = itemData
  self:Refresh()
end

function EquipRefineBord:SetNpcguid(npcguid)
  self.refine_npcguid = npcguid
end

function EquipRefineBord:SetMaxRefineLv(maxRefinelv)
  self.outset_maxrefine = maxRefinelv
end

function EquipRefineBord:HideAllChooseBord()
  self.chooseBord:Hide()
  self.materialchooseBord:Hide()
end

function EquipRefineBord:ShowTempResult(result)
  if not self.resultSuccess then
    self.resultSuccess = self:FindGO("Successful")
  end
  if not self.resultFailed then
    self.resultFailed = self:FindGO("Failed")
  end
  self.resultCandidate = result == SceneItem_pb.EREFINERESULT_SUCCESS and self.resultSuccess or self.resultFailed
  self.resultCandidateTween = self.resultCandidate:GetComponent(TweenAlpha)
  if self.resultCandidate then
    TimeTickManager.Me():ClearTick(self, resultTickId)
    self.resultCandidate:SetActive(true)
    self.resultCandidateTween:ResetToBeginning()
    self.resultCandidateTween:PlayForward()
    TimeTickManager.Me():CreateOnceDelayTick(2000, function(self)
      self.resultCandidateTween:PlayReverse()
    end, self, resultTickId)
    self:PlayEffect()
  end
end

function EquipRefineBord:PlayEffect()
  self:PlayUIEffect(EffectMap.UI.ForgingSuccess, self.effContainerRq.gameObject, true, self.ForgingSuccessEffectHandle, self)
end

function EquipRefineBord.ForgingSuccessEffectHandle(effectHandle, owner)
  if owner then
    owner.effContainerRq:AddChild(effectHandle.gameObject)
  end
end

function EquipRefineBord:OnExit()
  self.repair_matCell:OnExit()
  TimeTickManager.Me():ClearTick(self)
  if self.chooseBord and self.chooseBord.datas then
    for _, data in pairs(self.chooseBord.datas) do
      if data.isShowRedTip then
        data.isShowRedTip = nil
      end
    end
  end
end

function EquipRefineBord:__OnViewDestroy()
  if self.__destroyed then
    return
  end
  self.__destroyed = true
  self:OnComponentDestroy()
  TableUtility.TableClear(self)
end
