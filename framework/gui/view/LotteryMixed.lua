autoImport("LotteryMixCell")
autoImport("LotteryMixShopCombineCell")
autoImport("PopupCombineCell")
autoImport("LotteryMixedShop")
LotteryMixed = class("LotteryMixed", SubView)
LotteryMixed.ViewIndex = {Lottery = 1, Shop = 2}
local _Index_Lottery = LotteryMixed.ViewIndex.Lottery
local _Index_Shop = LotteryMixed.ViewIndex.Shop
local _AgainConfirmMsgID = 295
local _fashionType = 501
local _Eleven = 11
local _LotteryFunc, _LotteryProxy

function LotteryMixed:Init()
  _LotteryProxy = LotteryProxy.Instance
  _LotteryFunc = FunctionLottery.Me()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end

function LotteryMixed:FindObjs()
  self.root = self:FindGO("MixRoot")
  self.extra = self:FindGO("Extra", self.root)
  self.lotteryRoot = self:FindGO("LotteryRoot", self.root)
  self.lotteryRoot:SetActive(true)
  self.toShopBtn = self:FindGO("ToShopBtn", self.lotteryRoot)
  self.shopDetailLab = self:FindGO("Lab", self.toShopBtn):GetComponent(UILabel)
  self.shopDetailLab.text = ZhString.LotteryMixed_ShopBtn
  self.singleGroupFinish = self:FindGO("SingleGroupFinish", self.extra):GetComponent(UILabel)
  if self.singleGroupFinish then
    self.singleGroupFinish.gameObject:SetActive(false)
  end
  self.shopRoot = self:FindGO("ShopRoot", self.root)
  self.shopRoot:SetActive(false)
  self.shopBuyRoot = self:FindGO("ShopBuyRoot", self.shopRoot)
  self.toLotteryBtn = self:FindGO("ToLotteryBtn", self.shopRoot)
  self.shopName = self:FindComponent("ShopName", UILabel)
  self.shopName.text = ZhString.LotteryMixed_ShopBtn
  self.onlyGotToggle = self:FindComponent("OnlyGotToggle", UIToggle, self.extra)
  self.onlyGotToggleLab = self:FindComponent("Label", UILabel, self.onlyGotToggle.gameObject)
  self.onlyGotToggleLab.text = ZhString.LotteryMixed_filterGotItem
  self.onlyGotToggle.gameObject:SetActive(false)
  self.lotteryPanel = self:FindGO("MixLotteryPanel", self.root)
  self.lotteryPopUp = self:FindGO("MixLotteryPopUp", self.lotteryPanel)
  self.lotteryPopUpCtl = PopupCombineCell.new(self.lotteryPopUp)
  self.lotteryPopUpCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickLotteryFilter, self)
  self.shopPanel = self:FindGO("MixShopPanel", self.root)
  self.shopSitePopUp = self:FindGO("MixShopSitePopUp", self.shopPanel)
  self.shopSitePopUpCtrl = PopupCombineCell.new(self.shopSitePopUp)
  self.shopSitePopUpCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickSiteFilter, self)
  self.shopQualityPopUp = self:FindGO("MixShopQualityPopUp", self.shopPanel)
  self.shopQualityPopUpCtl = PopupCombineCell.new(self.shopQualityPopUp)
  self.shopQualityPopUpCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickQualityFilter, self)
end

function LotteryMixed:OnClickLotteryFilter()
  if self.lotteryGoal == self.lotteryPopUpCtl.goal then
    return
  end
  self.lotteryGoal = self.lotteryPopUpCtl.goal
  self:_updateLotteryHelper(true, true)
end

function LotteryMixed:OnClickSiteFilter()
  if self.siteGoal == self.shopSitePopUpCtrl.goal then
    return
  end
  self.siteGoal = self.shopSitePopUpCtrl.goal
  if self.siteGoal == _fashionType then
    self.shopQualityPopUpCtl:SetInvalidMsgID(41412)
    self.shopQualityPopUpCtl:Reset()
    self.qualityGoal = self.shopQualityPopUpCtl.goal
  else
    self.shopQualityPopUpCtl:SetInvalidMsgID(nil)
  end
  self:_updateShopHelper(true)
