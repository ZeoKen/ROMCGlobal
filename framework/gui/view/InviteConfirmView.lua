InviteConfirmView = class("InviteConfirmView", BaseView)
InviteConfirmView.ViewType = UIViewType.IConfirmLayer
autoImport("InviteConfirmCtl")
autoImport("DesertWolfInviteCell")
local teamProxy = function()
  return TeamProxy.Instance
end
local server_TeamProxy
local AssistantInviteMsgID = 368

function InviteConfirmView:Init()
  server_TeamProxy = ServiceSessionTeamProxy.Instance
  self:InitUI()
  self:MapViewListen()
end

function InviteConfirmView:InitUI()
  self.showHideCtrl = self:FindComponent("ShowHide", UIWidget)
  local inviteGrid = self:FindGO("InviteGrid")
  self.desertInviteRoot = self:FindGO("Anchor_RightCenter")
  self.conformCtl = InviteConfirmCtl.new(inviteGrid)
end

function InviteConfirmView:TempHide()
  if self.showHideCtrl then
    self.showHideCtrl.alpha = 0
  end
end

function InviteConfirmView:RecoverFromTempHide()
  if self.showHideCtrl then
    self.showHideCtrl.alpha = 1
  end
end

function InviteConfirmView:MapViewListen()
  self:AddListenEvt(InviteConfirmEvent.TempHide, self.TempHide)
  self:AddListenEvt(InviteConfirmEvent.RecoverFromTempHide, self.RecoverFromTempHide)
  self:AddListenEvt(InviteConfirmEvent.AddInvite, self.HandleRecvAddInvite)
  self:AddListenEvt(InviteConfirmEvent.RemoveInviteByType, self.HandleRemoveInviteByType)
  self:AddListenEvt(ServiceEvent.SessionTeamInviteMember, self.HandleRecvInvite)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamSummon, self.HandleRecvFollowInvite)
  self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.HandleEnterTeam)
  self:AddListenEvt(ServiceEvent.SessionTeamInviteGroupTeamCmd, self.HandleRecvInviteGroup)
  self:AddListenEvt(ServiceEvent.NUserInviteJoinHandsUserCmd, self.HandleRecvJoinHand)
  self:AddListenEvt(ServiceEvent.GuildCmdInviteMemberGuildCmd, self.HandleRecvGuildInvite)
  self:AddListenEvt(ServiceEvent.DojoDojoInviteCmd, self.HandleRecvDojoInvite)
  self:AddListenEvt(ServiceEvent.GuildCmdExchangeZoneNtfGuildCmd, self.HandleExchangeGuildZoneInvite)
  self:AddListenEvt(ServiceEvent.SceneAuguryAuguryInvite, self.HandleAuguryInvite)
  self:AddListenEvt(ServiceEvent.NUserInviteFollowUserCmd, self.HandleRecvFollow)
  self:AddListenEvt(ServiceEvent.MatchCCmdRevChallengeCCmd, self.HandleRecvChallenge)
  self:AddListenEvt(ServiceEvent.MatchCCmdFightConfirmCCmd, self.HandleDesertWorfConfirm)
  self:AddListenEvt(ServiceEvent.QuestInviteHelpAcceptQuestCmd, self.HandleRecvTeamWantedAcp)
  self:AddListenEvt(ServiceEvent.NUserCallTeamerUserCmd, self.HandleRecvCallTeamerReplyUserCmd)
  self:AddListenEvt(ServiceEvent.NUserMarriageProposalCmd, self.HandleMarriageProposalCmd)
  self:AddListenEvt(InviteConfirmEvent.Courtship_OutDistance, self.HandleMarriageProposal_OutDistance)
  self:AddListenEvt(ServiceEvent.WeddingCCmdMissyouInviteWedCCmd, self.HandleMissyouInviteWedCCmd)
  self:AddListenEvt(ServiceEvent.WeddingCCmdInviteBeginWeddingCCmd, self.HandleRecvInviteBeginWeddingCCmd)
  self:AddListenEvt(ServiceEvent.WeddingCCmdNtfReserveWeddingDateCCmd, self.HandleReserveWeddingDate)
  self:AddListenEvt(ServiceEvent.WeddingCCmdDivorceRollerCoasterInviteCCmd, self.HandleDivorceRollerCoasterInvite)
  self:AddListenEvt(ServiceEvent.NUserTwinsActionUserCmd, self.HandleRecvTwinsAction)
  self:AddListenEvt(ServiceEvent.NUserInviteWithMeUserCmd, self.HandleRecvInviteWithMe)
  self:AddListenEvt(ServiceEvent.TeamRaidCmdTeamRaidInviteCmd, self.HandleTeamRaidInviteMsg)
  self:AddListenEvt(ServiceEvent.QuestHelpQuickFinishBoardQuestCmd, self.HandleQuestHelpQuickFinish)
  self:AddListenEvt(ServiceEvent.FuBenCmdInviteSummonBossFubenCmd, self.HandleInviteSummonBossFubenCmd)
  self:AddListenEvt(ServiceEvent.SessionTeamLaunckKickTeamCmd, self.HandleVoteKickTeamMember)
  self:AddListenEvt(ServiceEvent.MatchCCmdTwelveWarbandInviterMatchCCmd, self.HandleWarbandInvite)
  self:AddListenEvt(CupModeEvent.Inviter_6v6, self.HandleCupModeInvite)
  self:AddListenEvt(TeamEvent.MemberExitTeam, self.HandleMidMatch)
  self:AddListenEvt(TeamEvent.MemberExitGroup, self.HandleMidMatch)
  self:AddListenEvt(TeamEvent.ExitTeam, self.HandleRemoveMidMatch)
  self:AddListenEvt(ServiceEvent.FuBenCmdInviteRollRewardFubenCmd, self.HandleRollRewardInviteMsg)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandlePlayerMapChange)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.HandleVarUpdate)
  self:AddListenEvt(NewbieCollegeEvent.RaidNpcFakeTeamClearInvite, self.HandleClearFakeTeamInvite)
  self:AddListenEvt(NewbieCollegeEvent.RaidNpcFakeTeamInvite, self.HandleNewbieCollegeRaidNpcFakeTeamInvite)
  self:AddListenEvt(ServiceEvent.MatchCCmdReserveRoomInviterMatchCCmd, self.HandleCustomRoomInvite)
  self:AddListenEvt(ServiceEvent.SessionTeamPublishReqHelpTeamCmd, self.HandleAssistantInvite)
  self:AddListenEvt(ServiceEvent.MessCCmdInviteeReceiveLoveConfessionMessCCmd, self.HandleLoveChallengeInvite)
