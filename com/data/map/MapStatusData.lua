MapStatusData = class("MapStatusData")

function MapStatusData:ctor(data)
  self.id = data.mapid
  self.name = data.name
  self.status = data.status
end
