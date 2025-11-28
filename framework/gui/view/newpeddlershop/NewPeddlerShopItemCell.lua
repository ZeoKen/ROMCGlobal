local BaseCell = autoImport("BaseCell")
NewPeddlerShopItemCell = class("NewPeddlerShopItemCell", BaseCell)
local Tex_Lock = "Mysterious-Merchant_bg_01"
local Tex_UnLock = "Mysterious-Merchant_bg_02"

function NewPeddlerShopItemCell:Init()
  NewPeddlerShopItemCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function NewPeddlerShopItemCell:FindObjs()
  self.m_uiTexBg = self:FindGO("uiTexBg"):GetComponent(UITexture)
  self.m_uiStarRoot = self:FindGO("uiStarGrid")
  self.m_uiMysticalBg = self:FindGO("uiImgMysticalBg")
  self.m_dragScroll = self.gameObject:GetComponent(UIDragScrollView)
  self.m_uiAllStars = {}
  for i = 1, 5 do
    local t = {}
    t.m_uiImgStar = self:FindGO("uiStarGrid/" .. i)
    t.m_uiImgSelected = self:FindGO("uiStarGrid/" .. i .. "/uiImgSelected")
    table.insert(self.m_uiAllStars, t)
  end
  self.m_uiTxtStarNum = self:FindGO("uiStarGrid/uiImgNum"):GetComponent(UILabel)
  self.m_uiTxtName = self:FindGO("uiTexBg/uiImgName/uiTxtName"):GetComponent(UILabel)
  self.m_uiTxtItemNum = self:FindGO("uiTexBg/uiImgNum/uiTxtNum"):GetComponent(UILabel)
  self.m_uiTxtPrice = self:FindGO("uiTexBg/uiImgPrice/uiTxtPrice"):GetComponent(UILabel)
  self.m_uiTxtSaleOut = self:FindGO("uiTexBg/uiImgLockBg/uiTxtSaleOut"):GetComponent(UILabel)
  self.m_uiImgIcon = self:FindGO("uiTexBg/uiImgIcon"):GetComponent(UISprite)
  self.m_uiImgLockBg = self:FindGO("uiTexBg/uiImgLockBg"):GetComponent(UISprite)
  self.m_uiImgLock = self:FindGO("uiTexBg/uiImgLockBg/uiImgLock"):GetComponent(UISprite)
  self.m_uiImgPriceIcon = self:FindGO("uiTexBg/uiImgPrice/uiImgPriceIcon"):GetComponent(UISprite)
  self.m_uiImgPrice = self:FindGO("uiTexBg/uiImgPrice"):GetComponent(UISprite)
  self.m_uiTxtName2 = self:FindGO("uiImgMysticalBg/uiImgName/uiTxtName"):GetComponent(UILabel)
  self.m_uiTxtItemNum2 = self:FindGO("uiImgMysticalBg/uiImgNum/uiTxtNum"):GetComponent(UILabel)
  self.m_uiTxtPrice2 = self:FindGO("uiImgMysticalBg/uiImgPrice/uiTxtPrice"):GetComponent(UILabel)
  self.m_uiTxtSaleOut2 = self:FindGO("uiImgMysticalBg/uiImgLockBg/uiTxtSaleOut"):GetComponent(UILabel)
  self.m_uiImgIcon2 = self:FindGO("uiImgMysticalBg/uiImgIcon"):GetComponent(UISprite)
  self.m_uiImgLockBg2 = self:FindGO("uiImgMysticalBg/uiImgLockBg"):GetComponent(UISprite)
  self.m_uiImgLock2 = self:FindGO("uiImgMysticalBg/uiImgQ"):GetComponent(UISprite)
  self.m_uiImgPriceIcon2 = self:FindGO("uiImgMysticalBg/uiImgPrice/uiImgPriceIcon"):GetComponent(UISprite)
  self.m_uiImgPrice2 = self:FindGO("uiImgMysticalBg/uiImgPrice"):GetComponent(UISprite)
  self.m_uiImgDesc = self:FindGO("uiImgMysticalBg/uiImgDesc"):GetComponent(UISprite)
  self.m_uiMysticalBg.gameObject:SetActive(false)
