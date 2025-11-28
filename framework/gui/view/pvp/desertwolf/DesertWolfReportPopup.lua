autoImport("DesertWolfReportPanel")
DesertWolfReportPopup = class("DesertWolfReportPopup", BaseView)
DesertWolfReportPopup.ViewType = UIViewType.PopUpLayer

function DesertWolfReportPopup:Init()
  self:InitReportPanel()
  self:AddButtonEvt()
  self:AddViewEvt()
end

function DesertWolfReportPopup:InitReportPanel()
  self.reportRootGO = self:FindGO("ReportRoot")
  self.reportPanel = DesertWolfReportPanel.new(self.reportRootGO)
end

function DesertWolfReportPopup:AddButtonEvt()
  self:AddClickEvent(self:FindGO("Mask"), function()
    self:ClickButtonClose()
  end)
  self:AddClickEvent(self:FindGO("BtnClose"), function()
    self:ClickButtonClose()
  end)
  self:AddClickEvent(self:FindGO("BtnLeave"), function()
    self:ClickButtonClose()
  end)
end

function DesertWolfReportPopup:AddViewEvt()
  self:AddListenEvt(DesertWolfEvent.OnStatChanged, self.OnStatChanged)
end

function DesertWolfReportPopup:OnStatChanged()
  if DesertWolfProxy.Instance.isEnd then
    self:CloseSelf()
  else
    self.reportPanel:UpdateView()
  end
end

function DesertWolfReportPopup:ClickButtonClose()
  self:CloseSelf()
end

function DesertWolfReportPopup:OnEnter()
  self.super.OnEnter(self)
  self.reportPanel:StartLoading()
  DesertWolfProxy.Instance:CallDesertWolfStatQuery()
end

function DesertWolfReportPopup:OnExit()
  DesertWolfProxy.Instance:Reset()
  self.super.OnExit(self)
end
