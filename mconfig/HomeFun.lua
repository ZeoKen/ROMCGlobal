HomeFun = {}
HomeFun.m_CellSize = 0.5

function HomeFun.ConvertWorldPosZToRow(mapName, floorIndex, worldZ)
  local homeMapData = _G[mapName]
  if not homeMapData then
    return -1
  end
  return HomeFun.ConvertWorldPosZToRowByFloorData(homeMapData[floorIndex], worldZ)
end

function HomeFun.ConvertWorldPosZToRowByFloorData(floorData, worldZ)
  return floorData and math.ceil(floorData.row * 0.5 - (worldZ - floorData.z) / HomeFun.m_CellSize) or -1
end

function HomeFun.ConvertWorldPosXToCol(mapName, floorIndex, worldX)
  local homeMapData = _G[mapName]
  if not homeMapData then
    return -1
  end
  return HomeFun.ConvertWorldPosXToColByFloorData(homeMapData[floorIndex], worldX)
end

function HomeFun.ConvertWorldPosXToColByFloorData(floorData, worldX)
  return floorData and math.ceil((worldX - floorData.x) / HomeFun.m_CellSize + floorData.col * 0.5) or -1
end

function HomeFun.ConvertRowToWorldPosZ(mapName, floorIndex, row)
  local homeMapData = _G[mapName]
  if not homeMapData then
    return -1
  end
  return HomeFun.ConvertRowToWorldPosZByFloorData(homeMapData[floorIndex], row)
end

function HomeFun.ConvertRowToWorldPosZByFloorData(floorData, row)
  return floorData and (floorData.row * 0.5 - row + 0.5) * HomeFun.m_CellSize + floorData.z or -1
end

function HomeFun.ConvertColToWorldPosX(mapName, floorIndex, col)
  local homeMapData = _G[mapName]
  if not homeMapData then
    return -1
  end
  return HomeFun.ConvertColToWorldPosXByFloorData(homeMapData[floorIndex], col)
end

function HomeFun.ConvertColToWorldPosXByFloorData(floorData, col)
  return floorData and (col - 0.5 - floorData.col * 0.5) * HomeFun.m_CellSize + floorData.x or -1
end

function HomeFun.IsPosValid(mapName, worldX, worldZ)
  local homeMapData = _G[mapName]
  if not homeMapData then
    return false
  end
  local row, col
  for floorIndex, floorData in pairs(homeMapData) do
    row = HomeFun.ConvertWorldPosZToRowByFloorData(floorData, worldZ)
    col = HomeFun.ConvertWorldPosXToColByFloorData(floorData, worldX)
    if HomeFun.IsCellValidByFloorData(floorData, row, col) then
      return true
    end
  end
  return false
end

function HomeFun.IsCellValid(mapName, floorIndex, row, col)
  local homeMapData = _G[mapName]
  if not homeMapData then
    return false
  end
  return HomeFun.IsCellValidByFloorData(homeMapData[floorIndex], row, col)
end

function HomeFun.IsCellValidByFloorData(floorData, row, col)
  return floorData ~= nil and row <= floorData.row and 0 < row and col <= floorData.col and 0 < col
end
