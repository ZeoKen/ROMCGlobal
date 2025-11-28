autoImport("BaseView")
autoImport("MatchPrepareCell")
MatchPreparePopUp = class("MatchPreparePopUp", BaseView)
MatchPreparePopUp.ViewType = UIViewType.PopUpLayer
MatchPreparePopUp.Instance = nil
MatchPreparePopUp.Anchor = nil
MatchPreparePopUp.PrepareData = {
  myTeam = {},
  enemyTeam = {}
}
MatchPreparePopUp.PwsInviteMatchStatus = {
  NONE = 1,
  READY = 2,
  CANCEL = 3
}

function MatchPreparePopUp.Show(pvpType)
  if not MatchPreparePopUp.Instance then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.MatchPreparePopUp,
      viewdata = {pvptype = pvpType}
    })
    return
  end
  if MatchPreparePopUp.Instance.isShow then
    return
  end
  if MatchPreparePopUp.Anchor and MatchPreparePopUp.Anchor.gameObject.activeInHierarchy then
    MatchPreparePopUp.Instance.trans.localScale = LuaGeometry.Const_V3_zero
    MatchPreparePopUp.Instance.trans.position = MatchPreparePopUp.Anchor.position
    TweenPosition.Begin(MatchPreparePopUp.Instance.gameObject, 0.2, LuaGeometry.Const_V3_zero)
    TweenScale.Begin(MatchPreparePopUp.Instance.gameObject, 0.2, LuaGeometry.Const_V3_one)
  else
    MatchPreparePopUp.Instance.trans.localPosition = LuaGeometry.Const_V3_zero
    MatchPreparePopUp.Instance.trans.localScale = LuaGeometry.Const_V3_one
  end
  if pvpType then
    MatchPreparePopUp.Instance.pvpType = pvpType
  end
  MatchPreparePopUp.Instance:OnShow()
  MatchPreparePopUp.Instance.isShow = true
end

function MatchPreparePopUp.Hide()
  if not MatchPreparePopUp.Instance or not MatchPreparePopUp.Instance.isShow then
    return
  end
  if MatchPreparePopUp.Anchor and MatchPreparePopUp.Anchor.gameObject.activeInHierarchy then
    TweenPosition.Begin(MatchPreparePopUp.Instance.gameObject, 0.2, MatchPreparePopUp.Anchor.position).worldSpace = true
  end
  TweenScale.Begin(MatchPreparePopUp.Instance.gameObject, 0.2, LuaGeometry.Const_V3_zero)
  MatchPreparePopUp.Instance:OnHide()
  MatchPreparePopUp.Instance.isShow = false
end

function MatchPreparePopUp.SetPrepareData(data)
  MatchPreparePopUp.PrepareData.type = data.type
  MatchPreparePopUp.PrepareData.startPrepareTime = data.startPrepareTime
  MatchPreparePopUp.PrepareData.maxPrepareTime = data.maxPrepareTime
  MatchPreparePopUp.PrepareData.myCamp = data.camp
  MatchPreparePopUp.PrepareData.myPrepareFlag = data.myPrepareFlag
  MatchPreparePopUp.CopyTeamPreInfo(MatchPreparePopUp.PrepareData.myTeam, data.myTeam, data.robotnum)
  MatchPreparePopUp.CopyTeamPreInfo(MatchPreparePopUp.PrepareData.enemyTeam, data.enemyTeam)
  MatchPreparePopUp.CampPlayerNum = data.campPlayerNum
  if MatchPreparePopUp.Instance then
    MatchPreparePopUp.Instance:InitData(data)
  end
end

function MatchPreparePopUp.CopyTeamPreInfo(targetList, sourceList, robotnum)
  local table
  if sourceList then
    for i = 1, #sourceList do
      table = targetList[i]
      if not table then
        table = {}
        targetList[i] = table
      end
      table.charID = sourceList[i].charID
      table.isReady = sourceList[i].isReady
    end
  end
  for i = sourceList and #sourceList + 1 or 1, #targetList do
    targetList[i].charID = MatchPrepareCell.EmptyCell
  end
  if robotnum and 0 < robotnum then
    local index = 0
    for i = 1, robotnum do
      index = #targetList + 1
      table = targetList[index]
      if not table then
        table = {}
        targetList[index] = table
      end
      targetList[index].charID = MatchPrepareCell.DefaultCell
    end
  end
