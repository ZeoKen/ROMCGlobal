local _GetFormatSecTimeStr = ClientTimeUtil.GetFormatSecTimeStr
local _StrFormat = string.format
local _GvgNewConfig = GameConfig.GvgNewConfig
local _MaxValueMap = {
  defense = _GvgNewConfig.defense_score,
  attack = _GvgNewConfig.max_attack_score,
  perfect = _GvgNewConfig.perfect_score,
  kill_mvp = _GvgNewConfig.max_mvp_score
}
local baseCell = autoImport("BaseCell")
GvgScoreCell = class("GvgScoreCell", baseCell)

function GvgScoreCell:Init()
  GvgScoreCell.super.Init(self)
  self.nameLab = self:FindComponent("Name", UILabel)
  self.descLab = self:FindComponent("DescLab", UILabel)
  self.perfectDefenseRoot = self:FindGO("CityRoot")
  self.perfectDefenseLab = self:FindComponent("PerfectDefenseLab", UILabel, self.perfectDefenseRoot)
end

function GvgScoreCell:SetData(configData)
  local key = configData.type
  self.descLab.text = configData.desc
  local score = GvgProxy.Instance:GetScoreInfoByKey(key)
  local name
  if GvgProxy.Instance:IsLeisureSeason() then
    name = 0 < score and key ~= "defense" and string.format(ZhString.MainViewGvgPage_GvgQuestTip_Complete, configData.title) or configData.title
  else
    local max_value = _MaxValueMap[key]
    if max_value then
      name = string.format(configData.title, score, max_value)
    else
      name = string.format(configData.title, score)
    end
  end
  self.nameLab.text = name
  if key == "perfect" then
    self:_TryAddPerfectDefenseTick()
  else
    self:Hide(self.perfectDefenseRoot)
  end
end

function GvgScoreCell:_TryAddPerfectDefenseTick()
  if not self.perfectDefenseLab then
    return
  end
  self:_RemovePerfectDefenseTick()
  self.perfectTimesInfo = GvgProxy.Instance:GetScorePerfectDefenseInfo()
  if not self.perfectTimesInfo or #self.perfectTimesInfo == 0 then
    return
  end
  self:Show(self.perfectDefenseRoot)
  self.perfectDefenseTick = TimeTickManager.Me():CreateTick(0, 1000, self._updatePerfectDefenseCD, self, 1)
end

function GvgScoreCell:_updatePerfectDefenseCD()
  local timeInfo = self.perfectTimesInfo
  local str = ""
  local min, sec, cityName, timeStamp, isPerfect, isPause
  local perfectStr = ZhString.MainViewGvgPage_GvgQuestTip_IsPerfectDefense
  local pauseStr = ZhString.MainViewGvgPage_GvgQuestTip_PerfectDefensePause
  local unpauseStr = ZhString.MainViewGvgPage_GvgQuestTip_PerfectDefense
  for i = 1, #timeInfo do
    local lineStr = i == #timeInfo and "" or "\n"
    cityName = timeInfo[i][1]
    timeStamp = timeInfo[i][2]
    isPerfect = timeInfo[i][3]
    isPause = timeInfo[i][4]
    if isPerfect then
      str = str .. cityName .. perfectStr .. lineStr
    elseif isPause then
      str = str .. cityName .. pauseStr .. lineStr
    else
      min, sec = _GetFormatSecTimeStr(timeStamp - ServerTime.CurServerTime() / 1000)
      str = str .. cityName .. _StrFormat(unpauseStr, min, sec) .. lineStr
    end
  end
  self.perfectDefenseLab.text = str
end

function GvgScoreCell:OnCellDestroy()
  self:_RemovePerfectDefenseTick()
end

function GvgScoreCell:_RemovePerfectDefenseTick()
  if self.perfectDefenseTick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.perfectDefenseTick = nil
  end
end
