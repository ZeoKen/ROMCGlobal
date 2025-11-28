local MyselfIdleAI_HandInHand = class("MyselfIdleAI_HandInHand", IdleAI_HandInHand)
local eventManager

function MyselfIdleAI_HandInHand:ctor()
  MyselfIdleAI_HandInHand.super.ctor(self)
  self.running = false
  self.on = false
  if not eventManager then
    eventManager = EventManager.Me()
  end
end

function MyselfIdleAI_HandInHand:Set(on)
  self.on = on
end

function MyselfIdleAI_HandInHand:Clear(idleElapsed, time, deltaTime, creature)
  MyselfIdleAI_HandInHand.super.Clear(self, idleElapsed, time, deltaTime, creature)
  self.running = false
end

function MyselfIdleAI_HandInHand:Prepare(idleElapsed, time, deltaTime, creature)
  return self.on and MyselfIdleAI_HandInHand.super.Prepare(self, idleElapsed, time, deltaTime, creature)
end

function MyselfIdleAI_HandInHand:Start(idleElapsed, time, deltaTime, creature)
  MyselfIdleAI_HandInHand.super.Start(self, idleElapsed, time, deltaTime, creature)
  self.running = true
end

function MyselfIdleAI_HandInHand:End(idleElapsed, time, deltaTime, creature)
  MyselfIdleAI_HandInHand.super.End(self, idleElapsed, time, deltaTime, creature)
  self.running = false
end

local MyselfIdleAI_DoubleAction = class("MyselfIdleAI_DoubleAction", IdleAI_DoubleAction)

function MyselfIdleAI_DoubleAction:ctor()
  MyselfIdleAI_DoubleAction.super.ctor(self)
  self.running = false
  self.on = false
end

function MyselfIdleAI_DoubleAction:Set(on)
  self.on = on
end

function MyselfIdleAI_DoubleAction:Start(idleElapsed, time, deltaTime, creature)
  MyselfIdleAI_DoubleAction.super.Start(self, idleElapsed, time, deltaTime, creature)
  self.running = true
end

function MyselfIdleAI_DoubleAction:Prepare(idleElapsed, time, deltaTime, creature)
  if not self.on then
    return false
  end
  return MyselfIdleAI_DoubleAction.super.Prepare(self, idleElapsed, time, deltaTime, creature)
end

function MyselfIdleAI_DoubleAction:_SwitchToConnecting(idleElapsed, time, deltaTime, creature, masterCreature)
  local connecting = MyselfIdleAI_DoubleAction.super._SwitchToConnecting(self, idleElapsed, time, deltaTime, creature, masterCreature)
  if connecting then
    creature:Logic_SetDoubleActionState(self.masterGUID, true)
  end
end

function MyselfIdleAI_DoubleAction:End(idleElapsed, time, deltaTime, creature)
  creature:Logic_SetDoubleActionState(self.masterGUID, false)
  MyselfIdleAI_DoubleAction.super.End(self, idleElapsed, time, deltaTime, creature, true)
end

IdleAI_FollowLeader = class("IdleAI_FollowLeader")
FunctionFollowCaptainEvent = {
  StateChanged = "E_FunctionFollowCaptain_StateChanged"
}
local OffsetRange = 4
local InnerRange = 1
local ReteleportTime = 0.5
local ReteleportDistance = 9
local CallFollowTransferCmdInterval = 1
local CallGoMapFollowUserCmdInterval = 1
local CallGoMapWhenInDifferentRaidsInterval = 5
local LeaderTargetValidDuration = 2

