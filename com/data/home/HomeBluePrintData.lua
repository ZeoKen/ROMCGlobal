HomeBluePrintData = class("HomeBluePrintData")

function HomeBluePrintData:ctor(staticID)
  self.inited = false
  self.furnitureInfoMap = {}
  self.staticID = staticID
  self.staticData = Table_HomeOfficialBluePrint and Table_HomeOfficialBluePrint[staticID]
  self.mapID = self.staticData and self.staticData.MapID
  self:InitFurnitureList()
end

function HomeBluePrintData:InitFurnitureList()
  if not self.staticData then
    return
  end
  pcall(function()
    autoImport("Table_" .. self.staticData.BPName)
  end)
  self.furnitureBPStaticDatas = _G["Table_" .. self.staticData.BPName]
  if not self.furnitureBPStaticDatas then
    LogUtility.Error("找不到系统蓝图数据：" .. tostring(self.staticData.BPName))
    return
  end
  self.haveFurnitureNum = 0
  self.totalFurnitureNum = #self.furnitureBPStaticDatas
  TableUtility.TableClear(self.furnitureInfoMap)
  local simpleDataMap = HomeProxy.Instance:GetMyFurnitureSimpleDatas()
  local tbItem = Table_Item
  local staticID, singleData, itemSData, typeItems, haveFurnitureNum
  for i = 1, self.totalFurnitureNum do
    staticID = self.furnitureBPStaticDatas[i].FurnitureId
    singleData = self.furnitureInfoMap[staticID]
    if not singleData then
      haveFurnitureNum = BagProxy.Instance:GetItemNumByStaticID(staticID, BagProxy.BagType.Furniture) or 0
      itemSData = tbItem[staticID]
      typeItems = simpleDataMap and simpleDataMap[itemSData and itemSData.Type]
      if typeItems then
        for guid, staticData in pairs(typeItems) do
          if staticData.id == staticID then
            haveFurnitureNum = haveFurnitureNum + 1
          end
        end
      end
      singleData = {
        staticID = staticID,
        staticData = Table_HomeFurniture[staticID],
        haveNum = haveFurnitureNum,
        needNum = 0
      }
      self.furnitureInfoMap[staticID] = singleData
    end
    singleData.needNum = singleData.needNum + 1
  end
  for staticID, info in pairs(self.furnitureInfoMap) do
    self.haveFurnitureNum = self.haveFurnitureNum + math.min(info.haveNum, info.needNum)
  end
  self.inited = true
end

function HomeBluePrintData:RefreshBagNum()
  self.haveFurnitureNum = 0
  local simpleDataMap = HomeProxy.Instance:GetMyFurnitureSimpleDatas()
  local tbItem = Table_Item
  local itemSData, typeItems
  for staticID, info in pairs(self.furnitureInfoMap) do
    info.haveNum = BagProxy.Instance:GetItemNumByStaticID(staticID, BagProxy.BagType.Furniture) or 0
    itemSData = tbItem[staticID]
    typeItems = simpleDataMap and simpleDataMap[itemSData and itemSData.Type]
    if typeItems then
      for guid, staticData in pairs(typeItems) do
        if staticData.id == staticID then
          info.haveNum = info.haveNum + 1
        end
      end
    end
    self.haveFurnitureNum = self.haveFurnitureNum + math.min(info.haveNum, info.needNum)
  end
end

function HomeBluePrintData:GetFurnitureNeedNum(FurnitureId)
  local furnitureInfo = self.furnitureInfoMap[FurnitureId]
  return furnitureInfo and furnitureInfo.needNum or 0
end

function HomeBluePrintData:CheckIsFinished()
  for i = 1, #self.furnitureBPStaticDatas do
    if not self:CheckSingleBPFurnitureFinished(self.furnitureBPStaticDatas[i]) then
      return false
    end
  end
  return true
end

function HomeBluePrintData:CheckSingleBPFurnitureFinished(bpStaticData)
  local furnitures = HomeManager.Me():GetFurnituresMap()
  for id, nFurniture in pairs(furnitures) do
    if self:IsBPEqualsFurniture(nFurniture, bpStaticData) then
      return true
    end
  end
  furnitures = HomeManager.Me():GetClientFurnituresMap()
  for id, nFurniture in pairs(furnitures) do
    if self:IsBPEqualsFurniture(nFurniture, bpStaticData) then
      return true
    end
  end
  return false
end

function HomeBluePrintData:IsBPEqualsFurniture(nFurniture, bpStaticData)
  return nFurniture.staticID == bpStaticData.FurnitureId and nFurniture.placeFloor == bpStaticData.Floor and nFurniture.placeRow == bpStaticData.Row and nFurniture.placeCol == bpStaticData.Col and nFurniture.placeAngle == bpStaticData.Angle
end
