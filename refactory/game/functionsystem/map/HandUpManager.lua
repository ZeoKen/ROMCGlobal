HandUpManager = class("HandUpManager")
local HANDUP_CANOPEN = GameConfig.HandUP.Open == 1
local HANDUP_TIME = GameConfig.HandUP.Time
local HANDUP_BRIGHTNESS = GameConfig.HandUP.Brightness
local HANDUP_FLITER = GameConfig.HandUP.SceneFilter or {10, 20}
local HANDUP_GC_INTERVAL = 300

function HandUpManager:ctor()
  self.maunalOpen = true
end

function HandUpManager:Launch()
  if self.running == true then
    return
  end
  if not HANDUP_CANOPEN then
    return
  end
  if ApplicationInfo.IsRunOnWindowns() then
    return
  end
  if not FunctionPerformanceSetting.Me():GetPowerMode() then
    return
  end
  self.running = true
end

function HandUpManager:MaunalOpen()
  self:ResetCacheTime()
  self.maunalOpen = true
end

function HandUpManager:MaunalClose()
  self:EndHandUp()
  self.maunalOpen = false
end

function HandUpManager:UpdateOpenState()
  local powerMode = FunctionPerformanceSetting.Me():GetPowerMode()
  if powerMode then
    self:Launch()
  else
    self:Shutdown()
  end
end

function HandUpManager:IsInHandingUp()
  return self.isHandUping == true
end

local countTime = 0
local gcTime = 5

function HandUpManager:Update(time, deltaTime)
  if not self.running then
    return
  end
  if Input.anyKey then
    self:ResetCacheTime()
    self:EndHandUp()
    return
  end
  if self.isHandUping then
    gcTime = gcTime + deltaTime
    if gcTime >= HANDUP_GC_INTERVAL then
      self:GC()
      gcTime = 0
    end
    return
  end
  local realDeltaTime = 0
  if self.lastTime then
    realDeltaTime = RealTime.time - self.lastTime
  end
  self.lastTime = RealTime.time
  countTime = countTime + realDeltaTime
  if countTime >= HANDUP_TIME then
    self:StartHandUp()
  end
end

function HandUpManager:ResetCacheTime()
  self.lastTime = nil
  countTime = 0
end

local originalBrightness = 0.5

function HandUpManager:StartHandUp()
  if not self.maunalOpen then
    return
  end
  if self.isHandUping then
    return
  end
  self.isHandUping = true
  self:ResetCacheTime()
  local nowPlatform = ApplicationInfo.GetRunPlatform()
  if nowPlatform == RuntimePlatform.Android then
    originalBrightness = -1
  else
    originalBrightness = ExternalInterfaces.GetSysScreenBrightness()
  end
  ExternalInterfaces.SetScreenBrightness(HANDUP_BRIGHTNESS)
  FunctionPerformanceSetting.EnterSavingMode()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.HandUpView
  })
  ServiceWeatherProxy.Instance:SetWeatherEnable(false)
  Game.EnviromentManager:SetAnimationEnable(false)
  FunctionSceneFilter.Me():StartFilter(HANDUP_FLITER)
  Game.PerformanceManager:LowPerformance()
end

function HandUpManager:EndHandUp()
  if not self.isHandUping then
    return
  end
  self.isHandUping = false
  self:ResetCacheTime()
  ExternalInterfaces.SetScreenBrightness(originalBrightness)
  FunctionPerformanceSetting.ExitSavingMode()
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.ShieldingLayer)
  FunctionSceneFilter.Me():EndFilter(HANDUP_FLITER)
  ServiceWeatherProxy.Instance:SetWeatherEnable(true)
  Game.EnviromentManager:SetAnimationEnable(true)
  Game.PerformanceManager:ResetPerformance()
end

function HandUpManager:GC()
  MyLuaSrv.Instance:LuaManualGC()
  MyLuaSrv.MonoGC()
  ResourceManager.Instance:GC()
end

function HandUpManager:Shutdown()
  if self.running == false then
    return
  end
  self.running = false
  self:EndHandUp()
end
