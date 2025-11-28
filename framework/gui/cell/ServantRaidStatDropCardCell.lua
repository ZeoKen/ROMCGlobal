ServantRaidStatDropCardCell = class("ServantRaidStatDropCardCell", BaseCell)

function ServantRaidStatDropCardCell:Init()
  ServantRaidStatDropCardCell.super.Init()
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(ServantRaidStatEvent.DropCardCellClick, self)
  end)
  if not self.cardItem then
    local cardobj = self:LoadPreferb("cell/ItemCardCell", self.gameObject)
    self.cardItem = ItemCardCell.new(cardobj)
  end
end

function ServantRaidStatDropCardCell:SetData(data)
  self.data = data
  self.cardItem:SetData(data)
end
