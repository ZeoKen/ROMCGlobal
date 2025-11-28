GOManager_InteractNpc = class("GOManager_InteractNpc")

function GOManager_InteractNpc:ctor()
  self.objects = {}
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.OnSceneLoaded, self)
end

function GOManager_InteractNpc:GetInteractObject(id)
  return self.objects[id]
end

function GOManager_InteractNpc:RegisterGameObject(obj)
  local objID = obj.ID
  self.objects[objID] = obj
  Game.InteractNpcManager:AddInteractObject(objID)
  return true
end

function GOManager_InteractNpc:UnregisterGameObject(obj)
  local objID = obj.ID
  local testObj = self.objects[objID]
  if testObj ~= nil and testObj == obj then
    self.objects[objID] = nil
    Game.InteractNpcManager:RemoveInteractObject(objID)
    return true
  end
  return false
end

function GOManager_InteractNpc:ShowInteractObject(id, show)
  local obj = self.objects[id]
  if obj ~= nil then
    self:SetActive(obj, show)
  end
end

function GOManager_InteractNpc:ShowAll(show)
  local obj
  for k, v in pairs(self.objects) do
    self:SetActive(v, show)
  end
end

function GOManager_InteractNpc:SetActive(obj, show)
  local go = obj.gameObject
  if go.activeInHierarchy ~= show then
    go:SetActive(show)
    if show then
      self:RegisterGameObject(obj)
    else
      self:UnregisterGameObject(obj)
    end
  end
end

function GOManager_InteractNpc:OnSceneLoaded()
  local raidID = SceneProxy.Instance:GetCurRaidID()
  if raidID == nil or raidID == 0 then
    raidID = ServicePlayerProxy.Instance:GetCurMapImageId() or 0
  end
  local mapRaid = Table_MapRaid[raidID]
  if mapRaid ~= nil then
    local feature = mapRaid.Feature
    if feature ~= nil and 0 < feature & 1 then
      self:ShowAll(false)
      return
    end
  end
  self:ShowAll(true)
  for k, v in pairs(self.objects) do
    if Table_InteractNpc[k] and Table_InteractNpc[k].Type == 4 then
      v.gameObject:SetActive(false)
    end
  end
end

function GOManager_InteractNpc:FindLuaGO(id)
  return self.objects and self.objects[id]
end

function GOManager_InteractNpc:ForEachLuaGO(func)
  if not func then
    return
  end
  for k, v in pairs(self.objects) do
    func(v)
  end
end
