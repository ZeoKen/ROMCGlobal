autoImport("LotteryCell")
DressLotteryCell = class("DressLotteryCell", LotteryCell)

function DressLotteryCell:FindObjs()
  DressLotteryCell.super.FindObjs(self)
  self.dressFlag = self:FindComponent("DressFlag", UILabel)
  self.dressFlag.text = ZhString.Lottery_Dressing
end

function DressLotteryCell:UpdateDressFlag()
end

function DressLotteryCell:SetData(data)
  DressLotteryCell.super.SetData(self, data)
  if not self.data then
    return
  end
  self:UpdateDressFlag()
end
