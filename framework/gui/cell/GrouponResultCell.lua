local baseCell = autoImport("BaseCell")
GrouponResultCell = class("GrouponResultCell", baseCell)

function GrouponResultCell:Init()
  self:FindObjs()
end

function GrouponResultCell:FindObjs()
  self.priceIcon = self:FindGO("Price"):GetComponent(UISprite)
  self.price = self:FindGO("PriceLabel"):GetComponent(UILabel)
  self.num = self:FindGO("Num"):GetComponent(UILabel)
  self.returnIcon = self:FindGO("ReturnIcon"):GetComponent(UISprite)
  self.returnPrice = self:FindGO("ReturnLabel"):GetComponent(UILabel)
end

function GrouponResultCell:SetData(data)
  self.data = data
  self.price.text = data.price
  self.num.text = data.count or 0
  self.grouponid = data.grouponid
  local returnValue = self:GetDiffPrice() * data.count
  self.returnPrice.text = math.modf(returnValue)
  IconManager:SetItemIcon("item_151", self.returnIcon)
  IconManager:SetItemIcon("item_151", self.priceIcon)
  local level = data.level
end

function GrouponResultCell:GetDiffPrice()
  local diff = 0
  local currentPrice = GrouponProxy.Instance.couponAct[self.grouponid] and GrouponProxy.Instance.couponAct[self.grouponid].currentPrice
  helplog("currentprice", currentPrice)
  if currentPrice then
    diff = self.data.price - currentPrice
    return diff
  end
  return 0
end
