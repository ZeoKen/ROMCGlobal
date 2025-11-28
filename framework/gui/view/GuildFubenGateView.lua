autoImport("GuildFubenGateCell")
GuildFubenGateView = class("GuildFubenGateView", ContainerView)
GuildFubenGateView.ViewType = UIViewType.NormalLayer

function GuildFubenGateView:Init()
  self:FindObjs()
  self:MapListenEvt()
  self:InitUIView()
end

function GuildFubenGateView:FindObjs()
  self.titleLab = self:FindComponent("Title", UILabel)
  self.ScrollView = self:FindGO("ScrollView")
  self.scrollViewComp = self.ScrollView:GetComponent(UIScrollView)
  self.container = self:FindGO("Container")
end

function GuildFubenGateView:MapListenEvt()
  self:AddListenEvt(ServiceEvent.FuBenCmdUserGuildRaidFubenCmd, self.UpdataUI)
  self:AddListenEvt(ServiceEvent.SessionTeamMemberDataUpdate, self.UpdataUI)
  self:AddListenEvt(TeamEvent.MemberExitTeam, self.UpdataUI)
  self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.UpdataUI)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamDataUpdate, self.UpdataUI)
end

function GuildFubenGateView:CallBuildingSubmitCountGuildCmd(type)
  ServiceGuildCmdProxy.Instance:CallBuildingSubmitCountGuildCmd(type)
end

function GuildFubenGateView:InitUIView()
  self.titleLab.text = ZhString.GuildFubenGateView_Title
  if self.wrapHelper == nil then
    local wrapConfig = {
      wrapObj = self.container,
      pfbNum = 6,
      cellName = "GuildFubenGateCell",
      control = GuildFubenGateCell,
      dir = 2
    }
    self.wrapHelper = WrapCellHelper.new(wrapConfig)
    self.wrapHelper:AddEventListener(MouseEvent.MouseClick, self.OnClick, self)
  end
  self:UpdataUI()
end

function GuildFubenGateView:OnClick(cellCtl)
  if cellCtl and cellCtl.data then
    local num = GuildProxy.Instance:GetGuildTeamMembermateNumInRaid()
    if 0 < num then
      ServiceFuBenCmdProxy.Instance:CallGuildGateOptCmd(cellCtl.data.gatenpcid, FuBenCmd_pb.EGUILDGATEOPT_ENTER)
      self:CloseSelf()
    else
      cellCtl:EnterRaidOpenGateEff()
      if nil == self.timeTick then
        self.timeTick = TimeTickManager.Me():CreateTick(1500, 33, function()
          ServiceFuBenCmdProxy.Instance:CallGuildGateOptCmd(cellCtl.data.gatenpcid, FuBenCmd_pb.EGUILDGATEOPT_ENTER)
          self:CloseSelf()
        end, self, 1)
      end
    end
  end
end

function GuildFubenGateView:ClearTimeTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.timeTick = nil
  end
end

function GuildFubenGateView:UpdataUI()
  local data = GuildProxy.Instance:GetGuildGateInfoArray()
  if data then
    self.wrapHelper:UpdateInfo(data)
  end
  self.wrapHelper:ResetPosition()
end

function GuildFubenGateView:OnEnter()
  GuildFubenGateView.super.OnEnter(self)
end

function GuildFubenGateView:OnExit()
  self:ClearTimeTick()
  PictureManager.Instance:UnLoadUI()
  GuildFubenGateView.super.OnExit(self)
end
