autoImport("PvpObNewSubview")
PvpObTeamPwsSubview = class("PvpObTeamPwsSubview", PvpObNewSubview)

function PvpObTeamPwsSubview:LoadPrefab()
  self:ReLoadPerferb("view/TeamPwsObSubview", true)
  self.obRootGO = self.gameObject
end

function PvpObTeamPwsSubview:FindObjs()
  PvpObTeamPwsSubview.super.FindObjs(self)
  self.killNumRedLabel = self:FindComponent("KillNum", UILabel, self.leftHeadRootGO)
  self.scoreRed = self:FindComponent("Score", UILabel, self.leftHeadRootGO)
  self.buffTimeRed = self:FindComponent("LeftTime", UILabel, self.leftHeadRootGO)
  local buffIconRedGO = self:FindGO("BuffIcon", self.leftHeadRootGO)
  self:AddClickEvent(buffIconRedGO, function()
    self:OnBuffRedClicked()
  end)
  IconManager:SetUIIcon("ui_teampvp_skillg", self:FindComponent("Bg", UISprite, buffIconRedGO))
  self.buffIconRed = buffIconRedGO:GetComponent(UISprite)
  self.buffIconRed_1 = self:FindComponent("1", UISprite, buffIconRedGO)
  self.buffIconRed_2 = self:FindComponent("2", UISprite, buffIconRedGO)
  self.buffIconRed_3 = self:FindComponent("3", UISprite, buffIconRedGO)
  self.buffIconRed_4 = self:FindComponent("4", UISprite, buffIconRedGO)
  self.killNumBlueLabel = self:FindComponent("KillNum", UILabel, self.rightHeadRootGO)
  self.scoreBlue = self:FindComponent("Score", UILabel, self.rightHeadRootGO)
  self.buffTimeBlue = self:FindComponent("LeftTime", UILabel, self.rightHeadRootGO)
  local buffIconBlueGO = self:FindGO("BuffIcon", self.rightHeadRootGO)
  self:AddClickEvent(buffIconBlueGO, function()
    self:OnBuffBlueClicked()
  end)
  IconManager:SetUIIcon("ui_teampvp_skillg", self:FindComponent("Bg", UISprite, buffIconBlueGO))
  self.buffIconBlue = buffIconRedGO:GetComponent(UISprite)
  self.buffIconBlue_1 = self:FindComponent("1", UISprite, buffIconBlueGO)
  self.buffIconBlue_2 = self:FindComponent("2", UISprite, buffIconBlueGO)
  self.buffIconBlue_3 = self:FindComponent("3", UISprite, buffIconBlueGO)
  self.buffIconBlue_4 = self:FindComponent("4", UISprite, buffIconBlueGO)
end

function PvpObTeamPwsSubview:InitListenEvents()
  PvpObTeamPwsSubview.super.InitListenEvents(self)
  self:AddDispatcherEvt(ServiceEvent.FuBenCmdTeamPwsInfoSyncFubenCmd, self.UpdateTeamPwsInfo)
  self:AddDispatcherEvt(ServiceEvent.FuBenCmdUpdateTeamPwsInfoFubenCmd, self.UpdateTeamPwsInfo)
  self:AddDispatcherEvt(ServiceEvent.FuBenCmdRaidKillNumSyncCmd, self.UpdateTeamPwsInfo)
end

function PvpObTeamPwsSubview:Show()
  PvpObTeamPwsSubview.super.Show(self)
  EventManager.Me():AddEventListener(PVPEvent.TeamPws_BuffBallChange, self.UpdateBuffInfo, self)
end

function PvpObTeamPwsSubview:Hide()
  PvpObTeamPwsSubview.super.Hide(self)
  EventManager.Me():RemoveEventListener(PVPEvent.TeamPws_BuffBallChange, self.UpdateBuffInfo, self)
  self:StopBuffTimeTick()
end

function PvpObTeamPwsSubview:UpdateTeamPwsInfo(data)
  local proxy = PvpObserveProxy.Instance
  self.killNumRedLabel.text = proxy:GetKillNum(1)
  self.killNumBlueLabel.text = proxy:GetKillNum(2)
  local pvpProxy = PvpProxy.Instance
  self.endTime = pvpProxy:GetSpareTime()
  if self:UpdateTimeLeft() then
    self:StartTimeTick()
  end
  local redInfo = pvpProxy:GetTeamPwsInfo(PvpProxy.TeamPws.TeamColor.Red)
  self.scoreRed.text = redInfo and redInfo.score or 0
  self.leftTeamName.text = ""
  if redInfo then
    self.leftTeamName.text = not StringUtil.IsEmpty(redInfo.warbandname) and redInfo.warbandname or redInfo.teamname or ""
  end
  local blueInfo = pvpProxy:GetTeamPwsInfo(PvpProxy.TeamPws.TeamColor.Blue)
  self.scoreBlue.text = blueInfo and blueInfo.score or 0
  self.rightTeamName.text = ""
  if blueInfo then
    self.rightTeamName.text = not StringUtil.IsEmpty(blueInfo.warbandname) and blueInfo.warbandname or blueInfo.teamname or ""
  end
  self:UpdateBuffInfo()
end

