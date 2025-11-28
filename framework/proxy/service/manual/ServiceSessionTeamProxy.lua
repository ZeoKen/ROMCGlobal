autoImport("ServiceSessionTeamAutoProxy")
ServiceSessionTeamProxy = class("ServiceSessionTeamProxy", ServiceSessionTeamAutoProxy)
ServiceSessionTeamProxy.Instance = nil
ServiceSessionTeamProxy.NAME = "ServiceSessionTeamProxy"
local ForbiddenGroupTeam = function()
  return Game.MapManager:IsPveMode_Thanatos() or Game.MapManager:IsPvPMode_TeamTwelve()
end

function ServiceSessionTeamProxy:ctor(proxyName)
  if ServiceSessionTeamProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSessionTeamProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSessionTeamProxy.Instance = self
  end
end

function ServiceSessionTeamProxy:CallExitTeam(teamid, callback)
  if callback then
    TeamProxy.Instance:SetServerExitTeamCallBack(callback)
  end
  ServiceSessionTeamProxy.super.CallExitTeam(self, teamid)
end

function ServiceSessionTeamProxy:CallProcessTeamInvite(type, userguid)
  local isInTeam = TeamProxy.Instance:IsInMyTeam(userguid)
  if not isInTeam then
    ServiceSessionTeamProxy.super.CallProcessTeamInvite(self, type, userguid)
  end
end

function ServiceSessionTeamProxy:CallProcessGroupApplyTeamCmd(etype, teamid)
  if ForbiddenGroupTeam() then
    MsgManager.ShowMsgByID(25960)
    return
  end
  ServiceSessionTeamProxy.super.CallProcessGroupApplyTeamCmd(self, etype, teamid)
end

function ServiceSessionTeamProxy:CallProcessInviteGroupTeamCmd(agree, charid, mycharid, fighting)
  if ForbiddenGroupTeam() then
    MsgManager.ShowMsgByID(25960)
    return
  end
  ServiceSessionTeamProxy.super.CallProcessInviteGroupTeamCmd(self, agree, charid, mycharid, fighting)
end

function ServiceSessionTeamProxy:RecvInviteMember(data)
  printGreen("Recv-->InviteMember")
  self:Notify(ServiceEvent.SessionTeamInviteMember, data)
end

