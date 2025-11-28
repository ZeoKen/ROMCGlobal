NoviceCombineView = class("NoviceCombineView", ContainerView)
NoviceCombineView.ViewType = UIViewType.NormalLayer
autoImport("NoviceTabCell")
autoImport("NoviceLoginView")
autoImport("NoviceBattlePassSubView")
autoImport("NoviceRechargeSignInSubView")
autoImport("NoviceShopSubView")
autoImport("NoviceRewardSubView")
local tabIndex = {
  [1] = {
    index = 1,
    Name = "初心签到",
    openCheck = DailyLoginProxy.Instance:isNoviceLoginOpen(),
    helpID = 35208,
    Redtip = SceneTip_pb.EREDSYS_SIGNACTIVITY_NOVICE
  },
  [2] = {
    index = 2,
    Name = "初心者战令",
    openCheck = NoviceBattlePassProxy.Instance:IsNoviceBPAvailable(),
    helpID = 35210,
    Redtip = SceneTip_pb.EREDSYS_NOVICE_BP
  },
  [3] = {
    index = 3,
    openCheck = NoviceRechargeProxy.Instance:GetActValid(),
    helpID = 35267,
    Redtip = SceneTip_pb.EREDSYS_NOVICE_CHARGE
  },
  [4] = {
    index = 4,
    Name = "超值礼包",
    openCheck = NoviceShopProxy.Instance:isShopOpen(),
    helpID = 35237
  },
  [5] = {
    index = 5,
    Name = "充值福利",
    openCheck = NoviceShopProxy.Instance:isShopOpen(),
    helpID = 35268,
    Redtip = SceneTip_pb.EREDSYS_FIRST_DEPOSIT
  }
}

function NoviceCombineView:Init()
  self:FindObjs()
  self:AddViewEvts()
  self:AddMapEvts()
  self:InitDatas()
  self:InitShow()
end

function NoviceCombineView:FindObjs()
  self.goBTNBack = self:FindGO("BTN_Back", self.gameObject)
  self.u_bgTex = self:FindComponent("bbg", UITexture, self.gameObject)
  self.bgTexName = "mall_twistedegg_bg_bottom"
  PictureManager.Instance:SetUI(self.bgTexName, self.u_bgTex)
  PictureManager.ReFitFullScreen(self.u_bgTex, 1)
  self.goGachaCoinBalance = self:FindGO("GachaCoinBalance", self.gameObject)
  self.goLabGachaCoinBalance = self:FindGO("Lab", self.goGachaCoinBalance)
  self.labGachaCoinBalance = self.goLabGachaCoinBalance:GetComponent(UILabel)
  self.spGachaCoin = self:FindGO("Icon", self.goGachaCoinBalance):GetComponent(UISprite)
  IconManager:SetItemIcon("item_151", self.spGachaCoin)
  self.subSelectContainer = self:FindComponent("Grid", UIGrid, self:FindGO("SubSelector", self.gameObject))
  self.subSelectListCtrl = UIGridListCtrl.new(self.subSelectContainer, NoviceTabCell, "NoviceTabCell")
  self.timeLeftLabel = self:FindGO("TimeLeftLabel"):GetComponent(UILabel)
  self.helpBtn = self:FindGO("HelpBtn")
end

function NoviceCombineView:UpdateHelpBtn()
  local helpID = self.currentTab and tabIndex[self.currentTab] and tabIndex[self.currentTab].helpID
  self:TryOpenHelpViewById(helpID, nil, self.helpBtn)
end

function NoviceCombineView:AddViewEvts()
  self:AddClickEvent(self.goBTNBack, function()
    self:CloseSelf()
  end)
end

function NoviceCombineView:AddMapEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateBalance)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateBalance)
  self:AddListenEvt(ServiceEvent.NUserUpdateShopGotItem, self.UpdateBalance)
  self:AddListenEvt(ServiceEvent.SceneUser3FirstDepositInfo, self.UpdateBalance)
end

function NoviceCombineView:InitDatas()
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.currentTab = viewdata and viewdata.tab
  self:UpdateHelpBtn()
end

function NoviceCombineView:InitShow()
  local tabList = {}
  for i = 1, #tabIndex do
    local valid = false
    if i == 1 then
      valid = DailyLoginProxy.Instance:isNoviceLoginOpen()
      if valid then
        table.insert(tabList, tabIndex[i])
      end
    elseif i == 2 then
      valid = NoviceBattlePassProxy.Instance:IsNoviceBPAvailable()
      if valid then
        table.insert(tabList, tabIndex[i])
      end
    elseif i == 3 then
      valid = NoviceRechargeProxy.Instance:GetActValid()
      if valid then
        table.insert(tabList, tabIndex[i])
      end
    elseif i == 4 then
      valid = NoviceShopProxy.Instance:isShopOpen()
      if valid then
        table.insert(tabList, tabIndex[i])
      end
    elseif i == 5 then
      valid = NoviceShopProxy.Instance:isShopOpen()
      if valid then
        table.insert(tabList, tabIndex[i])
      end
    end
    if valid and self.currentTab == nil then
      self.currentTab = tabIndex[i].index
      self:UpdateHelpBtn()
    end
  end
  self.subSelectListCtrl:ResetDatas(tabList)
  self:LoadSubView(tabList)
  local cells = self.subSelectListCtrl:GetCells()
  for i = 1, #cells do
    self:AddTabChangeEvent(cells[i].gameObject, nil, cells[i].data.index)
    if cells[i].data.Redtip then
      self:RegisterRedTipCheck(cells[i].data.Redtip, cells[i].gameObject, 42, {-10, -10})
    end
  end
  self:UpdateBalance()
  self:TabChangeHandler(self.currentTab)
