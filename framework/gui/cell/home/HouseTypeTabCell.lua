HouseTypeTabCell = class("HouseTypeTabCell", BaseCell)

function HouseTypeTabCell:Init()
  self:FindObjs()
end

function HouseTypeTabCell:FindObjs()
  self.toggle = self.gameObject:GetComponent(UIToggle)
  EventDelegate.Add(self.toggle.onChange, function()
    self.selected = self.toggle.value
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.label1 = self:FindComponent("Label1", UILabel)
  self.label2 = self:FindComponent("Label2", UILabel)
end

function HouseTypeTabCell:SetData(data)
  self.data = data
  if data then
    self.label1.text = data.name
    self.label2.text = data.name
  end
end

function HouseTypeTabCell:ToggleOn()
  self.toggle.value = true
  self.selected = true
end
