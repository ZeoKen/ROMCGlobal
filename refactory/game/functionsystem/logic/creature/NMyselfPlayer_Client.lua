local tmpVector3 = LuaVector3.Zero()
local tempCreatureArray = {}
local log = LogUtility.Info
local tempArray = {}
local FakeNormalAtk = GameConfig.FakeNormalAtk
local NotifyServerAngleYInterval = 0.3

function NMyselfPlayer:Client_PlaceXYZTo(x, y, z, div, ignoreNavMesh)
  LuaVector3.Better_Set(tmpVector3, x, y, z)
  if div ~= nil then
    LuaVector3.Div(tmpVector3, div)
  end
  self:Client_PlaceTo(tmpVector3, ignoreNavMesh)
end

function NMyselfPlayer:Client_PlaceTo(pos, ignoreNavMesh)
  self.ai:PushCommand(FactoryAICMD.Me_GetPlaceToCmd(pos, ignoreNavMesh), self)
end

function NMyselfPlayer:Client_MoveXYZTo(x, y, z, div, ignoreNavMesh, callback, callbackOwner, callbackCustom)
  LuaVector3.Better_Set(tmpVector3, x, y, z)
  if div ~= nil then
    LuaVector3.Div(tmpVector3, div)
  end
  self:Client_MoveTo(tmpVector3, ignoreNavMesh, callback, callbackOwner, callbackCustom)
end

function NMyselfPlayer:Client_SetDirCmd(mode, dir, noSmooth)
  self.ai:PushCommand(FactoryAICMD.Me_GetSetAngleYCmd(mode, dir, noSmooth), self)
end

function NMyselfPlayer:Client_MoveTo(pos, ignoreNavMesh, callback, callbackOwner, callbackCustom, range, customMoveActionName)
  self.ai:PushCommand(FactoryAICMD.Me_GetMoveToCmd(pos, ignoreNavMesh, callback, callbackOwner, callbackCustom, range), self)
end

function NMyselfPlayer:Client_DirMove(dir, ignoreNavMesh, customMoveActionName)
  self.ai:PushCommand(FactoryAICMD.Me_GetDirMoveCmd(dir, ignoreNavMesh, customMoveActionName), self)
end

function NMyselfPlayer:Client_DirMoveEnd(customIdleAction)
  self.ai:PushCommand(FactoryAICMD.Me_GetDirMoveEndCmd(customIdleAction), self)
end

function NMyselfPlayer:Client_PlayAction(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression, blendContext, ignoreWeapon)
  self.ai:PushCommand(FactoryAICMD.Me_GetPlayActionCmd(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression, blendContext, ignoreWeapon), self)
end

function NMyselfPlayer:Client_PlayAction2(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression)
  self.ai:PushCommand(FactoryAICMD.Me_GetPlayActionCmd(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression), self)
end

function NMyselfPlayer:Client_PlayActionMove(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, spExpression, ignoreWeapon)
  name = name or self:GetMoveAction()
  local moveActionScale = 1
  local staticData = self.data.staticData
  if nil ~= staticData and nil ~= staticData.MoveSpdRate then
    moveActionScale = staticData.MoveSpdRate
  end
  local moveSpeed = self.data.props:GetPropByName("MoveSpd"):GetValue()
  local actionSpeed = self.moveActionSpd or moveActionScale * moveSpeed
  self.ai:PushCommand(FactoryAICMD.Me_GetPlayActionCmd(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression, nil, ignoreWeapon), self)
end

function NMyselfPlayer:Client_PlayActionIdle(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression, ignoreWeapon)
  name = name or self:GetIdleAction()
  self.ai:PushCommand(FactoryAICMD.Me_GetPlayActionCmd(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression, nil, ignoreWeapon), self)
end

function NMyselfPlayer:Client_PlayHolyAction(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression)
  self.ai:PushCommand(FactoryAICMD.Me_GetPlayHolyActionCmd(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression), self)
end

function NMyselfPlayer:Client_PlayHolyActionAndNotifyServer(actionID, loop)
  local actionInfo = Table_ActionAnime[actionID]
  if nil == actionInfo then
    return
  end
  self:Client_PlayHolyAction(actionInfo.Name, nil, loop)
  ServiceNUserProxy.Instance:CallUserActionNtf(self.data.id, actionID, loop and SceneUser2_pb.EUSERACTIONTYPE_MOTION or SceneUser2_pb.EUSERACTIONTYPE_NORMALMOTION)
end

function NMyselfPlayer:Client_PlayMotionAction(actionID, once)
  local actionInfo = Table_ActionAnime[actionID]
  if nil == actionInfo then
    return
  end
  self:Client_PlayAction(actionInfo.Name, nil, not once)
  ServiceNUserProxy.Instance:CallUserActionNtf(self.data.id, actionID, SceneUser2_pb.EUSERACTIONTYPE_MOTION, nil, once)
end

