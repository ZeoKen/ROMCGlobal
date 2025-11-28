BuildingGrid = class("BuildingGrid")
BuildingGrid.m_CellSize = 0.5
BuildingGrid.m_BuildingGridData = nil
BuildingGrid.m_WallCells = nil
BuildingGrid.m_TemplateFurnitures = {}
BuildingGrid.m_Furnitures = {}
BuildingGrid.m_RightFurnitureCells = nil
BuildingGrid.m_WrongFurnitureCells = nil
BuildingGrid.EBuildingCellType = {
  EGround = 0,
  EGroundWithWall = 1,
  EWall = 2,
  EAir = 3,
  EObstacle = 4,
  EUnavailableFloor = 5
}
BuildingGrid.EBuildingDirection = {
  ENone = 0,
  EForward = 1,
  EBack = 2,
  ELeft = 3,
  ERight = 4,
  EForwardLeft = 5,
  EForwardRight = 6,
  EBackLeft = 7,
  EBackRight = 8
}
BuildingGrid.DirectionRotationMap = {
  [BuildingGrid.EBuildingDirection.EForward] = {
    [0] = 1,
    [90] = 3,
    [180] = 2,
    [270] = 4
  },
  [BuildingGrid.EBuildingDirection.EBack] = {
    [0] = 2,
    [90] = 4,
    [180] = 1,
    [270] = 3
  },
  [BuildingGrid.EBuildingDirection.ELeft] = {
    [0] = 3,
    [90] = 2,
    [180] = 4,
    [270] = 1
  },
  [BuildingGrid.EBuildingDirection.ERight] = {
    [0] = 4,
    [90] = 1,
    [180] = 3,
    [270] = 2
  }
}
BuildingGrid.EBuildingRotation = {
  E0 = 0,
  E90 = 90,
  E180 = 180,
  E270 = 270
}
BuildingGrid.EFurniturePlaceType = {
  ENormal = 1,
  ECloseToWall = 2,
  EOnGround = 3,
  EOnWall = 4
}
BuildingGrid.EPlaceFurnitureResult = {
  ESuccess = 0,
  EOutOfRange = 1,
  EObstacle = 2,
  ENotEmpty = 3,
  EExtraNotEmpty = 4,
  EWrongPosition = 5,
  EWrongDirection = 6,
  EExist = 7,
  EWrongConfig = 8,
  ETemplateNotFound = 9,
  EBeyondTheHight = 10
}

function BuildingGrid:ctor(data)
  self.m_BuildingGridData = data
  self.m_WallCells = {}
  for index, floorData in ipairs(self.m_BuildingGridData) do
    local wallCells = {}
    for i = 1, floorData.row do
      for j = 1, floorData.col do
        local cellValue = self:GetCellData(self.m_BuildingGridData[index], i, j, 1)
        if self:GetTypeOfCell(cellValue) == BuildingGrid.EBuildingCellType.EGroundWithWall then
          table.insert(wallCells, {i, j})
        end
      end
    end
    self.m_WallCells[index] = wallCells
  end
end

function BuildingGrid:GetCellData(floor, cellRow, cellCol, cellHeight)
  local index = (cellHeight - 1) * floor.row * floor.col + (cellRow - 1) * floor.col + cellCol
  return floor.cells[index]
end

function BuildingGrid:GetTypeOfCell(cellValue)
  return cellValue % 10
end

function BuildingGrid:GetWallDirectionOfCell(cellValue)
  return math.floor(cellValue % 100 / 10)
end

function BuildingGrid:IsEmptyOfCell(cellValue)
  local value = math.floor(cellValue % 1000 / 100)
  return value == 0
end

function BuildingGrid:SetEmptyOfCell(floorIndex, cellRow, cellCol, cellHeight, isEmpty)
  local floor = self.m_BuildingGridData[floorIndex]
  local index = (cellHeight - 1) * floor.row * floor.col + (cellRow - 1) * floor.col + cellCol
  local cellValue = floor.cells[index]
  local lValue = math.floor(cellValue % 100)
  local hValue = math.floor(cellValue / 1000) * 1000
  if isEmpty then
    floor.cells[index] = hValue + lValue
  else
    floor.cells[index] = hValue + lValue + 100
  end
end

function BuildingGrid:IsGroundExtraEmptyOfCell(cellValue)
  local value = math.floor(cellValue % 10000 / 1000)
  return value == 0
end

