PaySignRewardCell = class("PaySignRewardCell", ItemCell)
local SIGN_STYLE = {
  {
    bg_spriteName = "sign_bg_day1",
    bg2_Color = "0039ff19",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "adc1ef",
    index_Color = "8baadf",
    cat_spriteName = "sign_pic_cat_day1",
    embeSp_Color = "7088c1"
  },
  {
    bg_spriteName = "sign_bg_day2",
    bg2_Color = "0039ff19",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "adc1ef",
    index_Color = "778ee0",
    cat_spriteName = "sign_pic_cat_day2",
    embeSp_Color = "7088c1"
  },
  {
    bg_spriteName = "sign_bg_day3",
    bg2_Color = "aeb5fe",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "adc1ef",
    index_Color = "8290d2",
    cat_spriteName = "sign_pic_cat_day3",
    embeSp_Color = "707dc1"
  },
  {
    bg_spriteName = "sign_bg_day4",
    bg2_Color = "abacfe",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "adc1ef",
    index_Color = "7971d9",
    cat_spriteName = "sign_pic_cat_day4",
    embeSp_Color = "707dc1"
  },
  {
    bg_spriteName = "sign_bg_day5",
    bg2_Color = "a6a3fe",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "acbbed",
    index_Color = "8366cc",
    cat_spriteName = "sign_pic_cat_day5",
    embeSp_Color = "707dc1"
  },
  {
    bg_spriteName = "sign_bg_day6",
    bg2_Color = "a69efe",
    bg3_spriteName = "sign_bg_icon1",
    bg4_Color = "acbbed",
    index_Color = "7858b3",
    cat_spriteName = "sign_pic_cat_day6",
    embeSp_Color = "707dc1"
  },
  {
    bg_spriteName = "sign_bg_day7",
    bg2_Color = "f2baa8",
    bg3_spriteName = "sign_bg_icon2",
    bg4_Color = "f1deb2",
    index_Color = "ff9656",
    cat_spriteName = "sign_pic_cat_day7",
    embeSp_Color = "9a655e"
  }
}

function PaySignRewardCell:Init()
  local itemroot = self:FindGO("Item")
  local itemCell = self:FindGO("Common_ItemCell")
  if not itemCell then
    local go = self:LoadPreferb("cell/ItemCell", itemroot)
    go.name = "Common_ItemCell"
  end
  self.finishFlag = self:FindGO("Finished")
  self.finishLabel = self:FindGO("FinishLabel", self.finishFlag):GetComponent(UILabel)
  self.cbg = self:FindComponent("Bg0", UISprite)
  self.cbg2 = self:FindComponent("Bg2", UISprite)
  self.cbg3 = self:FindComponent("Bg3", UISprite)
  self.cbg4 = self:FindComponent("Bg4", UISprite)
  self.index = self:FindComponent("Index", UILabel)
  self.cat = self:FindComponent("Cat", UISprite)
  self.embe = self:FindComponent("Embe", UISprite)
  self.embe1 = self:FindComponent("Embe1", UISprite)
  self.embeSp = self:FindComponent("EmbeSp", UISprite)
  self.customNum = self:FindComponent("CustomNum", UILabel)
  PaySignRewardCell.super.Init(self)
  self:HideNum()
  self:AddClickEvent(self.gameObject, function()
    local stick = self.gameObject:GetComponent(UIWidget)
    local callback = function()
      self:CancelChoose()
    end
    local tipdata = ReusableTable.CreateTable()
    if self.data.DepositID then
      local info = NewRechargeProxy.Ins:GenerateDepositGoodsInfo(self.data.DepositID)
      local itemID = info.productConf.ItemId
      tipdata.itemdata = ItemData.new("Reward", itemID)
    else
      tipdata.itemdata = self.data
    end
    tipdata.funcConfig = {}
    tipdata.callback = callback
    TipManager.Instance:ShowItemFloatTip(tipdata, stick, NGUIUtil.AnchorSide.Right, {220, 0})
    ReusableTable.DestroyAndClearTable(tipdata)
  end)
  self.buyBtn = self:FindGO("BuyBtn")
  self.buyBtn_Price = self:FindGO("Label", self.buyBtn):GetComponent(UILabel)
  self.buyBtn_Icon = self:FindGO("icon", self.buyBtn):GetComponent(UISprite)
  self.buyBtn_LimitLabel = self:FindGO("LimitLabel", self.buyBtn):GetComponent(UILabel)
  self:AddClickEvent(self.buyBtn, function()
    self:PassEvent(UICellEvent.OnLeftBtnClicked, self)
  end)
  self.lock = self:FindGO("Lock")
  self.signBtn = self:FindGO("SignBtn")
  self:AddClickEvent(self.signBtn, function()
    self:PassEvent(UICellEvent.OnCellClicked, self)
  end)
end

