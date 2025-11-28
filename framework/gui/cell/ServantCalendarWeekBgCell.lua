autoImport("ServantWeekIntervalCell")
ServantCalendarWeekBgCell = class("ServantCalendarWeekBgCell", ItemCell)
local CELL_HEIGHT_CFG = 220
local MIN_HEIGHT = 400

function ServantCalendarWeekBgCell:Init()
  self.bg = self.gameObject:GetComponent(UISprite)
  self.bgCollider = self.gameObject:GetComponent(BoxCollider)
  self.todayFlag = self:FindGO("TodayFlag")
  self:AddCellClickEvent()
  self:AddEvts()
end

function ServantCalendarWeekBgCell:AddEvts()
  self:AddClickEvent(self.bg.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function ServantCalendarWeekBgCell:SetData(data)
  self.data = data
  if data then
    self:Show(self.gameObject)
    local displayData = data:GetWeekDisplayData()
    if not displayData then
      return
    end
    local _, maxNum = ServantCalendarProxy.Instance:GetWeekConsoleData()
    maxNum = math.min(maxNum, 3)
    local calHeight = #displayData * CELL_HEIGHT_CFG + maxNum * 70
    self.bg.height = math.max(calHeight, MIN_HEIGHT)
    self.bg:ResizeCollider()
    self.bg.alpha = data:CheckTransparent() and 0.5 or 0.9
    self.todayFlag:SetActive(data:IsToday())
  else
    self:Hide(self.gameObject)
  end
end