end

function LotteryMixed:OnClickQualityFilter(parama)
  if self.qualityGoal == self.shopQualityPopUpCtl.goal then
    return
  end
  self.qualityGoal = self.shopQualityPopUpCtl.goal
  self:_updateShopHelper(true)
end

function LotteryMixed:AddEvts()
  self:AddClickEvent(self.toLotteryBtn, function()
    self:ToLottery()
  end)
  self:AddClickEvent(self.toShopBtn, function()
    self:ToShop()
  end)
end

function LotteryMixed:ToLottery()
  self:SetViewIndex(_Index_Lottery)
end

function LotteryMixed:ToShop()
  self:_initShopSiteFilter()
  self:SetViewIndex(_Index_Shop)
  if not self.staticData then
    return
  end
  ShopProxy.Instance:CallQueryShopConfig(self.staticData.ShopType, self.staticData.ShopID)
end

function LotteryMixed:AddViewEvts()
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.HandleItemUpdate)
  self:AddDispatcherEvt(LotteryEvent.MixShopFilterChanged, self.HandleFilterChanged, self)
end

function LotteryMixed:HandleFilterChanged()
  self:_updateShopHelper(true)
end

function LotteryMixed:HandleItemUpdate()
  LotteryProxy.Instance:ResetMixShopData()
  _LotteryFunc:ResetMixFilterData()
  self:UpdateHelperByIndex(false)
end

function LotteryMixed:HandleMixLotteryArchive()
  self:SetViewIndex(_Index_Lottery)
  self:SetDressModel()
  self:HandleItemUpdate()
  self:UpdateCost()
end

function LotteryMixed:InitDressModel()
  local dress_data = FunctionLottery.Me():InitDefaultDress(self.lotteryType) or _LotteryProxy.mixDressMap
  local _ = _LotteryFunc:InitDressMap(dress_data, LotteryDressType.Mix)
  if _ then
    self.container:ShowModel()
  end
end

function LotteryMixed:SetLotteryType()
  self.lotteryType = self.container.lotteryType
  ServiceItemProxy.Instance:CallMixLotteryArchiveCmd(self.lotteryType)
  self.isNewMix = LotteryProxy.IsNewMixLottery(self.lotteryType)
  self.extra:SetActive(not self.isNewMix)
  self:ActiveNewMixShop(false)
  self:InitStaticData()
end

function LotteryMixed:ActiveNewMixShop(var)
  if var then
    if not self.mixShop then
      self.mixShop = self:AddSubView("LotteryMixedShop", LotteryMixedShop, self)
    end
    self.mixShop:ResetFilter()
    self.mixShop:Show()
  elseif self.mixShop then
    self.mixShop:Hide()
    self.mixShop.firstGoodsID = nil
  end
end

function LotteryMixed:InitShow()
  self:InitHelper()
end

local wrapConfig = {}

function LotteryMixed:InitHelper()
  local container = self:FindGO("LotteryContainer", self.root)
  TableUtility.TableClear(wrapConfig)
  wrapConfig.wrapObj = container
  wrapConfig.pfbNum = 7
  wrapConfig.cellName = "LotteryMixCell"
  wrapConfig.control = LotteryMixCell
  self.lotteryHelper = WrapCellHelper.new(wrapConfig)
  self.lotteryHelper:AddEventListener(MouseEvent.MouseClick, self.ClickDetail, self)
  self.lotteryHelper:AddEventListener(LotteryCell.ClickEvent, self.ClickCell, self)
  container = self:FindGO("ShopContainer", self.root)
  TableUtility.TableClear(wrapConfig)
  wrapConfig.wrapObj = container
  wrapConfig.pfbNum = 6
  wrapConfig.cellName = "LotteryMixShopCombineCell"
  wrapConfig.control = LotteryMixShopCombineCell
  self.shopHelper = WrapCellHelper.new(wrapConfig)
  self.shopHelper:AddEventListener(MouseEvent.MouseClick, self.container.SetBuyItemCell, self.container)
