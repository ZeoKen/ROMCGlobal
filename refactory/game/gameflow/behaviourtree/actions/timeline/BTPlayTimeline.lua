BTPlayTimeline = class("BTPlayTimeline", BTAction)
BTPlayTimeline.TypeName = "PlayTimeline"
BTDefine.RegisterAction(BTPlayTimeline.TypeName, BTPlayTimeline)

function BTPlayTimeline:ctor(config)
  BTPlayTimeline.super.ctor(self, config)
  self.assetId = config.assetId
  self.endBBKey = config.bbOnComplete and config.bbOnComplete.name
  self.endBBVal = config.bbOnComplete and config.bbOnComplete.value
end

function BTPlayTimeline:Dispose()
  BTPlayTimeline.super.Dispose(self)
end

function BTPlayTimeline:Exec(time, deltaTime, context)
  local ret = BTPlayTimeline.super.Exec(self, time, deltaTime, context)
  if ret ~= 0 then
    return 0
  end
  local bb = context.blackboard
  if not self.assetId or self.assetId == 0 or self.assetId == "" then
    bb:SetGlobalData(self.endBBKey, self.endBBVal)
    return 0
  end
  Game.PlotStoryManager:Launch()
  local result = Game.PlotStoryManager:Start_PQTLP(self.assetId, function()
    bb:SetGlobalData(self.endBBKey, self.endBBVal)
  end)
  if not result then
    bb:SetGlobalData(self.endBBKey, self.endBBVal)
  end
  return 0
end
