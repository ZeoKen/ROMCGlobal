autoImport("SgBaseTrigger")
SgCheckBagItemTrigger = class("SgCheckBagItemTrigger", SgBaseTrigger)

function SgCheckBagItemTrigger:DoDeconstruct()
  SgCheckBagItemTrigger.super.DoDeconstruct(self)
end

function SgCheckBagItemTrigger:initData(tc, uid, historyData)
  SgCheckBagItemTrigger.super.initData(self, tc, uid, historyData)
  self.m_needItem = {}
  local tmp = tc.PlotIds
  if tmp ~= nil then
    for i = 1, #tmp do
      local t = tonumber(tmp[i])
      t = math.modf(t)
      table.insert(self.m_needItem, t)
    end
  end
end

function SgCheckBagItemTrigger:onExecute()
  for _, v in ipairs(self.m_needItem) do
    if SgAIManager.Me():getItemById(v) == nil or SgAIManager.Me():getItemById(v) == 0 then
      MsgManager.ShowMsgByID(self.m_msgID)
      return
    end
  end
  if self.m_playPlotId ~= nil then
    return
  end
  if 0 ~= self.m_plotID and "" ~= self.m_plotID and self.m_plotID ~= nil then
    self.m_playPlotId = Game.PlotStoryManager:Start_PQTLP(self.m_plotID, self.onPlayPlotEnd, self, nil, false, nil, false)
    redlog("播放剧情" .. self.m_plotID)
  end
end

function SgCheckBagItemTrigger:onPlayPlotEnd()
  self.m_playPlotId = nil
end
