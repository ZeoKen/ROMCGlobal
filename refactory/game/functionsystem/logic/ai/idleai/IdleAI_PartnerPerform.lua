IdleAI_PartnerPerform = class("IdleAI_PartnerPerform")
local EventType = {
  EMOJI = 1,
  DIALOG = 2,
  AUDIO = 3,
  PLOT = 4
}
local RunningState = {
  DISABLE = 0,
  NORMAL = 1,
  ADVANCED = 2
}

function IdleAI_PartnerPerform:ctor()
  self.elapsedTime = 0
  self.eventHandler = {
    [EventType.EMOJI] = self.PlayEmoji,
    [EventType.DIALOG] = self.PlayDialog,
    [EventType.AUDIO] = self.PlayAudio,
    [EventType.PLOT] = self.PlayPlotStory
  }
  self.stopHandler = {
    [EventType.EMOJI] = self.StopEmoji,
    [EventType.DIALOG] = self.StopDialog,
    [EventType.AUDIO] = self.StopAudio,
    [EventType.PLOT] = self.StopPlotStory
  }
  self.state = RunningState.DISABLE
end

function IdleAI_PartnerPerform:Clear(idleElapsed, time, deltaTime, creature)
  self.state = RunningState.DISABLE
  self.elapsedTime = 0
  self.eventHandler = nil
  self.stopHandler = nil
  self.blankTime = nil
  self.currentEvent = nil
end

function IdleAI_PartnerPerform:Prepare(idleElapsed, time, deltaTime, creature)
  return true
end

function IdleAI_PartnerPerform:Start(idleElapsed, time, deltaTime, creature)
  local eventId = self:RandomEvent(creature)
  redlog("IdleAI_PartnerPerform:Start", tostring(eventId))
  self:ExecuteEvent(eventId, creature)
  self.state = RunningState.NORMAL
end

function IdleAI_PartnerPerform:End(idleElapsed, time, deltaTime, creature)
  self.elapsedTime = 0
  self.currentEvent = nil
  self.blankTime = nil
  self.state = RunningState.DISABLE
end

function IdleAI_PartnerPerform:Update(idleElapsed, time, deltaTime, creature)
  if self.state == RunningState.DISABLE then
    return
  end
  if not self.blankTime then
    return
  end
  local eventId = self.currentEvent
  local config = Table_FollowNpcEvent[eventId]
  if not config then
    return
  end
  self.elapsedTime = self.elapsedTime + deltaTime
  if self.elapsedTime >= self.blankTime then
    if self.state == RunningState.NORMAL then
      eventId = self:RandomEvent(creature)
    elseif self.state == RunningState.ADVANCED then
      local isLoop = config.isLoop == 1 and true or false
      if not isLoop and self.endCall then
        self.endCall(self.endCallParam)
        self.endCall = nil
      end
    end
    self:ExecuteEvent(eventId, creature)
    self.elapsedTime = 0
  end
  return true
end

function IdleAI_PartnerPerform:RandomEvent(creature)
  if not creature then
    return
  end
  local npcId = creature.data.id
  local mapId = Game.MapManager:GetMapID()
  if GameConfig.FollowNpcAI and GameConfig.FollowNpcAI[mapId] then
    local aiData = GameConfig.FollowNpcAI[mapId][npcId]
    if not aiData then
      return
    end
    local weights = 0
    for i = 1, #aiData.Events do
      local data = aiData.Events[i]
      local weight = data.weight
      weights = weights + weight
    end
    local randomWeight = math.random(0, weights)
    for i = 1, #aiData.Events do
      local data = aiData.Events[i]
      local weight = data.weight
      weights = weights - weight
      if randomWeight >= weights then
        return data.id
      end
    end
  end
end

function IdleAI_PartnerPerform:RandomBlankTime(creature)
  if not creature then
    return
  end
  local npcId = creature.data.id
  local mapId = Game.MapManager:GetMapID()
  if GameConfig.FollowNpcAI and GameConfig.FollowNpcAI[mapId] then
    local aiData = GameConfig.FollowNpcAI[mapId][npcId]
    if not aiData then
      return
    end
    local blank = aiData.BlankTime
    if blank and 0 < #blank then
      local startTime = blank[1]
      local endTime = blank[2]
      if endTime then
        return math.random(startTime, endTime)
      else
        return startTime
      end
    end
  end
