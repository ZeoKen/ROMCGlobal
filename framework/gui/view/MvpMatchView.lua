MvpMatchView = class("MvpMatchView", ContainerView)
MvpMatchView.ViewType = UIViewType.NormalLayer

function MvpMatchView:Init()
  self:FindObjs()
  self:AddEvts()
  self:InitData()
  self:InitShow()
  self:AddCloseButtonEvent()
end

function MvpMatchView:FindObjs()
  self.title = self:FindComponent("title", UILabel)
  self.content1 = self:FindGO("content1"):GetComponent(UIRichLabel)
  self.content2 = self:FindGO("content2"):GetComponent(UIRichLabel)
  self.matchBtn = self:FindGO("MatchBtn")
  self.matchLabel = self:FindComponent("Label", UILabel, self.matchBtn)
  self.pic = self:FindGO("pic"):GetComponent(UITexture)
  self.ScrollView = self:FindGO("ScrollView"):GetComponent(UIScrollView)
  self.ContentTable = self:FindGO("Content"):GetComponent(UITable)
end

function MvpMatchView:AddEvts()
  self:AddClickEvent(self.matchBtn, function()
    self:ClickMatchButton()
  end)
  self:AddListenEvt(ServiceEvent.MatchCCmdJoinRoomCCmd, self.CloseSelf)
end

function MvpMatchView:InitData()
  self.dTitle = ZhString.MvpMatchView_title
  self.dContent1 = ZhString.MVPMatch_tip1
  self.dContent2 = string.format(ZhString.MVPMatch_tip2, GameConfig.MvpBattle.ActivityTime)
  self.dicon = "main_bg_MVP"
  self.dMatchLabel = ZhString.MvpMatchView_Match
end

function MvpMatchView:InitShow()
  self.title.text = self.dTitle
  self.content1.text = self.dContent1
  self.content2.text = self.dContent2
  self.matchLabel.text = self.dMatchLabel
  PictureManager.Instance:SetUI(self.dicon, self.pic)
  self.ContentTable:Reposition()
end

function MvpMatchView:ClickMatchButton()
  if PvpProxy.Instance:CheckMvpMatchValid() then
    if not TeamProxy.Instance:CheckDiffServerValidByPvpType(PvpProxy.Type.MvpFight) then
      MsgManager.ShowMsgByID(42041)
      return
    end
    ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(PvpProxy.Type.MvpFight)
  end
end

function MvpMatchView:OnExit()
  PictureManager.Instance:UnLoadUI(self.dicon, self.pic)
  MvpMatchView.super.OnExit(self)
end
