FunctionScenicSpot = class("FunctionScenicSpot")
FunctionScenicSpot.Event = {
  StateChanged = {},
  ScenicSpotInvalidated = {}
}
local tempVector3 = LuaVector3.Zero()

function FunctionScenicSpot.Me()
  if nil == FunctionScenicSpot.me then
    FunctionScenicSpot.me = FunctionScenicSpot.new()
  end
  return FunctionScenicSpot.me
end

function FunctionScenicSpot:ctor()
  self:Reset()
  self.hideScenicSpots = {}
  EventManager.Me():AddEventListener(CreatureEvent.Hiding_Change, self.HandleCreatureHideChange, self)
end

function FunctionScenicSpot:Reset()
  self.deltaTime = 0
  return true
end

function FunctionScenicSpot:GetAllScenicSpot()
  return self.scenicSpots
end

function FunctionScenicSpot:GetScenicSpots(ssID)
  if nil == self.scenicSpots then
    return nil
  end
  return self.scenicSpots[ssID]
end

function FunctionScenicSpot:GetScenicSpot(ssID)
  if nil == self.scenicSpots then
    return nil
  end
  local spot = self.scenicSpots[ssID]
  if spot and not spot.ID and spot[1] then
    self:UpdateScenicCreaturePos(spot[1])
    return spot[1]
  end
  return spot
end

function FunctionScenicSpot:RemoveScenicSpot(ssID)
  if nil == self.scenicSpots then
    return nil
  end
  local ss = self.scenicSpots[ssID]
  self.scenicSpots[ssID] = nil
  return ss
end