end

function MatchPreparePopUp.UpdatePrepareStatus(charID)
  if MatchPreparePopUp.PrepareData then
    local datas = MatchPreparePopUp.PrepareData.myTeam
    local found = false
    for i = 1, #datas do
      if datas[i].charID == charID then
        datas[i].isReady = true
        found = true
        break
      end
    end
    if not found then
      datas = MatchPreparePopUp.PrepareData.enemyTeam
      for i = 1, #datas do
        if datas[i].charID == charID then
          datas[i].isReady = true
          break
        end
      end
    end
  end
  if MatchPreparePopUp.Instance then
    MatchPreparePopUp.Instance:UpdatePrepareStatusByID(charID)
  end
end

function MatchPreparePopUp.Update6v6PrepareStatus(charid, agree)
  local etype = MatchPreparePopUp.PrepareData.type
  local is6V6 = etype == PvpProxy.Type.TeamPws or etype == PvpProxy.Type.FreeBattle
  if MatchPreparePopUp.PrepareData and is6V6 then
    local datas = MatchPreparePopUp.PrepareData.myTeam
    if datas then
      for i = 1, #datas do
        if datas[i].charID == charid then
          datas[i].isReady = agree and MatchPreparePopUp.PwsInviteMatchStatus.READY or MatchPreparePopUp.PwsInviteMatchStatus.CANCEL
        end
      end
    end
  end
  if MatchPreparePopUp.Instance then
    MatchPreparePopUp.Instance:Update6v6PrepareStatusView(charid, agree)
  end
end

function MatchPreparePopUp.Refresh12PvpPrepare(camp, charid)
  if MatchPreparePopUp.Instance then
    MatchPreparePopUp.Instance:Refresh12PvpPrepareView(camp, charid)
  end
end

function MatchPreparePopUp:Refresh12PvpPrepareView(camp, charid)
  if not MatchPreparePopUp.PrepareData then
    return
  end
  if charid == Game.Myself.data.id and not MatchPreparePopUp.PrepareData.myPrepareFlag then
    MatchPreparePopUp.PrepareData.myPrepareFlag = true
  end
  self.objBtnPrepare:SetActive(not MatchPreparePopUp.PrepareData.myPrepareFlag)
  self.objPrepared:SetActive(MatchPreparePopUp.PrepareData.myPrepareFlag)
  local lab = camp == FuBenCmd_pb.EGROUPCAMP_RED and self.redCampNum or self.blueCampNum
  lab.text = string.format(ZhString.TwelvePVP_PreparePlayerNum, MatchPreparePopUp.CampPlayerNum[camp], GameConfig.Team.maxmember * 2)
end

function MatchPreparePopUp:Init()
  if MatchPreparePopUp.Instance then
    self:CloseSelf()
    return
  end
  MatchPreparePopUp.Instance = self
  self:FindObj()
  self:AddButtonEvt()
  self:AddViewEvt()
end

function MatchPreparePopUp:FindObj()
  self.gridMyTeam = self:FindComponent("gridMyTeam", UIGrid)
  self.listMyTeam = UIGridListCtrl.new(self.gridMyTeam, MatchPrepareCell, "MatchPrepareCell")
  local gridEnemyTeam = self:FindComponent("gridEnemyTeam", UIGrid)
  self.listEnemyTeam = UIGridListCtrl.new(gridEnemyTeam, MatchPrepareCell, "MatchPrepareCell")
  self.sliderCountDown = self:FindComponent("SliderCountDown", UISlider)
  self.labCountDown = self:FindComponent("labCountDown", UILabel)
  self.objBtnPrepare = self:FindGO("BtnPrepare")
  self.cancelBtn = self:FindGO("CancelBtn")
  self.objPrepared = self:FindGO("labPrepared")
  self.redCampNum = self:FindComponent("RedCampPlayerNum", UILabel)
  self.blueCampNum = self:FindComponent("BlueCampPlayerNum", UILabel)
  self.titleLab = self:FindComponent("labMatchSuccess", UILabel)
  self.forceMatchTip = self:FindComponent("ForceMatchTip", UILabel)
  self.labTip = self:FindComponent("labTip", UILabel)
  self.labTip.text = ZhString.MatchSussessTip
  self.forceMatchTip.text = ZhString.MatchPrepare_ForceMatchTip
  self.frameUp = self:FindGO("FrameUp")
  self.membersRoot = self:FindGO("Members")
  self.pvp12root = self:FindGO("Pvp12Root")
  self.pvp12Tex = self:FindComponent("Pvp12Tex", UITexture)
  self.redTex = self:FindComponent("RedTex", UITexture)
  self.blueTex = self:FindComponent("BlueTex", UITexture)
  self.vsTex = self:FindComponent("VsTex", UITexture)
  self.pvp12TexButtom = self:FindComponent("Pvp12TexButtom", UITexture)
  self.pvp12Thunder = self:FindComponent("Pvp12Thunder", UITexture)
  self.pvp12Thunder1 = self:FindComponent("Pvp12Thunder1", UITexture)
