GOManager_Base = class("GOManager_Base")

function GOManager_Base:ctor()
  self.objMap = {}
end

function GOManager_Base:Clear()
  TableUtility.TableClear(self.objMap)
end

function GOManager_Base:RegisterGameObject(obj)
  if obj then
    self.objMap[obj.ID] = obj
    return true
  end
end

function GOManager_Base:UnregisterGameObject(obj)
  if obj then
    self.objMap[obj.ID] = nil
    return true
  end
end

function GOManager_Base:GetObject(objID)
  return self.objMap[objID]
end
