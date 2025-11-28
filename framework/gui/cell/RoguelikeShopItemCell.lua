autoImport("ExpRaidShopItemCell")
RoguelikeShopItemCell = class("RoguelikeShopItemCell", ExpRaidShopItemCell)

function RoguelikeShopItemCell:SetData(data)
  self.gameObject:SetActive(data ~= nil)
  if not data then
    self.data = nil
    return
  end
  RoguelikeShopItemCell.super.super.super.SetData(self, data.itemData)
  self.data = data
  self.itemName.text = self:GetItemName()
  self:SetChildrenActive()
  self:SetCostMoneySpriteByAction(function(costSprite)
    IconManager:SetItemIcon(Table_Item[DungeonProxy.RoguelikeCoinId].Icon, costSprite)
  end)
  self.buyCondition.text = data.itemData.staticData.Desc
  self.costMoneyNums[1].text = data.cost
  self.costMoneyNums[1].color = DungeonProxy.Instance.roguelikeRaid.coinCount >= data.cost and ColorUtil.NGUIWhite or ColorUtil.Red
  self.soldout:SetActive(data.soldOut and true or false)
end

function RoguelikeShopItemCell:GetItemName()
  return self.data and self.data.itemData.staticData.NameZh or ""
end

function RoguelikeShopItemCell:GetItemId()
  return self.data and self.data.itemData.staticData.id or 0
end

function RoguelikeShopItemCell:GetItemCost()
  return self.data and self.data.cost or 99999
end

function RoguelikeShopItemCell:IsSoldOut()
  return self.data and self.data.soldOut
end
