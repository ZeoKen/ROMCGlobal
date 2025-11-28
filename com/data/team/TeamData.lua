autoImport("TeamMemberData")
TeamData = class("TeamData")
TeamData.INVALID_TEAMID = 0
TeamGoalType = {
  Around = 10010,
  EndlessTower = 10100,
  Laboratory = 10200,
  Dojo = 10300,
  RepairSeal = 10400
}
local MaxMember = GameConfig.Team.maxmember
TeamSummaryType = {}
local TeamSummaryTypeData = function(enum, valueName)
  if enum then
    TeamSummaryType[enum] = valueName
  else
    helplog("TeamData----> TeamSummaryType enum is nil! error valueName:", valueName)
  end
end
TeamSummaryTypeData(SessionTeam_pb.ETEAMDATA_TYPE, "type")
TeamSummaryTypeData(SessionTeam_pb.ETEAMDATA_MINLV, "minlv")
TeamSummaryTypeData(SessionTeam_pb.ETEAMDATA_MAXLV, "maxlv")
TeamSummaryTypeData(SessionTeam_pb.ETEAMDATA_OVERTIME, "overtime")
TeamSummaryTypeData(SessionTeam_pb.ETEAMDATA_MEMBERCOUNT, "membercount")
TeamSummaryTypeData(SessionTeam_pb.ETEAMDATA_AUTOACCEPT, "autoaccept")
TeamSummaryTypeData(SessionTeam_pb.ETEAMDATA_PICKUP_MODE, "pickupmode")
TeamSummaryTypeData(SessionTeam_pb.ETEAMDATA_STATE, "state")
TeamSummaryTypeData(SessionTeam_pb.ETEAMDATA_DESC, "desc")
TeamSummaryTypeData(SessionTeam_pb.ETEAMDATA_GROUP_TEAMID, "uniteteamid")
TeamSummaryTypeData(SessionTeam_pb.ETEAMDATA_GROUP_ID, "groupid")
TeamSummaryTypeData(SessionTeam_pb.ETEAMDATA_KICKOPEN, "kickopen")
TeamSummaryTypeData(SessionTeam_pb.ETEAMDATA_ALLOW_JOIN_GROUP, "allowjoin")
TeamSummaryTypeData(SessionTeam_pb.ETEAMDATA_NEED_FUNCTIONS, "teamRoles")
TeamSummaryTypeData(SessionTeam_pb.ETEAMDATA_PUBLISH_TIME, "publishTime")
TeamSummaryTypeData(SessionTeam_pb.ETEAMDATA_NO_CHANGE_MEM, "switchMemberState")

function TeamData:ctor(teamData)
  self.name = "No TeamName"
  self.membersMap = {}
  self.memberList = {}
  self.memberNum = 0
  self.groupApplyMap = {}
  self.applysMap = {}
  self.team1RolesList = {}
  self.team2RolesList = {}
  self.team1MemList = {}
  self.team2MemList = {}
  self:SetData(teamData)
  self.restoreMemberMap = {}
  self.restoreMemberJob = {}
end

function TeamData:SetData(teamData)
  if teamData then
    self.id = teamData.guid
    if teamData.items then
      self:SetSummary(teamData.items, teamData.name)
    end
    self:SetMembers(teamData.members)
    self:SetApplys(teamData.applys)
    if teamData.groupapplys then
      self:SetTeamGroupApply(teamData.groupapplys)
    end
  end
end

function TeamData:SetSummary(summaryes, name)
  if name and name ~= "" then
    local suffix = OverseasConfig.OriginTeamName
    self.name = name:gsub(suffix, OverSea.LangManager.Instance():GetLangByKey(suffix))
  end
  local team1Flag = false
  for i = 1, #summaryes do
    local item = summaryes[i]
    if item and item.type then
      local key = TeamSummaryType[item.type]
      if key then
        if key == "desc" then
          self[key] = item.strvalue
        elseif key == "membercount" then
          if nil == self[key] then
            self.team1MemberCount = item.value
          else
            self.team2MemberCount = item.value
          end
          self[key] = self[key] or 0
          self[key] = self[key] + item.value
        elseif key == "teamRoles" then
          if item.values then
            local roles = item.values
            if not team1Flag then
              TableUtility.ArrayClear(self.team1RolesList)
              for i = 1, #roles do
                table.insert(self.team1RolesList, roles[i])
              end
              team1Flag = true
            else
              TableUtility.ArrayClear(self.team2RolesList)
              for i = 1, #roles do
                table.insert(self.team2RolesList, roles[i])
              end
            end
            self[key] = 0
          end
        else
          self[key] = item.value
        end
      end
    end
  end
