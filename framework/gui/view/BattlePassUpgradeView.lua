autoImport("NewRechargeVirtualRecommendTShopGoodsCell")
autoImport("BattlePassUpgradeDescCell")
BattlePassUpgradeView = class("BattlePassUpgradeView", SubView)
local Prefab_Path = ResourcePathHelper.UIView("BattlePassUpgradeView")

function BattlePassUpgradeView:LoadSubView()
  local container = self:FindGO("upgradeViewPos")
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, container, true)
  obj.name = "BattlePassUpgradeView"
  self.gameObject = obj
end

function BattlePassUpgradeView:Init()
  self:LoadSubView()
  self:InitView()
end

function BattlePassUpgradeView:InitView()
  self.virtualTShopGoodsCell1 = NewRechargeVirtualRecommendTShopGoodsCell.new()
  self.virtualTShopGoodsCell1:Init()
  self.virtualTShopGoodsCell1:SetPurchaseSuccessCB(function()
    self:UpdateView()
  end)
  self.virtualTShopGoodsCell1:AddEventListener(NewRechargeEvent.GoodsCell_ShowShopItemPurchaseDetail, self.ShopItemPurchase, self)
  self.virtualTShopGoodsCell2 = NewRechargeVirtualRecommendTShopGoodsCell.new()
  self.virtualTShopGoodsCell2:Init()
  self.virtualTShopGoodsCell2:SetPurchaseSuccessCB(function()
    self:UpdateView()
  end)
  self.virtualTShopGoodsCell2:AddEventListener(NewRechargeEvent.GoodsCell_ShowShopItemPurchaseDetail, self.ShopItemPurchase, self)
  self.singlePanel = self:FindGO("Single")
  self.singleTitle = self:FindComponent("singletext", UILabel)
  self.singleLock = self:FindGO("singlelock")
  self.singleBuy = self:FindGO("singleBuy")
  self.singleBuyColl = self.singleBuy:GetComponent(BoxCollider)
  self.singlePriceIcon = self:FindComponent("priceIcon", UISprite, self.singleBuy)
  self.singlePriceNum = self:FindComponent("priceNum", UILabel, self.singleBuy)
  self.introContent = UIGridListCtrl.new(self:FindComponent("content", UITable), BattlePassUpgradeDescCell, "BattlePassUpgradeDescCell")
  self:AddClickEvent(self.singleBuy, function()
    self:BuyUpgrade(1)
  end)
  self.dualPanel = self:FindGO("Dual")
  self.normalTitle = self:FindComponent("dualtext1", UILabel)
  self.normalLock = self:FindGO("duallock1")
  self.quickTitle = self:FindComponent("dualtext2", UILabel)
  self.dualtext3 = self:FindComponent("dualtext3", UILabel)
  self.quickLock = self:FindGO("duallock2")
  self.normalBuy = self:FindGO("normalBuy")
  self.normalBuyColl = self.normalBuy:GetComponent(BoxCollider)
  self.quickBuy = self:FindGO("quickBuy")
  self.quickBuyColl = self.quickBuy:GetComponent(BoxCollider)
  self.normalPriceIcon = self:FindComponent("priceIcon", UISprite, self.normalBuy)
  self.normalPriceNum = self:FindComponent("priceNum", UILabel, self.normalBuy)
  self.quickPriceIcon = self:FindComponent("priceIcon", UISprite, self.quickBuy)
  self.quickPriceNum = self:FindComponent("priceNum", UILabel, self.quickBuy)
  self.normalContent = UIGridListCtrl.new(self:FindComponent("content1", UITable), BattlePassUpgradeDescCell, "BattlePassUpgradeDescCell")
  self.quickContent = UIGridListCtrl.new(self:FindComponent("content2", UITable), BattlePassUpgradeDescCell, "BattlePassUpgradeDescCell")
  self:AddClickEvent(self.normalBuy, function()
    self:BuyUpgrade(1)
  end)
  self:AddClickEvent(self.quickBuy, function()
    self:BuyUpgrade(2)
  end)
  self.singlePriceIcon.gameObject:SetActive(false)
  self.normalPriceIcon.gameObject:SetActive(false)
  self.quickPriceIcon.gameObject:SetActive(false)
  self.singlePriceNum.text = ""
  self.normalPriceNum.text = ""
  self.quickPriceNum.text = ""
