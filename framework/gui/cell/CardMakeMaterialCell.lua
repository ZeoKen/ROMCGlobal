CardMakeMaterialCell = class("CardMakeMaterialCell", ItemCell)
local TextColorRed = "[c][FF3B35]"

function CardMakeMaterialCell:Init()
  local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  CardMakeMaterialCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function CardMakeMaterialCell:FindObjs()
  self.choose = self:FindGO("Choose")
end

function CardMakeMaterialCell:AddEvts()
  self:AddCellClickEvent()
end

function CardMakeMaterialCell:SetData(data)
  if data then
    CardMakeMaterialCell.super.SetData(self, data.itemData)
    local num = data.itemData.num
    if 1 < num then
      local bagNum = 0
      if data.id == GameConfig.MoneyId.Zeny then
        bagNum = MyselfProxy.Instance:GetROB()
      else
        bagNum = CardMakeProxy.Instance:GetItemNumByStaticIDExceptFavoriteCard(data.id)
      end
      local colorStr = num <= bagNum and "" or TextColorRed
      local str = data.id == GameConfig.MoneyId.Zeny and colorStr .. num .. "[-][/c]" or colorStr .. bagNum .. "[-][/c]/" .. num
      self.numLab.text = str
    end
    self:SetIconGrey(not CardMakeProxy.Instance:CheckMaterialSlotCanMake(data.slotId))
  end
  self.cellData = data
end
