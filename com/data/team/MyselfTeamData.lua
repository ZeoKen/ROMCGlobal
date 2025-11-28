autoImport("TeamData")
MyselfTeamData = class("TeamData", TeamData)
MyselfTeamData.EMPTY_STATE = 1
MyselfTeamData.EMPTY_STATE_GROUP = 2
local MaxMember = GameConfig.Team.maxmember

function MyselfTeamData:ctor(teamData)
  MyselfTeamData.super.ctor(self, teamData)
  self.memberListExpMe = {}
  self.memberListWithAdd = {}
  self.hireMemberMap = {}
  self.hireMemberList = {}
  self.playerMemberList = {}
end

function MyselfTeamData:SetData(teamData)
  MyselfTeamData.super.SetData(self, teamData)
  if teamData and teamData.hireMemberList_dirty ~= nil then
    self.hireMemberList_dirty = teamData.hireMemberList_dirty
  end
end

local leaderMap
local CheckJobIsLeader = function(job)
  if not leaderMap then
    leaderMap = {
      [SessionTeam_pb.ETEAMJOB_LEADER] = 1,
      [SessionTeam_pb.ETEAMJOB_TEMPLEADER] = 1
    }
  end
  return nil ~= leaderMap[job]
end

function MyselfTeamData:SetMember(data)
  local member = self:GetMemberByGuid(data.guid)
  if not member then
    member = self:AddMember(data)
    self:RefreshCatMasterInfo(member)
  else
    local cachemapid = member.mapid
    local cacheJob = member.job
    local cacheOffline = member:IsOffline()
    local cacheCat = member.cat
    local cacheIsAfk = member:IsAfk()
    local cacheImage = member.image
    local cachesceneid = member.sceneid
    member:SetData(data)
    if member.image ~= cacheImage and data.guid == Game.Myself.data.id then
      GameFacade.Instance:sendNotification(TeamEvent.MyImageChanged)
    end
    if cacheOffline ~= member:IsOffline() then
      if member:IsOffline() then
        self:NotifyMemberOffline(member)
      else
        self:NotifyMemberOnline(member)
      end
    end
    if cachemapid ~= member.mapid or cachesceneid ~= member.sceneid then
      self:NotifyMemberChangeMap(member)
    end
    if cacheJob ~= member.job then
      if CheckJobIsLeader(member.job) or CheckJobIsLeader(cacheJob) then
        GameFacade.Instance:sendNotification(TeamEvent.MyLeaderChange)
      end
      self:NotifyMyTeamJobChange(member.job)
      if member.job == SessionTeam_pb.ETEAMJOB_LEADER and not FunctionPve.Me():IsServerThanatosInviting() then
        FunctionPve.Me():TryResetLeaderReady(member.id)
      end
    end
    if cacheCat ~= member.cat then
      self:RefreshCatMasterInfo(member)
    end
    if cacheIsAfk ~= member:IsAfk() then
      self:NotifyMemberAfkChange(member)
    end
    member:SetGroupTeamIndex(self:GetGroupTeamIndex())
  end
  return member
end

function MyselfTeamData:NotifyMemberOnline(memberData)
  EventManager.Me():DispatchEvent(TeamEvent.MemberOnline, memberData)
  GameFacade.Instance:sendNotification(TeamEvent.MemberOnline, memberData)
end

function MyselfTeamData:NotifyMemberOffline(memberData)
  EventManager.Me():DispatchEvent(TeamEvent.MemberOffline, memberData)
  GameFacade.Instance:sendNotification(TeamEvent.MemberOffline, memberData)
end

function MyselfTeamData:NotifyMemberChangeMap(memberData)
  GameFacade.Instance:sendNotification(TeamEvent.MemberChangeMap, memberData)
end

function MyselfTeamData:NotifyMemberAfkChange(memberData)
  GameFacade.Instance:sendNotification(TeamEvent.MemberAfkChange, memberData)
end

function MyselfTeamData:NotifyMyTeamJobChange(nowJob)
  FunctionTeam.Me():MyTeamJobChange(nowJob)
end

