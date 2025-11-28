ServiceNoviceNotebookAutoProxy = class("ServiceNoviceNotebookAutoProxy", ServiceProxy)
ServiceNoviceNotebookAutoProxy.Instance = nil
ServiceNoviceNotebookAutoProxy.NAME = "ServiceNoviceNotebookAutoProxy"

function ServiceNoviceNotebookAutoProxy:ctor(proxyName)
  if ServiceNoviceNotebookAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceNoviceNotebookAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceNoviceNotebookAutoProxy.Instance = self
  end
end

function ServiceNoviceNotebookAutoProxy:Init()
end

function ServiceNoviceNotebookAutoProxy:onRegister()
  self:Listen(231, 5, function(data)
    self:RecvNoviceNotebookLastPosCmd(data)
  end)
  self:Listen(231, 1, function(data)
    self:RecvNoviceNotebookCmd(data)
  end)
  self:Listen(231, 2, function(data)
    self:RecvNoviceNotebookCoverOpenCmd(data)
  end)
  self:Listen(231, 3, function(data)
    self:RecvNoviceNotebookReadPageCmd(data)
  end)
  self:Listen(231, 4, function(data)
    self:RecvNoviceNotebookReceiveAwardCmd(data)
  end)
end

function ServiceNoviceNotebookAutoProxy:CallNoviceNotebookLastPosCmd(global_activity_id, last_pos)
  if not NetConfig.PBC then
    local msg = NoviceNotebook_pb.NoviceNotebookLastPosCmd()
    if global_activity_id ~= nil then
      msg.global_activity_id = global_activity_id
    end
    if last_pos ~= nil and last_pos.chapter_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.last_pos == nil then
        msg.last_pos = {}
      end
      msg.last_pos.chapter_id = last_pos.chapter_id
    end
    if last_pos ~= nil and last_pos.page_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.last_pos == nil then
        msg.last_pos = {}
      end
      msg.last_pos.page_id = last_pos.page_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NoviceNotebookLastPosCmd.id
    local msgParam = {}
    if global_activity_id ~= nil then
      msgParam.global_activity_id = global_activity_id
    end
    if last_pos ~= nil and last_pos.chapter_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.last_pos == nil then
        msgParam.last_pos = {}
      end
      msgParam.last_pos.chapter_id = last_pos.chapter_id
    end
    if last_pos ~= nil and last_pos.page_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.last_pos == nil then
        msgParam.last_pos = {}
      end
      msgParam.last_pos.page_id = last_pos.page_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNoviceNotebookAutoProxy:CallNoviceNotebookCmd(global_activity_id, is_cover_unlock, chapters, reward_state, last_pos)
  if not NetConfig.PBC then
    local msg = NoviceNotebook_pb.NoviceNotebookCmd()
    if global_activity_id ~= nil then
      msg.global_activity_id = global_activity_id
    end
    if is_cover_unlock ~= nil then
      msg.is_cover_unlock = is_cover_unlock
    end
    if chapters ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.chapters == nil then
        msg.chapters = {}
      end
      for i = 1, #chapters do
        table.insert(msg.chapters, chapters[i])
      end
    end
    if reward_state ~= nil then
      msg.reward_state = reward_state
    end
    if last_pos ~= nil and last_pos.chapter_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.last_pos == nil then
        msg.last_pos = {}
      end
      msg.last_pos.chapter_id = last_pos.chapter_id
    end
    if last_pos ~= nil and last_pos.page_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.last_pos == nil then
        msg.last_pos = {}
      end
      msg.last_pos.page_id = last_pos.page_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NoviceNotebookCmd.id
    local msgParam = {}
    if global_activity_id ~= nil then
      msgParam.global_activity_id = global_activity_id
    end
    if is_cover_unlock ~= nil then
      msgParam.is_cover_unlock = is_cover_unlock
    end
    if chapters ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.chapters == nil then
        msgParam.chapters = {}
      end
      for i = 1, #chapters do
        table.insert(msgParam.chapters, chapters[i])
      end
    end
    if reward_state ~= nil then
      msgParam.reward_state = reward_state
    end
    if last_pos ~= nil and last_pos.chapter_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.last_pos == nil then
        msgParam.last_pos = {}
      end
      msgParam.last_pos.chapter_id = last_pos.chapter_id
    end
    if last_pos ~= nil and last_pos.page_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.last_pos == nil then
        msgParam.last_pos = {}
      end
      msgParam.last_pos.page_id = last_pos.page_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNoviceNotebookAutoProxy:CallNoviceNotebookCoverOpenCmd(global_activity_id)
  if not NetConfig.PBC then
    local msg = NoviceNotebook_pb.NoviceNotebookCoverOpenCmd()
    if global_activity_id ~= nil then
      msg.global_activity_id = global_activity_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NoviceNotebookCoverOpenCmd.id
    local msgParam = {}
    if global_activity_id ~= nil then
      msgParam.global_activity_id = global_activity_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNoviceNotebookAutoProxy:CallNoviceNotebookReadPageCmd(global_activity_id, chapter_id, page_id)
  if not NetConfig.PBC then
    local msg = NoviceNotebook_pb.NoviceNotebookReadPageCmd()
    if global_activity_id ~= nil then
      msg.global_activity_id = global_activity_id
    end
    if chapter_id ~= nil then
      msg.chapter_id = chapter_id
    end
    if page_id ~= nil then
      msg.page_id = page_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NoviceNotebookReadPageCmd.id
    local msgParam = {}
    if global_activity_id ~= nil then
      msgParam.global_activity_id = global_activity_id
    end
    if chapter_id ~= nil then
      msgParam.chapter_id = chapter_id
    end
    if page_id ~= nil then
      msgParam.page_id = page_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNoviceNotebookAutoProxy:CallNoviceNotebookReceiveAwardCmd(global_activity_id)
  if not NetConfig.PBC then
    local msg = NoviceNotebook_pb.NoviceNotebookReceiveAwardCmd()
    if global_activity_id ~= nil then
      msg.global_activity_id = global_activity_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.NoviceNotebookReceiveAwardCmd.id
    local msgParam = {}
    if global_activity_id ~= nil then
      msgParam.global_activity_id = global_activity_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceNoviceNotebookAutoProxy:RecvNoviceNotebookLastPosCmd(data)
  self:Notify(ServiceEvent.NoviceNotebookNoviceNotebookLastPosCmd, data)
