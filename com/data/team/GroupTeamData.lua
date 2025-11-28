autoImport("TeamData")
GroupTeamData = class("TeamData", TeamData)
GroupTeamData.EMPTY_STATE = 1
local MaxMember = GameConfig.Team.maxmember

function GroupTeamData:ctor(teamData)
  GroupTeamData.super.ctor(self, teamData)
  self.memberListWithAdd = {}
  self.hireMemberMap = {}
  self.hireMemberList = {}
  self.playerMemberList = {}
end

function GroupTeamData:SetData(teamData)
  if not teamData then
    return
  end
  local serverMembers = teamData.members
  local memberMap = self:GetMemberMap()
  local found
  for guid, memberData in pairs(memberMap) do
    if guid then
      found = false
      for i = 1, #serverMembers do
        if serverMembers[i].guid == guid then
          found = true
          break
        end
      end
      if not found then
        self:RemoveMember(guid)
      end
    end
  end
  self.id = teamData.teamid
  self:SetMembers(serverMembers)
  if teamData.items and #teamData.items > 0 then
    self:SetSummary(teamData.items, teamData.name)
  end
end

function GroupTeamData:SetMember(data)
  local member = self:GetMemberByGuid(data.guid)
  if not member then
    member = self:AddMember(data)
    self:RefreshCatMasterInfo(member)
  else
    local cachemapid = member.mapid
    local cacheJob = member.job
    local cacheOffline = member:IsOffline()
    local cacheCat = member.cat
    local cachesceneid = member.sceneid
    member:SetData(data)
    if cacheOffline == member:IsOffline() or member:IsOffline() then
    else
    end
    if cachemapid ~= member.mapid or cachesceneid ~= member.sceneid then
      self:NotifyMemberChangeMap(member)
    end
    if cacheCat ~= member.cat then
      self:RefreshCatMasterInfo(member)
    end
    member:SetGroupTeamIndex(self:GetGroupTeamIndex())
  end
  return member
end

function GroupTeamData:NotifyMemberOnline(memberData)
  EventManager.Me():DispatchEvent(TeamEvent.MemberOnline, memberData)
  GameFacade.Instance:sendNotification(TeamEvent.MemberOnline, memberData)
end

function GroupTeamData:NotifyMemberOffline(memberData)
  EventManager.Me():DispatchEvent(TeamEvent.MemberOffline, memberData)
  GameFacade.Instance:sendNotification(TeamEvent.MemberOffline, memberData)
end

function GroupTeamData:NotifyMemberChangeMap(memberData)
  GameFacade.Instance:sendNotification(TeamEvent.MemberChangeMap, memberData)
end

function GroupTeamData:RefreshCatMasterInfo(memberData)
  local masterid = memberData.masterid
  local master = self:GetMemberByGuid(masterid)
  if master then
    memberData:SetMasterName(master.name)
  end
end

function GroupTeamData:AddMember(member)
  local addMember = GroupTeamData.super.AddMember(self, member)
  if addMember then
    addMember:SetGroupTeamIndex(self:GetGroupTeamIndex())
    local player = NSceneUserProxy.Instance:Find(addMember.id)
    if player then
      player:OnAvatarPriorityChanged()
      player.data:Camp_SetIsInMyTeam(true)
    end
    GameFacade.Instance:sendNotification(TeamEvent.MemberEnterGroup, addMember)
    EventManager.Me():DispatchEvent(TeamEvent.MemberEnterGroup, addMember)
    return addMember
  end
end

function GroupTeamData:AddTeamMemberData(addMember)
  GroupTeamData.super.AddTeamMemberData(self, addMember)
  if addMember then
    addMember:SetGroupTeamIndex(self:GetGroupTeamIndex())
    local player = NSceneUserProxy.Instance:Find(addMember.id)
    if player then
      player:OnAvatarPriorityChanged()
      player.data:Camp_SetIsInMyTeam(true)
    end
    GameFacade.Instance:sendNotification(TeamEvent.MemberEnterGroup, addMember)
    EventManager.Me():DispatchEvent(TeamEvent.MemberEnterGroup, addMember)
  end
end

function GroupTeamData:RemoveMember(guid, catid)
  local removeMember = GroupTeamData.super.RemoveMember(self, guid, catid)
  if removeMember then
    local player = NSceneUserProxy.Instance:Find(removeMember.id)
    if player then
      player:OnAvatarPriorityChanged()
      if not TeamProxy.Instance:IsInMyTeam(guid) then
        player.data:Camp_SetIsInMyTeam(false)
      end
    end
    GameFacade.Instance:sendNotification(TeamEvent.MemberExitGroup, removeMember)
    EventManager.Me():DispatchEvent(TeamEvent.MemberExitGroup, removeMember)
    return removeMember
  end
end

function GroupTeamData:GetMemberListWithAdd()
  local memberList = self:GetMembersList()
  TableUtility.ArrayClear(self.memberListWithAdd)
  for i = 1, #memberList do
    table.insert(self.memberListWithAdd, memberList[i])
  end
  if #self.memberListWithAdd < GameConfig.Team.maxmember - 1 then
    table.insert(self.memberListWithAdd, GroupTeamData.EMPTY_STATE)
  end
  return self.memberListWithAdd
end

