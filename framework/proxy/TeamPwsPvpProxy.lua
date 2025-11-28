TeamPwsPvpProxy = class("TeamPwsPvpProxy", pm.Proxy)
TeamPwsPvpProxy.Instance = nil
TeamPwsPvpProxy.NAME = "TeamPwsPvpProxy"

function TeamPwsPvpProxy:ctor(proxyName, data)
  self.debugEnable = false
  self.proxyName = proxyName or TeamPwsPvpProxy.NAME
  if TeamPwsPvpProxy.Instance == nil then
    TeamPwsPvpProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function TeamPwsPvpProxy:Init()
end

function TeamPwsPvpProxy:Reset()
end
