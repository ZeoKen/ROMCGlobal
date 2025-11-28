ProtobufPool = {}
local ArrayPopBack = TableUtility.ArrayPopBack
local ArrayPushBack = TableUtility.ArrayPushBack
local pool = {}
local poolNum = 100

function ProtobufPool.Get(pb_class)
  local dataPool = pool[pb_class]
  if dataPool ~= nil then
    local data = ArrayPopBack(dataPool)
    if data ~= nil then
      return data
    end
  end
  return pb_class()
end

function ProtobufPool.GetArray(arrayIndex)
  local dataPool = pool[arrayIndex]
  if dataPool ~= nil then
    local data = ArrayPopBack(dataPool)
    if data ~= nil then
      return data
    end
  end
  return nil
end

function ProtobufPool.Add(pb_class, data, num)
  num = num or poolNum
  local dataPool = pool[pb_class]
  if dataPool == nil then
    dataPool = {}
    pool[pb_class] = dataPool
  elseif num <= #dataPool then
    return
  end
  ArrayPushBack(dataPool, data)
end

if not ApplicationInfo then
  autoImport("ApplicationInfo")
end
local pb_tag
local _unUsedPool = {}
local _usedPool = {}

function ProtobufPool.GetCbOut()
  if NetProtocol.CachingSomeReceives == true then
    return {}
  else
    local t
    if 0 < #_unUsedPool then
      t = table.remove(_unUsedPool)
    else
      t = {}
    end
    local cellPool = _usedPool[pb_tag]
    if cellPool == nil then
      cellPool = {}
      _usedPool[pb_tag] = cellPool
    end
    table.insert(cellPool, t)
    return t
  end
end

function ProtobufPool.GetPbOut(key)
  pb_tag = key
  local cellPool = _usedPool[pb_tag]
  if cellPool then
    for i = #cellPool, 1, -1 do
      local t = cellPool[i]
      cellPool[i] = nil
      setmetatable(t, nil)
      for k, _ in pairs(t) do
        t[k] = nil
      end
      table.insert(_unUsedPool, t)
    end
  end
  return ProtobufPool.GetCbOut()
end
