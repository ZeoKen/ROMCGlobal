autoImport("ItemCell")
ItemCell_Gift = class("ItemCell_Gift", ItemCell)

function ItemCell_Gift:InitItemCell()
  ItemCell_Gift.super.InitItemCell(self)
  self.check = self:FindGO("Check")
end

function ItemCell_Gift:SetData(data)
  ItemCell_Gift.super.SetData(self, data)
  self.check:SetActive(data.isReceived or false)
end