function IdleAI_FollowLeader:ctor()
  self.leaderID = 0
  self.autoBattleOn = false
  self.autoBattle = AutoBattle.new()
  self.prevUpdateTime = nil
  self.goFromMapID = nil
  self.goMapID = nil
  self.nextTimeCallFollowTransferCmd = 0
  self.nextTimeCallGoMapFollowUserCmd = 0
  self.requestLeaderID = 0
  self.requestHandInHandOn = nil
  self.requestDoubleAction = nil
  self.requestMoveToMapID = nil
  self.requestMoveToMapPos = nil
  self.subAIManager = IdleAIManager.new()
  self.subAI_DoubleAction = MyselfIdleAI_DoubleAction.new()
  self.subAIManager:PushAI(self.subAI_DoubleAction)
  self.subAI_HandInHand = MyselfIdleAI_HandInHand.new()
  self.subAIManager:PushAI(self.subAI_HandInHand)
  self.exitPointDisable = false
  self.prevHandInHandRunning = false
  self.leaderTargetID = 0
  self.leaderTargetIDValidTime = 0
  self.delay = 0
end

function IdleAI_FollowLeader:_NotifyHandInHand(time, deltaTime, creature)
  if self.prevHandInHandRunning == self.subAI_HandInHand.running then
    return
  end
  self.prevHandInHandRunning = self.subAI_HandInHand.running
  creature:Logic_SetHandInHandState(self.leaderID, self.subAI_HandInHand.running)
end

function IdleAI_FollowLeader:_SetExitPointDisable(disable)
  if self.exitPointDisable == disable then
    return
  end
  self.exitPointDisable = disable
  Game.AreaTrigger_ExitPoint:SetDisable(disable)
end

function IdleAI_FollowLeader:Clear(idleElapsed, time, deltaTime, creature)
  self:ResetMoveCMD(nil)
  self:_ClearMoveToMap()
  self.requestLeaderID = 0
  self.requestHandInHandOn = nil
  self.requestDoubleAction = nil
  self:_SwitchLeader(0, nil, nil, creature)
  self:_NotifyHandInHand(time, deltaTime, creature)
  self.subAIManager:Clear(idleElapsed, time, deltaTime, creature)
  self:_SetExitPointDisable(false)
  self.leaderTargetID = 0
  self.leaderTargetIDValidTime = 0
  self.delay = 0
end

function IdleAI_FollowLeader:Prepare(idleElapsed, time, deltaTime, creature)
  if nil ~= creature.ai.parent and not creature.ai.forceUpdate then
    return false
  end
  local oldLeader = self.leaderID
  self:_SwitchLeader(self.requestLeaderID, self.requestIgnoreNotifyServer, self.requestDoubleAction, creature)
  if nil ~= self.requestDoubleAction then
    self.subAI_DoubleAction:Set(self.requestDoubleAction)
    self.requestDoubleAction = nil
  end
  local oldHandInHandOn = self.subAI_HandInHand.on
  if nil ~= self.requestHandInHandOn then
    self.subAI_HandInHand:Set(self.requestHandInHandOn)
    self.requestHandInHandOn = nil
  end
  if oldLeader ~= self.leaderID or oldHandInHandOn ~= self.subAI_HandInHand.on then
    eventManager:DispatchEvent(FunctionFollowCaptainEvent.StateChanged, self)
  end
  return 0 ~= self.leaderID
end

function IdleAI_FollowLeader:Start(idleElapsed, time, deltaTime, creature)
  if 0 < self.delay then
    self.delay = time + 1
  end
end

function IdleAI_FollowLeader:End(idleElapsed, time, deltaTime, creature)
  self:ResetMoveCMD(nil)
  self:_ClearMoveToMap()
  self.subAIManager:Break(idleElapsed, time, deltaTime, creature)
  self:_NotifyHandInHand(time, deltaTime, creature)
  self:_SetExitPointDisable(false)
  if 1 ~= self.delay then
    self.delay = 0
  end
end