function BuildingGrid:SetGroundExtraEmptyOfCell(floorIndex, cellRow, cellCol, cellHeight, isEmpty)
  local floor = self.m_BuildingGridData[floorIndex]
  local index = (cellHeight - 1) * floor.row * floor.col + (cellRow - 1) * floor.col + cellCol
  local cellValue = floor.cells[index]
  local lValue = math.floor(cellValue % 1000)
  local hValue = math.floor(cellValue / 10000) * 10000
  if isEmpty then
    floor.cells[index] = hValue + lValue
  else
    floor.cells[index] = hValue + lValue + 1000
  end
end

function BuildingGrid:IsWallExtraEmptyOfCell(cellValue)
  local value = math.floor(cellValue % 100000 / 10000)
  return value == 0
end

function BuildingGrid:SetWallExtraEmptyOfCell(floorIndex, cellRow, cellCol, cellHeight, isEmpty)
  local floor = self.m_BuildingGridData[floorIndex]
  local index = (cellHeight - 1) * floor.row * floor.col + (cellRow - 1) * floor.col + cellCol
  local cellValue = floor.cells[index]
  local lValue = math.floor(cellValue % 10000)
  local hValue = math.floor(cellValue / 100000) * 100000
  if isEmpty then
    floor.cells[index] = hValue + lValue
  else
    floor.cells[index] = hValue + lValue + 10000
  end
end

function BuildingGrid:GetWallIdOfCell(cellValue)
  return math.floor(cellValue % 10000000 / 100000)
end

function BuildingGrid:RegisterFurnitureData(templateId, rowCount, colCount, beginHeight, endHeight, dirs1, dirs2, cellType)
  local furnitureData = self.m_TemplateFurnitures[templateId]
  if furnitureData == nil then
    local isEvenRow = rowCount % 2 == 0
    local isEvenCol = colCount % 2 == 0
    local halfRowCount = math.ceil(rowCount / 2)
    local halfColCount = math.ceil(colCount / 2)
    local furnitureCells = {}
    for h = beginHeight, endHeight do
      for r = 1, rowCount do
        for c = 1, colCount do
          local cellRow = 0
          if isEvenRow then
            if r <= halfRowCount then
              cellRow = r - halfRowCount - 1
            else
              cellRow = r - halfRowCount
            end
          else
            cellRow = r - halfRowCount
          end
          local cellCol = 0
          if isEvenCol then
            if c <= halfColCount then
              cellCol = c - halfColCount - 1
            else
              cellCol = c - halfColCount
            end
          else
            cellCol = c - halfColCount
          end
          table.insert(furnitureCells, {
            row = math.tointeger(cellRow),
            col = math.tointeger(cellCol),
            height = h,
            cellType = cellType
          })
        end
      end
    end
    furnitureData = {
      cells = furnitureCells,
      dirs1 = dirs1,
      dirs2 = dirs2,
      row = rowCount,
      col = colCount,
      bHeight = beginHeight,
      eHeight = endHeight
    }
    self.m_TemplateFurnitures[templateId] = furnitureData
    return furnitureData, true
  else
    return furnitureData, false
  end
end

function BuildingGrid:CalculatePlacedFurnitureData(targetRow, targetCol, rotation, furnitureData)
  local forward = -10000
  local back = 10000
  local left = 10000
  local right = -10000
  local sinRotation = math.floor(math.sin(rotation * 3.1415926 / 180) + 0.1)
  local cosRotation = math.floor(math.cos(rotation * 3.1415926 / 180) + 0.1)
  local furnitureRow = furnitureData.row
  local furnitureCol = furnitureData.col
  if rotation == 90 or rotation == 270 then
    furnitureRow = furnitureData.col
    furnitureCol = furnitureData.row
  end
  local furnitureCells = {}
  for i, furnitureCellData in ipairs(furnitureData.cells) do
    local cellRow = sinRotation * furnitureCellData.col + cosRotation * furnitureCellData.row
    local cellCol = cosRotation * furnitureCellData.col - sinRotation * furnitureCellData.row
    if furnitureRow % 2 == 0 then
      cellRow = math.ceil(targetRow + cellRow - 0.5 * (cellRow / math.abs(cellRow)))
    else
      cellRow = targetRow + cellRow
    end
    if forward < cellRow then
      forward = cellRow
    end
    if back > cellRow then
      back = cellRow
    end
    if furnitureCol % 2 == 0 then
      cellCol = math.ceil(targetCol + cellCol - 0.5 * (cellCol / math.abs(cellCol)))
    else
      cellCol = targetCol + cellCol
    end
    if right < cellCol then
      right = cellCol
    end
    if left > cellCol then
      left = cellCol
    end
    table.insert(furnitureCells, {
      row = cellRow,
      col = cellCol,
      height = furnitureCellData.height,
      cellType = furnitureCellData.cellType
    })
  end
  local dirs1 = {}
  for i, dir in ipairs(furnitureData.dirs1) do
    table.insert(dirs1, self.DirectionRotationMap[dir][rotation])
  end
  local dirs2 = {}
  for i, dir in ipairs(furnitureData.dirs2) do
    table.insert(dirs2, self.DirectionRotationMap[dir][rotation])
  end
  return {
    cells = furnitureCells,
    dirs1 = dirs1,
    dirs2 = dirs2,
    row = furnitureRow,
    col = furnitureCol,
    bHeight = furnitureData.bHeight,
    eHeight = furnitureData.eHeight
  }, forward, back, left, right
