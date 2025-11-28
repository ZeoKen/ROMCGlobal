autoImport("BagItemCell")
PersonalArtifactExchangeItemCell = class("PersonalArtifactExchangeItemCell", BagItemCell)

function PersonalArtifactExchangeItemCell:SetData(data)
  PersonalArtifactExchangeItemCell.super.SetData(self, data)
  if data and data.num == 0 then
    self:ShowMask()
  else
    self:HideMask()
  end
  if data and data.num == 1 then
    self:UpdateNumLabel("")
    self.numLab.text = 1
  end
end