function IdleAI_FollowLeader:Update(idleElapsed, time, deltaTime, creature)
  local resultAction
  if not self.skipTeamCheck then
    if not TeamProxy.Instance:IHaveTeam() then
      self:Request_Set(0, true)
      return false
    end
    local myTeam = TeamProxy.Instance.myTeam
    local leader = myTeam:GetMemberByGuid(self.leaderID)
    if nil == leader then
      self:Request_Set(0, true)
      return false
    end
    local myTeamData = myTeam:GetMemberByGuid(Game.Myself.data.id)
    FollowFun.follower.serverid = myTeamData.serverid
    FollowFun.befollower.serverid = leader.serverid
    FollowFun.follower.zoneid = myTeamData.zoneid
    FollowFun.befollower.zoneid = leader.zoneid
    FollowFun.follower.realzoneid = myTeamData.realzoneid
    FollowFun.befollower.realzoneid = leader.realzoneid
    FollowFun.follower.sceneid = myTeamData.sceneid
    FollowFun.befollower.sceneid = leader.sceneid
    FollowFun.follower.mapid = myTeamData.mapid
    FollowFun.befollower.mapid = leader.mapid
    FollowFun.follower.raidid = myTeamData.raid
    FollowFun.befollower.raidid = leader.raid
    FollowFun.follower.guildid = myTeamData.guildid
    FollowFun.befollower.guildid = leader.guildid
    FollowFun.follower.honeymooncomplete = false
    FollowFun.befollower.honeymooncomplete = false
    FollowFun.follower.baselv = myTeamData.baselv
    FollowFun.befollower.baselv = leader.baselv
    FollowFun.follower.tf = EnvChannel.IsTFBranch()
    FollowFun.follower.time = ServerTime.CurServerTime() / 1000
    resultAction = FollowFun.checkFollow().action
    if FollowFun.Result.msgid ~= 0 and FollowFun.Result.msgid ~= 99999 then
      self:Request_Set(0, true)
    end
  end
  if nil ~= self.prevUpdateTime then
    deltaTime = time - self.prevUpdateTime
  end
  self.prevUpdateTime = time
  local mapID = self.requestMoveToMapID
  if nil ~= mapID and 0 ~= mapID then
    local pos = self.requestMoveToMapPos
    self.requestMoveToMapID = nil
    self.requestMoveToMapPos = nil
    self:MoveToMap(mapID, pos)
    if nil ~= pos then
      pos:Destroy()
    end
    if nil == self.moveCMD then
      return false
    end
  end
  if self:Follow(time, deltaTime, creature, resultAction) then
    self.subAIManager:Break(idleElapsed, time, deltaTime, creature)
    self:_SetExitPointDisable(false)
  else
    self:_SetExitPointDisable(true)
    self.subAIManager:Update(idleElapsed, time, deltaTime, creature)
  end
  self:_NotifyHandInHand(time, deltaTime, creature)
  return true
end

function IdleAI_FollowLeader:IsMovingTo(mapID, pos)
  if self.moveCMD == nil then
    return false
  end
  local args = self.moveCMD.args
  if not args or args.targetMapID ~= mapID then
    return false
  end
  if pos == nil then
    return args.targetPos == nil
  end
  return args.targetPos and LuaVector3.Equal(pos, args.targetPos)
end

local tempMissionCommandArgs = {}

function IdleAI_FollowLeader:MoveToMap(mapID, pos)
  if 0 == self.leaderID or 0 == mapID then
    return
  end
  if Game.Myself.data:NoMove() then
    return
  end
  if self:IsMovingTo(mapID, pos) then
    return
  end
  tempMissionCommandArgs.targetMapID = mapID
  tempMissionCommandArgs.targetPos = pos
  tempMissionCommandArgs.customType = AccessCustomType.Follow
  local cmd = MissionCommandFactory.CreateCommand(tempMissionCommandArgs, MissionCommandMove)
  TableUtility.TableClear(tempMissionCommandArgs)
  self:ResetMoveCMD(cmd)
  self.moveFromMap = Game.MapManager:GetMapID()
  self.moveToMap = mapID
  if nil ~= pos then
    self.moveToPos = VectorUtility.Asign_3(self.moveToPos, pos)
  elseif nil ~= self.moveToPos then
    LuaVector3.Destroy(self.moveToPos)
    self.moveToPos = nil
  end
