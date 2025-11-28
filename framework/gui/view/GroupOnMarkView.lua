autoImport("BaseView")
autoImport("GroupPlayerCell")
GroupOnMarkView = class("GroupOnMarkView", BaseView)
GroupOnMarkView.ViewType = UIViewType.PopUpLayer
GroupOnMarkView.Instance = nil
GroupOnMarkView.Anchor = nil
local prepareTime = 30
local orange = LuaColor.New(0.6196078431372549, 0.33725490196078434, 0 / 255, 1)
local blue = LuaColor.New(0.14901960784313725, 0.24313725490196078, 0.5490196078431373, 1)
local grey = LuaColor.New(0.4235294117647059, 0.4235294117647059, 0.4235294117647059, 1)

function GroupOnMarkView.Show()
  if not GroupOnMarkView.Instance then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GroupOnMarkView
    })
    return
  end
  if GroupOnMarkView.Instance.isShow then
    return
  end
  if GroupOnMarkView.Anchor and GroupOnMarkView.Anchor.gameObject.activeInHierarchy then
    GroupOnMarkView.Instance.trans.localScale = LuaVector3.Zero()
    GroupOnMarkView.Instance.trans.position = GroupOnMarkView.Anchor.position
    TweenPosition.Begin(GroupOnMarkView.Instance.gameObject, 0.2, LuaVector3.Zero())
    TweenScale.Begin(GroupOnMarkView.Instance.gameObject, 0.2, LuaVector3.One())
  else
    GroupOnMarkView.Instance.trans.localPosition = LuaVector3.Zero()
    GroupOnMarkView.Instance.trans.localScale = LuaVector3.One()
  end
  GroupOnMarkView.Instance:OnShow()
  GroupOnMarkView.Instance.isShow = true
  local uniteTeam = TeamProxy.Instance:GetGroupUniteTeamData()
  if TeamProxy.Instance:IHaveGroup() and uniteTeam then
    GroupOnMarkView.Instance:InitData()
  end
end

function GroupOnMarkView.Hide()
  if not GroupOnMarkView.Instance or not GroupOnMarkView.Instance.isShow then
    return
  end
  if GroupOnMarkView.Anchor and GroupOnMarkView.Anchor.gameObject.activeInHierarchy then
    TweenPosition.Begin(GroupOnMarkView.Instance.gameObject, 0.2, GroupOnMarkView.Anchor.position).worldSpace = true
  end
  TweenScale.Begin(GroupOnMarkView.Instance.gameObject, 0.2, LuaVector3.Zero())
  GroupOnMarkView.Instance:OnHide()
  GroupOnMarkView.Instance.isShow = false
end

function GroupOnMarkView:Init()
  if GroupOnMarkView.Instance then
    self:CloseSelf()
    return
  end
  GroupOnMarkView.Instance = self
  self.disableClick = false
  self:FindObj()
  self:AddButtonEvt()
  self:AddViewEvt()
end

function GroupOnMarkView:OnEnter()
  GroupRaidProxy.Instance.delayOnMarkJump = false
  GroupOnMarkView.Show()
  local uniteTeam = TeamProxy.Instance:GetGroupUniteTeamData()
  ServiceSessionTeamProxy.Instance:CallQueryMemberTeamCmd(TeamProxy.Instance.myTeam.uniteteamid)
end

function GroupOnMarkView:OnShow()
  self.super.OnShow(self)
  if TeamProxy.Instance:CheckIHaveGroupLeaderAuthority() then
    self.readyBtn.gameObject:SetActive(false)
    self.cancelBtn.gameObject:SetActive(false)
    self.closeBtn.gameObject:SetActive(true)
  else
    self.readyBtn.gameObject:SetActive(true)
    self.cancelBtn.gameObject:SetActive(true)
    self.closeBtn.gameObject:SetActive(false)
  end
  self.cancelBtnLab.text = ZhString.GroupOnMark_MemberDeny
  self.readyBtnLab.text = ZhString.GroupOnMark_MemberConfirm
  if not self.disableClick then
    self.cancelBtn.isEnabled = true
    self.readyBtn.isEnabled = true
    self:SetLabel(self.cancelBtnLab, blue)
    self:SetLabel(self.readyBtnLab, orange)
  end
end

function GroupOnMarkView:OnHide()
  self.super.OnHide(self)
