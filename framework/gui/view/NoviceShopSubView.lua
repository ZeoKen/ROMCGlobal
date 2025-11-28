NoviceShopSubView = class("NoviceShopSubView", SubView)
local viewPath = ResourcePathHelper.UIView("NoviceShopSubView")
autoImport("NoviceShopItemCellType2")
local proxy
local DepositConfig = GameConfig.FirstDeposit

function NoviceShopSubView:Init()
  if self.inited then
    return
  end
  if not proxy then
    proxy = NoviceShopProxy.Instance
  end
  self:FindObjs()
  self:AddViewEvts()
  self:InitView()
  self.inited = true
end

function NoviceShopSubView:OnEnter()
  NoviceShopSubView.super.OnEnter(self)
  NoviceShopProxy.Instance:CallQueryShopConfig(true)
  ServiceUserEventProxy.Instance:CallQueryChargeCnt()
  self.container:TimeLeftCountDown(NoviceShopProxy.Instance:GetEndDate())
end

function NoviceShopSubView:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container, true)
  obj.name = "NoviceShopSubView"
end

function NoviceShopSubView:FindObjs()
  self:LoadSubView()
  self.gameObject = self:FindGO("NoviceShopSubView")
  self.itemGroupGO = self:FindGO("ItemGroup")
  self.itemListCtrl = ListCtrl.new(self:FindComponent("Container", UIGrid, self.itemGroupGO), NoviceShopItemCellType2, "NoviceShopItemCellType2")
  self.itemListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnItemCellClicked, self)
  self.itemListCells = self.itemListCtrl:GetCells()
  self.shopView = self:FindGO("ShopView")
end

function NoviceShopSubView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.RefreshPage)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.NUserUpdateShopGotItem, self.UpdataShopGotItem)
  self:AddListenEvt(ServiceEvent.SceneUser3FirstDepositInfo, self.RefreshPage)
  self:AddListenEvt(ServiceEvent.UserEventQueryChargeCnt, self.RefreshPage)
end

function NoviceShopSubView:InitView()
  self:RefreshShopList()
end

function NoviceShopSubView:RefreshPage()
  self:RefreshShopList()
end

function NoviceShopSubView:RefreshShopList()
  local items = proxy:GetShopItems()
  if items and 0 < #items then
    self.itemListCtrl:ResetDatas(items)
  end
end

function NoviceShopSubView:RecvQueryShopConfig()
  self:InitView()
end

function NoviceShopSubView:UpdataShopGotItem()
  self:InitView()
end

function NoviceShopSubView:OnItemCellClicked(cell)
  xdlog("OnItemCellClicked")
end
