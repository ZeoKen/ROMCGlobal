autoImport("CardMakeMaterialCell")
MvpCardComposeMaterialCell = class("MvpCardComposeMaterialCell", CardMakeMaterialCell)
local TextColorRed = "[c][FF3B35]"

function MvpCardComposeMaterialCell:SetData(data)
  CardMakeMaterialCell.super.SetData(self, data.itemData)
  local num = data.itemData.num
  local bagNum = data.ownNum or 0
  if 1 < num then
    local colorStr = num <= bagNum and "" or TextColorRed
    local str = data.id == GameConfig.MoneyId.Zeny and colorStr .. num .. "[-][/c]" or colorStr .. bagNum .. "[-][/c]/" .. num
    self.numLab.text = str
  end
  self:SetIconGrey(num > bagNum)
end
