FunctionAppForward = class("FunctionAppForward")

function FunctionAppForward.Me()
  if nil == FunctionAppForward.me then
    FunctionAppForward.me = FunctionAppForward.new()
  end
  return FunctionAppForward.me
end

function FunctionAppForward:ctor()
end

function FunctionAppForward:AppForwardByID(id, ...)
  if BackwardCompatibilityUtil.CompatibilityMode_V42 then
    MsgManager.ShowMsgByID(40543)
    return
  end
  local cfg = Table_AppForward and Table_AppForward[id]
  if not cfg then
    return
  end
  if ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer then
    ExternalInterfaces.TryAppForward(string.format(cfg.ios_url, ...), string.format(cfg.ios_fallback_url, ...), cfg.ios_scheme)
  elseif ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
    local result = ExternalInterfaces.TryAppForward(string.format(cfg.android_url, ...), string.format(cfg.android_fallback_url, ...), cfg.android_pkg_name)
    if result == -2 then
      MsgManager.ShowMsgByID(40544)
    end
  else
    helplog("platform not supported!")
  end
end
