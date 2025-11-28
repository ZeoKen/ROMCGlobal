ServiceSceneBeingAutoProxy = class("ServiceSceneBeingAutoProxy", ServiceProxy)
ServiceSceneBeingAutoProxy.Instance = nil
ServiceSceneBeingAutoProxy.NAME = "ServiceSceneBeingAutoProxy"

function ServiceSceneBeingAutoProxy:ctor(proxyName)
  if ServiceSceneBeingAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSceneBeingAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSceneBeingAutoProxy.Instance = self
  end
end

function ServiceSceneBeingAutoProxy:Init()
end

function ServiceSceneBeingAutoProxy:onRegister()
  self:Listen(32, 1, function(data)
    self:RecvBeingSkillQuery(data)
  end)
  self:Listen(32, 2, function(data)
    self:RecvBeingSkillUpdate(data)
  end)
  self:Listen(32, 3, function(data)
    self:RecvBeingSkillLevelUp(data)
  end)
  self:Listen(32, 4, function(data)
    self:RecvBeingInfoQuery(data)
  end)
  self:Listen(32, 5, function(data)
    self:RecvBeingInfoUpdate(data)
  end)
  self:Listen(32, 7, function(data)
    self:RecvBeingSwitchState(data)
  end)
  self:Listen(32, 6, function(data)
    self:RecvBeingOffCmd(data)
  end)
  self:Listen(32, 8, function(data)
    self:RecvChangeBodyBeingCmd(data)
  end)
  self:Listen(32, 9, function(data)
    self:RecvBeingQueryDataPartial(data)
  end)
end