end

function NewPeddlerShopItemCell:AddEvts()
  self:AddClickEvent(self.m_uiTexBg.gameObject, function(go)
    if self.m_funcClass ~= nil and self.m_funcClickItem ~= nil then
      self.m_funcClickItem(self.m_funcClass, self.m_data)
    end
  end)
  self:AddClickEvent(self.m_uiMysticalBg.gameObject, function(go)
    if self.m_funcClass ~= nil and self.m_funcClickItem ~= nil then
      self.m_funcClickItem(self.m_funcClass, self.m_data)
    end
  end)
end

function NewPeddlerShopItemCell:SetData(value)
  if value == "is_test" then
    return
  end
  self.m_data = value[1]
  self.m_index = value[2]
  if self.m_data.m_isMysticalShop == true then
    self:showMysticalItem()
  else
    self:showNormalItem()
  end
end

function NewPeddlerShopItemCell:showNormalItem()
  local tbGoods = Table_Item[self.m_data.goodsID]
  IconManager:SetItemIcon(tbGoods.Icon, self.m_uiImgIcon)
  self.m_uiTxtName.text = tbGoods.NameZh
  local canBuyCount, limitType = HappyShopProxy.Instance:GetCanBuyCount(self.m_data)
  local buyCount = HappyShopProxy.Instance:GetCachedHaveBoughtItemCount(self.m_data.id)
  buyCount = buyCount == nil and 0 or buyCount
  if limitType and canBuyCount then
    local tmp = buyCount .. "/" .. self.m_data.LimitNum
    self.m_uiTxtItemNum.text = tmp
  else
    self.m_uiTxtItemNum.text = ""
  end
  local tbItem = Table_Item[self.m_data.ItemID]
  IconManager:SetItemIcon(tbItem.Icon, self.m_uiImgPriceIcon)
  self.m_uiTxtPrice.text = StringUtil.NumThousandFormat(self.m_data.ItemCount)
  local goodsId = self.m_data.id
  self.unlockcur = PeddlerShopProxy.Instance:CheckUnlockByPre(goodsId)
  if not self.unlockcur then
    self.m_uiImgLockBg.gameObject:SetActive(true)
    self.m_uiTxtSaleOut.gameObject:SetActive(false)
    self.m_uiImgLock.gameObject:SetActive(true)
    self.m_uiImgPrice.gameObject:SetActive(false)
    PictureManager.Instance:SetUI(Tex_Lock, self.m_uiTexBg)
  else
    if canBuyCount and canBuyCount == 0 then
      PictureManager.Instance:SetUI(Tex_Lock, self.m_uiTexBg)
      self.m_uiImgLockBg.gameObject:SetActive(true)
      self.m_uiTxtSaleOut.gameObject:SetActive(true)
      self.m_uiImgPrice.gameObject:SetActive(false)
    else
      PictureManager.Instance:SetUI(Tex_UnLock, self.m_uiTexBg)
      self.m_uiImgLockBg.gameObject:SetActive(false)
      self.m_uiTxtSaleOut.gameObject:SetActive(false)
      self.m_uiImgPrice.gameObject:SetActive(true)
    end
    self.m_uiImgLock.gameObject:SetActive(false)
  end
  self:isMysticalItem(false)
  local list = PeddlerShopProxy.Instance.shopList
  local unLockNum = PeddlerShopProxy.Instance:GetPeddlerShopItemData(goodsId).unlocknextcount
  if self.m_index == #list then
    self.m_uiStarRoot:SetActive(false)
  else
    self.m_uiStarRoot:SetActive(true)
  end
  local unit = unLockNum / 5
  for k, v in ipairs(self.m_uiAllStars) do
    v.m_uiImgSelected.gameObject:SetActive(buyCount >= math.ceil(unit * k))
  end
  self.m_uiTxtStarNum.text = (buyCount > unLockNum and unLockNum or buyCount) .. "/" .. unLockNum
