AsyncPvpRaidDiffToggleCell = class("AsyncPvpRaidDiffToggleCell", BaseCell)

function AsyncPvpRaidDiffToggleCell:Init()
  self:FindObjs()
end

function AsyncPvpRaidDiffToggleCell:FindObjs()
  self.toggle = self:FindComponent("Toggle", UIToggle)
  EventDelegate.Add(self.toggle.onChange, function()
    self.selected = self.toggle.value
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.nameLabel = self:FindComponent("Name", UILabel)
end

function AsyncPvpRaidDiffToggleCell:SetData(data)
  self.data = data
  if data then
    self.id = data.id
    self:SetSelect(data.selected)
    local config = GameConfig.GeffenMagic and GameConfig.GeffenMagic.Difficulties and GameConfig.GeffenMagic.Difficulties[self.id]
    self.nameLabel.text = config and config.Name or ""
  end
end

function AsyncPvpRaidDiffToggleCell:SetSelect(select)
  self.toggle.value = select or false
  self.selected = self.toggle.value
end
