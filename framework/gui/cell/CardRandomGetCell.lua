CardRandomGetCell = class("CardRandomGetCell", ItemCell)

function CardRandomGetCell:Init()
  local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  CardRandomGetCell.super.Init(self)
  self:AddCellClickEvent()
end

function CardRandomGetCell:SetData(data)
  CardRandomGetCell.super.SetData(self, data)
  self.data = data
end
