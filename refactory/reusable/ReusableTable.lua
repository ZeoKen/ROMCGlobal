ReusableTable = class("ReusableTable")
if not ReusableTable.inited then
  ReusableTable.pool = TablePool.new()
  ReusableTable.inited = true
end
local TableCreator = TablePool.DefaultCreator
local ArrayClear = TableUtility.TableClear
local TableClear = TableUtility.TableClear
local pool = ReusableTable.pool
local arrayTag = pool:Init(1, 200)
local tableTag = pool:Init(2, 300)
local RemoveOrCreateByTag = TablePool.RemoveOrCreateByTag
local AddByTag = TablePool.AddByTag
local vector2Tag = pool:Init(3, 20)
local vector3Tag = pool:Init(4, 200)
local vector4Tag = pool:Init(5, 20)
local colorTag = pool:Init(6, 20)
local rolePartArrayTag = pool:Init(7, 100)
local rolePartTableTag = pool:Init(8, 200)
local quaternionTag = pool:Init(9, 20)
local searchTargetInfoTag = pool:Init(10, 100)
local innerTeleportInfoTag = pool:Init(11, 10)
local outterTeleportInfoTag = pool:Init(12, 10)
local clientNpcTableTag = pool:Init(13, 300)

function ReusableTable.LogPools()
  pool:Log()
end

function ReusableTable.CreateArray()
  local t, newCreated = RemoveOrCreateByTag(pool, arrayTag, TableCreator)
  if not newCreated then
    ArrayClear(t)
  end
  return t, newCreated
end

function ReusableTable.DestroyArray(array)
  AddByTag(pool, arrayTag, array)
end

function ReusableTable.DestroyAndClearArray(array)
  if array then
    ArrayClear(array)
  end
  AddByTag(pool, arrayTag, array)
end

function ReusableTable.CreateTable()
  local t, newCreated = RemoveOrCreateByTag(pool, tableTag, TableCreator)
  if not newCreated then
    TableClear(t)
  end
  return t, newCreated
end

function ReusableTable.DestroyTable(t)
  AddByTag(pool, tableTag, t)
end

function ReusableTable.DestroyAndClearTable(t)
  if t then
    TableClear(t)
  end
  AddByTag(pool, tableTag, t)
end

function ReusableTable.CreateVector2()
  local t, newCreated = RemoveOrCreateByTag(pool, vector2Tag, TableCreator)
  return t, newCreated
end

function ReusableTable.DestroyVector2(v)
  AddByTag(pool, vector2Tag, v)
end

function ReusableTable.CreateVector3()
  local t, newCreated = RemoveOrCreateByTag(pool, vector3Tag, TableCreator)
  return t, newCreated
end

function ReusableTable.DestroyVector3(v)
  AddByTag(pool, vector3Tag, v)
end

function ReusableTable.CreateColor()
  local t, newCreated = RemoveOrCreateByTag(pool, colorTag, TableCreator)
  return t, newCreated
end

function ReusableTable.DestroyColor(v)
  AddByTag(pool, colorTag, v)
end

function ReusableTable.CreateRolePartArray()
  local t, newCreated = RemoveOrCreateByTag(pool, rolePartArrayTag, TableCreator)
  return t, newCreated
end

function ReusableTable.DestroyRolePartArray(v)
  if v then
    TableClear(v)
  end
  AddByTag(pool, rolePartArrayTag, v)
end

function ReusableTable.DestroyAndClearRolePartArray(v)
  if v then
    TableClear(v)
  end
  AddByTag(pool, rolePartArrayTag, v)
end

function ReusableTable.CreateRolePartTable()
  local t, newCreated = RemoveOrCreateByTag(pool, rolePartTableTag, TableCreator)
  if not newCreated then
    TableClear(t)
  end
  return t, newCreated
end

function ReusableTable.DestroyRolePartTable(v)
  AddByTag(pool, rolePartTableTag, v)
end

function ReusableTable.DestroyAndClearRolePartTable(v)
  if v then
    TableClear(v)
  end
  AddByTag(pool, rolePartTableTag, v)
end

function ReusableTable.CreateQuaternion()
  local t, newCreated = RemoveOrCreateByTag(pool, quaternionTag, TableCreator)
  return t, newCreated
end

function ReusableTable.DestroyQuaternion(v)
  AddByTag(pool, quaternionTag, v)
end

function ReusableTable.CreateSearchTargetInfo()
  local t, newCreated = RemoveOrCreateByTag(pool, searchTargetInfoTag, TableCreator)
  return t, newCreated
end

function ReusableTable.DestroySearchTargetInfo(v)
  v[1] = nil
  AddByTag(pool, searchTargetInfoTag, v)
end

function ReusableTable.CreateInnerTeleportInfo()
  local t, newCreated = RemoveOrCreateByTag(pool, innerTeleportInfoTag, TableCreator)
  return t, newCreated
end

function ReusableTable.DestroyInnerTeleportInfo(v)
  if nil ~= v.targetPos then
    v.targetPos:Destroy()
  end
  if nil ~= v.epTargetPos then
    v.epTargetPos:Destroy()
  end
  TableClear(v)
  AddByTag(pool, innerTeleportInfoTag, v)
end

function ReusableTable.CreateOutterTeleportInfo()
  local t, newCreated = RemoveOrCreateByTag(pool, outterTeleportInfoTag, TableCreator)
  return t, newCreated
end

function ReusableTable.DestroyOutterTeleportInfo(v)
  if nil ~= v.targetPos then
    v.targetPos:Destroy()
  end
  TableClear(v)
  AddByTag(pool, outterTeleportInfoTag, v)
end

function ReusableTable.getClientNpcTable()
  return RemoveOrCreateByTag(pool, clientNpcTableTag, TableCreator)
end

function ReusableTable.destroyClientNpcTable(v)
  if v then
    TableClear(v)
    AddByTag(pool, clientNpcTableTag, v)
  end
end

function getTable()
  return ReusableTable.CreateTable()
end

function delTable(t)
  ReusableTable.DestroyAndClearTable(t)
end

function deepDelTable(t)
  for k, v in pairs(t) do
    if type(v) == "table" then
      deepDelTable(v)
      AddByTag(pool, tableTag, v)
    end
    t[k] = nil
  end
  AddByTag(pool, tableTag, t)
end

function getArray()
  return ReusableTable.CreateTable()
end

function delArray(t)
  return ReusableTable.DestroyAndClearArray(t)
end

function deepDelArray(t)
  for k, v in pairs(t) do
    if type(v) == "table" then
      deepDelArray(v)
      AddByTag(pool, arrayTag, v)
    end
    t[k] = nil
  end
  AddByTag(pool, arrayTag, t)
end

local tempTable = {
  {},
  {},
  {}
}

function getTempTable(index)
  index = 1
  return tempTable[index]
end

function delTempTable(index)
  index = 1
  local t = tempTable[index]
  if t == nil then
    return
  end
  for k, _ in pairs(t) do
    t[k] = nil
  end
end
