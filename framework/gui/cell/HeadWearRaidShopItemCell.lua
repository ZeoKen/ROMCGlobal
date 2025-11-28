HeadWearRaidShopItemCell = class("HeadWearRaidShopItemCell", ShopItemCell)
local zeroV3 = LuaVector3.Zero()

function HeadWearRaidShopItemCell:Init()
  self.cellContainer = self:FindGO("CellContainer")
  if self.cellContainer then
    local obj = self:LoadPreferb("cell/ItemCell", self.cellContainer)
    obj.transform.localPosition = zeroV3
    obj.transform.localScale = LuaGeometry.Const_V3_one
    self.cellContainer:AddComponent(UIDragScrollView)
  end
  HeadWearRaidShopItemCell.super.super.Init(self)
  self:FindObjs()
  self:AddEvts()
  self.NormalColor = "[ffffff]"
  self.WarnColor = "[FF3B0D]"
end

function HeadWearRaidShopItemCell:SetData(data)
  HeadWearRaidShopItemCell.super.SetData(self, data)
  local shopItemData = self:GetShopItemData(data)
  if shopItemData then
    local itemData = shopItemData:GetItemData()
    self:SetQuality(itemData)
  end
end

function HeadWearRaidShopItemCell:SetQuality(data)
  local quality = 1
  if data and data.staticData and data.staticData.Quality then
    self:GetBgSprite()
    quality = data.staticData.Quality
  end
  if self.bg_inited then
    self:SetItemQualityBG(quality)
  end
end

function HeadWearRaidShopItemCell:SetItemQualityBG(quality)
  if quality == 1 then
    local spName = self.DefaultBg_spriteName or "com_icon_bottom3"
    if self.bg.spriteName ~= spName then
      self.bg.atlas = self.DefaultBg_atlas or RO.AtlasMap.GetAtlas("NewCom")
      self.bg.spriteName = spName
    end
  else
    self.bg.atlas = RO.AtlasMap.GetAtlas("NEWUI_Equip")
    self.bg_inited = true
    if quality == 2 then
      self.bg.spriteName = "refine_bg_green"
    elseif quality == 3 then
      self.bg.spriteName = "refine_bg_blue"
    elseif quality == 4 then
      self.bg.spriteName = "refine_bg_purple"
    elseif quality == 5 then
      self.bg.spriteName = "refine_bg_orange"
    elseif quality == 6 then
      self.bg.spriteName = "refine_bg_red"
    end
  end
end
