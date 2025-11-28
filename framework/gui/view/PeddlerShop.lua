autoImport("PeddlerShopFlipCell")
autoImport("SlideListCtrl")
PeddlerShop = class("PeddlerShop", ContainerView)
PeddlerShop.ViewType = UIViewType.NormalLayer

function PeddlerShop:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
end

function PeddlerShop:FindObjs()
  self:FindComponent("titletext", UILabel).text = ZhString.PeddlerShop_title
  self.dialogtext = self:FindComponent("dialogtext", UILabel)
  self.cardContainer = self:FindGO("Cards")
  self.slideList = SlideListCtrl.new(self.cardContainer, PeddlerShopFlipCell, "PeddlerShopFlipCell")
  self.slideList:AddEventListener(MouseEvent.MouseClick, self.ClickItemHandler, self)
  self.slideList:SetLayoutCfg(self:FindGO("CardsTweenTrans"), 3, 0.3)
  self.slideList:SetLRButton(self:FindGO("left"), self:FindGO("right"))
  local zenyBalance = self:FindGO("ZenyBalance")
  self.zenyLabel = self:FindComponent("Lab", UILabel, zenyBalance)
  self.zenyIcon = self:FindComponent("Icon", UISprite, zenyBalance)
  self.zenyGoBtn = self:FindGO("ChargeBtn", zenyBalance)
  local bigCatCoin = self:FindGO("GachaCoinBalance")
  self.bigCatCoinLabel = self:FindComponent("Lab", UILabel, bigCatCoin)
  self.bigCatCoinIcon = self:FindComponent("Icon", UISprite, bigCatCoin)
  self.bigCatCoinGoBtn = self:FindGO("ChargeBtn", bigCatCoin)
end

function PeddlerShop:AddEvts()
  local BtnHelp = self:FindGO("BtnHelp")
  self:TryOpenHelpViewById(PanelConfig.PeddlerShop.id, nil, BtnHelp)
  self:AddClickEvent(self:FindGO("CloseButton"), function(go)
    self:CloseSelf()
  end)
  self:AddClickEvent(self.zenyGoBtn, function()
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_Zeny)
  end)
  self:AddClickEvent(self.bigCatCoinGoBtn, function()
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_ROB)
  end)
end

function PeddlerShop:AddViewEvts()
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.RecvBuyShopItem)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.OnReceiveEventMyDataChange)
end

function PeddlerShop:RecvBuyShopItem(data)
  if not data then
    NewRechargeProxy.Instance:readyTriggerEventId(0)
    return
  end
  self:CreateShowShopList()
  NewRechargeProxy.Instance:successTriggerEventId()
end

function PeddlerShop:CreateShowShopList()
  self.slideList:ResetDatas(PeddlerShopProxy.Instance.shopList)
  local cells = self.slideList:GetCells()
  local showIdx = #cells
  for i = 1, #cells do
    if cells[i]:NotSoldOut() and cells[i].unlockcur and i < showIdx then
      showIdx = i
    end
  end
  self.slideList:Layout(showIdx, true)
end

function PeddlerShop:InitBalanceIcon()
  local zeny = Table_Item[GameConfig.MoneyId.Zeny]
  local bigCatCoin = Table_Item[GameConfig.MoneyId.Lottery]
  IconManager:SetItemIcon(zeny.Icon, self.zenyIcon)
  IconManager:SetItemIcon(bigCatCoin.Icon, self.bigCatCoinIcon)
end

function PeddlerShop:OnEnter()
  PeddlerShop.super.OnEnter(self)
  LocalSaveProxy.Instance:SetPeddlerDailyDot()
  PeddlerShopProxy.Instance:UpdateWholeRedTip()
  PeddlerShopProxy.Instance:InitShop()
  self:CreateShowShopList()
  self:UpdateDialogTimer()
  self:RefreshBalance()
  self:InitBalanceIcon()
end

function PeddlerShop:UpdateDialogTimer()
  local newarr = PeddlerShopProxy.Instance:GetNewGoodsArrival()
  local closet = PeddlerShopProxy.Instance:GetCloseTime()
  if newarr then
    self.dialogtext.text = string.format(ZhString.PeddlerShop_dialog_1, newarr)
  elseif closet then
    self.dialogtext.text = string.format(ZhString.PeddlerShop_dialog_2, closet)
  else
    self.dialogtext.text = ""
  end
end

function PeddlerShop:LoadCellPfb(cName, pTrans)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if cellpfb == nil then
    error("can not find cellpfb" .. cName)
  end
  cellpfb.transform:SetParent(pTrans or self.gameObject.transform, false)
  return cellpfb
end

local tipData = {}
tipData.funcConfig = {}

function PeddlerShop:ClickItemHandler(cellctl)
  if cellctl.shopItemData.goodsID then
    tipData.itemdata = ItemData.new("peddler", cellctl.shopItemData.goodsID)
    self:ShowItemTip(tipData, nil, NGUIUtil.AnchorSide.Up, {300, 0})
  end
end

function PeddlerShop:RefreshBalance()
  local milCommaBalance = FunctionNewRecharge.FormatMilComma(MyselfProxy.Instance:GetROB())
  if milCommaBalance then
    self.zenyLabel.text = milCommaBalance
  end
  milCommaBalance = FunctionNewRecharge.FormatMilComma(MyselfProxy.Instance:GetLottery())
  if milCommaBalance then
    self.bigCatCoinLabel.text = milCommaBalance
  end
end

function PeddlerShop:OnReceiveEventMyDataChange(data)
  self:RefreshBalance()
end
