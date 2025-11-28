MapTransmitterCell = class("MapTransmitterCell", BaseCell)

function MapTransmitterCell:Init()
  self.texScene = self:FindComponent("texScene", UITexture)
  self.labMapName = self:FindComponent("labMapName", UILabel)
  self.objCurrent = self:FindGO("Current")
  self:AddCellClickEvent()
end

function MapTransmitterCell:SetData(data)
  self.data = data
  self.id = data.id
  self.isCurrent = data.isCurrent
  self.labMapName.text = data.name
  PictureManager.Instance:SetTransmitterScene(string.format("Transmitter_bg_%s", self.id), self.texScene)
  self.objCurrent:SetActive(self.isCurrent and true or false)
end
