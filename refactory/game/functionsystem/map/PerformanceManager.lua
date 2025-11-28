PerformanceManager = class("PerformanceManager")
PerformanceManager.LODLevel = {
  Low = LODLevel.LODLow,
  Mid = LODLevel.LODMid,
  High = LODLevel.LODHigh
}
local LODLevel = PerformanceManager.LODLevel
local LODShader = {
  Low = 200,
  Mid = 300,
  High = 400
}
local SkINWEIGHT = {
  One = SkinWeights.OneBone,
  Two = SkinWeights.TwoBones,
  Four = SkinWeights.FourBones
}
local MapPerformanceSetting = GameConfig.MapPerformanceSetting or {}
local SetSimplifyRolePart = function(creature, on)
  creature:SetSimplifyRolePart(on)
end

function PerformanceManager:ctor()
  self:Reset()
end

function PerformanceManager:Reset()
  self.running = false
  if self.deviceRate == nil then
    self.deviceRate = ROSystemInfo.DeviceRate
  end
  if self.deviceRate >= 4 then
    self:SetDefaultLODShader(LODShader.High)
  else
    self:SetDefaultLODShader(LODShader.Mid)
  end
  local setting = FunctionPerformanceSetting.Me()
  self:SetDefaultBloom(setting:GetBloom())
  self:SetDefaultEffect(setting:GetEffectLv())
  self:SetDefaultFxaa(setting:GetFxaa())
end

function PerformanceManager:Launch()
  if self.running then
    return
  end
  self.running = true
  local mapID = Game.MapManager:GetMapID()
  if MapPerformanceSetting[mapID] then
    FunctionPerformanceSetting.ApplyMapSetting(MapPerformanceSetting[mapID])
  end
  local isBigWorld = false
  if Game.MapManager.IsCurBigWorld ~= nil then
    isBigWorld = Game.MapManager:IsCurBigWorld()
  end
  if isBigWorld then
    Debug.Log("==>IsCurBigWorld")
    FunctionPerformanceSetting.AdjustBigWorldConfig()
  end
  local config = Table_Map[mapID]
  if config ~= nil and config.HighPerformance == 1 then
    self:SetDefaultLODShader(LODShader.High)
  else
    mapID = Game.MapManager:GetRaidID()
  end
  self:ResetLOD()
  self:ResetBone()
end

function PerformanceManager:Shutdown()
  if not self.running then
    return
  end
  self:Reset()
  FunctionPerformanceSetting.ExitMapSetting()
end

function PerformanceManager:CloseBloom()
  local setting = FunctionPerformanceSetting.Me()
  setting:SetBloom(false)
  setting:ApplyBloom()
  setting:SetFxaa(false)
  setting:ApplyFxaa()
end

local cacheBloomSetting = {}

function PerformanceManager:LowPerformance()
  self.originalLodShader = self.lodShader
  self.originalSkinWeight = self.skinWeight
  self:LODLow()
  self:ResetBone()
  local setting = FunctionPerformanceSetting.Me()
  cacheBloomSetting.bloom = setting:GetBloom()
  cacheBloomSetting.fxaa = setting:GetFxaa()
  setting:SetBloom(false)
  setting:ApplyBloom()
  setting:SetFxaa(false)
  setting:ApplyFxaa()
end

function PerformanceManager:ResetPerformance()
  if self.originalLodShader ~= nil then
    self:SetLODShader(self.originalLodShader)
    self.originalLodShader = nil
  end
  if self.originalSkinWeight ~= nil then
    self:SetSkinWeight(self.originalSkinWeight)
    self.originalSkinWeight = nil
  end
  local setting = FunctionPerformanceSetting.Me()
  setting:SetBloom(cacheBloomSetting.bloom)
  setting:SetFxaa(cacheBloomSetting.fxaa)
  setting:ApplyBloom()
  setting:ApplyFxaa()
end

function PerformanceManager:ResetBloom()
  local setting = FunctionPerformanceSetting.Me()
  setting:SetBloom(self.defaultBloom)
  setting:ApplyBloom()
  setting:SetFxaa(self.defaultFxaa)
  setting:ApplyFxaa()
