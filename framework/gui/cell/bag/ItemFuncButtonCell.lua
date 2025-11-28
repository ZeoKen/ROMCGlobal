local BaseCell = autoImport("BaseCell")
ItemFuncButtonCell = class("ItemFuncButtonCell", BaseCell)

function ItemFuncButtonCell:Init()
  self.bg = self:FindComponent("Background", UILabel)
  self.label = self:FindComponent("Label", UILabel)
  self:AddCellClickEvent()
end

function ItemFuncButtonCell:SetData(data)
  if data then
    self.data = data
    if data.name then
      self.label.text = tostring(data.name)
    end
  end
end
