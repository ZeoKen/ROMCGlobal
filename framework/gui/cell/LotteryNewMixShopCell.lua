LotteryNewMixShopCell = class("LotteryNewMixShopCell", LotteryCell)

function LotteryNewMixShopCell:Init()
  self:LoadPreferb("cell/LotteryNewMixShopCell", self.gameObject)
  LotteryNewMixShopCell.super.Init(self)
end

function LotteryNewMixShopCell:FindObjs()
  LotteryNewMixShopCell.super.FindObjs(self)
  self.moneyIcon = self:FindComponent("MoneyIcon", UISprite)
  self.money = self:FindComponent("Money", UILabel)
end

function LotteryNewMixShopCell:SetData(data)
  self.gameObject:SetActive(nil ~= data)
  if data then
    LotteryNewMixShopCell.super.SetData(self, data)
    self:UpdateMyselfInfo(data:GetItemData())
    local costIcon = Table_Item[data.ItemID].Icon
    IconManager:SetItemIcon(costIcon, self.moneyIcon)
    self.money.text = data.ItemCount
  end
  self.data = data
end
