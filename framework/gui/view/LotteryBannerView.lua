autoImport("BannerItemCell")
LotteryBannerView = class("LotteryBannerView", ContainerView)
LotteryBannerView.ViewType = UIViewType.NormalLayer
local TextureMap = {
  [1] = "mall_bg_pen",
  [2] = "mall_bg_bottom_10",
  [3] = "mall_bg_key",
  [4] = "mall_bg_decorate_10",
  [5] = "mall_bg_btn",
  [6] = "mall_bg_bottom_07"
}
local cardBgTexture = "mall_bg_bottom_16"
local DateStr = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
local TipMap = GameConfig.LotteryBanner.Tips

function LotteryBannerView:Init()
  self.texts = {}
  for i = 1, 4 do
    local t = self:FindGO("text" .. i):GetComponent(UITexture)
    self.texts[i] = t
  end
  self.gotoBtn = self:FindGO("gotoBtn")
  self.texts[5] = self.gotoBtn:GetComponent(UITexture)
  self.up = self:FindGO("up")
  self.upLabel = self:FindGO("upLabel"):GetComponent(UILabel)
  self.upLabel.text = GameConfig.LotteryBanner.SpecialTip or ""
  self.texts[6] = self.up:GetComponent(UITexture)
  for i = 1, 6 do
    PictureManager.Instance:SetUI(TextureMap[i], self.texts[i])
  end
  self.cover = self:FindGO("Cover"):GetComponent(UITexture)
  self.title = self:FindGO("title"):GetComponent(UILabel)
  self.duration = self:FindGO("duration"):GetComponent(UILabel)
  self.tip = self:FindGO("tip"):GetComponent(UILabel)
  self.tipSp = self:FindGO("tipSp"):GetComponent(UISprite)
  
  function self.tip.onChange()
    if self.tipSp then
      self.tipSp:ResetAndUpdateAnchors()
    end
  end
  
  self.itemCells = {}
  for i = 1, 3 do
    local itemGo = self:FindGO("ItemContainer" .. i)
    if itemGo then
      local cell = BannerItemCell.new(itemGo)
      cell:SetIndex(i)
      table.insert(self.itemCells, cell)
      cell:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
    end
  end
  self.preBtn = self:FindGO("preBtn")
  self.nextBtn = self:FindGO("nextBtn")
  self.currentIndex = 1
  self:AddClickEvent(self.preBtn, function()
    self:SetPre()
  end)
  self:AddClickEvent(self.nextBtn, function()
    self:SetNext()
  end)
  self:AddClickEvent(self.gotoBtn, function()
    if self.lotteryType then
      self:sendNotification(MainViewEvent.ClearViewSequence)
      FunctionLottery.Me():OpenNewLotteryByType(self.lotteryType)
    end
  end)
  self:AddCloseButtonEvent()
  self.cardDescGO = self:FindGO("CardDesc1")
  self.cardDesc1 = self.cardDescGO:GetComponent(UILabel)
  self.cardDescBg = self:FindGO("CardDescBg", self.cardDescGO):GetComponent(UITexture)
  self.cardDesc2 = self:FindGO("CardDesc2", self.cardDescGO):GetComponent(UILabel)
  self.cardTime = self:FindGO("CardTime", self.cardDescGO):GetComponent(UILabel)
end

function LotteryBannerView:OnEnter()
  self.currentIndex = 1
  self:UpdateView()
end

function LotteryBannerView:SetPre()
  self.currentIndex = self.currentIndex - 1
  local bList = LotteryProxy.Instance:GetBannerList()
  if self.currentIndex <= 0 then
    self.currentIndex = #bList
  end
  self:UpdateView()
end

function LotteryBannerView:SetNext()
  self.currentIndex = self.currentIndex + 1
  local bList = LotteryProxy.Instance:GetBannerList()
  if self.currentIndex > #bList then
    self.currentIndex = 1
  end
  self:UpdateView()
end

function LotteryBannerView:UpdateView()
  local bList = LotteryProxy.Instance:GetBannerList()
  self.preBtn:SetActive(1 < #bList)
  self.nextBtn:SetActive(1 < #bList)
  local curStyle = self.currentIndex and bList and bList[self.currentIndex]
  if curStyle then
    self.lotteryType = curStyle.type
    self.curStyleID = curStyle.styleID
  else
    self.curStyleID = 0
  end
  if TipMap and TipMap[self.lotteryType] then
    self.tip.text = TipMap[self.lotteryType]
    self.tip.gameObject:SetActive(true)
  else
    self.tip.gameObject:SetActive(false)
  end
  local dont = LocalSaveProxy.Instance:GetBannerDontShowAgain(self.lotteryType)
  if not dont then
    LocalSaveProxy.Instance:AddBannerDontShowAgain(self.lotteryType)
  end
  local styleConfig = Table_LotteryBanner[self.curStyleID]
  if styleConfig and curStyle then
    self.title.text = styleConfig.Name
    if not (BranchMgr.IsJapan() and styleConfig.JPShowTime) or styleConfig.JPShowTime == "" then
      local _, monthS, dayS = curStyle.validDate:match(DateStr)
      local _, monthE, dayE = curStyle.validEnd:match(DateStr)
      self.duration.text = string.format(ZhString.LotteryBanner_Duration, monthS, dayS, monthE, dayE)
      self.cardTime.text = string.format(ZhString.LotteryBanner_CardDuration, monthS, dayS, monthE, dayE)
    else
      self.duration.text = styleConfig.JPShowTime
      self.cardTime.text = styleConfig.JPShowTime
    end
    PictureManager.Instance:SetLotteryBannerTexture(styleConfig.Picture, self.cover)
    for i = 1, #self.itemCells do
      self.itemCells[i]:SetData(styleConfig["ItemId" .. i], curStyle.type)
    end
    self.up:SetActive(styleConfig.isUp == 1)
    local showCardDesc = styleConfig.CardDesc1 and styleConfig.CardDesc1 ~= ""
    if showCardDesc then
      self.cardDescGO:SetActive(true)
      self.cardDesc1.text = styleConfig.CardDesc1
      self.cardDesc2.text = styleConfig.CardDesc2
      PictureManager.Instance:SetUI(cardBgTexture, self.cardDescBg)
    else
      self.cardDescGO:SetActive(false)
    end
  end
end

function LotteryBannerView:ClickItem(cell)
  local data = cell.data
  if data == nil then
    self:ShowItemTip()
    return
  end
  local sdata = {
    itemdata = data,
    funcConfig = {},
    ignoreBounds = ignoreBounds,
    hideGetPath = true
  }
  self:ShowItemTip(sdata, self.tipstick, NGUIUtil.AnchorSide.Left, {-212, 0})
end

function LotteryBannerView:OnExit()
  for i = 1, 6 do
    PictureManager.Instance:UnLoadUI(TextureMap[i], self.texts[i])
  end
  PictureManager.Instance:UnLoadUI(cardBgTexture, self.cardDescBg)
  PictureManager.Instance:UnloadLotteryBannerTexture(nil, self.cover)
  if self.itemCells then
    for i = 1, #self.itemCells do
      self.itemCells[i]:DestroySelf()
    end
  end
end
