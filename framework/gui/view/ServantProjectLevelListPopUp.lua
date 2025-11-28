ServantProjectLevelListPopUp = class("ServantProjectLevelListPopUp", SubView)
autoImport("ServantProjectLevelCell")

function ServantProjectLevelListPopUp:Init()
  xdlog("ServantProjectLevelListPopUp")
  self:ReLoadPerferb("view/LevelListPopUp")
  self.trans:SetParent(self.container.recommendView.ProjectProgressPopup.transform, false)
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:InitData()
  self:InitShow()
end

function ServantProjectLevelListPopUp:FindObjs()
  self.scrollView = self:FindComponent("LevelScrollView", UIScrollView)
  self.levelTable = self:FindGO("LevelTable"):GetComponent(UITable)
  self.levelGridCtrl = UIGridListCtrl.new(self.levelTable, ServantProjectLevelCell, "ServantProjectLevelCell")
  self.panel = self.scrollView.panel
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  local bg = self:FindGO("Bg")
  local bgws = self:FindGO("Bg-ws")
  local btlb = self:FindGO("btm")
  bg:SetActive(false)
  bgws:SetActive(true)
  btlb:SetActive(false)
end

function ServantProjectLevelListPopUp:InitData()
  self:RefreshPage()
end

function ServantProjectLevelListPopUp:InitShow()
end

function ServantProjectLevelListPopUp:RefreshPage()
  local sss = SignIn21Proxy.Instance:GetProjectProgressList()
  self.levelGridCtrl:ResetDatas(sss)
  self:AdjustScrollView()
end

function ServantProjectLevelListPopUp:AddEvts()
end

function ServantProjectLevelListPopUp:AddMapEvts()
end

function ServantProjectLevelListPopUp:UpdatePage()
end

function ServantProjectLevelListPopUp:ReUnitData(datas)
end

function ServantProjectLevelListPopUp:OnActivate()
  self:UpdatePage()
end

function ServantProjectLevelListPopUp:SetActive(bool)
  if bool then
    self:Show()
  else
    self:Hide()
  end
end

function ServantProjectLevelListPopUp:OnMouseClick(data)
end

function ServantProjectLevelListPopUp:AdjustScrollView()
  self.scrollView:ResetPosition()
  local cells = self.levelGridCtrl:GetCells()
  local targetCell
  for i = 1, #cells do
    local cell = cells[i]
    if not cell:CheckIsFinish() then
      if not targetCell then
        targetCell = cell
      elseif targetCell.sortOrder > cell.sortOrder then
        targetCell = cell
      end
    end
  end
  if not targetCell then
    return
  end
  local bound = NGUIMath.CalculateRelativeWidgetBounds(self.panel.cachedTransform, targetCell.gameObject.transform)
  local offset = self.panel:CalculateConstrainOffset(bound.min, bound.max)
  offset = Vector3(0, offset.y, 0)
  self.scrollView:MoveRelative(offset)
end
