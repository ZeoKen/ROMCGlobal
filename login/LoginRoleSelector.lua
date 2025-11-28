autoImport("CSharpObjectForLogin")
autoImport("RoleReadyForLogin")
autoImport("PersonalPhoto")
autoImport("Scene_DefaultPPEffect")
LoginRoleSelector = class("LoginRoleSelector")
LoginRoleSelector.ins = nil

function LoginRoleSelector.Ins()
  if LoginRoleSelector.ins == nil then
    LoginRoleSelector.ins = LoginRoleSelector.new()
  end
  return LoginRoleSelector.ins
end

function LoginRoleSelector:Initialize()
  if not self.isInitialized then
    self.isShowSceneAndRoles = false
    self.isInitialized = true
  end
end

function LoginRoleSelector:Reset()
  self:Release()
end

function LoginRoleSelector:Release()
  CSharpObjectForLogin.Ins():Release()
  RoleReadyForLogin.Ins():Release()
end

function LoginRoleSelector:HideSceneAndRoles()
  if self.logoAudio then
    self.logoAudio:Stop()
    self.logoAudio = nil
  end
  local transCamera = CSharpObjectForLogin.Ins():GetTransCamera()
  if not Slua.IsNull(transCamera) then
    local x, y, z = LuaGameObject.GetLocalPosition(transCamera)
    if y <= 9000 then
      transCamera.localPosition = LuaGeometry.GetTempVector3(x, y + 10000, z)
    end
  end
  if self.logoAudio then
    self.logoAudio:Stop()
    self.logoAudio = nil
  end
end

function LoginRoleSelector:ShowSceneAndRoles()
  local transCamera = CSharpObjectForLogin.Ins():GetTransCamera()
  if not Slua.IsNull(transCamera) then
    local x, y, z = LuaGameObject.GetLocalPosition(transCamera)
    if 9000 <= y then
      transCamera.localPosition = LuaGeometry.GetTempVector3(x, y - 10000, z)
    end
  end
  if self.logoAudio then
    self.logoAudio:Stop()
    self.logoAudio = nil
  end
  self.logoAudio = AudioUtility.PlayLoop_At(AudioMap.Maps.LoginRoleSelector_Enter, 0, 0, 0, AudioSourceType.BGM)
end

local enviroMentRunning
local mSetEnviroment = function(sceneName, environmentId)
  Game.EnviromentManager:Launch()
  Game.GUISystemManager:AddMonoUpdateFunction(function(self, time, deltaTime)
    Game.EnviromentManager:Update(time, deltaTime)
  end, Game.EnviromentManager)
  Game.MapManager:SetEnviroment(environmentId or 192)
  Game.EnviromentManager:_Apply()
  Game.EnviromentManager:_ApplyFog()
  if PpLua.DepthSupport() and PpLua.BloomSupport() then
    PpLua:Init({
      Camera.main
    })
    PpLua:SetEffect(sceneName)
  end
  if ROSystemInfo.DeviceRate <= 3 then
    PostprocessManager.Instance:SetMSAA(1)
  else
    PostprocessManager.Instance:SetMSAA(4)
  end
  local p = {}
  p.mainLightRenderingMode = 1
  p.mainLightShadowmapResolution = 4096
  Game.PerformanceManager:SetURPAssetParam(p)
  RoleComplete.SetShadowConfig(Asset_Role.PartShadow[3])
  enviroMentRunning = true
end

function LoginRoleSelector.SetEnviroment(sceneName, enviromentId)
  local success, errorMsg = xpcall(mSetEnviroment, debug.traceback, sceneName, enviromentId)
  if not success then
    LogUtility.Error(errorMsg)
  end
end

local mUnSetEnviroment = function(sceneName)
  if PostprocessManager.Instance then
    PostprocessManager.Instance:UnSetDefaultBloom()
  end
  PpLua:Destory()
  Game.GUISystemManager:ClearMonoUpdateFunction(Game.EnviromentManager)
  Game.EnviromentManager:Shutdown()
  enviroMentRunning = false
end

function LoginRoleSelector.UnSetEnviroment()
  local success, errorMsg = xpcall(mUnSetEnviroment, debug.traceback, sceneName)
  if not success then
    LogUtility.Error(errorMsg)
  end
end

function LoginRoleSelector:GoToCreateRole(index)
  ResourceManager.Instance:GC()
  FunctionPreload.Me():PreloadMakeRole()
  ResourceManager.Instance:SAsyncLoadScene("CharacterSelect", function()
    SceneUtil.SyncLoad("CharacterSelect")
    TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
      self:SetEnviroment("CharacterSelect")
      FunctionPreload.Me():ClearMakeRole()
      ResourceManager.Instance:SUnLoadScene("CharacterSelect", false)
    end, self)
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "CreateRoleViewV2",
      index = index
    })
  end)
end

function LoginRoleSelector:ReduceEffect(level)
  if ROSystemInfo.DeviceRate <= 2 then
    return
  end
  if 0 < level then
    local lod_tree = GameObject.Find("Lod_tree")
    if lod_tree then
      lod_tree:SetActive(false)
    end
  end
  if 1 < level then
    local p = {}
    p.additionalLightsRenderingMode = 0
    p.shadowCascadeOption = 0
    p.mainLightShadowmapResolution = 2048
    Game.PerformanceManager:SetURPAssetParam(p)
    return
  end
  if 2 < level then
    PpLua:Destory()
    self.PpEffect_SupportDOF = nil
    return
  end
