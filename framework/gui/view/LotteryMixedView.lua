autoImport("LotteryView")
autoImport("LotteryMixCombineCell")
autoImport("LotteryMixShopCombineCell")
LotteryMixedView = class("LotteryMixedView", LotteryView)
LotteryMixedView.ViewType = LotteryView.ViewType
LotteryMixedView.ViewIndex = {
  Main = 1,
  Lottery = 2,
  Shop = 3
}
local _Index_Main = LotteryMixedView.ViewIndex.Main
local _Index_Lottery = LotteryMixedView.ViewIndex.Lottery
local _Index_Shop = LotteryMixedView.ViewIndex.Shop
local _AgainConfirmMsgID = 295
local _fashionType = 501
local LoadCellPfb = function(cName, obj)
  local pfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if nil == pfb then
    error("can not find pfb" .. cName)
  end
  pfb.transform:SetParent(obj.transform, false)
  pfb.transform.localPosition = LuaGeometry.Const_V3_zero
  return pfb
end

function LotteryMixedView:FindObjs()
  LotteryMixedView.super.FindObjs(self)
  self.mainInfoRoot = self:FindGO("MainInfoRoot")
  self.singleGroupFinish = self:FindGO("SingleGroupFinish", self.lotteryRoot):GetComponent(UILabel)
  self.singleGroupFinish.text = ZhString.LotteryMixed_singleGroupFinish
  self.singleGroupFinishIcon = self:FindGO("Icon", self.singleGroupFinish.gameObject):GetComponent(UISprite)
  self.singleGroupFinishLab = self:FindGO("Lab", self.singleGroupFinish.gameObject):GetComponent(UILabel)
  self.shopRoot = self:FindGO("ShopRoot")
  self.shopBuyRoot = self:FindGO("ShopBuyRoot")
  self.subRoot = self:FindGO("SubRoot")
  self.returnMainBtn = self:FindGO("ReturnMainBtn")
  self.onlyGotToggle = self:FindGO("OnlyGotToggle"):GetComponent(UIToggle)
  self.onlyGotToggleLab = self:FindGO("Label", self.onlyGotToggle.gameObject):GetComponent(UILabel)
  self.previewTex = self:FindGO("PreviewTexture"):GetComponent(UITexture)
  self.ticketBtn = self:FindGO("TicketBtn")
  self.lotteryFilter = self:FindGO("LotteryFilter"):GetComponent(UIPopupList)
  self.shopSiteFilter = self:FindGO("ShopSiteFilter"):GetComponent(UIPopupList)
  self.shopQualityFilter = self:FindGO("ShopQualityFilter"):GetComponent(UIPopupList)
  self.curQualityName = self:FindComponent("QualityText", UILabel)
  self.lotteryDetailBtn = self:FindGO("LotteryDetailBtn")
  self.lotteryDetailLab = self:FindGO("Lab", self.lotteryDetailBtn):GetComponent(UILabel)
  self.shopDetailBtn = self:FindGO("ShopDetailBtn")
  self.shopDetailLab = self:FindGO("Lab", self.shopDetailBtn):GetComponent(UILabel)
  self.todayLimitedLab = self:FindGO("TodayLimitedLab"):GetComponent(UILabel)
  self.todayTenLimitedLab = self:FindGO("TodayTenLimitedLab"):GetComponent(UILabel)
  self.ticket = self:FindGO("Ticket"):GetComponent(UILabel)
  self.ticketCost = self:FindGO("TicketCost"):GetComponent(UILabel)
  local go = LoadCellPfb("HappyShopBuyItemCell", self.shopBuyRoot)
  self.buyCell = HappyShopBuyItemCell.new(go)
  self.buyCell.gameObject:SetActive(false)
end

