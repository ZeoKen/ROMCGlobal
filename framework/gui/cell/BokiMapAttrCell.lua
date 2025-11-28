BokiMapAttrCell = class("BokiMapAttrCell", BaseItemCell)

function BokiMapAttrCell:Init()
  BokiMapAttrCell.super.Init(self)
  self.sp = self:FindComponent("ValueSp", UISprite)
  self.name = self:FindComponent("Name", UILabel)
  self.value = self:FindComponent("Value", UILabel)
end

function BokiMapAttrCell:SetData(data)
  self.data = data
  if not data then
    return
  end
  self.name.text = data.AttrName
  self.value.text = data.AttrDesc
  self.sp.spriteName = data.category == 1 and "tree_bg_yellow" or "tree_bg_blue"
end