end

function MatchPreparePopUp:AddButtonEvt()
  self:AddClickEvent(self.objBtnPrepare, function()
    self:ClickButtonPrepare()
  end)
  self:AddClickEvent(self:FindGO("BtnMin"), function()
    MatchPreparePopUp.Hide()
  end)
  self:AddClickEvent(self.cancelBtn, function()
    self:OnClickCancel()
  end)
end

function MatchPreparePopUp:AddViewEvt()
  self:AddListenEvt(ServiceEvent.MatchCCmdNtfMatchInfoCCmd, self.HandleNtfMatchInfo)
  self:AddListenEvt(PVPEvent.TeamPws_Launch, self.HandleClose)
  self:AddListenEvt(PVEEvent.ExpRaid_Launch, self.HandleClose)
  self:AddListenEvt(PVPEvent.TeamPwsOthello_Launch, self.HandleClose)
  self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.HandleTeamMember)
  self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.HandleTeamMember)
  self:AddListenEvt(ServiceEvent.TeamRaidCmdTeamPvpInviteMatchCmd, self.HandleInviteMatch)
  self:AddListenEvt(ServiceEvent.TeamRaidCmdTeamPvpReplyMatchCmd, self.HandleTeamPvpReplyMatch)
  self:AddListenEvt(PVPEvent.TeamPws_ClearInviteMatch, self.DelayClose)
end

function MatchPreparePopUp:DelayClose()
  self.ltDisableClick = TimeTickManager.Me():CreateOnceDelayTick(1000, function(self)
    self:CloseSelf()
    self.ltDisableClick = nil
  end, self, 3)
end

function MatchPreparePopUp:HandleTeamMember()
  self.listMyTeam:ResetDatas(MatchPreparePopUp.PrepareData.myTeam)
  self.listMyTeam:Layout()
end

function MatchPreparePopUp:HandleTeamPvpReplyMatch(note)
  local agree = note.body.agree
  if not agree or PvpProxy.Instance:CheckInviteMatchAllReady(self.pvpType) then
    self:DelayClose()
  end
end

function MatchPreparePopUp:HandleInviteMatch(note)
  local cancel = note.body and note.body.iscancel
  if cancel then
    self:DelayClose()
  end
end

local titleLabIndex = {
  [PvpProxy.Type.TeamPws] = ZhString.TeamPws_Invite,
  [PvpProxy.Type.FreeBattle] = ZhString.TeamPws_FreeBattle_Invite
}