function LotteryMixedView:AddEvts()
  LotteryMixedView.super.AddEvts(self)
  EventDelegate.Add(self.onlyGotToggle.onChange, function()
    self:UpdateHelperByIndex(false, true)
  end)
  self:AddClickEvent(self.ticketBtn, function()
    self:Ticket()
  end)
  self:AddClickEvent(self.lotteryDetailBtn, function()
    self:OnClickLotteryDetail()
  end)
  self:AddClickEvent(self.shopDetailBtn, function()
    self:OnClickShopDetail()
  end)
  self:AddClickEvent(self.returnMainBtn, function()
    self:OnClickReturn()
  end)
  local HelpBtn = self:FindGO("HelpBtn")
  self:TryOpenHelpViewById(35051, nil, HelpBtn)
  EventDelegate.Add(self.lotteryFilter.onChange, function()
    if self.lotteryFilter.data == nil then
      return
    end
    if self.lotteryFilterData ~= self.lotteryFilter.data then
      self.lotteryFilterData = self.lotteryFilter.data
      self:UpdateLotteryInfo(true)
    end
  end)
  EventDelegate.Add(self.shopSiteFilter.onChange, function()
    if self.shopSiteFilter.data == nil then
      return
    end
    if self.shopSiteFilterData ~= self.shopSiteFilter.data then
      self.shopSiteFilterData = self.shopSiteFilter.data
      if self.shopSiteFilterData == _fashionType then
        self.shopQualityFilterData = 0
        self.curQualityName.text = GameConfig.MixLottery.QualityFilter[0]
      end
      self:UpdateShopInfo(true)
    end
  end)
  EventDelegate.Add(self.shopQualityFilter.onChange, function()
    if self.shopQualityFilter.data == nil then
      return
    end
    if self.shopSiteFilterData == _fashionType and self.shopQualityFilter.data ~= 0 then
      self.shopQualityFilterData = 0
      self.curQualityName.text = GameConfig.MixLottery.QualityFilter[0]
      MsgManager.ShowMsgByID(41412)
      return
    end
    if self.shopQualityFilterData ~= self.shopQualityFilter.data then
      self.shopQualityFilterData = self.shopQualityFilter.data
      self:UpdateShopInfo(true)
      self.curQualityValue = self.shopQualityFilter.value
    end
  end)
end

function LotteryMixedView:OnClickLotteryDetail()
  self:SetViewIndex(_Index_Lottery)
end

function LotteryMixedView:OnClickShopDetail()
  self:SetViewIndex(_Index_Shop)
  if not self.staticData then
    return
  end
  ShopProxy.Instance:CallQueryShopConfig(self.staticData.ShopType, self.staticData.ShopID)
end

function LotteryMixedView:OnClickShopItemCell(ctl)
  local data = ctl.data
  if data then
    local id = data.id
    HappyShopProxy.Instance:SetSelectId(id)
    local itemType = data.itemtype
    if itemType and itemType ~= 2 then
      self.buyCell:SetData(data)
      self.buyCell.gameObject:SetActive(true)
      TipsView.Me():HideCurrent()
    else
      self.buyCell.gameObject:SetActive(false)
    end
  end
end

function LotteryMixedView:OnClickReturn()
  self:SetViewIndex(_Index_Main)
end

function LotteryMixedView:OnClickPreviewItemCell(ctl)
  local data = ctl.data
  if data then
    self.tipData.itemdata = data
    self:ShowItemTip(self.tipData, ctl.icon, NGUIUtil.AnchorSide.Left, {-250, 0})
  end
end

function LotteryMixedView:Ticket()
  self:CallTicket()
end

function LotteryMixedView:AddViewEvts()
  LotteryMixedView.super.AddViewEvts(self)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleUpdate)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.HandleUpdate)
  self:AddListenEvt(ServiceEvent.ItemMixLotteryArchiveCmd, self.HandleUpdate)
  self:AddListenEvt(LotteryEvent.MagicPictureComplete, self.HandlePicture)
end

function LotteryMixedView:HandleUpdate()
  LotteryProxy.Instance:UpdateMixLotteryFilterData()
  self:UpdateHelperByIndex(false, false)
end

function LotteryMixedView:InitShow()
  self.onlyGotToggle.value = false
  self:SetViewIndex(_Index_Main)
  self:SetMixedLotteryType()
  ServiceItemProxy.Instance:CallMixLotteryArchiveCmd(self.lotteryType)
  self:InitStaticData()
  self:InitReplace()
  LotteryMixedView.super.InitShow(self)
  self:InitHelper()
  self:InitMainView()
  self:InitText()
  self:InitFilter()
  self:InitTicket()
  self:UpdateTicket()
  self:UpdateTicketCost()
  self:UpdateReplaceMoney()
  self:InitView()
  self:UpdatePicUrl()
