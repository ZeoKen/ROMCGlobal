EnviromentAnimation_Base = class("EnviromentAnimation_Base")
local CopyGlobal = function(cur, info)
  if nil ~= info and nil ~= cur then
    info.sunColor = LuaColorUtility.TryAsign(info.sunColor, cur.sunColor)
    info.sunDir = VectorUtility.TryAsign_3(info.sunDir, cur.sunDir)
  end
end
local LerpGlobal = function(curFrom, curTo, progress, info)
  if info == nil then
    return
  end
  info.sunColor = LuaColorUtility.TryLerp(info.sunColor, curFrom.sunColor, curTo.sunColor, progress)
  info.sunDir = VectorUtility.TryAsign_3(info.sunDir, curTo.sunDir)
end
local CopyLighting = function(cur, info)
  info.ambientMode = cur.ambientMode
  info.ambientLight = LuaColorUtility.TryAsign(info.ambientLight, cur.ambientLight)
  info.ambientSkyColor = LuaColorUtility.TryAsign(info.ambientSkyColor, cur.ambientSkyColor)
  info.ambientEquatorColor = LuaColorUtility.TryAsign(info.ambientEquatorColor, cur.ambientEquatorColor)
  info.ambientGroundColor = LuaColorUtility.TryAsign(info.ambientGroundColor, cur.ambientGroundColor)
  info.ambientIntensity = cur.ambientIntensity
  info.defaultReflectionMode = cur.defaultReflectionMode
  info.customReflection = cur.customReflection or info.customReflection
  info.defaultReflectionResolution = cur.defaultReflectionResolution
  info.reflectionBounces = cur.reflectionBounces
  info.reflectionIntensity = cur.reflectionIntensity
end
local LerpLighting = function(curFrom, curTo, progress, info)
  info.ambientMode = curTo.ambientMode
  info.ambientLight = LuaColorUtility.TryLerp(info.ambientLight, curFrom.ambientLight, curTo.ambientLight, progress)
  info.ambientSkyColor = LuaColorUtility.TryLerp(info.ambientSkyColor, curFrom.ambientSkyColor, curTo.ambientSkyColor, progress)
  info.ambientEquatorColor = LuaColorUtility.TryLerp(info.ambientEquatorColor, curFrom.ambientEquatorColor, curTo.ambientEquatorColor, progress)
  info.ambientGroundColor = LuaColorUtility.TryLerp(info.ambientGroundColor, curFrom.ambientGroundColor, curTo.ambientGroundColor, progress)
  info.ambientIntensity = NumberUtility.TryLerpUnclamped(curFrom.ambientIntensity, curTo.ambientIntensity, progress)
  info.defaultReflectionMode = curTo.defaultReflectionMode
  info.customReflection = curTo.customReflection or info.customReflection
  info.defaultReflectionResolution = curTo.defaultReflectionResolution
  info.reflectionBounces = NumberUtility.TryLerpUnclamped(curFrom.reflectionBounces, curTo.reflectionBounces, progress)
  info.reflectionIntensity = NumberUtility.TryLerpUnclamped(curFrom.reflectionIntensity, curTo.reflectionIntensity, progress)
end
local CopyFog = function(cur, info)
  info.fog = cur.fog
  info.fogColor = LuaColorUtility.TryAsign(info.fogColor, cur.fogColor)
  info.fogMode = cur.fogMode or info.fogMode
  info.fogStartDistance = cur.fogStartDistance or info.fogStartDistance
  info.fogEndDistance = cur.fogEndDistance or info.fogEndDistance
  info.fogDensity = cur.fogDensity or info.fogDensity
  info.heightFogMode = cur.heightFogMode
  info.globalFogTuner = cur.globalFogTuner
  info.heightFogStart = cur.heightFogStart or info.heightFogStart
  info.heightFogEnd = cur.heightFogEnd or info.heightFogEnd
  info.heightFogCutoff = cur.heightFogCutoff or info.heightFogCutoff
  info.scatteringDensity = cur.scatteringDensity
  info.scatteringFalloff = cur.scatteringFalloff or info.scatteringFalloff
  info.scatteringExponent = cur.scatteringExponent or info.scatteringExponent
  info.heightFogMinOpacity = cur.heightFogMinOpacity or info.heightFogMinOpacity
  info.radiusFogFactor = cur.radiusFogFactor
  info.nearFogColor = LuaColorUtility.TryAsign(info.nearFogColor, cur.nearFogColor)
  info.nearFogDistance = cur.nearFogDistance or info.nearFogDistance
  info.farFogColor = LuaColorUtility.TryAsign(info.farFogColor, cur.farFogColor)
  info.farFogDistance = cur.farFogDistance or info.farFogDistance
  info.enableLocalHeightFog = cur.enableLocalHeightFog or 0
  info.localHeightFogStart = cur.localHeightFogStart or 0
  info.localHeightFogEnd = cur.localHeightFogEnd or 1
  info.localHeightFogColor = LuaColorUtility.TryAsign(info.localHeightFogColor, cur.localHeightFogColor)