function NMyselfPlayer:Client_PlayNormalMotinAction(actionID)
  local actionInfo = Table_ActionAnime[actionID]
  if nil == actionInfo then
    return
  end
  self:Client_PlayAction(actionInfo.Name, nil, false)
  ServiceNUserProxy.Instance:CallUserActionNtf(self.data.id, actionID, SceneUser2_pb.EUSERACTIONTYPE_NORMALMOTION)
end

function NMyselfPlayer:Client_LockTarget(creature)
  if self == creature then
    return
  end
  if creature then
    if creature:GetClickable() then
      if not creature.data:IsMonster() then
        ServicePlayerProxy.Instance:CallMapObjectData(creature.data.id)
      end
      Game.LockTargetEffectManager:SwitchLockedTarget(creature)
    else
      Game.LockTargetEffectManager:ClearLockedTarget()
      creature = nil
    end
  else
    Game.LockTargetEffectManager:ClearLockedTarget()
  end
  self:SetWeakData(NMyselfPlayer.WeakKey_LockTarget, creature)
  GameFacade.Instance:sendNotification(MyselfEvent.SelectTargetChange, creature)
  EventManager.Me():DispatchEvent(MyselfEvent.SelectTargetChange, creature)
end

function NMyselfPlayer:Client_AccessTarget(creature, custom, customDeleter, customType, accessRange)
  local myself = Game.Myself
  if myself.data and myself.data.userdata then
    local dressup = myself.data.userdata:Get(UDEnum.DRESSUP)
    if dressup == 1 or dressup == 2 then
      return
    end
  end
  self.ai:PushCommand(FactoryAICMD.Me_GetAccessCmd(creature, nil, accessRange, custom, customDeleter, customType), self)
end

function NMyselfPlayer:Client_ArrivedAccessTarget(creature, custom, customType)
  if creature then
    FunctionVisitNpc.Me():AccessTarget(creature, custom, customType)
  else
    errorLog("访问到达目标不存在")
  end
end

local zone_display_time = GameConfig.Weather and GameConfig.Weather.zone_display_time

function NMyselfPlayer:Client_MoveHandler(destination)
  if Game.LogicManager_HandInHand then
    Game.LogicManager_HandInHand:TryBreakMyDoubleAction()
  end
  local clientskill = Game.Myself.skill
  if clientskill:IsCastingMoveRunSkill() then
    clientskill:_SwitchToAttack(Game.Myself)
    self:Logic_LookAtTargetPos()
  elseif clientskill:IsCastingMoveBreakSkill() then
    self:Client_BreakSkillLead(clientskill:GetSkillID(), true)
  end
  EventManager.Me():PassEvent(MyselfEvent.StartToMove)
  if FunctionCheck.Me():CanSyncMove() then
    self:SyncServer_MoveTo(destination)
  end
  self:Client_EnterARegion()
end

function NMyselfPlayer:Client_EnterARegion(force)
  local regionID, regionConfig = Game.MapManager:GetMyRegionInfo()
  if force or self.regionID ~= regionID then
    self.regionID = regionID
    local bgm, bgmType = FunctionBGMCmd.Me():GetNowBgm()
    if regionConfig then
      if force or bgm ~= regionConfig.BGM or bgmType ~= FunctionBGMCmd.BgmSort.Region then
        if not self.regionBgmTime or UnityTime - self.regionBgmTime > 10 then
          self.regionBgmTime = UnityTime
          if regionConfig.BGM and regionConfig.BGM ~= "" then
            FunctionBGMCmd.Me():PlayRegionBgm(regionConfig.BGM, 0, 1, 3)
          else
            FunctionBGMCmd.Me():StopRegionBgm()
          end
        else
          if self.ltTick then
            TimeTickManager.Me():ClearTick(self, 111)
          end
          self.ltTick = TimeTickManager.Me():CreateOnceDelayTick(11000, function()
            self.ltTick = nil
            self:Client_EnterARegion(true)
          end, self, 111)
        end
      end
      if regionConfig.Type == 3 and (not self.zoneDisplayTime or UnityTime - self.zoneDisplayTime > 300) then
        self.zoneDisplayTime = UnityTime
        FloatingPanel.Instance:ShowMapName(regionConfig.NameZh, regionConfig.Desc, true, true, "tip/MapNameTip_1", zone_display_time)
      end
    elseif bgmType == FunctionBGMCmd.BgmSort.Region and bgm then
      FunctionBGMCmd.Me():StopRegionBgm()
    end
  end
end

