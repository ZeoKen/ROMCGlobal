autoImport("CardMakeMaterialCell")
CardDecomposeMaterialCell = class("CardDecomposeMaterialCell", CardMakeMaterialCell)

function CardDecomposeMaterialCell:SetData(data)
  if data then
    CardMakeMaterialCell.super.SetData(self, data.itemData)
    local num = data.itemData.num
    if 1 < num then
      self.numLab.text = data.isExtra and num or string.format(ZhString.CardDecompose_Material, num)
    end
  end
  self.cellData = data
end
