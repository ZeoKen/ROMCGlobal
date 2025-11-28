EquipStrengthenAttrCell = class("EquipStrengthenAttrCell", BaseCell)

function EquipStrengthenAttrCell:Init()
  self:FindObj()
end

function EquipStrengthenAttrCell:FindObj()
  self.attrName = self:FindComponent("Name", UILabel, self.gameObject)
  self.oldValue = self:FindComponent("OldValue", UILabel, self.gameObject)
  self.newValue = self:FindComponent("NewValue", UILabel, self.gameObject)
end

function EquipStrengthenAttrCell:SetData(data)
  self.data = data
  self.attrName.text = data.name
  self.oldValue.text = data.oldValue
  self.newValue.text = data.newValue
  local nameColor = data.isLv and "48a942ff" or "a1a1a1ff"
  local success, c = ColorUtil.TryParseHexString(nameColor)
  if success then
    self.attrName.color = c
    self.oldValue.color = c
  end
  local newValueColor = data.isLv and "48a942ff" or "a1a1a1ff"
  success, c = ColorUtil.TryParseHexString(newValueColor)
  if success then
    self.newValue.color = c
  end
end
