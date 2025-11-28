autoImport("ShopItemInfoCell")
autoImport("GrouponResultCell")
GroupPurchaseView = class("GroupPurchaseView", BaseView)
GroupPurchaseView.ViewType = UIViewType.NormalLayer
local orangeOutline = LuaColor.New(0.9803921568627451, 0.6196078431372549, 0.10980392156862745)
local purpleOutline = LuaColor.New(0.42745098039215684, 0.34901960784313724, 0.803921568627451)
local textPurple = LuaColor.New(0.48627450980392156, 0.5098039215686274, 0.7529411764705882)
local textOrange = LuaColor.New(1, 0.4627450980392157, 0.23137254901960785)

function GroupPurchaseView:Init()
  self:InitDatas()
  self:FindObjs()
  self:AddMapEvts()
  self:AddEvts()
  self:InitShow()
end

function GroupPurchaseView:InitDatas()
  self.openType = self.viewdata.viewdata.type or 1
  self.actid = self.viewdata.viewdata.actid
  self.discountTotal = 0
  self.discountLevel = 0
  self.config = GameConfig.Groupon
  self.currentPrice = 0
  self.tipData = {}
  self.rewardEffect = {}
  ServiceSceneTipProxy.Instance:CallBrowseRedTipCmd(705, self.actid)
end

function GroupPurchaseView:FindObjs()
  self.titleLabel = self:FindGO("TitleLabel"):GetComponent(UILabel)
  self.timeLabel = self:FindGO("TimeLabel"):GetComponent(UILabel)
  self.inviteView = self:FindGO("InviteView")
  self.purchaseView = self:FindGO("PurchaseView")
  if self.openType == 1 then
    self.inviteView:SetActive(true)
    self.purchaseView:SetActive(false)
  elseif self.openType == 2 then
    self.inviteView:SetActive(false)
    self.purchaseView:SetActive(true)
  end
  self.inviteLabel = self:FindGO("InviteLabel"):GetComponent(UILabel)
  self.inviteBtn = self:FindGO("InviteBtn")
  self.itemName = self:FindGO("ItemName"):GetComponent(UILabel)
  self.priceLabel = self:FindGO("Price"):GetComponent(UILabel)
  self.primePriceLabel = self:FindGO("PrimePrice"):GetComponent(UILabel)
  self.leftTime = self:FindGO("LeftTime"):GetComponent(UILabel)
  self.process = self:FindGO("ProcessRoot")
  self.processSlider = self:FindGO("ProcessSlider"):GetComponent(UISlider)
  self.buyBtn = self:FindGO("BuyBtn")
  self.buyBtnLabel = self:FindGO("Label", self.buyBtn):GetComponent(UILabel)
  self.showBuyRecordBtn = self:FindGO("Pig")
  self.pigSprite = self.showBuyRecordBtn:GetComponent(UISprite)
  self.pigBoxCollider = self.showBuyRecordBtn:GetComponent(BoxCollider)
  self.helpBtn = self:FindGO("BtnHelp")
  local closeBtn = self:FindGO("CloseButton")
  self.closeTweenRot = self:FindGO("BG", closeBtn):GetComponent(TweenRotation)
  self.closeTweenRot.enabled = false
  self.loadingPanel = self:FindGO("LoadingPanel")
  self.countInput = self:FindGO("CountBg"):GetComponent(UIInput)
  self.countPlusBg = self:FindGO("CountPlusBg"):GetComponent(UISprite)
  self.countPlus = self:FindGO("Plus", self.countPlusBg.gameObject):GetComponent(UISprite)
  self.countSubtractBg = self:FindGO("CountSubtractBg"):GetComponent(UISprite)
  self.countSubtract = self:FindGO("Subtract", self.countSubtractBg.gameObject):GetComponent(UISprite)
  self.totalPrice = self:FindGO("TotalPrice"):GetComponent(UILabel)
  self.totalPriceIcon = self:FindGO("TotalPriceIcon"):GetComponent(UISprite)
  IconManager:SetItemIcon("item_151", self.totalPriceIcon)
  self.buyRecordView = self:FindGO("BuyRecordView")
  self.buyRecordView:SetActive(false)
  self.recordGrid = self:FindGO("Grid", self.buyRecordView):GetComponent(UIGrid)
  self.recordCtrl = UIGridListCtrl.new(self.recordGrid, GrouponResultCell, "GrouponResultCell")
  self.noneTip = self:FindGO("NoneTip", self.buyRecordView)
  self.nowPriceLabel = self:FindGO("CurrentPrice", self.buyRecordView):GetComponent(UILabel)
  local nowPriceIcon = self:FindGO("CurrentPriceIcon", self.buyRecordView):GetComponent(UISprite)
  IconManager:SetItemIcon("item_151", nowPriceIcon)
  self.processRoot = {}
  self.processBoxCollider = {}
  self.processIcon = {}
  self.processLabel = {}
  self.processTweenRot = {}
  self.processPctgRoot = {}
  self.processEffectPos = {}
  self.percentNum = {}
  self.percentBG = {}
  for i = 1, 4 do
    self.processRoot[i] = self:FindGO("Process" .. i)
    self.processBoxCollider[i] = self.processRoot[i]:GetComponent(BoxCollider)
    self.processIcon[i] = self:FindGO("Sprite", self.processRoot[i]):GetComponent(UISprite)
    self.processLabel[i] = self:FindGO("Label", self.processRoot[i]):GetComponent(UILabel)
    self.processTweenRot[i] = self:FindGO("Sprite", self.processRoot[i]):GetComponent(TweenRotation)
    self.processPctgRoot[i] = self:FindGO("Percent", self.processRoot[i])
    self.processEffectPos[i] = self:FindGO("EffectPos", self.processRoot[i])
    self.percentNum[i] = self:FindGO("Value1", self.processPctgRoot[i]):GetComponent(UILabel)
    self.percentBG[i] = self:FindGO("BG", self.processPctgRoot[i]):GetComponent(UIMultiSprite)
  end
  self.goDiscount = self:FindGO("Discount", self.gameObject)
  self.goPercent = self:FindGO("Percent", self.goDiscount)
  self.labPercent = self:FindGO("Value1", self.goPercent):GetComponent(UILabel)
  self.labPercentSymbol = self:FindGO("Value2", self.goPercent):GetComponent(UILabel)
  self.spPercentBG = self:FindGO("BG", self.goPercent):GetComponent(UIMultiSprite)
  local targetCellGO = self:FindGO("TargetCell")
  self.targetCell = BaseItemCell.new(targetCellGO)
  self.targetCell:AddEventListener(MouseEvent.MouseClick, self.ClickTargetCell, self)
  local firstEnter = self.viewdata.viewdata.firstenter
  if firstEnter then
    self:PlayOpenEffect()
  end