end
local LerpFog = function(curFrom, curTo, progress, info)
  info.fog = curTo.fog
  info.fogColor = LuaColorUtility.TryLerp(info.fogColor, curFrom.fogColor, curTo.fogColor, progress)
  info.fogMode = curTo.fogMode or info.fogMode
  info.heightFogMode = curTo.heightFogMode or info.heightFogMode
  info.sphereCenter = curTo.sphereCenter or info.sphereCenter
  info.heightFogMinOpacity = curTo.heightFogMinOpacity or info.heightFogMinOpacity
  info.fogStartDistance = NumberUtility.TryLerpUnclamped(curFrom.fogStartDistance, curTo.fogStartDistance, progress) or info.fogStartDistance
  info.fogEndDistance = NumberUtility.TryLerpUnclamped(curFrom.fogEndDistance, curTo.fogEndDistance, progress) or info.fogEndDistance
  info.fogDensity = NumberUtility.TryLerpUnclamped(curFrom.fogDensity, curTo.fogDensity, progress) or info.fogDensity
  info.globalFogTuner = NumberUtility.TryLerpUnclamped(curFrom.globalFogTuner, curTo.globalFogTuner, progress) or info.globalFogTuner
  info.heightFogStart = NumberUtility.TryLerpUnclamped(curFrom.heightFogStart, curTo.heightFogStart, progress) or info.heightFogStart
  info.heightFogEnd = NumberUtility.TryLerpUnclamped(curFrom.heightFogEnd, curTo.heightFogEnd, progress) or info.heightFogEnd
  info.heightFogCutoff = NumberUtility.TryLerpUnclamped(curFrom.heightFogCutoff, curTo.heightFogCutoff, progress) or info.heightFogCutoff
  info.scatteringDensity = NumberUtility.TryLerpUnclamped(curFrom.scatteringDensity, curTo.scatteringDensity, progress) or info.scatteringDensity
  info.scatteringFalloff = NumberUtility.TryLerpUnclamped(curFrom.scatteringFalloff, curTo.scatteringFalloff, progress) or info.scatteringFalloff
  info.scatteringExponent = NumberUtility.TryLerpUnclamped(curFrom.scatteringExponent, curTo.scatteringExponent, progress) or info.scatteringExponent
  info.radiusFogFactor = curTo.radiusFogFactor
  info.nearFogDistance = NumberUtility.TryLerpUnclamped(curFrom.nearFogDistance, curTo.nearFogDistance, progress) or info.nearFogDistance
  info.nearFogColor = LuaColorUtility.TryLerp(info.nearFogColor, curFrom.nearFogColor, curTo.nearFogColor, progress)
  info.farFogDistance = NumberUtility.TryLerpUnclamped(curFrom.farFogDistance, curTo.farFogDistance, progress) or info.farFogDistance
  info.farFogColor = LuaColorUtility.TryLerp(info.farFogColor, curFrom.farFogColor, curTo.farFogColor, progress)
  info.enableLocalHeightFog = curTo.enableLocalHeightFog
  info.localHeightFogStart = NumberUtility.TryLerpUnclamped(curFrom.localHeightFogStart, curTo.localHeightFogStart, progress) or info.localHeightFogStart
  info.localHeightFogEnd = NumberUtility.TryLerpUnclamped(curFrom.localHeightFogEnd, curTo.localHeightFogEnd, progress) or info.localHeightFogStart
  info.localHeightFogColor = LuaColorUtility.TryLerp(info.localHeightFogColor, curFrom.localHeightFogColor, curTo.localHeightFogColor, progress)
