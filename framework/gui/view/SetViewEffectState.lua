SetViewEffectState = class("SetViewEffectState", SetViewSubPage)
local resolutionLabTab = {}
local resolutionIndex = 1
local TargetFrameRate = {
  {
    name = ZhString.SetView_LowFrameRate,
    count = 30,
    index = 1
  },
  {
    name = ZhString.SetView_HightFrameRate,
    count = 60,
    index = 2
  },
  {
    name = ZhString.SetView_MidFrameRate,
    count = 45,
    index = 3
  }
}
local effectRateName = {
  ZhString.QualitySet_Close,
  ZhString.QualitySet_Low,
  ZhString.QualityMid,
  ZhString.QualityHigh
}
local fpsEnum = {
  Low = 1,
  High = 2,
  Mid = 3
}
local fpsLevel = {
  [1] = "Low",
  [2] = "High",
  [3] = "Mid"
}
local index2Fps = {
  [1] = 30,
  [2] = 60,
  [3] = 45
}
local qualityEnum = {
  Personal = 0,
  Low = 1,
  Mid = 2,
  High = 3
}
local effectSet = {
  Close = 1,
  Low = 2,
  High = 3
}
local qualitySetLevel = {
  [0] = "Personal",
  [1] = "Low",
  [2] = "Mid",
  [3] = "High"
}
local effectRate = {
  [1] = "Close",
  [2] = "Low",
  [3] = "High"
}
local shadowRate = {}
local antiRate = {}
local extraDelta = 35
local qualitySetRootX = 58
local qualitySetRootY = -160
local fpsRootX = 0
local fpsRootY = -290

function SetViewEffectState:Init(initParama)
  SetViewEffectState.super.Init(self, initParama)
  self:FindObj()
  self:InitFrameRateData()
  self:GetPersonalConfig()
  self:AddEvts()
  self:Show()
end

