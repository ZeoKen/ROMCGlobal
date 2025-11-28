autoImport("LotteryView")
autoImport("LotteryRecoverCombineCell")
autoImport("LotteryDetailCell")
autoImport("LotteryMagicDetailCell")
LotteryMagicView = class("LotteryMagicView", LotteryView)
LotteryMagicView.ViewType = LotteryView.ViewType

function LotteryMagicView:OnEnter()
  LotteryMagicView.super.OnEnter(self)
  self:QueryLotteryExtraBonus()
end

function LotteryMagicView:OnExit()
  if self.rateSb ~= nil then
    self.rateSb:Destroy()
    self.rateSb = nil
  end
  GameObject.DestroyImmediate(self.bg.mainTexture)
  self.recoverHelper:Destroy()
  LotteryMagicView.super.OnExit(self)
end

function LotteryMagicView:FindObjs()
  LotteryMagicView.super.FindObjs(self)
  self.bg = self:FindGO("Background"):GetComponent(UITexture)
  self.ticket = self:FindGO("Ticket"):GetComponent(UILabel)
  self.discountRoot = self:FindGO("DiscountRoot")
  self.discount = self:FindGO("Discount"):GetComponent(UILabel)
  self.discountTime = self:FindGO("DiscountTime"):GetComponent(UILabel)
  self.ticketCost = self:FindGO("TicketCost"):GetComponent(UILabel)
  self.countlabel = self:FindGO("Label", self.bubblePfb):GetComponent(UILabel)
  self.filter = self:FindGO("Filter"):GetComponent(UIPopupList)
  self.newTag = self:FindGO("NewTag")
end

function LotteryMagicView:AddEvts()
  LotteryMagicView.super.AddEvts(self)
  local ticketBtn = self:FindGO("TicketBtn")
  self:AddClickEvent(ticketBtn, function()
    self:Ticket()
  end)
  local detailBtn = self:FindGO("DetailBtn")
  self:AddClickEvent(detailBtn, function()
    self:ShowDetail(true)
  end)
  local recoverReturnBtn = self:FindGO("RecoverReturnBtn")
  self:AddClickEvent(recoverReturnBtn, function()
    self:ShowRecover(false)
  end)
  local detailReturnBtn = self:FindGO("DetailReturnBtn")
  self:AddClickEvent(detailReturnBtn, function()
    self:ShowDetail(false)
  end)
  self:AddClickEvent(self.recoverBtn.gameObject, function()
    self:Recover()
  end)
  local help = self:FindGO("HelpButton")
  self:AddClickEvent(help, function()
    local data = Table_Help[self.viewdata.view.id]
    if data then
      TipsView.Me():ShowGeneralHelp(data.Desc, data.Title)
    else
      ServiceItemProxy.Instance:CallLotteryRateQueryCmd(self.lotteryType)
    end
  end)
  EventDelegate.Add(self.filter.onChange, function()
    if self.filter.data == nil then
      return
    end
    if self.filterData ~= self.filter.data then
      self.filterData = self.filter.data
      self.newTag:SetActive(self.filterData == 1)
      self:UpdateDetail()
    end
  end)
  local extrahelp = self:FindGO("ExtraHelpButton")
  self:RegistShowGeneralHelpByHelpID(35021, extrahelp)
end

function LotteryMagicView:AddViewEvts()
  LotteryMagicView.super.AddViewEvts(self)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(LotteryEvent.MagicPictureComplete, self.HandlePicture)
  self:AddListenEvt(ServiceEvent.ItemLotteryRateQueryCmd, self.HandleLotteryRateQuery)
  self:AddListenEvt(ServiceEvent.ItemQueryLotteryExtraBonusItemCmd, self.OnRecvExtraBonusItemCmd)
  self:AddListenEvt(ServiceEvent.ItemQueryLotteryExtraBonusCfgCmd, self.OnRecvExtraBonusCfgCmd)
end

function LotteryMagicView:InitShow()
  LotteryMagicView.super.InitShow(self)
  self:UpdateLotteryType()
  self.recoverSelect = {}
  self.isUpdateRecover = true
  local container = self:FindGO("RecoverContainer")
  local wrapConfig = ReusableTable.CreateTable()
  wrapConfig.wrapObj = container
  wrapConfig.pfbNum = 5
  wrapConfig.cellName = "LotteryRecoverCombineCell"
  wrapConfig.control = LotteryRecoverCombineCell
  wrapConfig.dir = 1
  self.recoverHelper = WrapCellHelper.new(wrapConfig)
  self.recoverHelper:AddEventListener(MouseEvent.MouseClick, self.ClickRecover, self)
  self.recoverHelper:AddEventListener(LotteryEvent.Select, self.SelectRecover, self)
  local detailContainer = self:FindGO("DetailContainer")
  TableUtility.TableClear(wrapConfig)
  wrapConfig.wrapObj = detailContainer
  wrapConfig.pfbNum = 7
  wrapConfig.cellName = "LotteryMagicDetailCell"
  wrapConfig.control = LotteryMagicDetailCell
  wrapConfig.dir = 1
  self.detailHelper = WrapCellHelper.new(wrapConfig)
  self.detailHelper:AddEventListener(MouseEvent.MouseClick, self.ClickDetail, self)
  ReusableTable.DestroyAndClearTable(wrapConfig)
  self.filter:Clear()
  local filterConfig = GameConfig.Lottery.MagicFilter
  for i = 1, #filterConfig do
    self.filter:AddItem(filterConfig[i].name, i)
  end
  if 0 < #filterConfig then
    self.filterData = 1
    self.filter.value = filterConfig[self.filterData].name
  end
  self:InitTicket()
  self:InitRecover()
  self:UpdateTicket()
  self:UpdateTicketCost()
  self:ShowRecover(false)
  self:InitView()
  self:UpdatePicUrl()
