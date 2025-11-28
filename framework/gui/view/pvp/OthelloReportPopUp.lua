autoImport("OthelloReportPanel")
OthelloReportPopUp = class("OthelloReportPopUp", BaseView)
OthelloReportPopUp.ViewType = UIViewType.PopUpLayer

function OthelloReportPopUp:Init()
  self:InitReportPanel()
  self:AddButtonEvt()
  self:AddViewEvt()
end

function OthelloReportPopUp:InitReportPanel()
  self.reportPanel = OthelloReportPanel.new(self:FindGO("ReportRoot"))
  redlog("InitReportPanel")
end

function OthelloReportPopUp:AddButtonEvt()
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

function OthelloReportPopUp:AddViewEvt()
  self:AddListenEvt(ServiceEvent.FuBenCmdQueryOthelloUserInfoFubenCmd, self.HandelQueryOthelloUserInfoFubenCmd)
  self:AddListenEvt(ServiceEvent.FuBenCmdOthelloReportFubenCmd, self.HandleOthelloReportFubenCmd)
end

function OthelloReportPopUp:HandelQueryOthelloUserInfoFubenCmd()
  redlog("HandelQueryOthelloUserInfoFubenCmd")
  self.reportPanel:InitData()
end

function OthelloReportPopUp:HandleOthelloReportFubenCmd()
  redlog("HandleOthelloReportFubenCmd")
  self:CloseSelf()
end

function OthelloReportPopUp:ClickButtonClose()
  PvpProxy.Instance:ClearOthelloReportData()
  self:CloseSelf()
end

function OthelloReportPopUp:OnEnter()
  self.super.OnEnter(self)
  self.reportPanel:StartLoading()
  ServiceFuBenCmdProxy.Instance:CallQueryOthelloUserInfoFubenCmd()
end

function OthelloReportPopUp:OnExit()
  self.super.OnExit(self)
end
