autoImport("GuildBuildingMatSubmitCell")
BifrostMatSubmitCell = class("BifrostMatSubmitCell", GuildBuildingMatSubmitCell)
local BUILD_PACKAGE_MATERIAL = GameConfig.PackageMaterialCheck.guildBuilding
local DONATE_PACKAGE_MATERIAL = GameConfig.PackageMaterialCheck.donate or {
  1,
  6,
  7,
  8,
  9,
  17
}

function BifrostMatSubmitCell:SetData(data, flag)
  self.data = data
  if data then
    self.content:SetActive(true)
    self:InitTexture()
    if data.materials and data.materials.id then
      IconManager:SetItemIcon(Table_Item[data.materials.id].Icon, self.icon)
      local packageCheck = data.__cname == "DonateMatData" and DONATE_PACKAGE_MATERIAL or BUILD_PACKAGE_MATERIAL
      local ownCount = BagProxy.Instance:GetItemNumByStaticID(data.materials.id, packageCheck)
      local num = data.materials.count
      self.name.text = string.format(ZhString.GuildBuilding_Submit_Name, Table_Item[data.materials.id].NameZh, ownCount, num)
    end
    local reward = data.rewardData
    if "table" == type(reward) and 1 < #reward then
      local rewardIconName = Table_Item[reward[1]] and Table_Item[reward[1]].Icon or "item_100"
      IconManager:SetItemIcon(rewardIconName, self.rewardIcon)
      self.rewardIcon:MakePixelPerfect()
      self.rewardCount.text = reward[2]
      self.rewardShowItem = reward[1]
    end
  else
    self.content:SetActive(false)
  end
end
