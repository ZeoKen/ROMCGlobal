autoImport("ShopSaleSellItemCell")
autoImport("PackageWalletPage")
ShopSaleBagPage = class("ShopSaleBagPage", SubView)
autoImport("ItemNormalList")
autoImport("ShopSaleCombineBagCell")
ShopSaleBagPage.TabName = {
  BagTab = ZhString.ShopSale_BagTabName,
  FoodTab = ZhString.ShopSale_FoodTabName,
  PetTab = ZhString.ShopSale_PetTabName,
  TempTab = ZhString.ShopSale_TempTabName,
  WalletTab = ZhString.ShopSale_WalletTabName
}

function ShopSaleBagPage:OnEnter()
  ShopSaleBagPage.super.OnEnter(self)
  self:UpdateBag(BagProxy.BagType.MainBag)
  self:InitUI()
end

function ShopSaleBagPage:Init()
  self:FindSaleItemPopUp()
  self:AddEvts()
  self:InitShow()
end

function ShopSaleBagPage:FindSaleItemPopUp()
  local go = self:LoadCellPfb("ShopSaleSellItemCell")
  self.saleCell = ShopSaleSellItemCell.new(go)
  self.saleCell:AddEventListener(ShopSaleEvent.SaleSuccess, self.UpdatePage, self)
  self.bagTab = self:FindGO("BagTab", self.bagRoot):GetComponent(UIToggle)
  self.tempTab = self:FindGO("TempTab", self.bagRoot)
  self.foodTab = self:FindGO("FoodTab", self.bagRoot)
  self.petTab = self:FindGO("PetTab", self.bagRoot)
  self.questTab = self:FindGO("QuestTab", self.bagRoot)
  self.walletTab = self:FindGO("WalletTab", self.bagRoot)
  RedTipProxy.Instance:RegisterUIByGroupID(21, self.walletTab, 30, {-20, -20})
  self.tabGrid = self:FindComponent("TabGrid", UIGrid)
end

function ShopSaleBagPage:InitShow()
  self.walletRoot = self:FindGO("PackageWalletRoot")
  self.bagRoot = self:FindGO("BagRoot")
  self.scrollView = self:FindGO("ItemScrollView", self.bagRoot):GetComponent(ROUIScrollView)
  local listObj = self:FindGO("ItemNormalList", self.bagRoot)
  self.itemlist = ItemNormalList.new(listObj, ShopSaleCombineBagCell, false)
  
  function self.itemlist.GetTabDatas(tabConfig)
    return ShopSaleProxy.Instance:GetBagItemDatas(tabConfig)
  end
  
  self.itemlist:SetScrollPullDownEvent(function()
    ServiceItemProxy.Instance:CallPackageSort(ShopSaleProxy.Instance:GetBagType())
  end)
  self.itemlist:AddCellEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.scrollView.PreDragEffect = 2
  self.walletPage = self:AddSubView("PackageWalletPage", PackageWalletPage)
  self.walletPage:Show()
  self.walletPage.itemlist:AddEventListener(ItemEvent.ClickItem, self.HandleClickItem, self)
end

function ShopSaleBagPage:AddEvts()
  self:AddClickEvent(self.bagTab.gameObject, function(g)
    self:UpdateBag(BagProxy.BagType.MainBag)
  end)
  self:AddClickEvent(self.foodTab, function(g)
    self:UpdateBag(BagProxy.BagType.Food)
  end)
  self:AddClickEvent(self.petTab, function(g)
    self:UpdateBag(BagProxy.BagType.Pet)
  end)
  self:AddClickEvent(self.tempTab, function(g)
    self:UpdateBag(BagProxy.BagType.Temp)
  end)
  self:AddClickEvent(self.questTab, function(g)
    self:UpdateBag(BagProxy.BagType.Quest)
  end)
  self:AddClickEvent(self.walletTab, function(g)
    self:UpdateBag(BagProxy.BagType.Wallet)
  end)
  self.bagTypeTabMap = {
    [BagProxy.BagType.MainBag] = self.bagTab.gameObject,
    [BagProxy.BagType.Food] = self.foodTab,
    [BagProxy.BagType.Pet] = self.petTab,
    [BagProxy.BagType.Temp] = self.tempTab,
    [BagProxy.BagType.Quest] = self.questTab,
    [BagProxy.BagType.Wallet] = self.walletTab
  }
  for _, tab in pairs(self.bagTypeTabMap) do
    local longPress = tab:GetComponent(UILongPress)
    
    function longPress.pressEvent(obj, state)
      self:PassEvent(TipLongPressEvent.ShopSaleBagPage, {
        state,
        obj.gameObject
      })
    end
  end
  self:AddEventListener(TipLongPressEvent.ShopSaleBagPage, self.HandleLongPress, self)
end

