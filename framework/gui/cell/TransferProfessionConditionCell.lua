local baseCell = autoImport("BaseCell")
TransferProfessionConditionCell = class("TransferProfessionConditionCell", baseCell)

function TransferProfessionConditionCell:Init()
  self.label = self.gameObject:GetComponent(UILabel)
  self.finishSymbol = self:FindGO("FinishSymbol")
  self.lockedSymbol = self:FindGO("LockedTip")
end

function TransferProfessionConditionCell:SetData(data)
  self.data = data
  self.label.text = data.Desc or ""
  if data.status then
    self.finishSymbol:SetActive(true)
    self.lockedSymbol:SetActive(false)
  else
    self.finishSymbol:SetActive(false)
    self.lockedSymbol:SetActive(true)
  end
end
