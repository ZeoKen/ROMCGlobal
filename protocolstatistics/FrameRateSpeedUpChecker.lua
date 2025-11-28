FrameRateSpeedUpChecker = class("FrameRateSpeedUpChecker")
local deltaTime = 60

function FrameRateSpeedUpChecker.Instance()
  if FrameRateSpeedUpChecker.instance == nil then
    FrameRateSpeedUpChecker.instance = FrameRateSpeedUpChecker.new()
  end
  return FrameRateSpeedUpChecker.instance
end

function FrameRateSpeedUpChecker:Open()
end

function FrameRateSpeedUpChecker:Close()
  if self.tick ~= nil then
    self.tick:ClearTick()
    self.tick = nil
  end
end

function FrameRateSpeedUpChecker:RequestTellFrameCount()
  ServiceLoginUserCmdProxy.Instance:CallClientFrameUserCmd(UnityFrameCount)
end

function FrameRateSpeedUpChecker:OnTick()
  self:RequestTellFrameCount()
end