end

function BuildingGrid:RecordFurnitureCells(floor, furnitureCells, beginHeight, wrongType)
  for i, furnitureCellData in ipairs(furnitureCells) do
    local cellRow = furnitureCellData.row
    local cellCol = furnitureCellData.col
    local cellHeight = furnitureCellData.height
    if cellHeight == beginHeight then
      local wrong = false
      if wrongType == BuildingGrid.EPlaceFurnitureResult.ESuccess then
        wrong = false
      elseif wrongType == BuildingGrid.EPlaceFurnitureResult.EOutOfRange then
        if cellRow > floor.row or cellRow <= 0 or cellCol <= 0 or cellCol > floor.col then
          wrong = true
        end
      elseif wrongType == BuildingGrid.EPlaceFurnitureResult.EObstacle then
        local cellValue = self:GetCellData(floor, cellRow, cellCol, cellHeight)
        local cellType = self:GetTypeOfCell(cellValue)
        if cellType == BuildingGrid.EBuildingCellType.EObstacle then
          wrong = true
        end
      elseif wrongType == BuildingGrid.EPlaceFurnitureResult.ENotEmpty then
        local cellValue = self:GetCellData(floor, cellRow, cellCol, cellHeight)
        if not self:IsEmptyOfCell(cellValue) then
          wrong = true
        end
      elseif wrongType == BuildingGrid.EPlaceFurnitureResult.EExtraNotEmpty then
        local cellValue = self:GetCellData(floor, cellRow, cellCol, cellHeight)
        if not self:IsGroundExtraEmptyOfCell(cellValue) or not self:IsWallExtraEmptyOfCell(cellValue) then
          wrong = true
        end
      else
        wrong = true
      end
      if wrong then
        table.insert(self.m_WrongFurnitureCells, {row = cellRow, col = cellCol})
      else
        table.insert(self.m_RightFurnitureCells, {row = cellRow, col = cellCol})
      end
    end
  end
end

function BuildingGrid:CheckFurnitureDirection(furnitureDirection, wallDirection)
  if furnitureDirection == BuildingGrid.EBuildingDirection.EForward then
    return wallDirection == BuildingGrid.EBuildingDirection.EForward or wallDirection == BuildingGrid.EBuildingDirection.EForwardLeft or wallDirection == BuildingGrid.EBuildingDirection.EForwardRight
  elseif furnitureDirection == BuildingGrid.EBuildingDirection.EBack then
    return wallDirection == BuildingGrid.EBuildingDirection.EBack or wallDirection == BuildingGrid.EBuildingDirection.EBackLeft or wallDirection == BuildingGrid.EBuildingDirection.EBackRight
  elseif furnitureDirection == BuildingGrid.EBuildingDirection.ELeft then
    return wallDirection == BuildingGrid.EBuildingDirection.ELeft or wallDirection == BuildingGrid.EBuildingDirection.EForwardLeft or wallDirection == BuildingGrid.EBuildingDirection.EBackLeft
  elseif furnitureDirection == BuildingGrid.EBuildingDirection.ERight then
    return wallDirection == BuildingGrid.EBuildingDirection.ERight or wallDirection == BuildingGrid.EBuildingDirection.EForwardRight or wallDirection == BuildingGrid.EBuildingDirection.EBackRight
  else
    return false
  end
end

