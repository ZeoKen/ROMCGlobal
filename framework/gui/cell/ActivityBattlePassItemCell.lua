ActivityBattlePassItemCell = class("ActivityBattlePassItemCell", BagItemCell)

function ActivityBattlePassItemCell:Init()
  local goName = self.gameObject and self.gameObject.name
  if not goName or not string.find(goName, "ActivityBattlePassItemCell", 1, true) then
    local obj = self:LoadPreferb("cell/ActivityBattlePassItemCell", self.gameObject)
    if obj then
      self.gameObject = obj
      self.trans = obj.transform
    end
  end
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
