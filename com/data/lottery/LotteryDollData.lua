LotteryDollData = class("LotteryDollData")

function LotteryDollData:ctor(data)
  self:SetData(data)
end

function LotteryDollData:SetData(serverData)
  if serverData then
    self.id = serverData.id
    self.weight = serverData.weight
    local item = serverData.item
    self.count = item.count
    self.itemId = item.id
    self.owned = serverData.owned
    self.rate = serverData.rate
  end
end

function LotteryDollData:UpdateData(serverData)
  if serverData then
    local item = serverData.item
    if item then
      self.itemId = item.id
    end
  end
end

function LotteryDollData:GetItemData()
  if not self.itemData then
    self.itemData = ItemData.new("LotteryItem", self.itemId)
    self.itemData.num = self.count
  end
  return self.itemData
end

function LotteryDollData:GetRate()
  if self.rate then
    if BranchMgr.IsJapan() then
      return math.floor(self.rate + 0.5)
    else
      return self.rate
    end
  end
  return 0
end
