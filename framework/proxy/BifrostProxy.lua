autoImport("BifrostMatData")
BifrostProxy = class("BifrostProxy", pm.Proxy)
BifrostProxy.Instance = nil
BifrostProxy.NAME = "BifrostProxy"
local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
local parseStamp = function(str)
  local year, month, day, hour, min, sec = str:match(p)
  return os.time({
    year = year,
    month = month,
    day = day,
    hour = hour,
    min = min,
    sec = sec
  })
end
local OnCrystalEffCreated = function(effectHandle, self, assetEffect)
  if not self then
    if assetEffect then
      assetEffect:Destroy()
    end
    return
  end
  self.crystalEff = assetEffect
  self:_onCrystalEffCreated(effectHandle)
end
local VIDEO_NAME = "BifrostEvent.mp4"
local MATH_CEIL = math.ceil

function BifrostProxy:ctor(proxyName, data)
  self.proxyName = proxyName or BifrostProxy.NAME
  if BifrostProxy.Instance == nil then
    BifrostProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.staticInited = false
  self.clientTest = false
end

function BifrostProxy:OpenClientTest()
  self.clientTest = true
end

function BifrostProxy:InitStatic()
  if self.staticInited then
    return
  end
  self.staticMatData = {}
  if self.clientTest then
    redlog("BifrostProxy:InitStatic")
  end
  self:_initContribute()
  self:_initCrystal()
  self.staticInited = true
end

function BifrostProxy:_initContribute()
  local staticData = GameConfig.BifrostEventActivity and GameConfig.BifrostEventActivity.DailyContributeInfo
  for k, v in pairs(staticData) do
    local data = BifrostMatData.new(k, v)
    self.staticMatData[k] = data
  end
end

function BifrostProxy:_initCrystal()
  local cfg = GameConfig.BifrostEventActivity and GameConfig.BifrostEventActivity.ActivityEffectEvent
  if nil == cfg then
    redlog("LaunchBrokenCrystalTick failed !  7.5大事件配置错误 检查配置: GameConfig.BifrostEventActivity.ActivityEffectEvent")
    return
  end
  if nil == self.crystalList then
    self.crystalList = {}
  end
  local isReleaseBranch = EnvChannel.IsReleaseBranch()
  if self.clientTest then
    redlog("BifrostProxy:_initCrystal isReleaseBranch: ", isReleaseBranch)
  end
  for i = 1, #cfg do
    local state = {}
    if isReleaseBranch then
      state.startTime, state.endTime = parseStamp(cfg[i].StartTime), parseStamp(cfg[i].EndTime)
    else
      state.startTime, state.endTime = parseStamp(cfg[i].TfStartTime), parseStamp(cfg[i].TFEndTime)
    end
    state.effectParam = cfg[i].effectParam
    self.crystalList[#self.crystalList + 1] = state
  end
  if isReleaseBranch then
    self.bifrostStartStamp, self.bifrostEndStamp = parseStamp(cfg[1].StartTime), parseStamp(cfg[#cfg].EndTime)
  else
    self.bifrostStartStamp, self.bifrostEndStamp = parseStamp(cfg[1].TfStartTime), parseStamp(cfg[#cfg].TFEndTime)
  end
  local uieffectCfg = cfg[#cfg].UIEffect
  if nil == uieffectCfg then
    redlog("魔法炮发射UI特效配置未找到")
    return
  end
  if not self.uiEffectCfg then
    self.uiEffectCfg = {}
  end
  self.uiEffectCfg.time = isReleaseBranch and MATH_CEIL(parseStamp(uieffectCfg.Time)) or MATH_CEIL(parseStamp(uieffectCfg.TFTime))
  if self.clientTest then
    redlog("BifrostProxy self.uiEffectCfg.time: ", self.uiEffectCfg.time)
  end
  self.uiEffectCfg.path = uieffectCfg.Path
end

function BifrostProxy:GetMatData(id)
  return id and self.staticMatData and self.staticMatData[id]
end

function BifrostProxy:_applyCrystalState(path)
  local index = self.curCrystalState
  local state = self.crystalList[index] and self.crystalList[index].effectParam
  local mapid = SceneProxy.Instance:GetCurMapID()
  self.crystalCfg = mapid and state and state[mapid]
  if nil == self.crystalCfg then
    return
  end
  local old = self.crystalEff
  if nil ~= old then
    old:Destroy()
  end
  self.crystalEff = Asset_Effect.PlayAt(self.crystalCfg.effectPath, LuaGeometry.Const_V3_zero, OnCrystalEffCreated, self, nil)
end

function BifrostProxy:LaunchBrokenCrystalTick()
  if not self.staticInited then
    return
  end
  self:RestoreCrystal()
  self:_clearCrystalTick()
  self.crystalTick = TimeTickManager.Me():CreateTick(0, 1000, self._updateCrystalEffect, self, 3)
end

function BifrostProxy:ShutDownBrokenCrystal()
  self:_clearCrystalTick()
  self:_clearCrystalEff()
  TableUtility.ArrayClear(self.crystalList)
  self.crystalCfg = nil
end

function BifrostProxy:RestoreCrystal()
  self.curCrystalState = nil
end

function BifrostProxy:_clearCrystalTick()
  if nil ~= self.crystalTick then
    TimeTickManager.Me():ClearTick(self, 3)
    self.crystalTick = nil
  end
end

function BifrostProxy:_clearCrystalEff()
  if self.crystalEff then
    self.crystalEff:Destroy()
    self.crystalEff = nil
  end
end

function BifrostProxy:_onCrystalEffCreated(effectHandle)
  if nil == self.crystalEff or self.crystalEff:GetEffectHandle() ~= effectHandle then
    return
  end
  self.crystalEff:ResetLocalScale(self.crystalCfg.scale)
  self.crystalEff:ResetLocalEulerAngles(self.crystalCfg.rotation)
end

function BifrostProxy:_updateCrystalEffect()
  local curServerTime = ServerTime.CurServerTime() / 1000
  if curServerTime > self.bifrostEndStamp or curServerTime < self.bifrostStartStamp then
    self:ShutDownBrokenCrystal()
    return
  end
  if self.clientTest and self.uiEffectCfg then
    redlog("_updateCrystalEffect:  ", self.uiEffectCfg.time, MATH_CEIL(curServerTime))
    redlog("self.uiEffectCfg.time==MATH_CEIL(curServerTime): ", self.uiEffectCfg.time == MATH_CEIL(curServerTime))
  end
  if self.uiEffectCfg and self.uiEffectCfg.time == MATH_CEIL(curServerTime) then
    local mapid = SceneProxy.Instance:GetCurMapID()
    if 33 == mapid then
      redlog("播放魔法炮发射视频")
      VideoPanel.PlayVideo(VIDEO_NAME)
    elseif nil ~= self.crystalList[#self.crystalList].effectParam[mapid] then
      redlog("播放魔法炮发射时UI特效")
      FloatingPanel.Instance:FloatingMidEffectByFullPath(self.uiEffectCfg.path)
    end
  end
  for state, tab in pairs(self.crystalList) do
    if curServerTime > tab.startTime and curServerTime < tab.endTime then
      self:_onCrystalStatusChanged(state)
      break
    end
  end
end

function BifrostProxy:_onCrystalStatusChanged(state)
  if state ~= self.curCrystalState then
    self.curCrystalState = state
    self:_applyCrystalState()
  end
end
