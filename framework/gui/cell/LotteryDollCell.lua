autoImport("LotteryBaseCell")
LotteryDollCell = class("LotteryDollCell", LotteryBaseCell)

function LotteryDollCell:SetData(data)
  LotteryDollCell.super.SetData(self, data)
  self.rateGO:SetActive(false)
end