function MyselfTeamData:RefreshCatMasterInfo(memberData)
  local masterid = memberData.masterid
  local master = self:GetMemberByGuid(masterid)
  if master then
    memberData:SetMasterName(master.name)
  elseif masterid == Game.Myself.data.id then
    memberData:SetMasterName(Game.Myself.data.name)
  end
end

local _resetPetCamp = function(memberid)
  local petMap = NScenePetProxy.Instance.userMap
  for _, nPet in pairs(petMap) do
    if nPet.data.ownerID == memberid then
      nPet.data:Camp_SetIsInMyTeam(true)
      break
    end
  end
end

function MyselfTeamData:AddMember(member)
  local addMember = MyselfTeamData.super.AddMember(self, member)
  if addMember then
    if addMember.id == Game.Myself.data.id then
      self.myMemberInfo = addMember
      addMember.offline = 0
    else
      local scenePlayer = NSceneUserProxy.Instance:Find(addMember.id)
      if scenePlayer then
        scenePlayer:OnAvatarPriorityChanged()
        scenePlayer.data:Camp_SetIsInMyTeam(true)
        scenePlayer.data:SetTeamID(self.id)
        _resetPetCamp(addMember.id)
      end
    end
    addMember:SetGroupTeamIndex(self:GetGroupTeamIndex())
    GameFacade.Instance:sendNotification(TeamEvent.MemberEnterTeam, addMember)
    EventManager.Me():DispatchEvent(TeamEvent.MemberEnterTeam, addMember)
    return addMember
  end
end

function MyselfTeamData:AddTeamMemberData(addMember)
  MyselfTeamData.super.AddTeamMemberData(self, addMember)
  if addMember then
    if addMember.id == Game.Myself.data.id then
      self.myMemberInfo = addMember
      addMember.offline = 0
    else
      local scenePlayer = NSceneUserProxy.Instance:Find(addMember.id)
      if scenePlayer then
        scenePlayer:OnAvatarPriorityChanged()
        scenePlayer.data:Camp_SetIsInMyTeam(true)
        scenePlayer.data:SetTeamID(self.id)
      end
    end
    addMember:SetGroupTeamIndex(self:GetGroupTeamIndex())
    GameFacade.Instance:sendNotification(TeamEvent.MemberEnterTeam, addMember)
    EventManager.Me():DispatchEvent(TeamEvent.MemberEnterTeam, addMember)
  end
end

function MyselfTeamData:RemoveMember(guid, catid, isClient)
  local removeMember = MyselfTeamData.super.RemoveMember(self, guid, catid)
  if removeMember then
    if removeMember.id ~= Game.Myself.data.id then
      local scenePlayer = NSceneUserProxy.Instance:Find(removeMember.id)
      if scenePlayer then
        scenePlayer:OnAvatarPriorityChanged()
        scenePlayer.data:Camp_SetIsInMyTeam(false)
        scenePlayer.data:SetTeamID(scenePlayer.data.id)
        _resetPetCamp(removeMember.id)
      end
    end
    removeMember.isClient = isClient
    GameFacade.Instance:sendNotification(TeamEvent.MemberExitTeam, removeMember)
    EventManager.Me():DispatchEvent(TeamEvent.MemberExitTeam, removeMember)
    return removeMember
  end
end

function MyselfTeamData:GetMembersListExceptMe()
  local memberList = self:GetMembersList()
  TableUtility.ArrayClear(self.memberListExpMe)
  for i = 1, #memberList do
    if memberList[i].id ~= Game.Myself.data.id then
      table.insert(self.memberListExpMe, memberList[i])
    end
  end
  return self.memberListExpMe
end

function MyselfTeamData:GetMemberListWithAdd()
  local memberList = self:GetMembersListExceptMe()
  TableUtility.ArrayClear(self.memberListWithAdd)
  for i = 1, #memberList do
    table.insert(self.memberListWithAdd, memberList[i])
  end
  if #self.memberListWithAdd < GameConfig.Team.maxmember - 1 then
    table.insert(self.memberListWithAdd, MyselfTeamData.EMPTY_STATE)
  end
  return self.memberListWithAdd
end

