autoImport("ItemCell")
AfricanPoringShopCell = class("AfricanPoringShopCell", ItemCell)

function AfricanPoringShopCell:Init()
  self.itemContainerGO = self:FindGO("ItemContainer")
  self:AddClickEvent(self.itemContainerGO, function()
    self:PassEvent(UICellEvent.OnLeftBtnClicked, self)
  end)
  local obj = self:LoadPreferb("cell/ItemCell", self.itemContainerGO)
  LuaGameObject.SetLocalPositionGO(obj, 0, 0, 0)
  AfricanPoringShopCell.super.Init(self)
  self:SetDefaultBgSprite(RO.AtlasMap.GetAtlas("UI_Lottery"), "mall_twistedegg_bg_09")
  self.soldoutGO = self:FindGO("Soldout", self.itemContainerGO)
  self.name = self:FindComponent("Name", UILabel)
  self.desc = self:FindComponent("Desc", UILabel)
  self.buyBtnGO = self:FindGO("BuyBtn")
  self:AddClickEvent(self.buyBtnGO, function()
    self:PassEvent(UICellEvent.OnRightBtnClicked, self)
  end)
  self.costIcon = self:FindComponent("CostIcon", UISprite, self.buyBtnGO)
  self.costNum = self:FindComponent("CostNum", UILabel, self.buyBtnGO)
end

function AfricanPoringShopCell:SetData(data)
  self.cellData = data
  if data then
    local itemData = data:GetItemData():Clone()
    if data.goodsCount and data.goodsCount > 1 then
      itemData:SetItemNum(data.goodsCount)
    end
    local itemConfig = itemData.staticData
    self.name.text = itemConfig and itemConfig.NameZh or ""
    local boughtCount = HappyShopProxy.Instance:GetCachedHaveBoughtItemCount(data.id) or 0
    local limitCount = data.LimitNum
    if limitCount and 0 < limitCount then
      self.desc.gameObject:SetActive(true)
      self.desc.text = string.format(ZhString.AfricanPoring_BuyLimit, boughtCount, limitCount)
    else
      self.desc.gameObject:SetActive(false)
    end
    local canBuyNum = HappyShopProxy.Instance:GetCanBuyCount(data)
    if canBuyNum == nil or 0 < canBuyNum then
      self.buyBtnGO:SetActive(true)
      self.soldoutGO:SetActive(false)
      IconManager:SetItemIconById(data.ItemID, self.costIcon)
      IconManager:FitAspect(self.costIcon)
      self.costNum.text = data.ItemCount or ""
    else
      self.buyBtnGO:SetActive(false)
      self.soldoutGO:SetActive(true)
    end
    AfricanPoringShopCell.super.SetData(self, itemData)
  end
end
