ActivityBattlePassItemCell = class("ActivityBattlePassItemCell", BagItemCell)

function ActivityBattlePassItemCell:Init()
  self:LoadPreferb("cell/ActivityBattlePassItemCell", self.gameObject)
  BagItemCell.super.Init(self)
  self:AddCellDoubleClickEvt()
end

function ActivityBattlePassItemCell:SetPic(itemType, staticData, hasQuench)
end

function ActivityBattlePassItemCell:SetIcon(data)
  ActivityBattlePassItemCell.super.SetIcon(self, data)
  self.icon.width = 70
  self.icon.height = 70
end