end

function LotteryMixedView:InitReplace()
  local replaceId = self.staticData.Replaceid
  if not replaceId then
    return
  end
  local replaceIcon = self:FindGO("ReplaceIcon"):GetComponent(UISprite)
  self.replaceNum = self:FindGO("ReplaceLab"):GetComponent(UILabel)
  local item = Table_Item[replaceId]
  if item then
    IconManager:SetItemIcon(item.Icon, replaceIcon)
    IconManager:SetItemIcon(item.Icon, self.singleGroupFinishIcon)
  end
end

function LotteryMixedView:UpdateReplaceMoney()
  if self.staticData and self.staticData.Replaceid and self.replaceNum then
    self.replaceNum.text = StringUtil.NumThousandFormat(BagProxy.Instance:GetItemNumByStaticID(self.staticData.Replaceid))
  end
end

function LotteryMixedView:UpdateCost()
  local price = LotteryProxy.Instance.mixLotteryPrice
  local onceMaxCount = LotteryProxy.Instance.mixLotteryOnceMaxCount
  self:UpdateCostValue(price, onceMaxCount)
end

function LotteryMixedView:Lottery()
  local price = LotteryProxy.Instance.mixLotteryPrice
  self:CallLottery(price, 1)
end

function LotteryMixedView:LotteryTen()
  local price = LotteryProxy.Instance.mixLotteryPrice
  local count = LotteryProxy.Instance.mixLotteryOnceMaxCount or 10
  self:CallLottery(price, count)
end

function LotteryMixedView:ClickDetail(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data:GetItemData()
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Right, {-280, 0})
  end
end

function LotteryMixedView:UpdateTodayLimit()
  local isChina = BranchMgr.IsChina()
  self.todayLimitedLab.gameObject:SetActive(isChina)
  self.todayTenLimitedLab.gameObject:SetActive(isChina)
  local cnt, maxCnt, tencnt, tenMaxcnt = LotteryProxy.Instance:GetMixCnts()
  if not (cnt and maxCnt and tencnt) or not tenMaxcnt then
    return
  end
  self.todayLimitedLab.text = string.format(ZhString.LotteryMixed_todayLimited, cnt, maxCnt)
  self.todayTenLimitedLab.text = string.format(ZhString.LotteryMixed_todayTenLimited, tencnt, tenMaxcnt)
end

function LotteryMixedView:UpdateSkip()
  local isShow = FunctionFirstTime.Me():IsFirstTime(FunctionFirstTime.LotteryMix)
  self.skipBtn.gameObject:SetActive(not isShow)
end

function LotteryMixedView:InitText()
  self.onlyGotToggleLab.text = ZhString.LotteryMixed_filterGotItem
  self.lotteryDetailLab.text = ZhString.LotteryMixed_LotteryBtn
  self.shopDetailLab.text = ZhString.LotteryMixed_ShopBtn
end

function LotteryMixedView:UpdatePicture(bytes)
  local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
  local ret = ImageConversion.LoadImage(texture, bytes)
  if ret then
    GameObject.DestroyImmediate(self.previewTex.mainTexture)
    self.previewTex.mainTexture = texture
  end
end

function LotteryMixedView:HandlePicture(note)
  local data = note.body
  if data and self.picUrl == data.picUrl then
    self:UpdatePicture(data.bytes)
  end
end

function LotteryMixedView:HandleActivityEventNtf(note)
  LotteryMixedView.super.HandleActivityEventNtf(self)
  self:UpdatePicUrl()
end