function NMyselfPlayer:SyncServer_MoveTo(destination)
  self.dstV3 = self.dstV3 or {}
  self.dstV3[1] = destination[1]
  self.dstV3[2] = destination[2]
  self.dstV3[3] = destination[3]
  if self.syncTimeTick and UnityTime - self.syncTimeTick < 0.15 then
    if not self.waitTick then
      self.waitTick = TimeTickManager.Me():CreateOnceDelayTick(150, function()
        self.waitTick = nil
        if Game.Myself.skill.info and Game.Myself.skill.info:GetRotateOnly() and Game.Myself.skill:IsCastingSkill() then
          return
        end
        if FunctionCheck.Me():CanSyncMove() then
          self.syncTimeTick = UnityTime
          ServicePlayerProxy.Instance:CallMoveTo(self.dstV3[1], self.dstV3[2], self.dstV3[3])
        end
      end, self, 1225)
    end
    return
  end
  self.syncTimeTick = UnityTime
  ServicePlayerProxy.Instance:CallMoveTo(self.dstV3[1], self.dstV3[2], self.dstV3[3])
end

function NMyselfPlayer:Client_UseSkillHandler(random, phaseData, targetCreatureGUID, isTrigger, manual)
  if self.disableSkillBroadcast then
    return
  end
  if self.skill.info and self.skill.info:GetRotateOnly() then
    local p = phaseData:GetPosition()
    if p then
      self.logicTransform:LookAt(p)
      self:Client_SyncRotationY(self.logicTransform:GetCurAngleY())
    end
  end
  local skillID = phaseData:GetSkillID()
  local sortID = skillID // 1000
  if self.data.startForgetting and self.data:GetAttackSkillIDAndLevel() ~= skillID then
    SkillProxy.Instance:SetSkillInForgetTime(sortID, self.data:GetForgetDuration())
    EventManager.Me():PassEvent(MyselfEvent.ForgetSkill_Start, sortID)
  end
  self:SetNextNormalAttack(skillID)
  ServicePlayerProxy.Instance:CallSkillBroadcast(random, phaseData, self, targetCreatureGUID, isTrigger, manual)
  local id, phase = phaseData:GetSkillID(), phaseData:GetSkillPhase()
  redlog("使用技能:" .. id .. ", " .. phase)
  EventManager.Me():PassEvent(MyselfEvent.BeginSkillBroadcast, {id, phase})
end

function NMyselfPlayer:Client_AutoAttackTarget(targetCreature)
  if MyselfProxy.Instance:IsProfessionCook() then
    return
  end
  if not MyselfProxy.Instance.selectAutoNormalAtk and not self:Logic_IsBeTaunt() then
    return
  end
  local id = self:GetFakeNormalAtkID()
  id = id or self.data:GetAttackSkillIDAndLevel()
  if id == 0 then
    return
  end
  if Game.SkillComboManager:PushSkill(id) then
    return
  end
  if FunctionSkill.Me().isCasting then
    local info = Game.Myself.skill.info
    if info and info:CanClientInterrupt() and not info:CanUseOtherSkill(id, self) then
      return
    end
  end
  self:Client_UseSkill(id, targetCreature, nil, false, true)
end

function NMyselfPlayer:Client_AttackTarget(targetCreature)
  local id = self:GetFakeNormalAtkID()
  id = id or self.data:GetAttackSkillIDAndLevel()
  if id == 0 then
    return
  end
  if FunctionSkill.Me().isCasting then
    local info = Game.Myself.skill.info
    if info and info:CanClientInterrupt() and not info:CanUseOtherSkill(id, self) then
      return
    end
  end
  self:Client_UseSkill(id, targetCreature, nil, false, true)
end

function NMyselfPlayer:Client_BreakSkillLead(skillID, manual)
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillID)
  if skillInfo:CanClientInterrupt() then
    local phaseData = SkillPhaseData.Create(skillID)
    phaseData:SetSkillPhase(SkillPhase.None)
    self:Client_UseSkillHandler(0, phaseData, nil, nil, manual)
    self:Server_BreakSkill(skillID)
    phaseData:Destroy()
    phaseData = nil
    return true
  end
  return false
end

function NMyselfPlayer:Client_QuickUseSkill(skillID, targetCreature, targetPosition, forceTargetCreature, skillPhase, random, manual)
  skillPhase = skillPhase or SkillPhase.Attack
  random = random or 0
  local phaseData = SkillPhaseData.Create(skillID)
  phaseData:SetSkillPhase(skillPhase)
  if targetPosition then
    phaseData:SetPosition(targetPosition)
  end
  self:Client_UseSkillHandler(random, phaseData, nil, nil, manual)
  self:Client_PlayUseSkill(phaseData)
  phaseData:Destroy()
  phaseData = nil
  return true
end