function BuildingGrid:CheckFurniture(floor, furnitureData, forwardRow, backRow, leftCol, rightCol, rotation)
  if forwardRow > floor.row or backRow <= 0 or leftCol <= 0 or rightCol > floor.col then
    return 2, nil
  end
  if furnitureData.eHeight > floor.height then
    return 4, nil
  end
  local floorCells = {
    [BuildingGrid.EBuildingDirection.EForward] = {},
    [BuildingGrid.EBuildingDirection.EBack] = {},
    [BuildingGrid.EBuildingDirection.ELeft] = {},
    [BuildingGrid.EBuildingDirection.ERight] = {}
  }
  for i = leftCol, rightCol do
    table.insert(floorCells[BuildingGrid.EBuildingDirection.EForward], self:GetCellData(floor, forwardRow, i, 1))
  end
  for i = leftCol, rightCol do
    table.insert(floorCells[BuildingGrid.EBuildingDirection.EBack], self:GetCellData(floor, backRow, i, 1))
  end
  for i = backRow, forwardRow do
    table.insert(floorCells[BuildingGrid.EBuildingDirection.ELeft], self:GetCellData(floor, i, leftCol, 1))
  end
  for i = backRow, forwardRow do
    table.insert(floorCells[BuildingGrid.EBuildingDirection.ERight], self:GetCellData(floor, i, rightCol, 1))
  end
  local check = function(dir)
    for i, v in ipairs(floorCells[dir]) do
      local floorCellType = self:GetTypeOfCell(v)
      if floorCellType ~= BuildingGrid.EBuildingCellType.EGroundWithWall then
        return false
      end
      if not self:CheckFurnitureDirection(dir, self:GetWallDirectionOfCell(v)) then
        return false
      end
    end
    return true
  end
  local backDir = self.DirectionRotationMap[BuildingGrid.EBuildingDirection.EBack][rotation]
  local backFlag = check(backDir)
  local dirs = {}
  for i, dir in ipairs(furnitureData.dirs1) do
    if not check(dir) then
      return 1, nil, backFlag
    end
    table.insert(dirs, dir)
  end
  if #furnitureData.dirs2 == 0 then
    return 0, dirs, backFlag
  else
    local result = 1
    for i, dir in ipairs(furnitureData.dirs2) do
      if check(dir) then
        result = 0
        table.insert(dirs, dir)
      end
    end
    return result, dirs, backFlag
  end
end

function BuildingGrid:MoveFurniture(id, templateId, floorIndex, currentRow, currentCol, currentRotation, deltaRow, deltaCol, closeToWall)
  if closeToWall == true then
    local _, _, _, targetRow, targetCol, newFloorIndex = self:MoveFurnitureInternal(id, templateId, floorIndex, currentRow, currentCol, currentRotation, deltaRow, deltaCol)
    local worldX, worldZ = self:ConvertRowAndColToWorldPosition(newFloorIndex, targetRow, targetCol)
    local newRotation, flag = self:CalculateRotationCloseToNearestWall(templateId, worldX, worldZ)
    local r1, r2, r3, r4, r5 = self:RotateFurniture(id, templateId, newFloorIndex, targetRow, targetCol, newRotation)
    if flag == true then
      return r1, r2, r3, r4, r5, newFloorIndex, nil
    else
      return r1, r2, r3, r4, r5, newFloorIndex, newRotation
    end
  else
    return self:MoveFurnitureInternal(id, templateId, floorIndex, currentRow, currentCol, currentRotation, deltaRow, deltaCol)
  end
end

function BuildingGrid:MoveFurnitureInternal(id, templateId, floorIndex, currentRow, currentCol, currentRotation, deltaRow, deltaCol)
  self:RemoveFurniture(id)
  local furnitureTemplateData = self.m_TemplateFurnitures[templateId]
  local floorData = self.m_BuildingGridData[floorIndex]
  local row = currentRow + deltaRow
  local col = currentCol + deltaCol
  local result, furnitureData, targetRow, targetCol = self:RealPlaceFurniture(id, templateId, row, col, currentRotation, furnitureTemplateData, floorIndex, floorData, false)
  if result == BuildingGrid.EPlaceFurnitureResult.EOutOfRange then
    local worldX, worldZ = self:ConvertRowAndColToWorldPosition(floorIndex, row, col)
    local newFloorIndex = self:CalculateFloorIndex(worldX, worldZ)
    if floorIndex ~= newFloorIndex then
      result, self.m_RightFurnitureCells, self.m_WrongFurnitureCells, targetRow, targetCol = self:PlaceFurniture(id, templateId, newFloorIndex, worldX, worldZ, currentRotation)
      return result, self.m_RightFurnitureCells, self.m_WrongFurnitureCells, targetRow, targetCol, newFloorIndex
    end
  end
  self.m_WrongFurnitureCells = {}
  self.m_RightFurnitureCells = {}
  self:RecordFurnitureCells(self.m_BuildingGridData[floorIndex], furnitureData.cells, furnitureData.bHeight, result)
  return result, self.m_RightFurnitureCells, self.m_WrongFurnitureCells, targetRow, targetCol, floorIndex
