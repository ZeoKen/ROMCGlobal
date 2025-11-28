GvGCityShowData = class("GvGCityShowData")
GvGCityShowData.CitySortType = {
  Recommend_Old = 1,
  Recommend_Temp = 2,
  Recommend_FriendState = 3,
  Other = 4
}
local TopCitySortType = {
  [GvGCityShowData.CitySortType.Recommend_Old] = 1,
  [GvGCityShowData.CitySortType.Recommend_Temp] = 1,
  [GvGCityShowData.CitySortType.Recommend_FriendState] = 1
}

function GvGCityShowData:ctor(cityid, groupid)
  self.cityid = cityid
  self.groupid = groupid
  self.occupy_guilds = {}
end

function GvGCityShowData:SetTop(var)
  self.show_in_top = var
end

function GvGCityShowData:ShowInTop()
  return self.show_in_top == true
end

function GvGCityShowData:SetSrvData(server_info)
  if not server_info then
    return
  end
  self.state = server_info.state
  self.guildid = server_info.guildid
  self.name = server_info.name
  self.portrait = server_info.portrait
  self.lv = server_info.lv
  self.membercount = server_info.membercount
  self.mvp_state = server_info.mvp_state
  self.mvp_summon_time = server_info.mvp_summon_time
  self.leadername = server_info.leadername
  self.oldguildid = server_info.oldguild
  if nil ~= server_info.roadblock then
    self.roadBlock = server_info.roadblock
  end
  self:UpdateOccupyGuilds(server_info.occupy_guilds)
  self.atk_count = server_info.attacker_count or 0
  self.friend_state = server_info.friend_state or 0
  self.my_guild_member_count = server_info.my_guild_member_count or 0
  self.calm_end_time = server_info.calm_end_time or 0
  self:SetCitySortType()
end

function GvGCityShowData:SetCitySortType()
  if self:IsMyOldCity() then
    self.sort_type = GvGCityShowData.CitySortType.Recommend_Old
  elseif self:IsMyTempCity() then
    self.sort_type = GvGCityShowData.CitySortType.Recommend_Temp
  elseif self.friend_state and self.friend_state ~= 0 then
    self.sort_type = GvGCityShowData.CitySortType.Recommend_FriendState
  else
    self.sort_type = GvGCityShowData.CitySortType.Other
  end
end

function GvGCityShowData:IsMyCity()
  return self:IsMyOldCity() or self:IsMyTempCity()
end

function GvGCityShowData:IsRecommendCity()
  return self.sort_type and nil ~= TopCitySortType[self.sort_type]
end

function GvGCityShowData:UpdateOccupyGuilds(srv_occupy_guilds)
  if not srv_occupy_guilds then
    return
  end
  TableUtility.TableClear(self.occupy_guilds)
  local guildid
  for i = 1, #srv_occupy_guilds do
    guildid = srv_occupy_guilds[i]
    if guildid and 0 < guildid then
      self.occupy_guilds[guildid] = 1
    end
  end
end

function GvGCityShowData:IsMyGuildOccupy()
  if self.occupy_guilds then
    return nil ~= self.occupy_guilds[GuildProxy.Instance.guildId] or nil ~= self.occupy_guilds[GuildProxy.Instance.myMercenaryGuildId]
  end
  return false
end

function GvGCityShowData:IsMyOldCity()
  if not GvgProxy.Instance:IsGvgFlagShow() then
    return false
  end
  local myGuildId = GuildProxy.Instance.guildId
  local myMercenaryGuildId = GuildProxy.Instance.myMercenaryGuildId
  return self.oldguildid == myGuildId or self.oldguildid == myMercenaryGuildId
end

function GvGCityShowData:IsMyTempCity()
  if self:IsMyOldCity() then
    return false
  end
  if not GvgProxy.Instance:IsGvgFlagShow() then
    return false
  end
  local myGuildId = GuildProxy.Instance.guildId
  local myMercenaryGuildId = GuildProxy.Instance.myMercenaryGuildId
  return self.guildid == myGuildId or self.guildid == myMercenaryGuildId
end

function GvGCityShowData:IsMyPrepareCity()
  if not GvgProxy.Instance:IsGvgFlagShow() then
    return false
  end
  if GvgProxy.Instance:CheckInSettleTime() then
    return false
  end
  return self.guildid ~= GuildProxy.Instance.guildId and self:IsMyGuildOccupy()
end

function GvGCityShowData:IsMyMercenaryGuildCity()
  if not GvgProxy.Instance:IsGvgFlagShow() then
    return false
  end
  return GuildProxy.Instance:IsMyMercenaryGuild(self.guildid)
end

function GvGCityShowData:HasRoadBlock()
  return self.roadBlock and self.roadBlock > 0
end