end

function TeamData:SetSeal(teamSealData)
end

function TeamData:SetMembers(datas)
  TableUtility.ArrayClear(self.team1MemList)
  TableUtility.ArrayClear(self.team2MemList)
  for i = 1, #datas do
    self:SetMember(datas[i])
  end
end

function TeamData:SetMember(data)
  local member = self:GetMemberByGuid(data.guid)
  if not member then
    member = self:AddMember(data)
  else
    member:SetData(data)
  end
  if data.teamid and data.teamid ~= 0 then
    if data.teamid == self.id then
      if not member:IsHireMember() then
        table.insert(self.team1MemList, member)
      end
    elseif not member:IsHireMember() then
      table.insert(self.team2MemList, member)
    end
  elseif not member:IsHireMember() then
    table.insert(self.team1MemList, member)
  end
  return member
end

function TeamData:AddMember(data)
  if data and data.guid then
    self.memberList_dirty = true
    local newMember = TeamMemberData.new(data)
    self.membersMap[data.guid] = newMember
    self.memberNum = self.memberNum + 1
    return newMember
  end
end

function TeamData:AddTeamMemberData(member)
  self.memberList_dirty = true
  self.membersMap[member.id] = member
  self.memberNum = self.memberNum + 1
end

function TeamData:RemoveMembers(deletelst)
  for i = 1, #deletelst do
    self:RemoveMember(deletelst[i])
  end
end

function TeamData:RemoveMember(guid)
  local catchMember = self:GetMemberByGuid(guid)
  if catchMember then
    self.memberList_dirty = true
    self.membersMap[guid] = nil
    self.memberNum = self.memberNum - 1
  end
  return catchMember
end

function TeamData:GetMemberByGuid(guid)
  return self.membersMap[guid]
end

function TeamData.MaxMemberCount(config_id)
  if TeamProxy.IsRoguelike(config_id) then
    return GameConfig.Team.Roguelike_maxmember
  else
    return GameConfig.Team.maxmember
  end
end

function TeamData:IsTeamFull()
  local maxmember = TeamData.MaxMemberCount(self.type)
  return maxmember <= self.team1MemberCount
end

function TeamData:IsRoguelikeTeamFull()
  return self.team1MemberCount > GameConfig.Team.Roguelike_maxmember
end

function TeamData:IsGroupTeamFull()
  return self.membercount >= 2 * GameConfig.Team.maxmember
end

function TeamData:GetMembersList()
  if self.memberList_dirty then
    self.memberList_dirty = false
    TableUtility.ArrayClear(self.memberList)
    for _, v in pairs(self.membersMap) do
      table.insert(self.memberList, v)
    end
    table.sort(self.memberList, TeamData.SortTeamMember)
  end
  return self.memberList
end

function TeamData:GetFullMembers()
  local result = {}
  local realMembers = self:GetMembersList()
  for i = 1, #realMembers do
    table.insert(result, realMembers[i])
  end
  local teamNum = GameConfig.Team.maxmember
  if self:IsGroupTeam() then
    if #realMembers < teamNum * 2 then
      for i = #realMembers + 1, teamNum * 2 do
        table.insert(result, 0)
      end
    end
  elseif teamNum > #realMembers then
    for i = #realMembers + 1, teamNum do
      table.insert(result, 0)
    end
  end
  return result
end

function TeamData.SortTeamMember(ma, mb)
  if ma.id ~= mb.id then
    return ma.id < mb.id
  end
  if ma.cat ~= nil and mb.cat ~= nil then
    return ma.cat < mb.cat
  end
  return false
end

function TeamData:GetMemberMap()
  return self.membersMap
