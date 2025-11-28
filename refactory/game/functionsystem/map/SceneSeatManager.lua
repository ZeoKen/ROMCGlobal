autoImport("SceneSeat")
local SitAction = 60
local DisplaySkillID = 50031001
local DisplayDuration = 60
local DisplaySkillReason = 9999
local CheckRangeInterval = 1
local VectorDistanceXZ = VectorUtility.DistanceXZ_Square
SceneSeatManager = class("SceneSeatManager")
SceneSeatManager.SkillID = DisplaySkillID

function SceneSeatManager:ctor()
  self.staticData = nil
  self.seats = {}
  self.checkRange = {}
  self.sittingCreatures = {}
  self.displayingReason = {}
  self.displayEndTime = 0
  self.nextCheckRangeTime = 0
end

function SceneSeatManager:Display(duration)
  self.displayEndTime = UnityTime + duration
  self:SetDisplay(true)
end

function SceneSeatManager:SetDisplay(on, reason)
  reason = reason or DisplaySkillReason
  if on == self.displayingReason[reason] then
    return
  end
  local orginDisplaying = self:IsDisplaying()
  self.displayingReason[reason] = on
  local isDisplaying = self:IsDisplaying()
  if orginDisplaying ~= isDisplaying then
    local seats = self.seats
    if isDisplaying then
      for k, v in pairs(seats) do
        v:DeterminShow()
      end
    else
      for k, v in pairs(seats) do
        v:Hide()
      end
    end
  end
  if not isDisplaying and reason == DisplaySkillReason then
    self.displayEndTime = 0
  end
end

function SceneSeatManager:SeatIsCustom(seatID)
  local seat = self.seats[seatID]
  if seat then
    return seat.isCustomSeat
  end
  return false
end

function SceneSeatManager:SetSeatsDisplay(seats, on)
  if seats then
    local seat
    for i = 1, #seats do
      seat = self.seats[seats[i]]
      if seat then
        if on then
          seat:Server_Show()
        else
          seat:Hide()
        end
      end
    end
  end
end

function SceneSeatManager:IsDisplaying()
  local skillDisplay = self:IsSkillDisplaying()
  if not skillDisplay then
    return false
  end
  for k, v in pairs(self.displayingReason) do
    if k ~= DisplaySkillReason and not v then
      return false
    end
  end
  return true
end

function SceneSeatManager:IsSkillDisplaying()
  return self.displayingReason[DisplaySkillReason]
end

function SceneSeatManager:GetCreatureSeat(creature)
  return self.sittingCreatures[creature]
end

function SceneSeatManager:GetOnSeat(creature, seatID, furn_guid)
  local seat
  if furn_guid ~= nil and furn_guid ~= 0 and furn_guid ~= "" then
    for _, s1t in pairs(self.seats) do
      if s1t:GetCustomParam("furn_guid") == furn_guid then
        seat = s1t
        break
      end
    end
  else
    seat = self.seats[seatID]
  end
  if nil == seat then
    return false
  end
  local oldSeat = self:GetCreatureSeat(creature)
  if nil ~= oldSeat then
    if oldSeat:GetID() == seatID then
      return true
    end
    self.sittingCreatures[creature] = nil
    oldSeat:GetOff(creature)
  end
  if not seat:GetOn(creature) then
    return false
  end
  self.sittingCreatures[creature] = seat
  creature:RegisterWeakObserver(self)
  return true
end

function SceneSeatManager:MyselfManualGetOffSeat()
  local creature = Game.Myself
  local seat = self:GetCreatureSeat(creature)
  if nil == seat then
    return false
  end
  self.sittingCreatures[creature] = nil
  seat:GetOff(creature)
  if self.isAtHome then
    ServiceNUserProxy.Instance:CallCheckSeatUserCmd(seat:GetCustomParam("furn_guid"), seat:GetID() % 100, false)
  else
    ServiceNUserProxy.Instance:CallCheckSeatUserCmd(nil, seat:GetID(), false)
  end
  return true
end

function SceneSeatManager:GetOffSeat(creature)
  local seat = self:GetCreatureSeat(creature)
  if nil == seat then
    return false
  end
  self.sittingCreatures[creature] = nil
  seat:GetOff(creature)
  return true
end

function SceneSeatManager:TryGetOffSeat(creature, seatID, furn_guid)
  local seat = self:GetCreatureSeat(creature)
  if nil == seat then
    return true
  end
  if (furn_guid == nil or furn_guid == 0) and seat:GetID() ~= seatID then
    return false
  end
  self.sittingCreatures[creature] = nil
  seat:GetOff(creature)
  return true
