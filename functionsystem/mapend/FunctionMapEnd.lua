FunctionMapEnd = class("FunctionMapEnd")

function FunctionMapEnd.Me()
  if nil == FunctionMapEnd.me then
    FunctionMapEnd.me = FunctionMapEnd.new()
  end
  return FunctionMapEnd.me
end

function FunctionMapEnd:ctor()
end

function FunctionMapEnd:Reset()
  self:ResetDelayCall()
  self.isRunning = false
end

function FunctionMapEnd:ResetDelayCall()
  if self.delayed ~= nil then
    self.delayed:Destroy()
    self.delayed = nil
  end
  if not BackwardCompatibilityUtil.CompatibilityMode_V62 then
    ResourceManager.Instance:SetDelayedGC(0)
  end
end

function FunctionMapEnd:TempSetDurationToTimeLine()
end

function FunctionMapEnd:SetBackDurationToTimeLine()
end

function FunctionMapEnd:BeginIgnoreAreaTrigger()
  if self.areaTriggerIgnored then
    return
  end
  self.areaTriggerIgnored = true
  Game.AreaTriggerManager:ResetIgnoreAndSyncIgnoreCount(2)
end

function FunctionMapEnd:EndIgnoreAreaTrigger()
  if not self.areaTriggerIgnored then
    return
  end
  self.areaTriggerIgnored = false
  Game.AreaTriggerManager:SetIgnore(false)
end

function FunctionMapEnd:Launch()
  if self.isRunning then
    return
  end
  self:ResetDelayCall()
  self.isRunning = true
  self:SetBackDurationToTimeLine()
  self.delayed = TimeTickManager.Me():CreateOnceDelayTick(66, function(owner, deltaTime)
    self.isRunning = false
    self.delayed = nil
    GameFacade.Instance:sendNotification(LoadingSceneView.ServerReceiveLoaded)
    self:EndIgnoreAreaTrigger()
    FunctionChangeScene.Me():GC()
    if not BackwardCompatibilityUtil.CompatibilityMode_V62 then
      ResourceManager.Instance:SetDelayedGC(-1)
    end
    FunctionChangeScene.Me():UpdateGCStrategy()
  end, self)
end
