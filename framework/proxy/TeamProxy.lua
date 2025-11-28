TeamProxy = class("TeamProxy", pm.Proxy)
TeamProxy.Instance = nil
TeamProxy.NAME = "TeamProxy"
autoImport("MyselfTeamData")
autoImport("GroupTeamData")
autoImport("RecruitTeamData")
TeamProxy.ExitType = {
  ServerExit = "TeamProxy_ExitType_ServerExit",
  ClearData = "TeamProxy_ExitType_ClearData"
}
TeamInviteMemberType = {
  Friend = 1,
  GuildMember = 2,
  NearlyTeamMember = 3,
  MemberCat = 4
}
TeamProxy.AllTeamType = 0
local _ClientRaidTypeForMergeServer = {
  [FuBenCmd_pb.ERAIDTYPE_PVP_LLH] = 1,
  [FuBenCmd_pb.ERAIDTYPE_PVP_SMZL] = 1,
  [FuBenCmd_pb.ERAIDTYPE_PVP_HLJS] = 1,
  [FuBenCmd_pb.ERAIDTYPE_PVP_POLLY] = 1,
  [FuBenCmd_pb.ERAIDTYPE_MVPBATTLE] = 1,
  [FuBenCmd_pb.ERAIDTYPE_SUPERGVG] = 1,
  [FuBenCmd_pb.ERAIDTYPE_TEAMPWS] = 1,
  [FuBenCmd_pb.ERAIDTYPE_OTHELLO] = 1,
  [FuBenCmd_pb.ERAIDTYPE_TEAMEXP] = 1,
  [FuBenCmd_pb.ERAIDTYPE_TRANSFERFIGHT] = 1,
  [FuBenCmd_pb.ERAIDTYPE_TWELVE_PVP] = 1,
  [FuBenCmd_pb.ERAIDTYPE_EINHERJAR] = 1,
  [FuBenCmd_pb.ERAIDTYPE_TOWER] = 1,
  [FuBenCmd_pb.ERAIDTYPE_SEAL] = 1,
  [FuBenCmd_pb.ERAIDTYPE_LABORATORY] = 1,
  [FuBenCmd_pb.ERAIDTYPE_THANATOS] = 1,
  [FuBenCmd_pb.ERAIDTYPE_THANATOS_MID] = 1,
  [FuBenCmd_pb.ERAIDTYPE_THANATOS_SCENE3] = 1,
  [FuBenCmd_pb.ERAIDTYPE_THANATOS_FOURTH] = 1,
  [FuBenCmd_pb.ERAIDTYPE_COMODO_TEAM_RAID] = 1,
  [FuBenCmd_pb.ERAIDTYPE_HEADWEAR] = 1,
  [FuBenCmd_pb.ERAIDTYPE_PVECARD] = 1,
  [FuBenCmd_pb.ERAIDTYPE_DEADBOSS] = 1,
  [FuBenCmd_pb.ERAIDTYPE_SEVEN_ROYAL_TEAM_RAID] = 1,
  [FuBenCmd_pb.ERAIDTYPE_ELEMENT] = 1,
  [FuBenCmd_pb.ERAIDTYPE_CRACK] = 1
}
local _RaidTypeForMergeServer = GameConfig.ServerMerge and GameConfig.ServerMerge.RaidTypeForMergeServer or _ClientRaidTypeForMergeServer
local NeedCheckUniteTeam = function(raid)
  if not raid then
    return false
  end
  local raidType
  if type(raid) == "number" then
    raidType = raid
  elseif type(raid) == "table" then
    raidType = raid.Type
  end
  return raidType == PvpProxy.Type.GroupRaid or TwelvePvPProxy.Instance:Is12pvp(raidType)
end

function TeamProxy:ctor(proxyName, data)
  self.proxyName = proxyName or TeamProxy.NAME
  if TeamProxy.Instance == nil then
    TeamProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:InitTeamProxy()
end

local PublishGoal = GameConfig.Team.publish_goal

function TeamProxy:InitTeamProxy()
  self.myTeam = nil
  self.uniteGroupTeam = nil
  self.teamlst = {}
  self.quickEnterTime = 0
  self.aroundTeamList = {}
  self.mainSubTeamIndex = {}
  self.recruitTeamList = {}
  self.onlyMyServerChoose = {}
  self:InitPvpRaidType()
end

function TeamProxy:CheckWarbandFitGroupMemberValid_CupMode6v6(isMultiServer)
  local proxy
  if isMultiServer then
    proxy = CupMode6v6Proxy_MultiServer.Instance
  else
    proxy = CupMode6v6Proxy.Instance
  end
  if not self:IHaveTeam() then
    return false
  end
  local list = self.myTeam:GetMembersList()
  for k, v in pairs(list) do
    if not proxy:CheckInMyBand(v.id) then
      return false
    end
  end
  local uniteteam = self:GetGroupUniteTeamData()
  if uniteteam then
    local list = uniteteam:GetMembersList()
    for k, v in pairs(list) do
      if not proxy:CheckInMyBand(v.id) then
        return false
      end
    end
  end
  return true
end

function TeamProxy:InitTeamGoals()
  if self._teamGoalInited == true then
    return
  end
  self._teamGoalInited = true
  local fatherGoals = {}
  local childGoals = {}
  local grandGoals = {}
  for k, v in pairs(Table_TeamGoals) do
    if (nil == v.FuncState or nil == Table_FuncState[v.FuncState] or FunctionUnLockFunc.checkFuncStateValid(v.FuncState)) and v.GoalGroup then
      local gourp = grandGoals[v.GoalGroup]
      if not group then
        group = {}
      end
      if v.id ~= v.type then
        local temp = childGoals[v.type]
        if not temp then
          temp = {}
          childGoals[v.type] = temp
        end
        table.insert(temp, v)
      else
        table.insert(fatherGoals, v)
        table.insert(group, v.id)
        grandGoals[v.GoalGroup] = group
      end
    end
  end
  self.goals = {}
  local combine = {
    fatherGoal = {
      id = 0,
      NameZh = ZhString.TeamFindPopUp_AllTeam,
      type = 0
    }
  }
  table.insert(self.goals, combine)
  for k, v in pairs(fatherGoals) do
    local combine = {}
    combine.fatherGoal = v
    combine.childGoals = childGoals[v.id]
    table.insert(self.goals, combine)
  end
  table.sort(self.goals, function(a, b)
    return a.fatherGoal.id < b.fatherGoal.id
  end)
  self.grandGoals = {}
  local grandcombine = {
    groupid = 0,
    fatherid = 0,
    NameZh = ZhString.TeamFindPopUp_AllTeam,
    type = 0
  }
  table.insert(self.grandGoals, grandcombine)
  for groupid, fatherid in pairs(grandGoals) do
    local grandcombine = {}
    grandcombine.groupid = groupid
    grandcombine.fatherid = fatherid
    grandcombine.NameZh = PublishGoal[groupid] or ""
    table.insert(self.grandGoals, grandcombine)
  end
  table.sort(self.grandGoals, function(a, b)
    return a.groupid < b.groupid
  end)