end

function BattlePassUpgradeView:OnEnter()
  BattlePassUpgradeView.super.OnEnter(self)
  self:UpdateView()
end

function BattlePassUpgradeView:UpdateView()
  local allItems, item = BattlePassProxy.Instance.UpgradeDepositItem
  local t = {}
  if not self.show then
    self.show = {}
  else
    TableUtility.ArrayClear(self.show)
  end
  for i = 1, #allItems do
    item = allItems[i]
    local s = item.Show
    if not self.show[s] and not BattlePassProxy.Instance:IsUpgradeDepositBought(item) then
      self.show[s] = item
    end
    t[s] = item
  end
  if not self.show[1] and t[1] then
    self.show[1] = t[1]
  end
  if not self.show[2] and t[2] then
    self.show[2] = t[2]
  end
  local allBought = not BattlePassProxy.Instance:GetUpgradeDepositToBuy(false, false)
  local notInSale = not BattlePassProxy.Instance:GetUpgradeDepositToBuy(false, true)
  if not self.show[1] then
    self.virtualTShopGoodsCell1:VirtualClearSetData()
    self.virtualTShopGoodsCell2:VirtualClearSetData()
    self.singlePanel:SetActive(false)
    self.dualPanel:SetActive(false)
    notInSale = true
  elseif not self.show[2] then
    self.virtualTShopGoodsCell1:VirtualSetData(NewRechargePrototypeGoodsCell.GoodsTypeEnum.Deposit, self.show[1].DepositeId)
    self.virtualTShopGoodsCell2:VirtualClearSetData()
    self.singlePanel:SetActive(true)
    self.dualPanel:SetActive(false)
    local canbuy, bought, name, price = self:GenerateStatusInfo(self.show[1])
    local descTab = self:GenerateDescTable(self.show[1])
    self.singleTitle.text = name
    self.singlePriceNum.text = price
    self.singleLock:SetActive(not canbuy)
    if not canbuy or bought then
      self:SetTextureGrey(self.singleBuy)
      self.singleBuyColl.enabled = false
    else
      self:SetTextureWhite(self.singleBuy, ColorUtil.ButtonLabelOrange)
      self.singleBuyColl.enabled = true
    end
    self.introContent:ResetDatas(descTab)
    self:CheckCanBuyInJapanBranch(self.show[1], self.singleBuy, self.singleBuyColl)
  else
    self.virtualTShopGoodsCell1:VirtualSetData(NewRechargePrototypeGoodsCell.GoodsTypeEnum.Deposit, self.show[1].DepositeId)
    self.virtualTShopGoodsCell2:VirtualSetData(NewRechargePrototypeGoodsCell.GoodsTypeEnum.Deposit, self.show[2].DepositeId)
    self.singlePanel:SetActive(false)
    self.dualPanel:SetActive(true)
    local canbuy, bought, name, price = self:GenerateStatusInfo(self.show[1])
    local descTab = self:GenerateDescTable(self.show[1])
    self.normalTitle.text = name
    self.normalPriceNum.text = price
    self.normalLock:SetActive(not canbuy)
    self.normalContent:ResetDatas(descTab)
    if not canbuy or bought then
      self:SetTextureGrey(self.normalBuy)
      self.normalBuyColl.enabled = false
    else
      self:SetTextureWhite(self.normalBuy, ColorUtil.ButtonLabelOrange)
      self.normalBuyColl.enabled = true
    end
    self:CheckCanBuyInJapanBranch(self.show[1], self.normalBuy, self.normalBuyColl)
    local canbuy, bought, name, price = self:GenerateStatusInfo(self.show[2])
    local descTab = self:GenerateDescTable(self.show[2])
    self.quickTitle.text = name
    self.quickPriceNum.text = price
    self.quickLock:SetActive(not canbuy)
    self.quickContent:ResetDatas(descTab)
    if not canbuy or bought then
      self:SetTextureGrey(self.quickBuy)
      self.quickBuyColl.enabled = false
    else
      self:SetTextureWhite(self.quickBuy, ColorUtil.ButtonLabelOrange)
      self.quickBuyColl.enabled = true
    end
    self.dualtext3.text = ZhString.BattlePassUpgradeView_dualtext3
    self:CheckCanBuyInJapanBranch(self.show[2], self.quickBuy, self.quickBuyColl)
  end
  if allBought or notInSale then
    local c = coroutine.create(function()
      Yield(WaitForSeconds(0.5))
      local msgid = allBought and 40926 or 40572
      MsgManager.ShowMsgByID(msgid)
      self:CloseSelf()
    end)
    coroutine.resume(c)
  end
