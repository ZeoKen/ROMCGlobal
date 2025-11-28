MainViewPolyFightPage = class("MainViewPolyFightPage", MainViewDungeonInfoSubPage)
MainViewPolyFightPage.CointItemId = 157
local tickMg

function MainViewPolyFightPage:Init()
  if not tickMg then
    tickMg = TimeTickManager.Me()
  end
  self:ReLoadPerferb("view/MainViewPolyFightPage")
  self:AddViewEvts()
  self:initView()
  self:initData()
  self:SetData()
end

function MainViewPolyFightPage:initData()
  local pvpCg = GameConfig.PVPConfig and GameConfig.PVPConfig[4] or nil
  self.totalTime = pvpCg and pvpCg.Time or 300
  self.personLimit = pvpCg and pvpCg.PeopleLimit or 10
  self.score = 0
  self.player_num = nil
  self.starttime = nil
end

function MainViewPolyFightPage:SetData()
  local fightInfo = PvpProxy.Instance:GetFightStatInfo()
  if fightInfo.player_num ~= self.player_num then
    self.player_num = fightInfo.player_num
    self.curPersonNum.text = string.format(ZhString.MainViewPolyFightPage_CurPersonNum, fightInfo.player_num, self.personLimit)
  end
  if fightInfo.starttime ~= self.starttime then
    self.starttime = fightInfo.starttime
    tickMg:ClearTick(self)
    tickMg:CreateTick(0, 500, self.updatePvpTime, self)
  end
  if fightInfo.score ~= self.score then
    self.score = fightInfo.score
    local str = ZhString.MainViewPolyFightPage_GoldAppleNum
    self.applCount:Reset()
    str = string.format(str, self.score, MainViewPolyFightPage.CointItemId)
    if self.goldAppleNum.gameObject.activeInHierarchy then
      self.applCount:SetText(str, true)
    end
  end
  local str = ZhString.MainViewPolyFightPage_MyRank
  local myRank = fightInfo.myrank or "?"
  self.myRank.text = string.format(str, myRank)
  self:updateRankChangeCCmd()
end

function MainViewPolyFightPage:initView()
  self.curPersonNum = self:FindComponent("curPersonNum", UILabel)
  self.myRank = self:FindComponent("myRank", UILabel)
  self.progressLabel = self:FindComponent("progressLabel", UILabel)
  self.applCount = SpriteLabel.CreateAsTable()
  self.goldAppleNum = self:FindComponent("goldAppleNum", UIRichLabel)
  self.applCount:Init(self.goldAppleNum, nil, 30, 30, true)
  self.progressSlider = self:FindComponent("progress", UISlider)
  self.firstName = self:FindComponent("firstName", UILabel)
  self.secondName = self:FindComponent("secondName", UILabel)
  self.thirdName = self:FindComponent("thirdName", UILabel)
  self.rankLabels = {
    self.firstName,
    self.secondName,
    self.thirdName
  }
  self.bg = self:FindComponent("bg", UISprite)
  self.content = self:FindGO("content")
  self.bgSizeX = self.bg.width
end

function MainViewPolyFightPage:AddViewEvts()
  self:AddListenEvt(ServiceEvent.MatchCCmdNtfFightStatCCmd, self.HandleMatchCCmdNtfFightStatCCmd)
  self:AddListenEvt(ServiceEvent.MatchCCmdNtfRankChangeCCmd, self.updateRankChangeCCmd)
end

function MainViewPolyFightPage:OnExit()
  tickMg:ClearTick(self)
  MainViewPolyFightPage.super.OnExit(self)
end

function MainViewPolyFightPage:HandleMatchCCmdNtfFightStatCCmd(note)
  self:SetData()
end

function MainViewPolyFightPage:updateRankChangeCCmd()
  local fightInfo = PvpProxy.Instance:GetFightStatInfo()
  for i = 1, 3 do
    local label = self.rankLabels[i]
    local data = fightInfo.ranks and fightInfo.ranks[i] or nil
    label.text = data and data.name or "？？？"
  end
end

function MainViewPolyFightPage:updatePvpTime()
  local pastTime = ServerTime.CurServerTime() / 1000 - self.starttime
  local leftTime = self.totalTime - pastTime
  if leftTime < 0 then
    leftTime = 0
    tickMg:ClearTick(self)
  end
  leftTime = math.floor(leftTime)
  local m = math.floor(leftTime / 60)
  local sd = leftTime - m * 60
  local leftTimeStr = string.format("%02d:%02d", m, sd)
  self.progressLabel.text = leftTimeStr
  self.progressSlider.value = leftTime / self.totalTime
end
