FollowFun = {}
FollowFun.MsgIDNoShow = 99999
FollowFun.Param = {
  serverid = 0,
  zoneid = 0,
  realzoneid = 0,
  sceneid = 0,
  mapid = 0,
  raidid = 0,
  guildid = 0,
  honeymooncomplete = false,
  baselv = 0,
  tf = false,
  time = 0
}
FollowFun.Param.meta = {
  __index = FollowFun.Param
}

function FollowFun.Param:new()
  local obj = {}
  setmetatable(obj, self.meta)
  obj.serverid = 0
  obj.zoneid = 0
  obj.realzoneid = 0
  obj.sceneid = 0
  obj.mapid = 0
  obj.guildid = 0
  obj.honeymooncomplete = false
  obj.baselv = 0
  obj.tf = false
  obj.time = 0
  return obj
end

FollowFun.Action = {}
FollowFun.Action.EFOLLOWACTION_NONE = 0
FollowFun.Action.EFOLLOWACTION_WALK = 1
FollowFun.Action.EFOLLOWACTION_JUMPZONE = 2
FollowFun.Action.EFOLLOWACTION_JUMPCOMMONLINE = 3
FollowFun.Action.EFOLLOWACTION_GOCOMMONLINEMAP = 4
FollowFun.Action.EFOLLOWACTION_MAP_TO_GUILD = 5
FollowFun.Action.EFOLLOWACTION_MAP_TO_RAID = 6
FollowFun.Action.EFOLLOWACTION_RAID_TO_MAP_POS = 7
FollowFun.Action.EFOLLOWACTION_RAID_TO_RAID = 8
FollowFun.Action.EFOLLOWACTION_TO_CLONEMAP = 9
FollowFun.Action.EFOLLOWACTION_MAP_TO_MAP_POS = 10
FollowFun.Result = {msgid = 0, action = 0}

function FollowFun.parseTime(date)
  local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
  local year_t, mon_t, day_t, hour_t, min_t, sec_t = string.match(date, p)
  return os.time({
    day = day_t,
    month = mon_t,
    year = year_t,
    hour = hour_t,
    min = min_t,
    sec = sec_t
  })
end

function FollowFun.updateResult(msgid, action)
  FollowFun.Result.msgid = tonumber(msgid)
  FollowFun.Result.action = tonumber(action)
  return FollowFun.Result
end

function FollowFun.debugLog(log)
end

FollowFun.follower = FollowFun.Param:new()
FollowFun.befollower = FollowFun.Param:new()

function FollowFun.checkMapCanFollow(mapcfg)
  if mapcfg == nil then
    return FollowFun.updateResult(FollowFun.MsgIDNoShow, FollowFun.Action.EFOLLOWACTION_NONE)
  end
  if mapcfg.id == 51 then
    return FollowFun.updateResult(121, FollowFun.Action.EFOLLOWACTION_NONE)
  end
  if mapcfg.id == GameConfig.ThanksGiving.raidid or mapcfg.id == GameConfig.ThanksGiving.spring_raidid then
    return FollowFun.updateResult(40102, FollowFun.Action.EFOLLOWACTION_NONE)
  end
  if GameConfig.Roguelike.RaidLayers[mapcfg.id] ~= nil then
    return FollowFun.updateResult(27018, FollowFun.Action.EFOLLOWACTION_NONE)
  end
  if mapcfg.id == 7050 then
    return FollowFun.updateResult(27018, FollowFun.Action.EFOLLOWACTION_NONE)
  end
  return FollowFun.updateResult(0, FollowFun.Action.EFOLLOWACTION_NONE)
end

