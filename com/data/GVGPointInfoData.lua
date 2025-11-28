local gvg_total_point_count = 8
local _Occupy_effect = {
  Blue = EffectMap.Maps.Gvg_Occupy_Circle_Blue,
  Red = EffectMap.Maps.Gvg_Occupy_Circle_Red,
  White = EffectMap.Maps.Gvg_Occupy_Circle_White
}
local _Occupied_effect = {
  Blue = EffectMap.Maps.Gvg_Occupy_Circle_Success_Blue,
  Red = EffectMap.Maps.Gvg_Occupy_Circle_Success_Red
}
local _Vec3 = LuaVector3.Zero()
GVGPointInfoData = class("GVGPointInfoData")

function GVGPointInfoData:ctor(data)
  self.pointid = data.pointid
  self:InitConfig()
  self.state = data.state
  self.per = data.per
  self.guildid = data.guildid
  self.guildName = data.guildname
  self.guildPortrait = data.guildportrait
  self.smallMetalGuid = data.metal_guid
  self.isSmallMetalOccupied = data.metal_occupied
  self.occupiedGuilds = {}
  if data.occupied_guilds then
    for _, v in ipairs(data.occupied_guilds) do
      self.occupiedGuilds[v] = 1
    end
  end
  if nil ~= data.score then
    self.score = data.score
  end
  self:UpdateFlag()
  self:SetEffect()
end

function GVGPointInfoData:InitConfig()
  local static_data = GvgProxy.Instance:GetCurStrongHoldConfig()
  if not static_data then
    return
  end
  self.static_point_data = static_data.Point and static_data.Point[self.pointid]
end

function GVGPointInfoData:Update(data)
  local cacheState = self.state
  self.state = data.state
  self.guildid = data.guildid
  self.guildName = data.guildname
  self.guildPortrait = data.guildportrait
  self.per = data.per
  self.smallMetalGuid = data.metal_guid
  if not self.occupiedGuilds then
    self.occupiedGuilds = {}
  else
    TableUtility.TableClear(self.occupiedGuilds)
  end
  if data.occupied_guilds then
    for _, v in ipairs(data.occupied_guilds) do
      self.occupiedGuilds[v] = 1
    end
  end
  if self.pointid == GvgProxy.Instance:GetCurOccupingPointID() then
    GameFacade.Instance:sendNotification(GVGEvent.GVG_UpdatePointPercentTip)
  end
  if cacheState ~= self.state then
    self:UpdateFlag()
  end
  if nil ~= data.score then
    self.score = data.score
  end
  self:SetEffect()
end

function GVGPointInfoData:CheckScore()
  return self.score == true
end

function GVGPointInfoData:UpdateFlag()
  local flagManager = Game.GameObjectManagers[Game.GameObjectType.SceneGuildFlag]
  if not flagManager then
    return
  end
  local point_map = flagManager:GetPointMap(self.pointid)
  if not point_map or not next(point_map) then
    return
  end
  for config_point_uniqueid, _ in pairs(point_map) do
    self:_SetFlag(config_point_uniqueid)
  end
end

function GVGPointInfoData:_SetFlag(pointid)
  local flagManager = Game.GameObjectManagers[Game.GameObjectType.SceneGuildFlag]
  if not flagManager then
    return
  end
  if self:IsOccupied() then
    flagManager:ResetNewGvgFlag(pointid, self.guildPortrait, self.guildid)
  else
    flagManager:HideNewGvgFlag(pointid)
  end
end

function GVGPointInfoData:GetOccupyProcess()
  return self.per and self.per / 100 or 0
end

function GVGPointInfoData:HasMaxSmallmetal()
  local own = GvgProxy.Instance:GetSmallMetalCnt(self.guildid)
  local max = GameConfig.GVGConfig.occupy_smallmetal_maxcount or 5
  return own >= max
end

function GVGPointInfoData:IsOccupied()
  return self.state == GvgProxy.EpointState.Occupied
end

function GVGPointInfoData:IsSmallMetalOccupied()
  return self.isSmallMetalOccupied
end

function GVGPointInfoData:CheckSmallMetalExist()
  return nil ~= self.smallMetalGuid and 0 ~= self.smallMetalGuid
end

function GVGPointInfoData:GetOccupyGuildPortrait()
  if self:IsOccupied() then
    return tonumber(self.guildPortrait) or self.guildPortrait
  end
  return -1