function NMyselfPlayer:Client_UseSkill(skillID, targetCreature, targetPosition, forceTargetCreature, noSearch, searchFilter, allowResearch, noLimit, ignoreCast, autoInterrupt, manual, autolock)
  if self == targetCreature then
    targetCreature = nil
    forceTargetCreature = false
  end
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillID)
  if skillInfo:GetSkillType() == SkillType.FakeDead and self:IsFakeDead() then
    local phaseData = SkillPhaseData.Create(skillID)
    phaseData:SetSkillPhase(SkillPhase.Attack)
    self:Client_UseSkillHandler(0, phaseData, nil, nil, manual)
    phaseData:Destroy()
    phaseData = nil
    return true
  end
  if (skillInfo:GetSkillType() == SkillType.Ensemble or skillInfo:GetSkillType() == SkillType.EnsembleDouble) and self:Logic_CanUseEnsembleSkill(skillInfo) == false then
    return false
  end
  if SkillTargetType.Point == skillInfo:GetTargetType(self) and targetPosition ~= nil and not ignoreCast then
    local isEarthMagic = skillInfo:IsEarthMagic(self)
    local isElementTrap = skillInfo:IsElementTrap(self)
    local isSelfStartTrap = skillInfo:IsSelfStartTrap(self)
    if isEarthMagic or isElementTrap then
      local trapMap = SceneTrapProxy.Instance:GetAll()
      local _LogicManager_Skill = Game.LogicManager_Skill
      local _DistanceXZ = VectorUtility.DistanceXZ_Square
      local selfPos
      if isSelfStartTrap then
        selfPos = self:GetPosition()
      end
      local data
      for k, v in pairs(trapMap) do
        data = _LogicManager_Skill:GetSkillInfo(v.skillID)
        if data ~= nil and (isEarthMagic and data:NoEarthMagic() or isElementTrap and data:NoElementTrap()) and _DistanceXZ(selfPos or targetPosition, v.pos) <= data.logicParam.range * data.logicParam.range then
          return false, 609
        end
      end
    end
  end
  local lockedCreature = self:GetLockTarget()
  local oldTargetCreature = targetCreature
  local teamFirst = skillInfo:TeamFirst(self)
  local hatredFirst = self:IsAutoBattleProtectingTeam() and skillInfo:TargetEnemy(self)
  if not noSearch and nil ~= targetCreature then
    if teamFirst and not targetCreature:IsInMyTeam() then
      targetCreature = nil
    else
      local res, resValue, reason = skillInfo:CheckTarget(self, targetCreature)
      if not res then
        if resValue and resValue == 4 and reason == 1 then
          MsgManager.ShowMsgByIDTable(2216)
        end
        targetCreature = nil
      elseif hatredFirst and skillInfo:TargetOnlyEnemy(creature) and not targetCreature:IsHatred() then
        targetCreature = nil
      end
    end
  end
  if nil == targetCreature then
    if SkillTargetType.Creature == skillInfo:GetTargetType(self) then
      if noSearch then
        return false
      end
      if nil ~= lockedCreature and (not teamFirst or lockedCreature:IsInMyTeam()) and (not hatredFirst or lockedCreature:IsHatred()) and skillInfo:CheckTarget(self, lockedCreature) then
        targetCreature = lockedCreature
      else
        local searchRange = SkillLogic_Base.DefaultSearchRange
        if self:IsAutoBattleStanding() then
          searchRange = skillInfo:GetLaunchRange(self)
        end
        if hatredFirst then
          SkillLogic_Base.SearchTargetInRange(tempCreatureArray, self:GetPosition(), searchRange, skillInfo, self, searchFilter, SkillLogic_Base.SortComparator_HatredFirstDistance)
          targetCreature = tempCreatureArray[1]
          TableUtility.ArrayClear(tempCreatureArray)
          if nil == targetCreature or not targetCreature:IsHatred() then
            local autoBattleLockTarget, lockIDs = self.ai:GetAutoBattleLockTarget(self, skillInfo)
            if nil ~= autoBattleLockTarget then
              targetCreature = autoBattleLockTarget
            elseif nil ~= oldTargetCreature then
              targetCreature = oldTargetCreature
            end
          end
        else
          local autoBattleLockTarget, lockIDs = self.ai:GetAutoBattleLockTarget(self, skillInfo)
          if nil ~= autoBattleLockTarget then
            targetCreature = autoBattleLockTarget
          else
            local sortComparator = teamFirst and SkillLogic_Base.SortComparator_TeamFirstDistance or SkillLogic_Base.SortComparator_Distance
            SkillLogic_Base.SearchTargetInRange(tempCreatureArray, self:GetPosition(), searchRange, skillInfo, self, searchFilter, sortComparator)
            targetCreature = tempCreatureArray[1]
            TableUtility.ArrayClear(tempCreatureArray)
            if nil ~= oldTargetCreature then
              if FunctionPerformanceSetting.Me():GetAutoLockMode() then
                if (nil == targetCreature or teamFirst and not targetCreature:IsInMyTeam()) and skillInfo:CheckTarget(self, oldTargetCreature) then
                  targetCreature = oldTargetCreature
                end
              else
                targetCreature = oldTargetCreature
              end
            end
          end
        end
        if nil ~= targetCreature then
          self:Client_LockTarget(targetCreature)
        else
          if skillInfo:NoPreCheckTarget() then
            MsgManager.ShowMsgByIDTable(43546)
          end
          return false
        end
      end
    elseif SkillTargetType.Point == skillInfo:GetTargetType(self) and nil ~= targetPosition then
      forceTargetCreature = false
    end
  elseif targetCreature ~= lockedCreature then
    if (SkillTargetType.Creature == skillInfo:GetTargetType(self) or forceTargetCreature) and self:IsAutoBattleStanding() then
      local skillLaunchRanage = skillInfo:GetLaunchRange(self)
      if VectorUtility.DistanceXZ_Square(self:GetPosition(), targetCreature:GetPosition()) > skillLaunchRanage * skillLaunchRanage then
        self:Client_ClearAutoBattleCurrentTarget()
        return false
      end
    end
    self:Client_LockTarget(targetCreature)
  end
  if targetCreature and targetCreature:GetCreatureType() == Creature_Type.Npc and (targetCreature.data:GetZoneType() == NpcData.ZoneType.ZONE_FIELD or targetCreature.data:GetZoneType() == NpcData.ZoneType.ZONE_STORM) and not targetCreature.data.isBossFromBranch and not targetCreature.data.noPunishBoss and (targetCreature.data:IsBoss() or targetCreature.data:IsMini()) and self:GetBuffActive(104) then
    local curClientTime = ServerTime.CurClientTime()
    if not self.lastMsgTime or curClientTime - self.lastMsgTime > GameConfig.ChangeZone.buff_remind_interval * 1000 then
      MsgManager.ShowMsgByID(3094)
      self.lastMsgTime = curClientTime
    end
  end
  if ISNoviceServerType then
    local curClientTime = ServerTime.CurClientTime()
    local msgId
    local AttrFunction = self.data:GetProperty("AttrFunction")
    local bitfunc = CommonFun.getBits(AttrFunction)
    if targetCreature and targetCreature:GetCreatureType() == Creature_Type.Npc and targetCreature.data.serverBossType == 1 then
      local furnitureID = targetCreature.data:GetRelativeFurnitureID()
      local isHomeFurniture = furnitureID and not StringUtil.IsEmpty(furnitureID)
      if bitfunc and bitfunc[CommonFun.AttrFunction.MvpLimit] == 1 and not isHomeFurniture and (not self.lastMsgTime_novice or curClientTime - self.lastMsgTime_novice > GameConfig.MvpLimit.MsgInterval) then
        msgId = 43497
      end
    end
    if targetCreature and targetCreature:GetCreatureType() == Creature_Type.Npc and targetCreature.data.serverBossType == 2 then
      local furnitureID = targetCreature.data:GetRelativeFurnitureID()
      local isHomeFurniture = furnitureID and not StringUtil.IsEmpty(furnitureID)
      if bitfunc and bitfunc[CommonFun.AttrFunction.MiniLimit] == 1 and not isHomeFurniture and (not self.lastMsgTime_novice or curClientTime - self.lastMsgTime_novice > GameConfig.MvpLimit.MsgInterval) then
        msgId = 43498
      end
    end
    if msgId then
      MsgManager.ShowMsgByID(msgId)
      self.lastMsgTime_novice = curClientTime
    end
  end
  local isNormalSkill = self.data:GetAttackSkillIDAndLevel() == skillID
  local concurrent = skillInfo:AllowConcurrent(self) and (skillInfo:IsGuideCast(self) or skillInfo:GetCastInfo(self) <= 0.01)
  local ignoreHit = skillInfo:IsHeavyHit()
  if targetCreature and isNormalSkill and Game.MapManager:IsPVPMode_GVGDetailed() then
    local monster_id = targetCreature.data:GetNpcID()
    if monster_id ~= 0 then
      local gvg_mvp_id = GvgProxy.Instance:GetCurMvpId()
      local isGvg_metal = monster_id == GvgProxy.MetalID
      local isGvg_mvp = monster_id == gvg_mvp_id
      if isGvg_metal or isGvg_mvp then
        if not self.data:InGvgZone() then
          local msg_id = GuildProxy.Instance:GetGuildID() and 2667 or 2666
          MsgManager.ShowMsgByIDTable(msg_id)
          return false
        end
        if isGvg_metal and GvgProxy.Instance:IsMvpAlive() then
          MsgManager.ShowMsgByID(2690)
          return false
        end
        if targetCreature.data:GetBuffActive(950) then
          if isGvg_metal then
            local str = GvgProxy.Instance:GetAllProtectMetalStr() or ""
            MsgManager.ShowMsgByIDTable(2668, {str})
          end
          return false
        end
        if targetCreature.data:GetBuffActive(952) and isGvg_mvp then
          MsgManager.ShowMsgByID(2686)
          return false
        end
      elseif GvgProxy.Instance:IsDefSide() then
        return
      end
    end
  end
  self.ai:PushCommand(FactoryAICMD.Me_GetSkillCmd(skillID, targetCreature, targetPosition, nil, forceTargetCreature, allowResearch, noLimit, ignoreCast, isNormalSkill, autoInterrupt, concurrent, ignoreHit, nil, manual, autolock), self)
  return true
