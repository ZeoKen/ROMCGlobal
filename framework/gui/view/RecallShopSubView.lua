RecallShopSubView = class("RecallShopSubView", SubMediatorView)
autoImport("RecallShopItemCell")
autoImport("NewRechargeGiftTipCell")
autoImport("RecallShopBuyItemCell")
local viewPath = ResourcePathHelper.UIView("ActivityIntegrationShopSubView")
local picIns = PictureManager.Instance
local tempVector3 = LuaVector3.Zero()

function RecallShopSubView:ctor(gameObject, parent, viewData)
  RecallShopSubView.super.ctor(self, gameObject, parent, viewData)
  self.shopItems = {}
  self:FindObjs()
  self:AddMapEvts()
  self:AddViewEvts()
  self:InitShow()
end

function RecallShopSubView:OnShow()
  RecallShopSubView.super.OnShow(self)
  xdlog("RecallShopSubView:OnShow")
  self:RefreshShopData()
  self:UpdateBalance()
end

function RecallShopSubView:OnHide()
  RecallShopSubView.super.OnHide(self)
  xdlog("RecallShopSubView:OnHide")
end

function RecallShopSubView:OnEnter()
  RecallShopSubView.super.OnEnter(self)
  xdlog("RecallShopSubView:OnEnter")
  self:RefreshShopData()
  self:UpdateBalance()
end

function RecallShopSubView:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container, true)
  obj.name = "RecallShopSubView"
end

function RecallShopSubView:FindObjs()
  self:LoadSubView()
  self.gameObject = self:FindGO("RecallShopSubView")
  self.titleLabel = self:FindGO("TitleLabel", self.gameObject):GetComponent(UILabel)
  self.timeLabel = self:FindGO("TimeLabel", self.gameObject):GetComponent(UILabel)
  self.batchLabel = self:FindGO("BatchLabel", self.gameObject):GetComponent(UILabel)
  self.helpBtn = self:FindGO("HelpBtn", self.gameObject)
  self.shopScrollView = self:FindGO("ShopScrollView", self.gameObject):GetComponent(UIScrollView)
  self.shopGrid = self:FindGO("Grid", self.gameObject):GetComponent(UIGrid)
  self.shopListCtrl = UIGridListCtrl.new(self.shopGrid, RecallShopItemCell, "NewRechargeCommonGoodsCellType2")
  self.shopListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.goGachaCoinBalance = self:FindGO("GachaCoinBalance", self.gameObject)
  self.goLabGachaCoinBalance = self:FindGO("Lab", self.goGachaCoinBalance)
  self.labGachaCoinBalance = self.goLabGachaCoinBalance:GetComponent(UILabel)
  self.spGachaCoin = self:FindGO("Icon", self.goGachaCoinBalance):GetComponent(UISprite)
  self.goGachaCoinBalance2 = self:FindGO("GachaCoinBalance2", self.gameObject)
  self.goLabGachaCoinBalance2 = self:FindGO("Lab", self.goGachaCoinBalance2)
  self.labGachaCoinBalance2 = self.goLabGachaCoinBalance2:GetComponent(UILabel)
  self.spGachaCoin2 = self:FindGO("Icon", self.goGachaCoinBalance2):GetComponent(UISprite)
  self.uiCamera = NGUIUtil:GetCameraByLayername("UI")
  self:InitBuyItemCell()
end

function RecallShopSubView:AddMapEvts()
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateBalance)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateBalance)
  self:AddDispatcherEvt(ServiceEvent.RecallCCmdShopQueryInfoRecallCmd, self.OnRecvShopQueryInfo)
  self:AddDispatcherEvt(ServiceEvent.RecallCCmdBuyShopGoodRecallCmd, self.OnRecvShopBuyItem)
end

function RecallShopSubView:AddViewEvts()
  self:AddClickEvent(self.helpBtn, function()
    self:HandleClickHelpBtn(500007)
  end)
end

