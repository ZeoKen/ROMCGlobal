autoImport("AIBaseBehaviour")
AIMoveToVertigoNpc = class("AIMoveToVertigoNpc", AIBaseBehaviour)

function AIMoveToVertigoNpc:ctor(aiNpc)
  AIMoveToVertigoNpc.super.ctor(self, aiNpc)
end

function AIMoveToVertigoNpc:getType()
  return AIBehaviourType.eMoveToVertigoNpc
end

function AIMoveToVertigoNpc:onEnter(...)
  AIMoveToVertigoNpc.super.onEnter(self, ...)
  self.m_state = 0
  local data = self.m_ai:getHistoryStateData()
  if data ~= nil then
    if tonumber(data.m_type) == self:getType() then
      self.m_curTime = tonumber(data.m_currentTime)
    end
    self.m_ai:setHistoryStateData(nil)
    self.m_state = data.m_state
    if data.m_posX == nil or data.m_posY == nil or data.m_posZ == nil then
      self.m_targetPosition = self.m_ai:getBirthPosition()
      self.m_state = 1
    else
      self.m_targetPosition = {
        data.m_posX,
        data.m_posY,
        data.m_posZ
      }
    end
  else
    self.m_targetPosition = self.m_ai:getVertigoNpc():getPosition()
  end
  redlog("move to vertigo ai")
  self.m_ai:beginMoveTo(self.m_targetPosition, "walk2", false, self.moveEnd, self)
end

function AIMoveToVertigoNpc:onBreakExit()
  self.m_ai:endMove(true)
end

function AIMoveToVertigoNpc:onReEnter()
  if 0 == self.m_state then
    self.m_ai:beginMoveTo(self.m_targetPosition, "walk2", false, self.moveEnd, self)
  else
    self.m_ai:beginMoveTo(self.m_targetPosition, "walk", true, self.moveEnd, self)
  end
end

function AIMoveToVertigoNpc:onExit()
  AIMoveToVertigoNpc.super.onExit(self)
  self.m_ai:endMove(true)
end

function AIMoveToVertigoNpc:moveEnd()
  if self.m_state == 0 then
    if self.m_ai:getVertigoNpc() ~= nil then
      self.m_ai:getVertigoNpc():onWakeUpByNpc(nil)
    end
    self.m_targetPosition = self.m_ai:getBirthPosition()
    self.m_ai:beginMoveTo(self.m_targetPosition, "walk", true, self.moveEnd, self)
    self.m_state = 1
  else
    self.m_ai:setAngleY(self.m_ai:getBirthAngleY())
    self.m_ai:getStateMachine():switchLastState()
  end
end

function AIMoveToVertigoNpc:logicUpdate(deltaTime)
end

function AIMoveToVertigoNpc:getData()
  self.m_data.m_type = self:getType()
  self.m_data.m_state = self.m_state
  self.m_data.m_posX = self.m_targetPosition.x
  self.m_data.m_posY = self.m_targetPosition.y
  self.m_data.m_posZ = self.m_targetPosition.z
  return self.m_data
end