function SetViewEffectState:FindObj()
  if self:FindGO("OutlineToggle") then
    self.outlineToggle = self:FindGO("OutlineToggle"):GetComponent("UIToggle")
    self.effectToggle = self:FindGO("EffectToggle"):GetComponent("UIToggle")
    self.slimToggle = self:FindGO("SlimToggle"):GetComponent("UIToggle")
    self.weatherEffectToggle = self:FindGO("WeatherEffectToggle"):GetComponent("UIToggle")
    self.weatherEffectLab = self:FindGO("WeatherEffectSet"):GetComponent("UILabel")
    self.weatherEffectLab.text = ZhString.SetView_EffectState_WeatherEffect
    self.effectSetToggleLow = self:FindGO("EffectSetToggleLow"):GetComponent("UIToggle")
    self.effectSetToggleMid = self:FindGO("EffectSetToggleMid"):GetComponent("UIToggle")
    self.effectSetToggleHigh = self:FindGO("EffectSetToggleHigh"):GetComponent("UIToggle")
    self.effectSetToggleLow = self:FindGO("EffectSetToggleLow"):GetComponent("UIToggle")
    self.effectSetToggleMid = self:FindGO("EffectSetToggleMid"):GetComponent("UIToggle")
    self.effectSetToggleHigh = self:FindGO("EffectSetToggleHigh"):GetComponent("UIToggle")
    self.effectSetToggleRecommend = self:FindGO("EffectSetToggleRecommend"):GetComponent("UIToggle")
    self.screenCountToggleLow = self:FindGO("ScreenCountToggleLow"):GetComponent("UIToggle")
    self.screenCountToggleMid = self:FindGO("ScreenCountToggleMid"):GetComponent("UIToggle")
    self.screenCountToggleHigh = self:FindGO("ScreenCountToggleHigh"):GetComponent("UIToggle")
    self.ResolutionSet = self:FindGO("ResolutionSet")
    self.ResolutionFilter = self:FindGO("ResolutionFilter"):GetComponent("UIPopupList")
    self.targetFrameRate = self:FindGO("FrameRatePop"):GetComponent("UIPopupList")
    self.resolutionSetTempSprite = self:FindGO("ResolutionSetTempSprite")
    self.FpsFrameExtraSet = self:FindGO("FpsFrameExtraSet")
    self.FpsFrameExtraSetTitle = self:FindGO("Title", self.FpsFrameExtraSet)
    self.FpsFrameExtraSetTitle_UILabel = self.FpsFrameExtraSetTitle:GetComponent(UILabel)
    self.FpsFrameExtraSetTitle_UILabel.text = ZhString.SetView_HightFpsHint
    self.FpsFrameSet = self:FindGO("FpsFrameSet")
    self.FpsLow = self:FindGO("FpsLow", self.FpsFrameSet):GetComponent(UIToggle)
    self.FpsMid = self:FindGO("FpsMid", self.FpsFrameSet):GetComponent(UIToggle)
    self.FpsHigh = self:FindGO("FpsHigh", self.FpsFrameSet):GetComponent(UIToggle)
    self.GameEffectSet = self:FindGO("GameEffectSet")
    self.PeakEffectSet = self:FindGO("PeakEffectSet")
    self.effectSet = self:FindGO("EffectSet", self.GameEffectSet)
    if nil ~= self.effectSet then
      self:Hide(self.effectSet)
    end
    self.ScreenCountSet = self:FindGO("ScreenCountSet")
    local l_labLodWarningExtraSet = self:FindComponent("Title", UILabel, self:FindGO("LodWarningExtraSet"))
    l_labLodWarningExtraSet.text = ZhString.SetView_HightFpsHint
    self.objLodWarningMoveRoot = self:FindGO("LodWarningMoveRoot")
    self.objFpsWarningMoveRoot = self:FindGO("FpsWarningMoveRoot", self.objLodWarningMoveRoot)
    if self.resolutionSetTempSprite then
      TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
        self.resolutionSetTempSprite:SetActive(true)
      end, self)
    end
    self.peakSet = self:FindGO("PeakToggle"):GetComponent("UIToggle")
    self.qualitySetRoot = self:FindGO("QualitySet")
    self.resetBtn = self:FindGO("Reset", self.qualitySetRoot)
    self.effectQualityLow = self:FindGO("QualityLow", self.qualitySetRoot):GetComponent("UIToggle")
    self.effectQualityMid = self:FindGO("QualityMid", self.qualitySetRoot):GetComponent("UIToggle")
    self.effectQualityHigh = self:FindGO("QualityHigh", self.qualitySetRoot):GetComponent("UIToggle")
    self.effectQualityPersonal = self:FindGO("QualityPersonal", self.qualitySetRoot):GetComponent("UIToggle")
    self.antiClose = self:FindGO("AntiClose"):GetComponent("UIToggle")
    self.antiMid = self:FindGO("AntiLow"):GetComponent("UIToggle")
    self.antiHigh = self:FindGO("AntiHigh"):GetComponent("UIToggle")
    self.antiWarning = self:FindGO("AntiWarning")
    self.shadowClose = self:FindGO("ShadowClose"):GetComponent(UIToggle)
    self.shadowMid = self:FindGO("ShadowLow"):GetComponent(UIToggle)
    self.shadowHigh = self:FindGO("ShadowHigh"):GetComponent(UIToggle)
    self.objPersonalRoot = self:FindGO("PersonalSettings")
    self.bloomSet = self:FindGO("Bloom", self.objPersonalRoot)
    self.bloomBtn = self:FindGO("Background", self.bloomSet)
    self.enviroSet = self:FindGO("Enviro", self.objPersonalRoot)
    self.enviroBtn = self:FindGO("Background", self.enviroSet)
    self.shadowSetRoot = self:FindGO("Shadow", self.objPersonalRoot)
    self.effectSetRoot = self:FindGO("Effect", self.objPersonalRoot)
    self.antiSetRoot = self:FindGO("Anti", self.objPersonalRoot)
    local cameraCtlObj = self:FindGO("CameraControl")
    local cameraSettingLab = self:FindGO("CameraControlCount", cameraCtlObj):GetComponent(UILabel)
    cameraSettingLab.text = ZhString.CameraSetting
    self.objBtnCameraGuide = self:FindGO("btnCameraGuide", cameraCtlObj)
    local objCameraToggle = self:FindGO("LockToggle", cameraCtlObj)
    self.cameraLockCtlToggle = objCameraToggle:GetComponent(UIToggle)
    local labCameraCtlName = self:FindGO("Label", objCameraToggle):GetComponent(UILabel)
    labCameraCtlName.text = ZhString.LockCameraCtl
    objCameraToggle = self:FindGO("2.5DToggle", cameraCtlObj)
    self.camera25DCtlToggle = objCameraToggle:GetComponent(UIToggle)
    labCameraCtlName = self:FindGO("Label", objCameraToggle):GetComponent(UILabel)
    labCameraCtlName.text = ZhString.Half3DCtl
    objCameraToggle = self:FindGO("3DToggle", cameraCtlObj)
    self.camera3DCtlToggle = objCameraToggle:GetComponent(UIToggle)
    labCameraCtlName = self:FindGO("Label", objCameraToggle):GetComponent(UILabel)
    labCameraCtlName.text = ZhString.Real3DCtl
    if GameConfig.SystemForbid.FreeCamera then
      cameraCtlObj:SetActive(false)
    end
    if GameConfig.System.Camera3D == 1 then
      self.camera3DCtlToggle.gameObject:SetActive(false)
    end
    self.SavingMode = self:FindGO("SavingMode")
    self.SavingModeToggle = self:FindGO("SavingMode/SavingModeToggle"):GetComponent(UIToggle)
    if ApplicationInfo.IsRunOnWindowns() then
      self.ResolutionSet:SetActive(true)
      self.ResolutionSet.transform.localPosition = LuaGeometry.GetTempVector3(58, 160, 0)
      self.objLodWarningMoveRoot.transform.localPosition = LuaGeometry.GetTempVector3(0, 140, 0)
    else
      self.ResolutionSet:SetActive(false)
    end
  end