end

local checkChildGoalRaidType = function(childGoals)
  if not childGoals then
    return false
  end
  for i = 1, #childGoals do
    if childGoals[i].RaidType then
      return true
    end
  end
  return false
end

function TeamProxy:GetTeamGoals(groupid)
  local result = {}
  for i = 1, #self.goals do
    local v = self.goals[i]
    local newGoal = {}
    local flag
    local isRaidType = checkChildGoalRaidType(v.childGoals)
    flag = v.fatherGoal.id ~= GameConfig.Team.defaulttype
    if flag and v.fatherGoal.GoalGroup == groupid then
      newGoal.fatherGoal = v.fatherGoal
      newGoal.childGoals = {}
      newGoal.avaliable = true
      if v.childGoals then
        for ck, cv in pairs(v.childGoals) do
          table.insert(newGoal.childGoals, cv)
        end
        table.sort(newGoal.childGoals, function(a, b)
          return a.id < b.id
        end)
      end
      table.insert(result, newGoal)
    end
  end
  return result
end

function TeamProxy:GetGroupGoals()
  return self.grandGoals
end

function TeamProxy:CheckDiffServerValidByPvpType(t)
  local raidType = PvpProxy.PvpType2RaidType[t]
  if not raidType then
    return true
  end
  if self:ForbiddenByRaidType(raidType) then
    return false
  end
  if not self:CheckMatchTypeSupportDiffServer(t) then
    return false
  end
  return true
end

function TeamProxy:InitPvpRaidType()
  self.raidTypeClassified = {}
  for id, v in pairs(Table_MapRaid) do
    if _RaidTypeForMergeServer[v.Type] then
      if not self.raidTypeClassified[v.Type] then
        self.raidTypeClassified[v.Type] = {}
      end
      table.insert(self.raidTypeClassified[v.Type], v)
    end
  end
  self.matchRaidTypeClassified = {}
  for id, v in pairs(Table_MatchRaid) do
    if not self.matchRaidTypeClassified[v.Type] then
      self.matchRaidTypeClassified[v.Type] = {}
    end
    table.insert(self.matchRaidTypeClassified[v.Type], v)
  end
end

function TeamProxy:CheckRaidTypeSupportDiffServer(raidType)
  local allTab = self.raidTypeClassified[raidType]
  if allTab then
    for i = 1, #allTab do
      if self:CheckRaidIdSupportDiffServer(allTab[i].id) then
        return true
      end
    end
  end
  return false
end

function TeamProxy:CheckMatchTypeSupportDiffServer(pvpType)
  local allTab = self.matchRaidTypeClassified[pvpType]
  if allTab then
    for i = 1, #allTab do
      if self:ForbiddenByMatchRaidID(allTab[i].id) then
        return false
      end
    end
  end
  return true
end

function TeamProxy:ForbiddenByRaidType(t)
  local checkUniteTeam = NeedCheckUniteTeam(t)
  if not self:CheckRaidTypeSupportDiffServer(t) then
    if self:CheckHasDiffServerMember(checkUniteTeam) then
      return true
    else
      return false
    end
  else
    return false
  end
end

function TeamProxy:ForbiddenByRaidID(id)
  local checkUniteTeam = NeedCheckUniteTeam(Table_MapRaid[id])
  if not self:CheckRaidIdSupportDiffServer(id) then
    if self:CheckHasDiffServerMember(checkUniteTeam) then
      return true
    else
      return false
    end
  else
    return false
  end
end

function TeamProxy:ForbiddenByMatchRaidID(id)
  local raidCfg = Table_MatchRaid[id] and Table_MatchRaid[id].RaidConfigID or nil
  local checkUniteTeam = NeedCheckUniteTeam(raidCfg)
  if not self:CheckMatchRaidSupportDiffServer(id) then
    if self:CheckHasDiffServerMember(checkUniteTeam) then
      return true
    else
      return false
    end
  else
    return false
  end
end

function TeamProxy:CheckHasDiffServerMember(checkGroup)
  if self:IHaveTeam() then
    if self.myTeam:HasDifferentServerTM() then
      return true
    end
    if checkGroup and self:IHaveGroup() then
      local uniteteam = self:GetGroupUniteTeamData()
      if uniteteam then
        local list = uniteteam:GetMembersList()
        for k, v in pairs(list) do
          if not v:IsSameServer() then
            return true
          end
        end
      end
    end
  end
  return false
end

local _timeMatchFmt = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"

function TeamProxy:CheckRaidIdSupportDiffServer(id)
  local mapRaidConfig = id and Table_MapRaid[id] or nil
  if mapRaidConfig then
    local validDate
    if EnvChannel.IsReleaseBranch() then
      validDate = mapRaidConfig.ServerMergeTime
    elseif EnvChannel.IsTFBranch() then
      validDate = mapRaidConfig.TFServerMergeTime
    else
      validDate = mapRaidConfig.ServerMergeTime
    end
    if not StringUtil.IsEmpty(validDate) then
      local year, month, day, hour, min, sec = validDate:match(_timeMatchFmt)
      local startDate = os.time({
        day = day,
        month = month,
        year = year,
        hour = hour,
        min = min,
        sec = sec
      })
      local curServerTime = ServerTime.CurServerTime()
      if curServerTime and startDate < curServerTime / 1000 then
        return true
      end
    end
  end
  return false
end

function TeamProxy:CheckMatchRaidSupportDiffServer(id)
  local matchRaidConfig = id and Table_MatchRaid[id] or nil
  if matchRaidConfig and matchRaidConfig.NoServerMerge == 1 then
    return false
  end
  return true
end

function TeamProxy:HasOfflineMember()
  if self:IHaveTeam() then
    local list = self.myTeam:GetMembersList()
    for k, v in pairs(list) do
      if v:IsOffline() then
        return true
      end
    end
  end
  return false
end

