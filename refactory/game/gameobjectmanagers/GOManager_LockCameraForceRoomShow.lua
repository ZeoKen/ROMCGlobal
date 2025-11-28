GOManager_LockCameraForceRoomShow = class("GOManager_LockCameraForceRoomShow")

function GOManager_LockCameraForceRoomShow:ctor()
  self.objects = {}
end

function GOManager_LockCameraForceRoomShow:Clear()
  TableUtility.TableClear(self.objects)
end

function GOManager_LockCameraForceRoomShow:RegisterGameObject(obj)
  local go = obj.gameObject
  self.objects[go] = go.activeSelf
  return true
end

function GOManager_LockCameraForceRoomShow:UnregisterGameObject(obj)
  self.objects[obj.gameObject] = nil
  return true
end

function GOManager_LockCameraForceRoomShow:ShowAll()
  for k, v in pairs(self.objects) do
    k:SetActive(true)
  end
end

function GOManager_LockCameraForceRoomShow:DefaultActiveSelf()
  for obj, v in pairs(self.objects) do
    obj:SetActive(v)
  end
end

function GOManager_LockCameraForceRoomShow:HideAll()
  for k, v in pairs(self.objects) do
    k:SetActive(false)
  end
end
