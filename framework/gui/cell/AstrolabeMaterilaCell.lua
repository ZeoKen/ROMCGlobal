local BaseCell = autoImport("BaseCell")
AstrolabeMaterilaCell = class("AstrolabeMaterilaCell", BaseCell)

function AstrolabeMaterilaCell:Init()
  AstrolabeMaterilaCell.super.Init()
  self:FindObjs()
end

function AstrolabeMaterilaCell:FindObjs()
  self.icon = self.gameObject:GetComponent(UISprite)
  self.label = self:FindComponent("label", UILabel)
end

function AstrolabeMaterilaCell:SetData(data)
  self.id = data[1]
  self.num = data[2]
  IconManager:SetItemIcon(Table_Item[self.id].Icon, self.icon)
  self.label.text = StringUtil.NumThousandFormat(self.num)
end

function AstrolabeMaterilaCell:GetLabelWidth()
  return self.label.width + self.icon.width
end

function AstrolabeMaterilaCell:GetHeight()
  return self.icon.height
end

function AstrolabeMaterilaCell:SetLabelColor(c)
  self.label.color = c or ColorUtil.NGUIWhite
end

function AstrolabeMaterilaCell:SetIconSize(width, height)
  height = height or width or 0
  self.icon.width = width
  self.icon.height = height
end