function RecallShopSubView:InitShow()
  self.titleLabel.text = ZhString.RecallIntegration_Shop_Title
  self:UpdateLeftTime()
  self:InitCurrencyDisplay()
  self:RefreshShopData()
  self:UpdateBatchLabel()
end

function RecallShopSubView:InitCurrencyDisplay()
  self.shopItemID = nil
  self.shopItemID2 = nil
  if RecallShopProxy.Instance then
    local shopItems = RecallShopProxy.Instance:GetAllShopItems()
    local currencySet = {}
    for _, item in pairs(shopItems) do
      if item.serverData and item.serverData.cost then
        for _, costInfo in pairs(item.serverData.cost) do
          currencySet[costInfo.id] = true
        end
      end
    end
    local currencyList = {}
    for currencyId, _ in pairs(currencySet) do
      table.insert(currencyList, currencyId)
    end
    table.sort(currencyList)
    if 0 < #currencyList then
      self.shopItemID = currencyList[1]
    end
    if 1 < #currencyList then
      self.shopItemID2 = currencyList[2]
    end
  end
  if self.shopItemID then
    local itemData = Table_Item[self.shopItemID]
    if itemData then
      IconManager:SetItemIcon(itemData.Icon, self.spGachaCoin)
    end
  end
  self.goGachaCoinBalance2:SetActive(self.shopItemID2 ~= nil)
  if self.shopItemID2 then
    local itemData = Table_Item[self.shopItemID2]
    if itemData then
      IconManager:SetItemIcon(itemData.Icon, self.spGachaCoin2)
    end
  end
  self:UpdateBalance()
end

function RecallShopSubView:UpdateLeftTime()
  local displayInfo = RecallShopProxy.Instance and RecallShopProxy.Instance:GetDisplayInfo()
  if displayInfo and displayInfo.endTime and displayInfo.endTime > 0 then
    self.timeLabel.gameObject:SetActive(true)
    self:StartUpdateTimer()
  else
    self.timeLabel.gameObject:SetActive(false)
  end
end

function RecallShopSubView:StartUpdateTimer()
  self:StopUpdateTimer()
  TimeTickManager.Me():CreateTick(0, 1000, function()
    self:UpdateTimeDisplay()
  end, self, "TimeUpdate")
end

function RecallShopSubView:StopUpdateTimer()
  TimeTickManager.Me():ClearTick(self, "TimeUpdate")
end

function RecallShopSubView:UpdateTimeDisplay()
  if not self.timeLabel then
    return
  end
  local displayInfo = RecallShopProxy.Instance and RecallShopProxy.Instance:GetDisplayInfo()
  if not (displayInfo and displayInfo.endTime) or displayInfo.endTime <= 0 then
    self:StopUpdateTimer()
    self.timeLabel.gameObject:SetActive(false)
    return
  end
  local endTime = displayInfo.endTime
  local currentTime = ServerTime.CurServerTime() / 1000
  local leftTime = endTime - currentTime
  if 0 < leftTime then
    local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(leftTime)
    local timeText
    if 0 < day then
      timeText = string.format(ZhString.PlayerTip_ExpireTime, day)
      self.timeLabel.text = timeText .. ZhString.PlayerTip_Day
    else
      timeText = string.format("%02d:%02d:%02d", hour, min, sec)
      self.timeLabel.text = string.format(ZhString.PlayerTip_ExpireTime, timeText)
    end
  else
    self:StopUpdateTimer()
    self.timeLabel.text = ZhString.Activity_End
  end
end

function RecallShopSubView:UpdateBalance()
  if self.shopItemID then
    local coinNum = BagProxy.Instance:GetAllItemNumByStaticIDIncludeMoney(self.shopItemID)
    local milCommaBalance = FunctionNewRecharge.FormatMilComma(coinNum)
    if milCommaBalance then
      self.labGachaCoinBalance.text = milCommaBalance
    end
  end
  if self.shopItemID2 then
    coinNum = BagProxy.Instance:GetAllItemNumByStaticIDIncludeMoney(self.shopItemID2)
    milCommaBalance = FunctionNewRecharge.FormatMilComma(coinNum) or 0
    if milCommaBalance then
      self.labGachaCoinBalance2.text = milCommaBalance
    end
  end