function MatchPreparePopUp:InitData(data)
  if not MatchPreparePopUp.PrepareData then
    LogUtility.Error("未找到准备数据！")
    self:CloseSelf()
    return
  end
  if MatchPreparePopUp.PrepareData.type ~= self.pvpType then
    LogUtility.Warning(string.format("界面pvp类型(%s)与数据pvp类型(%s)不一致，以数据类型为准。", self.pvpType, MatchPreparePopUp.PrepareData.type))
    self.pvpType = MatchPreparePopUp.PrepareData.type
  end
  local matchState = PvpProxy.Instance:GetMatchState(self.pvpType)
  local goodMatch = matchState and matchState.goodMatch
  self.forceMatchTip.gameObject:SetActive(not goodMatch)
  self.startPrepareTime = MatchPreparePopUp.PrepareData.startPrepareTime
  self.maxTeamPwsPrepareTime = MatchPreparePopUp.PrepareData.maxPrepareTime
  if self.startPrepareTime then
    TimeTickManager.Me():CreateTick(0, 33, self.UpdateCountDown, self, 1)
  else
    self.labCountDown.text = string.format("%ss", 0)
    self.sliderCountDown.value = 0
  end
  local is6V6 = self.pvpType == PvpProxy.Type.TeamPws or self.pvpType == PvpProxy.Type.FreeBattle
  if PvpProxy.Instance:IsInPreparation() then
    self.objBtnPrepare:SetActive(false)
    self.titleLab.text = ZhString.MidMatching_Title
    self.labCountDown.text = ""
    self.labTip.gameObject:SetActive(false)
    self.sliderCountDown.gameObject:SetActive(false)
  else
    self.titleLab.text = titleLabIndex[self.pvpType] or ZhString.MatchSussess
    self.labTip.gameObject:SetActive(true)
    self.sliderCountDown.gameObject:SetActive(true)
  end
  local is12pvp = TwelvePvPProxy.Instance:Is12pvp(self.pvpType)
  self.membersRoot:SetActive(not is12pvp)
  self.frameUp:SetActive(not is12pvp)
  self.pvp12root:SetActive(is12pvp)
  if is12pvp then
    local num = MatchPreparePopUp.CampPlayerNum[FuBenCmd_pb.EGROUPCAMP_RED] or 0
    self.redCampNum.text = string.format(ZhString.TwelvePVP_PreparePlayerNum, num, GameConfig.Team.maxmember * 2)
    num = MatchPreparePopUp.CampPlayerNum[FuBenCmd_pb.EGROUPCAMP_BLUE] or 0
    self.blueCampNum.text = string.format(ZhString.TwelvePVP_PreparePlayerNum, num, GameConfig.Team.maxmember * 2)
    return
  end
  if is6V6 then
    self.gridMyTeam.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(0, 10, 0)
    self.objBtnPrepare.transform.localPosition = LuaGeometry.GetTempVector3(130, -168, 0)
    self.cancelBtn:SetActive(true)
    local hasChoose = PvpProxy.Instance:CheckHasChooseInviteMatch(self.pvpType)
    self.objPrepared:SetActive(false)
    self.cancelBtn:SetActive(not hasChoose)
    self.objBtnPrepare:SetActive(not hasChoose)
    self.listMyTeam:ResetDatas(MatchPreparePopUp.PrepareData.myTeam)
    self.listMyTeam:Layout()
    self.labTip.gameObject:SetActive(false)
    self.forceMatchTip.gameObject:SetActive(false)
    return
  end
  local myCharID = Game.Myself.data.id
  local datas = MatchPreparePopUp.PrepareData.myTeam
  if datas then
    for i = 1, #datas do
      local data = datas[i]
      if myCharID == data.charID then
        self.objBtnPrepare:SetActive(not data.isReady)
        self.objPrepared:SetActive(data.isReady)
        break
      end
    end
  end
  self.listMyTeam:ResetDatas(MatchPreparePopUp.PrepareData.myTeam)
  self.listMyTeam:Layout()
  local tempVector3 = LuaGeometry.GetTempVector3()
  if MatchPreparePopUp.PrepareData.enemyTeam and 0 < #MatchPreparePopUp.PrepareData.enemyTeam then
    self.listEnemyTeam:ResetDatas(MatchPreparePopUp.PrepareData.enemyTeam)
    self.listEnemyTeam:Layout()
    tempVector3:Set(0, 45, 0)
  else
    tempVector3:Set(0, 10, 0)
  end
  self.gridMyTeam.gameObject.transform.localPosition = tempVector3
  self.objBtnPrepare.transform.localPosition = LuaGeometry.GetTempVector3(8, -168, 0)
  if self.pvpType == PvpProxy.Type.ExpRaid and TeamProxy.Instance:IHaveTeam() and not TeamProxy.Instance:CheckIHaveLeaderAuthority() and not ExpRaidProxy.Instance:CheckBattleTimelenAndRemainingTimes() then
    MsgManager.ShowMsgByID(28021)
  end
end

function MatchPreparePopUp:UpdatePrepareStatusByID(charID)
  if not self:TryUpdateData(charID, self.listMyTeam) then
    self:TryUpdateData(charID, self.listEnemyTeam)
  end
end

function MatchPreparePopUp:UpdateCountDown()
  local curTime = (ServerTime.CurServerTime() - self.startPrepareTime) / 1000
  local leftTime = math.max(self.maxTeamPwsPrepareTime - curTime, 0)
  self.labCountDown.text = string.format("%ss", math.ceil(leftTime))
  self.sliderCountDown.value = leftTime / self.maxTeamPwsPrepareTime
  if leftTime == 0 then
    TimeTickManager.Me():ClearTick(self, 1)
  end