end

function InviteConfirmView:HandleRemoveMidMatch()
  GameFacade.Instance:sendNotification(InviteConfirmEvent.RemoveInviteByType, InviteType.MidMatch)
end

function InviteConfirmView:HandleMidMatch()
  if not TeamProxy.Instance:CheckIHaveGroupLeaderAuthority() then
    return
  end
  if not Game.MapManager:IsPveMode_Thanatos() then
    return
  end
  local raidid = Game.MapManager:GetRaidID()
  local config = Table_TeamGroupRaid[raidid]
  if not config or not config.BossID then
    return redlog("HandleMidMatch raidid:", raidid)
  end
  if PvpProxy.Instance.groupRaidState == FuBenCmd_pb.EGROUPRAIDSCENE_OVER then
    redlog("HandleMidMatch boosOver ")
    return
  end
  local cdtime = PvpProxy.Instance:GetMidMatchCD()
  local curServerTime = ServerTime.CurServerTime() / 1000
  local cfg_mid_match_timecd = GameConfig.Team.mid_match_time_cd or 120
  if cdtime and cfg_mid_match_timecd > curServerTime - cdtime then
    redlog("InviteConfirmView:HandleMidMatch ----> cdtime")
    return
  else
    PvpProxy.Instance:ResetMidMatchCD(curServerTime)
  end
  local sData
  for k, v in pairs(Table_MatchRaid) do
    if v.RaidConfigID == raidid then
      sData = v
      break
    end
  end
  if not sData then
    return
  end
  local playerid = Game.Myself.data.id
  local data = {
    playerid = playerid,
    time = GameConfig.Team.mid_match_time,
    msgId = 384
  }
  
  function data.yesevt(id)
    local _teamPy = TeamProxy.Instance
    if not _teamPy:CheckDiffServerValidByPvpType(sData.Type) or _teamPy:ForbiddenByRaidID(sData.RaidConfigID) then
      MsgManager.ShowMsgByID(42041)
      return
    end
    ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(sData.Type, sData.RaidConfigID)
  end
  
  self.conformCtl:AddInvite(InviteType.MidMatch, data)
end

function InviteConfirmView:HandleRecvChallenge(note)
  local data = note.body
  if not data then
    return
  end
  DesertWolfInviteCell.new(self.desertInviteRoot, data)
end

function InviteConfirmView:HandleDesertWorfConfirm(note)
  local nData = note.body
  helplog("HandleDesertWorfConfirm", nData.roomid)
  if TeamProxy.Instance:CheckIHaveLeaderAuthority() then
    return
  end
  local roomid = nData.roomid
  local teamID = Game.Myself.data:GetTeamID()
  local playerid = Game.Myself.data.id
  local challenger = nData.challenger
  local data = {
    playerid = playerid,
    time = GameConfig.Team.inviteovertime,
    msgId = teamID == nData.teamid and 969 or 979,
    msgParama = {challenger}
  }
  
  function data.yesevt(id)
    ServiceMatchCCmdProxy.Instance:CallFightConfirmCCmd(PvpProxy.Type.DesertWolf, roomid, teamID, 1)
  end
  
  function data.noevt(id)
    ServiceMatchCCmdProxy.Instance:CallFightConfirmCCmd(PvpProxy.Type.DesertWolf, roomid, teamID, 2)
  end
  
  function data.endevt(id)
    ServiceMatchCCmdProxy.Instance:CallFightConfirmCCmd(PvpProxy.Type.DesertWolf, roomid, teamID, 2)
  end
  
  self.conformCtl:AddInvite(InviteType.DesertWolf, data)
end

function InviteConfirmView:HandleVoteKickTeamMember(note)
  redlog("发起投票踢人 HandleVoteKickTeamMember")
  local data = note.body
  if not data then
    return
  end
  if data.cancel then
    GameFacade.Instance:sendNotification(InviteConfirmEvent.RemoveInviteByType, InviteType.VoteKickOutTeamMember)
    return
  end
  if not data.kickid or not teamProxy():IHaveTeam() then
    return
  end
  local playerid = Game.Myself.data.id
  local msgParama
  local memData = teamProxy().myTeam and teamProxy().myTeam:GetMemberByGuid(data.kickid)
  if not memData then
    memData = teamProxy().uniteGroupTeam and teamProxy().uniteGroupTeam:GetMemberByGuid(data.kickid)
    if memData then
      msgParama = memData.name
    end
  else
    msgParama = memData.name
  end
  if not msgParama then
    redlog("voteKick not find memberData")
    return
  end
  local data = {
    playerid = playerid,
    time = GameConfig.Team.reply_kick_time,
    msgId = 383,
    msgParama = {msgParama}
  }
  
  function data.yesevt(id)
    ServiceSessionTeamProxy.Instance:CallReplyKickTeamCmd(true)
  end
  
  function data.noevt(id)
    ServiceSessionTeamProxy.Instance:CallReplyKickTeamCmd(false)
  end
  
  function data.endevt(id)
    ServiceSessionTeamProxy.Instance:CallReplyKickTeamCmd(false)
  end
  
  self.conformCtl:AddInvite(InviteType.VoteKickOutTeamMember, data)
end

function InviteConfirmView:HandleRecvTeamWantedAcp(note)
  local leaderName = note.body.leadername
  local leaderid = note.body.leaderid
  local questid = note.body.questid
  local stData = Table_WantedQuest[questid]
  local issubmit = note.body.issubmit
  if stData then
    local questName = stData.Name
    local sign = note.body.sign
    local time = note.body.time
    local msgId = 4011
    local data = {
      playerid = sign,
      time = GameConfig.Team.inviteovertime,
      msgId = msgId,
      msgParama = {leaderName, questName}
    }
    
    function data.yesevt(id)
      ServiceQuestProxy.Instance:CallReplyHelpAccelpQuestCmd(leaderid, questid, time, sign, true)
    end
    
    function data.endevt(id)
      ServiceQuestProxy.Instance:CallReplyHelpAccelpQuestCmd(leaderid, questid, time, sign, true)
    end
    
    self.conformCtl:AddInvite(InviteType.TmLeaderAcp, data)
  else
    helplog("unkown wantedQuest:", questid)
  end
