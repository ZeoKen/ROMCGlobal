EquipConvertAttributeCell = class("EquipConvertAttributeCell", CoreView)
local valueColorStr = "[c][ffc64a]%s[-][/c]"

function EquipConvertAttributeCell:ctor(obj)
  EquipConvertAttributeCell.super.ctor(self, obj)
  self:Init()
end

function EquipConvertAttributeCell:Init()
  self.label = self:FindComponent("Label", UILabel)
end

function EquipConvertAttributeCell:SetData(idValueData)
  local flag = idValueData ~= nil
  self.gameObject:SetActive(flag)
  if not flag then
    return
  end
  local randomEffectId, value = idValueData.id, idValueData.value or 0
  local sData = Table_EquipEffect[randomEffectId]
  local tAttrType, attrType = type(sData.AttrType)
  if tAttrType == "string" then
    attrType = sData.AttrType
  elseif tAttrType == "table" then
    attrType = tostring(sData.AttrType[1])
  end
  local attrConfig = Game.Config_PropName[attrType]
  value = math.abs(value)
  self.label.text = string.format(OverSea.LangManager.Instance():GetLangByKey(sData.Dsc), string.format(valueColorStr, attrConfig.IsPercent == 1 and value * 100 .. "%" or value))
end