end

function LotteryMagicView:Ticket()
  self:CallTicket()
end

function LotteryMagicView:InitView()
  LotteryMagicView.super.InitView(self)
  self:UpdateCost()
  self:UpdateDetail()
end

function LotteryMagicView:ClickDetail(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data:GetItemData()
    local currentTip = self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Right, {-300, 0})
  end
end

function LotteryMagicView:UpdateSkip()
  local isShow = FunctionFirstTime.me:IsFirstTime(FunctionFirstTime.LotteryMagic)
  self.skipBtn.gameObject:SetActive(not isShow)
end

function LotteryMagicView:UpdatePicUrl()
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

function LotteryMagicView:UpdateDownloadPic()
  if self.picUrl ~= nil then
    return LotteryProxy.Instance:DownloadMagicPicFromUrl(self.picUrl)
  end
end

function LotteryMagicView:UpdatePicture(bytes)
  local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
  local ret = ImageConversion.LoadImage(texture, bytes)
  if ret then
    GameObject.DestroyImmediate(self.bg.mainTexture)
    self.bg.mainTexture = texture
  end
end

function LotteryMagicView:UpdateDiscount()
  LotteryMagicView.super.UpdateDiscount(self)
  local aeDiscount = ActivityEventProxy.Instance:GetLotteryDiscountByCoinType(self.lotteryType, AELotteryDiscountData.CoinType.Coin)
  if aeDiscount ~= nil and aeDiscount:IsInActivity() then
    self.discountRoot:SetActive(true)
    self.discount.text = string.format(ZhString.Lottery_Discount, 100 - aeDiscount.discount)
    local beginTime = os.date("*t", aeDiscount.beginTime)
    local endTime = os.date("*t", aeDiscount.endTime)
    self.discountTime.text = string.format(ZhString.Lottery_DiscountTime, beginTime.month, beginTime.day, endTime.month, endTime.day)
  else
    self.discountRoot:SetActive(false)
  end
end

function LotteryMagicView:UpdateLotteryType()
  self.lotteryType = LotteryType.Magic
end

function LotteryMagicView:UpdateDetail()
  local data = LotteryProxy.Instance:FilterMagic(self.lotteryType, self.filterData)
  if data then
    self.detailHelper:UpdateInfo(data)
    self.detailHelper:ResetPosition()
  end
end

function LotteryMagicView:HandleItemUpdate(note)
  self:UpdateTicket()
  if self.isShowRecover then
    self:TryUpdateRecover()
  else
    self.isUpdateRecover = true
  end
end

function LotteryMagicView:HandleActivityEventNtf(note)
  LotteryMagicView.super.HandleActivityEventNtf(self)
  self:UpdatePicUrl()
end

function LotteryMagicView:HandlePicture(note)
  local data = note.body
  if data and self.picUrl == data.picUrl then
    self:UpdatePicture(data.bytes)
  end
end

function LotteryMagicView:HandleLotteryRateQuery(note)
  local data = note.body
  if data and data.type == self.lotteryType then
    if self.rateSb == nil then
      self.rateSb = LuaStringBuilder.CreateAsTable()
    else
      self.rateSb:Clear()
    end
    local desc = Table_Help[20008].Desc or ""
    local lines = string.split(desc, "\n")
    for _, v in pairs(lines) do
      self.rateSb:AppendLine(v)
    end
    self.rateSb:AppendLine("")
    if not GameConfig.SystemForbid.LotteryRateUrl then
      self.rateSb:AppendLine(ZhString.Lottery_RateUrl)
    end
    self.rateSb:AppendLine(ZhString.Lottery_MagicRateTip)
    self.rateSb:AppendLine("")
    local _ItemType = GameConfig.Lottery.ItemType
    local leftRate = 100
    for i = 1, #data.infos do
      local info = data.infos[i]
      if info.rate ~= 0 then
        if BranchMgr.IsJapan() then
          self.rateSb:AppendLine(string.format(ZhString.Lottery_RateTip1, _ItemType[info.type] or "", info.rate / 10000))
        else
          self.rateSb:Append(_ItemType[info.type] or "")
          self.rateSb:AppendLine(string.format(ZhString.Lottery_RateTip, info.rate / 10000))
        end
        leftRate = leftRate - info.rate / 10000
      end
    end
    TipsView.Me():ShowGeneralHelp(self.rateSb:ToString(), "")
  end
end
