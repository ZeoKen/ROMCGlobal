TimeLimitShopView = class("TimeLimitShopView", BaseView)
TimeLimitShopView.ViewType = UIViewType.NormalLayer

function TimeLimitShopView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:InitData()
end

function TimeLimitShopView:FindObjs()
  self.titleLabel = self:FindGO("TitleLabel"):GetComponent(UILabel)
  self.timeLabel = self:FindGO("TimeLabel"):GetComponent(UILabel)
  self.itemIcon = self:FindGO("ItemIcon"):GetComponent(UISprite)
  self.sale = self:FindGO("Sale")
  self.saleLabel = self:FindGO("SaleLabel", self.sale):GetComponent(UILabel)
  self.tipLabel = self:FindGO("TipLabel"):GetComponent(UILabel)
  self.itemScrollView = self:FindGO("ItemScrollView"):GetComponent(UIScrollView)
  self.itemGrid = self:FindGO("ItemGrid"):GetComponent(UIGrid)
  self.itemListCtrl = UIGridListCtrl.new(self.itemGrid, RewardGridCell, "RewardGridCellType2")
  self.itemListCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickItem, self)
  self.bgTexture = self:FindGO("BGTexture"):GetComponent(UITexture)
  PictureManager.Instance:SetUI("Gift_bg_03", self.bgTexture)
  self.buyBtn = self:FindGO("BuyBtn")
  self.helpBtn = self:FindGO("HelpBtn")
  self.priceGO = self:FindGO("Price", self.purchaseBtn)
  self.priceBG = self.priceGO:GetComponent(UISprite)
  self.price_Label = self:FindGO("PriceLabel", self.priceGO):GetComponent(UILabel)
  self.price_Icon = self:FindGO("PriceIcon", self.priceGO):GetComponent(UISprite)
  local itemId = 151
  local itemData = Table_Item[itemId]
  if not itemData then
    redlog("Item表缺少配置", itemId)
  end
  IconManager:SetItemIcon(itemData.Icon, self.price_Icon)
  self.leftIndicator = self:FindGO("LeftIndicator")
  self.rightIndicator = self:FindGO("RightIndicator")
  self.effectContainer = self:FindGO("EffectContainer")
  self.titleTexture = self:FindGO("TitleTexture"):GetComponent(UITexture)
end

function TimeLimitShopView:AddEvts()
  self:AddClickEvent(self.buyBtn, function()
    local bCatGold = MyselfProxy.Instance:GetLottery()
    local cost = tonumber(self.price_Label.text)
    local title = self.titleLabel.text
    if bCatGold < cost then
      MsgManager.ConfirmMsgByID(41164, function()
        FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
        self:CloseSelf()
      end)
      return
    end
    local costStr = string.format(ZhString.Friend_RecallRewardItem, cost, Table_Item[151].NameZh)
    local shopItemData = ShopProxy.Instance:GetShopItemDataByTypeId(650, 1, self.curGoodID)
    if shopItemData then
      if BranchMgr.IsJapan() then
        OverseaHostHelper:GachaUseComfirm(cost, function()
          HappyShopProxy.Instance:BuyItemByShopItemData(shopItemData, 1, true)
        end)
      else
        MsgManager.ConfirmMsgByID(9630, function()
          HappyShopProxy.Instance:BuyItemByShopItemData(shopItemData, 1, true)
        end, nil, nil, costStr, title)
      end
    end
  end)
  self:TryOpenHelpViewById(35082, nil, self.helpBtn)
  self:AddClickEvent(self.leftIndicator, function()
    self:GoLeft()
  end)
  self:AddClickEvent(self.rightIndicator, function()
    self:GoRight()
  end)
  self:AddClickEvent(self.itemIcon.gameObject, function()
    local goodsID = self.shopItemData and self.shopItemData.goodsID
    local itemData = ItemData.new("Main", goodsID)
    if itemData then
      self.tipData.itemdata = itemData
      self:ShowItemTip(self.tipData, self.itemIcon, NGUIUtil.AnchorSide.Center, {200, -150})
    end
  end)
