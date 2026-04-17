local _ArrayPushBack = TableUtility.ArrayPushBack
local _TableClear = TableUtility.TableClear
local _ArrayClear = TableUtility.ArrayClear
autoImport("GeffenMagicWaveScoreData")
autoImport("WildMvpAffixData")
GeffenMagicWaveScoreProxy = class("GeffenMagicWaveScoreProxy", pm.Proxy)
GeffenMagicWaveScoreProxy.Instance = nil
GeffenMagicWaveScoreProxy.NAME = "GeffenMagicWaveScoreProxy"

function GeffenMagicWaveScoreProxy:ctor(proxyName, data)
  self.proxyName = proxyName or GeffenMagicWaveScoreProxy.NAME
  self.data = data
  if GeffenMagicWaveScoreProxy.Instance == nil then
    GeffenMagicWaveScoreProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function GeffenMagicWaveScoreProxy:Init()
  self.waveScoreMap = {}
  self:ResetWaveScoreMap()
  self.queryInterval = 5
  self.waveScoreDataOutOfDate = 0
  self.waveTotalScore = 0
  self.showCurSeasonReward = true
  self.weeklyAffixIds = {}
  self.seasonEndTime = 0
  self.enemyInfos = {}
  self.enemyWaves = {}
end

function GeffenMagicWaveScoreProxy:ResetWaveScoreMap()
  for i = 1, 4 do
    self.waveScoreMap[i] = i
  end
end

function GeffenMagicWaveScoreProxy:HandleRankQuery(data)
  if not data then
    return
  end
  self.serverId = data.serverid or 0
  self.accId = data.accid or 0
  self.charId = data.charid or 0
  self.totalScore = data.total_score or 0
  self.rankPercent = data.rank_percent or 0
  self.hasRank = data.has_rank or false
  self.lastSeasonHasRank = data.last_season_has_rank or false
  self.lastSeasonRankPercent = data.last_season_rank_percent or 0
  self.lastSeasonGottenReward = data.last_season_gotten_reward
end

function GeffenMagicWaveScoreProxy:HandleGetReward()
  self.lastSeasonGottenReward = true
end

function GeffenMagicWaveScoreProxy:LastSeasonHasReward()
  return self.lastSeasonGottenReward == false and self.lastSeasonHasRank == true
end

function GeffenMagicWaveScoreProxy:GetTotalScore()
  return self.totalScore or 0
end

function GeffenMagicWaveScoreProxy:GetRankPercent()
  return self.rankPercent or 0
end

function GeffenMagicWaveScoreProxy:HandleWaveScoreInfo(data)
  if not data then
    return
  end
  self.total_score = data.score or 0
  self.has_rank = data.has_rank
  self.waveTotalScore = 0
  self:ResetWaveScoreMap()
  self:UpdateWaveScores(data.wave_scores)
end

function GeffenMagicWaveScoreProxy:UpdateWaveScores(wave_scores)
  if not wave_scores then
    return
  end
  for i = 1, #wave_scores do
    self:UpdateWaveScore(wave_scores[i])
  end
end

function GeffenMagicWaveScoreProxy:UpdateWaveScore(wave_score)
  local waveIndex = wave_score.wave
  local waveData = self.waveScoreMap[waveIndex]
  if not waveData or type(waveData) ~= "table" then
    waveData = GeffenMagicWaveScoreData.new(wave_score)
    self.waveScoreMap[waveIndex] = waveData
    self.waveTotalScore = self.waveTotalScore + waveData.score
  else
    waveData:SetData(wave_score)
  end
end

function GeffenMagicWaveScoreProxy:QueryWaveScoreInfo(forceRefresh)
  if forceRefresh or UnityRealtimeSinceStartup - self.waveScoreDataOutOfDate > self.queryInterval then
    ServiceSceneUser3Proxy.Instance:CallGeffenMagicWaveScoreQueryCmd()
    self.waveScoreDataOutOfDate = UnityRealtimeSinceStartup
    return true
  end
  return false
end

function GeffenMagicWaveScoreProxy:GetWaveScore()
  return self.waveScoreMap
end

function GeffenMagicWaveScoreProxy:GetWaveTotalScore()
  return self.waveTotalScore or 0
