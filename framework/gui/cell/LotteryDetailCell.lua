LotteryDetailCell = class("LotteryDetailCell", LotteryCell)

function LotteryDetailCell:FindObjs()
  LotteryDetailCell.super.FindObjs(self)
  self.rate = self:FindGO("Rate")
  if self.rate then
    self.rate = self.rate:GetComponent(UILabel)
  end
  self.dressLab = self:FindComponent("DressLab", UILabel)
end

function LotteryDetailCell:SetData(data)
  self.gameObject:SetActive(data ~= nil)
  if data then
    LotteryDetailCell.super.SetData(self, data)
    self:UpdateMyselfInfo(data:GetItemData())
    if self.rate then
      self.rate.text = string.format(ZhString.Lottery_DetailRate, data:GetRate())
    end
  end
  self.data = data
  self:UpdateDressLab()
end
