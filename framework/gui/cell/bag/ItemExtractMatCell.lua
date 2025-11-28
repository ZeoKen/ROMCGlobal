autoImport("MaterialSelectItemNewCell")
ItemExtractMatCell = class("ItemExtractMatCell", MaterialSelectItemNewCell)

function ItemExtractMatCell:InitCell()
  ItemExtractMatCell.super.InitCell(self)
  self.addIcon:SetActive(false)
end

function ItemExtractMatCell:UpdateSelect()
  local selectedCount = 0
  if self.selectedReference and type(self.data) == "table" then
    selectedCount = selectedCount + (BagItemCell.CheckData(self.data) and self.selectedReference[self.data.staticData.id] or 0)
  end
  self.selectedCount = selectedCount
  self:UpdateSelectedCount()
end

function ItemExtractMatCell:UpdateSelectedCount()
  self:HideMask()
  self.selected:SetActive(false)
  local hasData = BagItemCell.CheckData(self.data)
  self:TrySetShowDeselect(hasData and self.selectedCount > 0)
  self:SetFavoriteTipActive(false)
  if hasData then
    self:UpdateNumLabel(tostring(self.selectedCount))
  end
end
