LogicManager_MapCell = class("LogicManager_MapCell")
local _Game = Game
local _MapCellHelper = MapCellHelper
local TableClear = TableUtility.TableClear
local DistanceXZ_Square = VectorUtility.DistanceXZ_Square
local max = math.max
local min = math.min
local abs = math.abs
local round = math.round
local GetTempVector2 = LuaGeometry.GetTempVector2
local Dot = LuaVector2.Dot
local Normalized_Vec2 = LuaVector2.Normalized
local NSceneNpcProxyIns
local FindCreature = SceneCreatureProxy.FindCreature
local UpdateFrequency_First = {
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  2,
  3,
  3
}
local MaxRefreshRowsPerFrame = 5
LogicManager_MapCell.RoleUGUIVisibleRange = 10
LogicManager_MapCell.RoleUGUIVisibleCount = 10
LogicManager_MapCell.ObjType = {
  Trap = 1,
  CullingObj = 2,
  ExitPoint = 3,
  ModelEPPointEffect = 4
}
LogicManager_MapCell.CullingType = {
  Default = 1,
  CallbackOnlyVisibleChange = 2,
  AutoSetActive = 3,
  AutoChangeLayer = 4
}
LogicManager_MapCell.LODPriority = {
  High = 7,
  Mid = 14,
  Low = 20
}
local LODPriority = LogicManager_MapCell.LODPriority
LogicManager_MapCell.LODLevel = {
  High = 0,
  Mid = 1,
  Low = 2,
  Invisible = 3
}
local LODLevel = LogicManager_MapCell.LODLevel
local _CreatureType = Creature_Type

function LogicManager_MapCell:ctor()
  local l_mapCellManager = MapCellManager.Instance
  self.cellSize = l_mapCellManager.cellSize
  self.centerIndex = MapCellManager.CenterIndex
  self.maxSideLen = MapCellManager.MaxSideLen
  self.maxCellIndex = self.maxSideLen * self.maxSideLen
  self.tooFarCellIndex = self.maxSideLen * self.maxSideLen
  self.invisiblePriority = MapCellManager.InvisiblePriority
  self.horiPriorityWeight = l_mapCellManager.horiPriorityWeight
  self.centerPositionX = 0
  self.centerPositionZ = 0
  self.cameraPosition = LuaVector2(0, 0)
  self.cameraForward = LuaVector2(0, 0)
  self.cameraHalfHoriRad = 0
  self.priorityCenterRow = 0
  self.priorityCenterCol = 0
  self.npcRings = {}
  self.petRings = {}
  self.playerRings = {}
  self.rings = {
    [_CreatureType.Player] = self.playerRings,
    [_CreatureType.Npc] = self.npcRings,
    [_CreatureType.Pet] = self.petRings
  }
  local luaMaxSideLen = self.maxSideLen - 1
  for cType, typeMap in pairs(self.rings) do
    for i = 0, luaMaxSideLen do
      for j = 0, luaMaxSideLen do
        typeMap[self:RowAndColToIndex(i, j)] = {}
      end
    end
  end
  self.tooFarCell = {}
  self.priorityMap = {}
  self.cellCreatureNumMap = {}
  self.refreshCellIndex = -1
  self.refreshRoleStep = 0
  self.refreshObjStep = 0
  self.updateNumber = 0
  self.isCreatureUpdateDisable = not l_mapCellManager.ActiveRoleUpdate
  self.isObjCullingDisable = not l_mapCellManager.ActiveObjCulling
end

function LogicManager_MapCell:Launch()
  if self.running then
    return
  end
  self.running = true
  _Game.MapCellManager:ResetCenterTransform(Game.Myself.assetRole.completeTransform)
end

function LogicManager_MapCell:Shutdown()
  if not self.running then
    return
  end
  self.running = false
end

function LogicManager_MapCell:DisableCreatureUpdate(disable)
  self.isCreatureUpdateDisable = disable
  _Game.MapCellManager.ActiveRoleUpdate = disable ~= true
