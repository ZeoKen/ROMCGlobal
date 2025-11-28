autoImport("SgBaseTrigger")
SgVisitTriggerChildTrigger = class("SgVisitTriggerChildTrigger", SgBaseTrigger)

function SgVisitTriggerChildTrigger:initData(tc, uid, historyData)
  SgVisitTriggerChildTrigger.super.initData(self, tc, uid, historyData)
  self.m_completed = tonumber(self.m_makeVoiceKey)
  if #self.m_effectList < 1 then
    redlog("子触发器没有动画配置")
  else
    self.m_curAnim = self.m_effectList[1]
  end
end

function SgVisitTriggerChildTrigger:onExecute()
  if self.m_curAnim == nil then
    return
  end
  if SgAIManager.Me():triggerIsVisited(self:getUid()) then
    return
  end
  self.m_curAnim:PlayAnimationByIndex(-1)
  if self:isCompleted() then
    SgAIManager.Me():onChildTriggerCompleted()
  end
end

function SgVisitTriggerChildTrigger:isCompleted()
  return self.m_completed == self.m_curAnim:GetCurrentIndex()
end
