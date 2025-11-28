GOManager_CameraFocusObj = class("GOManager_CameraFocusObj")

function GOManager_CameraFocusObj:ctor()
  self.objects = {}
end

function GOManager_CameraFocusObj:Clear()
  TableUtility.TableClear(self.objects)
end

function GOManager_CameraFocusObj:RegisterGameObject(obj)
  if not obj then
    return
  end
  self.objects[obj.ID] = obj.transform
  return true
end

function GOManager_CameraFocusObj:UnregisterGameObject(obj)
  self.objects[obj.ID] = nil
  return true
end

function GOManager_CameraFocusObj:FindObjTransform(ID)
  return self.objects[ID]
end
