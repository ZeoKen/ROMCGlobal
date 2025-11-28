autoImport("EquipNewCountChooseCell")
EquipExtractionCountChooseCell = class("EquipExtractionCountChooseCell", EquipNewCountChooseCell)

function EquipExtractionCountChooseCell:Init()
  EquipExtractionCountChooseCell.super.Init(self)
  if self.itemCell then
    self.itemCell:SetDefaultBgSprite(nil, nil)
  end
end
