autoImport("AIBaseBehaviour")
AIStand = class("AIStand", AIBaseBehaviour)

function AIStand:ctor(aiNpc)
  AIStand.super.ctor(self, aiNpc)
end

function AIStand:getType()
  return AIBehaviourType.eStand
end

function AIStand:onEnter(...)
  AIStand.super.onEnter(self, ...)
  self.m_stayTime = (...)
  math.randomseed(tostring(os.time()):reverse():sub(1, 6))
  local v = math.random(1, 10)
  if v < 3 then
    self.m_ai:playAction("wait")
  else
    self.m_ai:playAction("playshow")
  end
  self.m_state = 0
  local data = self.m_ai:getHistoryStateData()
  if data ~= nil then
    if tonumber(data.m_type) == self:getType() then
      self.m_curTime = tonumber(data.m_currentTime)
    end
    self.m_ai:setHistoryStateData(nil)
    if data.m_pos ~= nil then
      self.m_breakPosition = data.m_pos
      self.m_ai:beginMoveTo(self.m_breakPosition, "walk", false, self.moveEnd, self)
      self.m_state = 1
    end
  end
  self.m_autoSpeakInterval = self.m_ai:getAutoSpeakInterval()
  self.m_autoSpeakTime = 0
  if self.m_autoSpeakInterval ~= nil then
    self.m_ai:autoSpeak()
  end
end

function AIStand:onBreakExit()
  local aiPos = self.m_ai:getPosition()
  self.m_breakPosition = {}
  self.m_breakPosition[1] = aiPos[1]
  self.m_breakPosition[2] = aiPos[2]
  self.m_breakPosition[3] = aiPos[3]
  self.m_lastAngle = self.m_ai.m_creature:GetAngleY()
end

function AIStand:onReEnter()
  if self.m_breakPosition ~= nil then
    self.m_ai:beginMoveTo(self.m_breakPosition, "walk", false, self.moveEnd, self)
    self.m_state = 1
  end
  self.m_ai:setAngleY(self.m_lastAngle)
end

function AIStand:moveEnd()
  self.m_ai:endMove(true)
  self.m_breakPosition = nil
  self.m_state = 0
  self.m_ai:setAngleY(self.m_lastAngle)
end

function AIStand:onExit()
  AIStand.super.onExit(self)
end

function AIStand:logicUpdate(deltaTime)
  if self.m_state == 1 then
    return
  end
  self.m_curTime = self.m_curTime + deltaTime
  if self.m_autoSpeakInterval ~= nil and self.m_autoSpeakTime ~= nil then
    self.m_autoSpeakTime = self.m_autoSpeakTime + deltaTime
    if self.m_autoSpeakTime >= self.m_autoSpeakInterval then
      self.m_ai:autoSpeak()
      self.m_autoSpeakTime = 0
    end
  end
  if self.m_curTime >= self.m_stayTime then
    self.m_ai:getStateMachine():switchNext()
  end
end

function AIStand:getData()
  self.m_data.m_type = self:getType()
  self.m_data.m_currentTime = self.m_curTime
  self.m_data.m_state = self.m_state
  if self.m_breakPosition ~= nil then
    self.m_data.m_pos = self.m_breakPosition
  end
  return self.m_data
end
