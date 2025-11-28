local BaseCell = autoImport("BaseCell")
ZoneGroupCell = class("ZoneGroupCell", BaseCell)

function ZoneGroupCell:Init()
  self.groupIDLab = self:FindGO("GroupIDLab"):GetComponent(UILabel)
  self.zoneLab = self:FindGO("ZoneLab"):GetComponent(UILabel)
end

function ZoneGroupCell:SetData(data)
  self.data = data
  self.groupIDLab.text = data:GetGroupIdStr()
  self.zoneLab.text = data:GetZoneStr()
end
