local _Vec_zero = LuaVector3.Zero()
local _Vec_one = LuaVector3.One()
local _TweenDuration = 0.2
local _Color_Green = ColorUtil.ButtonLabelGreen
local _Color_Red = LuaColor.New(0.49411764705882355, 0.027450980392156862, 0.01568627450980392, 1)
local _Color_Gray = ColorUtil.NGUIGray
autoImport("BaseView")
autoImport("PveInvitePlayerCell")
PveGroupInvitePopUp = class("PveGroupInvitePopUp", BaseView)
PveGroupInvitePopUp.ViewType = UIViewType.PopUpLayer
PveGroupInvitePopUp.Instance = nil
PveGroupInvitePopUp.Anchor = nil

function PveGroupInvitePopUp.Show(groupraidType)
  if not PveGroupInvitePopUp.Instance then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PveGroupInvitePopUp,
      viewdata = {groupraidtype = groupraidType}
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

function PveGroupInvitePopUp:Init()
  if PveGroupInvitePopUp.Instance then
    self:CloseSelf()
    return
  end
  PveGroupInvitePopUp.Instance = self
  self.disableClick = false
  self:FindObj()
  self:AddButtonEvt()
  self:AddViewEvt()
end

function PveGroupInvitePopUp:OnEnter()
  self.super.OnEnter(self)
  self.configid = FunctionPve.Me():GetCurDifficulty()
  PveGroupInvitePopUp.Show(self.configid)
  local uniteTeam = TeamProxy.Instance:GetGroupUniteTeamData()
  if TeamProxy.Instance:IHaveGroup() and not uniteTeam then
    ServiceSessionTeamProxy.Instance:CallQueryMemberTeamCmd(TeamProxy.Instance.myTeam.uniteteamid)
  end
end

function PveGroupInvitePopUp:OnShow()
  self.super.OnShow(self)
  self.configid = FunctionPve.Me():GetCurDifficulty()
  local diffConfig = GameConfig.Pve and GameConfig.Pve.Difficulty and GameConfig.Pve.Difficulty[1]
  local diff = diffConfig and diffConfig[self.configid] or ""
  self.labMatch.text = string.format(ZhString.Thanatos_EnterView, diff)
  if TeamProxy.Instance:CheckIHaveGroupLeaderAuthority() then
    self.cancelBtnLab.text = ZhString.Pve_Invite_Cancel
    self.readyBtnLab.text = ZhString.Pve_Invite_Go
  else
    self.cancelBtnLab.text = ZhString.Thanatos_NotReady
    self.readyBtnLab.text = ZhString.Thanatos_GetReady
  end
  if not self.disableClick then
    self.cancelBtn.isEnabled = true
    self.readyBtn.isEnabled = true
    self:SetLabel(self.cancelBtnLab, _Color_Red)
    self:SetLabel(self.readyBtnLab, _Color_Green)
  end
end

function PveGroupInvitePopUp:OnHide()
  self.super.OnHide(self)
end

function PveGroupInvitePopUp:OnExit()
  TimeTickManager.Me():ClearTick(self, 1)
  PveGroupInvitePopUp.Instance = nil
  self.super.OnExit(self)
end

function PveGroupInvitePopUp:FindObj()
  self.gridMyTeam = self:FindComponent("gridMyTeam", UIGrid)
  self.listMyTeam = UIGridListCtrl.new(self.gridMyTeam, PveInvitePlayerCell, "PveInvitePlayerCell")
  local gridGroupTeam = self:FindComponent("gridGroupTeam", UIGrid)
  self.listGroupTeam = UIGridListCtrl.new(gridGroupTeam, PveInvitePlayerCell, "PveInvitePlayerCell")
  self.sliderCountDown = self:FindComponent("SliderCountDown", UISlider)
  self.labCountDown = self:FindComponent("labCountDown", UILabel)
  self.cancelBtn = self:FindComponent("cancelBtn", UIButton)
  self.readyBtn = self:FindComponent("readyBtn", UIButton)
  self.cancelBtnLab = self:FindComponent("Label", UILabel, self.cancelBtn.gameObject)
  self.readyBtnLab = self:FindComponent("Label", UILabel, self.readyBtn.gameObject)
  self.labMatch = self:FindComponent("labMatchSuccess", UILabel)
end

