autoImport("HappyShop")
autoImport("HeadWearRaidShopItemCell")
autoImport("HappyShopBuyItemCell")
HeadwearRaidShop = class("HeadwearRaidShop", HappyShop)
HeadwearRaidShop.ViewType = UIViewType.NormalLayer
ShopInfoType = {
  MyProfession = "MyProfession",
  All = "All"
}

function HeadwearRaidShop:Init()
  self:DeactivateNoUseObjs()
  self:FindObjs()
  self:AddViewEvts()
  self:InitShow()
  self:AddEvts()
end

function HeadwearRaidShop:FindObjs()
  self.moneySprite = {}
  self.moneySprite[1] = self:FindGO("goldIcon"):GetComponent(UISprite)
  self.moneySprite[2] = self:FindGO("silversIcon"):GetComponent(UISprite)
  self.moneyLabel = {}
  self.moneyLabel[1] = self:FindGO("gold"):GetComponent(UILabel)
  self.moneyLabel[2] = self:FindGO("silvers"):GetComponent(UILabel)
  self.LeftStick = self:FindGO("LeftStick"):GetComponent(UISprite)
  self.ItemScrollView = self:FindGO("ItemScrollView"):GetComponent(UIScrollView)
  self.ItemScrollViewSpecial = self:FindGO("ItemScrollViewSpecial"):GetComponent(UIScrollView)
  self.skipBtn = self:FindGO("SkipBtn"):GetComponent(UISprite)
  self.skipBtn.gameObject:SetActive(HappyShopProxy.Instance:IsShowSkip())
  self.descLab = self:FindGO("desc"):GetComponent(UILabel)
  self.tipStick = self:FindComponent("TipStick", UIWidget)
  self.specialRoot = self:FindGO("SpecialRoot")
  self.limitLab = self:FindComponent("LimitLab", UILabel)
  self.weeklyLimitTime = self:FindGO("weeklyLimitTime"):GetComponent(UILabel)
  self.timeLimitCountDown = self:FindGO("timeLimitCountDown"):GetComponent(UILabel)
  self.tipsIcon = self:FindGO("TipsIcon")
  self:InitBuyItemCell()
end

function HeadwearRaidShop:InitBuyItemCell()
  local go = self:LoadCellPfb("HappyShopBuyItemCell")
  self.buyCell = HappyShopBuyItemCell.new(go)
  self.buyCell:AddCloseWhenClickOtherPlaceCallBack(self)
end

function HeadwearRaidShop:InitShow()
  self.tipData = {}
  self.tipData.funcConfig = {}
  local itemContainer = self:FindGO("shop_itemContainer")
  local wrapConfig = {
    wrapObj = itemContainer,
    pfbNum = 6,
    cellName = "HeadWearRaidShopItemCell",
    control = HeadWearRaidShopItemCell,
    dir = 1,
    disableDragIfFit = true
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.itemWrapHelper:AddEventListener(HappyShopEvent.SelectIconSprite, self.HandleClickIconSprite, self)
end

function HeadwearRaidShop:AddEvts()
  self:RegistShowGeneralHelpByHelpID(8000001, self.tipsIcon)
  self:AddClickEvent(self.skipBtn.gameObject, function()
    self:OnClickSkip()
  end)
  local config = Table_NpcFunction[HappyShopProxy.Instance:GetShopType()]
  if config.Parama.ItemID then
    if self.money1tg then
      self:AddClickEvent(self.money1tg.gameObject, function(g)
        self.tabid = 1
        self:ClickMoneyType()
      end)
    end
    if self.money2tg then
      self:AddClickEvent(self.money2tg.gameObject, function(g)
        self.tabid = 2
        self:ClickMoneyType()
      end)
    end
  end
end

function HeadwearRaidShop:AddViewEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateMoney)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateMoney)
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.RecvBuyShopItem)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopShopDataUpdateCmd, self.RecvShopDataUpdate)
  self:AddListenEvt(ServiceEvent.SessionShopServerLimitSellCountCmd, self.UpdateShopInfo)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopSoldCountCmd, self.HandleShopSoldCountCmd)
  self:AddListenEvt(ServiceEvent.SessionShopUpdateShopConfigCmd, self.RecvUpdateShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopExchangeShopItemCmd, self.HideGoodsTip)
  self:AddListenEvt(ServiceEvent.SessionShopFreyExchangeShopCmd, self.HideGoodsTip)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