end

function GroupPurchaseView:AddEvts()
  self:AddClickEvent(self.inviteBtn, function()
    ServiceNUserProxy.Instance:CallGrouponQueryUserCmd(self.actid)
    self:PlayOpenEffect()
    self.closeTweenRot.enabled = true
    self.closeTweenRot:PlayForward()
    TimeTickManager.Me():CreateOnceDelayTick(700, function(owner, deltaTime)
      self.inviteView:SetActive(false)
      self.purchaseView:SetActive(true)
    end, self, 2)
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
  self:AddClickEvent(self.buyBtn, function()
    local money = MyselfProxy.Instance:GetLottery()
    if money < self.totalPriceNum then
      MsgManager.ConfirmMsgByID(3551, function()
        self:CloseSelf()
        FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_Zeny)
      end)
      return
    end
    redlog("购买参数", self.grouponid, self.count, self.currentPrice)
    ServiceNUserProxy.Instance:CallGrouponBuyUserCmd(self.grouponid, self.count, self.currentPrice)
  end)
  self:AddClickEvent(self.showBuyRecordBtn, function()
    self:ShowBuyRecordView(true)
  end)
  self:AddClickEvent(self:FindGO("CloseButton", self.buyRecordView), function()
    self:ShowBuyRecordView(false)
  end)
  for i = 2, 4 do
    self:AddClickEvent(self.processRoot[i], function()
      local recvedReward = GrouponProxy.Instance.couponAct[self.grouponid].recvedReward
      local level = GrouponProxy.Instance.couponAct[self.grouponid].discountLevel
      local recved = false
      if recvedReward and recvedReward[i - 1] then
        helplog("当前奖励已领取")
        recved = true
      end
      if not recved and level >= i - 1 then
        redlog("====》CallGrouponRewardUserCmd", self.grouponid, i - 1)
        ServiceNUserProxy.Instance:CallGrouponRewardUserCmd(self.grouponid, i - 1)
        return
      end
      local progressList = self.config[self.grouponid].Progress
      local cellData = {
        rewardid = progressList[i - 1].RewardId
      }
      local widget = self.processIcon[i]:GetComponent(UIWidget)
      TipManager.Instance:ShowRewardListTip(cellData, widget, NGUIUtil.AnchorSide.DownRight, {35, 35})
    end)
  end
  self:RegistShowGeneralHelpByHelpID(35022, self.helpBtn)
