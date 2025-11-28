autoImport("AIBaseBehaviour")
AIDoubtStand = class("AIDoubtStand", AIBaseBehaviour)

function AIDoubtStand:ctor(aiNpc)
  AIDoubtStand.super.ctor(self, aiNpc)
  self.m_stayTime = 3
end

function AIDoubtStand:getType()
  return AIBehaviourType.eDoubtStand
end

function AIDoubtStand:onEnter(...)
  AIDoubtStand.super.onEnter(self, ...)
  self.m_stayTime = (...)
  local data = self.m_ai:getHistoryStateData()
  if data ~= nil then
    if tonumber(data.m_type) == self:getType() then
      self.m_curTime = tonumber(data.m_currentTime)
      self.m_lastAngle = data.m_lastAngle
    end
    self.m_ai:setHistoryStateData(nil)
  else
    self.m_curTime = 0
    self.m_lastAngle = self.m_ai.m_creature:GetAngleY()
  end
  self.m_lastAngle = self.m_ai.m_creature:GetAngleY()
  self.m_ai:lookAtTrigger()
  self.m_isBreak = false
  if self.m_plotId == nil then
    self.m_plotId = Game.PlotStoryManager:Start_PQTLP("3030", self.onPlayEnd, self, nil, false, nil, {
      myself = self.m_ai:getUid()
    }, false)
  end
end

function AIDoubtStand:onPlayEnd(ret)
  if self.m_isBreak then
    return
  end
  self.m_plotId = nil
  self.m_ai:getStateMachine():switchLastState()
end

function AIDoubtStand:onBreakExit()
  if self.m_plotId ~= nil then
    self.m_isBreak = true
    Game.PlotStoryManager:StopFreeProgress(self.m_plotId, true)
    self.m_plotId = nil
  end
  self.m_ai:setAngleY(self.m_lastAngle)
end

function AIDoubtStand:onReEnter()
  if self.m_isBreak then
    self.m_plotId = Game.PlotStoryManager:Start_PQTLP("3030", self.onPlayEnd, self, nil, false, nil, {
      myself = self.m_ai:getUid()
    }, false)
  end
end

function AIDoubtStand:onExit()
  AIDoubtStand.super.onExit(self)
  self.m_curTime = 0
  self.m_ai:setAngleY(self.m_lastAngle)
  if self.m_plotId ~= nil then
    self.m_isBreak = true
    Game.PlotStoryManager:StopFreeProgress(self.m_plotId, true)
    self.m_plotId = nil
  end
end

function AIDoubtStand:logicUpdate(deltaTime)
end

function AIDoubtStand:getData()
  self.m_data.m_type = self:getType()
  self.m_data.m_currentTime = self.m_curTime
  self.m_data.m_lastAngle = self.m_lastAngle
  return self.m_data
end
