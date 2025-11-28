local Undefined = "Undefined"
autoImport("GuildDateBattleRecordData")
autoImport("GvGPerfectTimeInfo")
GuildDateBattleEntranceData = class("GuildDateBattleEntranceData")

function GuildDateBattleEntranceData:ctor(svr_record)
  self.recordData = GuildDateBattleRecordData.new(svr_record)
  self.end_time = self.recordData.stamp + self.recordData.duration
  redlog("[公会约战]入口截止时间", self.end_time)
end

function GuildDateBattleEntranceData:SetEntrance(srv_data)
  self.atk_member_count = srv_data.atk_member_count
  self.def_member_count = srv_data.def_member_count
  self.hp = srv_data.boss_hp or 1000
  self.perfect_end_time = GvGPerfectTimeInfo.new(srv_data.perfect_time)
  self.death_count = srv_data.death_count or 0
  self.atk_kill_count = srv_data.atk_kill_count or 0
  self.def_kill_count = srv_data.def_kill_count or 0
end

function GuildDateBattleEntranceData:GetEndTime()
  return self.end_time
end

function GuildDateBattleEntranceData:GetRecordData()
  return self.recordData
end

function GuildDateBattleEntranceData:GetModel()
  return self.recordData.mode
end

function GuildDateBattleEntranceData:GetModeDesc()
  return self.recordData.modeDesc
end

function GuildDateBattleEntranceData:GetModeName()
  return self.recordData:GetModeName()
end

function GuildDateBattleEntranceData:GetDefGuildName()
  return self.recordData:GetDefGuildName()
end

function GuildDateBattleEntranceData:GetOffGuildName()
  return self.recordData:GetOffGuildName()
end

function GuildDateBattleEntranceData:GetId()
  return self.recordData.id
end

function GuildDateBattleEntranceData:GetBattleStartTime()
  return self.recordData.stamp
end

function GuildDateBattleEntranceData:GetBanCardIds()
  return self.recordData:GetBanCardIds(true)
end

function GuildDateBattleEntranceData:GetGameMode()
  return self.recordData:GetGameMode()
end

function GuildDateBattleEntranceData:GetDatedModeDesc()
  return self.recordData:GetDatedModeDesc()
end