function ServiceSessionTeamProxy:RecvTeamList(data)
  helplog("RecvTeamList -->TeamList count ", #data.list)
  helplog("RecvTeamList -->type: ", data.type)
  TeamProxy.Instance:UpdateAroundTeamList(data.list, data.type)
  self:Notify(ServiceEvent.SessionTeamTeamList, data)
end

function ServiceSessionTeamProxy:RecvTeamDataUpdate(data)
  redlog("RecvTeamDataUpdate")
  TeamProxy.Instance:UpdateMyTeamData(data.datas, data.name, data.dojo)
  self:Notify(ServiceEvent.SessionTeamTeamDataUpdate, data)
  EventManager.Me():DispatchEvent(ServiceEvent.SessionTeamMemberDataUpdate)
end

function ServiceSessionTeamProxy:CallCreateTeam(minlv, maxlv, type, autoaccept, name, state, desc, alljoingroup)
  local matchStatus, etype = PvpProxy.Instance:GetCurMatchStatus()
  if matchStatus and etype == PvpProxy.Type.TeamPws and (matchStatus.isprepare or matchStatus.ismatch) then
    MsgManager.ShowMsgByID(25984)
    return
  end
  ServiceSessionTeamProxy.super.CallCreateTeam(self, minlv, maxlv, type, autoaccept, name, state, desc, alljoingroup)
end

function ServiceSessionTeamProxy:RecvCreateTeam(data)
  self:Notify(ServiceEvent.SessionTeamCreateTeam, data)
end

function ServiceSessionTeamProxy:RecvEnterTeam(data)
  TeamProxy.Instance:CreateMyTeam(data.data)
  GVoiceProxy.Instance:RecvEnterTeam(data)
  self:Notify(ServiceEvent.SessionTeamEnterTeam, data)
end

function ServiceSessionTeamProxy:RecvTeamMemberUpdate(data)
  TeamProxy.Instance:UpdateTeamMember(data.updates, data.deletes)
  self:Notify(ServiceEvent.SessionTeamTeamMemberUpdate, data)
end

function ServiceSessionTeamProxy:RecvExitTeam(data)
  helplog("Recv-->" .. "ExitTeam")
  TeamProxy.Instance:ExitTeam(TeamProxy.ExitType.ServerExit)
  GVoiceProxy.Instance:RecvExitTeam(data)
  GmeVoiceProxy.Instance:ExitRoom()
end

function ServiceSessionTeamProxy:RecvTeamApplyUpdate(data)
  TeamProxy.Instance:UpdateMyTeamApply(data.updates, data.deletes, data.isgroup)
  self:Notify(ServiceEvent.SessionTeamTeamApplyUpdate, data)
end

function ServiceSessionTeamProxy:RecvMemberPosUpdate(data)
  TeamProxy.Instance:UpdateMyTeamMemberPos(data.id, data.pos, data.dead)
  self:Notify(ServiceEvent.SessionTeamMemberPosUpdate, data)
end

function ServiceSessionTeamProxy:RecvMemberDataUpdate(data)
  local _TeamProxy = TeamProxy.Instance
  if not _TeamProxy.myTeam then
    errorLog("I'm Not EnterTeam When Recv(UpdateMyTeamData)")
    return
  end
  _TeamProxy:UpdateMyTeamMemberData(data.id, data.members)
  GVoiceProxy.Instance:RecvMemberDataUpdate(data)
  self:Notify(ServiceEvent.SessionTeamMemberDataUpdate, data)
end

function ServiceSessionTeamProxy:RecvLockTarget(data)
  TeamProxy.Instance:LockTeamTarget(data.targetid)
  self:Notify(ServiceEvent.SessionTeamLockTarget, data)
end

function ServiceSessionTeamProxy:CallQueryUserTeamInfoTeamCmd(charid, teamid)
  ServiceSessionTeamProxy.super.CallQueryUserTeamInfoTeamCmd(self, charid, teamid)
end

function ServiceSessionTeamProxy:RecvQueryUserTeamInfoTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamQueryUserTeamInfoTeamCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.SessionTeamQueryUserTeamInfoTeamCmd, data)
end

function ServiceSessionTeamProxy:CallQuickEnter(type, time, set)
  ServiceSessionTeamProxy.super.CallQuickEnter(self, type, time, set)
end

function ServiceSessionTeamProxy:RecvQuickEnter(data)
  TeamProxy.Instance:SetQuickEnterTime(data.time)
  self:Notify(ServiceEvent.SessionTeamQuickEnter, data)
end

function ServiceSessionTeamProxy:RecvQuestWantedQuestTeamCmd(data)
  ShareAnnounceQuestProxy.Instance:RecvQuestWantedQuestTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamQuestWantedQuestTeamCmd, data)
end

function ServiceSessionTeamProxy:RecvUpdateWantedQuestTeamCmd(data)
  ShareAnnounceQuestProxy.Instance:RecvUpdateWantedQuestTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamUpdateWantedQuestTeamCmd, data)
end

function ServiceSessionTeamProxy:RecvUpdateHelpWantedTeamCmd(data)
  ShareAnnounceQuestProxy.Instance:RecvUpdateHelpWantedTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamUpdateHelpWantedTeamCmd, data)
end

function ServiceSessionTeamProxy:RecvQueryHelpWantedTeamCmd(data)
  ShareAnnounceQuestProxy.Instance:RecvQueryHelpWantedTeamCmd(data)
  self:Notify(ServiceEvent.SessionTeamQueryHelpWantedTeamCmd, data)
end

