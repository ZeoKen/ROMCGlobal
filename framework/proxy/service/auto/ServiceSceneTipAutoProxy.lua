ServiceSceneTipAutoProxy = class("ServiceSceneTipAutoProxy", ServiceProxy)
ServiceSceneTipAutoProxy.Instance = nil
ServiceSceneTipAutoProxy.NAME = "ServiceSceneTipAutoProxy"

function ServiceSceneTipAutoProxy:ctor(proxyName)
  if ServiceSceneTipAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSceneTipAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSceneTipAutoProxy.Instance = self
  end
end

function ServiceSceneTipAutoProxy:Init()
end

function ServiceSceneTipAutoProxy:onRegister()
  self:Listen(18, 1, function(data)
    self:RecvGameTipCmd(data)
  end)
  self:Listen(18, 2, function(data)
    self:RecvBrowseRedTipCmd(data)
  end)
  self:Listen(18, 3, function(data)
    self:RecvAddRedTip(data)
  end)
end

function ServiceSceneTipAutoProxy:CallGameTipCmd(opt, redtip)
  if not NetConfig.PBC then
    local msg = SceneTip_pb.GameTipCmd()
    if opt ~= nil then
      msg.opt = opt
    end
    if redtip ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.redtip == nil then
        msg.redtip = {}
      end
      for i = 1, #redtip do
        table.insert(msg.redtip, redtip[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.GameTipCmd.id
    local msgParam = {}
    if opt ~= nil then
      msgParam.opt = opt
    end
    if redtip ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.redtip == nil then
        msgParam.redtip = {}
      end
      for i = 1, #redtip do
        table.insert(msgParam.redtip, redtip[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneTipAutoProxy:CallBrowseRedTipCmd(red, tipid)
  if not NetConfig.PBC then
    local msg = SceneTip_pb.BrowseRedTipCmd()
    if red ~= nil then
      msg.red = red
    end
    if tipid ~= nil then
      msg.tipid = tipid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BrowseRedTipCmd.id
    local msgParam = {}
    if red ~= nil then
      msgParam.red = red
    end
    if tipid ~= nil then
      msgParam.tipid = tipid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneTipAutoProxy:CallAddRedTip(red, tipid)
  if not NetConfig.PBC then
    local msg = SceneTip_pb.AddRedTip()
    if red ~= nil then
      msg.red = red
    end
    if tipid ~= nil then
      msg.tipid = tipid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AddRedTip.id
    local msgParam = {}
    if red ~= nil then
      msgParam.red = red
    end
    if tipid ~= nil then
      msgParam.tipid = tipid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneTipAutoProxy:RecvGameTipCmd(data)
  self:Notify(ServiceEvent.SceneTipGameTipCmd, data)
end

function ServiceSceneTipAutoProxy:RecvBrowseRedTipCmd(data)
  self:Notify(ServiceEvent.SceneTipBrowseRedTipCmd, data)
end

function ServiceSceneTipAutoProxy:RecvAddRedTip(data)
  self:Notify(ServiceEvent.SceneTipAddRedTip, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.SceneTipGameTipCmd = "ServiceEvent_SceneTipGameTipCmd"
ServiceEvent.SceneTipBrowseRedTipCmd = "ServiceEvent_SceneTipBrowseRedTipCmd"
ServiceEvent.SceneTipAddRedTip = "ServiceEvent_SceneTipAddRedTip"
