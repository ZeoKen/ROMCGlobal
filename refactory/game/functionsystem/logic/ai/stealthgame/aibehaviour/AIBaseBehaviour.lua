AIBaseBehaviour = class("AIBaseBehaviour")
AIBehaviourType = {
  eNone = -1,
  eEmpty = 0,
  eStand = 1,
  ePatrol = 2,
  eDoubt = 3,
  eLethargy = 4,
  eAlert = 5,
  eAlertPatrol = 6,
  eVertigo = 7,
  eMoveToLightUp = 8,
  eMoveToVertigoNpc = 9,
  eShooting = 10,
  eMoveToDog = 11,
  eMoveToNewBirth = 12,
  eDead = 13,
  eDoubtStand = 14,
  eDoubtMoveTo = 15,
  eVisit = 16
}

function AIBaseBehaviour:ctor(aiNpc)
  self.m_curTime = 0
  self.m_ai = aiNpc
  self.m_stayTime = 0
  self.m_arg = {}
  self.m_data = {}
  self.m_isRun = false
end

function AIBaseBehaviour:getType()
  return AIBehaviourType.eNone
end

function AIBaseBehaviour:getWeight()
  return self.m_weight
end

function AIBaseBehaviour:onEnter(...)
  self.m_curTime = 0
  self.m_isRun = true
  self:showLog("enter")
end

function AIBaseBehaviour:onBreakExit()
end

function AIBaseBehaviour:onReEnter()
end

function AIBaseBehaviour:onExit()
  self.m_curTime = 0
  self.m_isRun = false
  self:showLog("exit")
end

function AIBaseBehaviour:onUpdate(deltaTime)
  if self.m_isRun then
    self:logicUpdate(deltaTime)
  end
end

function AIBaseBehaviour:logicUpdate(deltaTime)
end

function AIBaseBehaviour:sendEvent(type, value)
  self.m_arg.m_type = type
  self.m_arg.m_state = self:getType()
  self.m_arg.m_value = value
  self.m_arg.m_ai = self.m_ai
  EventManager.Me():PassEvent(StealthGameEvent.AIState_Update, self.m_arg)
end

function AIBaseBehaviour:getData()
  return self.m_data
end

function AIBaseBehaviour:showLog(msg)
  do return end
  local type = self:getType()
  local log = "<color=#%s>" .. self.m_ai:getUid() .. " " .. msg .. " %s</color>"
  if type == AIBehaviourType.eAlert then
    LogUtility.Info(string.format(log, "FF00E2", "警戒"))
  elseif type == AIBehaviourType.eAlertPatrol then
    LogUtility.Info(string.format(log, "FF00E2", "警戒巡逻"))
  elseif type == AIBehaviourType.eDoubt then
    LogUtility.Info(string.format(log, "FF00E2", "疑惑"))
  elseif type == AIBehaviourType.eLethargy then
    LogUtility.Info(string.format(log, "FF00E2", "睡觉"))
  elseif type == AIBehaviourType.ePatrol then
    LogUtility.Info(string.format(log, "FF00E2", "巡逻"))
  elseif type == AIBehaviourType.eStand then
    LogUtility.Info(string.format(log, "FF00E2", "伫立"))
  elseif type == AIBehaviourType.eVertigo then
    LogUtility.Info(string.format(log, "FF00E2", "眩晕"))
  elseif type == AIBehaviourType.eMoveToVertigoNpc then
    LogUtility.Info(string.format(log, "FF00E2", "走向眩晕npc"))
  elseif type == AIBehaviourType.eMoveToLightUp then
    LogUtility.Info(string.format(log, "FF00E2", "走向火光"))
  elseif type == AIBehaviourType.eShooting then
    LogUtility.Info(string.format(log, "FF00E2", "射击"))
  elseif type == AIBehaviourType.eMoveToNewBirth then
    LogUtility.Info(string.format(log, "FF00E2", "移动新重生点"))
  end
end