end

function TimeLimitShopView:AddMapEvts()
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.RecvBuyShopItem)
end

function TimeLimitShopView:InitData()
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function TimeLimitShopView:GoLeft()
  self.curPage = self.curPage - 1
  if self.curPage < 1 then
    self.curPage = 1
  end
  self.curGoodID = self.shopGoods[self.curPage]
  self:RefreshGoodPage(self.curGoodID)
  self:UpdateIndicator()
end

function TimeLimitShopView:GoRight()
  self.curPage = self.curPage + 1
  if self.curPage > self.maxPage then
    self.curPage = self.maxPage
  end
  self.curGoodID = self.shopGoods[self.curPage]
  self:RefreshGoodPage(self.curGoodID)
  self:UpdateIndicator()
end

function TimeLimitShopView:UpdateIndicator()
  if self.curPage == 1 then
    self.leftIndicator:SetActive(false)
  else
    self.leftIndicator:SetActive(true)
  end
  if self.curPage >= self.maxPage then
    self.rightIndicator:SetActive(false)
  else
    self.rightIndicator:SetActive(true)
  end
end

function TimeLimitShopView:InitShow()
  self.shopGoods = TimeLimitShopProxy.Instance.timeLimitGoods
  if not self.shopGoods or #self.shopGoods == 0 then
    self:CloseSelf()
    return
  end
  self.maxPage = #self.shopGoods
  local initPage = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.initPage or false
  self.curPage = 1
  if not initPage then
    local newStock = TimeLimitShopProxy.Instance.newInstock
    if newStock then
      for i = 1, #self.shopGoods do
        if self.shopGoods[i] == newStock then
          self.curPage = i
        end
      end
    end
  end
  self.curGoodID = self.shopGoods[self.curPage]
  self:RefreshGoodPage(self.curGoodID)
  self:UpdateIndicator()
end

function TimeLimitShopView:RefreshGoodPage(ShopItemID)
  xdlog("刷新商品界面", ShopItemID)
  local shopData = ShopProxy.Instance:GetShopDataByTypeId(650, 1)
  if not shopData then
    redlog("没有指定商店类型信息")
    return
  end
  local shopItemData
  local goods = shopData:GetGoods()
  for k, good in pairs(goods) do
    if good.id == ShopItemID then
      shopItemData = good
      break
    end
  end
  if not shopItemData then
    redlog("没有找到指定商品", ShopItemID)
    return
  end
  self.shopItemData = shopItemData
  local itemData = shopItemData:GetItemData()
  IconManager:SetItemIcon(itemData.staticData.Icon, self.itemIcon)
  self.titleLabel.text = shopItemData.nameZh or ""
  if shopItemData.showInfo then
    local mainList, subList = shopItemData.showInfo[1], shopItemData.showInfo[2]
    local result = {}
    for i = 1, #mainList do
      local data = {}
      local itemid = mainList[i].itemid
      data.itemData = ItemData.new("Goods", itemid)
      data.num = mainList[i].num or 1
      table.insert(result, data)
    end
    for i = 1, #subList do
      local data = {}
      local itemid = subList[i].itemid
      data.itemData = ItemData.new("Goods", itemid)
      data.num = subList[i].num or 1
      table.insert(result, data)
    end
    if 3 < #result then
      self.itemScrollView.contentPivot = UIWidget.Pivot.Left
    else
      self.itemScrollView.contentPivot = UIWidget.Pivot.Center
    end
    self.itemListCtrl:ResetDatas(result)
    self.itemScrollView:ResetPosition()
  end
  local superValue = 100
  local picture = ""
  for k, v in pairs(Table_ShopShow) do
    if v.ShopID == ShopItemID then
      superValue = v.SuperValue or 0
      picture = v.Picture
    end
  end
  if not IconManager:SetZenyShopItem(picture, self.itemIcon) then
    IconManager:SetItemIcon(itemData.staticData.Icon, self.itemIcon)
  end
  self.sale:SetActive(100 < superValue)
  self.saleLabel.text = superValue .. "%"
  self.price_Label.text = shopItemData.ItemCount or 0
  self.endTimeStamp = shopItemData.RemoveDate
  TimeTickManager.Me():ClearTick(self, 1)
  local canBuyCount = HappyShopProxy.Instance:GetCanBuyCount(shopItemData)
  if not canBuyCount or 0 < canBuyCount then
    TimeTickManager.Me():CreateTick(0, 1000, self.RefreshShopEndTime, self, 1)
  else
    self.timeLabel.text = ZhString.BattlePassUpgradeView_bought
    self.buyBtn:SetActive(false)
  end
