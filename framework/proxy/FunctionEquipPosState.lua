FunctionEquipPosState = class("FunctionEquipPosState")
local _serverDeltaSecondTime

function FunctionEquipPosState.Me()
  if nil == FunctionEquipPosState.me then
    FunctionEquipPosState.me = FunctionEquipPosState.new()
  end
  return FunctionEquipPosState.me
end

function FunctionEquipPosState:ctor()
  _serverDeltaSecondTime = ServerTime.ServerDeltaSecondTime
  self.equipPosStateTimeMap = {}
  self.offPosMap = {}
  self.protectPosMap = {}
end

function FunctionEquipPosState:Server_SetEquipPos_StateTime(server_EquipPosDatas)
  for i = 1, #server_EquipPosDatas do
    local d = server_EquipPosDatas[i]
    local ld = self.equipPosStateTimeMap[d.pos]
    if ld == nil then
      ld = {}
      self.equipPosStateTimeMap[d.pos] = ld
    end
    ld.offstarttime = d.offstarttime
    ld.offendtime = d.offendtime
    ld.offduration = d.offendtime - d.offstarttime
    local off_lefttime = ServerTime.ServerDeltaSecondTime(ld.offendtime * 1000)
    if 0 < off_lefttime then
      self.offPosMap[d.pos] = 1
    else
      self.offPosMap[d.pos] = nil
    end
    ld.protecttime = d.protecttime
    ld.protectalways = d.protectalways
    if 0 < ld.protectalways then
      self.protectPosMap[d.pos] = 1
    else
      local protect_lefttime = ServerTime.ServerDeltaSecondTime(ld.protecttime * 1000)
      if 0 < protect_lefttime then
        self.protectPosMap[d.pos] = 1
      else
        self.protectPosMap[d.pos] = nil
      end
    end
  end
  self:UpdatePosState()
  FunctionBuff.Me():UpdateOffingEquipBuff()
  FunctionBuff.Me():UpdateProtectEquipBuff()
end

function FunctionEquipPosState:UpdatePosState()
  local needUpdate = false
  for _, _ in pairs(self.offPosMap) do
    needUpdate = true
    break
  end
  if not needUpdate then
    for pos, _ in pairs(self.protectPosMap) do
      local ld = self.equipPosStateTimeMap[pos]
      if ld and ld.protectalways <= 0 then
        needUpdate = true
        break
      end
    end
  end
  if needUpdate then
    self.traceTimeTick = TimeTickManager.Me():CreateTick(0, 1000, self._updatePosState, self, 1)
  else
    TimeTickManager.Me():ClearTick(self, 1)
  end
end

function FunctionEquipPosState:_updatePosState()
  local needUpdate
  local hasV = false
  for site, v in pairs(self.offPosMap) do
    hasV = true
    local ld = self.equipPosStateTimeMap[site]
    if ld == nil then
      self.offPosMap[site] = nil
    else
      local off_lefttime = _serverDeltaSecondTime(ld.offendtime * 1000)
      if off_lefttime < 0 then
        self.offPosMap[site] = nil
        EventManager.Me():PassEvent(RoleEquipEvent.OffPosEnd, site)
      else
        needUpdate = true
      end
    end
  end
  if hasV and not needUpdate then
    EventManager.Me():PassEvent(RoleEquipEvent.AllOffPosEnd)
  end
  for site, v in pairs(self.protectPosMap) do
    local ld = self.equipPosStateTimeMap[site]
    if ld == nil then
      self.protectPosMap[site] = nil
    elseif 0 >= ld.protectalways then
      local protect_lefttime = _serverDeltaSecondTime(ld.protecttime * 1000)
      if protect_lefttime < 0 then
        self.protectPosMap[site] = nil
        EventManager.Me():PassEvent(RoleEquipEvent.ProtectPosEnd, site)
      else
        needUpdate = true
      end
    end
  end
  if not needUpdate then
    TimeTickManager.Me():ClearTick(self, 1)
    self.traceTimeTick = nil
  end
end

function FunctionEquipPosState:GetEquipPos_StateTime(site)
  return self.equipPosStateTimeMap[site]
end

function FunctionEquipPosState:IsEquipPosInOffing(site)
  return self.offPosMap[site] ~= nil
end

function FunctionEquipPosState:IsEquipPosInProtecting(site)
  return self.protectPosMap[site] ~= nil
end

function FunctionEquipPosState:HasOffEquipPos()
  local k, _ = next(self.offPosMap)
  return k ~= nil
end

local tempTable = {}

function FunctionEquipPosState:GetOffingEquipPoses()
  TableUtility.ArrayClear(tempTable)
  for site, v in pairs(self.offPosMap) do
    table.insert(tempTable, site)
  end
  table.sort(tempTable, function(a, b)
    return a < b
  end)
  return tempTable
end

function FunctionEquipPosState:GetProtectEquipPoses()
  TableUtility.ArrayClear(tempTable)
  for site, v in pairs(self.protectPosMap) do
    table.insert(tempTable, site)
  end
  table.sort(tempTable, function(a, b)
    return a < b
  end)
  return tempTable
end
