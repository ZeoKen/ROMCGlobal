autoImport("DojoRewardData")
ExchangeGiftData = class("ExchangeGiftData")

function ExchangeGiftData:ctor(serverdata)
  if serverdata then
    self.require_item = DojoRewardData.new(serverdata.require_item)
    self.reward_item = DojoRewardData.new(serverdata.reward_item)
    self.quality = Table_Item[self.require_item.id].Quality
  end
  self.textStr = "%s(%s/[c][4b7cff]%s[-][/c])"
end

function ExchangeGiftData:GetMaterials()
  return self.require_item
end

function ExchangeGiftData:GetReward()
  return self.reward_item
end
