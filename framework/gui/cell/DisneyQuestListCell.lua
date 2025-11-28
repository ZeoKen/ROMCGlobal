local baseCell = autoImport("BaseCell")
DisneyQuestListCell = class("DisneyQuestListCell", baseCell)
local unfinishedColor = LuaColor(1, 0.5882352941176471, 0.5882352941176471, 1)
local lockedColor = LuaColor(0.5843137254901961, 0.6078431372549019, 0.7333333333333333, 1)
local normalColor = LuaColor(0.788235294117647, 0.796078431372549, 0.8784313725490196, 1)

function DisneyQuestListCell:Init()
  self:FindObjs()
end

function DisneyQuestListCell:FindObjs()
  self.questName = self:FindGO("QuestName"):GetComponent(UILabel)
  self.score = self:FindGO("Score"):GetComponent(UILabel)
end

function DisneyQuestListCell:SetData(data)
  self.data = data
  self.config = data.config
  if self.config then
    self.questName.text = self.config.QuestName or "任务名字没写"
    local score = data.score
    local challengeBeginTime = 0
    local curServerTime = ServerTime.CurServerTime() / 1000
    if EnvChannel.IsTFBranch() then
      challengeBeginTime = self.config.TFBeginTime or 0
    else
      challengeBeginTime = self.config.BeginTime or 0
    end
    local st_year, st_month, st_day, st_hour, st_min, st_sec = StringUtil.GetDateData(challengeBeginTime)
    local startTime = os.time({
      day = st_day,
      month = st_month,
      year = st_year,
      hour = st_hour,
      min = st_min,
      sec = st_sec
    })
    if curServerTime < startTime then
      self.score.text = ZhString.DisneyChallengeLocked
      self.questName.color = lockedColor
      self.score.color = lockedColor
    elseif score then
      self.questName.color = normalColor
      self.score.color = normalColor
      self.score.text = score
    else
      self.questName.color = unfinishedColor
      self.score.color = unfinishedColor
      self.score.text = ZhString.DisneyChallengeUnfinished
    end
  end
end
