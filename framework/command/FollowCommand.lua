FollowCommand = class("FollowCommand", pm.SimpleCommand)

function FollowCommand:execute(note)
  if note.name == FollowEvent.Follow then
    if type(note.body) == "table" then
      self:TryFollow(note.body.playerid, note.body.noConfirm)
    else
      self:TryFollow(note.body)
    end
  elseif note.name == ServiceEvent.NUserFollowerUser then
    local followid = note.body.userid
    local followType = note.body.eType
    Game.Myself:Client_SetFollowLeader(followid, followType, true)
  elseif note.name == FollowEvent.CancelFollow then
    Game.Myself:Client_SetFollowLeader(0)
  elseif note.name == ServiceEvent.NUserGoMapFollowUserCmd then
    if WorldMapProxy.Instance:CheckMapBannedFollow(note.body.mapid) then
      redlog("跟随去了当前未解锁的地图id", note.body.mapid)
      Game.Myself:Client_SetFollowLeader(0)
      MsgManager.ShowMsgByID(399)
      return
    end
    Game.Myself:Client_SetFollowLeaderMoveToMap(note.body.mapid)
  elseif note.name == TeamEvent.MemberOffline then
    if Game.Myself:Client_GetFollowLeaderID() == note.body.id and not note.body:IsAfk() then
      Game.Myself:Client_SetFollowLeader(0)
    end
  elseif note.name == TeamEvent.MemberAfkChange and Game.Myself:Client_GetFollowLeaderID() == note.body.id and note.body:IsOffline() and not note.body:IsAfk() then
    Game.Myself:Client_SetFollowLeader(0)
  end
end

local RaidType_SameRaidInDiffZone = {
  [5] = 1,
  [28] = 1,
  [26] = 1
}

function FollowCommand:TryFollow(targetId, noConfirm)
  if not targetId then
    return
  end
  if Game.Myself:IsDead() then
    MsgManager.ShowMsgByIDTable(2500)
    return
  end
  local myTeam = TeamProxy.Instance.myTeam
  if myTeam == nil then
    MsgManager.ShowMsgByIDTable(332)
    return
  end
  local teamMemberData = myTeam:GetMemberByGuid(targetId)
  if teamMemberData == nil then
    return
  end
  local mymapid = Game.MapManager:GetMapID()
  if teamMemberData.mapid == 51 or mymapid == 51 then
    MsgManager.ShowMsgByIDTable(121)
    return
  end
  local meInRaid, sameRaid, sameZone, memberInRaid, sameServer
  local curRaidId = Game.MapManager:GetRaidID()
  if curRaidId == 10001 then
    curRaidId = nil
  end
  if curRaidId == nil or curRaidId == 0 then
    curRaidId = ServicePlayerProxy.Instance:GetCurMapImageId()
  end
  meInRaid = curRaidId ~= nil and 0 < curRaidId
  local memberRaidId = teamMemberData.raid
  if memberRaidId == 10001 then
    memberRaidId = nil
  end
  local myTeamData = myTeam:GetMemberByGuid(Game.Myself.data.id)
  sameRaid = memberRaidId == curRaidId
  local curServer = FunctionLogin.Me():getCurServerData()
  local curServerID = curServer.linegroup or 1
  local teamMemberServerId = teamMemberData.serverid
  sameServer = teamMemberServerId == curServerID
  local myZoneId = ChangeZoneProxy.Instance:GetSimpleZoneId(Game.Myself.data.userdata:Get(UDEnum.ZONEID))
  local myRealZoneId = ChangeZoneProxy.Instance:GetSimpleZoneId(Game.Myself.data.userdata:Get(UDEnum.REAL_ZONEID))
  local teamMemberZoneId = ChangeZoneProxy.Instance:GetSimpleZoneId(teamMemberData.zoneid)
  local teamMemberRealZoneId = ChangeZoneProxy.Instance:GetSimpleZoneId(teamMemberData.realzoneid)
  sameZone = sameServer and myRealZoneId == teamMemberRealZoneId or myZoneId == teamMemberZoneId
  memberInRaid = memberRaidId ~= nil and 0 < memberRaidId
  FollowFun.follower.serverid = myTeamData.serverid
  FollowFun.befollower.serverid = teamMemberData.serverid
  FollowFun.follower.zoneid = myTeamData.zoneid
  FollowFun.befollower.zoneid = teamMemberData.zoneid
  FollowFun.follower.realzoneid = myTeamData.realzoneid
  FollowFun.befollower.realzoneid = teamMemberData.realzoneid
  FollowFun.follower.sceneid = myTeamData.sceneid
  FollowFun.befollower.sceneid = teamMemberData.sceneid
  FollowFun.follower.mapid = myTeamData.mapid
  FollowFun.befollower.mapid = teamMemberData.mapid
  FollowFun.follower.raidid = myTeamData.raid
  FollowFun.befollower.raidid = teamMemberData.raid
  FollowFun.follower.guildid = myTeamData.guildid
  FollowFun.befollower.guildid = teamMemberData.guildid
  FollowFun.follower.honeymooncomplete = false
  FollowFun.befollower.honeymooncomplete = false
  FollowFun.follower.baselv = myTeamData.baselv
  FollowFun.befollower.baselv = teamMemberData.baselv
  FollowFun.follower.tf = EnvChannel.IsTFBranch()
  FollowFun.follower.time = ServerTime.CurServerTime() / 1000
  local result = FollowFun.checkFollow()
  if FollowFun.Result.msgid ~= 0 then
    if FollowFun.Result.msgid ~= 99999 then
      MsgManager.ShowMsgByID(FollowFun.Result.msgid)
    end
    return
  end
  local callFollow = function()
    ServiceNUserProxy.Instance:CallFollowerUser(teamMemberData.id, nil, function(id, eType)
      if id ~= 0 and id ~= nil then
        ServiceNUserProxy.Instance:CallGoMapFollowUserCmd(teamMemberData.mapid, teamMemberData.id)
      end
    end)
  end
  if result and result.action then
    xdlog("CheckFollow - Action", result.action)
    if result.action == FollowFun.Action.EFOLLOWACTION_JUMPZONE then
      xdlog("同服 - 切线疲劳警告")
      MsgManager.DontAgainConfirmMsgByID(27016, callFollow)
    else
      callFollow()
    end
  end
end