function PaySignRewardCell:CancelChoose()
  self:ShowItemTip()
end

function PaySignRewardCell:SetStyle(style)
  if not style then
    return
  end
  self.cbg.spriteName = style.bg_spriteName
  self.cbg3.spriteName = style.bg3_spriteName
  local suc1, col1 = ColorUtil.TryParseHexString(style.bg2_Color)
  if suc1 then
    self.cbg2.color = col1
    self.embe.color = col1
    self.embe1.color = col1
  end
  local suc2, col2 = ColorUtil.TryParseHexString(style.index_Color)
  if suc2 then
    self.index.color = col2
  end
  self.cat.spriteName = style.cat_spriteName
  local suc3, col3 = ColorUtil.TryParseHexString(style.embeSp_Color)
  if suc3 then
    self.embeSp.color = col3
    self.customNum.effectColor = col3
  end
  local suc4, col4 = ColorUtil.TryParseHexString(style.bg4_Color)
  if suc4 then
    self.cbg4.color = col4
  end
end

function PaySignRewardCell:SetData(data)
  self.data = data
  if data then
    if data.staticData then
      PaySignRewardCell.super.SetData(self, data)
      if self.numLab then
        self.numLab.effectStyle = UILabel.Effect.Outline
      end
      local bg = self:GetBgSprite()
      if bg then
        self:Hide(bg)
      end
      self:SetGOActive(self.empty, false)
      self.index.text = string.format(ZhString.PaySignRewardView_DayIndex, data.index)
      self.customNum.text = "x" .. data.num
    elseif data.ShopID then
      self.shopItemData = ShopProxy.Instance:GetConfigByTypeId(data.ShopType, data.ShopID)
      local _HappyShopProxy = HappyShopProxy.Instance
      local canBuyCount, limitType = _HappyShopProxy:GetCanBuyCount(self.shopItemData)
      if canBuyCount == 0 then
        redlog("已售罄")
        self.buyBtn:SetActive(false)
      else
        self.buyBtn:SetActive(true)
      end
      if canBuyCount ~= nil then
        local str = string.format(ZhString.NewRecharge_BuyLimit_Acc_Ever, maxLimit - canBuyCount, maxLimit)
        self.buyBtn_LimitLabel.gameObject:SetActive(true)
        self.buyBtn_LimitLabel.text = str
      else
        self.buyBtn_LimitLabel.gameObject:SetActive(false)
      end
      self.buyBtn_Price.text = StringUtil.NumThousandFormat(self.shopItemData.ItemCount)
    elseif data.DepositID then
      self.buyBtn:SetActive(true)
      self.buyBtn_Icon.gameObject:SetActive(false)
      local info = NewRechargeProxy.Ins:GenerateDepositGoodsInfo(data.DepositID)
      local purchasedTimes, purchaseLimitTimes
      purchasedTimes = info.purchaseTimes or 0
      purchaseLimitTimes = info.purchaseLimit_N or 0
      local formatString = info.purchaseLimitStr
      if 9999 <= purchaseLimitTimes or purchaseLimitTimes <= 0 or not formatString then
        self.buyBtn_LimitLabel.gameObject:SetActive(false)
        redlog("无限次购买  不符合设计")
      else
        if purchasedTimes == purchaseLimitTimes then
          xdlog("deposit 售罄")
          self:SetFinishFlag(true)
          self.buyBtn:SetActive(false)
          self.finishLabel.text = ZhString.NewRechargeRecommendTShopGoodsCell_SoldOut
        end
        self.buyBtn_LimitLabel.gameObject:SetActive(true)
        self.buyBtn_LimitLabel.text = string.format(formatString, purchasedTimes, purchaseLimitTimes)
      end
      self.buyBtn_Price.text = info.productConf.priceStr or info.productConf.CurrencyType .. " " .. FunctionNewRecharge.FormatMilComma(info.productConf.Rmb)
      local itemID = info.productConf.ItemId
      local itemData = ItemData.new("Reward", itemID)
      itemData:SetItemNum(info.productConf.Count)
      self:SetIcon(itemData)
      self:UpdateNumLabel(info.productConf.Count)
      self.customNum.text = "x" .. info.productConf.Count
      self.index.text = itemData.staticData and itemData.staticData.NameZh
    end
    self.gameObject:SetActive(true)
  else
    self.gameObject:SetActive(false)
  end
end

function PaySignRewardCell:SetFinishFlag(var)
  self.finishFlag:SetActive(var)
  self:SetIconDark(var)
  if var and self.numLab then
    self.numLab.effectStyle = UILabel.Effect.None
  end
end

function PaySignRewardCell:SetSignBtnActive(bool)
  self.signBtn:SetActive(bool)
end

function PaySignRewardCell:SetLock(bool)
  self.lock:SetActive(bool)
end

function PaySignRewardCell:RefreshSelf()
  self:SetData(self.data)
end
