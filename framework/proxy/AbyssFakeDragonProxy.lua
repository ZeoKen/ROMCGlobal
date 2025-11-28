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
  self:SetFakeDragonInfo(data)
end

function AbyssFakeDragonProxy:SetFakeDragonStepInfo(data)
  local info = self.abyssFakeDragonInfo
  local params = data.params
  local anim = params.anim and params.anim[1]
  info.map = data.map
  info.animDuration = params.time
  info.stepRecvTime = ServerTime.CurServerTime() / 1000
  if info.anim ~= anim then
    info.anim = anim
  end
  self:TryStartPlayFakeDragonAnim()
end

function AbyssFakeDragonProxy:SetFakeDragonInfo(data)
  local info = self.abyssFakeDragonInfo
  info.startBp = data.dragon_from_bp
  info.endBp = data.dragon_to_bp
  info.animStartTime = data.anim_start_time
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
  if info.startBp and info.endBp then
    local mapId = info.map or 154
    local mapName = Table_Map[mapId] and Table_Map[mapId].NameEn
    if mapName == nil then
      return
    end
    local fName = "Scene_" .. mapName
    local sceneInfo = autoImport(fName)
    local bps = sceneInfo.PVE.bps
    for _, v in pairs(bps) do
      if v.ID == info.startBp then
        info.startPos = LuaVector3.New(v.position[1], v.position[2], v.position[3])
        break
      end
    end
    for _, v in pairs(bps) do
      if v.ID == info.endBp then
        info.endPos = LuaVector3.New(v.position[1], v.position[2], v.position[3])
        break
      end
    end
  end
  GameFacade.Instance:sendNotification(FakeDragonEvent.UpdateFakeDragonPoses)
end

function AbyssFakeDragonProxy:IsFakeDragonAnimInfoReady()
  local info = self.abyssFakeDragonInfo
  if info.anim and info.stepRecvTime and info.infoRecvTime then
    return math.abs(info.stepRecvTime - info.infoRecvTime) <= 100
  end
end

function AbyssFakeDragonProxy:TryStartPlayFakeDragonAnim()
  if self:IsFakeDragonAnimInfoReady() then
    local info = self.abyssFakeDragonInfo
    local curTime = ServerTime.CurServerTime() / 1000
    local pctElapsed = (curTime - info.animStartTime) / info.animDuration
    if pctElapsed < 0.99 then
      local extraParams
      if info.startPos and info.endPos then
        extraParams = {
          start = info.startPos,
          ["end"] = info.endPos
        }
      end
      Game.PlotStoryManager:Launch()
      local result = Game.PlotStoryManager:Start_PQTLP(info.anim, nil, nil, nil, false, nil, extraParams, nil, pctElapsed)
    end
  end
end

function AbyssFakeDragonProxy:NotifyFakeDragonPhaseChange(phase)
end

function AbyssFakeDragonProxy:GetFakeDragonPosition()
  local info = self.abyssFakeDragonInfo
  if not info then
    return
  end
  if info.startPos and info.endPos and info.animStartTime and info.animDuration then
    local pctElapsed = (ServerTime.CurServerTime() / 1000 - info.animStartTime) / info.animDuration
    if 1 < pctElapsed then
      if info.dragonStage > 0 and info.dragonStage < 3 then
        return info.animStartTime, info.endPos
      end
      return nil
    end
    local result = LuaVector3.Lerp(info.startPos, info.endPos, pctElapsed)
    return info.animStartTime, result
  end
  return nil
end

function AbyssFakeDragonProxy:GetCountDownTime()
  if not self.abyssFakeDragonInfo then
    return
  end
  local info = self.abyssFakeDragonInfo
  local activityStartTime = info.activityStartTime
  local passedTime = info.animStartTime - activityStartTime
  local duration = GameConfig.AbyssDragon.StageCountDown[info.dragonStage or 1] - passedTime
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
  local duration = GameConfig.AbyssDragon.StageCountDown[info.dragonStage or 1] - passedTime
  return passedTime
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
