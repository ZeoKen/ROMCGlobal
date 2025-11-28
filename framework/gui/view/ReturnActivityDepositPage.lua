autoImport("ReturnActivityShopPage")
ReturnActivityDepositPage = class("ReturnActivityDepositPage", ReturnActivityShopPage)
ReturnActivityDepositPage.ViewType = UIViewType.NormalLayer
autoImport("RewardGridCell")
autoImport("ReturnActivityShopCell")
autoImport("HappyShopBuyItemCell")
local viewPath = ResourcePathHelper.UIView("ReturnActivityShopPage")
local picIns = PictureManager.Instance
local tempVector3 = LuaVector3.Zero()

function ReturnActivityDepositPage:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container.depositPageObj, true)
  obj.name = "ReturnActivityDepositPage"
  self.gameObject = self:FindGO("ReturnActivityDepositPage")
end

function ReturnActivityDepositPage:InitDatas()
  self.tipData = {}
  self.tipData.funcConfig = {}
  local globalActID = ReturnActivityProxy.Instance.curActID
  self.config = globalActID and GameConfig.Return.Feature[globalActID]
  self.shopType = ReturnActivityProxy.Instance.shopType2
  self.shopID = self.config.ShopID
  self.depositIDs = self.config.DepositIDs
  self.costID = self.config and self.config.ShopItemID2 or 151
end
