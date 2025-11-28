local BaseCell = autoImport("BaseCell")
BWEventCell = class("BWEventCell", BaseCell)

function BWEventCell:Init()
  self.symbol = self:FindComponent("Symbol", UISprite)
  self.name = self:FindComponent("Name", UILabel)
  self.progress = self:FindComponent("Progress", UILabel)
  self:AddCellClickEvent()
end

function BWEventCell:SetData(data)
  if not data then
    self.gameObject:SetActive(true)
    return
  end
  IconManager:SetUIIcon(data:GetSymbol(), self.symbol)
  self.name.text = data:GetName()
end
