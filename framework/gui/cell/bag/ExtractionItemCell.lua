autoImport("BagItemCell")
ExtractionItemCell = class("ExtractionItemCell", BagItemCell)

function ExtractionItemCell:Init()
  ExtractionItemCell.super.Init(self)
  self.activatedGO = self:FindGO("Activated")
end

function ExtractionItemCell:SetData(data)
  ExtractionItemCell.super.SetData(self, data)
  if data and data.IsExtractionActive and data:IsExtractionActive() then
    self.activatedGO:SetActive(true)
  else
    self.activatedGO:SetActive(false)
  end
end
