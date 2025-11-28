autoImport("SgBaseTrigger")
SgVictoryTrigger = class("SgVictoryTrigger", SgBaseTrigger)

function SgVictoryTrigger:onExecute()
  self:showEffect(true)
  if 0 ~= self.m_plotID and "" ~= self.m_plotID and self.m_plotID ~= nil then
    local playEnd = function(result)
      ServiceNUserProxy.Instance:ReturnToHomeCity()
    end
    Game.PlotStoryManager:Start_PQTLP(self.m_plotID, playEnd, nil, nil, false, nil, false)
  else
    ServiceNUserProxy.Instance:ReturnToHomeCity()
  end
  redlog("胜利触发器" .. self.m_plotID)
end
