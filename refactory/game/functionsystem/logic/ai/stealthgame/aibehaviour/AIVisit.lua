autoImport("AIBaseBehaviour")
AIVisit = class("AIVisit", AIBaseBehaviour)

function AIVisit:ctor(aiNpc)
  AIVisit.super.ctor(self, aiNpc)
end

function AIVisit:getType()
  return AIBehaviourType.eVisit
end

function AIVisit:onEnter(...)
  AIVisit.super.onEnter(self, ...)
  self.m_lastAngle = self.m_ai.m_creature:GetAngleY()
  self.m_ai:endMove(true)
end

function AIVisit:onExit()
  self.m_ai:setAngleY(self.m_lastAngle)
  AIVisit.super.onExit(self)
end

function AIVisit:getData()
  self.m_data.m_type = self:getType()
  return self.m_data
end
