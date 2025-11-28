FunctionGetIpStrategy = class("FunctionGetIpStrategy")
FunctionGetIpStrategy.LANGUAGESCOPE = {EN = "EN", CN = "CN"}
FunctionGetIpStrategy.GROUPKEY = {
  "LANGUAGESCOPE"
}

function FunctionGetIpStrategy.Me()
  if not BranchMgr.IsChina() then
    autoImport("OverseaHostHelper")
  end
  if nil == FunctionGetIpStrategy.me then
    FunctionGetIpStrategy.me = FunctionGetIpStrategy.new()
  end
  return FunctionGetIpStrategy.me
end

function FunctionGetIpStrategy:ctor()
  self:initData()
end

function FunctionGetIpStrategy:initData()
  self.needComatibility = false
  Game.FunctionLoginMono = FunctionLoginMono.Instance
  LogUtility.InfoFormat(" FunctionGetIpStrategy:initData needComatibility:{0}", self.needComatibility)
  self.language = FunctionGetIpStrategy.LANGUAGESCOPE.CN
  self.groupKey = self.language
  self.accId = nil
  self.isReconnect = false
  self.normalIpIndex = 0
  self.hasConnFailure = false
  self.reConnCountInGame = 0
  self.socketInfo = nil
  self:resetData()
end

function FunctionGetIpStrategy:setReConnectState(state)
  self.isReconnect = state
  LogUtility.InfoFormat(" FunctionGetIpStrategy:setReConnectState:state:{0}", state)
end

function FunctionGetIpStrategy:setAccId(accId)
  self.accId = accId
  LogUtility.InfoFormat(" FunctionGetIpStrategy:setAccId:accId:{0}", accId)
end

function FunctionGetIpStrategy:getAccId()
  return self.accId
end

function FunctionGetIpStrategy:setSdkState(sdkState)
  self.sdkState = sdkState
  LogUtility.InfoFormat(" FunctionGetIpStrategy:setSdkState:sdkState:{0}", sdkState)
end

function FunctionGetIpStrategy:setHasConnFailure(hasConnFailure)
  self.hasConnFailure = hasConnFailure
  if not hasConnFailure then
    self.reConnCountInGame = 0
  end
  LogUtility.InfoFormat(" FunctionGetIpStrategy:setHasConnFailure hasConnFailure:{0}", hasConnFailure)
end

function FunctionGetIpStrategy:resetData()
  self.curSerIndexInGroup = 1
  self.curSerIndex = nil
  self.sdkState = true
  LogUtility.Info(" FunctionGetIpStrategy:resetData")
end

function FunctionGetIpStrategy:getRequestAddresss()
  return NetConfig.NewAccessTokenAuthHost
end

local tempTable = {}

function FunctionGetIpStrategy:setCurrentSocketInfo(socketInfo)
  if socketInfo then
    tempTable.ip = socketInfo.ip
    tempTable.domain = socketInfo.originDomain
    self.socketInfo = tempTable
  else
    self.socketInfo = nil
  end
end

function FunctionGetIpStrategy:getCurrentSocketInfo()
  return self.socketInfo
end

function FunctionGetIpStrategy:getServerIpSync(callback, groupName)
  self:getBestServerIpByAliSdkSync(callback, groupName)
end

function FunctionGetIpStrategy:getBestServerIpByAliSdkSync(callback, groupName)
  self:getIpByDomains(function(resolveRets)
    if self.hasConnFailure and not self.isReconnect then
      self:multiSocketConnectTest(callback, resolveRets)
      return
    elseif self.isReconnect and self.hasConnFailure and self.reConnCountInGame > 0 then
      self:multiSocketConnectTest(callback, resolveRets)
      return
    elseif self.isReconnect and self.hasConnFailure then
      self.reConnCountInGame = self.reConnCountInGame + 1
    end
    if self:checkIsIpv6(resolveRets) then
      self:multiSocketConnectTest(callback, resolveRets)
      LogUtility.Info(" checkIsIpv6: return true")
    else
      local useSdk = false
      if not useSdk then
        groupName = nil
      end
      LogUtility.InfoFormat(" start FunctionGetIpStrategy:getServerIpByAliSdkAsync groupName:{0}", groupName)
      self:multiSocketConnectTest(callback, resolveRets)
    end
  end)
end

function FunctionGetIpStrategy:getIpByDomains(callback)
  local domains = OverseaHostHelper:GetHosts()
  if type(domains) ~= "table" or 0 == #domains then
    domains = NetConfig.NewGateHost
  end
  domains = self:addUcloudIps(domains)
  if domains and 0 < #domains then
    self.dnsrel = FunctionLoginDnsResolve(NetConfig.DnsResolveTimeOut)
    for i = 1, #domains do
      local domain = domains[i]
      self.dnsrel:addDomainName(domains[i])
    end
    self.dnsrel:setCallback(function(resolveRets)
      callback(resolveRets)
    end)
    self.dnsrel:tryStartResolve()
  else
    callback()
  end
