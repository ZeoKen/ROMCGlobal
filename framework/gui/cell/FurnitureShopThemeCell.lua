FurnitureShopThemeCell = class("FurnitureShopThemeCell", BaseCell)

function FurnitureShopThemeCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function FurnitureShopThemeCell:FindObjs()
  self.sprTheme = self:FindComponent("Icon", UISprite)
  self.objBG = self:FindGO("bg")
  self.objBG_Select = self:FindGO("bg_Select")
end

function FurnitureShopThemeCell:SetData(data)
  self.data = data
  local setSuc = IconManager:SetHomeBuildingIcon(data.Icon, self.sprTheme)
  setSuc = setSuc or IconManager:SetItemIcon("item_45001", self.sprTheme)
  self:Select(false)
end

function FurnitureShopThemeCell:Select(isSelect)
  self.objBG:SetActive(isSelect ~= true)
  self.objBG_Select:SetActive(isSelect == true)
end