end

function SetViewEffectState:OnEnter()
  SetViewEffectState.super.OnEnter(self)
  self.OnEnterTag = true
  self.ExtraCount = 0
end

function SetViewEffectState:OnExit()
  local setting = FunctionPerformanceSetting.Me()
  local rateKey = setting:GetSetting().targetFrameRate
  ApplicationInfo.SetTargetFrameRate(index2Fps[rateKey])
  self.ExtraCount = 0
  self.OnEnterTag = false
  self.IsSettingInited = false
  SetViewEffectState.super.OnExit(self)
end

function SetViewEffectState:InitFrameRateData()
  self.targetFrameRate:Clear()
  for i = 1, #TargetFrameRate do
    local single = TargetFrameRate[i]
    self.targetFrameRate:AddItem(single.name, single)
  end
  self.frameRateIndex = FunctionPerformanceSetting.Me():GetSetting().targetFrameRate
end

function SetViewEffectState:SetPersonalUI()
  local setting = FunctionPerformanceSetting.Me()
  local shadowRate = self.shadowRate
  local effRate = self.effRate
  local antiRate = self.antiRate
  local bloomSprt = self:FindGO("BloomImg", self.bloomSet)
  local cover = self:FindGO("Cover", self.bloomSet)
  if self.showBloom then
    if nil ~= cover then
      cover:SetActive(false)
    end
    TweenPosition.Begin(bloomSprt, 0, LuaGeometry.GetTempVector3(22, 0, 0)).method = 2
  else
    if nil ~= cover then
      cover:SetActive(true)
    end
    TweenPosition.Begin(bloomSprt, 0, LuaGeometry.GetTempVector3(-22, 0, 0)).method = 2
  end
  for i = 1, 3 do
    local obj = self:FindGO("Shadow" .. effectRate[i], self.shadowSetRoot):GetComponent("UIToggle")
    obj.value = shadowRate + 1 == i
  end
  for i = 1, 3 do
    local obj = self:FindGO("Effect" .. effectRate[i], self.effectSetRoot):GetComponent("UIToggle")
    obj.value = effRate + 1 == i
  end
  for i = 1, 3 do
    local obj = self:FindGO("Anti" .. effectRate[i], self.antiSetRoot):GetComponent("UIToggle")
    obj.value = antiRate == i
  end
end

function SetViewEffectState:ResetDefaultConfig()
  local setting = FunctionPerformanceSetting.Me()
  setting:ResetQualityConfig()
end

function SetViewEffectState:GetExtraCount()
  local fpsFlag = self.FpsFrameExtraSet.activeSelf == true and 1 or 0
  local antiFlag = self.antiRate == 3 and 1 or 0
  self.ExtraCount = fpsFlag + antiFlag
end

