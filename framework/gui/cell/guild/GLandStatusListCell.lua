local EMvpState = GvgProxy.EMvpState
local Mvp_StateStr = {
  [EMvpState.Will_Summon] = ZhString.GvgLand_Mvp_State_WillSommon,
  [EMvpState.Summoned] = ZhString.GvgLand_Mvp_State_Sommoned,
  [EMvpState.Die] = ZhString.GvgLand_Mvp_State_Die
}
local friendStateStr = {
  [1] = ZhString.GvgLandPlanView_FriendState_TeamLeader,
  [2] = ZhString.GvgLandPlanView_FriendState_TeamGroupLeader,
  [3] = ZhString.GvgLandPlanView_FriendState_GuildLeader
}
local _SetLocalPositionGo = LuaGameObject.SetLocalPositionGO
local BaseCell = autoImport("BaseCell")
GLandStatusListCell = class("GLandStatusListCell", BaseCell)
GLandStatusList_CellEvent_Trace = "GLandStatusList_CellEvent_Trace"
GLandStatusList_CellEvent_FriendState = "GLandStatusList_CellEvent_FriendState"
autoImport("GuildHeadCell")

function GLandStatusListCell:Init()
  local guildHeadCellGO = self:FindGO("GuildHeadCell")
  self.headCell = GuildHeadCell.new(guildHeadCellGO)
  self.headCell:SetCallIndex(UnionLogo.CallerIndex.UnionList)
  self.city_name = self:FindComponent("CityName", UILabel)
  self.guild_name = self:FindComponent("GuildName", UILabel)
  self.status_desc = self:FindComponent("StatusDesc", UILabel)
  self.status_descXAxis = self.status_desc.gameObject.transform.localPosition.x
  self.mvp_status_desc = self:FindComponent("MvpStatusDesc", UILabel)
  self.trace_button = self:FindGO("TraceButton")
  self:AddClickEvent(self.trace_button, function(go)
    self:DoTrace()
  end)
  self.neutralSymbol = self:FindGO("NeutralSymbol")
  self.leadName = self:FindComponent("LeaderName", UILabel)
  self.cityIcon = self:FindComponent("CityScaleIcon", UISprite)
  self.mercenaryIcon = self:FindGO("MercenaryIcon")
  self.oldCityLabel = self:FindComponent("OldCityLabel", UILabel)
  self.oldCityLabel.text = ZhString.GvgLandPlanView_OldCity
  self.prepareCityLabel = self:FindComponent("PrepareCityLabel", UILabel)
  self.prepareCityLabel.text = ZhString.GvgLandPlanView_Prepare
  self.recommendStatusLab = self:FindComponent("RecommendStatusLab", UILabel)
  self.myGuildMemberCountLab = self:FindComponent("MyGuildMemberCountLab", UILabel)
  self.friendStateLab = self:FindComponent("FriendStateLab", UILabel)
  self:AddClickEvent(self.friendStateLab.gameObject, function(go)
    self:OnClickFriendState()
  end)
  self:AddCellClickEvent()
end

function GLandStatusListCell:DoTrace()
  self:PassEvent(GLandStatusList_CellEvent_Trace, self)
end

function GLandStatusListCell:OnClickFriendState()
  self:PassEvent(GLandStatusList_CellEvent_FriendState, self)
end

function GLandStatusListCell:IsTopCity()
  return self.data and self.data:ShowInTop()
end

function GLandStatusListCell:SetRecommendCity()
  if not self.data then
    return
  end
  if not self:IsTopCity() then
    return
  end
  self:Hide(self.mvp_status_desc)
  self:Hide(self.status_desc)
  self:Show(self.recommendStatusLab)
  self:SetRecommendStatus()
  if self.data.friend_state and self.data.friend_state > 0 then
    self:Show(self.friendStateLab)
    self.friendStateLab.text = friendStateStr[self.data.friend_state]
  else
    self:Hide(self.friendStateLab)
  end
  self:Show(self.myGuildMemberCountLab)
  self.myGuildMemberCountLab.text = string.format(ZhString.GvgLandPlanView_MyGuildMemberCount, self.data.my_guild_member_count)
end

function GLandStatusListCell:SetRecommendStatus()
  self:ClearCalmEndTimeTick()
  local calm_end_time = self.data.calm_end_time
  if calm_end_time and calm_end_time > ServerTime.CurServerTime() / 1000 then
    self:CreateCalmEndTimeTick()
  elseif self.data.state == GuildCmd_pb.EGCITYSTATE_PERFECT and self.data.mvp_state == GvgProxy.EMvpState.Die then
    self.recommendStatusLab.text = ZhString.GvgLandPlanView_PerfectDefense
  else
    self.recommendStatusLab.text = self.data.atk_count and self.data.atk_count >= 0 and string.format(ZhString.GvgLandPlanView_AtkCount, self.data.atk_count) or ""
  end
end

local debug_error_state = "NO CONFIG DESC:%d"

