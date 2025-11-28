MainView3TeamsScoreCell = class("MainView3TeamsScoreCell", BaseCell)
local LabelRed = "ff8b85"
local LabelYellow = "e2df9a"
local LabelBlue = "9bb1ff"
local LabelGreen = "94ecaf"
local SpRed = "pvp_bood_red"
local SpYellow = "pvp_bood_yellow"
local SpBlue = "pvp_bood_blue"
local SpGreen = "pvp_bood_green"
local CampConf = {
  [ETRIPLECAMP.ETRIPLE_CAMP_RED] = {labelCol = LabelRed, sp = SpRed},
  [ETRIPLECAMP.ETRIPLE_CAMP_YELLOW] = {labelCol = LabelYellow, sp = SpYellow},
  [ETRIPLECAMP.ETRIPLE_CAMP_BLUE] = {labelCol = LabelBlue, sp = SpBlue},
  [ETRIPLECAMP.ETRIPLE_CAMP_GREEN] = {labelCol = LabelGreen, sp = SpGreen}
}

function MainView3TeamsScoreCell:Init()
  self:FindObjs()
end

function MainView3TeamsScoreCell:FindObjs()
  self.campLabel = self:FindComponent("camp", UILabel)
  self.scoreLabel = self:FindComponent("score", UILabel)
  local scoreBarGo = self:FindGO("scoreBar")
  self.scoreBar = scoreBarGo:GetComponent(UIProgressBar)
  self.scoreBarSp = scoreBarGo:GetComponent(UISprite)
  self.firstSp = self:FindGO("1st")
end

function MainView3TeamsScoreCell:SetData(data)
  if data and CampConf[data.camp] then
    local conf = CampConf[data.camp]
    local campName = GameConfig.Triple.CampName[data.camp]
    if data.camp ~= PvpProxy.Instance.myselfCamp then
      self.campLabel.text = string.format(ZhString.Triple_Camp_Enemy, campName)
    else
      self.campLabel.text = campName
    end
    local _, c = ColorUtil.TryParseHexString(conf.labelCol)
    self.campLabel.color = c
    self.scoreLabel.text = string.format("%s/%s", data.score, GameConfig.Triple.MaxScore)
    self.scoreBarSp.spriteName = conf.sp
    self.scoreBar.value = data.score / GameConfig.Triple.MaxScore
    self.firstSp:SetActive(PvpProxy.Instance:IsScoreFirstCamp(data.camp))
  end
end
