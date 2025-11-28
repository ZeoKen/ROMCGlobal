ServiceSceneInterlocutionAutoProxy = class("ServiceSceneInterlocutionAutoProxy", ServiceProxy)
ServiceSceneInterlocutionAutoProxy.Instance = nil
ServiceSceneInterlocutionAutoProxy.NAME = "ServiceSceneInterlocutionAutoProxy"

function ServiceSceneInterlocutionAutoProxy:ctor(proxyName)
  if ServiceSceneInterlocutionAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSceneInterlocutionAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSceneInterlocutionAutoProxy.Instance = self
  end
end

function ServiceSceneInterlocutionAutoProxy:Init()
end

function ServiceSceneInterlocutionAutoProxy:onRegister()
  self:Listen(22, 1, function(data)
    self:RecvNewInter(data)
  end)
  self:Listen(22, 2, function(data)
    self:RecvAnswer(data)
  end)
  self:Listen(22, 3, function(data)
    self:RecvQuery(data)
  end)
  self:Listen(22, 4, function(data)
    self:RecvQueryPaperResultInterCmd(data)
  end)
  self:Listen(22, 5, function(data)
    self:RecvPaperQuestionInterCmd(data)
  end)
  self:Listen(22, 6, function(data)
    self:RecvPaperResultInterCmd(data)
  end)
end

function ServiceSceneInterlocutionAutoProxy:CallNewInter(inter, npcid, answerid)
  if not NetConfig.PBC then
    local msg = SceneInterlocution_pb.NewInter()
    if inter ~= nil and inter.guid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.inter == nil then
        msg.inter = {}
      end
      msg.inter.guid = inter.guid
    end
    if inter ~= nil and inter.interid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.inter == nil then
        msg.inter = {}
      end
      msg.inter.interid = inter.interid
    end
    if inter ~= nil and inter.paramid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.inter == nil then
        msg.inter = {}
      end
      msg.inter.paramid = inter.paramid
    end
    if inter ~= nil and inter.source ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.inter == nil then
        msg.inter = {}
      end
      msg.inter.source = inter.source
    end
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if answerid ~= nil then
      msg.answerid = answerid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NewInter.id
    local msgParam = {}
    if inter ~= nil and inter.guid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.inter == nil then
        msgParam.inter = {}
      end
      msgParam.inter.guid = inter.guid
    end
    if inter ~= nil and inter.interid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.inter == nil then
        msgParam.inter = {}
      end
      msgParam.inter.interid = inter.interid
    end
    if inter ~= nil and inter.paramid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.inter == nil then
        msgParam.inter = {}
      end
      msgParam.inter.paramid = inter.paramid
    end
    if inter ~= nil and inter.source ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.inter == nil then
        msgParam.inter = {}
      end
      msgParam.inter.source = inter.source
    end
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if answerid ~= nil then
      msgParam.answerid = answerid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneInterlocutionAutoProxy:CallAnswer(npcid, guid, interid, source, answer, correct, paramid)
  if not NetConfig.PBC then
    local msg = SceneInterlocution_pb.Answer()
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if guid ~= nil then
      msg.guid = guid
    end
    if interid ~= nil then
      msg.interid = interid
    end
    if source ~= nil then
      msg.source = source
    end
    if answer ~= nil then
      msg.answer = answer
    end
    if correct ~= nil then
      msg.correct = correct
    end
    if paramid ~= nil then
      msg.paramid = paramid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.Answer.id
    local msgParam = {}
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if guid ~= nil then
      msgParam.guid = guid
    end
    if interid ~= nil then
      msgParam.interid = interid
    end
    if source ~= nil then
      msgParam.source = source
    end
    if answer ~= nil then
      msgParam.answer = answer
    end
    if correct ~= nil then
      msgParam.correct = correct
    end
    if paramid ~= nil then
      msgParam.paramid = paramid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneInterlocutionAutoProxy:CallQuery(npcid, ret)
  if not NetConfig.PBC then
    local msg = SceneInterlocution_pb.Query()
    if npcid ~= nil then
      msg.npcid = npcid
    end
    if ret ~= nil then
      msg.ret = ret
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.Query.id
    local msgParam = {}
    if npcid ~= nil then
      msgParam.npcid = npcid
    end
    if ret ~= nil then
      msgParam.ret = ret
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneInterlocutionAutoProxy:CallQueryPaperResultInterCmd(datas)
  if not NetConfig.PBC then
    local msg = SceneInterlocution_pb.QueryPaperResultInterCmd()
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
    local msgId = ProtoReqInfoList.QueryPaperResultInterCmd.id
    local msgParam = {}
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