end

function InviteConfirmView:HandleRecvJoinHand(note)
  local playerid = note.body.charid
  local masterid = note.body.masterid
  local username = note.body.mastername
  local sign = note.body.sign
  local time = note.body.time
  local data = {
    playerid = masterid,
    time = GameConfig.Team.inviteovertime,
    msgId = 825,
    msgParama = {username, username}
  }
  
  function data.yesevt(id)
    if teamProxy():IHaveTeam() then
      ServiceNUserProxy.Instance:CallJoinHandsUserCmd(masterid, sign, time)
    else
      MsgManager.ShowMsgByIDTable(827)
    end
  end
  
  function data.noevt(id)
    ServiceNUserProxy.Instance:CallJoinHandsUserCmd(masterid)
  end
  
  self.conformCtl:AddInvite(InviteType.JoinHand, data)
end

function InviteConfirmView:HandleRecvAddInvite(note)
  local data = note.body
  data.yestip = ZhString.InviteConfirmView_Join
  self.conformCtl:AddInvite(InviteType.Carrier, data)
end

function InviteConfirmView:HandleRemoveInviteByType(note)
  self.conformCtl:ClearInviteMap(note.body)
end

function InviteConfirmView:HandleRecvInvite(note)
  local playerid = note.body.userguid
  local teamname = note.body.teamname
  local username = note.body.username
  local data = {
    playerid = playerid,
    time = GameConfig.Team.inviteovertime,
    msgId = 323,
    msgParama = {teamname, username}
  }
  
  function data.yesevt(id)
    if TeamProxy.Instance:IHaveTeam() then
      local cb = function()
        server_TeamProxy:CallProcessTeamInvite(SessionTeam_pb.ETEAMINVITETYPE_AGREE, id)
      end
      ServiceSessionTeamProxy.Instance:CallExitTeam(TeamProxy.Instance.myTeam.id, cb)
    else
      server_TeamProxy:CallProcessTeamInvite(SessionTeam_pb.ETEAMINVITETYPE_AGREE, id)
    end
  end
  
  function data.noevt(id)
    server_TeamProxy:CallProcessTeamInvite(SessionTeam_pb.ETEAMINVITETYPE_DISAGREE, id)
  end
  
  function data.endevt(id)
    server_TeamProxy:CallProcessTeamInvite(SessionTeam_pb.ETEAMINVITETYPE_DISAGREE, id)
  end
  
  self.conformCtl:AddInvite(InviteType.Team, data)
end

function InviteConfirmView:HandleInvite(note, pvpType)
  local body = note.body
  local charid = body.charid
  local capital = body.capitalname
  local inviteovertime = GameConfig.TwelvePvp.inviteovertime or 15
  local data = {
    playerid = charid,
    time = inviteovertime,
    msgId = 28052,
    msgParama = {capital}
  }
  xdlog("受到邀请参与杯赛", pvpType, body.cross_server)
  local myname = Game.Myself.data and Game.Myself.data:GetName() or ""
  
  function data.yesevt(id)
    ServiceMatchCCmdProxy.Instance:CallTwelveWarbandInviteeMatchCCmd(true, myname, pvpType, body.cross_server)
  end
  
  function data.noevt(id)
    ServiceMatchCCmdProxy.Instance:CallTwelveWarbandInviteeMatchCCmd(false, myname, pvpType, body.cross_server)
  end
  
  function data.endevt(id)
    ServiceMatchCCmdProxy.Instance:CallTwelveWarbandInviteeMatchCCmd(false, myname, pvpType, body.cross_server)
  end
  
  self.conformCtl:AddInvite(InviteType.Warband, data)
end

function InviteConfirmView:HandleCupModeInvite(note)
  self:HandleInvite(note, PvpProxy.Type.TeamPwsChampion)
end

function InviteConfirmView:HandleWarbandInvite(note)
  redlog("InviteConfirmView HandleWarbandInvite")
  local body = note.body
  local charid = body.charid
  local capital = body.capitalname
  local inviteovertime = GameConfig.TwelvePvp.inviteovertime or 15
  local data = {
    playerid = charid,
    time = inviteovertime,
    msgId = 28052,
    msgParama = {capital}
  }
  local myname = Game.Myself.data and Game.Myself.data:GetName() or ""
  
  function data.yesevt(id)
    ServiceMatchCCmdProxy.Instance:CallTwelveWarbandInviteeMatchCCmd(true, myname)
  end
  
  function data.noevt(id)
    ServiceMatchCCmdProxy.Instance:CallTwelveWarbandInviteeMatchCCmd(false, myname)
  end
  
  function data.endevt(id)
    ServiceMatchCCmdProxy.Instance:CallTwelveWarbandInviteeMatchCCmd(false, myname)
  end
  
  self.conformCtl:AddInvite(InviteType.Warband, data)
end

function InviteConfirmView:HandleCustomRoomInvite(note)
  local body = note.body
  local charid = body.charid
  local capital = body.capitalname
  local inviteovertime = GameConfig.ReserveRoom.InviteOvertime or 10
  local data = {
    playerid = charid,
    time = inviteovertime,
    msgId = 480,
    msgParama = {capital}
  }
  local myname = Game.Myself.data and Game.Myself.data:GetName() or ""
  
  function data.yesevt(id)
    PvpCustomRoomProxy.Instance:SendInviteResp(true, myname)
  end
  
  function data.noevt(id)
    PvpCustomRoomProxy.Instance:SendInviteResp(false, myname)
  end
  
  function data.endevt(id)
    PvpCustomRoomProxy.Instance:SendInviteResp(false, myname)
  end
  
  self.conformCtl:AddInvite(InviteType.CustomRoom, data)
end

