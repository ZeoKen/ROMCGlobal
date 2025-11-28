autoImport("AIBaseBehaviour")
AIAlert = class("AIAlert", AIBaseBehaviour)

function AIAlert:ctor(aiNpc)
  AIAlert.super.ctor(self, aiNpc)
  self.m_maxValue = 10
  self.m_value = 0
  self.m_addSpeed = aiNpc:getAiAlertAddSpeed()
  self.m_reduceSpeed = aiNpc:getAiAlertReduceSpeed()
end

function AIAlert:getType()
  return AIBehaviourType.eAlert
end

function AIAlert:onEnter(...)
  AIAlert.super.onEnter(self, ...)
  local data = self.m_ai:getHistoryStateData()
  if data ~= nil then
    if tonumber(data.m_type) == self:getType() then
      self.m_value = tonumber(data.m_alertValue)
    end
    self.m_ai:setHistoryStateData(nil)
  end
  self.m_ai:onLookAtPlayer()
  self.m_isBreak = false
  if self.m_ai:isFindPlayer() then
    self.m_plotId = Game.PlotStoryManager:Start_PQTLP("11097", self.onPlotStoryEnd, self, nil, false, nil, {
      myself = self.m_ai:getUid()
    }, false)
  else
    self.m_plotId = Game.PlotStoryManager:Start_PQTLP("11099", self.onPlotStoryEnd, self, nil, false, nil, {
      myself = self.m_ai:getUid()
    }, false)
  end
  self.m_ai:showAlertUI()
  self.m_ai:disableDialog()
  self.m_lastState = self.m_ai:getStateMachine():getLastState()
  self.m_smellAlertTime = 0
end

function AIAlert:onPlotStoryEnd(result)
  if self.m_isBreak then
    return
  end
  self.m_plotId = nil
end

function AIAlert:onBreakExit()
  if self.m_plotId ~= nil then
    self.m_isBreak = true
    Game.PlotStoryManager:StopFreeProgress(self.m_plotId, true)
    self.m_plotId = nil
  end
  self.m_ai:hideAlertUI()
  self.m_ai:enabledDialog()
  self.m_lastState = nil
  self.m_smellAlertTime = 0
end

function AIAlert:onReEnter()
  if self.m_isBreak then
    self.m_isBreak = false
    if self.m_ai:isFindPlayer() then
      self.m_plotId = Game.PlotStoryManager:Start_PQTLP("11097", self.onPlotStoryEnd, self, nil, false, nil, {
        myself = self.m_ai:getUid()
      }, false)
    else
      self.m_plotId = Game.PlotStoryManager:Start_PQTLP("11099", self.onPlotStoryEnd, self, nil, false, nil, {
        myself = self.m_ai:getUid()
      }, false)
    end
  end
  self.m_ai:showAlertUI()
  self.m_ai:disableDialog()
  self.m_lastState = self.m_ai:getStateMachine():getLastState()
  self.m_smellAlertTime = 0
end

function AIAlert:onExit()
  AIAlert.super.onExit(self)
  if self.m_value > self.m_maxValue then
    self.m_value = self.m_maxValue
  end
  if self.m_value < 0 then
    self.m_value = 0
  end
  self.m_ai:hideAlertUI()
  self.m_ai:enabledDialog()
  self.m_lastState = nil
  self.m_smellAlertTime = 0
end

function AIAlert:logicUpdate(deltaTime)
  local r = (self.m_ai:getVisionRadius() - math.abs(LuaVector3.Distance(Game.Myself:GetPosition(), self.m_ai:getPosition()))) * 0.3 + 0.5
  if self.m_ai:isFindPlayer() then
    if self.m_ai:isHasAlertPatrolState() then
      self.m_value = self.m_value + self.m_addSpeed * r * deltaTime
      self.m_ai:onLookAtPlayer()
    elseif self.m_smellAlertTime > 0 then
      self.m_smellAlertTime = self.m_smellAlertTime - deltaTime
    elseif self.m_smellAlertTime < 0 then
      self.m_value = self.m_value - self.m_reduceSpeed * deltaTime
      if self.m_value < 0 then
        self.m_value = 0
      end
    else
      self.m_value = self.m_value + self.m_addSpeed * r * deltaTime
      self.m_ai:onLookAtPlayer()
    end
  else
    self.m_value = self.m_value - self.m_reduceSpeed * deltaTime
    if self.m_value < 0 then
      self.m_value = 0
      self.m_smellAlertTime = 0
    end
  end
  if self.m_value >= self.m_maxValue then
    self.m_value = self.m_maxValue
    if self.m_ai:isHasAlertPatrolState() then
      self.m_ai:getStateMachine():switchByType(AIBehaviourType.eAlertPatrol)
    elseif self.m_smellAlertTime == 0 then
      self.m_smellAlertTime = 3
    end
  end
  if self.m_value >= 0 and self.m_value <= self.m_maxValue then
    self.m_ai:updateAlertValue(false, self.m_value / self.m_maxValue)
  end
  if self.m_value <= 0 then
    self.m_ai:getStateMachine():switchLastState()
  end
end

function AIAlert:getCurValue()
  return self.m_value / self.m_maxValue
end

function AIAlert:getData()
  self.m_data.m_type = self:getType()
  self.m_data.m_alertValue = self.m_value
  return self.m_data
end
