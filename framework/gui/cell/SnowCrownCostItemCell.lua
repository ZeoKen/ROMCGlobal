SnowCrownCostItemCell = class("SnowCrownCostItemCell", ItemCell)

function SnowCrownCostItemCell:Init()
  SnowCrownCostItemCell.super.Init(self)
  self.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.95, 0.95, 0.95)
end
