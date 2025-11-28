FunctionTeam = class("FunctionTeam")
FunctionTeam.EndlessTowerID = 31

function FunctionTeam.Me()
  if nil == FunctionTeam.me then
    FunctionTeam.me = FunctionTeam.new()
  end
  return FunctionTeam.me
end

function FunctionTeam:ctor()
  self.canInviteFollow = true
end

function FunctionTeam:InviteMemberFollow()
  self:TryInviteMemberFollow()
end

function FunctionTeam:TryInviteMemberFollow(charid, follow)
  if TeamProxy.Instance:IHaveTeam() then
    local myTeam = TeamProxy.Instance.myTeam
    local memberlist = myTeam:GetMembersList()
    if 1 < #memberlist then
      self:DoInviteMemberFollow(charid, follow)
    else
      MsgManager.ShowMsgByIDTable(345)
    end
  end
end

function FunctionTeam:DoInviteMemberFollow(charid, follow)
  if follow == false then
    ServiceNUserProxy.Instance:CallInviteFollowUserCmd(charid, follow)
    return
  end
  if self.canInviteFollow then
    self.canInviteFollow = false
    MsgManager.ShowMsgByIDTable(342)
    ServiceNUserProxy.Instance:CallInviteFollowUserCmd(charid, follow)
    if self.inviteFollow_LT then
      self.inviteFollow_LT:Destroy()
      self.inviteFollow_LT = nil
    end
    self.inviteFollow_LT = TimeTickManager.Me():CreateOnceDelayTick(20000, function(owner, deltaTime)
      self.canInviteFollow = true
      self.inviteFollow_LT = nil
    end, self)
  else
    MsgManager.ShowMsgByIDTable(343)
  end
end

function FunctionTeam:MyTeamJobChange(newjob)
  if newjob ~= SessionTeam_pb.ETEAMJOB_LEADER or newjob ~= SessionTeam_pb.ETEAMJOB_TEMPLEADER then
    RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_TEAMAPPLY)
    TeamProxy.Instance.myTeam:ClearApplyList()
  end
end

function FunctionTeam:OnClickPublish(goal)
  if Game.Myself:IsDead() then
    MsgManager.ShowMsgByIDTable(2500)
    return
  end
  local isgroupTeamGoal = TeamProxy.IsGroupTeamGoal(goal)
  if TeamProxy.Instance:IHaveGroup() and not isgroupTeamGoal then
    MsgManager.ShowMsgByID(25957)
    return
  end
  if TeamProxy.Instance:IHaveGroup() and not TeamProxy.Instance:CheckIHaveGroupLeaderAuthority() then
    MsgManager.ShowMsgByID(25958)
    return
  end
  if TeamProxy.Instance:IHaveTeam() and not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
    MsgManager.ShowMsgByID(364)
    return
  end
  local matchStatus, etype = PvpProxy.Instance:GetCurMatchStatus()
  if matchStatus and etype == PvpProxy.Type.TeamPws and (matchStatus.isprepare or matchStatus.ismatch) then
    MsgManager.ShowMsgByID(25984)
    return
  end
  if TeamProxy.IsRoguelike(goal) and TeamProxy.Instance.myTeam:IsRoguelikeTeamFull() then
    MsgManager.ShowMsgByID(40548)
    return
  end
  local viewData = ReusableTable.CreateTable()
  viewData.goal = goal
  viewData.ispublish = true
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TeamOptionPopUp,
    viewdata = viewData
  })
  ReusableTable.DestroyAndClearTable(viewData)
end

function FunctionTeam.DoApply(teamData)
  if not teamData then
    return
  end
  local _TeamProxy = TeamProxy.Instance
  local _haveTeam = _TeamProxy:IHaveTeam()
  if _haveTeam and not _TeamProxy:CheckIHaveLeaderAuthority() then
    MsgManager.ShowMsgByID(39100)
    return
  end
  if _TeamProxy:GetUserApplyCt() >= GameConfig.Team.maxapplycount then
    MsgManager.ShowMsgByID(362)
    return
  end
  local teamCheck, groupCheck = teamData:CheckValidRole(true)
  if TeamProxy.IsGroupTeamGoal(teamData.type) then
    if _haveTeam and teamData:IsGroupTeam() then
      return
    end
    if not _haveTeam then
      if teamData:IsGroupTeam() then
        if teamCheck then
          _TeamProxy:CallTeamMemberApply(teamData.id, teamCheck, teamData)
        else
          _TeamProxy:CallTeamMemberApply(teamData.uniteteamid, groupCheck, teamData)
        end
      else
        _TeamProxy:CallTeamMemberApply(teamData.id, teamCheck, teamData)
      end
    else
      ServiceSessionTeamProxy.Instance:CallTeamGroupApplyTeamCmd(teamData.id, nil, false)
    end
  else
    _TeamProxy:CallTeamMemberApply(teamData.id, teamCheck, teamData)
  end