end

function IdleAI_FollowLeader:ResetMoveCMD(cmd)
  if nil ~= self.moveCMD then
    self.moveCMD:Shutdown()
    self.moveCMD:Destroy()
  end
  self.moveCMD = cmd
  if nil ~= self.moveCMD then
    self.moveCMD:Launch()
  end
end

function IdleAI_FollowLeader:Attack(creature, targetCreature)
  if nil ~= targetCreature then
    return self.autoBattle:Attack(creature, targetCreature)
  else
    return self.autoBattle:Attack(creature, targetCreature, nil, true)
  end
end

function IdleAI_FollowLeader:DoCallGoMap(fromMapID, mapID, userID, time)
  if time > self.nextTimeCallGoMapFollowUserCmd then
    self.nextTimeCallGoMapFollowUserCmd = time + CallGoMapFollowUserCmdInterval
    ServiceNUserProxy.Instance:CallGoMapFollowUserCmd(mapID, userID)
    self.goFromMapID = fromMapID
    self.goMapID = mapID
    self:ResetMoveCMD(nil)
    self.isInDifferentRaids = nil
  end
end

function IdleAI_FollowLeader:TryCallGoMap(leader, time)
  local currentMapID, leaderMapID = Game.MapManager:GetMapID(), leader.mapid
  local currentRaidID, leaderRaidID = Game.MapManager:GetRaidID(), leader.raid or 0
  if currentRaidID == 0 then
    currentRaidID = ServicePlayerProxy.Instance:GetCurMapImageId() or 0
  end
  local doCallGoMapAction = function()
    if leaderMapID ~= self.goMapID and nil ~= leaderMapID and 0 ~= leaderMapID then
      self:DoCallGoMap(currentMapID, leaderMapID, leader.id, time)
      return true
    end
    return false
  end
  if currentRaidID ~= leaderRaidID then
    if not self.isInDifferentRaids then
      self.isInDifferentRaids = true
      self.nextTimeCallGoMapFollowUserCmd = time + CallGoMapWhenInDifferentRaidsInterval
    end
    return doCallGoMapAction()
  elseif currentMapID ~= leaderMapID then
    return doCallGoMapAction()
  end
  local myZoneID = Game.Myself.data.userdata:Get(UDEnum.ZONEID)
  if currentMapID == leaderMapID and not ChangeZoneProxy.Instance:IsCommonLine(myZoneID) and ChangeZoneProxy.Instance:IsCommonLine(leader.zoneid) then
    local config = Table_Map[leaderMapID]
    local isCommonLine = config and config.IsCommonline
    if isCommonLine then
      self:DoCallGoMap(currentMapID, leaderMapID, leader.id, time)
      return true
    end
  end
  local myTeam = TeamProxy.Instance.myTeam
  local myTeamData = myTeam and myTeam:GetMemberByGuid(Game.Myself.data.id)
  if myTeamData and myTeamData.sceneid ~= leader.sceneid then
    self:DoCallGoMap(currentMapID, leaderMapID, leader.id, time)
    return true
  end
  self.goFromMapID = nil
  self.goMapID = nil
  return false
end

function IdleAI_FollowLeader:TryAttack(time, myTeam, leader, creature)
  if not self.autoBattleOn then
    return false
  end
  local targetCreature
  local teamTargetID = 0
  if nil ~= self.leaderTargetID and 0 ~= self.leaderTargetID then
    if time < self.leaderTargetIDValidTime then
      teamTargetID = self.leaderTargetID
    else
      self.leaderTargetID = 0
      self.leaderTargetIDValidTime = 0
    end
  end
  if 0 ~= teamTargetID then
    targetCreature = SceneCreatureProxy.FindCreature(teamTargetID)
  end
  return self:Attack(creature, targetCreature)
end

