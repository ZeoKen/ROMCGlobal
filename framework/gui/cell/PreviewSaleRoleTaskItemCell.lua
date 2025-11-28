autoImport("ItemCell")
PreviewSaleRoleTaskItemCell = class("PreviewSaleRoleTaskItemCell", ItemCell)
PreviewSaleRoleTaskItemCell.CellPartPathFolderName = "ItemCellParts"
PreviewSaleRoleTaskItemCell.DefaultNumLabelLocalPos = LuaVector3.New(35, -37, 0)
PreviewSaleRoleTaskItemCell.CardSlotElementWidth = 10

function PreviewSaleRoleTaskItemCell:Init()
  PreviewSaleRoleTaskItemCell.super.Init(self)
  self:AddCellClickEvent()
end

function PreviewSaleRoleTaskItemCell:InitItemCell()
  PreviewSaleRoleTaskItemCell.super.InitItemCell(self)
  self.unlock = self:FindGO("unlock")
end

function PreviewSaleRoleTaskItemCell:SetData(data)
  PreviewSaleRoleTaskItemCell.super.SetData(self, data)
  self.unlock:SetActive(data.unlock)
end

function PreviewSaleRoleTaskItemCell:SetPic(itemType)
  self:GetBgSprite()
end
