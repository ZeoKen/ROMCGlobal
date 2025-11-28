WildMvpAffixData = class("WildMvpAffixData")

function WildMvpAffixData:ctor(staticData)
  self:SetData(staticData)
end

function WildMvpAffixData:SetData(staticData)
  self.id = staticData.id
  self.staticData = staticData
end