function InviteConfirmView:HandleRecvInviteGroup(note)
  self.waitForGroupAnswerID = nil
  local playerid = note.body.charid
  local username = note.body.leadername
  local data = {
    playerid = playerid,
    time = GameConfig.Team.inviteovertime,
    msgId = 25943,
    msgParama = {username}
  }
  
  function data.yesevt(id)
    if PvpProxy.Instance:Is12PvpInMatch() then
      MsgManager.ShowMsgByID(25984)
      return
    end
    if TeamProxy.Instance:IHaveTeam() then
      server_TeamProxy:CallProcessInviteGroupTeamCmd(true, id)
    else
      self:CreateDefaultTeam()
      self.waitForGroupAnswerID = id
    end
  end
  
  function data.noevt(id)
    server_TeamProxy:CallProcessInviteGroupTeamCmd(false, id)
    self.waitForGroupAnswerID = nil
  end
  
  function data.endevt(id)
    server_TeamProxy:CallProcessInviteGroupTeamCmd(false, id)
    self.waitForGroupAnswerID = nil
  end
  
  self.conformCtl:AddInvite(InviteType.Group, data)
end

function InviteConfirmView:CreateDefaultTeam()
  local teamState = SessionTeam_pb.ETEAMSTATE_FREE
  local teamDesc
  local defaultname = Game.Myself.data.name .. GameConfig.Team.teamname
  local filterType = GameConfig.MaskWord.TeamName
  local accept = GameConfig.Team.defaultauto
  if FunctionMaskWord.Me():CheckMaskWord(defaultname, filterType) then
    defaultname = Game.Myself.data.name .. "_" .. GameConfig.Team.teamname
  end
  local filtratelevel = GameConfig.Team.filtratelevel
  local defaultMinlv, defaultMaxlv = filtratelevel[1], filtratelevel[#filtratelevel]
  local goal = GameConfig.Team.defaulttype
  local typeName = Table_TeamGoals[goal].NameZh
  teamDesc = goal == GameConfig.Team.defaulttype and typeName or string.format(GameConfig.Team.defaulTeamDesc or "%s副本开组", typeName)
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
  ServiceSessionTeamProxy.Instance:CallCreateTeam(defaultMinlv, defaultMaxlv, goal, accept, defaultname, teamState, teamDesc)
end

function InviteConfirmView:HandleEnterTeam()
  if self.waitForGroupAnswerID then
    server_TeamProxy:CallProcessInviteGroupTeamCmd(true, self.waitForGroupAnswerID)
    self.waitForGroupAnswerID = nil
  end
end

function InviteConfirmView:HandleRecvFollowInvite(note)
  local leader = self.MyTeam():GetLeader()
  local raid = note.body.raidid
  local data = {
    playerid = leader.id,
    time = 20,
    msgId = 406,
    msgParama = {
      leader.name,
      Table_MapRaid[raid].NameZh
    }
  }
  local memData = teamProxy().myTeam:GetMemberByGuid(playerid)
  if not memData then
    errorLog("No Member When Recv FollowInvite")
    return
  end
  
  function data.yesevt(id)
    if Game.Myself:IsDead() then
      MsgManager.ShowMsgByIDTable(2500)
      return
    end
    local ptdata = PlayerTipData.new()
    ptdata:SetByTeamMemberData(memData)
    FunctionPlayerTip.FollowMember(ptdata)
  end
  
  self.conformCtl:AddInvite(InviteType.Carrier, data)
end

function InviteConfirmView:HandleRecvGuildInvite(note)
  local guildid = note.body.guildid
  local playername = note.body.invitename
  local guildname = note.body.guildname
  local job = note.body.job
  local isMercenaryInvite = job == GuildCmd_pb.EGUILDJOB_INVITE_MERCENARY
  local msgId = isMercenaryInvite and 31037 or 2632
  if guildid and guildname then
    local data = {
      playerid = guildid,
      time = GameConfig.Team.inviteovertime,
      msgId = msgId,
      msgParama = {playername, guildname}
    }
    
    function data.yesevt(id)
      if isMercenaryInvite and GuildProxy.Instance:IsMyGuild(guildid) then
        MsgManager.ShowMsgByID(31049)
        return
      end
      ServiceGuildCmdProxy.Instance:CallProcessInviteGuildCmd(GuildCmd_pb.EGUILDACTION_AGREE, id, job)
    end
    
    function data.noevt(id)
      ServiceGuildCmdProxy.Instance:CallProcessInviteGuildCmd(GuildCmd_pb.EGUILDACTION_DISAGREE, id, job)
    end
    
    function data.endevt(id)
      ServiceGuildCmdProxy.Instance:CallProcessInviteGuildCmd(GuildCmd_pb.EGUILDACTION_DISAGREE, id, job)
    end
    
    local inviteType = isMercenaryInvite and InviteType.Mercenary or InviteType.Guild
    self.conformCtl:AddInvite(inviteType, data)
  end
end

function InviteConfirmView:HandleRecvDojoInvite(note)
  local sponsorid = note.body.sponsorid
  local sponsorname = note.body.sponsorname
  local dojoid = note.body.dojoid
  if sponsorid and sponsorname and dojoid then
    local dojoName = Table_Guild_Dojo[dojoid] and Table_Guild_Dojo[dojoid].Name or ""
    local data = {
      playerid = sponsorid,
      time = GameConfig.Team.inviteovertime,
      msgId = 406,
      msgParama = {sponsorname, dojoName}
    }
    
    function data.yesevt(id)
      local lvreq = DojoProxy.Instance:GetGroupLvreq(dojoid)
      if lvreq and lvreq > MyselfProxy.Instance:RoleLevel() then
        MsgManager.ShowMsgByID(2950)
        ServiceDojoProxy.Instance:CallDojoReplyCmd(Dojo_pb.EDOJOREPLY_DISAGREE)
        return
      end
      ServiceDojoProxy.Instance:CallDojoReplyCmd(Dojo_pb.EDOJOREPLY_AGREE)
    end
    
    function data.noevt(id)
      ServiceDojoProxy.Instance:CallDojoReplyCmd(Dojo_pb.EDOJOREPLY_DISAGREE)
    end
    
    function data.endevt(id)
      ServiceDojoProxy.Instance:CallDojoReplyCmd(Dojo_pb.EDOJOREPLY_DISAGREE)
    end
    
    self.conformCtl:AddInvite(InviteType.Dojo, data)
  end
end

function InviteConfirmView.AgreeExchangeGuildZone(id)
  ServiceGuildCmdProxy.Instance:CallExchangeZoneAnswerGuildCmd(true)
end

function InviteConfirmView.RefuseExchangeGuildZone(id)
  ServiceGuildCmdProxy.Instance:CallExchangeZoneAnswerGuildCmd(false)
end

function InviteConfirmView:HandleExchangeGuildZoneInvite(note)
  local curzoneid = note.body.curzoneid
  curzoneid = ChangeZoneProxy.Instance:ZoneNumToString(curzoneid)
  local nextzoneid = note.body.nextzoneid
  nextzoneid = ChangeZoneProxy.Instance:ZoneNumToString(nextzoneid)
  local data = {
    playerid = "Temp",
    time = GameConfig.Team.inviteovertime,
    msgId = 3081,
    msgParama = {nextzoneid, nextzoneid}
  }
  data.yesevt = InviteConfirmView.AgreeExchangeGuildZone
  data.noevt = InviteConfirmView.RefuseExchangeGuildZone
  data.endevt = InviteConfirmView.RefuseExchangeGuildZone
  self.conformCtl:AddInvite(InviteType.Guild, data)
end

function InviteConfirmView:HandleAuguryInvite(note)
  local body = note.body
  local inviterid = body.inviterid
  local invitername = body.invitername
  local npcId = body.npcguid
  local augurytype = body.type
  local isextra = body.isextra
  local data = {
    playerid = inviterid,
    time = GameConfig.Team.inviteovertime,
    msgId = 928,
    msgParama = {invitername}
  }
  
  function data.yesevt(id)
    if npcId then
      local npc = NSceneNpcProxy.Instance:Find(npcId)
      local squareRange = NumberUtility.Square(GameConfig.Augury.Range)
      if npc and squareRange >= VectorUtility.DistanceXZ_Square(Game.Myself:GetPosition(), npc:GetPosition()) then
        ServiceSceneAuguryProxy.Instance:CallAuguryInviteReply(SceneAugury_pb.EReplyType_Agree, id, npcId, augurytype, isextra)
      else
        ServiceSceneAuguryProxy.Instance:CallAuguryInviteReply(SceneAugury_pb.EReplyType_Refuse, id, npcId, augurytype, isextra)
      end
    end
  end
  
  function data.noevt(id)
    ServiceSceneAuguryProxy.Instance:CallAuguryInviteReply(SceneAugury_pb.EReplyType_Refuse, id, npcId, augurytype, isextra)
  end
  
  function data.endevt(id)
    ServiceSceneAuguryProxy.Instance:CallAuguryInviteReply(SceneAugury_pb.EReplyType_Refuse, id, npcId, augurytype, isextra)
  end
  
  self.conformCtl:AddInvite(InviteType.Augury, data)
end

function InviteConfirmView:HandleRecvFollow(note)
  local playerid = note.body.charid
  if Game.Myself and Game.Myself:Client_GetFollowLeaderID() == playerid then
    return
  end
  if teamProxy():IHaveTeam() then
    local memData = teamProxy().myTeam:GetMemberByGuid(playerid)
    if not memData then
      errorLog("No Member When Recv FollowInvite")
      return
    end
    local data = {
      playerid = playerid,
      time = GameConfig.Team.inviteovertime,
      msgId = 344,
      msgParama = {
        memData.name
      }
    }
    local yesevt = function(id)
      if Game.Myself:IsDead() then
        MsgManager.ShowMsgByIDTable(2500)
        return
      end
      local ptdata = PlayerTipData.new()
      ptdata:SetByTeamMemberData(memData)
      FunctionPlayerTip.FollowMember(ptdata)
    end
    data.yesevt = yesevt
    
    function data.endevt(id)
      local myMemberData = teamProxy():GetMyTeamMemberData()
      if myMemberData and myMemberData.autofollow == 1 then
        yesevt(id)
      end
    end
    
    self.conformCtl:AddInvite(InviteType.Follow, data)
  else
    errorLog("No Team When Recv FollowInvite")
  end
end

function InviteConfirmView:HandleRecvCallTeamerReplyUserCmd(note)
  local playerid = note.body.masterid
  local sign = note.body.sign
  local time = note.body.time
  if teamProxy():IHaveTeam() then
    local memData = teamProxy().myTeam:GetMemberByGuid(playerid)
    if not memData then
      errorLog("No Member When Recv FollowInvite")
      return
    end
    local data = {
      playerid = playerid,
      time = 5,
      msgId = 344,
      msgParama = {
        note.body.username
      }
    }
    local yesevt = function(id)
      ServiceNUserProxy.Instance:CallCallTeamerReplyUserCmd(playerid, sign, time)
    end
    data.yesevt = yesevt
    data.endevt = yesevt
    self.conformCtl:AddInvite(InviteType.Follow, data)
  else
    errorLog("No Team When Recv FollowInvite")
  end
end

local marriageProposal_Map = {}

function InviteConfirmView:HandleMarriageProposalCmd(note)
  local server_data = note.body
  if server_data == nil then
    return
  end
  local masterid = server_data.masterid
  local mastername = server_data.mastername
  local itemid = server_data.itemid
  local sign = server_data.sign
  local server_time = server_data.time
  local gameconfig_wedding = GameConfig.Wedding
  local overtime, msgId = 5, 344
  if gameconfig_wedding then
    overtime, msgId = gameconfig_wedding.Courtship_InviteOverTime, gameconfig_wedding.Courtship_InviteMsgId
  end
  local data = {
    playerid = masterid,
    time = overtime,
    msgId = msgId
  }
  local msgData = Table_Sysmsg[msgId]
  local msgTitle = msgData.Title
  if msgTitle then
    msgTitle = string.format(msgTitle, mastername)
    data.tip = msgTitle
  end
  
  function data.yesevt(id)
    FunctionWedding.Me():RemoveCourtshipDistanceCheck(id)
    ServiceNUserProxy.Instance:CallMarriageProposalReplyCmd(id, SceneUser2_pb.EPROPOSALREPLY_YES, server_time, sign)
    marriageProposal_Map[id] = nil
  end
  
  function data.noevt(id)
    FunctionWedding.Me():RemoveCourtshipDistanceCheck(id)
    ServiceNUserProxy.Instance:CallMarriageProposalReplyCmd(id, SceneUser2_pb.EPROPOSALREPLY_NO, server_time, sign)
    marriageProposal_Map[id] = nil
  end
  
  function data.endevt(id)
    FunctionWedding.Me():RemoveCourtshipDistanceCheck(id)
    ServiceNUserProxy.Instance:CallMarriageProposalReplyCmd(id, SceneUser2_pb.EPROPOSALREPLY_CANCEL, server_time, sign, itemid)
    marriageProposal_Map[id] = nil
  end
  
  marriageProposal_Map[masterid] = {sign, server_time}
  self.conformCtl:AddInvite(InviteType.Courtship, data)
end

function InviteConfirmView:HandleMarriageProposal_OutDistance(note)
  local playerid = note.body
  if playerid == nil then
    return
  end
  local cacheInfo = marriageProposal_Map[playerid]
  if cacheInfo == nil then
    return
  end
  local sign, server_time = cacheInfo[1], cacheInfo[2]
  ServiceNUserProxy.Instance:CallMarriageProposalReplyCmd(id, SceneUser2_pb.EPROPOSALREPLY_OUTRANGE, server_time, sign)
end

function InviteConfirmView:HandleRecvInviteBeginWeddingCCmd(note)
  local server_data = note.body
  local masterid = server_data.masterid
  local myname = Game.Myself.data.name
  local name = server_data.name
  local tocharid = server_data.tocharid
  local gameconfig_wedding = GameConfig.Wedding
  local overtime, msgId = 5, 344
  if gameconfig_wedding then
    overtime, msgId = gameconfig_wedding.Cememony_InviteOverTime, gameconfig_wedding.Cememony_InviteMsgId
  end
  local msgData = Table_Sysmsg[msgId]
  local msgTitle, msgText = msgData.Title, msgData.Text
  local data = {
    playerid = masterid,
    time = overtime,
    msgId = msgId
  }
  if msgTitle ~= "" then
    msgTitle = string.format(msgTitle, myname, name)
    data.tip = msgTitle
  end
  
  function data.yesevt(id)
    ServiceWeddingCCmdProxy.Instance:CallReplyBeginWeddingCCmd(masterid)
  end
  
  function data.noevt(id)
  end
  
  function data.endevt(id)
  end
  
  self.conformCtl:AddInvite(InviteType.WeddingCemoney, data)
end

function InviteConfirmView:HandleRecvInviteWeddingStartNtf(note)
  local itemguid = note.body.itemguid
  if itemguid == nil then
    return
  end
  local itemData = BagProxy.Instance:GetItemByGuid(itemguid)
  if itemData == nil then
    return
  end
  local weddingData = itemData.weddingData
  if weddingData == nil then
    return
  end
  local gameconfig_wedding = GameConfig.Wedding
  local overtime, msgId = 5, 344
  if gameconfig_wedding then
    overtime, msgId = gameconfig_wedding.Cememony_InviteOverTime, gameconfig_wedding.Cememony_Invite_GotoMsgId
  end
  local msgData = Table_Sysmsg[msgId]
  local msgTitle, msgText = msgData.Title, msgData.Text
  local data = {
    playerid = itemguid,
    time = overtime,
    msgId = msgId
  }
  if msgTitle ~= "" then
  end
  
  function data.yesevt(id)
    ServiceWeddingCCmdProxy.Instance:CallReplyBeginWeddingCCmd(tocharid)
  end
  
  function data.noevt(id)
  end
  
  function data.endevt(id)
  end
  
  self.conformCtl:AddInvite(InviteType.WeddingCemoney, data)
end

function InviteConfirmView:HandleReserveWeddingDate(note)
  local serverData = note.body
  local zoneid = serverData.zoneid % 10000
  local starttime = os.date("*t", serverData.starttime)
  local endtime = os.date("*t", serverData.endtime)
  local id = 29999
  if GameConfig.SystemForbid.WeddingReserve then
    id = 9609
  end
  local title = Table_Sysmsg[id]
  title = string.format(title.Title, serverData.name)
  local data = {
    playerid = serverData.charid1,
    time = GameConfig.Wedding.EngageInviteOverTime,
    msgId = id,
    tip = title,
    msgParama = {
      starttime.month,
      starttime.day,
      starttime.hour,
      endtime.hour,
      ChangeZoneProxy.Instance:ZoneNumToString(zoneid)
    }
  }
  
  function data.yesevt(id)
    ServiceWeddingCCmdProxy.Instance:CallReplyReserveWeddingDateCCmd(serverData.date, serverData.configid, id, WeddingCCmd_pb.EReply_Agree, serverData.time, serverData.use_ticket, serverData.zoneid, serverData.sign)
  end
  
  function data.noevt(id)
    ServiceWeddingCCmdProxy.Instance:CallReplyReserveWeddingDateCCmd(serverData.date, serverData.configid, id, WeddingCCmd_pb.EReply_Refuse, serverData.time, serverData.use_ticket, serverData.zoneid, serverData.sign)
  end
  
  function data.endevt(id)
    ServiceWeddingCCmdProxy.Instance:CallReplyReserveWeddingDateCCmd(serverData.date, serverData.configid, id, WeddingCCmd_pb.EReply_Refuse, serverData.time, serverData.use_ticket, serverData.zoneid, serverData.sign)
  end
  
  self.conformCtl:AddInvite(InviteType.Engage, data)
end

function InviteConfirmView:HandleDivorceRollerCoasterInvite(note)
  local serverData = note.body
  local data = {
    playerid = serverData.inviter,
    time = GameConfig.Wedding.Divorce_OverTime,
    msgId = 9612,
    msgParama = {
      serverData.inviter_name
    }
  }
  
  function data.yesevt(id)
    ServiceWeddingCCmdProxy.Instance:CallDivorceRollerCoasterReplyCCmd(id, WeddingCCmd_pb.EReply_Agree)
  end
  
  function data.noevt(id)
    ServiceWeddingCCmdProxy.Instance:CallDivorceRollerCoasterReplyCCmd(id, WeddingCCmd_pb.EReply_Refuse)
  end
  
  function data.endevt(id)
    ServiceWeddingCCmdProxy.Instance:CallDivorceRollerCoasterReplyCCmd(id, WeddingCCmd_pb.EReply_Refuse)
  end
  
  self.conformCtl:AddInvite(InviteType.ConsentDivorce, data)
end

function InviteConfirmView:HandleQuestHelpQuickFinish(note)
  local serverData = note.body
  local data = {
    playerid = serverData.questid,
    msgId = 25443,
    time = 3,
    msgParama = {
      serverData.leadername
    }
  }
  
  function data.endevt(id)
    ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_QUICK_SUBMIT_BOARD, id)
  end
  
  self.conformCtl:AddInvite(InviteType.HelpFinishQuest, data)
