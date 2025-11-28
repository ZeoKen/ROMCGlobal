MaidDungeonView = class("MaidDungeonView", ContainerView)
autoImport("MaidDungeonInfo")
autoImport("MaidDungeonRate")
autoImport("CostInfoCell")
autoImport("RaidEnterWaitView")
MaidDungeonView.ViewType = UIViewType.NormalLayer
local raidConfig = GameConfig.JanuaryRaid

function MaidDungeonView:Init()
  self:InitUI()
  self:AddListenEvts()
end

function MaidDungeonView:OnEnter()
  MaidDungeonView.super.OnEnter(self)
  self:CameraRotateToMe()
  if self.viewdata.view and self.viewdata.view.tab then
    self:TabChangeHandler(self.viewdata.view.tab)
  else
    self:TabChangeHandler(1)
  end
  self:AddButtonEvent("Enter", function()
    self:Enter()
  end)
  self:TabChangeHandler(1)
end

function MaidDungeonView:InitUI()
  self.infoGO = self:FindGO("ActivityDungeonInfo")
  self.rateGO = self:FindGO("ActivityDungeonRate")
  self.shopGO = self:FindGO("ActivityDungeonShop")
  self.infoPage = self:AddSubView("MaidDungeonInfo", MaidDungeonInfo)
  self.ratePage = self:AddSubView("MaidDungeonRate", MaidDungeonRate)
  local coinsGrid = self:FindComponent("TopCoins", UIGrid)
  self.coinsCtl = UIGridListCtrl.new(coinsGrid, CostInfoCell, "CoinInfoCell")
  local infoTab = self:FindGO("InfoTab")
  self:AddTabChangeEvent(infoTab, self.infoGO, PanelConfig.MaidDungeonInfo)
  local ratingTab = self:FindGO("RatingTab")
  self:AddTabChangeEvent(ratingTab, self.rateGO, PanelConfig.MaidDungeonRate)
  self.redtip = self:FindGO("redtip")
  local shopTab = self:FindGO("ShopTab")
  shopTab:SetActive(false)
  local tabList = {
    infoTab,
    ratingTab,
    shopTab
  }
  self.tabIconSpList = {}
  for i, v in ipairs(tabList) do
    local icon = Game.GameObjectUtil:DeepFindChild(v, "Icon")
    self.tabIconSpList[#self.tabIconSpList + 1] = icon:GetComponent(UISprite)
  end
end

function MaidDungeonView:TabChangeHandler(key)
  if MaidDungeonView.super.TabChangeHandler(self, key) then
    self:SetCurrentTabIconColor(self.coreTabMap[key].go)
  end
end

function MaidDungeonView:OnExit()
  UIUtil.StopEightTypeMsg()
  self:CameraReset()
  MaidDungeonView.super.OnExit(self)
end

function MaidDungeonView:SetCurrentTabIconColor(currentTabGo)
  TabNameTip.ResetColorOfTabIconList(self.tabIconSpList)
  TabNameTip.SetupIconColorOfCurrentTabObj(currentTabGo)
end

function MaidDungeonView:Enter()
  ServiceFuBenCmdProxy.Instance:CallJanuaryOperFubenCmd(1)
end

function MaidDungeonView:UpdateRedtip()
  self.redtip:SetActive(DungeonProxy.Instance:CheckRedtip())
end

function MaidDungeonView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
end