end

function MatchPreparePopUp:HandleNtfMatchInfo(note)
  if note.body and note.body.etype == self.pvpType then
    self:CloseSelf()
  end
end

function MatchPreparePopUp:HandleClose()
  PvpProxy.Instance:ClearTeamPwsPreInfo()
  PvpProxy.Instance:ClearTeamPwsMatchInfo()
  PvpProxy.Instance:ClearMatchInfo(self.pvpType)
  self:CloseSelf()
end

function MatchPreparePopUp:TryUpdateData(charID, list)
  local cell
  local cells = list:GetCells()
  for i = 1, #cells do
    cell = cells[i]
    if cell.charID == charID then
      cell:Prepared()
      if charID == Game.Myself.data.id then
        self.objBtnPrepare:SetActive(false)
        self.objPrepared:SetActive(true)
      end
      return true
    end
  end
  return false
end

function MatchPreparePopUp:Update6v6PrepareStatusView(charid, agree)
  local list = self.listMyTeam
  local cell
  local cells = list:GetCells()
  for i = 1, #cells do
    cell = cells[i]
    if cell.charID == charid then
      if agree then
        cell:Prepared()
      else
        cell:Canceled()
      end
    end
  end
  local hasChoose = PvpProxy.Instance:CheckHasChooseInviteMatch(self.pvpType)
  self.objBtnPrepare:SetActive(not hasChoose)
  self.cancelBtn:SetActive(not hasChoose)
  self.objPrepared:SetActive(false)
end

function MatchPreparePopUp:ClickButtonPrepare()
  if self.disableClick then
    return
  end
  if TwelvePvPProxy.Instance:Is12pvp(self.pvpType) then
    local camp = PvpProxy.Instance:Get12PvpMatchCamp()
    ServiceMatchCCmdProxy.Instance:CallTwelvePvpUpdatePreInfoMatchCCmd(camp, Game.Myself.data.id, self.pvpType)
  elseif self.pvpType == PvpProxy.Type.TeamPws or self.pvpType == PvpProxy.Type.FreeBattle then
    ServiceTeamRaidCmdProxy.Instance:CallTeamPvpReplyMatchCmd(self.pvpType, Game.Myself.data.id, true)
  else
    ServiceMatchCCmdProxy.Instance:CallUpdatePreInfoMatchCCmd(nil, self.pvpType)
  end
  self.disableClick = true
  self.ltDisableClick = TimeTickManager.Me():CreateOnceDelayTick(3000, function(owner, deltaTime)
    self.disableClick = false
    self.ltDisableClick = nil
  end, self, 3)
end

function MatchPreparePopUp:OnClickCancel()
  ServiceTeamRaidCmdProxy.Instance:CallTeamPvpReplyMatchCmd(self.pvpType, Game.Myself.data.id, false)
end

function MatchPreparePopUp:OnEnter()
  self.super.OnEnter(self)
  MatchPreparePopUp.Show(self.viewdata.viewdata.pvptype)
  PictureManager.Instance:SetPVP("12pvp_bg2", self.pvp12Tex)
  PictureManager.Instance:SetPVP("12pvp_bg_01", self.redTex)
  PictureManager.Instance:SetPVP("12pvp_bg_02", self.blueTex)
  PictureManager.Instance:SetPVP("pvp_icon_vs", self.vsTex)
  PictureManager.Instance:SetPVP("12pvp_bg3", self.pvp12TexButtom)
  PictureManager.Instance:SetPVP("pvp_bg_01", self.pvp12Thunder)
  PictureManager.Instance:SetPVP("pvp_bg_01", self.pvp12Thunder1)
end

function MatchPreparePopUp:OnShow()
  self.super.OnShow(self)
  self:InitData(MatchPreparePopUp.PrepareData)
end

function MatchPreparePopUp:OnHide()
  TimeTickManager.Me():ClearTick(self, 1)
  self.super.OnHide(self)
end

function MatchPreparePopUp:OnExit()
  TimeTickManager.Me():ClearTick(self, 1)
  if self.ltDisableClick then
    self.ltDisableClick:Destroy()
    self.ltDisableClick = nil
  end
  MatchPreparePopUp.Instance = nil
  self.super.OnExit(self)
end
