LotteryPrayData = class("LotteryPrayData")

function LotteryPrayData:ctor(t)
  self.lotteryType = t
  self.cardId = 0
end

function LotteryPrayData:ResetData(data)
  self.open = data.pray_open
  self.cardId = data.cardid
  self.curPray = data.cur_pray
  self.maxPray = data.max_pray
  if Table_Item[self.cardId] then
    self.cardData = ItemData.new("pray_card", self.cardId)
  end
  self.leftPrayCount = data.left_pray
end

function LotteryPrayData:IsOpen()
  return self.open == true
end

function LotteryPrayData:GetPrayInfo()
  return self.cardId, self.curPray, self.maxPray, self.cardData
end

function LotteryPrayData:GetProgress()
  return self.curPray, self.maxPray
end

function LotteryPrayData:GetName()
  return self.cardId and self.cardId ~= 0 and Table_Item[self.cardId].NameZh or ""
end

function LotteryPrayData:GetLeftPrayCount()
  return self.leftPrayCount
end
