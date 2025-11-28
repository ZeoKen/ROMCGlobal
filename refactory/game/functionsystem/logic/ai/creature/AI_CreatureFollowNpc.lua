autoImport("ParallelAIManager")
AI_CreatureFollowNpc = class("AI_CreatureFollowNpc", AI_Creature)
local RunningState = {
  DISABLE = 0,
  NORMAL = 1,
  CONDITION = 2,
  VISIT = 3,
  HIGHEST = 4
}
local InterruptType = {FOLLOW = 1, PERFORM = 2}

function AI_CreatureFollowNpc:ctor()
  self.parallelAIManager = ParallelAIManager.new()
  self.conditionEventList = {}
  self.runningState = RunningState.DISABLE
  AI_CreatureFollowNpc.super.ctor(self)
end

function AI_CreatureFollowNpc:_InitIdleAI(idleAIManager)
  redlog("AI_CreatureFollowNpc:_InitIdleAI")
  local idleAI_PartnerPerform = IdleAI_PartnerPerform.new()
  self.parallelAIManager:PushAI(idleAI_PartnerPerform)
  local idleAI_WalkFollow = IdleAI_WalkFollow.new()
  idleAIManager:PushAI(idleAI_WalkFollow)
  self.runningState = RunningState.NORMAL
end

function AI_CreatureFollowNpc:_DoUpdate(time, deltaTime, creature)
  if self.fromState ~= self.runningState then
    if self.runningState == RunningState.HIGHEST then
      local eventId = self.currentEvent
      local config = Table_FollowNpcEvent[eventId]
      if config then
        if config.interruptType == InterruptType.PERFORM then
          local endCall
          if not config.isLoop or config.isLoop == 0 then
            function endCall(self)
              if self.inCondition then
                if self.runningState > RunningState.CONDITION then
                  self:BackToConditionState()
                end
              else
                self:BackToNormalState()
              end
            end
          end
          self.parallelAIManager:Interrupt(eventId, creature, endCall, self)
          self.followBreak = false
        elseif config.interruptType == InterruptType.FOLLOW then
          self:PlayPlotStory(eventId, creature)
          self.followBreak = true
        end
      end
    elseif self.runningState == RunningState.VISIT then
      local config = Table_FollowNpcEvent[self.lastEvent]
      if config and config.interruptType == InterruptType.PERFORM then
        self.parallelAIManager:Pause(creature)
      end
      self.followBreak = true
    elseif self.runningState == RunningState.CONDITION then
      if not self.inCondition then
        local config = Table_FollowNpcEvent[self.currentEvent]
        if config then
          if config.interruptType == InterruptType.PERFORM then
            self.parallelAIManager:Resume(creature)
          elseif config.interruptType == InterruptType.FOLLOW then
            self:StopPlotStory()
          end
          self:BackToNormalState()
          self.followBreak = false
        end
      else
        local eventId = self.currentEvent
        local config = Table_FollowNpcEvent[eventId]
        if config then
          if config.interruptType == InterruptType.PERFORM then
            local endCall
            if not config.isLoop or config.isLoop == 0 then
              function endCall(self)
                if not self.inCondition then
                  self:BackToNormalState()
                end
              end
            end
            self.parallelAIManager:Interrupt(eventId, creature, endCall, self)
            self.followBreak = false
          elseif config.interruptType == InterruptType.FOLLOW then
            self:PlayPlotStory(eventId, creature)
            self.followBreak = true
          end
        end
      end
    elseif self.runningState == RunningState.NORMAL then
      local config = Table_FollowNpcEvent[self.lastEvent]
      if config then
        if config.interruptType == InterruptType.PERFORM then
          self.parallelAIManager:Resume(creature)
        elseif config.interruptType == InterruptType.FOLLOW then
          self:StopPlotStory()
        end
      end
      self.followBreak = false
    end
    self.fromState = self.runningState
  end
  AI_CreatureFollowNpc.super._TryExecuteCommands(self, time, deltaTime, creature)
  if self.runningState == RunningState.NORMAL then
    AI_Creature.super._Idle(self, time, deltaTime, creature)
  elseif self.followBreak then
    AI_Creature.super._IdleBreak(self, time, deltaTime, creature)
  else
    AI_Creature.super._Idle(self, time, deltaTime, creature)
  end
  AI_Creature.super._DoUpdate(self, time, deltaTime, creature)
  self.parallelAIManager:Update(self.idleElapsed, time, deltaTime, creature)
end

