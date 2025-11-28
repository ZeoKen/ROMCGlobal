local NewInviteTeammemberType = {Invite = 1, Apply = 2}
FunctionTeamInvite = class("FunctionTeamInvite")

function FunctionTeamInvite.Me()
  if nil == FunctionTeamInvite.me then
    FunctionTeamInvite.me = FunctionTeamInvite.new()
  end
  return FunctionTeamInvite.me
end

function FunctionTeamInvite:ctor()
  self:Init()
end

function FunctionTeamInvite:Init()
  FunctionTeamInvite.Options = {}
  FunctionTeamInvite.Options[NewInviteTeammemberType.Invite] = FunctionTeamInvite.newInvite
  FunctionTeamInvite.Options[NewInviteTeammemberType.Apply] = FunctionTeamInvite.newApply
end

function FunctionTeamInvite.tryExecuteNewInvite(invitee, cb)
  if not invitee then
    return
  end
  local _TeamProxy = TeamProxy.Instance
  if _TeamProxy:IHaveTeam() and _TeamProxy:CheckIHaveLeaderAuthority() and not _TeamProxy:IHaveGroup() and invitee and invitee:IsTeam() then
    local type
    if not _TeamProxy:IsMyTeamFull() and invitee:IsSingle() then
      type = NewInviteTeammemberType.Invite
    elseif TeamProxy.Instance:GetMyTeamMemberCount() == 1 and not invitee:IsTeamFull() then
      type = NewInviteTeammemberType.Apply
    end
    if type then
      local call = FunctionTeamInvite.Options[type]
      if nil ~= call then
        call(invitee, cb)
        return true
      end
    end
  end
  return false
end

function FunctionTeamInvite.newInvite(invitee, cb)
  if not invitee then
    return
  end
  MsgManager.ConfirmMsgByID(494, function()
    FunctionTeamInvite.do_InviteMember(invitee, cb)
  end, function()
    FunctionTeamInvite.do_InviteGroup(invitee, cb)
  end, nil, nil)
end

function FunctionTeamInvite.newApply(invitee, cb)
  if not invitee then
    return
  end
  MsgManager.ConfirmMsgByID(493, function()
    local cb = function()
      FunctionTeamInvite.do_InviteMember(invitee, cb)
    end
    ServiceSessionTeamProxy.Instance:CallExitTeam(TeamProxy.Instance.myTeam.id, cb)
  end, function()
    FunctionTeamInvite.do_InviteGroup(invitee, cb)
  end, nil, nil)
end

function FunctionTeamInvite.do_InviteMember(invitee, cb)
  if not invitee then
    return
  end
  if Game.MapManager:IsPVPMode_TeamPws() then
    MsgManager.ShowMsgByIDTable(25930)
    return
  end
  if Game.MapManager:IsPVPMode_TransferFight() or Game.MapManager:IsPVPMode_PoringFight() then
    MsgManager.ShowMsgByIDTable(3606)
    return
  end
  local isInGroup = TeamProxy.Instance:IsInMyGroup(invitee.id)
  if isInGroup then
    MsgManager.ShowMsgByIDTable(333)
    return
  end
  if invitee.isGroupInvite == nil and TeamProxy.Instance:CheckIHaveGroupLeaderAuthority() and TeamProxy.Instance:IsMyTeamFull() then
    invitee.isGroupInvite = true
  end
  local user_guid = invitee:IsCat() and Game.Myself.data.id or invitee.id
  ServiceSessionTeamProxy.Instance:CallInviteMember(user_guid, invitee.cat, nil, nil, invitee.isGroupInvite)
  if cb then
    cb()
  end
end

function FunctionTeamInvite.do_InviteGroup(invitee, cb)
  if not invitee then
    return
  end
  if PvpProxy.Instance:Is12PvpInMatch() then
    MsgManager.ShowMsgByID(25984)
    return
  end
  if Game.MapManager:IsPVPMode_TeamPws() then
    MsgManager.ShowMsgByIDTable(25930)
    return
  end
  if Game.MapManager:IsPveMode_Thanatos() or Game.MapManager:IsPvPMode_TeamTwelve() then
    MsgManager.ShowMsgByID(25960)
    return
  end
  local isInGroup = TeamProxy.Instance:IsInMyGroup(invitee.id)
  if isInGroup then
    MsgManager.ShowMsgByIDTable(333)
    return
  end
  local call = function()
    ServiceSessionTeamProxy.Instance:CallInviteGroupTeamCmd(invitee.id)
  end
  if invitee:IsMultiMember() then
    MsgManager.ConfirmMsgByID(496, function()
      call()
    end)
  else
    call()
  end
  if cb then
    cb()
  end
end

function FunctionTeamInvite:HandleQueryUserTeamInfo(data)
  if not data then
    return
  end
  FunctionPlayerTip.Me():HandleQueryUserTeamInfo(data)
end

function FunctionTeamInvite:InviteMember(invitee, invite_callback)
  local matchStatus, etype = PvpProxy.Instance:GetCurMatchStatus()
  if matchStatus and etype == PvpProxy.Type.TeamPws and (matchStatus.isprepare or matchStatus.ismatch) then
    MsgManager.ShowMsgByID(25984)
    return
  end
  if PvpProxy.Instance:Is12PvpInMatch() then
    MsgManager.ShowMsgByID(25984)
    return
  end
  if not invitee then
    return
  end
  if FunctionTeamInvite.tryExecuteNewInvite(invitee, invite_callback) then
    return
  end
  if invitee:IsMultiMember() and TeamProxy.Instance:IHaveTeam() and not TeamProxy.Instance:IHaveGroup() and TeamProxy.Instance:GetMyTeamMemberCount() > 1 then
    FunctionTeamInvite.do_InviteGroup(invitee, invite_callback)
  else
    FunctionTeamInvite.do_InviteMember(invitee, invite_callback)
  end
end

function FunctionTeamInvite:InviteGroup(invitee, invite_callback)
  if FunctionTeamInvite.tryExecuteNewInvite(invitee, invite_callback) then
    return
  end
  FunctionTeamInvite.do_InviteGroup(invitee, invite_callback)
end