end
local CopyWind = function(cur, info)
  info.sheenColorNear = LuaColorUtility.TryAsign(info.sheenColorNear, cur.sheenColorNear)
  info.sheenColorFar = LuaColorUtility.TryAsign(info.sheenColorFar, cur.sheenColorFar)
  info.sheenDistanceNear = cur.sheenDistanceNear
  info.sheenDistanceFar = cur.sheenDistanceFar
  info.sheenScatterMinInten = cur.sheenScatterMinInten
  info.sheenPower = cur.sheenPower
  info.windTexTiling = VectorUtility.TryAsign_4(info.windTexTiling, cur.windTexTiling)
  info.windAngle = cur.windAngle
  info.windWaveSpeed = cur.windWaveSpeed
  info.windBendStrength = cur.windBendStrength
  info.windWaveSwingEffect = cur.windWaveSwingEffect
  info.windMask = cur.windMask
  info.windSheenInten = cur.windSheenInten
  info.windWaveDisorderFreq = cur.windWaveDisorderFreq
end
local LerpWind = function(curFrom, curTo, progress, info)
  info.sheenColorNear = LuaColorUtility.TryLerp(info.sheenColorNear, curFrom.sheenColorNear, curTo.sheenColorNear, progress)
  info.sheenColorFar = LuaColorUtility.TryLerp(info.sheenColorFar, curFrom.sheenColorFar, curTo.sheenColorFar, progress)
  info.sheenDistanceNear = NumberUtility.TryLerpUnclamped(curFrom.sheenDistanceNear, curTo.sheenDistanceNear, progress)
  info.sheenDistanceFar = NumberUtility.TryLerpUnclamped(curFrom.sheenDistanceFar, curTo.sheenDistanceFar, progress)
  info.sheenScatterMinInten = NumberUtility.TryLerpUnclamped(curFrom.sheenScatterMinInten, curTo.sheenScatterMinInten, progress)
  info.sheenPower = NumberUtility.TryLerpUnclamped(curFrom.sheenPower, curTo.sheenPower, progress)
  info.windAngle = NumberUtility.TryLerpUnclamped(curFrom.windAngle, curTo.windAngle, progress)
  info.windWaveSpeed = NumberUtility.TryLerpUnclamped(curFrom.windWaveSpeed, curTo.windWaveSpeed, progress)
  info.windBendStrength = NumberUtility.TryLerpUnclamped(curFrom.windBendStrength, curTo.windBendStrength, progress)
  info.windWaveSwingEffect = NumberUtility.TryLerpUnclamped(curFrom.windWaveSwingEffect, curTo.windWaveSwingEffect, progress)
  info.windMask = NumberUtility.TryLerpUnclamped(curFrom.windMask, curTo.windMask, progress)
  info.windSheenInten = NumberUtility.TryLerpUnclamped(curFrom.windSheenInten, curTo.windSheenInten, progress)
  info.windWaveDisorderFreq = NumberUtility.TryLerpUnclamped(curFrom.windWaveDisorderFreq, curTo.windWaveDisorderFreq, progress)
  if progress < 0.5 then
    info.windTexTiling = VectorUtility.TryAsign_4(info.windTexTiling, curFrom.windTexTiling)
  else
    info.windTexTiling = VectorUtility.TryAsign_4(info.windTexTiling, curTo.windTexTiling)
  end
end
local CopyFlare = function(cur, info)
  info.flareFadeSpeed = cur.flareFadeSpeed
  info.flareStrength = cur.flareStrength
end
local LerpFlare = function(curFrom, curTo, progress, info)
  info.flareFadeSpeed = NumberUtility.TryLerpUnclamped(curFrom.flareFadeSpeed, curTo.flareFadeSpeed, progress)
  info.flareStrength = NumberUtility.TryLerpUnclamped(curFrom.flareStrength, curTo.flareStrength, progress)
