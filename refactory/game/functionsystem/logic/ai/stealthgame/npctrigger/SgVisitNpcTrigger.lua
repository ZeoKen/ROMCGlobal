autoImport("SgBaseNpcTrigger")
SgVisitNpcTrigger = class("SgVisitNpcTrigger", SgBaseNpcTrigger)

function SgVisitNpcTrigger:DoDeconstruct()
  SgVisitNpcTrigger.super.DoDeconstruct(self)
  if self.m_playPlotId ~= nil then
    Game.PlotStoryManager:StopFreeProgress(self.m_playPlotId, true)
    self.m_playPlotId = nil
  end
  EventManager.Me():RemoveEventListener(StealthGameEvent.ClickMinMapLeave, self.onLeave, self)
end

function SgVisitNpcTrigger:initData(sgClass, uid, tid, historyData)
  SgVisitNpcTrigger.super.initData(self, sgClass, uid, tid, historyData)
  self.m_dialogList = {}
  local tmp = sgClass.DialogList
  for i = 1, #tmp do
    table.insert(self.m_dialogList, tmp[i])
  end
  if #self.m_dialogList < 1 then
    self.m_dialogList = nil
  end
  self.m_skillId = sgClass.SkillID
  self.m_msgId = sgClass.MsgID
  self.m_isLeave = false
  EventManager.Me():AddEventListener(StealthGameEvent.ClickMinMapLeave, self.onLeave, self)
end

function SgVisitNpcTrigger:onLeave()
  self.m_isLeave = true
end

function SgVisitNpcTrigger:addEvent()
  local isCanVisited = true
  if SgAIManager.Me():npcTriggerIsVisited(self.m_uid) then
    isCanVisited = false
    if self.m_isRepeat then
      isCanVisited = true
    end
  end
  if isCanVisited then
    FunctionVisitNpc.Me():RegisterVisitShow(self.m_uid, self.m_dialogList, function()
      self:onExecute()
    end, nil)
  end
end

function SgVisitNpcTrigger:onExecute()
  if nil == self.m_plotID then
    self:addReward()
    if self.m_isCanDelete then
      SgAIManager.Me():removeNpcTrigger(self.m_uid)
    elseif not self.m_isRepeat then
      FunctionVisitNpc.Me():UnRegisterVisitShow(self.m_uid)
    end
    SgAIManager.Me():visitedNpcTrigger(self.m_uid)
    MsgManager.ShowMsgByID(self.m_msgId)
    if self.m_skillId ~= nil and self.m_skillId > 0 then
      SgAIManager.Me():AddTriggerSkill(self.m_skillId)
    end
    local dialog = self.m_memoryDialog
    if dialog and 0 < #dialog then
      SgAIManager.Me():AddMemory(dialog)
      RedTipProxy.Instance:UpdateRedTip(711)
      EventManager.Me():PassEvent(StealthGameEvent.Update_MemoryInfo)
    end
    for _, v in pairs(self.m_usedItems) do
      SgAIManager.Me():playerUseItem(v, 1, true)
    end
  else
    if self.m_playPlotId ~= nil then
      return
    end
    SgAIManager.Me():onEnableAttachedUI(false)
    self.m_playPlotId = Game.PlotStoryManager:Start_PQTLP(self.m_plotID, self.plotPlayEnd, self, nil, false, nil, {
      myself = self.m_creature.data.id,
      {
        obj = {
          id = self.m_objId,
          type = self.m_objType
        }
      }
    }, false)
  end
end

function SgVisitNpcTrigger:plotPlayEnd()
  self:addReward()
  if self.m_isCanDelete then
    SgAIManager.Me():removeNpcTrigger(self.m_uid)
  elseif not self.m_isRepeat then
    FunctionVisitNpc.Me():UnRegisterVisitShow(self.m_uid)
  end
  SgAIManager.Me():visitedNpcTrigger(self.m_uid)
  MsgManager.ShowMsgByID(self.m_msgId)
  if self.m_skillId ~= nil and self.m_skillId > 0 then
    SgAIManager.Me():AddTriggerSkill(self.m_skillId)
  end
  self.m_playPlotId = nil
  for _, v in pairs(self.m_usedItems) do
    SgAIManager.Me():playerUseItem(v, 1, true)
  end
  if self.m_isLeave then
    return
  end
  SgAIManager.Me():onEnableAttachedUI(true)
end

function SgVisitNpcTrigger:addReward()
  if SgAIManager.Me():npcTriggerIsVisited(self.m_uid) then
    return
  end
  for i = 1, #self.m_dorpItems do
    SgAIManager.Me():playerAddItem(self.m_dorpItems[i], 1)
  end
end