end

function LogicManager_MapCell:IsCreatureUpdateWorking()
  return not self.isCreatureUpdateDisable
end

function LogicManager_MapCell:DisableObjCulling(disable)
  self.isObjCullingDisable = disable
  _Game.MapCellManager.ActiveObjCulling = disable ~= true
end

function LogicManager_MapCell:IsObjCullingWorking()
  return not self.isObjCullingDisable
end

function LogicManager_MapCell:SetPriorityByCenterAngle(angle)
  _Game.MapCellManager.priorityByCenterAngle = angle
end

function LogicManager_MapCell:IsIgnoreCameraDir()
  return self.ignoreCameraDir
end

function LogicManager_MapCell:SetIgnoreCameraDir(value)
  self.ignoreCameraDir = value == true
  _Game.MapCellManager.IgnoreCameraDir = self.ignoreCameraDir
end

function LogicManager_MapCell:RegisterCreature(creature)
  local cType = creature:GetCreatureType()
  if cType == _CreatureType.Player or cType == _CreatureType.Npc or cType == _CreatureType.Pet or cType == _CreatureType.Stage then
    _Game.MapCellManager:RegisterRole(creature.assetRole.complete)
    local pos = creature:GetPosition()
    local priority = self:GetPriority(self:RowAndColToIndex(self:PositionXZToRowAndCol(pos.x, pos.z)))
    creature:CullingStateChange(self:ParseToCullingState(priority))
    creature:OnPriorityChange(priority)
  end
end

function LogicManager_MapCell:UnRegisterCreature(creature)
  _Game.MapCellManager:UnRegisterRole(creature.assetRole.complete)
  local cType = creature:GetCreatureType()
  if cType == _CreatureType.Me then
    return
  end
  if cType == _CreatureType.Stage then
    cType = _CreatureType.Npc
  end
  local preIndex = creature:GetMapCellIndex()
  creature:SetMapCellIndex(-1)
  if preIndex == nil then
    return
  end
  self:GetCell(cType, preIndex)[creature] = nil
  self.cellCreatureNumMap[preIndex] = max((self.cellCreatureNumMap[preIndex] or 0) - 1, 0)
end

function LogicManager_MapCell:RegisterGameObject(transform, objType, objID, outRange, cullingType)
  _Game.MapCellManager:RegisterGameObject(transform, objType, objID, outRange or 0, cullingType or LogicManager_MapCell.CullingType.CallbackOnlyVisibleChange)
end

function LogicManager_MapCell:UnRegisterGameObject(transformOrInstanceID)
  if not transformOrInstanceID then
    return
  end
  _Game.MapCellManager:UnRegisterGameObject(transformOrInstanceID)
end

function LogicManager_MapCell:GetPriority(index)
  if self.isCreatureUpdateDisable and self.isObjCullingDisable then
    return 0
  end
  if not index or index < self.maxCellIndex then
    return self.priorityMap[index] or LODPriority.Mid
  end
  return self.invisiblePriority + 1
end

function LogicManager_MapCell:GetPriorityByPos(posX, posZ)
  local cellIndex = self:RowAndColToIndex(self:PositionXZToRowAndCol(posX, posZ))
  return self:GetPriority(cellIndex)
end

function LogicManager_MapCell:GetCellCreatureCount(index)
  if self.isCreatureUpdateDisable then
    return 0
  end
  return self.cellCreatureNumMap[index] or 0
end

function LogicManager_MapCell:GetCellCreatureCountByPos(posX, posZ)
  return self:GetCellCreatureCount(self:RowAndColToIndex(self:PositionXZToRowAndCol(posX, posZ)))
end

local listCellCreatures = {}

