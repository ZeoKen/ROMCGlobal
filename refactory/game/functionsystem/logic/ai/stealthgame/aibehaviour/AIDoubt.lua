autoImport("AIBaseBehaviour")
AIDoubt = class("AIDoubt", AIBaseBehaviour)

function AIDoubt:ctor(aiNpc)
  AIDoubt.super.ctor(self, aiNpc)
  self.m_isLookAtTarget = aiNpc:doubtIslookAtTarget()
end

function AIDoubt:getType()
  return AIBehaviourType.eDoubt
end

function AIDoubt:onEnter(...)
  AIDoubt.super.onEnter(self, ...)
  self.m_stayTime = (...)
end

function AIDoubt:onBreakExit()
end

function AIDoubt:onReEnter()
end

function AIDoubt:onExit()
  AIDoubt.super.onExit(self)
end

function AIDoubt:logicUpdate(deltaTime)
end

function AIDoubt:getData()
  self.m_data.m_type = self:getType()
  return self.m_data
end
