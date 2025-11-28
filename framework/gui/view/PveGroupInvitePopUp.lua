PveGroupInvitePopUp = class("PveGroupInvitePopUp", PveInvitePopUp)
PveGroupInvitePopUp.ViewType = UIViewType.PopUpLayer
PveGroupInvitePopUp.Instance = nil
PveGroupInvitePopUp.Anchor = nil
local _Vec_zero = LuaVector3.Zero()
local _Vec_one = LuaVector3.One()
local _TweenDuration = 0.2

function PveGroupInvitePopUp.Show()
  if not PveGroupInvitePopUp.Instance then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PveGroupInvitePopUp
    })
    return
  end
  if PveGroupInvitePopUp.Instance.isShow then
    return
  end
  if PveGroupInvitePopUp.Anchor and PveGroupInvitePopUp.Anchor.gameObject.activeInHierarchy then
    PveGroupInvitePopUp.Instance.trans.localScale = _Vec_zero
    PveGroupInvitePopUp.Instance.trans.position = PveGroupInvitePopUp.Anchor.position
    TweenPosition.Begin(PveGroupInvitePopUp.Instance.gameObject, _TweenDuration, _Vec_zero)
    TweenScale.Begin(PveGroupInvitePopUp.Instance.gameObject, _TweenDuration, _Vec_one)
  else
    PveGroupInvitePopUp.Instance.trans.localPosition = _Vec_zero
    PveGroupInvitePopUp.Instance.trans.localScale = _Vec_one
  end
  PveGroupInvitePopUp.Instance:OnShow()
  PveGroupInvitePopUp.Instance.isShow = true
  local uniteTeam = TeamProxy.Instance:GetGroupUniteTeamData()
  if TeamProxy.Instance:IHaveGroup() and uniteTeam then
    PveGroupInvitePopUp.Instance:InitData()
  end
end

function PveGroupInvitePopUp.Hide()
  if not PveGroupInvitePopUp.Instance or not PveGroupInvitePopUp.Instance.isShow then
    return
  end
  if PveGroupInvitePopUp.Anchor and PveGroupInvitePopUp.Anchor.gameObject.activeInHierarchy then
    TweenPosition.Begin(PveGroupInvitePopUp.Instance.gameObject, _TweenDuration, PveGroupInvitePopUp.Anchor.position).worldSpace = true
  end
  TweenScale.Begin(PveGroupInvitePopUp.Instance.gameObject, _TweenDuration, _Vec_zero)
  PveGroupInvitePopUp.Instance:OnHide()
  PveGroupInvitePopUp.Instance.isShow = false
end

function PveGroupInvitePopUp:OnShow()
  self.super.super.OnShow(self)
end

function PveGroupInvitePopUp:OnHide()
  self.super.super.OnHide(self)
end

function PveGroupInvitePopUp:Init()
  if PveGroupInvitePopUp.Instance then
    self:CloseSelf()
    return
  end
  PveGroupInvitePopUp.Instance = self
  self:FindObj()
  self:AddButtonEvt()
  self:AddClickEvent(self:FindGO("MinViewBtn"), function()
    PveGroupInvitePopUp.Hide()
  end)
  self:AddViewEvt()
end

function PveGroupInvitePopUp:OnEnter()
  self.super.super.OnEnter(self)
  PveGroupInvitePopUp.Show()
  local uniteTeam = TeamProxy.Instance:GetGroupUniteTeamData()
  if TeamProxy.Instance:IHaveGroup() and not uniteTeam then
    ServiceSessionTeamProxy.Instance:CallQueryMemberTeamCmd(TeamProxy.Instance.myTeam.uniteteamid)
  end
end

function PveGroupInvitePopUp:OnExit()
  TimeTickManager.Me():ClearTick(self, 1)
  PveGroupInvitePopUp.Instance = nil
  self.super.super.OnExit(self)
end

function PveGroupInvitePopUp:SetOptionalBtnText()
  self.memberReadyLab.text = ZhString.Thanatos_GetReady
  self.memberUnReadyLab.text = ZhString.Thanatos_NotReady
  self.cancelGoLab.text = ZhString.Thanatos_CancelJoin
  self.goLab.text = ZhString.Thanatos_Join
end

function PveGroupInvitePopUp:FindObj()
  self.super.FindObj(self)
  local gridGroupTeam = self:FindComponent("TeamGrid2", UIGrid)
  self.listGroupTeam = UIGridListCtrl.new(gridGroupTeam, PveInvitePlayerCell, "PveInvitePlayerCell")
end

function PveGroupInvitePopUp:AddViewEvt()
  self.super.AddViewEvt(self)
  self:AddListenEvt(ServiceEvent.SessionTeamQueryMemberTeamCmd, self.UpdateTeamInfo)
end

function PveGroupInvitePopUp:UpdateTeam()
  local myTeam = TeamProxy.Instance.myTeam
  local uniteTeam = TeamProxy.Instance:GetGroupUniteTeamData()
  self:_SetTeamList(self.listMyTeam, myTeam)
  self:_SetTeamList(self.listGroupTeam, uniteTeam)
end

function PveGroupInvitePopUp:TryUpdateReply()
  self:TryUpdateReplyStatus(self.listMyTeam)
  self:TryUpdateReplyStatus(self.listGroupTeam)
  self:UpdateBtn()
end

function PveGroupInvitePopUp:_SetTeamList(ctl, teamdata)
  local members = teamdata and teamdata:GetPlayerMemberList(true, true) or _EmptyTable
  ctl:ResetDatas(members, nil, true)
end
