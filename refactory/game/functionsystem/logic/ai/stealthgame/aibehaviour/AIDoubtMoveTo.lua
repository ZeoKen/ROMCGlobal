autoImport("AIBaseBehaviour")
AIDoubtMoveTo = class("AIDoubtMoveTo", AIBaseBehaviour)

function AIDoubtMoveTo:ctor(aiNpc)
  AIDoubtMoveTo.super.ctor(self, aiNpc)
  self.m_stayTime = 3
  self.m_radius = aiNpc:getAiAlertPatrolRadius()
  self.m_totalCount = aiNpc:getAiAlertPatrolTotalTimes()
  self.m_patrolTime = 0
  self.m_tmpVec3 = LuaVector3.New()
end

function AIDoubtMoveTo:getType()
  return AIBehaviourType.eDoubtMoveTo
end

function AIDoubtMoveTo:onEnter(...)
  AIDoubtMoveTo.super.onEnter(self, ...)
  local arg = {
    ...
  }
  self.m_moveToPlayer = false
  self.m_stayTime = arg[1]
  if 1 < #arg then
    self.m_moveToPlayer = true
  end
  self.m_state = 0
  self.m_patrolTime = 0
  local data = self.m_ai:getHistoryStateData()
  if data ~= nil then
    if tonumber(data.m_type) == self:getType() then
      self.m_curTime = tonumber(data.m_currentTime)
    end
    self.m_ai:setHistoryStateData(nil)
    self.m_triggerId = data.m_doubtTriggerId
    self.m_moveToPlayer = data.m_moveToPlayer
    self.m_state = data.m_state
  elseif SgAIManager.Me():getCurTrigger() ~= nil and not self.m_moveToPlayer then
    self.m_triggerId = SgAIManager.Me():getCurTrigger():getUid()
  end
  self.m_lastAngle = self.m_ai.m_creature:GetAngleY()
  if not self.m_moveToPlayer then
    self.m_ai:lookAtTrigger()
  end
  self.m_isBreak = false
  self.m_plotId = Game.PlotStoryManager:Start_PQTLP("3031", self.playPlotEnd, self, nil, false, nil, {
    myself = self.m_ai:getUid()
  }, false)
end

function AIDoubtMoveTo:playPlotEnd(ret)
  if self.m_isBreak then
    return
  end
  if self.m_moveToPlayer then
    self.m_targetPosition = self.m_ai:getDogPos()
    self.m_ai:beginMoveTo(self.m_targetPosition, "walk2", true, self.moveEnd, self)
  else
    local trigger = SgAIManager.Me():findTrigger(self.m_triggerId)
    if trigger ~= nil then
      self.m_ai:beginMoveTo(trigger:getPosition(), "walk", true, self.moveEnd, self)
    else
      self.m_ai:getStateMachine():switchLastState()
    end
  end
  self.m_plotId = nil
end

function AIDoubtMoveTo:onBreakExit()
  self.m_ai:endMove(true)
  if self.m_plotId ~= nil then
    self.m_isBreak = true
    Game.PlotStoryManager:StopFreeProgress(self.m_plotId, true)
    self.m_plotId = nil
  end
  self.m_ai:setAngleY(self.m_lastAngle)
end

function AIDoubtMoveTo:onReEnter()
  if self.m_isBreak then
    self.m_plotId = Game.PlotStoryManager:Start_PQTLP("3031", self.playPlotEnd, self, nil, false, nil, {
      myself = self.m_ai:getUid()
    }, false)
  end
end

function AIDoubtMoveTo:moveEnd()
  if self.m_state == 0 then
    self.m_state = 1
  elseif self.m_state == 2 then
    self.m_patrolTime = self.m_patrolTime + 1
    self.m_curTime = 0
    if self.m_patrolTime <= self.m_totalCount then
      self.m_state = 1
    else
      self.m_state = 3
      self.m_ai:setAngleY(self.m_ai:getBirthAngleY())
    end
  elseif self.m_state == 4 then
    self.m_ai:getStateMachine():switchLastState()
  end
end

function AIDoubtMoveTo:setNextPosition()
  local x, y, z = SgAIManager.Me():getInstance():RandomPositonInRaidus(self.m_ai:getAITransform(), self.m_radius)
  local flag, p = NavMeshUtility.Better_Sample({
    x,
    y,
    z
  }, self.m_tmpVec3, nil)
  if not flag then
    self:setNextPosition()
  end
  self.m_targetPosition = p
end

function AIDoubtMoveTo:onExit()
  AIDoubtMoveTo.super.onExit(self)
  self.m_ai:endMove(true)
  self.m_ai:setAngleY(self.m_lastAngle)
end

function AIDoubtMoveTo:logicUpdate(deltaTime)
  if self.m_state == 1 then
    if 1 >= self.m_curTime then
      self.m_curTime = self.m_curTime + deltaTime
    else
      self.m_state = 2
      self:setNextPosition()
      self.m_ai:beginMoveTo(self.m_targetPosition, "walk2", false, self.moveEnd, self)
    end
    return
  end
  if self.m_state == 3 then
    self.m_curTime = self.m_curTime + deltaTime
    if self.m_curTime >= self.m_stayTime then
      self.m_ai:beginMoveTo(self.m_ai:getBirthPosition(), "walk", true, self.moveEnd, self)
      self.m_state = 4
    end
  end
end

function AIDoubtMoveTo:getData()
  self.m_data.m_type = self:getType()
  self.m_data.m_state = self.m_state
  self.m_data.m_currentTime = self.m_curTime
  self.m_data.m_doubtTriggerId = self.m_triggerId
  self.m_data.m_moveToPlayer = self.m_moveToPlayer
  return self.m_data
end
