autoImport("SgBaseTrigger")
SgSavePointTrigger = class("SgSavePointTrigger", SgBaseTrigger)

function SgSavePointTrigger:initData(tc, uid, historyData)
  SgSavePointTrigger.super.initData(self, tc, uid, historyData)
  self.m_isHasHistoryDataRePlay = tc.IsHasHistoryDataRePlay
end

function SgSavePointTrigger:isUsedHock()
  return self.m_isHasHistoryDataRePlay
end

function SgSavePointTrigger:onExecute()
  self:showEffect(true)
  SgAIManager.Me():recordHistoryData(self:getUid())
  redlog("存档点")
end

function SgSavePointTrigger:setPlayerToBirth()
  TimeTickManager.Me():CreateTick(100, 0, self.delay, self, self:getUid())
end

function SgSavePointTrigger:delay()
  local flag, x, y, z, dir = self.m_objTrigger:GetBirthPostion()
  if flag then
    Game.Myself.logicTransform:PlaceTo({
      x,
      y,
      z
    })
    Game.Myself.logicTransform:SetTargetAngleY(dir)
  else
    redlog("该触发器没有重生点")
  end
  FunctionCameraEffect.ResetFreeCameraFocusOffset(Game.Myself.assetRole, true)
  if self:isUsedHock() then
    SgAIManager.Me():setIsUseHock(self:playerInRange())
  else
    SgAIManager.Me():setIsUseHock(false)
  end
  TimeTickManager.Me():ClearTick(self, self:getUid())
end