function IdleAI_FollowLeader:Follow(time, deltaTime, creature, action)
  if self.skipTeamCheck then
    local leaderCreature = SceneCreatureProxy.FindCreature(self.leaderID)
    if not leaderCreature then
      return true
    end
    return self:FollowMove(time, deltaTime, creature, leaderCreature:GetPosition())
  end
  local myTeam = TeamProxy.Instance.myTeam
  local leader = myTeam and myTeam:GetMemberByGuid(self.leaderID)
  if not leader and not self.skipTeamCheck then
    LogUtility.Warning("Cannot find leader from my team when skipTeamCheck == nil. What happened??")
    return true
  end
  if action ~= FollowFun.Action.EFOLLOWACTION_WALK then
    self:TryCallGoMap(leader, time)
    return true
  elseif self:TryCallGoMap(leader, time) then
    return true
  end
  if nil ~= self.goMapID then
    if 0 < self.delay then
      if time < self.delay then
        return true
      else
        self.delay = 0
      end
    end
    local currentMapID = Game.MapManager:GetMapID()
    if nil ~= self.moveCMD then
      if self.moveFromMap ~= currentMapID then
        self:MoveToMap(self.moveToMap)
      else
        self.moveCMD:Update(time, deltaTime)
        if not self.moveCMD.running then
          self:ResetMoveCMD(nil)
        elseif not creature:IsMoving() and deltaTime > ReteleportTime then
          self:MoveToMap(self.moveToMap)
        end
      end
    elseif self.goFromMapID ~= currentMapID then
      self.goFromMapID = nil
      self.goMapID = nil
    elseif nil ~= self.moveToMap then
      self:MoveToMap(self.moveToMap)
    end
    return true
  end
  if self:TryAttack(time, nil, nil, creature) then
    self:ResetMoveCMD(nil)
    return true
  end
  local leaderPos
  local leaderCreature = SceneCreatureProxy.FindCreature(leader.id)
  if leaderCreature then
    leaderPos = leaderCreature:GetPosition()
  elseif leader.pos_seted then
    leaderPos = leader.pos
  end
  return self:FollowMove(time, deltaTime, creature, leaderPos)
end

function IdleAI_FollowLeader:FollowMove(time, deltaTime, creature, followPos)
  if 0 < self.delay then
    if time < self.delay then
      return true
    else
      self.delay = 0
    end
  end
  if nil ~= self.subAIManager.currentAI then
    return false
  end
  if followPos == nil then
    return true
  end
  if nil == self.moveToPos or ReteleportDistance < VectorUtility.DistanceXZ_Square(self.moveToPos, followPos) then
    self:MoveToMap(nil, followPos)
    if nil == self.moveCMD and not creature.data:NoMove() then
      self:Request_Set(0)
      return true
    end
  end
  if nil ~= self.moveCMD then
    self.moveCMD:Update(time, deltaTime)
  end
  local myPosition = creature:GetPosition()
  local distance = VectorUtility.DistanceXZ_Square(followPos, myPosition)
  if distance > OffsetRange then
    if nil ~= self.moveCMD then
      if not self.moveCMD.running then
        self:ResetMoveCMD(nil)
      end
    elseif time > self.nextTimeCallFollowTransferCmd then
      self.nextTimeCallFollowTransferCmd = time + CallFollowTransferCmdInterval
      self:MoveToMap(nil, followPos)
      if nil == self.moveCMD and not creature.data:NoMove() then
        self:Request_Set(0)
        return true
      end
    end
  elseif distance < InnerRange then
    if nil ~= self.moveCMD then
      self:ResetMoveCMD(nil)
    end
    return false
  elseif nil == self.moveCMD or not self.moveCMD.running then
    return false
  end
  return true
end

function IdleAI_FollowLeader:OnExitedTeam(event)
  if event.data == TeamProxy.ExitType.ServerExit then
    self:Request_Set(0, true)
  end
end