function TeamProxy:CheckMatchValid(raidCfg)
  local isgroupRaid = raidCfg.Type == PvpProxy.Type.GroupRaid
  local is12pvp = TwelvePvPProxy.Instance:Is12pvp(raidCfg.Type)
  if not isgroupRaid and not is12pvp and self:IHaveGroup() then
    MsgManager.ShowMsgByID(25959)
    return
  end
  local enterLv = raidCfg.EnterLevel
  local myself = Game.Myself
  local mylv = myself.data.userdata:Get(UDEnum.ROLELEVEL)
  if enterLv > mylv then
    MsgManager.ShowMsgByID(363)
    return
  end
  local noviceCanJoin = raidCfg.NoviceCanJoin == 1
  if not noviceCanJoin and 1 == MyselfProxy.Instance:GetMyProfession() then
    MsgManager.ShowMsgByID(378)
    return
  end
  local supportDiffServer = self:CheckMatchRaidSupportDiffServer(raidCfg.id)
  if self:IHaveTeam() then
    if not self:CheckIHaveLeaderAuthority() then
      MsgManager.ShowMsgByID(372)
      return
    end
    local list = self.myTeam:GetMembersList()
    for k, v in pairs(list) do
      if not supportDiffServer and not v:IsSameServer() then
        MsgManager.ShowMsgByID(42041)
        return
      end
      if v:IsOffline() then
        MsgManager.ShowMsgByID(25903)
        return
      end
      if enterLv > v.baselv then
        MsgManager.ShowMsgByID(7305, enterLv)
        return
      end
      if not noviceCanJoin and 1 == v.profession then
        MsgManager.ShowMsgByID(378)
        return
      end
    end
    local needCheckUniteTeam = isgroupRaid or is12pvp
    if needCheckUniteTeam and self:IHaveGroup() then
      local authorityValid = self.myTeam:IsLeaderTeamInGroup() and self:CheckIHaveLeaderAuthority()
      if not authorityValid then
        MsgManager.ShowMsgByID(25970)
        return
      end
      local uniteteam = self:GetGroupUniteTeamData()
      if uniteteam then
        local list = uniteteam:GetMembersList()
        for k, v in pairs(list) do
          if not supportDiffServer and not v:IsSameServer() then
            MsgManager.ShowMsgByID(42041)
            return
          end
          if v:IsOffline() then
            MsgManager.ShowMsgByID(25903)
            return
          end
          if enterLv > v.baselv then
            MsgManager.ShowMsgByID(7305, enterLv)
            return
          end
          if not noviceCanJoin and 1 == v.profession then
            MsgManager.ShowMsgByID(378)
            return
          end
        end
      end
    end
  end
  return true
end

function TeamProxy:CreateMyTeam(myTeamData)
  if self.myTeam then
    self:ExitTeam()
  end
  self.myTeam = MyselfTeamData.new()
  self.myTeam:SetData(myTeamData)
  if self.myTeam.id ~= 0 then
    local myself = Game.Myself
    myself.data:SetTeamID(self.myTeam.id)
  end
  if self:IHaveGroup() then
    ServiceSessionTeamProxy.Instance:CallQueryMemberTeamCmd(self.myTeam.uniteteamid)
    MsgManager.ShowMsgByIDTable(25971)
  end
  FunctionPve.Me():OnCreateMyTeam()
  self:ClearServerExitTeamCb()
end

function TeamProxy:UpdateMyTeamData(summaryDatas, name, dojo)
  if not self.myTeam then
    errorLog("Not Find MyTeam (UpdateMyTeamData)")
    return
  end
  local lastUniteTeamID = self.myTeam.uniteteamid
  self.myTeam:SetSummary(summaryDatas, name)
  if dojo then
    self.myTeam:SetDojo(data.dojo)
  end
  if self.myTeam.uniteteamid ~= lastUniteTeamID then
    self:ExitGroup()
    if self.myTeam.uniteteamid and self.myTeam.uniteteamid ~= 0 then
      ServiceSessionTeamProxy.Instance:CallQueryMemberTeamCmd(self.myTeam.uniteteamid)
      MsgManager.ShowMsgByIDTable(25971)
    end
  end
  self.myTeam:RefreshGroupTeamIndex()
  if self.uniteGroupTeam then
    self.uniteGroupTeam:RefreshGroupTeamIndex()
  end
end

function TeamProxy:LockTeamTarget(targetId)
  if not self.myTeam then
    errorLog("Not Find MyTeam (LockTeamTarget)")
    return
  end
  self.myTeam.target = targetId
end

function TeamProxy:UpdateTeamMember(updates, dels)
  if not self.myTeam then
    errorLog("Not Find MyTeam (UpdateMyTeamData)")
    return
  end
  self.myTeam:SetMembers(updates)
  self.myTeam:RemoveMembers(dels)
end

function TeamProxy:IsVoteKickOpen()
  if self.myTeam then
    return self.myTeam:IsVoteKickOpen()
  end
  return false
end

function TeamProxy:UpdateMyTeamMemberData(memberid, memberData)
  local teamMemberData = self.myTeam:GetMemberByGuid(memberid)
  if teamMemberData then
    local tempData = {guid = memberid, datas = memberData}
    self.myTeam:SetMember(tempData)
  elseif self.uniteGroupTeam then
    teamMemberData = self.uniteGroupTeam:GetMemberByGuid(memberid)
    if teamMemberData then
      local tempData = {guid = memberid, datas = memberData}
      self.uniteGroupTeam:SetMember(tempData)
    else
      errorLog(string.format("Member:%s Not EnterTeam When Recv(MemberDataUpdate)", memberid))
    end
  else
    errorLog(string.format("Member:%s Not EnterTeam When Recv(MemberDataUpdate)", memberid))
  end
  self.myTeam:UpdateHireMember(memberid, memberData)
  EventManager.Me():PassEvent(GMEEvent.OnMemberUpdateBackListInfo, teamMemberData)
end

function TeamProxy:UpdateMyTeamApply(updates, dels, isUniteGroup)
  if isUniteGroup then
    return
  end
  if not self.myTeam then
    errorLog("Not Find MyTeam (UpdateMyTeamData)")
    return
  end
  if updates then
    self.myTeam:SetApplys(updates, isUniteGroup)
  end
  if dels then
    self.myTeam:RemoveApplys(dels)
  end
end

function TeamProxy:RemoveMyUniteApply()
  if not self.myTeam then
    errorLog("Not Find MyTeam (RemoveMyUniteApply)")
    return
  end
  self.myTeam:RemoveUniteApply()
