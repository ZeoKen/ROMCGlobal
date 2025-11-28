SpyInfo = {}
SpyInfo.specialUser = false
local SpyApkMap = {}
local SpyProcessMap = {}
local SpyPluginMap = {}
local ProcessesMap = {}
local ApksMap = {}
local CheatMapCache = {}
CheatMapCache.apks = {}
CheatMapCache.processes = {}

function SpyInfo.IsRunOnAndroid()
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  return runtimePlatform == RuntimePlatform.Android
end

function SpyInfo.SetSpyConfig(pluginInfos)
  for i = 1, #pluginInfos do
    local plugin = pluginInfos[i]
    table.insert(SpyApkMap, plugin.apk)
    table.insert(SpyProcessMap, plugin.process)
    SpyPluginMap[plugin.apk] = plugin.process
  end
end

function SpyInfo.GetProccesses()
  if SpyInfo.IsRunOnAndroid() then
    local processesStr = ExternalInterfaces.GetAndroidRunningProcesses()
    local processes = string.split(processesStr, "\n")
    for i = 1, #processes do
      local process = processes[i]
      if process ~= "" then
        table.insert(ProcessesMap, process)
      end
    end
  end
end

function SpyInfo.GetInstalledPackages()
  if SpyInfo.IsRunOnAndroid() then
    local apksStr = ExternalInterfaces.GetAndroidInstalledPackages()
    local apks = string.split(apksStr, "\n")
    for i = 1, #apks do
      local apk = apks[i]
      if apk ~= "" then
        table.insert(ApksMap, apk)
      end
    end
  end
end

function SpyInfo.Clear()
  ProcessesMap = {}
  ApksMap = {}
end

function SpyInfo.Detect()
  if SpyInfo.IsRunOnAndroid() then
    SpyInfo.Clear()
    SpyInfo.GetProccesses()
    SpyInfo.GetInstalledPackages()
    local isChange = false
    local apksMap = {}
    if SpyInfo.specialUser == true then
      apksMap = ApksMap
    else
      for i = 1, #SpyApkMap do
        local spy = SpyApkMap[i]
        for j = 1, #ApksMap do
          local apk = ApksMap[j]
          if spy == apk then
            table.insert(apksMap, apk)
          end
        end
      end
    end
    if 0 < #apksMap and SpyInfo.CacheCheat(apksMap, "apk") then
      isChange = true
    end
    local processesMap = {}
    for _, spy in pairs(SpyProcessMap) do
      for _, process in pairs(ProcessesMap) do
        if SpyInfo.Levenshtein(spy, process) then
          table.insert(processesMap, process)
        end
      end
    end
    if 0 < #processesMap and SpyInfo.CacheCheat(processesMap, "process") then
      isChange = true
    end
    if isChange then
      SpyInfo.PostCheat(CheatMapCache)
    end
  end
end

function SpyInfo.CacheCheat(cheatMap, type)
  local targetMap
  if type == "apk" then
    targetMap = CheatMapCache.apks
  elseif type == "process" then
    targetMap = CheatMapCache.processes
  end
  if #cheatMap ~= #targetMap then
    CheatMapCache.apks = cheatMap
    return true
  else
    return false
  end
end

function SpyInfo.PostCheat(cheatMap)
  local plugins = {}
  for i = 1, #CheatMapCache.apks do
    local apk = CheatMapCache.apks[i]
    local plugin = {}
    plugin.apk = apk
    plugin.process = ""
    table.insert(plugins, plugin)
  end
  for i = 1, #CheatMapCache.processes do
    local process = CheatMapCache.processes[i]
    local plugin = {}
    plugin.apk = ""
    plugin.process = process
    table.insert(plugins, plugin)
  end
  ServiceSceneUser3Proxy.Instance:CallPlugInUpload(plugins, SpyInfo.specialUser and 1 or 0)
end

local reportInfo = {}

function SpyInfo.ResetReport()
  reportInfo = nil
  reportInfo = {}
end

function SpyInfo.CacheReportInfo(assetPath)
  if reportInfo[assetPath] == nil then
    reportInfo[assetPath] = 0
  end
  reportInfo[assetPath] = reportInfo[assetPath] + 1
end