end

function TeamData:SetApplys(applys, isunite)
  for i = 1, #applys do
    self:SetApply(applys[i], isunite)
  end
end

function TeamData:UpdateTeamGroupApply(data)
  local GTApply = {}
  GTApply.name = data.name
  GTApply.memNum = data.memnum
  GTApply.id = data.teamid
  GTApply.serverid = data.serverid
  self.groupApplyMap[data.teamid] = GTApply
  if TeamProxy.Instance:CheckIHaveGroupLeaderAuthority() then
    RedTipProxy.Instance:UpdateRedTip(SceneTip_pb.EREDSYS_TEAMAPPLY)
  end
end

function TeamData:SetTeamGroupApply(applys)
  for i = 1, #applys do
    self:UpdateTeamGroupApply(applys[i])
  end
end

function TeamData:SetApply(apply, isunite)
  local catchApply = self:GetApplyByGuid(apply.guid)
  if not catchApply then
    catchApply = self:AddApply(apply)
  else
    catchApply:SetData(apply)
  end
  catchApply.isunite = isunite
  return catchApply
end

function TeamData:AddApply(apply)
  if apply and apply.guid then
    local catchApply = TeamMemberData.new(apply)
    self.applysMap[apply.guid] = catchApply
    return catchApply
  end
end

function TeamData:RemoveApplys(deletelst)
  for i = 1, #deletelst do
    self:RemoveApply(deletelst[i])
  end
end

function TeamData:GetAroundTeamSortID()
  if self:IsGroupTeam() then
    if self:IsGroupTeamFull() then
      return 0
    end
  elseif self:IsTeamFull() then
    return 0
  end
  return self.membercount
end

function TeamData:RemoveApply(guid)
  local catchApply = self:GetApplyByGuid(guid)
  if catchApply then
    self.applysMap[guid] = nil
  end
  return catchApply
end

