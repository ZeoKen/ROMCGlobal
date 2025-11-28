autoImport("GemContainerView")
SevenRoyalFamilyTreeView = class("SevenRoyalFamilyTreeView", GemContainerView)
SevenRoyalFamilyTreeView.ViewType = UIViewType.NormalLayer
SevenRoyalFamilyTreeView.ViewMaskAdaption = {all = 1}
SevenRoyalFamilyTreeView.TogglePageNameMap = {
  VolumeTab = "SevenRoyalFamilyTreeVolumePage",
  AttrTab = "SevenRoyalFamilyTreeAttrPage"
}
local bgTexName = "Sevenroyalfamilies_bg"

function SevenRoyalFamilyTreeView:Init()
  SevenRoyalFamilyTreeView.super.Init(self)
  self.tipData = {
    funcConfig = _EmptyTable
  }
  self.gpContainer = self:FindGO("GetPathContainer")
  self.bgTex = self:FindComponent("BgTex", UITexture)
  self.uiCamera = NGUIUtil:GetCameraByLayername("UI")
  self:InitCostCtrl()
end

local costTipOffset = {160, -340}

function SevenRoyalFamilyTreeView:InitCostCtrl()
  self.costSp = self:FindComponent("CostCtrl", UISprite)
  self.costLabel = self:FindComponent("CostLabel", UILabel)
  self.costItemId = GameConfig.Family.ItemCost
  IconManager:SetItemIcon(Table_Item[self.costItemId].Icon, self.costSp)
  self.tipData.itemdata = ItemData.new("cost", self.costItemId)
  self:UpdateCostCtrl()
  self:AddClickEvent(self.costSp.gameObject, function()
    self:ShowItemTip(self.tipData, self.costSp, NGUIUtil.AnchorSide.Down, costTipOffset)
  end)
  self:AddButtonEvent("CostAddBtn", function()
    local moneyCfg = GameConfig.MoneyId
    if self.costItemId == moneyCfg.Zeny then
      FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_Zeny)
    elseif self.costItemId == moneyCfg.Lottery then
      FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_ROB)
    else
      self:ShowGetPathOfCost()
    end
  end)
end

function SevenRoyalFamilyTreeView:AddEvents()
  local go = self:FindGO("Help")
  self:RegistShowGeneralHelpByHelpID(35089, go)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddListenEvt(MyselfEvent.ZenyChange, self.OnZenyChange)
end

function SevenRoyalFamilyTreeView:GetDefaultPageName()
  return self.TogglePageNameMap.VolumeTab
end

function SevenRoyalFamilyTreeView:OnEnter()
  SevenRoyalFamilyTreeView.super.OnEnter(self)
  PictureManager.Instance:SetUI(bgTexName, self.bgTex)
  PictureManager.ReFitFullScreen(self.bgTex)
  self:UpdateCostCtrl()
end

function SevenRoyalFamilyTreeView:OnExit()
  PictureManager.Instance:UnLoadUI(bgTexName, self.bgTex)
  SevenRoyalFamilyTreeView.super.OnExit(self)
end

function SevenRoyalFamilyTreeView:OnItemUpdate()
  self:UpdateCostCtrl()
end

function SevenRoyalFamilyTreeView:OnZenyChange()
  self:UpdateCostCtrl()
end

function SevenRoyalFamilyTreeView:UpdateCostCtrl()
  self.costLabel.text = StringUtil.NumThousandFormat(HappyShopProxy.Instance:GetItemNum(self.costItemId)) or 0
end

function SevenRoyalFamilyTreeView:ShowGetPathOfCost()
  if self.bdt then
    self.bdt:OnExit()
  elseif self.costItemId then
    self.bdt = GainWayTip.new(self.gpContainer)
    self.bdt:SetAnchorPos(true)
    self.bdt:SetData(self.costItemId)
    self.bdt:AddEventListener(ItemEvent.GoTraceItem, function()
      self:CloseSelf()
    end, self)
    self.bdt:AddEventListener(GainWayTip.CloseGainWay, self.GetPathCloseCall, self)
  end
end

function SevenRoyalFamilyTreeView:GetPathCloseCall()
  self.bdt = nil
end
