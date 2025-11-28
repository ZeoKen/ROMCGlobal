autoImport("BaseView")
autoImport("PveInvitePlayerCell")
PveInvitePopUp = class("PveInvitePopUp", BaseView)
PveInvitePopUp.ViewType = UIViewType.PopUpLayer
PveInvitePopUp.Instance = nil
PveInvitePopUp.Anchor = nil
local _Vec_zero = LuaVector3.Zero()
local _Vec_one = LuaVector3.One()
local _TweenDuration = 0.2
PveInvitePopUp.BtnConfig = {
  spriteName = {"com_btn_3", "com_btn_13"},
  effectColor = {
    ColorUtil.ButtonLabelGreen,
    ColorUtil.NGUIGray
  }
}

function PveInvitePopUp.Show()
  if not PveInvitePopUp.Instance then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PveInvitePopUp
    })
    return
  end
  if PveInvitePopUp.Instance.isShow then
    return
  end
  if PveInvitePopUp.Anchor and PveInvitePopUp.Anchor.gameObject.activeInHierarchy then
    PveInvitePopUp.Instance.trans.localScale = _Vec_zero
    PveInvitePopUp.Instance.trans.position = PveInvitePopUp.Anchor.position
    TweenPosition.Begin(PveInvitePopUp.Instance.gameObject, _TweenDuration, _Vec_zero)
    TweenScale.Begin(PveInvitePopUp.Instance.gameObject, _TweenDuration, _Vec_one)
  else
    PveInvitePopUp.Instance.trans.localPosition = _Vec_zero
    PveInvitePopUp.Instance.trans.localScale = _Vec_one
  end
  PveInvitePopUp.Instance:OnShow()
  PveInvitePopUp.Instance.isShow = true
  if TeamProxy.Instance:IHaveTeam() then
    PveInvitePopUp.Instance:InitData()
  end
end

function PveInvitePopUp.Hide()
  if not PveInvitePopUp.Instance or not PveInvitePopUp.Instance.isShow then
    return
  end
  if PveInvitePopUp.Anchor and PveInvitePopUp.Anchor.gameObject.activeInHierarchy then
    TweenPosition.Begin(PveInvitePopUp.Instance.gameObject, _TweenDuration, PveInvitePopUp.Anchor.position).worldSpace = true
  end
  TweenScale.Begin(PveInvitePopUp.Instance.gameObject, _TweenDuration, _Vec_zero)
  PveInvitePopUp.Instance:OnHide()
  PveInvitePopUp.Instance.isShow = false
end

function PveInvitePopUp:Init()
  if PveInvitePopUp.Instance then
    self:CloseSelf()
    return
  end
  PveInvitePopUp.Instance = self
  self:FindObj()
  self:AddButtonEvt()
  self:AddClickEvent(self:FindGO("MinViewBtn"), function()
    PveInvitePopUp.Hide()
  end)
  self:AddViewEvt()
end

function PveInvitePopUp:OnEnter()
  self.super.OnEnter(self)
  PveInvitePopUp.Show()
  local uniteTeam = TeamProxy.Instance:GetGroupUniteTeamData()
  if TeamProxy.Instance:IHaveGroup() and not uniteTeam then
    ServiceSessionTeamProxy.Instance:CallQueryMemberTeamCmd(TeamProxy.Instance.myTeam.uniteteamid)
  end
  self:PlayUISound(AudioMap.UI.MissionEnter)
end

function PveInvitePopUp:OnShow()
  self.super.OnShow(self)
end

function PveInvitePopUp:OnHide()
  self.super.OnHide(self)
end

function PveInvitePopUp:OnExit()
  TimeTickManager.Me():ClearTick(self, 1)
  PveInvitePopUp.Instance = nil
  self.super.OnExit(self)
end

function PveInvitePopUp:FindObj()
  self.gridMyTeam = self:FindComponent("TeamGrid1", UIGrid)
  self.listMyTeam = UIGridListCtrl.new(self.gridMyTeam, PveInvitePlayerCell, "PveInvitePlayerCell")
  self.sliderCD = self:FindComponent("SliderCD", UISlider)
  self.cdLab = self:FindComponent("CDLabel", UILabel)
  self.titleLab = self:FindGO("TitleLab"):GetComponent(UILabel)
  self.titleBg = self:FindComponent("Bg", UISprite, self.titleLab.gameObject)
  self.waitLabTip = self:FindComponent("FixedTipLab", UILabel)
  self.memberBtnRoot = self:FindGO("MemberBtnRoot")
  self.memberReadyBtn = self:FindComponent("MemberReadyBtn", UISprite, self.memberBtnRoot)
  self.memberReadColider = self.memberReadyBtn.gameObject:GetComponent(BoxCollider)
  self.memberReadyLab = self:FindComponent("Label", UILabel, self.memberReadyBtn.gameObject)
  self.memberUnReadyBtn = self:FindComponent("MemberUnReadyBtn", UISprite, self.memberBtnRoot)
  self.memberUnReadyLab = self:FindComponent("Label", UILabel, self.memberUnReadyBtn.gameObject)
  self.leaderBtnRoot = self:FindGO("LeaderBtnRoot")
  self.leaderCancelBtn = self:FindGO("LeaderCancelBtn", self.leaderBtnRoot)
  self.cancelGoLab = self:FindComponent("Label", UILabel, self.leaderCancelBtn)
  self.leaderGoBtn = self:FindComponent("LeaderGoBtn", UISprite, self.leaderBtnRoot)
  self.leadBoxColider = self.leaderGoBtn.gameObject:GetComponent(BoxCollider)
  self.goLab = self:FindComponent("Label", UILabel, self.leaderGoBtn.gameObject)
  self:SetOptionalBtnText()
