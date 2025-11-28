GOManager_InteractCard = class("GOManager_InteractCard")

function GOManager_InteractCard:ctor()
  self.objects = {}
end

function GOManager_InteractCard:GetInteractObject(id)
  return self.objects[id]
end

function GOManager_InteractCard:RegisterGameObject(obj)
  local objID = obj.ID
  self.objects[objID] = obj
  return true
end

function GOManager_InteractCard:UnregisterGameObject(obj)
  local objID = obj.ID
  local testObj = self.objects[objID]
  if testObj ~= nil and testObj == obj then
    self.objects[objID] = nil
    return true
  end
  return false
end

function GOManager_InteractCard:OnClick(obj)
  redlog("OnClick", obj.ID)
  MountLotteryProxy.Instance:OnClickCard(obj.ID)
end