end

function ServiceNoviceNotebookAutoProxy:RecvNoviceNotebookCmd(data)
  self:Notify(ServiceEvent.NoviceNotebookNoviceNotebookCmd, data)
end

function ServiceNoviceNotebookAutoProxy:RecvNoviceNotebookCoverOpenCmd(data)
  self:Notify(ServiceEvent.NoviceNotebookNoviceNotebookCoverOpenCmd, data)
end

function ServiceNoviceNotebookAutoProxy:RecvNoviceNotebookReadPageCmd(data)
  self:Notify(ServiceEvent.NoviceNotebookNoviceNotebookReadPageCmd, data)
end

function ServiceNoviceNotebookAutoProxy:RecvNoviceNotebookReceiveAwardCmd(data)
  self:Notify(ServiceEvent.NoviceNotebookNoviceNotebookReceiveAwardCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.NoviceNotebookNoviceNotebookLastPosCmd = "ServiceEvent_NoviceNotebookNoviceNotebookLastPosCmd"
ServiceEvent.NoviceNotebookNoviceNotebookCmd = "ServiceEvent_NoviceNotebookNoviceNotebookCmd"
ServiceEvent.NoviceNotebookNoviceNotebookCoverOpenCmd = "ServiceEvent_NoviceNotebookNoviceNotebookCoverOpenCmd"
ServiceEvent.NoviceNotebookNoviceNotebookReadPageCmd = "ServiceEvent_NoviceNotebookNoviceNotebookReadPageCmd"
ServiceEvent.NoviceNotebookNoviceNotebookReceiveAwardCmd = "ServiceEvent_NoviceNotebookNoviceNotebookReceiveAwardCmd"
