LotteryRecoverData = class("LotteryRecoverData")

function LotteryRecoverData:ctor(data)
  self:SetData(data)
end

function LotteryRecoverData:SetData(data)
  if data then
    self.itemData = data
    self.cost = 0
    self.specialCost = 0
    self.selectCount = 0
  end
end

function LotteryRecoverData:SetInfo(lotteryItemData, type)
  self.costItem = lotteryItemData.recoverItemid
  self.cost = lotteryItemData.recoverPrice
  if ShopMallProxy.Instance:JudgeSpecialEquip(self.itemData) then
    self.specialCost = CommonFun.calcRefineRecovery(self.itemData.id, self.itemData.equipInfo.refinelv, self.itemData.equipInfo.damage, type)
  end
  self.totalCost = self.cost + self.specialCost
end

function LotteryRecoverData:SelectCount(offset)
  local count = self.selectCount + offset
  if count < 0 then
    return false
  end
  if count > self.itemData.num then
    return false
  end
  self.selectCount = count
  return true
end

function LotteryRecoverData:GetCost()
  return self.cost * self.selectCount
end

function LotteryRecoverData:GetLeftCost()
  return self.totalCost * (self.itemData.num - self.selectCount)
end

function LotteryRecoverData:GetTotalCost()
  return self.totalCost * self.selectCount
end
