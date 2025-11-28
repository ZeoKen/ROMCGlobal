autoImport("ShopItemCell")
FurnitureShopItemCell = class("FurnitureShopItemCell", ShopItemCell)

function FurnitureShopItemCell:Init()
  FurnitureShopItemCell.super.Init(self)
  self.gameObject:SetActive(false)
end

function FurnitureShopItemCell:FindObjs()
  FurnitureShopItemCell.super.FindObjs(self)
  self.objFurnitureIcon = self:FindGO("sprFurnitureIcon")
  self.sprFurnitureIcon = self.objFurnitureIcon:GetComponent(UISprite)
  self.objOwnedNum = self:FindGO("labOwnedNum")
  self.labOwnedNum = self.objOwnedNum:GetComponent(UILabel)
  self:SetEvent(self.objFurnitureIcon, function()
    self:PassEvent(HappyShopEvent.SelectIconSprite, self)
  end)
end

function FurnitureShopItemCell:GetShopItemData(id)
  local themeData = FurnitureShopView.GetCurThemeData()
  return themeData and ShopProxy.Instance:GetShopItemDataByTypeId(themeData.ShopType, themeData.ShopID, id)
end

function FurnitureShopItemCell:SetData(data)
  FurnitureShopItemCell.super.SetData(self, data)
  if not data then
    return
  end
  local shopItemData = self:GetShopItemData(data)
  self.goodsItemStaticID = shopItemData and shopItemData.goodsID
  local itemStaticData = shopItemData and Table_Item[shopItemData.goodsID]
  local setSuc = IconManager:SetItemIcon(itemStaticData and itemStaticData.Icon or "item_45001", self.sprFurnitureIcon)
  self.objFurnitureIcon:SetActive(setSuc == true)
  if setSuc then
    self.sprFurnitureIcon:MakePixelPerfect()
  end
  local moneyColor = shopItemData and shopItemData.secDiscount > 0 and LuaGeometry.GetTempColor(0.5607843137254902, 0.9450980392156862, 0.4392156862745098) or LuaGeometry.GetTempColor(1, 1, 1)
  for i = 1, #self.costMoneyNums do
    self.costMoneyNums[i].color = moneyColor
  end
  if shopItemData.secDiscount > 0 then
    self:Show(self.primeCost.gameObject)
    self.primeCost.text = ZhString.HappyShop_originalCost .. StringUtil.NumThousandFormat(shopItemData.ItemCount)
  end
  self:RefreshOwnedNum()
  self:SetChoose(data == FurnitureShopView.GetCurItemData())
end

function FurnitureShopItemCell:RefreshOwnedNum()
  if not self.goodsItemStaticID then
    self.objOwnedNum:SetActive(false)
    return
  end
  local ownedNum = BagProxy.Instance:GetItemNumByStaticID(self.goodsItemStaticID, BagProxy.BagType.Furniture) or 0
  local bgData = AdventureDataProxy.Instance.bagMap[SceneManual_pb.EMANUALTYPE_FURNITURE]
  if bgData then
    local adventureItemData = bgData:GetItemByStaticID(self.goodsItemStaticID)
    if adventureItemData and adventureItemData.savedItemDatas then
      ownedNum = ownedNum + #adventureItemData.savedItemDatas
    end
  end
  ownedNum = ownedNum + HomeProxy.Instance:GetPlacedFurnitureNum(self.goodsItemStaticID)
  self.objOwnedNum:SetActive(0 < ownedNum)
  self.labOwnedNum.text = string.format(ZhString.FurnitureShop_haveCount, ownedNum)
end
