autoImport("AIBaseBehaviour")
AIShooting = class("AIShooting", AIBaseBehaviour)

function AIShooting:ctor(aiNpc)
  AIShooting.super.ctor(self, aiNpc)
end

function AIShooting:getType()
  return AIBehaviourType.eShooting
end

function AIShooting:onEnter(...)
  AIShooting.super.onEnter(self, ...)
  self.m_stayTime = (...)
  Game.PlotStoryManager:Start_PQTLP("3039", nil, nil, nil, false, nil, {
    myself = self.m_ai:getUid()
  }, false)
  local data = self.m_ai:getHistoryStateData()
  if data ~= nil then
    if tonumber(data.m_type) == self:getType() then
      self.m_curTime = tonumber(data.m_currentTime)
    end
    self.m_ai:setHistoryStateData(nil)
  end
end

function AIShooting:onBreakExit()
end

function AIShooting:onReEnter()
end

function AIShooting:onExit()
  AIShooting.super.onExit(self)
end

function AIShooting:logicUpdate(deltaTime)
  self.m_curTime = self.m_curTime + deltaTime
  if self.m_curTime >= self.m_stayTime then
    self.m_ai:getStateMachine():switchNext()
  end
end

function AIShooting:getData()
  self.m_data.m_type = self:getType()
  self.m_data.m_currentTime = self.m_curTime
  return self.m_data
end
