local _Path = "GUI/v1/part/MixShopFilterPopup"
local _Proxy
autoImport("MixShopFilterSiteCell")
autoImport("MixShopFilterYearCell")
MixShopFilterPopup = class("MixShopFilterPopup", SubView)

function MixShopFilterPopup:CreateSelf(parent)
  local obj = self:LoadPreferb_ByFullPath(_Path, parent, true)
  obj.name = "MixShopFilterPopup"
  self.gameObject = obj
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  if not self.closecomp then
    self.closecomp = self.gameObject:AddComponent(CloseWhenClickOtherPlace)
  end
end

function MixShopFilterPopup:ResetFilter()
  self.choose_site = 0
  self.noGotTogValue = false
  self:UpdateColider(true, self.choose_site)
  if self.shop_GotToggle then
    self.shop_GotToggle:Set(false)
  end
  self:ChooseSite()
  self:ChooseYear()
end

function MixShopFilterPopup:Init(parent)
  _Proxy = LotteryProxy.Instance
  self:ResetFilter()
  self:CreateSelf(parent)
  self:FindObj()
end

function MixShopFilterPopup:FindObj()
  self.shop_GotToggleObj = self:FindGO("OnlyGot")
  self.shop_GotToggle = self.shop_GotToggleObj:GetComponent(UIToggle)
  self:AddClickEvent(self.shop_GotToggleObj, function()
    self.noGotTogValue = not self.noGotTogValue
    self:TryChangeYear()
    EventManager.Me():DispatchEvent(LotteryEvent.MixShopTogChanged)
  end)
  self.onlyGotLab = self:FindComponent("Lab", UILabel, self.togObj)
  self.onlyGotLab.text = ZhString.LotteryMixed_filterGotItem
  self.siteLab = self:FindComponent("SiteLab", UILabel)
  self.siteLab.text = ZhString.Lottery_MixShop_Site
  self.yearLab = self:FindComponent("YearLab", UILabel)
  self.yearLab.text = ZhString.Lottery_MixShop_Year
  self.processLab = self:FindComponent("ProcessLab", UILabel)
  local site_grid = self:FindComponent("SiteGrid", UIGrid)
  self.siteCtl = UIGridListCtrl.new(site_grid, MixShopFilterSiteCell, "MixShopFilterSiteCell")
  self.siteCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickSite, self)
  local year_grid = self:FindComponent("YearGrid", UIGrid)
  self.yearCtl = UIGridListCtrl.new(year_grid, MixShopFilterYearCell, "MixShopFilterYearCell")
  self.yearCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickYear, self)
end

function MixShopFilterPopup:ChooseSite()
  if not self.siteCtl then
    return
  end
  local cells = self.siteCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoose(self.choose_site)
  end
end

function MixShopFilterPopup:OnClickSite(cellCtl)
  if self.choose_site == cellCtl.data then
    return
  end
  self.choose_site = cellCtl.data
  self:ChooseSite()
  if self:TryChangeYear() then
    return
  end
  EventManager.Me():DispatchEvent(LotteryEvent.MixShopSiteChanged, cellCtl.data)
end

function MixShopFilterPopup:OnClickYear(cellCtl)
  if self.choose_year == cellCtl.data then
    return
  end
  self.choose_year = cellCtl.data
  if self:TryChangeYear() then
    return
  end
  self:ChooseYear()
  EventManager.Me():DispatchEvent(LotteryEvent.MixShopYearChanged, self.choose_year)
end

function MixShopFilterPopup:SetYear(y)
  self.choose_year = y
  self:ChooseYear()
end

function MixShopFilterPopup:ChooseYear()
  if not self.yearCtl then
    return
  end
  local cells = self.yearCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoose(self.choose_year)
  end
end

function MixShopFilterPopup:UpdateColider(igonre, site)
  if not self.yearCtl then
    return
  end
  local cells = self.yearCtl:GetCells()
  for i = 1, #cells do
    cells[i]:UpdateColider(igonre, site)
  end
end

function MixShopFilterPopup:OnEnter()
  MixShopFilterPopup.super.OnEnter(self)
  self.siteCtl:ResetDatas(FunctionLottery.Me():GetShopSiteFilter())
  self:UpdateYear()
  self:ChooseSite()
end

function MixShopFilterPopup:UpdateYear()
  self.processLab.text = string.format(ZhString.PetAdventure_Process, _Proxy.mixShopGoodsGotCount, _Proxy.mixShopGoodsCnt)
  self.yearCtl:ResetDatas(_Proxy:GetShopGoodsYears())
end

function MixShopFilterPopup:OnShow()
  self:UpdateYear()
  self:UpdateColider(not self.noGotTogValue, self.choose_site)
end

function MixShopFilterPopup:OnExit()
  self.siteCtl:Destroy()
  self.yearCtl:Destroy()
  MixShopFilterPopup.super.OnExit(self)
end

function MixShopFilterPopup:TryChangeYear()
  self:UpdateColider(not self.noGotTogValue, self.choose_site)
  if self.noGotTogValue then
    local choose_year = LotteryProxy.Instance:CalcValidYear(self.choose_site, self.choose_year)
    if choose_year and self.choose_year ~= choose_year then
      self.choose_year = choose_year
      EventManager.Me():DispatchEvent(LotteryEvent.MixShopYearManualChanged, {
        self.choose_year,
        choose_year,
        self.choose_site
      })
      self:ChooseYear()
      return true
    end
  end
  return false
end
