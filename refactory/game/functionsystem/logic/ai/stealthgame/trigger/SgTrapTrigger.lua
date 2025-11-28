autoImport("SgBaseTrigger")
SgTrapTrigger = class("SgTrapTrigger", SgBaseTrigger)

function SgTrapTrigger:DoDeconstruct()
  SgTrapTrigger.super.DoDeconstruct(self)
  self.m_timeInfo = {}
  self.m_curTimeList = {}
  if self.m_tickTime ~= nil then
    TimeTickManager.Me():ClearTick(self, self:getUid())
    self.m_tickTime = nil
  end
  if self.m_checkTime ~= nil then
    TimeTickManager.Me():ClearTick(self, self:getUid() + 999)
    self.m_checkTime = nil
  end
end

function SgTrapTrigger:initData(tc, uid, historyData)
  SgTrapTrigger.super.initData(self, tc, uid, historyData)
  self.m_curPlayingPlotId = nil
  self.m_timeInfo = {}
  local tmp = tc.PlotIds
  if tmp ~= nil then
    for i = 1, #tmp, 2 do
      local delay = tonumber(tmp[i])
      local fixed = tonumber(tmp[i + 1])
      table.insert(self.m_timeInfo, {delay, fixed})
    end
  end
  if #self.m_timeInfo >= #self.m_effectList then
    self.m_curTimeList = {}
    for k, v in ipairs(self.m_effectList) do
      local timeInfo = self.m_timeInfo[k]
      table.insert(self.m_curTimeList, 0 - timeInfo[1])
    end
    self.m_tickTime = TimeTickManager.Me():CreateTick(0, 33, self.update, self, uid)
  end
end

function SgTrapTrigger:update()
  for k, v in ipairs(self.m_effectList) do
    local timeInfo = self.m_timeInfo[k]
    if self.m_curTimeList[k] >= timeInfo[2] then
      v:PlayAnimationByIndex(-1)
      self.m_curTimeList[k] = 0
    else
      self.m_curTimeList[k] = self.m_curTimeList[k] + 0.033
    end
  end
end

function SgTrapTrigger:onExecute()
  if 0 ~= self.m_plotID and "" ~= self.m_plotID and self.m_plotID ~= nil then
    self.m_checkTime = TimeTickManager.Me():CreateTick(0, 33, self.checkCanKillPlayer, self, self:getUid() + 999)
  else
    SgAIManager.Me():CancelAttachNPC()
    SgAIManager.Me():setPlayerIsDead(true)
    Game.Myself:Client_NoMove(true)
    SgAIManager.Me():setIsGameOver(true)
    SgAIManager.Me():ResetSkillEffect()
    SgAIManager.Me():RemoveLookAtEffect()
    Game.Myself:Client_NoMove(false)
    SgAIManager.Me():CancelAttachNPC()
    SgAIManager.Me():onRestart()
  end
end

function SgTrapTrigger:exit()
  SgTrapTrigger.super.exit(self)
  if self.m_checkTime ~= nil then
    TimeTickManager.Me():ClearTick(self, self:getUid() + 999)
    self.m_checkTime = nil
  end
end

function SgTrapTrigger:checkCanKillPlayer()
  local isKill = false
  for _, v in ipairs(self.m_effectList) do
    if v:IsPlayingByName(self.m_makeVoiceKey) then
      isKill = true
    end
  end
  if self.m_curPlayingPlotId == nil and isKill then
    SgAIManager.Me():CancelAttachNPC()
    SgAIManager.Me():setPlayerIsDead(true)
    Game.Myself:Client_NoMove(true)
    SgAIManager.Me():setIsGameOver(true)
    SgAIManager.Me():ResetSkillEffect()
    SgAIManager.Me():RemoveLookAtEffect()
    SgAIManager.Me():CancelAttachNPC()
    self.m_curPlayingPlotId = Game.PlotStoryManager:Start_PQTLP(self.m_plotID, self.plotPlayEnd, self, nil, false, nil, false)
    if self.m_checkTime ~= nil then
      TimeTickManager.Me():ClearTick(self, self:getUid() + 999)
      self.m_checkTime = nil
    end
  end
end

function SgTrapTrigger:plotPlayEnd()
  Game.Myself:Client_NoMove(false)
  SgAIManager.Me():onRestart()
  self.m_curPlayingPlotId = nil
end