function GLandStatusListCell:SetStateDesc()
  if not self.data then
    return
  end
  if self:IsTopCity() then
    return
  end
  self:Hide(self.friendStateLab)
  self:Hide(self.myGuildMemberCountLab)
  self:Hide(self.recommendStatusLab)
  local mvp_state = self.data.mvp_state
  local statueDescYAxis = 0
  if mvp_state and mvp_state ~= GvgProxy.EMvpState.None then
    self:Show(self.mvp_status_desc)
    statueDescYAxis = 5
    if mvp_state == GvgProxy.EMvpState.Will_Summon then
      if self.data.mvp_summon_time > ServerTime.CurServerTime() / 1000 then
        self.tick_str = Mvp_StateStr[mvp_state]
        self:CreateMvpSummonTick()
      else
        redlog("服务器设置状态未召唤， mvp_summon_time小于服务器时间| cityid", self.data.mvp_summon_time, self.data.cityid)
        TableUtil.Print(self.data)
        self.mvp_status_desc.text = Mvp_StateStr[EMvpState.Summoned]
      end
    else
      self.mvp_status_desc.text = Mvp_StateStr[mvp_state]
    end
  else
    self:Hide(self.mvp_status_desc)
  end
  _SetLocalPositionGo(self.status_desc.gameObject, self.status_descXAxis, statueDescYAxis, 0)
  local state = self.data.state
  if state then
    local gland_status_desc = GameConfig.GVGConfig.gland_status_desc or _EmptyTable
    self.status_desc.text = gland_status_desc[self.data.state] or string.format(debug_error_state, self.data.state)
  end
end

function GLandStatusListCell:CreateMvpSummonTick()
  self.mvpSummonTick = TimeTickManager.Me():CreateTick(0, 1000, self._UpdateSummonTick, self, 1)
end

function GLandStatusListCell:CreateCalmEndTimeTick()
  if self.camlEndTick then
    return
  end
  self.camlEndTick = TimeTickManager.Me():CreateTick(0, 1000, self._UpdateCalmEndTimeTick, self, 2)
end

function GLandStatusListCell:_UpdateCalmEndTimeTick()
  local server_time = ServerTime.CurServerTime() / 1000
  local calm_end_time = self.data and self.data.calm_end_time
  if not calm_end_time or server_time >= calm_end_time then
    self:ClearCalmEndTimeTick()
    return
  end
  self.recommendStatusLab.text = string.format(ZhString.GvgLandPlanView_StartFight, calm_end_time - server_time)
end

function GLandStatusListCell:ClearCalmEndTimeTick()
  if not self.camlEndTick then
    return
  end
  self.camlEndTick:Destroy()
  self.camlEndTick = nil
end

function GLandStatusListCell:_UpdateSummonTick()
  local server_time = ServerTime.CurServerTime() / 1000
  local mvp_summon_time = self.data and self.data.mvp_summon_time
  if not mvp_summon_time or server_time > mvp_summon_time or not self.tick_str then
    self:ClearMvpSummonTick()
    return
  end
  local left_time = mvp_summon_time - server_time
  if 0 < left_time then
    self.mvp_status_desc.text = string.format(self.tick_str, left_time)
  else
    self:ClearMvpSummonTick()
  end
end

function GLandStatusListCell:OnCellDestroy()
  self:ClearMvpSummonTick()
  self:ClearCalmEndTimeTick()
end

function GLandStatusListCell:ClearMvpSummonTick()
  if not self.mvpSummonTick then
    return
  end
  self.mvpSummonTick:Destroy()
  self.mvpSummonTick = nil
  self.tick_str = nil
end

function GLandStatusListCell:SetData(data)
  self.data = data
  self:ClearMvpSummonTick()
  self:ClearCalmEndTimeTick()
  if data == nil then
    self.gameObject:SetActive(false)
    return
  end
  self.gameObject:SetActive(true)
  self.data_cityid = data.cityid
  self.data_guildid = data.guildid
  self.data_groupid = data.groupid
  self.data_oldguildid = data.oldguildid
  local land_config = GvgProxy.GetStrongHoldStaticData(data.cityid)
  if land_config ~= nil then
    self.city_name.text = land_config.Name
  else
    self.city_name.text = "NO CONFIG LAND:" .. tostring(data.cityid)
    self.gameObject:SetActive(false)
    return
  end
  self:SetStateDesc()
  self:SetRecommendCity()
  self.is_neutral = data.name == nil or data.name == ""
  if self.is_neutral then
    self.guild_name.text = "[c][6c6c6cff]------------[-][/c]"
  else
    self.guild_name.text = data.name
  end
  self.mercenaryIcon:SetActive(data:IsMyMercenaryGuildCity())
  self.oldCityLabel.gameObject:SetActive(data:IsMyOldCity())
  self.prepareCityLabel.gameObject:SetActive(data:IsMyPrepareCity())
  if data.portrait == "" then
    self.data_portrait = 61
  else
    local portrait_num = tonumber(data.portrait)
    if portrait_num == nil then
      self.data_portrait = data.portrait
    else
      self.data_portrait = portrait_num
    end
  end
  self:SetGuildHeadIcon()
  if self.leadName then
    self.leadName.text = data.leadername or ""
  end
  local cityConfig = GvgProxy.GetStrongHoldStaticData(data.cityid or 0)
  if cityConfig then
    self.cityIcon.gameObject:SetActive(true)
    if cityConfig.Icon then
      IconManager:SetUIIcon(cityConfig.Icon, self.cityIcon)
    end
    if cityConfig.IconColor then
      local hasC, resultC = ColorUtil.TryParseHexString(cityConfig.IconColor)
      self.cityIcon.color = resultC
    end
  else
    self.cityIcon.gameObject:SetActive(false)
  end
end

function GLandStatusListCell:GetMyGuildHeadData()
  if self.myGuildHeadData == nil then
    self.myGuildHeadData = GuildHeadData.new()
  end
  self.myGuildHeadData:SetBy_InfoId(self.data_portrait)
  self.myGuildHeadData:SetGuildId(self.data_guildid)
  return self.myGuildHeadData
end

function GLandStatusListCell:SetGuildHeadIcon()
  if self.is_neutral then
    self.headCell:SetData(nil)
    self.neutralSymbol:SetActive(true)
    return
  end
  self.neutralSymbol:SetActive(false)
  self.headCell:SetData(self:GetMyGuildHeadData())
end
