MainViewTransferFightPage = class("MainViewTransferFightPage", SubMediatorView)

function MainViewTransferFightPage:Init()
  self:ReLoadPerferb("view/MainViewTransferFightPage")
  self:AddViewEvts()
  self:initView()
  self:initData()
end

function MainViewTransferFightPage:ResetParent(parent)
  self.trans:SetParent(parent.transform, false)
end

function MainViewTransferFightPage:resetData()
  self.starttime = nil
  self.score = 0
  self.tickMg:ClearTick(self)
  PvpProxy.Instance:ClearTransferFightResult()
end

function MainViewTransferFightPage:initData()
  local pvpCg = GameConfig.TransferFight
  self.totalTime = pvpCg and pvpCg.lastTime or 180
  self.personLimit = pvpCg and pvpCg.PeopleLimit or 10
  self.tickMg = TimeTickManager.Me()
  self.score = 0
end

function MainViewTransferFightPage:Show(tarObj)
  MainViewTransferFightPage.super.Show(self, tarObj)
  if not tarObj then
    self.isInit = true
    self:SetData()
  end
end

function MainViewTransferFightPage:Hide(tarObj)
  MainViewTransferFightPage.super.Hide(self, tarObj)
  if not tarObj then
    self.isInit = false
    self:resetData()
  end
end

function MainViewTransferFightPage:initView()
  self.myScore = self:FindComponent("myScore", UILabel)
  self.countDownPart = self:FindGO("CountDown")
  self.countDownPart.gameObject:SetActive(false)
  self.progressLabel = self:FindComponent("progressLabel", UILabel)
  self.progressSlider = self:FindComponent("progress", UISlider)
  self.firstScore = self:FindComponent("firstScore", UILabel)
  self.secondScore = self:FindComponent("secondScore", UILabel)
  self.thirdScore = self:FindComponent("thirdScore", UILabel)
  self.scoreLabels = {
    self.firstScore,
    self.secondScore,
    self.thirdScore
  }
  self.firstName = self:FindComponent("firstName", UILabel)
  self.secondName = self:FindComponent("secondName", UILabel)
  self.thirdName = self:FindComponent("thirdName", UILabel)
  self.nameLabels = {
    self.firstName,
    self.secondName,
    self.thirdName
  }
  self.bg = self:FindComponent("bg", UISprite)
  self.content = self:FindGO("content")
  self.bgSizeX = self.bg.width
end

function MainViewTransferFightPage:AddViewEvts()
  self:AddListenEvt(ServiceEvent.FuBenCmdTransferFightRankFubenCmd, self.HandleMatchCCmdNtfFightStatCCmd)
end

function MainViewTransferFightPage:HandleMatchCCmdNtfFightStatCCmd(note)
  self:SetData()
end

function MainViewTransferFightPage:updateRankChangeCCmd()
  local fightInfo = PvpProxy.Instance:GetFightStatInfo()
  for i = 1, 3 do
    local label = self.scoreLabels[i]
    local data = fightInfo.ranks and fightInfo.ranks[i] or nil
    label.text = data and data.name or "？？？"
  end
end

function MainViewTransferFightPage:SetData()
  local fightInfo = PvpProxy.Instance:GetFightStatInfo()
  if fightInfo.coldtime and not self.starttime then
    self.countDownPart.gameObject:SetActive(true)
    self.starttime = ServerTime.CurServerTime() / 1000
    self.totalTime = fightInfo.coldtime or self.totalTime
    self.tickMg:ClearTick(self)
    self.tickMg:CreateTick(0, 500, self.updatePvpTime, self)
  end
  if fightInfo.score ~= self.score then
    self.score = fightInfo.score or self.score
    local str = ZhString.MainViewTransferFight_score
    str = string.format(str, self.score)
  end
  local str = ZhString.MainViewTransferFight_score
  local myScore = self.score or 0
  self.myScore.text = string.format(str, myScore)
  for i = 1, 3 do
    local scorelabel = self.scoreLabels[i]
    local namelabel = self.nameLabels[i]
    local data = fightInfo.ranks and fightInfo.ranks[i] or nil
    scorelabel.text = data and data.score or "？？？"
    namelabel.text = data and data.name or "？？？"
  end
end

function MainViewTransferFightPage:updatePvpTime()
  local pastTime = ServerTime.CurServerTime() / 1000 - self.starttime
  local leftTime = self.totalTime - pastTime
  if leftTime < 0 then
    leftTime = 0
    self.tickMg:ClearTick(self)
  end
  leftTime = math.floor(leftTime)
  local m = math.floor(leftTime / 60)
  local sd = leftTime - m * 60
  local leftTimeStr = string.format("%02d:%02d", m, sd)
  self.progressLabel.text = leftTimeStr
  self.progressSlider.value = leftTime / self.totalTime
end