end

function GroupPurchaseView:AddMapEvts()
  self:AddListenEvt(ServiceEvent.NUserGrouponQueryUserCmd, self.InitShow)
  self:AddListenEvt(ServiceEvent.NUserGrouponBuyUserCmd, self.recvBuyCmd)
  self:AddListenEvt(ServiceEvent.NUserGrouponRewardUserCmd, self.InitShow)
end

function GroupPurchaseView:InitShow()
  self.grouponid = GrouponProxy.Instance.primaryID
  redlog("优先开启的团购id", self.grouponid)
  self.endTimeStamp = GrouponProxy.Instance:GetEndTime(self.grouponid)
  if self.endTimeStamp then
    TimeTickManager.Me():ClearTick(self, 1)
    TimeTickManager.Me():CreateTick(0, 1000, self.UpdateLeftTime, self, 1)
  end
  if not self.grouponid then
    self.loadingPanel:SetActive(true)
    self.process:SetActive(false)
    return
  else
    self.loadingPanel:SetActive(false)
    self.process:SetActive(true)
  end
  if not self.config[self.grouponid] then
    redlog("GameConfig中未配置" .. self.grouponid .. "相关内容")
    return
  end
  self.maxcount = self.config[self.grouponid].ItemCountLimit
  self.mycount = GrouponProxy.Instance.couponAct[self.grouponid] and GrouponProxy.Instance.couponAct[self.grouponid].myselfBuyCount or 0
  self.titleLabel.text = self.config[self.grouponid].activityName
  self.inviteLabel.text = self.config[self.grouponid].activityContent or "..."
  self.countInput.value = 1
  self:UpdateShow()
end

function GroupPurchaseView:UpdateShow()
  self:UpdateProcessShow()
  self:UpdateProcessPercentage()
  self:UpdateItemDiscountPercent()
  self:UpdateItem()
  self:UpdateTotalPrice(1)
end

function GroupPurchaseView:UpdateProcessPercentage()
  self.processPctgRoot[1]:SetActive(false)
  for i = 2, 4 do
    local discount = self.config[self.grouponid].Progress[i - 1].Discount or 0
    self.percentNum[i].text = 100 - discount .. "%"
  end
end

function GroupPurchaseView:UpdateItemDiscountPercent()
  local progressList = self.config[self.grouponid].Progress
  local discount = progressList[self.discountLevel] and progressList[self.discountLevel].Discount or 100
  if discount == 100 then
    self.goDiscount:SetActive(false)
  else
    self.labPercent.text = 100 - discount .. "%"
  end
end

function GroupPurchaseView:UpdateItem()
  local itemid = self.config[self.grouponid].ItemId or 3851
  self.itemdata = ItemData.new("Groupon", itemid)
  self.targetCell:SetData(self.itemdata)
end

function GroupPurchaseView:UpdateLeftTime()
  local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(self.endTimeStamp)
  if 0 < leftDay then
    self.timeLabel.text = string.format(ZhString.Bazaar_HourDes, leftDay, leftHour, ZhString.ActivityData_Finish)
  else
    self.timeLabel.text = string.format(ZhString.Bazaar_TimeLineDes, leftHour, leftMin, leftSec, ZhString.ActivityData_Finish)
  end
end

