autoImport("PpLua")
autoImport("EnviromentInfo")
autoImport("EnviromentAnimation_Base")
autoImport("EnviromentAnimation_Fog")
autoImport("EnviromentAnimation_Weather")
autoImport("Scene_DefaultPPEffect")
EnviromentManager = class("EnviromentManager")
EnviromentManager.UIRoleBloom = {
  bExposure = false,
  clamp = 65472,
  index = 0,
  intensity = 0.75,
  scatter = 0.9,
  threshold = 0.6,
  toneMapAces = 0
}
local NumberAlmostEqualWithDiff = NumberUtility.AlmostEqualWithDiff
local UpdateInterval = 0.1
local UpdateVolumeFogFrameInterval = 3
local ArrayClear = TableUtility.ArrayClear
local ArrayFindIndex = TableUtility.ArrayFindIndex
local ArrayRemove = TableUtility.ArrayRemove
local ArraySortedInsert = TableUtility.InsertSort
local GetChangedNumberWithDiff = function(prev, new, diff)
  if nil ~= prev and NumberAlmostEqualWithDiff(prev, new, diff) then
    return nil
  end
  return new
end

function EnviromentManager.ResetAmbientLight()
  Shader.SetGlobalColor("_LightModel_Ambient", LuaGeometry.Const_Col_white)
end

function EnviromentManager.SetToneMapAcesParam(f)
  Shader.SetGlobalFloat("_UBER_TONEMAP_ACE_A", f)
end

local sunDir = Vector4(0, 0, 1.0, 0)
local sunColor = LuaColor.White()
local colorWhite = LuaColor.White()

function EnviromentManager.ApplyGlobal(info, applyArgs, prevInfo)
  sunDir = LuaGeometry.GetTempVector4(0, 0, 1.0, 0, sunDir)
  sunColor:Set(1.0, 1.0, 1.0, 1.0)
  if info ~= nil then
    if info.sunDir ~= nil then
      sunDir.x = info.sunDir[1] or 0
      sunDir.y = info.sunDir[2] or 0
      sunDir.z = info.sunDir[3] or 1.0
    end
    if info.sunColor ~= nil then
      LuaColorUtility.Asign(sunColor, info.sunColor)
    end
    if info.sheenColor ~= nil then
      LuaColorUtility.Asign(sheenColor, info.sheenColor)
    end
  end
  Shader.SetGlobalColor("ro_SunColor", sunColor)
  Shader.SetGlobalVector("ro_SunDir", sunDir)
end

function EnviromentManager.ApplyLighting(info, applyArgs, prevInfo)
  if nil ~= info and info.enable then
    RenderSettings.ambientMode = info.ambientMode
    if AmbientMode.Skybox == info.ambientMode or AmbientMode.Flat == info.ambientMode then
      Shader.SetGlobalColor("_LightModel_Ambient", info.ambientLight)
    elseif AmbientMode.Trilight == info.ambientMode then
      RenderSettings.ambientSkyColor = info.ambientSkyColor
      RenderSettings.ambientEquatorColor = info.ambientEquatorColor
      RenderSettings.ambientGroundColor = info.ambientGroundColor
    end
    RenderSettings.ambientIntensity = info.ambientIntensity
    RenderSettings.defaultReflectionMode = info.defaultReflectionMode
    if DefaultReflectionMode.Custom == info.defaultReflectionMode then
      applyArgs.assetPathCustomRelection = info.customReflection
    end
    RenderSettings.defaultReflectionResolution = info.defaultReflectionResolution
    RenderSettings.reflectionBounces = info.reflectionBounces
    RenderSettings.reflectionIntensity = info.reflectionIntensity
  else
    RenderSettings.ambientMode = AmbientMode.Flat
    RenderSettings.skybox = nil
    RenderSettings.ambientIntensity = 1
    Shader.SetGlobalColor("_LightModel_Ambient", LuaGeometry.Const_Col_white)
    RenderSettings.defaultReflectionMode = DefaultReflectionMode.Skybox
    RenderSettings.defaultReflectionResolution = 128
    RenderSettings.reflectionBounces = 0
    RenderSettings.reflectionIntensity = 0
  end
end

local globalFogParams = Vector4(0, 0, 0, 0)
local heightFogParams = Vector4(0, 0, 0, 0)
local heightFogCenter = Vector4(0, 0, 0, 0)
local scatteringParams = Vector4(0, 0, 0, 0)
local nearFogParams = Vector4(0, 0, 0, 0)
local farFogParams = Vector4(0, 0, 0, 0)
local localHeightFogParams = Vector4(0, 0, 0, 0)
local localHeightFogColor = Vector4(0, 0, 0, 0)
local HeightFogMode = {
  None = 0,
  Flat = 1,
  Sphere = 2
}
EnviromentManager.HeightFogMode = HeightFogMode
local linearFogOffset = 0

