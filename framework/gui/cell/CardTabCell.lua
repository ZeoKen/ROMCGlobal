CardTabCell = class("CardTabCell", BaseCell)
local SpriteName = {
  [1700] = "Kingboli_icon_Card-reset",
  [1701] = "Kingboli_icon_custom-made",
  [1702] = "Kingboli_icon_Card-breakdown",
  [1703] = "Kingboli_icon_synthesis",
  [1704] = "Kingboli_icon_synthesis",
  [1705] = "Kingboli_icon_activity",
  [1706] = "Kingboli_icon_synthesis"
}

function CardTabCell:Init()
  self:FindObjs()
end

function CardTabCell:FindObjs()
  self.checkSp = self:FindComponent("Checkmark", UISprite)
  self.checkShadowSp = self:FindComponent("Shadow", UISprite)
  self.mvpLabel = self:FindGO("Mvp")
  self.toggle = self:FindComponent("Sprite", UIToggle)
  self.sps = self:FindComponent("Sprite", UISprite)
  local longPress = self.gameObject:GetComponent(UILongPress)
  
  function longPress.pressEvent(obj, state)
    self:OnTabLongPress(state)
  end
  
  self.upRateSp = self:FindGO("UpRateIcon")
end

function CardTabCell:SetData(data)
  self.id = data
  local spName = SpriteName[self.id]
  self.checkSp.spriteName = spName
  self.checkShadowSp.spriteName = spName
  self.sps.spriteName = spName
  self.mvpLabel:SetActive(self.id == 1704)
end

function CardTabCell:OnTabLongPress(state)
  local isPressing = state
  local config = Table_NpcFunction[self.id]
  local name = config and config.NameZh
  TabNameTip.OnLongPress(isPressing, name, false, self.sps)
end

function CardTabCell:CheckRateUp()
  local type
  if self.id == 1703 then
    type = CardMakeProxy.MakeType.BossCompose
  elseif self.id == 1704 then
    type = CardMakeProxy.MakeType.MvpCardCompose
  elseif self.id == 1705 then
    type = CardMakeProxy.MakeType.DungeonMvpCardCompose
  end
  local isUp = CardMakeProxy.Instance:IsHaveUpRateCards(type)
  self.upRateSp:SetActive(isUp)
end
