autoImport("ThanatosGuildCell")
ThanatosGuildRankView = class("ThanatosGuildRankView", ContainerView)
ThanatosGuildRankView.ViewType = UIViewType.PopUpLayer

function ThanatosGuildRankView:OnEnter()
  ThanatosGuildRankView.super.OnEnter(self)
  self.showdata = self.viewdata.viewdata
  self:InitShow()
end

function ThanatosGuildRankView:OnExit()
  self.listCtr:Destroy()
  ThanatosGuildRankView.super.OnExit(self)
end

function ThanatosGuildRankView:OnDestroy()
end

function ThanatosGuildRankView:Init()
  self:FindObjs()
  self:AddViewEvts()
end

function ThanatosGuildRankView:FindObjs()
  self.banner = self:FindGO("banner"):GetComponent(UITexture)
  self.listcell = self:FindGO("listcell"):GetComponent(UIGrid)
  self.listCtr = UIGridListCtrl.new(self.listcell, ThanatosGuildCell, "ThanatosGuildCell")
  local title = self:FindGO("title"):GetComponent(UISprite)
  IconManager:SetArtFontIcon("Guild_title_name", title)
end

function ThanatosGuildRankView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.TeamGroupRaidQueryGroupRaidKillGuildInfo, self.UpdateView)
end

function ThanatosGuildRankView:InitShow()
  if self.showdata and #self.showdata ~= 0 then
    self.listCtr:ResetDatas(self.showdata)
  end
end

function ThanatosGuildRankView:CloseSelf()
  self.super.CloseSelf(self)
end
