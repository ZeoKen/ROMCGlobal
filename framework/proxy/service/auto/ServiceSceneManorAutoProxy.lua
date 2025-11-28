ServiceSceneManorAutoProxy = class("ServiceSceneManorAutoProxy", ServiceProxy)
ServiceSceneManorAutoProxy.Instance = nil
ServiceSceneManorAutoProxy.NAME = "ServiceSceneManorAutoProxy"

function ServiceSceneManorAutoProxy:ctor(proxyName)
  if ServiceSceneManorAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSceneManorAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSceneManorAutoProxy.Instance = self
  end
end

function ServiceSceneManorAutoProxy:Init()
end

function ServiceSceneManorAutoProxy:onRegister()
  self:Listen(233, 1, function(data)
    self:RecvBuildDataNtfManorCmd(data)
  end)
  self:Listen(233, 2, function(data)
    self:RecvBuildQueryManorCmd(data)
  end)
  self:Listen(233, 3, function(data)
    self:RecvBuildLevelUpManorCmd(data)
  end)
  self:Listen(233, 4, function(data)
    self:RecvBuildDispatchManorCmd(data)
  end)
  self:Listen(233, 5, function(data)
    self:RecvBuildLotteryManorCmd(data)
  end)
  self:Listen(233, 6, function(data)
    self:RecvBuildCollectManorCmd(data)
  end)
  self:Listen(233, 7, function(data)
    self:RecvReqEnterRaidManorCmd(data)
  end)
  self:Listen(233, 8, function(data)
    self:RecvPartnerInfoManorCmd(data)
  end)
  self:Listen(233, 9, function(data)
    self:RecvPartnerStroyManorCmd(data)
  end)
  self:Listen(233, 10, function(data)
    self:RecvPartnerIdleListManorCmd(data)
  end)
  self:Listen(233, 11, function(data)
    self:RecvPartnerIdleUpdateManorCmd(data)
  end)
  self:Listen(233, 12, function(data)
    self:RecvPartnerGiveManorCmd(data)
  end)
  self:Listen(233, 13, function(data)
    self:RecvBuildForgeManorCmd(data)
  end)
  self:Listen(233, 14, function(data)
    self:RecvSmithInfoManorCmd(data)
  end)
  self:Listen(233, 15, function(data)
    self:RecvSmithLevelUpManorCmd(data)
  end)
  self:Listen(233, 16, function(data)
    self:RecvSmithAcceptQuestManorCmd(data)
  end)
end