function SetViewEffectState:AddEvts()
  EventDelegate.Add(self.ResolutionFilter.onChange, function()
    resolutionIndex = resolutionLabTab[self.ResolutionFilter.value]
    if ApplicationInfo.IsRunOnWindowns() then
      local saveIndex = LocalSaveProxy.Instance:GetWindowsResolution()
      if saveIndex == resolutionIndex then
        return
      end
      LocalSaveProxy.Instance:SetWindowsResolution(resolutionIndex)
      Game.SetResolution(resolutionIndex)
    end
  end)
  EventDelegate.Add(self.targetFrameRate.onChange, function()
    local data = self.targetFrameRate.data
    if data.count == self.currentRate or not self.objFpsWarningMoveRoot then
      return
    end
    self.currentRate = data.count
    local isUseTween = self.OnEnterTag and self.IsSettingInited
    if self.OnEnterTag then
      ApplicationInfo.SetTargetFrameRate(data.count)
    end
    self.FpsFrameExtraSet:SetActive(data.count == 60)
  end)
  EventDelegate.Add(self.SavingModeToggle.onChange, function()
    self:NotifySaveStatus()
  end)
  EventDelegate.Add(self.screenCountToggleLow.onChange, function()
    self:NotifySaveStatus()
  end)
  EventDelegate.Add(self.screenCountToggleMid.onChange, function()
    self:NotifySaveStatus()
  end)
  EventDelegate.Add(self.screenCountToggleHigh.onChange, function()
    self:NotifySaveStatus()
  end)
  EventDelegate.Add(self.peakSet.onChange, function()
    self:NotifySaveStatus()
  end)
  EventDelegate.Add(self.outlineToggle.onChange, function()
    self:NotifySaveStatus()
  end)
  EventDelegate.Add(self.slimToggle.onChange, function()
    self:NotifySaveStatus()
  end)
  EventDelegate.Add(self.weatherEffectToggle.onChange, function()
    self:NotifySaveStatus()
  end)
  EventDelegate.Add(self.cameraLockCtlToggle.onChange, function()
    self:NotifySaveStatus()
  end)
  EventDelegate.Add(self.camera25DCtlToggle.onChange, function()
    self:NotifySaveStatus()
  end)
  EventDelegate.Add(self.camera3DCtlToggle.onChange, function()
    self:NotifySaveStatus()
  end)
  for i = 1, 3 do
    local fpsSelect = self:FindGO("Fps" .. fpsLevel[i], self.FpsFrameSet)
    self:AddClickEvent(fpsSelect, function(go)
      local index = string.gsub(go.name, "Fps", "")
      local value = fpsEnum[index]
      local rate = index2Fps[value]
      if self.OnEnterTag then
        ApplicationInfo.SetTargetFrameRate(rate)
      end
      for j = 1, 3 do
        local fpsSelect = self:FindGO("Fps" .. fpsLevel[j], self.FpsFrameSet):GetComponent(UIToggle)
        fpsSelect.value = j == value
      end
      self.frameRateIndex = value
      self.FpsFrameExtraSet:SetActive(rate == 60)
      self:GetExtraCount()
      self:SetFpsTween(rate == 60)
      self:NotifySaveStatus()
    end)
  end
  for i = 0, 3 do
    local qualitySelect = self:FindGO("Quality" .. qualitySetLevel[i], self.qualitySetRoot)
    self:AddClickEvent(qualitySelect, function(go)
      local index = string.gsub(go.name, "Quality", "")
      local value = qualityEnum[index]
      for j = 0, 3 do
        local qualitySelect = self:FindGO("Quality" .. qualitySetLevel[j], self.qualitySetRoot):GetComponent(UIToggle)
        qualitySelect.value = j == value
      end
      self.qualityLevel = value
      if value ~= 0 then
        self.lastQuality = value
      end
      self:GetPersonalConfig()
      self:SetPersonalUI()
      self:NotifySaveStatus()
    end)
  end
  for i = 1, 3 do
    local shadowSelect = self:FindGO("Shadow" .. effectRate[i], self.shadowSetRoot)
    self:AddClickEvent(shadowSelect, function(go)
      local index = string.gsub(go.name, "Shadow", "")
      local value = effectSet[index]
      for j = 1, 3 do
        local shadowSelect = self:FindGO("Shadow" .. effectRate[j], self.shadowSetRoot):GetComponent("UIToggle")
        shadowSelect.value = j == value
      end
      self.shadowRate = value - 1
      self:CheckPersonal("shadow", self.shadowRate)
      self:NotifySaveStatus()
    end)
  end
  for i = 1, 3 do
    local effectSelect = self:FindGO("Effect" .. effectRate[i], self.effectSetRoot)
    self:AddClickEvent(effectSelect, function(go)
      local index = string.gsub(go.name, "Effect", "")
      local value = effectSet[index]
      for j = 1, 3 do
        local effectSelect = self:FindGO("Effect" .. effectRate[j], self.effectSetRoot):GetComponent("UIToggle")
        effectSelect.value = j == value
      end
      self.effRate = value - 1
      self:CheckPersonal("effect", self.effRate)
      self:NotifySaveStatus()
    end)
  end
  for i = 1, 3 do
    local antiSelect = self:FindGO("Anti" .. effectRate[i], self.antiSetRoot)
    self:AddClickEvent(antiSelect, function(go)
      local index = string.gsub(go.name, "Anti", "")
      local value = effectSet[index]
      for j = 1, 3 do
        local antiSelect = self:FindGO("Anti" .. effectRate[j], self.antiSetRoot):GetComponent("UIToggle")
        antiSelect.value = j == value
      end
      self.antiRate = value
      local tweenTime = 0.5
      self:GetExtraCount()
      TweenPosition.Begin(self.objFpsWarningMoveRoot, tweenTime, LuaGeometry.GetTempVector3(fpsRootX, fpsRootY - self.ExtraCount * extraDelta, 0)).method = 2
      self:CheckPersonal("anti", self.antiRate)
      self:NotifySaveStatus()
    end)
  end
  self:AddClickEvent(self.bloomBtn, function()
    local isUseTween = self.OnEnterTag and self.IsSettingInited
    local bloomSprt = self:FindGO("BloomImg", self.bloomSet)
    local cover = self:FindGO("Cover", self.bloomSet)
    local setting = FunctionPerformanceSetting.Me()
    self.showBloom = not self.showBloom
    if self.showBloom then
      if nil ~= cover then
        cover:SetActive(false)
      end
      TweenPosition.Begin(bloomSprt, isUseTween and 0.05 or 0, LuaGeometry.GetTempVector3(22, 0, 0)).method = 2
    else
      if nil ~= cover then
        cover:SetActive(true)
      end
      TweenPosition.Begin(bloomSprt, isUseTween and 0.05 or 0, LuaGeometry.GetTempVector3(-22, 0, 0)).method = 2
    end
    self:CheckPersonal("bloom", self.showBloom)
    self:NotifySaveStatus()
  end)
  self:AddClickEvent(self.enviroBtn, function()
    MsgManager.ShowMsgByID(854)
  end)
  self:AddClickEvent(self.objBtnCameraGuide, function()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.CameraGuidePopUp
    })
  end)
