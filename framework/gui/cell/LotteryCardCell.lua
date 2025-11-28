local IconMap = {
  [2] = "mall_twistedegg_card_02"
}
autoImport("LotteryCell")
LotteryCardCell = class("LotteryCardCell", LotteryCell)

function LotteryCardCell:FindObjs()
  LotteryCardCell.super.FindObjs(self)
  self.rate = self:FindGO("Rate"):GetComponent(UILabel)
  self.quality = self:FindGO("Quality"):GetComponent(UISprite)
end

function LotteryCardCell:SetData(data)
  LotteryCardCell.super.SetData(self, data)
  if not self.data then
    return
  end
  if self.rate then
    self.rate.text = string.format(ZhString.Lottery_DetailRate, data:GetRate())
  end
  if self.quality then
    self.quality.spriteName = IconMap[data.itemType] or ""
  end
  self.data = data
end