end

function LotteryMixed:ClickDetail(cell)
  local data = cell.data
  if data then
    self.container:ShowTip(data:GetItemData())
  end
end

function LotteryMixed:_initLotteryFilter()
  local cfg = _LotteryFunc:GetMixLotteryFilter()
  if not cfg then
    return
  end
  self.lotteryPopUpCtl:SetData(cfg, true)
  self.lotteryGoal = self.lotteryPopUpCtl.goal
end

function LotteryMixed:_initShopSiteFilter()
  local cfg = GameConfig.MixLottery.EquipFilter
  if cfg then
    self.shopSitePopUpCtrl:SetData(cfg, true)
    self.siteGoal = self.shopSitePopUpCtrl.goal
  end
  cfg = GameConfig.MixLottery.QualityFilter
  if cfg then
    self.shopQualityPopUpCtl:SetData(cfg, true)
    self.qualityGoal = self.shopQualityPopUpCtl.goal
  end
end

function LotteryMixed:_updateLotteryHelper(layout, manualFilter)
  local helperData = _LotteryProxy:FilterMixLottery(self.lotteryGoal, self.onlyGotToggle.value, manualFilter and layout)
  self.lotteryHelper:UpdateInfo(helperData, layout)
end

function LotteryMixed:_updateShopHelper(layout)
  local helperData
  if self.isNewMix then
    if layout then
      helperData = _LotteryProxy:FilterNewMixLotteryShop(self.mixShop.chooseSite, self.mixShop.filterPopup.noGotTogValue)
      self.mixShop:ResetDatas(helperData, layout)
    else
      self.mixShop:HandleMixShopPurchase()
    end
  else
    helperData = _LotteryProxy:FilterMixLotteryShop(self.lotteryType, self.siteGoal, self.qualityGoal, self.onlyGotToggle.value)
    local newData = self.container:ReUniteCellData(helperData, 3)
    self.shopHelper:UpdateInfo(newData, layout)
  end
end

function LotteryMixed:CallLottery(price, times, freecnt)
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(_AgainConfirmMsgID)
  if dont == nil and freecnt == 0 then
    MsgManager.DontAgainConfirmMsgByID(_AgainConfirmMsgID, function()
      self.container:CallLottery(price, nil, nil, times, freecnt)
    end, nil, nil, math.floor(price * times))
    return
  end
  self.container:CallLottery(price, nil, nil, times, freecnt)
end

function LotteryMixed:SetViewIndex(index)
  if self.viewIndex ~= index then
    self.viewIndex = index
    self.modelSet = false
    self:SetDressModel()
    self.lotteryRoot:SetActive(index == _Index_Lottery)
    self.lotteryPanel:SetActive(index == _Index_Lottery)
    self.shopRoot:SetActive(index == _Index_Shop and not self.isNewMix)
    self.shopPanel:SetActive(index == _Index_Shop and not self.isNewMix)
    self:ActiveNewMixShop(self.isNewMix and index == _Index_Shop)
    self:UpdateHelperByIndex(true)
    self.container:SetSkipBtnActive(index == _Index_Lottery)
    self.shopName.gameObject:SetActive(index == _Index_Shop)
    self.container:ActiveLotteryName(index == _Index_Lottery)
    self.container:SetLotteryBtnActive(not self.isNewMix or index ~= _Index_Shop)
  end
end

function LotteryMixed:UpdateHelperByIndex(forceReposition)
  self.container:UpdateReplaceMoney()
  self.container:UpdateTicket()
  local index = self.viewIndex
  if index == _Index_Lottery then
    self:_initLotteryFilter()
    self:_updateLotteryHelper(forceReposition, true)
  elseif index == _Index_Shop then
    self:_updateShopHelper(forceReposition)
  end
end

function LotteryMixed:OnClickLotteryHelp()
  TipsView.Me():ShowGeneralHelpByHelpId(35051)
