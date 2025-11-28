HotUpdateMgr = class("HotUpdateMgr")
autoImport("DownloadTip")
autoImport("DownloadCell")
local luaCallback, luaParam

function HotUpdateMgr.StartDownload()
  HotUpdateManager.StartDownloadFromLua()
  BuglyManager.GetInstance():Log("HotUpdateManager.StartDownloadFromLua()")
end

function HotUpdateMgr.PauseDownload()
  HotUpdateManager.PauseDownloadFromLua()
  BuglyManager.GetInstance():Log("HotUpdateManager.PauseDownloadFromLua()")
end

function HotUpdateMgr.ContinueDownload()
  HotUpdateManager.StartDownloadFromLua()
  BuglyManager.GetInstance():Log("HotUpdateManager.ContinueDownload()")
end

function HotUpdateMgr.StartUnzip()
  HotUpdateManager.StartUnzipFromLua()
  BuglyManager.GetInstance():Log("HotUpdateManager.StartUnzipFromLua()")
end

function HotUpdateMgr.Shutdown(force)
  HotUpdateManager.ShutDown(force)
  BuglyManager.GetInstance():Log("HotUpdateManager.ShutDown()")
end

function HotUpdateMgr.ReInit()
  HotUpdateManager.ReInit()
  HotUpdateMgr.SetDownloadHandler()
  HotUpdateMgr.ShowUI(true)
  HotUpdateMgr.IsEnableUnzip(false, false)
end

function HotUpdateMgr.IsUpdateDone()
  return HotUpdateManager.IsUpdateDone
end

function HotUpdateMgr.SetFullExtTag()
  HotUpdateManager.SetFullExtTag()
  BuglyManager.GetInstance():Log("HotUpdateManager.SetFullExtTag()")
end

function HotUpdateMgr.GetTotalSizeToDl()
  return HotUpdateManager.GetTotalDownloadSize()
end

function HotUpdateMgr.GetTotaExtSize()
  if HotUpdateManager.GetTotaExtSize then
    return HotUpdateManager.GetTotaExtSize()
  else
    return HotUpdateMgr.GetTotalSizeToDl()
  end
end

function HotUpdateMgr.ShowUI(ret)
  HotUpdateManager.ShowUI(ret)
  BuglyManager.GetInstance():Log("HotUpdateManager.ShowUI()")
end

function HotUpdateMgr.IsEnableUnzip(ret, downloadWithUnzip)
  HotUpdateManager.IsEnableUnzip(ret, false)
  BuglyManager.GetInstance():Log("HotUpdateManager.IsEnableUnzip()")
end

function HotUpdateMgr.GetHotUpdatState()
  return HotUpdateManager.GetHotUpdatState()
end

function HotUpdateMgr.GetDownloadProgress()
  return HotUpdateManager.GetDownloadProgress()
end

function HotUpdateMgr.SetMaxThreadCountForDl(count, sleepTime)
  BuglyManager.GetInstance():Log("HotUpdateMgr.SetMaxThreadCountForDl:" .. tostring(count) .. "," .. tostring(sleepTime))
  return HotUpdateManager.setMaxThreadCountForDl(count, sleepTime)
end

function HotUpdateMgr.CallbackForCsharp(processEntry)
  if luaCallback then
    luaCallback(luaParam, processEntry)
  end
end

function HotUpdateMgr.DefaultDownloadHandler(processEntry)
  GameFacade.Instance:sendNotification(DownloadTip.DownloadEvent, processEntry)
end

function HotUpdateMgr.SetDownloadHandler(param, callback)
  luaCallback = callback
  luaParam = param
  HotUpdateManager.SetLuaHandler()
  BuglyManager.GetInstance():Log("HotUpdateManager.SetLuaHandler()")
end

function HotUpdateMgr.EnterSelectScene()
  HotUpdateMgr.IsEnableUnzip(false, false)
  BuglyManager.GetInstance():Log("HotUpdateMgr.EnterSelectScene:")
end

local showed = false

function HotUpdateMgr.CheckShowDownloadTip()
  local updateDone = HotUpdateMgr.IsUpdateDone()
  local state = HotUpdateMgr.GetHotUpdatState()
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if updateDone and runtimePlatform == RuntimePlatform.IPhonePlayer then
    local _PatchFileManager = PatchFileManager.Instance
    if _PatchFileManager then
      _PatchFileManager:Init()
    end
  end
  BuglyManager.GetInstance():Log("HotUpdateMgr.IsUpdateDone:" .. tostring(updateDone) .. ";status:" .. tostring(state))
  if showed or HotUpdateState.None ~= state then
    HotUpdateMgr.IsEnableUnzip(true, false)
    HotUpdateMgr.SetMaxThreadCountForDl(1, 10)
    return
  end
  showed = true
  if not updateDone and not Application.isEditor and not Game.inAppStoreReview then
    local loginData = FunctionLogin.Me():getLoginData()
    local rewarded = loginData and loginData.resourceReward or false
    local active = loginData and loginData.activePlayer == 3 or true
    local iswifi = Application.internetReachability == NetworkReachability.ReachableViaLocalAreaNetwork
    HotUpdateMgr.SetMaxThreadCountForDl(1, 10)
    HotUpdateMgr.IsEnableUnzip(true, false)
    HotUpdateMgr.SetDownloadHandler(nil, HotUpdateMgr.DefaultDownloadHandler)
    if iswifi and not active then
      HotUpdateMgr.StartDownload()
    else
      GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
        viewname = "DownloadTip",
        errorCode = "StartGamePanel"
      })
    end
  end
end

function HotUpdateMgr.UploadPatchFileToYun(url, policy, authorization, signObj)
  local path = HotUpdateManager.GetAssetCfgPatchFilePath()
  if BranchMgr.IsChina() then
  else
  end
end
