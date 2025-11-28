local BaseCell = autoImport("BaseCell")
CollapseTreeCell = class("CollapseTreeCell", BaseCell)

function CollapseTreeCell:Init()
  self:FindObjs()
end

function CollapseTreeCell:FindObjs()
  self.playTween = self.gameObject:GetComponent(UIPlayTween)
  self.headerGO = self:FindGO("Header")
  self:AddClickEvent(self.headerGO, function()
    self:SetCollapsed(not self.collapsed)
  end)
  self.title = self:FindComponent("Title", UILabel, self.headerGO)
  self.contentGO = self:FindGO("Content")
  local contentContainerGO = self:FindGO("Container")
  self.contentContainer = contentContainerGO:GetComponent(UITable)
  if self.contentContainer == nil then
    self.contentContainer = contentContainerGO:GetComponent(UIGrid)
  end
  self.contentBg = self:FindComponent("ContentBG", UISprite, self.contentGO)
end

function CollapseTreeCell:SetData(data)
  self.data = data
  self.title.text = data.name or ""
  if not self.contentCtrl then
    self.contentCtrl = ListCtrl.new(self.contentContainer, data.cellCtrl, data.cellPrefab)
    self.contentCtrl:SetNoScrollView(true)
  end
  if self.contentCtrl then
    self.contentCtrl:ResetDatas(data.datas)
    self.contentCtrl:AddEventListener(MouseEvent.MouseClick, self.OnCellClicked, self)
  end
  if self.contentBg then
    local bound = NGUIMath.CalculateRelativeWidgetBounds(self.contentContainer.transform)
    self.contentBg.height = bound.size.y + (data.contentBgPadding or 0)
  end
end

function CollapseTreeCell:OnCellClicked(cell)
  self:PassEvent(MouseEvent.MouseClick, cell)
end

function CollapseTreeCell:SetCollapsed(b)
  if self.collapsed == b then
    return
  end
  self.collapsed = b
  EventDelegate.Set(self.playTween.onFinished, function()
    self:PassEvent(UICellEvent.OnCollapseFinished, self)
  end)
  self.playTween:Play(b)
  if self.contentCtrl then
    local cells = self.contentCtrl:GetCells()
    if cells then
      for _, cell in ipairs(cells) do
        if cell.OnCollapsed then
          cell:OnCollapsed(b)
        end
      end
    end
  end
end

function CollapseTreeCell:OnCellDestroy()
  if self.contentCtrl then
    self.contentCtrl:RemoveAll()
    self.contentCtrl = nil
  end
end
