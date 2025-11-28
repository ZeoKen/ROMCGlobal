LocalSimpleAIManager = class("LocalSimpleAIManager")

function LocalSimpleAIManager:ctor()
  self.aiRunners = {}
end

function LocalSimpleAIManager.Me()
  if not LocalSimpleAIManager.Instance then
    LocalSimpleAIManager.Instance = LocalSimpleAIManager.new()
  end
  return LocalSimpleAIManager.Instance
end

function LocalSimpleAIManager:TryGetAIRunner(id)
  return self.aiRunners[id]
end

function LocalSimpleAIManager:CreateAIRunner(id, config, successCallback, failCallback)
  local aiRunner = self.aiRunners[id]
  if aiRunner == nil then
    aiRunner = LocalSimpleAIRunner.Create(id, config)
    aiRunner:Init(successCallback, failCallback)
    self.aiRunners[id] = aiRunner
  end
end

function LocalSimpleAIManager:DestroyAIRunner(id)
  local aiRunner = self.aiRunners[id]
  if aiRunner ~= nil then
    aiRunner:Destroy()
    self.aiRunners[id] = nil
  end
end

function LocalSimpleAIManager:ActivateAIRunner(id)
  local aiRunner = self.aiRunners[id]
  if aiRunner ~= nil then
    aiRunner:Activate()
  end
end

function LocalSimpleAIManager:DeactivateAIRunner(id)
  local aiRunner = self.aiRunners[id]
  if aiRunner ~= nil then
    aiRunner:Deactivate()
  end
end

function LocalSimpleAIManager:Launch()
  if self.running then
    return
  end
  self.running = true
  self.aiRunners = {}
  self:OnSceneLoaded()
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.OnSceneLoaded, self)
  EventManager.Me():AddEventListener(ServiceEvent.ConnReconnect, self.HandleReconnect, self)
  EventManager.Me():AddEventListener(MyselfEvent.DeathBegin, self.HandleMyselfPlayerDeath, self)
end

function LocalSimpleAIManager:Shutdown()
  if not self.running then
    return
  end
  self.running = false
  EventManager.Me():RemoveEventListener(LoadSceneEvent.FinishLoadScene, self.OnSceneLoaded, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.ConnReconnect, self.HandleReconnect, self)
  EventManager.Me():RemoveEventListener(MyselfEvent.DeathBegin, self.HandleMyselfPlayerDeath, self)
  self:OnLeaveScene()
  self:Clear()
end

local _pendingRemove = {}