function ServiceSceneBeingAutoProxy:CallBeingSkillQuery(data)
  if not NetConfig.PBC then
    local msg = SceneBeing_pb.BeingSkillQuery()
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
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BeingSkillQuery.id
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
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneBeingAutoProxy:CallBeingSkillUpdate(update, del)
  if not NetConfig.PBC then
    local msg = SceneBeing_pb.BeingSkillUpdate()
    if update ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.update == nil then
        msg.update = {}
      end
      for i = 1, #update do
        table.insert(msg.update, update[i])
      end
    end
    if del ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.del == nil then
        msg.del = {}
      end
      for i = 1, #del do
        table.insert(msg.del, del[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BeingSkillUpdate.id
    local msgParam = {}
    if update ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.update == nil then
        msgParam.update = {}
      end
      for i = 1, #update do
        table.insert(msgParam.update, update[i])
      end
    end
    if del ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.del == nil then
        msgParam.del = {}
      end
      for i = 1, #del do
        table.insert(msgParam.del, del[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneBeingAutoProxy:CallBeingSkillLevelUp(beingid, skillids)
  if not NetConfig.PBC then
    local msg = SceneBeing_pb.BeingSkillLevelUp()
    if beingid ~= nil then
      msg.beingid = beingid
    end
    if skillids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.skillids == nil then
        msg.skillids = {}
      end
      for i = 1, #skillids do
        table.insert(msg.skillids, skillids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BeingSkillLevelUp.id
    local msgParam = {}
    if beingid ~= nil then
      msgParam.beingid = beingid
    end
    if skillids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.skillids == nil then
        msgParam.skillids = {}
      end
      for i = 1, #skillids do
        table.insert(msgParam.skillids, skillids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneBeingAutoProxy:CallBeingInfoQuery(beinginfo)
  if not NetConfig.PBC then
    local msg = SceneBeing_pb.BeingInfoQuery()
    if beinginfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.beinginfo == nil then
        msg.beinginfo = {}
      end
      for i = 1, #beinginfo do
        table.insert(msg.beinginfo, beinginfo[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BeingInfoQuery.id
    local msgParam = {}
    if beinginfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.beinginfo == nil then
        msgParam.beinginfo = {}
      end
      for i = 1, #beinginfo do
        table.insert(msgParam.beinginfo, beinginfo[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneBeingAutoProxy:CallBeingInfoUpdate(beingid, datas)
  if not NetConfig.PBC then
    local msg = SceneBeing_pb.BeingInfoUpdate()
    if msg == nil then
      msg = {}
    end
    msg.beingid = beingid
    if datas ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.datas == nil then
        msg.datas = {}
      end
      for i = 1, #datas do
        table.insert(msg.datas, datas[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BeingInfoUpdate.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.beingid = beingid
    if datas ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.datas == nil then
        msgParam.datas = {}
      end
      for i = 1, #datas do
        table.insert(msgParam.datas, datas[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneBeingAutoProxy:CallBeingSwitchState(beingid, battle)
  if not NetConfig.PBC then
    local msg = SceneBeing_pb.BeingSwitchState()
    if msg == nil then
      msg = {}
    end
    msg.beingid = beingid
    if msg == nil then
      msg = {}
    end
    msg.battle = battle
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BeingSwitchState.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.beingid = beingid
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.battle = battle
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneBeingAutoProxy:CallBeingOffCmd(beingid)
  if not NetConfig.PBC then
    local msg = SceneBeing_pb.BeingOffCmd()
    if msg == nil then
      msg = {}
    end
    msg.beingid = beingid
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BeingOffCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.beingid = beingid
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneBeingAutoProxy:CallChangeBodyBeingCmd(beingid, body)
  if not NetConfig.PBC then
    local msg = SceneBeing_pb.ChangeBodyBeingCmd()
    if msg == nil then
      msg = {}
    end
    msg.beingid = beingid
    if msg == nil then
      msg = {}
    end
    msg.body = body
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ChangeBodyBeingCmd.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.beingid = beingid
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.body = body
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneBeingAutoProxy:CallBeingQueryDataPartial(beingid, exp)
  if not NetConfig.PBC then
    local msg = SceneBeing_pb.BeingQueryDataPartial()
    if msg == nil then
      msg = {}
    end
    msg.beingid = beingid
    if exp ~= nil then
      msg.exp = exp
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BeingQueryDataPartial.id
    local msgParam = {}
    if msgParam == nil then
      msgParam = {}
    end
    msgParam.beingid = beingid
    if exp ~= nil then
      msgParam.exp = exp
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneBeingAutoProxy:RecvBeingSkillQuery(data)
  self:Notify(ServiceEvent.SceneBeingBeingSkillQuery, data)
end

function ServiceSceneBeingAutoProxy:RecvBeingSkillUpdate(data)
  self:Notify(ServiceEvent.SceneBeingBeingSkillUpdate, data)
end

function ServiceSceneBeingAutoProxy:RecvBeingSkillLevelUp(data)
  self:Notify(ServiceEvent.SceneBeingBeingSkillLevelUp, data)
end

function ServiceSceneBeingAutoProxy:RecvBeingInfoQuery(data)
  self:Notify(ServiceEvent.SceneBeingBeingInfoQuery, data)
end

function ServiceSceneBeingAutoProxy:RecvBeingInfoUpdate(data)
  self:Notify(ServiceEvent.SceneBeingBeingInfoUpdate, data)
end

function ServiceSceneBeingAutoProxy:RecvBeingSwitchState(data)
  self:Notify(ServiceEvent.SceneBeingBeingSwitchState, data)
end

function ServiceSceneBeingAutoProxy:RecvBeingOffCmd(data)
  self:Notify(ServiceEvent.SceneBeingBeingOffCmd, data)
end

function ServiceSceneBeingAutoProxy:RecvChangeBodyBeingCmd(data)
  self:Notify(ServiceEvent.SceneBeingChangeBodyBeingCmd, data)
end

function ServiceSceneBeingAutoProxy:RecvBeingQueryDataPartial(data)
  self:Notify(ServiceEvent.SceneBeingBeingQueryDataPartial, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.SceneBeingBeingSkillQuery = "ServiceEvent_SceneBeingBeingSkillQuery"
ServiceEvent.SceneBeingBeingSkillUpdate = "ServiceEvent_SceneBeingBeingSkillUpdate"
ServiceEvent.SceneBeingBeingSkillLevelUp = "ServiceEvent_SceneBeingBeingSkillLevelUp"
ServiceEvent.SceneBeingBeingInfoQuery = "ServiceEvent_SceneBeingBeingInfoQuery"
ServiceEvent.SceneBeingBeingInfoUpdate = "ServiceEvent_SceneBeingBeingInfoUpdate"
ServiceEvent.SceneBeingBeingSwitchState = "ServiceEvent_SceneBeingBeingSwitchState"
ServiceEvent.SceneBeingBeingOffCmd = "ServiceEvent_SceneBeingBeingOffCmd"
ServiceEvent.SceneBeingChangeBodyBeingCmd = "ServiceEvent_SceneBeingChangeBodyBeingCmd"
ServiceEvent.SceneBeingBeingQueryDataPartial = "ServiceEvent_SceneBeingBeingQueryDataPartial"
