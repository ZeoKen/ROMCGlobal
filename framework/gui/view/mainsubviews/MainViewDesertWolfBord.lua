MainViewDesertWolfBord = class("MainViewDesertWolfBord", MainViewDungeonInfoSubPage)
local pagePath = "view/DesertWolf/DesertWolfInGameBord"
MainViewDesertWolfBord.DouCointItemId = 150

function MainViewDesertWolfBord:Init()
  self.root = self.container.viewMap.TraceInfoBord and self.container.viewMap.TraceInfoBord.classicPvpFightBord and self.container.viewMap.TraceInfoBord.classicPvpFightBord.transform
  self:ReLoadPerferb(pagePath, false, nil, self.root)
  local pvpCg = GameConfig.PVPConfig and GameConfig.PVPConfig[2] or nil
  self.maxScore = pvpCg and pvpCg.MaxScore or 30
  self.totalTime = pvpCg and pvpCg.Time or 300
  self:FindObjs()
  self:AddViewEvts()
end

function MainViewDesertWolfBord:FindObjs()
  self.traceInfoGO = self:FindGO("TraceInfo")
  self.inoutTween = self.traceInfoGO:GetComponent(UIPlayTween)
  self.isShow = true
  self.arrowGO = self:FindGO("Arrow", self.traceInfoGO)
  self:AddClickEvent(self.arrowGO, function()
    self.isShow = not self.isShow
    self.inoutTween:Play(not self.isShow)
  end)
  self.titleLab = self:FindComponent("Title", UILabel, self.traceInfoGO)
  self.titleLab.text = ZhString.MainViewClassicPvpFightPage_DesertWolfPvpName
  self.countdownLab = self:FindComponent("Time", UILabel, self.traceInfoGO)
  self.redProgress = self:FindComponent("RedProgressBg", UIProgressBar, self.traceInfoGO)
  self.redScoreLab = self:FindComponent("RedScoreLab", UILabel, self.traceInfoGO)
  self.blueProgress = self:FindComponent("BlueProgressBg", UIProgressBar, self.traceInfoGO)
  self.blueScoreLab = self:FindComponent("BlueScoreLab", UILabel, self.traceInfoGO)
  self.coinIcon = self:FindComponent("Coin", UISprite, self.traceInfoGO)
  local itemConfig = Table_Item[MainViewDesertWolfBord.DouCointItemId]
  if itemConfig and itemConfig.Icon then
    IconManager:SetItemIcon(itemConfig.Icon, self.coinIcon)
  end
  self.coinCountLab = self:FindComponent("CoinCount", UILabel, self.traceInfoGO)
  self.detailBtnGO = self:FindGO("DetailBtn", self.traceInfoGO)
  self:AddClickEvent(self.detailBtnGO, function()
    self:OnDetailClicked()
  end)
end

function MainViewDesertWolfBord:OnEnter()
  MainViewDesertWolfBord.super.OnEnter(self)
  self:UpdateView()
  self:StartCountDown()
end

function MainViewDesertWolfBord:OnExit()
  MainViewDesertWolfBord.super.OnExit(self)
  self:StopCountDown()
end

function MainViewDesertWolfBord:StartCountDown()
  if not self.countdownTimer then
    self.countdownTimer = TimeTickManager.Me():CreateTick(0, 500, function()
      self:UpdateCountDown()
    end, self)
  end
end

function MainViewDesertWolfBord:StopCountDown()
  if self.countdownTimer then
    self.countdownTimer:Destroy()
    self.countdownTimer = nil
  end
end

function MainViewDesertWolfBord:UpdateView()
  local fightInfo = PvpProxy.Instance:GetFightStatInfo()
  if fightInfo then
    if self.starttime ~= fightInfo.starttime then
      self.starttime = fightInfo.starttime
      self:UpdateCountDown()
      self:StartCountDown()
    end
    local redScore = fightInfo.red_score or 0
    self.redProgress.value = redScore / self.maxScore
    self.redScoreLab.text = string.format("%s/%s", redScore, self.maxScore)
    local blueScore = fightInfo.blue_score or 0
    self.blueProgress.value = blueScore / self.maxScore
    self.blueScoreLab.text = string.format("%s/%s", blueScore, self.maxScore)
  end
  self:UpdateCoin()
end

function MainViewDesertWolfBord:UpdateCountDown()
  local leftTime = 0
  if self.starttime and self.totalTime then
    local pastTime = ServerTime.CurServerTime() / 1000 - self.starttime
    leftTime = self.totalTime - pastTime
  end
  if leftTime <= 0 then
    leftTime = 0
    self:StopCountDown()
  end
  local min, sec = ClientTimeUtil.GetFormatSecTimeStr(leftTime)
  self.countdownLab.text = string.format("%02d:%02d", min, sec)
end

function MainViewDesertWolfBord:AddViewEvts()
  self:AddListenEvt(ServiceEvent.MatchCCmdNtfFightStatCCmd, self.UpdateView)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateCoin)
end

function MainViewDesertWolfBord:UpdateCoin()
  local userdata = Game.Myself and Game.Myself.data.userdata
  local num = userdata and userdata:Get(UDEnum.PVPCOIN) or 0
  self.coinCountLab.text = num
end

function MainViewDesertWolfBord:OnDetailClicked()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.DesertWolfReportPopup
  })
end
