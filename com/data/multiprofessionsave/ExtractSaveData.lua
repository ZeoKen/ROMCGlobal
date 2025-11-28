ExtractSaveData = class("ExtractSaveData")
autoImport("ExtractionData")

function ExtractSaveData:ctor(serverdata)
  self.gridCount = serverdata.gridcount
  self.extracts = {}
  local datas = serverdata.datas
  local EquipExtractionConfig = GameConfig.EquipExtraction
  self.MaxCount = EquipExtractionConfig.GridCountDefault + EquipExtractionConfig.GridBuyLimit
  for i = 1, self.MaxCount do
    local single = ExtractionData.new(i)
    self.extracts[single.gridid] = single
  end
  for i = 1, #datas do
    index = datas[i].gridid
    if self.extracts[index] then
      self.extracts[index]:Update(datas[i])
    end
  end
  self.gridCount = math.max(GameConfig.EquipExtraction.GridCountDefault, self.gridCount)
  for i = self.gridCount + 1, self.MaxCount do
    self.extracts[i]:Lock(true)
  end
  local activeids = serverdata.activeids
  if self.activeids then
    TableUtility.ArrayClear(self.activeids)
  else
    self.activeids = {}
  end
  for k, v in pairs(self.extracts) do
    self.extracts[k]:SetActive(false)
  end
  for i = 1, #activeids do
    index = activeids[i]
    table.insert(self.activeids, index)
    if self.extracts[index] then
      self.extracts[index]:SetActive(true)
    end
  end
  self.cacheExtractItemData = {}
end

function ExtractSaveData:GetActiveItemData(attrType)
  local cache_data = self.cacheExtractItemData[attrType]
  if not cache_data then
    for grid, data in pairs(self.extracts) do
      if data.active and data:GetAttrType() == attrType then
        cache_data = ExtractionItemData.new("extractSave", data.itemid)
        cache_data:ParseFromExtractionData(data)
        self.cacheExtractItemData[attrType] = cache_data
        break
      end
    end
  end
  return cache_data
end

function ExtractSaveData:GetGridCount()
  return self.gridCount or 0
end

function ExtractSaveData:GetActiveCount()
  return #self.activeids or 0
end

function ExtractSaveData:GetExtractData()
  return self.extracts
end
