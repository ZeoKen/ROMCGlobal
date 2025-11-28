autoImport("ItemData")
Anniversary2023CellData = class("Anniversary2023CellData")
local CellStatus = {
  InActive = 0,
  CanTakeReward = 1,
  Rewarded = 2
}

function Anniversary2023CellData:ctor(serverData, staticData, isShare)
  self:SetData(serverData, staticData, isShare)
end

function Anniversary2023CellData:SetData(serverData, staticData, isShare)
  self.data = serverData
  self.isShare = isShare
  self.rewardItems = {}
  if not serverData then
    return
  end
  self.day = serverData.day
  self.status = serverData.status
  self.luckyNum = serverData.lucky_number
  if staticData then
    local rewards = isShare and staticData.ShareReward or staticData.SignInRewards[self.day]
    for i, reward in ipairs(rewards) do
      local itemKey = string.format("Anniversary2023CellData_%s_%s", self.day or 0, i)
      local itemData = ItemData.new(itemKey, reward[1])
      table.insert(self.rewardItems, {
        itemNum = reward[2],
        itemData = itemData,
        owned = self:IsRewarded()
      })
    end
  end
end

function Anniversary2023CellData:IsLuckyNumValid()
  return self.luckyNum and self.luckyNum ~= 0 and self.luckyNum ~= ""
end

function Anniversary2023CellData:GetRewardData(index)
  return self.rewardItems and self.rewardItems[index]
end

function Anniversary2023CellData:IsInActive()
  return self.status == CellStatus.InActive
end

function Anniversary2023CellData:IsRewarded()
  return self.status == CellStatus.Rewarded
end

function Anniversary2023CellData:CanTakeReward()
  return self.status == CellStatus.CanTakeReward
end
