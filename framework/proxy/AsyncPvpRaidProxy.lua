AsyncPvpRaidProxy = class("AsyncPvpRaidProxy", pm.Proxy)
AsyncPvpRaidProxy.Instance = nil
AsyncPvpRaidProxy.NAME = "AsyncPvpRaidProxy"

function AsyncPvpRaidProxy:ctor(proxyName, data)
  self.proxyName = proxyName or AsyncPvpRaidProxy.NAME
  if AsyncPvpRaidProxy.Instance == nil then
    AsyncPvpRaidProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function AsyncPvpRaidProxy:Init()
  self.allAffixes = {}
  self.selectedAffixes = {}
  self.localSelectedAffixes = {}
  self.statDatas = {}
end

function AsyncPvpRaidProxy:SyncGeffenMagicAffixInfo(data)
  if data.affixes then
    TableUtility.ArrayClear(self.allAffixes)
    for i = 1, #data.affixes do
      local affix = data.affixes[i]
      TableUtility.ArrayPushBack(self.allAffixes, affix)
    end
    table.sort(self.allAffixes, function(a, b)
      local typeA = Table_MonsterAffix[a] and Table_MonsterAffix[a].Type
      local typeB = Table_MonsterAffix[b] and Table_MonsterAffix[b].Type
      local configA = GameConfig.GeffenMagic and GameConfig.GeffenMagic.Affix and GameConfig.GeffenMagic.Affix[typeA]
      local configB = GameConfig.GeffenMagic and GameConfig.GeffenMagic.Affix and GameConfig.GeffenMagic.Affix[typeB]
      return configA and configB and configA.ScoreRate > configB.ScoreRate
    end)
  end
  TableUtility.ArrayClear(self.selectedAffixes)
  if data.select_affixes then
    for i = 1, #data.select_affixes do
      local affix = data.select_affixes[i]
      TableUtility.ArrayPushBack(self.selectedAffixes, affix)
    end
  end
  self.wave = data.wave or 0
  self.startTime = data.start_time or 0
  self.isInBattle = data.start_fight or false
  if data.difficulty and 0 < data.difficulty then
    self.difficulty = data.difficulty
  end
  self:ClearStatDatas()
  GeffenMagicWaveScoreProxy.Instance:TryQueryWaveEnemy()
end

function AsyncPvpRaidProxy:UpdateGeffenMagicStat(serverDatas)
  for i = 1, #serverDatas do
    local serverData = serverDatas[i]
    local statData = self.statDatas[serverData.stat_type]
    if not statData then
      statData = {}
      statData.type = serverData.stat_type
      self.statDatas[serverData.stat_type] = statData
    end
    statData.value = serverData.value or 0
    statData.score = serverData.score or 0
  end
end

function AsyncPvpRaidProxy:SyncGeffenMagicResultInfo(data)
  local scoreData = data.wave_scores
  self.wave = scoreData.wave or 0
  if scoreData.stat_data then
    for i = 1, #scoreData.stat_data do
      local serverData = scoreData.stat_data[i]
      local statData = self.statDatas[serverData.stat_type]
      if not statData then
        statData = {}
        statData.type = serverData.stat_type
        self.statDatas[serverData.stat_type] = statData
      end
      statData.value = serverData.value or 0
      statData.score = serverData.score or 0
      redlog("AsyncPvpRaidProxy:SyncGeffenMagicResultInfo stat data", statData.type, statData.value, statData.score)
    end
  end
  self.score = scoreData.score or 0
  self.scoreRate = scoreData.score_rate or 0
  self.isNewRecord = data.new_record or false
end

function AsyncPvpRaidProxy:GetAllAffixes()
  return self.allAffixes
end

function AsyncPvpRaidProxy:IsSelectedAffix(affixId, isPreview)
  if isPreview then
    return TableUtility.ArrayFindIndex(self.selectedAffixes, affixId) ~= 0
  end
  return TableUtility.ArrayFindIndex(self.localSelectedAffixes, affixId) ~= 0
end

function AsyncPvpRaidProxy:HasSelectedAffix()
  return #self.selectedAffixes > 0
end

function AsyncPvpRaidProxy:GetSelectedAffixes()
  return self.selectedAffixes
end

function AsyncPvpRaidProxy:GetCurWave()
  return self.wave or 0
end

function AsyncPvpRaidProxy:GetStartTime()
  return self.startTime or 0
end

function AsyncPvpRaidProxy:GetScore()
  return self.score or 0
end

function AsyncPvpRaidProxy:GetScoreRate()
  return self.scoreRate or 0
end

function AsyncPvpRaidProxy:GetDifficulty()
  return self.difficulty or 0
end

function AsyncPvpRaidProxy:GetDamageStatData()
  return self:GetStatData(FuBenCmd_pb.ESTAT_TYPE_DAMAGE)
end

function AsyncPvpRaidProxy:GetTakeDamageStatData()
  return self:GetStatData(FuBenCmd_pb.ESTAT_TYPE_TAKE_DAMAGE)
end

function AsyncPvpRaidProxy:GetReviveStatData()
  return self:GetStatData(FuBenCmd_pb.ESTAT_TYPE_RELIVE)
end

function AsyncPvpRaidProxy:GetTimeStatData()
  return self:GetStatData(FuBenCmd_pb.ESTAT_TYPE_TIME)
end

function AsyncPvpRaidProxy:GetStatData(statType)
  return self.statDatas[statType]
end

function AsyncPvpRaidProxy:ClearStatDatas()
  TableUtility.TableClear(self.statDatas)
end

function AsyncPvpRaidProxy:IsInBattle()
  return self.isInBattle or false
end

function AsyncPvpRaidProxy:IsNewRecord()
  return self.isNewRecord or false
end

function AsyncPvpRaidProxy:SetLocalSelectedAffixes(affixes)
  TableUtility.ArrayClear(self.localSelectedAffixes)
  for i = 1, #affixes do
    local affix = affixes[i]
    TableUtility.ArrayPushBack(self.localSelectedAffixes, affix)
  end
end

function AsyncPvpRaidProxy:GetLocalSelectedAffixes()
  return self.localSelectedAffixes
end