end

function GeffenMagicWaveScoreProxy:GetRankReward()
  if not self.rankRewards then
    self.rankRewards = {}
    local config = GameConfig.GeffenMagic and GameConfig.GeffenMagic.RankReward
    if config then
      local sortedRanks = {}
      for percentRound, _ in pairs(config) do
        sortedRanks[#sortedRanks + 1] = percentRound
      end
      table.sort(sortedRanks)
      for i = 1, #sortedRanks do
        local rank = sortedRanks[i]
        local reward = config[rank]
        self.rankRewards[#self.rankRewards + 1] = {
          rank = rank,
          rewards = reward,
          index = i
        }
      end
    end
  end
  return self.rankRewards
end

function GeffenMagicWaveScoreProxy:GetPreRankPercent(target_index)
  local ranks = self:GetRankReward()
  if ranks then
    if target_index <= 1 then
      return 0
    else
      return ranks[target_index - 1].rank
    end
  end
  return 0
end

function GeffenMagicWaveScoreProxy:SwitchSeasonReward()
  self.showCurSeasonReward = not self.showCurSeasonReward
end

function GeffenMagicWaveScoreProxy:IsShowCurSeasonReward()
  return self.showCurSeasonReward == true
end

function GeffenMagicWaveScoreProxy:QueryEnemyInfo()
  if self.seasonEndTime and self.seasonEndTime > ServerTime.CurServerTime() / 1000 then
    return
  end
  ServiceFuBenCmdProxy.Instance:CallGeffenMagicEnemyInfoQueryCmd()
end

function GeffenMagicWaveScoreProxy:QueryRank()
  ServiceSceneUser3Proxy.Instance:CallGeffenMagicRankQueryCmd()
end

function GeffenMagicWaveScoreProxy:HandleWeeklyAffix(data)
  local weeklyAffix = data and data.affixes
  if not weeklyAffix then
    return
  end
  local _Table_MonsterAffix = Table_MonsterAffix
  for i = 1, #weeklyAffix do
    local config = _Table_MonsterAffix[weeklyAffix[i]]
    if config then
      self.weeklyAffixIds[#self.weeklyAffixIds + 1] = WildMvpAffixData.new(config)
    end
  end
end

function GeffenMagicWaveScoreProxy:HandleEnemyInfos(data)
  self:HandleWeeklyAffix(data)
  self.seasonEndTime = data.season_end_time
  _TableClear(self.enemyInfos)
  _ArrayClear(self.enemyWaves)
  local enemyInfos = data.enemy_infos
  if not enemyInfos then
    return
  end
  for i = 1, #enemyInfos do
    self:HandleEnemyInfo(enemyInfos[i])
  end
  table.sort(self.enemyWaves)
end

function GeffenMagicWaveScoreProxy:GetMaxWave()
  return #self.enemyWaves
end

function GeffenMagicWaveScoreProxy:HandleEnemyInfo(server_enemy_infos)
  local wave = server_enemy_infos.wave
  local enemy_infos = server_enemy_infos.enemy_infos
  if not enemy_infos then
    return
  end
  local waveEnemies = {}
  for i = 1, #enemy_infos do
    local headImageData = HeadImageData.new()
    headImageData:TransByGeffenMagicEnemyInfo(enemy_infos[i])
    _ArrayPushBack(waveEnemies, headImageData)
  end
  self.enemyInfos[wave] = waveEnemies
  _ArrayPushBack(self.enemyWaves, wave)
end

function GeffenMagicWaveScoreProxy:GetEnemyInfos()
  return self.enemyInfos
end

function GeffenMagicWaveScoreProxy:TryQueryWaveEnemy()
  if not next(self.enemyInfos) then
    self:QueryEnemyInfo()
  end
end

function GeffenMagicWaveScoreProxy:GetEnemyInfo(wave)
  return self.enemyInfos[wave]
end

function GeffenMagicWaveScoreProxy:GetWeeklyAffixIds()
  return self.weeklyAffixIds
end

function GeffenMagicWaveScoreProxy:Reset()
  self.showCurSeasonReward = true
  self.waveScoreDataOutOfDate = 0
end