end

function RecallShopSubView:RefreshShopData()
  self.shopItems = {}
  if not RecallShopProxy.Instance then
    redlog("RecallShopSubView:RefreshShopData RecallShopProxy未初始化")
    self.shopListCtrl:ResetDatas({})
    return
  end
  self.shopItems = RecallShopProxy.Instance:GetAllShopItems()
  if self.shopItems and #self.shopItems > 0 then
    table.sort(self.shopItems, function(a, b)
      local isSoldOutA = self:IsItemSoldOut(a)
      local isSoldOutB = self:IsItemSoldOut(b)
      if isSoldOutA ~= isSoldOutB then
        return not isSoldOutA
      end
      return a.id < b.id
    end)
  end
  self.shopListCtrl:ResetDatas(self.shopItems)
  self.shopScrollView:ResetPosition()
  self:UpdateBatchLabel()
  xdlog("RecallShopSubView:RefreshShopData 加载了", #self.shopItems, "个商品")
end

function RecallShopSubView:IsItemSoldOut(itemData)
  if not itemData or not itemData.serverData then
    return false
  end
  local serverData = itemData.serverData
  local boughtCount = serverData.bought_count or 0
  local buyLimit = serverData.buy_limit or 0
  return 0 < buyLimit and boughtCount >= buyLimit
end

function RecallShopSubView:LoadCellPfb(cName)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if cellpfb == nil then
    error("can not find cellpfb" .. cName)
  end
  cellpfb.transform:SetParent(self.gameObject.transform, false)
  return cellpfb
end

function RecallShopSubView:InitBuyItemCell()
  local go = self:LoadCellPfb("NewHappyShopBuyItemCell")
  self.buyCell = RecallShopBuyItemCell.new(go)
  self.buyCell:AddEventListener(ItemTipEvent.ClickItemUrl, self.OnClickItemUrl, self)
  self.buyCell:AddCloseWhenClickOtherPlaceCallBack(self)
  self.CloseWhenClickOtherPlace = self.buyCell.closeWhenClickOtherPlace
  self.buyCell.gameObject:SetActive(false)
end

function RecallShopSubView:HandleClickItem(cellCtrl)
  if self.currentItem ~= cellCtrl then
    if self.currentItem then
    end
    self.currentItem = cellCtrl
  end
  local data = cellCtrl.data
  if not data then
    redlog("RecallShopSubView:HandleClickItem data为空")
    return
  end
  xdlog("RecallShopSubView:HandleClickItem", "点击商品ID:", data.id)
  self:HandleClickShopItem(cellCtrl)
end

function RecallShopSubView:GetScreenTouchedPos()
  local positionX, positionY, positionZ = LuaGameObject.GetMousePosition()
  LuaVector3.Better_Set(tempVector3, positionX, positionY, positionZ)
  if not UIUtil.IsScreenPosValid(positionX, positionY) then
    LogUtility.Error(string.format("RecallShopSubView MousePosition is Invalid! x: %s, y: %s", positionX, positionY))
    return 0, 0
  end
  positionX, positionY, positionZ = LuaGameObject.ScreenToWorldPointByVector3(self.uiCamera, tempVector3)
  LuaVector3.Better_Set(tempVector3, positionX, positionY, positionZ)
  positionX, positionY, positionZ = LuaGameObject.InverseTransformPointByVector3(self.gameObject.transform, tempVector3)
  return positionX, positionY
end

function RecallShopSubView:HandleClickShopItem(cellCtrl)
  local data = cellCtrl.data
  local go = cellCtrl.gameObject
  if data then
    if not self:CanShowBuyCell(data) then
      self.buyCell.gameObject:SetActive(false)
      return
    end
    local buyCallback = function(itemData, buyCount)
      self:OnBuyItem(itemData, buyCount)
    end
    self:UpdateBuyItemInfo(data, buyCallback)
  end
end

function RecallShopSubView:CanShowBuyCell(data)
  if not data or not data.serverData then
    return false
  end
  local serverData = data.serverData
  local buyLimit = serverData.buy_limit or 0
  local boughtCount = serverData.bought_count or 0
  if 0 < buyLimit and buyLimit <= boughtCount then
    MsgManager.ShowMsgByID(10158)
    return false
  end
  if RecallShopProxy.Instance and not RecallShopProxy.Instance:IsActivityValid() then
    MsgManager.ShowMsgByID(40973)
    return false
  end
  return true
end

function RecallShopSubView:CanBuyItem(data)
  if not data or not data.serverData then
    return false
  end
  local serverData = data.serverData
  local buyLimit = serverData.buy_limit or 0
  local boughtCount = serverData.bought_count or 0
  if 0 < buyLimit and buyLimit <= boughtCount then
    return false
  end
  if serverData.cost then
    for _, costInfo in pairs(serverData.cost) do
      local costItemId = costInfo.id
      local costAmount = costInfo.count
      local currentAmount = BagProxy.Instance:GetAllItemNumByStaticIDIncludeMoney(costItemId)
      if costAmount > currentAmount then
        return false
      end
    end
  end
  if RecallShopProxy.Instance and not RecallShopProxy.Instance:IsActivityValid() then
    return false
  end
  return true
end

function RecallShopSubView:UpdateBuyItemInfo(data, buyCallback)
  if data then
    local positionX, positionY = self:GetScreenTouchedPos()
    if 0 < positionX then
      self.buyCell:updateLocalPostion(-217)
    else
      self.buyCell:updateLocalPostion(300)
    end
    self.buyCell:SetData(data, buyCallback)
    self.buyCell.gameObject:SetActive(true)
    TipsView.Me():HideCurrent()
  else
    self.buyCell.gameObject:SetActive(false)
  end
end

function RecallShopSubView:OnBuyItem(data, buyCount)
  if not data or not data.id then
    redlog("RecallShopSubView:OnBuyItem 数据无效")
    return
  end
  xdlog("RecallShopSubView:OnBuyItem", "购买商品", data.id, "数量:", buyCount)
  ServiceRecallCCmdProxy.Instance:CallBuyShopGoodRecallCmd(data.id, buyCount)
end

function RecallShopSubView:OnClickItemUrl(event, url)
  if url then
    xdlog("RecallShopSubView:OnClickItemUrl", url)
  end
end

function RecallShopSubView:HandleClickHelpBtn(helpid)
  if helpid and Table_Help[helpid] then
    local helpConfig = Table_Help[helpid]
    self:OpenHelpView(helpConfig)
  end
end

function RecallShopSubView:OnRecvShopQueryInfo(data)
  xdlog("RecallShopSubView:OnRecvShopQueryInfo")
  if RecallShopProxy.Instance and data and data.info then
    RecallShopProxy.Instance:UpdateShopData(data.info)
  end
  self:RefreshShopData()
end

function RecallShopSubView:OnRecvShopBuyItem(data)
  xdlog("RecallShopSubView:OnRecvShopBuyItem 购买成功")
  if RecallShopProxy.Instance and data and data.info then
    RecallShopProxy.Instance:UpdateShopData(data.info)
  end
  self:RefreshShopData()
  self:UpdateBalance()
  if not data or data.rewards then
  end
end

function RecallShopSubView:UpdateBatchLabel()
  if not self.batchLabel then
    return
  end
  if RecallShopProxy.Instance then
    local shopData = RecallShopProxy.Instance:GetShopDataFirst()
    if shopData then
      local currentBatch = shopData.index + 1 or 1
      local totalBatch = RecallInfoProxy.Instance:GetTotalBatchCount() or 1
      self.batchLabel.text = string.format(ZhString.RecallIntegration_BatchNumber or "第%d/%d期", currentBatch, totalBatch)
    end
  end
end

function RecallShopSubView:OnExit()
  RecallShopSubView.super.OnExit(self)
  self:StopUpdateTimer()
  xdlog("RecallShopSubView:OnExit")
end
