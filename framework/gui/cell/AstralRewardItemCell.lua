autoImport("ItemCell")
AstralRewardItemCell = class("AstralRewardItemCell", ItemCell)

function AstralRewardItemCell:InitItemCell()
  AstralRewardItemCell.super.InitItemCell(self)
  self:AddCellClickEvent()
  self:SetDefaultBgSprite(nil, "com_icon_bottom2")
end

function AstralRewardItemCell:UpdateNumLabel(scount, x, y, z)
  AstralRewardItemCell.super.UpdateNumLabel(self, scount, x, y, z)
  if self.numLabTrans then
    x, y, z = LuaGameObject.GetLocalPosition(self.numLabTrans)
    self.numLabTrans.localPosition = LuaGeometry.GetTempVector3(x, -42, z)
  end
end
