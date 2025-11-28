autoImport("AIBaseBehaviour")
AIEmpty = class("AIEmpty", AIBaseBehaviour)

function AIEmpty:ctor(aiNpc)
  AIEmpty.super.ctor(self, aiNpc)
end

function AIEmpty:getType()
  return AIBehaviourType.eEmpty
end

function AIEmpty:onEnter(...)
  AIEmpty.super.onEnter(self, ...)
end

function AIEmpty:getData()
  self.m_data.m_type = self:getType()
  return self.m_data
end
