local EStat = {
  Damage = 1,
  TakeDamage = 2,
  Time = 3,
  Relive = 4,
  ScoreRate = 5,
  TotalScore = 6
}
GeffenMagicWaveScoreData = class("GeffenMagicWaveScoreData")

function GeffenMagicWaveScoreData.GetStatTitle(key)
  if not GeffenMagicWaveScoreData.StatTitle then
    GeffenMagicWaveScoreData.StatTitle = {
      [EStat.Time] = {
        ZhString.GeffenMagic_Stat_Time,
        "miniro_icon_countdown",
        "NewUI6"
      },
      [EStat.Damage] = {
        ZhString.GeffenMagic_Stat_Damage
      },
      [EStat.TakeDamage] = {
        ZhString.GeffenMagic_Stat_Take_Damage,
        "com_icon_dun",
        "NewUI11"
      },
      [EStat.Relive] = {
        ZhString.GeffenMagic_Stat_Relive,
        "main_icon_fuhuo",
        "NewUI10"
      }
    }
  end
  return GeffenMagicWaveScoreData.StatTitle[key]
end

function GeffenMagicWaveScoreData:ctor(serverData)
  self.statMap = {}
  self.displayStats = {}
  self:SetData(serverData)
end

function GeffenMagicWaveScoreData:SetData(serverData)
  if not serverData then
    return
  end
  self.dirty = true
  self.wave = serverData.wave or 0
  self:SetStatDatas(serverData.stat_data)
  self.score_rate = serverData.score_rate or 0
  self.score = serverData.score or 0
end

function GeffenMagicWaveScoreData:GetDisplayStats()
  if self.dirty then
    self.dirty = false
    TableUtility.ArrayClear(self.displayStats)
    local statDatas = TableUtil.HashToArray(self.statMap)
    for i = 1, #statDatas do
      if statDatas[i].key ~= EStat.Damage then
        self:AddDisplayStat(statDatas[i].key, statDatas[i].desc, statDatas[i].score, statDatas[i].value, statDatas[i].atlas, statDatas[i].icon)
      end
    end
    self:AddDisplayStat(EStat.ScoreRate, ZhString.GeffenMagic_Score_Rate, self.score_rate, "", "NewUI11", "com_icon_points")
    self:AddDisplayStat(EStat.TotalScore, ZhString.GeffenMagic_All, self.score)
  end
  return self.displayStats
end

function GeffenMagicWaveScoreData:AddDisplayStat(key, desc, score, value, atlas, icon)
  table.insert(self.displayStats, {
    key = key,
    desc = desc,
    value = value,
    atlas = atlas,
    icon = icon,
    score = key == EStat.ScoreRate and string.format("x%d%%", NumberUtility.RoundToInt(score * 100)) or score
  })
end

function GeffenMagicWaveScoreData:SetStatDatas(statDatas)
  if not statDatas then
    return
  end
  if statDatas and 0 < #statDatas then
    for i = 1, #statDatas do
      self:SetStatData(statDatas[i])
    end
  end
end

function GeffenMagicWaveScoreData:SetStatData(stat_data)
  local key = stat_data.stat_type
  local data = self.statMap[key]
  if not data then
    data = {}
    self.statMap[key] = data
  end
  local titleConfig = GeffenMagicWaveScoreData.GetStatTitle(key)
  data.key = key
  data.desc = titleConfig[1]
  data.icon = titleConfig[2]
  data.atlas = titleConfig[3]
  data.value = stat_data.value or 0
  data.score = stat_data.score or 0
end
