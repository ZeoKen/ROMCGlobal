autoImport("SgBaseTrigger")
SgRubbleTrigger = class("SgRubbleTrigger", SgBaseTrigger)

function SgRubbleTrigger:onExecute()
  self:showEffect(true)
  if self.m_plotID ~= nil and self.m_curPlayPlotId == nil then
    self.m_curPlayPlotId = Game.PlotStoryManager:Start_PQTLP(self.m_plotID, self.onPlotStoryEnd, self, nil, false, nil, {
      obj = {
        id = self.m_objId,
        type = self.m_objType
      }
    }, false)
  end
  SgAIManager.Me():setCurrentTrigger(self.m_uid)
  for _, npc in ipairs(SgAIManager.Me():getAllNpcs()) do
    if npc:isDead() == false then
      local pos = npc:getPosition()
      if self:inVoiceRange(pos[1], pos[2], pos[3]) then
        npc:onWakeUpByTrigger(self.m_uid)
      end
    end
  end
  redlog("瓦砾")
end

function SgRubbleTrigger:onPlotStoryEnd(ret)
  self.m_curPlayPlotId = nil
end
