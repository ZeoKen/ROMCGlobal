ServiceLoginUserCmdAutoProxy = class("ServiceLoginUserCmdAutoProxy", ServiceProxy)
ServiceLoginUserCmdAutoProxy.Instance = nil
ServiceLoginUserCmdAutoProxy.NAME = "ServiceLoginUserCmdAutoProxy"

function ServiceLoginUserCmdAutoProxy:ctor(proxyName)
  if ServiceLoginUserCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceLoginUserCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceLoginUserCmdAutoProxy.Instance = self
  end
end

function ServiceLoginUserCmdAutoProxy:Init()
end

function ServiceLoginUserCmdAutoProxy:onRegister()
  self:Listen(1, 4, function(data)
    self:RecvRegResultUserCmd(data)
  end)
  self:Listen(1, 5, function(data)
    self:RecvCreateCharUserCmd(data)
  end)
  self:Listen(1, 6, function(data)
    self:RecvSnapShotUserCmd(data)
  end)
  self:Listen(1, 7, function(data)
    self:RecvSelectRoleUserCmd(data)
  end)
  self:Listen(1, 8, function(data)
    self:RecvLoginResultUserCmd(data)
  end)
  self:Listen(1, 9, function(data)
    self:RecvDeleteCharUserCmd(data)
  end)
  self:Listen(1, 10, function(data)
    self:RecvHeartBeatUserCmd(data)
  end)
  self:Listen(1, 11, function(data)
    self:RecvServerTimeUserCmd(data)
  end)
  self:Listen(1, 12, function(data)
    self:RecvGMDeleteCharUserCmd(data)
  end)
  self:Listen(1, 13, function(data)
    self:RecvClientInfoUserCmd(data)
  end)
  self:Listen(1, 14, function(data)
    self:RecvReqLoginUserCmd(data)
  end)
  self:Listen(1, 15, function(data)
    self:RecvReqLoginParamUserCmd(data)
  end)
  self:Listen(1, 16, function(data)
    self:RecvKickParamUserCmd(data)
  end)
  self:Listen(1, 17, function(data)
    self:RecvCancelDeleteCharUserCmd(data)
  end)
  self:Listen(1, 18, function(data)
    self:RecvClientFrameUserCmd(data)
  end)
  self:Listen(1, 19, function(data)
    self:RecvSafeDeviceUserCmd(data)
  end)
  self:Listen(1, 20, function(data)
    self:RecvConfirmAuthorizeUserCmd(data)
  end)
  self:Listen(1, 21, function(data)
    self:RecvSyncAuthorizeGateCmd(data)
  end)
  self:Listen(1, 22, function(data)
    self:RecvRealAuthorizeUserCmd(data)
  end)
  self:Listen(1, 23, function(data)
    self:RecvRealAuthorizeServerCmd(data)
  end)
  self:Listen(1, 24, function(data)
    self:RecvRefreshZoneIDUserCmd(data)
  end)
  self:Listen(1, 25, function(data)
    self:RecvQueryAfkStatUserCmd(data)
  end)
  self:Listen(1, 26, function(data)
    self:RecvKickCharUserCmd(data)
  end)
  self:Listen(1, 27, function(data)
    self:RecvOfflineDetectUserCmd(data)
  end)
  self:Listen(1, 28, function(data)
    self:RecvDeviceInfoUserCmd(data)
  end)
  self:Listen(1, 29, function(data)
    self:RecvAttachLoginUserCmd(data)
  end)
  self:Listen(1, 30, function(data)
    self:RecvAttachSyncCmdUserCmd(data)
  end)
  self:Listen(1, 31, function(data)
    self:RecvPingUserCmd(data)
  end)
  self:Listen(1, 33, function(data)
    self:RecvSetMaxScopeUserCmd(data)
  end)
  self:Listen(1, 34, function(data)
    self:RecvReqLoginOutGateCmd(data)
  end)
end