end
local CopySkybox = function(cur, info)
  info.type = cur.type
  info.sunColor = LuaColorUtility.TryAsign(info.sunColor, cur.sunColor)
  info.sunIntensity = cur.sunIntensity or 0
  info.sunBounceIntensity = cur.sunBounceIntensity or 0
  info.sunRotation = VectorUtility.TryAsign_3(info.sunRotation, cur.sunRotation)
  info.sunSize = cur.sunSize or 0
  info.sunFlare = cur.sunFlare
  info.atmoshpereThickness = cur.atmoshpereThickness or 0
  info.skyTint = LuaColorUtility.TryAsign(info.skyTint, cur.skyTint)
  info.ground = LuaColorUtility.TryAsign(info.ground, cur.ground)
  info.exposure = cur.exposure or 0
  info.cubemap = cur.cubemap
  info.cubemapAlpha = cur.cubemapAlpha
  info.cubemapRotation = cur.cubemapRotation or 0
  info.cubemapTint = LuaColorUtility.TryAsign(info.cubemapTint, cur.cubemapTint)
end
local LerpSkybox = function(curFrom, curTo, progress, info)
  info.type = curTo.type
  info.sunColor = LuaColorUtility.TryLerp(info.sunColor, curFrom.sunColor, curTo.sunColor, progress)
  info.sunIntensity = NumberUtility.TryLerpUnclamped(curFrom.sunIntensity, curTo.sunIntensity, progress) or info.sunIntensity
  info.sunBounceIntensity = NumberUtility.TryLerpUnclamped(curFrom.sunBounceIntensity, curTo.sunBounceIntensity, progress) or info.sunBounceIntensity
  info.sunRotation = VectorUtility.TryLerpAngleUnclamped_3(info.sunRotation, curFrom.sunRotation, curTo.sunRotation, progress)
  info.sunSize = NumberUtility.TryLerpUnclamped(curFrom.sunSize, curTo.sunSize, progress) or info.sunSize
  info.atmoshpereThickness = NumberUtility.TryLerpUnclamped(curFrom.atmoshpereThickness, curTo.atmoshpereThickness, progress) or info.atmoshpereThickness
  info.skyTint = LuaColorUtility.TryLerp(info.skyTint, curFrom.skyTint, curTo.skyTint, progress)
  info.ground = LuaColorUtility.TryLerp(info.ground, curFrom.ground, curTo.ground, progress)
  info.exposure = NumberUtility.TryLerpUnclamped(curFrom.exposure, curTo.exposure, progress) or info.exposure
  if progress < 0.5 then
    info.sunFlare = curFrom.sunFlare or info.sunFlare
    info.cubemap = curFrom.cubemap or info.cubemap
    info.cubemapAlpha = curFrom.cubemapAlpha
    info.cubemapTint = LuaColorUtility.TryLerp(info.cubemapTint, curFrom.cubemapTint, LuaGeometry.Const_Col_whiteClear, progress * 2)
  else
    info.sunFlare = curTo.sunFlare or info.sunFlare
    info.cubemap = curTo.cubemap or info.cubemap
    info.cubemapAlpha = curTo.cubemapAlpha
    info.cubemapTint = LuaColorUtility.TryLerp(info.cubemapTint, LuaGeometry.Const_Col_whiteClear, curTo.cubemapTint, (progress - 0.5) * 2)
  end
  info.cubemapRotation = NumberUtility.TryLerpAngleUnclamped(curFrom.cubemapRotation, curTo.cubemapRotation, progress) or info.cubemapRotation
end
local CopyCustomSkybox = function(cur, info)
  info.texPath = cur.texPath
  info.tint = LuaColorUtility.TryAsign(info.tint, cur.tint)
  info.rotation = cur.rotation or 0
  info.exposure = cur.exposure or 1.0
  info.sunSize = cur.sunSize or 0
  info.applyFog = cur.applyFog
