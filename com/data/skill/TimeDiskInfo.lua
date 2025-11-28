TimeDiskInfo = class("TimeDiskInfo")
TimeDiskInfo.Move = {
  Run = SceneSkill_pb.TIMEDISKMOVE_RUN,
  Suspend = SceneSkill_pb.TIMEDISKMOVE_SUSPEND,
  Del = SceneSkill_pb.TIMEDISKMOVE_DEL
}
local deltaTime = 0
local bigGridNum = GameConfig.TimeDisk.bigGridNum
local smallGridNum = GameConfig.TimeDisk.smallGridNum
local totalGrid = bigGridNum * smallGridNum
local MaxGrid = totalGrid * 2

function TimeDiskInfo:ctor(points)
  self.move = TimeDiskInfo.Move.Run
  self.isSun = true
  self.curGrid = 0
end

function TimeDiskInfo:SetData(data)
  if data then
    self.move = data.move
    self.isSun = data.sundisk
    self.smallgrid = data.smallgrid
    self.begintime = data.begintime
    if not self.isSun then
      self.smallgrid = self.smallgrid + smallGridNum * bigGridNum
    end
    self.suspendtime = data.suspendendtime
    redlog("self.move,self.isSun,self.starttime", self.begintime, self.isSun, self.smallgrid)
  end
end

function TimeDiskInfo:isSun()
  return self.isSun
end

function TimeDiskInfo:MoveGrid()
  self.smallgrid = (self.smallgrid + 1) % (totalGrid * 2)
end

function TimeDiskInfo:ResetGrid(v)
  self.smallgrid = v
end

local zone, zonb_b = 1, 1

function TimeDiskInfo:GetCurGrid()
  if not self.smallgrid then
    return 1
  end
  zone = self.smallgrid % totalGrid
  zone_b = zone // (bigGridNum + 1) + 1
  return zone_b
end

local curTime = 0
local curDelta, totalDelta, maxDelta = 0, 0, 0

function TimeDiskInfo:GetSmallGrid()
  if self.begintime ~= 0 then
    curTime = ServerTime.CurServerTime()
    curDelta = (curTime - self.begintime) // 1000
    totalDelta = curDelta % totalGrid
    maxDelta = curDelta % MaxGrid
    self.isSun = maxDelta < totalGrid
    self.smallgrid = totalDelta
    self.begintime = 0
  end
  return self.smallgrid
end