function FunctionScenicSpot:AddCreatureScenicSpot(guid, ssID)
  if self.hideScenicSpots[guid] then
    self.hideScenicSpots[guid] = ssID
    return
  end
  local creature = SceneCreatureProxy.FindCreature(guid)
  if not creature then
    return
  end
  if creature.data.props:GetPropByName("Hiding"):GetValue() > 0 and (not (Game.Myself and Game.Myself.data) or Game.Myself.data.id ~= guid) then
    self.hideScenicSpots[guid] = ssID
    return
  end
  self.scenicSpots = self.scenicSpots or {}
  local ss = self.scenicSpots[ssID]
  if ss then
    for i = 1, #ss do
      local single = ss[i]
      if single.guid == guid then
        return
      end
    end
  else
    ss = {}
  end
  local posX, posY, posZ = creature.assetRole:GetEPPosition(RoleDefines_EP.Top)
  local data = {
    ID = ssID,
    position = LuaVector3.Zero(),
    guid = guid
  }
  if posX then
    data.position = LuaVector3(posX, posY, posZ)
  end
  ss[#ss + 1] = data
  self.scenicSpots[ssID] = ss
  return data
end

function FunctionScenicSpot:RemoveCreatureScenicSpot(guid, ssID)
  self.hideScenicSpots[guid] = nil
  if nil == self.scenicSpots then
    return nil
  end
  local removeData
  if ssID then
    local ss = self.scenicSpots[ssID]
    if not ss then
      return
    end
    for i = 1, #ss do
      local single = ss[i]
      if single.guid == guid then
        table.remove(ss, i)
        removeData = single
        if #ss == 0 then
          self.scenicSpots[ssID] = nil
        end
        break
      end
    end
    if removeData then
      self:Notify(MiniMapEvent.CreatureScenicRemove, removeData)
    end
    return
  end
  for k, v in pairs(self.scenicSpots) do
    if not v.ID then
      for i = 1, #v do
        local single = v[i]
        if single.guid == guid then
          ssID = single.ID
          removeData = single
          table.remove(v, i)
          if #v == 0 then
            self.scenicSpots[single.ID] = nil
          end
          break
        end
      end
    end
  end
  if removeData then
    self:Notify(MiniMapEvent.CreatureScenicRemove, removeData)
  end
end

function FunctionScenicSpot:GetNearestScenicSpot(originPos, camera)
  if nil == self.scenicSpots then
    return nil
  end
  local nearestScenicSpot
  local minDistance = 9999999
  for k, v in pairs(self.scenicSpots) do
    local ss = v
    local distance = -1
    if v.ID then
      if nil ~= camera then
        local viewport = camera:WorldToViewportPoint(ss.position)
        if 0 < viewport.x and viewport.x < 1 and 0 < viewport.y and 1 > viewport.y and camera.nearClipPlane < viewport.z and camera.farClipPlane > viewport.z then
          distance = viewport.z
        end
      else
        distance = LuaVector3.Distance(ss.position, originPos)
      end
      if not (0 < distance and minDistance > distance) or self:IsThisSceneSpotShouldBeRemoved(ss) then
      else
        minDistance = distance
        nearestScenicSpot = ss
      end
    else
      for i = 1, #v do
        local single = v[i]
        self:UpdateScenicCreaturePos(single)
        if nil ~= camera then
          local viewport = camera:WorldToViewportPoint(single.position)
          if 0 < viewport.x and viewport.x < 1 and 0 < viewport.y and 1 > viewport.y and camera.nearClipPlane < viewport.z and camera.farClipPlane > viewport.z then
            distance = viewport.z
          end
        else
          distance = LuaVector3.Distance(single.position, originPos)
        end
        if not (0 < distance and minDistance > distance) or self:IsThisSceneSpotShouldBeRemoved(single) then
        else
          minDistance = distance
          nearestScenicSpot = single
        end
      end
    end
  end
  return nearestScenicSpot
end

function FunctionScenicSpot:IsThisSceneSpotShouldBeRemoved(nearestScenicSpot)
  if nearestScenicSpot and nearestScenicSpot.ID then
    local viewSpotData = Table_Viewspot[nearestScenicSpot.ID]
    if AdventureDataProxy.Instance:IsSceneryUnlock(nearestScenicSpot.ID) and viewSpotData.Type == 3 then
      return true
    end
  end
  return false
end

function FunctionScenicSpot:UpdateScenicCreaturePos(senicData)
  local creature = SceneCreatureProxy.FindCreature(senicData.guid)
  if not creature then
    return
  end
  local posX, posY, posZ = creature.assetRole:GetEPPosition(RoleDefines_EP.Top)
  if posX then
    LuaVector3.Better_Set(tempVector3, posX, posY, posZ)
    if senicData.position and LuaVector3.Equal(tempVector3, senicData.position) then
      return
    end
    senicData.position = VectorUtility.TryAsign_3(senicData.position, tempVector3)
    return true
  end
end

function FunctionScenicSpot:ResetValidScenicSpots(validScenicSpotIDs)
  if not self:Reset() then
    return false
  end
  local validScenicSpots = {}
  for i = 1, #validScenicSpotIDs do
    local ssID = validScenicSpotIDs[i].sceneryid
    if nil ~= ssID then
      local info = Table_Viewspot[ssID]
      if nil ~= info then
        local coordinate = info.Coordinate
        local ss = {}
        ss.mapid = info.MapName
        ss.ID = ssID
        ss.position = LuaVector3(coordinate[1], coordinate[2], coordinate[3])
        validScenicSpots[ssID] = ss
      end
    end
  end
  if not self.scenicSpots then
    self.scenicSpots = validScenicSpots
  else
    for k, v in pairs(self.scenicSpots) do
      if not v.ID then
        local ss = validScenicSpots[k] or {}
        for i = 1, #v do
          local single = v[i]
          ss[#ss + 1] = v[i]
        end
        validScenicSpots[k] = ss
      end
    end
    self.scenicSpots = validScenicSpots
  end
  local data = {
    validScenicSpots = {}
  }
  local curMapID = Game.MapManager:GetMapID()
  for k, info in pairs(validScenicSpots) do
    if info.mapid == curMapID then
      table.insert(data.validScenicSpots, info)
    end
  end
  self:Notify(FunctionScenicSpot.Event.StateChanged, data)
  return true
end

function FunctionScenicSpot:InvalidateScenicSpot(data)
  ServiceNUserProxy.Instance:CallSceneryUserCmd(nil, {
    [1] = data
  })
  return true
end

function FunctionScenicSpot:HandleCreatureHideChange(guid)
  local creature = SceneCreatureProxy.FindCreature(guid)
  if not creature then
    return
  end
  local hideValue = creature.data.props:GetPropByName("Hiding"):GetValue()
  if 0 < hideValue then
    if Game.Myself and Game.Myself.data and Game.Myself.data.id == guid then
      return
    end
    if not self.scenicSpots or self.hideScenicSpots[guid] then
      return
    end
  else
    local ssID = self.hideScenicSpots[guid]
    if ssID then
      self.hideScenicSpots[guid] = nil
      self:AddCreatureScenicSpot(guid, ssID)
    end
    return
  end
  for k, v in pairs(self.scenicSpots) do
    if not v.ID then
      for i = 1, #v do
        local single = v[i]
        if single.guid == guid then
          self:RemoveCreatureScenicSpot(guid, single.ID)
          self.hideScenicSpots[guid] = single.ID
          break
        end
      end
    end
  end
end

function FunctionScenicSpot:Update(time, deltaTime)
  if self.deltaTime < 1 and deltaTime then
    self.deltaTime = self.deltaTime + deltaTime
    return
  end
  self.deltaTime = 0
  if not self.scenicSpots then
    return
  end
  local changeList = {}
  for k, v in pairs(self.scenicSpots) do
    local ss = v
    if not v.ID then
      for i = 1, #v do
        local single = v[i]
        local changed = self:UpdateScenicCreaturePos(single)
        if changed then
          changeList[#changeList + 1] = single
        end
      end
    end
  end
  if 0 < #changeList then
    self:Notify(MiniMapEvent.CreatureScenicChange, changeList)
  end
end

function FunctionScenicSpot:Notify(event, data)
  if nil == GameFacade then
    return
  end
  GameFacade.Instance:sendNotification(event, data)
end