function TeamData:RemoveUniteApply()
  local removeid = {}
  for guid, v in pairs(self.applysMap) do
    if v.isunite then
      removeid[#removeid + 1] = guid
    end
  end
  self:RemoveApplys(removeid)
end

function TeamData:GetApplyByGuid(guid)
  return self.applysMap[guid]
end

function TeamData:GetApplyList()
  local result = {}
  for k, v in pairs(self.groupApplyMap) do
    result[#result + 1] = v
  end
  for k, v in pairs(self.applysMap) do
    result[#result + 1] = v
  end
  return result
end

function TeamData:GetGTApplyList()
  local data = {}
  for _, v in pairs(self.groupApplyMap) do
    data[#data + 1] = v
  end
  return data
end

function TeamData:UpdateGroupApply(updates, dels)
  if updates then
    for i = 1, #updates do
      self:UpdateTeamGroupApply(updates[i])
    end
  end
  if dels then
    for i = 1, #dels do
      self.groupApplyMap[dels[i]] = nil
    end
  end
end

function TeamData:ClearApplyList()
  TableUtility.TableClear(self.applysMap)
end

function TeamData:GetLeader()
  for _, mdata in pairs(self.membersMap) do
    if mdata.job == SessionTeam_pb.ETEAMJOB_LEADER then
      return mdata
    end
  end
end

function TeamData:GetTempLeader()
  for _, mdata in pairs(self.membersMap) do
    if mdata.job == SessionTeam_pb.ETEAMJOB_TEMPLEADER then
      return mdata
    end
  end
end

function TeamData:GetNowLeader()
  local leader = self:GetLeader()
  if leader and leader.offline == 0 then
    return leader
  end
  return self:GetTempLeader()
end

function TeamData:GetNowLeaderID()
  local leader = self:GetNowLeader()
  return leader and leader.id or 0
end

function TeamData:CheckInTeam(playerid)
  return self.membersMap[playerid] ~= nil
end

function TeamData:ClearTeamMembers()
  for key, member in pairs(self.membersMap) do
    member:Exit()
    self.membersMap[key] = nil
  end
end

function TeamData:IsGroupTeam()
  return nil ~= self.uniteteamid and 0 ~= self.uniteteamid
end

function TeamData:IsVoteKickOpen()
  return self.kickopen == 1
end

function TeamData:Exit()
  self:ClearTeamMembers()
end

function TeamData:StoreMembersData()
  if self.isMemberDataStored then
    return
  end
  self.isMemberDataStored = true
  for guid, member in pairs(self.membersMap) do
    self.restoreMemberMap[guid] = member
  end
end

function TeamData:RestoreMembersData()
  if not self.isMemberDataStored then
    return
  end
  self.isMemberDataStored = nil
  for guid, member in pairs(self.membersMap) do
    self:RemoveMember(guid)
  end
  for guid, member in pairs(self.restoreMemberMap) do
    self:AddTeamMemberData(member)
  end
end

function TeamData:ClearStoreMembersData()
  TableUtility.TableClear(self.restoreMemberMap)
  self.isMemberDataStored = nil
  for guid, member in pairs(self.membersMap) do
    self.restoreMemberMap[guid] = member
    self.restoreMemberJob[guid] = member.job
  end
  self.restoreGroupId = self.groupid
end

function TeamData:RestoreMembersData()
  if not self.isMemberDataStored then
    return
  end
  self.isMemberDataStored = nil
  for guid, member in pairs(self.membersMap) do
    self:RemoveMember(guid)
  end
  for guid, member in pairs(self.restoreMemberMap) do
    self:AddTeamMemberData(member)
    local job = self.restoreMemberJob[guid]
    if job then
      member.job = job
    end
  end
  self.groupid = self.restoreGroupId
  self:RefreshGroupTeamIndex()
end

function TeamData:ClearStoreMembersData()
  TableUtility.TableClear(self.restoreMemberMap)
  TableUtility.TableClear(self.restoreMemberJob)
  self.restoreGroupId = nil
  self.isMemberDataStored = nil
end

function TeamData:GetRoleMembers()
  return self.team1MemList, self.team2MemList
end

function TeamData:GetWantedRoles()
  return self.team1RolesList, self.team2RolesList
end

function TeamData:GetMaxMember()
  return MaxMember
end

function TeamData:GetRoles()
  local result = {}
  local rm1, rm2 = self:GetRoleMembers()
  local wr1, wr2 = self:GetWantedRoles()
  self:SetRoleList(result, rm1, wr1, self:GetMaxMember())
  if self:IsGroupTeam() then
    self:SetRoleList(result, rm2, wr2, self:GetMaxMember() * 2)
  end
  return result
end

function TeamData:SetRoleList(result, roles, wanted, Max)
  local role = 0
  if roles then
    for i = 1, #roles do
      if not roles[i]:IsHireMember() then
        role = roles[i]:GetRole()
        table.insert(result, role)
      end
    end
  end
  if Max > #result and wanted and 0 < #wanted then
    for i = 1, #wanted do
      table.insert(result, wanted[i] * -1)
    end
  end
  if Max > #result then
    for i = #result + 1, Max do
      table.insert(result, 0)
    end
  end
end

function TeamData:CheckValidRole(checkTeam2, role)
  local wr1, wr2 = self:GetWantedRoles()
  local rm1, rm2 = self:GetRoleMembers()
  local team1Flag, team2Flag = false, false
  team1Flag = self:CheckTeam(wr1, rm1, role)
  if checkTeam2 then
    team2Flag = self:CheckTeam(wr2, rm2, role)
  end
  return team1Flag, team2Flag
end

function TeamData:CheckTeam(wantedRole, membersRole, role)
  redlog("CheckTeam", role)
  if membersRole and #membersRole >= self:GetMaxMember() then
    return false
  else
    if not wantedRole or #wantedRole == 0 then
      return true
    end
    if 0 < TableUtility.ArrayFindIndex(wantedRole, 0) then
      return true
    end
    if not role then
      local myroles = MyselfProxy.Instance:GetMyTeamRoles()
      if myroles then
        for i = 1, #myroles do
          role = myroles[i]
          if 0 < TableUtility.ArrayFindIndex(wantedRole, role) then
            return true
          end
        end
      end
    elseif 0 < TableUtility.ArrayFindIndex(wantedRole, role) then
      return true
    end
  end
  return false
end
