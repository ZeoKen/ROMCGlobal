GOManager_RoomShow = class("GOManager_RoomShow")

function GOManager_RoomShow:ctor()
  self.showObjects = {}
end

function GOManager_RoomShow:Clear()
  TableUtility.TableClear(self.showObjects)
end

function GOManager_RoomShow:RegisterGameObject(obj)
  local go = obj.gameObject
  self.showObjects[go] = 1
  go:SetActive(false)
  return true
end

function GOManager_RoomShow:UnregisterGameObject(obj)
  self.showObjects[obj.gameObject] = nil
  return true
end

function GOManager_RoomShow:ShowAll()
  for k, v in pairs(self.showObjects) do
    k:SetActive(true)
  end
end

function GOManager_RoomShow:HideAll()
  for k, v in pairs(self.showObjects) do
    k:SetActive(false)
  end
end