end

function GroupOnMarkView:OnExit()
  TimeTickManager.Me():ClearTick(self, 1)
  GroupOnMarkView.Instance = nil
  self.super.OnExit(self)
end

function GroupOnMarkView:CloseSelf()
  GroupRaidProxy.Instance:ResetGroupOnMarkStatus()
  self.super.CloseSelf(self)
end

function GroupOnMarkView:FindObj()
  self.gridMyTeam = self:FindComponent("gridMyTeam", UIGrid)
  self.listMyTeam = UIGridListCtrl.new(self.gridMyTeam, GroupPlayerCell, "GroupPlayerCell")
  local gridGroupTeam = self:FindComponent("gridGroupTeam", UIGrid)
  self.listGroupTeam = UIGridListCtrl.new(gridGroupTeam, GroupPlayerCell, "GroupPlayerCell")
  self.sliderCountDown = self:FindComponent("SliderCountDown", UISlider)
  self.labCountDown = self:FindComponent("labCountDown", UILabel)
  self.cancelBtn = self:FindGO("cancelBtn"):GetComponent(UIButton)
  self.readyBtn = self:FindGO("readyBtn"):GetComponent(UIButton)
  self.cancelBtnLab = self:FindGO("Label", self.cancelBtn.gameObject):GetComponent(UILabel)
  self.readyBtnLab = self:FindGO("Label", self.readyBtn.gameObject):GetComponent(UILabel)
  self.labMatch = self:FindGO("labMatchSuccess"):GetComponent(UILabel)
  self.closeBtn = self:FindGO("closeBtn"):GetComponent(UIButton)
end

function GroupOnMarkView:AddButtonEvt()
  self:AddClickEvent(self:FindGO("BtnMin"), function()
    GroupOnMarkView.Hide()
  end)
  self:AddClickEvent(self.readyBtn.gameObject, function()
    if not self.disableClick then
      self.disableClick = true
      ServiceTeamGroupRaidProxy.Instance:CallReplyConfirmRaidTeamGroupCmd(true)
    end
    self.readyBtn.isEnabled = false
    self.cancelBtn.isEnabled = false
    self:SetLabel(self.cancelBtnLab, grey)
    self:SetLabel(self.readyBtnLab, grey)
  end)
  self:AddClickEvent(self.cancelBtn.gameObject, function()
    if not self.disableClick then
      self.disableClick = true
    end
    ServiceTeamGroupRaidProxy.Instance:CallReplyConfirmRaidTeamGroupCmd(false)
    self.cancelBtn.isEnabled = false
    self.readyBtn.isEnabled = false
    self:SetLabel(self.cancelBtnLab, grey)
    self:SetLabel(self.readyBtnLab, grey)
    GameFacade.Instance:sendNotification(GroupOnMarkEvent.CloseMiniBtn)
    self:CloseSelf()
  end)
  self:AddClickEvent(self.closeBtn.gameObject, function()
    ServiceTeamGroupRaidProxy.Instance:CallInviteConfirmRaidTeamGroupCmd(true)
    self:CloseSelf()
  end)
end

function GroupOnMarkView:SetLabel(lable, color)
  lable.effectColor = color
  lable.effectStyle = UILabel.Effect.Outline
end

function GroupOnMarkView:AddViewEvt()
  self:AddListenEvt(ServiceEvent.SessionTeamQueryMemberTeamCmd, self.UpdateGroupUniteTeamMembers)
  self:AddListenEvt(ServiceEvent.TeamGroupRaidReplyConfirmRaidTeamGroupCmd, self.UpdateStatusByCharID)
  self:AddListenEvt(ServiceEvent.TeamGroupRaidInviteConfirmRaidTeamGroupCmd, self.UpdateUI)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamMemberUpdate, self.UpdateGroupUniteTeamMembers)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamDataUpdate, self.UpdateGroupUniteTeamMembers)
  self:AddListenEvt(ServiceEvent.SessionTeamMemberDataUpdate, self.UpdateGroupUniteTeamMembers)
  self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.HandleClose)
end