function EnviromentManager.ApplyFog(info, applyArgs, prevInfo)
  globalFogParams = LuaGeometry.GetTempVector4(0, 0, 0, 0, globalFogParams)
  heightFogParams = LuaGeometry.GetTempVector4(0, 0, 0, 0, heightFogParams)
  heightFogCenter = LuaGeometry.GetTempVector4(0, 0, 0, 0, heightFogCenter)
  scatteringParams = LuaGeometry.GetTempVector4(0, 0, 0, 0, scatteringParams)
  nearFogParams = LuaGeometry.GetTempVector4(0, 0, 0, 0, nearFogParams)
  farFogParams = LuaGeometry.GetTempVector4(0, 0, 0, 0, farFogParams)
  localHeightFogParams = LuaGeometry.GetTempVector4(0, 0, 0, 0, localHeightFogParams)
  localHeightFogColor = LuaGeometry.GetTempVector4(0, 0, 0, 0, localHeightFogColor)
  local enableFlatHeightMap = 0
  local enableSphereHeightMap = 0
  if nil ~= info and info.enable then
    RenderSettings.fog = info.fog
    RenderSettings.fogColor = info.fogColor
    RenderSettings.fogMode = info.fogMode
    if FogMode.Linear == info.fogMode then
      RenderSettings.fogStartDistance = info.fogStartDistance + linearFogOffset
      RenderSettings.fogEndDistance = info.fogEndDistance + linearFogOffset
    else
      RenderSettings.fogDensity = info.fogDensity
    end
    globalFogParams.x = info.globalFogTuner or 0
    if info.heightFogMode and info.heightFogMode ~= HeightFogMode.None then
      if info.heightFogMode == HeightFogMode.Flat then
        globalFogParams.y = 1.0
        scatteringParams.x = info.scatteringDensity or 0
        scatteringParams.y = info.scatteringFalloff or 0
        scatteringParams.z = info.scatteringExponent or 0
        scatteringParams.w = info.heightFogMinOpacity or 0
      elseif info.heightFogMode == HeightFogMode.Sphere then
        globalFogParams.z = 1.0
        if info.sphereCenter then
          heightFogCenter.x = info.sphereCenter.x or 0
          heightFogCenter.y = info.sphereCenter.y or 0
          heightFogCenter.z = info.sphereCenter.z or 0
        end
      end
      local heightFogCutoff = info.heightFogCutoff or 0.001
      if heightFogCutoff <= 0 then
        heightFogCutoff = 0.001
      end
      heightFogCutoff = 1.0 / heightFogCutoff
      heightFogParams.y = heightFogCutoff
      local heightFogStart = info.heightFogStart or 1000
      local heightFogEnd = info.heightFogEnd or 1000.01
      if heightFogStart >= heightFogEnd then
        heightFogEnd = heightFogStart + 0.01
      end
      heightFogEnd = heightFogEnd - heightFogStart
      heightFogParams.z = 1.0 / heightFogEnd
      heightFogParams.w = -heightFogStart / heightFogEnd
    end
    globalFogParams.w = info.radiusFogFactor or 0
    if 0 < globalFogParams.w then
      local radiusFogScale = 0
      local radiusFogOffset = 0
      local nearFogDistance = info.nearFogDistance and info.nearFogDistance + linearFogOffset or 0
      local farFogDistance = info.farFogDistance and info.farFogDistance + linearFogOffset or 0
      local delta = farFogDistance - nearFogDistance
      if 0 < delta then
        radiusFogScale = 1.0 / delta
        radiusFogOffset = -nearFogDistance / delta
      end
      if info.nearFogColor then
        nearFogParams.x = info.nearFogColor.r or 0
        nearFogParams.y = info.nearFogColor.g or 0
        nearFogParams.z = info.nearFogColor.b or 0
        nearFogParams.w = radiusFogOffset
      end
      if info.farFogColor then
        farFogParams.x = info.farFogColor.r or 0
        farFogParams.y = info.farFogColor.g or 0
        farFogParams.z = info.farFogColor.b or 0
        farFogParams.w = radiusFogScale
      end
    end
    localHeightFogParams.x = info.enableLocalHeightFog or 0
    localHeightFogParams.y = info.localHeightFogStart or 0
    localHeightFogParams.z = (info.localHeightFogEnd or 1) - localHeightFogParams.y
    localHeightFogParams.w = 0
    if info.localHeightFogColor then
      localHeightFogColor.x = info.localHeightFogColor.r or 0
      localHeightFogColor.y = info.localHeightFogColor.g or 0
      localHeightFogColor.z = info.localHeightFogColor.b or 0
      localHeightFogColor.w = 1
    end
  else
    RenderSettings.fog = false
  end
  Shader.SetGlobalVector("ro_globalFogParams", globalFogParams)
  Shader.SetGlobalVector("ro_heightFogParams", heightFogParams)
  Shader.SetGlobalVector("ro_heightFogCenter", heightFogCenter)
  Shader.SetGlobalVector("ro_heightFogParams2", scatteringParams)
  Shader.SetGlobalVector("ro_NearFogColor", nearFogParams)
  Shader.SetGlobalVector("ro_FarFogColor", farFogParams)
  Shader.SetGlobalVector("ro_localHeightFogParams", localHeightFogParams)
  Shader.SetGlobalVector("ro_localHeightFogColor", localHeightFogColor)
  if 0 < localHeightFogParams.x then
    Shader.EnableKeyword("LOCAL_HEIGHT_FOG")
  else
    Shader.DisableKeyword("LOCAL_HEIGHT_FOG")
  end
end

local sheenParams = Vector4(0, 0, 0, 0)
local windParams1 = Vector4(0, 0, 0, 0)
local windParams2 = Vector4(0, 0, 0, 0)
local windTexTiling = Vector4(1, 1, 0, 0)
local sheenNearColor = LuaColor.Black()
local sheenFarColor = LuaColor.Black()