function LocalSimpleAIManager:Update(time, deltaTime)
  if not self.running then
    return
  end
  for k, v in pairs(self.aiRunners) do
    if v.isActive and v:Update(time, deltaTime) then
      _pendingRemove[#_pendingRemove + 1] = k
    end
  end
  for i = 1, #_pendingRemove do
    self.aiRunners[_pendingRemove[i]] = nil
  end
  _pendingRemove = {}
end

function LocalSimpleAIManager:Clear()
  for k, v in pairs(self.aiRunners) do
    v:Destroy()
  end
  self.aiRunners = {}
end

function LocalSimpleAIManager:OnSceneLoaded()
  redlog("LocalSimpleAIManager", "OnSceneLoaded / SwitchLine / Reconnect")
  self:Clear()
end

function LocalSimpleAIManager:OnLeaveScene()
  redlog("LocalSimpleAIManager", "OnLeaveScene")
end

function LocalSimpleAIManager:HandleReconnect()
  redlog("LocalSimpleAIManager", "HandleReconnect")
end

function LocalSimpleAIManager:HandleMyselfPlayerDeath(note)
end

LocalSimpleAIRunner = class("LocalSimpleAIRunner")

function LocalSimpleAIRunner.Create(id, config)
  if config.type == "AvoidPlayerNTimes" then
    return LocalSimpleAIRunner_AvoidPlayerNTimes.new(id, config)
  elseif config.type == "SeqVisit" then
    return LocalSimpleAIRunner_SeqVisit.new(id, config)
  end
end

function LocalSimpleAIRunner:ctor(id, config)
  self.target = nil
  self.ai = nil
  self.id = id
  self.config = config
end

function LocalSimpleAIRunner:Init(successCallback, failCallback)
  self.successCallback = successCallback
  self.failCallback = failCallback
end

function LocalSimpleAIRunner:Activate()
  if self.isActive then
    return
  end
  self.isActive = true
  self.target = self:_CreateCreature(self.id, self.config.npcid, self.config.pos)
  self.ai = self.target.ai
end

function LocalSimpleAIRunner:Deactivate()
  self.isActive = false
  self:_RemoveCreature(self.id)
  self.ai = nil
  self.target = nil
end

function LocalSimpleAIRunner:Destroy()
  self:Deactivate()
  self.config = nil
  self.id = 0
end

function LocalSimpleAIRunner:_CreateCreature(uid, nid, pos, dir, npc_uid)
  local creature = NSceneNpcProxy.Instance:Find(uid)
  if not creature then
    local data = {}
    data.npcID = nid
    data.id = uid
    local posX, posY, posZ = 0, 0, 0
    if pos then
      posX = (pos.x or pos[1] or posX) * 1000
      posY = (pos.y or pos[2] or posY) * 1000
      posZ = (pos.z or pos[3] or posZ) * 1000
    end
    data.pos = {
      x = posX,
      y = posY,
      z = posZ
    }
    data.dir = (dir or 0) * 1000
    data.datas = {}
    data.attrs = {}
    data.mounts = {}
    local staticData = Table_Npc[nid]
    data.staticData = staticData
    data.name = staticData.NameZh
    data.searchrange = 0
    creature = NSceneNpcProxy.Instance:Add(data, NNpc)
    if staticData then
      if staticData.ShowName then
        creature.data.userdata:Set(UDEnum.SHOWNAME, staticData.ShowName)
      end
      if staticData.Scale then
        creature:Server_SetScaleCmd(staticData.Scale, true)
      end
      if staticData.Behaviors then
        creature.data:SetBehaviourData(staticData.Behaviors)
      end
    end
    local noAccessable = creature.data:NoAccessable()
    creature.assetRole:SetColliderEnable(not noAccessable)
  end
  return creature
end

function LocalSimpleAIRunner:_RemoveCreature(uid)
  NSceneNpcProxy.Instance:Remove(uid)
end

function LocalSimpleAIRunner:Update(time, deltaTime)
end

function LocalSimpleAIRunner:Clear()
end

function LocalSimpleAIRunner:Abort(result)
  self.result = result
  if self.result then
    if self.successCallback then
      self.successCallback()
    end
  elseif self.failCallback then
    self.failCallback()
  end
end

function LocalSimpleAIRunner.GetRunnerCenterPos(config)
  if config.type == "SeqVisit" then
    return LocalSimpleAIRunner_SeqVisit.GetRunnerCenterPos(config)
  end
  return config.pos
end

local _SqrDistance = LuaVector3.Distance_Square
local _closeDistanceSqr = 3

function LocalSimpleAIRunner:Checker_MyselfCloseTo(target, dis)
  return _SqrDistance(target:GetPosition(), Game.Myself:GetPosition()) < (dis and dis * dis or _closeDistanceSqr)
end

function LocalSimpleAIRunner:TargetPlayFreePlot(target, free_plot_id, end_cb, end_cb_args)
  if free_plot_id then
    local anchorPos, anchorDir = self:_GetPlotAnchorSetting()
    Game.PlotStoryManager:Launch()
    Game.PlotStoryManager:Start_PQTLP(free_plot_id, function()
      if end_cb then
        end_cb(end_cb_args)
      end
      self.actionInstanceId = nil
    end, nil, nil, false, nil, {
      myself = target.data.id,
      player = Game.Myself.data.id
    }, nil, nil, nil, nil, nil, nil, anchorPos, anchorDir)
  end
end

function LocalSimpleAIRunner:_GetPlotAnchorSetting()
  local anchorPos, anchorDir
  local uniqueId = self.config.cutSceneTargetUniqueId
  if uniqueId then
    local npcId = Game.MapManager:GetNpcIDByUniqueID(uniqueId)
    anchorPos = Game.MapManager:GetNpcPosByUniqueID(uniqueId)
    local npcConfig = Table_Npc[npcId]
    if npcConfig and npcConfig.Feature == 64 then
      NavMeshUtility.SelfSample(anchorPos, 1)
    end
    local dir = Game.MapManager:GetNpcDirByUniqueID(uniqueId)
    if dir then
      anchorDir = LuaVector3.Zero()
      LuaVector3.Better_Set(anchorDir, 0, dir, 0)
    end
  elseif self.config.cutSceneAnchorPlayer == 1 then
    anchorPos = Game.Myself:GetPosition()
    local dir = Game.Myself:GetAngleY()
    anchorDir = LuaVector3.Zero()
    LuaVector3.Better_Set(anchorDir, 0, dir, 0)
  end
  return anchorPos, anchorDir
end

LocalSimpleAIRunner_AvoidPlayerNTimes = class("LocalSimpleAIRunner_AvoidPlayerNTimes", LocalSimpleAIRunner)

function LocalSimpleAIRunner_AvoidPlayerNTimes:ctor(id, config)
  LocalSimpleAIRunner_AvoidPlayerNTimes.super.ctor(self, id, config)
  self.avoidTimes = 0
  self.avoidState = nil
  if not self.config.rangeRect then
    local x, z = self.config.pos[1], self.config.pos[3]
    self.config.rangeRect = {
      x - self.config.distance,
      z - self.config.distance,
      x + self.config.distance,
      z + self.config.distance
    }
  end
end

function LocalSimpleAIRunner_AvoidPlayerNTimes:Deactivate()
  LocalSimpleAIRunner_AvoidPlayerNTimes.super.Deactivate(self)
  self.avoidTimes = 0
  self.avoidState = nil
end

function LocalSimpleAIRunner_AvoidPlayerNTimes:BindTarget(target)
  LocalSimpleAIRunner_AvoidPlayerNTimes.super.BindTarget(self, target)
  self.bornPosition = target:GetPosition()
end

function LocalSimpleAIRunner_AvoidPlayerNTimes:Abort(result)
  self.result = result
  if self.result then
    if self.config.fin_act then
      self:TargetPlayFreePlot(self.target, self.config.fin_act, function()
        if self.successCallback then
          self.successCallback()
        end
      end)
    elseif self.successCallback then
      self.successCallback()
    end
  elseif self.config.fail_act then
    self:TargetPlayFreePlot(self.target, self.config.fail_act, function()
      if self.failCallback then
        self.failCallback()
      end
    end)
  elseif self.failCallback then
    self.failCallback()
  end
end

local avoidTimeOut = 10000

function LocalSimpleAIRunner_AvoidPlayerNTimes:Update()
  if self.result then
    return
  end
  if self.avoidState and ServerTime.CurServerTime() - self.avoidState < avoidTimeOut then
  else
    if self:Checker_MyselfCloseTo(self.target, self.config.args.chase_distance) then
      self.avoidTimes = self.avoidTimes + 1
      if self.avoidTimes >= self.config.args.times then
        self:Abort(true)
        return true
      else
        self.avoidState = ServerTime.CurServerTime()
        self:TargetPlayFreePlot(self.target, self.config.on_act)
        self.target:Server_MoveToCmd(self:GetAvoidTargetPos(), nil, function()
          self.avoidState = nil
        end, self.config.args.customMoveAction)
      end
    else
    end
  end
end

local offsetCheckSet = {
  0,
  -30,
  30,
  -60,
  60,
  -90,
  90,
  180
}
local Logic_GetRotatedDir = function(dirx, diry, offset)
  if offset == 0 then
    return dirx, diry
  end
  offset = math.rad(offset)
  return dirx * math.cos(offset) - diry * math.sin(offset), dirx * math.cos(offset) + diry * math.sin(offset)
end
local _shuffleArray = function(array)
  local n = #array
  for i = n, 2, -1 do
    local j = math.random(i)
    array[i], array[j] = array[j], array[i]
  end
  return array
end
local tempV2 = LuaVector2.Zero()
local tempV3 = LuaVector3.Zero()
local Logic_GetAvoidPositionInRange = function(endPos, srcPos, avoidDistance, targetPos, rangeRect)
  LuaVector3.Better_Sub(endPos, srcPos, tempV3)
  tempV2[1] = tempV3[1]
  tempV2[2] = tempV3[3]
  LuaVector2.Normalized(tempV2)
  offsetCheckSet = _shuffleArray(offsetCheckSet)
  for i = 1, #offsetCheckSet do
    tempV3[1], tempV3[3] = Logic_GetRotatedDir(tempV2[1], tempV2[2], offsetCheckSet[i])
    tempV3[2] = 0
    local ret, _ = NavMeshUtility.Better_RaycastDirection(srcPos, targetPos, tempV3, avoidDistance)
    if not ret then
      targetPos[1] = srcPos[1] + tempV3[1] * avoidDistance
      targetPos[2] = srcPos[2] + tempV3[2] * avoidDistance
      targetPos[3] = srcPos[3] + tempV3[3] * avoidDistance
      if targetPos[1] > rangeRect[1] and targetPos[1] < rangeRect[2] and targetPos[3] > rangeRect[3] and targetPos[3] < rangeRect[4] then
        return true
      end
    end
  end
end
local _tempVector3 = LuaVector3.zero

function LocalSimpleAIRunner_AvoidPlayerNTimes:GetAvoidTargetPos()
  local endPos, srcPos = self.target:GetPosition(), Game.Myself:GetPosition()
  local get = Logic_GetAvoidPositionInRange(endPos, srcPos, self.config.args.avoid_distance, _tempVector3, self.config.rangeRect)
  redlog("LocalSimpleAIRunner_AvoidPlayerNTimes:GetAvoidTargetPos", get)
  NavMeshUtility.SelfSample(_tempVector3, 1)
  return _tempVector3
end

LocalSimpleAIRunner_SeqVisit = class("LocalSimpleAIRunner_SeqVisit", LocalSimpleAIRunner)

function LocalSimpleAIRunner_SeqVisit:ctor(id, config)
  LocalSimpleAIRunner_SeqVisit.super.ctor(self, id, config)
  self.seqTargets = {}
  self.seqIndex = 0
end

function LocalSimpleAIRunner_SeqVisit:Init(successCallback, failCallback)
  self.successCallback = successCallback
  self.failCallback = failCallback
end

function LocalSimpleAIRunner_SeqVisit:Activate()
  if self.isActive then
    return
  end
  self.isActive = true
  self.seqIndex = 1
  local targetConfig = self.config.npcCfg[self.seqIndex]
  if targetConfig and #self.seqTargets < self.seqIndex then
    local target = self:_CreateCreature(self.id * 100 + self.seqIndex, targetConfig[5], targetConfig, targetConfig[4])
    table.insert(self.seqTargets, target.data.id)
  end
end

function LocalSimpleAIRunner_SeqVisit:Deactivate()
  self.isActive = false
  for i = 1, #self.seqTargets do
    self:_RemoveCreature(self.seqTargets[i])
  end
  self.seqTargets = {}
  self.seqIndex = 0
end

function LocalSimpleAIRunner_SeqVisit:Destroy()
  self:Deactivate()
  self.config = nil
  self.id = 0
end

function LocalSimpleAIRunner_SeqVisit:Update()
  if self.result then
    return
  end
  if self.pending_next_target then
    return
  end
  self.target = self.seqTargets[self.seqIndex]
  self.target = self.target and SceneCreatureProxy.FindCreature(self.target)
  if self.target then
    if self:Checker_MyselfCloseTo(self.target, self.config.args.chase_distance) then
      self.seqIndex = self.seqIndex + 1
      if self.seqIndex > #self.config.npcCfg then
        self:Abort(true)
        return true
      else
        local last_target = self.target
        self:TargetPlayFreePlot(last_target, self.config.off_act, function()
          self:_RemoveCreature(last_target.data.id)
          local targetConfig = self.config.npcCfg[self.seqIndex]
          if targetConfig then
            local target = self:_CreateCreature(self.id * 100 + self.seqIndex, targetConfig[5], targetConfig, targetConfig[4])
            self:TargetPlayFreePlot(target, self.config.on_act)
            table.insert(self.seqTargets, target.data.id)
          end
          self.pending_next_target = false
        end)
        self.pending_next_target = true
      end
    else
    end
  else
    self:Abort(true)
    return true
  end
end

function LocalSimpleAIRunner_SeqVisit:Abort(result)
  self.result = result
  if self.result then
    if self.config.fin_act and self.target then
      self:TargetPlayFreePlot(self.target, self.config.fin_act, function()
        if self.successCallback then
          self.successCallback()
        end
      end)
    elseif self.successCallback then
      self.successCallback()
    end
  elseif self.config.fail_act and self.target then
    self:TargetPlayFreePlot(self.target, self.config.fail_act, function()
      if self.failCallback then
        self.failCallback()
      end
    end)
  elseif self.failCallback then
    self.failCallback()
  end
end

function LocalSimpleAIRunner_SeqVisit.GetRunnerCenterPos(config)
  local posSet = config.npcCfg
  if posSet then
    local pos = LuaVector3.Zero()
    for i = 1, #posSet do
      LuaVector3.Better_Add(pos, posSet[i], pos)
    end
    LuaVector3.Better_Mul(pos, 1 / #posSet, pos)
    return pos
  end
end
