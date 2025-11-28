InheritSkillCostPointAttrCell = class("InheritSkillCostPointAttrCell", BaseCell)

function InheritSkillCostPointAttrCell:Init()
  self:FindObjs()
end

function InheritSkillCostPointAttrCell:FindObjs()
  self.nameLabel = self:FindComponent("Name", UILabel)
  self.attrLabel = self:FindComponent("Attr", UILabel)
end

local StrFormat = "+%s"

function InheritSkillCostPointAttrCell:SetData(data)
  if data then
    local config = Game.Config_PropName[data.name]
    if config then
      self.nameLabel.text = config.PropName .. ":"
      if config.IsPercent == 1 then
        self.attrLabel.text = string.format(StrFormat .. "%%", data.value * 100)
      else
        self.attrLabel.text = string.format(StrFormat, data.value)
      end
    end
  end
end
