TeamInvitee = class("TeamInvitee")

function TeamInvitee:SetId(id, cat)
  self.id = id
  self.cat = cat
  self:reset()
end

function TeamInvitee:reset()
  self.team_id = nil
  self.group_team_id = nil
  self.team_member_count = nil
  self.team_cfg_id = nil
  self.isGroupInvite = nil
end

function TeamInvitee:SetTeamInfo(server_data)
  self.team_id = server_data.teamid
  self.group_team_id = server_data.groupteamid
  self.team_member_count = server_data.team_member_count
  self.team_cfg_id = server_data.teamcfgid
end

function TeamInvitee:IsGroupInvite(var)
  self.isGroupInvite = var
end

function TeamInvitee:IsTeam()
  return self.team_id and self.team_id ~= 0 and not self:IsGroupTeam()
end

function TeamInvitee:IsMultiMember()
  return self:IsTeam() and self.team_member_count and self.team_member_count > 1
end

function TeamInvitee:IsGroupTeam()
  return self.group_team_id and self.group_team_id ~= 0
end

function TeamInvitee:IsTeamFull()
  if self.team_cfg_id and self.team_member_count then
    local maxmember = TeamData.MaxMemberCount(self.team_cfg_id)
    return maxmember <= self.team_member_count
  end
  return false
end

function TeamInvitee:IsSingle()
  return self.team_member_count and self.team_member_count == 1
end

function TeamInvitee:IsCat()
  return nil ~= self.cat
end
