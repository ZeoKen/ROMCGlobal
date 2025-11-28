autoImport("AIBaseBehaviour")
AIAlertPatrol = class("AIAlertPatrol", AIBaseBehaviour)
local eNpcState = {
  eNone = 0,
  eStop = 1,
  eMoveToPlayer = 2,
  eMoveToPlayerLastPos = 3,
  eMoveToRandom = 4,
  eMoveToRandomEnd = 5,
  eChangeAlert = 6,
  eStand = 7,
  eMoveToBirth = 8,
  eBreakExit = 9,
  eKillPlayer = 777
}

function AIAlertPatrol:ctor(aiNpc)
  AIAlertPatrol.super.ctor(self, aiNpc)
  self.m_maxValue = 10
  self.m_value = 0
  self.m_addSpeed = aiNpc:getAiAlertPatrolAddSpeed()
  self.m_reduceSpeed = aiNpc:getAiAlertPatrolReduceSpeed()
  self.m_radius = aiNpc:getAiAlertPatrolRadius()
  self.m_totalCount = aiNpc:getAiAlertPatrolTotalTimes()
  self.m_patrolTime = 0
  self.m_tmpVec3 = LuaVector3.New()
end

function AIAlertPatrol:getType()
  return AIBehaviourType.eAlertPatrol
end

function AIAlertPatrol:onEnter(...)
  AIAlertPatrol.super.onEnter(self, ...)
  self.m_patrolTime = 0
  self.m_stayTime = 1
  self.m_state = 0
  local data = self.m_ai:getHistoryStateData()
  if data ~= nil then
    if tonumber(data.m_type) == self:getType() then
      self.m_value = tonumber(data.m_alertValue)
      self.m_patrolTime = tonumber(data.m_patrolTime)
    end
    self.m_ai:setHistoryStateData(nil)
    self.m_npcState = data.m_state
    if self.m_npcState == nil then
      self.m_npcState = eNpcState.eMoveToRandomEnd
    end
  else
    self.m_npcState = eNpcState.eNone
  end
  self.m_ai:showAlertUI()
  self.m_targetPosition = nil
  self.m_ai:disableDialog()
end

function AIAlertPatrol:onBreakExit()
  self.m_ai:endMove(true)
  if self.m_npcState == eNpcState.eMoveToRandom then
    self.m_npcState = eNpcState.eBreakExit
  end
  self.m_ai:hideAlertUI()
  self.m_ai:enabledDialog()
end

function AIAlertPatrol:onReEnter()
  if self.m_npcState == eNpcState.eBreakExit then
    self.m_ai:beginMoveTo(self.m_targetPosition, "walk2", false, self.moveEnd, self)
    self.m_npcState = eNpcState.eMoveToRandom
  end
  self.m_ai:showAlertUI()
  self.m_ai:disableDialog()
end

function AIAlertPatrol:onExit()
  AIAlertPatrol.super.onExit(self)
  self.m_ai:endMove(true)
  self.m_patrolTime = 0
  self.m_playerPosition = nil
  if self.m_value > self.m_maxValue then
    self.m_value = self.m_maxValue
  end
  if 0 > self.m_value then
    self.m_value = 0
  end
  self.m_ai:hideAlertUI()
  self.m_ai:enabledDialog()
end

function AIAlertPatrol:moveEnd()
  if self.m_npcState == eNpcState.eMoveToPlayerLastPos then
    self:setNextPosition()
    self.m_ai:beginMoveTo(self.m_targetPosition, "walk2", false, self.moveEnd, self)
    self.m_npcState = eNpcState.eMoveToRandom
  elseif self.m_npcState == eNpcState.eMoveToRandom then
    self.m_patrolTime = self.m_patrolTime + 1
    self.m_curTime = 0
    if self.m_patrolTime <= self.m_totalCount then
      self.m_npcState = eNpcState.eStand
    else
      self.m_npcState = eNpcState.eMoveToRandomEnd
    end
  elseif self.m_npcState == eNpcState.eMoveToBirth then
    self.m_ai:setAngleY(self.m_ai:getBirthAngleY())
    self.m_ai:getStateMachine():switchByType(AIBehaviourType.eAlert)
    self.m_npcState = eNpcState.eNone
  end
end

function AIAlertPatrol:logicUpdate(deltaTime)
  if self.m_npcState == eNpcState.eKillPlayer then
    if not self.m_ai:isMoving() and not SgAIManager.Me():playerIsDead() then
      self.m_ai:killPlayer()
    end
    return
  end
  if self.m_npcState == eNpcState.eStand then
    if self.m_curTime <= self.m_stayTime then
      self.m_curTime = self.m_curTime + deltaTime
    else
      self:setNextPosition()
      self.m_ai:beginMoveTo(self.m_targetPosition, "walk2", false, self.moveEnd, self)
      self.m_npcState = eNpcState.eMoveToRandom
    end
    return
  end
  if self.m_ai:isFindPlayer() then
    local r = (self.m_ai:getVisionRadius() - math.abs(LuaVector3.Distance(Game.Myself:GetPosition(), self.m_ai:getPosition()))) * 0.3 + 0.5
    self.m_npcState = eNpcState.eNone
    self.m_patrolTime = 0
    self.m_value = self.m_value + self.m_addSpeed * r * deltaTime
    local x, y, z = SgAIManager:Me():getInstance():GetPlayerPosition(self.m_ai:getAITransform())
    LuaVector3.Better_Set(self.m_tmpVec3, x, y, z)
    if self.m_value >= self.m_maxValue then
      self.m_npcState = eNpcState.eKillPlayer
      self.m_ai.m_creature.logicTransform:SetMoveSpeed(GameConfig.HeartLock.DeadMoveSpeed)
      SgAIManager.Me():CancelAttachNPC()
    else
      self.m_npcState = eNpcState.eMoveToPlayer
      self.m_ai:beginMoveTo(self.m_tmpVec3, "walk2", false, nil, nil)
    end
  elseif self.m_npcState == eNpcState.eMoveToPlayer then
    self.m_ai:beginMoveTo(self.m_tmpVec3, "walk2", false, self.moveEnd, self)
    self.m_npcState = eNpcState.eMoveToPlayerLastPos
  elseif self.m_npcState == eNpcState.eMoveToRandomEnd and self.m_value <= self.m_maxValue then
    self.m_value = self.m_value - self.m_reduceSpeed * deltaTime
    if 0 >= self.m_value then
      self.m_value = 0
      self.m_ai:beginMoveTo(self.m_ai:getBirthPosition(), "walk2", false, self.moveEnd, self)
      self.m_npcState = eNpcState.eMoveToBirth
    end
  end
  local v = self.m_value / self.m_maxValue
  if 1 <= v then
    v = 1
  end
  self.m_ai:updateAlertValue(true, v)
end

function AIAlertPatrol:setNextPosition()
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

function AIAlertPatrol:getData()
  self.m_data.m_type = self:getType()
  self.m_data.m_state = self.m_npcState
  self.m_data.m_alertValue = self.m_value
  self.m_data.m_patrolTime = self.m_patrolTime
  return self.m_data
end
