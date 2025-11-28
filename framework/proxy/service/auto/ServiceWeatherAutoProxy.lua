ServiceWeatherAutoProxy = class("ServiceWeatherAutoProxy", ServiceProxy)
ServiceWeatherAutoProxy.Instance = nil
ServiceWeatherAutoProxy.NAME = "ServiceWeatherAutoProxy"

function ServiceWeatherAutoProxy:ctor(proxyName)
  if ServiceWeatherAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceWeatherAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceWeatherAutoProxy.Instance = self
  end
end

function ServiceWeatherAutoProxy:Init()
end

function ServiceWeatherAutoProxy:onRegister()
  self:Listen(53, 1, function(data)
    self:RecvWeatherChange(data)
  end)
  self:Listen(53, 2, function(data)
    self:RecvSkyChange(data)
  end)
end

function ServiceWeatherAutoProxy:CallWeatherChange(id)
  if not NetConfig.PBC then
    local msg = SessionWeather_pb.WeatherChange()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.WeatherChange.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeatherAutoProxy:CallSkyChange(id, sec)
  if not NetConfig.PBC then
    local msg = SessionWeather_pb.SkyChange()
    if id ~= nil then
      msg.id = id
    end
    if sec ~= nil then
      msg.sec = sec
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SkyChange.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if sec ~= nil then
      msgParam.sec = sec
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceWeatherAutoProxy:RecvWeatherChange(data)
  self:Notify(ServiceEvent.WeatherWeatherChange, data)
end

function ServiceWeatherAutoProxy:RecvSkyChange(data)
  self:Notify(ServiceEvent.WeatherSkyChange, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.WeatherWeatherChange = "ServiceEvent_WeatherWeatherChange"
ServiceEvent.WeatherSkyChange = "ServiceEvent_WeatherSkyChange"
