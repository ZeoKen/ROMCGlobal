local IconMap = {
  [2] = "mall_twistedegg_card_02"
}
autoImport("LotteryCell")
CardLotteryCell = class("CardLotteryCell", LotteryCell)

function CardLotteryCell:FindObjs()
  self.batchConfigField = GameConfig.Lottery and GameConfig.Lottery.BatchIcon and GameConfig.Lottery.BatchIcon.cardUpBatchIcon or "up"
  CardLotteryCell.super.FindObjs(self)
  self.rate = self:FindGO("rate"):GetComponent(UILabel)
  self.extraRate = self:FindGO("extraRate"):GetComponent(UILabel)
  self.up = self:FindGO("up")
  self.quality = self:FindGO("Quality"):GetComponent(UISprite)
  self.dressFlag = self:FindGO("DressFlag")
end

function CardLotteryCell:SetData(data)
  CardLotteryCell.super.SetData(self, data)
  if not self.data then
    return
  end
  local baseRate, safatyRate = data:GetDisplayRate()
  self.rate.text = string.format(ZhString.Lottery_DetailRate, baseRate)
  if 0 < safatyRate then
    self.extraRate.text = string.format(ZhString.CardLottery_ExtraRate, safatyRate)
  else
    self.extraRate.text = ""
  end
  self.up:SetActive(0 < safatyRate)
  self.quality.spriteName = IconMap[data.itemType] or ""
  self.data = data
end