function ShopSaleBagPage:InitUI()
  self.params = self.viewdata.viewdata.params
  self.bagTab:Set(true)
  ShopSaleProxy.Instance:SetBagType(BagProxy.BagType.MainBag)
  ShopSaleProxy.Instance:InitBagData()
  self.itemlist:UpdateTabList(BagProxy.BagType.MainBag)
  self.itemlist:ChooseTab(self.params)
  self.itemlist:UpdateList()
  self.saleCell.gameObject:SetActive(false)
  self.tempTab:SetActive(#BagProxy.Instance.tempBagData:GetItems() > 0)
  self.foodTab:SetActive(0 < #BagProxy.Instance.foodBagData:GetItems())
  self.petTab:SetActive(0 < #BagProxy.Instance.petBagData:GetItems())
  self.questTab:SetActive(false)
  self.tabGrid:Reposition()
  local iconGO, iconSp
  self.tabIconSpList = {}
  for _, tab in pairs(self.bagTypeTabMap) do
    iconGO = Game.GameObjectUtil:DeepFindChild(tab, "Icon")
    if iconGO then
      iconSp = iconGO:GetComponent(UISprite)
      if tab.activeSelf then
        TabNameTip.SwitchShowTabIconOrLabel(iconGO, Game.GameObjectUtil:DeepFindChild(tab, "Label"))
      end
      TableUtility.ArrayPushBack(self.tabIconSpList, iconSp)
      TabNameTip.ResetColorOfTabIcon(iconSp)
    end
  end
  TabNameTip.SetupIconColorOfCurrentTabObj(self.bagTab.gameObject)
end

function ShopSaleBagPage:HandleClickItem(cellCtl)
  if cellCtl and cellCtl.data then
    if cellCtl.data.id == "wallet" then
      return
    end
    local data = cellCtl.data
    self.selectItemData = data
    local equipInfo = data.equipInfo
    if ShopSaleProxy.Instance:IsThisItemCanSale(data.id) then
      if data:HasQuench() then
        MsgManager.ShowMsgByID(43364)
        return
      elseif equipInfo and equipInfo.strengthlv > 0 then
        MsgManager.ConfirmMsgByID(1404, function()
          self:AddItem(self.selectItemData)
        end)
        return
      elseif data:HasEquipedCard() then
        MsgManager.ConfirmMsgByID(1404, function()
          self:AddItem(self.selectItemData)
        end)
        return
      end
      self:AddItem(data)
    else
      if equipInfo and equipInfo.refinelv > GameConfig.Item.sell_equip_max_refine_lv then
        MsgManager.ShowMsgByID(1403)
        return
      end
      MsgManager.FloatMsgTableParam(nil, ZhString.ShopSale_cantSale)
    end
  end
end

function ShopSaleBagPage:AddItem(data)
  local tipRefinelv = GameConfig.Item.material_tip_refine or 6
  local refinelv = data.equipInfo and data.equipInfo.refinelv or 0
  if tipRefinelv > refinelv then
    self:mDoAddItem(data)
  else
    MsgManager.ConfirmMsgByID(43293, function()
      self:mDoAddItem(data)
    end, nil, nil)
  end
end

function ShopSaleBagPage:mDoAddItem(data)
  if data.num > 1 then
    local canSaleNums = ShopSaleProxy.Instance:CanSaleNums(data.id)
    if canSaleNums < 0 then
      canSaleNums = 0
    end
    self:UpdateSaleItemPopUp()
  elseif ShopSaleProxy.Instance:IsCanSaleItemNums(data.id, 1) then
    ShopSaleProxy.Instance:AddToWaitSaleItems(data.id, 1, ShopSaleProxy.Instance:GetPrice(data))
    self.container.ShopSaleItemPage:UpdateShopSaleInfo()
    local bagType = ShopSaleProxy.Instance:GetBagType()
    self.walletPage.itemlist:UpdateList(true)
    self.itemlist:UpdateList(true)
  end
  self.container.ShopSaleItemPage:ResetPosition()
end

function ShopSaleBagPage:UpdateSaleItemPopUp()
  local data = self.selectItemData
  if data then
    data.moneycount = data.staticData.SellPrice
    data.maxcount = ShopSaleProxy.Instance:CanSaleNums(data.id)
    data.moneytype = 100
    self.saleCell:SetData(data)
  end
end

function ShopSaleBagPage:UpdateBag(bagType)
  if bagType ~= nil then
    ShopSaleProxy.Instance:SetBagType(bagType)
    TabNameTip.ResetColorOfTabIconList(self.tabIconSpList)
    TabNameTip.SetupIconColorOfCurrentTabObj(self.bagTypeTabMap[bagType])
  end
  if bagType ~= BagProxy.BagType.Wallet then
    self.walletPage:Hide()
    self.bagRoot:SetActive(true)
    self.itemlist:UpdateTabList(bagType)
    self.itemlist:UpdateList(false)
    self.itemlist:ChooseTab(1)
  else
    self.walletPage:Show()
    self.bagRoot:SetActive(false)
    self.walletPage.itemlist:UpdateList(ItemNormalList.TabType.WalletSale)
    self.walletPage.itemlist:UpdateList(false)
    self.walletPage.itemlist:ChooseTab(1)
  end
end

function ShopSaleBagPage:UpdateList()
  self.itemlist:UpdateList(true)
end

function ShopSaleBagPage:HandleItemUpdate(note)
  ShopSaleProxy.Instance:InitBagData()
  self:UpdateList()
end

function ShopSaleBagPage:UpdatePage()
  self.container.ShopSaleItemPage:UpdateShopSaleInfo()
  self.itemlist:UpdateList(true)
  self.walletPage.itemlist:UpdateList(true)
end

function ShopSaleBagPage:HandleItemReArrage(note)
  self:PlayUISound(AudioMap.UI.ReArrage)
  ShopSaleProxy.Instance:InitBagData()
  self:UpdateList()
  self.itemlist:ScrollViewRevert()
end

function ShopSaleBagPage:LoadCellPfb(cName)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cName))
  if cellpfb == nil then
    error("can not find cellpfb" .. cName)
  end
  cellpfb.transform:SetParent(self.gameObject.transform, false)
  return cellpfb
end

function ShopSaleBagPage:OnExit()
  ShopSaleBagPage.super.OnExit(self)
  self.saleCell:Exit()
end

function ShopSaleBagPage:HandleLongPress(param)
  local isPressing, go = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, ShopSaleBagPage.TabName[go.name], false, go:GetComponent(UISprite))
end
