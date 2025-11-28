StorePayPanel = class("StorePayPanel", BaseView)
StorePayPanel.ViewType = UIViewType.PopUpLayer

function StorePayPanel:Init()
  self:LoadView()
end

function StorePayPanel:LoadView()
  self.promotingIap = PlayerPrefs.GetString("PromotingIAP")
  PlayerPrefs.DeleteKey("PromotingIAP")
  helplog(self.promotingIap)
  self.curProduct = nil
  for _, v in pairs(Table_Deposit) do
    local tpro = v
    if self.promotingIap ~= "" and tpro.ProductID == self.promotingIap then
      self.curProduct = tpro
      break
    end
  end
  local isDiscount = false
  self.activity = NewRechargeProxy.Ins:Deposit_GetProductActivity(self.curProduct.id)
  if self.activity ~= nil then
    self.discountActivity = self.activity[1]
    if self.discountActivity ~= nil then
      local dActivityEndTime = self.discountActivity[5]
      local serverTime = ServerTime.CurServerTime() / 1000
      if dActivityEndTime > serverTime then
        local activityTimes = self.discountActivity[1]
        local activityUsedTimes = self.discountActivity[3]
        if activityTimes > activityUsedTimes then
          self.curProduct = Table_Deposit[self.discountActivity[2]]
          isDiscount = true
        end
      end
    end
  elseif self.curProduct.Type == 4 and OverseaHostHelper:DateValid(self.curProduct.Release_OpenTime, self.curProduct.Release_CloseTime) then
    isDiscount = true
  end
  if self.curProduct ~= nil then
    self.PayBtn = self:FindGO("PayBtn")
    self:AddClickEvent(self.PayBtn, function(go)
      StorePayPanel:Pay(self.curProduct.ProductID)
    end)
    self.CloseBtn = self:FindGO("CloseButton")
    self:AddClickEvent(self.CloseBtn, function(go)
      self:PayEnd()
    end)
    self.title = self:FindGO("Title"):GetComponent(UILabel)
    self.title.text = self.curProduct and self.curProduct.Desc or ""
    self.paytitle = self:FindGO("PayTitle"):GetComponent(UILabel)
    self.paytitle.text = self.curProduct.priceStr ~= nil and self.curProduct.priceStr or "$" .. self.curProduct.Rmb
    self.zenytitle = self:FindGO("ZenyTitle"):GetComponent(UILabel)
    self.zenytitle.text = self.curProduct.priceStr ~= nil and self.curProduct.priceStr or "$" .. self.curProduct.Rmb
    local iconName = self.curProduct and self.curProduct.Picture or ""
    self.goIcon = self:FindGO("zeny", self.gameObject)
    self.spIcon = self.goIcon:GetComponent(UISprite)
    IconManager:SetZenyShopItem(iconName, self.spIcon)
    self.spIcon:MakePixelPerfect()
    local priceObj = self:FindGO("price")
    local productDes = self:FindGO("producDes")
    local priceSprite = priceObj:GetComponent(UISprite)
    if self.curProduct.Type == 1 then
      IconManager:SetItemIcon(Table_Item[100].Icon, priceSprite)
      priceSprite.width = 50
      priceSprite.height = 50
    elseif self.curProduct.Type == 3 then
      IconManager:SetItemIcon("item_151", priceSprite)
      priceSprite.width = 60
      priceSprite.height = 60
    end
    if self.curProduct.MonthLimit ~= nil then
      self.productDesLabel = productDes:GetComponent(UILabel)
      priceObj:SetActive(false)
      if isDiscount then
        local purchaseTimes = NewRechargeProxy.Ins:Deposit_GetLuckyBagPurchaseTimes(self.curProduct.id)
        if purchaseTimes >= self.curProduct.MonthLimit then
          self.productDesLabel.text = FunctionNewRecharge.PaintColorPurchaseTimes(string.format(ZhString.IAPBoughtLimit, self.curProduct.Desc))
          self.PayBtn:SetActive(false)
          self.productDesLabel.transform.localPosition = LuaGeometry.GetTempVector3(0, -130, 0)
        else
          self.PayBtn:SetActive(true)
          if self.curProduct.MonthLimit == 9999 then
            self.productDesLabel.gameObject:SetActive(false)
          end
          self.productDesLabel.text = FunctionNewRecharge.PaintColorPurchaseTimes(string.format(ZhString.LuckyBag_PurchaseTimesMonth, purchaseTimes, FunctionNewRecharge.PaintColorMorePurchaseTimes(self.curProduct.MonthLimit)))
        end
      else
        self.productDesLabel.text = FunctionNewRecharge.PaintColorPurchaseTimes(ZhString.ActivityProductLimit)
        self.PayBtn:SetActive(false)
        self.productDesLabel.transform.localPosition = LuaGeometry.GetTempVector3(0, -130, 0)
      end
    else
      productDes:SetActive(false)
    end
  end
  helplog(isDiscount)
end

function StorePayPanel:GetOriginProduct(activity_product)
  if activity_product == "com.gravity.romg.2019_card30" then
    activity_product = "com.gravity.romg.2019_card68"
  end
  local productID = Table_Deposit[activity_product].ProductID
  for k, v in pairs(Table_Deposit) do
    if string.find(productID, v.ProductID) ~= nil then
      return k
    end
  end
  return nil
end

function StorePayPanel:Pay(productID)
  local productCount = 1
  local roleGrade = MyselfProxy.Instance:RoleLevel() or 0
  local server = FunctionLogin.Me():getCurServerData()
  local serverID = server ~= nil and server.sid or nil
  local roleID = Game.Myself and Game.Myself.data and Game.Myself.data.id or nil
  local this = self
end

function StorePayPanel:PayEnd()
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, StorePayPanel.ViewType)
end

function StorePayPanel:OnEnter()
  StorePayPanel.super.OnEnter(self)
end

function StorePayPanel:OnExit()
  StorePayPanel.super.OnExit(self)
end
