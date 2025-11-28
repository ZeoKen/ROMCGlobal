ComodoBuildingSendAreaFeatureCell = class("ComodoBuildingSendAreaFeatureCell", CoreView)

function ComodoBuildingSendAreaFeatureCell:ctor(obj)
  ComodoBuildingSendAreaFeatureCell.super.ctor(self, obj)
  self.icon = self.gameObject:GetComponent(UISprite)
end

function ComodoBuildingSendAreaFeatureCell:SetData(index)
  local spName = GameConfig.Manor.DispatchFeatureIcon[index]
  self.gameObject:SetActive(spName ~= nil)
  if spName then
    IconManager:SetUIIcon(spName, self.icon)
    self.icon.height = 40
    self.icon.width = 40
  end
end
