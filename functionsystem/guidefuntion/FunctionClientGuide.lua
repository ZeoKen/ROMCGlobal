autoImport("CoreView")
autoImport("ClientGuide")
local IsNull = Slua.IsNull
local mEvent_FuncMap = {
  clicktarget = function(self, event)
    return self:AddClickEvent(event and event.target)
  end,
  clickmask = function(self, event)
    self:SetDisplayMaskEnabled(true)
    return true
  end,
  targetshow = function(self, event)
    return self:AddTargetMono(event and event.target)
  end,
  targethide = function(self, event)
    return self:AddTargetMono(event and event.target)
  end,
  guideparam = function(self, event)
    if event.param then
      for k, v in pairs(event.param) do
        self:SetCustomParam(k, v)
      end
    end
    return true
  end
}
local SafeGuideTime = 10
FunctionClientGuide = class("FunctionClientGuide", EventDispatcher)

function FunctionClientGuide.Me()
  if nil == FunctionClientGuide.me then
    FunctionClientGuide.me = FunctionClientGuide.new()
  end
  return FunctionClientGuide.me
end

function FunctionClientGuide:ctor()
  self.targetMap = {}
  self.targetMonoMap = {}
  self.clickEventMap = {}
  self.trigger = {}
  self:ResetEvtHandlerTag()
  self:ResetDisplayHandlerTag()
end

function FunctionClientGuide:RegisterTarget(targetType, obj)
  self.targetMap[targetType] = obj
  EventManager.Me():PassEvent(GuideEvent.TargetRegisted, targetType)
end

function FunctionClientGuide:UnRegisterTarget(targetType)
  EventManager.Me():PassEvent(GuideEvent.UnTargetRegisted, targetType)
  self:RemoveClickEvent(targetType)
  self.targetMap[targetType] = nil
end

function FunctionClientGuide:FindTarget(typeKey)
  if not typeKey then
    return
  end
  local targetType = ClientGuide.TargetType[typeKey]
  if targetType then
    return self.targetMap[targetType]
  else
    error(string.format("未定义目标类型：%s", typeKey))
  end
  return nil
end

function FunctionClientGuide:AddClickEvent(targetType)
  if not targetType then
    error(string.format("%s 未配置target", self.guideKey))
  end
  local targetGO = self:FindTarget(targetType)
  if IsNull(targetGO) then
    return false
  end
  if self.clickEventMap[targetType] then
    return true
  end
  local clickEvent = function(go)
    self:ClickTarget(targetType)
    self:RemoveClickEvent(targetType)
  end
  UIEventListener.Get(targetGO).onClick = {"+=", clickEvent}
  self.clickEventMap[targetType] = clickEvent
  return true
end

function FunctionClientGuide:RemoveClickEvent(targetType)
  if self.clickEventMap[targetType] then
    local targetGO = self:FindTarget(targetType)
    if not IsNull(targetGO) then
      UIEventListener.Get(targetGO).onClick = {
        "-=",
        self.clickEventMap[targetType]
      }
    end
  end
  self.clickEventMap[targetType] = nil
end

function FunctionClientGuide:ClearClickEvent()
  for k, v in pairs(self.clickEventMap) do
    self:RemoveClickEvent(k)
  end
end

function FunctionClientGuide:AddTargetMono(targetType)
  if self.targetMonoMap[targetType] then
    return true
  end
  local targetGO = self:FindTarget(targetType)
  if IsNull(targetGO) then
    return false
  end
  local targetMono = targetGO:AddComponent(GameObjectForLua)
  
  function targetMono.onEnable(go)
    self:TargetShow(targetType)
  end
  
  function targetMono.onDisable(go)
    self:TargetHide(targetType)
  end
  
  function targetMono.onDestroy(go)
    self.targetMonoMap[targetType] = nil
  end
  
  self.targetMonoMap[targetType] = targetMono
  return true
end

function FunctionClientGuide:RemoveTargetMono(targetType)
  local targetMono = self.targetMonoMap[targetType]
  self.targetMonoMap[targetType] = nil
  if not IsNull(targetMono) then
    targetMono.onEnable = nil
    targetMono.onDisable = nil
    targetMono.onDestroy = nil
    Component.Destroy(targetMono)
  end
end

function FunctionClientGuide:ClearTargetMono()
  for k, v in pairs(self.targetMonoMap) do
    self:RemoveTargetMono(k)
  end
end

function FunctionClientGuide:DoEvent(event)
  if event and event.type then
    local func = mEvent_FuncMap[event.type]
    if func then
      return func(self, event)
    end
  end
  return true
end

function FunctionClientGuide:ResetEvtHandlerTag()
  self.evtExecuted = false
  self.evtHandlerTag = {}
  self.evtHandlerTime = 0
end

function FunctionClientGuide:HandleEvents(time, deltaTime)
  if self.evtExecuted then
    return
  end
  self.evtExecuted = true
  local events = self.stepConfig.events
  if events then
    for i = 1, #events do
      if not self.evtHandlerTag[i] then
        self.evtHandlerTag[i] = self:DoEvent(events[i])
      end
      if not self.evtHandlerTag[i] then
        self.evtExecuted = false
      end
    end
    self.evtHandlerTime = self.evtHandlerTime + deltaTime
    if self.evtHandlerTime > SafeGuideTime then
      self:FinishCurrentGuide(false)
    end
  end
end

