autoImport("DressingPage")
autoImport("WrapCellHelper")
autoImport("ClothDressingCombineItemCell")
ClothDressingPage = class("ClothDressingPage", DressingPage)

function ClothDressingPage:InitPageView()
  self.shopType = ShopDressingProxy.Instance.shopType
  self.shopID = ShopDressingProxy.Instance.shopID
  ShopDressingProxy.Instance:ResetData(self.shopType, self.shopID)
  if self.itemWrapHelper == nil then
    local wrapConfig = {
      wrapObj = self.itemRoot,
      pfbNum = 6,
      cellName = "ClothDressingCombineItemCell",
      control = ClothDressingCombineItemCell,
      dir = 1
    }
    self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
    self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.OnClickItem, self)
  end
  local staticData = ShopDressingProxy.Instance.staticData
  local clothData = staticData and staticData[ShopDressingProxy.DressingType.ClothColor]
  if clothData then
    local newData = ShopDressingProxy.Instance:ReUniteCellData(clothData, 5)
    self.itemWrapHelper:UpdateInfo(newData)
  end
end

local args = {}
local defaultCount = 1

function ClothDressingPage:OnClickItem(cellctl)
  if cellctl and cellctl.data and (nil == self.chooseId or cellctl.data.id ~= self.chooseId) then
    self.chooseId = cellctl.data.id
    local data = cellctl.data
    if data then
      args[1] = Table_Couture[data.clothColorID].ClothColor
      args[2] = 1
      args[3] = data.id
      args[4] = data.ItemID
      args[5] = data.ItemCount
      args[6] = data.Discount
      ShopDressingProxy.Instance:SetClothQueryArgs(args)
      self:RefreshChooseUI(data)
      self.container:RefreshModel(self.shopType, self.shopID)
      self:SetChoose(data.id)
    else
      self.container:DisableState()
    end
  end
end

function ClothDressingPage:RefreshChooseUI(chooseData)
  self:SetDes(chooseData)
  self:SetMenuDes(chooseData, ShopDressingProxy.DressingType.ClothColor)
  local id = chooseData.id
  local menuID = chooseData.MenuID
  local moneyID = chooseData.ItemID
  local itemCount = chooseData.ItemCount
  self.container:RefreshROB(moneyID, itemCount, menuID)
end