end

function SetViewEffectState:SetFpsTween(active)
  local tweenTime = 0.5
  if active then
    TweenPosition.Begin(self.qualitySetRoot, tweenTime, LuaGeometry.GetTempVector3(qualitySetRootX, qualitySetRootY - extraDelta, 0)).method = 2
    TweenPosition.Begin(self.objFpsWarningMoveRoot, tweenTime, LuaGeometry.GetTempVector3(fpsRootX, fpsRootY - self.ExtraCount * extraDelta, 0)).method = 2
  else
    TweenPosition.Begin(self.qualitySetRoot, tweenTime, LuaGeometry.GetTempVector3(qualitySetRootX, qualitySetRootY, 0)).method = 2
    TweenPosition.Begin(self.objFpsWarningMoveRoot, tweenTime, LuaGeometry.GetTempVector3(fpsRootX, fpsRootY - self.ExtraCount * extraDelta, 0)).method = 2
  end
end

function SetViewEffectState:CheckPersonal(type, value)
  local setting = FunctionPerformanceSetting.Me()
  local result = setting:IsPersonal(self.qualityLevel, type, value)
  for i = 0, 3 do
    local qualitySelect = self:FindGO("Quality" .. qualitySetLevel[i], self.qualitySetRoot):GetComponent("UIToggle")
    if i ~= 0 then
      if result then
        qualitySelect.value = false
        self.qualityLevel = 0
        self.lastQuality = 0
      else
        qualitySelect.value = qualitySelect.value
      end
    else
      qualitySelect.value = result and true or false
    end
  end
end

