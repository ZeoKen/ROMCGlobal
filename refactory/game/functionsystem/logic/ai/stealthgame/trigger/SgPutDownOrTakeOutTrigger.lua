autoImport("SgBaseTrigger")
SgPutDownOrTakeOutTrigger = class("SgPutDownOrTakeOutTrigger", SgBaseTrigger)

function SgPutDownOrTakeOutTrigger:DoDeconstruct()
  SgPutDownOrTakeOutTrigger.super.DoDeconstruct(self)
  if self.m_tickTime ~= nil then
    TimeTickManager.Me():ClearTick(self, self:getUid())
    self.m_tickTime = nil
  end
end

function SgPutDownOrTakeOutTrigger:initData(tc, uid, historyData)
  SgPutDownOrTakeOutTrigger.super.initData(self, tc, uid, historyData)
  self.m_putDowItem = 0
  if tc.PlotID2 ~= nil and tc.PlotID2 ~= "" then
    self.m_putDowItem, _ = math.modf(tonumber(tc.PlotID2))
  end
  if nil == historyData then
    if self.m_putDowItem ~= 0 then
      self.m_isPutDown = true
      SgAIManager.Me():addToUsedItem(self.m_putDowItem, 1)
    else
      self.m_isPutDown = false
    end
  else
    self.m_isPutDown = historyData.m_isPutDown
  end
  self.m_plotIds = {}
  local tmp = tc.PlotIds
  if tmp ~= nil then
    for i = 1, #tmp do
      table.insert(self.m_plotIds, tmp[i])
    end
  end
  if self.m_isPutDown then
    for _, v in ipairs(self.m_effectList) do
      v:PlayAnimationByIndex(0)
    end
    local id = self.m_plotIds[1]
    if 0 ~= id and "" ~= id and id ~= nil then
      self.m_curPlayingPlotId = Game.PlotStoryManager:Start_PQTLP(id, self.playPlotEnd, self, nil, false, nil, false)
    end
  end
end

function SgPutDownOrTakeOutTrigger:update()
  if not self:playerInRange() then
    TimeTickManager.Me():ClearTick(self, self:getUid())
    self.m_tickTime = nil
    self:exit()
  end
end

function SgPutDownOrTakeOutTrigger:onExecute()
  self.m_tickTime = TimeTickManager.Me():CreateTick(0, 33, self.update, self, self:getUid())
  if self.m_curPlayingPlotId ~= nil then
    redlog("≤•∑≈æÁ«È÷–...")
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.SgPutDownItemView,
    viewdata = {
      triggerId = self:getUid()
    }
  })
  self.m_tickTime = TimeTickManager.Me():CreateTick(0, 33, self.update, self, self:getUid())
end

function SgPutDownOrTakeOutTrigger:isPutDown()
  return self.m_isPutDown
end

function SgPutDownOrTakeOutTrigger:hasItem()
  local items = self:getUnLockItem()
  if #items == 0 then
    return false
  else
    for _, id in pairs(items) do
      if nil == SgAIManager.Me():getItemById(id) then
        return false
      end
    end
  end
  return true
end

function SgPutDownOrTakeOutTrigger:putDownItem()
  if not self:hasItem() then
    return
  end
  local items = self:getUnLockItem()
  for _, id in pairs(items) do
    SgAIManager.Me():playerUseItem(id, 1, true)
  end
  self.m_isPutDown = true
  for _, v in ipairs(self.m_effectList) do
    v:PlayAnimationByIndex(0)
  end
  local id = self.m_plotIds[1]
  if 0 ~= id and "" ~= id and id ~= nil then
    self.m_curPlayingPlotId = Game.PlotStoryManager:Start_PQTLP(id, self.playPlotEnd, self, nil, false, nil, false)
  end
  SgAIManager.Me():recordHistoryData(nil)
end

function SgPutDownOrTakeOutTrigger:takeOutItem()
  if not self.m_isPutDown then
    return
  end
  local items = self:getUnLockItem()
  for _, id in pairs(items) do
    SgAIManager.Me():playerAddItem(id, 1)
  end
  self.m_isPutDown = false
  for _, v in ipairs(self.m_effectList) do
    v:PlayAnimationByIndex(1)
  end
  local id = self.m_plotIds[2]
  if 0 ~= id and "" ~= id and id ~= nil then
    self.m_curPlayingPlotId = Game.PlotStoryManager:Start_PQTLP(id, self.playPlotEnd, self, nil, false, nil, false)
  end
  SgAIManager.Me():recordHistoryData(nil)
end

function SgPutDownOrTakeOutTrigger:playPlotEnd()
  self.m_curPlayingPlotId = nil
end

function SgPutDownOrTakeOutTrigger:getLeftCount()
  local items = self:getUnLockItem()
  local totalCount = 0
  for _, id in pairs(items) do
    local t = SgAIManager.Me():getItemById(id)
    if nil ~= t then
      totalCount = totalCount + t
    end
  end
  return totalCount
end

function SgPutDownOrTakeOutTrigger:getItemId()
  local items = self:getUnLockItem()
  for _, id in pairs(items) do
    return id
  end
  return nil
end

function SgPutDownOrTakeOutTrigger:setUICallBack(func, table)
  self.m_func = func
  self.m_table = table
end

function SgPutDownOrTakeOutTrigger:exit()
  SgPutDownOrTakeOutTrigger.super.exit(self)
  if self.m_func ~= nil then
    self.m_func(self.m_table)
  end
end

function SgPutDownOrTakeOutTrigger:getData()
  local arg = SgPutDownOrTakeOutTrigger.super.getData(self)
  arg.m_isPutDown = self.m_isPutDown
  return arg
end