function EnviromentManager.ApplyWind(info, applyArgs, prevInfo)
  sheenParams = LuaGeometry.GetTempVector4(0, 0, 0, 0, sheenParams)
  windParams1 = LuaGeometry.GetTempVector4(0, 0, 0, 0, windParams1)
  windParams2 = LuaGeometry.GetTempVector4(0, 0, 0, 0, windParams2)
  windTexTiling = LuaGeometry.GetTempVector4(1, 1, 0, 0, windTexTiling)
  LuaColor.Better_Set(sheenNearColor, 0, 0, 0, 1)
  LuaColor.Better_Set(sheenFarColor, 0, 0, 0, 1)
  if nil ~= info and info.enable then
    if info.sheenColorNear ~= nil then
      local tempC = info.sheenColorNear
      LuaColor.Better_Set(sheenNearColor, tempC[1] or 0, tempC[2] or 0, tempC[3] or 0, tempC[4] or 1)
    end
    if info.sheenColorFar ~= nil then
      local tempC = info.sheenColorFar
      LuaColor.Better_Set(sheenFarColor, tempC[1] or 0, tempC[2] or 0, tempC[3] or 0, tempC[4] or 1)
    end
    if info.windTexTiling ~= nil then
      local tiling = info.windTexTiling
      windTexTiling = LuaGeometry.GetTempVector4(tiling[1] or 1, tiling[2] or 1, tiling[3] or 0, tiling[4] or 0, windTexTiling)
    end
    sheenParams[1] = info.sheenDistanceNear or 0
    sheenParams[2] = info.sheenDistanceFar or 0
    sheenParams[3] = info.sheenScatterMinInten or 0
    sheenParams[4] = info.sheenPower or 0
    windParams1[1] = info.windAngle or 0
    windParams1[2] = info.windWaveSpeed or 0
    windParams1[3] = info.windBendStrength or 0
    windParams1[4] = info.windWaveSwingEffect or 0
    windParams2[1] = info.windMask or 0
    windParams2[2] = info.windSheenInten or 0
    windParams2[3] = info.windWaveDisorderFreq or 0
  end
  Shader.SetGlobalColor("_SheenColorNear", sheenNearColor)
  Shader.SetGlobalColor("_SheenColorFar", sheenFarColor)
  Shader.SetGlobalVector("_WindTexTiling", windTexTiling)
  Shader.SetGlobalVector("_SheenParams", sheenParams)
  Shader.SetGlobalVector("_WindParams1", windParams1)
  Shader.SetGlobalVector("_WindParams2", windParams2)
end

function EnviromentManager.ApplyFlare(info, applyArgs, prevInfo)
  if nil ~= info and info.enable then
    local n = GetChangedNumberWithDiff(prevInfo.flareFadeSpeed, info.flareFadeSpeed, 1)
    if nil ~= n then
      RenderSettings.flareFadeSpeed = n
      prevInfo.flareFadeSpeed = n
    end
    n = GetChangedNumberWithDiff(prevInfo.flareStrength, info.flareStrength, 0.1)
    if nil ~= n then
      RenderSettings.flareStrength = n
      prevInfo.flareStrength = n
    end
  else
    RenderSettings.flareFadeSpeed = 0
    RenderSettings.flareStrength = 0
    prevInfo.flareFadeSpeed = nil
    prevInfo.flareStrength = nil
  end
end

local defaultSkyBoxMat = Material(Shader.Find("RO/Clear"))

function EnviromentManager.ApplySkybox(info, applyArgs, prevInfo)
  local skyboxCamera = applyArgs.skyboxCamera
  local skyboxMaterial = applyArgs.skyboxMaterial
  if nil ~= info and info.enable and nil ~= skyboxCamera then
    if RenderSettings.skybox == nil then
      RenderSettings.skybox = defaultSkyBoxMat
    end
    if SkyboxType.SolidColor == info.type or nil == skyboxMaterial then
      skyboxCamera.clearFlags = CameraClearFlags.Color
      skyboxCamera.backgroundColor = info.skyTint
      EnviromentManager.ClearSkybox_Sun(info, applyArgs, prevInfo)
    else
      local shaderManager = Game.ShaderManager
      skyboxCamera.clearFlags = CameraClearFlags.Skybox
      if SkyboxType.CubemapOnly == info.type then
        if shaderManager.skyboxCubemap ~= skyboxMaterial.shader then
          skyboxMaterial.shader = shaderManager.skyboxCubemap
        end
        applyArgs.assetPathSkyboxCubemap = info.cubemap
        applyArgs.assetPathSkyboxCubemapAlpha = info.cubemapAlpha
        skyboxMaterial:SetFloat("_Rotation", info.cubemapRotation)
        skyboxMaterial:SetColor("_Tint", info.cubemapTint)
        skyboxMaterial:SetFloat("_Exposure", info.exposure)
      elseif SkyboxType.Procedural == info.type then
        if shaderManager.skyboxProcedural ~= skyboxMaterial.shader then
          skyboxMaterial.shader = shaderManager.skyboxProcedural
        end
        skyboxMaterial:SetFloat("_SunSize", info.sunSize)
        skyboxMaterial:SetFloat("_AtmosphereThickness", info.atmoshpereThickness)
        skyboxMaterial:SetColor("_SkyTint", info.skyTint)
        skyboxMaterial:SetColor("_GroundColor", info.ground)
        skyboxMaterial:SetFloat("_Exposure", info.exposure)
      elseif SkyboxType.ProceduralEx == info.type then
        if shaderManager.skyboxProceduralEx ~= skyboxMaterial.shader then
          skyboxMaterial.shader = shaderManager.skyboxProceduralEx
        end
        skyboxMaterial:SetFloat("_SunSize", info.sunSize)
        skyboxMaterial:SetFloat("_AtmosphereThickness", info.atmoshpereThickness)
        skyboxMaterial:SetColor("_SkyTint", info.skyTint)
        skyboxMaterial:SetColor("_GroundColor", info.ground)
        skyboxMaterial:SetFloat("_Exposure", info.exposure)
        applyArgs.assetPathSkyboxCubemap = info.cubemap
        applyArgs.assetPathSkyboxCubemapAlpha = info.cubemapAlpha
        skyboxMaterial:SetFloat("_Rotation", info.cubemapRotation)
        skyboxMaterial:SetColor("_TexTint", info.cubemapTint)
      end
      EnviromentManager.ApplySkybox_Sun(info, applyArgs, prevInfo)
    end
  else
    if nil ~= skyboxCamera then
      skyboxCamera.clearFlags = CameraClearFlags.Color
      skyboxCamera.backgroundColor = LuaGeometry.Const_Col_black
    end
    EnviromentManager.ClearSkybox_Sun(info, applyArgs, prevInfo)
  end
