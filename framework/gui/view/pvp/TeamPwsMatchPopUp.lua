TeamPwsMatchPopUp = class("TeamPwsMatchPopUp", BaseView)
TeamPwsMatchPopUp.ViewType = UIViewType.PopUpLayer
TeamPwsMatchPopUp.Instance = nil
TeamPwsMatchPopUp.Anchor = nil

function TeamPwsMatchPopUp.Show(pvpType)
  if not TeamPwsMatchPopUp.Instance then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamPwsMatchPopUp,
      viewdata = {pvptype = pvpType}
    })
    return
  end
  if TeamPwsMatchPopUp.Instance.isShow then
    return
  end
  if TeamPwsMatchPopUp.Anchor and TeamPwsMatchPopUp.Anchor.gameObject.activeInHierarchy then
    TeamPwsMatchPopUp.Instance.gameObject.transform.localScale = LuaGeometry.GetTempVector3()
    TeamPwsMatchPopUp.Instance.gameObject.transform.position = TeamPwsMatchPopUp.Anchor.position
    TweenPosition.Begin(TeamPwsMatchPopUp.Instance.gameObject, 0.2, Vector3.zero)
    TweenScale.Begin(TeamPwsMatchPopUp.Instance.gameObject, 0.2, Vector3.one)
  else
    TeamPwsMatchPopUp.Instance.gameObject.transform.localPosition = LuaGeometry.GetTempVector3()
    TeamPwsMatchPopUp.Instance.gameObject.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  end
  if pvpType then
    TeamPwsMatchPopUp.Instance.pvpType = pvpType
  end
  TeamPwsMatchPopUp.Instance:OnShow()
  TeamPwsMatchPopUp.Instance.isShow = true
  if not PvpProxy.Instance:GetCurMatchStatus() then
    TeamPwsMatchPopUp.Hide()
  end
end

function TeamPwsMatchPopUp.Hide()
  if not TeamPwsMatchPopUp.Instance or not TeamPwsMatchPopUp.Instance.isShow then
    return
  end
  if TeamPwsMatchPopUp.Anchor and TeamPwsMatchPopUp.Anchor.gameObject.activeInHierarchy then
    TweenPosition.Begin(TeamPwsMatchPopUp.Instance.gameObject, 0.2, TeamPwsMatchPopUp.Anchor.position).worldSpace = true
  end
  TweenScale.Begin(TeamPwsMatchPopUp.Instance.gameObject, 0.2, Vector3.zero)
  TeamPwsMatchPopUp.Instance:OnHide()
  TeamPwsMatchPopUp.Instance.isShow = false
end

function TeamPwsMatchPopUp:Init()
  if TeamPwsMatchPopUp.Instance then
    self:CloseSelf()
    return
  end
  TeamPwsMatchPopUp.Instance = self
  self:FindObjs()
  self:AddButtonEvts()
  self:AddEvts()
  TeamPwsMatchPopUp.Show(self.viewdata.viewdata.pvptype)
end

function TeamPwsMatchPopUp:FindObjs()
  self.objLayoutLeader = self:FindGO("layoutLeader")
  self.objLayoutMember = self:FindGO("layoutMember")
  self.labTime = self:FindComponent("labTime", UILabel)
  self.labTip = self:FindComponent("labTip", UILabel)
  self.labMatching = self:FindComponent("labMatching", UILabel)
  self.labWaiting = self:FindComponent("labWaiting", UILabel)
  self.btnGo = self:FindGO("btnGo"):GetComponent(UIButton)
  self.goLabel = self:FindGO("Label", self.btnGo.gameObject):GetComponent(UILabel)
  self.goSp = self.btnGo.gameObject:GetComponent(UISprite)
  self.btnCancel = self:FindGO("btnCancel")
  self.btnMin = self:FindGO("btnMin")
  self.btnGrid = self:FindGO("btnGrid"):GetComponent(UIGrid)
  self:InitPwsChampionCancelBtn()
end

function TeamPwsMatchPopUp:InitPwsChampionCancelBtn()
  self.pwsChampionCancelRoot = self:FindGO("TeamPwsChampionCancelRoot")
  self.pwsChampionCancelBtn = self:FindGO("TeamPwsChampionCancelBtn", self.pwsChampionCancelRoot)
  self:AddClickEvent(self.pwsChampionCancelBtn, function()
    self:ClickBtnCancel()
  end)
