SevenRoyalFamilyTreeAttrCell = class("SevenRoyalFamilyTreeAttrCell", CoreView)

function SevenRoyalFamilyTreeAttrCell:ctor(obj)
  SevenRoyalFamilyTreeAttrCell.super.ctor(self, obj)
  self:Init()
end

function SevenRoyalFamilyTreeAttrCell:Init()
  self.label = self:FindComponent("Label", UILabel)
  self.amount = self:FindComponent("Amount", UILabel)
end

function SevenRoyalFamilyTreeAttrCell:SetData(data)
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  self.label.text = data.desc or ""
  local value = data.value
  local t = type(value)
  if t == "number" then
    self.amount.text = (0 < value and "+" or "") .. (data.isPercent and value * 100 .. "%" or value)
  elseif t == "string" then
    self.amount.text = value
  else
    self.amount.text = ""
  end
end
