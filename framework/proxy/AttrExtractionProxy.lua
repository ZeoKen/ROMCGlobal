AttrExtractionProxy = class("AttrExtractionProxy", pm.Proxy)
AttrExtractionProxy.Instance = nil
AttrExtractionProxy.NAME = "AttrExtractionProxy"
autoImport("ExtractionData")
autoImport("ExtractionItemData")
autoImport("ExtractionCostData")
local FilterConfig = GameConfig.EquipExtractionFilter

function AttrExtractionProxy:ctor(proxyName, data)
  self.proxyName = proxyName or AttrExtractionProxy.NAME
  if AttrExtractionProxy.Instance == nil then
    AttrExtractionProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

local EquipExtractionConfig = GameConfig.EquipExtraction

function AttrExtractionProxy:Init()
  self.discountMap = {}
  if GameConfig.EquipExtraction then
    self.MaxCount = EquipExtractionConfig.GridCountDefault + EquipExtractionConfig.GridBuyLimit
    if self.extractionDataMap then
      TableUtility.TableClear(self.extractionDataMap)
    else
      self.extractionDataMap = {}
    end
    for i = 1, self.MaxCount do
      local single = ExtractionData.new(i)
      self.extractionDataMap[single.gridid] = single
    end
  end
  self:PreProcessUpgradeConfig()
end

function AttrExtractionProxy:PreProcessUpgradeConfig()
  if not GameConfig.ExtractLevelUp then
    return
  end
  self.upgradeEquipCostConfig = GameConfig.ExtractLevelUp.equip_cost
  self.upgradeMaterialCostConfig = {}
  for _, config in pairs(GameConfig.ExtractLevelUp.materials_cost) do
    for _, pos in ipairs(config.pos) do
      self.upgradeMaterialCostConfig[pos] = config.cost
    end
  end
end

function AttrExtractionProxy:RecvExtractionQueryUserCmd(data)
  if not self.extractionDataMap then
    return
  end
  local datas = data.datas
  local index = 1
  for i = 1, #datas do
    index = datas[i].gridid
    if self.extractionDataMap[index] then
      self.extractionDataMap[index]:Update(datas[i])
    end
  end
  self.gridCount = data.gridcount
  for i = self.gridCount + 1, self.MaxCount do
    self.extractionDataMap[i]:Lock(true)
  end
  local activeids = data.activeids
  if self.activeids then
    TableUtility.ArrayClear(self.activeids)
  else
    self.activeids = {}
  end
  for k, v in pairs(self.extractionDataMap) do
    self.extractionDataMap[k]:SetActive(false)
  end
  for i = 1, #activeids do
    index = activeids[i]
    table.insert(self.activeids, index)
    if self.extractionDataMap[index] then
      self.extractionDataMap[index]:SetActive(true)
    end
  end
  self.needUpdateItemData = true
end

function AttrExtractionProxy:RecvExtractionOperateUserCmd(data)
  if data and data.data then
    local index = data.data.gridid
    if not self.extractionDataMap[index] then
      local single = ExtractionData.new(index)
      self.extractionDataMap[index] = single
    end
    self.extractionDataMap[index]:Update(data.data)
    self.needUpdateItemData = true
  else
    redlog("not data.data")
  end
end

function AttrExtractionProxy:GetExtractionDataByGrid(gridid)
  if self.extractionDataMap and gridid then
    return self.extractionDataMap[gridid]
  else
    return nil
  end
end

function AttrExtractionProxy:GetExtractDataList()
  if self.gridList then
    TableUtility.ArrayClear(self.gridList)
  else
    self.gridList = {}
  end
  for k, v in pairs(self.extractionDataMap) do
    table.insert(self.gridList, self.extractionDataMap[k])
  end
  table.sort(self.gridList, function(a, b)
    return a.gridid < b.gridid
  end)
  return self.gridList
end

function AttrExtractionProxy:GetActiveExtraceCount()
  local count = 0
  for k, v in pairs(self.extractionDataMap) do
    if v:IsActive() then
      count = count + 1
    end
  end
  return count
end

function AttrExtractionProxy:RecvExtractionRemoveUserCmd(data)
  if data and data.success and self.extractionDataMap and data.gridid then
    self.extractionDataMap[data.gridid]:Empty()
    self.needUpdateItemData = true
  end
end

