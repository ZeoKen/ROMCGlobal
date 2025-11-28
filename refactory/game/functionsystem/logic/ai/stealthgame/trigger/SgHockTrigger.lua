autoImport("SgBaseTrigger")
SgHockTrigger = class("SgHockTrigger", SgBaseTrigger)

function SgHockTrigger:initData(tc, uid, historyData)
  SgHockTrigger.super.initData(self, tc, uid, historyData)
  self.m_outPlotId = tc.PlotID2
end

function SgHockTrigger:onExecute()
  if SgAIManager.Me():isUseHock() then
    if 0 ~= self.m_outPlotId then
      local playEnd = function(result)
        self:setPlayerToOutPosition()
        SgAIManager.Me():setIsUseHock(false)
      end
      Game.PlotStoryManager:Start_PQTLP(self.m_outPlotId, playEnd, nil, nil, false, nil, false)
      redlog("播放剧情" .. self.m_outPlotId)
    end
  elseif 0 ~= self.m_plotID and "" ~= self.m_plotID and self.m_plotID ~= nil then
    local playEnd = function(result)
      self:setPlayerToBirth()
      SgAIManager.Me():setIsUseHock(true)
    end
    Game.PlotStoryManager:Start_PQTLP(self.m_plotID, playEnd, nil, nil, false, nil, false)
    redlog("播放剧情" .. self.m_plotID)
  end
end