function LogicManager_MapCell:GetCellCreatureList(index, cType)
  TableClear(listCellCreatures)
  local creatureMap
  if not cType and self:IsIndexValid(index) then
    for type, typeMap in pairs(self.rings) do
      creatureMap = typeMap[index]
      for c, _ in pairs(creatureMap) do
        listCellCreatures[#listCellCreatures + 1] = c
      end
    end
  else
    creatureMap = self:GetCell(cType, index)
    for c, _ in pairs(creatureMap) do
      listCellCreatures[#listCellCreatures + 1] = c
    end
  end
  return listCellCreatures
end

function LogicManager_MapCell:GetCellCreatureListByPos(posX, posZ, cType)
  return self:GetCellCreatureList(self:RowAndColToIndex(self:PositionXZToRowAndCol(posX, posZ)), cType)
end

function LogicManager_MapCell:RowAndColToIndex(row, col)
  return 0 <= col and col < self.maxSideLen and min(self.maxSideLen * row + col, self.tooFarCellIndex) or self.tooFarCellIndex
end

function LogicManager_MapCell:IsIndexValid(index)
  return -1 < index and index < self.maxCellIndex
end

function LogicManager_MapCell:GetCell(cType, index)
  local creatureMap = self.rings[cType]
  return self:IsIndexValid(index) and creatureMap and creatureMap[index] or self.tooFarCell
end

function LogicManager_MapCell:IndexToRowAndCol(index)
  return math.floor(index / self.maxSideLen), index % self.maxSideLen
end

function LogicManager_MapCell:PositionXZToRowAndCol(posX, posZ)
  return self.centerIndex + round((posZ - self.centerPositionZ) / self.cellSize), self.centerIndex + round((posX - self.centerPositionX) / self.cellSize)
end

function LogicManager_MapCell:RowAndColToPositionXZ(row, col)
  return self.centerPositionX + (col - self.centerIndex) * self.cellSize, self.centerPositionZ + (row - self.centerIndex) * self.cellSize
end

function LogicManager_MapCell:ParseToCullingState(priority)
  local visible = priority < self.invisiblePriority and 1 or 0
  if priority < LODPriority.High then
    return visible, 0
  elseif priority < LODPriority.Mid then
    return visible, 1
  elseif priority < LODPriority.Low then
    return visible, 2
  else
    return visible, 3
  end
end

local distanceLevelArray = {
  10,
  20,
  50
}

function LogicManager_MapCell:DistanceLevelToDistance(level)
  if not level then
    return 0
  end
  level = level + 1
  if level <= 1 then
    return max(distanceLevelArray[1] * level, 0)
  end
  if level >= #distanceLevelArray then
    return 50
  end
  local prevLevel = math.floor(level)
  local nextLevel = math.ceil(level)
  return distanceLevelArray[prevLevel] + (distanceLevelArray[nextLevel] - distanceLevelArray[prevLevel]) * (level - prevLevel)
end

function LogicManager_MapCell:DistanceToDistanceLevel(distance)
  if not distance then
    return 0
  end
  local maxLevel = #distanceLevelArray
  for i = 1, maxLevel do
    if distance < distanceLevelArray[i] then
      return max(i - 1, 0)
    end
  end
  return maxLevel
end

function LogicManager_MapCell:MapCellLodLevelByPos(posX, posZ)
  local priority = self:GetPriorityByPos(posX, posZ)
  if priority < LODPriority.High then
    return LODLevel.High
  elseif priority < LODPriority.Mid then
    return LODLevel.Mid
  elseif priority < LODPriority.Low then
    return LODLevel.Low
  else
    return LODLevel.Invisible
  end
end

local refreshCellWaitTime = 0
local refreshType = 1

function LogicManager_MapCell:LateUpdate(time, deltaTime)
  if not self.running then
    return
  end
  if 0 < refreshCellWaitTime then
    refreshCellWaitTime = refreshCellWaitTime - deltaTime
  elseif (refreshType == 1 or 0 <= self.refreshCellIndex) and (not self.isCreatureUpdateDisable or not self.isObjCullingDisable) then
    self:RefreshMapInfo()
  end
  if refreshType == 2 then
    if not self.isCreatureUpdateDisable then
      self:RefreshChangedRolesList()
    end
  elseif not self.isObjCullingDisable then
    self:RefreshChangedObjsList()
  end
  refreshType = refreshType + 1
  if 3 < refreshType then
    refreshType = 1
  end
end

arrayChangedMapInfos = {}

function LogicManager_MapCell:RefreshMapInfo()
  if self.refreshCellIndex < 0 then
    _MapCellHelper.GetMapInfoList(arrayChangedMapInfos)
    self.centerPositionX = arrayChangedMapInfos[1]
    self.centerPositionZ = arrayChangedMapInfos[2]
    if #arrayChangedMapInfos > 2 then
      self.cameraPosition[1] = arrayChangedMapInfos[3]
      self.cameraPosition[2] = arrayChangedMapInfos[4]
      self.cameraForward[1] = arrayChangedMapInfos[5]
      self.cameraForward[2] = arrayChangedMapInfos[6]
      self.cameraHalfHoriRad = arrayChangedMapInfos[7]
      self.priorityCenterRow, self.priorityCenterCol = self:IndexToRowAndCol(arrayChangedMapInfos[8])
      self.refreshCellIndex = 0
    else
      refreshCellWaitTime = 0.1
    end
    TableClear(arrayChangedMapInfos)
    return
  end
  local cellToCamera, priority, rad
  for i = max(self.refreshCellIndex, 0), min(self.refreshCellIndex + 5, self.maxSideLen - 1) do
    for j = 0, self.maxSideLen - 1 do
      priority = max(abs(i - self.priorityCenterRow), abs(j - self.priorityCenterCol))
      if 2 < priority and not self.ignoreCameraDir then
        cellToCamera = GetTempVector2(self:RowAndColToPositionXZ(i, j))
        LuaVector2.Sub(cellToCamera, self.cameraPosition)
        Normalized_Vec2(cellToCamera)
        rad = Dot(cellToCamera, self.cameraForward)
        if rad < self.cameraHalfHoriRad then
          priority = self.invisiblePriority + 1
        else
          priority = priority + self.horiPriorityWeight * rad * (priority / self.maxSideLen)
        end
      end
      self:UpdateCellStatus(self:RowAndColToIndex(i, j), priority)
    end
  end
  self.refreshCellIndex = self.refreshCellIndex + 6
  if self.refreshCellIndex > self.maxSideLen - 1 then
    self.refreshCellIndex = -1
  end
end

function LogicManager_MapCell:UpdateCellStatus(index, priority)
  if self.priorityMap[index] == priority then
    return
  end
  self.priorityMap[index] = priority
  local visible, distanceLevel = self:ParseToCullingState(priority)
  local frequency = self:GetUpdateFrequency(priority)
  local curCellCreatureNum = self.cellCreatureNumMap[index] or 0
  if frequency and 2 < curCellCreatureNum then
    frequency = frequency + 1
  end
  if index < 0 or index >= self.maxCellIndex then
    for creature, _ in pairs(self.tooFarCell) do
      creature:CullingStateChange(visible, distanceLevel)
      creature:OnPriorityChange(priority)
      creature:SetUpdateFrequency(CreatureUpdateFrequency.Every1Frame)
    end
    return
  end
  local creatureMap
  for type, typeMap in pairs(self.rings) do
    creatureMap = typeMap[index]
    for creature, _ in pairs(creatureMap) do
      creature:CullingStateChange(visible, distanceLevel)
      creature:OnPriorityChange(priority)
      if frequency then
        creature:SetUpdateFrequency(CreatureUpdateFrequency.Every1Frame)
      else
        creature:SetUpdateFrequency(2 + self.updateNumber % 2)
        self.updateNumber = self.updateNumber + 1
      end
    end
  end
end

local arrayChangedRoles = {}

function LogicManager_MapCell:RefreshChangedRolesList()
  if self.refreshRoleStep == 0 then
    _MapCellHelper.GetChangedRolesList(arrayChangedRoles)
    self.refreshRoleStep = 1
    return
  end
  local myselfId = _Game.Myself and _Game.Myself.data.id
  local index
  for i = 1, #arrayChangedRoles / 2 do
    index = 1 + (i - 1) * 2
    if arrayChangedRoles[index] ~= myselfId then
      self:UpdateCreature(FindCreature(arrayChangedRoles[index]), arrayChangedRoles[index + 1])
    end
  end
  TableClear(arrayChangedRoles)
  self.refreshRoleStep = 0
end

function LogicManager_MapCell:UpdateCreature(creature, index)
  if not creature then
    return
  end
  local cType = creature:GetCreatureType()
  if cType == _CreatureType.Stage then
    cType = _CreatureType.Npc
  end
  local preIndex = creature:GetMapCellIndex()
  if preIndex then
    if preIndex == index then
      return
    end
    self:GetCell(cType, preIndex)[creature] = nil
    self.cellCreatureNumMap[preIndex] = max((self.cellCreatureNumMap[preIndex] or 0) - 1, 0)
  end
  self:GetCell(cType, index)[creature] = true
  local curCellCreatureNum = (self.cellCreatureNumMap[index] or 0) + 1
  self.cellCreatureNumMap[index] = curCellCreatureNum
  creature:SetMapCellIndex(index)
  creature:SetCellCreatureIndex(curCellCreatureNum)
  local priority = self:GetPriority(index)
  local prevPriority = creature.cellPriority
  if not prevPriority or 1 < abs(priority - prevPriority) then
    creature:CullingStateChange(self:ParseToCullingState(priority))
    creature:OnPriorityChange(priority)
  end
  local frequency = self:GetUpdateFrequency(priority)
  if frequency then
    creature:SetUpdateFrequency(CreatureUpdateFrequency.Every1Frame)
  else
    creature:SetUpdateFrequency(2 + self.updateNumber % 2)
    self.updateNumber = self.updateNumber + 1
  end
end

function LogicManager_MapCell:GetUpdateFrequency(priority)
  if priority < LODPriority.High then
    return 1
  elseif priority < LODPriority.Mid then
    return UpdateFrequency_First[priority - LODPriority.High + 1]
  end
end

local arrayChangedObjs = {}

function LogicManager_MapCell:RefreshChangedObjsList()
end

local drawSize = LuaVector3(0, 0, 0)

function LogicManager_MapCell:OnDrawGizmos()
  if not self.drawCreatureMap then
    return
  end
  LuaVector3.Better_Set(drawSize, self.cellSize, 1, self.cellSize)
  for i = 0, self.maxSideLen - 1 do
    for j = 0, self.maxSideLen - 1 do
      local posX, posZ = self:RowAndColToPositionXZ(i, j)
      local priority = self:GetPriority(self:RowAndColToIndex(i, j))
      local color = LuaGeometry.GetTempColor(1, 0, 0)
      local roleCount = self:GetCellCreatureCount(self:RowAndColToIndex(i, j))
      if 0 < priority then
        color.r = color.r - priority * 10 / 255
      end
      if 0 > color.r then
        color.r = 0
      end
      if priority < 1 then
        color = LuaGeometry.GetTempColor(0, 1, 0)
      elseif priority < 2 then
        color = LuaGeometry.GetTempColor(1, 1, 0)
      elseif priority < 3 then
        color = LuaGeometry.GetTempColor(0, 1, 1)
      elseif priority >= self.invisiblePriority then
        color = LuaGeometry.GetTempColor(1, 1, 1)
      end
      _Game.MapCellManager:GizmoDrawRect(LuaGeometry.GetTempVector3(posX, 0, posZ), drawSize, color)
      if roleCount < 1 then
        color = LuaGeometry.GetTempColor(1, 1, 1)
      elseif roleCount < 2 then
        color = LuaGeometry.GetTempColor(0, 1, 0)
      elseif roleCount < 3 then
        color = LuaGeometry.GetTempColor(1, 1, 0)
      elseif roleCount < 4 then
        color = LuaGeometry.GetTempColor(1, 0, 0)
      elseif roleCount < 5 then
        color = LuaGeometry.GetTempColor(0, 0, 1)
      else
        color = LuaGeometry.GetTempColor(0, 0, 0)
      end
      _Game.MapCellManager:GizmoDrawSphere(LuaGeometry.GetTempVector3(posX, 4, posZ), self.cellSize / 4, color)
    end
  end
end

local listCreaturesAroundMe = {}

function LogicManager_MapCell:GetCreaturesAround(pos, condition, range, cType)
  if cType == _CreatureType.Stage then
    cType = _CreatureType.Npc
  end
  TableClear(listCreaturesAroundMe)
  local rings = self.rings[cType]
  if not rings then
    LogUtility.Error("Cannot Find Ring By Type: " .. tostring(cType))
    return
  end
  local delta = math.ceil(range / self.cellSize)
  local row, col = self:PositionXZToRowAndCol(pos.x, pos.z)
  local sqrRange = range * range
  local creatureMap
  local luaMaxSideLen = self.maxSideLen - 1
  for i = max(row - delta, 0), min(row + delta, luaMaxSideLen) do
    for j = max(col - delta, 0), min(col + delta, luaMaxSideLen) do
      creatureMap = rings[self:RowAndColToIndex(i, j)]
      for c, _ in pairs(creatureMap) do
        if sqrRange >= DistanceXZ_Square(c:GetPosition(), pos) and (not condition or condition(c)) then
          table.insert(listCreaturesAroundMe, c)
        end
      end
    end
  end
  return listCreaturesAroundMe
end

function LogicManager_MapCell:TraversingCreatureAround(pos, action, range, cType)
  if cType == _CreatureType.Stage then
    cType = _CreatureType.Npc
  end
  local rings = self.rings[cType]
  if not rings then
    LogUtility.Error("Cannot Find Ring By Type: " .. tostring(cType))
    return
  end
  local delta = math.ceil(range / self.cellSize)
  local row, col = self:PositionXZToRowAndCol(pos.x, pos.z)
  local sqrRange = range * range
  local creatureMap
  local luaMaxSideLen = self.maxSideLen - 1
  for i = max(row - delta, 0), min(row + delta, luaMaxSideLen) do
    for j = max(col - delta, 0), min(col + delta, luaMaxSideLen) do
      creatureMap = rings[self:RowAndColToIndex(i, j)]
      for c, _ in pairs(creatureMap) do
        if sqrRange >= DistanceXZ_Square(c:GetPosition(), pos) then
          action(c)
        end
      end
    end
  end
end

local creatureInfo = {}

function LogicManager_MapCell:FindCreatureAround(pos, condition, range, cType)
  if cType == _CreatureType.Stage then
    cType = _CreatureType.Npc
  end
  local rings = self.rings[cType]
  if not rings then
    LogUtility.Error("Cannot Find Ring By Type: " .. tostring(cType))
    return
  end
  creatureInfo.pos, creatureInfo.condition = pos, condition
  creatureInfo.sqrRange, creatureInfo.creature = range * range
  local row, col = self:PositionXZToRowAndCol(pos.x, pos.z)
  local index = self:RowAndColToIndex(row, col)
  if not self:IsIndexValid(index) then
    for c, _ in pairs(self.tooFarCell) do
      if self:_RecordCreature(c, creatureInfo) then
        return creatureInfo.creature
      end
    end
    return creatureInfo.creature
  end
  for c, _ in pairs(rings[index]) do
    if self:_RecordCreature(c, creatureInfo) then
      return creatureInfo.creature
    end
  end
  local maxRing = max(row, self.maxSideLen - 1 - row, col, self.maxSideLen - 1 - col)
  for i = 1, range and 0 < range and min(math.ceil(range / self.cellSize), maxRing) or maxRing do
    self:_LoopCellsRingAroundCell(rings, row, col, i, LogicManager_MapCell._RecordCreature, creatureInfo)
    if creatureInfo.creature then
      return creatureInfo.creature
    end
  end
end

function LogicManager_MapCell:_RecordCreature(creature, creatureInfo)
  if DistanceXZ_Square(creature:GetPosition(), creatureInfo.pos) > creatureInfo.sqrRange or creatureInfo.condition and not creatureInfo.condition(creature) then
    return
  end
  creatureInfo.creature = creature
  return true
end

local nearestInfo = {}

function LogicManager_MapCell:FindNearestCreatureAround(pos, condition, range, cType)
  if cType == _CreatureType.Stage then
    cType = _CreatureType.Npc
  end
  local rings = self.rings[cType]
  if not rings then
    LogUtility.Error("Cannot Find Ring By Type: " .. tostring(cType))
    return
  end
  nearestInfo.pos, nearestInfo.condition = pos, condition
  nearestInfo.nearestCreature, nearestInfo.nearestSqrRange = nil, range and range * range or math.huge
  local row, col = self:PositionXZToRowAndCol(pos.x, pos.z)
  local index = self:RowAndColToIndex(row, col)
  if not self:IsIndexValid(index) then
    for c, _ in pairs(self.tooFarCell) do
      self:_RecordNearestCreature(c, nearestInfo)
    end
    return nearestInfo.nearestCreature, nearestInfo.nearestSqrRange
  end
  for c, _ in pairs(rings[index]) do
    self:_RecordNearestCreature(c, nearestInfo)
  end
  if nearestInfo.nearestCreature then
    return nearestInfo.nearestCreature, nearestInfo.nearestSqrRange
  end
  local maxRing = max(row, self.maxSideLen - 1 - row, col, self.maxSideLen - 1 - col)
  for i = 1, range and 0 < range and min(math.ceil(range / self.cellSize), maxRing) or maxRing do
    self:_LoopCellsRingAroundCell(rings, row, col, i, LogicManager_MapCell._RecordNearestCreature, nearestInfo)
    if nearestInfo.nearestCreature then
      return nearestInfo.nearestCreature, nearestInfo.nearestSqrRange
    end
  end
end

function LogicManager_MapCell:_RecordNearestCreature(creature, nearestInfo)
  local sqrDistance = DistanceXZ_Square(creature:GetPosition(), nearestInfo.pos)
  if sqrDistance <= nearestInfo.nearestSqrRange and (not nearestInfo.condition or nearestInfo.condition(creature)) then
    nearestInfo.nearestSqrRange = sqrDistance
    nearestInfo.nearestCreature = creature
  end
end

function LogicManager_MapCell:_LoopCellsRingAroundCell(rings, row, col, ringIndex, action, params)
  local luaMaxSideLen = self.maxSideLen - 1
  local curRow = row + ringIndex
  if curRow < self.maxSideLen then
    for i = max(col - ringIndex, 0), min(col + ringIndex, luaMaxSideLen) do
      for c, _ in pairs(rings[self:RowAndColToIndex(curRow, i)]) do
        if action(self, c, params) then
          return
        end
      end
    end
  end
  curRow = row - ringIndex
  if -1 < curRow then
    for i = max(col - ringIndex, 0), min(col + ringIndex, luaMaxSideLen) do
      for c, _ in pairs(rings[self:RowAndColToIndex(curRow, i)]) do
        if action(self, c, params) then
          return
        end
      end
    end
  end
  local curCol = col - ringIndex
  if -1 < curCol then
    for i = max(row - ringIndex + 1, 0), min(row + ringIndex - 1, luaMaxSideLen) do
      for c, _ in pairs(rings[self:RowAndColToIndex(i, curCol)]) do
        if action(self, c, params) then
          return
        end
      end
    end
  end
  curCol = col + ringIndex
  if curCol < self.maxSideLen then
    for i = max(row - ringIndex + 1, 0), min(row + ringIndex - 1, luaMaxSideLen) do
      for c, _ in pairs(rings[self:RowAndColToIndex(i, curCol)]) do
        if action(self, c, params) then
          return
        end
      end
    end
  end
end