function FollowFun.checkRaidCanFollow(beraidcfg)
  local result = FollowFun.Result
  if beraidcfg == nil then
    return FollowFun.updateResult(FollowFun.MsgIDNoShow, FollowFun.Action.EFOLLOWACTION_NONE)
  end
  local follower = FollowFun.follower
  local befollower = FollowFun.befollower
  if beraidcfg.Restrict == 1 or beraidcfg.Restrict == 3 or beraidcfg.Restrict == 7 then
    if beraidcfg.Type ~= 32 and beraidcfg.Type ~= 44 and beraidcfg.Type ~= 83 then
      return FollowFun.updateResult(329, FollowFun.Action.EFOLLOWACTION_NONE)
    end
  elseif beraidcfg.Restrict == 4 then
    if follower.guildid == 0 then
      return FollowFun.updateResult(FollowFun.MsgIDNoShow, FollowFun.Action.EFOLLOWACTION_NONE)
    end
  elseif beraidcfg.Restrict == 5 then
    if follower.guildid == 0 or befollower.guildid == 0 then
      return FollowFun.updateResult(2906, FollowFun.Action.EFOLLOWACTION_NONE)
    end
    if follower.guildid ~= befollower.guildid then
      return FollowFun.updateResult(2638, FollowFun.Action.EFOLLOWACTION_NONE)
    end
  elseif beraidcfg.Restrict == 8 then
    return FollowFun.updateResult(329, FollowFun.Action.EFOLLOWACTION_NONE)
  elseif beraidcfg.Restrict == 9 then
    return FollowFun.updateResult(329, FollowFun.Action.EFOLLOWACTION_NONE)
  elseif beraidcfg.Restrict == 10 then
    return FollowFun.updateResult(FollowFun.MsgIDNoShow, FollowFun.Action.EFOLLOWACTION_NONE)
  elseif beraidcfg.Restrict == 11 and follower.honeymooncomplete == false then
    return FollowFun.updateResult(9654, FollowFun.Action.EFOLLOWACTION_NONE)
  end
  if beraidcfg.Type == 14 or beraidcfg.Type == 30 or beraidcfg.Type == 43 or beraidcfg.Type == 50 or beraidcfg.Type == 52 or beraidcfg.Type == 76 then
    return FollowFun.updateResult(27018, FollowFun.Action.EFOLLOWACTION_NONE)
  elseif beraidcfg.Type == 37 or beraidcfg.Type == 41 then
    return FollowFun.updateResult(38024, FollowFun.Action.EFOLLOWACTION_NONE)
  elseif beraidcfg.Type == 34 then
    local expcfg = Table_ExpRaid[beraidcfg.id]
    if expcfg ~= nil and follower.baselv < expcfg.Level then
      return FollowFun.updateResult(FollowFun.MsgIDNoShow, FollowFun.Action.EFOLLOWACTION_NONE)
    end
  elseif beraidcfg.Type == 61 then
    return FollowFun.updateResult(42071, FollowFun.Action.EFOLLOWACTION_NONE)
  elseif beraidcfg.Type == 13 then
    if befollower.guildid ~= follower.guildid then
      return FollowFun.updateResult(28046, FollowFun.Action.EFOLLOWACTION_NONE)
    end
  elseif beraidcfg.Type == 75 then
    return FollowFun.updateResult(329, FollowFun.Action.EFOLLOWACTION_NONE)
  end
  if beraidcfg.LimitLv ~= nil and beraidcfg.LimitLv ~= 0 and follower.baselv < beraidcfg.LimitLv then
    return FollowFun.updateResult(204, FollowFun.Action.EFOLLOWACTION_NONE)
  end
  return FollowFun.updateResult(0, FollowFun.Action.EFOLLOWACTION_NONE)
end

function FollowFun.getTeamGroupCFG(raidid)
  for k, v in pairs(Table_TeamGroupRaid) do
    if v.InnerRaidID == raidid or v.id == raidid then
      return v
    end
  end
  return nil
end

function FollowFun.checkTeamGroupInnerRaid(raidid)
  for k, v in pairs(Table_TeamGroupRaid) do
    if v.InnerRaidID == raidid then
      return true
    end
  end
  return false
end

