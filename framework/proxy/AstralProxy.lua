autoImport("PveEntranceData")
autoImport("AstralDestinyGraphData")
AstralProxy = class("AstralProxy", pm.Proxy)
AstralProxy.Instance = nil
AstralProxy.NAME = "AstralProxy"
AstralProxy.RoundState = {
  RoundInterval = 0,
  RoundStart = 1,
  RoundEnd = 2,
  InRound = 3
}

function AstralProxy:ctor(proxyName, data)
  self.proxyName = proxyName or AstralProxy.NAME
  if AstralProxy.Instance == nil then
    AstralProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function AstralProxy:Init()
  self.graphInfos = {}
  self.gotten_reward_num = {}
  self.nextEntranceDataMap = {}
  self.bossIds = {}
  self.prayGroupInfos = {}
end

function AstralProxy:RecvSyncAstralInfo(season, reward_nums, pass_num)
  self.season = season
  self.pass_num = pass_num or 0
  if reward_nums then
    TableUtility.ArrayClear(self.gotten_reward_num)
    for i = 1, #reward_nums do
      local rewardId = reward_nums[i]
      self.gotten_reward_num[i] = rewardId
    end
  end
end

function AstralProxy:SyncAstralRoundInfo(data)
  if data then
    self.lastRound = self.curRound or 0
    self.curRound = data.round or 0
    self.roundEndTime = data.kill_limit_time or 0
    self.totalMonster = data.total_monster or 0
    self.leftMonster = data.left_monster or 0
    self.prayedProNum = data.pray_profession_num or 0
    if data.pray_id and 0 < data.pray_id then
      self.teamPrayId = data.pray_id
    end
    if data.pray_profession_group and 0 < data.pray_profession_group then
      self.prayGroup = data.pray_profession_group
    end
    TableUtility.ArrayClear(self.bossIds)
    if data.boss_ids and 0 < #data.boss_ids then
      for i = 1, #data.boss_ids do
        self.bossIds[#self.bossIds + 1] = data.boss_ids[i]
      end
    end
  end
end

function AstralProxy:SyncAstralSeason(season)
  self.season = season
end

function AstralProxy:SyncAstralPrayBranchInfo(groups)
  if groups then
    for i = 1, #groups do
      local groupId = groups[i].group
      local branches = self.prayGroupInfos[groupId]
      if not branches then
        branches = {}
        self.prayGroupInfos[groupId] = branches
      end
      TableUtility.TableClear(branches)
      for j = 1, #groups[i].branches do
        branches[#branches + 1] = groups[i].branches[j]
      end
    end
  end
end

function AstralProxy:GetBossIds()
  return self.bossIds
end

function AstralProxy:GetNextLevelEntranceDataByRaidId(raidId)
  if not self.nextEntranceDataMap[raidId] then
    local diffs = {}
    for k, v in pairs(Table_PveRaidEntrance) do
      if v.RaidType == FuBenCmd_pb.ERAIDTYPE_ASTRAL then
        diffs[#diffs + 1] = v
      end
    end
    table.sort(diffs, function(l, r)
      if l.GroupId == r.GroupId then
        return l.DifficultyName[2] < r.DifficultyName[2]
      end
      return l.GroupId < r.GroupId
    end)
    for i = 1, #diffs - 1 do
      if diffs[i].GroupId == diffs[i + 1].GroupId then
        self.nextEntranceDataMap[diffs[i].Difficulty] = PveEntranceData.new(diffs[i + 1].id)
      end
    end
  end
  return self.nextEntranceDataMap[raidId]
end

function AstralProxy:GetCurRound()
  return self.curRound
end

function AstralProxy:GetRoundState()
  if self.lastRound ~= self.curRound then
    if self.curRound > 0 then
      return AstralProxy.RoundState.RoundStart
    else
      return AstralProxy.RoundState.RoundEnd
    end
  elseif self.curRound > 0 then
    return AstralProxy.RoundState.InRound
  else
    return AstralProxy.RoundState.RoundInterval
  end
end

function AstralProxy:GetRoundEndTime()
  return self.roundEndTime
end

function AstralProxy:GetTotalMonsterNum()
  return self.totalMonster
end

function AstralProxy:GetLeftMonsterNum()
  return self.leftMonster
end

function AstralProxy:GetCurPrayedLevel()
  if GameConfig.Astral and GameConfig.Astral.LevelCondition then
    for i = #GameConfig.Astral.LevelCondition, 1, -1 do
      local prayedNum = GameConfig.Astral.LevelCondition[i]
      if prayedNum <= self.prayedProNum then
        return i
      end
    end
  end
  return 0
end

function AstralProxy:GetTeamPrayId()
  redlog("AstralProxy:GetTeamPrayId", tostring(self.teamPrayId))
  return self.teamPrayId
end

function AstralProxy:GetPrayGroup()
  redlog("AstralProxy:GetPrayGroup", tostring(self.prayGroup))
  return self.prayGroup
end

function AstralProxy:GetSeason()
  return self.season
end

function AstralProxy:IsSeasonEnd()
  local config = Table_AstralSeason[self.season]
  if config then
    local endTimeFormat = config and EnvChannel.IsTFBranch() and config.TfEndTime or config and config.EndTime
    local endTime = ClientTimeUtil.GetOSDateTime(endTimeFormat)
    if not endTime then
      redlog("AstralSeason表中未配置EndTime!!!")
      return false
    end
    local curTime = ServerTime.CurServerTime() / 1000
    return endTime < curTime
  end
  return true
end

function AstralProxy:IsSeasonNotOpen()
  local config = Table_AstralSeason[self.season]
  return config == nil
end

function AstralProxy:GetCurPassNum()
  return self.pass_num
end

function AstralProxy:IsRewardReceived(targetNum)
  return TableUtility.ArrayFindIndex(self.gotten_reward_num, targetNum) > 0
end

function AstralProxy:InitDestinyGraphInfo(curSeason)
  if Game.AstralDestinyGraphSeasonPointMap then
    for season, points in pairs(Game.AstralDestinyGraphSeasonPointMap) do
      if season <= curSeason then
        local graphData = self.graphInfos[season]
        if not graphData then
          graphData = AstralDestinyGraphData.new(season)
          self.graphInfos[season] = graphData
          for i = 1, #points do
            local pointData = graphData:GetPointData(i)
            local state = MessCCmd_pb.EGRAPH_POINT_STATE_LOCKED
            pointData:SetState(state)
          end
        end
      end
    end
  end
end

function AstralProxy:SyncDestinyGraphInfo(curSeason, infos)
  self.season = curSeason
  if not self.graphInfos[curSeason] then
    self:InitDestinyGraphInfo(curSeason)
  end
  if infos then
    for i = 1, #infos do
      local info = infos[i]
      local graphData = self.graphInfos[info.season]
      if graphData and info.pointinfos then
        for j = 1, #info.pointinfos do
          local pointinfo = info.pointinfos[j]
          local index = pointinfo.point
          local pointData = graphData:GetPointData(index)
          local state = pointinfo.state or MessCCmd_pb.EGRAPH_POINT_STATE_LOCKED
          pointData:SetState(state)
        end
      end
    end
  end
end

function AstralProxy:GetGraphRoundNum()
  local seasonCount = self:GetSeasonNum()
  return (seasonCount - 1) // 4 + 1
end

function AstralProxy:GetSeasonNum()
  return #self.graphInfos
end

function AstralProxy:GetGraphInfosByRound(round)
  local infos = {}
  for i = round * 4 - 3, round * 4 do
    infos[#infos + 1] = self.graphInfos[i]
  end
  return infos
end

function AstralProxy:GetEarliestSeasonHasNoLightenPoint()
  for i = 1, #self.graphInfos do
    local graphData = self.graphInfos[i]
    local pointData = graphData:GetFirstNoLightenPoint()
    if pointData then
      return graphData.season
    end
  end
  return 1
end

function AstralProxy:GetFirstNoLightenPointByRound(round)
  local infos = self:GetGraphInfosByRound(round)
  for i = 1, #infos do
    local graphData = infos[i]
    local pointData = graphData:GetFirstNoLightenPoint()
    if pointData then
      return graphData, pointData
    end
  end
end

function AstralProxy:GetLightenPointNumByRound(round)
  local infos = self:GetGraphInfosByRound(round)
  local num, totalNum = 0, 0
  for i = 1, #infos do
    num = num + infos[i]:GetLightenPointNum()
    totalNum = totalNum + infos[i]:GetTotalPointNum()
  end
  return num, totalNum
end

function AstralProxy:GetTotalBuffEffects()
  local buffEffects = {}
  for i = 1, #self.graphInfos do
    local graphData = self.graphInfos[i]
    local points = graphData.points
    for j = 1, #points do
      local pointData = points[j]
      if pointData:IsLighten() then
        local effects = pointData:GetBuffEffects()
        for k, v in pairs(effects) do
          buffEffects[k] = buffEffects[k] or 0
          buffEffects[k] = buffEffects[k] + v
        end
      end
    end
  end
  return buffEffects
end

function AstralProxy:IsProAstralPrayed(pro, astral_pray_group)
  if pro then
    local depth = ProfessionProxy.GetJobDepth(pro)
    if 1 < depth then
      local branch = ProfessionProxy.GetTypeBranchFromProf(pro)
      local groupBranches = self.prayGroupInfos[astral_pray_group]
      if groupBranches then
        return branch and TableUtility.ArrayFindIndex(groupBranches, branch) > 0 or false
      end
    end
  end
  return false
end

function AstralProxy:GetPrayedBranches(astral_pray_group)
  return self.prayGroupInfos[astral_pray_group]
end
