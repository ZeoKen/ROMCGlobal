autoImport("BaseCell")
autoImport("ActivityBattlePassItemCell")
ActivityBattlePassLevelRewardCell = class("ActivityBattlePassLevelRewardCell", BaseCell)

function ActivityBattlePassLevelRewardCell:GetIsNormalRewardReceived(level)
  return ActivityBattlePassProxy.Instance:IsNormalRewardReceived(self.data.ActID, level)
end

function ActivityBattlePassLevelRewardCell:GetIsNormalRewardLocked(level)
  return ActivityBattlePassProxy.Instance:IsNormalRewardLocked(self.data.ActID, level)
end

function ActivityBattlePassLevelRewardCell:GetIsProRewardReceived(level)
  return ActivityBattlePassProxy.Instance:IsProRewardReceived(self.data.ActID, level)
end

function ActivityBattlePassLevelRewardCell:GetIsProRewardLocked(level)
  return ActivityBattlePassProxy.Instance:IsProRewardLocked(self.data.ActID, level)
end

function ActivityBattlePassLevelRewardCell:Init()
  ActivityBattlePassLevelRewardCell.super.Init(self)
  self:FindObjs()
end

function ActivityBattlePassLevelRewardCell:FindObjs()
  self.levelLabel = self:FindComponent("Level", UILabel)
  self.receivedSp = self:FindGO("get")
  self.locker = self:FindGO("Locker")
  self.getLabel = self:FindGO("GetLabel")
  local basic = self:FindGO("Basic")
  self.basicHolder = self:FindGO("holder", basic)
  self.basicReceivedCheck = self:FindGO("BasicGet")
  local adv = self:FindGO("Adv")
  self.advHolder = self:FindGO("holder", adv)
  self.basicMask = self:FindGO("BasicCover")
  self.advMask = self:FindGO("AdvCover")
  self:AddClickEvent(basic, function()
    self:HandleClickRewardIcon(self.basicItemCell)
  end)
  self:AddClickEvent(adv, function()
    self:HandleClickRewardIcon(self.advItemCell)
  end)
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.buyBtn = self:FindGO("BuyBtn")
  self.buyBtn_Price = self:FindGO("Label", self.buyBtn):GetComponent(UILabel)
  self.buyBtn_Icon = self:FindGO("icon", self.buyBtn):GetComponent(UISprite)
  self.buyBtn_LimitLabel = self:FindGO("LimitLabel", self.buyBtn):GetComponent(UILabel)
  self:AddClickEvent(self.buyBtn, function()
    self:PassEvent(UICellEvent.OnCellClicked, self)
  end)
end

function ActivityBattlePassLevelRewardCell:SetData(data)
  if data then
    self.data = data
    self.level = data.Level
    self.levelLabel.text = "Lv." .. self.level
    local basicRewardItem = data.RewardItems[1]
    local proRewardItem = data.ProRewardItems[1]
    if not self.basicItemCell then
      self.basicItemCell = self:SetRewardIcon(basicRewardItem, self.basicHolder)
    else
      local data = self.basicItemCell.data
      data:ResetData(basicRewardItem.itemid, basicRewardItem.itemid)
      data:SetItemNum(basicRewardItem.num)
      self.basicItemCell:SetData(data)
    end
    if not self.advItemCell then
      self.advItemCell = self:SetRewardIcon(proRewardItem, self.advHolder)
    else
      local data = self.advItemCell.data
      data:ResetData(proRewardItem.itemid, proRewardItem.itemid)
      data:SetItemNum(proRewardItem.num)
      self.advItemCell:SetData(data)
    end
    self:RefreshRecvState(self.level)
  end
end

function ActivityBattlePassLevelRewardCell:SetRewardIcon(data, holder)
  if not data then
    return
  end
  local itemCell = ActivityBattlePassItemCell.new(holder)
  itemCell:AddCellClickEvent()
  local itemData = ItemData.new(data.itemid, data.itemid)
  itemData:SetItemNum(data.num)
  itemCell:SetData(itemData)
  return itemCell
end

function ActivityBattlePassLevelRewardCell:RefreshRecvState(level)
  local isBasicReceived = self:GetIsNormalRewardReceived(level)
  local isBasicLocked = self:GetIsNormalRewardLocked(level)
  local isAdvReceived = self:GetIsProRewardReceived(level)
  local isAdvLocked = self:GetIsProRewardLocked(level)
  local isRewardAvailable = not isBasicLocked and not isBasicReceived or not isAdvLocked and not isAdvReceived
  self.basicReceivedCheck:SetActive(isBasicReceived and not isAdvReceived or false)
  self.basicMask:SetActive(isBasicLocked)
  self.advMask:SetActive(isAdvLocked)
  self.receivedSp:SetActive(isBasicReceived and isAdvReceived or false)
  self.locker:SetActive(isAdvLocked and (isBasicLocked or isBasicReceived) or false)
  self.getLabel:SetActive(isRewardAvailable)
  self.buyBtn:SetActive(false)
  if isBasicReceived then
    self:UpdateBuyInfo()
  end