end

function LotteryMixed:SetMixedLotteryType()
  self.lotteryType = _LotteryFunc:GetRecentMixLotteryType()
end

function LotteryMixed:InitStaticData()
  _LotteryFunc:InitMixShop(self.lotteryType, nil)
  if self.isNewMix then
    return
  end
  self.staticData = _LotteryFunc:GetMixStaticData(self.lotteryType)
  if nil == self.staticData then
    redlog("混合扭蛋未初始化 检查GameConfig.MixLottery.MixLotteryShop : ", self.lotteryType)
  end
end

function LotteryMixed:DoEnter()
  self.container.lotterySaleIcon:SetActive(false)
  self.container:ActiveLotteryName(true)
end

function LotteryMixed:SetDressModel()
  if self.modelSet then
    return
  end
  if self.viewIndex == _Index_Lottery then
    self:InitDressModel()
    self.modelSet = true
  else
    _LotteryFunc:ClearDressMap()
  end
end

function LotteryMixed:Show()
  self:SetLotteryType()
  self.root:SetActive(true)
  self:DoEnter()
  self:UpdateHelperByIndex(true)
  self:SetDressModel()
end

function LotteryMixed:Hide()
  self:ToLottery()
  self.root:SetActive(false)
  self.modelSet = false
end

function LotteryMixed:_clearPopupCombineCallBack()
  self.lotteryPopUpCtl:ClearCallBack()
  self.shopSitePopUpCtrl:ClearCallBack()
  self.shopQualityPopUpCtl:ClearCallBack()
end

function LotteryMixed:OnExit()
  LotteryMixed.super.OnExit(self)
  self:_clearPopupCombineCallBack()
  self.lotteryHelper:Destroy()
  self.shopHelper:Destroy()
  TableUtility.TableClear(wrapConfig)
  TimeLimitShopProxy.Instance:viewPopUp()
end

function LotteryMixed:OnEnter()
  LotteryMixed.super.OnEnter(self)
  self:DoEnter()
end

function LotteryMixed:UpdateCost()
  local price = _LotteryProxy.mixLotteryPrice
  local onceMaxCount = _LotteryProxy.mixLotteryOnceMaxCount
  self.container:UpdateCostValue(price, onceMaxCount)
end

function LotteryMixed:UpdateTicketCost()
  self.container:UpdateTicketCostValue(_LotteryProxy.mixLotteryOnceMaxCount)
end

function LotteryMixed:Lottery()
  local price = _LotteryProxy.mixLotteryPrice
  local freecnt = _LotteryProxy:GetMixFreeCnt()
  self:CallLottery(price, 1, freecnt)
end

function LotteryMixed:LotteryTen()
  local price = _LotteryProxy.mixLotteryPrice
  local count = _LotteryProxy.mixLotteryOnceMaxCount or 10
  self:CallLottery(price, count, 0)
end

function LotteryMixed:Ticket()
  self.container:CallTicket()
end

function LotteryMixed:TicketTen()
  self.container:CallTicket(nil, nil, _Eleven)
end

function LotteryMixed:UpdateLimit()
  local cnt, maxCnt, tencnt, tenMaxcnt = _LotteryProxy:GetMixCnts()
  if not (cnt and maxCnt and tencnt) or not tenMaxcnt then
    return
  end
  local limitStr
  if self.container:TenToggleEnabled() then
    limitStr = string.format(ZhString.LotteryMixed_todayTenLimited, tencnt, tenMaxcnt)
  else
    limitStr = string.format(ZhString.LotteryMixed_todayLimited, cnt, maxCnt)
  end
  self.container:SetLotteryLimitLab(limitStr)
end

function LotteryMixed:ClickCell(cell)
  self.container:ClickCell(cell)
  if self.viewIndex == _Index_Lottery then
    self:_updateLotteryHelper()
  else
    self:_updateShopHelper()
  end
end

function LotteryMixed:UpdateHelpBtn()
  self.container:ActiveHelpBtn(true)
end
