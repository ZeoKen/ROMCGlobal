autoImport("Trap")
SceneTrapProxy = class("SceneTrapProxy", SceneObjectProxy)
SceneTrapProxy.Instance = nil
SceneTrapProxy.NAME = "SceneTrapProxy"

function SceneTrapProxy:ctor(proxyName, data)
  self.proxyName = proxyName or SceneTrapProxy.NAME
  self:Reset()
  self.addMode = SceneObjectProxy.AddMode.Normal
  if SceneTrapProxy.Instance == nil then
    SceneTrapProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
end

function SceneTrapProxy:Reset()
  self.trapMap = {}
  self.trapAddCaches = {}
  self.trapRemoveCaches = {}
end

function SceneTrapProxy:Find(guid)
  return self.trapMap[guid]
end

function SceneTrapProxy:CullingStateChange(guid, visible, distanceLevel)
  local trap = self.trapMap[guid]
  if trap then
    trap:CullingStateChange(visible, distanceLevel)
  end
end

function SceneTrapProxy:Add(data)
  local id = data.id
  local trap = self.trapMap[id]
  if not trap then
    local cache = self.trapAddCaches[id]
    if cache == nil then
      cache = ReusableTable.CreateTable()
    end
    cache.id = id
    cache.skillID = data.skillID
    cache.masterid = data.masterid
    local pos = ReusableTable.CreateTable()
    pos.x = data.pos.x
    pos.y = data.pos.y
    pos.z = data.pos.z
    cache.pos = pos
    cache.dir = data.dir
    self.trapAddCaches[id] = cache
  else
    trap:Refresh(data)
  end
  if self.trapRemoveCaches[id] then
    self.trapRemoveCaches[id] = nil
  end
  return nil
end

function SceneTrapProxy:PureAddSome(datas)
  for i = 1, #datas do
    self:Add(datas[i])
  end
  return nil
end

function SceneTrapProxy:RefreshAdd(datas)
  return nil
end

function SceneTrapProxy:AddSome(datas)
  if self.addMode == SceneObjectProxy.AddMode.Normal then
    return self:PureAddSome(datas)
  elseif self.addMode == SceneObjectProxy.AddMode.Refresh then
    return self:RefreshAdd(datas)
  end
end

function SceneTrapProxy:Remove(guid)
  local cache = self.trapAddCaches[guid]
  if cache ~= nil then
    ReusableTable.DestroyAndClearTable(cache.pos)
    ReusableTable.DestroyAndClearTable(cache)
    self.trapAddCaches[guid] = nil
    return
  end
  cache = self.trapRemoveCaches[guid]
  if cache == nil then
    self.trapRemoveCaches[guid] = guid
    return
  end
end

function SceneTrapProxy:RemoveSome(guids)
  if guids ~= nil and 0 < #guids then
    for i = 1, #guids do
      self:Remove(guids[i])
    end
  end
end

function SceneTrapProxy:Clear()
  self:ChangeAddMode(SceneObjectProxy.AddMode.Normal)
  for id, trap in pairs(self.trapMap) do
    trap:Destroy()
  end
  for k, v in pairs(self.trapAddCaches) do
    local id = v.id
    ReusableTable.DestroyAndClearTable(v.pos)
    ReusableTable.DestroyAndClearTable(v)
    self.trapAddCaches[id] = nil
  end
  for k, v in pairs(self.trapRemoveCaches) do
    self.trapRemoveCaches[k] = nil
  end
  self:Reset()
end

function SceneTrapProxy:GetAll()
  return self.trapMap
end

function SceneTrapProxy:PrintEffectCount()
  redlog("SceneTrapProxy:PrintEffectCount ========== start ==========")
  for k, v in pairs(self.trapMap) do
    redlog("[SceneTrapProxy:PrintEffectCount =====1===== ]", k, v.skillID)
  end
  redlog("SceneTrapProxy:PrintEffectCount ========== end ==========")
end

function SceneTrapProxy:Update()
  for k, v in pairs(self.trapAddCaches) do
    local id = v.id
    local trap = Trap.CreateAsTable()
    trap:Init(id, v.skillID, v.masterid, v.pos, v.dir)
    self.trapMap[id] = trap
    ReusableTable.DestroyAndClearTable(v.pos)
    ReusableTable.DestroyAndClearTable(v)
    self.trapAddCaches[id] = nil
  end
  for k, v in pairs(self.trapRemoveCaches) do
    local trap = self.trapMap[k]
    if trap then
      trap:Destroy()
      self.trapMap[k] = nil
    end
    self.trapRemoveCaches[k] = nil
  end
end