end
local LerpCustomSkybox = function(curFrom, curTo, progress, info)
  info.applyFog = curTo.applyFog
  info.tint = LuaColorUtility.TryLerp(info.tint, curFrom.tint, curTo.tint, progress)
  info.rotation = NumberUtility.TryLerpUnclamped(curFrom.rotation, curTo.rotation, progress) or info.rotation
  info.exposure = NumberUtility.TryLerpUnclamped(curFrom.exposure, curTo.exposure, progress) or info.exposure
  info.sunSize = NumberUtility.TryLerpUnclamped(curFrom.sunSize, curTo.sunSize, progress) or info.sunSize
  if progress < 0.5 then
    info.texPath = curFrom.texPath or info.texPath
  else
    info.texPath = curTo.texPath or info.texPath
  end
end
local CopySceneObject = function(cur, info)
  info.lightColor = LuaColorUtility.TryAsign(info.lightColor, cur.lightColor)
  info.lightScale = cur.lightScale
end
local LerpSceneObject = function(curFrom, curTo, progress, info)
  info.lightColor = LuaColorUtility.TryLerp(info.lightColor, curFrom.lightColor, curTo.lightColor, progress)
  info.lightScale = NumberUtility.TryLerpUnclamped(curFrom.lightScale, curTo.lightScale, progress)
end
local CopyBloom = function(cur, info)
  info.version = cur.version
  info.index = cur.index
  info.threshold = cur.threshold
  info.intensity = cur.intensity
  info.bExposure = cur.bExposure
  info.scatter = cur.scatter
  info.clamp = cur.clamp
  info.highQualityFiltering = cur.highQualityFiltering
  info.dirtIntensity = cur.dirtIntensity
end
local LerpBloom = function(curFrom, curTo, progress, info)
  info.version = curTo.version
  info.threshold = NumberUtility.TryLerpUnclamped(curFrom.threshold, curTo.threshold, progress)
  info.intensity = NumberUtility.TryLerpUnclamped(curFrom.intensity, curTo.intensity, progress)
  info.scatter = NumberUtility.TryLerpUnclamped(curFrom.scatter, curTo.scatter, progress)
  info.clamp = NumberUtility.TryLerpUnclamped(curFrom.clamp, curTo.clamp, progress)
  info.dirtIntensity = NumberUtility.TryLerpUnclamped(curFrom.dirtIntensity, curTo.dirtIntensity, progress)
  if progress < 0.5 then
    info.version = curFrom.bExposure
    info.index = curFrom.index
    info.bExposure = curFrom.bExposure
    info.highQualityFiltering = curFrom.highQualityFiltering
  else
    info.version = curTo.version
    info.index = curTo.index
    info.bExposure = curTo.bExposure
    info.highQualityFiltering = curTo.highQualityFiltering
  end
end
local CopySetting = function(from, setting)
  local cur = from.global
  local info = setting.global
  if nil ~= cur then
    CopyGlobal(cur, info)
  end
  cur = from.lighting
  info = setting.lighting
  if nil ~= cur then
    info.enable = true
    CopyLighting(cur, info)
  else
    info.enable = false
  end
  cur = from.fog
  info = setting.fog
  if nil ~= cur then
    info.enable = true
    CopyFog(cur, info)
  else
    info.enable = false
  end
  cur = from.wind
  info = setting.wind
  if nil ~= cur then
    info.enable = true
    CopyWind(cur, info)
  else
    info.enable = false
  end
  cur = from.flare
  info = setting.flare
  if nil ~= cur then
    info.enable = true
    CopyFlare(cur, info)
  else
    info.enable = false
  end
  cur = from.skybox
  info = setting.skybox
  if nil ~= cur then
    info.enable = true
    CopySkybox(cur, info)
  else
    info.enable = false
  end
  cur = from.customskybox
  info = setting.customskybox
  if nil ~= cur then
    info.enable = true
    CopyCustomSkybox(cur, info)
  else
    info.enable = false
  end
  cur = from.sceneObject
  info = setting.sceneObject
  if nil ~= cur then
    info.enable = true
    CopySceneObject(cur, info)
  else
    info.enable = false
  end
  cur = from.bloom
  info = setting.bloom
  if nil ~= cur then
    info.enable = true
    CopyBloom(cur, info)
  else
    info.enable = false
  end