end

function NewPeddlerShopItemCell:showMysticalItem()
  local tbGoods = Table_Item[self.m_data.goodsID]
  IconManager:SetItemIcon(tbGoods.Icon, self.m_uiImgIcon2)
  local canBuyCount, limitType = HappyShopProxy.Instance:GetCanBuyCount(self.m_data)
  local buyCount = HappyShopProxy.Instance:GetCachedHaveBoughtItemCount(self.m_data.id)
  buyCount = buyCount == nil and 0 or buyCount
  if limitType and canBuyCount then
    local tmp = buyCount .. "/" .. self.m_data.LimitNum
    self.m_uiTxtItemNum2.text = tmp
  else
    self.m_uiTxtItemNum2.text = ""
  end
  local tbItem = Table_Item[self.m_data.ItemID]
  IconManager:SetItemIcon(tbItem.Icon, self.m_uiImgPriceIcon2)
  self.m_uiTxtPrice2.text = StringUtil.NumThousandFormat(self.m_data.ItemCount)
  self.m_uiImgLockBg2.gameObject:SetActive(false)
  self.m_uiImgPrice2.gameObject:SetActive(false)
  self.m_uiImgPriceIcon2.gameObject:SetActive(false)
  self.m_uiTxtItemNum2.gameObject:SetActive(false)
  self.m_uiImgIcon2.gameObject:SetActive(false)
  if 0 < canBuyCount then
    self.m_uiTxtName2.text = tbGoods.NameZh
    self.m_uiImgLock2.gameObject:SetActive(false)
    self.m_uiImgDesc.gameObject:SetActive(false)
    self.m_uiImgPrice2.gameObject:SetActive(true)
    self.m_uiImgPriceIcon2.gameObject:SetActive(true)
    self.m_uiTxtItemNum2.gameObject:SetActive(true)
    self.m_uiImgIcon2.gameObject:SetActive(true)
  else
    self.m_uiTxtName2.text = ZhString.PeddlerShop_MysticalName
    self.m_uiImgLock2.gameObject:SetActive(true)
    self.m_uiImgDesc.gameObject:SetActive(true)
    local leftTime = self.m_data.RemoveDate - ServerTime.CurServerTime() / 1000
    if leftTime < 86400 then
      self.m_uiImgDesc.gameObject:SetActive(false)
      self.m_uiImgLockBg2.gameObject:SetActive(true)
      self.m_uiImgLock2.gameObject:SetActive(false)
      self.m_uiTxtName2.text = tbGoods.NameZh
      self.m_uiImgIcon2.gameObject:SetActive(true)
    end
  end
  self:isMysticalItem(true)
end

function NewPeddlerShopItemCell:isMysticalItem(value)
  self.m_uiTexBg.gameObject:SetActive(not value)
  self.m_uiStarRoot.gameObject:SetActive(not value)
  self.m_uiMysticalBg.gameObject:SetActive(value)
end

function NewPeddlerShopItemCell:setClickItemFunc(func, class)
  self.m_funcClickItem = func
  self.m_funcClass = class
end

function NewPeddlerShopItemCell:OnDestroy()
  PictureManager.Instance:UnLoadUI(Tex_Lock, self.m_uiTexBg)
  PictureManager.Instance:UnLoadUI(Tex_UnLock, self.m_uiTexBg)
  NewPeddlerShopItemCell.super.OnDestroy(self)
end

function NewPeddlerShopItemCell:OnDisable()
  PictureManager.Instance:UnLoadUI(Tex_Lock, self.m_uiTexBg)
  PictureManager.Instance:UnLoadUI(Tex_UnLock, self.m_uiTexBg)
  NewPeddlerShopItemCell.super.OnDisable(self)
end

function NewPeddlerShopItemCell:isShowItem()
  local canBuyCount, limitType = HappyShopProxy.Instance:GetCanBuyCount(self.m_data)
  if self.m_data.m_isMysticalShop == true then
    return 0 < canBuyCount
  elseif self.unlockcur then
    return 0 < canBuyCount
  end
  return false
end
