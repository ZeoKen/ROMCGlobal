GCSystemManager = class("GCSystemManager")
local LogFormat = LogUtility.InfoFormat
local FormatSize = LogUtility.FormatSize_KB
local UpdateInterval = 1
local GCInterval = 120
local LimitLevel_1 = 92160
local LimitLevel_2 = 122880

function GCSystemManager:ctor()
  self.nextUpdateTime = 0
  self:InitData()
  self:Collect()
end

function GCSystemManager:Collect()
  local memOld = self.memCurrent or 0
  Debug_LuaMemotry.Debug()
  collectgarbage("collect")
  self.memStart = collectgarbage("count")
  self.memCurrent = self.memStart
  self:_SetTime()
end

function GCSystemManager:Update(time, deltaTime)
  if time < self.nextUpdateTime then
    return
  end
  self.nextUpdateTime = time + UpdateInterval
  self.memCurrent = collectgarbage("count")
  if LimitLevel_2 < self.memCurrent then
    self:Collect()
  elseif LimitLevel_1 < self.memCurrent and (nil == Game.Myself or not Game.Myself:IsMoving()) then
    self:Collect()
  end
end

function GCSystemManager:InitData()
  self.collectTimeGaps = {}
  self.sampleTimeGapCount = 8
  self.lastSampleTimeStamp = Time.unscaledTime * 1000
  self.limitAverageGapTime = 3000
  self.systemSizeOfRAM = DeviceInfo.GetSizeOfRAM() * 1024
  local platform = ApplicationInfo.GetRunPlatform()
  if ApplicationInfo.IsRunOnEditor() then
    LimitLevel_1 = 348160
    LimitLevel_2 = 389120
  elseif platform == RuntimePlatform.IPhonePlayer then
    if self.systemSizeOfRAM <= 1048576 then
      LimitLevel_1 = 143360
      LimitLevel_2 = 184320
    elseif self.systemSizeOfRAM <= 2097152 then
      LimitLevel_1 = 143360
      LimitLevel_2 = 184320
    elseif self.systemSizeOfRAM <= 3145728 then
      LimitLevel_1 = 143360
      LimitLevel_2 = 184320
    else
      LimitLevel_1 = 143360
      LimitLevel_2 = 184320
    end
  elseif self.systemSizeOfRAM <= 1048576 then
    LimitLevel_1 = 143360
    LimitLevel_2 = 184320
  elseif self.systemSizeOfRAM <= 2097152 then
    LimitLevel_1 = 143360
    LimitLevel_2 = 184320
  elseif self.systemSizeOfRAM <= 3145728 then
    LimitLevel_1 = 143360
    LimitLevel_2 = 184320
  elseif self.systemSizeOfRAM <= 4194304 then
    LimitLevel_1 = 143360
    LimitLevel_2 = 184320
  else
    LimitLevel_1 = 143360
    LimitLevel_2 = 184320
  end
  LimitLevel_1 = LimitLevel_1 + 40960
  LimitLevel_2 = LimitLevel_2 + 40960
  LimitLevel_1 = LimitLevel_1 + 107520
  LimitLevel_2 = LimitLevel_2 + 107520
  self:Log()
end

function GCSystemManager:_ResetTimeGap()
  TableUtility.ArrayClear(self.collectTimeGaps)
  self.collectTimeGaps[1] = self.limitAverageGapTime + 1
end

function GCSystemManager:_SetTime()
  local currentTime = Time.unscaledTime * 1000
  local gap = currentTime - self.lastSampleTimeStamp
  if gap == 0 then
    return
  end
  self.lastSampleTimeStamp = currentTime
  self.collectTimeGaps[#self.collectTimeGaps + 1] = gap
  if #self.collectTimeGaps > self.sampleTimeGapCount then
    table.remove(self.collectTimeGaps, 1)
  end
  local count = #self.collectTimeGaps
  local total = 0
  for i = 1, count do
    total = total + self.collectTimeGaps[i]
  end
  local average = total / count
  if average <= self.limitAverageGapTime then
    LimitLevel_1 = LimitLevel_1 + 2048
    LimitLevel_2 = LimitLevel_2 + 2048
    self:_ResetTimeGap()
  end
end

function GCSystemManager:Log()
  LogUtility.Info(self.systemSizeOfRAM)
end