function PveGroupInvitePopUp:AddButtonEvt()
  self:AddClickEvent(self:FindGO("BtnMin"), function()
    PveGroupInvitePopUp.Hide()
  end)
  self:AddClickEvent(self.readyBtn.gameObject, function()
    if TeamProxy.Instance:CheckIHaveGroupLeaderAuthority() then
      ServiceTeamGroupRaidProxy.Instance:CallOpenGroupRaidTeamCmd()
      self:CloseSelf()
    else
      if not self.disableClick then
        self.disableClick = true
        ServiceTeamGroupRaidProxy.Instance:CallReplyGroupJoinRaidTeamCmd(true)
      end
      self.readyBtn.isEnabled = false
      self.cancelBtn.isEnabled = false
      self:SetLabel(self.cancelBtnLab, _Color_Gray)
      self:SetLabel(self.readyBtnLab, _Color_Gray)
    end
  end)
  self:AddClickEvent(self.cancelBtn.gameObject, function()
    if not self.disableClick then
      self.disableClick = true
    end
    if TeamProxy.Instance:CheckIHaveGroupLeaderAuthority() then
      ServiceTeamGroupRaidProxy.Instance:CallInviteGroupJoinRaidTeamCmd(true)
    else
      ServiceTeamGroupRaidProxy.Instance:CallReplyGroupJoinRaidTeamCmd(false)
    end
    self.cancelBtn.isEnabled = false
    self.readyBtn.isEnabled = false
    self:SetLabel(self.cancelBtnLab, _Color_Gray)
    self:SetLabel(self.readyBtnLab, _Color_Gray)
  end)
end

function PveGroupInvitePopUp:SetLabel(lable, color)
  lable.effectColor = color
end

function PveGroupInvitePopUp:AddViewEvt()
  self:AddListenEvt(ServiceEvent.ReplyInvite, self.UpdateStatusByCharID)
  self:AddListenEvt(PVEEvent.CancelInvite, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamMemberUpdate, self.UpdateGroupUniteTeamMembers)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamDataUpdate, self.UpdateGroupUniteTeamMembers)
  self:AddListenEvt(ServiceEvent.SessionTeamMemberDataUpdate, self.UpdateGroupUniteTeamMembers)
  self:AddListenEvt(ServiceEvent.SessionTeamQueryMemberTeamCmd, self.UpdateGroupUniteTeamMembers)
end

function PveGroupInvitePopUp:InitData()
  self:StartCountDown()
  if TeamProxy.Instance:CheckIHaveGroupLeaderAuthority() then
    self.cancelBtnLab.text = ZhString.Thanatos_CancelJoin
    self.readyBtnLab.text = ZhString.Thanatos_Join
  else
    self.cancelBtnLab.text = ZhString.Thanatos_NotReady
    self.readyBtnLab.text = ZhString.Thanatos_GetReady
  end
  self:UpdateTeamInfo()
end

function PveGroupInvitePopUp:UpdateTeamInfo()
  self:UpdateTeam()
  self:TryUpdateReply()
end

function PveGroupInvitePopUp:UpdateTeam()
  local myTeam = TeamProxy.Instance.myTeam
  local uniteTeam = TeamProxy.Instance:GetGroupUniteTeamData()
  self:SetTeamList(self.listMyTeam, myTeam)
  self:SetTeamList(self.listGroupTeam, uniteTeam)
end

function PveGroupInvitePopUp:UpdateGroupUniteTeamMembers()
  self:InitData()
end

function PveGroupInvitePopUp:TryUpdateReply()
  local replymap = FunctionPve.Me():GetPlayerReplyMap()
  if replymap then
    for k, v in pairs(replymap) do
      if not self:TryUpdateData(k, v, self.listMyTeam) then
        self:TryUpdateData(k, v, self.listGroupTeam)
      end
    end
  end
end

function PveGroupInvitePopUp:StartCountDown()
  self.endPrepareTime = FunctionPve.Me():GetReadyEndTime()
  TimeTickManager.Me():CreateTick(0, 33, self.UpdateCountDown, self, 1)
end

function PveGroupInvitePopUp:UpdateCountDown()
  local leftTime = math.max((self.endPrepareTime - ServerTime.CurServerTime()) / 1000, 0)
  self.labCountDown.text = string.format("%ss", math.ceil(leftTime))
  self.sliderCountDown.value = leftTime / FunctionPve.MaxPrepareTime()
  if 0 == leftTime then
    TimeTickManager.Me():ClearTick(self, 1)
    FunctionPve.Me():DoTimeUp()
  end
end

function PveGroupInvitePopUp:SetTeamList(ctl, teamdata)
  local members = teamdata and teamdata:GetPlayerMemberList(true, true) or _EmptyTable
  ctl:ResetDatas(members, nil, true)
end

function PveGroupInvitePopUp:UpdateStatusByCharID(note)
  if note and note.body and not self:TryUpdateData(note.body.charid, note.body.reply, self.listMyTeam) then
    self:TryUpdateData(note.body.charid, note.body.reply, self.listGroupTeam)
  end
end

function PveGroupInvitePopUp:UpdateUI(note)
  if note and note.body and note.body.iscancel then
    self:CloseSelf()
  end
end

function PveGroupInvitePopUp:TryUpdateData(charID, reply, list)
  local cell
  if not charID then
    return false
  end
  local cells = list:GetCells()
  for i = 1, #cells do
    cell = cells[i]
    if cell.charID == charID then
      cell:UpdateReadyStatus(reply)
      return true
    end
  end
  return false
end
