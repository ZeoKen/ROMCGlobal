local BaseCell = autoImport("BaseCell")
PeddlerShopFlipCell = class("PeddlerShopFlipCell", BaseCell)
local triColors = {
  [1] = LuaColor(1, 0.9803921568627451, 0.8431372549019608, 1),
  [2] = LuaColor(0.803921568627451, 0.8705882352941177, 0.9607843137254902, 1),
  [3] = LuaColor(1, 0.8862745098039215, 0.8392156862745098, 1),
  [4] = LuaColor(1, 1, 1, 1),
  [5] = LuaColor(1, 1, 1, 1)
}

function PeddlerShopFlipCell:Init()
  PeddlerShopFlipCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function PeddlerShopFlipCell:FindObjs()
  self.uipanel = self.gameObject:GetComponent(UIPanel)
  self.tweenTrans = self.gameObject:GetComponent(TweenTransform)
  self.tweenAlpha = self.gameObject:GetComponent(TweenAlpha)
  self.page = self:FindGO("page")
  self.mark = self:FindGO("mark")
  self.markcolor = self:FindComponent("bg", UISprite, self.mark)
  self.marklv = self:FindComponent("lv", UIMultiSprite, self.mark)
  self.title = self:FindComponent("title", UILabel, self.page)
  self.limit = self:FindComponent("limit", UILabel, self.page)
  self.unlock = self:FindComponent("unlock", UILabel, self.page)
  self.itemIcon = self:FindComponent("itemIcon", UISprite, self.page)
  self.num = self:FindComponent("num", UILabel, self.page)
  self.soldout = self:FindGO("SoldOut")
  self.purchase = self:FindGO("PurchaseBtn")
  self.purchaseColl = self.purchase:GetComponent(BoxCollider)
  self.coin = self:FindComponent("Icon", UISprite, self.purchase)
  self.price = self:FindComponent("Price", UILabel, self.purchase)
  self.countInput = self:FindGO("CountBg"):GetComponent(UIInput)
  self.countPlusBg = self:FindGO("CountPlusBg"):GetComponent(UISprite)
  self.countPlus = self:FindGO("Plus", self.countPlusBg.gameObject):GetComponent(UISprite)
  self.countSubtractBg = self:FindGO("CountSubtractBg"):GetComponent(UISprite)
  self.countSubtract = self:FindGO("Subtract", self.countSubtractBg.gameObject):GetComponent(UISprite)
  UIUtil.LimitInputCharacter(self.countInput, 8)
end

