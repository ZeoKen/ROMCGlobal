autoImport("RecipeCell")
TicketPreviewCell = class("TicketPreviewCell", RecipeCell)

function TicketPreviewCell:InitCell()
  TicketPreviewCell.super.InitCell(self)
  self:SetEvent(self.itemCell.gameObject, function()
    self:PassEvent(EquipChooseCellEvent.ClickItemIcon, self)
  end)
end

function TicketPreviewCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  self.itemCell:SetData(data)
  self.itemCell.invalid:SetActive(not ShopMallProxy.Instance:JudgeSelfProfession(data.staticData.id))
  self.name.text = data.staticData.NameZh
  self.effect.gameObject:SetActive(false)
end
