AbyssFakeDragonProxy = class("AbyssFakeDragonProxy", pm.Proxy)
AbyssFakeDragonProxy.Instance = nil
AbyssFakeDragonProxy.NAME = "AbyssFakeDragonProxy"

function AbyssFakeDragonProxy:ctor(proxyName, data)
  self.proxyName = proxyName or AbyssFakeDragonProxy.NAME
  if AbyssFakeDragonProxy.Instance == nil then
    AbyssFakeDragonProxy.Instance = self
  end
  self.abyssFakeDragonInfo = {}
  self.traceData = nil
end

function AbyssFakeDragonProxy:UpdateAbyssDragonInfo(data)
  redlog("AbyssFakeDragonProxy:UpdateAbyssDragonInfo")
  self:SetFakeDragonInfo(data)
end

function AbyssFakeDragonProxy:SetFakeDragonInfo(data)
  redlog("dragon_stage, stage_start_time, activity_start_time", tostring(data.dragon_stage), tostring(data.stage_start_time), tostring(data.activity_start_time))
  local info = self.abyssFakeDragonInfo
  info.stageStartTime = data.stage_start_time
  info.infoRecvTime = ServerTime.CurServerTime() / 1000
  info.dragonStage = data.dragon_stage
  if info.dragonStage == 1 then
    info.phase = 1
  elseif info.dragonStage == 2 then
    info.phase = 2
  else
    info.phase = 3
  end
  info.stepRecvTime = ServerTime.CurServerTime() / 1000
  info.activityStartTime = data.activity_start_time
end

function AbyssFakeDragonProxy:NotifyFakeDragonPhaseChange(phase)
end

function AbyssFakeDragonProxy:GetCountDownTime()
  if not self.abyssFakeDragonInfo then
    return
  end
  local info = self.abyssFakeDragonInfo
  local activityStartTime = info.activityStartTime
  local passedTime = info.stageStartTime - activityStartTime
  local duration = 0
  if info.dragonStage == 1 then
    duration = GameConfig.AbyssDragon.StageCountDown[info.dragonStage]
  else
    duration = GameConfig.AbyssDragon.StageCountDown[info.dragonStage or 2] - passedTime
  end
  return duration
end

function AbyssFakeDragonProxy:GetPassedTime()
  if not self.abyssFakeDragonInfo then
    return 0
  end
  local info = self.abyssFakeDragonInfo
  local activityStartTime = info.activityStartTime
  local now = ServerTime.CurServerTime() / 1000
  local passedTime = now - activityStartTime
  return passedTime
end

function AbyssFakeDragonProxy:GetTargetTime()
  if not self.abyssFakeDragonInfo then
    return
  end
  local info = self.abyssFakeDragonInfo
  local activityStartTime = info.activityStartTime
  local duration = GameConfig.AbyssDragon.StageCountDown[info.dragonStage or 1]
  return activityStartTime + duration
end

function AbyssFakeDragonProxy:GetTraceDesc()
  if not self.abyssFakeDragonInfo then
    return ""
  end
  local info = self.abyssFakeDragonInfo
  if info.phase == 2 then
    return info.map or 154, info.startPos
  end
end

function AbyssFakeDragonProxy:GetDragonInfos()
  if not (self.abyssFakeDragonInfo and self.abyssFakeDragonInfo.activityStartTime) or self.abyssFakeDragonInfo.activityStartTime <= 0 then
    return
  end
  return self.abyssFakeDragonInfo
end

function AbyssFakeDragonProxy:GetTracePos()
  if not self.abyssFakeDragonInfo then
    return
  end
  local info = self.abyssFakeDragonInfo
  if info.dragonStage == 3 then
    return info.map or 154, LuaVector3.New(122.100006103516, 183.100006103516, 327.400024414063)
  end
  if info.endPos and info.endBp then
    return info.map or 154, info.endPos
  end
end

function AbyssFakeDragonProxy:RecvAbyssDragonHpUpdateQuestCmd(data)
  self.dragon_hp = data.dragon_hp
  self.dragon_maxhp = data.dragon_maxhp
end

function AbyssFakeDragonProxy:GetDragonHp()
  if self.dragon_maxhp == 0 then
    self.dragon_maxhp = 1
  end
  local info = self.abyssFakeDragonInfo
  if info and info.dragonStage == 3 then
    return 1, 1
  end
  return self.dragon_hp or 1, self.dragon_maxhp or 1
end

function AbyssFakeDragonProxy:RecvAbyssDragonOnOffQuestCmd(data)
  self.onoff = data and data.onoff
end

function AbyssFakeDragonProxy:GetOnOff()
  return self.onoff == true
end

function AbyssFakeDragonProxy:GetRewardNum()
  return self.rewardNum or 0
end