function FunctionClientGuide:DoDisplay(stepConfig)
  if not stepConfig or not stepConfig.display then
    return true
  end
  if stepConfig.display.target then
    local targetGO = self:FindTarget(stepConfig.display.target)
    if IsNull(targetGO) then
      return false
    end
  end
  self:ShowGuideView(stepConfig)
  return true
end

function FunctionClientGuide:ResetDisplayHandlerTag()
  self.displayExecuted = false
  self.displayWaitTime = 0
  self:SetDisplayMaskEnabled(false)
  self:CloseGuideView()
end

function FunctionClientGuide:SetDisplayMaskEnabled(b)
  self.displayMaskEnabled = b
end

function FunctionClientGuide:DisplayMaskEnabled(b)
  return self.displayMaskEnabled == true
end

function FunctionClientGuide:HandleDisplay(time, deltaTime)
  if self.displayExecuted then
    return
  end
  self.displayExecuted = true
  local display = self.stepConfig.display
  if display then
    self.displayExecuted = self:DoDisplay(self.stepConfig)
    self.displayWaitTime = self.displayWaitTime + deltaTime
    if self.displayWaitTime > SafeGuideTime then
      self:FinishCurrentGuide(false)
    end
  end
end

function FunctionClientGuide:StepGuide(step)
  if not self.config then
    return
  end
  redlog("引导推进", self.guideKey, step)
  self.step = step
  self.stepConfig = self.config[self.step]
  self:ResetEvtHandlerTag()
  self:ResetDisplayHandlerTag()
  if not self.stepConfig then
    self:FinishCurrentGuide(true)
  end
end

function FunctionClientGuide:StartGuide(guideKey, finishCall, finishCallParam)
  if self.config then
    self:FinishCurrentGuide(false)
  end
  redlog("开始引导", guideKey)
  guideKey = "ClientGuide_" .. guideKey
  local config = _G[guideKey]
  if not config then
    autoImport(guideKey)
    config = _G[guideKey]
  end
  if not config then
    error(string.format("引导失败，未找到配置：%s.", guideKey))
    return
  end
  self.guideKey = guideKey
  self.config = config
  self.finishCall = finishCall
  self.finishCallParam = finishCallParam
  self:StepGuide(1)
end

function FunctionClientGuide:FinishCurrentGuide(finished)
  if not self.config then
    return
  end
  if finished then
    if self.finishCall then
      self.finishCall(self.finishCallParam)
    end
    self.finishCall = nil
    self.finishCallParam = nil
    redlog("结束引导", self.guideKey)
  else
    redlog("中断引导", self.guideKey)
  end
  self.config = nil
  self.guideKey = nil
  self.step = 0
  self:ResetEvtHandlerTag()
  self:ResetDisplayHandlerTag()
  self:CloseGuideView()
  self:ClearClickEvent()
  self:ClearTargetMono()
  self:ClearCustomParam()
end

function FunctionClientGuide:ShowGuideView(viewdata)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.ClientGuideView,
    viewdata = viewdata
  })
end

function FunctionClientGuide:CloseGuideView()
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, {
    className = "ClientGuideView"
  })
end

function FunctionClientGuide:ClickTarget(targetType)
  self.trigger.dirty = true
  self.trigger.click = targetType
end

function FunctionClientGuide:ClickGuideMask()
  self.trigger.dirty = true
  self.trigger.click = "mask"
end

function FunctionClientGuide:TargetShow(targetType)
  self.trigger.dirty = true
  self.trigger.targetshow = targetType
end

function FunctionClientGuide:TargetHide(targetType)
  self.trigger.dirty = true
  self.trigger.targethide = targetType
end

function FunctionClientGuide:DoTrigger(event, trigger)
  if event.type == "clicktarget" then
    if trigger.click == event.target then
      self:StepGuide(event.tostep)
      return true
    end
  elseif event.type == "clickmask" then
    if trigger.click == "mask" then
      self:StepGuide(event.tostep)
      return true
    end
  elseif event.type == "targetshow" then
    if trigger.targetshow == event.target then
      self:StepGuide(event.tostep)
      return true
    end
  elseif event.type == "targethide" and trigger.targethide == event.target then
    self:StepGuide(event.tostep)
    return true
  end
  return false
end

function FunctionClientGuide:HandleTrigger(time, deltaTime)
  if not self.trigger.dirty then
    return
  end
  local trigger = self.trigger
  self.trigger = {}
  local events = self.stepConfig.events
  if not events then
    return
  end
  for i = 1, #events do
    if self:DoTrigger(events[i], trigger) then
      return
    end
  end
end

function FunctionClientGuide:LateUpdate(time, deltaTime)
  if not self.config or not self.stepConfig then
    return
  end
  self:HandleEvents(time, deltaTime)
  self:HandleDisplay(time, deltaTime)
  self:HandleTrigger(time, deltaTime)
end

function FunctionClientGuide:SetCustomParam(key, param)
  if not self.guideParamMap then
    self.guideParamMap = {}
  end
  local parsekey = ClientGuide.ParamType[key]
  if parsekey then
    self.guideParamMap[parsekey] = param
  else
    error(string.format("Not Find Key:(%s) In ClientGuide.ParamType.", key))
  end
end

function FunctionClientGuide:TryTakeCustomParam(key)
  if not self.guideParamMap then
    return nil
  end
  local val = self.guideParamMap[key]
  self.guideParamMap[key] = nil
  return val
end

function FunctionClientGuide:ClearCustomParam()
  self.guideParamMap = nil
end