function SetViewEffectState:SettingUI()
  self.IsSettingInited = false
  if self.ResolutionFilter then
    self.ResolutionFilter:Clear()
    resolutionLabTab = {}
    local tab = Game.GetResolutionNames()
    for i = 1, #tab do
      local str = tab[i]
      self.ResolutionFilter:AddItem(str)
      resolutionLabTab[str] = i
    end
    local setting = FunctionPerformanceSetting.Me()
    local screenCount = setting:GetSetting().screenCount
    local effectLv = setting:GetSetting().effectLv
    self.outlineToggle.value = setting:GetSetting().outLine
    self.slimToggle.value = setting:GetSetting().slim
    self.weatherEffectToggle.value = setting:GetSetting().weatherEffect
    local rateKey = setting:GetSetting().targetFrameRate
    self.FpsLow.value = rateKey == fpsEnum.Low
    self.FpsHigh.value = rateKey == fpsEnum.High
    self.FpsMid.value = rateKey == fpsEnum.Mid
    local isHighFps = rateKey == fpsEnum.High
    self.FpsFrameExtraSet:SetActive(isHighFps)
    self:GetExtraCount()
    self:SetFpsTween(isHighFps)
    if ApplicationInfo.IsRunOnWindowns() then
      resolutionIndex = LocalSaveProxy.Instance:GetWindowsResolution()
    else
      resolutionIndex = setting:GetSetting().resolution
    end
    self.ResolutionFilter.value = tab[resolutionIndex]
    local screenCountLevel = setting:GetScreenCountLevel(screenCount)
    self.screenCountToggleMid.value = screenCountLevel == EScreenCountLevel.Mid and true or false
    self.screenCountToggleHigh.value = screenCountLevel == EScreenCountLevel.High and true or false
    self.screenCountToggleLow.value = screenCountLevel == EScreenCountLevel.Low and true or false
    self.effectSetToggleLow.value = effectLv == LogicManager_MapCell.LODLevel.Low and true or false
    self.effectSetToggleMid.value = effectLv == LogicManager_MapCell.LODLevel.Mid and true or false
    self.effectSetToggleHigh.value = effectLv == LogicManager_MapCell.LODLevel.High and true or false
    self.effectSetToggleRecommend.value = effectLv == 3 and true or false
    self.peakSet.value = setting:GetPeak()
    local quality = setting:GetQualitySet()
    self.effectQualityLow.value = quality == qualityEnum.Low
    self.effectQualityMid.value = quality == qualityEnum.Mid
    self.effectQualityHigh.value = quality == qualityEnum.High
    self.effectQualityPersonal.value = quality == qualityEnum.Personal
    self:SetPersonalUI()
    if setting:GetSetting().disableFreeCamera then
      self.cameraLockCtlToggle.value = true
    elseif setting:GetSetting().disableFreeCameraVert then
      self.camera25DCtlToggle.value = true
    else
      self.camera3DCtlToggle.value = true
    end
    self.SavingModeToggle.value = setting:GetSetting().powerMode
    self.SavingMode:SetActive(not ApplicationInfo.IsRunOnWindowns())
  end
  self.IsSettingInited = true
end

function SetViewEffectState:GetPersonalConfig()
  local setting = FunctionPerformanceSetting.Me()
  if self.qualityLevel == nil then
    self.qualityLevel = setting:GetQualitySet()
  end
  if self.qualityLevel ~= qualityEnum.Personal then
    local qualityConfig = setting:GetQualityConfig(self.qualityLevel)
    self.showBloom = qualityConfig.bloom
    self.shadowRate = qualityConfig.shadow
    self.antiRate = qualityConfig.anti
    self.effRate = qualityConfig.effect
    self.fxaa = qualityConfig.fxaa
  elseif self.lastQuality and self.lastQuality ~= qualityEnum.Personal then
    local lastConfig = setting.qualitySetConfig[self.lastQuality]
    self.showBloom = lastConfig.bloom
    self.shadowRate = lastConfig.shadow
    self.antiRate = lastConfig.anti
    self.effRate = lastConfig.effect
    self.fxaa = lastConfig.fxaa
  else
    self.showBloom = setting:GetBloom()
    self.shadowRate = setting:GetShadowRate()
    self.antiRate = setting:GetAntiRate()
    self.effRate = setting:GetEffectLv()
    self.fxaa = setting:GetFxaa()
  end
end

function SetViewEffectState:Show()
  self:SettingUI()
  self:ShowFpsFrameHintMsgBox()
end

function SetViewEffectState:ShowFpsFrameHintMsgBox()
  if BranchMgr.IsJapan() then
    return
  end
  local setting = FunctionPerformanceSetting.Me()
  local isFPSShow = setting:GetSetting().showFpsFrameHint
  if isFPSShow then
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "PetPackagePopView",
      viewdata = {msgid = 27180}
    })
  end
