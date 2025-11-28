autoImport("GuildBuildingMatSubmitCell")
GiftMatSubmitCell = class("GiftMatSubmitCell", GuildBuildingMatSubmitCell)
local DONATE_PACKAGE_MATERIAL = GameConfig.PackageMaterialCheck.donate or {
  1,
  6,
  7,
  8,
  9,
  17
}

function GiftMatSubmitCell:SetData(data, flag)
  self.data = data
  if data then
    self.content:SetActive(true)
    self:InitTexture()
    if data.require_item and data.require_item.id then
      self.itemID = data.require_item.id
      IconManager:SetItemIcon(Table_Item[self.itemID].Icon, self.icon)
      local ownCount = BagProxy.Instance:GetItemNumByStaticID(self.itemID, DONATE_PACKAGE_MATERIAL)
      self.num = data.require_item.count
      local str = data.textStr or ZhString.GuildBuilding_Submit_Name
      self.name.text = string.format(str, Table_Item[self.itemID].NameZh, ownCount, self.num)
    end
    local reward = data.reward_item
    if reward then
      local rewardIconName = Table_Item[reward.id] and Table_Item[reward.id].Icon or "item_100"
      IconManager:SetItemIcon(rewardIconName, self.rewardIcon)
      self.rewardIcon:MakePixelPerfect()
      self.rewardCount.text = reward.count
      self.rewardShowItem = reward.id
    end
  else
    self.content:SetActive(false)
  end
end