function ServiceSceneInterlocutionAutoProxy:CallPaperQuestionInterCmd(id)
  if not NetConfig.PBC then
    local msg = SceneInterlocution_pb.PaperQuestionInterCmd()
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PaperQuestionInterCmd.id
    local msgParam = {}
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneInterlocutionAutoProxy:CallPaperResultInterCmd(result)
  if not NetConfig.PBC then
    local msg = SceneInterlocution_pb.PaperResultInterCmd()
    if result ~= nil and result.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.result == nil then
        msg.result = {}
      end
      msg.result.id = result.id
    end
    if result ~= nil and result.result ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.result == nil then
        msg.result = {}
      end
      msg.result.result = result.result
    end
    if result ~= nil and result.source ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.result == nil then
        msg.result = {}
      end
      msg.result.source = result.source
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PaperResultInterCmd.id
    local msgParam = {}
    if result ~= nil and result.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.result == nil then
        msgParam.result = {}
      end
      msgParam.result.id = result.id
    end
    if result ~= nil and result.result ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.result == nil then
        msgParam.result = {}
      end
      msgParam.result.result = result.result
    end
    if result ~= nil and result.source ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.result == nil then
        msgParam.result = {}
      end
      msgParam.result.source = result.source
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneInterlocutionAutoProxy:RecvNewInter(data)
  self:Notify(ServiceEvent.SceneInterlocutionNewInter, data)
end

function ServiceSceneInterlocutionAutoProxy:RecvAnswer(data)
  self:Notify(ServiceEvent.SceneInterlocutionAnswer, data)
end

function ServiceSceneInterlocutionAutoProxy:RecvQuery(data)
  self:Notify(ServiceEvent.SceneInterlocutionQuery, data)
end

function ServiceSceneInterlocutionAutoProxy:RecvQueryPaperResultInterCmd(data)
  self:Notify(ServiceEvent.SceneInterlocutionQueryPaperResultInterCmd, data)
end

function ServiceSceneInterlocutionAutoProxy:RecvPaperQuestionInterCmd(data)
  self:Notify(ServiceEvent.SceneInterlocutionPaperQuestionInterCmd, data)
end

function ServiceSceneInterlocutionAutoProxy:RecvPaperResultInterCmd(data)
  self:Notify(ServiceEvent.SceneInterlocutionPaperResultInterCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.SceneInterlocutionNewInter = "ServiceEvent_SceneInterlocutionNewInter"
ServiceEvent.SceneInterlocutionAnswer = "ServiceEvent_SceneInterlocutionAnswer"
ServiceEvent.SceneInterlocutionQuery = "ServiceEvent_SceneInterlocutionQuery"
ServiceEvent.SceneInterlocutionQueryPaperResultInterCmd = "ServiceEvent_SceneInterlocutionQueryPaperResultInterCmd"
ServiceEvent.SceneInterlocutionPaperQuestionInterCmd = "ServiceEvent_SceneInterlocutionPaperQuestionInterCmd"
ServiceEvent.SceneInterlocutionPaperResultInterCmd = "ServiceEvent_SceneInterlocutionPaperResultInterCmd"