end

function EnviromentManager.ApplySkybox_Sun(info, applyArgs, prevInfo)
  local skyboxSun = applyArgs.skyboxSun
  if nil ~= info and info.enable and nil ~= skyboxSun then
    if nil ~= info.sunSize and info.sunSize > 0 then
      skyboxSun.color = info.sunColor
      skyboxSun.intensity = info.sunIntensity
      skyboxSun.bounceIntensity = info.sunBounceIntensity
      skyboxSun.transform.eulerAngles = info.sunRotation
      applyArgs.assetPathSunFlare = info.sunFlare
    end
    RenderSettings.skybox = applyArgs.skyboxMaterial
  else
    EnviromentManager.ClearSkybox_Sun(info, applyArgs)
  end
end

function EnviromentManager.ClearSkybox_Sun(info, applyArgs, prevInfo)
  local skyboxSun = applyArgs.skyboxSun
  if nil ~= skyboxSun then
    skyboxSun.color = LuaGeometry.Const_Col_white
    skyboxSun.intensity = 0
    skyboxSun.bounceIntensity = 0
  end
end

function EnviromentManager.ApplyCustomSkybox(info, applyArgs, prevInfo)
  local skyboxManager = Game.GameObjectManagers[Game.GameObjectType.Skybox]
  if info ~= nil and info.enable then
    skyboxManager:SetEnabled(true)
    skyboxManager:SetTintColor(info.tint)
    skyboxManager:SetExposure(info.exposure)
    skyboxManager:SetRotation(info.rotation)
    skyboxManager:SetSunSize(info.sunSize)
    skyboxManager:SetMatFloatProperty("_ApplyFog", info.applyFog and 1.0 or 0)
    applyArgs.customSkyboxTexPath = info.texPath
  else
    skyboxManager:SetEnabled(false)
  end
end

function EnviromentManager.ApplySceneObject(info, applyArgs, prevInfo)
  local sceneObjectMaterials = applyArgs.sceneObjectMaterials
  if nil ~= info and info.enable and nil ~= sceneObjectMaterials and 0 < #sceneObjectMaterials then
    for i = 1, #sceneObjectMaterials do
      local mat = sceneObjectMaterials[i]
      mat:SetColor("_LightColor", info.lightColor)
      mat:SetFloat("_LightScale", info.lightScale)
    end
  elseif nil ~= sceneObjectMaterials and 0 < #sceneObjectMaterials then
    for i = 1, #sceneObjectMaterials do
      local mat = sceneObjectMaterials[i]
      mat:SetColor("_LightColor", LuaGeometry.Const_Col_white)
      mat:SetFloat("_LightScale", 1)
    end
  end
end

function EnviromentManager.ApplyBloom(info, applyArgs, prevInfo)
  Game.EnviromentManager:SetBloom(info)
end

function EnviromentManager.ApplySetting(applyArgs)
  local setting = applyArgs.setting
  local prevSetting = applyArgs.prevSetting
  if nil ~= setting then
    EnviromentManager.ApplyGlobal(setting.global, applyArgs, prevSetting.global)
    EnviromentManager.ApplyLighting(setting.lighting, applyArgs, prevSetting.lighting)
    EnviromentManager.ApplyFog(applyArgs.displayFogParams or setting.fog, applyArgs, prevSetting.fog)
    EnviromentManager.ApplyWind(setting.wind, applyArgs, prevSetting.wind)
    EnviromentManager.ApplyFlare(setting.flare, applyArgs, prevSetting.flare)
    EnviromentManager.ApplySkybox(setting.skybox, applyArgs, prevSetting.skybox)
    EnviromentManager.ApplyCustomSkybox(setting.customskybox, applyArgs, prevSetting.customSkybox)
    EnviromentManager.ApplySceneObject(setting.sceneObject, applyArgs, prevSetting.sceneObject)
    EnviromentManager.ApplyBloom(setting.bloom, applyArgs, prevSetting.bloom)
  end
end

