autoImport("SgBaseTrigger")
SgBurrowTrigger = class("SgBurrowTrigger", SgBaseTrigger)

function SgBurrowTrigger:initData(tc, uid, historyData)
  SgBurrowTrigger.super.initData(self, tc, uid, historyData)
  self.m_plotIds = {}
  local tmp = tc.PlotIds
  if tmp ~= nil then
    for i = 1, #tmp do
      table.insert(self.m_plotIds, tmp[i])
    end
  end
end

function SgBurrowTrigger:onClick(obj)
  if SgAIManager.Me():playerIsInBurrow() then
    if self.m_triggerType == SgTriggerCondition.eClick then
      self:onExecute()
    else
      Game.Myself:Client_MoveTo(self:getPosition(), nil, function()
        if self.m_triggerType == SgTriggerCondition.eClick and self:playerInRange() then
          self:onExecute()
        end
      end, nil, nil, 3)
    end
  elseif self.m_triggerType == SgTriggerCondition.eClick and self:playerInRange() then
    self:onExecute()
  else
    Game.Myself:Client_MoveTo(self:getPosition(), nil, function()
      if self.m_triggerType == SgTriggerCondition.eClick and self:playerInRange() then
        self:onExecute()
      end
    end, nil, nil, 0.5)
  end
end

function SgBurrowTrigger:onExecute()
  SgAIManager.Me():visitedTrigger(self:getUid())
  self:showEffect(true)
  SgAIManager.Me():playerInBurrow(self.m_uid)
end

function SgBurrowTrigger:playSound(isEnterBurrow)
  if not isEnterBurrow then
    if #self.m_plotIds > 0 then
      Game.PlotStoryManager:Start_PQTLP(self.m_plotIds[1], nil, nil, nil, false, nil, false)
    end
  elseif #self.m_plotIds > 1 then
    Game.PlotStoryManager:Start_PQTLP(self.m_plotIds[2], nil, nil, nil, false, nil, false)
  end
end

function SgBurrowTrigger:showOutLine()
  local effect = self.m_objTrigger.MyOutLine
  if effect ~= nil then
    effect.enabled = true
    PostprocessManager.Instance:SetEffect("OutLinePP")
  else
    redlog("Trigger : 洞穴没有描边脚本")
  end
end

function SgBurrowTrigger:hideOutLine()
  local effect = self.m_objTrigger.MyOutLine
  if effect ~= nil then
    effect.enabled = false
    PostprocessManager.Instance:ClearEffect()
  else
    redlog("Trigger : 洞穴没有描边脚本")
  end
end

function SgBurrowTrigger:GetUIAnchorPosition()
  if self.m_objTrigger then
    return self.m_objTrigger:GetUIAnchorPosition()
  end
end