end

function PveInvitePopUp:SetOptionalBtnText()
  self.memberReadyLab.text = ZhString.Pve_Invite_Ready
  self.memberUnReadyLab.text = ZhString.Pve_Invite_Cancel
  self.cancelGoLab.text = ZhString.Pve_Invite_Cancel
  self.goLab.text = ZhString.Pve_Invite_Go
end

function PveInvitePopUp:AddButtonEvt()
  self:AddClickEvent(self.memberReadyBtn.gameObject, function()
    FunctionPve.Me():DoReply(true)
  end)
  self:AddClickEvent(self.memberUnReadyBtn.gameObject, function()
    FunctionPve.Me():DoReply(false)
  end)
  self:AddClickEvent(self.leaderGoBtn.gameObject, function()
    FunctionPve.Me():DoEnter()
    self:CloseSelf()
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
  end)
  self:AddClickEvent(self.leaderCancelBtn, function()
    FunctionPve.Me():DoCancel()
  end)
end

function PveInvitePopUp:SetLabel(lable, color)
  lable.effectColor = color
  lable.effectStyle = UILabel.Effect.Outline
end

function PveInvitePopUp:AddViewEvt()
  self:AddListenEvt(PVEEvent.ReplyInvite, self.TryUpdateReply)
  self:AddListenEvt(PVEEvent.CancelInvite, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamMemberUpdate, self.UpdateTeamInfo)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamDataUpdate, self.UpdateTeamInfo)
  self:AddListenEvt(ServiceEvent.SessionTeamMemberDataUpdate, self.UpdateTeamInfo)
end

function PveInvitePopUp:InitData()
  self.titleLab.text = FunctionPve.Me():GetCurInviteingRaidName()
  self.titleBg.width = 150 + self.titleLab.width
  self:StartCountDown()
  self:UpdateTeamInfo()
end

function PveInvitePopUp:UpdateTeamInfo()
  local hasAuthority = FunctionPve.Me():HasLeaderAuthority()
  self.leaderBtnRoot:SetActive(hasAuthority)
  self.memberBtnRoot:SetActive(not hasAuthority)
  self:UpdateTeam()
  self:TryUpdateReply()
end

function PveInvitePopUp:TryUpdateReply()
  self:TryUpdateReplyStatus(self.listMyTeam)
  self:UpdateBtn()
  self.waitLabTip.text = FunctionPve.Me():GetMyReply() == true and ZhString.Pve_Invite_ReadyGO or ZhString.Pve_Invite_Wait
end

function PveInvitePopUp:UpdateBtn()
  self:UpdateLeaderGoBtn()
  self:UpdateMemberReadyBtn()
end

function PveInvitePopUp:UpdateMemberReadyBtn()
  local no_record = nil == FunctionPve.Me():GetMyReply()
  self.memberReadyBtn.spriteName = no_record and PveInvitePopUp.BtnConfig.spriteName[1] or PveInvitePopUp.BtnConfig.spriteName[2]
  self.memberReadyLab.effectColor = no_record and PveInvitePopUp.BtnConfig.effectColor[1] or PveInvitePopUp.BtnConfig.effectColor[2]
  self.memberReadColider.enabled = no_record
end

function PveInvitePopUp:UpdateLeaderGoBtn()
  local canEnter = FunctionPve.Me():CheckEnterValid()
  self.leaderGoBtn.spriteName = canEnter and PveInvitePopUp.BtnConfig.spriteName[1] or PveInvitePopUp.BtnConfig.spriteName[2]
  self.goLab.effectColor = canEnter and PveInvitePopUp.BtnConfig.effectColor[1] or PveInvitePopUp.BtnConfig.effectColor[2]
  self.leadBoxColider.enabled = canEnter
end

function PveInvitePopUp:StartCountDown()
  self.endReadyTime = FunctionPve.Me():GetReadyEndTime()
  TimeTickManager.Me():CreateTick(0, 33, self.UpdateCDTime, self, 1)
end

function PveInvitePopUp:UpdateCDTime()
  local leftTime = math.max(self.endReadyTime - ServerTime.CurServerTime() / 1000, 0)
  self.cdLab.text = string.format("%ss", math.ceil(leftTime))
  self.sliderCD.value = leftTime / FunctionPve.MaxPrepareTime()
  if leftTime == 0 then
    TimeTickManager.Me():ClearTick(self, 1)
    FunctionPve.Me():DoTimeUp()
    self:CloseSelf()
  end
end

function PveInvitePopUp:UpdateTeam()
  local teamdata = TeamProxy.Instance.myTeam
  self.listMyTeam:ResetDatas(teamdata and teamdata:GetPlayerMemberList(true, true))
  self.listMyTeam:Layout()
end

function PveInvitePopUp:TryUpdateReplyStatus(list)
  local cells = list:GetCells()
  for i = 1, #cells do
    cells[i]:UpdateReadyStatus()
  end
end
