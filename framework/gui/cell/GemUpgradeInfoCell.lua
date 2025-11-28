GemUpgradeInfoCell = class("GemUpgradeInfoCell", CoreView)
GemUpgradeInfoCellLabelNames = {
  "Desc",
  "Param1",
  "Param2"
}
local tempV3

function GemUpgradeInfoCell:ctor(obj)
  GemUpgradeInfoCell.super.ctor(self, obj)
  self:Init()
end

function GemUpgradeInfoCell:Init()
  self.labels = {}
  for _, name in pairs(GemUpgradeInfoCellLabelNames) do
    self:FindLabel(name)
  end
  self.collider = self.gameObject:GetComponent(BoxCollider)
  tempV3 = self.collider.size
end

function GemUpgradeInfoCell:SetData(data)
  self.data = data
  if not (data and data.key and data.beforeData) or not data.afterData then
    self.gameObject:SetActive(false)
    return
  end
  self.gameObject:SetActive(true)
  self:SetLabelText("Desc", data.key)
  self:SetLabelText("Param1", data.beforeData)
  self:SetLabelText("Param2", data.afterData)
  self:ResetColliderHeight()
end

function GemUpgradeInfoCell:FindLabel(goName)
  self.labels[self:GetLabelKey(goName)] = self:FindComponent(goName, UILabel)
end

function GemUpgradeInfoCell:SetLabelText(labelGOName, text)
  local labelKey = self:GetLabelKey(labelGOName)
  if not self.labels[labelKey] then
    return
  end
  self.labels[labelKey].text = text
end

function GemUpgradeInfoCell:ResetColliderHeight()
  local maxHeight = 16
  for _, label in pairs(self.labels) do
    if maxHeight < label.height then
      maxHeight = label.height
    end
  end
  tempV3.y = maxHeight + 2
  self.collider.size = tempV3
end

function GemUpgradeInfoCell:GetLabelKey(goName)
  return goName .. "Label"
end
