autoImport("TeamPwsFightResultPopUp")
autoImport("DesertWolfReportPanel")
DesertWolfFightResultPopup = class("DesertWolfFightResultPopup", TeamPwsFightResultPopUp)
DesertWolfFightResultPopup.ViewType = UIViewType.NormalLayer

function DesertWolfFightResultPopup:InitReportPanel()
  self.reportPanel = DesertWolfReportPanel.new(self:FindGO("ReportRoot"))
end

function DesertWolfFightResultPopup:HandleLoadScene()
  if not Game.MapManager:IsPvpMode_DesertWolf() then
    self:CloseSelf()
  end
end

function DesertWolfFightResultPopup:OnEnter()
  DesertWolfFightResultPopup.super.OnEnter(self)
end

function DesertWolfFightResultPopup:OnExit()
  DesertWolfProxy.Instance:Reset()
  DesertWolfFightResultPopup.super.OnExit(self)
end