end

function BattlePassUpgradeView:GenerateStatusInfo(info)
  local bought = BattlePassProxy.Instance:IsUpgradeDepositBought(info)
  local canbuy = BattlePassProxy.Instance:IsUpgradeDepositReachCondition(info)
  if bought then
    canbuy = true
  end
  local name = info.Name
  local price = info.DepositeId
  if price then
    price = Table_Deposit and Table_Deposit[price] and Table_Deposit[price].CurrencyType and Table_Deposit[price].Rmb and Table_Deposit[price].CurrencyType .. Table_Deposit[price].Rmb
  else
    price = ZhString.HappyShop_Buy
  end
  if bought then
    price = ZhString.BattlePassUpgradeView_bought
  end
  return canbuy, bought, name, price
end

function BattlePassUpgradeView:GenerateDescTable(info)
  if info and info.Desc and BattlePassProxy.Instance.CurrentBPConfig.UpgradeDesc and BattlePassProxy.Instance.CurrentBPConfig.UpgradeDesc[info.Desc] then
    local rawDesc = BattlePassProxy.Instance.CurrentBPConfig.UpgradeDesc[info.Desc]
    local descTab = {}
    for i = 1, 9 do
      if rawDesc[i] then
        local desc = {}
        desc[1] = info.Show
        desc[2] = rawDesc[i].Text
        for j = 1, 5 do
          if rawDesc[i * 10 + j] then
            desc[2 + j] = rawDesc[i * 10 + j].Text
          end
        end
        TableUtility.ArrayPushBack(descTab, desc)
      end
    end
    return descTab
  end
end

function BattlePassUpgradeView:CloseSelf()
  EventManager.Me():DispatchEvent(BattlePassEvent.BackToLevelView)
end

function BattlePassUpgradeView:OnExit()
  BattlePassUpgradeView.super.OnExit(self)
  self.virtualTShopGoodsCell1:OnCellDestroy()
  self.virtualTShopGoodsCell2:OnCellDestroy()
end

function BattlePassUpgradeView:BuyUpgrade(type)
  if type == 1 then
    self.virtualTShopGoodsCell1:Pre_Purchase()
  elseif type == 2 then
    self.virtualTShopGoodsCell2:Pre_Purchase()
  end
end

function BattlePassUpgradeView:ShopItemPurchase(data)
  if data.m_funcRmbBuy then
    data.m_funcRmbBuy()
  end
end

function BattlePassUpgradeView:CheckCanBuyInJapanBranch(info, button, collider)
  if not BranchMgr.IsJapan() then
    return
  end
  local left = ChargeComfirmPanel.left
  if left then
    local depositId = info.DepositeId
    local currency = Table_Deposit[depositId] and Table_Deposit[depositId].Rmb
    currency = currency or 0
    if left < currency then
      self:SetTextureGrey(button)
      collider.enabled = false
    end
  end
end