end

function HeadwearRaidShop:InitUI()
  self:UpdateShopInfo(true)
  self:InitLeftUpIcon()
  self:UpdateMoney()
  self.descLab.text = HappyShopProxy.Instance.desc
  self:SetScrollView()
  self:DeactivateNoUseObjs()
  self.lastSelect = nil
  self.buyCell.gameObject:SetActive(false)
end

function HeadwearRaidShop:UpdateShopInfo(isReset)
  local datas = HappyShopProxy.Instance:GetShopItems()
  if datas then
    self.itemWrapHelper:UpdateInfo(datas)
  end
  if isReset == true then
    self.itemWrapHelper:ResetPosition()
  end
end

function HeadwearRaidShop:InitShowtoggle()
end

function HeadwearRaidShop:SetHeadwearRaidInfo()
  self:SetInfoDetail()
end

function HeadwearRaidShop:SetInfoDetail()
  local weeklyMax = 100000
  local currentGainNum = BagProxy.Instance:GetItemNumByStaticID(ProtoCommon_pb.EMONEYTYPE_HEADWEAR_COINA)
  helplog("代币A的现有数量是", currentGainNum)
  self.weeklyLimitTime.text = string.format(ZhString.HeadwearRaidShop_WeeklyLimit, currentGainNum, weeklyMax)
  local nextRefreshTime = ShopProxy.Instance:GetNextRefreshTime()
  helplog("nextRefreshTime is ", nextRefreshTime)
  local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(nextRefreshTime)
  if 0 < leftDay then
    self.timeLimitCountDown.text = string.format("%s %02d:%02d:%02d", ZhString.HeadwearRaidShop_RefreshTimeLimit, leftDay, leftHour, leftMin)
  else
    self.timeLimitCountDown.text = string.format("%s %02d:%02d:%02d", ZhString.HeadwearRaidShop_RefreshTimeLimit, leftHour, leftMin, leftSec)
  end
end

function HeadwearRaidShop:DeactivateNoUseObjs()
  if self.specialRoot then
    self.specialRoot:SetActive(false)
  end
  if self.skipBtn then
    self.skipBtn.gameObject:SetActive(false)
  end
  if self.toggleRoot then
    self.toggleRoot:SetActive(false)
  end
  if self.showtoggle then
    self.showtoggle:SetActive(false)
  end
  if self.servantExp then
    self.servantExp:SetActive(false)
  end
  if self.screenRoot then
    self.screenRoot:SetActive(false)
  end
end

function HeadwearRaidShop:HandleClickItem(cellctl)
  if self.currentItem ~= cellctl then
    if self.currentItem then
      self.currentItem:SetChoose(false)
    end
    cellctl:SetChoose(true)
    self.currentItem = cellctl
  end
  local id = cellctl.data
  local data = HappyShopProxy.Instance:GetShopItemDataByTypeId(id)
  local go = cellctl.gameObject
  if self.selectGo == go then
    self.selectGo = nil
    return
  end
  self.selectGo = go
  if data then
    if data:GetLock() then
      FunctionUnLockFunc.Me():CheckCanOpen(data.MenuID, true)
      self.buyCell.gameObject:SetActive(false)
      return
    end
    HappyShopProxy.Instance:SetSelectId(id)
    self:UpdateBuyItemInfo(data)
  end
end

function HeadwearRaidShop:HandleClickIconSprite(cellctl)
  local data = HappyShopProxy.Instance:GetShopItemDataByTypeId(cellctl.data)
  self.tipData.itemdata = data:GetItemData()
  self:ShowItemTip(self.tipData, self.LeftStick)
  self.buyCell.gameObject:SetActive(false)
  self.selectGo = nil
end

function HeadwearRaidShop:OnEnter()
  HeadwearRaidShop.super.OnEnter(self)
  self:DeactivateNoUseObjs()
  self:InitUI()
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.npcdata = viewdata and viewdata.npcdata
  self.npcguid = self.npcdata.data.id
end

function HeadwearRaidShop:OnExit()
  HeadwearRaidShop.super.OnExit(self)
end