end

function BuildingGrid:PlaceFurniture(id, templateId, floorIndex, targetX, targetZ, rotation)
  local result, furnitureData, targetRow, targetCol = self:PlaceFurnitureInternal(id, templateId, floorIndex, targetX, targetZ, rotation, false)
  self.m_WrongFurnitureCells = {}
  self.m_RightFurnitureCells = {}
  self:RecordFurnitureCells(self.m_BuildingGridData[floorIndex], furnitureData.cells, furnitureData.bHeight, result)
  return result, self.m_RightFurnitureCells, self.m_WrongFurnitureCells, targetRow, targetCol
end

function BuildingGrid:PlaceFurniture_T(id, templateId, floorIndex, targetRow, targetCol, rotation, isTry)
  if self.m_Furnitures[id] ~= nil then
    self:RemoveFurniture(id)
  end
  local furnitureData = self.m_TemplateFurnitures[templateId]
  if furnitureData == nil then
    return BuildingGrid.EPlaceFurnitureResult.ETemplateNotFound
  end
  local floor = self.m_BuildingGridData[floorIndex]
  local result, backClosedToWall
  result, furnitureData, targetRow, targetCol, backClosedToWall = self:RealPlaceFurniture(id, templateId, targetRow, targetCol, rotation, furnitureData, floorIndex, floor, isTry)
  self.m_WrongFurnitureCells = {}
  self.m_RightFurnitureCells = {}
  self:RecordFurnitureCells(self.m_BuildingGridData[floorIndex], furnitureData.cells, furnitureData.bHeight, result)
  return result, self.m_RightFurnitureCells, self.m_WrongFurnitureCells, targetRow, targetCol, backClosedToWall
end

function BuildingGrid:TryPlaceFurniture(id, templateId, floorIndex, targetX, targetZ, rotation)
  local result, furnitureData, targetRow, targetCol, backClosedToWall = self:PlaceFurnitureInternal(id, templateId, floorIndex, targetX, targetZ, rotation, true)
  self.m_WrongFurnitureCells = {}
  self.m_RightFurnitureCells = {}
  self:RecordFurnitureCells(self.m_BuildingGridData[floorIndex], furnitureData.cells, furnitureData.bHeight, result)
  return result, self.m_RightFurnitureCells, self.m_WrongFurnitureCells, targetRow, targetCol, backClosedToWall
end

function BuildingGrid:PlaceFurnitureInternal(id, templateId, floorIndex, targetX, targetZ, rotation, isTry)
  if self.m_Furnitures[id] ~= nil then
    self:RemoveFurniture(id)
  end
  local furnitureData = self.m_TemplateFurnitures[templateId]
  if furnitureData == nil then
    return BuildingGrid.EPlaceFurnitureResult.ETemplateNotFound
  end
  local floor = self.m_BuildingGridData[floorIndex]
  local posX = (targetX - floor.x) / self.m_CellSize + floor.col * 0.5
  local posZ = floor.row * 0.5 - (targetZ - floor.z) / self.m_CellSize
  local format = function(formatValue, baseValue)
    local floorValue = math.floor(formatValue)
    if baseValue % 2 == 0 then
      local delta = formatValue - floorValue
      if 0.5 < delta then
        return floorValue + 1
      else
        return floorValue
      end
    else
      return floorValue + 1
    end
  end
  local targetRow = format(posZ, furnitureData.row)
  local targetCol = format(posX, furnitureData.col)
  return self:RealPlaceFurniture(id, templateId, targetRow, targetCol, rotation, furnitureData, floorIndex, floor, isTry)
end

function BuildingGrid:RotateFurniture(id, templateId, floorIndex, targetRow, targetCol, rotation)
  local result, furnitureData, targetRow, targetCol = self:RotateFurnitureInternal(id, templateId, floorIndex, targetRow, targetCol, rotation)
  self.m_WrongFurnitureCells = {}
  self.m_RightFurnitureCells = {}
  self:RecordFurnitureCells(self.m_BuildingGridData[floorIndex], furnitureData.cells, furnitureData.bHeight, result)
  return result, self.m_RightFurnitureCells, self.m_WrongFurnitureCells, targetRow, targetCol
