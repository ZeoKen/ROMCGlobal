OverseaFFKK = {}

function OverseaFFKK:CatchHook(info)
  if not BranchMgr.IsSEA() then
    return
  end
  local traceStr = debug.traceback()
  if string.match(traceStr, "/data/local/tmp") then
    helplog("hook open:" .. info)
    ServiceOverseasTaiwanCmdProxy.Instance:CallTaiwanMagicLiziCmd(info)
  else
    helplog("not hook:" .. info)
  end
end
