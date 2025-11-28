ServiceActMiniRoCmdAutoProxy = class("ServiceActMiniRoCmdAutoProxy", ServiceProxy)
ServiceActMiniRoCmdAutoProxy.Instance = nil
ServiceActMiniRoCmdAutoProxy.NAME = "ServiceActMiniRoCmdAutoProxy"

function ServiceActMiniRoCmdAutoProxy:ctor(proxyName)
  if ServiceActMiniRoCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceActMiniRoCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceActMiniRoCmdAutoProxy.Instance = self
  end
end

function ServiceActMiniRoCmdAutoProxy:Init()
end

function ServiceActMiniRoCmdAutoProxy:onRegister()
  self:Listen(229, 1, function(data)
    self:RecvActMiniRoOpenPage(data)
  end)
  self:Listen(229, 2, function(data)
    self:RecvActMiniRoCastDice(data)
  end)
  self:Listen(229, 4, function(data)
    self:RecvActMiniRoDiceSync(data)
  end)
  self:Listen(229, 3, function(data)
    self:RecvActMiniRoGetOneKey(data)
  end)
  self:Listen(229, 5, function(data)
    self:RecvActMiniRoEventFAQS(data)
  end)
  self:Listen(229, 6, function(data)
    self:RecvActMiniRoCheckCircleReward(data)
  end)
end

function ServiceActMiniRoCmdAutoProxy:CallActMiniRoOpenPage(curindex, circles, onetimerewards, dayfirst, dices, dicefree, unanswerqid, dialoginfo)
  if not NetConfig.PBC then
    local msg = ActMiniRoCmd_pb.ActMiniRoOpenPage()
    if curindex ~= nil then
      msg.curindex = curindex
    end
    if circles ~= nil then
      msg.circles = circles
    end
    if onetimerewards ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.onetimerewards == nil then
        msg.onetimerewards = {}
      end
      for i = 1, #onetimerewards do
        table.insert(msg.onetimerewards, onetimerewards[i])
      end
    end
    if dayfirst ~= nil then
      msg.dayfirst = dayfirst
    end
    if dices ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dices == nil then
        msg.dices = {}
      end
      for i = 1, #dices do
        table.insert(msg.dices, dices[i])
      end
    end
    if dicefree ~= nil and dicefree.store ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dicefree == nil then
        msg.dicefree = {}
      end
      msg.dicefree.store = dicefree.store
    end
    if dicefree ~= nil and dicefree.storemax ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dicefree == nil then
        msg.dicefree = {}
      end
      msg.dicefree.storemax = dicefree.storemax
    end
    if dicefree ~= nil and dicefree.nexttimestamp ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dicefree == nil then
        msg.dicefree = {}
      end
      msg.dicefree.nexttimestamp = dicefree.nexttimestamp
    end
    if unanswerqid ~= nil then
      msg.unanswerqid = unanswerqid
    end
    if dialoginfo ~= nil and dialoginfo.step ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dialoginfo == nil then
        msg.dialoginfo = {}
      end
      msg.dialoginfo.step = dialoginfo.step
    end
    if dialoginfo ~= nil and dialoginfo.dialogid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dialoginfo == nil then
        msg.dialoginfo = {}
      end
      msg.dialoginfo.dialogid = dialoginfo.dialogid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActMiniRoOpenPage.id
    local msgParam = {}
    if curindex ~= nil then
      msgParam.curindex = curindex
    end
    if circles ~= nil then
      msgParam.circles = circles
    end
    if onetimerewards ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.onetimerewards == nil then
        msgParam.onetimerewards = {}
      end
      for i = 1, #onetimerewards do
        table.insert(msgParam.onetimerewards, onetimerewards[i])
      end
    end
    if dayfirst ~= nil then
      msgParam.dayfirst = dayfirst
    end
    if dices ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dices == nil then
        msgParam.dices = {}
      end
      for i = 1, #dices do
        table.insert(msgParam.dices, dices[i])
      end
    end
    if dicefree ~= nil and dicefree.store ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dicefree == nil then
        msgParam.dicefree = {}
      end
      msgParam.dicefree.store = dicefree.store
    end
    if dicefree ~= nil and dicefree.storemax ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dicefree == nil then
        msgParam.dicefree = {}
      end
      msgParam.dicefree.storemax = dicefree.storemax
    end
    if dicefree ~= nil and dicefree.nexttimestamp ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dicefree == nil then
        msgParam.dicefree = {}
      end
      msgParam.dicefree.nexttimestamp = dicefree.nexttimestamp
    end
    if unanswerqid ~= nil then
      msgParam.unanswerqid = unanswerqid
    end
    if dialoginfo ~= nil and dialoginfo.step ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dialoginfo == nil then
        msgParam.dialoginfo = {}
      end
      msgParam.dialoginfo.step = dialoginfo.step
    end
    if dialoginfo ~= nil and dialoginfo.dialogid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dialoginfo == nil then
        msgParam.dialoginfo = {}
      end
      msgParam.dialoginfo.dialogid = dialoginfo.dialogid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceActMiniRoCmdAutoProxy:CallActMiniRoCastDice(type, step)
  if not NetConfig.PBC then
    local msg = ActMiniRoCmd_pb.ActMiniRoCastDice()
    if type ~= nil then
      msg.type = type
    end
    if step ~= nil then
      msg.step = step
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActMiniRoCastDice.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if step ~= nil then
      msgParam.step = step
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceActMiniRoCmdAutoProxy:CallActMiniRoDiceSync(dicesync)
  if not NetConfig.PBC then
    local msg = ActMiniRoCmd_pb.ActMiniRoDiceSync()
    if dicesync ~= nil and dicesync.store ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dicesync == nil then
        msg.dicesync = {}
      end
      msg.dicesync.store = dicesync.store
    end
    if dicesync ~= nil and dicesync.storemax ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dicesync == nil then
        msg.dicesync = {}
      end
      msg.dicesync.storemax = dicesync.storemax
    end
    if dicesync ~= nil and dicesync.nexttimestamp ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dicesync == nil then
        msg.dicesync = {}
      end
      msg.dicesync.nexttimestamp = dicesync.nexttimestamp
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActMiniRoDiceSync.id
    local msgParam = {}
    if dicesync ~= nil and dicesync.store ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dicesync == nil then
        msgParam.dicesync = {}
      end
      msgParam.dicesync.store = dicesync.store
    end
    if dicesync ~= nil and dicesync.storemax ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dicesync == nil then
        msgParam.dicesync = {}
      end
      msgParam.dicesync.storemax = dicesync.storemax
    end
    if dicesync ~= nil and dicesync.nexttimestamp ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dicesync == nil then
        msgParam.dicesync = {}
      end
      msgParam.dicesync.nexttimestamp = dicesync.nexttimestamp
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceActMiniRoCmdAutoProxy:CallActMiniRoGetOneKey()
  if not NetConfig.PBC then
    local msg = ActMiniRoCmd_pb.ActMiniRoGetOneKey()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActMiniRoGetOneKey.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceActMiniRoCmdAutoProxy:CallActMiniRoEventFAQS(questionid, answer, result)
  if not NetConfig.PBC then
    local msg = ActMiniRoCmd_pb.ActMiniRoEventFAQS()
    if questionid ~= nil then
      msg.questionid = questionid
    end
    if answer ~= nil then
      msg.answer = answer
    end
    if result ~= nil then
      msg.result = result
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActMiniRoEventFAQS.id
    local msgParam = {}
    if questionid ~= nil then
      msgParam.questionid = questionid
    end
    if answer ~= nil then
      msgParam.answer = answer
    end
    if result ~= nil then
      msgParam.result = result
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceActMiniRoCmdAutoProxy:CallActMiniRoCheckCircleReward()
  if not NetConfig.PBC then
    local msg = ActMiniRoCmd_pb.ActMiniRoCheckCircleReward()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ActMiniRoCheckCircleReward.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceActMiniRoCmdAutoProxy:RecvActMiniRoOpenPage(data)
  self:Notify(ServiceEvent.ActMiniRoCmdActMiniRoOpenPage, data)