function MyselfTeamData:GetHireCatID()
  local data = {}
  local memberListWithAdd = self:GetMemberListWithAdd()
  for k, v in pairs(memberListWithAdd) do
    if "table" == type(v) and v:IsHireMember() then
      data[#data + 1] = v.cat
    end
  end
  return data
end

function MyselfTeamData:IsTeamFull()
  local mb = self:GetPlayerMemberList(true, true)
  local maxmember = TeamData.MaxMemberCount(self.type)
  return maxmember <= #mb
end

function MyselfTeamData:IsRoguelikeTeamFull()
  local mb = self:GetPlayerMemberList(true, true)
  return #mb > GameConfig.Team.Roguelike_maxmember
end

local raid, raidData

function MyselfTeamData:HasMemberInRaid(raidType)
  local tm = self:GetPlayerMemberList(false, true)
  local _raidTable = Table_MapRaid
  for i = 1, #tm do
    raid = not tm[i]:IsOffline() and tm[i].raid
    raidData = raid and _raidTable[raid]
    if raidData and raidData.Type == raidType then
      return true
    end
  end
  return false
end

function MyselfTeamData:GetPlayerMemberList(includeMe, exceptCat)
  TableUtility.ArrayClear(self.playerMemberList)
  local list = self:GetMembersList()
  for i = 1, #list do
    if list[i].id == Game.Myself.data.id then
      if includeMe then
        table.insert(self.playerMemberList, list[i])
      end
    elseif exceptCat ~= true then
      table.insert(self.playerMemberList, list[i])
    elseif list[i].cat == nil or list[i].cat == 0 then
      table.insert(self.playerMemberList, list[i])
    end
  end
  return self.playerMemberList
end

function MyselfTeamData:HasDifferentServerTM()
  local tm = self:GetPlayerMemberList()
  for i = 1, #tm do
    if not tm[i]:IsSameServer() then
      return true
    end
  end
  return false
end

function MyselfTeamData:GetMemberCreatureArrayInRange(range, creatureArray, filter, filterArgs)
  local FindCreature = SceneCreatureProxy.FindCreature
  local myPosition = Game.Myself:GetPosition()
  for _, v in pairs(self.membersMap) do
    local creature = FindCreature(v.id)
    if nil ~= creature and (filter == nil or filter(creature, filterArgs)) then
      if 0 < range then
        local dist = VectorUtility.DistanceXZ_Square(creature:GetPosition(), myPosition)
        if dist < range * range then
          TableUtility.ArrayPushBack(creatureArray, creature)
        end
      else
        TableUtility.ArrayPushBack(creatureArray, creature)
      end
    end
  end
end

function MyselfTeamData:GetApplyList()
  local memData = self:GetMemberByGuid(Game.Myself.data.id)
  if memData and (memData.job == SessionTeam_pb.ETEAMJOB_LEADER or memData.job == SessionTeam_pb.ETEAMJOB_TEMPLEADER) then
    return MyselfTeamData.super.GetApplyList(self)
  end
  return {}
end

function MyselfTeamData:Server_SetHireTeamMembers(cats)
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

function MyselfTeamData:UpdateHireMember(id, memberDatas)
  if nil ~= self.hireMemberMap[id] then
    local tempData = {guid = id, datas = memberDatas}
    self.hireMemberMap[id]:SetData(tempData)
    self:RefreshCatMasterInfo(self.hireMemberMap[id])
  end
end

function MyselfTeamData:Server_RemoveHireTeamMembers(cats)
  for i = 1, #cats do
    self:Server_RemoveHireTeamMember(cats[i])
  end
end

function MyselfTeamData:ClearHireTeamMembers()
  if nil == next(self.hireMemberMap) then
    self.hireMemberList_dirty = false
    return
  end
  for key, catMember in pairs(self.hireMemberMap) do
    self.hireMemberList_dirty = true
    catMember:Exit()
    self.hireMemberMap[key] = nil
  end
end

function MyselfTeamData:Server_RemoveHireTeamMember(serverCat)
  local memberData = self.hireMemberMap[serverCat.id]
  if memberData then
    self.hireMemberList_dirty = true
    memberData:Exit()
  end
  self.hireMemberMap[serverCat.id] = nil
end

function MyselfTeamData:GetHireTeamMembers()
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

function MyselfTeamData:GetStrStatus()
  if self.state == SessionTeam_pb.ETEAMSTATE_MATCH then
    return strFormat(ZhString.TeamMemberListPopUp_Status, self.name, ZhString.TeamMemberListPopUp_Match)
  elseif self.state == SessionTeam_pb.ETEAMSTATE_PUBLISH then
    return strFormat(ZhString.TeamMemberListPopUp_Status, self.name, ZhString.TeamMemberListPopUp_Publish)
  elseif self.state == SessionTeam_pb.ETEAMSTATE_PUBLISH_GROUP then
    return strFormat(ZhString.TeamMemberListPopUp_Status, self.name, ZhString.TeamMemberListPopUp_GroupPublish)
  elseif self.state == SessionTeam_pb.ETEAMSTATE_INVITE then
    return strFormat(ZhString.TeamMemberListPopUp_Status, self.name, ZhString.Pve_Invite_MainViewText)
  else
    return strFormat(ZhString.TeamMemberListPopUp_Status, self.name, ZhString.TeamMemberListPopUp_Free)
  end
end

function MyselfTeamData:IsLeaderTeamInGroup()
  return self.groupid == self.id
end

function MyselfTeamData:GetGroupID()
  return self.groupid
end

function MyselfTeamData:GetGroupTeamIndex()
  return self:IsLeaderTeamInGroup() and 1 or 2
end

function MyselfTeamData:RefreshGroupTeamIndex()
  local groupIndex = self:GetGroupTeamIndex()
  local membersMap = self:GetMemberMap()
  for _, v in pairs(membersMap) do
    v:SetGroupTeamIndex(groupIndex)
  end
end

function MyselfTeamData:Exit(exitType)
  for _, v in pairs(self.membersMap) do
    self:RemoveMember(v.id, nil, exitType == TeamProxy.ExitType.ClearData)
  end
  RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_TEAMAPPLY)
  RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_TEAMAPPLY)
  EventManager.Me():DispatchEvent(TeamEvent.ExitTeam)
  DisneyStageProxy.Instance:ClientShutDownDisneyMusicTeam()
