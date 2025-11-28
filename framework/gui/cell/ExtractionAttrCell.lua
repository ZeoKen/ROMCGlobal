local BaseCell = autoImport("BaseCell")
ExtractionAttrCell = class("BossCell", BaseCell)

function ExtractionAttrCell:Init()
  self:FindObjs()
end

function ExtractionAttrCell:FindObjs()
  self.info = self:FindGO("Label"):GetComponent(UILabel)
end

function ExtractionAttrCell:SetData(data)
  self.data = data
  if data then
    self.info.text = data
  end
end