function GroupPurchaseView:UpdateProcessShow()
  local progressList = self.config[self.grouponid].Progress
  local list = {}
  if progressList then
    for i = 1, 3 do
      if progressList[i].Num then
        list[i] = progressList[i].Num
      else
        redlog("团购活动ID", self.grouponid, "Progress配置有错误")
      end
    end
  else
    redlog("GameConfig未配置对应团购ID的Progress")
    return
  end
  if not GrouponProxy.Instance.couponAct[self.grouponid] then
    return
  end
  local maxProcess = 100
  local saleNum = GrouponProxy.Instance.couponAct[self.grouponid].totalBuyCount or 3000
  local processSliderValue = 0
  if saleNum < list[1] then
    processSliderValue = saleNum / list[1] * 100 / 3
    self.discountLevel = 0
  elseif saleNum >= list[1] and saleNum < list[2] then
    processSliderValue = 33.3 + (saleNum - list[1]) / (list[2] - list[1]) * 100 / 3
    self.discountLevel = 1
  elseif saleNum >= list[2] and saleNum < list[3] then
    processSliderValue = 66.7 + (saleNum - list[2]) / (list[3] - list[2]) * 100 / 3
    self.discountLevel = 2
  elseif saleNum >= list[3] then
    processSliderValue = 100
    self.discountLevel = 3
  end
  if 100 < processSliderValue then
    processSliderValue = 100
  end
  local originalPrice = self.config[self.grouponid].ItemPrice or 0
  local currentDiscount = progressList[self.discountLevel] and progressList[self.discountLevel].Discount or 100
  if self.discountLevel == 0 then
    self.primePriceLabel.gameObject:SetActive(false)
    self.priceLabel.color = textPurple
  else
    self.primePriceLabel.gameObject:SetActive(true)
    self.priceLabel.color = textOrange
  end
  self.priceLabel.text = ZhString.Bazaar_NowPrice .. math.modf(originalPrice * currentDiscount / 100)
  self.primePriceLabel.text = ZhString.HappyShop_originalCost .. math.modf(originalPrice)
  self.currentPrice = progressList[self.discountLevel] and progressList[self.discountLevel].Price or originalPrice
  self.nowPriceLabel.text = ZhString.Bazaar_NowPrice .. self.currentPrice
  GrouponProxy.Instance:SetCurrentDiscountStatus(self.grouponid, self.discountLevel, self.currentPrice)
  self.leftTime.text = self.mycount .. " /" .. self.maxcount
  if 0 < self.mycount then
  end
  self.timeLimit = self.maxcount - self.mycount
  if 0 >= self.timeLimit then
    self:SetTextureGrey(self.buyBtn)
    self.buyBtn:GetComponent(BoxCollider).enabled = false
    self.buyBtnLabel.text = ZhString.HappyShop_SoldOut
  end
  local recvedReward = GrouponProxy.Instance.couponAct[self.grouponid].recvedReward
  for i = 2, 4 do
    if i <= self.discountLevel + 1 then
      self.processLabel[i].effectColor = orangeOutline
      self.processLabel[i].text = string.format(ZhString.Bazaar_Reached, tostring(progressList[i - 1].Num))
      if recvedReward and recvedReward[i - 1] then
        self.processTweenRot[i].enabled = false
        self.processIcon[i].spriteName = "growup2"
        self:RemoveRewardEff(i)
      else
        self.processTweenRot[i].enabled = true
        self.processIcon[i].spriteName = "growup1"
        self:CreateRewardEff(self.processEffectPos[i], i)
      end
    else
      self.processTweenRot[i].enabled = false
      self.processIcon[i].spriteName = "growup1"
      self.processLabel[i].effectColor = purpleOutline
      self.processLabel[i].text = string.format(ZhString.Bazaar_NotReached, tostring(progressList[i - 1].Num))
      self:RemoveRewardEff(i)
    end
  end
  local itemid = self.config[self.grouponid].ItemId
  local itemData = Table_Item[itemid]
  if itemData and itemData.Icon then
    IconManager:SetItemIcon(itemData.Icon, self.processIcon[1])
  end
  self.processLabel[1].text = ZhString.Bazaar_TotalSellCount .. saleNum
  self.processSlider.value = processSliderValue / maxProcess
end

function GroupPurchaseView:PlusPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(1)
    end, self, 1003)
  else
    TimeTickManager.Me():ClearTick(self, 1003)
  end
end

function GroupPurchaseView:SubtractPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(-1)
    end, self, 1004)
  else
    TimeTickManager.Me():ClearTick(self, 1004)
  end
end

function GroupPurchaseView:InputOnChange()
  local count = tonumber(self.countInput.value)
  if count == nil then
    return
  end
  if self.timeLimit == 0 then
    count = 0
    self:SetCountPlus(0.5)
    self:SetCountSubtract(0.5)
  elseif count <= 1 then
    count = 1
    self:SetCountPlus(1)
    self:SetCountSubtract(0.5)
  elseif count >= self.timeLimit then
    count = self.timeLimit
    self:SetCountPlus(0.5)
    self:SetCountSubtract(1)
  else
    self:SetCountPlus(1)
    self:SetCountSubtract(1)
  end
  self:UpdateTotalPrice(count)
