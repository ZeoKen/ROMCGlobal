ServiceTechTreeCmdAutoProxy = class("ServiceTechTreeCmdAutoProxy", ServiceProxy)
ServiceTechTreeCmdAutoProxy.Instance = nil
ServiceTechTreeCmdAutoProxy.NAME = "ServiceTechTreeCmdAutoProxy"

function ServiceTechTreeCmdAutoProxy:ctor(proxyName)
  if ServiceTechTreeCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceTechTreeCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceTechTreeCmdAutoProxy.Instance = self
  end
end

function ServiceTechTreeCmdAutoProxy:Init()
end

function ServiceTechTreeCmdAutoProxy:onRegister()
  self:Listen(73, 1, function(data)
    self:RecvTechTreeUnlockLeafCmd(data)
  end)
  self:Listen(73, 2, function(data)
    self:RecvTechTreeSyncLeafCmd(data)
  end)
  self:Listen(73, 3, function(data)
    self:RecvAddToyDrawingCmd(data)
  end)
  self:Listen(73, 4, function(data)
    self:RecvSyncToyDrawingCmd(data)
  end)
  self:Listen(73, 5, function(data)
    self:RecvTechTreeMakeToyCmd(data)
  end)
  self:Listen(73, 6, function(data)
    self:RecvToyTransSetPosCmd(data)
  end)
  self:Listen(73, 7, function(data)
    self:RecvTechTreeLevelAwardCmd(data)
  end)
  self:Listen(73, 8, function(data)
    self:RecvTechTreeProduceCollectCmd(data)
  end)
  self:Listen(73, 9, function(data)
    self:RecvTechTreeProdecInfoCmd(data)
  end)
  self:Listen(73, 10, function(data)
    self:RecvTechTreeInjectCmd(data)
  end)
  self:Listen(73, 11, function(data)
    self:RecvTechTreeInjectInfoCmd(data)
  end)
end

