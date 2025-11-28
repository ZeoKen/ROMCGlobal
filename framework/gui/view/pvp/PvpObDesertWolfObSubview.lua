autoImport("PvpObSubview")
autoImport("PvpObDesertWolfBord")
PvpObDesertWolfObSubview = class("PvpObDesertWolfObSubview", PvpObSubview)

function PvpObDesertWolfObSubview:Init()
  PvpObDesertWolfObSubview.super.Init(self)
  self.infoPanel = PvpObDesertWolfBord.new(self.infoPanelContainerGO)
end

function PvpObDesertWolfObSubview:InitListenEvents()
  PvpObDesertWolfObSubview.super.InitListenEvents(self)
  self:AddDispatcherEvt(ServiceEvent.MatchCCmdNtfFightStatCCmd, self.UpdateBordInfo)
end

function PvpObDesertWolfObSubview:UpdateBordInfo()
  if not self.infoPanel then
    return
  end
  self.infoPanel:UpdateView()
  self.infoPanel:StartCountDown()
end

function PvpObDesertWolfObSubview:OnExit()
  PvpObDesertWolfObSubview.super.OnExit(self)
  if not self.infoPanel then
    return
  end
  self.infoPanel:Hide()
end