end

function NoviceCombineView:LoadSubView(tabList)
  local loadNoviceLogin = function()
    if not self.noviceLoginView then
      self.noviceLoginView = self:AddSubView("NoviceLoginView", NoviceLoginView)
      self.noviceLoginView.parentView = self
    end
    return self.noviceLoginView
  end
  local loadNoviceBattlePass = function()
    if not self.noviceBattlePassView then
      self.noviceBattlePassView = self:AddSubView("NoviceBattlePassSubView", NoviceBattlePassSubView)
      self.noviceBattlePassView.parentView = self
    end
    return self.noviceBattlePassView
  end
  local loadNoviceRechargeView = function()
    if not self.noviceRechargeView then
      self.noviceRechargeView = self:AddSubView("NoviceRechargeSignInSubView", NoviceRechargeSignInSubView)
      self.noviceRechargeView.parentView = self
    end
    return self.noviceRechargeView
  end
  local loadNoviceShopView = function()
    if not self.noviceShopView then
      self.noviceShopView = self:AddSubView("NoviceShopSubView", NoviceShopSubView)
      self.noviceShopView.parentView = self
    end
    return self.noviceShopView
  end
  local loadNoviceRewardView = function()
    if not self.noviceRewardView then
      self.noviceRewardView = self:AddSubView("NoviceRewardSubView", NoviceRewardSubView)
      self.noviceRewardView.parentView = self
    end
    return self.noviceRewardView
  end
  self.subViews = {}
  self.subViews[1] = loadNoviceLogin
  self.subViews[2] = loadNoviceBattlePass
  self.subViews[3] = loadNoviceRechargeView
  self.subViews[4] = loadNoviceShopView
  self.subViews[5] = loadNoviceRewardView
  for i = 1, #tabList do
    local index = tabList[i].index
    if index then
      local subView = self.subViews[index]()
      subView:Init(true)
      subView.gameObject:SetActive(false)
    end
  end
end

function NoviceCombineView:TabChangeHandler(tab, inner)
  local subView = self.subViews[tab]()
  if subView then
    subView:Init(true)
  end
  if self.currentTab then
    local curSubView = self.subViews[self.currentTab]()
    curSubView.gameObject:SetActive(false)
    curSubView:OnHide()
  end
  self.currentTab = tab
  self:UpdateHelpBtn()
  subView.gameObject:SetActive(true)
  subView:OnShow()
  subView:OnEnter()
  subView:RefreshPage()
  self:ChangeSubSelectorOnSelect(tab)
end

function NoviceCombineView:ChangeSubSelectorOnSelect(id)
  local ssCells = self.subSelectListCtrl:GetCells()
  for i = 1, #ssCells do
    local sstab = ssCells[i].data.index
    ssCells[i]:SetSelect(sstab == id)
  end
end

function NoviceCombineView:UpdateBalance()
  local milCommaBalance = FunctionNewRecharge.FormatMilComma(MyselfProxy.Instance:GetLottery())
  if milCommaBalance then
    self.labGachaCoinBalance.text = milCommaBalance
  end
end

function NoviceCombineView:TimeLeftCountDown(timeStamp)
  TimeTickManager.Me():ClearTick(self, 1)
  if not timeStamp then
    self.timeLeftLabel.gameObject:SetActive(false)
    return
  end
  local curServerTime = ServerTime.CurServerTime() / 1000
  if timeStamp < curServerTime then
    self.timeLeftLabel.gameObject:SetActive(false)
    return
  end
  self.timeLeftLabel.gameObject:SetActive(true)
  self.endTimeStamp = timeStamp
  TimeTickManager.Me():CreateTick(0, 5000, self.UpdateTimeLeftLabel, self, 1)
end

function NoviceCombineView:UpdateTimeLeftLabel()
  local curServerTime = ServerTime.CurServerTime() / 1000
  local leftTime = self.endTimeStamp - curServerTime
  local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(leftTime)
  if 86400 < leftTime then
    self.timeLeftLabel.text = string.format(ZhString.ActivityPuzzle_LefttimeInDays, day)
  else
    self.timeLeftLabel.text = string.format(ZhString.ActivityPuzzle_LefttimeInHours, hour, min)
  end
end

function NoviceCombineView:OnExit()
  NoviceCombineView.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
end
