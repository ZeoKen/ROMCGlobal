ExtractionCostData = class("ExractionCostData")

function ExtractionCostData:ctor(itemId, costNum, ownedNum, discount, isEquip)
  self.itemId = itemId
  self.costNum = costNum or 1
  self.ownedNum = ownedNum or 0
  self.discount = discount
  self.isEquip = isEquip
  self.isMoney = false
  if GameConfig.MoneyId then
    for _, v in pairs(GameConfig.MoneyId) do
      if v == itemId then
        self.isMoney = true
        break
      end
    end
  end
end

function ExtractionCostData:HasEnoughItems()
  return self.ownedNum >= self.costNum
end

function ExtractionCostData:SetCostNum(num)
  self.costNum = num or 1
end

function ExtractionCostData:SetOwnedNum(num)
  self.ownedNum = num or 0
end

function ExtractionCostData:IsMoney()
  return self.isMoney
end
