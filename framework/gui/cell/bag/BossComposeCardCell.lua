autoImport("BagCardCell")
BossComposeCardCell = class("BossComposeCardCell", BagCardCell)

function BossComposeCardCell:Init()
  BossComposeCardCell.super.Init(self)
  self.probabilityGo = self:FindGO("probabilityBg")
  self.probabilityLabel = self:FindComponent("probability", UILabel)
end

function BossComposeCardCell:SetData(data)
  BossComposeCardCell.super.SetData(self, data)
  self:SetProbability()
end

function BossComposeCardCell:SetProbability()
  if not self.data then
    self.probabilityGo:SetActive(false)
  else
    self.probabilityGo:SetActive(true)
    local rate = self.data.RateShow or 0
    self.probabilityLabel.text = string.format(ZhString.Lottery_DetailRate, rate)
  end
end

function BossComposeCardCell:SetCardAlpha()
  self.widget.alpha = 1
end
