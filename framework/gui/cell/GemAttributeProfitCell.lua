GemAttributeProfitCell = class("GemAttributeProfitCell", CoreView)

function GemAttributeProfitCell:ctor(obj)
  GemAttributeProfitCell.super.ctor(self, obj)
  self:Init()
end

function GemAttributeProfitCell:Init()
  self.label = self:FindComponent("Name", UILabel)
  self.valueLabel = self:FindComponent("Value", UILabel)
end

function GemAttributeProfitCell:SetData(nameValueData)
  local flag = nameValueData ~= nil and next(nameValueData) ~= nil
  self.gameObject:SetActive(flag)
  if flag then
    self.data = nameValueData
  else
    self.data = nil
    return
  end
  self.label.text = nameValueData.name or ""
  self.valueLabel.text = nameValueData.value or ""
end