end

function InviteConfirmView:HandleMissyouInviteWedCCmd(note)
  local playerid = Game.Myself.data.id
  local msgId = GameConfig.Wedding.MissYou_Inviteid or 969
  local data = {
    playerid = playerid,
    time = GameConfig.Team.inviteovertime,
    msgId = msgId,
    msgParama = {}
  }
  
  function data.yesevt(id)
    ServiceWeddingCCmdProxy.Instance:CallMisccyouReplyWedCCmd(true)
  end
  
  function data.noevt(id)
    ServiceWeddingCCmdProxy.Instance:CallMisccyouReplyWedCCmd(false)
  end
  
  self.conformCtl:AddInvite(InviteType.DesertWolf, data)
end

function InviteConfirmView:HandleRecvTwinsAction(note)
  local userid, actionid, etype = note.body.userid, note.body.actionid, note.body.etype
  if etype ~= SceneUser2_pb.ETWINS_OPERATION_REQUEST then
    return
  end
  local creature = SceneCreatureProxy.FindCreature(userid)
  local nameCfg = GameConfig.TwinsAction.name_ch
  local data = {
    playerid = userid,
    time = 10,
    msgId = 393,
    msgParama = {
      creature and creature.data and creature.data:GetName() or "",
      nameCfg and nameCfg[actionid] or ""
    }
  }
  
  function data.yesevt(id)
    ServiceNUserProxy.Instance:CallTwinsActionUserCmd(userid, nil, SceneUser2_pb.ETWINS_OPERATION_AGREE)
    self:sendNotification(DialogEvent.CloseDialog)
  end
  
  function data.noevt(id)
    ServiceNUserProxy.Instance:CallTwinsActionUserCmd(userid, nil, SceneUser2_pb.ETWINS_OPERATION_DISAGREE)
  end
  
  function data.endevt(id)
    ServiceNUserProxy.Instance:CallTwinsActionUserCmd(userid, nil, SceneUser2_pb.ETWINS_OPERATION_DISAGREE)
  end
  
  self.conformCtl:AddInvite(InviteType.DoubleAction, data)
