local IconMap = {
  [2] = "mall_twistedegg_card_02"
}
local _CurBatchIcon = {
  "mall_icon_exclamationpoint",
  "recharge_icon_up"
}
autoImport("LotteryCell")
CardLotteryCell = class("CardLotteryCell", LotteryCell)

function CardLotteryCell:FindObjs()
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

function CardLotteryCell:UpdateCurBranch()
  if not self.curBatch then
    return
  end
  if self.data and self.data.isCurBatch == 1 then
    self.curBatch.gameObject:SetActive(true)
    self.curBatch.spriteName = BranchMgr.IsJapan() and _CurBatchIcon[1] or _CurBatchIcon[2]
    self.curBatch:MakePixelPerfect()
  else
    self.curBatch.gameObject:SetActive(false)
  end
end
