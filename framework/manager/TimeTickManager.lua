autoImport("TimeTick")
TimeTickManager = class("TimeTickManager")

function TimeTickManager.Me()
  if TimeTickManager.me == nil then
    TimeTickManager.me = TimeTickManager.new()
  end
  return TimeTickManager.me
end

function TimeTickManager:ctor()
  self.timeTickMap = {}
  self.timeTickIdMap = {}
end

function TimeTickManager:InitOwnerTable(owner)
  local ownerTicks = self.timeTickMap[owner]
  if ownerTicks == nil then
    ownerTicks = ReusableTable.CreateTable()
    self.timeTickMap[owner] = ownerTicks
  end
  return ownerTicks
end

function TimeTickManager:InitOwnerIdTable(owner, id)
  local ownerTickId = self.timeTickIdMap[owner]
  if ownerTickId == nil then
    ownerTickId = ReusableTable.CreateTable()
    self.timeTickIdMap[owner] = ownerTickId
  end
  ownerTickId.timeTickId = id or ownerTickId.timeTickId == nil and 1 or ownerTickId.timeTickId + 1
  return ownerTickId
end

function TimeTickManager:CreateTick(delay, interval, updateFunc, owner, id, rawSecond, loopCount)
  local ownerTickId = self:InitOwnerIdTable(owner, id)
  local ownerTicks = self:InitOwnerTable(owner)
  local tick = ownerTicks[ownerTickId.timeTickId]
  if tick == nil then
    tick = TimeTick.new(delay, interval, updateFunc, owner, ownerTickId.timeTickId, rawSecond, loopCount)
    ownerTicks[ownerTickId.timeTickId] = tick
  else
    tick:ResetData(delay, interval, updateFunc, owner, ownerTickId.timeTickId, rawSecond, loopCount)
  end
  tick:Restart()
  return tick
end

function TimeTickManager:CreateOnceDelayTick(delay, CompleteFunc, owner, id, rawSecond)
  local ownerTickId = self:InitOwnerIdTable(owner, id)
  local ownerTicks = self:InitOwnerTable(owner)
  local tick = ownerTicks[ownerTickId.timeTickId]
  if tick == nil then
    tick = TimeTick.new(delay, 0, nil, owner, ownerTickId.timeTickId, rawSecond, 1)
    ownerTicks[ownerTickId.timeTickId] = tick
  else
    tick:ResetData(delay, 0, nil, owner, ownerTickId.timeTickId, rawSecond, 1)
  end
  tick:SetCompleteFunc(CompleteFunc)
  tick:Restart()
  return tick
end

function TimeTickManager:CreateTickFromTo(delay, from, to, timeTotal, updateFunc, owner, id, rawSecond)
  local ownerTickId = self:InitOwnerIdTable(owner, id)
  local ownerTicks = self:InitOwnerTable(owner)
  local tick = ownerTicks[ownerTickId.timeTickId]
  if tick == nil then
    tick = TimeTick.new(delay, 0, updateFunc, owner, ownerTickId.timeTickId, rawSecond, -1, from, to, timeTotal)
    ownerTicks[ownerTickId.timeTickId] = tick
  else
    tick:ResetData(delay, 0, updateFunc, owner, ownerTickId.timeTickId, rawSecond, -1, from, to, timeTotal)
  end
  tick:Restart()
  return tick
end

function TimeTickManager:getCount(owner)
  local ownerTicks = self.timeTickMap[owner]
  local count = ownerTicks ~= nil and #ownerTicks or 0
  return count
end

function TimeTickManager:ClearTick(owner, id)
  local ownerTicks = self.timeTickMap[owner]
  if ownerTicks ~= nil then
    if id ~= nil then
      local tick = ownerTicks[id]
      if tick ~= nil then
        tick:ClearTick()
      end
    else
      for id, tick in pairs(ownerTicks) do
        tick:ClearTick()
      end
      self:ClearTickId(owner)
    end
  end
end

function TimeTickManager:ClearTickId(owner)
  local ownerTickId = self.timeTickIdMap[owner]
  ReusableTable.DestroyAndClearTable(ownerTickId)
  self.timeTickIdMap[owner] = nil
end

function TimeTickManager:HasTick(owner, id)
  local ownerTicks = self.timeTickMap[owner]
  if ownerTicks then
    if id then
      return ownerTicks[id] ~= nil
    end
    return true
  end
  return false
end

function TimeTickManager:Clear()
  printRed("清除所有计时器，慎用")
  for owner, ticks in pairs(self.timeTickMap) do
    ReusableTable.DestroyAndClearTable(ticks)
    self.timeTickMap[owner] = nil
    self:ClearTickId(owner)
  end
  self.timeTickMap = {}
end

function TimeTickManager:Update(time, deltaTime)
  for owner, ticks in pairs(self.timeTickMap) do
    if TableUtil.TableIsEmpty(ticks) then
      ReusableTable.DestroyAndClearTable(ticks)
      self.timeTickMap[owner] = nil
      self:ClearTickId(owner)
    else
      for id, tick in pairs(ticks) do
        if tick ~= nil then
          if tick.needDestroy then
            ticks[id] = nil
          else
            tick:Update(time, deltaTime)
          end
        end
      end
    end
  end
end
