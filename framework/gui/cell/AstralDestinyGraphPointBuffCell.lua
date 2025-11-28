AstralDestinyGraphPointBuffCell = class("AstralDestinyGraphPointBuffCell", BaseCell)

function AstralDestinyGraphPointBuffCell:Init()
  self:FindObjs()
end

function AstralDestinyGraphPointBuffCell:FindObjs()
  self.nameLabel = self:FindComponent("Name", UILabel)
  self.valueLabel = self:FindComponent("Value", UILabel)
end

local StrFormat = "+%s"

function AstralDestinyGraphPointBuffCell:SetData(data)
  if data then
    local name = data.name
    local value = data.value
    local config = Game.Config_PropName[name]
    if config then
      self.nameLabel.text = config.PropName
      if config.IsPercent == 1 then
        self.valueLabel.text = string.format(StrFormat .. "%%", value * 100)
      else
        self.valueLabel.text = string.format(StrFormat, value)
      end
    end
  end
end
