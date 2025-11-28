local _ParseColor = function(hexStr)
  local success, c = ColorUtil.TryParseHexString(hexStr)
  if success then
    return c
  end
end
local _Config = {
  Choose = {
    color = "61390E",
    sprite = "mall_twistedegg_bg_20"
  },
  UnChoose = {
    color = "8E6D47",
    sprite = "mall_twistedegg_bg_21"
  }
}
local BaseCell = autoImport("BaseCell")
MixShopFilterSiteCell = class("MixShopFilterSiteCell", BaseCell)

function MixShopFilterSiteCell:Init()
  self.name = self.gameObject:GetComponent(UILabel)
  self.bgSp = self:FindComponent("bg", UISprite)
  self:AddCellClickEvent()
end

function MixShopFilterSiteCell:SetData(data)
  self.data = data
  self.name.text = GameConfig.MixLottery.EquipFilter[data]
  self:UpdateChoose()
end

function MixShopFilterSiteCell:SetChoose(id)
  self.chooseId = id
  self:UpdateChoose()
end

function MixShopFilterSiteCell:UpdateChoose()
  local config = self.data and self.data == self.chooseId and _Config.Choose or _Config.UnChoose
  self.name.color = _ParseColor(config.color)
  self.bgSp.spriteName = config.sprite
end
