autoImport("PvpObNewSubview")
PvpObTeamPwsOthelloSubview = class("PvpObTeamPwsOthelloSubview", PvpObNewSubview)

function PvpObTeamPwsOthelloSubview:LoadPrefab()
  self:ReLoadPerferb("view/OthelloObSubview", true)
  self.obRootGO = self.gameObject
end

function PvpObTeamPwsOthelloSubview:FindObjs()
  local othelloConfig = DungeonProxy:GetOthelloConfigRaid()
  self.endscore = othelloConfig.endscore or 1
  PvpObTeamPwsOthelloSubview.super.FindObjs(self)
  self.killNumRedLabel = self:FindComponent("KillNum", UILabel, self.leftHeadRootGO)
  self.scoreRed = self:FindComponent("Score", UILabel, self.leftHeadRootGO)
  self.redProgress = self:FindComponent("ScoreSlider", UISlider, self.leftHeadRootGO)
  self.killNumBlueLabel = self:FindComponent("KillNum", UILabel, self.rightHeadRootGO)
  self.scoreBlue = self:FindComponent("Score", UILabel, self.rightHeadRootGO)
  self.blueProgress = self:FindComponent("ScoreSlider", UISlider, self.rightHeadRootGO)
end

function PvpObTeamPwsOthelloSubview:InitListenEvents()
  PvpObTeamPwsOthelloSubview.super.InitListenEvents(self)
  self:AddDispatcherEvt(ServiceEvent.FuBenCmdOthelloInfoSyncFubenCmd, self.UpdateOthelloInfo)
  self:AddDispatcherEvt(ServiceEvent.FuBenCmdRaidKillNumSyncCmd, self.UpdateOthelloInfo)
end

function PvpObTeamPwsOthelloSubview:UpdateOthelloInfo(data)
  local proxy = PvpObserveProxy.Instance
  self.killNumRedLabel.text = proxy:GetKillNum(1)
  self.killNumBlueLabel.text = proxy:GetKillNum(2)
  local pvpProxy = PvpProxy.Instance
  self.endTime = pvpProxy:GetOthelloEndtime()
  if self:UpdateTimeLeft() then
    self:StartTimeTick()
  end
  local rd = pvpProxy:GetOhelloInfo(PvpProxy.TeamPws.TeamColor.Red)
  local redScore = rd and rd.score or 0
  self.scoreRed.text = redScore
  self.redProgress.value = redScore / self.endscore
  self.leftTeamName.text = ""
  if rd then
    self.leftTeamName.text = not StringUtil.IsEmpty(rd.warbandname) and rd.warbandname or rd.teamname or ""
  end
  local bd = pvpProxy:GetOhelloInfo(PvpProxy.TeamPws.TeamColor.Blue)
  local blueScore = bd and bd.score or 0
  self.scoreBlue.text = blueScore
  self.blueProgress.value = blueScore / self.endscore
  self.rightTeamName.text = ""
  if bd then
    self.rightTeamName.text = not StringUtil.IsEmpty(bd.warbandname) and bd.warbandname or bd.teamname or ""
  end
end

function PvpObTeamPwsOthelloSubview:OnDetailClicked()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.OthelloReportPopUp
  })
end