end

function SceneSeatManager:ClickSeat(obj)
  local creature = Game.Myself
  local seat = self:GetCreatureSeat(creature)
  if nil ~= seat then
    return
  end
  local seatID = obj.ID
  seat = self.seats[seatID]
  if nil == seat then
    return
  end
  local accessPos = seat:GetAccessPosition()
  if VectorUtility.AlmostEqual_3_XZ(accessPos, creature:GetPosition()) then
    self:_OnSeatAccessed(seatID)
    return
  end
  creature:Client_MoveXYZTo(accessPos[1], accessPos[2], accessPos[3], nil, nil, SceneSeatManager._OnSeatAccessed, self, seatID)
end

function SceneSeatManager:_OnSeatAccessed(seatID)
  local creature = Game.Myself
  local seat = self:GetCreatureSeat(creature)
  if nil ~= seat then
    return
  end
  seat = self.seats[seatID]
  if nil == seat then
    return
  end
  if 0 < seat:GetPassengerCount() then
    return
  end
  FunctionSystem.InterruptMyselfAll()
  self:GetOnSeat(creature, seatID)
  if self.isAtHome then
    ServiceNUserProxy.Instance:CallCheckSeatUserCmd(seat:GetCustomParam("furn_guid"), seatID % 100, true)
  else
    ServiceNUserProxy.Instance:CallCheckSeatUserCmd(nil, seatID, true)
  end
  creature:Client_PlayMotionAction(SitAction)
  creature:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, seat:GetDir(), true)
  self:SetDisplay(false)
end

