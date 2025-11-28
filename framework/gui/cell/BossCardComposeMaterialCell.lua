autoImport("CardMakeMaterialCell")
BossCardComposeMaterialCell = class("BossCardComposeMaterialCell", CardMakeMaterialCell)

function BossCardComposeMaterialCell:SetData(data)
  BossCardComposeMaterialCell.super.SetData(self, data)
  local num = data.itemData.num
  local bagNum = 0
  if data.id == GameConfig.MoneyId.Zeny then
    bagNum = MyselfProxy.Instance:GetROB()
  else
    bagNum = CardMakeProxy.Instance:GetItemNumByStaticIDExceptFavoriteCard(data.id)
  end
  self:SetIconGrey(num > bagNum)
end