end

function SetViewEffectState:SetNormalModeData()
  local setting = FunctionPerformanceSetting.Me()
  local screenCount
  if self.screenCountToggleMid.value == true then
    screenCount = FunctionPerformanceSetting.Me():GetScreenCountByLevel(EScreenCountLevel.Mid)
  elseif self.screenCountToggleHigh.value == true then
    screenCount = FunctionPerformanceSetting.Me():GetScreenCountByLevel(EScreenCountLevel.High)
  else
    screenCount = FunctionPerformanceSetting.Me():GetScreenCountByLevel(EScreenCountLevel.Low)
  end
  setting:SetBegin()
  setting:SetOutLine(self.outlineToggle.value)
  setting:SetSlim(self.slimToggle.value)
  setting:SetWeatherEffect(self.weatherEffectToggle.value)
  setting:SetScreenCount(screenCount)
  setting:SetFrameRate(self.frameRateIndex)
  setting:SetPeak(self.peakSet.value)
  setting:SetQualityLevel(self.qualityLevel)
  setting:SetBloom(self.showBloom)
  if self.qualityLevel == qualityEnum.Personal then
    setting:SetBloom(self.showBloom)
    setting:SetShadow(self.shadowRate)
    setting:SetAnti(self.antiRate)
    setting:SetEffectLv(self.effRate)
    setting:SetFxaa(self.fxaa)
  else
    local config = setting.qualitySetConfig[self.qualityLevel]
    setting:SetBloom(config.bloom)
    setting:SetShadow(config.shadow)
    setting:SetAnti(config.anti)
    setting:SetEffectLv(config.effect)
    setting:SetFxaa(config.fxaa)
  end
  if not BackwardCompatibilityUtil.CompatibilityMode_V9 then
    setting:SetPowerMode(self.SavingModeToggle.value)
  end
  setting:SetLockCamera(self.cameraLockCtlToggle.value)
  setting:SetLockFreeCameraVert(self.camera25DCtlToggle.value)
  setting:SetEnd()
end

function SetViewEffectState:NotifySaveStatus()
  EventManager.Me():PassEvent(SetViewEvent.SaveBtnStatus, self:IsChanged())
end

function SetViewEffectState:IsChanged()
  if not self:FindGO("OutlineToggle") then
    return false
  end
  local setting = FunctionPerformanceSetting.Me()
  setting:SetBegin()
  local oldSetting = setting.oldSetting
  local screenCount
  if self.screenCountToggleMid.value == true then
    screenCount = FunctionPerformanceSetting.Me():GetScreenCountByLevel(EScreenCountLevel.Mid)
  elseif self.screenCountToggleHigh.value == true then
    screenCount = FunctionPerformanceSetting.Me():GetScreenCountByLevel(EScreenCountLevel.High)
  else
    screenCount = FunctionPerformanceSetting.Me():GetScreenCountByLevel(EScreenCountLevel.Low)
  end
  local isChanged = false
  if self.outlineToggle.value ~= oldSetting.outLine then
    isChanged = true
  end
  if self.slimToggle.value ~= oldSetting.slim then
    isChanged = true
  end
  if self.weatherEffectToggle.value ~= oldSetting.weatherEffect then
    isChanged = true
  end
  if self.frameRateIndex ~= oldSetting.targetFrameRate then
    isChanged = true
  end
  if self.peakSet.value ~= oldSetting.showPeak then
    isChanged = true
  end
  if self.qualityLevel ~= oldSetting.qualityLevel then
    isChanged = true
  end
  if self.showBloom ~= oldSetting.showBloom then
    isChanged = true
  end
  if self.shadowRate ~= oldSetting.shadowRate then
    isChanged = true
  end
  if self.antiRate ~= oldSetting.antiRate then
    isChanged = true
  end
  if self.effRate ~= oldSetting.effectLv then
    isChanged = true
  end
  if screenCount ~= oldSetting.screenCount then
    isChanged = true
  end
  if self.SavingModeToggle.value ~= oldSetting.powerMode then
    isChanged = true
  end
  if self.cameraLockCtlToggle.value ~= oldSetting.disableFreeCamera then
    isChanged = true
  end
  if self.camera25DCtlToggle.value ~= oldSetting.disableFreeCameraVert then
    isChanged = true
  end
  return isChanged
end

function SetViewEffectState:Save()
  self:SetNormalModeData()
end