end

function TimeLimitShopView:RefreshShopEndTime()
  local curServerTime = ServerTime.CurServerTime() / 1000
  if curServerTime > self.endTimeStamp then
    redlog("活动时间结束")
    TimeTickManager.Me():ClearTick(self, 1)
    self.buyBtn:SetActive(false)
    self.timeLabel.text = ZhString.ActivityPuzzle_Outtime
    return
  elseif not self.buyBtn.activeSelf then
    self.buyBtn:SetActive(true)
  end
  local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(self.endTimeStamp)
  if 0 < leftDay then
    self.timeLabel.text = string.format(ZhString.NoviceBattlePassRemainTime, leftDay, leftHour)
  elseif 0 < leftHour then
    self.timeLabel.text = string.format(ZhString.NoviceBattlePassRemainTimeHourMin, leftHour, leftMin)
  elseif 0 < leftMin or 0 < leftSec then
    self.timeLabel.text = string.format(ZhString.NoviceBattlePassRemainTimeMin, leftMin)
  end
end

function TimeLimitShopView:RefreshTweenShow()
  self.discount_TweenAlpha:ResetToBeginning()
  self.costNum_TweenAlpha:ResetToBeginning()
  self.discount_TweenAlpha:PlayForward()
  self.costNum_TweenAlpha:PlayForward()
end

function TimeLimitShopView:RecvQueryShopConfig()
  self:InitShow()
end

function TimeLimitShopView:RecvBuyShopItem(note)
  local success = note.body.success
  xdlog("购买是否成功", success)
  if success then
    local id = note.body.id or self.curGoodID
    TimeLimitShopProxy.Instance:RemoveGood(id)
    local shopData = ShopProxy.Instance:GetShopDataByTypeId(650, 1)
    if shopData then
      shopData:RemoveShopItemData(id)
    end
    self:CloseSelf()
  end
end

function TimeLimitShopView:handleClickItem(cellCtrl)
  xdlog("点击查看商品")
  local data = cellCtrl and cellCtrl.data
  local itemData = data and data.itemData
  if itemData then
    self.tipData.itemdata = itemData
    self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Center, {200, -150})
  end
end

function TimeLimitShopView:OnEnter()
  ServiceSessionShopProxy.Instance:CallQueryShopConfigCmd(650, 1)
  TimeLimitShopView.super.OnEnter(self)
  PictureManager.Instance:SetUI("Gift_bg_03", self.bgTexture)
  PictureManager.Instance:SetUI("Gift_bg_title", self.titleTexture)
  TimeLimitShopProxy.Instance.showView = false
  self:PlayUIEffect(EffectMap.UI.DisneyBubble, self.effectContainer)
end

function TimeLimitShopView:OnExit()
  PictureManager.Instance:UnLoadUI("Gift_bg_03", self.bgTexture)
  PictureManager.Instance:UnLoadUI("Gift_bg_title", self.titleTexture)
  TimeLimitShopView.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  TimeLimitShopProxy.Instance:RemoveAllGoods()
end
