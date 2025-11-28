autoImport("TwelvePVPShopItemCell")
TwelvePVPShopView = class("TwelvePVPShopView", BaseView)
TwelvePVPShopView.ViewType = UIViewType.NormalLayer
local ShopType = GameConfig.TwelvePvp.ShopConfig.shoptype
local ShopID = GameConfig.TwelvePvp.ShopConfig.shopid
local itemid = GameConfig.TwelvePvp.ShopConfig.shopcoin
local LevelItem = GameConfig.TwelvePvp.ShopItemConfig.LevelItem
local CrystalExpConfig = GameConfig.TwelvePvp.CrystalConfig.ExpLevel
local CampUIConfig = {
  [1] = "12pvp_bg_01",
  [2] = "12pvp_bg_02"
}

function TwelvePVPShopView:Init()
  self:FindObjs()
  self:AddViewEvts()
  self:InitShow()
end

function TwelvePVPShopView:FindObjs()
  self.LeftStick = self:FindGO("LeftStick"):GetComponent(UISprite)
  local itemGrid = self:FindGO("itemGrid"):GetComponent(UIGrid)
  self.itemGridCtrl = UIGridListCtrl.new(itemGrid, TwelvePVPShopItemCell, "TwelvePVPShopItemCell")
  self.itemGridCtrl:AddEventListener(HappyShopEvent.SelectIconSprite, self.HandleClickIconSprite, self)
  self.crystalLv = self:FindGO("crystalLv"):GetComponent(UILabel)
  self.crystalIcon = self:FindGO("crystalIcon"):GetComponent(UITexture)
  self.expProgress = self:FindGO("EXPProgress"):GetComponent(UISlider)
  self.expPercent = self:FindGO("EXPPercent"):GetComponent(UILabel)
  self.goldIcon = self:FindGO("goldIcon"):GetComponent(UISprite)
  self.gold = self:FindGO("gold"):GetComponent(UILabel)
end

function TwelvePVPShopView:AddViewEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateMoney)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.RecvBuyShopItem)
  self:AddListenEvt(ServiceEvent.SessionShopServerLimitSellCountCmd, self.UpdateShopInfo)
  self:AddListenEvt(TwelvePVPEvent.UpdateCrystalExp, self.UpdateCrystalLv)
  self:AddListenEvt(TwelvePVPEvent.UpdateGold, self.UpdateGold)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
end

function TwelvePVPShopView:InitShow()
  self.tipData = {}
  self.tipData.funcConfig = {}
  ServiceFuBenCmdProxy.Instance:CallTwelvePvpUIOperCmd(FuBenCmd_pb.ETWELVEPVP_UI_SHOP, true)
  HappyShopProxy.Instance:InitShop(nil, ShopID, ShopType)
  self:UpdateShopInfo()
  self.myCamp = MyselfProxy.Instance:GetTwelvePVPCamp()
  PictureManager.Instance:SetPVP(CampUIConfig[self.myCamp], self.crystalIcon)
  self:UpdateCrystalLv()
  if itemid and Table_Item[itemid] then
    IconManager:SetItemIcon(Table_Item[itemid].Icon, self.goldIcon)
  end
  self:UpdateGold()
end

function TwelvePVPShopView:UpdateCrystalLv()
  local myCamp = self.myCamp
  local process = TwelvePvPProxy.Instance:GetCrystalProgress(myCamp)
  local crystalexp = TwelvePvPProxy.Instance:GetCrystalExpByCamp(myCamp)
  self.crystalLv.text = string.format(ZhString.TwelvePVPInfoTip_LV, TwelvePvPProxy.Instance:GetCrystalLv(self.myCamp))
  self.expProgress.value = process
  if crystalexp >= CrystalExpConfig[#CrystalExpConfig] then
    self.expPercent.text = ZhString.TwelvePVPShop_FullExp
  else
    local totalExp = TwelvePvPProxy.Instance:GetCrystalTotalExp(myCamp)
    self.expPercent.text = string.format(ZhString.TwelvePVP_PreparePlayerNum, crystalexp, totalExp)
  end
end

function TwelvePVPShopView:UpdateGold()
  self.gold.text = TwelvePvPProxy.Instance:GetGold()
end

function TwelvePVPShopView:UpdateShopInfo(isReset)
  local datas = HappyShopProxy.Instance:GetShopItems()
  local shopData = ShopProxy.Instance:GetShopDataByTypeId(ShopType, ShopID)
  if not self.shopItems then
    self.shopItems = {}
  else
    TableUtility.ArrayClear(self.shopItems)
  end
  if shopData then
    local config = shopData:GetGoods()
    for k, v in pairs(config) do
      TableUtility.ArrayPushBack(self.shopItems, k)
    end
  end
  table.sort(self.shopItems, function(l, r)
    local _ShopProxy = ShopProxy.Instance
    local ldata = _ShopProxy:GetShopItemDataByTypeId(ShopType, ShopID, l)
    local rdata = _ShopProxy:GetShopItemDataByTypeId(ShopType, ShopID, r)
    if ldata.CanOpen ~= rdata.CanOpen then
      return not ldata:GetLock()
    elseif ldata.ShopOrder == rdata.ShopOrder then
      return ldata.id < rdata.id
    else
      return ldata.ShopOrder < rdata.ShopOrder
    end
  end)
  self.itemGridCtrl:ResetDatas(self.shopItems)
end

function TwelvePVPShopView:RecvBuyShopItem(note)
  self:UpdateShopInfo()
end

function TwelvePVPShopView:RecvQueryShopConfig(note)
  self:UpdateShopInfo()
end

function TwelvePVPShopView:HandleClickIconSprite(cellctl)
  local data = ShopProxy.Instance:GetShopItemDataByTypeId(ShopType, ShopID, cellctl.data)
  local itemdata = data:GetItemData()
  if data and data.goodsID and itemdata then
    self.tipData.itemdata = itemdata
    if LevelItem[data.goodsID] then
      local count = TwelvePvPProxy.Instance:GetRaidItemNum(data.goodsID) + 1
      if count > #LevelItem[data.goodsID] then
        count = count - 1
      end
      self.tipData.itemdata.staticData.Desc = LevelItem[data.goodsID][count] and LevelItem[data.goodsID][count].desc or self.tipData.itemdata.staticData.Desc
    end
    self:ShowItemTip(self.tipData, self.LeftStick)
  end
end

function TwelvePVPShopView:OnEnter()
  TwelvePVPShopView.super.OnEnter(self)
end

function TwelvePVPShopView:OnExit()
  ServiceFuBenCmdProxy.Instance:CallTwelvePvpUIOperCmd(FuBenCmd_pb.ETWELVEPVP_UI_SHOP, false)
  if self.itemGridCtrl then
    self.itemGridCtrl:Destroy()
  end
  if self.myCamp and CampUIConfig[self.myCamp] then
    PictureManager.Instance:UnLoadPVP(CampUIConfig[self.myCamp], self.crystalIcon)
  end
  TwelvePVPShopView.super.OnExit(self)
end
