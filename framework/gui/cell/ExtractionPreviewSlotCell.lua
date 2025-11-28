autoImport("ExtractionSlotCell")
ExtractionPreviewSlotCell = class("ExtractionPreviewSlotCell", ExtractionSlotCell)

function ExtractionPreviewSlotCell:SetData(data)
  self.data = data
  if data then
    self.id = self.data.gridid
    self.extractionData = data
    self:UpdataData()
  end
end

function ExtractionPreviewSlotCell:UpdataData()
  if not self.data then
    return
  end
  ExtractionPreviewSlotCell.super.UpdataData(self)
  local showDeleted = false
  if self.data.itemid ~= 0 then
    local curExtractionData = AttrExtractionProxy.Instance:GetExtractionDataByGrid(self.id)
    if not curExtractionData or curExtractionData.itemid ~= self.data.itemid then
      showDeleted = true
    end
  end
  self.deletedIcon:SetActive(showDeleted)
end