end

function NMyselfPlayer:Client_SyncRotationY(y)
  if FunctionCheck.Me():CanSyncAngleY() then
    ServiceNUserProxy.Instance:CallSetDirection(y)
  end
end

function NMyselfPlayer:Client_EnterExitRangeHandler(exitPoint)
  if self:Client_IsCurrentCommand_Skill() then
    LogUtility.InfoFormat("<color=yellow>Call Enter Exit Point: </color>{0}, but skill is running", exitPoint.ID)
    return
  end
  LogUtility.InfoFormat("<color=blue>Call Enter Exit Point: </color>{0}", exitPoint.ID)
  local pos = self.logicTransform.currentPosition
  LuaVector3.Better_Set(tmpVector3, pos[1] * 1000, pos[2] * 1000, pos[3] * 1000)
  local mapid = SceneProxy.Instance.currentScene.mapID
  ServiceNUserProxy.Instance:CallExitPosUserCmd(tmpVector3, exitPoint.ID, mapid)
end

function NMyselfPlayer:Client_PauseIdleAI()
  self.ai:PauseIdleAI(self)
end

function NMyselfPlayer:Client_ResumeIdleAI()
  self.ai:ResumeIdleAI(self)
end

function NMyselfPlayer:Client_SetMissionCommand(newCmd)
  self.ai:SetAuto_MissionCommand(newCmd, self)