function ServiceTechTreeCmdAutoProxy:CallTechTreeUnlockLeafCmd(leaf, treeid, nodeinfo)
  if not NetConfig.PBC then
    local msg = TechTreeCmd_pb.TechTreeUnlockLeafCmd()
    if leaf ~= nil and leaf.leafid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.leaf == nil then
        msg.leaf = {}
      end
      msg.leaf.leafid = leaf.leafid
    end
    if leaf ~= nil and leaf.level ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.leaf == nil then
        msg.leaf = {}
      end
      msg.leaf.level = leaf.level
    end
    if treeid ~= nil then
      msg.treeid = treeid
    end
    if nodeinfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.nodeinfo == nil then
        msg.nodeinfo = {}
      end
      for i = 1, #nodeinfo do
        table.insert(msg.nodeinfo, nodeinfo[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TechTreeUnlockLeafCmd.id
    local msgParam = {}
    if leaf ~= nil and leaf.leafid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.leaf == nil then
        msgParam.leaf = {}
      end
      msgParam.leaf.leafid = leaf.leafid
    end
    if leaf ~= nil and leaf.level ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.leaf == nil then
        msgParam.leaf = {}
      end
      msgParam.leaf.level = leaf.level
    end
    if treeid ~= nil then
      msgParam.treeid = treeid
    end
    if nodeinfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.nodeinfo == nil then
        msgParam.nodeinfo = {}
      end
      for i = 1, #nodeinfo do
        table.insert(msgParam.nodeinfo, nodeinfo[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTechTreeCmdAutoProxy:CallTechTreeSyncLeafCmd(leaves, treeinfo)
  if not NetConfig.PBC then
    local msg = TechTreeCmd_pb.TechTreeSyncLeafCmd()
    if leaves ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.leaves == nil then
        msg.leaves = {}
      end
      for i = 1, #leaves do
        table.insert(msg.leaves, leaves[i])
      end
    end
    if treeinfo ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.treeinfo == nil then
        msg.treeinfo = {}
      end
      for i = 1, #treeinfo do
        table.insert(msg.treeinfo, treeinfo[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TechTreeSyncLeafCmd.id
    local msgParam = {}
    if leaves ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.leaves == nil then
        msgParam.leaves = {}
      end
      for i = 1, #leaves do
        table.insert(msgParam.leaves, leaves[i])
      end
    end
    if treeinfo ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.treeinfo == nil then
        msgParam.treeinfo = {}
      end
      for i = 1, #treeinfo do
        table.insert(msgParam.treeinfo, treeinfo[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTechTreeCmdAutoProxy:CallAddToyDrawingCmd(drawingid)
  if not NetConfig.PBC then
    local msg = TechTreeCmd_pb.AddToyDrawingCmd()
    if drawingid ~= nil then
      msg.drawingid = drawingid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.AddToyDrawingCmd.id
    local msgParam = {}
    if drawingid ~= nil then
      msgParam.drawingid = drawingid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTechTreeCmdAutoProxy:CallSyncToyDrawingCmd(drawings)
  if not NetConfig.PBC then
    local msg = TechTreeCmd_pb.SyncToyDrawingCmd()
    if drawings ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.drawings == nil then
        msg.drawings = {}
      end
      for i = 1, #drawings do
        table.insert(msg.drawings, drawings[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SyncToyDrawingCmd.id
    local msgParam = {}
    if drawings ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.drawings == nil then
        msgParam.drawings = {}
      end
      for i = 1, #drawings do
        table.insert(msgParam.drawings, drawings[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTechTreeCmdAutoProxy:CallTechTreeMakeToyCmd(drawingid, count)
  if not NetConfig.PBC then
    local msg = TechTreeCmd_pb.TechTreeMakeToyCmd()
    if drawingid ~= nil then
      msg.drawingid = drawingid
    end
    if count ~= nil then
      msg.count = count
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TechTreeMakeToyCmd.id
    local msgParam = {}
    if drawingid ~= nil then
      msgParam.drawingid = drawingid
    end
    if count ~= nil then
      msgParam.count = count
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTechTreeCmdAutoProxy:CallToyTransSetPosCmd(pos)
  if not NetConfig.PBC then
    local msg = TechTreeCmd_pb.ToyTransSetPosCmd()
    if pos ~= nil and pos.x ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.x = pos.x
    end
    if pos ~= nil and pos.y ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.y = pos.y
    end
    if pos ~= nil and pos.z ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.pos == nil then
        msg.pos = {}
      end
      msg.pos.z = pos.z
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ToyTransSetPosCmd.id
    local msgParam = {}
    if pos ~= nil and pos.x ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.x = pos.x
    end
    if pos ~= nil and pos.y ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.y = pos.y
    end
    if pos ~= nil and pos.z ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.pos == nil then
        msgParam.pos = {}
      end
      msgParam.pos.z = pos.z
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTechTreeCmdAutoProxy:CallTechTreeLevelAwardCmd(treeid, levelnode)
  if not NetConfig.PBC then
    local msg = TechTreeCmd_pb.TechTreeLevelAwardCmd()
    if treeid ~= nil then
      msg.treeid = treeid
    end
    if levelnode ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.levelnode == nil then
        msg.levelnode = {}
      end
      for i = 1, #levelnode do
        table.insert(msg.levelnode, levelnode[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TechTreeLevelAwardCmd.id
    local msgParam = {}
    if treeid ~= nil then
      msgParam.treeid = treeid
    end
    if levelnode ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.levelnode == nil then
        msgParam.levelnode = {}
      end
      for i = 1, #levelnode do
        table.insert(msgParam.levelnode, levelnode[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTechTreeCmdAutoProxy:CallTechTreeProduceCollectCmd(success)
  if not NetConfig.PBC then
    local msg = TechTreeCmd_pb.TechTreeProduceCollectCmd()
    if success ~= nil then
      msg.success = success
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TechTreeProduceCollectCmd.id
    local msgParam = {}
    if success ~= nil then
      msgParam.success = success
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTechTreeCmdAutoProxy:CallTechTreeProdecInfoCmd(producenum, produceupperlimit, prodecespeed, firstopen)
  if not NetConfig.PBC then
    local msg = TechTreeCmd_pb.TechTreeProdecInfoCmd()
    if producenum ~= nil then
      msg.producenum = producenum
    end
    if produceupperlimit ~= nil then
      msg.produceupperlimit = produceupperlimit
    end
    if prodecespeed ~= nil then
      msg.prodecespeed = prodecespeed
    end
    if firstopen ~= nil then
      msg.firstopen = firstopen
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TechTreeProdecInfoCmd.id
    local msgParam = {}
    if producenum ~= nil then
      msgParam.producenum = producenum
    end
    if produceupperlimit ~= nil then
      msgParam.produceupperlimit = produceupperlimit
    end
    if prodecespeed ~= nil then
      msgParam.prodecespeed = prodecespeed
    end
    if firstopen ~= nil then
      msgParam.firstopen = firstopen
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTechTreeCmdAutoProxy:CallTechTreeInjectCmd(treeid, leafnode, inject_num)
  if not NetConfig.PBC then
    local msg = TechTreeCmd_pb.TechTreeInjectCmd()
    if treeid ~= nil then
      msg.treeid = treeid
    end
    if leafnode ~= nil then
      msg.leafnode = leafnode
    end
    if inject_num ~= nil then
      msg.inject_num = inject_num
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TechTreeInjectCmd.id
    local msgParam = {}
    if treeid ~= nil then
      msgParam.treeid = treeid
    end
    if leafnode ~= nil then
      msgParam.leafnode = leafnode
    end
    if inject_num ~= nil then
      msgParam.inject_num = inject_num
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTechTreeCmdAutoProxy:CallTechTreeInjectInfoCmd(treeid, leafnode, injected_num, is_first_open)
  if not NetConfig.PBC then
    local msg = TechTreeCmd_pb.TechTreeInjectInfoCmd()
    if treeid ~= nil then
      msg.treeid = treeid
    end
    if leafnode ~= nil then
      msg.leafnode = leafnode
    end
    if injected_num ~= nil then
      msg.injected_num = injected_num
    end
    if is_first_open ~= nil then
      msg.is_first_open = is_first_open
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.TechTreeInjectInfoCmd.id
    local msgParam = {}
    if treeid ~= nil then
      msgParam.treeid = treeid
    end
    if leafnode ~= nil then
      msgParam.leafnode = leafnode
    end
    if injected_num ~= nil then
      msgParam.injected_num = injected_num
    end
    if is_first_open ~= nil then
      msgParam.is_first_open = is_first_open
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceTechTreeCmdAutoProxy:RecvTechTreeUnlockLeafCmd(data)
  self:Notify(ServiceEvent.TechTreeCmdTechTreeUnlockLeafCmd, data)
end

function ServiceTechTreeCmdAutoProxy:RecvTechTreeSyncLeafCmd(data)
  self:Notify(ServiceEvent.TechTreeCmdTechTreeSyncLeafCmd, data)
end

function ServiceTechTreeCmdAutoProxy:RecvAddToyDrawingCmd(data)
  self:Notify(ServiceEvent.TechTreeCmdAddToyDrawingCmd, data)
end

function ServiceTechTreeCmdAutoProxy:RecvSyncToyDrawingCmd(data)
  self:Notify(ServiceEvent.TechTreeCmdSyncToyDrawingCmd, data)
end

function ServiceTechTreeCmdAutoProxy:RecvTechTreeMakeToyCmd(data)
  self:Notify(ServiceEvent.TechTreeCmdTechTreeMakeToyCmd, data)
end

function ServiceTechTreeCmdAutoProxy:RecvToyTransSetPosCmd(data)
  self:Notify(ServiceEvent.TechTreeCmdToyTransSetPosCmd, data)
end

function ServiceTechTreeCmdAutoProxy:RecvTechTreeLevelAwardCmd(data)
  self:Notify(ServiceEvent.TechTreeCmdTechTreeLevelAwardCmd, data)
end

function ServiceTechTreeCmdAutoProxy:RecvTechTreeProduceCollectCmd(data)
  self:Notify(ServiceEvent.TechTreeCmdTechTreeProduceCollectCmd, data)
end

function ServiceTechTreeCmdAutoProxy:RecvTechTreeProdecInfoCmd(data)
  self:Notify(ServiceEvent.TechTreeCmdTechTreeProdecInfoCmd, data)
end

function ServiceTechTreeCmdAutoProxy:RecvTechTreeInjectCmd(data)
  self:Notify(ServiceEvent.TechTreeCmdTechTreeInjectCmd, data)
end

function ServiceTechTreeCmdAutoProxy:RecvTechTreeInjectInfoCmd(data)
  self:Notify(ServiceEvent.TechTreeCmdTechTreeInjectInfoCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.TechTreeCmdTechTreeUnlockLeafCmd = "ServiceEvent_TechTreeCmdTechTreeUnlockLeafCmd"
ServiceEvent.TechTreeCmdTechTreeSyncLeafCmd = "ServiceEvent_TechTreeCmdTechTreeSyncLeafCmd"
ServiceEvent.TechTreeCmdAddToyDrawingCmd = "ServiceEvent_TechTreeCmdAddToyDrawingCmd"
ServiceEvent.TechTreeCmdSyncToyDrawingCmd = "ServiceEvent_TechTreeCmdSyncToyDrawingCmd"
ServiceEvent.TechTreeCmdTechTreeMakeToyCmd = "ServiceEvent_TechTreeCmdTechTreeMakeToyCmd"
ServiceEvent.TechTreeCmdToyTransSetPosCmd = "ServiceEvent_TechTreeCmdToyTransSetPosCmd"
ServiceEvent.TechTreeCmdTechTreeLevelAwardCmd = "ServiceEvent_TechTreeCmdTechTreeLevelAwardCmd"
ServiceEvent.TechTreeCmdTechTreeProduceCollectCmd = "ServiceEvent_TechTreeCmdTechTreeProduceCollectCmd"
ServiceEvent.TechTreeCmdTechTreeProdecInfoCmd = "ServiceEvent_TechTreeCmdTechTreeProdecInfoCmd"
ServiceEvent.TechTreeCmdTechTreeInjectCmd = "ServiceEvent_TechTreeCmdTechTreeInjectCmd"
ServiceEvent.TechTreeCmdTechTreeInjectInfoCmd = "ServiceEvent_TechTreeCmdTechTreeInjectInfoCmd"
