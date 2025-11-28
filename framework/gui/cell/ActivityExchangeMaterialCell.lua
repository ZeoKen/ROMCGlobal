autoImport("ActivityExchangeItemCell")
ActivityExchangeMaterialCell = class("ActivityExchangeMaterialCell", ActivityExchangeItemCell)
local RedColor = "d33700"
local BlackColor = "000000"

function ActivityExchangeMaterialCell:UpdateNumLabel(num)
  local checkPackage = GameConfig.PackageMaterialCheck.exchange_shop
  local bagNum = BagProxy.Instance:GetItemNumByStaticID(self.data.staticData.id, checkPackage)
  local colStr = num > bagNum and RedColor or BlackColor
  self.numLab.text = string.format("[c][%s]%s[-][/c]/%s", colStr, bagNum, num)
  self.symbol.gameObject:SetActive(self.indexInList ~= 1)
end

function ActivityExchangeMaterialCell:SetSymbol()
  self.symbol.text = "+"
end
