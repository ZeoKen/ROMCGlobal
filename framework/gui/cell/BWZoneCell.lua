local BaseCell = autoImport("BaseCell")
BWZoneCell = class("BWZoneCell", BaseCell)
autoImport("UIGridListCtrl")
autoImport("BWEventCell")
BWZoneCell.Event = {
  ClickArrow = "BWZoneCell.Event.ClickArrow",
  ClickArea = "BWZoneCell.Event.ClickArea",
  ClickEvent = "BWZoneCell.Event.ClickEvent"
}

function BWZoneCell:Init()
  self.areaName = self:FindComponent("AreaName", UILabel)
  self.progressLabel = self:FindComponent("Progress", UILabel)
  self.arrowTween = self:FindComponent("Arrow", TweenRotation)
  local arrowGO = self:FindGO("Arrow")
  self.arrowTween = arrowGO:GetComponent(TweenRotation)
  self:AddClickEvent(arrowGO, function(go)
    self:PassEvent(BWZoneCell.Event.ClickArrow, self)
  end)
  self.childrenTween = self:FindComponent("Children", TweenScale)
  local grid = self:FindComponent("Children", UIGrid)
  self.eventCtl = UIGridListCtrl.new(grid, BWEventCell, "BWEventCell")
  self.eventCtl:AddEventListener(MouseEvent.MouseClick, self.ClickEventCell, self)
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(BWZoneCell.Event.ClickArea, cell)
  end)
end

function BWZoneCell:ClickEventCell(cell)
  self:PassEvent(BWZoneCell.Event.ClickEvent, cell)
end

function BWZoneCell:SetData(data)
  if not data then
    self.gameObject:SetActive(false)
    return
  end
  self.areaName.text = data:GetName()
  self.progressLabel.text = string.format("%s/%s", data:GetProgress())
  self.eventCtl:ResetDatas(data:GetEvents())
end

function BWZoneCell:Toggle(val)
  self.toggle = val
  self.childrenTween.updateTable = true
  if val then
    self.arrowTween:ResetToBeginning()
    self.arrowTween:PlayForward()
    self.childrenTween:ResetToBeginning()
    self.childrenTween:PlayForward()
  else
    self.arrowTween:PlayReverse()
    self.childrenTween:PlayReverse()
  end
end