function PeddlerShopFlipCell:AddEvts()
  self:AddClickEvent(self.itemIcon.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:AddClickEvent(self.purchase, function()
    local ret = HappyShopProxy.Instance:BuyItem(self.goodsID, self.count, true)
    if ret then
      NewRechargeProxy.Instance:readyTriggerEventId(117)
    else
      NewRechargeProxy.Instance:readyTriggerEventId(0)
    end
  end)
  self:AddPressEvent(self.countPlusBg.gameObject, function(g, b)
    self:PlusPressCount(b)
  end)
  self:AddPressEvent(self.countSubtractBg.gameObject, function(g, b)
    self:SubtractPressCount(b)
  end)
  EventDelegate.Set(self.countInput.onChange, function()
    self:InputOnChange()
  end)
  EventDelegate.Set(self.countInput.onSubmit, function()
    self:InputOnSubmit()
  end)
end

function PeddlerShopFlipCell:SetData(data)
  if data == "is_test" then
    return
  end
  self.idx = data[2]
  self.shopItemData = data[1]
  self.goodsID = self.shopItemData.id
  self.itemConf = Table_Item[self.shopItemData.goodsID]
  IconManager:SetItemIcon(self.itemConf.Icon, self.itemIcon)
  self.num.text = self.shopItemData.goodsCount
  self.title.text = self.itemConf.NameZh
  local canBuyCount, limitType = HappyShopProxy.Instance:GetCanBuyCount(self.shopItemData)
  if limitType and canBuyCount then
    self.limit.text = string.format(ZhString.PeddlerShop_buyLimit, canBuyCount)
  else
    self.limit.text = ""
  end
  if canBuyCount and canBuyCount == 0 then
    self.soldout:SetActive(true)
    self.purchase:GetComponent(BoxCollider).enabled = false
    self:SetTextureGrey(self.purchase)
    self.purchase:SetActive(false)
  else
    self.soldout:SetActive(false)
    self.purchase:GetComponent(BoxCollider).enabled = true
    self:SetTextureWhite(self.purchase, ColorUtil.ButtonLabelOrange)
    self.purchase:SetActive(true)
  end
  local costItem = Table_Item[self.shopItemData.ItemID]
  IconManager:SetItemIcon(costItem.Icon, self.coin)
  self.maxcount = canBuyCount or 0
  self:UpdateTotalPrice(math.min(self.maxcount, 1))
  self.canBuyCount = canBuyCount
  self.unlockcur = PeddlerShopProxy.Instance:CheckUnlockByPre(self.goodsID)
  if not self.unlockcur then
    self.unlock.text = ZhString.PeddlerShop_unlockCur
    self.purchaseColl.enabled = false
    self:SetTextureGrey(self.purchase)
  else
    self.purchaseColl.enabled = true
    self:SetTextureWhite(self.purchase)
    self.buyCount = HappyShopProxy.Instance:GetCachedHaveBoughtItemCount(self.goodsID) or 0
    local unlockNext = math.max(0, self.shopItemData.unlocknextcount - self.buyCount)
    self.unlock.text = unlockNext <= 0 and "" or string.format(ZhString.PeddlerShop_unlockNext, unlockNext)
  end
  self.marklv.CurrentState = self.idx - 1
  self.markcolor.color = triColors[self.idx]
end

function PeddlerShopFlipCell:OnLayout()
  if self.tIdx and type(self.tIdx) == "number" and self.tIdx < 0 then
    self.page.transform.localPosition = LuaGeometry.GetTempVector3(20, 0, 0)
    self.mark.transform.localScale = LuaGeometry.GetTempVector3(-1, 1, 1)
  else
    self.page.transform.localPosition = LuaGeometry.GetTempVector3(-20, 0, 0)
    self.mark.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  end
end

function PeddlerShopFlipCell:NotSoldOut()
  return self.canBuyCount and self.canBuyCount > 0
end

function PeddlerShopFlipCell:InputOnChange()
  local count = tonumber(self.countInput.value)
  if count == nil then
    return
  end
  if self.maxcount == 0 then
    count = 0
    self:SetCountPlus(0.5)
    self:SetCountSubtract(0.5)
  elseif count <= 1 then
    count = 1
    self:SetCountPlus(1)
    self:SetCountSubtract(0.5)
  elseif count >= self.maxcount then
    count = self.maxcount
    self:SetCountPlus(0.5)
    self:SetCountSubtract(1)
  else
    self:SetCountPlus(1)
    self:SetCountSubtract(1)
  end
  self:UpdateTotalPrice(count)
end

function PeddlerShopFlipCell:InputOnSubmit()
  local count = tonumber(self.countInput.value)
  if count == nil then
    self.countInput.value = self.count
  end
end

function PeddlerShopFlipCell:SetCountPlus(alpha)
  if self.countPlusBg.color.a ~= alpha then
    self:SetSpritAlpha(self.countPlusBg, alpha)
    self:SetSpritAlpha(self.countPlus, alpha)
  end
end

function PeddlerShopFlipCell:SetCountSubtract(alpha)
  if self.countSubtractBg.color.a ~= alpha then
    self:SetSpritAlpha(self.countSubtractBg, alpha)
    self:SetSpritAlpha(self.countSubtract, alpha)
  end
end

function PeddlerShopFlipCell:SetSpritAlpha(sprit, alpha)
  sprit.color = Color(sprit.color.r, sprit.color.g, sprit.color.b, alpha)
end

function PeddlerShopFlipCell:PlusPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(1)
    end, self, 1001)
  else
    TimeTickManager.Me():ClearTick(self, 1001)
  end
end

function PeddlerShopFlipCell:SubtractPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(-1)
    end, self, 1002)
  else
    TimeTickManager.Me():ClearTick(self, 1002)
  end
end

function PeddlerShopFlipCell:UpdateCount(change)
  if tonumber(self.countInput.value) == nil then
    self.countInput.value = self.count
  end
  local count = tonumber(self.countInput.value) + self.countChangeRate * change
  if count < 1 then
    self.countChangeRate = 1
    return
  elseif count > self.maxcount then
    self.countChangeRate = 1
    return
  end
  self:UpdateTotalPrice(count)
  if self.countChangeRate <= 3 then
    self.countChangeRate = self.countChangeRate + 1
  end
end

function PeddlerShopFlipCell:UpdateTotalPrice(count)
  self.count = count
  local total = self.shopItemData.ItemCount * count
  self.price.text = StringUtil.NumThousandFormat(total)
  if self.countInput.value ~= tostring(count) then
    self.countInput.value = count
  end
end