end

function NMyselfPlayer:Client_GetCurrentMissionCommand()
  self.ai:GetCurrentMissionCommand(self)
end

function NMyselfPlayer:Client_SetFollowLeader(leaderID, followType, ignoreNotifyServer)
  self.ai:SetAuto_FollowLeader(leaderID, followType, self, ignoreNotifyServer)
end

function NMyselfPlayer:Client_SetFollowLeaderMoveToMap(mapID, pos)
  self.ai:SetAuto_FollowLeaderMoveToMap(mapID, pos)
end

function NMyselfPlayer:Client_SetFollowLeaderTarget(guid, time)
  self.ai:SetAuto_FollowLeaderTarget(guid, time)
end

function NMyselfPlayer:Client_SetFollowLeaderDelay()
  self.ai:SetAuto_FollowLeaderDelay()
end

function NMyselfPlayer:Client_GetFollowLeaderID()
  return self.ai:GetFollowLeaderID(self)
end

function NMyselfPlayer:Client_IsFollowHandInHand()
  if self.handInActionID ~= nil then
    return false
  end
  return self.ai:IsFollowHandInHand(self)
end

function NMyselfPlayer:Client_SetFollower(followerID, followType)
  self.ai:SetFollower(followerID, followType, self)
end

function NMyselfPlayer:Client_ClearFollower()
  self.ai:ClearFollower(self)
end

function NMyselfPlayer:Client_GetAllFollowers()
  return self.ai:GetAllFollowers(self)
end

function NMyselfPlayer:Client_GetHandInHandFollower()
  return self.ai:GetHandInHandFollower(self)
end

function NMyselfPlayer:Client_ClearAutoBattleCurrentTarget()
  self.ai:ClearAuto_BattleCurrentTarget(self)
end

function NMyselfPlayer:Client_SetAutoBattleLockID(lockID)
  self.ai:SetAuto_BattleLockID(lockID, self)
end

function NMyselfPlayer:Client_UnSetAutoBattleLockID(lockID)
  self.ai:UnSetAuto_BattleLockID(lockID, self)
end

function NMyselfPlayer:Client_AutoBattleLost()
  self.ai:AutoBattleLost()
end

function NMyselfPlayer:Client_SetAutoBattleProtectTeam(on)
  self.ai:SetAuto_BattleProtectTeam(on, self)
end

function NMyselfPlayer:Client_SetAutoBattleStanding(on)
  if FunctionSniperMode.Me():IsWorking() then
    on = true
  end
  self.ai:SetAuto_BattleStanding(on, self)
end

function NMyselfPlayer:Client_SetAutoBattle(on)
  self.ai:SetAuto_Battle(on, self)
end

function NMyselfPlayer:Client_GetAutoBattleLockIDs()
  return self.ai:GetAutoBattleLockIDs(self)
end

function NMyselfPlayer:Client_ManualControlled()
  self:Client_SetMissionCommand(nil)
  self:Client_SetFollowLeaderDelay()
end

function NMyselfPlayer:Client_IsCurrentCommand_Skill()
  local cmd = self.ai:GetCurrentCommand(self)
  return nil ~= cmd and AI_CMD_Myself_Skill == cmd.AIClass
end

function NMyselfPlayer:Client_Die()
  FunctionSystem.InterruptMyMissionCommand()
  local params = Asset_Role.GetPlayActionParams(Asset_Role.ActionName.Die)
  params[6] = true
  params[7] = OnActionFinished
  params[8] = self.instanceID
  self:Logic_PlayAction(params, true)
  Asset_Role.ClearPlayActionParams(params)