function ServiceSessionTeamProxy:CallKickMember(userid, catid, isgroup, robotguid)
  local matchStatus, etype = PvpProxy.Instance:GetCurMatchStatus()
  if matchStatus and etype == PvpProxy.Type.TeamPws and (matchStatus.isprepare or matchStatus.ismatch) then
    MsgManager.ShowMsgByID(25984)
    return
  end
  if PvpProxy.Instance:Is12PvpInMatch() then
    MsgManager.ShowMsgByID(25984)
    return
  end
  if isgroup == nil and TeamProxy.Instance:CheckIHaveGroupLeaderAuthority() and TeamProxy.Instance.uniteGroupTeam:GetMemberByGuid(userid) then
    isgroup = true
  end
  ServiceSessionTeamProxy.super.CallKickMember(self, userid, catid, isgroup, robotguid)
end

function ServiceSessionTeamProxy:CallQueryMemberCatTeamCmd(data)
  TeamProxy.Instance:ClearHireTeamMembers()
  ServiceSessionTeamProxy.super.CallQueryMemberCatTeamCmd(self, data)
end

function ServiceSessionTeamProxy:RecvMemberCatUpdateTeam(data)
  TeamProxy.Instance:SetMyHireTeamMembers(data.updates)
  TeamProxy.Instance:RemoveMyHireTeamMembers(data.dels)
  self:Notify(ServiceEvent.SessionTeamMemberCatUpdateTeam, data)
end

function ServiceSessionTeamProxy:RecvQueryMemberTeamCmd(data)
  TeamProxy.Instance:HandleQueryMemberTeam(data)
  self:Notify(ServiceEvent.SessionTeamQueryMemberTeamCmd, data)
end

function ServiceSessionTeamProxy:RecvUserApplyUpdateTeamCmd(data)
  TeamProxy.Instance:HandleUserApplyUpdate(data)
  self:Notify(ServiceEvent.SessionTeamUserApplyUpdateTeamCmd, data)
end

function ServiceSessionTeamProxy:RecvMyGroupApplyUpdateTeamCmd(data)
  TeamProxy.Instance:HandleUserApplyUpdate(data, true)
  self:Notify(ServiceEvent.SessionTeamMyGroupApplyUpdateTeamCmd, data)
end

function ServiceSessionTeamProxy:RecvTeamGroupApplyUpdate(data)
  TeamProxy.Instance:HandleGroupApplyUpdate(data.updates, data.deletes)
  self:Notify(ServiceEvent.SessionTeamTeamGroupApplyUpdate, data)
end

function ServiceSessionTeamProxy:RecvGroupUpdateNtfTeamCmd(data)
  TeamProxy.Instance:HandleGroupDataUpdate(data)
  redlog("RecvGroupUpdateNtfTeamCmd")
  self:Notify(ServiceEvent.SessionTeamGroupUpdateNtfTeamCmd, data)
end

function ServiceSessionTeamProxy:RecvQueryGroupTeamApplyListTeamCmd(data)
  TeamProxy.Instance:UpdateMyTeamApply(data.applys, nil, true)
  self:Notify(ServiceEvent.SessionTeamQueryGroupTeamApplyListTeamCmd, data)
end

function ServiceSessionTeamProxy:CallTeamGroupApplyTeamCmd(applyteamid, applyinfo, cancel)
  if ForbiddenGroupTeam() then
    MsgManager.ShowMsgByID(25960)
    return
  end
  ServiceSessionTeamProxy.super.CallTeamGroupApplyTeamCmd(self, applyteamid, applyinfo, cancel)
end

function ServiceSessionTeamProxy:RecvNewRecruitPublishTeamCmd(data)
  redlog("ServiceSessionTeamProxy:RecvNewRecruitPublishTeamCmd")
  TeamProxy.Instance:UpdateNewRecruitPublishTeam(data)
  self:Notify(ServiceEvent.SessionTeamNewRecruitPublishTeamCmd, data)
end

function ServiceSessionTeamProxy:RecvUpdateRecruitTeamInfoTeamCmd(data)
  redlog("ServiceSessionTeamProxy:RecvUpdateRecruitTeamInfoTeamCmd")
  TeamProxy.Instance:UpdateRecruitTeamInfo(data.delids, data.teams)
  self:Notify(ServiceEvent.SessionTeamUpdateRecruitTeamInfoTeamCmd, data)
end