end

function InviteConfirmView:HandleRecvInviteWithMe(note)
  local serverData = note.body
  local messageId = 25521
  if Table_Sysmsg[25521] == nil then
    messageId = 969
    errorLog("Message ID: 25521 is not exist")
  end
  local data = {
    playerid = serverData.sendid,
    time = GameConfig.Team.inviteovertime,
    msgId = messageId,
    msgParama = {}
  }
  
  function data.yesevt(id)
    ServiceNUserProxy.Instance:CallInviteWithMeUserCmd(serverData.sendid, serverData.time, true, serverData.sign)
  end
  
  function data.noevt(id)
    ServiceNUserProxy.Instance:CallInviteWithMeUserCmd(serverData.sendid, serverData.time, false, serverData.sign)
  end
  
  function data.endevt(id)
    ServiceNUserProxy.Instance:CallInviteWithMeUserCmd(serverData.sendid, serverData.time, false, serverData.sign)
  end
  
  self.conformCtl:AddInvite(InviteType.InviteWithMe, data)
end

function InviteConfirmView:HandleTeamRaidInviteMsg(note)
  if not note or not note.body then
    redlog("Note Is Nil")
    return
  end
  local recvData = note.body
  local raid_type, difficulty, iscancel, entranceid, lefttime = recvData.raid_type, recvData.difficulty, recvData.iscancel, recvData.entranceid, recvData.lefttime
  if PveEntranceProxy.IsNewEntrancePveById(entranceid) then
    FunctionPve.Me():HandleServerInvite(iscancel, entranceid, difficulty, lefttime)
    return
  end
  local msgId = 120
  if raid_type == FuBenCmd_pb.ERAIDTYPE_ALTMAN then
    msgId = GameConfig.Altman.invite_msgid
  end
  local data = {
    playerid = Game.Myself.data.id,
    time = GameConfig.Team.inviteovertime,
    msgId = msgId
  }
  
  function data.yesevt(id)
    local myTeam = TeamProxy.Instance.myTeam
    if myTeam == nil then
      redlog("No Team")
      return
    end
    local nowleader = myTeam:GetNowLeader()
    if nowleader == nil then
      redlog("No Leader")
      return
    end
    ServiceTeamRaidCmdProxy.Instance:CallTeamRaidReplyCmd(true, Game.Myself.data.id, raid_type)
  end
  
  function data.noevt(id)
    ServiceTeamRaidCmdProxy.Instance:CallTeamRaidReplyCmd(false, Game.Myself.data.id, raid_type)
  end
  
  function data.endevt(id)
    ServiceTeamRaidCmdProxy.Instance:CallTeamRaidReplyCmd(false, Game.Myself.data.id, raid_type)
  end
  
  self.conformCtl:AddInvite(InviteType.AltMan, data)