function FollowFun.checkFollow()
  local follower = FollowFun.follower
  local befollower = FollowFun.befollower
  FollowFun.updateResult(0, FollowFun.Action.EFOLLOWACTION_NONE)
  FollowFun.debugLog("FollowFun.checkFollow - same raidid - walk")
  if follower.raidid ~= 0 and befollower.raidid ~= 0 and follower.raidid == befollower.raidid and follower.zoneid == befollower.zoneid and follower.sceneid == befollower.sceneid then
    return FollowFun.updateResult(0, FollowFun.Action.EFOLLOWACTION_WALK)
  end
  FollowFun.debugLog("FollowFun.checkFollow - check map cfg valid follower = " .. follower.mapid .. "befollower = " .. befollower.mapid)
  local mapcfg = Table_Map[follower.mapid]
  local bemapcfg = Table_Map[befollower.mapid]
  if mapcfg == nil or bemapcfg == nil then
    return FollowFun.updateResult(99, FollowFun.Action.EFOLLOWACTION_NONE)
  end
  local activityMap = bemapcfg.EnterCond.type == "activity"
  if bemapcfg.CloneMap ~= nil and bemapcfg.CloneMap ~= 0 or activityMap then
    if follower.serverid ~= befollower.serverid then
      return FollowFun.updateResult(42044, FollowFun.Action.EFOLLOWACTION_NONE)
    end
    if follower.realzoneid ~= befollower.realzoneid then
      return FollowFun.updateResult(0, FollowFun.Action.EFOLLOWACTION_JUMPZONE)
    end
    if follower.sceneid ~= befollower.sceneid then
      return FollowFun.updateResult(0, FollowFun.Action.EFOLLOWACTION_TO_CLONEMAP)
    end
  end
  FollowFun.debugLog("FollowFun.checkFollow - check TeamFollowCheckMaps map")
  if bemapcfg.id == 106 or bemapcfg.id == 107 or bemapcfg.id == 108 then
    return FollowFun.updateResult(FollowFun.MsgIDNoShow, FollowFun.Action.EFOLLOWACTION_NONE)
  end
  local raidcfg = Table_MapRaid[follower.raidid]
  local beraidcfg = Table_MapRaid[befollower.raidid]
  if follower.serverid ~= befollower.serverid then
    if bemapcfg.IsCommonline == 1 then
      if mapcfg.IsCommonline == 1 then
        if follower.zoneid ~= befollower.zoneid then
          return FollowFun.updateResult(0, FollowFun.Action.EFOLLOWACTION_JUMPCOMMONLINE)
        else
          return FollowFun.updateResult(0, FollowFun.Action.EFOLLOWACTION_WALK)
        end
      elseif raidcfg == nil then
        return FollowFun.updateResult(0, FollowFun.Action.EFOLLOWACTION_WALK)
      elseif raidcfg ~= nil then
        return FollowFun.updateResult(0, FollowFun.Action.EFOLLOWACTION_RAID_TO_MAP_POS)
      end
    end
    if beraidcfg == nil then
      return FollowFun.updateResult(42044, FollowFun.Action.EFOLLOWACTION_NONE)
    end
    local mergetime = 0
    if follower.tf == true then
      if beraidcfg.TFServerMergeTime ~= "" then
        mergetime = FollowFun.parseTime(beraidcfg.TFServerMergeTime)
      end
    elseif beraidcfg.ServerMergeTime ~= "" then
      mergetime = FollowFun.parseTime(beraidcfg.ServerMergeTime)
    end
    FollowFun.debugLog("FollowFun.checkFollow - check unsame serverid mergetime = " .. mergetime)
    if mergetime == 0 or mergetime > follower.time then
      return FollowFun.updateResult(42044, FollowFun.Action.EFOLLOWACTION_NONE)
    end
  end
  if raidcfg == nil and beraidcfg == nil then
    if follower.realzoneid ~= befollower.realzoneid then
      return FollowFun.updateResult(0, FollowFun.Action.EFOLLOWACTION_JUMPZONE)
    end
    if mapcfg.IsCommonline == 1 and bemapcfg.IsCommonline == 1 and mapcfg.id == bemapcfg.id and follower.zoneid ~= befollower.zoneid then
      if follower.zoneid ~= befollower.zoneid then
        return FollowFun.updateResult(0, FollowFun.Action.EFOLLOWACTION_JUMPCOMMONLINE)
      end
      return FollowFun.updateResult(0, EFOLLOWACTION_GOCOMMONLINEMAP)
    end
    return FollowFun.updateResult(0, FollowFun.Action.EFOLLOWACTION_WALK)
  end
  FollowFun.debugLog("FollowFun.checkFollow - check befollower map can follow")
  local result = FollowFun.checkMapCanFollow(bemapcfg)
  if result.msgid ~= 0 then
    FollowFun.debugLog("FollowFun.checkFollow - check befollower map can follow msgid = " .. result.msgid)
    return FollowFun.updateResult(result.msgid, result.action)
  end
  if beraidcfg ~= nil then
    local result = FollowFun.checkRaidCanFollow(beraidcfg)
    if result.msgid ~= 0 then
      return FollowFun.updateResult(result.msgid, result.action)
    end
  end
  if raidcfg == nil and beraidcfg ~= nil then
    if beraidcfg.Restrict == 4 then
      return FollowFun.updateResult(0, FollowFun.Action.EFOLLOWACTION_MAP_TO_GUILD)
    end
    if beraidcfg.Type == 83 then
      return FollowFun.updateResult(0, FollowFun.Action.EFOLLOWACTION_MAP_TO_MAP_POS)
    end
    return FollowFun.updateResult(0, FollowFun.Action.EFOLLOWACTION_MAP_TO_RAID)
  end
  if raidcfg ~= nil and beraidcfg == nil then
    if bemapcfg.IsCommonline == 1 then
      if follower.zoneid ~= befollower.zoneid then
        return FollowFun.updateResult(0, FollowFun.Action.EFOLLOWACTION_JUMPCOMMONLINE)
      else
        return FollowFun.updateResult(0, FollowFun.Action.EFOLLOWACTION_RAID_TO_MAP_POS)
      end
    end
    if follower.realzoneid ~= befollower.realzoneid then
      return FollowFun.updateResult(27011, FollowFun.Action.EFOLLOWACTION_NONE)
    else
      return FollowFun.updateResult(0, FollowFun.Action.EFOLLOWACTION_RAID_TO_MAP_POS)
    end
  end
  if raidcfg ~= nil then
    if follower.realzoneid ~= befollower.realzoneid then
      return FollowFun.updateResult(27011, FollowFun.Action.EFOLLOWACTION_NONE)
    end
    if raidcfg.Type == 32 or raidcfg.Type == 44 or raidcfg.Type == 58 then
      return FollowFun.updateResult(39207, FollowFun.Action.EFOLLOWACTION_NONE)
    end
    if raidcfg.Restrict == 9 then
      return FollowFun.updateResult(39207, FollowFun.Action.EFOLLOWACTION_NONE)
    end
    if raidcfg.Type == 28 then
      return FollowFun.updateResult(39207, FollowFun.Action.EFOLLOWACTION_NONE)
    end
    if beraidcfg ~= nil then
      if beraidcfg.Type == 5 or beraidcfg.Type == 7 then
        return FollowFun.updateResult(38197, FollowFun.Action.EFOLLOWACTION_NONE)
      end
      if beraidcfg.Type == 43 or beraidcfg.Type == 50 then
        return FollowFun.updateResult(38197, FollowFun.Action.EFOLLOWACTION_NONE)
      end
      if beraidcfg.Type == 76 or beraidcfg.Type == 83 then
        return FollowFun.updateResult(38197, FollowFun.Action.EFOLLOWACTION_NONE)
      end
      local teamgroup = FollowFun.getTeamGroupCFG(raidcfg.id)
      local beteamgroup = FollowFun.getTeamGroupCFG(beraidcfg.id)
      if teamgroup ~= nil and beteamgroup ~= nil and (FollowFun.checkTeamGroupInnerRaid(raidcfg.id) == true or FollowFun.checkTeamGroupInnerRaid(beraidcfg.id) == true) then
        return FollowFun.updateResult(FollowFun.MsgIDNoShow, FollowFun.Action.EFOLLOWACTION_NONE)
      end
      return FollowFun.updateResult(0, FollowFun.Action.EFOLLOWACTION_RAID_TO_RAID)
    end
  end
  FollowFun.debugLog("FollowFun.checkFollow end")
  return FollowFun.updateResult(FollowFun.MsgIDNoShow, FollowFun.Action.EFOLLOWACTION_NONE)
end
