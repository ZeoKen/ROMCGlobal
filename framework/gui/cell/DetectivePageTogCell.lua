local baseCell = autoImport("BaseCell")
DetectivePageTogCell = class("DetectivePageTogCell", baseCell)

function DetectivePageTogCell:Init()
  self:FindObjs()
end

function DetectivePageTogCell:FindObjs()
  self.label = self:FindGO("Label"):GetComponent(UILabel)
  self.chooseLabel = self:FindGO("ChooseLabel"):GetComponent(UILabel)
end

function DetectivePageTogCell:SetData(data)
  self.label.text = data or "???"
  self.chooseLabel.text = data or "???"
end
