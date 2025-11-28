autoImport("Asset_Furniture")
NFurniture_BluePrint = class("NFurniture_BluePrint")
local BuildingRotations = {
  [1] = BuildingGrid.EBuildingRotation.E0,
  [2] = BuildingGrid.EBuildingRotation.E90,
  [3] = BuildingGrid.EBuildingRotation.E180,
  [4] = BuildingGrid.EBuildingRotation.E270
}
local TAG = 0

function NFurniture_BluePrint:_SetTag()
  TAG = TAG - 1
  self.tag = TAG
end

function NFurniture_BluePrint:ctor(index, staticID, parent, callBack)
  self.isAlive = true
  self.index = index
  self.id = "bp" .. index
  self.staticID = staticID
  self.staticData = Table_HomeFurniture[staticID]
  self.assetFurniture = Asset_Furniture.new(staticID, parent, function(furniture)
    self.assetFurniture = furniture
    if not self.assetFurniture.gameObject then
      self:Destroy()
      return
    end
    self.gameObject = self.assetFurniture.gameObject
    self.trans = self.assetFurniture.trans
    self:Init(id, staticID)
    if callBack then
      callBack(self)
    end
  end)
end

function NFurniture_BluePrint:Init(id, staticID)
  self:_SetTag()
  self.rotationIndex = 1
  self.assetFurniture:SetName(self.staticData.NameZh)
  self.isAutoRotate = type(self.staticData.FixedPlanes) == "table" and #self.staticData.FixedPlanes > 0
  self.isHideWithWall = self.isAutoRotate and self.staticData.Altitude
  self.centerCellHeight = self.staticData.Altitude or 0 + (self.staticData.Height or 0) / 2
  self.assetFurniture:SetAlpha(0.5)
  self.assetFurniture:SetColliderName(self.id)
  self.assetFurniture:SetColliderLayer(Game.ELayer.HomeFurniture_BP)
  self.inited = true
end

function NFurniture_BluePrint:GetRotationAngle()
  return BuildingRotations[self.rotationIndex] or self.assetFurniture:GetLocalEulerAngleY()
end

function NFurniture_BluePrint:SetRotationAngle(angle)
  if not angle then
    LogUtility.Error("Angle Is Nil!")
    return
  end
  if self:GetRotationAngle() == angle then
    return
  end
  for i = 1, #BuildingRotations do
    if math.abs(angle - BuildingRotations[i]) < 10 then
      self.rotationIndex = i
    end
  end
  self.assetFurniture:SetLocalEulerAngleY(angle)
end

function NFurniture_BluePrint:IsAutoRotate()
  return self.isAutoRotate
end

function NFurniture_BluePrint:IsHideWithWall()
  return self.isHideWithWall
end

function NFurniture_BluePrint:GetInstanceID()
  return self.assetFurniture:GetInstanceID() or "BPFurniture" .. self.tag
end

function NFurniture_BluePrint:Alive()
  return self.isAlive == true
end

function NFurniture_BluePrint:SetCurCell(floorIndex, row, col)
  self:PlaceOnCell(floorIndex, row, col)
end

function NFurniture_BluePrint:PlaceOnCell(floorIndex, row, col)
  self.placeFloor = floorIndex
  self.placeRow = row
  self.placeCol = col
  self.placeAngle = self:GetRotationAngle()
end

function NFurniture_BluePrint:IsPlacedSuccess()
  return self.isPlacedSuccess == true
end

function NFurniture_BluePrint:RefreshStatus()
  self.isPlacedSuccess = false
  local furnitures = HomeManager.Me():GetFurnituresMap()
  for id, nFurniture in pairs(furnitures) do
    if self:Equals(nFurniture) then
      self.isPlacedSuccess = true
      self.assetFurniture:SetActive(false)
      return true
    end
  end
  furnitures = HomeManager.Me():GetClientFurnituresMap()
  for id, nFurniture in pairs(furnitures) do
    if self:Equals(nFurniture) then
      self.isPlacedSuccess = true
      self.assetFurniture:SetActive(false)
      return true
    end
  end
  self.assetFurniture:SetActive(true)
  return false
end

function NFurniture_BluePrint:Equals(nFurniture)
  return nFurniture.staticID == self.staticID and nFurniture.placeFloor == self.placeFloor and nFurniture.placeRow == self.placeRow and nFurniture.placeCol == self.placeCol and nFurniture.placeAngle == self.placeAngle
end

function NFurniture_BluePrint:Destroy(delayDestroy)
  if self.assetFurniture then
    self.assetFurniture:Destroy(delayDestroy)
  end
  self.isAlive = false
  self.inited = false
  self.index = nil
end