end

function NMyselfPlayer:Client_SetAutoFakeDead(skillID)
  self.ai:SetAutoFakeDead(skillID, self)
end

function NMyselfPlayer:Client_SetAutoEndlessTowerSweep(on)
  self.ai:SetAuto_EndlessTowerSweep(on, self)
end

function NMyselfPlayer:Client_GetAutoEndlessTowerSweep()
  return self.ai:GetAuto_EndlessTowerSweep(self)
end

function NMyselfPlayer:Client_SetAutoSkillTargetPoint(on)
  self.ai:SetAuto_SkillTargetPoint(on)
end

function NMyselfPlayer:TryUseQuickRide()
  if not (Game.SkillOptionManager:GetSkillOption(SkillOptionManager.OptionEnum.QuickRide) == 0 and not BagProxy.Instance.roleEquip:GetMount() and GameConfig.SkillQuickRideID) or not SkillProxy.Instance:HasLearnedSkill(GameConfig.SkillQuickRideID[1]) then
    return
  end
  if self.data:HasBuffID(6799) then
    return
  end
  if self.data:HasBuffID(4213) then
    MsgManager.ShowMsgByID(40603)
    return
  end
  if self.data:IsTransformed() then
    return
  end
  if SgAIManager.Me().m_isInBattle then
    return
  end
  FunctionSkill.Me():TryUseSkill(GameConfig.SkillQuickRideID[1])
end

function NMyselfPlayer:LearnedAutoLockBoss()
  local autoLockSkillID = GameConfig.SkillFunc.AutoLockBossID and GameConfig.SkillFunc.AutoLockBossID[1]
  return autoLockSkillID and SkillProxy.Instance:HasLearnedSkill(autoLockSkillID)
end

function NMyselfPlayer:CanUseAutoLockBoss()
  return Game.Myself:Client_GetFollowLeaderID() == 0 and self:LearnedAutoLockBoss()
end