end

function MyselfTeamData:CheckImageInActive()
  local md = self:GetMemberByGuid(Game.Myself.data.id)
  return md and md.image == 1
end

function MyselfTeamData:GetRoleMembers()
  local memList = self:GetPlayerMemberList(true, true)
  local result = {}
  for i = 1, #memList do
    table.insert(result, memList[i]:GetRole() or 0)
  end
  return result
end

function MyselfTeamData:GetRoles()
  local result = {}
  local rm1 = self:GetRoleMembers()
  local wr1 = self:GetWantedRoles()
  redlog("wr1", wr1, #wr1)
  self:SetRoleList(result, rm1, wr1, self:GetMaxMember())
  return result
end

function MyselfTeamData:SetRoleList(result, roles, wanted, Max)
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

function MyselfTeamData:GetMemberCountInRange(range, filter, filterArgs)
  local FindCreature = SceneCreatureProxy.FindCreature
  local myPosition = Game.Myself:GetPosition()
  local myID = Game.Myself.data.id
  if Game.Myself.data.excludeTeammate then
    return 0
  end
  local count = 0
  for _, v in pairs(self.membersMap) do
    local creature = FindCreature(v.id)
    if v.id ~= myID and nil ~= creature and not v:IsHireMember() and not v:IsRobotMember() and (filter == nil or filter(creature, filterArgs)) and not creature.data.excludeTeammate then
      if 0 < range then
        local dist = VectorUtility.DistanceXZ_Square(creature:GetPosition(), myPosition)
        if dist < range * range then
          count = count + 1
        end
      else
        count = count + 1
      end
    end
  end
  return count
end

function MyselfTeamData:HasTeamProfession(classID)
  local memList = self:GetPlayerMemberList(true, true)
  for i = 1, #memList do
    if memList[i]:GetProfession() == classID then
      return true
    end
  end
  return false
end
