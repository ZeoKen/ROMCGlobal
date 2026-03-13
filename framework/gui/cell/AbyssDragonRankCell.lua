AbyssDragonRankCell = class("AbyssDragonRankCell", BaseCell)

function AbyssDragonRankCell:Init()
  self:FindObjs()
end

function AbyssDragonRankCell:FindObjs()
  self.nameLabel = self:FindComponent("Name", UILabel)
  self.effectContainer = self:FindGO("EffectContainer")
end

function AbyssDragonRankCell:SetData(data)
  if self.id ~= data.id then
    self:PlayUIEffect(EffectMap.UI[string.format("AbyssDragonRank_%d", data.rank)], self.effectContainer, true)
  end
  self.id = data.id
  self.nameLabel.text = data.name
end
