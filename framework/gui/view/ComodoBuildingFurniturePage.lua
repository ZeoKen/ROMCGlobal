autoImport("ComodoBuildingSubPage")
autoImport("HappyShopBuyItemCell")
autoImport("ComodoBuildingFurnitureTabListCell")
autoImport("ComodoBuildingFurnitureShopItemCell")
ComodoBuildingFurniturePage = class("ComodoBuildingFurniturePage", ComodoBuildingSubPage)
local shopIns, buildingIns

function ComodoBuildingFurniturePage:InitPage()
  if not shopIns then
    shopIns = HappyShopProxy.Instance
    buildingIns = ComodoBuildingProxy.Instance
  end
  ComodoBuildingFurniturePage.super.InitPage(self)
  self:InitBuyItemCell()
  self.leftStick = self:FindComponent("LeftStick", UIWidget)
  self.tipData = {
    funcConfig = _EmptyTable
  }
  self.tabListCtrl = ListCtrl.new(self:FindComponent("FurnitureTabGrid", UIGrid), ComodoBuildingFurnitureTabListCell, "ComodoBuildingFurnitureTabListCell")
  self.tabListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickTab, self)
  self.tabListCells = self.tabListCtrl:GetCells()
  local container = self:FindGO("ItemContainer")
  self.itemCtrl = WrapListCtrl.new(container, ComodoBuildingFurnitureShopItemCell, "ComodoBuildingFurnitureShopItemCell", nil, nil, nil, true)
  self.itemCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickItem, self)
  self.itemCtrl:AddEventListener(HappyShopEvent.SelectIconSprite, self.OnClickIcon, self)
  
  function self.itemCtrl.scrollView.onDragStarted()
    self.selectGo = nil
    self.buyCell.gameObject:SetActive(false)
    TipManager.CloseTip()
  end
  
  self.buyCell.closeWhenClickOtherPlace:AddTarget(container.transform)
end

function ComodoBuildingFurniturePage:InitBuyItemCell()
  local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("HappyShopBuyItemCell"))
  if not go then
    return
  end
  go.transform:SetParent(self.gameObject.transform, false)
  go.transform.localPosition = LuaGeometry.GetTempVector3(-350)
  self.buyCell = HappyShopBuyItemCell.new(go)
  self.buyCell:AddCloseWhenClickOtherPlaceCallBack(self)
end

function ComodoBuildingFurniturePage:AddEvents()
  ComodoBuildingFurniturePage.super.AddEvents(self)
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.OnBuyShopItem)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.OnQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopShopDataUpdateCmd, self.OnShopDataUpdate)
  self:AddListenEvt(ServiceEvent.SessionShopServerLimitSellCountCmd, self.OnServerLimitSellCount)
  self:AddListenEvt(ServiceEvent.SessionShopUpdateShopConfigCmd, self.OnUpdateShopConfig)
end

function ComodoBuildingFurniturePage:OnEnter()
  ComodoBuildingFurniturePage.super.OnEnter(self)
  local arr = ReusableTable.CreateArray()
  for index, _ in pairs(GameConfig.Manor.BuildingFurnitureShopFilter) do
    TableUtility.ArrayPushBack(arr, index)
  end
  table.sort(arr)
  self.tabListCtrl:ResetDatas(arr)
  ReusableTable.DestroyAndClearArray(arr)
  local firstTab = self.tabListCells[1]
  firstTab.toggle.value = true
  self:OnClickTab(firstTab)
end

function ComodoBuildingFurniturePage:OnBuyShopItem(note)
  self:UpdateShopInfo()
end

function ComodoBuildingFurniturePage:OnQueryShopConfig(note)
  self:UpdateTab()
end

function ComodoBuildingFurniturePage:OnShopDataUpdate(note)
  local data = note.body
  if data and data.type == shopIns:GetShopType() and data.shopid == shopIns:GetShopId() then
    shopIns:CallQueryShopConfig()
  end
end

function ComodoBuildingFurniturePage:OnServerLimitSellCount(note)
  self:UpdateShopInfo()
end

function ComodoBuildingFurniturePage:OnUpdateShopConfig(note)
  self:UpdateTab()
end

function ComodoBuildingFurniturePage:OnQuery()
  ComodoBuildingProxy.RefreshFurniture()
  self:UpdateTab()
end

function ComodoBuildingFurniturePage:OnLevelUp()
  self:OnQuery()
end

function ComodoBuildingFurniturePage:OnClickTab(cellCtl)
  self.tab = cellCtl and cellCtl.index or 1
  self:UpdateTab()
end

function ComodoBuildingFurniturePage:OnClickItem(cellCtl)
  if self.currentItem ~= cellCtl then
    if self.currentItem then
      self.currentItem:SetChoose(false)
    end
    cellCtl:SetChoose(true)
    self.currentItem = cellCtl
  end
  local id = cellCtl.data
  local data = shopIns:GetShopItemDataByTypeId(id)
  local go = cellCtl.gameObject
  if self.selectGo == go then
    self.selectGo = nil
    return
  end
  self.selectGo = go
  if data then
    if data:GetLock() then
      FunctionUnLockFunc.Me():CheckCanOpen(data.MenuID, true)
      self.buyCell.gameObject:SetActive(false)
      return
    end
    shopIns:SetSelectId(id)
    self:UpdateBuyItemInfo(data)
  end
end

local tipOffset = {-170, 0}

function ComodoBuildingFurniturePage:OnClickIcon(cellCtl)
  local data = shopIns:GetShopItemDataByTypeId(cellCtl.data)
  if data and data.goodsID then
    if #self.tipData.ignoreBounds == 1 then
      TableUtility.ArrayPushBack(self.tipData.ignoreBounds, self.itemContainer)
    end
    self:ShowItemTip(data:GetItemData(), self.leftStick, NGUIUtil.AnchorSide.Left, tipOffset)
  end
  self.buyCell.gameObject:SetActive(false)
  self.selectGo = nil
end

function ComodoBuildingFurniturePage:UpdateShopInfo(isReset)
  local datas = shopIns:GetShopItems()
  if datas then
    self.itemCtrl:ResetDatas(datas)
    shopIns:SetSelectId(nil)
  end
  if isReset == true then
    self.itemCtrl:ResetPosition()
    self.buyCell.gameObject:SetActive(false)
  end
  self.currentItem = nil
  self.selectGo = nil
end

function ComodoBuildingFurniturePage:UpdateBuyItemInfo(data)
  if not data then
    return
  end
  local itemType = data.itemtype
  if itemType and itemType ~= 2 then
    self.buyCell:SetData(data)
    self.buyCell:UpdateConfirmBtn(shopIns:GetCanBuyCount(data) ~= 0 and buildingIns:CheckFavoredItemCanBuy(self.buyCell.data.staticData.id))
    self.buyCell.gameObject:SetActive(true)
    TipManager.CloseTip()
  else
    self.buyCell.gameObject:SetActive(false)
  end
end

function ComodoBuildingFurniturePage:UpdateTab()
  shopIns:InitShop(nil, self.tab or 1, GameConfig.Manor.BuildingFurnitureShopType)
  self:UpdateShopInfo(true)
end

function ComodoBuildingFurniturePage:GetUpgradeMaterialConfig()
  return GameConfig.Manor.BuildingShopMat
end
