AstralPrayBuffEffectCell = class("AstralPrayBuffEffectCell", BaseCell)

function AstralPrayBuffEffectCell:Init()
  self:FindObjs()
end

function AstralPrayBuffEffectCell:FindObjs()
  self.descLabel = self:FindComponent("Desc", UILabel)
end

function AstralPrayBuffEffectCell:SetData(data)
  self.data = data
  local config = Table_Buffer[data]
  self.descLabel.text = config and config.BuffDesc or ""
end