end

function GVGPointInfoData:GetGuildID()
  return self.guildid
end

function GVGPointInfoData:IsMyGuildPoint()
  return GuildProxy.Instance:IsMyGuildUnion(self.guildid)
end

function GVGPointInfoData:GetOccupyEffectPath()
  if not (self:IsOccupied() or self.guildid) or 0 == self.guildid then
    return _Occupy_effect.White
  elseif self:IsMyGuildPoint() then
    return _Occupy_effect.Blue
  else
    return _Occupy_effect.Red
  end
end

function GVGPointInfoData:SetEffect()
  self:SetOccupyEffect()
  self:SetOccupySuccessEffect()
end

function GVGPointInfoData:SetOccupyEffect()
  if not self.pointid then
    return
  end
  if not self.static_point_data then
    return
  end
  local effect = self.occupyEffect
  if nil == effect then
    effect = self:AddOccupyEffect()
    self.occupyEffect = effect
  else
    local path = self:GetOccupyEffectPath()
    if effect:GetPath() ~= path then
      effect:Destroy()
      effect = self:AddOccupyEffect()
      self.occupyEffect = effect
    end
  end
end

function GVGPointInfoData:AddOccupyEffect()
  if not self.pointid then
    return
  end
  local path = self:GetOccupyEffectPath()
  if not path then
    return
  end
  if not self.static_point_data then
    return
  end
  local pos = self.static_point_data.pos
  LuaVector3.Better_Set(_Vec3, pos[1], pos[2], pos[3])
  local effect = Asset_Effect.PlayAt(path, _Vec3)
  local scale = self.static_point_data.range or 1
  effect:ResetLocalScale({
    scale,
    scale,
    scale
  })
  return effect
end

function GVGPointInfoData:RemoveOccupyEffect()
  if self.occupyEffect then
    self.occupyEffect:Destroy()
    self.occupyEffect = nil
  end
end

function GVGPointInfoData:RemoveOccupySuccessEffect()
  if self.occupySuccessEffect then
    self.occupySuccessEffect:Destroy()
    self.occupySuccessEffect = nil
  end
end

function GVGPointInfoData:OnClear()
  self:RemoveOccupyEffect()
  self:RemoveOccupySuccessEffect()
end

function GVGPointInfoData:SetOccupySuccessEffect()
  if not self.pointid then
    return
  end
  if not self.static_point_data then
    return
  end
  if not self:IsOccupied() then
    self:RemoveOccupySuccessEffect()
    return
  end
  local effect = self.occupySuccessEffect
  if nil == effect then
    effect = self:AddSuccessEffect()
    self.occupySuccessEffect = effect
  else
    local path = self:GetOccupySuccessEffect()
    if effect:GetPath() ~= path then
      effect:Destroy()
      effect = self:AddSuccessEffect()
      self.occupySuccessEffect = effect
    end
  end
end

function GVGPointInfoData:AddSuccessEffect()
  local path = self:GetOccupySuccessEffect()
  if not path then
    return
  end
  if not self.static_point_data then
    return
  end
  local pos = self.static_point_data.pos
  LuaVector3.Better_Set(_Vec3, pos[1], pos[2], pos[3])
  local effect = Asset_Effect.PlayAt(path, _Vec3)
  local scale = self.static_point_data.range or 1
  effect:ResetLocalScale({
    scale,
    scale,
    scale
  })
  return effect
end

function GVGPointInfoData:GetOccupySuccessEffect()
  if self:IsMyGuildPoint() then
    return _Occupied_effect.Blue
  else
    return _Occupied_effect.Red
  end
end

function GVGPointInfoData:CanGetRewardFromThisHold()
  local guildProxy = GuildProxy.Instance
  local gvgProxy = GvgProxy.Instance
  if gvgProxy:IsDefSide() then
    return false
  end
  if not gvgProxy:CanIGetMoreStrongHoldReward() then
    return false
  end
  local myGuildId = gvgProxy:GetGuildID()
  if not myGuildId then
    return false
  end
  if self.occupiedGuilds and self.occupiedGuilds[myGuildId] then
    return false
  end
  if not gvgProxy:CheckCurMapIsInGuildUnionGroup() then
    return false
  end
  return true
end
