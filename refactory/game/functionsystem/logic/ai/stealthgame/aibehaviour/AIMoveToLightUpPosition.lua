autoImport("AIBaseBehaviour")
AIMoveToLightUpPosition = class("AIMoveToLightUpPosition", AIBaseBehaviour)

function AIMoveToLightUpPosition:ctor(aiNpc)
  AIMoveToLightUpPosition.super.ctor(self, aiNpc)
  self.m_state = -1
end

function AIMoveToLightUpPosition:getType()
  return AIBehaviourType.eMoveToLightUp
end

function AIMoveToLightUpPosition:onEnter(...)
  AIMoveToLightUpPosition.super.onEnter(self, ...)
  math.randomseed(tostring(os.time()):reverse():sub(1, 6))
  self.m_stayTime = math.random() + math.random(3, 6)
  self.m_state = 0
  local data = self.m_ai:getHistoryStateData()
  if data ~= nil then
    if tonumber(data.m_type) == self:getType() then
      self.m_curTime = tonumber(data.m_currentTime)
    end
    self.m_ai:setHistoryStateData(nil)
    self.m_triggerId = data.m_triggerId
    self.m_state = data.m_state
  elseif SgAIManager.Me():getCurTrigger() ~= nil then
    self.m_triggerId = SgAIManager.Me():getCurTrigger():getUid()
  end
  local playEnd = function()
    local trigger = SgAIManager.Me():findTrigger(self.m_triggerId)
    if trigger ~= nil then
      local flag, x, y, z, _ = trigger.m_objTrigger:GetBirthPostion()
      self.m_targetPosition = {
        x,
        y,
        z
      }
      self.m_ai:beginMoveTo(self.m_targetPosition, "walk2", false, self.moveEnd, self)
    end
  end
  Game.PlotStoryManager:Start_PQTLP("3031", playEnd, nil, nil, false, nil, {
    myself = self.m_ai:getUid()
  }, false)
end

function AIMoveToLightUpPosition:onBreakExit()
  self.m_ai:endMove(true)
end

function AIMoveToLightUpPosition:onReEnter()
  if self.m_state == 2 then
    self.m_ai:beginMoveTo(self.m_targetPosition, "walk", false, self.moveEnd, self)
  else
    self.m_ai:beginMoveTo(self.m_targetPosition, "walk2", false, self.moveEnd, self)
  end
end

function AIMoveToLightUpPosition:onExit()
  AIMoveToLightUpPosition.super.onExit(self)
  self.m_ai:endMove(true)
end

function AIMoveToLightUpPosition:moveEnd()
  if 0 == self.m_state then
    local playEnd = function(ret)
      self.m_ai:getLightUpTrigger():closeMachine()
      self.m_state = 1
    end
    Game.PlotStoryManager:Start_PQTLP("3052", playEnd, nil, nil, false, nil, {
      myself = self.m_ai:getUid()
    }, false)
  elseif 2 == self.m_state then
    self.m_ai:setAngleY(self.m_ai:getBirthAngleY())
    self.m_ai:getStateMachine():switchLastState()
  end
end

function AIMoveToLightUpPosition:logicUpdate(deltaTime)
  if 1 == self.m_state then
    self.m_curTime = self.m_curTime + deltaTime
    if self.m_curTime >= self.m_stayTime then
      self.m_targetPosition = self.m_ai:getBirthPosition()
      self.m_ai:beginMoveTo(self.m_targetPosition, "walk", true, self.moveEnd, self)
      self.m_state = 2
    end
  end
end

function AIMoveToLightUpPosition:getData()
  self.m_data.m_type = self:getType()
  self.m_data.m_triggerId = self.m_triggerId
  self.m_data.m_state = self.m_state
  return self.m_data
end
