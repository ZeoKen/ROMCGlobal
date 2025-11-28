autoImport("AIBaseBehaviour")
AILethargy = class("AILethargy", AIBaseBehaviour)

function AILethargy:ctor(aiNpc)
  AILethargy.super.ctor(self, aiNpc)
end

function AILethargy:getType()
  return AIBehaviourType.eLethargy
end

function AILethargy:onEnter(...)
  AILethargy.super.onEnter(self, ...)
  self.m_stayTime = (...)
  self.m_isPlaying = false
  self.m_ai:playAction("state1001")
  self.m_curPlayPlotId = "3032"
  self.m_sleepPlotId = Game.PlotStoryManager:Start_PQTLP("3032", self.onPlotStoryEnd, self, nil, false, nil, {
    myself = self.m_ai:getUid()
  }, false)
  local data = self.m_ai:getHistoryStateData()
  if data ~= nil then
    if tonumber(data.m_type) == self:getType() then
      self.m_curTime = tonumber(data.m_currentTime)
    end
    self.m_ai:setHistoryStateData(nil)
  end
  self.m_ai:disableDialog()
  self.m_isBreak = false
end

function AILethargy:onPlotStoryEnd(result)
  if self.m_isBreak then
    return
  end
  if self.m_sleepPlotId ~= nil then
    self.m_sleepPlotId = nil
  end
  if self.m_plotId ~= nil then
    self.m_ai:getStateMachine():switchNext()
    self.m_plotId = nil
  end
end

function AILethargy:onBreakExit()
  if self.m_plotId ~= nil then
    self.m_isBreak = true
    if self.m_sleepPlotId ~= nil then
      Game.PlotStoryManager:StopFreeProgress(self.m_sleepPlotId, true)
      self.m_sleepPlotId = nil
    end
    if self.m_plotId ~= nil then
      Game.PlotStoryManager:StopFreeProgress(self.m_plotId, true)
      self.m_plotId = nil
    end
  end
  self.m_ai:enabledDialog()
end

function AILethargy:onReEnter()
  if self.m_isBreak then
    if self.m_curPlayPlotId == "3032" then
      self.m_sleepPlotId = Game.PlotStoryManager:Start_PQTLP("3032", self.onPlotStoryEnd, self, nil, false, nil, {
        myself = self.m_ai:getUid()
      }, false)
    else
      self.m_plotId = Game.PlotStoryManager:Start_PQTLP("3033", self.onPlotStoryEnd, self, nil, false, nil, {
        myself = self.m_ai:getUid()
      }, false)
    end
  end
  self.m_ai:disableDialog()
end

function AILethargy:onExit()
  AILethargy.super.onExit(self)
  self.m_ai:enabledDialog()
  if self.m_plotId ~= nil then
    Game.PlotStoryManager:StopFreeProgress(self.m_plotId, true)
    self.m_plotId = nil
  end
end

function AILethargy:logicUpdate(deltaTime)
  self.m_curTime = self.m_curTime + deltaTime
  if self.m_curTime >= self.m_stayTime and not self.m_isPlaying then
    if self.m_sleepPlotId ~= nil then
      Game.PlotStoryManager:StopFreeProgress(self.m_sleepPlotId, true)
      self.m_sleepPlotId = nil
    end
    self.m_curPlayPlotId = "3033"
    self.m_plotId = Game.PlotStoryManager:Start_PQTLP("3033", self.onPlotStoryEnd, self, nil, false, nil, {
      myself = self.m_ai:getUid()
    }, false)
    self.m_isPlaying = true
  end
end

function AILethargy:getData()
  self.m_data.m_type = self:getType()
  self.m_data.m_currentTime = self.m_curTime
  return self.m_data
end
