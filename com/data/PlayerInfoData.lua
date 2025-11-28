PlayerInfoData = class("PlayerInfoData")

function PlayerInfoData:ctor()
  self.charid = 0
  self.profession = 0
  self.name = ""
end

function PlayerInfoData:SetData(pdata)
  self.charid = pdata.charid
  self.profession = pdata.profession
  self.name = pdata.name
end

function PlayerInfoData:UpdateBuffLayer(bufflayer)
  self.layer = bufflayer
end

function PlayerInfoData:UpdateInnerOuterStatus(status)
  self.status = status
end

function PlayerInfoData:UpdateData(profession, name)
  self.profession = profession
  self.name = name
end