function EnviromentManager:ctor()
  self.prevSetting = {
    global = {},
    lighting = {},
    fog = {},
    wind = {},
    flare = {},
    skybox = {},
    customskybox = {},
    sceneObject = {},
    bloom = {}
  }
  self.setting = {
    global = {
      sunColor = LuaColor.White(),
      sunDir = LuaVector3.Zero()
    },
    lighting = {
      enable = false,
      ambientMode = AmbientMode.Flat,
      ambientLight = LuaColor.White(),
      ambientSkyColor = LuaColor.White(),
      ambientEquatorColor = LuaColor.White(),
      ambientGroundColo = LuaColor.White(),
      ambientIntensity = 1,
      defaultReflectionMode = DefaultReflectionMode.Skybox,
      customReflection = nil,
      defaultReflectionResolution = 128,
      reflectionBounces = 0,
      reflectionIntensity = 0
    },
    fog = {
      enable = false,
      fog = false,
      fogColor = LuaColor.White(),
      fogMode = FogMode.Linear,
      fogStartDistance = 40,
      fogEndDistance = 110,
      fogDensity = 0,
      radiusFogFactor = 0,
      nearFogColor = LuaColor.White(),
      nearFogDistance = 0,
      farFogColor = LuaColor.White(),
      farFogDistance = 0,
      enableLocalHeightFog = 0,
      localHeightFogStart = 0,
      localHeightFogEnd = 1,
      localHeightFogColor = LuaColor.white
    },
    wind = {
      enable = false,
      sheenColorNear = LuaColor.black,
      sheenColorFar = LuaColor.black,
      sheenDistanceNear = 0,
      sheenDistanceFar = 0,
      sheenScatterMinInten = 0,
      sheenPower = 0,
      windTexTiling = Vector4(1, 1, 0, 0),
      windAngle = 0,
      windWaveSpeed = 0,
      windBendStrength = 0,
      windWaveSwingEffect = 0,
      windMask = 0,
      windSheenInten = 0,
      windWaveDisorderFreq = 0
    },
    flare = {
      enable = false,
      flareFadeSpeed = 0,
      flareStrength = 0
    },
    skybox = {
      enable = false,
      type = SkyboxType.SolidColor,
      sunColor = LuaColor.White(),
      sunIntensity = 1,
      sunBounceIntensity = 1,
      sunRotation = LuaVector3.Zero(),
      sunSize = 0,
      atmoshpereThickness = 0,
      skyTint = LuaColor.White(),
      ground = LuaColor.White(),
      exposure = 0,
      cubemap = nil,
      cubemapAlpha = nil,
      cubemapRotation = 0,
      cubemapTint = LuaColor.Clear(),
      exposure = 0
    },
    customskybox = {
      enable = false,
      texPath = nil,
      tint = LuaColor.White(),
      rotation = 0,
      exposure = 1.0,
      sunSize = 0,
      applyFog = false
    },
    sceneObject = {
      enable = false,
      lightColor = LuaColor.White(),
      lightScale = 1
    },
    bloom = {
      enable = false,
      version = 0,
      index = 0,
      threshold = 0,
      intensity = 0,
      bExposure = false,
      scatter = 0,
      clamp = 0,
      highQualityFiltering = false,
      dirtIntensity = 0
    }
  }
  self.applyArgs = {}
  self:_Reset()
  self.animationEnable = true
  self.cameraEffectOn = true
  self.forbiddenFxaa = true
end

function EnviromentManager:SetLinearFogOffset(val, duration)
  if not self.running then
    return
  end
  if linearFogOffset ~= val then
    if not duration or duration <= 0 then
      linearFogOffset = val
      self.targetLinearFogDuration = nil
      self.targetLinearFogTimer = nil
      self:_ApplyFog()
    else
      self.targetLinearFogOffsetStart = linearFogOffset
      self.targetLinearFogOffsetEnd = val
      self.targetLinearFogDuration = duration
      self.targetLinearFogTimer = 0
    end
  end
end

function EnviromentManager:_Reset()
  self.baseID = nil
  self.skyboxCamera = nil
  self.skyboxMaterial = nil
  self.skyboxSun = nil
  self.sceneObjectMaterials = nil
  self.animationBase = nil
  self.animationWeather = nil
  self.animationVolumeFog = nil
  self.weatherID = nil
  self.running = false
  self.nextUpdateTime = 0
  self.eatenDeltaTime = 0
  self.bloomIndex = nil
  self.bloomParam = nil
  self:mSetBloomEffect(nil)
  self.bloomConfig = nil
  for k, v in pairs(self.prevSetting) do
    TableUtility.TableClear(v)
  end
  self.volumeConfigs = nil
  self:ResetVolumeFogStates()
  linearFogOffset = 0
  self.targetLinearFogOffsetStart = nil
  self.targetLinearFogOffsetEnd = nil
  self.targetLinearFogDuration = nil
  self.targetLinearFogTimer = nil
end

function EnviromentManager:_Apply()
  local applyArgs = self.applyArgs
  applyArgs.setting = self.setting
  applyArgs.displayFogParams = self.displayFogParams
  applyArgs.prevSetting = self.prevSetting
  applyArgs.skyboxCamera = self.skyboxCamera
  applyArgs.skyboxMaterial = self.skyboxMaterial
  applyArgs.skyboxSun = self.skyboxSun
  applyArgs.sceneObjectMaterials = self.sceneObjectMaterials
  applyArgs.assetPathCustomRelection = nil
  applyArgs.assetPathSkyboxCubemap = nil
  applyArgs.assetPathSkyboxCubemapAlpha = nil
  applyArgs.assetPathSunFlare = nil
  applyArgs.customSkyboxTexPath = nil
  EnviromentManager.ApplySetting(applyArgs)
  Game.AssetManager_Enviroment:ApplyAssets(applyArgs)
end

function EnviromentManager:_ApplyFog()
  EnviromentManager.ApplyFog(self.displayFogParams or self.setting.fog)
end