end

function BuildingGrid:RotateFurnitureInternal(id, templateId, floorIndex, targetRow, targetCol, rotation)
  self:RemoveFurniture(id)
  local furnitureData = self.m_TemplateFurnitures[templateId]
  local floor = self.m_BuildingGridData[floorIndex]
  return self:RealPlaceFurniture(id, templateId, targetRow, targetCol, rotation, furnitureData, floorIndex, floor, false)
end

function BuildingGrid:RealPlaceFurniture(id, templateId, targetRow, targetCol, rotation, furnitureData, floorIndex, floor, isTry)
  local furnitureData, forwardRow, backRow, leftCol, rightCol = self:CalculatePlacedFurnitureData(targetRow, targetCol, rotation, furnitureData)
  if not floor then
    return BuildingGrid.EPlaceFurnitureResult.EWrongPosition, furnitureData, targetRow, targetCol
  end
  local flag, dirs, backClosedToWall = self:CheckFurniture(floor, furnitureData, forwardRow, backRow, leftCol, rightCol, rotation)
  if flag == 2 then
    return BuildingGrid.EPlaceFurnitureResult.EOutOfRange, furnitureData, targetRow, targetCol
  else
    local targetCellValue = self:GetCellData(floor, targetRow, targetCol, 1)
    local targetCellType = self:GetTypeOfCell(targetCellValue)
    if targetCellType == BuildingGrid.EBuildingCellType.EUnavailableFloor then
      return BuildingGrid.EPlaceFurnitureResult.EOutOfRange, furnitureData, targetRow, targetCol
    end
    if flag == 1 then
      return BuildingGrid.EPlaceFurnitureResult.EWrongPosition, furnitureData, targetRow, targetCol
    elseif flag == 3 then
      return BuildingGrid.EPlaceFurnitureResult.EWrongConfig, furnitureData, targetRow, targetCol
    elseif flag == 4 then
      return BuildingGrid.EPlaceFurnitureResult.EBeyondTheHight, furnitureData, targetRow, targetCol
    end
  end
  local cacheData = {}
  local result = BuildingGrid.EPlaceFurnitureResult.ESuccess
  for i, furnitureCellData in ipairs(furnitureData.cells) do
    local cellRow = furnitureCellData.row
    local cellCol = furnitureCellData.col
    local cellHeight = furnitureCellData.height
    local cellValue = self:GetCellData(floor, cellRow, cellCol, cellHeight)
    local cellType = self:GetTypeOfCell(cellValue)
    if cellType == BuildingGrid.EBuildingCellType.EObstacle then
      result = BuildingGrid.EPlaceFurnitureResult.EObstacle
      break
    end
    local furnitureCellType = furnitureCellData.cellType
    if furnitureCellType == BuildingGrid.EFurniturePlaceType.EOnGround then
      if cellType ~= BuildingGrid.EBuildingCellType.EGround and cellType ~= BuildingGrid.EBuildingCellType.EGroundWithWall then
        result = BuildingGrid.EPlaceFurnitureResult.EWrongPosition
        break
      end
      if not self:IsGroundExtraEmptyOfCell(cellValue) then
        result = BuildingGrid.EPlaceFurnitureResult.EExtraNotEmpty
        break
      end
    elseif furnitureCellType == BuildingGrid.EFurniturePlaceType.EOnWall then
      if cellType ~= BuildingGrid.EBuildingCellType.EWall and cellType ~= BuildingGrid.EBuildingCellType.EGroundWithWall then
        result = BuildingGrid.EPlaceFurnitureResult.EWrongPosition
        break
      end
      if not self:IsWallExtraEmptyOfCell(cellValue) then
        result = BuildingGrid.EPlaceFurnitureResult.EExtraNotEmpty
        break
      end
    elseif not self:IsEmptyOfCell(cellValue) then
      result = BuildingGrid.EPlaceFurnitureResult.ENotEmpty
      break
    end
    table.insert(cacheData, {
      row = cellRow,
      col = cellCol,
      height = cellHeight,
      type = furnitureCellType
    })
  end
  if result == BuildingGrid.EPlaceFurnitureResult.ESuccess and not isTry then
    for i, data in ipairs(cacheData) do
      if data.type == BuildingGrid.EFurniturePlaceType.EOnGround then
        self:SetGroundExtraEmptyOfCell(floorIndex, data.row, data.col, data.height, false)
      elseif data.type == BuildingGrid.EFurniturePlaceType.EOnWall then
        self:SetWallExtraEmptyOfCell(floorIndex, data.row, data.col, data.height, false)
      elseif data.type == BuildingGrid.EFurniturePlaceType.ECloseToWall then
        self:SetEmptyOfCell(floorIndex, data.row, data.col, data.height, false)
      else
        self:SetEmptyOfCell(floorIndex, data.row, data.col, data.height, false)
      end
    end
    self.m_Furnitures[id] = {
      templateId = templateId,
      data = cacheData,
      floorIndex = floorIndex,
      dirs = dirs,
      backClosedToWall = backClosedToWall,
      targetRow = targetRow,
      targetCol = targetCol,
      rotation = rotation
    }
  end
  return result, furnitureData, targetRow, targetCol, backClosedToWall
