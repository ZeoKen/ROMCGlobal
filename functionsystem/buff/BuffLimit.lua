BuffLimit = reusableClass("BuffLimit")
BuffLimit.PoolSize = 5

function BuffLimit:SetData(buffID, fromID, ignoreTarget)
  local data = self.datas[buffID]
  if data == nil then
    data = {}
    data.fromID = fromID
    if ignoreTarget ~= nil then
      data.ignoreTarget = ignoreTarget
    end
    self.datas[buffID] = data
  end
end

function BuffLimit:ClearData(buffID)
  self.datas[buffID] = nil
end

function BuffLimit:GetFromID()
  for k, v in pairs(self.datas) do
    if v.fromID ~= nil then
      return v.fromID
    end
  end
  return nil
end

function BuffLimit:IsIgnoreTarget()
  for k, v in pairs(self.datas) do
    if v.ignoreTarget == 1 then
      return true
    end
  end
  return false
end

function BuffLimit:IsEmpty()
  for k, v in pairs(self.datas) do
    return false
  end
  return true
end

function BuffLimit:DoConstruct(asArray)
  self.datas = {}
end

function BuffLimit:DoDeconstruct(asArray)
  self.datas = nil
end
