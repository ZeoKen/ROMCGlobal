TablePool = class("TablePool")
local LogFormat = LogUtility.InfoFormat
local LogIsEnable = LogUtility.IsEnable
local LogSetEnable = LogUtility.SetEnable
local ArrayPushBack = TableUtility.ArrayPushBack
local ArrayPopBack = TableUtility.ArrayPopBack

function TablePool.DefaultCreator()
  return {}
end

function TablePool:ctor()
  self.pool = {}
  self.poolSize = {}
end

function TablePool:Log()
  local logEnable = LogIsEnable()
  LogSetEnable(true)
  for k, v in pairs(self.pool) do
    local poolSize = self.poolSize[v] or -1
    local poolName = type(k) == "table" and k.__cname or tostring(k)
    LogFormat("<color=#0066BB>Pool({0}): </color>{1}/{2}", poolName, #v, poolSize)
  end
  LogSetEnable(logEnable)
end

function TablePool:_Init(k, size)
  local tag = self.pool[k]
  if nil == tag then
    tag = {}
    self.pool[k] = tag
    if nil ~= size then
      self.poolSize[tag] = size
    elseif type(k) == "table" and nil ~= k.PoolSize then
      self.poolSize[tag] = k.PoolSize
    end
  end
  return tag
end

function TablePool:Init(k, size)
  return self:_Init(k, size)
end

function TablePool:SetPoolSize(k, size)
  local tag = self:_Init(k)
  self:SetPoolSizeByTag(tag, size)
end

function TablePool:SetPoolSizeByTag(tag, size)
  self.poolSize[tag] = size
end

function TablePool:GetPoolSize(k)
  local tag = self.pool[k]
  if nil == tag then
    return -1
  end
  return self.poolSize[tag] or -1
end

function TablePool:Add(k, v)
  local tag = self:_Init(k)
  local poolSize = self.poolSize[tag] or -1
  if 0 < poolSize then
    if poolSize <= #tag then
      return false
    end
  elseif 0 == poolSize then
    return false
  end
  ArrayPushBack(tag, v)
  return true
end

function TablePool:AddByTag(tag, v)
  local poolSize = self.poolSize[tag] or -1
  if 0 < poolSize then
    if poolSize <= #tag then
      return false
    end
  elseif 0 == poolSize then
    return false
  end
  ArrayPushBack(tag, v)
  return true
end

if ApplicationInfo.IsRunOnEditor() then
  function TablePool:AddByTag(tag, v)
    local poolSize = self.poolSize[tag] or -1
    
    if 0 < poolSize then
      if poolSize <= #tag then
        return false
      end
    elseif 0 == poolSize then
      return false
    end
    for i = 1, #tag do
      if tag[i] == v then
        error("ReuseTable不能被重复删除")
      end
    end
    ArrayPushBack(tag, v)
    return true
  end
end

function TablePool:RemoveOrCreate(k, creator)
  local tag = self.pool[k]
  if nil ~= tag and 0 < #tag then
    return ArrayPopBack(tag), false
  end
  return creator(k), true
end

function TablePool:RemoveOrCreateByTag(tag, creator, k)
  if nil ~= tag and 0 < #tag then
    return ArrayPopBack(tag), false
  end
  return creator(k), true
end