end

function BuildingGrid:RemoveFurniture(id)
  local furnitureData = self.m_Furnitures[id]
  if furnitureData == nil then
    return
  end
  for i, data in ipairs(furnitureData.data) do
    if data.type == BuildingGrid.EFurniturePlaceType.EOnGround then
      self:SetGroundExtraEmptyOfCell(furnitureData.floorIndex, data.row, data.col, data.height, true)
    elseif data.type == BuildingGrid.EFurniturePlaceType.EOnWall then
      self:SetWallExtraEmptyOfCell(furnitureData.floorIndex, data.row, data.col, data.height, true)
    elseif data.type == BuildingGrid.EFurniturePlaceType.ECloseToWall then
      self:SetEmptyOfCell(furnitureData.floorIndex, data.row, data.col, data.height, true)
    else
      self:SetEmptyOfCell(furnitureData.floorIndex, data.row, data.col, data.height, true)
    end
  end
  self.m_Furnitures[id] = nil
end

function BuildingGrid:GetPlacedFurnitureCells(id)
  local furnitureData = self.m_Furnitures[id]
  if furnitureData == nil then
    return nil
  end
  local height = -1
  local cells = {}
  for i, data in ipairs(furnitureData.data) do
    if height == -1 then
      height = data.height
    end
    if data.height == height then
      table.insert(cells, {
        row = data.row,
        col = data.col
      })
    end
  end
  return furnitureData.floorIndex, cells
end

function BuildingGrid:ConvertWorldPositionToRowAndCol(floorIndex, worldX, worldZ)
  local floor = self.m_BuildingGridData[floorIndex]
  if not floor then
    return nil, nil
  end
  local posX = (worldX - floor.x) / self.m_CellSize + floor.col * 0.5
  local posZ = floor.row * 0.5 - (worldZ - floor.z) / self.m_CellSize
  return math.ceil(posZ), math.ceil(posX)
end

function BuildingGrid:ConvertRowAndColToWorldPosition(floorIndex, row, col)
  local floor = self.m_BuildingGridData[floorIndex]
  if not floor then
    return nil, nil
  end
  local worldX = (col - 0.5 - floor.col * 0.5) * self.m_CellSize + floor.x
  local worldZ = (floor.row * 0.5 - row + 0.5) * self.m_CellSize + floor.z
  return worldX, worldZ
end

function BuildingGrid:CalculateFloorIndex(worldX, worldZ)
  local minValue = 10000
  local index = 0
  local finalRow = 0
  local finalCol = 0
  for i, floorData in ipairs(self.m_BuildingGridData) do
    local row, col = self:ConvertWorldPositionToRowAndCol(i, worldX, worldZ)
    if 1 <= row and row <= floorData.row and 1 <= col and col <= floorData.col then
      local cellValue = self:GetCellData(floorData, row, col, 1)
      local cellType = self:GetTypeOfCell(cellValue)
      if cellType ~= BuildingGrid.EBuildingCellType.EUnavailableFloor then
        return i, row, col
      end
    else
      local value = 0
      if row < 1 then
        value = 1 - row
      elseif row > floorData.row then
        value = row - floorData.row
      end
      if col < 1 then
        value = value + 1 - col
      elseif col > floorData.col then
        value = value + col - floorData.col
      end
      if minValue > value then
        minValue = value
        finalRow = row
        finalCol = col
        index = i
      end
    end
  end
  return index, finalRow, finalCol
end