end
local LerpSetting = function(from, to, progress, setting)
  local curFrom = from.global
  local curTo = from.global
  local info = setting.global
  if nil ~= curTo then
    if nil ~= curFrom then
      LerpGlobal(curFrom, curTo, progress, info)
    else
      CopyGlobal(curTo, info)
    end
  end
  curFrom = from.lighting
  curTo = to.lighting
  info = setting.lighting
  if nil ~= curTo then
    info.enable = true
    if nil ~= curFrom then
      LerpLighting(curFrom, curTo, progress, info)
    else
      CopyLighting(curTo, info)
    end
  else
    info.enable = false
  end
  curFrom = from.fog
  curTo = to.fog
  info = setting.fog
  if nil ~= curTo then
    info.enable = true
    if nil ~= curFrom then
      LerpFog(curFrom, curTo, progress, info)
    else
      CopyFog(curTo, info)
    end
  else
    info.enable = false
  end
  curFrom = from.wind
  curTo = to.wind
  info = setting.wind
  if nil ~= curTo then
    info.enable = true
    if nil ~= curFrom then
      LerpWind(curFrom, curTo, progress, info)
    else
      CopyWind(curTo, info)
    end
  else
    info.enable = false
  end
  curFrom = from.flare
  curTo = to.flare
  info = setting.flare
  if nil ~= curTo then
    info.enable = true
    if nil ~= curFrom then
      LerpFlare(curFrom, curTo, progress, info)
    else
      CopyFlare(curTo, info)
    end
  else
    info.enable = false
  end
  curFrom = from.skybox
  curTo = to.skybox
  info = setting.skybox
  if nil ~= curTo then
    info.enable = true
    if nil ~= curFrom then
      LerpSkybox(curFrom, curTo, progress, info)
    else
      CopySkybox(curTo, info)
    end
  else
    info.enable = false
  end
  curFrom = from.customskybox
  curTo = to.customskybox
  info = setting.customskybox
  if nil ~= curTo then
    info.enable = true
    if nil ~= curFrom then
      LerpCustomSkybox(curFrom, curTo, progress, info)
    else
      CopyCustomSkybox(curTo, info)
    end
  else
    info.enable = false
  end
  curFrom = from.sceneObject
  curTo = to.sceneObject
  info = setting.sceneObject
  if nil ~= curTo then
    info.enable = true
    if nil ~= curFrom then
      LerpSceneObject(curFrom, curTo, progress, info)
    else
      CopySceneObject(curTo, info)
    end
  else
    info.enable = false
  end
  curFrom = from.bloom
  curTo = to.bloom
  info = setting.bloom
  if nil ~= curTo then
    info.enable = true
    if nil ~= curFrom then
      LerpBloom(curFrom, curTo, progress, info)
    else
      CopyBloom(curTo, info)
    end
  else
    info.enable = false
  end
end

function EnviromentAnimation_Base:ctor()
  self.running = false
  self.from = nil
  self.to = nil
  self.duration = 0
  self.timeElapsed = 0
end

function EnviromentAnimation_Base:Reset(to, duration)
  self.to = to
  self.duration = self.timeElapsed + duration
end

function EnviromentAnimation_Base:EndAnimation()
  self.duration = 0
end

function EnviromentAnimation_Base:Clear()
  self.from = nil
  self.to = nil
  self.duration = 0
  self.timeElapsed = 0
end

function EnviromentAnimation_Base:Start()
  if self.running then
    return
  end
  self.running = true
end

function EnviromentAnimation_Base:End()
  if not self.running then
    return
  end
  self.running = false
  self.from = self.to
  self.duration = 0
  self.timeElapsed = 0
end

function EnviromentAnimation_Base:Update(time, deltaTime, setting)
  if self.running then
    if nil ~= self.from and self.timeElapsed < self.duration then
      self.timeElapsed = self.timeElapsed + deltaTime
      LerpSetting(self.from, self.to, self.timeElapsed / self.duration, setting)
      return
    else
      self:End()
    end
  end
  CopySetting(self.to, setting)
end
