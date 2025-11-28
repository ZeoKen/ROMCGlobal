autoImport("AIBaseBehaviour")
AIVertigo = class("AIVertigo", AIBaseBehaviour)

function AIVertigo:ctor(aiNpc)
  AIVertigo.super.ctor(self, aiNpc)
end

function AIVertigo:getType()
  return AIBehaviourType.eVertigo
end

function AIVertigo:onEnter(...)
  AIVertigo.super.onEnter(self, ...)
  self.m_stayTime = SgAIManager.Me():vertigoTime()
  self.m_isPlaying = false
  self.m_ai:playAction("state1001")
  self.m_plotId = Game.PlotStoryManager:Start_PQTLP("3032", self.onPlotStoryEnd, self, nil, false, nil, {
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

function AIVertigo:onBreakExit()
end

function AIVertigo:onReEnter()
end

function AIVertigo:onExit()
  AIVertigo.super.onExit(self)
  self.m_ai:playAction("state2001")
  if self.m_plotId ~= nil then
    Game.PlotStoryManager:StopFreeProgress(self.m_plotId, true)
  end
end

function AIVertigo:onPlotStoryEnd(result)
  self.m_plotId = nil
end

function AIVertigo:logicUpdate(deltaTime)
  self.m_curTime = self.m_curTime + deltaTime
  if self.m_curTime >= self.m_stayTime then
    self.m_ai:getStateMachine():switchLastState()
  end
  self:showLog(self.m_curTime / self.m_stayTime)
end

function AIVertigo:getData()
  self.m_data.m_type = self:getType()
  self.m_data.m_currentTime = self.m_curTime
  return self.m_data
end
