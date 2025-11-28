GOManager_RaidPuzzleLight = class("GOManager_RaidPuzzleLight")

function GOManager_RaidPuzzleLight:ctor()
  self.objects = {}
end

function GOManager_RaidPuzzleLight:Clear()
  TableUtility.TableClear(self.objects)
end

function GOManager_RaidPuzzleLight:RegisterGameObject(obj)
  if not obj then
    return
  end
  local comLine = obj:GetComponent(LineReflection)
  if not comLine then
    LogUtility.Error("Register Raid Puzzle Light But Cannot Find LineReflection Component, ID = " .. tostring(obj.ID))
    return
  end
  self.objects[obj.ID] = comLine
  return true
end

function GOManager_RaidPuzzleLight:UnregisterGameObject(obj)
  self.objects[obj.ID] = nil
  return true
end

function GOManager_RaidPuzzleLight:RefreshLight(id, onFinish)
  local comLine = self.objects[id]
  if not comLine or not comLine.gameObject.activeInHierarchy then
    if onFinish then
      onFinish(comLine.gameObject)
    end
    return
  end
  comLine:Refresh(onFinish)
end

function GOManager_RaidPuzzleLight:GetLastLinePosition(id)
  local comLine = self.objects[id]
  if not comLine or not comLine.gameObject.activeInHierarchy then
    return
  end
  return comLine:GetLastLinePosition()
end

function GOManager_RaidPuzzleLight:GetLastHitGameObject(id)
  local comLine = self.objects[id]
  if not comLine or not comLine.gameObject.activeInHierarchy then
    return
  end
  return comLine:GetLastHitGameObject()
end

function GOManager_RaidPuzzleLight:GetLightObjMap()
  return self.objects
end
