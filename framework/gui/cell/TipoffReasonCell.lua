local baseCell = autoImport("BaseCell")
TipoffReasonCell = class("TipoffReasonCell", baseCell)

function TipoffReasonCell:Init()
  TipoffReasonCell.super.Init(self)
  self:AddCellClickEvent()
  self:FindObj()
end

function TipoffReasonCell:FindObj()
  self.toggle = self.gameObject:GetComponent(UIToggle)
  self.reasonLab = self:FindComponent("Label", UILabel)
end

function TipoffReasonCell:SetData(data)
  self.data = data
  if not data then
    return
  end
  self.reasonLab.text = data.Name or ""
  self:SetTog()
end

function TipoffReasonCell:SetTog()
  local reasons = FunctionTipoff.Me():GetPlayerReasons()
  if not reasons then
    self.toggle.value = false
    return
  end
  self.toggle.value = nil ~= reasons[self.data.id]
end
