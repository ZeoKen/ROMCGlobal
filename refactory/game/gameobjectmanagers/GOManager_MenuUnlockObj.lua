GOManager_MenuUnlockObj = class("GOManager_MenuUnlockObj")

function GOManager_MenuUnlockObj:ctor()
  self.objects = {}
end

function GOManager_MenuUnlockObj:Clear()
  TableUtility.TableClear(self.objects)
end

function GOManager_MenuUnlockObj:GetObject(ID)
  return self.objects[ID]
end

function GOManager_MenuUnlockObj:RegisterGameObject(obj)
  local id = obj.ID
  if self.objects[id] ~= nil then
    redlog(string.format("MenuUnlockObj:%s Register Twice", id))
  end
  self.objects[id] = obj
  local menuId = obj:GetProperty(0)
  local active = FunctionUnLockFunc.Me():CheckCanOpen(tonumber(menuId))
  obj.gameObject:SetActive(active)
  return true
end

function GOManager_MenuUnlockObj:UnregisterGameObject(obj)
  local id = obj.ID
  if self.objects[id] ~= nil then
    self.objects[id] = nil
  end
  return true
end

function GOManager_MenuUnlockObj:UpdateGameobjectByMenuId(menuId, active)
  for id, obj in pairs(self.objects) do
    local mId = obj:GetProperty(0)
    mId = tonumber(mId)
    if mId and mId == menuId then
      obj.gameObject:SetActive(active)
    end
  end
end
