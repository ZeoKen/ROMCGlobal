EnviromentAnimation_Fog = class("EnviromentAnimation_Fog")
local CopyFog = function(outFog, fromFog)
  if outFog == nil then
    outFog = {}
  end
  outFog.enable = true
  outFog.blendDuration = fromFog.blendDuration or 0.5
  outFog.weight = fromFog.weight or 1.0
  outFog.fog = fromFog.fog or false
  outFog.heightFogMode = fromFog.heightFogMode
  outFog.radiusFogFactor = fromFog.radiusFogFactor
  outFog.fogMode = fromFog.fogMode
  outFog.fogStartDistance = fromFog.fogStartDistance
  outFog.fogEndDistance = fromFog.fogEndDistance
  outFog.fogDensity = fromFog.fogDensity
  outFog.globalFogTuner = fromFog.globalFogTuner
  outFog.heightFogStart = fromFog.heightFogStart
  outFog.heightFogEnd = fromFog.heightFogEnd
  outFog.heightFogCutoff = fromFog.heightFogCutoff
  outFog.scatteringDensity = fromFog.scatteringDensity
  outFog.scatteringExponent = fromFog.scatteringExponent
  outFog.heightFogMinOpacity = fromFog.heightFogMinOpacity
  outFog.nearFogDistance = fromFog.nearFogDistance
  outFog.farFogDistance = fromFog.farFogDistance
  outFog.nearFogColor = LuaColorUtility.TryAsign(outFog.nearFogColor or LuaColor.white, fromFog.nearFogColor or LuaColor.white)
  outFog.farFogColor = LuaColorUtility.TryAsign(outFog.farFogColor or LuaColor.white, fromFog.farFogColor or LuaColor.white)
  outFog.localHeightFogColor = LuaColorUtility.TryAsign(outFog.localHeightFogColor or LuaColor.white, fromFog.localHeightFogColor or LuaColor.black)
  outFog.enableLocalHeightFog = fromFog.enableLocalHeightFog
  outFog.localHeightFogStart = fromFog.localHeightFogStart
  outFog.localHeightFogEnd = fromFog.localHeightFogEnd
  outFog.fogColor = outFog.farFogColor
  return outFog
end
EnviromentAnimation_Fog.CopyFog = CopyFog
local LerpFog = function(outFog, fromFog, toFog, factor)
  outFog.fogMode = toFog.fogMode
  outFog.fogStartDistance = NumberUtility.Lerp(fromFog.fogStartDistance or 1000.0, toFog.fogStartDistance or 1000.0, factor)
  outFog.fogEndDistance = NumberUtility.Lerp(fromFog.fogEndDistance or 1000.0, toFog.fogEndDistance or 1000.0, factor)
  outFog.fogDensity = NumberUtility.Lerp(fromFog.fogDensity or 0, toFog.fogDensity or 0, factor)
  outFog.globalFogTuner = NumberUtility.Lerp(fromFog.fog and fromFog.globalFogTuner or 1.0, toFog.fog and toFog.globalFogTuner or 1.0, factor)
  outFog.heightFogStart = NumberUtility.Lerp(fromFog.heightFogStart or 1000.0, toFog.heightFogStart or 1000.0, factor)
  outFog.heightFogEnd = NumberUtility.Lerp(fromFog.heightFogEnd or 1000.0, toFog.heightFogEnd or 1000.0, factor)
  outFog.heightFogCutoff = NumberUtility.Lerp(fromFog.heightFogCutoff or 0, toFog.heightFogCutoff or 0, factor)
  outFog.scatteringDensity = NumberUtility.Lerp(fromFog.scatteringDensity or 0, toFog.scatteringDensity or 0, factor)
  outFog.scatteringExponent = NumberUtility.Lerp(fromFog.scatteringExponent or 40.0, toFog.scatteringExponent or 40.0, factor)
  outFog.heightFogMinOpacity = NumberUtility.Lerp(fromFog.heightFogMinOpacity or 0, toFog.heightFogMinOpacity or 0, factor)
  outFog.nearFogDistance = NumberUtility.Lerp(fromFog.nearFogDistance or 0, toFog.nearFogDistance or 0, factor)
  outFog.farFogDistance = NumberUtility.Lerp(fromFog.farFogDistance or 0, toFog.farFogDistance or 0, factor)
  outFog.nearFogColor = LuaColorUtility.TryLerp(outFog.nearFogColor or LuaColor.white, fromFog.radiusFogFactor and 0 < fromFog.radiusFogFactor and fromFog.nearFogColor or fromFog.farFogColor or LuaColor.white, toFog.radiusFogFactor and 0 < toFog.radiusFogFactor and toFog.nearFogColor or toFog.farFogColor or LuaColor.white, factor)
  outFog.farFogColor = LuaColorUtility.TryLerp(outFog.farFogColor or LuaColor.white, fromFog.farFogColor or LuaColor.white, toFog.farFogColor or LuaColor.white, factor)
  outFog.localHeightFogColor = LuaColorUtility.TryLerp(outFog.localHeightFogColor or LuaColor.black, fromFog.localHeightFogColor or LuaColor.black, toFog.localHeightFogColor or LuaColor.black, factor)
  outFog.enableLocalHeightFog = NumberUtility.Lerp(fromFog.enableLocalHeightFog or 0, toFog.enableLocalHeightFog or 0, factor)
  outFog.localHeightFogStart = NumberUtility.Lerp(fromFog.localHeightFogStart or 0, toFog.localHeightFogStart or 0, factor)
  outFog.localHeightFogEnd = NumberUtility.Lerp(fromFog.localHeightFogEnd or 1.0, toFog.localHeightFogEnd or 1.0, factor)
  outFog.fogColor = outFog.farFogColor
  if factor == 0 then
    outFog.fog = fromFog.fog or false
    outFog.heightFogMode = fromFog.heightFogMode
    outFog.radiusFogFactor = fromFog.radiusFogFactor
  elseif factor < 1.0 then
    outFog.fog = toFog.fog or fromFog.fog or false
    outFog.heightFogMode = toFog.heightFogMode == EnviromentManager.HeightFogMode.None and fromFog.heightFogMode or toFog.heightFogMode
    outFog.radiusFogFactor = math.max(toFog.radiusFogFactor or 0, fromFog.radiusFogFactor or 0)
  else
    outFog.fog = toFog.fog or false
    outFog.heightFogMode = toFog.heightFogMode
    outFog.radiusFogFactor = toFog.radiusFogFactor
  end
  outFog.enable = true
end
EnviromentAnimation_Fog.LerpFog = LerpFog

function EnviromentAnimation_Fog:ctor()
  self.running = false
  self.from = nil
  self.to = nil
  self.duration = 0
  self.timeElapsed = 0
end

function EnviromentAnimation_Fog:Start(fromFog, toFog, duration)
  self.running = true
  self.duration = duration or 0
  self.timeElapsed = 0
  self.from = CopyFog(self.from, fromFog)
  self.to = CopyFog(self.to, toFog)
end

function EnviromentAnimation_Fog:End()
  self.running = false
  self.from = nil
  self.to = nil
  self.duration = 0
  self.timeElapsed = 0
end

function EnviromentAnimation_Fog:Update(time, deltaTime, outFog)
  if self.running then
    self.timeElapsed = self.timeElapsed + deltaTime
    if self.timeElapsed >= self.duration then
      CopyFog(outFog, self.to)
      self:End()
    else
      local factor = self.timeElapsed / self.duration * (self.to.weight or 1.0)
      LerpFog(outFog, self.from, self.to, factor)
    end
    return true
  end
  return false
end
