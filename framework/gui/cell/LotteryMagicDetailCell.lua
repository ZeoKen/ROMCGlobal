autoImport("LotteryCell")
LotteryMagicDetailCell = class("LotteryMagicDetailCell", LotteryCell)

function LotteryMagicDetailCell:FindObjs()
  LotteryMagicDetailCell.super.FindObjs(self)
  self.rate = self:FindGO("Rate")
  if self.rate then
    self.rate = self.rate:GetComponent(UILabel)
  end
  self.fashionUnlock = self:FindGO("FashionUnlock")
  if self.fashionUnlock then
    self.fashionUnlock = self.fashionUnlock:GetComponent(UIMultiSprite)
  end
  if self.fashionUnlock then
    self:Hide(self.fashionUnlock)
  end
  self.magicLotteryRate = self:FindGO("ItemRate")
  if self.magicLotteryRate then
    self.magicLotteryRate = self.magicLotteryRate:GetComponent(UILabel)
  end
  self.dressLab = self:FindComponent("DressLab", UILabel)
end

function LotteryMagicDetailCell:SetData(data)
  self.gameObject:SetActive(data ~= nil)
  if data then
    LotteryMagicDetailCell.super.SetData(self, data)
  end
  self.data = data
  self:SetRate(self.rate)
  self:SetRate(self.magicLotteryRate)
  self:UpdateDressLab()
end

function LotteryMagicDetailCell:GetRateShowConfig()
  return GameConfig.Lottery.MagicLotteryRateShow
end

function LotteryMagicDetailCell:SetRate(lab)
  if not lab then
    return
  end
  if not self.data then
    lab.text = ""
  else
    lab.text = self:GetRateShowConfig() == 1 and self.data:GetUIRate() or ""
  end
end