function EnviromentManager:SetAnimationEnable(enable)
  if self.animationEnable == enable then
    return
  end
  self.animationEnable = enable
  if not enable then
    if nil ~= self.animationBase then
      self.animationBase:EndAnimation()
    end
    if nil ~= self.animationWeather then
      self.animationWeather:End()
    end
    if nil ~= self.animationVolumeFog then
      self.animationVolumeFog:End()
    end
  end
end

function EnviromentManager:SetSkyboxCamera(camera, material)
  self.skyboxCamera = camera
  self.skyboxMaterial = material
end

function EnviromentManager:SetSkyboxSun(sun)
  self.skyboxSun = sun
end

function EnviromentManager:SetSceneObjectMaterials(materials)
  self.sceneObjectMaterials = materials
end

function EnviromentManager:GetBaseID()
  return self.baseID
end

function EnviromentManager:SetBaseInfo(baseID, duration)
  if nil ~= self.baseID and self.baseID == baseID then
    return
  end
  if not self.animationEnable or nil == duration then
    duration = 0
  end
  local envFile = "Enviroment_" .. baseID
  if not ResourceID.CheckFileIsRecorded(envFile) then
    errorLog("EnviromentManager:SetBaseInfo set invalid Enviroment Lua file : " .. envFile)
    return
  end
  local info = autoImport(envFile)
  self.baseID = baseID
  if nil == self.animationBase then
    self.animationBase = EnviromentAnimation_Base.new()
  end
  self.animationBase:Reset(info, duration)
  self.animationBase:Start()
  local cameraEffectIndex = 0
  if info.lightmap then
    self:SwitchLightmap(info.lightmap.mode, 0)
    self:SwitchLightmapColor(info.lightmap.color, 0)
    if info.lightmap.mode == 1 then
      cameraEffectIndex = 1
    end
  else
    self:SwitchLightmap(0, 0)
    self:SwitchLightmapColor(LuaGeometry.Const_Col_white, 0)
  end
  if self.animationVolumeFog == nil then
    self.animationVolumeFog = EnviromentAnimation_Fog.new()
  end
  self:ResetVolumeFogStates()
  self.volumeConfigs = info.volumes
  self:SetDefaultCameraEffect(cameraEffectIndex)
end

function EnviromentManager:SetWeatherInfo(r, g, b, a, scale)
  if not self.animationEnable then
    return
  end
  if nil == self.animationWeather then
    self.animationWeather = EnviromentAnimation_Weather.new()
  end
  self.animationWeather:Reset(r, g, b, a, scale)
  self.animationWeather:Start()
end

function EnviromentManager:SetWeatherAnimationEnable(enable)
  if self.animationEnable and nil ~= self.animationWeather then
    self.animationWeather:End()
  end
end

function EnviromentManager:StopAnimations()
  if nil ~= self.animationWeather then
    self.animationWeather:End()
    self.animationWeather:Clear()
  end
end

function EnviromentManager:Launch()
  if self.running then
    return
  end
  self:StopAnimations()
  self.running = true
end

function EnviromentManager:Shutdown()
  if not self.running then
    return
  end
  self.running = false
  if nil ~= self.animationVolumeFog then
    self.animationVolumeFog:End()
  end
  if nil ~= self.animationBase then
    self.animationBase:End()
    self.animationBase:Clear()
  end
  if nil ~= self.animationWeather then
    self.animationWeather:End()
    self.animationWeather:Clear()
  end
  Game.AssetManager_Enviroment:Clear()
  self:_Reset()
end

function EnviromentManager:Update(time, deltaTime)
  if not self.running then
    return
  end
  if time < self.nextUpdateTime then
    self.eatenDeltaTime = self.eatenDeltaTime + deltaTime
    return
  end
  deltaTime = deltaTime + self.eatenDeltaTime
  self.eatenDeltaTime = 0
  self.nextUpdateTime = time + UpdateInterval
  local settingUpdated = false
  local volumeFogChanged = false
  if nil ~= self.animationBase and self.animationBase.running then
    self.animationBase:Update(time, deltaTime, self.setting)
    settingUpdated = true
  end
  if nil ~= self.animationWeather and self.animationWeather.running then
    self.animationWeather:Update(time, deltaTime, self.setting)
    settingUpdated = true
  end
  local volumeFogChanged = self:UpdateVolumeFogs(time, deltaTime)
  local targetLinearFogOffsetChanged = false
  if self.targetLinearFogDuration then
    self.targetLinearFogTimer = self.targetLinearFogTimer + deltaTime
    if self.targetLinearFogTimer < self.targetLinearFogDuration then
      linearFogOffset = NumberUtility.Lerp(self.targetLinearFogOffsetStart or 0, self.targetLinearFogOffsetEnd or 0, self.targetLinearFogTimer / self.targetLinearFogDuration)
    else
      linearFogOffset = self.targetLinearFogOffsetEnd or 0
      self.targetLinearFogDuration = nil
    end
    targetLinearFogOffsetChanged = true
  end
  if settingUpdated then
    self:_Apply()
  elseif volumeFogChanged or targetLinearFogOffsetChanged then
    self:_ApplyFog()
  end
end

function EnviromentManager:SwitchLightmap(mode, duration)
  local envMananager = EnvironmentManager.Instance
  if envMananager and mode then
    if duration and 0 < duration then
      envMananager:SwitchLightmap(mode, duration)
    else
      envMananager:SwitchLightmap(mode, 0)
    end
  end
end