function PvpObTeamPwsSubview:UpdateBuffInfo()
  local pvpProxy = PvpProxy.Instance
  local _PvpTeamRaid = DungeonProxy.Instance:GetConfigPvpTeamRaid()
  local combineConfig = _PvpTeamRaid.ElementCombine
  local redInfo = pvpProxy:GetTeamPwsInfo(PvpProxy.TeamPws.TeamColor.Red)
  if redInfo then
    self.redBuffEndTime = redInfo.effectcd
    if redInfo.effectid and redInfo.effectid ~= 0 then
      self.buffIconRed.enabled = true
      local cdata = combineConfig[redInfo.effectid]
      IconManager:SetUIIcon(cdata.icon, self.buffIconRed)
      self.redBuffID = cdata.BuffIDs[1]
    else
      IconManager:SetUIIcon("ui_teampvp_skillg", self.buffIconRed)
      self.buffIconRed.enabled = false
      self.redBuffID = nil
    end
  else
    self.blueBuffEndTime = nil
    IconManager:SetUIIcon("ui_teampvp_skillg", self.buffIconRed)
    self.buffIconRed.enabled = false
    self.redBuffID = nil
  end
  local blueInfo = pvpProxy:GetTeamPwsInfo(PvpProxy.TeamPws.TeamColor.Blue)
  if blueInfo then
    self.blueBuffEndTime = blueInfo.effectcd
    if blueInfo.effectid and blueInfo.effectid ~= 0 then
      self.buffIconBlue.enabled = true
      local cdata = combineConfig[redInfo.effectid]
      IconManager:SetUIIcon(cdata.icon, self.buffIconBlue)
      self.blueBuffID = cdata.BuffIDs[1]
    else
      IconManager:SetUIIcon("ui_teampvp_skillg", self.buffIconBlue)
      self.buffIconBlue.enabled = false
      self.blueBuffID = nil
    end
  else
    self.blueBuffEndTime = nil
    IconManager:SetUIIcon("ui_teampvp_skillg", self.buffIconBlue)
    self.buffIconBlue.enabled = false
    self.blueBuffID = nil
  end
  local redBallMap, blueBallMap = redInfo.balls, blueInfo.balls
  local ballConfig = _PvpTeamRaid.ElementNpcsID
  for i = 1, 4 do
    local redSp = self["buffIconRed_" .. i]
    if redBallMap[i] then
      redSp.enabled = true
      IconManager:SetUIIcon(ballConfig[i].icon, redSp)
    else
      redSp.enabled = false
    end
    local blueSp = self["buffIconBlue_" .. i]
    if blueBallMap[i] then
      blueSp.enabled = true
      IconManager:SetUIIcon(ballConfig[i].icon, blueSp)
    else
      blueSp.enabled = false
    end
  end
  if self:UpdateBuffTimeTick() then
    self:StartBuffTimeTick()
  end
end

function PvpObTeamPwsSubview:OnDetailClicked()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TeamPwsReportPopUp,
    viewdata = {}
  })
end

function PvpObTeamPwsSubview:OnBuffRedClicked()
  if not self.redBuffID then
    return
  end
  local desc = Table_Buffer[self.redBuffID].BuffDesc
  local normalTip = TipManager.Instance:ShowNormalTip(desc, self.leftCenterStick, NGUIUtil.AnchorSide.Left, {210, 0})
  normalTip:SetAnchor(NGUIUtil.AnchorSide.TopRight)
end

function PvpObTeamPwsSubview:OnBuffBlueClicked()
  if not self.blueBuffID then
    return
  end
  local desc = Table_Buffer[self.blueBuffID].BuffDesc
  local normalTip = TipManager.Instance:ShowNormalTip(desc, self.rightCenterStick, NGUIUtil.AnchorSide.Right, {-410, 0})
  normalTip:SetAnchor(NGUIUtil.AnchorSide.TopRight)
end

function PvpObTeamPwsSubview:StartBuffTimeTick(camp)
  if self.buffTimeTick then
    return
  end
  self.buffTimeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateBuffTimeTick, self, 2)
end

function PvpObTeamPwsSubview:StopBuffTimeTick(camp)
  if self.buffTimeTick then
    self.buffTimeTick:Destroy()
    self.buffTimeTick = nil
    self.buffTimeRed.text = "0s"
    self.buffTimeBlue.text = "0s"
  end
end

function PvpObTeamPwsSubview:UpdateBuffTimeTick()
  local redLeftTime = self.redBuffEndTime and self.redBuffEndTime - ServerTime.CurServerTime() / 1000 or 0
  if 0 < redLeftTime then
    self.buffTimeRed.text = string.format("%ss", math.floor(redLeftTime))
  else
    self.buffTimeRed.text = "0s"
  end
  local blueLeftTime = self.blueBuffEndTime and self.blueBuffEndTime - ServerTime.CurServerTime() / 1000 or 0
  if 0 < blueLeftTime then
    self.buffTimeBlue.text = string.format("%ss", math.floor(blueLeftTime))
  else
    self.buffTimeBlue.text = "0s"
  end
  if redLeftTime <= 0 and blueLeftTime <= 0 then
    self:StopBuffTimeTick()
    return false
  end
  return true
end