function BuildingGrid:CalculateRotationCloseToNearestWall(templateId, worldX, worldZ)
  local floorIndex, furnitureRow, funitureCol = self:CalculateFloorIndex(worldX, worldZ)
  if floorIndex == 0 then
    return 0, false
  else
    local flag = false
    local minValue = 10000
    local row = 0
    local col = 0
    for i, wallData in ipairs(self.m_WallCells[floorIndex]) do
      local value = math.abs(wallData[1] - furnitureRow) + math.abs(wallData[2] - funitureCol)
      if minValue > value then
        row = wallData[1]
        col = wallData[2]
        minValue = value
        flag = false
      elseif value == minValue then
        flag = true
      end
    end
    if row == 0 or col == 0 then
      return 0, flag
    else
      local cellValue = self:GetCellData(self.m_BuildingGridData[floorIndex], row, col, 1)
      local wallDirection = self:GetWallDirectionOfCell(cellValue)
      if minValue == 0 then
        flag = 5 <= wallDirection and wallDirection <= 8
      end
      local furnitureData = self.m_TemplateFurnitures[templateId]
      local furnitureDirection = furnitureData.dirs1[1]
      if furnitureDirection == nil then
        furnitureDirection = furnitureData.dirs2[1]
        if furnitureDirection == nil then
          return 0, flag
        end
      end
      for k, v in pairs(self.DirectionRotationMap[furnitureDirection]) do
        if BuildingGrid:CheckFurnitureDirection(v, wallDirection) then
          return k, flag
        end
      end
      return 0, flag
    end
  end
end

function BuildingGrid:GetWallDirection(floorIndex, worldX, worldZ)
  local pointRow, pointCol = self:ConvertWorldPositionToRowAndCol(floorIndex, worldX, worldZ)
  local minValue = 10000
  local row = 0
  local col = 0
  for i, wallData in ipairs(self.m_WallCells[floorIndex]) do
    local value = math.abs(wallData[1] - pointRow) + math.abs(wallData[2] - pointCol)
    if minValue > value then
      row = wallData[1]
      col = wallData[2]
      minValue = value
    end
  end
  local cellValue = self:GetCellData(self.m_BuildingGridData[floorIndex], row, col, 1)
  local wallDirection = self:GetWallDirectionOfCell(cellValue)
  if wallDirection == BuildingGrid.EBuildingDirection.EForwardLeft then
    return BuildingGrid.EBuildingDirection.EForward
  elseif wallDirection == BuildingGrid.EBuildingDirection.EForwardRight then
    return BuildingGrid.EBuildingDirection.EForward
  elseif wallDirection == BuildingGrid.EBuildingDirection.EBackLeft then
    return BuildingGrid.EBuildingDirection.EBack
  elseif wallDirection == BuildingGrid.EBuildingDirection.EBackRight then
    return BuildingGrid.EBuildingDirection.EBack
  else
    return wallDirection
  end
end

function BuildingGrid:GetWallId(floorIndex, worldX, worldZ)
  local pointRow, pointCol = self:ConvertWorldPositionToRowAndCol(floorIndex, worldX, worldZ)
  local minValue = 10000
  local row = 0
  local col = 0
  for i, wallData in ipairs(self.m_WallCells[floorIndex]) do
    local value = math.abs(wallData[1] - pointRow) + math.abs(wallData[2] - pointCol)
    if minValue > value then
      row = wallData[1]
      col = wallData[2]
      minValue = value
    end
  end
  local cellValue = self:GetCellData(self.m_BuildingGridData[floorIndex], row, col, 1)
  return self:GetWallIdOfCell(cellValue)
end

function BuildingGrid:IsFurnitureNearWallSide(id)
  local furnitureData = self.m_Furnitures[id]
  if furnitureData == nil then
    return false
  else
    return furnitureData.backClosedToWall
  end
end

function BuildingGrid:IsCellAvaliableTypeByPos(floorIndex, worldX, worldZ)
  local pointRow, pointCol = self:ConvertWorldPositionToRowAndCol(floorIndex, worldX, worldZ)
  return self:IsCellAvaliableType(floorIndex, pointRow, pointCol)
end

function BuildingGrid:IsCellAvaliableType(floorIndex, row, col)
  local floor = self.m_BuildingGridData[floorIndex]
  if row < 0 or row > floor.row then
    return false
  end
  if col < 0 or col > floor.col then
    return false
  end
  local cellValue = self:GetCellData(floor, row, col, 1)
  if not cellValue then
    return false
  end
  local cellType = self:GetTypeOfCell(cellValue)
  return cellType ~= nil and cellType ~= BuildingGrid.EBuildingCellType.EObstacle and cellType ~= BuildingGrid.EBuildingCellType.EUnavailableFloor
end
