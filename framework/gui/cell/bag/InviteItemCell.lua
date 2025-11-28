autoImport("ItemCell")
InviteItemCell = class("InviteItemCell", ItemCell)
InviteItemCell.CellPartPathFolderName = "ItemCellParts"
InviteItemCell.DefaultNumLabelLocalPos = LuaVector3.New(35, -37, 0)
InviteItemCell.CardSlotElementWidth = 10

function InviteItemCell:Init()
  InviteItemCell.super.Init(self)
  self:AddCellClickEvent()
end
