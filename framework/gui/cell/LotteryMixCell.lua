autoImport("LotteryCell")
LotteryMixCell = class("LotteryMixCell", LotteryCell)

function LotteryMixCell:FindObjs()
  LotteryMixCell.super.FindObjs(self)
  self.rateLab = self:FindComponent("RateLab", UILabel)
  self.dressLab = self:FindComponent("DressLab", UILabel)
end

function LotteryMixCell:SetData(data)
  self.gameObject:SetActive(nil ~= data)
  if data then
    LotteryMixCell.super.SetData(self, data)
    local unget = AdventureDataProxy.Instance:IsFashionNeverDisplay(data.itemid, true)
    if self.rateLab then
      if FunctionLottery.Me():MixLotteryRateShow() and unget then
        self:Show(self.rateLab)
        self.rateLab.text = data:GetRate() .. "%"
      else
        self:Hide(self.rateLab)
      end
    end
    self:UpdateMyselfInfo(data:GetItemData())
  end
  self.data = data
  self:UpdateDressLab()
end

function LotteryMixCell:UpdateGotFlag()
  if not self.gotFlag then
    return
  end
  self.gotFlag:SetActive(self.data and self.data.CheckGoodsGroupGot and self.data:CheckGoodsGroupGot() or false)
end