end

function ServiceActMiniRoCmdAutoProxy:RecvActMiniRoCastDice(data)
  self:Notify(ServiceEvent.ActMiniRoCmdActMiniRoCastDice, data)
end

function ServiceActMiniRoCmdAutoProxy:RecvActMiniRoDiceSync(data)
  self:Notify(ServiceEvent.ActMiniRoCmdActMiniRoDiceSync, data)
end

function ServiceActMiniRoCmdAutoProxy:RecvActMiniRoGetOneKey(data)
  self:Notify(ServiceEvent.ActMiniRoCmdActMiniRoGetOneKey, data)
end

function ServiceActMiniRoCmdAutoProxy:RecvActMiniRoEventFAQS(data)
  self:Notify(ServiceEvent.ActMiniRoCmdActMiniRoEventFAQS, data)
end

function ServiceActMiniRoCmdAutoProxy:RecvActMiniRoCheckCircleReward(data)
  self:Notify(ServiceEvent.ActMiniRoCmdActMiniRoCheckCircleReward, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.ActMiniRoCmdActMiniRoOpenPage = "ServiceEvent_ActMiniRoCmdActMiniRoOpenPage"
ServiceEvent.ActMiniRoCmdActMiniRoCastDice = "ServiceEvent_ActMiniRoCmdActMiniRoCastDice"
ServiceEvent.ActMiniRoCmdActMiniRoDiceSync = "ServiceEvent_ActMiniRoCmdActMiniRoDiceSync"
ServiceEvent.ActMiniRoCmdActMiniRoGetOneKey = "ServiceEvent_ActMiniRoCmdActMiniRoGetOneKey"
ServiceEvent.ActMiniRoCmdActMiniRoEventFAQS = "ServiceEvent_ActMiniRoCmdActMiniRoEventFAQS"
ServiceEvent.ActMiniRoCmdActMiniRoCheckCircleReward = "ServiceEvent_ActMiniRoCmdActMiniRoCheckCircleReward"