function AI_CreatureFollowNpc:AddEvent(eventId)
  self.conditionEventList[#self.conditionEventList + 1] = eventId
end

function AI_CreatureFollowNpc:RemoveEvent(eventId)
  TableUtility.ArrayRemove(self.conditionEventList, eventId)
  if self.inCondition and (eventId == self.currentEvent or eventId == self.conditionEvent) then
    self.conditionEvent = nil
    self.inCondition = false
    if self.runningState == RunningState.CONDITION then
      self:BackToNormalState()
    end
  end
end

function AI_CreatureFollowNpc:ExecuteEventDirectly(eventId)
  self:TransitState(self.runningState, RunningState.HIGHEST, eventId)
end

function AI_CreatureFollowNpc:PlayPlotStory(eventId, creature)
  if not creature then
    return
  end
  local config = Table_FollowNpcEvent[eventId]
  if not config then
    return
  end
  local params = config.params
  local pqtlName = params.pqtlName
  local isLoop = config.isLoop == 1 and true or false
  redlog("AI_CreatureFollowNpc:PlayPlotStory", tostring(eventId), tostring(pqtlName), tostring(isLoop))
  if pqtlName then
    self.actionInstanceId = Game.PlotStoryManager:Start_PQTLP(pqtlName, self.OnPlotStoryEnd, self, nil, false, nil, {
      myself = creature.data.id
    }, isLoop)
  end
end

function AI_CreatureFollowNpc:OnPlotStoryEnd(result)
  if result then
    if self.inCondition then
      if self.runningState > RunningState.CONDITION then
        self:BackToConditionState()
      end
    else
      self:BackToNormalState()
    end
  end
  self.actionInstanceId = nil
end

function AI_CreatureFollowNpc:StopPlotStory()
  if self.actionInstanceId then
    redlog("AI_CreatureFollowNpc:StopPlotStory")
    Game.PlotStoryManager:StopFreeProgress(self.actionInstanceId, true)
  end
end

function AI_CreatureFollowNpc:SwitchState(state)
  self.runningState = state
end

function AI_CreatureFollowNpc:TransitState(from, to, eventId)
  self.fromState = from
  self:SwitchState(to)
  self.lastEvent = self.currentEvent
  self.currentEvent = eventId
end

function AI_CreatureFollowNpc:BackToNormalState()
  self:TransitState(self.runningState, RunningState.NORMAL)
end

function AI_CreatureFollowNpc:BackToConditionState()
  local eventId = self.conditionEvent
  self:TransitState(self.runningState, RunningState.CONDITION, eventId)
end

function AI_CreatureFollowNpc:OnConditionEnter(triggerId)
  if self.inCondition then
    return
  end
  if self.runningState == RunningState.CONDITION then
    return
  end
  for i = 1, #self.conditionEventList do
    local eventId = self.conditionEventList[i]
    local config = Table_FollowNpcEvent[eventId]
    if config and config.condition and config.condition.id == triggerId then
      if self.runningState < RunningState.CONDITION then
        self:TransitState(self.runningState, RunningState.CONDITION, eventId)
      end
      self.conditionEvent = eventId
      self.inCondition = true
      break
    end
  end
end

function AI_CreatureFollowNpc:OnConditionLeave(triggerId)
  if not self.inCondition then
    return
  end
  if self.runningState == RunningState.CONDITION then
    local config = Table_FollowNpcEvent[self.currentEvent]
    if config and config.condition and config.condition.id == triggerId then
      self.conditionEvent = nil
      self.inCondition = false
      self:BackToNormalState()
    end
  else
    local config = Table_FollowNpcEvent[self.conditionEvent]
    if config and config.condition and config.condition.id == triggerId then
      self.conditionEvent = nil
      self.inCondition = false
    end
  end
end

function AI_CreatureFollowNpc:OnConditionTrigger(triggerId)
  if self.inCondition then
    return
  end
  if self.runningState == RunningState.CONDITION then
    return
  end
  for i = 1, #self.conditionEventList do
    local eventId = self.conditionEventList[i]
    local config = Table_FollowNpcEvent[eventId]
    if config and config.condition and config.condition.id == triggerId then
      if self.runningState < RunningState.CONDITION then
        self:TransitState(self.runningState, RunningState.CONDITION, eventId)
      end
      self.conditionEvent = eventId
      break
    end
  end
end

function AI_CreatureFollowNpc:OnVisitNpc()
  if self.runningState < RunningState.VISIT then
    self:TransitState(self.runningState, RunningState.VISIT)
  end
end

function AI_CreatureFollowNpc:OnVisitNpcEnd()
  if self.runningState == RunningState.VISIT then
    if self.inCondition then
      self:BackToConditionState()
    else
      self:BackToNormalState()
    end
  end
end

function AI_CreatureFollowNpc:_Clear(time, deltaTime, creature)
  AI_CreatureFollowNpc.super._Clear(self, time, deltaTime, creature)
  self.parallelAIManager:Clear(self.idleElapsed, time, deltaTime, creature)
  TableUtility.ArrayClear(self.conditionEventList)
  self.runningState = RunningState.DISABLE
  self.fromState = nil
  self.inCondition = nil
end
