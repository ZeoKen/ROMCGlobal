GOManager_ObjectFinder = class("GOManager_ObjectFinder")

function GOManager_ObjectFinder:ctor()
  self.objects = {}
end

function GOManager_ObjectFinder:Clear()
  TableUtility.TableClear(self.objects)
end

function GOManager_ObjectFinder:RegisterGameObject(obj)
  local id = obj.ID
  if id then
    self.objects[id] = obj
  end
  return true
end

function GOManager_ObjectFinder:UnregisterGameObject(obj)
  local id = obj.ID
  if id then
    self.objects[id] = nil
  end
  return true
end

function GOManager_ObjectFinder:FindObject(id)
  return self.objects[id]
end
