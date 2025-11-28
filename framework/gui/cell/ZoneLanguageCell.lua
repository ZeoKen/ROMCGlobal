local BaseCell = autoImport("BaseCell")
ZoneLanguageCell = class("ZoneLanguageCell", BaseCell)

function ZoneLanguageCell:Init()
  self.ENLabel = self:FindComponent("EN_ZoneName", UILabel)
  self.LocalLabel = self:FindComponent("Local_ZoneName", UILabel)
  self:AddCellClickEvent()
  self.choose = false
end

function ZoneLanguageCell:SetData(data)
  self.data = data
  self.ENLabel.text = data.name_prefix
  self.LocalLabel.text = data.fullname
end

function ZoneLanguageCell:SetID(id)
  self.id = id
end