function AttrExtractionProxy:RecvExtractionActiveUserCmd(data)
  local newactiveids = {}
  local index = 1
  for i = 1, #data.activeids do
    index = data.activeids[i]
    newactiveids[index] = true
    if self.extractionDataMap and self.extractionDataMap[index] then
      self.extractionDataMap[index]:SetActive(true)
    end
  end
  for i = 1, #self.activeids do
    index = self.activeids[i]
    if not newactiveids[index] then
      self.extractionDataMap[index]:SetActive(false)
    end
  end
  if self.activeids then
    TableUtility.ArrayClear(self.activeids)
  else
    self.activeids = {}
  end
  for i = 1, #data.activeids do
    index = data.activeids[i]
    table.insert(self.activeids, index)
  end
  self.needUpdateItemData = true
end

function AttrExtractionProxy:RecvExtractionGridBuyUserCmd(data)
  if not self.extractionDataMap or not data then
    return
  end
  local newcount = data.gridcount
  for i = self.gridCount, newcount do
    if self.extractionDataMap[i] then
      self.extractionDataMap[i]:Lock(false)
    end
  end
  self.needUpdateItemData = true
end

function AttrExtractionProxy:RecvExtractionRefreshUserCmd(data)
  if not self.extractionDataMap or not data then
    return
  end
  if self.extractionDataMap[data.gridid] then
    self.extractionDataMap[data.gridid]:Update(data.data)
    self.needUpdateItemData = true
  end
end

function AttrExtractionProxy:InitIllustrationEquip()
  if self.initedEquip then
    return
  end
  self.initedEquip = true
  if not self.equipIData then
    self.equipIData = {}
  else
    TableUtility.TableClear(self.equipIData)
  end
  local attrType, equipVID, VIDType, VID, index
  for k, v in pairs(FilterConfig) do
    if not self.equipIData[k] then
      self.equipIData[k] = {}
    end
    if not self.recordMap then
      self.recordMap = {}
    else
      TableUtility.TableClear(self.recordMap)
    end
    for equipID, staticData in pairs(Table_EquipExtraction) do
      attrType = staticData.AttrType
      equipVID = Table_Equip[equipID] and Table_Equip[equipID].VID
      VIDType = math.floor(equipVID / 10000)
      VID = equipVID % 1000
      index = VIDType * 1000 + VID
      if not self.recordMap[index] and table.ContainsValue(v.AttrType, attrType) then
        table.insert(self.equipIData[k], equipID)
        self.recordMap[index] = true
      end
    end
  end
end

function AttrExtractionProxy:GetEquipDataByFilter(filterdata)
  self:InitIllustrationEquip()
  if not (self.equipIData and filterdata) or not self.equipIData[filterdata] then
    redlog("no data", filterdata)
    return
  end
  return self.equipIData[filterdata]
end

function AttrExtractionProxy:SetDiscount(params)
  if #params & 1 ~= 0 then
    redlog("GlobalActivity 萃取打折折扣配置错误")
    return
  end
  for i = 1, #params, 2 do
    self.discountMap[params[i]] = params[i + 1] / 10000
  end
end

function AttrExtractionProxy:ResetDiscount()
  TableUtility.TableClear(self.discountMap)
end

function AttrExtractionProxy:GetDiscount(id)
  return self.discountMap[id] or 1
end

function AttrExtractionProxy:UpdateItemDataList()
  if not self.needUpdateItemData or not self.extractionDataMap then
    return
  end
  self.needUpdateItemData = false
  self.allItemDataList = {}
  self.offenseItemDataList = {}
  self.defenseItemDataList = {}
  for _, extData in pairs(self.extractionDataMap) do
    if extData.itemid and extData.itemid > 0 then
      local itemData = ExtractionItemData.new("ExtractionItemData_" .. extData.gridid, extData.itemid)
      itemData:ParseFromExtractionData(extData)
      table.insert(self.allItemDataList, itemData)
      local attrType = extData:GetAttrType()
      if attrType == 1 then
        table.insert(self.offenseItemDataList, itemData)
      elseif attrType == 2 then
        table.insert(self.defenseItemDataList, itemData)
      end
    end
  end
end

function AttrExtractionProxy:SortExtractionItemDataList(dataList)
  if not dataList then
    return
  end
  table.sort(dataList, function(a, b)
    local isActiveA = a.IsExtractionActive and a:IsExtractionActive()
    local isActiveB = b.IsExtractionActive and b:IsExtractionActive()
    if isActiveA and not isActiveB then
      return true
    elseif not isActiveA and isActiveB then
      return false
    else
      local gridIdA = a.GetGridId and a:GetGridId()
      local gridIdB = b.GetGridId and b:GetGridId()
      return gridIdA and gridIdB and gridIdA < gridIdB or false
    end
  end)
end

function AttrExtractionProxy:GetAllItemDataList()
  if self.needUpdateItemData or not self.allItemDataList then
    self:UpdateItemDataList()
  end
  return self.allItemDataList
end

