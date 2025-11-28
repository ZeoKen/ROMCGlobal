autoImport("AIBaseBehaviour")
AIPatrol = class("AIPatrol", AIBaseBehaviour)

function AIPatrol:ctor(aiNpc)
  AIPatrol.super.ctor(self, aiNpc)
end

function AIPatrol:getType()
  return AIBehaviourType.ePatrol
end

function AIPatrol:onEnter(...)
  AIPatrol.super.onEnter(self, ...)
  self.m_endPos, self.m_endAngle = self.m_ai:getPatrolPosition()
  self.m_state = 0
  if self.m_ai:isCanMove(self.m_endPos) then
    self.m_ai:beginMoveTo(self.m_endPos, "walk", true, self.arrive, self)
  else
    self.m_curTime = 0
    self.m_state = 9
    self.m_ai:setAngleY(self.m_endAngle)
  end
  self.m_autoSpeakInterval = self.m_ai:getAutoSpeakInterval()
  self.m_autoSpeakTime = 0
  if self.m_autoSpeakInterval ~= nil then
    self.m_ai:autoSpeak()
  end
end

function AIPatrol:onBreakExit()
  self.m_ai:endMove(true)
end

function AIPatrol:onReEnter()
  self.m_state = 0
  self.m_curTime = 0
  self.m_ai:beginMoveTo(self.m_endPos, "walk", true, self.arrive, self)
end

function AIPatrol:onExit()
  AIPatrol.super.onExit(self)
  self.m_ai:endMove(true)
  self.m_ai:setAngleY(self.m_endAngle)
end

function AIPatrol:logicUpdate(deltaTime)
  if self.m_autoSpeakInterval ~= nil and self.m_autoSpeakTime ~= nil then
    self.m_autoSpeakTime = self.m_autoSpeakTime + deltaTime
    if self.m_autoSpeakTime >= self.m_autoSpeakInterval then
      self.m_ai:autoSpeak()
      self.m_autoSpeakTime = 0
    end
  end
  if self.m_state == 9 then
    self.m_curTime = self.m_curTime + deltaTime
    if self.m_curTime > 0.5 then
      self.m_ai:getStateMachine():switchNext()
    end
  end
end

function AIPatrol:arrive()
  self:showLog("arrive")
  self.m_ai:getStateMachine():switchNext()
  if self.m_ai:getStateMachine():getCurState():getType() ~= self:getType() then
    self.m_ai:setAngleY(self.m_endAngle)
  end
end

function AIPatrol:getData()
  self.m_data.m_type = self:getType()
  return self.m_data
end
