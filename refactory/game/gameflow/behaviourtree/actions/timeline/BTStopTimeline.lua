BTStopTimeline = class("BTStopTimeline", BTAction)
BTStopTimeline.TypeName = "StopTimeline"
BTDefine.RegisterAction(BTStopTimeline.TypeName, BTStopTimeline)

function BTStopTimeline:ctor(config)
  BTStopTimeline.super.ctor(self, config)
  self.assetId = config.assetId
end

function BTStopTimeline:Dispose()
  BTStopTimeline.super.Dispose(self)
end

function BTStopTimeline:Exec(time, deltaTime, context)
  local ret = BTStopTimeline.super.Exec(self, time, deltaTime, context)
  if ret ~= 0 then
    return 0
  end
  if not self.assetId or self.assetId == 0 or self.assetId == "" then
    return 0
  end
  Game.PlotStoryManager:StopProgressById(self.assetId)
  return 0
end
