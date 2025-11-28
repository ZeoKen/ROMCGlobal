autoImport("ServiceOverseasTaiwanCmdAutoProxy")
ServiceOverseasTaiwanCmdProxy = class("ServiceOverseasTaiwanCmdProxy", ServiceOverseasTaiwanCmdAutoProxy)
ServiceOverseasTaiwanCmdProxy.Instance = nil
ServiceOverseasTaiwanCmdProxy.NAME = "ServiceOverseasTaiwanCmdProxy"

function ServiceOverseasTaiwanCmdProxy:ctor(proxyName)
  if ServiceOverseasTaiwanCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceOverseasTaiwanCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceOverseasTaiwanCmdProxy.Instance = self
  end
end

uploadCallbacks = {}
downloadCallbacks = {}

function ServiceOverseasTaiwanCmdProxy:GetUpLoadSign(type, photoId, callback)
  LogUtility.InfoFormat("type:{0} photoId:{1}", type, photoId)
  local callbackKey = "cb_" .. type .. "_" .. photoId
  uploadCallbacks[callbackKey] = callback
  self:CallOverseasPhotoUploadCmd(type, photoId)
end

function ServiceOverseasTaiwanCmdProxy:GetDownLoadPath(type, callback)
  local callbackKey = "cb_" .. type
  downloadCallbacks[callbackKey] = callback
  self:CallOverseasPhotoPathPrefixCmd(type)
end

function ServiceOverseasTaiwanCmdProxy:RecvOverseasPhotoUploadCmd(data)
  helplog(" ServiceOverseasTaiwanCmdProxy:RecvOverseasPhotoUploadCmd", data.type)
  if data.type == 3 or not BranchMgr.IsTW() then
    self:Notify(ServiceEvent.OverseasTaiwanCmdOverseasPhotoUploadCmd, data)
    EventManager.Me():PassEvent(ServiceEvent.OverseasTaiwanCmdOverseasPhotoUploadCmd, data)
  else
    local callbackKey = "cb_" .. data.type .. "_" .. data.photoId
    local callback = uploadCallbacks[callbackKey]
    if callback ~= nil then
      callback(data)
      uploadCallbacks[callbackKey] = nil
    end
  end
end

function ServiceOverseasTaiwanCmdProxy:RecvOverseasChargeLimitGetChargeCmd(data)
  helplog("ServiceOverseasTaiwanCmdProxy:RecvOverseasChargeLimitGetChargeCmd")
  EventManager.Me():PassEvent(ServiceEvent.OverseasTaiwanCmdOverseasChargeLimitGetChargeCmd, data)
  self:Notify(ServiceEvent.OverseasTaiwanCmdOverseasChargeLimitGetChargeCmd, data)
end

function ServiceOverseasTaiwanCmdProxy:RecvOverseasPhotoPathPrefixCmd(data)
  local callbackKey = "cb_" .. data.type
  local callback = downloadCallbacks[callbackKey]
  if callback ~= nil then
    callback(data)
    downloadCallbacks[callbackKey] = nil
  end
end
