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
  local attrType = extData:GetAttrType()
  local cardConfig = self:GetExtractionCardConfig(attrType)
  self.cardSlotNum = cardConfig and cardConfig.CardSlot or 0
  self:SetEquipCards(extData.cards)
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

function ExtractionItemData:GetMaxCardSlot()
  return self.cardSlotNum or 0
end

function ExtractionItemData:GetExtractionCardConfig(attrType)
  attrType = attrType or self.extractionInfo and self.extractionInfo:GetAttrType()
  local config = GameConfig.EquipExtraction and GameConfig.EquipExtraction.ExtractionAttrCard
  return config and config[attrType]
end

function ExtractionItemData:GetExtractionCardPoses()
  local config = self:GetExtractionCardConfig()
  return config and config.CardPos
end

function ExtractionItemData:GetExtractionEquipPos()
  if self.extractionInfo then
    local attrType = self.extractionInfo:GetAttrType()
    if attrType == 1 then
      return ItemUtil.EquipExtractionOffense
    elseif attrType == 2 then
      return ItemUtil.EquipExtractionDefense
    end
  end
end
