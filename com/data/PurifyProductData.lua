autoImport("PurifyMaterialData")
autoImport("Table_Item")
PurifyProductData = class("PurifyProductData")

function PurifyProductData:ctor(data)
  self:Init()
  self:SetData(data)
  self.PurifyProductsConfig = GameConfig.PurifyProducts
end

function PurifyProductData:Init()
  self.isChoose = false
  self.materials = {}
end

function PurifyProductData:SetData(data)
  self.productItemID = data.productid
  self.showNewmark = data.newmark
  self.close = data.close
  self.showConfirmMsg = data.confirm
  if data.times then
    self.frequencyType = data.times.type
    self.totalTimes = data.times.totaltimes
    self.leftTimes = data.times.lefttimes
  end
  if data.materials then
    local materials = data.materials
    self.materials = {}
    local purifyConfig
    for _, config in pairs(Table_PurifyProducts) do
      if config.ProductId == data.productid then
        purifyConfig = config
        break
      end
    end
    if purifyConfig and purifyConfig.QualityCombine then
      local qualityGroups = {}
      for i = 1, #materials do
        local materialData = materials[i]
        local single = PurifyMaterialData.new(materialData)
        local itemConfig = Table_Item[materialData.itemid]
        if itemConfig and itemConfig.Quality then
          local quality = itemConfig.Quality
          if not qualityGroups[quality] then
            qualityGroups[quality] = {}
          end
          qualityGroups[quality][#qualityGroups[quality] + 1] = single
        end
      end
      local slotIndex = 1
      for quality, requirements in pairs(purifyConfig.QualityCombine) do
        local qualityMaterials = qualityGroups[quality] or {}
        local numRequirements = #requirements
        local materialsPerSlot = math.max(1, math.floor(#qualityMaterials / numRequirements))
        for reqIndex = 1, numRequirements do
          local slotMaterials = {}
          local startIndex = (reqIndex - 1) * materialsPerSlot + 1
          local endIndex = math.min(reqIndex * materialsPerSlot, #qualityMaterials)
          if reqIndex == numRequirements then
            endIndex = #qualityMaterials
          end
          for i = startIndex, endIndex do
            if qualityMaterials[i] then
              slotMaterials[#slotMaterials + 1] = qualityMaterials[i]
            end
          end
          self.materials[slotIndex] = {
            quality = quality,
            requiredNum = requirements[reqIndex],
            materials = slotMaterials
          }
          xdlog("slotIndex", slotIndex, quality, requirements[reqIndex], #slotMaterials)
          slotIndex = slotIndex + 1
        end
      end
    end
  end
end

function PurifyProductData:GetMaterials()
  return self.materials
end

function PurifyProductData:SetChoose(isChoose)
  self.isChoose = isChoose
end

function PurifyProductData:IsChoose()
  return self.isChoose
end

function PurifyProductData:IsSeasonItem()
  if self.close and self.PurifyProductsConfig.SeasonItem then
    return self.close, self.PurifyProductsConfig.SeasonItem[self.productItemID]
  end
  return self.close
end

function PurifyProductData:GetConfirmMsg()
  if self.confirm and self.PurifyProductsConfig.ConfirmMsg then
    return self.confirm, self.PurifyProductsConfig.ConfirmMsg[self.productItemID]
  end
  return self.confirm
end

function PurifyProductData:GetProductLimit()
  if self.totalTimes and self.totalTimes > 0 then
    return self.leftTimes, self.totalTimes
  end
  return self.leftTimes
end