function ServiceSceneManorAutoProxy:CallBuildDataNtfManorCmd(builds)
  if not NetConfig.PBC then
    local msg = SceneManor_pb.BuildDataNtfManorCmd()
    if builds ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.builds == nil then
        msg.builds = {}
      end
      for i = 1, #builds do
        table.insert(msg.builds, builds[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuildDataNtfManorCmd.id
    local msgParam = {}
    if builds ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.builds == nil then
        msgParam.builds = {}
      end
      for i = 1, #builds do
        table.insert(msgParam.builds, builds[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManorAutoProxy:CallBuildQueryManorCmd(build)
  if not NetConfig.PBC then
    local msg = SceneManor_pb.BuildQueryManorCmd()
    if build ~= nil and build.build_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.build == nil then
        msg.build = {}
      end
      msg.build.build_id = build.build_id
    end
    if build ~= nil and build.open_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.build == nil then
        msg.build = {}
      end
      msg.build.open_time = build.open_time
    end
    if build ~= nil and build.funcs ~= nil then
      if msg.build == nil then
        msg.build = {}
      end
      if msg.build.funcs == nil then
        msg.build.funcs = {}
      end
      for i = 1, #build.funcs do
        table.insert(msg.build.funcs, build.funcs[i])
      end
    end
    if build ~= nil and build.dispatch.groups ~= nil then
      if msg.build.dispatch == nil then
        msg.build.dispatch = {}
      end
      if msg.build.dispatch.groups == nil then
        msg.build.dispatch.groups = {}
      end
      for i = 1, #build.dispatch.groups do
        table.insert(msg.build.dispatch.groups, build.dispatch.groups[i])
      end
    end
    if build ~= nil and build.dispatch.rewards ~= nil then
      if msg.build.dispatch == nil then
        msg.build.dispatch = {}
      end
      if msg.build.dispatch.rewards == nil then
        msg.build.dispatch.rewards = {}
      end
      for i = 1, #build.dispatch.rewards do
        table.insert(msg.build.dispatch.rewards, build.dispatch.rewards[i])
      end
    end
    if build ~= nil and build.lottery.ids ~= nil then
      if msg.build.lottery == nil then
        msg.build.lottery = {}
      end
      if msg.build.lottery.ids == nil then
        msg.build.lottery.ids = {}
      end
      for i = 1, #build.lottery.ids do
        table.insert(msg.build.lottery.ids, build.lottery.ids[i])
      end
    end
    if build.resource ~= nil and build.resource.reserve ~= nil then
      if msg.build == nil then
        msg.build = {}
      end
      if msg.build.resource == nil then
        msg.build.resource = {}
      end
      msg.build.resource.reserve = build.resource.reserve
    end
    if build.resource ~= nil and build.resource.begin_time ~= nil then
      if msg.build == nil then
        msg.build = {}
      end
      if msg.build.resource == nil then
        msg.build.resource = {}
      end
      msg.build.resource.begin_time = build.resource.begin_time
    end
    if build ~= nil and build.isforbid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.build == nil then
        msg.build = {}
      end
      msg.build.isforbid = build.isforbid
    end
    if build ~= nil and build.forges ~= nil then
      if msg.build == nil then
        msg.build = {}
      end
      if msg.build.forges == nil then
        msg.build.forges = {}
      end
      for i = 1, #build.forges do
        table.insert(msg.build.forges, build.forges[i])
      end
    end
    if build ~= nil and build.achieve_hour ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.build == nil then
        msg.build = {}
      end
      msg.build.achieve_hour = build.achieve_hour
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuildQueryManorCmd.id
    local msgParam = {}
    if build ~= nil and build.build_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.build == nil then
        msgParam.build = {}
      end
      msgParam.build.build_id = build.build_id
    end
    if build ~= nil and build.open_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.build == nil then
        msgParam.build = {}
      end
      msgParam.build.open_time = build.open_time
    end
    if build ~= nil and build.funcs ~= nil then
      if msgParam.build == nil then
        msgParam.build = {}
      end
      if msgParam.build.funcs == nil then
        msgParam.build.funcs = {}
      end
      for i = 1, #build.funcs do
        table.insert(msgParam.build.funcs, build.funcs[i])
      end
    end
    if build ~= nil and build.dispatch.groups ~= nil then
      if msgParam.build.dispatch == nil then
        msgParam.build.dispatch = {}
      end
      if msgParam.build.dispatch.groups == nil then
        msgParam.build.dispatch.groups = {}
      end
      for i = 1, #build.dispatch.groups do
        table.insert(msgParam.build.dispatch.groups, build.dispatch.groups[i])
      end
    end
    if build ~= nil and build.dispatch.rewards ~= nil then
      if msgParam.build.dispatch == nil then
        msgParam.build.dispatch = {}
      end
      if msgParam.build.dispatch.rewards == nil then
        msgParam.build.dispatch.rewards = {}
      end
      for i = 1, #build.dispatch.rewards do
        table.insert(msgParam.build.dispatch.rewards, build.dispatch.rewards[i])
      end
    end
    if build ~= nil and build.lottery.ids ~= nil then
      if msgParam.build.lottery == nil then
        msgParam.build.lottery = {}
      end
      if msgParam.build.lottery.ids == nil then
        msgParam.build.lottery.ids = {}
      end
      for i = 1, #build.lottery.ids do
        table.insert(msgParam.build.lottery.ids, build.lottery.ids[i])
      end
    end
    if build.resource ~= nil and build.resource.reserve ~= nil then
      if msgParam.build == nil then
        msgParam.build = {}
      end
      if msgParam.build.resource == nil then
        msgParam.build.resource = {}
      end
      msgParam.build.resource.reserve = build.resource.reserve
    end
    if build.resource ~= nil and build.resource.begin_time ~= nil then
      if msgParam.build == nil then
        msgParam.build = {}
      end
      if msgParam.build.resource == nil then
        msgParam.build.resource = {}
      end
      msgParam.build.resource.begin_time = build.resource.begin_time
    end
    if build ~= nil and build.isforbid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.build == nil then
        msgParam.build = {}
      end
      msgParam.build.isforbid = build.isforbid
    end
    if build ~= nil and build.forges ~= nil then
      if msgParam.build == nil then
        msgParam.build = {}
      end
      if msgParam.build.forges == nil then
        msgParam.build.forges = {}
      end
      for i = 1, #build.forges do
        table.insert(msgParam.build.forges, build.forges[i])
      end
    end
    if build ~= nil and build.achieve_hour ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.build == nil then
        msgParam.build = {}
      end
      msgParam.build.achieve_hour = build.achieve_hour
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManorAutoProxy:CallBuildLevelUpManorCmd(type, build)
  if not NetConfig.PBC then
    local msg = SceneManor_pb.BuildLevelUpManorCmd()
    if type ~= nil then
      msg.type = type
    end
    if build ~= nil and build.build_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.build == nil then
        msg.build = {}
      end
      msg.build.build_id = build.build_id
    end
    if build ~= nil and build.open_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.build == nil then
        msg.build = {}
      end
      msg.build.open_time = build.open_time
    end
    if build ~= nil and build.funcs ~= nil then
      if msg.build == nil then
        msg.build = {}
      end
      if msg.build.funcs == nil then
        msg.build.funcs = {}
      end
      for i = 1, #build.funcs do
        table.insert(msg.build.funcs, build.funcs[i])
      end
    end
    if build ~= nil and build.dispatch.groups ~= nil then
      if msg.build.dispatch == nil then
        msg.build.dispatch = {}
      end
      if msg.build.dispatch.groups == nil then
        msg.build.dispatch.groups = {}
      end
      for i = 1, #build.dispatch.groups do
        table.insert(msg.build.dispatch.groups, build.dispatch.groups[i])
      end
    end
    if build ~= nil and build.dispatch.rewards ~= nil then
      if msg.build.dispatch == nil then
        msg.build.dispatch = {}
      end
      if msg.build.dispatch.rewards == nil then
        msg.build.dispatch.rewards = {}
      end
      for i = 1, #build.dispatch.rewards do
        table.insert(msg.build.dispatch.rewards, build.dispatch.rewards[i])
      end
    end
    if build ~= nil and build.lottery.ids ~= nil then
      if msg.build.lottery == nil then
        msg.build.lottery = {}
      end
      if msg.build.lottery.ids == nil then
        msg.build.lottery.ids = {}
      end
      for i = 1, #build.lottery.ids do
        table.insert(msg.build.lottery.ids, build.lottery.ids[i])
      end
    end
    if build.resource ~= nil and build.resource.reserve ~= nil then
      if msg.build == nil then
        msg.build = {}
      end
      if msg.build.resource == nil then
        msg.build.resource = {}
      end
      msg.build.resource.reserve = build.resource.reserve
    end
    if build.resource ~= nil and build.resource.begin_time ~= nil then
      if msg.build == nil then
        msg.build = {}
      end
      if msg.build.resource == nil then
        msg.build.resource = {}
      end
      msg.build.resource.begin_time = build.resource.begin_time
    end
    if build ~= nil and build.isforbid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.build == nil then
        msg.build = {}
      end
      msg.build.isforbid = build.isforbid
    end
    if build ~= nil and build.forges ~= nil then
      if msg.build == nil then
        msg.build = {}
      end
      if msg.build.forges == nil then
        msg.build.forges = {}
      end
      for i = 1, #build.forges do
        table.insert(msg.build.forges, build.forges[i])
      end
    end
    if build ~= nil and build.achieve_hour ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.build == nil then
        msg.build = {}
      end
      msg.build.achieve_hour = build.achieve_hour
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuildLevelUpManorCmd.id
    local msgParam = {}
    if type ~= nil then
      msgParam.type = type
    end
    if build ~= nil and build.build_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.build == nil then
        msgParam.build = {}
      end
      msgParam.build.build_id = build.build_id
    end
    if build ~= nil and build.open_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.build == nil then
        msgParam.build = {}
      end
      msgParam.build.open_time = build.open_time
    end
    if build ~= nil and build.funcs ~= nil then
      if msgParam.build == nil then
        msgParam.build = {}
      end
      if msgParam.build.funcs == nil then
        msgParam.build.funcs = {}
      end
      for i = 1, #build.funcs do
        table.insert(msgParam.build.funcs, build.funcs[i])
      end
    end
    if build ~= nil and build.dispatch.groups ~= nil then
      if msgParam.build.dispatch == nil then
        msgParam.build.dispatch = {}
      end
      if msgParam.build.dispatch.groups == nil then
        msgParam.build.dispatch.groups = {}
      end
      for i = 1, #build.dispatch.groups do
        table.insert(msgParam.build.dispatch.groups, build.dispatch.groups[i])
      end
    end
    if build ~= nil and build.dispatch.rewards ~= nil then
      if msgParam.build.dispatch == nil then
        msgParam.build.dispatch = {}
      end
      if msgParam.build.dispatch.rewards == nil then
        msgParam.build.dispatch.rewards = {}
      end
      for i = 1, #build.dispatch.rewards do
        table.insert(msgParam.build.dispatch.rewards, build.dispatch.rewards[i])
      end
    end
    if build ~= nil and build.lottery.ids ~= nil then
      if msgParam.build.lottery == nil then
        msgParam.build.lottery = {}
      end
      if msgParam.build.lottery.ids == nil then
        msgParam.build.lottery.ids = {}
      end
      for i = 1, #build.lottery.ids do
        table.insert(msgParam.build.lottery.ids, build.lottery.ids[i])
      end
    end
    if build.resource ~= nil and build.resource.reserve ~= nil then
      if msgParam.build == nil then
        msgParam.build = {}
      end
      if msgParam.build.resource == nil then
        msgParam.build.resource = {}
      end
      msgParam.build.resource.reserve = build.resource.reserve
    end
    if build.resource ~= nil and build.resource.begin_time ~= nil then
      if msgParam.build == nil then
        msgParam.build = {}
      end
      if msgParam.build.resource == nil then
        msgParam.build.resource = {}
      end
      msgParam.build.resource.begin_time = build.resource.begin_time
    end
    if build ~= nil and build.isforbid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.build == nil then
        msgParam.build = {}
      end
      msgParam.build.isforbid = build.isforbid
    end
    if build ~= nil and build.forges ~= nil then
      if msgParam.build == nil then
        msgParam.build = {}
      end
      if msgParam.build.forges == nil then
        msgParam.build.forges = {}
      end
      for i = 1, #build.forges do
        table.insert(msgParam.build.forges, build.forges[i])
      end
    end
    if build ~= nil and build.achieve_hour ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.build == nil then
        msgParam.build = {}
      end
      msgParam.build.achieve_hour = build.achieve_hour
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManorAutoProxy:CallBuildDispatchManorCmd(pet_id, area_id, equip_id, isreward, build)
  if not NetConfig.PBC then
    local msg = SceneManor_pb.BuildDispatchManorCmd()
    if pet_id ~= nil then
      msg.pet_id = pet_id
    end
    if area_id ~= nil then
      msg.area_id = area_id
    end
    if equip_id ~= nil then
      msg.equip_id = equip_id
    end
    if isreward ~= nil then
      msg.isreward = isreward
    end
    if build ~= nil and build.build_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.build == nil then
        msg.build = {}
      end
      msg.build.build_id = build.build_id
    end
    if build ~= nil and build.open_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.build == nil then
        msg.build = {}
      end
      msg.build.open_time = build.open_time
    end
    if build ~= nil and build.funcs ~= nil then
      if msg.build == nil then
        msg.build = {}
      end
      if msg.build.funcs == nil then
        msg.build.funcs = {}
      end
      for i = 1, #build.funcs do
        table.insert(msg.build.funcs, build.funcs[i])
      end
    end
    if build ~= nil and build.dispatch.groups ~= nil then
      if msg.build.dispatch == nil then
        msg.build.dispatch = {}
      end
      if msg.build.dispatch.groups == nil then
        msg.build.dispatch.groups = {}
      end
      for i = 1, #build.dispatch.groups do
        table.insert(msg.build.dispatch.groups, build.dispatch.groups[i])
      end
    end
    if build ~= nil and build.dispatch.rewards ~= nil then
      if msg.build.dispatch == nil then
        msg.build.dispatch = {}
      end
      if msg.build.dispatch.rewards == nil then
        msg.build.dispatch.rewards = {}
      end
      for i = 1, #build.dispatch.rewards do
        table.insert(msg.build.dispatch.rewards, build.dispatch.rewards[i])
      end
    end
    if build ~= nil and build.lottery.ids ~= nil then
      if msg.build.lottery == nil then
        msg.build.lottery = {}
      end
      if msg.build.lottery.ids == nil then
        msg.build.lottery.ids = {}
      end
      for i = 1, #build.lottery.ids do
        table.insert(msg.build.lottery.ids, build.lottery.ids[i])
      end
    end
    if build.resource ~= nil and build.resource.reserve ~= nil then
      if msg.build == nil then
        msg.build = {}
      end
      if msg.build.resource == nil then
        msg.build.resource = {}
      end
      msg.build.resource.reserve = build.resource.reserve
    end
    if build.resource ~= nil and build.resource.begin_time ~= nil then
      if msg.build == nil then
        msg.build = {}
      end
      if msg.build.resource == nil then
        msg.build.resource = {}
      end
      msg.build.resource.begin_time = build.resource.begin_time
    end
    if build ~= nil and build.isforbid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.build == nil then
        msg.build = {}
      end
      msg.build.isforbid = build.isforbid
    end
    if build ~= nil and build.forges ~= nil then
      if msg.build == nil then
        msg.build = {}
      end
      if msg.build.forges == nil then
        msg.build.forges = {}
      end
      for i = 1, #build.forges do
        table.insert(msg.build.forges, build.forges[i])
      end
    end
    if build ~= nil and build.achieve_hour ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.build == nil then
        msg.build = {}
      end
      msg.build.achieve_hour = build.achieve_hour
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuildDispatchManorCmd.id
    local msgParam = {}
    if pet_id ~= nil then
      msgParam.pet_id = pet_id
    end
    if area_id ~= nil then
      msgParam.area_id = area_id
    end
    if equip_id ~= nil then
      msgParam.equip_id = equip_id
    end
    if isreward ~= nil then
      msgParam.isreward = isreward
    end
    if build ~= nil and build.build_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.build == nil then
        msgParam.build = {}
      end
      msgParam.build.build_id = build.build_id
    end
    if build ~= nil and build.open_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.build == nil then
        msgParam.build = {}
      end
      msgParam.build.open_time = build.open_time
    end
    if build ~= nil and build.funcs ~= nil then
      if msgParam.build == nil then
        msgParam.build = {}
      end
      if msgParam.build.funcs == nil then
        msgParam.build.funcs = {}
      end
      for i = 1, #build.funcs do
        table.insert(msgParam.build.funcs, build.funcs[i])
      end
    end
    if build ~= nil and build.dispatch.groups ~= nil then
      if msgParam.build.dispatch == nil then
        msgParam.build.dispatch = {}
      end
      if msgParam.build.dispatch.groups == nil then
        msgParam.build.dispatch.groups = {}
      end
      for i = 1, #build.dispatch.groups do
        table.insert(msgParam.build.dispatch.groups, build.dispatch.groups[i])
      end
    end
    if build ~= nil and build.dispatch.rewards ~= nil then
      if msgParam.build.dispatch == nil then
        msgParam.build.dispatch = {}
      end
      if msgParam.build.dispatch.rewards == nil then
        msgParam.build.dispatch.rewards = {}
      end
      for i = 1, #build.dispatch.rewards do
        table.insert(msgParam.build.dispatch.rewards, build.dispatch.rewards[i])
      end
    end
    if build ~= nil and build.lottery.ids ~= nil then
      if msgParam.build.lottery == nil then
        msgParam.build.lottery = {}
      end
      if msgParam.build.lottery.ids == nil then
        msgParam.build.lottery.ids = {}
      end
      for i = 1, #build.lottery.ids do
        table.insert(msgParam.build.lottery.ids, build.lottery.ids[i])
      end
    end
    if build.resource ~= nil and build.resource.reserve ~= nil then
      if msgParam.build == nil then
        msgParam.build = {}
      end
      if msgParam.build.resource == nil then
        msgParam.build.resource = {}
      end
      msgParam.build.resource.reserve = build.resource.reserve
    end
    if build.resource ~= nil and build.resource.begin_time ~= nil then
      if msgParam.build == nil then
        msgParam.build = {}
      end
      if msgParam.build.resource == nil then
        msgParam.build.resource = {}
      end
      msgParam.build.resource.begin_time = build.resource.begin_time
    end
    if build ~= nil and build.isforbid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.build == nil then
        msgParam.build = {}
      end
      msgParam.build.isforbid = build.isforbid
    end
    if build ~= nil and build.forges ~= nil then
      if msgParam.build == nil then
        msgParam.build = {}
      end
      if msgParam.build.forges == nil then
        msgParam.build.forges = {}
      end
      for i = 1, #build.forges do
        table.insert(msgParam.build.forges, build.forges[i])
      end
    end
    if build ~= nil and build.achieve_hour ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.build == nil then
        msgParam.build = {}
      end
      msgParam.build.achieve_hour = build.achieve_hour
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManorAutoProxy:CallBuildLotteryManorCmd(build)
  if not NetConfig.PBC then
    local msg = SceneManor_pb.BuildLotteryManorCmd()
    if build ~= nil and build.build_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.build == nil then
        msg.build = {}
      end
      msg.build.build_id = build.build_id
    end
    if build ~= nil and build.open_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.build == nil then
        msg.build = {}
      end
      msg.build.open_time = build.open_time
    end
    if build ~= nil and build.funcs ~= nil then
      if msg.build == nil then
        msg.build = {}
      end
      if msg.build.funcs == nil then
        msg.build.funcs = {}
      end
      for i = 1, #build.funcs do
        table.insert(msg.build.funcs, build.funcs[i])
      end
    end
    if build ~= nil and build.dispatch.groups ~= nil then
      if msg.build.dispatch == nil then
        msg.build.dispatch = {}
      end
      if msg.build.dispatch.groups == nil then
        msg.build.dispatch.groups = {}
      end
      for i = 1, #build.dispatch.groups do
        table.insert(msg.build.dispatch.groups, build.dispatch.groups[i])
      end
    end
    if build ~= nil and build.dispatch.rewards ~= nil then
      if msg.build.dispatch == nil then
        msg.build.dispatch = {}
      end
      if msg.build.dispatch.rewards == nil then
        msg.build.dispatch.rewards = {}
      end
      for i = 1, #build.dispatch.rewards do
        table.insert(msg.build.dispatch.rewards, build.dispatch.rewards[i])
      end
    end
    if build ~= nil and build.lottery.ids ~= nil then
      if msg.build.lottery == nil then
        msg.build.lottery = {}
      end
      if msg.build.lottery.ids == nil then
        msg.build.lottery.ids = {}
      end
      for i = 1, #build.lottery.ids do
        table.insert(msg.build.lottery.ids, build.lottery.ids[i])
      end
    end
    if build.resource ~= nil and build.resource.reserve ~= nil then
      if msg.build == nil then
        msg.build = {}
      end
      if msg.build.resource == nil then
        msg.build.resource = {}
      end
      msg.build.resource.reserve = build.resource.reserve
    end
    if build.resource ~= nil and build.resource.begin_time ~= nil then
      if msg.build == nil then
        msg.build = {}
      end
      if msg.build.resource == nil then
        msg.build.resource = {}
      end
      msg.build.resource.begin_time = build.resource.begin_time
    end
    if build ~= nil and build.isforbid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.build == nil then
        msg.build = {}
      end
      msg.build.isforbid = build.isforbid
    end
    if build ~= nil and build.forges ~= nil then
      if msg.build == nil then
        msg.build = {}
      end
      if msg.build.forges == nil then
        msg.build.forges = {}
      end
      for i = 1, #build.forges do
        table.insert(msg.build.forges, build.forges[i])
      end
    end
    if build ~= nil and build.achieve_hour ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.build == nil then
        msg.build = {}
      end
      msg.build.achieve_hour = build.achieve_hour
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuildLotteryManorCmd.id
    local msgParam = {}
    if build ~= nil and build.build_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.build == nil then
        msgParam.build = {}
      end
      msgParam.build.build_id = build.build_id
    end
    if build ~= nil and build.open_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.build == nil then
        msgParam.build = {}
      end
      msgParam.build.open_time = build.open_time
    end
    if build ~= nil and build.funcs ~= nil then
      if msgParam.build == nil then
        msgParam.build = {}
      end
      if msgParam.build.funcs == nil then
        msgParam.build.funcs = {}
      end
      for i = 1, #build.funcs do
        table.insert(msgParam.build.funcs, build.funcs[i])
      end
    end
    if build ~= nil and build.dispatch.groups ~= nil then
      if msgParam.build.dispatch == nil then
        msgParam.build.dispatch = {}
      end
      if msgParam.build.dispatch.groups == nil then
        msgParam.build.dispatch.groups = {}
      end
      for i = 1, #build.dispatch.groups do
        table.insert(msgParam.build.dispatch.groups, build.dispatch.groups[i])
      end
    end
    if build ~= nil and build.dispatch.rewards ~= nil then
      if msgParam.build.dispatch == nil then
        msgParam.build.dispatch = {}
      end
      if msgParam.build.dispatch.rewards == nil then
        msgParam.build.dispatch.rewards = {}
      end
      for i = 1, #build.dispatch.rewards do
        table.insert(msgParam.build.dispatch.rewards, build.dispatch.rewards[i])
      end
    end
    if build ~= nil and build.lottery.ids ~= nil then
      if msgParam.build.lottery == nil then
        msgParam.build.lottery = {}
      end
      if msgParam.build.lottery.ids == nil then
        msgParam.build.lottery.ids = {}
      end
      for i = 1, #build.lottery.ids do
        table.insert(msgParam.build.lottery.ids, build.lottery.ids[i])
      end
    end
    if build.resource ~= nil and build.resource.reserve ~= nil then
      if msgParam.build == nil then
        msgParam.build = {}
      end
      if msgParam.build.resource == nil then
        msgParam.build.resource = {}
      end
      msgParam.build.resource.reserve = build.resource.reserve
    end
    if build.resource ~= nil and build.resource.begin_time ~= nil then
      if msgParam.build == nil then
        msgParam.build = {}
      end
      if msgParam.build.resource == nil then
        msgParam.build.resource = {}
      end
      msgParam.build.resource.begin_time = build.resource.begin_time
    end
    if build ~= nil and build.isforbid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.build == nil then
        msgParam.build = {}
      end
      msgParam.build.isforbid = build.isforbid
    end
    if build ~= nil and build.forges ~= nil then
      if msgParam.build == nil then
        msgParam.build = {}
      end
      if msgParam.build.forges == nil then
        msgParam.build.forges = {}
      end
      for i = 1, #build.forges do
        table.insert(msgParam.build.forges, build.forges[i])
      end
    end
    if build ~= nil and build.achieve_hour ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.build == nil then
        msgParam.build = {}
      end
      msgParam.build.achieve_hour = build.achieve_hour
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManorAutoProxy:CallBuildCollectManorCmd(build)
  if not NetConfig.PBC then
    local msg = SceneManor_pb.BuildCollectManorCmd()
    if build ~= nil and build.build_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.build == nil then
        msg.build = {}
      end
      msg.build.build_id = build.build_id
    end
    if build ~= nil and build.open_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.build == nil then
        msg.build = {}
      end
      msg.build.open_time = build.open_time
    end
    if build ~= nil and build.funcs ~= nil then
      if msg.build == nil then
        msg.build = {}
      end
      if msg.build.funcs == nil then
        msg.build.funcs = {}
      end
      for i = 1, #build.funcs do
        table.insert(msg.build.funcs, build.funcs[i])
      end
    end
    if build ~= nil and build.dispatch.groups ~= nil then
      if msg.build.dispatch == nil then
        msg.build.dispatch = {}
      end
      if msg.build.dispatch.groups == nil then
        msg.build.dispatch.groups = {}
      end
      for i = 1, #build.dispatch.groups do
        table.insert(msg.build.dispatch.groups, build.dispatch.groups[i])
      end
    end
    if build ~= nil and build.dispatch.rewards ~= nil then
      if msg.build.dispatch == nil then
        msg.build.dispatch = {}
      end
      if msg.build.dispatch.rewards == nil then
        msg.build.dispatch.rewards = {}
      end
      for i = 1, #build.dispatch.rewards do
        table.insert(msg.build.dispatch.rewards, build.dispatch.rewards[i])
      end
    end
    if build ~= nil and build.lottery.ids ~= nil then
      if msg.build.lottery == nil then
        msg.build.lottery = {}
      end
      if msg.build.lottery.ids == nil then
        msg.build.lottery.ids = {}
      end
      for i = 1, #build.lottery.ids do
        table.insert(msg.build.lottery.ids, build.lottery.ids[i])
      end
    end
    if build.resource ~= nil and build.resource.reserve ~= nil then
      if msg.build == nil then
        msg.build = {}
      end
      if msg.build.resource == nil then
        msg.build.resource = {}
      end
      msg.build.resource.reserve = build.resource.reserve
    end
    if build.resource ~= nil and build.resource.begin_time ~= nil then
      if msg.build == nil then
        msg.build = {}
      end
      if msg.build.resource == nil then
        msg.build.resource = {}
      end
      msg.build.resource.begin_time = build.resource.begin_time
    end
    if build ~= nil and build.isforbid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.build == nil then
        msg.build = {}
      end
      msg.build.isforbid = build.isforbid
    end
    if build ~= nil and build.forges ~= nil then
      if msg.build == nil then
        msg.build = {}
      end
      if msg.build.forges == nil then
        msg.build.forges = {}
      end
      for i = 1, #build.forges do
        table.insert(msg.build.forges, build.forges[i])
      end
    end
    if build ~= nil and build.achieve_hour ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.build == nil then
        msg.build = {}
      end
      msg.build.achieve_hour = build.achieve_hour
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuildCollectManorCmd.id
    local msgParam = {}
    if build ~= nil and build.build_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.build == nil then
        msgParam.build = {}
      end
      msgParam.build.build_id = build.build_id
    end
    if build ~= nil and build.open_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.build == nil then
        msgParam.build = {}
      end
      msgParam.build.open_time = build.open_time
    end
    if build ~= nil and build.funcs ~= nil then
      if msgParam.build == nil then
        msgParam.build = {}
      end
      if msgParam.build.funcs == nil then
        msgParam.build.funcs = {}
      end
      for i = 1, #build.funcs do
        table.insert(msgParam.build.funcs, build.funcs[i])
      end
    end
    if build ~= nil and build.dispatch.groups ~= nil then
      if msgParam.build.dispatch == nil then
        msgParam.build.dispatch = {}
      end
      if msgParam.build.dispatch.groups == nil then
        msgParam.build.dispatch.groups = {}
      end
      for i = 1, #build.dispatch.groups do
        table.insert(msgParam.build.dispatch.groups, build.dispatch.groups[i])
      end
    end
    if build ~= nil and build.dispatch.rewards ~= nil then
      if msgParam.build.dispatch == nil then
        msgParam.build.dispatch = {}
      end
      if msgParam.build.dispatch.rewards == nil then
        msgParam.build.dispatch.rewards = {}
      end
      for i = 1, #build.dispatch.rewards do
        table.insert(msgParam.build.dispatch.rewards, build.dispatch.rewards[i])
      end
    end
    if build ~= nil and build.lottery.ids ~= nil then
      if msgParam.build.lottery == nil then
        msgParam.build.lottery = {}
      end
      if msgParam.build.lottery.ids == nil then
        msgParam.build.lottery.ids = {}
      end
      for i = 1, #build.lottery.ids do
        table.insert(msgParam.build.lottery.ids, build.lottery.ids[i])
      end
    end
    if build.resource ~= nil and build.resource.reserve ~= nil then
      if msgParam.build == nil then
        msgParam.build = {}
      end
      if msgParam.build.resource == nil then
        msgParam.build.resource = {}
      end
      msgParam.build.resource.reserve = build.resource.reserve
    end
    if build.resource ~= nil and build.resource.begin_time ~= nil then
      if msgParam.build == nil then
        msgParam.build = {}
      end
      if msgParam.build.resource == nil then
        msgParam.build.resource = {}
      end
      msgParam.build.resource.begin_time = build.resource.begin_time
    end
    if build ~= nil and build.isforbid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.build == nil then
        msgParam.build = {}
      end
      msgParam.build.isforbid = build.isforbid
    end
    if build ~= nil and build.forges ~= nil then
      if msgParam.build == nil then
        msgParam.build = {}
      end
      if msgParam.build.forges == nil then
        msgParam.build.forges = {}
      end
      for i = 1, #build.forges do
        table.insert(msgParam.build.forges, build.forges[i])
      end
    end
    if build ~= nil and build.achieve_hour ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.build == nil then
        msgParam.build = {}
      end
      msgParam.build.achieve_hour = build.achieve_hour
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManorAutoProxy:CallReqEnterRaidManorCmd(npcguid)
  if not NetConfig.PBC then
    local msg = SceneManor_pb.ReqEnterRaidManorCmd()
    if npcguid ~= nil then
      msg.npcguid = npcguid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.ReqEnterRaidManorCmd.id
    local msgParam = {}
    if npcguid ~= nil then
      msgParam.npcguid = npcguid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManorAutoProxy:CallPartnerInfoManorCmd(partnerinfos)
  if not NetConfig.PBC then
    local msg = SceneManor_pb.PartnerInfoManorCmd()
    if partnerinfos ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.partnerinfos == nil then
        msg.partnerinfos = {}
      end
      for i = 1, #partnerinfos do
        table.insert(msg.partnerinfos, partnerinfos[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PartnerInfoManorCmd.id
    local msgParam = {}
    if partnerinfos ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.partnerinfos == nil then
        msgParam.partnerinfos = {}
      end
      for i = 1, #partnerinfos do
        table.insert(msgParam.partnerinfos, partnerinfos[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManorAutoProxy:CallPartnerStroyManorCmd(partnerid, storyid)
  if not NetConfig.PBC then
    local msg = SceneManor_pb.PartnerStroyManorCmd()
    if partnerid ~= nil then
      msg.partnerid = partnerid
    end
    if storyid ~= nil then
      msg.storyid = storyid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PartnerStroyManorCmd.id
    local msgParam = {}
    if partnerid ~= nil then
      msgParam.partnerid = partnerid
    end
    if storyid ~= nil then
      msgParam.storyid = storyid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManorAutoProxy:CallPartnerIdleListManorCmd(partners)
  if not NetConfig.PBC then
    local msg = SceneManor_pb.PartnerIdleListManorCmd()
    if partners ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.partners == nil then
        msg.partners = {}
      end
      for i = 1, #partners do
        table.insert(msg.partners, partners[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PartnerIdleListManorCmd.id
    local msgParam = {}
    if partners ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.partners == nil then
        msgParam.partners = {}
      end
      for i = 1, #partners do
        table.insert(msgParam.partners, partners[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManorAutoProxy:CallPartnerIdleUpdateManorCmd(adds, delid)
  if not NetConfig.PBC then
    local msg = SceneManor_pb.PartnerIdleUpdateManorCmd()
    if adds ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.adds == nil then
        msg.adds = {}
      end
      for i = 1, #adds do
        table.insert(msg.adds, adds[i])
      end
    end
    if delid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.delid == nil then
        msg.delid = {}
      end
      for i = 1, #delid do
        table.insert(msg.delid, delid[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PartnerIdleUpdateManorCmd.id
    local msgParam = {}
    if adds ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.adds == nil then
        msgParam.adds = {}
      end
      for i = 1, #adds do
        table.insert(msgParam.adds, adds[i])
      end
    end
    if delid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.delid == nil then
        msgParam.delid = {}
      end
      for i = 1, #delid do
        table.insert(msgParam.delid, delid[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManorAutoProxy:CallPartnerGiveManorCmd(partnerid, itemid, itemnum)
  if not NetConfig.PBC then
    local msg = SceneManor_pb.PartnerGiveManorCmd()
    if partnerid ~= nil then
      msg.partnerid = partnerid
    end
    if itemid ~= nil then
      msg.itemid = itemid
    end
    if itemnum ~= nil then
      msg.itemnum = itemnum
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PartnerGiveManorCmd.id
    local msgParam = {}
    if partnerid ~= nil then
      msgParam.partnerid = partnerid
    end
    if itemid ~= nil then
      msgParam.itemid = itemid
    end
    if itemnum ~= nil then
      msgParam.itemnum = itemnum
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManorAutoProxy:CallBuildForgeManorCmd(part, isreward, build)
  if not NetConfig.PBC then
    local msg = SceneManor_pb.BuildForgeManorCmd()
    if part ~= nil then
      msg.part = part
    end
    if isreward ~= nil then
      msg.isreward = isreward
    end
    if build ~= nil and build.build_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.build == nil then
        msg.build = {}
      end
      msg.build.build_id = build.build_id
    end
    if build ~= nil and build.open_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.build == nil then
        msg.build = {}
      end
      msg.build.open_time = build.open_time
    end
    if build ~= nil and build.funcs ~= nil then
      if msg.build == nil then
        msg.build = {}
      end
      if msg.build.funcs == nil then
        msg.build.funcs = {}
      end
      for i = 1, #build.funcs do
        table.insert(msg.build.funcs, build.funcs[i])
      end
    end
    if build ~= nil and build.dispatch.groups ~= nil then
      if msg.build.dispatch == nil then
        msg.build.dispatch = {}
      end
      if msg.build.dispatch.groups == nil then
        msg.build.dispatch.groups = {}
      end
      for i = 1, #build.dispatch.groups do
        table.insert(msg.build.dispatch.groups, build.dispatch.groups[i])
      end
    end
    if build ~= nil and build.dispatch.rewards ~= nil then
      if msg.build.dispatch == nil then
        msg.build.dispatch = {}
      end
      if msg.build.dispatch.rewards == nil then
        msg.build.dispatch.rewards = {}
      end
      for i = 1, #build.dispatch.rewards do
        table.insert(msg.build.dispatch.rewards, build.dispatch.rewards[i])
      end
    end
    if build ~= nil and build.lottery.ids ~= nil then
      if msg.build.lottery == nil then
        msg.build.lottery = {}
      end
      if msg.build.lottery.ids == nil then
        msg.build.lottery.ids = {}
      end
      for i = 1, #build.lottery.ids do
        table.insert(msg.build.lottery.ids, build.lottery.ids[i])
      end
    end
    if build.resource ~= nil and build.resource.reserve ~= nil then
      if msg.build == nil then
        msg.build = {}
      end
      if msg.build.resource == nil then
        msg.build.resource = {}
      end
      msg.build.resource.reserve = build.resource.reserve
    end
    if build.resource ~= nil and build.resource.begin_time ~= nil then
      if msg.build == nil then
        msg.build = {}
      end
      if msg.build.resource == nil then
        msg.build.resource = {}
      end
      msg.build.resource.begin_time = build.resource.begin_time
    end
    if build ~= nil and build.isforbid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.build == nil then
        msg.build = {}
      end
      msg.build.isforbid = build.isforbid
    end
    if build ~= nil and build.forges ~= nil then
      if msg.build == nil then
        msg.build = {}
      end
      if msg.build.forges == nil then
        msg.build.forges = {}
      end
      for i = 1, #build.forges do
        table.insert(msg.build.forges, build.forges[i])
      end
    end
    if build ~= nil and build.achieve_hour ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.build == nil then
        msg.build = {}
      end
      msg.build.achieve_hour = build.achieve_hour
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BuildForgeManorCmd.id
    local msgParam = {}
    if part ~= nil then
      msgParam.part = part
    end
    if isreward ~= nil then
      msgParam.isreward = isreward
    end
    if build ~= nil and build.build_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.build == nil then
        msgParam.build = {}
      end
      msgParam.build.build_id = build.build_id
    end
    if build ~= nil and build.open_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.build == nil then
        msgParam.build = {}
      end
      msgParam.build.open_time = build.open_time
    end
    if build ~= nil and build.funcs ~= nil then
      if msgParam.build == nil then
        msgParam.build = {}
      end
      if msgParam.build.funcs == nil then
        msgParam.build.funcs = {}
      end
      for i = 1, #build.funcs do
        table.insert(msgParam.build.funcs, build.funcs[i])
      end
    end
    if build ~= nil and build.dispatch.groups ~= nil then
      if msgParam.build.dispatch == nil then
        msgParam.build.dispatch = {}
      end
      if msgParam.build.dispatch.groups == nil then
        msgParam.build.dispatch.groups = {}
      end
      for i = 1, #build.dispatch.groups do
        table.insert(msgParam.build.dispatch.groups, build.dispatch.groups[i])
      end
    end
    if build ~= nil and build.dispatch.rewards ~= nil then
      if msgParam.build.dispatch == nil then
        msgParam.build.dispatch = {}
      end
      if msgParam.build.dispatch.rewards == nil then
        msgParam.build.dispatch.rewards = {}
      end
      for i = 1, #build.dispatch.rewards do
        table.insert(msgParam.build.dispatch.rewards, build.dispatch.rewards[i])
      end
    end
    if build ~= nil and build.lottery.ids ~= nil then
      if msgParam.build.lottery == nil then
        msgParam.build.lottery = {}
      end
      if msgParam.build.lottery.ids == nil then
        msgParam.build.lottery.ids = {}
      end
      for i = 1, #build.lottery.ids do
        table.insert(msgParam.build.lottery.ids, build.lottery.ids[i])
      end
    end
    if build.resource ~= nil and build.resource.reserve ~= nil then
      if msgParam.build == nil then
        msgParam.build = {}
      end
      if msgParam.build.resource == nil then
        msgParam.build.resource = {}
      end
      msgParam.build.resource.reserve = build.resource.reserve
    end
    if build.resource ~= nil and build.resource.begin_time ~= nil then
      if msgParam.build == nil then
        msgParam.build = {}
      end
      if msgParam.build.resource == nil then
        msgParam.build.resource = {}
      end
      msgParam.build.resource.begin_time = build.resource.begin_time
    end
    if build ~= nil and build.isforbid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.build == nil then
        msgParam.build = {}
      end
      msgParam.build.isforbid = build.isforbid
    end
    if build ~= nil and build.forges ~= nil then
      if msgParam.build == nil then
        msgParam.build = {}
      end
      if msgParam.build.forges == nil then
        msgParam.build.forges = {}
      end
      for i = 1, #build.forges do
        table.insert(msgParam.build.forges, build.forges[i])
      end
    end
    if build ~= nil and build.achieve_hour ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.build == nil then
        msgParam.build = {}
      end
      msgParam.build.achieve_hour = build.achieve_hour
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManorAutoProxy:CallSmithInfoManorCmd(quests, all_partners, level, reward_level)
  if not NetConfig.PBC then
    local msg = SceneManor_pb.SmithInfoManorCmd()
    if quests ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.quests == nil then
        msg.quests = {}
      end
      for i = 1, #quests do
        table.insert(msg.quests, quests[i])
      end
    end
    if all_partners ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.all_partners == nil then
        msg.all_partners = {}
      end
      for i = 1, #all_partners do
        table.insert(msg.all_partners, all_partners[i])
      end
    end
    if level ~= nil then
      msg.level = level
    end
    if reward_level ~= nil then
      msg.reward_level = reward_level
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SmithInfoManorCmd.id
    local msgParam = {}
    if quests ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.quests == nil then
        msgParam.quests = {}
      end
      for i = 1, #quests do
        table.insert(msgParam.quests, quests[i])
      end
    end
    if all_partners ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.all_partners == nil then
        msgParam.all_partners = {}
      end
      for i = 1, #all_partners do
        table.insert(msgParam.all_partners, all_partners[i])
      end
    end
    if level ~= nil then
      msgParam.level = level
    end
    if reward_level ~= nil then
      msgParam.reward_level = reward_level
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManorAutoProxy:CallSmithLevelUpManorCmd()
  if not NetConfig.PBC then
    local msg = SceneManor_pb.SmithLevelUpManorCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SmithLevelUpManorCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManorAutoProxy:CallSmithAcceptQuestManorCmd(questid, help_npcid)
  if not NetConfig.PBC then
    local msg = SceneManor_pb.SmithAcceptQuestManorCmd()
    if questid ~= nil then
      msg.questid = questid
    end
    if help_npcid ~= nil then
      msg.help_npcid = help_npcid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.SmithAcceptQuestManorCmd.id
    local msgParam = {}
    if questid ~= nil then
      msgParam.questid = questid
    end
    if help_npcid ~= nil then
      msgParam.help_npcid = help_npcid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceSceneManorAutoProxy:RecvBuildDataNtfManorCmd(data)
  self:Notify(ServiceEvent.SceneManorBuildDataNtfManorCmd, data)
end

function ServiceSceneManorAutoProxy:RecvBuildQueryManorCmd(data)
  self:Notify(ServiceEvent.SceneManorBuildQueryManorCmd, data)
end

function ServiceSceneManorAutoProxy:RecvBuildLevelUpManorCmd(data)
  self:Notify(ServiceEvent.SceneManorBuildLevelUpManorCmd, data)
end

function ServiceSceneManorAutoProxy:RecvBuildDispatchManorCmd(data)
  self:Notify(ServiceEvent.SceneManorBuildDispatchManorCmd, data)
end

function ServiceSceneManorAutoProxy:RecvBuildLotteryManorCmd(data)
  self:Notify(ServiceEvent.SceneManorBuildLotteryManorCmd, data)
end

function ServiceSceneManorAutoProxy:RecvBuildCollectManorCmd(data)
  self:Notify(ServiceEvent.SceneManorBuildCollectManorCmd, data)
end

function ServiceSceneManorAutoProxy:RecvReqEnterRaidManorCmd(data)
  self:Notify(ServiceEvent.SceneManorReqEnterRaidManorCmd, data)
end

function ServiceSceneManorAutoProxy:RecvPartnerInfoManorCmd(data)
  self:Notify(ServiceEvent.SceneManorPartnerInfoManorCmd, data)
end

function ServiceSceneManorAutoProxy:RecvPartnerStroyManorCmd(data)
  self:Notify(ServiceEvent.SceneManorPartnerStroyManorCmd, data)
end

function ServiceSceneManorAutoProxy:RecvPartnerIdleListManorCmd(data)
  self:Notify(ServiceEvent.SceneManorPartnerIdleListManorCmd, data)
end

function ServiceSceneManorAutoProxy:RecvPartnerIdleUpdateManorCmd(data)
  self:Notify(ServiceEvent.SceneManorPartnerIdleUpdateManorCmd, data)
end

function ServiceSceneManorAutoProxy:RecvPartnerGiveManorCmd(data)
  self:Notify(ServiceEvent.SceneManorPartnerGiveManorCmd, data)
end

function ServiceSceneManorAutoProxy:RecvBuildForgeManorCmd(data)
  self:Notify(ServiceEvent.SceneManorBuildForgeManorCmd, data)
end

function ServiceSceneManorAutoProxy:RecvSmithInfoManorCmd(data)
  self:Notify(ServiceEvent.SceneManorSmithInfoManorCmd, data)
end

function ServiceSceneManorAutoProxy:RecvSmithLevelUpManorCmd(data)
  self:Notify(ServiceEvent.SceneManorSmithLevelUpManorCmd, data)
end

function ServiceSceneManorAutoProxy:RecvSmithAcceptQuestManorCmd(data)
  self:Notify(ServiceEvent.SceneManorSmithAcceptQuestManorCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.SceneManorBuildDataNtfManorCmd = "ServiceEvent_SceneManorBuildDataNtfManorCmd"
ServiceEvent.SceneManorBuildQueryManorCmd = "ServiceEvent_SceneManorBuildQueryManorCmd"
ServiceEvent.SceneManorBuildLevelUpManorCmd = "ServiceEvent_SceneManorBuildLevelUpManorCmd"
ServiceEvent.SceneManorBuildDispatchManorCmd = "ServiceEvent_SceneManorBuildDispatchManorCmd"
ServiceEvent.SceneManorBuildLotteryManorCmd = "ServiceEvent_SceneManorBuildLotteryManorCmd"
ServiceEvent.SceneManorBuildCollectManorCmd = "ServiceEvent_SceneManorBuildCollectManorCmd"
ServiceEvent.SceneManorReqEnterRaidManorCmd = "ServiceEvent_SceneManorReqEnterRaidManorCmd"
ServiceEvent.SceneManorPartnerInfoManorCmd = "ServiceEvent_SceneManorPartnerInfoManorCmd"
ServiceEvent.SceneManorPartnerStroyManorCmd = "ServiceEvent_SceneManorPartnerStroyManorCmd"
ServiceEvent.SceneManorPartnerIdleListManorCmd = "ServiceEvent_SceneManorPartnerIdleListManorCmd"
ServiceEvent.SceneManorPartnerIdleUpdateManorCmd = "ServiceEvent_SceneManorPartnerIdleUpdateManorCmd"
ServiceEvent.SceneManorPartnerGiveManorCmd = "ServiceEvent_SceneManorPartnerGiveManorCmd"
ServiceEvent.SceneManorBuildForgeManorCmd = "ServiceEvent_SceneManorBuildForgeManorCmd"
ServiceEvent.SceneManorSmithInfoManorCmd = "ServiceEvent_SceneManorSmithInfoManorCmd"
ServiceEvent.SceneManorSmithLevelUpManorCmd = "ServiceEvent_SceneManorSmithLevelUpManorCmd"
ServiceEvent.SceneManorSmithAcceptQuestManorCmd = "ServiceEvent_SceneManorSmithAcceptQuestManorCmd"