function GroupOnMarkView:InitData()
  self:StartCountDown()
  if TeamProxy.Instance:CheckIHaveGroupLeaderAuthority() then
    self.readyBtn.gameObject:SetActive(false)
    self.cancelBtn.gameObject:SetActive(false)
    self.closeBtn.gameObject:SetActive(true)
  else
    self.readyBtn.gameObject:SetActive(true)
    self.cancelBtn.gameObject:SetActive(true)
    self.closeBtn.gameObject:SetActive(false)
  end
  local myTeam = TeamProxy.Instance.myTeam
  local uniteTeam = TeamProxy.Instance:GetGroupUniteTeamData()
  local myselfID = Game.Myself.data.id
  local groupLeader = TeamProxy.Instance:GetGroupLeaderGuid(myTeam)
  groupLeader = groupLeader or TeamProxy.Instance:GetGroupLeaderGuid(uniteTeam)
  if myTeam:IsLeaderTeamInGroup() then
    self:SetTeam1(myTeam)
    self:SetTeam2(uniteTeam)
  else
    self:SetTeam1(uniteTeam)
    self:SetTeam2(myTeam)
  end
  self:TryUpdateData(groupLeader, true, self.listMyTeam)
  self:TryUpdateReply()
end

function GroupOnMarkView:UpdateGroupUniteTeamMembers()
  if not TeamProxy.Instance:IHaveGroup() then
    GameFacade.Instance:sendNotification(GroupOnMarkEvent.CloseMiniBtn)
    self:CloseSelf()
    return
  end
  self:InitData()
end

function GroupOnMarkView:TryUpdateReply()
  local replymap = GroupRaidProxy.Instance:GetOnMarkReplyMap()
  if replymap then
    for k, v in pairs(replymap) do
      if not self:TryUpdateData(k, v, self.listMyTeam) then
        self:TryUpdateData(k, v, self.listGroupTeam)
      end
    end
  end
end

function GroupOnMarkView:StartCountDown()
  self.startPrepareTime = GroupRaidProxy.Instance.startPrepareTime
  self.endPrepareTime = self.startPrepareTime + prepareTime * 1000
  local leftTime = math.max((self.endPrepareTime - ServerTime.CurServerTime()) / 1000, 0)
  self.sliderCountDown.value = leftTime / prepareTime
  TimeTickManager.Me():CreateTick(0, 33, self.UpdateCountDown, self, 1)
end

function GroupOnMarkView:UpdateCountDown()
  local leftTime = math.max((self.endPrepareTime - ServerTime.CurServerTime()) / 1000, 0)
  self.labCountDown.text = string.format("%ss", math.ceil(leftTime))
  self.sliderCountDown.value = leftTime / prepareTime
  if leftTime <= 0 then
    TimeTickManager.Me():ClearTick(self, 1)
    if not TeamProxy.Instance:CheckIHaveGroupLeaderAuthority() then
      ServiceTeamGroupRaidProxy.Instance:CallReplyConfirmRaidTeamGroupCmd(false)
    else
      ServiceTeamGroupRaidProxy.Instance:CallInviteConfirmRaidTeamGroupCmd(true)
    end
    GameFacade.Instance:sendNotification(GroupOnMarkEvent.CloseMiniBtn)
    self:CloseSelf()
  end
end

function GroupOnMarkView:SetTeam1(teamdata)
  local num = teamdata:GetPlayerMemberList(true, true)
  self.listMyTeam:ResetDatas(teamdata and teamdata:GetPlayerMemberList(true, true))
  self.listMyTeam:Layout()
end

function GroupOnMarkView:SetTeam2(teamdata)
  self.listGroupTeam:ResetDatas(teamdata and teamdata:GetPlayerMemberList(true, true))
  self.listGroupTeam:Layout()
end

function GroupOnMarkView:UpdateStatusByCharID(note)
  if note and note.body and not self:TryUpdateData(note.body.charid, note.body.reply, self.listMyTeam) then
    self:TryUpdateData(note.body.charid, note.body.reply, self.listGroupTeam)
  end
end

function GroupOnMarkView:HandleClose()
  self:CloseSelf()
end

function GroupOnMarkView:UpdateUI(note)
  if note and note.body and note.body.cancel then
    self:CloseSelf()
  end
end

function GroupOnMarkView:TryUpdateData(charID, reply, list)
  local cell
  if not charID then
    return false
  end
  local cells = list:GetCells()
  for i = 1, #cells do
    cell = cells[i]
    if cell.charID == charID then
      cell:SetStatus(reply)
      return true
    end
  end
  return false
end
