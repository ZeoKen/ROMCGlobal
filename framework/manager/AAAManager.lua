autoImport("Atcmi")
autoImport("Atlpc")
AAAManager = class("AAAManager")
local isMPlus = false
local atMap

function AAAManager.Me()
  if AAAManager.me == nil then
    AAAManager.me = AAAManager.new()
  end
  return AAAManager.me
end

function AAAManager:ctor()
  atMap = {}
  atMap.cmi = Atcmi.new(GameConfig.GameHealth.P1ClickTimes * 1000)
  atMap.lpc = Atlpc.new()
end

function AAAManager:RecvCheatTagStat(data)
  local recvThreshold = data.clickmvpthreshold
  if recvThreshold and 0 < recvThreshold and recvThreshold ~= atMap.cmi.threshold then
    atMap.cmi.threshold = recvThreshold
  end
  if data.cheated then
    self:MPlus()
  else
    self:MMinus()
  end
end

function AAAManager:MPlus()
  if isMPlus then
    return
  end
  isMPlus = true
  LogUtility.Info("M+")
end

function AAAManager:MMinus()
  if not isMPlus then
    return
  end
  isMPlus = false
  LogUtility.Info("M-")
end

function AAAManager:ClickEvent(name, positionX, positionY)
  if not name then
    return
  end
  atMap.lpc:Record(name, positionX, positionY)
end

function AAAManager:IsCmiOn()
  return atMap.cmi and atMap.cmi:IsOn()
end

function AAAManager:StartCmi()
  atMap.cmi:Start()
end

function AAAManager:ClearCmi()
  atMap.cmi:Clear()
end

function AAAManager:Rcmc()
  atMap.cmi:R()
end

function AAAManager:GetLpc(name)
  return atMap.lpc:Get(name)
end

function AAAManager:ClearLpc(name)
  return atMap.lpc:Clear(name)
end

function AAAManager.MakeInteger(a, b)
  return math.ceil(a) * 10000 + math.ceil(b)
end
