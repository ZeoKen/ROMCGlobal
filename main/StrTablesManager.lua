StrTablesManager = class("StrTablesManager")
local transConfig = {
  Table_Item = {"Desc", "NameZh"},
  Table_Skill = {"NameZh"}
}

function StrTablesManager.GetData(tableName, key)
  local strTable = _G[tableName .. "_s"]
  if nil == strTable then
    redlog("Trying to access " .. tableName .. "_s but it's not exist")
    return nil
  end
  local strData = strTable[key]
  if nil == strData or "" == strData then
    return nil
  end
  if string.find(strData, "\\") then
    strData = string.gsub(strData, "\\", "\\\\")
  end
  if string.find(strData, "\n") then
    strData = string.gsub(strData, "\n", "\\n")
  end
  if not string.find(strData, "return") then
    strData = "return " .. strData
  end
  local funcData = loadstring(strData)
  if nil == funcData then
    redlog("Data Cannot Parse: " .. strData)
    return nil
  end
  local data = funcData()
  local transKeys = transConfig[tableName]
  if transKeys then
    Game.track2(data, transKeys)
  end
  _G[tableName][key] = data
  strTable[key] = nil
  return data
end

function StrTablesManager.GetLuaObject(tableName, key)
  local strTable = _G[tableName .. "_s"]
  if nil == strTable then
    redlog("Trying to access " .. tableName .. "_s but it's not exist")
    return nil
  end
  local strData = strTable[key]
  if nil == strData or "" == strData then
    return nil
  end
  if string.find(strData, "\\") then
    strData = string.gsub(strData, "\\", "\\\\")
  end
  if string.find(strData, "\n") then
    strData = string.gsub(strData, "\n", "\\n")
  end
  if not string.find(strData, "return") then
    strData = "return " .. strData
  end
  local funcData = loadstring(strData)
  if nil == funcData then
    redlog("Data Cannot Parse: " .. strData)
    return nil
  end
  return funcData()
end

function StrTablesManager.GetDataRedundantly(tableName, key)
  local data = StrTablesManager.GetLuaObject(tableName, key)
  local table = _G[tableName]
  if data ~= nil and table ~= nil then
    for k, _ in pairs(table) do
      table[k] = nil
    end
    table[key] = data
  end
  return data
end

function StrTablesManager.ProcessMonsterOrNPC(data)
  if nil ~= data then
    if nil ~= data.SpawnSE and "" ~= data.SpawnSE then
      data.SE = string.split(data.SpawnSE, "-")
    end
    data.Race_Parsed = CommonFun.ParseRace(data.Race)
    data.Nature_Parsed = CommonFun.ParseNature(data.Nature)
  end
  return data
end

function Table_ProcessData(tableName, data)
  if tableName == "Table_Monster" or tableName == "Table_Npc" then
    StrTablesManager.ProcessMonsterOrNPC(data)
  end
end

local fd, tempD

function StrTablesManager.GetTableDataByString(str, tableName)
  if str == nil then
    return
  end
  if str:find("\\") then
    str = str:gsub("\\", "\\\\")
  end
  if str:find("\n") then
    str = str:gsub("\n", "\\n")
  end
  fd = loadstring("return " .. str)
  if not fd then
    return
  end
  tempD = fd()
  if not tempD then
    return
  end
  local transKeys = transConfig[tableName]
  if transKeys then
    Game.track3(tempD, transKeys)
  end
  return tempD
end

function StrTablesManager.GetTableData(tb, tableName)
  if tb == nil then
    return
  end
  local transKeys = transConfig[tableName]
  if transKeys then
    Game.track3(tb, transKeys)
  end
end

local mTranslate = function(tempD, tableName)
  local transKeys = transConfig[tableName]
  if transKeys then
    Game.track2(tempD, transKeys)
  end
end
local tempTranslateArray = {}

function StrTablesManager.Translate(tempD, tableName)
  if Game and Game.State == Game.EState.Running then
    mTranslate(tempD, tableName)
  else
    table.insert(tempTranslateArray, {tempD, tableName})
  end
end

function StrTablesManager.DoInitTranslate()
  local tempD, tableName, transKeys
  for i = 1, #tempTranslateArray do
    tempD, tableName = tempTranslateArray[i][1], tempTranslateArray[i][2]
    mTranslate(tempD, tableName)
  end
  tempTranslateArray = {}
end
