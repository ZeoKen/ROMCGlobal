local pagePath = "GUI/v1/part/PvpObDesertWolfBord"
PvpObDesertWolfBord = class("PvpObDesertWolfBord", CoreView)

function PvpObDesertWolfBord:ctor(parent)
  if not parent then
    return
  end
  self:CreateSelf(parent)
end

function PvpObDesertWolfBord:CreateSelf(parent)
  self.gameObject = self:LoadPreferb_ByFullPath(pagePath, parent, true)
  self:InitView()
end

function PvpObDesertWolfBord:InitView()
  local pvpCg = GameConfig.PVPConfig and GameConfig.PVPConfig[2] or nil
  self.maxScore = pvpCg and pvpCg.MaxScore or 30
  self.totalTime = pvpCg and pvpCg.Time or 300
  self:FindObjs()
end

function PvpObDesertWolfBord:FindObjs()
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
  self.detailBtnGO = self:FindGO("DetailBtn", self.traceInfoGO)
  self:AddClickEvent(self.detailBtnGO, function()
    self:OnDetailClicked()
  end)
end

function PvpObDesertWolfBord:OnExit()
  PvpObDesertWolfBord.super.OnExit(self)
  self:StopCountDown()
end

function PvpObDesertWolfBord:StartCountDown()
  if not self.countdownTimer then
    self.countdownTimer = TimeTickManager.Me():CreateTick(0, 500, function()
      self:UpdateCountDown()
    end, self)
  end
end

function PvpObDesertWolfBord:StopCountDown()
  if self.countdownTimer then
    self.countdownTimer:Destroy()
    self.countdownTimer = nil
  end
end

function PvpObDesertWolfBord:UpdateView()
  local fightInfo = PvpProxy.Instance:GetFightStatInfo()
  if fightInfo then
    if self.starttime ~= fightInfo.starttime then
      self.starttime = fightInfo.starttime
      self:UpdateCountDown()
    end
    local redScore = fightInfo.red_score or 0
    self.redProgress.value = redScore / self.maxScore
    self.redScoreLab.text = string.format("%s/%s", redScore, self.maxScore)
    local blueScore = fightInfo.blue_score or 0
    self.blueProgress.value = blueScore / self.maxScore
    self.blueScoreLab.text = string.format("%s/%s", blueScore, self.maxScore)
  end
end

function PvpObDesertWolfBord:UpdateCountDown()
  local pastTime = ServerTime.CurServerTime() / 1000 - self.starttime
  local leftTime = self.totalTime - pastTime
  if leftTime <= 0 then
    self:StopCountDown()
  end
  local min, sec = ClientTimeUtil.GetFormatSecTimeStr(leftTime)
  self.countdownLab.text = string.format("%02d:%02d", min, sec)
end

function PvpObDesertWolfBord:OnDetailClicked()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.DesertWolfReportPopup
  })
end

function PvpObDesertWolfBord:Hide()
  PvpObDesertWolfBord.super.Hide(self)
  self:StopCountDown()
end
