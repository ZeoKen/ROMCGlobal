BTBlackBoard = class("BTBlackBoard")
BTDefine.RegisterReservedBBKey("target")
BTDefine.RegisterReservedBBKey("dirtyKeys")

function BTBlackBoard:ctor()
  self.dirtyKeys = {}
  self.target = nil
  self.globalDatas = {}
end

function BTBlackBoard:Dispose()
  local TableClear = TableUtility.TableClear
  TableClear(self.dirtyKeys)
  TableClear(self.globalDatas)
  self.target = nil
end

function BTBlackBoard:Exec(time, deltaTime)
  for k, _ in pairs(self.dirtyKeys) do
    self.dirtyKeys[k] = nil
  end
end

function BTBlackBoard:SetKeyDirty(key, dirty)
  if key then
    self.dirtyKeys[key] = dirty
  end
end

function BTBlackBoard:IsKeyDirty(key)
  if key then
    return self.dirtyKeys[key]
  end
  return false
end

function BTBlackBoard:GetTarget()
  return self.target
end

function BTBlackBoard:SetTarget(obj)
  self.target = obj
end

function BTBlackBoard:SetGlobalData(key, val)
  if key then
    self.globalDatas[key] = val
  end
end

function BTBlackBoard:UnsetGlobalData(key)
  if key then
    self.globalDatas[key] = nil
  end
end

function BTBlackBoard:GetGlobalData(key)
  if key then
    return self.globalDatas[key]
  end
  return nil
end