end

function LoginRoleSelector:AdjustPerformanceEffect()
  Game.GameHealthProtector:SetCheckFpsFunc(15, function(averageFps)
    if 25 < averageFps then
      return
    end
    if averageFps < 12 then
      self:ReduceEffect(3)
    elseif 12 <= averageFps and averageFps < 20 then
      self:ReduceEffect(2)
    else
      self:ReduceEffect(1)
    end
  end)
end

function LoginRoleSelector:PerformanceEffect(deviceRate)
  PostprocessManager.Instance:SetMSAA(1)
  PostprocessManager.Instance:UnSetDefaultBloom()
  local resolutionIndex = ApplicationInfo.IsRunOnWindowns() and LocalSaveProxy.Instance:GetWindowsResolution() or 1
  Game.SetResolution(resolutionIndex)
  if deviceRate <= 2 then
    local p = {}
    p.additionalLightsRenderingMode = 0
    p.shadowCascadeOption = 0
    p.mainLightShadowmapResolution = 2048
    Game.PerformanceManager:SetURPAssetParam(p)
    local lod_tree = GameObject.Find("Lod_tree")
    if lod_tree then
      lod_tree:SetActive(false)
    end
    if LightMono.GlobalDirectionalLight then
      LightMono.GlobalDirectionalLight.cullingMask = LayerMask.GetMask("Default", "Terrain")
    end
    self.PpEffect_SupportDOF = false
  else
    local p = {}
    p.mainLightShadowmapResolution = 4096
    Game.PerformanceManager:SetURPAssetParam(p)
    if PpLua.DepthSupport() and PpLua.BloomSupport() then
      PpLua:Init({
        Camera.main
      })
      PpLua:SetEffect("CreateRole")
      local param = PostprocessManager.Instance:GetCurrentDepthOfFieldParam()
      param.focusDistance = 10
      PostprocessManager.Instance:UpdateDepthOfField(param)
      self.PpEffect_SupportDOF = true
    end
  end
end

function LoginRoleSelector:GoToNewCreateRole(index, finish_cb)
  local newCreateRoleScene = GameConfig.CreateRole and GameConfig.CreateRole.SceneName or "Scenesc_chuangjue"
  ResourceManager.Instance:SAsyncLoadScene(newCreateRoleScene, function()
    SceneUtil.SyncLoad(newCreateRoleScene)
    self:LoadBgmAsync(self:GetBgmName(newCreateRoleScene))
    TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
      LoginRoleSelector.SetEnviroment("CreateRole", 231)
      local viewName = GameConfig.CreateRole and GameConfig.CreateRole.ViewName or "CreateRoleView_v3"
      GameFacade.Instance:sendNotification(UIEvent.ShowUI, {viewname = viewName, index = index})
      self:PerformanceEffect(ROSystemInfo.DeviceRate)
      self:AdjustPerformanceEffect()
      FunctionPreload.Me():ClearMakeRole()
      if finish_cb then
        finish_cb()
      end
    end, self, 1)
  end)
end

function LoginRoleSelector:ClearAllEffect()
  Game.GameHealthProtector:ShutDownFpsFuncCheck()
  Shader.SetGlobalVector("ro_heightFogParams", Vector4.zero)
  if not enviroMentRunning then
    PpLua:Destory()
  end
  self.PpEffect_SupportDOF = nil
end

local default_dof_param = {
  10,
  300,
  16.4
}

function LoginRoleSelector:ChangePPEffectDepthOfField(dof_param)
  dof_param = dof_param or default_dof_param
  local param = PostprocessManager.Instance:GetCurrentDepthOfFieldParam()
  if param then
    param.focusDistance = dof_param[1]
    param.focalLength = dof_param[2]
    param.aperture = dof_param[3]
    PostprocessManager.Instance:UpdateDepthOfField(param)
  end
end

function LoginRoleSelector:CheckSupportPPEffectDepthOfField()
  return self.PpEffect_SupportDOF
end

function LoginRoleSelector:GetPPEffectDepthOfFieldParams()
  local param = PostprocessManager.Instance:GetCurrentDepthOfFieldParam()
  return param.focusDistance, param.focalLength, param.aperture
end

function LoginRoleSelector:ClearPPEffectDepthOfField()
  local param = PostprocessManager.Instance:GetCurrentDepthOfFieldParam()
  param.focusDistance = 0
  PostprocessManager.Instance:UpdateDepthOfField(param)
  if ROSystemInfo.DeviceRate <= 3 then
    PostprocessManager.Instance:SetMSAA(1)
  else
    PostprocessManager.Instance:SetMSAA(4)
  end
end

function LoginRoleSelector:LoadBgmAsync(bgmName)
  FunctionBGMCmd.Me():ReplaceCurrentBgm(bgmName)
end

function LoginRoleSelector:GetBgmName(sceneName)
  local mapBgmTable = Table_MapBgm
  sceneName = string.gsub(sceneName, "Scene", "")
  for _, mapInfo in pairs(mapBgmTable) do
    if mapInfo.NameEn == sceneName then
      return mapInfo.SceneBgm
    end
  end
  return ""
end