end

function InviteConfirmView:HandleInviteSummonBossFubenCmd(note)
  local msgId = 25921
  local data = {
    playerid = Game.Myself.data.id,
    time = 10,
    msgId = msgId
  }
  
  function data.yesevt(id)
    ServiceFuBenCmdProxy.Instance:CallReplySummonBossFubenCmd(nil, true)
  end
  
  function data.noevt(id)
    ServiceFuBenCmdProxy.Instance:CallReplySummonBossFubenCmd(nil, false)
  end
  
  function data.endevt(id)
    ServiceFuBenCmdProxy.Instance:CallReplySummonBossFubenCmd(nil, false)
  end
  
  self.conformCtl:AddInvite(InviteType.PveCard, data)
end

function InviteConfirmView:HandleRollRewardInviteMsg(note)
  if not note or not note.body then
    LogUtility.Error("Cannot get RollRewardInviteMsg")
    return
  end
  if DungeonProxy.Instance:GetRestRewardInvitationCount() <= 0 then
    return
  end
  local showingCell = self:_GetShowingRollRewardCell()
  if showingCell then
    showingCell:UpdateFolded()
  else
    self.conformCtl:AddInvite(InviteType.RollReward, DungeonProxy.Instance:PeekRollRewardInvitation())
  end
end