end

function GroupPurchaseView:SetCountPlus(alpha)
  if self.countPlusBg.color.a ~= alpha then
    self:SetSpritAlpha(self.countPlusBg, alpha)
    self:SetSpritAlpha(self.countPlus, alpha)
  end
end

function GroupPurchaseView:SetCountSubtract(alpha)
  if self.countSubtractBg.color.a ~= alpha then
    self:SetSpritAlpha(self.countSubtractBg, alpha)
    self:SetSpritAlpha(self.countSubtract, alpha)
  end
end

function GroupPurchaseView:SetSpritAlpha(sprit, alpha)
  sprit.color = Color(sprit.color.r, sprit.color.g, sprit.color.b, alpha)
end

function GroupPurchaseView:UpdatePrice()
  self.price.text = StringUtil.NumThousandFormat(self.currentPrice)
end

function GroupPurchaseView:UpdateTotalPrice(count)
  self.count = count
  self.totalPriceNum = self:CalcTotalPrice(count)
  self.totalPrice.text = StringUtil.NumThousandFormat(self.totalPriceNum)
  if self.countInput.value ~= tostring(count) then
    self.countInput.value = count
  end
end

function GroupPurchaseView:CalcTotalPrice(count)
  local totalCost = self.currentPrice * count
  return totalCost
end

function GroupPurchaseView:UpdateCount(change)
  if tonumber(self.countInput.value) == nil then
    self.countInput.value = self.count
  end
  local count = tonumber(self.countInput.value) + self.countChangeRate * change
  if count < 1 then
    self.countChangeRate = 1
    return
  elseif count > self.timeLimit then
    self.countChangeRate = 1
    return
  end
  self:UpdateTotalPrice(count)
  if self.countChangeRate <= 3 then
    self.countChangeRate = self.countChangeRate + 1
  end
end

function GroupPurchaseView:InputOnSubmit()
  local count = tonumber(self.countInput.value)
  if count == nil then
    self.countInput.value = self.count
  end
end

function GroupPurchaseView:ClickTargetCell(cellctl)
  redlog("点击商品")
  self.tipData.itemdata = cellctl.data
  self:ShowItemTip(self.tipData, cellctl.icon, NGUIUtil.AnchorSide.Left, {-170, 0})
end

function GroupPurchaseView:ShowBuyRecordView(isOpen)
  if isOpen then
    self.buyRecordView:SetActive(true)
    local buyRecords = GrouponProxy.Instance.couponAct[self.grouponid].buyRecords
    if buyRecords and 0 < #buyRecords then
      self.recordCtrl:ResetDatas(buyRecords)
      self.noneTip:SetActive(false)
    else
      self.noneTip:SetActive(true)
    end
  else
    self.buyRecordView:SetActive(false)
  end
end

function GroupPurchaseView:recvBuyCmd()
  self:PlayPigBankEffect()
  self:InitShow()
end

function GroupPurchaseView:PlayOpenEffect()
  local eParent = self:FindGO("OpenEffContainer")
  self:PlayUIEffect(EffectMap.UI.Bazaar_envelope, eParent, true)
end

function GroupPurchaseView:PlayPigBankEffect(isFirstEnter)
  self.pigSprite.alpha = 0
  TimeTickManager.Me():CreateOnceDelayTick(1800, function(owner, deltaTime)
    self.pigSprite.alpha = 1
  end, self, 3)
  local eParent = self:FindGO("Pig")
  self:PlayUIEffect(EffectMap.UI.Bazaar_piggybank, eParent, true)
end

function GroupPurchaseView:CreateRewardEff(parent, index)
  if not self.rewardEffect[index] and parent then
    self:PlayUIEffect(EffectMap.UI.Bazaar_chest, parent, false, function(obj, args, assetEffect)
      self.rewardEffect[index] = assetEffect
    end)
  end
end

function GroupPurchaseView:RemoveRewardEff(index)
  if self.rewardEffect[index] then
    self.rewardEffect[index]:Stop()
  end
end

function GroupPurchaseView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  GroupPurchaseView.super.OnExit(self)
end