function LotteryMixedView:UpdatePicUrl()
  local list = ActivityEventProxy.Instance:GetLotteryBanner(self.lotteryType)
  if list ~= nil and 0 < #list then
    local picUrl = list[#list]:GetPath()
    if self.picUrl ~= picUrl then
      self.picUrl = picUrl
      local bytes = self:UpdateDownloadPic()
      if bytes then
        self:UpdatePicture(bytes)
      end
    end
  end
end

function LotteryMixedView:UpdateDownloadPic()
  if self.picUrl ~= nil then
    return LotteryProxy.Instance:DownloadMagicPicFromUrl(self.picUrl)
  end
end

function LotteryMixedView:_initPreviewCtl()
  self.previewItemGrid = self:FindGO("PreviewItemGrid"):GetComponent(UIGrid)
  self.previewItemCtl = UIGridListCtrl.new(self.previewItemGrid, BaseItemCell, "DropItemCell")
  self.previewItemCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickPreviewItemCell, self)
  self.previewItemCtl:ResetDatas(self.staticData.PreviewItems)
end

local wrapConfig = {}

function LotteryMixedView:InitHelper()
  local container = self:FindGO("LotteryContainer")
  TableUtility.TableClear(wrapConfig)
  wrapConfig.wrapObj = container
  wrapConfig.pfbNum = 7
  wrapConfig.cellName = "LotteryMixCombineCell"
  wrapConfig.control = LotteryMixCombineCell
  self.lotteryHelper = WrapCellHelper.new(wrapConfig)
  self.lotteryHelper.wrap.itemSize = BranchMgr.IsJapan() and 150 or 100
  self.lotteryHelper:AddEventListener(MouseEvent.MouseClick, self.ClickDetail, self)
  container = self:FindGO("ShopContainer")
  TableUtility.TableClear(wrapConfig)
  wrapConfig.wrapObj = container
  wrapConfig.pfbNum = 6
  wrapConfig.cellName = "LotteryMixShopCombineCell"
  wrapConfig.control = LotteryMixShopCombineCell
  self.shopHelper = WrapCellHelper.new(wrapConfig)
  self.shopHelper:AddEventListener(MouseEvent.MouseClick, self.OnClickShopItemCell, self)
end

function LotteryMixedView:InitMainView()
  self:_initPreviewCtl()
end

function LotteryMixedView:InitFilter()
  self:_initShopSiteFilter()
  self:_initShopQualityFilter()
  self:_initShopFilterFirst()
end

function LotteryMixedView:_initLotteryFilter(resetPosition)
  if not self.lotteryFilter then
    self.lotteryFilter = self:FindGO("LotteryFilter"):GetComponent(UIPopupList)
  end
  local cfg = LotteryProxy.Instance.lotteryFilterData
  if not cfg then
    return
  end
  self.lotteryFilter:Clear()
  local rangeList = LotteryProxy.GetLotteryFilter(cfg)
  for i = 1, #rangeList do
    local rangeData = cfg[rangeList[i]]
    self.lotteryFilter:AddItem(rangeData, rangeList[i])
  end
  if resetPosition and 0 < #rangeList then
    local range = rangeList[1]
    self.lotteryFilterData = range
    local rangeData = cfg[range]
    self.lotteryFilter.value = rangeData
  end
end

function LotteryMixedView:_initShopSiteFilter()
  self.shopSiteFilter:Clear()
  local cfg = GameConfig.MixLottery.EquipFilter
  local rangeList = LotteryProxy.GetLotteryFilter(cfg)
  for i = 1, #rangeList do
    local rangeData = cfg[rangeList[i]]
    self.shopSiteFilter:AddItem(rangeData, rangeList[i])
  end
end

function LotteryMixedView:_initShopFilterFirst()
  local cfg = GameConfig.MixLottery.EquipFilter
  local rangeList = LotteryProxy.GetLotteryFilter(cfg)
  local rangeData
  if 0 < #rangeList then
    local range = rangeList[1]
    self.shopSiteFilterData = range
    rangeData = cfg[range]
    self.shopSiteFilter.value = rangeData
  end
  cfg = GameConfig.MixLottery.QualityFilter
  rangeList = LotteryProxy.GetLotteryFilter(cfg)
  if 0 < #rangeList then
    local range = rangeList[1]
    self.shopQualityFilterData = range
    rangeData = cfg[range]
    self.shopQualityFilter.value = rangeData
  end
end

function LotteryMixedView:_initShopQualityFilter()
  self.shopQualityFilter:Clear()
  local cfg = GameConfig.MixLottery.QualityFilter
  local rangeList = LotteryProxy.GetLotteryFilter(cfg)
  for i = 1, #rangeList do
    local rangeData = cfg[rangeList[i]]
    self.shopQualityFilter:AddItem(rangeData, rangeList[i])
  end
