autoImport("EventDispatcher")
autoImport("ConditionCheck")
FunctionCheck = class("FunctionCheck", EventDispatcher)
FunctionCheck.CannotSyncMoveReason = {
  OnCarrier = 1,
  LoadingScene = 2,
  Skill_Transport = 3,
  ExitPoint = 4,
  AttachOb = 5,
  StealthGame = 6
}

function FunctionCheck.Me()
  if nil == FunctionCheck.me then
    FunctionCheck.me = FunctionCheck.new()
  end
  return FunctionCheck.me
end

function FunctionCheck:ctor()
  self.cannotSyncMoveChecker = ConditionCheck.new()
  self.cannotSyncAngleYChecker = ConditionCheck.new()
end

function FunctionCheck:Reset()
  self.cannotSyncMoveChecker:Reset()
  self:SetSysMsg(nil)
end

function FunctionCheck:SetSyncMove(reason, value)
  if value then
    self.cannotSyncMoveChecker:RemoveReason(reason)
  else
    self.cannotSyncMoveChecker:SetReason(reason)
  end
end

function FunctionCheck:CanSyncMove()
  return not self.cannotSyncMoveChecker:HasReason()
end

function FunctionCheck:SetSyncAngleY(reason, value)
  if value then
    self.cannotSyncAngleYChecker:RemoveReason(reason)
  else
    self.cannotSyncAngleYChecker:SetReason(reason)
  end
end

function FunctionCheck:CanSyncAngleY()
  return not self.cannotSyncAngleYChecker:HasReason()
end

function FunctionCheck:CheckProp(p)
  self:CheckFucOpen(p)
  self:PassEvent(MyselfEvent.MyPropChange, p)
end

function FunctionCheck:CheckFucOpen(p)
  FunctionUnLockFunc.Me():CheckProp(p)
end

function FunctionCheck:SetSysMsg(time)
  self.canRecvSysMsgTime = time
end

function FunctionCheck:CheckSysMsg()
  if self.canRecvSysMsgTime == nil then
    return true
  end
  if UnityTime > self.canRecvSysMsgTime then
    self:SetSysMsg(nil)
    return true
  end
  return false
end
