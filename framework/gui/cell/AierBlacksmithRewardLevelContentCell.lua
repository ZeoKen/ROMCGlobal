autoImport("TechTreeLevelContentCell")
AierBlacksmithRewardLevelContentCell = class("AierBlacksmithRewardLevelContentCell", TechTreeLevelContentCell)

function AierBlacksmithRewardLevelContentCell:FindObjs()
  AierBlacksmithRewardLevelContentCell.super.FindObjs(self)
  self.descLabel.transform.localPosition = LuaGeometry.GetTempVector3(-60, 0, 0)
  self.descLabel.width = 145
end

function AierBlacksmithRewardLevelContentCell:SetData(data)
  self.data = data
  self.id = data.cfg.id
  self.count = data.cfg.num
  self.itemid = self.id
  self.itemContainer:SetActive(false)
  self.commonSymbol:SetActive(false)
  self.goBtn:SetActive(false)
  self.itemContainer:SetActive(true)
  local cfg = Table_Item[self.id]
  local str = cfg.Icon
  local setSuc = IconManager:SetItemIcon(str, self.itemIcon)
  setSuc = setSuc or IconManager:SetItemIcon("item_45001", self.itemIcon)
  self.itemCount.text = self.count
  self.descLabel.text = cfg.NameZh .. "X" .. tostring(self.count)
  self.widget.alpha = data.achieved and 0.33 or 1
  self.rewardEffect:SetActive(false)
end
