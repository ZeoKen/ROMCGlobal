autoImport("ShopItemCell")
ExpRaidShopItemCell = class("ExpRaidShopItemCell", ShopItemCell)
local ins

function ExpRaidShopItemCell:Init()
  if not ins then
    ins = ExpRaidProxy.Instance
  end
  ExpRaidShopItemCell.super.Init(self)
  self.soldout:SetActive(false)
end

function ExpRaidShopItemCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  ExpRaidShopItemCell.super.super.SetData(self, data)
  self:SetChildrenActive()
  self:SetCostMoneySpriteByAction(function(costPointSprite)
    IconManager:SetUIIcon("exp_integral", costPointSprite)
  end)
  self.itemName.text = data.staticData.NameZh
  self.buyCondition.text = data.staticData.Desc
  self.costMoneyNums[1].text = ins:GetPriceOfItem(data.staticData.id)
  self.invalid:SetActive(not ins:CheckIsShopItemUnlocked(data))
  self.soldout:SetActive(false)
end

function ExpRaidShopItemCell:SetChildrenActive()
  self.costMoneySprite[1].gameObject:SetActive(true)
  self.costMoneySprite[2].gameObject:SetActive(false)
  self.choose:SetActive(false)
  self.lock:SetActive(false)
  self.primeCost.gameObject:SetActive(false)
  self.sellDiscount.gameObject:SetActive(false)
  self.exchangeButton:SetActive(false)
  self.fashionUnlock:SetActive(false)
end

function ExpRaidShopItemCell:SetCostMoneySpriteByAction(setIconAction)
  if type(setIconAction) ~= "function" then
    LogUtility.Error("ArgumentNilException")
    return
  end
  local costPointSprite = self.costMoneySprite[1]
  setIconAction(costPointSprite)
  local costPointLocalPos = costPointSprite.gameObject.transform.localPosition
  costPointLocalPos.y = 0
  costPointSprite.gameObject.transform.localPosition = costPointLocalPos
end