end

function TeamPwsMatchPopUp:UpdatePwsChampionCancelBtn()
  self.pwsChampionCancelRoot:SetActive(PvpProxy.CheckCanCancel(self.pvpType))
end

function TeamPwsMatchPopUp:AddButtonEvts()
  self:AddClickEvent(self.btnCancel, function()
    self:ClickBtnCancel()
  end)
  self:AddClickEvent(self:FindGO("Mask"), function()
    TeamPwsMatchPopUp.Hide()
  end)
  self:AddClickEvent(self.btnGo.gameObject, function()
    self:ClickBtnGO()
  end)
  self:AddClickEvent(self.btnMin, function()
    TeamPwsMatchPopUp.Hide()
  end)
end

function TeamPwsMatchPopUp:AddEvts()
  self:AddListenEvt(ServiceEvent.MatchCCmdNtfMatchInfoCCmd, self.HandleNtfMatchInfoCCmd)
  self:AddListenEvt(ServiceEvent.MatchCCmdSyncMatchInfoCCmd, self.HandleNtfMatchInfoCCmd)
  self:AddListenEvt(ServiceEvent.MatchCCmdMidMatchPrepareMatchCCmd, self.SetLayout)
  self:AddListenEvt(ServiceEvent.MatchCCmdTeamPwsPreInfoMatchCCmd, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamDataUpdate, self.SetLayout)
  self:AddListenEvt(PVPEvent.TeamPws_Launch, self.CloseSelf)
  self:AddListenEvt(PVEEvent.ExpRaid_Launch, self.CloseSelf)
  self:AddListenEvt(PVPEvent.TeamPwsOthello_Launch, self.CloseSelf)
  self:AddListenEvt(PVPEvent.TeamTwelve_Launch, self.CloseSelf)
end

function TeamPwsMatchPopUp:SetLayout()
  local inpreparation = PvpProxy.Instance:IsInPreparation()
  self.labTip.text = inpreparation and ZhString.TeamPws_InPreparing or ZhString.TeamPws_Matching
  self.labMatching.text = inpreparation and ZhString.MidMatching_Title or PvpProxy.Instance:GetTypeName()
  local bImLeader = not TeamProxy.Instance:IHaveTeam() or TeamProxy.Instance:CheckIHaveLeaderAuthority()
  local ispvpChamption = self.pvpType == PvpProxy.Type.TwelvePVPChampion or self.pvpType == PvpProxy.Type.TeamPwsChampion
  self.objLayoutLeader:SetActive(bImLeader and not inpreparation and not ispvpChamption)
  local matchid = PvpProxy.Instance:GetMatchID()
  local robot_rest_time, robot_match_time
  robot_rest_time, robot_match_time = PvpProxy.Instance:GetRobotTime(self.pvpType)
  local is_robot_match = robot_rest_time ~= 0 or robot_match_time ~= 0
  if Table_MatchRaid[matchid] and Table_MatchRaid[matchid].RobotAttrRate and is_robot_match then
    self:SetRobotTimeLayout()
  else
    self:SetNormalLayout()
  end
  self:UpdatePwsChampionCancelBtn()
end

function TeamPwsMatchPopUp:SetRobotTimeLayout()
  self.btnGo.gameObject:SetActive(true)
  self.btnGrid:Reposition()
end

function TeamPwsMatchPopUp:SetNormalLayout()
  self.labWaiting.text = ""
  self.btnGo.gameObject:SetActive(false)
  self.btnGrid:Reposition()
end

function TeamPwsMatchPopUp:HandleNtfMatchInfoCCmd(note)
  if note.body.etype == self.pvpType and note.body.ismatch then
    self:CountMatchingTime()
  else
    self:CloseSelf()
  end
end

function TeamPwsMatchPopUp:CountMatchingTime()
  TimeTickManager.Me():ClearTick(self, 1)
  self.startMatchTime = PvpProxy.Instance:GetStartMatchTime(self.pvpType)
  if self.startMatchTime then
    TimeTickManager.Me():CreateTick(0, 250, self.UpdateMatchingTime, self, 1)
  else
    self.labTime.text = "-"
  end