function GroupTeamData:GetHireCatID()
  local data = {}
  local memberListWithAdd = self:GetMemberListWithAdd()
  for k, v in pairs(memberListWithAdd) do
    if "table" == type(v) and v:IsHireMember() then
      data[#data + 1] = v.cat
    end
  end
  return data
end

function GroupTeamData:GetPlayerMemberList(exceptCat)
  TableUtility.ArrayClear(self.playerMemberList)
  local list = self:GetMembersList()
  for i = 1, #list do
    if exceptCat ~= true then
      table.insert(self.playerMemberList, list[i])
    elseif list[i].cat == nil or list[i].cat == 0 then
      table.insert(self.playerMemberList, list[i])
    end
  end
  return self.playerMemberList
end

function GroupTeamData:GetMemberCreatureArrayInRange(range, creatureArray, filter, filterArgs)
  local FindCreature = SceneCreatureProxy.FindCreature
  local myPosition = Game.Myself:GetPosition()
  for _, v in pairs(self.membersMap) do
    local creature = FindCreature(v.id)
    if nil ~= creature and (filter == nil or filter(creature, filterArgs)) then
      if 0 < range then
        local dist = VectorUtility.DistanceXZ(creature:GetPosition(), myPosition)
        if range > dist then
          TableUtility.ArrayPushBack(creatureArray, creature)
        end
      else
        TableUtility.ArrayPushBack(creatureArray, creature)
      end
    end
  end
end

function GroupTeamData:GetApplyList()
  local memData = self:GetMemberByGuid(Game.Myself.data.id)
  if memData and (memData.job == SessionTeam_pb.ETEAMJOB_LEADER or memData.job == SessionTeam_pb.ETEAMJOB_TEMPLEADER) then
    return GroupTeamData.super.GetApplyList(self)
  end
  return {}
end

function GroupTeamData:Server_SetHireTeamMembers(cats)
  self.hireMemberList_dirty = true
  for i = 1, #cats do
    local serverCat = cats[i]
    local guid = serverCat.id
    local memberData = self.hireMemberMap[guid]
    if not memberData then
      memberData = TeamMemberData.new()
      memberData.id = guid
      self.hireMemberMap[guid] = memberData
    end
    memberData.cat = serverCat.catid
    memberData:SetRestTime(serverCat.relivetime)
    memberData.baselv = serverCat.lv
    memberData.expiretime = serverCat.expiretime
    memberData.masterid = serverCat.ownerid
    memberData:UpdateHireMemberInfo()
    self:RefreshCatMasterInfo(memberData)
  end
end

function GroupTeamData:Server_RemoveHireTeamMembers(cats)
  for i = 1, #cats do
    self:Server_RemoveHireTeamMember(cats[i])
  end
end

function GroupTeamData:ClearHireTeamMembers()
  for key, catMember in pairs(self.hireMemberMap) do
    self.hireMemberList_dirty = true
    catMember:Exit()
    self.hireMemberMap[key] = nil
  end
end

function GroupTeamData:Server_RemoveHireTeamMember(serverCat)
  local memberData = self.hireMemberMap[serverCat.id]
  if memberData then
    self.hireMemberList_dirty = true
    memberData:Exit()
  end
  self.hireMemberMap[serverCat.id] = nil
end

function GroupTeamData:GetHireTeamMembers()
  if self.hireMemberList_dirty then
    self.hireMemberList_dirty = false
    TableUtility.ArrayClear(self.hireMemberList)
    for _, member in pairs(self.hireMemberMap) do
      table.insert(self.hireMemberList, member)
    end
    table.sort(self.hireMemberList, TeamData.SortTeamMember)
  end
  return self.hireMemberList
end

local strFormat = string.format

function GroupTeamData:GetStrStatus()
  if self.state == SessionTeam_pb.ETEAMSTATE_MATCH then
    return strFormat(ZhString.TeamMemberListPopUp_Status, self.name, ZhString.TeamMemberListPopUp_Match)
  elseif self.state == SessionTeam_pb.ETEAMSTATE_PUBLISH then
    return strFormat(ZhString.TeamMemberListPopUp_Status, self.name, ZhString.TeamMemberListPopUp_Publish)
  else
    return strFormat(ZhString.TeamMemberListPopUp_Status, self.name, ZhString.TeamMemberListPopUp_Free)
  end
end

function GroupTeamData:GetGroupTeamIndex()
  local myTeam = TeamProxy.Instance.myTeam
  return myTeam and myTeam:IsLeaderTeamInGroup() and 2 or 1
end

function GroupTeamData:RefreshGroupTeamIndex()
  local groupIndex = self:GetGroupTeamIndex()
  local membersMap = self:GetMemberMap()
  for _, v in pairs(membersMap) do
    v:SetGroupTeamIndex(groupIndex)
  end
end

function GroupTeamData:Exit()
  for _, v in pairs(self.membersMap) do
    self:RemoveMember(v.id)
  end
  EventManager.Me():DispatchEvent(TeamEvent.ExitGroup)
end

function GroupTeamData:GetRoleMembers()
  local memList = self:GetPlayerMemberList(true, true)
  local result = {}
  for i = 1, #memList do
    table.insert(result, memList[i]:GetRole() or 0)
  end
  return result
end

function GroupTeamData:GetWantedRoles()
  return self.team1RolesList
end

function GroupTeamData:GetRoles()
  local result = {}
  local rm1 = self:GetRoleMembers()
  local wr1 = self:GetWantedRoles()
  self:SetRoleList(result, rm1, wr1, MaxMember)
  return result
end

function GroupTeamData:SetRoleList(result, roles, wanted, Max)
  local role = 0
  if roles then
    for i = 1, #roles do
      table.insert(result, roles[i])
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
