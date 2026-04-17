AsyncPvpRaidWaveResultCell = class("AsyncPvpRaidWaveResultCell", BaseCell)

function AsyncPvpRaidWaveResultCell:Init()
  self:FindObjs()
end

function AsyncPvpRaidWaveResultCell:FindObjs()
  self.nameLabel = self:FindComponent("Name", UILabel)
  self.valueLabel = self:FindComponent("Value", UILabel)
  self.scoreLabel = self:FindComponent("Score", UILabel)
end

function AsyncPvpRaidWaveResultCell:SetData(data)
  if data then
    self.nameLabel.text = data.name
    self.valueLabel.text = data.value
    self.scoreLabel.text = data.score
  end
end
