ServicePuzzleCmdAutoProxy = class("ServicePuzzleCmdAutoProxy", ServiceProxy)
ServicePuzzleCmdAutoProxy.Instance = nil
ServicePuzzleCmdAutoProxy.NAME = "ServicePuzzleCmdAutoProxy"

function ServicePuzzleCmdAutoProxy:ctor(proxyName)
  if ServicePuzzleCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServicePuzzleCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServicePuzzleCmdAutoProxy.Instance = self
  end
end

function ServicePuzzleCmdAutoProxy:Init()
end

function ServicePuzzleCmdAutoProxy:onRegister()
  self:Listen(68, 1, function(data)
    self:RecvQueryActPuzzleCmd(data)
  end)
  self:Listen(68, 3, function(data)
    self:RecvPuzzleItemNtf(data)
  end)
  self:Listen(68, 4, function(data)
    self:RecvActivePuzzleCmd(data)
  end)
end

function ServicePuzzleCmdAutoProxy:CallQueryActPuzzleCmd(actitem)
  if not NetConfig.PBC then
    local msg = PuzzleCmd_pb.QueryActPuzzleCmd()
    if actitem ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.actitem == nil then
        msg.actitem = {}
      end
      for i = 1, #actitem do
        table.insert(msg.actitem, actitem[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryActPuzzleCmd.id
    local msgParam = {}
    if actitem ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.actitem == nil then
        msgParam.actitem = {}
      end
      for i = 1, #actitem do
        table.insert(msgParam.actitem, actitem[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePuzzleCmdAutoProxy:CallPuzzleItemNtf(items)
  if not NetConfig.PBC then
    local msg = PuzzleCmd_pb.PuzzleItemNtf()
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
    local msgId = ProtoReqInfoList.PuzzleItemNtf.id
    local msgParam = {}
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

function ServicePuzzleCmdAutoProxy:CallActivePuzzleCmd(actid, puzzleid)
  if not NetConfig.PBC then
    local msg = PuzzleCmd_pb.ActivePuzzleCmd()
    if actid ~= nil then
      msg.actid = actid
    end
    if puzzleid ~= nil then
      msg.puzzleid = puzzleid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActivePuzzleCmd.id
    local msgParam = {}
    if actid ~= nil then
      msgParam.actid = actid
    end
    if puzzleid ~= nil then
      msgParam.puzzleid = puzzleid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServicePuzzleCmdAutoProxy:RecvQueryActPuzzleCmd(data)
  self:Notify(ServiceEvent.PuzzleCmdQueryActPuzzleCmd, data)
end

function ServicePuzzleCmdAutoProxy:RecvPuzzleItemNtf(data)
  self:Notify(ServiceEvent.PuzzleCmdPuzzleItemNtf, data)
end

function ServicePuzzleCmdAutoProxy:RecvActivePuzzleCmd(data)
  self:Notify(ServiceEvent.PuzzleCmdActivePuzzleCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.PuzzleCmdQueryActPuzzleCmd = "ServiceEvent_PuzzleCmdQueryActPuzzleCmd"
ServiceEvent.PuzzleCmdPuzzleItemNtf = "ServiceEvent_PuzzleCmdPuzzleItemNtf"
ServiceEvent.PuzzleCmdActivePuzzleCmd = "ServiceEvent_PuzzleCmdActivePuzzleCmd"
