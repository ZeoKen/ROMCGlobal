AuthUserInfoProxy = class("AuthUserInfoProxy", pm.Proxy)
AuthUserInfoProxy.Instance = nil
AuthUserInfoProxy.NAME = "AuthUserInfoProxy"
local AuthType = {PHONE = 1, EMAIL = 2}
local RedTipId = {
  [AuthType.PHONE] = GameConfig.AuthUserInfo.PhoneRedTip,
  [AuthType.EMAIL] = GameConfig.AuthUserInfo.MailRedTip
}

function AuthUserInfoProxy:ctor(proxyName, data)
  self.proxyName = proxyName or AuthUserInfoProxy.NAME
  if AuthUserInfoProxy.Instance == nil then
    AuthUserInfoProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function AuthUserInfoProxy:Init()
  self.authInfo = {}
end

function AuthUserInfoProxy:RecvAuthUserInfo(data)
  if data.auths then
    for i = 1, #data.auths do
      local serverInfo = data.auths[i]
      self:UpdateInfo(serverInfo)
    end
  end
end

function AuthUserInfoProxy:UpdateAuthUserInfo(data)
  if data.auth then
    self:UpdateInfo(data.auth)
  end
end

function AuthUserInfoProxy:UpdateInfo(serverInfo)
  local info = self.authInfo[serverInfo.auth]
  if not info then
    info = {}
    self.authInfo[serverInfo.auth] = info
  end
  info.content = serverInfo.content
  info.updateTime = serverInfo.updatetime
  local redTipId = RedTipId[serverInfo.auth]
  if self:IsAuthUpdatedThisMonth(serverInfo.auth) then
    RedTipProxy.Instance:RemoveWholeTip(redTipId)
  else
    RedTipProxy.Instance:UpdateRedTip(redTipId)
  end
end

function AuthUserInfoProxy:GetAuthContent(authType)
  if self.authInfo[authType] then
    return self.authInfo[authType].content
  end
end

function AuthUserInfoProxy:GetAuthUpdateTime(authType)
  if self.authInfo[authType] then
    return self.authInfo[authType].updateTime
  end
end

function AuthUserInfoProxy:IsAuthUpdatedThisMonth(authType)
  local info = self.authInfo[authType]
  if info then
    local curTimestamp = ServerTime.CurServerTime() / 1000
    local now = os.date("*t", curTimestamp)
    now.day = 1
    now.hour = 5
    now.min = 0
    now.sec = 0
    local targetTimestamp = os.time(now)
    return targetTimestamp < info.updateTime
  end
  return false
end