end

function TeamProxy:UpdateMyTeamMemberPos(id, pos, dead)
  if self.myTeam then
    local member = self.myTeam:GetMemberByGuid(id)
    if member then
      member:UpdatePos(pos, dead)
      return
    end
  end
  if self.uniteGroupTeam then
    local member = self.uniteGroupTeam:GetMemberByGuid(id)
    if member then
      member:UpdatePos(pos, dead)
      return
    end
  end
  errorLog(string.format("No Member In Team When Update Member Pos %s", id))
end

function TeamProxy:SetMyHireTeamMembers(cats)
  if self.myTeam then
    self.myTeam:Server_SetHireTeamMembers(cats)
  end
end

function TeamProxy:RemoveMyHireTeamMembers(dels)
  if self.myTeam then
    self.myTeam:Server_RemoveHireTeamMembers(dels)
  end
end

function TeamProxy:ClearHireTeamMembers()
  if self.myTeam then
    self.myTeam:ClearHireTeamMembers()
  end
end

function TeamProxy:GetMyHireTeamMembers()
  if self.myTeam then
    return self.myTeam:GetHireTeamMembers()
  end
  return {}
end

function TeamProxy:GetMercenaryCatByID(id)
  if self.myTeam then
    return self.myTeam.hireMemberMap[id]
  end
end

