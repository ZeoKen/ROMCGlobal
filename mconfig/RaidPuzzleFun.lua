RaidPuzzleFun = {}

function RaidPuzzleFun.SetRaidID(raidID, mapScale)
  RaidPuzzleFun.raidAreaMap = Table_RaidPushArea[raidID]
  RaidPuzzleFun.mapScale = mapScale
end

function RaidPuzzleFun.Round(value)
  return math.floor(value + 0.5)
end

function RaidPuzzleFun.PosZToAreaRow(areaID, posZ)
  local areaData = RaidPuzzleFun.raidAreaMap and RaidPuzzleFun.raidAreaMap[areaID]
  if not areaData then
    return
  end
  return RaidPuzzleFun.Round((posZ - areaData.MinPosZ) / (areaData.CellSize * RaidPuzzleFun.mapScale) + 0.5)
end

function RaidPuzzleFun.PosXToAreaCol(areaID, posX)
  local areaData = RaidPuzzleFun.raidAreaMap and RaidPuzzleFun.raidAreaMap[areaID]
  if not areaData then
    return
  end
  return RaidPuzzleFun.Round((posX - areaData.MinPosX) / (areaData.CellSize * RaidPuzzleFun.mapScale) + 0.5)
end

function RaidPuzzleFun.AreaColToPosX(areaID, col)
  local areaData = RaidPuzzleFun.raidAreaMap and RaidPuzzleFun.raidAreaMap[areaID]
  if not areaData then
    return
  end
  return areaData.MinPosX + (col - 0.5) * (areaData.CellSize * RaidPuzzleFun.mapScale)
end

function RaidPuzzleFun.AreaRowToPosZ(areaID, row)
  local areaData = RaidPuzzleFun.raidAreaMap and RaidPuzzleFun.raidAreaMap[areaID]
  if not areaData then
    return
  end
  return areaData.MinPosZ + (row - 0.5) * (areaData.CellSize * RaidPuzzleFun.mapScale)
end