end

function LotteryMixedView:InitView()
  LotteryMixedView.super.InitView(self)
  self:UpdateCost()
  self:UpdateTodayLimit()
end

function LotteryMixedView:UpdateLotteryInfo(resetPosition)
  self:_updateLotteryHelper()
  if resetPosition then
    self.lotteryHelper:ResetPosition()
  end
end

function LotteryMixedView:UpdateShopInfo(resetPosition)
  self:_updateShopHelper()
  if resetPosition then
    self.shopHelper:ResetPosition()
  end
end

function LotteryMixedView:_updateLotteryHelper()
  local helperData = LotteryProxy.Instance:FilterMixLottery(self.lotteryFilterData, self.onlyGotToggle.value)
  local newData = self:ReUniteCellData(helperData, 4)
  if 0 == FunctionLottery.Me():GetUngetCnt(self.lotteryFilterData) then
    local rate = FunctionLottery.Me():GetRateByGroup(self.lotteryFilterData)
    self.singleGroupFinish.gameObject:SetActive(true)
    self.onlyGotToggle.gameObject:SetActive(false)
    self.singleGroupFinishLab.text = string.format(ZhString.LotteryMixed_singleGroup, rate * 100)
  else
    self.singleGroupFinish.gameObject:SetActive(false)
    self.onlyGotToggle.gameObject:SetActive(true)
  end
  self.lotteryFilter.value = LotteryProxy.Instance.lotteryFilterData[self.lotteryFilterData]
  self.lotteryHelper:UpdateInfo(newData)
end

function LotteryMixedView:_updateShopHelper()
  local helperData = LotteryProxy.Instance:FilterMixLotteryShop(self.lotteryType, self.shopSiteFilterData, self.shopQualityFilterData, self.onlyGotToggle.value)
  local newData = self:ReUniteCellData(helperData, 3)
  self.shopHelper:UpdateInfo(newData)
end

function LotteryMixedView:CallLottery(price, times)
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(_AgainConfirmMsgID)
  if dont == nil then
    MsgManager.DontAgainConfirmMsgByID(_AgainConfirmMsgID, function()
      LotteryMixedView.super.CallLottery(self, price, nil, nil, times)
    end, nil, nil, price * times)
    return
  end
  LotteryMixedView.super.CallLottery(self, price, nil, nil, times)
end

function LotteryMixedView:SetViewIndex(index)
  if self.viewIndex ~= index then
    self.viewIndex = index
    local isMain = index == _Index_Main
    self.mainInfoRoot:SetActive(isMain)
    self.subRoot:SetActive(not isMain)
    self.lotteryRoot:SetActive(index == _Index_Lottery)
    self.shopRoot:SetActive(index == _Index_Shop)
    self.onlyGotToggle:Set(false)
    self:UpdateHelperByIndex(true)
  end
end

function LotteryMixedView:UpdateHelperByIndex(init, forceReposition)
  self:UpdateTicket()
  self:UpdateReplaceMoney()
  local index = self.viewIndex
  if index == _Index_Lottery then
    self:_initLotteryFilter(init)
    self:UpdateLotteryInfo(init or forceReposition)
  elseif index == _Index_Shop then
    if init then
      self:_initShopFilterFirst()
    end
    self:UpdateShopInfo(init or forceReposition)
  end
end

function LotteryMixedView:SetMixedLotteryType()
  self.lotteryType = FunctionLottery.Me():GetRecentMixLotteryType()
end

function LotteryMixedView:InitStaticData()
  self.staticData = FunctionLottery.Me():GetMixStaticData(self.lotteryType)
  if nil == self.staticData then
    redlog("混合扭蛋未初始化 检查GameConfig.MixLottery.MixLotteryShop : ", self.lotteryType)
  end
end

function LotteryMixedView:OnExit()
  GameObject.DestroyImmediate(self.previewTex.mainTexture)
  self.buyCell:Exit()
  LotteryMixedView.super.OnExit(self)
  TimeLimitShopProxy.Instance:viewPopUp()
end