end

function ActivityBattlePassLevelRewardCell:UpdateBuyInfo()
  self.buyBtn:SetActive(false)
  if self.data.DepositID then
    if ShopProxy.Instance:GetDepositItemCanBuy(self.data.DepositID) then
      local info = NewRechargeProxy.Ins:GenerateDepositGoodsInfo(self.data.DepositID)
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
          return true
        end
        self.buyBtn_LimitLabel.gameObject:SetActive(true)
        self.buyBtn_LimitLabel.text = string.format(formatString, purchasedTimes, purchaseLimitTimes)
      end
      self.receivedSp:SetActive(false)
      self.buyBtn:SetActive(true)
      self.buyBtn_Icon.gameObject:SetActive(false)
      self.buyBtn_Price.text = info.productConf.priceStr or info.productConf.CurrencyType .. " " .. FunctionNewRecharge.FormatMilComma(info.productConf.Rmb)
      if self.advItemCell then
        local proRewardItem = {
          itemid = info.productConf.ItemId,
          num = info.productConf.Count
        }
        local data = self.advItemCell.data
        data:ResetData(proRewardItem.itemid, proRewardItem.itemid)
        data:SetItemNum(proRewardItem.num)
        self.advItemCell:SetData(data)
        self.advMask:SetActive(false)
      else
        local proRewardItem = {
          itemid = info.productConf.ItemId,
          num = info.productConf.Count
        }
        local data = self.basicItemCell.data
        data:ResetData(proRewardItem.itemid, proRewardItem.itemid)
        data:SetItemNum(proRewardItem.num)
        self.basicItemCell:SetData(data)
        if self.nameLabel then
          self.nameLabel.text = data.staticData and data.staticData.NameZh
        end
      end
    end
  elseif self.data.ShopItemID then
    local shopInfo = GameConfig.ActivityBattlePass and GameConfig.ActivityBattlePass[self.data.ActID] and GameConfig.ActivityBattlePass[self.data.ActID].ShopInfo
    if not shopInfo then
      redlog("未配置ShopInfo", self.data.ActID)
      return
    end
    local shopItemData = ShopProxy.Instance:GetShopItemDataByTypeId(shopInfo.ShopType, shopInfo.ShopId, self.data.ShopItemID)
    if not shopItemData then
      redlog("商品信息不存在")
      return
    end
    local _HappyShopProxy = HappyShopProxy.Instance
    local canBuyCount, limitType = _HappyShopProxy:GetCanBuyCount(shopItemData)
    local maxLimit = shopItemData.LimitNum
    if canBuyCount == 0 then
      redlog("售罄")
      return
    end
    if canBuyCount ~= nil then
      local str = string.format(ZhString.NewRecharge_BuyLimit_Acc_Ever, maxLimit - canBuyCount, maxLimit)
      self.buyBtn_LimitLabel.gameObject:SetActive(true)
      self.buyBtn_LimitLabel.text = str
    else
      self.buyBtn_LimitLabel.gameObject:SetActive(false)
    end
    self.buyBtn_Price.text = StringUtil.NumThousandFormat(self.shopItemData.ItemCount)
    self.buyBtn:SetActive(true)
    self.receivedSp:SetActive(false)
    if self.advItemCell then
      local proRewardItem = {
        itemid = shopItemData.goodsID,
        num = shopItemData.goodsCount
      }
      local data = self.advItemCell.data
      data:ResetData(proRewardItem.itemid, proRewardItem.itemid)
      data:SetItemNum(proRewardItem.num)
      self.advItemCell:SetData(data)
      self.advMask:SetActive(false)
    else
      local proRewardItem = {
        itemid = shopItemData.goodsID,
        num = shopItemData.goodsCount
      }
      local data = self.basicItemCell.data
      data:ResetData(proRewardItem.itemid, proRewardItem.itemid)
      data:SetItemNum(proRewardItem.num)
      self.basicItemCell:SetData(data)
    end
  end
end

function ActivityBattlePassLevelRewardCell:HandleClickRewardIcon(cellCtrl)
  if cellCtrl and cellCtrl.data then
    self.tipData.itemdata = cellCtrl.data
    local x, y, z = NGUIUtil.GetUIPositionXYZ(cellCtrl.icon.gameObject)
    if 0 < x then
      self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Left, {-280, 0})
    else
      self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Right, {280, 0})
    end
  end
end
