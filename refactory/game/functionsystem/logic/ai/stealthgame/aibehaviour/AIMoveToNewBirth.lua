autoImport("AIBaseBehaviour")
AIMoveToNewBirth = class("AIMoveToNewBirth", AIBaseBehaviour)

function AIMoveToNewBirth:ctor(aiNpc)
  AIMoveToNewBirth.super.ctor(self, aiNpc)
end

function AIMoveToNewBirth:getType()
  return AIBehaviourType.eMoveToNewBirth
end

function AIMoveToNewBirth:onEnter(...)
  AIMoveToNewBirth.super.onEnter(self, ...)
  self.m_targetPosition = self.m_ai:getBirthPosition()
  self.m_ai:beginMoveTo(self.m_targetPosition, "walk", true, self.moveEnd, self)
end

function AIMoveToNewBirth:onBreakExit()
  self.m_ai:endMove(true)
end

function AIMoveToNewBirth:onReEnter()
  self.m_ai:beginMoveTo(self.m_targetPosition, "walk", true, self.moveEnd, self)
end

function AIMoveToNewBirth:onExit()
  AIMoveToNewBirth.super.onExit(self)
  self.m_ai:endMove(true)
end

function AIMoveToNewBirth:moveEnd()
  self.m_ai:setStateQueue(1)
  self.m_ai:setAngleY(self.m_ai:getBirthAngleY())
  self.m_ai:getStateMachine():switchNext()
end

function AIMoveToNewBirth:logicUpdate(deltaTime)
end

function AIMoveToNewBirth:getData()
  self.m_data.m_type = self:getType()
  return self.m_data
end
