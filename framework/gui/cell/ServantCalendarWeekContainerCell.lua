autoImport("ServantWeekIntervalCell")
ServantCalendarWeekContainerCell = class("ServantCalendarWeekContainerCell", ItemCell)

function ServantCalendarWeekContainerCell:Init()
  self:InitView()
end

function ServantCalendarWeekContainerCell:InitView()
  local grid = self.gameObject:GetComponent(UIGrid)
  self.weekIntervalCtl = UIGridListCtrl.new(grid, ServantWeekIntervalCell, "ServantWeekIntervalCell")
end

function ServantCalendarWeekContainerCell:SetData(data)
  self.data = data
  if data then
    self:Show(self.gameObject)
    local displayData = data:GetWeekDisplayData()
    if not displayData then
      return
    end
    self.weekIntervalCtl:ResetDatas(displayData)
  else
    self:Hide(self.gameObject)
  end
end

function ServantCalendarWeekContainerCell:UpdatePic(url, bytes)
  local cells = self.weekIntervalCtl:GetCells()
  for i = 1, #cells do
    cells[i]:UpdatePic(url, bytes)
  end
end

function ServantCalendarWeekContainerCell:OnCellDestroy()
  self.weekIntervalCtl:Destroy()
end
