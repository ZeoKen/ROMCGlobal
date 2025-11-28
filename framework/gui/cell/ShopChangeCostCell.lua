local baseCell = autoImport("BaseCell")
ShopChangeCostCell = reusableClass("ShopChangeCostCell", baseCell)
local tempVector3 = LuaVector3.Zero()

function ShopChangeCostCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function ShopChangeCostCell:FindObjs()
  self.costRange = self.gameObject:GetComponent(UILabel)
  self.priceTip = self:FindGO("PriceTip"):GetComponent(UILabel)
  self.priceIcon = self:FindGO("PriceIcon"):GetComponent(UISprite)
  self.price = self:FindGO("Price"):GetComponent(UILabel)
end

function ShopChangeCostCell:SetData(data)
  self.data = data
  local min = data.min
  local max = data.max or 0
  local str = ""
  if min == max then
    str = min
  elseif min and max == 0 then
    str = min .. "+"
  else
    str = min .. "~" .. max
  end
  self.costRange.text = ZhString.HappyShop_BuyCount .. str
  self.priceTip.text = ZhString.HappyShop_RetailPrice
  local costID = data.costID
  local itemData = Table_Item[costID]
  IconManager:SetItemIcon(itemData.Icon, self.priceIcon)
  self.price.text = StringUtil.NumThousandFormat(data.price)
end

function ShopChangeCostCell:GetPriceWidth()
  return self.price.printedSize.x
end
