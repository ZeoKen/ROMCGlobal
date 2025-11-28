local baseCell = autoImport("BaseCell")
AncientUpgradeAttrCell = class("AncientUpgradeAttrCell", baseCell)

function AncientUpgradeAttrCell:Init()
  self:initView()
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function AncientUpgradeAttrCell:initView()
  self.oriAttr = self:FindComponent("OriAttr", UILabel)
  self.newMark = self:FindGO("NewMark")
end

function AncientUpgradeAttrCell:setIsSelected(isSelected)
end

function AncientUpgradeAttrCell:SetData(data)
  self.data = data
  if data == nil then
    self:Hide()
    return
  else
    self:Show()
  end
  if data.new then
    data.value = 9999
  end
  self.newMark:SetActive(data.new == true)
  local sData = Table_EquipEffect[data.id]
  if not sData then
    return
  end
  local tAttrType, attrType = type(sData.AttrType)
  if tAttrType == "string" then
    attrType = sData.AttrType
  elseif tAttrType == "table" then
    attrType = tostring(sData.AttrType[1])
  end
  local attrConfig = Game.Config_PropName[attrType]
  if not attrConfig then
    LogUtility.WarningFormat("Cannot find prop data by name = {0} with id = {1}", attrType or "", data.id)
    return
  end
  local str = ItemTipBaseCell.FormatRandomEffectStr(data.id, data.value, true)
  if data.new then
    str = string.gsub(str, "999900%%", "???")
  end
  self.oriAttr.text = str
end
