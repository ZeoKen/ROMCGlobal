autoImport("ServantWeekActivityCell")
ServantWeekIntervalCell = class("ServantWeekIntervalCell", ItemCell)

function ServantWeekIntervalCell:Init()
  self.grid = self.gameObject:GetComponent(UIGrid)
  self.weekIntervalCtl = UIGridListCtrl.new(self.grid, ServantWeekActivityCell, "ServantWeekActivityCell")
end

function ServantWeekIntervalCell:SetData(data)
  self.data = data
  if data then
    self.gameObject:SetActive(true)
    local limitedDisplayData = {}
    for i = 1, math.min(#data, 3) do
      limitedDisplayData[#limitedDisplayData + 1] = data[i]
    end
    self.limitedFlag = 3 < #data
    self.weekIntervalCtl:ResetDatas(limitedDisplayData)
  else
    self.gameObject:SetActive(false)
  end
end

function ServantWeekIntervalCell:OnCellDestroy()
  self.weekIntervalCtl:Destroy()
end
