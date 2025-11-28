autoImport("SgBaseTrigger")
SgPaintingTrigger = class("SgPaintingTrigger", SgBaseTrigger)

function SgPaintingTrigger:initData(tc, uid, historyData)
  SgPaintingTrigger.super.initData(self, tc, uid, historyData)
  self.m_plotIds = {}
  local tmp = tc.PlotIds
  if tmp ~= nil then
    for i = 1, #tmp do
      table.insert(self.m_plotIds, tmp[i])
    end
  end
end

function SgPaintingTrigger:onExecute()
  if SgAIManager.Me():IsHiding() then
    return
  end
  SgAIManager.Me():setCurrentTrigger(self.m_uid)
  self:showEffect(true)
  SgAIManager.Me():Handle_Hiding(true)
  EventManager.Me():PassEvent(StealthGameEvent.HideIn, true)
end

function SgPaintingTrigger:playSound(isEnter)
  if not isEnter then
    if #self.m_plotIds > 0 then
      Game.PlotStoryManager:Start_PQTLP(self.m_plotIds[1], nil, nil, nil, false, nil, false)
    end
  elseif #self.m_plotIds > 1 then
    Game.PlotStoryManager:Start_PQTLP(self.m_plotIds[2], nil, nil, nil, false, nil, false)
  end
end

function SgPaintingTrigger:GetUIAnchorPosition()
  if self.m_objTrigger then
    return self.m_objTrigger:GetUIAnchorPosition()
  end
end
