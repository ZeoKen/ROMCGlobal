autoImport("EquipConvertShopItemCell")
autoImport("EquipConvertBuyItemCell")
autoImport("HappyShop")
EquipConvertView = class("EquipConvertView", HappyShop)
local shopIns

function EquipConvertView:GetShowHideMode()
  return PanelShowHideMode.CreateAndDestroy
end

function EquipConvertView:InitBuyItemCell()
  if not shopIns then
    shopIns = HappyShopProxy.Instance
  end
  local go = self:LoadCellPfb("EquipConvertBuyItemCell")
  go.transform.localPosition = LuaGeometry.GetTempVector3(-185, 2)
  self.buyCell = EquipConvertBuyItemCell.new(go)
  self.buyCell.convertView = self
  self.CloseWhenClickOtherPlace = self.buyCell.closecomp
end

function EquipConvertView:InitShopInfo()
  self.itemContainer = self:FindGO("shop_itemContainer")
  local wrapConfig = {
    wrapObj = self.itemContainer,
    pfbNum = 6,
    cellName = "ShopItemCell",
    control = EquipConvertShopItemCell,
    dir = 1,
    disableDragIfFit = true
  }
  if self.itemWrapHelper then
    return
  end
  self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.itemWrapHelper:AddEventListener(HappyShopEvent.SelectIconSprite, self.HandleClickIconSprite, self)
  self.CloseWhenClickOtherPlace:AddTarget(self.itemContainer.transform)
end

function EquipConvertView:InitFilter()
  local filterPopObjName = "SkillProfessionFilterPop"
  self.filterPop = self:FindComponent(filterPopObjName, UIPopupList)
  if not self.filterPop then
    self.filterPop = self:FindComponent(filterPopObjName, UIScrollablePopupList)
    if not self.filterPop then
      LogUtility.WarningFormat("Cannot find filterPop of {0} with name {1}", self.__cname, filterPopObjName)
      return
    end
  end
  EventDelegate.Add(self.filterPop.onChange, function()
    if self.filterPop.data == nil then
      return
    end
    if self.curFilterData ~= self.filterPop.data then
      self.curFilterData = self.filterPop.data
      self:UpdateShopInfo(true)
    end
  end)
  self.filterPop.gameObject:SetActive(true)
end

function EquipConvertView:RecvQueryShopConfig(note)
  self.curFilterData = nil
  EquipConvertView.super.RecvQueryShopConfig(self, note)
end

function EquipConvertView:RecvBuyShopItem(note)
  if note.body.success then
    local shopItemData = shopIns:GetShopItemDataByTypeId(note.body.id)
    self.boughtId = shopItemData:GetItemData().staticData.id
    self.boughtSnapshot = self.boughtSnapshot or {}
    self:MakeSnapshotByStaticId(self.boughtSnapshot, self.boughtId)
  end
  self:UpdateShopInfo()
end

function EquipConvertView:OnEnter()
  self:InitFilter()
  EquipConvertView.super.OnEnter(self)
  local viewData = self.viewdata.viewdata
  self.useRandomPreview = viewData and viewData.useRandomPreview
end

function EquipConvertView:OnExit()
  self.filterPop.gameObject:SetActive(false)
  EquipConvertView.super.OnExit(self)
end

function EquipConvertView:OnItemUpdate()
  EquipConvertView.super.OnItemUpdate(self)
  if self.boughtId then
    self:TryShowConvertResult()
  end
end

function EquipConvertView:TryShowConvertResult()
  local nowSnapshot = ReusableTable.CreateTable()
  self:MakeSnapshotByStaticId(nowSnapshot, self.boughtId)
  local item
  for id, num in pairs(nowSnapshot) do
    if self.boughtSnapshot[id] ~= num then
      item = BagProxy.Instance:GetItemByGuid(id)
      break
    end
  end
  ReusableTable.DestroyAndClearTable(nowSnapshot)
  if not item then
    return
  end
  local equipInfo = item.equipInfo
  local attriMap = equipInfo and equipInfo:GetRandomEffectMap()
  if not attriMap then
    LogUtility.WarningFormat("Cannot get random effect map of item by static id = {0}", item and item.staticData.id)
    return
  end
  local isMax = false
  if item and item.equipInfo and item.equipInfo.randomEffect then
    for k, v in pairs(item.equipInfo.randomEffect) do
      local equipeffectData = Table_EquipEffect[k]
      if equipeffectData and v == equipeffectData.AttrRate[#equipeffectData.AttrRate][1] then
        isMax = true
        break
      end
    end
  end
  if isMax then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.EquipConvertResultShareView,
      viewdata = item
    })
  else
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.EquipConvertResultView,
      viewdata = item
    })
  end
  self.boughtId = nil