function AttrExtractionProxy:GetOffenseItemDataList()
  if self.needUpdateItemData or not self.offenseItemDataList then
    self:UpdateItemDataList()
  end
  return self.offenseItemDataList
end

function AttrExtractionProxy:GetDefenseItemDataList()
  if self.needUpdateItemData or not self.defenseItemDataList then
    self:UpdateItemDataList()
  end
  return self.defenseItemDataList
end

function AttrExtractionProxy:GetActiveItemData(attrType)
  local dataList
  if attrType == 1 then
    dataList = self:GetOffenseItemDataList()
  elseif attrType == 2 then
    dataList = self:GetDefenseItemDataList()
  end
  if dataList then
    for _, v in ipairs(dataList) do
      if v:IsExtractionActive() then
        return v
      end
    end
  end
end

function AttrExtractionProxy:GetActiveOffenseItemData()
  return self:GetActiveItemData(1)
end

function AttrExtractionProxy:GetActiveDefenseItemData()
  return self:GetActiveItemData(2)
end

function AttrExtractionProxy:GetActiveItemDataByEquipPos(pos)
  if pos == ItemUtil.EquipExtractionOffense then
    return self:GetActiveOffenseItemData()
  elseif pos == ItemUtil.EquipExtractionDefense then
    return self:GetActiveDefenseItemData()
  end
end

function AttrExtractionProxy:SelectUpgradeCostEquips(itemId, costNum)
  local selectedEquips = {}
  local selectedCount = 0
  if itemId and 0 < itemId and costNum and 0 < costNum then
    local DEFAULT_MATERIAL_SEARCH_BAGTYPES = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.default or {1, 9}
    local REFINE_MATERIAL_SEARCH_BAGTYPES = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.refine or DEFAULT_MATERIAL_SEARCH_BAGTYPES
    if not self.upgradeItemData then
      self.upgradeItemData = ItemData.new("ExtractionItem", itemId)
    else
      self.upgradeItemData:ResetData("ExtractionItem", itemId)
    end
    local defaultDatas = BlackSmithProxy.Instance:GetMaterialEquips_ByVID(self.upgradeItemData, REFINE_MATERIAL_SEARCH_BAGTYPES, nil, nil, nil, true)
    for _, data in ipairs(defaultDatas) do
      if data.num and 0 < data.num then
        local cloneData = data:Clone()
        local ownedNum = cloneData.num
        if costNum > ownedNum then
          costNum = costNum - ownedNum
          table.insert(selectedEquips, cloneData)
          selectedCount = selectedCount + ownedNum
        else
          cloneData.ownedNum = cloneData.num
          cloneData:SetItemNum(costNum)
          table.insert(selectedEquips, cloneData)
          selectedCount = selectedCount + costNum
          costNum = 0
        end
      end
    end
  end
  return selectedEquips, selectedCount
end

function AttrExtractionProxy:GetUpgradeCostConfig(extractionData)
  local costDataList = {}
  local selectedEquips, selectedCount
  if extractionData then
    local refinelv = extractionData.refinelv or 0
    local equipCost = self.upgradeEquipCostConfig[refinelv + 1]
    if equipCost and 0 < equipCost then
      local costEquipId = BlackSmithProxy.GetMinCostMaterialID(extractionData.itemid)
      local composeEquipConfig = Table_EquipCompose[costEquipId]
      if composeEquipConfig then
        costEquipId = composeEquipConfig.Material[1].id
      end
      selectedEquips, selectedCount = self:SelectUpgradeCostEquips(costEquipId, equipCost)
      table.insert(costDataList, ExtractionCostData.new(costEquipId, equipCost, selectedCount, nil, true))
    end
    local equipConfig = Table_Equip[extractionData.itemid]
    local siteConfig = GameConfig.EquipType[equipConfig.EquipType]
    local site = siteConfig and siteConfig.site and siteConfig.site[1]
    local matCostConfig = equipConfig and self.upgradeMaterialCostConfig[site]
    local matCost = matCostConfig and matCostConfig[refinelv + 1]
    if matCost then
      for _, matItemConfig in ipairs(matCost) do
        local itemId = matItemConfig[1]
        local itemNum = matItemConfig[2]
        local owned = 0
        if itemId == GameConfig.MoneyId.Zeny then
          owned = MyselfProxy.Instance:GetROB()
        elseif itemId == GameConfig.MoneyId.Lottery then
          owned = MyselfProxy.Instance:GetLottery()
        else
          owned = BagProxy.Instance:GetAllItemNumByStaticID(itemId)
        end
        table.insert(costDataList, ExtractionCostData.new(itemId, itemNum, owned))
      end
    end
  end
  return costDataList, selectedEquips, selectedCount
end
