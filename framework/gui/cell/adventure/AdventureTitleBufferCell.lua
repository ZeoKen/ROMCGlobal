local baseCell = autoImport("BaseCell")
AdventureTitleBufferCell = class("AdventureTitleBufferCell", baseCell)

function AdventureTitleBufferCell:Init()
  self:initView()
end

function AdventureTitleBufferCell:initView()
  self.attrName = self:FindComponent("AttrName", UILabel)
  self.attrValue = self:FindComponent("AttrValue", UILabel)
end

function AdventureTitleBufferCell:SetData(data)
  local name = data[1]
  local value = data[2]
  local config = Game.Config_PropName[data[1]]
  if config ~= nil then
    local str = value
    if config.IsPercent == 1 then
      str = value * 100 .. "%"
    end
    self.attrName.text = config.PropName
    self.attrValue.text = "+" .. str
  else
    self.attrName.text = "can't not fine prop:" .. name
  end
end