end

function PerformanceManager:SetLODShader(level)
  if self.lodShader ~= level then
    Shader.globalMaximumLOD = level
    self.lodShader = level
  end
end

function PerformanceManager:SetDefaultLODShader(level)
  self.defaultLODShader = level
end

function PerformanceManager:SetDefaultBloom(level)
  self.defaultBloom = level
end

function PerformanceManager:SetDefaultEffect(level)
  self.defaultEffect = level
end

function PerformanceManager:SetDefaultFxaa(on)
  self.defaultFxaa = on
end

function PerformanceManager:ResetLOD()
  self:SetLODShader(self.defaultLODShader)
  self:SimplifyRolePart(true)
end

function PerformanceManager:LODLow()
  self:SetLODShader(LODShader.Low)
  self:SimplifyRolePart(true)
end

function PerformanceManager:LODHigh()
  self:SetLODShader(LODShader.High)
  self:SimplifyRolePart(false)
end

function PerformanceManager:SetSkinWeight(weight)
  if self.skinWeight ~= weight then
    QualitySettings.skinWeights = weight
    self.skinWeight = weight
  end
end

function PerformanceManager:SkinWeightHigh(var)
  if var then
    self:FourBone()
  else
    self:ResetBone()
  end
end

function PerformanceManager:ResetBone()
  self:SetSkinWeight(SkINWEIGHT.Two)
end

function PerformanceManager:FourBone()
  self:SetSkinWeight(SkINWEIGHT.Four)
end

function PerformanceManager:SimplifyRolePart(on)
  if BackwardCompatibilityUtil.CompatibilityMode_V48 then
    return
  end
  local myself = Game.Myself
  if myself ~= nil then
    SetSimplifyRolePart(myself, on)
  end
  NSceneUserProxy.Instance:ForEach(SetSimplifyRolePart, on)
end

function PerformanceManager:SetLODEffect(level)
  if BackwardCompatibilityUtil.CompatibilityMode_V52 then
    return
  end
  if self.lodEffect ~= level then
    ModelEpPointRefs.SetAllNodes(level)
    self.lodEffect = level
  end
end

function PerformanceManager:GetLODEffect(gameObject, level)
  if BackwardCompatibilityUtil.CompatibilityMode_V52 then
    return
  end
  return ModelEpPointRefs.SetNodesByGameObject(gameObject, level)
end

function PerformanceManager:ResetLODEffect()
  self:SetLODEffect(LODLevel.Mid)
end

function PerformanceManager:HighLODEffect()
  if self.lodEffect == LODLevel.Low then
    return
  end
  self:SetLODEffect(LODLevel.High)
end

function PerformanceManager:LowLODEffect()
  self:SetLODEffect(LODLevel.Low)
end

function PerformanceManager:SetOutline(val)
  RenderingManager.Instance:SetOutline(val)
end

function PerformanceManager:SetFrameCount(frameRate)
  RenderingManager.Instance:SetCustomFrameCount(frameRate)
end

function PerformanceManager:SetUICameraClearAll(val)
  RenderingManager.Instance:SetUICameraClearAll(val)
end

function PerformanceManager:SetShadowSize(texSize)
  RenderingManager.Instance:SetShadowSize(texSize)
end

function PerformanceManager:SetSRPBatch(val)
  RenderingManager.Instance:SetSRPBatch(val)
end

function PerformanceManager:SetURPAssetParam(params)
  if not params then
    return
  end
  local p = RenderingManager.Instance:GetNowURPAssetParam()
  if params.mainLightRenderingMode then
    p.mainLightRenderingMode = params.mainLightRenderingMode
  end
  if params.additionalLightsRenderingMode then
    p.additionalLightsRenderingMode = params.additionalLightsRenderingMode
  end
  if params.shadowCascadeOption then
    p.shadowCascadeOption = params.shadowCascadeOption
  end
  if params.mainLightShadowmapResolution then
    p.mainLightShadowmapResolution = params.mainLightShadowmapResolution
  end
  if params.renderScale then
    p.renderScale = params.renderScale
  end
  RenderingManager.Instance:UpdateURPAssetParam(p)
end
