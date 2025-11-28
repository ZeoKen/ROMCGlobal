ExtractionData = class("ExtractionData")

function ExtractionData:ctor(index)
  self.gridid = index
  self.itemid = 0
  self.refinelv = 0
  self.active = false
  self.got = true
  self.extractionLv = 0
end

function ExtractionData:Clone()
  local data = ExtractionData.new()
  data.gridid = self.gridid
  data.itemid = self.itemid
  data.refinelv = self.refinelv
  data.extractionLv = self.extractionLv
  data.active = self.active
  data.got = self.got
  return data
end

function ExtractionData:Update(serverdata)
  if serverdata then
    self.gridid = serverdata.gridid
    self.itemid = serverdata.itemid
    self.refinelv = serverdata.refinelv
    self.itemStaticData = Table_Item[self.itemid]
    self.extractionLv = serverdata.lv
  end
end

function ExtractionData:SetActive(b)
  self.active = b
end

function ExtractionData:Empty()
  self.itemid = 0
  self.refinelv = 0
  self.itemStaticData = nil
  self.active = false
  self.extractionLv = 0
end

function ExtractionData:Lock(b)
  self.got = not b
end

function ExtractionData:IsActive()
  return self.active
end

function ExtractionData:GetAttrType()
  local config = Table_EquipExtraction[self.itemid]
  return config and config.AttrType
end