local trackingTables = {
  ActionEffect = Table_ActionEffect,
  ActionEffectSetUp = Table_ActionEffectSetUp,
  Assesories = Table_Assesories,
  Body = Table_Body,
  Brick = Table_Brick,
  BusCarrier = Table_BusCarrier,
  CommonFaceStyle = Table_CommonFaceStyle,
  EquipDisplay = Table_EquipDisplay,
  EquipFake = Table_EquipFake,
  EyeFake = Table_EyeFake,
  HairColor = Table_HairColor,
  Mount = Table_Mount,
  RolePartLogic = Table_RolePartLogic
}
local reverseTables = {}
for name, tb in pairs(trackingTables) do
  reverseTables[tb] = name
end
local G_Table = _G
local RegisterTrackingTable = function(tb, tbName)
  if tb ~= nil then
    local source_mt = getmetatable(tb)
    local name = tbName
    if source_mt ~= nil then
      local mt = {
        __index = function(t, k)
          local metafunc = source_mt.__index
          if k ~= nil and k ~= 0 and k ~= "0" then
            SpyInfo.CacheReportInfo(name .. "|" .. tostring(k))
          end
          local tempData = metafunc(t, k)
          local temp_mt = getmetatable(tempData)
          return tempData
        end
      }
      setmetatable(tb, mt)
    else
      do
        local tmp_t = trackingTables[tbName]
        local mt = {
          __index = function(t, k)
            if k ~= nil and k ~= 0 and k ~= "0" then
              SpyInfo.CacheReportInfo(tbName .. "|" .. tostring(k))
            end
            return tmp_t[k]
          end
        }
        G_Table["Table_" .. tbName] = nil
        G_Table["Table_" .. tbName] = {}
        setmetatable(G_Table["Table_" .. tbName], mt)
      end
    end
  end
end

function SpyInfo.RegisterAllTracking()
  for key, tb in pairs(trackingTables) do
    RegisterTrackingTable(tb, key)
  end
end

function SpyInfo.ConvertReportLog()
  local sourceTb = reportInfo
  local resultTb = {}
  local server = FunctionLogin.Me():getCurServerData()
  local serverId = tostring(server ~= nil and server.sid or 1)
  local tmpTB = {}
  for k, v in pairs(sourceTb) do
    local resourceInfo = string.split(k, "|")
    local tmp = {
      tableName = resourceInfo[1],
      tableID = resourceInfo[2],
      count = tostring(v),
      sid = serverId
    }
    table.insert(tmpTB, tmp)
  end
  resultTb.__topic__ = "client_resource"
  resultTb.__logs__ = tmpTB
  return resultTb
end

function SpyInfo.ReportLoadInfo()
  if BranchMgr.IsChina() or BranchMgr.IsSEA() or BranchMgr.IsTW() then
    local c = coroutine.create(function()
      local baseurl = ""
      if BranchMgr.IsChina() and EnvChannel.IsReleaseBranch() then
        baseurl = "https://rogame.cn-shanghai.log.aliyuncs.com/logstores/clientupload_prod/track"
      elseif BranchMgr.IsSEA() then
        baseurl = "https://rogame-sg.ap-southeast-1.log.aliyuncs.com/logstores/clientupload_prod_sea/track"
      elseif BranchMgr.IsTW() then
        baseurl = "https://rogame-sg.ap-southeast-1.log.aliyuncs.com/logstores/clientupload_prod_tw/track"
      end
      if baseurl ~= "" then
        local data = json.encode(SpyInfo.ConvertReportLog())
        local order = Slua.CreateClass("UnityEngine.Networking.UnityWebRequest", baseurl, "POST")
        order:SetRequestHeader("x-log-apiversion", "0.6.0")
        local bytes = Slua.ToBytes(data)
        local rawDataHandler = Slua.CreateClass("UnityEngine.Networking.UploadHandlerRaw", bytes)
        order.uploadHandler = rawDataHandler
        Yield(order:SendWebRequest())
        if order.error == nil or order.error == "" then
          SpyInfo.ResetReport()
        end
        order:Dispose()
        order = nil
      end
    end)
    coroutine.resume(c)
  end
end

function SpyInfo.Levenshtein(strA, strB)
  return strA == strB
end