function ServiceLoginUserCmdAutoProxy:CallRegResultUserCmd(id, ret)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.RegResultUserCmd()
    if msg == nil then
      msg = {}
    end
    msg.id = id
    if msg == nil then
      msg = {}
    end
    msg.ret = ret
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RegResultUserCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.id = id
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.ret = ret
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallCreateCharUserCmd(name, role_sex, profession, hair, haircolor, clothcolor, accid, sequence, version, serverid, deviceid, ip, realzoneid, eye)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.CreateCharUserCmd()
    if name ~= nil then
      msg.name = name
    end
    if role_sex ~= nil then
      msg.role_sex = role_sex
    end
    if profession ~= nil then
      msg.profession = profession
    end
    if hair ~= nil then
      msg.hair = hair
    end
    if haircolor ~= nil then
      msg.haircolor = haircolor
    end
    if clothcolor ~= nil then
      msg.clothcolor = clothcolor
    end
    if accid ~= nil then
      msg.accid = accid
    end
    if sequence ~= nil then
      msg.sequence = sequence
    end
    if version ~= nil then
      msg.version = version
    end
    if serverid ~= nil then
      msg.serverid = serverid
    end
    if deviceid ~= nil then
      msg.deviceid = deviceid
    end
    if ip ~= nil then
      msg.ip = ip
    end
    if realzoneid ~= nil then
      msg.realzoneid = realzoneid
    end
    if eye ~= nil then
      msg.eye = eye
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CreateCharUserCmd.id
    local msgParam = {}
    if name ~= nil then
      msgParam.name = name
    end
    if role_sex ~= nil then
      msgParam.role_sex = role_sex
    end
    if profession ~= nil then
      msgParam.profession = profession
    end
    if hair ~= nil then
      msgParam.hair = hair
    end
    if haircolor ~= nil then
      msgParam.haircolor = haircolor
    end
    if clothcolor ~= nil then
      msgParam.clothcolor = clothcolor
    end
    if accid ~= nil then
      msgParam.accid = accid
    end
    if sequence ~= nil then
      msgParam.sequence = sequence
    end
    if version ~= nil then
      msgParam.version = version
    end
    if serverid ~= nil then
      msgParam.serverid = serverid
    end
    if deviceid ~= nil then
      msgParam.deviceid = deviceid
    end
    if ip ~= nil then
      msgParam.ip = ip
    end
    if realzoneid ~= nil then
      msgParam.realzoneid = realzoneid
    end
    if eye ~= nil then
      msgParam.eye = eye
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallSnapShotUserCmd(data, lastselect, deletechar, deletecdtime, maincharid, area, firstcreatechar)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.SnapShotUserCmd()
    if data ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.data == nil then
        msg.data = {}
      end
      for i = 1, #data do
        table.insert(msg.data, data[i])
      end
    end
    if lastselect ~= nil then
      msg.lastselect = lastselect
    end
    if deletechar ~= nil then
      msg.deletechar = deletechar
    end
    if deletecdtime ~= nil then
      msg.deletecdtime = deletecdtime
    end
    if maincharid ~= nil then
      msg.maincharid = maincharid
    end
    if area ~= nil then
      msg.area = area
    end
    if firstcreatechar ~= nil then
      msg.firstcreatechar = firstcreatechar
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SnapShotUserCmd.id
    local msgParam = {}
    if data ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.data == nil then
        msgParam.data = {}
      end
      for i = 1, #data do
        table.insert(msgParam.data, data[i])
      end
    end
    if lastselect ~= nil then
      msgParam.lastselect = lastselect
    end
    if deletechar ~= nil then
      msgParam.deletechar = deletechar
    end
    if deletecdtime ~= nil then
      msgParam.deletecdtime = deletecdtime
    end
    if maincharid ~= nil then
      msgParam.maincharid = maincharid
    end
    if area ~= nil then
      msgParam.area = area
    end
    if firstcreatechar ~= nil then
      msgParam.firstcreatechar = firstcreatechar
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallSelectRoleUserCmd(id, zoneID, accid, deviceid, name, version, extraData, ignorepwd, password, resettime, language, realauthorized, maxbaselv, pushkey, clickpos, serverid, relogin, ip, super, extra, validcharids, langzone, clientversion, lastest_clientversion, fingerprint, tradeforbid, proxyid, syslanguage)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.SelectRoleUserCmd()
    if msg == nil then
      msg = {}
    end
    msg.id = id
    if zoneID ~= nil then
      msg.zoneID = zoneID
    end
    if accid ~= nil then
      msg.accid = accid
    end
    if deviceid ~= nil then
      msg.deviceid = deviceid
    end
    if name ~= nil then
      msg.name = name
    end
    if version ~= nil then
      msg.version = version
    end
    if extraData ~= nil and extraData.phone ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.extraData == nil then
        msg.extraData = {}
      end
      msg.extraData.phone = extraData.phone
    end
    if extraData ~= nil and extraData.safedevice ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.extraData == nil then
        msg.extraData = {}
      end
      msg.extraData.safedevice = extraData.safedevice
    end
    if extraData ~= nil and extraData.system ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.extraData == nil then
        msg.extraData = {}
      end
      msg.extraData.system = extraData.system
    end
    if extraData ~= nil and extraData.model ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.extraData == nil then
        msg.extraData = {}
      end
      msg.extraData.model = extraData.model
    end
    if extraData ~= nil and extraData.version ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.extraData == nil then
        msg.extraData = {}
      end
      msg.extraData.version = extraData.version
    end
    if extraData ~= nil and extraData.codeVersion ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.extraData == nil then
        msg.extraData = {}
      end
      msg.extraData.codeVersion = extraData.codeVersion
    end
    if extraData ~= nil and extraData.fingerprint ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.extraData == nil then
        msg.extraData = {}
      end
      msg.extraData.fingerprint = extraData.fingerprint
    end
    if ignorepwd ~= nil then
      msg.ignorepwd = ignorepwd
    end
    if password ~= nil then
      msg.password = password
    end
    if resettime ~= nil then
      msg.resettime = resettime
    end
    if language ~= nil then
      msg.language = language
    end
    if realauthorized ~= nil then
      msg.realauthorized = realauthorized
    end
    if maxbaselv ~= nil then
      msg.maxbaselv = maxbaselv
    end
    if pushkey ~= nil then
      msg.pushkey = pushkey
    end
    if clickpos ~= nil then
      msg.clickpos = clickpos
    end
    if serverid ~= nil then
      msg.serverid = serverid
    end
    if relogin ~= nil then
      msg.relogin = relogin
    end
    if ip ~= nil then
      msg.ip = ip
    end
    if super ~= nil then
      msg.super = super
    end
    if extra ~= nil then
      msg.extra = extra
    end
    if validcharids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.validcharids == nil then
        msg.validcharids = {}
      end
      for i = 1, #validcharids do
        table.insert(msg.validcharids, validcharids[i])
      end
    end
    if langzone ~= nil then
      msg.langzone = langzone
    end
    if clientversion ~= nil then
      msg.clientversion = clientversion
    end
    if lastest_clientversion ~= nil then
      msg.lastest_clientversion = lastest_clientversion
    end
    if fingerprint ~= nil then
      msg.fingerprint = fingerprint
    end
    if tradeforbid ~= nil then
      msg.tradeforbid = tradeforbid
    end
    if proxyid ~= nil then
      msg.proxyid = proxyid
    end
    if syslanguage ~= nil then
      msg.syslanguage = syslanguage
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SelectRoleUserCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.id = id
    if zoneID ~= nil then
      msgParam.zoneID = zoneID
    end
    if accid ~= nil then
      msgParam.accid = accid
    end
    if deviceid ~= nil then
      msgParam.deviceid = deviceid
    end
    if name ~= nil then
      msgParam.name = name
    end
    if version ~= nil then
      msgParam.version = version
    end
    if extraData ~= nil and extraData.phone ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.extraData == nil then
        msgParam.extraData = {}
      end
      msgParam.extraData.phone = extraData.phone
    end
    if extraData ~= nil and extraData.safedevice ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.extraData == nil then
        msgParam.extraData = {}
      end
      msgParam.extraData.safedevice = extraData.safedevice
    end
    if extraData ~= nil and extraData.system ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.extraData == nil then
        msgParam.extraData = {}
      end
      msgParam.extraData.system = extraData.system
    end
    if extraData ~= nil and extraData.model ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.extraData == nil then
        msgParam.extraData = {}
      end
      msgParam.extraData.model = extraData.model
    end
    if extraData ~= nil and extraData.version ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.extraData == nil then
        msgParam.extraData = {}
      end
      msgParam.extraData.version = extraData.version
    end
    if extraData ~= nil and extraData.codeVersion ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.extraData == nil then
        msgParam.extraData = {}
      end
      msgParam.extraData.codeVersion = extraData.codeVersion
    end
    if extraData ~= nil and extraData.fingerprint ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.extraData == nil then
        msgParam.extraData = {}
      end
      msgParam.extraData.fingerprint = extraData.fingerprint
    end
    if ignorepwd ~= nil then
      msgParam.ignorepwd = ignorepwd
    end
    if password ~= nil then
      msgParam.password = password
    end
    if resettime ~= nil then
      msgParam.resettime = resettime
    end
    if language ~= nil then
      msgParam.language = language
    end
    if realauthorized ~= nil then
      msgParam.realauthorized = realauthorized
    end
    if maxbaselv ~= nil then
      msgParam.maxbaselv = maxbaselv
    end
    if pushkey ~= nil then
      msgParam.pushkey = pushkey
    end
    if clickpos ~= nil then
      msgParam.clickpos = clickpos
    end
    if serverid ~= nil then
      msgParam.serverid = serverid
    end
    if relogin ~= nil then
      msgParam.relogin = relogin
    end
    if ip ~= nil then
      msgParam.ip = ip
    end
    if super ~= nil then
      msgParam.super = super
    end
    if extra ~= nil then
      msgParam.extra = extra
    end
    if validcharids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.validcharids == nil then
        msgParam.validcharids = {}
      end
      for i = 1, #validcharids do
        table.insert(msgParam.validcharids, validcharids[i])
      end
    end
    if langzone ~= nil then
      msgParam.langzone = langzone
    end
    if clientversion ~= nil then
      msgParam.clientversion = clientversion
    end
    if lastest_clientversion ~= nil then
      msgParam.lastest_clientversion = lastest_clientversion
    end
    if fingerprint ~= nil then
      msgParam.fingerprint = fingerprint
    end
    if tradeforbid ~= nil then
      msgParam.tradeforbid = tradeforbid
    end
    if proxyid ~= nil then
      msgParam.proxyid = proxyid
    end
    if syslanguage ~= nil then
      msgParam.syslanguage = syslanguage
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallLoginResultUserCmd(ret)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.LoginResultUserCmd()
    if msg == nil then
      msg = {}
    end
    msg.ret = ret
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.LoginResultUserCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.ret = ret
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallDeleteCharUserCmd(id, accid, version, serverid)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.DeleteCharUserCmd()
    if id ~= nil then
      msg.id = id
    end
    if accid ~= nil then
      msg.accid = accid
    end
    if version ~= nil then
      msg.version = version
    end
    if serverid ~= nil then
      msg.serverid = serverid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DeleteCharUserCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if accid ~= nil then
      msgParam.accid = accid
    end
    if version ~= nil then
      msgParam.version = version
    end
    if serverid ~= nil then
      msgParam.serverid = serverid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallHeartBeatUserCmd(time)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.HeartBeatUserCmd()
    if time ~= nil then
      msg.time = time
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HeartBeatUserCmd.id
    local msgParam = {}
    if time ~= nil then
      msgParam.time = time
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallServerTimeUserCmd(time, timeZone)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.ServerTimeUserCmd()
    if time ~= nil then
      msg.time = time
    end
    if timeZone ~= nil then
      msg.timeZone = timeZone
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ServerTimeUserCmd.id
    local msgParam = {}
    if time ~= nil then
      msgParam.time = time
    end
    if timeZone ~= nil then
      msgParam.timeZone = timeZone
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallGMDeleteCharUserCmd(accid, zoneid)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.GMDeleteCharUserCmd()
    if accid ~= nil then
      msg.accid = accid
    end
    if zoneid ~= nil then
      msg.zoneid = zoneid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GMDeleteCharUserCmd.id
    local msgParam = {}
    if accid ~= nil then
      msgParam.accid = accid
    end
    if zoneid ~= nil then
      msgParam.zoneid = zoneid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallClientInfoUserCmd(ip, delay, cmddelay, cmdno)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.ClientInfoUserCmd()
    if ip ~= nil then
      msg.ip = ip
    end
    if delay ~= nil then
      msg.delay = delay
    end
    if cmddelay ~= nil then
      msg.cmddelay = cmddelay
    end
    if cmdno ~= nil then
      msg.cmdno = cmdno
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ClientInfoUserCmd.id
    local msgParam = {}
    if ip ~= nil then
      msgParam.ip = ip
    end
    if delay ~= nil then
      msgParam.delay = delay
    end
    if cmddelay ~= nil then
      msgParam.cmddelay = cmddelay
    end
    if cmdno ~= nil then
      msgParam.cmdno = cmdno
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallReqLoginUserCmd(accid, sha1, zoneid, timestamp, version, domain, ip, device, phone, safe_device, language, site, authorize, serverid, deviceid, clientversion, langzone, fingerprint, syslanguage)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.ReqLoginUserCmd()
    if accid ~= nil then
      msg.accid = accid
    end
    if sha1 ~= nil then
      msg.sha1 = sha1
    end
    if zoneid ~= nil then
      msg.zoneid = zoneid
    end
    if timestamp ~= nil then
      msg.timestamp = timestamp
    end
    if version ~= nil then
      msg.version = version
    end
    if domain ~= nil then
      msg.domain = domain
    end
    if ip ~= nil then
      msg.ip = ip
    end
    if device ~= nil then
      msg.device = device
    end
    if phone ~= nil then
      msg.phone = phone
    end
    if safe_device ~= nil then
      msg.safe_device = safe_device
    end
    if language ~= nil then
      msg.language = language
    end
    if site ~= nil then
      msg.site = site
    end
    if authorize ~= nil then
      msg.authorize = authorize
    end
    if serverid ~= nil then
      msg.serverid = serverid
    end
    if deviceid ~= nil then
      msg.deviceid = deviceid
    end
    if clientversion ~= nil then
      msg.clientversion = clientversion
    end
    if langzone ~= nil then
      msg.langzone = langzone
    end
    if fingerprint ~= nil then
      msg.fingerprint = fingerprint
    end
    if syslanguage ~= nil then
      msg.syslanguage = syslanguage
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqLoginUserCmd.id
    local msgParam = {}
    if accid ~= nil then
      msgParam.accid = accid
    end
    if sha1 ~= nil then
      msgParam.sha1 = sha1
    end
    if zoneid ~= nil then
      msgParam.zoneid = zoneid
    end
    if timestamp ~= nil then
      msgParam.timestamp = timestamp
    end
    if version ~= nil then
      msgParam.version = version
    end
    if domain ~= nil then
      msgParam.domain = domain
    end
    if ip ~= nil then
      msgParam.ip = ip
    end
    if device ~= nil then
      msgParam.device = device
    end
    if phone ~= nil then
      msgParam.phone = phone
    end
    if safe_device ~= nil then
      msgParam.safe_device = safe_device
    end
    if language ~= nil then
      msgParam.language = language
    end
    if site ~= nil then
      msgParam.site = site
    end
    if authorize ~= nil then
      msgParam.authorize = authorize
    end
    if serverid ~= nil then
      msgParam.serverid = serverid
    end
    if deviceid ~= nil then
      msgParam.deviceid = deviceid
    end
    if clientversion ~= nil then
      msgParam.clientversion = clientversion
    end
    if langzone ~= nil then
      msgParam.langzone = langzone
    end
    if fingerprint ~= nil then
      msgParam.fingerprint = fingerprint
    end
    if syslanguage ~= nil then
      msgParam.syslanguage = syslanguage
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallReqLoginParamUserCmd(accid, sha1, timestamp, phone, version)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.ReqLoginParamUserCmd()
    if accid ~= nil then
      msg.accid = accid
    end
    if sha1 ~= nil then
      msg.sha1 = sha1
    end
    if timestamp ~= nil then
      msg.timestamp = timestamp
    end
    if phone ~= nil then
      msg.phone = phone
    end
    if version ~= nil then
      msg.version = version
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqLoginParamUserCmd.id
    local msgParam = {}
    if accid ~= nil then
      msgParam.accid = accid
    end
    if sha1 ~= nil then
      msgParam.sha1 = sha1
    end
    if timestamp ~= nil then
      msgParam.timestamp = timestamp
    end
    if phone ~= nil then
      msgParam.phone = phone
    end
    if version ~= nil then
      msgParam.version = version
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallKickParamUserCmd(charid, accid, afktime)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.KickParamUserCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if accid ~= nil then
      msg.accid = accid
    end
    if afktime ~= nil then
      msg.afktime = afktime
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.KickParamUserCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if accid ~= nil then
      msgParam.accid = accid
    end
    if afktime ~= nil then
      msgParam.afktime = afktime
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallCancelDeleteCharUserCmd(id, accid)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.CancelDeleteCharUserCmd()
    if id ~= nil then
      msg.id = id
    end
    if accid ~= nil then
      msg.accid = accid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.CancelDeleteCharUserCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    if accid ~= nil then
      msgParam.accid = accid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallClientFrameUserCmd(frame)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.ClientFrameUserCmd()
    if frame ~= nil then
      msg.frame = frame
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ClientFrameUserCmd.id
    local msgParam = {}
    if frame ~= nil then
      msgParam.frame = frame
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallSafeDeviceUserCmd(safe)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.SafeDeviceUserCmd()
    if safe ~= nil then
      msg.safe = safe
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SafeDeviceUserCmd.id
    local msgParam = {}
    if safe ~= nil then
      msgParam.safe = safe
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallConfirmAuthorizeUserCmd(password, success, resettime, hasset)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.ConfirmAuthorizeUserCmd()
    if password ~= nil then
      msg.password = password
    end
    if success ~= nil then
      msg.success = success
    end
    if resettime ~= nil then
      msg.resettime = resettime
    end
    if hasset ~= nil then
      msg.hasset = hasset
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ConfirmAuthorizeUserCmd.id
    local msgParam = {}
    if password ~= nil then
      msgParam.password = password
    end
    if success ~= nil then
      msgParam.success = success
    end
    if resettime ~= nil then
      msgParam.resettime = resettime
    end
    if hasset ~= nil then
      msgParam.hasset = hasset
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallSyncAuthorizeGateCmd(ignorepwd, password, version, accid, resettime, serverid)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.SyncAuthorizeGateCmd()
    if ignorepwd ~= nil then
      msg.ignorepwd = ignorepwd
    end
    if password ~= nil then
      msg.password = password
    end
    if version ~= nil then
      msg.version = version
    end
    if accid ~= nil then
      msg.accid = accid
    end
    if resettime ~= nil then
      msg.resettime = resettime
    end
    if serverid ~= nil then
      msg.serverid = serverid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncAuthorizeGateCmd.id
    local msgParam = {}
    if ignorepwd ~= nil then
      msgParam.ignorepwd = ignorepwd
    end
    if password ~= nil then
      msgParam.password = password
    end
    if version ~= nil then
      msgParam.version = version
    end
    if accid ~= nil then
      msgParam.accid = accid
    end
    if resettime ~= nil then
      msgParam.resettime = resettime
    end
    if serverid ~= nil then
      msgParam.serverid = serverid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallRealAuthorizeUserCmd(authoriz_state, authorized)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.RealAuthorizeUserCmd()
    if authoriz_state ~= nil then
      msg.authoriz_state = authoriz_state
    end
    if authorized ~= nil then
      msg.authorized = authorized
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RealAuthorizeUserCmd.id
    local msgParam = {}
    if authoriz_state ~= nil then
      msgParam.authoriz_state = authoriz_state
    end
    if authorized ~= nil then
      msgParam.authorized = authorized
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallRealAuthorizeServerCmd(authorized)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.RealAuthorizeServerCmd()
    if authorized ~= nil then
      msg.authorized = authorized
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RealAuthorizeServerCmd.id
    local msgParam = {}
    if authorized ~= nil then
      msgParam.authorized = authorized
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallRefreshZoneIDUserCmd(charid, accid, zoneid, realzoneid, serverid)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.RefreshZoneIDUserCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if accid ~= nil then
      msg.accid = accid
    end
    if zoneid ~= nil then
      msg.zoneid = zoneid
    end
    if realzoneid ~= nil then
      msg.realzoneid = realzoneid
    end
    if serverid ~= nil then
      msg.serverid = serverid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.RefreshZoneIDUserCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if accid ~= nil then
      msgParam.accid = accid
    end
    if zoneid ~= nil then
      msgParam.zoneid = zoneid
    end
    if realzoneid ~= nil then
      msgParam.realzoneid = realzoneid
    end
    if serverid ~= nil then
      msgParam.serverid = serverid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallQueryAfkStatUserCmd(charid, afktime, statdata)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.QueryAfkStatUserCmd()
    if charid ~= nil then
      msg.charid = charid
    end
    if afktime ~= nil then
      msg.afktime = afktime
    end
    if statdata ~= nil and statdata.baseexp ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.statdata == nil then
        msg.statdata = {}
      end
      msg.statdata.baseexp = statdata.baseexp
    end
    if statdata ~= nil and statdata.jobexp ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.statdata == nil then
        msg.statdata = {}
      end
      msg.statdata.jobexp = statdata.jobexp
    end
    if statdata ~= nil and statdata.items ~= nil then
      if msg.statdata == nil then
        msg.statdata = {}
      end
      if msg.statdata.items == nil then
        msg.statdata.items = {}
      end
      for i = 1, #statdata.items do
        table.insert(msg.statdata.items, statdata.items[i])
      end
    end
    if statdata ~= nil and statdata.moneys ~= nil then
      if msg.statdata == nil then
        msg.statdata = {}
      end
      if msg.statdata.moneys == nil then
        msg.statdata.moneys = {}
      end
      for i = 1, #statdata.moneys do
        table.insert(msg.statdata.moneys, statdata.moneys[i])
      end
    end
    if statdata ~= nil and statdata.extra_zeny ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.statdata == nil then
        msg.statdata = {}
      end
      msg.statdata.extra_zeny = statdata.extra_zeny
    end
    if statdata ~= nil and statdata.extra_base ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.statdata == nil then
        msg.statdata = {}
      end
      msg.statdata.extra_base = statdata.extra_base
    end
    if statdata ~= nil and statdata.extra_job ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.statdata == nil then
        msg.statdata = {}
      end
      msg.statdata.extra_job = statdata.extra_job
    end
    if statdata ~= nil and statdata.extra_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.statdata == nil then
        msg.statdata = {}
      end
      msg.statdata.extra_time = statdata.extra_time
    end
    if statdata ~= nil and statdata.killinfo ~= nil then
      if msg.statdata == nil then
        msg.statdata = {}
      end
      if msg.statdata.killinfo == nil then
        msg.statdata.killinfo = {}
      end
      for i = 1, #statdata.killinfo do
        table.insert(msg.statdata.killinfo, statdata.killinfo[i])
      end
    end
    if statdata ~= nil and statdata.be_killinfo ~= nil then
      if msg.statdata == nil then
        msg.statdata = {}
      end
      if msg.statdata.be_killinfo == nil then
        msg.statdata.be_killinfo = {}
      end
      for i = 1, #statdata.be_killinfo do
        table.insert(msg.statdata.be_killinfo, statdata.be_killinfo[i])
      end
    end
    if statdata.battle_time ~= nil and statdata.battle_time.totaltime ~= nil then
      if msg.statdata == nil then
        msg.statdata = {}
      end
      if msg.statdata.battle_time == nil then
        msg.statdata.battle_time = {}
      end
      msg.statdata.battle_time.totaltime = statdata.battle_time.totaltime
    end
    if statdata.battle_time ~= nil and statdata.battle_time.usedtime ~= nil then
      if msg.statdata == nil then
        msg.statdata = {}
      end
      if msg.statdata.battle_time == nil then
        msg.statdata.battle_time = {}
      end
      msg.statdata.battle_time.usedtime = statdata.battle_time.usedtime
    end
    if statdata.battle_time ~= nil and statdata.battle_time.estatus ~= nil then
      if msg.statdata == nil then
        msg.statdata = {}
      end
      if msg.statdata.battle_time == nil then
        msg.statdata.battle_time = {}
      end
      msg.statdata.battle_time.estatus = statdata.battle_time.estatus
    end
    if statdata ~= nil and statdata.estatus ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.statdata == nil then
        msg.statdata = {}
      end
      msg.statdata.estatus = statdata.estatus
    end
    if statdata ~= nil and statdata.timelen ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.statdata == nil then
        msg.statdata = {}
      end
      msg.statdata.timelen = statdata.timelen
    end
    if statdata ~= nil and statdata.kill_count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.statdata == nil then
        msg.statdata = {}
      end
      msg.statdata.kill_count = statdata.kill_count
    end
    if statdata ~= nil and statdata.left_afk_count ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.statdata == nil then
        msg.statdata = {}
      end
      msg.statdata.left_afk_count = statdata.left_afk_count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryAfkStatUserCmd.id
    local msgParam = {}
    if charid ~= nil then
      msgParam.charid = charid
    end
    if afktime ~= nil then
      msgParam.afktime = afktime
    end
    if statdata ~= nil and statdata.baseexp ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      msgParam.statdata.baseexp = statdata.baseexp
    end
    if statdata ~= nil and statdata.jobexp ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      msgParam.statdata.jobexp = statdata.jobexp
    end
    if statdata ~= nil and statdata.items ~= nil then
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      if msgParam.statdata.items == nil then
        msgParam.statdata.items = {}
      end
      for i = 1, #statdata.items do
        table.insert(msgParam.statdata.items, statdata.items[i])
      end
    end
    if statdata ~= nil and statdata.moneys ~= nil then
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      if msgParam.statdata.moneys == nil then
        msgParam.statdata.moneys = {}
      end
      for i = 1, #statdata.moneys do
        table.insert(msgParam.statdata.moneys, statdata.moneys[i])
      end
    end
    if statdata ~= nil and statdata.extra_zeny ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      msgParam.statdata.extra_zeny = statdata.extra_zeny
    end
    if statdata ~= nil and statdata.extra_base ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      msgParam.statdata.extra_base = statdata.extra_base
    end
    if statdata ~= nil and statdata.extra_job ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      msgParam.statdata.extra_job = statdata.extra_job
    end
    if statdata ~= nil and statdata.extra_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      msgParam.statdata.extra_time = statdata.extra_time
    end
    if statdata ~= nil and statdata.killinfo ~= nil then
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      if msgParam.statdata.killinfo == nil then
        msgParam.statdata.killinfo = {}
      end
      for i = 1, #statdata.killinfo do
        table.insert(msgParam.statdata.killinfo, statdata.killinfo[i])
      end
    end
    if statdata ~= nil and statdata.be_killinfo ~= nil then
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      if msgParam.statdata.be_killinfo == nil then
        msgParam.statdata.be_killinfo = {}
      end
      for i = 1, #statdata.be_killinfo do
        table.insert(msgParam.statdata.be_killinfo, statdata.be_killinfo[i])
      end
    end
    if statdata.battle_time ~= nil and statdata.battle_time.totaltime ~= nil then
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      if msgParam.statdata.battle_time == nil then
        msgParam.statdata.battle_time = {}
      end
      msgParam.statdata.battle_time.totaltime = statdata.battle_time.totaltime
    end
    if statdata.battle_time ~= nil and statdata.battle_time.usedtime ~= nil then
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      if msgParam.statdata.battle_time == nil then
        msgParam.statdata.battle_time = {}
      end
      msgParam.statdata.battle_time.usedtime = statdata.battle_time.usedtime
    end
    if statdata.battle_time ~= nil and statdata.battle_time.estatus ~= nil then
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      if msgParam.statdata.battle_time == nil then
        msgParam.statdata.battle_time = {}
      end
      msgParam.statdata.battle_time.estatus = statdata.battle_time.estatus
    end
    if statdata ~= nil and statdata.estatus ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      msgParam.statdata.estatus = statdata.estatus
    end
    if statdata ~= nil and statdata.timelen ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      msgParam.statdata.timelen = statdata.timelen
    end
    if statdata ~= nil and statdata.kill_count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      msgParam.statdata.kill_count = statdata.kill_count
    end
    if statdata ~= nil and statdata.left_afk_count ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.statdata == nil then
        msgParam.statdata = {}
      end
      msgParam.statdata.left_afk_count = statdata.left_afk_count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallKickCharUserCmd(force, versions)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.KickCharUserCmd()
    if force ~= nil then
      msg.force = force
    end
    if versions ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.versions == nil then
        msg.versions = {}
      end
      for i = 1, #versions do
        table.insert(msg.versions, versions[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.KickCharUserCmd.id
    local msgParam = {}
    if force ~= nil then
      msgParam.force = force
    end
    if versions ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.versions == nil then
        msgParam.versions = {}
      end
      for i = 1, #versions do
        table.insert(msgParam.versions, versions[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallOfflineDetectUserCmd(eventid, time, param1, param2)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.OfflineDetectUserCmd()
    if eventid ~= nil then
      msg.eventid = eventid
    end
    if time ~= nil then
      msg.time = time
    end
    if param1 ~= nil then
      msg.param1 = param1
    end
    if param2 ~= nil then
      msg.param2 = param2
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OfflineDetectUserCmd.id
    local msgParam = {}
    if eventid ~= nil then
      msgParam.eventid = eventid
    end
    if time ~= nil then
      msgParam.time = time
    end
    if param1 ~= nil then
      msgParam.param1 = param1
    end
    if param2 ~= nil then
      msgParam.param2 = param2
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallDeviceInfoUserCmd(deviceid, items)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.DeviceInfoUserCmd()
    if deviceid ~= nil then
      msg.deviceid = deviceid
    end
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.DeviceInfoUserCmd.id
    local msgParam = {}
    if deviceid ~= nil then
      msgParam.deviceid = deviceid
    end
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallAttachLoginUserCmd(accid, time, sign, charid)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.AttachLoginUserCmd()
    if accid ~= nil then
      msg.accid = accid
    end
    if time ~= nil then
      msg.time = time
    end
    if sign ~= nil then
      msg.sign = sign
    end
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AttachLoginUserCmd.id
    local msgParam = {}
    if accid ~= nil then
      msgParam.accid = accid
    end
    if time ~= nil then
      msgParam.time = time
    end
    if sign ~= nil then
      msgParam.sign = sign
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallAttachSyncCmdUserCmd(dcmd, dparam, data)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.AttachSyncCmdUserCmd()
    if dcmd ~= nil then
      msg.dcmd = dcmd
    end
    if dparam ~= nil then
      msg.dparam = dparam
    end
    if data ~= nil then
      msg.data = data
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AttachSyncCmdUserCmd.id
    local msgParam = {}
    if dcmd ~= nil then
      msgParam.dcmd = dcmd
    end
    if dparam ~= nil then
      msgParam.dparam = dparam
    end
    if data ~= nil then
      msgParam.data = data
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallPingUserCmd()
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.PingUserCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PingUserCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallSetMaxScopeUserCmd(num)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.SetMaxScopeUserCmd()
    if num ~= nil then
      msg.num = num
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SetMaxScopeUserCmd.id
    local msgParam = {}
    if num ~= nil then
      msgParam.num = num
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:CallReqLoginOutGateCmd(accid)
  if not NetConfig.PBC then
    local msg = LoginUserCmd_pb.ReqLoginOutGateCmd()
    if accid ~= nil then
      msg.accid = accid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqLoginOutGateCmd.id
    local msgParam = {}
    if accid ~= nil then
      msgParam.accid = accid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceLoginUserCmdAutoProxy:RecvRegResultUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdRegResultUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvCreateCharUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdCreateCharUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvSnapShotUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdSnapShotUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvSelectRoleUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdSelectRoleUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvLoginResultUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdLoginResultUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvDeleteCharUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdDeleteCharUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvHeartBeatUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdHeartBeatUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvServerTimeUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdServerTimeUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvGMDeleteCharUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdGMDeleteCharUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvClientInfoUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdClientInfoUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvReqLoginUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdReqLoginUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvReqLoginParamUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdReqLoginParamUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvKickParamUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdKickParamUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvCancelDeleteCharUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdCancelDeleteCharUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvClientFrameUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdClientFrameUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvSafeDeviceUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdSafeDeviceUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvConfirmAuthorizeUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdConfirmAuthorizeUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvSyncAuthorizeGateCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdSyncAuthorizeGateCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvRealAuthorizeUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdRealAuthorizeUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvRealAuthorizeServerCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdRealAuthorizeServerCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvRefreshZoneIDUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdRefreshZoneIDUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvQueryAfkStatUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdQueryAfkStatUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvKickCharUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdKickCharUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvOfflineDetectUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdOfflineDetectUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvDeviceInfoUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdDeviceInfoUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvAttachLoginUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdAttachLoginUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvAttachSyncCmdUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdAttachSyncCmdUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvPingUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdPingUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvSetMaxScopeUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdSetMaxScopeUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvReqLoginOutGateCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdReqLoginOutGateCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.LoginUserCmdRegResultUserCmd = "ServiceEvent_LoginUserCmdRegResultUserCmd"
ServiceEvent.LoginUserCmdCreateCharUserCmd = "ServiceEvent_LoginUserCmdCreateCharUserCmd"
ServiceEvent.LoginUserCmdSnapShotUserCmd = "ServiceEvent_LoginUserCmdSnapShotUserCmd"
ServiceEvent.LoginUserCmdSelectRoleUserCmd = "ServiceEvent_LoginUserCmdSelectRoleUserCmd"
ServiceEvent.LoginUserCmdLoginResultUserCmd = "ServiceEvent_LoginUserCmdLoginResultUserCmd"
ServiceEvent.LoginUserCmdDeleteCharUserCmd = "ServiceEvent_LoginUserCmdDeleteCharUserCmd"
ServiceEvent.LoginUserCmdHeartBeatUserCmd = "ServiceEvent_LoginUserCmdHeartBeatUserCmd"
ServiceEvent.LoginUserCmdServerTimeUserCmd = "ServiceEvent_LoginUserCmdServerTimeUserCmd"
ServiceEvent.LoginUserCmdGMDeleteCharUserCmd = "ServiceEvent_LoginUserCmdGMDeleteCharUserCmd"
ServiceEvent.LoginUserCmdClientInfoUserCmd = "ServiceEvent_LoginUserCmdClientInfoUserCmd"
ServiceEvent.LoginUserCmdReqLoginUserCmd = "ServiceEvent_LoginUserCmdReqLoginUserCmd"
ServiceEvent.LoginUserCmdReqLoginParamUserCmd = "ServiceEvent_LoginUserCmdReqLoginParamUserCmd"
ServiceEvent.LoginUserCmdKickParamUserCmd = "ServiceEvent_LoginUserCmdKickParamUserCmd"
ServiceEvent.LoginUserCmdCancelDeleteCharUserCmd = "ServiceEvent_LoginUserCmdCancelDeleteCharUserCmd"
ServiceEvent.LoginUserCmdClientFrameUserCmd = "ServiceEvent_LoginUserCmdClientFrameUserCmd"
ServiceEvent.LoginUserCmdSafeDeviceUserCmd = "ServiceEvent_LoginUserCmdSafeDeviceUserCmd"
ServiceEvent.LoginUserCmdConfirmAuthorizeUserCmd = "ServiceEvent_LoginUserCmdConfirmAuthorizeUserCmd"
ServiceEvent.LoginUserCmdSyncAuthorizeGateCmd = "ServiceEvent_LoginUserCmdSyncAuthorizeGateCmd"
ServiceEvent.LoginUserCmdRealAuthorizeUserCmd = "ServiceEvent_LoginUserCmdRealAuthorizeUserCmd"
ServiceEvent.LoginUserCmdRealAuthorizeServerCmd = "ServiceEvent_LoginUserCmdRealAuthorizeServerCmd"
ServiceEvent.LoginUserCmdRefreshZoneIDUserCmd = "ServiceEvent_LoginUserCmdRefreshZoneIDUserCmd"
ServiceEvent.LoginUserCmdQueryAfkStatUserCmd = "ServiceEvent_LoginUserCmdQueryAfkStatUserCmd"
ServiceEvent.LoginUserCmdKickCharUserCmd = "ServiceEvent_LoginUserCmdKickCharUserCmd"
ServiceEvent.LoginUserCmdOfflineDetectUserCmd = "ServiceEvent_LoginUserCmdOfflineDetectUserCmd"
ServiceEvent.LoginUserCmdDeviceInfoUserCmd = "ServiceEvent_LoginUserCmdDeviceInfoUserCmd"
ServiceEvent.LoginUserCmdAttachLoginUserCmd = "ServiceEvent_LoginUserCmdAttachLoginUserCmd"
ServiceEvent.LoginUserCmdAttachSyncCmdUserCmd = "ServiceEvent_LoginUserCmdAttachSyncCmdUserCmd"
ServiceEvent.LoginUserCmdPingUserCmd = "ServiceEvent_LoginUserCmdPingUserCmd"
ServiceEvent.LoginUserCmdSetMaxScopeUserCmd = "ServiceEvent_LoginUserCmdSetMaxScopeUserCmd"
ServiceEvent.LoginUserCmdReqLoginOutGateCmd = "ServiceEvent_LoginUserCmdReqLoginOutGateCmd"