end

function FunctionGetIpStrategy:addUcloudIps(domains)
  local ipList = OverseaHostHelper.ucloud_addrs
  if OverseaHostHelper.ucloud_addrs ~= nil then
    for k, v in pairs(ipList) do
      table.insert(domains, v)
    end
  end
  return domains
end

local tempArray = {}

function FunctionGetIpStrategy:multiSocketConnectTest(callback, resolveRets, aliIP, aliGroup)
  self.sts = nil
  local gatePort = FunctionLogin.Me():getServerPort()
  LogUtility.InfoFormat("multiSocketConnectTest gatePort:{0}", gatePort)
  TableUtility.ArrayClear(tempArray)
  OverseaHostHelper:InitDomainMap()
  for i = 1, #resolveRets do
    local ret = resolveRets[i]
    if ret.result.state == FunctionLoginDnsResolve.DnsResolveState.Finish and not table.ContainsValue(tempArray, ret.result.ip) and not table.ContainsValue(OverseaHostHelper.ucloud_addrs, ret.result.domain) then
      if self.sts == nil then
        self.sts = FunctionLoginChooseSocket(NetConfig.SocketConnectTestTimeOut)
      end
      self.sts:addIpAndPort(ret.result.ip, gatePort, ret.result.domain)
      table.insert(tempArray, ret.result.ip)
    end
    OverseaHostHelper:AddDomainWithIp(ret.result.domain, ret.result.ip)
    LogUtility.InfoFormat("FunctionLoginDnsResolve delay:{0},ip:{1},domain:{2}", ret.result.delay, ret.result.ip, ret.result.domain)
    LogUtility.InfoFormat("FunctionLoginDnsResolve state:{0},errorMessage:{1}", ret.result.state, ret.result.errorMessage)
  end
  if aliIP then
    if self.sts == nil then
      self.sts = FunctionLoginChooseSocket(NetConfig.SocketConnectTestTimeOut)
    end
    self.sts:addIpAndPort(aliIP, gatePort, aliGroup)
  end
  if self.sts then
    self.sts:setCallback(function(connectRets)
      local result = self:getBestResult(connectRets)
      self:setCurrentSocketInfo(result)
      if callback then
        callback(result)
      end
    end)
    self.sts:tryStartConnect()
  else
    callback()
  end
end

function FunctionGetIpStrategy:checkIsIpv6(resolveRets)
  if resolveRets then
    for i = 1, #resolveRets do
      local ret = resolveRets[i]
      if ret.result.state == FunctionLoginDnsResolve.DnsResolveState.Finish then
        local ip = ret.result.ip
        if ip and string.find(ip, ":") then
          return true
        end
      end
    end
  end
end

function FunctionGetIpStrategy:getBestResult(connectRets)
  return self:getBestResult_2(connectRets)
end

function FunctionGetIpStrategy:getBestResult_3(connectRets)
  local result
  local validHosts = {}
  local minDelay = 999999
  for i = 1, #connectRets do
    local ret = connectRets[i]
    local isConnected = ret.result.state == FunctionLoginChooseSocket.SocketConnectState.Finish
    local isAli = self:isAliSdk(ret.result.originDomain)
    local delta = isAli and NetConfig.AliyunNetDelayDelta or 0
    LogUtility.InfoFormat("FunctionLoginChooseSocket isAli:{0},delta:{1}", isAli, delta)
    if isConnected then
      if result then
        result:dispose()
      end
      validHosts[ret.result.originDomain] = ret
    else
      ret.result:dispose()
    end
  end
  table.sort(OverseaHostHelper.hostList, function(a, b)
    return a.priority < b.priority
  end)
  for k, v in pairs(OverseaHostHelper.hostList) do
    local ret = validHosts[v.host]
    if ret then
      result = ret.result
      break
    end
  end
  Debug.LogFormat("last connect to {0}", result and result.originDomain)
  return result
end

function FunctionGetIpStrategy:getBestResult_1(connectRets)
  local result
  local minDelay = 999999
  for i = 1, #connectRets do
    local ret = connectRets[i]
    local isConnected = ret.result.state == FunctionLoginChooseSocket.SocketConnectState.Finish
    local isAli = self:isAliSdk(ret.result.originDomain)
    local delta = isAli and NetConfig.AliyunNetDelayDelta or 0
    LogUtility.InfoFormat("FunctionLoginChooseSocket isAli:{0},delta:{1}", isAli, delta)
    if isConnected and delta > ret.result.delay - minDelay then
      minDelay = ret.result.delay
      if result then
        result:dispose()
      end
      result = ret.result
    else
      ret.result:dispose()
    end
    LogUtility.InfoFormat("FunctionLoginChooseSocket delay:{0},ip:{1},originDomain:{2}", ret.result.delay, ret.result.ip, ret.result.originDomain)
    LogUtility.InfoFormat("FunctionLoginChooseSocket state:{0},errorMessage:{1}", ret.result.state, ret.result.errorMessage)
  end
  return result