function EnviromentManager:SwitchCameraDefaultEffect(on)
  if self.cameraEffectOn == on then
    return
  end
  self.cameraEffectOn = on
  self:SetBloom(self.setting and self.setting.bloom or nil)
end

function EnviromentManager:GetBloomConfig(sceneName, index)
  if not PpLua.BloomSupport() then
    return nil
  end
  if not self.cameraEffectOn then
    return
  end
  if sceneName == nil then
    sceneName = "CommonBloom"
  end
  if index == nil then
    index = 0
  end
  local curConfigs = Scene_DefaultPPEffect[sceneName]
  if curConfigs == nil then
    local commonConfigs = Scene_DefaultPPEffect.CommonBloom
    if commonConfigs then
      return commonConfigs[index] or commonConfigs[0]
    end
    return nil
  end
  if curConfigs.NoBloom then
    return nil
  end
  return curConfigs[index] or curConfigs[0]
end

function EnviromentManager:SetDefaultCameraEffect(index)
  self.bloomIndex = index
  self:SetBloom(nil)
end

function EnviromentManager:SetBloom(bloomConfig)
  if not self.cameraEffectOn then
    self:SetBloomEffectByConfig(nil)
    return
  end
  if bloomConfig ~= nil and bloomConfig.enable and bloomConfig.version and bloomConfig.version > 0 then
    self:SetBloomEffectByConfig(bloomConfig)
  else
    local index = self.bloomIndex or -1
    if index < 0 then
      PostprocessManager.Instance:UnSetDefaultBloom()
      return
    end
    local mapId = Game.MapManager:GetMapID()
    if Table_Map and mapId and Table_Map[mapId] then
      self:SetBloomEffectByConfig(self:GetBloomConfig(Table_Map[mapId].NameEn, index))
    else
      self:SetBloomEffectByConfig(nil)
    end
  end
end

function EnviromentManager:SetSpecialBloomEffect(bloomConfig)
  if bloomConfig and PpLua.BloomSupport() then
    if not self.speicalBloomParam then
      self.speicalBloomParam = RO.PostprocessBloomParam()
    end
    if bloomConfig.threshold then
      self.speicalBloomParam.threshold = bloomConfig.threshold
    end
    if bloomConfig.clamp then
      self.speicalBloomParam.clamp = bloomConfig.clamp
    end
    if bloomConfig.intensity then
      self.speicalBloomParam.intensity = bloomConfig.intensity
    end
    if bloomConfig.scatter then
      self.speicalBloomParam.scatter = bloomConfig.scatter
    end
    if bloomConfig.bExposure ~= nil then
      self.speicalBloomParam.bExposure = bloomConfig.bExposure
    end
    if bloomConfig.tint then
      self.speicalBloomParam.tint = bloomConfig.tint
    end
    self:mSetBloomEffect(self.speicalBloomParam)
  else
    self.speicalBloomParam = nil
    self:mSetBloomEffect(self.speicalBloomParam)
  end
end

function EnviromentManager:UnSetSpecialBloomEffect()
  self:SetSpecialBloomEffect(nil)
  self:RefreshCurrentBloom()
end

function EnviromentManager:SetBloomEffectByConfig(bloomConfig)
  if self.bloomConfig == bloomConfig then
    return
  end
  if bloomConfig and PpLua.BloomSupport() then
    self.bloomConfig = bloomConfig
    if self.bloomParam == nil then
      self.bloomParam = RO.PostprocessBloomParam()
    end
    if bloomConfig.threshold then
      self.bloomParam.threshold = bloomConfig.threshold
    end
    if bloomConfig.clamp then
      self.bloomParam.clamp = bloomConfig.clamp
    end
    if bloomConfig.intensity then
      self.bloomParam.intensity = bloomConfig.intensity
    end
    if bloomConfig.scatter then
      self.bloomParam.scatter = bloomConfig.scatter
    end
    if bloomConfig.bExposure ~= nil then
      self.bloomParam.bExposure = bloomConfig.bExposure
    end
    if bloomConfig.tint then
      self.bloomParam.tint = bloomConfig.tint
    end
    self:mSetBloomEffect(self.bloomParam)
  else
    self.bloomConfig = nil
    self.bloomParam = nil
    self:mSetBloomEffect(self.bloomParam)
  end
end

function EnviromentManager:RefreshCurrentBloom()
  self:mSetBloomEffect(self.bloomParam)
end

function EnviromentManager:mSetBloomEffect(bloomParam)
  if not PpLua.BloomSupport() then
    redlog("[PPEffect] 设置Bloom效果:Frue, 该设备不支持Bloom效果.")
    PostprocessManager.Instance:UnSetDefaultBloom()
    return
  end
  if Slua.IsNull(Camera.main) then
    return
  end
  if bloomParam then
    PostprocessManager.Instance:SetDefaultBloom(bloomParam, true)
    redlog("[PPEffect] 设置Bloom效果:True")
  else
    PostprocessManager.Instance:UnSetDefaultBloom()
    redlog("[PPEffect] 设置Bloom效果:False")
  end
  local fxaa = FunctionPerformanceSetting.Me():GetFxaa()
  self:SwitchFxaa(fxaa)
end

function EnviromentManager:UpdateBloom()
  if self.bloomParam ~= nil then
    PostprocessManager.Instance:UpdateBloom(self.bloomParam)
  end
end

