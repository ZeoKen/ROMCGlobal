MemoryEquipRewardData = class("MemoryEquipRewardData")

function MemoryEquipRewardData:ctor(serverData)
  self:SetData(serverData)
end

function MemoryEquipRewardData:SetData(serverData)
  self.index = serverData.index
  self.pos = serverData.pos
  self.state = serverData.state
  self.oldLevel = serverData.beginlevel or 0
  self.newLevel = serverData.endlevel or 0
  self.upLevel = serverData.quality or 0
  self.quality = GameConfig.SpaceTimeIllusion.MemoryReward and GameConfig.SpaceTimeIllusion.MemoryReward.RewardColor and GameConfig.SpaceTimeIllusion.MemoryReward.RewardColor[self.upLevel] or 0
  self.rewards = {}
  if serverData.items then
    for i = 1, #serverData.items do
      local item = serverData.items[i]
      local itemData = ItemData.new(item.itemid, item.itemid)
      itemData.num = item.count
      table.insert(self.rewards, itemData)
    end
  end
end

function MemoryEquipRewardData:GetEquipMemoryData()
  return EquipMemoryProxy.Instance:GetPosData(self.pos)
end
