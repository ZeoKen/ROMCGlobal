LotteryMixItemCell = class("LotteryMixItemCell", LotteryCell)

function LotteryMixItemCell:Init()
  self:LoadPreferb("cell/LotteryMixItemCell", self.gameObject)
  LotteryMixItemCell.super.Init(self)
end

function LotteryMixItemCell:FindObjs()
  self.gotFlag = self:FindGO("Get")
  self.rateLab = self:FindComponent("RateLab", UILabel)
end

function LotteryMixItemCell:SetData(data)
  self.gameObject:SetActive(nil ~= data)
  if data then
    LotteryMixItemCell.super.SetData(self, data)
    local unget = AdventureDataProxy.Instance:IsFashionNeverDisplay(data.itemid, true)
    self.gotFlag:SetActive(not unget)
    if BranchMgr.IsJapan() and unget then
      self.rateLab.gameObject:SetActive(true)
      self.rateLab.text = data:GetRate() .. "%"
    else
      self.rateLab.gameObject:SetActive(false)
    end
    self:UpdateMyselfInfo(data:GetItemData())
  end
  self.data = data
end