function EnviromentManager:SwitchLightmapColor(color, duration)
  local envMananager = EnvironmentManager.Instance
  if envMananager and color then
    if duration and 0 < duration then
      envMananager:SwitchLightmapColor(color, duration)
    else
      envMananager:SwitchLightmapColor(color, 0)
    end
  end
  if Game.Myself and Game.Myself.assetRole then
    Game.Myself.assetRole:RefreshLightMapColor()
  end
end

function EnviromentManager:ClientForbiddenFxaa(var)
  self.forbiddenFxaa = var
  redlog("Fxaa 是否禁用： ", var)
end

function EnviromentManager:SwitchFxaa(on)
  if self.forbiddenFxaa then
    return
  end
  local mainCamera = Camera.main
  if nil == mainCamera then
    self.fxaaOn = nil
    return
  end
  if not PpLua.BloomSupport() then
    PostprocessManager.Instance:UnSetAA()
    self.fxaaOn = nil
    return
  end
  if on == self.fxaaOn then
    return
  end
  if on then
    PostprocessManager.Instance:SetFxaa()
  else
    PostprocessManager.Instance:UnSetAA()
  end
  self.fxaaOn = on
end

function EnviromentManager:ClientForbiddenFxaa(var)
  self.forbiddenFxaa = var
  redlog("Fxaa 是否禁用： ", var)
end

function EnviromentManager:SwitchFxaa(on)
  if self.forbiddenFxaa then
    return
  end
  local mainCamera = Camera.main
  if nil == mainCamera then
    self.fxaaOn = nil
    return
  end
  if not PpLua.BloomSupport() then
    PostprocessManager.Instance:UnSetAA()
    self.fxaaOn = nil
    return
  end
  if on == self.fxaaOn then
    return
  end
  if on then
    PostprocessManager.Instance:SetFxaa()
  else
    PostprocessManager.Instance:UnSetAA()
  end
  self.fxaaOn = on
end

function EnviromentManager:SetLightmap(isDay)
end

function EnviromentManager:ClearLightmap()
end

local VolumeFogInsertSortFunc = function(fogInArray, fog)
  local pA = fogInArray and fogInArray.volume and fogInArray.volume.priority or 0
  local pB = fog and fog.volume and fog.volume.priority or 0
  return pA > pB
end
local tempLocalPos = LuaVector3.zero

function EnviromentManager:GetCurrentVolumeFogParams()
  local myself = Game.Myself
  if myself == nil then
    return nil, false
  end
  if self.volumeConfigs == nil then
    return nil, false
  end
  local changed = false
  local myPos = myself:GetPosition()
  local volumeConfig = self.volumeConfigs
  if self.triggeredVolumeFogs == nil then
    self.triggeredVolumeFogs = {}
  end
  local triggeredVolumeFogs = self.triggeredVolumeFogs
  for i = 1, #volumeConfig do
    local vol = volumeConfig[i]
    if vol ~= nil and vol.volume ~= nil then
      local volParams = vol.volume
      local worldCenter = volParams.worldCenter
      local worldRange = volParams.worldRange
      if worldCenter and worldRange and LuaVector3.Distance_Square(worldCenter, myPos) > worldRange * worldRange then
        if ArrayRemove(self.triggeredVolumeFogs, vol) > 0 then
          changed = true
        end
      else
        local center = volParams.center or {}
        local mat = volParams.worldToLocalMatrix
        tempLocalPos = LuaVector3.TransformPoint(mat, myPos, tempLocalPos)
        local type = volParams.type or 0
        local isTriggered = false
        if type == LuaGeometry.VolumeTypes.Cube then
          local extents = volParams.extents or {}
          if LuaGeometry.BoundContainsPoint(tempLocalPos, center, extents) then
            isTriggered = true
          end
        elseif type == LuaGeometry.VolumeTypes.Sphere then
          local radius = volParams.radius or 0
          if LuaGeometry.SphereContainsPoint(tempLocalPos, center, radius) then
            isTriggered = true
          end
        end
        if isTriggered then
          local i = ArrayFindIndex(triggeredVolumeFogs, vol)
          if i == 0 then
            ArraySortedInsert(self.triggeredVolumeFogs, vol, VolumeFogInsertSortFunc)
            triggeredVolumeFogs[#triggeredVolumeFogs + 1] = vol
            changed = true
          end
        elseif ArrayRemove(self.triggeredVolumeFogs, vol) > 0 then
          changed = true
        end
      end
    end
  end
  return triggeredVolumeFogs, changed
end

function EnviromentManager:UpdateVolumeFogs(time, deltaTime)
  if self.animationVolumeFog == nil then
    return false
  end
  local volumeFogs, changed = self:GetCurrentVolumeFogParams()
  if changed then
    if self.displayFogParams == nil then
      self.displayFogParams = EnviromentAnimation_Fog.CopyFog(self.displayFogParams, self.setting.fog)
    end
    local hasTriggeredVolume = 0 < #volumeFogs
    local toFog = hasTriggeredVolume and volumeFogs[1].fog or self.setting.fog
    local duration = hasTriggeredVolume and toFog.blendDuration or self.displayFogParams.blendDuration or 0
    self.animationVolumeFog:Start(self.displayFogParams, toFog, duration)
  end
  return changed or self.animationVolumeFog:Update(time, deltaTime, self.displayFogParams)
end

function EnviromentManager:ResetVolumeFogStates()
  local changed = self.displayFogParams ~= nil or self.triggeredVolumeFogs ~= nil and #self.triggeredVolumeFogs > 0
  if self.animationVolumeFog then
    self.animationVolumeFog:End()
  end
  self.displayFogParams = nil
  self.triggeredVolumeFogs = nil
  return changed
end
