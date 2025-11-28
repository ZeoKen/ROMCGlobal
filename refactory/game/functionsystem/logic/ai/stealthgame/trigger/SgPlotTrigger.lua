autoImport("SgBaseTrigger")
SgPlotTrigger = class("SgPlotTrigger", SgBaseTrigger)

function SgPlotTrigger:initData(tc, uid, historyData)
  SgPlotTrigger.super.initData(self, tc, uid, historyData)
  self.m_isHasHistoryDataRePlay = tc.IsHasHistoryDataRePlay
  if SgAIManager.Me():triggerIsVisited(self.m_uid) and self.m_isHasHistoryDataRePlay then
    Game.PlotStoryManager:Start_PQTLP(self.m_plotID, nil, nil, nil, false, nil, false)
  end
end

function SgPlotTrigger:onExecute()
  if SgAIManager.Me():triggerIsVisited(self.m_uid) then
    return
  end
  if self.m_playPlotId ~= nil then
    return
  end
  self:showEffect(true)
  SgAIManager.Me():setCurrentTrigger(self.m_uid)
  if 0 ~= self.m_plotID and "" ~= self.m_plotID and self.m_plotID ~= nil then
    self.m_playPlotId = Game.PlotStoryManager:Start_PQTLP(self.m_plotID, self.onPlayPlotEnd, self, nil, false, nil, false)
    redlog("播放剧情" .. self.m_plotID)
    if false == self.m_playPlotId then
      self.m_tickTime = TimeTickManager.Me():CreateTick(500, 0, self.onPlayPlotFailed, self, self.m_uid)
    end
  end
  self:getReward()
  local rmItems = self:getUnLockItem()
  if 0 < #rmItems then
    local tmp = {}
    for _, v in pairs(rmItems) do
      if tmp[v] == nil then
        tmp[v] = 1
      else
        tmp[v] = tmp[v] + 1
      end
    end
    for k, v in pairs(tmp) do
      SgAIManager.Me():playerUseItem(k, v, true)
    end
  end
end

function SgPlotTrigger:onPlayPlotEnd()
  if nil ~= self.m_tickTime then
    TimeTickManager.Me():ClearTick(self, self.m_uid)
  end
  MsgManager.ShowMsgByID(self.m_msgID)
  if self.m_skillID ~= nil and self.m_skillID > 0 then
    SgAIManager.Me():AddTriggerSkill(self.m_skillID)
  end
  SgAIManager.Me():visitedTrigger(self:getUid())
  self.m_playPlotId = nil
end

function SgPlotTrigger:onPlayPlotFailed()
  redlog("重新播放剧情" .. self.m_plotID)
  self.m_playPlotId = Game.PlotStoryManager:Start_PQTLP(self.m_plotID, self.onPlayPlotEnd, self, nil, false, nil, false)
  TimeTickManager.Me():ClearTick(self, self.m_uid)
  if false == self.m_playPlotId and self.m_plotID ~= nil and "" ~= self.m_plotID then
    self.m_tickTime = TimeTickManager.Me():CreateTick(500, 0, self.onPlayPlotFailed, self, self.m_uid)
  end
end

function SgPlotTrigger:onStopPlot()
  if self.m_playPlotId ~= nil then
    Game.PlotStoryManager:StopFreeProgress(self.m_playPlotId, true)
    self.m_playPlotId = nil
  end
end
