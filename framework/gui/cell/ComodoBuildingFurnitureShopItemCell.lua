autoImport("ShopItemCell")
ComodoBuildingFurnitureShopItemCell = class("ComodoBuildingFurnitureShopItemCell", ShopItemCell)
local shopIns, buildingIns

function ComodoBuildingFurnitureShopItemCell:Init()
  if not shopIns then
    shopIns = HappyShopProxy.Instance
    buildingIns = ComodoBuildingProxy.Instance
  end
  ComodoBuildingFurnitureShopItemCell.super.Init(self)
  self.itemDesc = self:FindComponent("ItemDesc", UILabel)
  self.itemIcon = self:FindComponent("ItemIcon", UISprite)
  self.itemNumLabel = self:FindComponent("ItemNumLabel", UILabel)
  self:AddClickEvent(self.itemIcon.gameObject, function()
    self:PassEvent(HappyShopEvent.SelectIconSprite, self)
  end)
end

function ComodoBuildingFurnitureShopItemCell:SetData(data)
  local id = data
  data = self:GetShopItemData(id)
  self.gameObject:SetActive(data ~= nil)
  if data then
    local itemData = data:GetItemData()
    local setSuc = IconManager:SetItemIcon(itemData.staticData.Icon, self.itemIcon)
    setSuc = setSuc or IconManager:SetItemIcon("item_45001", self.itemIcon)
    self.itemDesc.text = itemData.staticData.Desc
    local goodsCount = data.goodsCount
    self.itemNumLabel.text = goodsCount ~= nil and 1 < goodsCount and tostring(goodsCount) or ""
    local itemId, isLock = data.goodsID, data:GetLock()
    if itemId ~= nil then
      self:Show(self.itemName.gameObject)
      local goodsData = Table_Item[itemId]
      if goodsData then
        self.itemName.text = goodsData.NameZh .. (isLock and ZhString.HappyShop_LockSuffix or "")
      end
    end
    self.lock:SetActive(isLock)
    self.costGrid.gameObject:SetActive(not isLock)
    self.itemIcon.alpha = isLock and 0.5 or 1
    if goodsCount and 1 < goodsCount then
      itemData.num = goodsCount
    end
    self.choose:SetActive(false)
    if data.ItemCount and data.ItemID and not isLock then
      for i = 1, #self.costMoneySprite do
        local temp = i
        if temp == 1 then
          temp = ""
        end
        local moneyId = data["ItemID" .. temp]
        local icon = Table_Item[moneyId] and Table_Item[moneyId].Icon
        local isGuildMat = data.LimitType == HappyShopProxy.LimitType.GuildMaterialWeek and moneyId == GameConfig.MoneyId.Quota
        if icon and not isGuildMat then
          self.costMoneySprite[i].gameObject:SetActive(true)
          IconManager:SetItemIcon(icon, self.costMoneySprite[i])
          local price = data:GetBuyDiscountPrice(data["ItemCount" .. temp], 1)
          local priceStr = StringUtil.NumThousandFormat(price)
          if price <= shopIns:GetItemNum(moneyId) then
            self.costMoneyNums[i].text = priceStr
          else
            self.costMoneyNums[i].text = string.format("[c][fb725f]%s[-][/c]", priceStr)
          end
        else
          self.costMoneySprite[i].gameObject:SetActive(false)
        end
      end
      TimeTickManager.Me():CreateOnceDelayTick(16, function(self)
        self.costGrid:Reposition()
        self.costGrid.repositionNow = true
      end, self)
    end
    self.soldout:SetActive(not isLock and (shopIns:GetCanBuyCount(data) == 0 or not buildingIns:CheckFavoredItemCanBuy(itemId)))
  end
  self.data = id
end
