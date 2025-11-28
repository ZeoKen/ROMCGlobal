autoImport("GuildFindPage")
GuildFindView = class("GuildFindView", ContainerView)
GuildFindView.ViewType = UIViewType.NormalLayer

function GuildFindView:Init()
  self.isGuildDate = self.viewdata.viewdata.isGuildDate
  GuildProxy.Instance:SetGuildDateBattleFind(self.isGuildDate)
  local findBord = self:FindGO("FindBord")
  if not self.guildFindPage then
    self.guildFindPage = self:AddSubView("GuildFindPage", GuildFindPage, findBord)
  end
  self:AddListenEvt(GuildDateBattleEvent.CloseGuildFindView, self.CloseSelf)
end

function GuildFindView:OnExit()
  GuildFindView.super.OnExit(self)
  if self.isGuildDate then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GuildDateBattleRecordView
    })
  end
  GuildProxy.Instance:SetGuildDateBattleFind(false)
end
