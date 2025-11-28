MiniMapSymbol_FairyTale = class("MiniMapSymbol_FairyTale", CoreView)

function MiniMapSymbol_FairyTale:ctor(go)
  MiniMapSymbol_FairyTale.super.ctor(self, go)
  self:FindObjs()
end

function MiniMapSymbol_FairyTale:FindObjs()
  self.icon = self.gameObject:GetComponent(UISprite)
  self.hpBar = self:FindComponent("HpBar", UIProgressBar)
end

function MiniMapSymbol_FairyTale:SetData(data)
  if data then
    local riderId = data:GetParama("RiderId")
    self.hpBar.gameObject:SetActive(riderId ~= nil)
    IconManager:SetNpcMonsterIconByID(riderId, self.icon)
    local hp = data:GetParama("hp")
    local maxHp = data:GetParama("maxHp")
    self:SetHp(hp, maxHp)
  end
end

function MiniMapSymbol_FairyTale:SetHp(hp, maxHp)
  self.hpBar.value = hp / maxHp
end