end

function FunctionGetIpStrategy:getBestResult_2(connectRets)
  local minDelay = 999999
  local result, norRet, aliRet, gfRet, fnRet
  local norDelayDelta = 100
  if BranchMgr.IsChina() then
    for i = 1, #connectRets do
      local ret = connectRets[i]
      local isConnected = ret.result.state == FunctionLoginChooseSocket.SocketConnectState.Finish
      local isAli = self:isAliSdk(ret.result.originDomain)
      local isGf = self:isGfDomain(ret.result.originDomain)
      local isFn = self:isForeignDomain(ret.result.originDomain)
      if isConnected and isAli then
        aliRet = ret.result
      elseif isConnected and isGf then
        gfRet = ret.result
      elseif isConnected and isFn then
        fnRet = ret.result
      elseif isConnected then
        norRet = ret.result
      end
      LogUtility.InfoFormat("FunctionLoginChooseSocket isAli:{0},isGf:{1}", isAli, isGf)
      LogUtility.InfoFormat("FunctionLoginChooseSocket delay:{0},ip:{1},originDomain:{2}", ret.result.delay, ret.result.ip, ret.result.originDomain)
      LogUtility.InfoFormat("FunctionLoginChooseSocket state:{0},errorMessage:{1}", ret.result.state, ret.result.errorMessage)
    end
    if fnRet and norRet then
      if norDelayDelta <= norRet.delay - fnRet.delay then
        norRet = fnRet
      end
    elseif not norRet and fnRet then
      norRet = fnRet
    end
    local aliOk = false
    local gfOk = false
    local maxDelta = 20
    local delta
    if aliRet then
      if norRet then
        delta = aliRet.delay - norRet.delay
        if maxDelta > delta then
          aliOk = true
        end
      else
        aliOk = true
      end
    end
    if gfRet then
      if norRet then
        delta = gfRet.delay - norRet.delay
        if maxDelta > delta then
          gfOk = true
        end
      else
        gfOk = true
      end
    end
    if aliOk and gfOk then
      local ret = math.random(2) == 1
      if ret then
        result = aliRet
        LogUtility.Info("FunctionLoginChooseSocket Choose Ali by random")
      else
        result = gfRet
        LogUtility.Info("FunctionLoginChooseSocket Choose GF by random")
      end
    elseif aliOk then
      result = aliRet
      LogUtility.Info("FunctionLoginChooseSocket Choose Ali")
    elseif gfOk then
      result = gfRet
      LogUtility.Info("FunctionLoginChooseSocket Choose GF")
    else
      result = norRet
      LogUtility.Info("FunctionLoginChooseSocket Choose Other")
    end
  end
  if not BranchMgr.IsChina() then
    local hosts = OverseaHostHelper:GetHosts()
    local found = false
    for i = 1, #hosts do
      local host = hosts[i]
      for i = 1, #connectRets do
        local socketRet = connectRets[i].result
        local isConnected = socketRet.state == FunctionLoginChooseSocket.SocketConnectState.Finish
        if socketRet.originDomain == host and isConnected then
          result = socketRet
          found = true
          break
        end
      end
      if found then
        break
      end
    end
  end
  if nil ~= result then
    LogUtility.InfoFormat("FunctionLoginChooseSocket Choose: delay:{0},ip:{1},originDomain:{2}", result.delay, result.ip, result.originDomain)
  end
  for i = 1, #connectRets do
    local ret = connectRets[i].result
    if ret ~= result then
      ret:dispose()
    end
  end
  return result
end

function FunctionGetIpStrategy:checkResultIsOk(result, connectRets)
  local result
  local minDelay = 999999
  local maxDelta = 100
  local isAli = self:isAliSdk(result.originDomain)
  local isGf = self:isGfDomain(result.originDomain)
  for i = 1, #connectRets do
    local ret = connectRets[i]
    if result ~= ret.result then
      local isConnected = ret.result.state == FunctionLoginChooseSocket.SocketConnectState.Finish
      LogUtility.InfoFormat("FunctionLoginChooseSocket isAli:{0},isGf:{1},delta:{2}", isAli, isGf, delta)
      if isConnected and maxDelta > result.delay - minDelay then
        minDelay = ret.result.delay
        if result then
          result:dispose()
        end
        result = ret.result
      end
    end
  end
end

function FunctionGetIpStrategy:isAliSdk(originDomain)
  local domains = NetConfig.NewGateHost
  for i = 1, #domains do
    if originDomain == domains[i] then
      return false
    end
  end
  return true
end

function FunctionGetIpStrategy:isGfDomain(originDomain)
  return originDomain == NetConfig.NewGateHostGf
end

function FunctionGetIpStrategy:isForeignDomain(originDomain)
  return originDomain == NetConfig.NewGateHostFg
end

function FunctionGetIpStrategy:GameEnd()
  if self.dnsrel then
    self.dnsrel:setCallback(nil)
  end
  if self.sts then
    self.dnsrel:setCallback(nil)
  end
end
