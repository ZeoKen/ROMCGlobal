autoImport("ItemData")
ExtractionItemData = class("ExtractionItemData", ItemData)

function ExtractionItemData:ParseFromExtractionData(extData)
  if not extData then
    return
  end
  self.extractionInfo = extData:Clone()
  if self.equipInfo then
    self.equipInfo.refinelv = extData.extractionLv or 0
  end
end

function ExtractionItemData:IsExtractionActive()
  if self.extractionInfo then
    local extData = AttrExtractionProxy.Instance:GetExtractionDataByGrid(self.extractionInfo.gridid)
    return extData and extData.active
  end
end

function ExtractionItemData:GetGridId()
  return self.extractionInfo and self.extractionInfo.gridid
end
