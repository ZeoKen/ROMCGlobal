autoImport("SgBaseTrigger")
SgNpcPlayPlotTrigger = class("SgNpcPlayPlotTrigger", SgBaseTrigger)

function SgNpcPlayPlotTrigger:initData(tc, uid, historyData)
  SgNpcPlayPlotTrigger.super.initData(self, tc, uid, historyData)
  self.m_npcIds = {}
  local tmp = tc.NpcIds
  if tmp ~= nil then
    for i = 1, #tmp do
      table.insert(self.m_npcIds, tmp[i])
    end
  end
  self.m_plotIds = {}
  tmp = tc.PlotIds
  if tmp ~= nil then
    for i = 1, #tmp do
      table.insert(self.m_plotIds, tmp[i])
    end
  end
end

function SgNpcPlayPlotTrigger:onExecute()
  if #self.m_npcIds < 1 or 1 > #self.m_plotIds then
    return
  end
  for i = 1, #self.m_npcIds do
    Game.PlotStoryManager:Start_PQTLP(self.m_plotIds[i], nil, nil, nil, false, nil, {
      myself = self.m_npcIds[i]
    }, false)
  end
end
