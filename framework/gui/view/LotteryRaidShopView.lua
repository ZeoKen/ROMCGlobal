autoImport("ActivityIntegrationLotteryRaidShopSubView")
LotteryRaidShopView = class("LotteryRaidShopView", ContainerView)
LotteryRaidShopView.ViewType = UIViewType.NormalLayer

function LotteryRaidShopView:Init()
  LotteryRaidShopView.super.Init(self)
  self:FindObjs()
  self:AddViewEvts()
  self.shopView = self:AddSubView("ActivityIntegrationLotteryRaidShopSubView", ActivityIntegrationLotteryRaidShopSubView, {hideRaidEntry = true})
end

function LotteryRaidShopView:FindObjs()
  self.goBTNBack = self:FindGO("BTN_Back", self.gameObject)
  self.bgTexture = self:FindComponent("MainBG", UITexture, self.gameObject)
  PictureManager.ReFitFullScreen(self.bgTexture, 1)
end

function LotteryRaidShopView:AddViewEvts()
  self:AddClickEvent(self.goBTNBack, function()
    self:CloseSelf()
  end)
end

function LotteryRaidShopView:OnEnter()
  LotteryRaidShopView.super.OnEnter(self)
  local config = GameConfig.LotteryRaidShop
  self.bgTextureName = config and config.BgTexture
  if self.bgTextureName then
    PictureManager.Instance:SetUI(self.bgTextureName, self.bgTexture)
  end
end

function LotteryRaidShopView:OnExit()
  if self.bgTextureName then
    PictureManager.Instance:UnLoadUI(self.bgTextureName, self.bgTexture)
    self.bgTextureName = nil
  end
  LotteryRaidShopView.super.OnExit(self)
end
