autoImport("SgBaseTrigger")
SgDogHoleTrigger = class("SgDogHoleTrigger", SgBaseTrigger)

function SgDogHoleTrigger:initData(tc, uid, historyData)
  SgDogHoleTrigger.super.initData(self, tc, uid, historyData)
  self.m_curPlayPlotId = nil
  self.m_enableState = {}
  local tmp = tc.PlotIds
  if tmp ~= nil then
    for i = 1, #tmp do
      table.insert(self.m_enableState, tmp[i])
    end
  end
end

function SgDogHoleTrigger:onExecute()
  if #self.m_enableState ~= #self.m_effectList then
    redlog("触发器配置有误 " .. self:getUid())
    return
  end
  for k, v in ipairs(self.m_effectList) do
    if not v:IsPlayingByName(self.m_enableState[k]) then
      return
    end
  end
  if 0 ~= self.m_plotID and "" ~= self.m_plotID and self.m_plotID ~= nil then
    redlog("播放剧情" .. self.m_plotID)
    if self.m_curPlayPlotId ~= nil then
      return
    end
    self.m_curPlayPlotId = Game.PlotStoryManager:Start_PQTLP(self.m_plotID, self.onPlotPlayEnd, self, nil, false, nil, false)
  else
    self:setPlayerToBirth()
    for _, v in ipairs(self.m_effectList) do
      if not v:PlayAnimationByIndex(0) then
        redlog("触发器 -> " .. self:getUid() .. " play enter animation index = 0 失败")
      end
    end
  end
end

function SgDogHoleTrigger:onPlotPlayEnd()
  self:setPlayerToBirth()
  self.m_curPlayPlotId = nil
end