function TeamProxy:GetCanChangeCats()
  local teamCats = self.myTeam:GetHireCatID()
  local catDatas = {}
  local hireCats = self:GetMyHireTeamMembers()
  local curServerTime = ServerTime.CurServerTime() / 1000
  local dycatid = {}
  for i = 1, #hireCats do
    local catData = hireCats[i]
    if not TeamProxy.Instance:IsInMyTeam(catData.id) and curServerTime > catData.expiretime then
      local cat = {}
      cat.expiretime = catData.expiretime
      cat.id = catData.cat
      dycatid[#dycatid + 1] = cat.id
      catDatas[#catDatas + 1] = cat
    end
  end
  for _, cfg in pairs(Table_MercenaryCat) do
    if 0 == TableUtility.ArrayFindIndex(dycatid, cfg.id) and 0 == TableUtility.ArrayFindIndex(teamCats, cfg.id) and FunctionUnLockFunc.Me():CheckCanOpen(cfg.MenuID) then
      local cat = {}
      cat.id = cfg.id
      cat.expiretime = 0
      catDatas[#catDatas + 1] = cat
    end
  end
  return catDatas
end

function TeamProxy:ExitTeam(exitType)
  local _exitType = exitType or TeamProxy.ExitType.ServerExit
  if self.myTeam then
    if self.myTeam.id ~= 0 then
      local myself = Game.Myself
      if myself and myself.data then
        myself.data:SetTeamID(self.myTeam.id)
      end
    end
    self.myTeam:Exit(_exitType)
    self.myTeam = nil
  end
  self:ExitGroup()
  FunctionPve.Me():TryReset()
  GameFacade.Instance:sendNotification(TeamEvent.ExitTeam, _exitType)
  GameFacade.Instance:sendNotification(ServiceEvent.SessionTeamExitTeam, _exitType)
  self:_AfterLeaveTeam()
  if nil ~= self.exitTeamCb and exitType == TeamProxy.ExitType.ServerExit then
    self.exitTeamCb()
  end
  self:ClearServerExitTeamCb()
end

function TeamProxy:SetServerExitTeamCallBack(func)
  self.exitTeamCb = func
end

function TeamProxy:ClearServerExitTeamCb()
  self.exitTeamCb = nil
end

function TeamProxy:Reconnect()
  self:ClearServerExitTeamCb()
end

function TeamProxy:ExitGroup()
  if self.uniteGroupTeam then
    self.uniteGroupTeam:Exit(exitType)
    self.uniteGroupTeam = nil
    MsgManager.ShowMsgByIDTable(25972)
  end
  GameFacade.Instance:sendNotification(TeamEvent.ExitGroup)
end

function TeamProxy:HandleUserApplyUpdate(serverdata, isgroup)
  if not self.userApplyMap then
    self.userApplyMap = {}
  end
  local updates = serverdata.updates
  if updates then
    for i = 1, #updates do
      local data = {}
      data.createtime = updates[i].createtime
      data.isgroup = isgroup
      self.userApplyMap[updates[i].teamid] = data
    end
  end
  local deletes = serverdata.deletes
  if deletes then
    for i = 1, #deletes do
      self.userApplyMap[deletes[i]] = nil
    end
  end
end

function TeamProxy:GetUserApply(teamid)
  if not self.userApplyMap then
    return
  end
  return self.userApplyMap[teamid]
end

function TeamProxy:RemoveApply(teamid)
  self.userApplyMap[teamid] = nil
end

function TeamProxy:GetUserApplyCt()
  local c = 0
  if self.userApplyMap then
    for k, v in pairs(self.userApplyMap) do
      c = c + 1
    end
  end
  return c
end

function TeamProxy:IHaveTeam()
  return self.myTeam ~= nil and self.myTeam.id ~= 0
end

function TeamProxy:IHaveGroup()
  return self:IHaveTeam() and self.myTeam.uniteteamid ~= nil and self.myTeam.uniteteamid ~= 0
end

function TeamProxy:IsSubTeamLeader()
  return self:IHaveTeam() and self:CheckIHaveLeaderAuthority() and not self:IHaveGroup()
end

function TeamProxy:IsInMyTeam(playerid)
  if self.myTeam then
    return self.myTeam:GetMemberByGuid(playerid) ~= nil
  end
  return false
end

function TeamProxy:IsInUniteGroupTeam(playerid)
  if self.uniteGroupTeam then
    return self.uniteGroupTeam:GetMemberByGuid(playerid) ~= nil
  end
  return false
end

function TeamProxy:IsInMyGroup(playerid)
  local found = false
  if self.myTeam then
    found = self.myTeam:GetMemberByGuid(playerid) ~= nil
  end
  if self.uniteGroupTeam then
    found = found or false
  end
  return found
end

function TeamProxy:IsInSameTeam(id1, id2)
  return (not self:IsInMyTeam(id1) or not self:IsInMyTeam(id2)) and self:IsInUniteGroupTeam(id1) and self:IsInUniteGroupTeam(id2)
end

function TeamProxy:CheckImTheLeader()
  local myMemberData = self:GetMyTeamMemberData()
  if myMemberData then
    return myMemberData.job == SessionTeam_pb.ETEAMJOB_LEADER
  end
  return false
end

function TeamProxy:GetTeamLeaderId()
  if self:IHaveTeam() then
    local list = self.myTeam:GetMembersList()
    for k, v in pairs(list) do
      if v.job == SessionTeam_pb.ETEAMJOB_LEADER then
        return v.id
      end
    end
  end
  return nil
end

function TeamProxy:CheckImTheGroupLeader()
  return self:IHaveGroup() and self.myTeam:IsLeaderTeamInGroup() and self:CheckImTheLeader()
end

function TeamProxy:CheckIHaveLeaderAuthority()
  local myMemberData = self:GetMyTeamMemberData()
  if myMemberData then
    return myMemberData.job == SessionTeam_pb.ETEAMJOB_LEADER or myMemberData.job == SessionTeam_pb.ETEAMJOB_TEMPLEADER
  end
  return false
end

function TeamProxy:CheckIHaveGroupLeaderAuthority()
  return self:IHaveGroup() and self.myTeam:IsLeaderTeamInGroup() and self:CheckIHaveLeaderAuthority()
end

function TeamProxy:GetMyTeamMemberData()
  if not Game.Myself then
    return
  end
  if not self.myTeam then
    return
  end
  return self.myTeam:GetMemberByGuid(Game.Myself.data.id)
end

function TeamProxy:CheckMyselfAutoFollowIsOpen()
  local md = self:GetMyTeamMemberData()
  if md then
    return md.autofollow == 1
  end
  return false
end

function TeamProxy:UpdateAroundTeamList(list, type)
  TableUtility.ArrayClear(self.aroundTeamList)
  TableUtility.TableClear(self.mainSubTeamIndex)
  for i = 1, #list do
    local teamData = TeamData.new(list[i])
    table.insert(self.aroundTeamList, teamData)
    if teamData:IsGroupTeam() then
      self.mainSubTeamIndex[teamData.id] = teamData.uniteteamid
    end
  end
  if type == 0 then
    return
  end
  table.sort(self.aroundTeamList, function(l, r)
    local lsortid = l:GetAroundTeamSortID()
    local rsortid = r:GetAroundTeamSortID()
    if lsortid == rsortid then
      return l.id < r.id
    else
      return lsortid > rsortid
    end
  end)
end

function TeamProxy:IsMyTeamFull()
  if self:IHaveTeam() then
    return self.myTeam:IsTeamFull()
  end
  return false
end

function TeamProxy:GetMyTeamMemberList()
  if self:IHaveTeam() then
    return self.myTeam:GetPlayerMemberList(true, true)
  end
end

function TeamProxy:GetMyTeamMemberCount()
  local myTeamMemberList = self:GetMyTeamMemberList()
  if myTeamMemberList then
    return #myTeamMemberList
  end
  return 0
end

function TeamProxy:GetUniteTeamMemberCount()
  if self.uniteGroupTeam then
    return #self.uniteGroupTeam:GetPlayerMemberList(true)
  end
  return 0
end

function TeamProxy:GetGroupTeammateNum()
  local num = 0
  if self:IHaveGroup() then
    num = #self.myTeam:GetPlayerMemberList(true, true)
    local uniteteam = self:GetGroupUniteTeamData()
    if nil ~= uniteteam then
      num = num + #uniteteam:GetPlayerMemberList(true)
    end
  end
  return num
end

function TeamProxy:HandleQueryMemberTeam(data)
  local oldGroupLeaderId = self:GetGroupLeaderGuid()
  if self:IHaveGroup() and data.teamid == self.myTeam.uniteteamid then
    if not self.uniteGroupTeam then
      self.uniteGroupTeam = GroupTeamData.new()
    end
    self.uniteGroupTeam:SetData(data)
    self.myTeam:RefreshGroupTeamIndex()
  end
  if not self.teamMemberMap then
    self.teamMemberMap = {}
  end
  self.teamMemberMap[data.teamid] = {}
  for i = 1, #data.members do
    local member = TeamMemberData.new(data.members[i])
    table.insert(self.teamMemberMap[data.teamid], member)
  end
  local newGroupLeaderId = self:GetGroupLeaderGuid()
  if newGroupLeaderId and newGroupLeaderId ~= oldGroupLeaderId then
    FunctionPve.Me():TryResetLeaderReady(newGroupLeaderId)
    GameFacade.Instance:sendNotification(TeamEvent.GroupLeaderChanged, {oldGroupLeaderId, newGroupLeaderId})
  end
end

function TeamProxy:ClearTeamMembers()
  if self.teamMemberMap then
    TableUtility.TableClear(self.teamMemberMap)
  end
end

function TeamProxy:GetTeamMembers(teamid)
  if not self.teamMemberMap then
    return
  end
  local teams = self.teamMemberMap[teamid]
  local result = {}
  if teams then
    for i = 1, #teams do
      result[#result + 1] = teams[i]
    end
  end
  local uniteteamid = self:GetUniteTeamid(teamid)
  if uniteteamid then
    local uniteteams = self.teamMemberMap[uniteteamid]
    if uniteteams then
      for i = 1, #uniteteams do
        result[#result + 1] = uniteteams[i]
      end
    end
  end
  return result
end

function TeamProxy:CheckImageInActive()
  return self:IHaveTeam() and self.myTeam:CheckImageInActive()
end

function TeamProxy:GetUniteTeamid(teamid)
  if self.mainSubTeamIndex then
    local id = self.mainSubTeamIndex[teamid]
    if not id then
      for k, v in pairs(self.mainSubTeamIndex) do
        if v == teamid then
          return k
        end
      end
    end
    return id
  end
end

function TeamProxy:GetAroundTeamList()
  return self.aroundTeamList
end

function TeamProxy:SetQuickEnterTime(time)
  self.quickEnterTime = time
end

function TeamProxy:IsQuickEntering()
  if self.quickEnterTime ~= nil then
    return ServerTime.CurServerTime() / 1000 < self.quickEnterTime
  end
  return false
end

function TeamProxy:CheckIsCatByPlayerId(id)
  if self.myTeam then
    local memberData = self.myTeam:GetMemberByGuid(id)
    if memberData and memberData.cat then
      return memberData.cat ~= 0
    end
  end
  return false
end

function TeamProxy:GetCatMasterName(catid)
  if self.myTeam then
    local memberData = self.myTeam:GetMemberByGuid(catid)
    if memberData then
      return memberData.mastername
    end
  end
end

function TeamProxy:GetGuildNumInTeam()
  local num = 0
  if not self.myTeam then
    return num
  end
  for id, _ in pairs(self.myTeam.membersMap) do
    local isInMyGuild = GuildProxy.Instance:CheckIsInMyGuild(id)
    if isInMyGuild then
      num = num + 1
    end
  end
  return num
end

function TeamProxy:GetGroupUniteTeamData()
  if self.uniteGroupTeam and self.myTeam and self.myTeam.uniteteamid == self.uniteGroupTeam.id then
    return self.uniteGroupTeam
  end
end

function TeamProxy:GetMemberCreatureArrayInRange(range, creatureArray, filter, filterArgs)
  if self.myTeam == nil then
    return
  end
  local _MapManager = Game.MapManager
  if _MapManager:IsPveMode_Thanatos() then
    local myPosition = Game.Myself:GetPosition()
    if Game.LogicManager_MapCell:IsCreatureUpdateWorking() then
      local list = Game.LogicManager_MapCell:GetCreaturesAround(myPosition, function(player)
        return filter(player, filterArgs)
      end, range, Creature_Type.Player)
      TableUtil.InsertArray(creatureArray, list)
    else
      local map = NSceneUserProxy.Instance.userMap
      for _, v in pairs(map) do
        if nil ~= v and (filter == nil or filter(v, filterArgs)) then
          if 0 < range then
            local dist = VectorUtility.DistanceXZ(v:GetPosition(), myPosition)
            if range > dist then
              TableUtility.ArrayPushBack(creatureArray, v)
            end
          else
            TableUtility.ArrayPushBack(creatureArray, v)
          end
        end
      end
    end
  else
    self.myTeam:GetMemberCreatureArrayInRange(range, creatureArray, filter, filterArgs)
  end
  local uniteGroupTeam = self:GetGroupUniteTeamData()
  if uniteGroupTeam ~= nil and _MapManager:IsPvPMode_TeamTwelve() then
    uniteGroupTeam:GetMemberCreatureArrayInRange(range, creatureArray, filter, filterArgs)
  end
end

function TeamProxy:CheckWarbandFitGroupMemberValid(modeProxy)
  local proxy = modeProxy or WarbandProxy.Instance
  if not self:IHaveGroup() then
    return false
  end
  local list = self.myTeam:GetMembersList()
  for k, v in pairs(list) do
    if not proxy:CheckInMyBand(v.id) then
      return false
    end
  end
  local uniteteam = self:GetGroupUniteTeamData()
  if uniteteam then
    local list = uniteteam:GetMembersList()
    for k, v in pairs(list) do
      if not proxy:CheckInMyBand(v.id) then
        return false
      end
    end
  end
  return true
end

function TeamProxy:HandleGroupDataUpdate()
  if self:IHaveGroup() then
    ServiceSessionTeamProxy.Instance:CallQueryMemberTeamCmd(self.myTeam.uniteteamid)
  end
end

function TeamProxy:HandleGroupApplyUpdate(server_updates, server_dels)
  if self.myTeam then
    self.myTeam:UpdateGroupApply(server_updates, server_dels)
  end
end

function TeamProxy.IsGroupTeamGoal(goal)
  return Table_TeamGoals[goal] and Table_TeamGoals[goal].Filter == 42
end

function TeamProxy.IsRoguelike(goal)
  return Table_TeamGoals[goal] and Table_TeamGoals[goal].Filter == 48
end

function TeamProxy.IsExpRaid(goal)
  return Table_TeamGoals[goal] and Table_TeamGoals[goal].Filter == 8
end

function TeamProxy:GetGroupLeaderGuid()
  if not self:IHaveGroup() then
    return nil
  end
  local teamData = self.myTeam and self.myTeam:IsLeaderTeamInGroup() and self.myTeam or self.uniteGroupTeam
  local leaderData = teamData and teamData:GetNowLeader()
  return leaderData and leaderData.id
end

function TeamProxy:IsSameMapWithNowLeader()
  if not self:IHaveTeam() then
    return false
  end
  local nowLeader = self.myTeam:GetNowLeader()
  return nowLeader and nowLeader:IsSameMap()
end

function TeamProxy:GetChatTeamFreshTime()
  return self.refreshChatTime
end

function TeamProxy:SetChatTeamFreshTime(t)
  self.refreshChatTime = t
end

function TeamProxy:SetDiffServerJoinRoomStatus(parentObj, uiToggle, tipObj, supportServerMerge, invalid)
  if invalid then
    parentObj:SetActive(false)
    return
  end
  local curIsMergeServer = ChangeZoneProxy.Instance:CheckCurIsMergeServer()
  if curIsMergeServer and supportServerMerge then
    parentObj:SetActive(true)
    if not self:IHaveTeam() then
      uiToggle.gameObject:SetActive(true)
      tipObj:SetActive(false)
    else
      local hasDiffMember = self:CheckHasDiffServerMember(true)
      uiToggle.gameObject:SetActive(not hasDiffMember)
      tipObj:SetActive(hasDiffMember)
    end
  else
    parentObj:SetActive(false)
  end
end

function TeamProxy:CallTeamMemberApply(teamguid, isValid)
  if isValid then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.SelectTeamRolePopUp,
      viewdata = teamguid
    })
  else
    MsgManager.ShowMsgByID(28102)
  end
end

function TeamProxy:SetDiffServerChooseStatus(type, status)
  if not type then
    return
  end
  self.onlyMyServerChoose[type] = status
end

function TeamProxy:GetDiffServerChooseStatus(type)
  return self.onlyMyServerChoose[type] or false
end

function TeamProxy:SwitchTeamMember(memberId1, memberId2)
  self:StoreTeamData()
  local myTeam = self.myTeam
  local uniteGroupTeam = self.uniteGroupTeam
  if memberId1 == Game.Myself.data.id then
    self:SwitchGroupLeader(memberId1, memberId2)
  elseif self:IsInMyTeam(memberId1) then
    local member1 = myTeam:RemoveMember(memberId1)
    if self:IsInMyGroup(memberId2) then
      local member2 = uniteGroupTeam:RemoveMember(memberId2)
      if not member2:IsHireMember() then
        if member2.job == SessionTeam_pb.ETEAMJOB_LEADER then
          local uniteGroupTeamMems = uniteGroupTeam:GetMembersList()
          local mem = uniteGroupTeamMems[1]
          if mem and not mem:IsHireMember() then
            mem.job = SessionTeam_pb.ETEAMJOB_LEADER
          end
        end
        myTeam:AddTeamMemberData(member2)
        member2.job = SessionTeam_pb.ETEAMJOB_MEMBER
      end
      uniteGroupTeam:AddTeamMemberData(member1)
    elseif not memberId2 then
      uniteGroupTeam:AddTeamMemberData(member1)
    end
  elseif self:IsInMyGroup(memberId1) then
    if memberId2 == Game.Myself.data.id then
      self:SwitchGroupLeader(memberId2, memberId1)
    else
      local member1 = uniteGroupTeam:RemoveMember(memberId1)
      if member1.job == SessionTeam_pb.ETEAMJOB_LEADER then
        local uniteGroupTeamMems = uniteGroupTeam:GetMembersList()
        local mem = uniteGroupTeamMems[1]
        if mem and not mem:IsHireMember() then
          mem.job = SessionTeam_pb.ETEAMJOB_LEADER
        end
      end
      member1.job = SessionTeam_pb.ETEAMJOB_MEMBER
      if self:IsInMyTeam(memberId2) then
        local member2 = myTeam:RemoveMember(memberId2)
        if not member2:IsHireMember() then
          uniteGroupTeam:AddTeamMemberData(member2)
        end
        myTeam:AddTeamMemberData(member1)
      elseif not memberId2 then
        myTeam:AddTeamMemberData(member1)
      end
    end
  end
end

function TeamProxy:SwitchGroupLeader(groupLeaderId, anotherId)
  local myTeamMembers = self.myTeam:GetMembersList()
  local myTeamOtherMembers = {}
  for i = #myTeamMembers, 1, -1 do
    local v = myTeamMembers[i]
    if v.id ~= groupLeaderId then
      local mem = self.myTeam:RemoveMember(v.id)
      myTeamOtherMembers[#myTeamOtherMembers + 1] = mem
    end
  end
  local uniteGroupTeamMembers = self.uniteGroupTeam:GetMembersList()
  local uniteGroupTeamOtherMembers = {}
  for i = #uniteGroupTeamMembers, 1, -1 do
    local v = uniteGroupTeamMembers[i]
    if v.id ~= anotherId then
      local mem = self.uniteGroupTeam:RemoveMember(v.id)
      uniteGroupTeamOtherMembers[#uniteGroupTeamOtherMembers + 1] = mem
    end
  end
  for i = 1, #uniteGroupTeamOtherMembers do
    local mem = uniteGroupTeamOtherMembers[i]
    self.myTeam:AddTeamMemberData(mem)
    if mem.job == SessionTeam_pb.ETEAMJOB_LEADER then
      mem.job = SessionTeam_pb.ETEAMJOB_MEMBER
      local myTeamMem = myTeamOtherMembers[1]
      myTeamMem.job = SessionTeam_pb.ETEAMJOB_LEADER
    end
  end
  for i = 1, #myTeamOtherMembers do
    local mem = myTeamOtherMembers[i]
    self.uniteGroupTeam:AddTeamMemberData(mem)
  end
end

function TeamProxy:StoreTeamData()
  self.myTeam:StoreMembersData()
  self.uniteGroupTeam:StoreMembersData()
end

function TeamProxy:RestoreTeamData()
  self.myTeam:RestoreMembersData()
  self.uniteGroupTeam:RestoreMembersData()
end

function TeamProxy:ClearStoredTeamData()
  self.myTeam:ClearStoreMembersData()
  self.uniteGroupTeam:ClearStoreMembersData()
end

function TeamProxy:GetMainTeamMemberIds()
  local ids = {}
  local teamMembers = self.myTeam:GetPlayerMemberList(true, true)
  for i = 1, #teamMembers do
    ids[i] = teamMembers[i].id
  end
  return ids
end

function TeamProxy:GetSubTeamMemberIds()
  local ids = {}
  local teamMembers = self.uniteGroupTeam:GetPlayerMemberList(true)
  for i = 1, #teamMembers do
    ids[i] = teamMembers[i].id
  end
  return ids
end

function TeamProxy:IsLastPlayerInTeam(playerid)
  if self:IsInMyTeam(playerid) then
    return self:GetMyTeamMemberCount() == 1
  elseif self:IsInUniteGroupTeam(playerid) then
    return self:GetUniteTeamMemberCount() == 1
  end
  return false
end

function TeamProxy:IsSwitchMemberEnabled()
  return not self.myTeam.switchMemberState or self.myTeam.switchMemberState == 0
end

function TeamProxy:UpdateNewRecruitPublishTeam(data)
  local team = data.team
  local chat = data.chat
  local maxTeamNum = GameConfig.Recruit and GameConfig.Recruit.maxTeamNum
  maxTeamNum = maxTeamNum or 20
  redlog("TeamProxy:UpdateNewRecruitPublishTeam", team.data.guid)
  TableUtility.ArrayRemoveByPredicate(self.recruitTeamList, function(teamData, id)
    return teamData.id == id
  end, team.data.guid)
  if maxTeamNum <= #self.recruitTeamList then
    table.remove(self.recruitTeamList, 1)
  end
  local teamData = RecruitTeamData.new(team, chat)
  self.recruitTeamList[#self.recruitTeamList + 1] = teamData
end

function TeamProxy:UpdateRecruitTeamInfo(delIds, teams)
  if delIds then
    for i = 1, #delIds do
      TableUtility.ArrayRemoveByPredicate(self.recruitTeamList, function(teamData, id)
        return teamData.id == id
      end, delIds[i])
    end
  end
  if teams then
    for i = 1, #teams do
      local team = teams[i]
      local teamData = TableUtility.ArrayFindByPredicate(self.recruitTeamList, function(teamData, id)
        return teamData.id == id
      end, team.data.guid)
      teamData:SetData(team)
    end
  end
end

function TeamProxy:GetRecruitTeamList()
  return self.recruitTeamList
end

function TeamProxy:GetReqRecruitTeamInfoList(list)
  for i = 1, #self.recruitTeamList do
    local teamData = self.recruitTeamList[i]
    local recruitTeamData = {}
    recruitTeamData.data = {
      guid = teamData.id
    }
    recruitTeamData.version_time = teamData.version_time
    list[i] = recruitTeamData
  end
  return list
end

function TeamProxy:GetReqRecruitTeamInfo(list, teamId)
  local teamData = TableUtility.ArrayFindByPredicate(self.recruitTeamList, function(data, id)
    return data.id == id
  end, teamId)
  if teamData then
    local recruitTeamData = {}
    recruitTeamData.data = {
      guid = teamData.id
    }
    recruitTeamData.version_time = teamData.version_time
    list[#list + 1] = recruitTeamData
  end
  return list
end

function TeamProxy:IsRecruitTeamCanApply(teamId)
  local data = TableUtility.ArrayFindByPredicate(self.recruitTeamList, function(teamData, id)
    return teamData.id == id
  end, teamId)
  if self:IHaveTeam() and (data.id == Game.Myself.data:GetTeamID() or data:IsGroupTeam() or not self:IsSubTeamLeader()) then
    return false
  end
  return true
end

function TeamProxy:CallTeamMemberApply(teamguid, isValid, teamData)
  if isValid then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.SelectTeamRolePopUp,
      viewdata = {teamguid, teamData}
    })
  else
    MsgManager.ShowMsgByID(28102)
  end
end

function TeamProxy:GetLeaderMemberData()
  if not self.myTeam then
    return nil
  end
  local nowLeader = self.myTeam:GetNowLeader()
  return nowLeader
end

function TeamProxy:HasRobotInTeam()
  if not self.myTeam then
    return false
  end
  local mlist = self.myTeam:GetMembersList()
  for k, v in pairs(mlist) do
    if v:IsRobotMember() then
      return true
    end
  end
  local uniteteam = self:GetGroupUniteTeamData()
  if uniteteam then
    local list = uniteteam:GetMembersList()
    for k, v in pairs(list) do
      if v:IsRobotMember() then
        return true
      end
    end
  end
  return false
end

function TeamProxy:GetMyTeamMemberPos(id)
  if self.myTeam then
    local member = self.myTeam:GetMemberByGuid(id)
    if member then
      return member:GetPos()
    end
  end
  return nil
end

function TeamProxy:CheckTeamTwsProfValid()
  local pwsProfLimit = GameConfig.PvpTeamRaidPublic.SameProfLimit
  if not pwsProfLimit then
    return true
  end
  local myselfTeamData = TeamProxy.Instance.myTeam
  if TeamProxy.Instance:IHaveTeam() and myselfTeamData ~= nil then
    local extistProfs = {}
    local teammates = myselfTeamData:GetPlayerMemberList(true, true)
    if teammates ~= nil then
      for _, v in pairs(teammates) do
        local prof = v.profession
        if not extistProfs[prof] then
          extistProfs[prof] = 1
        else
          extistProfs[prof] = extistProfs[prof] + 1
          if pwsProfLimit < extistProfs[prof] then
            local sysmsgData = Table_Sysmsg[26294]
            if sysmsgData then
              local sysText = sysmsgData.Text
              MsgManager.FloatMsg(sysmsgData.Title, string.format(sysText, extistProfs[prof]))
            end
            return false
          end
        end
      end
    end
  end
  return true
end

local create_single_team_max_wait_time = 10
local create_single_team_max_wait_time_tick_id = 114514

function TeamProxy:ForceCreateSingleTeam(fin_call_back, fail_call_back)
  if self.create_single_team_context then
    TimeTickManager.Me():ClearTick(self, create_single_team_max_wait_time_tick_id)
    if self.create_single_team_context.fail_call_back then
      self.create_single_team_context.fail_call_back()
    end
    self.create_single_team_context = nil
  end
  if not self:IHaveTeam() then
    self:_CreateDefaultSingleTeam()
    if fin_call_back then
      fin_call_back()
    end
  else
    local list = self.myTeam:GetMembersList()
    if 1 < #list then
      if not self.create_single_team_context then
        self.create_single_team_context = {}
        self.create_single_team_context.fin_call_back = fin_call_back
        self.create_single_team_context.fail_call_back = fail_call_back
        TimeTickManager.Me():CreateOnceDelayTick(create_single_team_max_wait_time * 1000, function()
          if self.create_single_team_context then
            if self.create_single_team_context.fail_call_back then
              self.create_single_team_context.fail_call_back()
            end
            self.create_single_team_context = nil
          end
        end, self, create_single_team_max_wait_time_tick_id)
      end
      self:_LeaveTeam()
    elseif fin_call_back then
      fin_call_back()
    end
  end
end

function TeamProxy:_LeaveTeam()
  if TeamProxy.Instance:IHaveTeam() then
    ServiceSessionTeamProxy.Instance:CallExitTeam(TeamProxy.Instance.myTeam.id)
  end
end

function TeamProxy:_AfterLeaveTeam()
  if self.create_single_team_context then
    TimeTickManager.Me():ClearTick(self, create_single_team_max_wait_time_tick_id)
    self:_CreateDefaultSingleTeam()
    if self.create_single_team_context.fin_call_back then
      self.create_single_team_context.fin_call_back()
    end
    self.create_single_team_context = nil
  end
end

function TeamProxy:_CreateDefaultSingleTeam()
  local teamState = SessionTeam_pb.ETEAMSTATE_FREE
  local teamDesc = ""
  local defaultname = Game.Myself.data.name .. GameConfig.Team.teamname
  local filterType = GameConfig.MaskWord.TeamName
  local accept = 0
  if FunctionMaskWord.Me():CheckMaskWord(defaultname, filterType) then
    defaultname = Game.Myself.data.name .. "_" .. GameConfig.Team.teamname
  end
  local filtratelevel = GameConfig.Team.filtratelevel
  local defaultMinlv, defaultMaxlv = filtratelevel[1], filtratelevel[#filtratelevel]
  local goal = GameConfig.Team.defaulttype
  local typeName = Table_TeamGoals[goal].NameZh
  teamDesc = goal == GameConfig.Team.defaulttype and typeName or string.format(GameConfig.Team.defaulTeamDesc, typeName)
  if goal then
    local goalData = Table_TeamGoals[goal]
    if goalData and goalData.SetShow == 0 then
      if goalData.Filter == 10 then
        goal = 10010
      elseif goalData.SetShow == 0 then
        goal = goalData.type
      end
    end
  end
  if BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
    defaultname = defaultname:gsub(" ", ""):gsub("%(", ""):gsub("%)", "")
    teamDesc = teamDesc:gsub(" ", ""):gsub("%(", ""):gsub("%)", "")
  end
  ServiceSessionTeamProxy:CallCreateTeam(defaultMinlv, defaultMaxlv, goal, accept, defaultname, teamState, teamDesc)
end

function TeamProxy:GetMemberCountInRange(range, filter, filterArgs, targetPosition)
  if self.myTeam == nil then
    return 0
  end
  return self.myTeam:GetMemberCountInRange(range, filter, filterArgs, targetPosition)
end
