GOManager_AreaCP = class("GOManager_AreaCP")

function GOManager_AreaCP:ctor()
end

function GOManager_AreaCP:RegisterGameObject(obj)
  self.areaCP = obj
  return true
end

function GOManager_AreaCP:UnregisterGameObject(obj)
  self.areaCP = nil
  return true
end

function GOManager_AreaCP:GetAreaCP()
  return self.areaCP
end