function InviteConfirmView:_GetShowingRollRewardCell()
  local queueCells, showingCell = self.conformCtl.queue.excutequeue
  for i = 1, #queueCells do
    if queueCells[i].__cname == "RollRewardCell" then
      showingCell = queueCells[i]
      break
    end
  end
  return showingCell
end

function InviteConfirmView:TryRemoveRollRewardCell()
  local showingCell = self:_GetShowingRollRewardCell()
  if not showingCell then
    return
  end
  showingCell:Exit()
  DungeonProxy.Instance:ClearRollRewardInvitation()
end

function InviteConfirmView:HandlePlayerMapChange()
  self:TryRemoveRollRewardCell()
end

function InviteConfirmView:HandleItemUpdate()
  local showingCell = self:_GetShowingRollRewardCell()
  if showingCell then
    showingCell:UpdateRollCoin()
  end
end

function InviteConfirmView:HandleVarUpdate()
  local showingCell = self:_GetShowingRollRewardCell()
  if showingCell then
    showingCell:UpdateRestRollTimes()
  end
end

function InviteConfirmView:HandleNewbieCollegeRaidNpcFakeTeamInvite(note)
  local data = note.body
  if not data then
    return
  end
  self.pendingProceedQuest = data.questData
  local playerid = data.configid
  local username = self.pendingProceedQuest.params.invite_name
  local data = {
    playerid = playerid,
    time = GameConfig.Team.inviteovertime,
    msgId = 41347,
    msgParama = {username},
    CanNOTrefuse = true
  }
  
  function data.yesevt(id)
    if self.pendingProceedQuest and self.pendingProceedQuest.scope and self.pendingProceedQuest.id and self.pendingProceedQuest.staticData and self.pendingProceedQuest.staticData.FinishJump then
      QuestProxy.Instance:notifyQuestState(self.pendingProceedQuest.scope, self.pendingProceedQuest.id, self.pendingProceedQuest.staticData.FinishJump)
    else
      redlog("quest config contains error")
    end
    self.pendingProceedQuest = nil
  end
  
  function data.noevt(id)
    MsgManager.ShowMsgByID(41146)
  end
  
  function data.endevt(id)
    MsgManager.ShowMsgByID(41146)
  end
  
  self.conformCtl:AddInvite(InviteType.NewbieCollegeFake, data)
end

function InviteConfirmView:HandleClearFakeTeamInvite(note)
  self.conformCtl:ClearInviteMap(InviteType.NewbieCollegeFake)
end

function InviteConfirmView:HandleAssistantInvite(note)
  local data = note.body
  if not data then
    return
  end
  local msgData = Table_Sysmsg[AssistantInviteMsgID]
  if not msgData then
    return
  end
  if not msgData.showInPVP and Game.MapManager:IsPVPMode() then
    redlog("PVP地图中屏蔽 ")
    return
  end
  local can = LocalSaveProxy.Instance:GetCanRefuseTime()
  if not can then
    return
  end
  self.teamData = TeamData.new(data.teaminfo)
  local leaderdata = self.teamData:GetLeader()
  local teamName = leaderdata and leaderdata.name or ""
  local goaltype = self.teamData.type or 0
  local isOpen = PveEntranceProxy.Instance:IsOpenByTeamGoal(goaltype)
  if not isOpen then
    return
  end
  local goalConfig = Table_TeamGoals[goaltype]
  local goal = goalConfig and goalConfig.NameZh or ""
  local str1 = string.format(msgData.Text, teamName)
  local str2 = string.format(ZhString.HelpInvite_Detail, goal)
  local data = {
    playerid = self.teamData,
    time = GameConfig.Team.inviteovertime,
    lab1 = str1,
    lab2 = str2,
    button = ZhString.UniqueConfirmView_Confirm,
    tip = msgData.Title
  }
  
  function data.yesevt(teamData)
    FunctionTeam.DoApply(teamData)
  end
  
  function data.noevt(id)
    LocalSaveProxy.Instance:SetLastRefuseTime()
  end
  
  function data.endevt(id)
    LocalSaveProxy.Instance:SetLastRefuseTime()
  end
  
  self.conformCtl:AddInvite(InviteType.AssistantInvite, data)
end

function InviteConfirmView:HandleLoveChallengeInvite(note)
  local data = note.body
  local invitername = data and data.invitername
  local inviter = data and data.inviter
  if not invitername or not inviter then
    redlog("缺少邀请者信息")
    return
  end
  xdlog("爱情邀请", invitername, inviter)
  MiniGameProxy.Instance:SetInviter(inviter)
  MiniGameProxy.Instance:SetOppoInfo(inviter, invitername)
  local inviteData = {
    name = invitername,
    playerid = inviter,
    button = ZhString.GuildActivityCell_Show
  }
  local str1 = string.format(ZhString.LoveChallenge_BeInvited, invitername)
  
  function inviteData.yesevt(inviterID, inviterName)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.LoveChallengeView,
      viewdata = {
        page = 1,
        inviterID = inviterID,
        inviterName = inviterName
      }
    })
  end
  
  function inviteData.noevt(inviterID, inviterName)
  end
  
  self.conformCtl:AddInvite(InviteType.LoveChallenge, inviteData)
end