function NMyselfPlayer:OnAddNpc(npc)
  if Game.MapManager:IsInDungeon() then
    return
  end
  local opt = npc.data.userdata:Get(UDEnum.OPTION)
  if npc:IsDead() or opt == 1 then
    return
  end
  local checkFuncs = ReusableTable.CreateArray()
  checkFuncs[#checkFuncs + 1] = NpcData.IsBossType_Dead
  self:TryAutoAttackTarget(npc, NpcData.IsBossType_Dead, SkillOptionManager.OptionEnum.AutoLockDeadBoss, checkFuncs)
  checkFuncs[#checkFuncs + 1] = NpcData.IsBossType_Mvp
  self:TryAutoAttackTarget(npc, NpcData.IsBossType_Mvp, SkillOptionManager.OptionEnum.AutoLockMvp, checkFuncs)
  checkFuncs[#checkFuncs + 1] = NpcData.IsBossType_Mini
  self:TryAutoAttackTarget(npc, NpcData.IsBossType_Mini, SkillOptionManager.OptionEnum.AutoLockMini, checkFuncs)
  ReusableTable.DestroyAndClearArray(checkFuncs)
end

function NMyselfPlayer:TryAutoAttackTarget(npc, funcSelfType, autoLockType, funcCheckTypes)
  if not (funcSelfType(npc.data) and npc.data:GetFeature_CanAutoLock() and self:CanUseAutoLockBoss()) or Game.SkillOptionManager:GetSkillOption(autoLockType) ~= 0 then
    return
  end
  if npc and npc.data.props:GetPropByName("Hiding"):GetValue() == 2 then
    return
  end
  MsgManager.FloatMsg(nil, string.format(ZhString.AutoAimMonster_Tip, npc.data:GetName()))
  local lockIDs = Game.Myself:Client_GetAutoBattleLockIDs()
  if not Game.AutoBattleManager.on or next(lockIDs) then
    self:Client_SetAutoBattleLockID(npc.data:GetStaticID())
    self:Client_SetAutoBattle(true)
    return true
  end
  local curTarget = self:GetLockTarget()
  local keepTarget = false
  if not curTarget or curTarget:IsDead() then
    keepTarget = false
  elseif funcCheckTypes then
    for i = 1, #funcCheckTypes do
      if funcCheckTypes[i](npc.data) then
        keepTarget = true
        break
      end
    end
  end
  if not keepTarget then
    if Game.AutoBattleManager.on then
      self:Client_ClearAutoBattleCurrentTarget()
    end
    self:Client_AttackTarget(npc)
  end
  EventManager.Me():DispatchEvent(AutoBattleManagerEvent.RefreshStatus, Game.AutoBattleManager)
  return true
end

function NMyselfPlayer:ConfirmUseItem_RandPos(func)
  if not func then
    return
  end
  local isLockMvp = Game.SkillOptionManager:GetSkillOption(SkillOptionManager.OptionEnum.AutoLockMvp) == 0
  local isLockMini = Game.SkillOptionManager:GetSkillOption(SkillOptionManager.OptionEnum.AutoLockMini) == 0
  local isLockDeadBoss = Game.SkillOptionManager:GetSkillOption(SkillOptionManager.OptionEnum.AutoLockDeadBoss) == 0
  if not (not LocalSaveProxy.Instance:GetDontShowAgain(4999) and Game.AutoBattleManager.on and self:LearnedAutoLockBoss()) or not NSceneNpcProxy.Instance:PickSingleNpc(function(npc)
    if npc.data:IsBossType_Mvp() then
      return isLockMvp
    elseif npc.data:IsBossType_Mini() then
      return isLockMini
    elseif npc.data:IsBossType_Dead() then
      return isLockDeadBoss
    end
  end) then
    func()
    return
  end
  MsgManager.DontAgainConfirmMsgByID(4999, func)
end

function NMyselfPlayer:Client_SetSkillDir(dir)
  self.skill:SetAttackWorkerDir(dir)
end

function NMyselfPlayer:Client_SetAutoReload(skillID)
  self.ai:Set_AutoReload(skillID, self)
end

function NMyselfPlayer:GetCenterPosition()
  return FunctionSniperMode.Me():GetCenterPosition() or self:GetPosition()
end

function NMyselfPlayer:Client_SetIsDirMoving(isDirMoving, customMoveActionName)
  self.isDirMoving = isDirMoving
  self.customMoveActionName = customMoveActionName
end

function NMyselfPlayer:Client_IsDirMoving()
  return self.isDirMoving == true
end

function NMyselfPlayer:Client_IsMoving()
  return self:Client_IsDirMoving() or self:Client_IsMoveToWorking()
end

function NMyselfPlayer:Client_GetMoveToCustomActionName()
  if self:Client_IsDirMoving() then
    return
  end
  return NMyselfPlayer.super.Client_GetMoveToCustomActionName(self)
end

function NMyselfPlayer:Client_NotifyServerAngleY(time, deltaTime, force)
  if force or time > (self.nextNotifyAngleTime or 0) then
    local angleY = self.logicTransform:GetCurAngleY()
    if not self.prevNotifyAngleY or not NumberUtility.AlmostEqualAngle(self.prevNotifyAngleY, angleY) then
      self.nextNotifyAngleTime = time + 0.2
      self.prevNotifyAngleY = angleY
      ServiceNUserProxy.Instance:CallSetDirection(angleY)
    end
  end
end

function NMyselfPlayer:Client_TryNotifyServerAngleY(time, angleY, interval, diff)
  if time ~= nil and time > (self.nextNotifyAngleTime or 0) then
    angleY = angleY or self:GetAngleY()
    if angleY ~= nil then
      self.prevNotifyAngleY = self.prevNotifyAngleY or 0
      if self.prevNotifyAngleY ~= angleY and math.abs(self.prevNotifyAngleY - angleY) > (diff or 0.1) then
        self.nextNotifyAngleTime = time + (interval or NotifyServerAngleYInterval)
        self.prevNotifyAngleY = angleY
        self:Client_SyncRotationY(angleY)
      end
    end
  end
end

function NMyselfPlayer:Client_StopNotifyServerAngleY()
  self.prevNotifyAngleY = 10086
end

local HugPopUpSkillData = {
  iconType = "skillIcon",
  btnStr = ZhString.FunctionPlayerTip_Pet_CancelHug,
  noClose = true,
  ClickCall = function(skillid)
    Game.Myself:Client_UseSkill(skillid, nil, nil, nil, nil, nil, nil, true)
  end
}

function NMyselfPlayer:Client_HandlerHugSkillPopUp(isAdd, skillid)
  if self.popUpAdded then
    QuickUseProxy.Instance:RemoveCommonNow(HugPopUpSkillData)
  end
  if isAdd then
    local skillData = Table_Skill[skillid]
    HugPopUpSkillData.skillid = skillid
    HugPopUpSkillData.ClickCallParam = skillid
    QuickUseProxy.Instance:AddSkillCallBack(HugPopUpSkillData)
  end
  self.popUpAdded = isAdd
end

function NMyselfPlayer:UpdateSanityBuff(bufflayer)
  local value = bufflayer / (self.MadBuffLimit or 100)
  local sceneUI = Game.Myself:GetSceneUI() or nil
  if sceneUI and sceneUI.roleBottomUI then
    sceneUI.roleBottomUI:UpdateSanity(Game.Myself, value)
  end
end

function NMyselfPlayer:IsSpecialInterruptSkill()
  local clientskill = Game.Myself.skill
  local currentSkillID = clientskill:GetSkillID()
  if self.data:UseSameSkillReduceCD() and currentSkillID and currentSkillID // 1000 == 2781 or clientskill and clientskill.info and clientskill.info:IsSpecialInterruptSkill() then
    return true
  end
  return false
end
