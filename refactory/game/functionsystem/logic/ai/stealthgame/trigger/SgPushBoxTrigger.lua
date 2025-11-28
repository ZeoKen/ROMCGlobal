autoImport("SgBaseTrigger")
SgPushBoxTrigger = class("SgPushBoxTrigger", SgBaseTrigger)

function SgPushBoxTrigger:initData(tc, uid, historyData)
  SgPushBoxTrigger.super.initData(self, tc, uid, historyData)
  self.m_needBoxCount = tc.BoxCount
  if historyData ~= nil then
    self.m_boxInfo = historyData.m_boxInfo
  else
    self.m_boxInfo = {}
  end
  self.m_curPlayPlotId = nil
end

function SgPushBoxTrigger:enter()
  if self.m_triggerType == SgTriggerCondition.eEnter then
    SgAIManager.Me():setCurrentTrigger(self.m_uid)
    self:onExecute()
  end
end

function SgPushBoxTrigger:onExecute()
  if SgAIManager.Me():triggerIsVisited(self.m_uid) then
    return
  end
  if self:isMaxBox() then
    SgAIManager.Me():visitedTrigger(self:getUid())
    self:showEffect(true)
    if self.m_plotID ~= nil and self.m_curPlayPlotId == nil then
      self.m_curPlayPlotId = Game.PlotStoryManager:Start_PQTLP(self.m_plotID, self.onPlotStoryEnd, self, nil, false, nil, nil, false)
    end
    SgAIManager.Me():onTriggerExecuteSuccessed(self.m_uid)
  end
end

function SgPushBoxTrigger:onPlotStoryEnd(ret)
  self.m_curPlayPlotId = nil
end

function SgPushBoxTrigger:addBox(uid)
  if not self:playerInRange() then
    return
  end
  if self.m_boxInfo == nil then
    self.m_boxInfo = {}
  end
  if self.m_boxInfo[uid] == nil then
    self.m_boxInfo[uid] = 1
  else
    self.m_boxInfo[uid] = self.m_boxInfo[uid] + 1
  end
  self:onExecute()
end

function SgPushBoxTrigger:removeBox(uid)
  if not self:playerInRange() then
    return
  end
  if self.m_boxInfo[uid] == nil then
    return
  end
  self.m_boxInfo[uid] = self.m_boxInfo[uid] - 1
  if self.m_boxInfo[uid] == 0 then
    self.m_boxInfo[uid] = nil
  end
end

function SgPushBoxTrigger:getBoxCount()
  local count = 0
  for _, _ in pairs(self.m_boxInfo) do
    count = count + 1
  end
  return count
end

function SgPushBoxTrigger:hasBox(uid)
  return self.m_boxInfo[uid] ~= nil and self.m_boxInfo[uid] > 0
end

function SgPushBoxTrigger:isMaxBox()
  return self:getBoxCount() >= self.m_needBoxCount
end

function SgPushBoxTrigger:showOutLine()
  local effect = self.m_objTrigger.MyOutLine
  if effect ~= nil then
    effect.enabled = true
    PostprocessManager.Instance:SetEffect("OutLinePP")
  else
    redlog("Trigger : 洞穴没有描边脚本")
  end
end

function SgPushBoxTrigger:hideOutLine()
  local effect = self.m_objTrigger.MyOutLine
  if effect ~= nil then
    effect.enabled = false
    PostprocessManager.Instance:ClearEffect()
  else
    redlog("Trigger : 洞穴没有描边脚本")
  end
end

function SgPushBoxTrigger:getData()
  local arg = SgPushBoxTrigger.super.getData(self)
  arg.m_boxInfo = self.m_boxInfo
  return arg
end
