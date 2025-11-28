autoImport("DesertWolfReportCell")
DesertWolfReportPanel = class("DesertWolfReportPanel", BaseView)
DesertWolfReportPanel.ColorRed = Color(1, 0.6862745098039216, 0.6862745098039216, 1)
DesertWolfReportPanel.ColorBlue = Color(0.6235294117647059, 0.796078431372549, 1, 1)

function DesertWolfReportPanel:ctor(parent)
  local viewPath = ResourcePathHelper.UIView("DesertWolf/DesertWolfReportPanel")
  DesertWolfReportPanel.super.ctor(self, self:LoadPreferb_ByFullPath(viewPath, parent, true))
end

function DesertWolfReportPanel:Init()
  self:FindObjs()
  self:ProcessReportTitles()
end

function DesertWolfReportPanel:FindObjs()
  self.objLoading = self:FindGO("LoadingRoot")
  self.objEmptyList = self:FindGO("EmptyList")
  local gridReport = self:FindComponent("reportContainer", UIGrid)
  self.listReports = UIGridListCtrl.new(gridReport, DesertWolfReportCell, "DesertWolf/DesertWolfReportCell")
end

function DesertWolfReportPanel:ProcessReportTitles()
  local parent = self:FindGO("ReportTitles")
  local objButton = self:FindGO("Title1", parent)
  self:ProcessLabelCollider(objButton)
  self:AddClickEvent(objButton, function()
    self:SortByKey("name")
  end)
  objButton = self:FindGO("Title2", parent)
  self:ProcessLabelCollider(objButton)
  self:AddClickEvent(objButton, function()
    self:SortByKey("kill")
  end)
  objButton = self:FindGO("Title3", parent)
  self:ProcessLabelCollider(objButton)
  self:AddClickEvent(objButton, function()
    self:SortByKey("death")
  end)
  objButton = self:FindGO("Title4", parent)
  self:ProcessLabelCollider(objButton)
  self:AddClickEvent(objButton, function()
    self:SortByKey("assist")
  end)
  objButton = self:FindGO("Title5", parent)
  self:ProcessLabelCollider(objButton)
  self:AddClickEvent(objButton, function()
    self:SortByKey("combo")
  end)
  objButton = self:FindGO("Title6", parent)
  self:ProcessLabelCollider(objButton)
  self:AddClickEvent(objButton, function()
    self:SortByKey("heal")
  end)
  objButton = self:FindGO("Title7", parent)
  self:ProcessLabelCollider(objButton)
  self:AddClickEvent(objButton, function()
    self:SortByKey("damage")
  end)
end

function DesertWolfReportPanel:ProcessLabelCollider(go)
  local label = go:GetComponent(UILabel)
  local boxCollider = go:GetComponent(BoxCollider)
  local width = label.printedSize.x
  local vec = boxCollider.size
  vec.x = width + math.min(math.max(label.width - width, 0), 10)
  boxCollider.size = vec
  vec = boxCollider.center
  vec.x = width / 2
  boxCollider.center = vec
end

function DesertWolfReportPanel:StartLoading()
  self.objLoading:SetActive(true)
end

function DesertWolfReportPanel:UpdateView()
  local stats = DesertWolfProxy.Instance:GetStats()
  if not stats then
    return
  end
  self.objLoading:SetActive(false)
  self.objEmptyList:SetActive(#stats < 1)
  if self.curLastCell then
    self.curLastCell:SetLineActive(true)
  end
  self.listReports:ResetDatas(stats)
  if 0 < #stats then
    local cells = self.listReports:GetCells()
    self.curLastCell = cells[#cells]
    self.curLastCell:SetLineActive(false)
  end
end

function DesertWolfReportPanel:SortByKey(key)
  DesertWolfProxy.Instance:SortStatsByKey(key)
  self:UpdateView()
end
