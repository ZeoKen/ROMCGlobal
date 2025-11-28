autoImport("AIAlert")
autoImport("AIAlertPatrol")
autoImport("AIDoubt")
autoImport("AILethargy")
autoImport("AIPatrol")
autoImport("AIStand")
autoImport("AIShooting")
autoImport("AIVertigo")
autoImport("AIMoveToVertigoNpc")
autoImport("AIMoveToLightUpPosition")
autoImport("AIMoveToDog")
autoImport("AIMoveToNewBirth")
autoImport("AIDead")
autoImport("AIEmpty")
autoImport("AIDoubtStand")
autoImport("AIDoubtMoveTo")
autoImport("AIVisit")
AIStateMachine = class("AIStateMachine")

function AIStateMachine:ctor(aiNpc)
  self.m_curState = nil
  self.m_lastState = nil
  self.m_allStates = {}
  self.m_stateQueue = {}
  self.m_curIndex = 1
  self:addState(AIAlert.new(aiNpc))
  self:addState(AIAlertPatrol.new(aiNpc))
  self:addState(AIDoubt.new(aiNpc))
  self:addState(AIVertigo.new(aiNpc))
  self:addState(AIMoveToLightUpPosition.new(aiNpc))
  self:addState(AIMoveToVertigoNpc.new(aiNpc))
  self:addState(AIMoveToDog.new(aiNpc))
  self:addState(AIStand.new(aiNpc))
  self:addState(AIPatrol.new(aiNpc))
  self:addState(AILethargy.new(aiNpc))
  self:addState(AIShooting.new(aiNpc))
  self:addState(AIMoveToNewBirth.new(aiNpc))
  self:addState(AIDead.new(aiNpc))
  self:addState(AIEmpty.new(aiNpc))
  self:addState(AIDoubtStand.new(aiNpc))
  self:addState(AIDoubtMoveTo.new(aiNpc))
  self:addState(AIVisit.new(aiNpc))
end

function AIStateMachine:addState(aiState)
  self.m_allStates[aiState:getType()] = aiState
end

function AIStateMachine:addStateInQueue(type, time)
  table.insert(self.m_stateQueue, {type, time})
end

function AIStateMachine:clearQueue()
  self.m_stateQueue = {}
end

function AIStateMachine:queueIsLoop(value)
  self.m_isLoop = value
end

function AIStateMachine:resetQueue()
  self.m_curIndex = 1
end

function AIStateMachine:switchByType(type, ...)
  self.m_runing = true
  local newState = self.m_allStates[type]
  if self.m_curState ~= nil then
    self.m_curState:onExit()
  end
  self.m_curState = newState
  if self.m_curState ~= nil then
    self.m_curState:onEnter(...)
  end
end

function AIStateMachine:switchNext()
  self.m_runing = true
  local count = #self.m_stateQueue
  if count < 1 then
    self:switchByType(AIBehaviourType.eEmpty)
  elseif self.m_isLoop then
    local stateInfo = self.m_stateQueue[self.m_curIndex]
    local nextType = stateInfo[1]
    local time = stateInfo[2]
    self:switchByType(nextType, time)
    self.m_curIndex = self.m_curIndex + 1
    if count < self.m_curIndex then
      self.m_curIndex = 1
    end
  elseif count >= self.m_curIndex then
    local stateInfo = self.m_stateQueue[self.m_curIndex]
    local nextType = stateInfo[1]
    local time = stateInfo[2]
    self:switchByType(nextType, time)
    self.m_curIndex = self.m_curIndex + 1
  elseif not self:isType(AIBehaviourType.eEmpty) then
    self:switchByType(AIBehaviourType.eEmpty)
  end
end

function AIStateMachine:breakSwitch(type, ...)
  self.m_runing = true
  local newState = self.m_allStates[type]
  if self.m_curState ~= nil then
    if self.m_lastState == nil then
      self.m_curState:onBreakExit()
    elseif self.m_lastState:getType() ~= type then
      self.m_curState:onExit()
    end
  end
  if self.m_lastState == nil then
    self.m_lastState = self.m_curState
  end
  self.m_curState = newState
  if self.m_curState ~= nil then
    self.m_curState:onEnter(...)
  end
end

function AIStateMachine:switchLastState()
  self.m_runing = true
  if self.m_lastState == nil then
    self:switchNext()
  else
    if self.m_curState ~= nil then
      self.m_curState:onExit()
    end
    self.m_curState = self.m_lastState
    if self.m_curState ~= nil then
      self.m_curState:onReEnter()
    end
    self.m_lastState = nil
  end
end

function AIStateMachine:onDestroy()
  if self.m_curState ~= nil then
    self.m_curState:onExit()
  end
  self.m_curState = nil
  self.m_runing = false
  for i = #self.m_allStates, 1, -1 do
    self.m_allStates[i] = nil
    table.remove(self.m_allStates, i)
  end
  self.m_allStates = {}
end

function AIStateMachine:getCurState()
  return self.m_curState
end

function AIStateMachine:getLastState()
  return self.m_lastState
end

function AIStateMachine:onUpdate(deltaTime)
  if not self.m_runing then
    return
  end
  if self.m_curState ~= nil then
    self.m_curState:onUpdate(deltaTime)
  end
end

function AIStateMachine:isType(type)
  if self.m_curState == nil then
    return false
  end
  return self.m_curState:getType() == type
end
