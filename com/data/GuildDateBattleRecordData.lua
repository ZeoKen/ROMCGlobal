local _modeName
local GetModeName = function(type)
  if not _modeName then
    _modeName = {
      [GuildCmd_pb.EGUILDDATEBATTLETYPE_BASE] = ZhString.GuildDateBattle_Mode_Base,
      [GuildCmd_pb.EGUILDDATEBATTLETYPE_DEATH] = ZhString.GuildDateBattle_Mode_Death,
      [GuildCmd_pb.EGUILDDATEBATTLETYPE_BLOOD] = ZhString.GuildDateBattle_Mode_Blood
    }
  end
  return _modeName[type]
end
local GvGDateBattleExtraInfo = class("GvGDateBattleExtraInfo")

function GvGDateBattleExtraInfo:ctor(srv_info)
  self.type = srv_info.type or 0
  self.isBaseMode = self.type == GuildCmd_pb.EGUILDDATEBATTLETYPE_BASE
  self.type_name = GetModeName(self.type)
  self.cardids = {}
  if srv_info.cardids then
    for i = 1, #srv_info.cardids do
      self.cardids[#self.cardids + 1] = srv_info.cardids[i]
    end
  end
  self.target_num = srv_info.target_num or 0
  self:SetTypeDesc()
end

function GvGDateBattleExtraInfo:SetTypeDesc()
  if self.type == GuildCmd_pb.EGUILDDATEBATTLETYPE_DEATH then
    self.type_desc = string.format(ZhString.GuildDateBattle_Mode_Death_Desc, self.target_num)
  elseif self.type == GuildCmd_pb.EGUILDDATEBATTLETYPE_BLOOD then
    self.type_desc = string.format(ZhString.GuildDateBattle_Mode_Blood_Desc, self.target_num)
  else
    self.type_desc = ""
  end
end

function GvGDateBattleExtraInfo:GetBanCardIds()
  return self.cardids
end

function GvGDateBattleExtraInfo:GetModeName()
  return self.type_name
end

function GvGDateBattleExtraInfo:GetDatedModeDesc()
  if self.isBaseMode then
    return self.type_name
  end
  return self.type_name .. "\n" .. self.type_desc
end

autoImport("GuildHeadData")
GuildDateBattleRecordData = class("GuildDateBattleRecordData")
local Pb = GuildCmd_pb
local EState = E_GuildDateBattle_State
local ESort = E_GuildDateBattle_SortID
local FinishedState = {
  [EState.Win] = 1,
  [EState.Failed] = 1,
  [EState.Invalid] = 1
}
local GoingState = {
  [EState.OnMatch] = 1,
  [EState.PreEnter] = 1
}
local DeActiveState = {
  [EState.Win] = 1,
  [EState.Failed] = 1,
  [EState.Refused] = 1
}
local UnderApprovalState = {
  [EState.UnderApproval_Me] = 1,
  [EState.UnderApproval_Other] = 1
}
local InvalidStampState = {
  [EState.OnMatch] = 1,
  [EState.Invalid] = 1,
  [EState.PreEnter] = 1,
  [EState.UnderApproval_Other] = 1
}
local Undefined = "Undefined"
local stateDescConfig, complexStateDescConfig
local GetStateDesc = function(state)
  if not stateDescConfig then
    stateDescConfig = {
      [EState.OnMatch] = ZhString.GuildDateBattle_State_OnMatch,
      [EState.PreEnter] = ZhString.GuildDateBattle_State_PreEnter,
      [EState.UnderApproval_Me] = ZhString.GuildDateBattle_State_UnderApproval_Me,
      [EState.UnderApproval_Other] = ZhString.GuildDateBattle_State_UnderApproval,
      [EState.Win] = ZhString.GuildDateBattle_State_Win,
      [EState.Failed] = ZhString.GuildDateBattle_State_Failed,
      [EState.Refused] = ZhString.GuildDateBattle_State_Refused,
      [EState.Invalid] = ZhString.GuildDateBattle_State_Invalid
    }
  end
  if not complexStateDescConfig then
    complexStateDescConfig = {
      [EState.OnMatch] = ZhString.GuildDateBattle_State_OnMatch,
      [EState.PreEnter] = ZhString.GuildDateBattle_State_PreEnter,
      [EState.UnderApproval_Me] = ZhString.GuildDateBattle_State_UnderApproval_Me_Complex,
      [EState.UnderApproval_Other] = ZhString.GuildDateBattle_State_UnderApproval_Complex,
      [EState.Win] = ZhString.GuildDateBattle_State_Win,
      [EState.Failed] = ZhString.GuildDateBattle_State_Failed,
      [EState.Refused] = ZhString.GuildDateBattle_State_Refused,
      [EState.Invalid] = ZhString.GuildDateBattle_State_Invalid
    }
  end
  return stateDescConfig[state] or "", complexStateDescConfig[state] or ""
end
local Date_format = "%04d-%02d-%02d %02d:%02d"
local IsEmpty = StringUtil.IsEmpty

function GuildDateBattleRecordData:ctor(srv_data, target_guild_id)
  self.id = srv_data.id
  self.target_guild_id = target_guild_id
  self.defGuildHeadData = GuildHeadData.new()
  self.offGuildHeadData = GuildHeadData.new()
  self:Update(srv_data)
end

function GuildDateBattleRecordData:GetSelfGuildId()
  if not self.my_guild_id then
    self.my_guild_id = self.target_guild_id or GuildProxy.Instance:GetOwnGuildID()
  end
  return self.my_guild_id
end

function GuildDateBattleRecordData:GetServerId()
  return self.atkServerId
end

function GuildDateBattleRecordData:Update(srv_data)
  self.atkGuildid = srv_data.atk_guildid
  self.atkGuildName = IsEmpty(srv_data.atk_guildname) and ZhString.GuildDate_EmptyGuild or srv_data.atk_guildname
  self.atkGuildPortrait = srv_data.atk_guildportrait
  self.offGuildHeadData:SetBy_InfoId(self.atkGuildPortrait)
  self.offGuildHeadData:SetGuildId(self.atkGuildid)
  self.atkServerId = srv_data.atk_serverid
  self.defGuildid = srv_data.def_guildid
  self.defGuildName = IsEmpty(srv_data.def_guildname) and ZhString.GuildDate_EmptyGuild or srv_data.def_guildname
  self.defGuildPortrait = srv_data.def_guildportrait
  self.defGuildHeadData:SetBy_InfoId(self.defGuildPortrait)
  self.defGuildHeadData:SetGuildId(self.defGuildid)
  self.defServerId = srv_data.def_serverid
  self:SetStamp(srv_data.battle_starttime)
  self.inviteTime = srv_data.invite_time
  self:SetInviteStamp(self.inviteTime)
  self.mode = srv_data.mode
  self.winner = srv_data.winner_guildid
  self.offLeaderId = srv_data.atk_chairmanid or 0
  self.defLeaderId = srv_data.def_chairmanid or 0
  self:SetState(srv_data.state)
  self:SetStaticData()
  self:SetSortID()
  self:SetExtraInfo(srv_data.info)
end

function GuildDateBattleRecordData:SetExtraInfo(info)
  if not info then
    return
  end
  self.extraInfo = GvGDateBattleExtraInfo.new(info)
end

function GuildDateBattleRecordData:GetDatedModeDesc()
  if self.extraInfo then
    return self.extraInfo:GetDatedModeDesc()
  end
  return ""
end

function GuildDateBattleRecordData:GetGameMode()
  return self.extraInfo and self.extraInfo.type or 0
end

function GuildDateBattleRecordData:GetBanCardIds(forceGetFromGvGRecord)
  if forceGetFromGvGRecord then
    return self.extraInfo and self.extraInfo:GetBanCardIds() or _EmptyTable
  end
  if self.extraInfo then
    return self.extraInfo:GetBanCardIds()
  else
    return PvpCustomRoomProxy.Instance:GetSavedForbidCards(ProtoCommon_pb.EFORBID_CARD_TYPE_GUILD_DATEBATTLE)
  end
end

function GuildDateBattleRecordData:SetSortID()
  if self:IsGoing() then
    self.sortID = ESort.Valid
  elseif self:IsUnderApproval() then
    self.sortID = ESort.Approval
  elseif self:IsFinished() or self:IsRefused() then
    self.sortID = ESort.InValid
  else
    self.sortID = ESort.UnDefined
  end
end

function GuildDateBattleRecordData:GetOppositeGuildName()
  local my_guild_id = self:GetSelfGuildId()
  if my_guild_id == self.defGuildid then
    return self:GetOffGuildName()
  else
    return self:GetDefGuildName()
  end
end

function GuildDateBattleRecordData:GetOppositeGuild()
  local my_guild_id = self:GetSelfGuildId()
  if my_guild_id == self.defGuildid then
    return self.atkGuildName, self.atkGuildid, self.atkGuildPortrait
  else
    return self.defGuildName, self.defGuildid, self.defGuildPortrait
  end
end

function GuildDateBattleRecordData:SetStamp(battle_starttime)
  self.stamp = battle_starttime
  if not self.stamp then
    return
  end
  self.year = tonumber(os.date("%Y", self.stamp))
  self.month = tonumber(os.date("%m", self.stamp))
  self.day = tonumber(os.date("%d", self.stamp))
  self.hour = tonumber(os.date("%H", self.stamp))
  self.osStamp = os.time({
    year = self.year,
    month = self.month,
    day = self.day,
    hour = self.hour,
    min = 0,
    sec = 0
  })
end

function GuildDateBattleRecordData:SetInviteStamp(invite_time)
  self.inviteYear = tonumber(os.date("%Y", invite_time))
  self.inviteMonth = tonumber(os.date("%m", invite_time))
  self.inviteDay = tonumber(os.date("%d", invite_time))
end

function GuildDateBattleRecordData:MatchCurrentDay()
  local curServerTime = ServerTime.CurServerTime() / 1000
  local date = os.date("*t", curServerTime)
  if date.year == self.inviteYear and date.month == self.inviteMonth and date.day == self.inviteDay then
    return true
  end
  return false
end

function GuildDateBattleRecordData:IsSameStamp(y, m, d, h)
  return self.year == y and self.month == m and self.day == d and self.hour == h
end

function GuildDateBattleRecordData:GetClock()
  return self.hour
end

function GuildDateBattleRecordData:SetState(state)
  self.serverState = state
  if not self.serverState or self.serverState == 0 then
    return
  end
  local _, opposite_guild_id = self:GetOppositeGuild()
  if self.serverState == Pb.EGUILDDATEBATTLESTATE_INVITE then
    local my_guild_id = self:GetSelfGuildId()
    self.state = self.atkGuildid == my_guild_id and EState.UnderApproval_Other or EState.UnderApproval_Me
  elseif self.serverState == Pb.EGUILDDATEBATTLESTATE_REFUSE then
    self.state = EState.Refused
  elseif self.serverState == Pb.EGUILDDATEBATTLESTATE_READY then
    self.state = EState.PreEnter
  elseif self.serverState == Pb.EGUILDDATEBATTLESTATE_ING then
    self.state = EState.OnMatch
  elseif self.serverState == Pb.EGUILDDATEBATTLESTATE_END then
    self.state = self.winner == opposite_guild_id and EState.Failed or EState.Win
  else
    self.state = EState.Invalid
  end
  self.stateName, self.complexStateName = GetStateDesc(self.state)
end

function GuildDateBattleRecordData:SetStaticGameConfig()
  local mode_config = GuildDateBattleProxy.GetModeConfig()
  local config = mode_config and mode_config[self.mode]
  if config then
    self.modeName = config.name or Undefined
    self.modeDesc = config.client_desc or Undefined
    self.duration = config.duration or 0
  else
    self.modeName = Undefined
    self.modeDesc = Undefined
    self.duration = 0
  end
end

function GuildDateBattleRecordData:ResetMode(mode)
  if mode == self.mode then
    return
  end
  self.mode = mode
  self:SetStaticGameConfig()
end

function GuildDateBattleRecordData:SetStaticData()
  self:SetStaticGameConfig()
  if self.inviteTime then
    local longest_approval_time = GameConfig.GuildDateBattle and GameConfig.GuildDateBattle.longest_approval_time
    self.longestApprovalStamp = self.inviteTime + longest_approval_time
  end
  if self.stamp then
    local last_approval_time = GameConfig.GuildDateBattle and GameConfig.GuildDateBattle.last_approval_time
    self.lastApprovalStamp = self.stamp - last_approval_time
  end
end

function GuildDateBattleRecordData:GetAutoRefuseTime()
  return math.min(self.lastApprovalStamp, self.longestApprovalStamp)
end

function GuildDateBattleRecordData:GetDefGuildName()
  return self.defGuildName
end

function GuildDateBattleRecordData:GetOffGuildName()
  return self.atkGuildName
end

function GuildDateBattleRecordData:GetModeName()
  return self.modeName
end

function GuildDateBattleRecordData:GetModeDesc()
  return self.modeDesc
end

function GuildDateBattleRecordData:GetModeDuration()
  return self.duration
end

function GuildDateBattleRecordData:IsFinished()
  return nil ~= FinishedState[self.state]
end

function GuildDateBattleRecordData:IsGoing()
  return nil ~= GoingState[self.state]
end

function GuildDateBattleRecordData:IsUnderApproval()
  return nil ~= UnderApprovalState[self.state]
end

function GuildDateBattleRecordData:IsUnderApproval_Other()
  return self.state == EState.UnderApproval_Other
end

function GuildDateBattleRecordData:IsUnderApproval_Me()
  return self.state == EState.UnderApproval_Me
end

function GuildDateBattleRecordData:IsRefused()
  return self.state == EState.Refused
end

function GuildDateBattleRecordData:IsPreEnter()
  return self.state == EState.PreEnter
end

function GuildDateBattleRecordData:IsWin()
  return self.state == EState.Win
end

function GuildDateBattleRecordData:IsFailed()
  return self.state == EState.Failed
end

function GuildDateBattleRecordData:IsInValid()
  return self.state == EState.Invalid
end

function GuildDateBattleRecordData:IsOnMatch()
  return self.state == EState.OnMatch
end

function GuildDateBattleRecordData:IsInvalidStamp()
  return nil ~= InvalidStampState[self.state]
end

function GuildDateBattleRecordData:IsDeActive()
  return nil ~= DeActiveState[self.state]
end

function GuildDateBattleRecordData:GetStateStr()
  return self.stateName
end

function GuildDateBattleRecordData:GetComplexStateStr()
  return self.complexStateName
end

function GuildDateBattleRecordData:GetDateStampStr()
  if not self.stampStr then
    local year = tonumber(os.date("%Y", self.stamp))
    local month = tonumber(os.date("%m", self.stamp))
    local day = tonumber(os.date("%d", self.stamp))
    local hour = tonumber(os.date("%H", self.stamp))
    local min = tonumber(os.date("%M", self.stamp))
    self.stampStr = string.format(Date_format, year, month, day, hour, min)
  end
  return self.stampStr
end

function GuildDateBattleRecordData:GetStamp()
  return self.stamp
end
