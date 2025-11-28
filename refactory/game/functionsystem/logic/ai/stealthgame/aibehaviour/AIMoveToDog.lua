autoImport("AIBaseBehaviour")
AIMoveToDog = class("AIMoveToDog", AIBaseBehaviour)

function AIMoveToDog:ctor(aiNpc)
  AIStand.super.ctor(self, aiNpc)
  self.m_radius = aiNpc:getAiAlertPatrolRadius()
  self.m_totalCount = aiNpc:getAiAlertPatrolTotalTimes()
end

function AIMoveToDog:getType()
  return AIBehaviourType.eMoveToDog
end

function AIMoveToDog:onEnter(...)
  AIMoveToDog.super.onEnter(self, ...)
  self.m_state = 0
  self.m_patrolTimes = 0
  local data = self.m_ai:getHistoryStateData()
  if data ~= nil then
    if tonumber(data.m_type) == self:getType() then
      self.m_curTime = tonumber(data.m_currentTime)
      self.m_patrolTimes = tonumber(data.m_patrolTime)
    end
    self.m_ai:setHistoryStateData(nil)
  end
  self.m_targetPosition = self.m_ai:getDogPos()
  self.m_ai:beginMoveTo(self.m_targetPosition, "walk2", false, self.moveEnd, self)
end

function AIMoveToDog:onBreakExit()
  self.m_ai:endMove(true)
end

function AIMoveToDog:onReEnter()
  if 1 == self.m_state then
    self.m_ai:beginMoveTo(self.m_targetPosition, "walk", false, self.moveEnd, self)
  else
    self.m_ai:beginMoveTo(self.m_targetPosition, "walk2", false, self.moveEnd, self)
  end
end

function AIMoveToDog:onExit()
  AIMoveToDog.super.onExit(self)
  self.m_ai:endMove(true)
end

local tmpVec3 = LuaVector3.New()

function AIMoveToDog:moveEnd()
  if 0 == self.m_state then
    self.m_patrolTimes = self.m_patrolTimes + 1
    if self.m_patrolTimes <= self.m_totalCount then
      local x, y, z = SgAIManager.Me():getInstance():RandomPositonInRaidus(self.m_ai:getAITransform(), self.m_radius)
      LuaVector3.Better_Set(tmpVec3, x, y, z)
      self.m_targetPosition = tmpVec3
      self.m_ai:beginMoveTo(self.m_targetPosition, "walk2", false, self.moveEnd, self)
    else
      self.m_targetPosition = self.m_ai:getBirthPosition()
      self.m_ai:beginMoveTo(self.m_targetPosition, "walk", true, self.moveEnd, self)
      self.m_state = 1
    end
  elseif 1 == self.m_state then
    self.m_ai:setAngleY(self.m_ai:getBirthAngleY())
    self.m_ai:getStateMachine():switchLastState()
  end
end

function AIMoveToDog:logicUpdate(deltaTime)
end

function AIMoveToDog:getData()
  self.m_data.m_type = self:getType()
  self.m_data.m_currentTime = self.m_curTime
  self.m_data.m_patrolTime = self.m_patrolTimes
  return self.m_data
end
