autoImport("SgBaseTrigger")
SgCostItemPlayPlotTrigger = class("SgCostItemPlayPlotTrigger", SgBaseTrigger)

function SgCostItemPlayPlotTrigger:initData(tc, uid, historyData)
  SgCostItemPlayPlotTrigger.super.initData(self, tc, uid, historyData)
  self.m_plotIds = {}
  local tmp = tc.PlotIds
  if tmp ~= nil then
    for i = 1, #tmp do
      table.insert(self.m_plotIds, tmp[i])
    end
  end
  if historyData ~= nil then
    self.m_executeCount = historyData.m_executeCount
    for i, v in ipairs(self.m_plotIds) do
      if i <= self.m_executeCount then
        Game.PlotStoryManager:Start_PQTLP(v, self.finished, self, nil, false, nil, nil, false)
      end
    end
  else
    self.m_executeCount = 0
  end
end

function SgCostItemPlayPlotTrigger:showDialog(id, isKeepOpen)
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {id},
    callback = self.handlerDialogOption,
    callbackData = self,
    keepOpen = isKeepOpen
  }
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
end

function SgCostItemPlayPlotTrigger:closeDialog()
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.DialogLayer)
end

function SgCostItemPlayPlotTrigger:handlerDialogOption(optionId)
  if optionId == 1 then
    local index = self.m_executeCount + 1
    local itemId = self.m_unLockItem[index]
    local count = SgAIManager.Me():getItemById(itemId)
    if count == nil or count == 0 then
      self:showDialog(393796, false)
    else
      if SgAIManager.Me():playerUseItem(itemId, 1, true) then
        self.m_executeCount = self.m_executeCount + 1
        if self.m_executeCount + 1 > #self.m_unLockItem then
          Game.PlotStoryManager:Start_PQTLP(self.m_plotIds[index], self.finished, self, nil, false, nil, nil, false)
        else
          Game.PlotStoryManager:Start_PQTLP(self.m_plotIds[index], nil, nil, nil, false, nil, nil, false)
        end
      end
      self:closeDialog()
      SgAIManager.Me():recordHistoryData(nil)
    end
  elseif optionId == 2 then
    self:closeDialog()
  end
end

function SgCostItemPlayPlotTrigger:finished()
  if self.m_executeCount + 1 > #self.m_unLockItem then
    SgAIManager.Me():setIsFinished(true)
    if SgAIManager.Me():isFinished() then
      local questdata = SgAIManager.Me():getQuest()
      if questdata ~= nil then
        redlog("任务推进")
        QuestProxy.Instance:notifyQuestState(questdata.scope, questdata.id, questdata.staticData.FinishJump)
      else
        redlog("副本完成|没有相关任务信息")
      end
    end
    ServiceNUserProxy.Instance:ReturnToHomeCity()
  end
end

function SgCostItemPlayPlotTrigger:onExecute()
  local index = self.m_executeCount + 1
  if index > #self.m_unLockItem or index > #self.m_plotIds then
    return
  end
  self:showDialog(393795, true)
end

function SgCostItemPlayPlotTrigger:getData()
  local arg = SgCostItemPlayPlotTrigger.super.getData(self)
  arg.m_executeCount = self.m_executeCount
  return arg
end