end

function FunctionTeam:OnClickMatch(goal, only_myserver, entranceid, bossid, ai, heal)
  if Game.Myself:IsDead() then
    MsgManager.ShowMsgByIDTable(2500)
    return false
  end
  if not TeamProxy.IsGroupTeamGoal(goal) and TeamProxy.Instance:IHaveGroup() then
    MsgManager.ShowMsgByID(25959)
    return false
  end
  local raidMatchId = goal and Table_TeamGoals[goal] and Table_TeamGoals[goal].RaidType
  local sData = raidMatchId and Table_MatchRaid[raidMatchId]
  if not sData then
    redlog("未找到MatchRaid配置，ID: ", raidMatchId)
    MsgManager.ShowMsgByID(360)
    return false
  end
  if not TeamProxy.Instance:CheckMatchValid(sData) then
    return false
  end
  local mapRaidId
  if PvpProxy.IsPveCard(sData.Type) then
    if not Table_PveRaid[sData.RaidConfigID] then
      redlog("神域副本PveRaid表未配置ID： ", sData.RaidConfigID)
    end
    mapRaidId = Table_PveRaid[sData.RaidConfigID].RaidID
  elseif PvpProxy.IsElememt(sData.Type) then
    mapRaidId = GameConfig.ElementRaid.RaidIDs[sData.RaidConfigID][1][1]
  else
    mapRaidId = sData.RaidConfigID
  end
  local mapRaidConfig = Table_MapRaid[mapRaidId]
  if mapRaidConfig and TeamProxy.Instance:ForbiddenByRaidID(mapRaidConfig.id) then
    MsgManager.ShowMsgByID(42041)
    return false
  end
  if not PvpProxy.Instance:CheckMatchValid(sData.Type, sData.RaidConfigID) then
    return false
  end
  local matchFunc = function()
    local roomid = bossid or sData.RaidConfigID
    ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(sData.Type, roomid, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, only_myserver, entranceid, ai, heal)
  end
  if sData.Type == PvpProxy.Type.GroupRaid then
    if LocalSaveProxy.Instance:GetDontShowAgain(39105) == nil then
      MsgManager.DontAgainConfirmMsgByID(39105, matchFunc)
      return
    end
  elseif sData.Type == PvpProxy.Type.ExpRaid and not ExpRaidProxy.Instance:CheckBattleTimelenAndRemainingTimes() then
    MsgManager.ConfirmMsgByID(28022, matchFunc)
    return
  end
  matchFunc()
  return true
end

function FunctionTeam:OnClickEnter(goal)
  if Game.Myself:IsDead() then
    MsgManager.ShowMsgByIDTable(2500)
    return false
  end
  local raidMatchId = goal and Table_TeamGoals[goal] and Table_TeamGoals[goal].RaidType
  local sData = raidMatchId and Table_MatchRaid[raidMatchId]
  if not sData then
    MsgManager.ShowMsgByID(360)
    return false
  end
  local matchStatus = PvpProxy.Instance:GetCurMatchStatus()
  if matchStatus then
    MsgManager.ShowMsgByID(25917)
    return false
  end
  if MyselfProxy.Instance:RoleLevel() < sData.EnterLevel then
    MsgManager.ShowMsgByID(7301, sData.EnterLevel)
    return false
  end
  if TeamProxy.Instance:IHaveTeam() then
    if not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
      MsgManager.ShowMsgByID(25528)
      return false
    end
    local memberListExceptMe = TeamProxy.Instance.myTeam:GetMembersListExceptMe()
    for i = 1, #memberListExceptMe do
      if memberListExceptMe[i].baselv < sData.EnterLevel then
        MsgManager.ShowMsgByID(7305, sData.EnterLevel)
        return false
      end
    end
  end
  if not TeamProxy.Instance:CheckDiffServerValidByPvpType(sData.Type) or TeamProxy.Instance:ForbiddenByMatchRaidID(raidMatchId) then
    MsgManager.ShowMsgByID(42042)
    return false
  end
  local enterFunc = function()
    ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(sData.Type, sData.RaidConfigID, nil, true)
  end
  if TeamProxy.IsExpRaid(goal) and not ExpRaidProxy.Instance:CheckBattleTimelenAndRemainingTimes() then
    MsgManager.ConfirmMsgByID(28022, enterFunc)
    return false
  end
  enterFunc()
  return true
end
