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
MixShopFilterYearCell = class("MixShopFilterYearCell", BaseCell)

function MixShopFilterYearCell:Init()
  self.bgSp = self.gameObject:GetComponent(UISprite)
  self.bgColider = self.bgSp.gameObject:GetComponent(BoxCollider)
  self.nameLab = self:FindComponent("Year", UILabel)
  self:AddCellClickEvent()
end

function MixShopFilterYearCell:SetData(data)
  self.data = data
  self:SetName()
  self:UpdateChoose()
end

function MixShopFilterYearCell:SetName()
  if self.data == LotteryProxy.Invalid_Year then
    self.nameLab.text = ZhString.Lottery_MixShop_InvalidYear
  else
    self.cntData = LotteryProxy.Instance:GetShopGoodsProcessByYear(self.data)
    local process = self.cntData and string.format(ZhString.Lottery_GetCount, self.cntData.got, self.cntData.total) or ""
    self.nameLab.text = tostring(self.data) .. process
  end
end

function MixShopFilterYearCell:UpdateColider(ignore, site)
  if ignore then
    self.bgSp.alpha = 1
    self.bgColider.enabled = true
    return
  end
  local hasData = LotteryProxy.Instance:HasNewMixLotteryShopData(site, true, self.data)
  self.bgSp.alpha = hasData and 1 or 0.5
  self.bgColider.enabled = hasData
  self:UpdateChoose()
end

function MixShopFilterYearCell:SetChoose(id)
  self.chooseYear = id
  self:UpdateChoose()
end

function MixShopFilterYearCell:UpdateChoose()
  local config = self.data and self.data == self.chooseYear and self.bgColider.enabled and _Config.Choose or _Config.UnChoose
  self.nameLab.color = _ParseColor(config.color)
  self.bgSp.spriteName = config.sprite
end
