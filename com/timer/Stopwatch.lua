Stopwatch = class("Stopwatch")

function Stopwatch:ctor(pauseFunc, owner, id)
  self:ResetData(pauseFunc, owner, id)
end

function Stopwatch:ResetData(pauseFunc, owner, id)
  self.pauseFunc = pauseFunc
  self.owner = owner
  self.id = id
  self:Clear()
end

function Stopwatch:Start()
  self:Clear()
  self.startTime = self:Continue()
end

function Stopwatch:Continue()
  self.continueTime = ServerTime.CurServerTime()
  self.isOn = true
  return self.continueTime
end

function Stopwatch:Pause()
  self.isOn = false
  self.timeInterval = self.timeInterval + (ServerTime.CurServerTime() - self.continueTime)
  if self.pauseFunc then
    self.pauseFunc(self.owner, self.timeInterval)
  end
end

function Stopwatch:Clear()
  self.isOn = false
  self.startTime = 0
  self.continueTime = 0
  self.timeInterval = 0
end
