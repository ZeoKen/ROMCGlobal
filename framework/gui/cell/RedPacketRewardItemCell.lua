RedPacketRewardItemCell = class("RedPacketRewardItemCell", ItemCell)

function RedPacketRewardItemCell:InitItemCell()
  RedPacketRewardItemCell.super.InitItemCell(self)
  self:SetDefaultBgSprite(RO.AtlasMap.GetAtlas("UI_Lottery"), "mall_twistedegg_bg_09")
  self:AddCellClickEvent()
end