end

function IdleAI_PartnerPerform:ExecuteEvent(eventId, creature)
  local data = Table_FollowNpcEvent[eventId]
  if not data then
    return
  end
  self.currentEvent = eventId
  redlog("IdleAI_PartnerPerform:ExecuteEvent", eventId)
  local type = data.type
  local params = data.params
  local handler = self.eventHandler[type]
  if handler then
    handler(self, creature, params)
  end
  if type == EventType.PLOT then
    self.blankTime = nil
  else
    self.blankTime = self:RandomBlankTime(creature)
  end
end

function IdleAI_PartnerPerform:StopCurrentEvent(creature)
  local data = Table_FollowNpcEvent[self.currentEvent]
  if not data then
    return
  end
  local type = data.type
  local stopHandler = self.stopHandler[type]
  if stopHandler then
    stopHandler(self, creature)
  end
end

function IdleAI_PartnerPerform:Interrupt(eventId, creature, endCall, endCallParam)
  self.endCall = endCall
  self.endCallParam = endCallParam
  self:RestartEvent(eventId, creature, RunningState.ADVANCED)
end

function IdleAI_PartnerPerform:Pause(creature)
  self:StopCurrentEvent(creature)
  self.state = RunningState.DISABLE
end

function IdleAI_PartnerPerform:Resume(creature)
  local eventId = self:RandomEvent(creature)
  self:RestartEvent(eventId, creature, RunningState.NORMAL)
end

function IdleAI_PartnerPerform:RestartEvent(eventId, creature, state)
  self:StopCurrentEvent(creature)
  self:ExecuteEvent(eventId, creature)
  self.state = state
  self.elapsedTime = 0
end

function IdleAI_PartnerPerform:PlayEmoji(creature, params)
  if not creature then
    return
  end
  local emojiId = params.emojiid
  local sceneUI = creature:GetSceneUI()
  local emojiData = Table_Expression[emojiId]
  redlog("IdleAI_PartnerPerform:PlayEmoji", tostring(emojiId))
  if sceneUI and emojiData then
    redlog("emojiData", emojiData.NameEn)
    sceneUI.roleTopUI:PlayEmoji(emojiData.NameEn, nil, nil, creature)
  end
end

function IdleAI_PartnerPerform:PlayDialog(creature, params)
  if not creature then
    return
  end
  local dialogId = params.dialogid
  local dialogData = DialogUtil.GetDialogData(dialogId)
  local msg = dialogData and dialogData.Text
  local sceneUI = creature:GetSceneUI()
  if sceneUI then
    sceneUI.roleTopUI:Speak(msg, creature, true)
  end
end

function IdleAI_PartnerPerform:PlayAudio(creature, params)
  if not creature then
    return
  end
  local path = params.audiopath
  path = ResourcePathHelper.AudioSE(path)
  local ep = RoleDefines_EP.Top
  local pos = LuaGeometry.GetTempVector3(creature.assetRole:GetEPOrRootPosition(ep))
  redlog("IdleAI_PartnerPerform:PlayAudio", tostring(path))
  AudioUtility.PlayOneShotAt_Path(path, pos)
end

function IdleAI_PartnerPerform:PlayPlotStory(creature, params)
  if not creature then
    return
  end
  local pqtlName = params.pqtlName
  self.actionInstanceId = Game.PlotStoryManager:Start_PQTLP(pqtlName, self.OnPlotStoryEnd, self, nil, false, nil, {
    myself = creature.data.id
  }, false)
end

function IdleAI_PartnerPerform:OnPlotStoryEnd(result)
  if result and self.endCall then
    self.endCall(self.endCallParam)
    self.endCall = nil
  end
  self.actionInstanceId = nil
end

function IdleAI_PartnerPerform:StopEmoji(creature)
  if not creature then
    return
  end
  local sceneUI = creature:GetSceneUI()
  if sceneUI then
    sceneUI.roleTopUI:DestroySpine()
  end
end

function IdleAI_PartnerPerform:StopDialog(creature)
end

function IdleAI_PartnerPerform:StopAudio(creature)
end

function IdleAI_PartnerPerform:StopPlotStory(creature)
  if self.actionInstanceId then
    Game.PlotStoryManager:StopFreeProgress(self.actionInstanceId, true)
  end
end
