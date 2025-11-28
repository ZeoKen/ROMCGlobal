local BaseCell = autoImport("BaseCell")
ExtractionAttrNewCell = class("ExtractionAttrNewCell", BaseCell)

function ExtractionAttrNewCell:Init()
  self:FindObjs()
end

function ExtractionAttrNewCell:FindObjs()
  self.info = self:FindGO("Label"):GetComponent(UILabel)
end

function ExtractionAttrNewCell:SetData(data)
  self.data = data
  if data then
    self.info.text = data
  end
end