end

function EquipConvertView:ShowHappyItemTip(data)
  if not data.goodsID then
    return
  end
  local item = data:GetItemData():Clone()
  if self.useRandomPreview then
    item.equipInfo.isFromShopButRandomPreview = true
  else
    item.equipInfo.isFromShop = true
  end
  self.tipData.itemdata = item
  self.tipData.ignoreBounds = {
    self.itemContainer
  }
  self:ShowItemTip(self.tipData, self.LeftStick)
end

function EquipConvertView:MakeSnapshotByStaticId(tab, sId)
  TableUtility.TableClear(tab)
  if not sId then
    return
  end
  local check, items, id, num = GameConfig.PackageMaterialCheck.Exist
  for i = 1, #check do
    items = BagProxy.Instance:GetItemsByStaticID(sId, check[i])
    if items then
      for j = 1, #items do
        id, num = items[j].id, items[j].num
        tab[id] = (tab[id] or 0) + num
      end
    end
  end
end

function EquipConvertView:UpdateFilter(datas)
  self.filterPop:Clear()
  self.filterPop:AddItem(ShopInfoType.All, 0)
  local itemTypeList, adventureLogGroupList, goodsId, itemType, group = ReusableTable.CreateArray(), ReusableTable.CreateArray()
  for i = 1, #datas do
    goodsId = self:GetGoodsIdByTypeId(datas[i])
    itemType = goodsId and Table_Item[goodsId] and Table_Item[goodsId].Type
    group = itemType and Table_ItemType[itemType].AdventureLogGroup
    if TableUtility.ArrayFindIndex(itemTypeList, itemType) == 0 then
      TableUtility.ArrayPushBack(itemTypeList, itemType)
      TableUtility.ArrayPushBack(adventureLogGroupList, group or false)
    end
  end
  local groupAddedMap = ReusableTable.CreateTable()
  for i = 1, #itemTypeList do
    group = adventureLogGroupList[i]
    if group and not groupAddedMap[group] then
      self.filterPop:AddItem(Table_ItemTypeAdventureLog[group].Name, group)
      groupAddedMap[group] = true
    elseif not group then
      self.filterPop:AddItem(Table_ItemType[itemTypeList[i]].Name, itemTypeList[i])
    end
  end
  self.filterPop.value = ShopInfoType.All
  ReusableTable.DestroyAndClearTable(groupAddedMap)
  ReusableTable.DestroyAndClearArray(itemTypeList)
  ReusableTable.DestroyAndClearArray(adventureLogGroupList)
end

function EquipConvertView:UpdateShopInfo(isReset)
  local datas = shopIns:GetShopItems()
  local wrap = self:GetWrapHelper()
  if datas then
    self:NeedUpdateSold(datas)
    if self.curFilterData and self.curFilterData > 0 then
      local arr, item = {}
      for i = 1, #datas do
        item = self:GetGoodsIdByTypeId(datas[i])
        if item and Table_Item[item] then
          local itemType = Table_Item[item].Type
          local group = Table_ItemType[itemType].AdventureLogGroup
          if group and group == self.curFilterData then
            TableUtility.ArrayPushBack(arr, datas[i])
          elseif not group and itemType == self.curFilterData then
            TableUtility.ArrayPushBack(arr, datas[i])
          end
        end
      end
      datas = arr
    else
      self:UpdateFilter(datas)
    end
    wrap:UpdateInfo(datas)
    shopIns:SetSelectId(nil)
  end
  if isReset == true then
    wrap:ResetPosition()
  end
end

function EquipConvertView:GetGoodsIdByTypeId(id)
  local item = shopIns:GetShopItemDataByTypeId(id)
  return item and item.goodsID
end