function SceneSeatManager:_CreateSeats()
  local seats = self.seats
  local range = self.checkRange
  for k, v in pairs(self.staticData) do
    local seat
    if v.PrefabID == nil then
      seat = SceneSeat.Create(v)
    else
      seat = CustomSceneSeat.Create(v)
    end
    if self.displaying then
      seat:DeterminShow()
    end
    seats[k] = seat
    if v.FindRange ~= nil then
      range[#range + 1] = k
    end
  end
end

function SceneSeatManager:_DestroySeats()
  local seats = self.seats
  for k, v in pairs(seats) do
    seats[k] = nil
    v:Destroy()
  end
  local range = self.checkRange
  for i = #range, 1, -1 do
    range[i] = nil
  end
end

function SceneSeatManager:_ClearSittingCreatures()
  for k, v in pairs(self.sittingCreatures) do
    v:GetOff(k)
    k:UnregisterWeakObserver(self)
    self.sittingCreatures[k] = nil
  end
end

function SceneSeatManager:_OnSkillUsed(skillID)
  if DisplaySkillID == skillID then
    self:Display(DisplayDuration)
  end
end

function SceneSeatManager:ObserverDestroyed(creature)
  self:GetOffSeat(creature)
end

function SceneSeatManager:UpdateCheckRange()
  if not SkillProxy.Instance:HasLearnedSkill(DisplaySkillID) then
    return
  end
  local seat, seatPot, isInTrigger
  local myPos = Game.Myself:GetPosition()
  for i = 1, #self.checkRange do
    seat = self.seats[self.checkRange[i]]
    if seat ~= nil then
      seatPot = seat.staticData.SeatPot
      if seatPot ~= nil then
        local findRange = seat.staticData.FindRange
        if VectorDistanceXZ(myPos, seatPot) < findRange * findRange then
          isInTrigger = true
          break
        end
      end
    end
  end
  if self.checkRangeInTrigger ~= isInTrigger then
    self.checkRangeInTrigger = isInTrigger
  end
end

function SceneSeatManager:Launch()
  if self.running then
    return
  end
  local mapID = Game.MapManager:GetMapID()
  local mapInfo = Table_Map[mapID]
  if nil == mapInfo then
    return
  end
  local seatFile = "Table_Seat_" .. mapInfo.NameEn
  if ResourceID.CheckFileIsRecorded(seatFile) then
    if _G[seatFile] == nil then
      autoImport(seatFile)
    end
    self.staticData = _G[seatFile]
  end
  self.isAtHome = HomeManager.Me():IsAtHome()
  if self.isAtHome then
    if self.staticData == nil then
      self.staticData = {}
    end
    EventManager.Me():AddEventListener(HomeEvent.AddFurniture, SceneSeatManager._OnFurnitureCreate, self)
    EventManager.Me():AddEventListener(HomeEvent.RemoveFurniture, SceneSeatManager._OnFurnitureRemove, self)
    EventManager.Me():AddEventListener(HomeEvent.UpdateFurniture, SceneSeatManager._OnFurnitureUpdate, self)
  end
  if nil == self.staticData then
    return
  end
  self.running = true
  EventManager.Me():AddEventListener(MyselfEvent.UsedSkill, SceneSeatManager._OnSkillUsed, self)
  self:_CreateSeats()
end

local mFurnitureSetasIDs = {}

function SceneSeatManager:_OnFurnitureCreate(note)
  self:_UpdateSeatsByNfurniture(note.data)
end

function SceneSeatManager:_UpdateSeatsByNfurniture(nfurniture)
  if nfurniture == nil then
    return
  end
  local seatTypes = GameConfig.Home.SeatTypes
  if seatTypes == nil then
    return
  end
  local sid = nfurniture.data:GetFurnitureType()
  if not TableUtil.FindKeyByValue(seatTypes, sid) then
    return
  end
  local isDisplay = self:IsDisplaying()
  local MAX_COUNT = nfurniture.staticData and nfurniture.staticData.SeatCount or 0
  local _FindGO = UIUtil.FindGO
  local spGO, cpGO
  for i = 1, MAX_COUNT do
    spGO = _FindGO("SP_" .. i, nfurniture.gameObject)
    if spGO == nil then
      break
    end
    cpGO = _FindGO("CP_" .. i, nfurniture.gameObject)
    local id = nfurniture.tag
    mFurnitureSetasIDs[id] = i
    local fid = id * 100 + i
    local seat = self.seats[fid]
    if seat == nil then
      local fakeData = {}
      fakeData.id = fid
      seat = SceneSeat.Create(fakeData)
      seat:SetCustomParam("furn_guid", nfurniture.id)
      self.seats[fid] = seat
    end
    seat.staticData.StandPot = {
      LuaGameObject.GetPosition(spGO.transform)
    }
    seat.staticData.SeatPot = {
      LuaGameObject.GetPosition(cpGO.transform)
    }
    _, seat.staticData.Dir = LuaGameObject.GetEulerAngles(cpGO.transform)
    if isDisplay then
      seat:DeterminShow()
    end
  end
end

function SceneSeatManager:_OnFurnitureUpdate(note)
  self:_UpdateSeatsByNfurniture(note.data)
end

function SceneSeatManager:_OnFurnitureRemove(note)
  local guid, id = note.data[1], note.data[2]
  local maxCount = mFurnitureSetasIDs[id]
  if maxCount == nil then
    return
  end
  mFurnitureSetasIDs[id] = nil
  local seats = self.seats
  local fid
  for i = 1, maxCount do
    fid = id * 100 + i
    local seat = seats[fid]
    if seat == nil then
    else
      for k, cacheSeat in pairs(self.sittingCreatures) do
        if cacheSeat == seat then
          self.sittingCreatures[k] = nil
          break
        end
      end
      seat:Destroy()
      seats[fid] = nil
    end
  end
end

function SceneSeatManager:Shutdown()
  if not self.running then
    return
  end
  self.running = false
  EventManager.Me():RemoveEventListener(MyselfEvent.UsedSkill, SceneSeatManager._OnSkillUsed, self)
  if self.isAtHome then
    EventManager.Me():RemoveEventListener(HomeEvent.AddFurniture, SceneSeatManager._OnFurnitureCreate, self)
    EventManager.Me():RemoveEventListener(HomeEvent.RemoveFurniture, SceneSeatManager._OnFurnitureRemove, self)
    EventManager.Me():RemoveEventListener(HomeEvent.UpdateFurniture, SceneSeatManager._OnFurnitureUpdate, self)
  end
  self.isAtHome = nil
  self:_ClearSittingCreatures()
  self:_DestroySeats()
  self.staticData = nil
  self.displayEndTime = 0
  self.nextCheckRangeTime = 0
  self.checkRangeInTrigge = nil
  TableUtility.TableClear(self.displayingReason)
end

function SceneSeatManager:Update(time, deltaTime)
  if not self.running then
    return
  end
  if self:IsSkillDisplaying() and 0 < self.displayEndTime and time > self.displayEndTime then
    self:SetDisplay(false)
  end
  if time >= self.nextCheckRangeTime then
    self.nextCheckRangeTime = time + CheckRangeInterval
    self:UpdateCheckRange()
  end
end
