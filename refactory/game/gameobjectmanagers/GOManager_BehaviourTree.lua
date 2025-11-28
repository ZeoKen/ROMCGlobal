GOManager_BehaviourTree = class("GOManager_BehaviourTree")

function GOManager_BehaviourTree:ctor()
  self.managers = {}
end

function GOManager_BehaviourTree:Clear()
  for _, v in pairs(self.managers) do
    if v then
      v:Dispose()
    end
  end
  TableUtility.TableClear(self.managers)
end

function GOManager_BehaviourTree:RegisterGameObject(obj)
  self:AddBTSystemManager(obj.ID, obj)
  return true
end

function GOManager_BehaviourTree:UnregisterGameObject(obj)
  self:RemoveBTSystemManager(obj.ID)
  return true
end

function GOManager_BehaviourTree:AddBTSystemManager(id, obj)
  if not id then
    return
  end
  if self.managers[id] then
    redlog("[bt] duplicated behaviour tree", id)
    return
  end
  local properties = obj.properties
  if not properties then
    return
  end
  local configPath = properties[1]
  if configPath == nil then
    redlog("[bt] config not specified", configPath)
    return
  end
  local config = autoImport(configPath)
  if config == nil then
    redlog("[bt] config not found", configPath)
    return
  end
  self.managers[id] = BTSystemManager.new(obj.gameObject, config)
end

function GOManager_BehaviourTree:RemoveBTSystemManager(id)
  if not id then
    return
  end
  local root = self.managers[id]
  if root then
    root:Dispose()
    self.managers[id] = nil
  end
end

function GOManager_BehaviourTree:Update(time, deltaTime)
  for _, v in pairs(self.managers) do
    if v then
      v:Update(time, deltaTime)
    end
  end
end
