ServantProjectSmallCell = class("ServantProjectSmallCell", BaseCell)

function ServantProjectSmallCell:Init()
  self.selected = self:FindComponent("_selected", UILabel)
  self.normal = self:FindComponent("_normal", UILabel)
  self.red = self:FindGO("red")
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function ServantProjectSmallCell:SetData(data)
  self.data = data
  self.id = data.id
  self.selected.text = data.name
  self.normal.text = data.name
  self.red:SetActive(self.data.red and self.data.red == true)
end

function ServantProjectSmallCell:SetSelected(isTrue)
  if isTrue then
    self.selected.gameObject:SetActive(true)
    self.normal.gameObject:SetActive(false)
  else
    self.selected.gameObject:SetActive(false)
    self.normal.gameObject:SetActive(true)
  end
end