end

function TeamPwsMatchPopUp:CancelValid()
  if not self.pvpType then
    return false
  end
  if PvpProxy.CheckCanCancel(self.pvpType) then
    return true
  end
  if TeamProxy.Instance:IHaveTeam() and not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
    return false
  end
  return true
end

function TeamPwsMatchPopUp:ClickBtnCancel()
  if self.disableClick then
    return
  end
  if not self:CancelValid() then
    return
  end
  ServiceMatchCCmdProxy.Instance:CallLeaveRoomCCmd(self.pvpType)
  self.disableClick = true
  self.ltDisableClick = TimeTickManager.Me():CreateOnceDelayTick(3000, function(owner, deltaTime)
    self.disableClick = false
    self.ltDisableClick = nil
  end, self, 100)
end

local matchingTime

function TeamPwsMatchPopUp:UpdateMatchingTime()
  if self.pvpType == PvpProxy.Type.TwelvePVPChampion or self.pvpType == PvpProxy.Type.TeamPwsChampion then
    matchingTime = self.startMatchTime - ServerTime.CurServerTime() / 1000
  else
    matchingTime = (ServerTime.CurServerTime() - self.startMatchTime) / 1000
  end
  local min, sec = ClientTimeUtil.GetFormatSecTimeStr(matchingTime)
  self.labTime.text = string.format("%02d:%02d", min, sec)
  self:UpdateRobotTime()
end

function TeamPwsMatchPopUp:ClickBtnGO()
  if not self.btnGo.enabled then
    MsgManager.ShowMsgByID(28111)
    return
  end
  if TeamProxy.Instance:IHaveTeam() and not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
    return
  end
  MsgManager.ConfirmMsgByID(28110, function()
    ServiceMatchCCmdAutoProxy:CallJoinRaidWithRobotMatchCCmd(self.pvpType)
    self:CloseSelf()
  end)
end

local lefttime = 0
local spriteName = {"com_btn_3", "com_btn_13"}
local effectColor = {
  ColorUtil.ButtonLabelGreen,
  ColorUtil.NGUIGray
}
local curTime = 0

function TeamPwsMatchPopUp:UpdateRobotTime()
  self.robot_rest_time, self.robot_match_time = PvpProxy.Instance:GetRobotTime(self.pvpType)
  curTime = ServerTime.CurServerTime() / 1000
  if self.robot_rest_time ~= 0 and curTime <= self.robot_rest_time then
    lefttime = self.robot_rest_time - curTime
    self.labWaiting.text = string.format(ZhString.RobotMatch_InRest, lefttime)
    self.btnGo.enabled = false
    self.goLabel.effectColor = effectColor[2]
    self.goSp.spriteName = spriteName[2]
  elseif self.robot_match_time ~= 0 then
    lefttime = self.robot_match_time - curTime
    if lefttime <= 0 then
      self.labWaiting.text = ZhString.RobotMatch_ReadyToGo
      if self.goSp.spriteName ~= spriteName[1] then
        self.goSp.spriteName = spriteName[1]
        self.btnGo.enabled = true
        self.goLabel.effectColor = effectColor[1]
      end
    else
      self.labWaiting.text = string.format(ZhString.RobotMatch_InMatch, lefttime)
      if self.goSp.spriteName ~= spriteName[2] then
        self.btnGo.enabled = false
        self.goLabel.effectColor = effectColor[2]
        self.goSp.spriteName = spriteName[2]
      end
    end
  end
end

function TeamPwsMatchPopUp:OnShow()
  TeamPwsMatchPopUp.super.OnShow(self)
  if not PvpProxy.Instance:GetCurMatchStatus() then
    return
  end
  self:SetLayout()
  self:CountMatchingTime()
end

function TeamPwsMatchPopUp:OnHide()
  TimeTickManager.Me():ClearTick(self, 1)
  TeamPwsMatchPopUp.super.OnHide(self)
end

function TeamPwsMatchPopUp:OnExit()
  TimeTickManager.Me():ClearTick(self, 1)
  if self.ltDisableClick then
    self.ltDisableClick:Destroy()
    self.ltDisableClick = nil
  end
  TeamPwsMatchPopUp.Instance = nil
  TeamPwsMatchPopUp.super.OnExit(self)
end