function IdleAI_FollowLeader:_SwitchLeader(newLeaderID, ignoreNotifyServer, forDoubleAction, creature)
  if self.leaderID == newLeaderID then
    return
  end
  self.leaderID = newLeaderID
  self.subAI_DoubleAction:Request_Set(newLeaderID)
  self.subAI_HandInHand:Request_Set(newLeaderID)
  if 0 ~= self.leaderID then
    Game.AutoBattleManager:SetController(self)
    Game.AutoBattleManager:AutoBattleOn()
    if not self.exitTeamListenerAdded then
      eventManager:AddEventListener(TeamEvent.ExitTeam, self.OnExitedTeam, self)
      self.exitTeamListenerAdded = true
    end
    self.skipTeamCheck = forDoubleAction and true or false
  else
    Game.AutoBattleManager:ClearController(self, true)
    self:ResetMoveCMD(nil)
    self.prevUpdateTime = nil
    self.goFromMapID = nil
    self.goMapID = nil
    self.nextTimeCallFollowTransferCmd = 0
    self.nextTimeCallGoMapFollowUserCmd = 0
    if self.exitTeamListenerAdded then
      eventManager:RemoveEventListener(TeamEvent.ExitTeam, self.OnExitedTeam, self)
      self.exitTeamListenerAdded = nil
    end
    if self.skipTeamCheck then
      self.skipTeamCheck = nil
      ignoreNotifyServer = false
    end
    if not ignoreNotifyServer then
      ServiceNUserProxy.Instance:CallFollowerUser(0)
    end
  end
end

function IdleAI_FollowLeader:_ClearMoveToMap()
  self.requestMoveToMapID = nil
  if nil ~= self.requestMoveToMapPos then
    LuaVector3.Destroy(self.requestMoveToMapPos)
    self.requestMoveToMapPos = nil
  end
end

function IdleAI_FollowLeader:IsHandInHand()
  return self.subAI_HandInHand.on
end

function IdleAI_FollowLeader:Request_MoveToMap(mapID, pos)
  LogUtility.InfoFormat("<color=yellow>Follow Request_MoveToMap: </color>{0}, {1}", mapID, pos)
  if 0 == mapID then
    self.requestMoveToMapID = nil
    return
  end
  if self:IsMovingTo(mapID, pos) then
    return
  end
  self.requestMoveToMapID = mapID
  if nil ~= pos then
    self.requestMoveToMapPos = VectorUtility.TryAsign_3(self.requestMoveToMapPos, pos)
  elseif nil ~= self.requestMoveToMapPos then
    LuaVector3.Destroy(self.requestMoveToMapPos)
    self.requestMoveToMapPos = nil
  end
end

function IdleAI_FollowLeader:Request_Set(leaderID, ignoreNotifyServer)
  LogUtility.InfoFormat("<color=yellow>Follow Request_Set: </color>{0}", leaderID)
  self.requestLeaderID = leaderID
  self.requestIgnoreNotifyServer = ignoreNotifyServer
end

function IdleAI_FollowLeader:Request_SetDoubleAction(on)
  self.requestDoubleAction = on
end

function IdleAI_FollowLeader:Request_SetHandInHand(on)
  self.requestHandInHandOn = on
end

function IdleAI_FollowLeader:Request_SetHandInHandState(running)
  self.prevHandInHandRunning = running
end

function IdleAI_FollowLeader:Request_RefreshLeaderTarget(guid, time)
  if 0 ~= guid then
    self.leaderTargetID = guid
    self.leaderTargetIDValidTime = time + LeaderTargetValidDuration
  else
    self.leaderTargetID = 0
    self.leaderTargetIDValidTime = 0
  end
end

function IdleAI_FollowLeader:Request_Delay()
  self.delay = 1
end

function IdleAI_FollowLeader:AutoBattleOn()
  self.autoBattleOn = true
end

function IdleAI_FollowLeader:AutoBattleOff()
  self.autoBattleOn = false
end

function IdleAI_FollowLeader:AutoBattleLost()
  self:AutoBattleOff()
end
