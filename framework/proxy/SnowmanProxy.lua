SnowmanProxy = class("SnowmanProxy", pm.Proxy)
SnowmanProxy.Instance = nil
SnowmanProxy.NAME = "SnowmanProxy"

function SnowmanProxy:ctor(proxyName, data)
  self.proxyName = proxyName or SnowmanProxy.NAME
  if SnowmanProxy.Instance == nil then
    SnowmanProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.snowmanProcessInfo = {}
end

function SnowmanProxy:UpdateSnowmanProcessInfo(data)
  redlog("SnowmanProxy:UpdateSnowmanProcessInfo snowman_id=" .. tostring(data.snowman_id), "progress=" .. tostring(data.progress), "activated=" .. tostring(data.activated))
  if not self.snowmanProcessInfo[data.snowman_id] then
    self.snowmanProcessInfo[data.snowman_id] = {}
  end
  self.snowmanProcessInfo[data.snowman_id].process = data.progress or 0
end

function SnowmanProxy:GetSnowmanProcess(area)
  return self.snowmanProcessInfo[area] and self.snowmanProcessInfo[area].process or 0
end
