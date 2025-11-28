NMyselfPlayer = reusableClass("NMyselfPlayer", NPlayer)
NMyselfPlayer.WeakKey_LockTarget = "WeakKey_LockTarget"
NMyselfPlayer.WeakKey_AttackTarget = "WeakKey_AttackTarget"
NMyselfPlayer.WeakKey_AccessTarget = "WeakKey_AccessTarget"
autoImport("NMyselfPlayer_Effect")
autoImport("NMyselfPlayer_Client")
autoImport("NMyselfPlayer_Logic")
autoImport("SceneTimeDiskInfo")
autoImport("SceneStarMap")
local ArroundRange = 100
local _Game = Game
local _UDEnum = UDEnum
local UpdateInterval = 2
local ReloadCheckInterval = 1
local TryUseSkillInterval = 3
local RefreshTauntInterval = 0.2
local Reload_None, Reload_LT4 = true, false
local ReloadOption = 0
local S2C_Number = ProtolUtility.S2C_Number
local TIMEDISKMOVE_RUN = SceneSkill_pb.TIMEDISKMOVE_RUN
local TIMEDISKMOVE_SUSPEND = SceneSkill_pb.TIMEDISKMOVE_SUSPEND
local TIMEDISKMOVE_DEL = SceneSkill_pb.TIMEDISKMOVE_DEL
local AtkSpdSerialSkills = {
  [2731001] = 2732001,
  [2732001] = 2733001,
  [2733001] = 2734001,
  [2734001] = 2731001
}

function NMyselfPlayer:ctor()
  NMyselfPlayer.super.ctor(self, AI_Myself)
  self.cannotUseSkillChecker = ConditionCheck.new()
  self.userDataManager = _Game.LogicManager_Myself_Userdata
  self.propmanager = _Game.LogicManager_Myself_Props
  self.skill = ClientSkill.new()
  self:CreateWeakData()
end

function NMyselfPlayer:GetCreatureType()
  return Creature_Type.Me
end

function NMyselfPlayer:InitLogicTransform()
  self.logicTransform:SetOwner(self)
  self.logicTransform:SetMoveSpeed(self.data:ReturnMoveSpeedWithFactor(moveSpeed))
  self.logicTransform:SetRotateSpeed(self.data:ReturnRotateSpeedWithFactor(rotateSpeed))
  self.logicTransform:SetScaleSpeed(self.data:ReturnScaleSpeedWithFactor(scaleSpeed))
end

function NMyselfPlayer:GetLockTarget()
  return self:GetWeakData(NMyselfPlayer.WeakKey_LockTarget)
end

function NMyselfPlayer:IsAutoBattleProtectingTeam()
  return self.ai:IsAutoBattleProtectingTeam(self)
end

function NMyselfPlayer:SetVisible(v, reason)
  NMyselfPlayer.super.SetVisible(self, v, reason)
end

function NMyselfPlayer:IsAutoBattleStanding()
  return self.ai:IsAutoBattleStanding(self)
end

local tmpVector3 = LuaVector3.Zero()

function NMyselfPlayer:Server_SetPosXYZCmd(x, y, z, div)
  LuaVector3.Better_Set(tmpVector3, x, y, z)
  if div ~= nil then
    LuaVector3.Div(tmpVector3, div)
  end
  self:Server_SetPosCmd(tmpVector3)
end

function NMyselfPlayer:Server_SetPosCmd(p, ignoreNavMesh)
  self.ai:PushCommand(FactoryAICMD.Me_GetPlaceToCmd(p, ignoreNavMesh), self)
end

function NMyselfPlayer:Server_PlayActionCmd(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression, blendContext, ignoreWeapon)
  self.ai:PushCommand(FactoryAICMD.Me_GetPlayActionCmd(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression, blendContext, ignoreWeapon), self)
end

function NMyselfPlayer:Server_DieCmd(noaction)
  self.ai:PushCommand(FactoryAICMD.Me_GetDieCmd(noaction), self)
end

function NMyselfPlayer:Server_ReviveCmd(name, normalizedTime, loop)
end

function NMyselfPlayer:Server_SetScaleCmd(scale, noSmooth)
  self.data.bodyScale = scale
  local scaleX, scaleY, scaleZ = self:GetScaleWithFixHW()
  self.ai:PushCommand(FactoryAICMD.Me_GetSetScaleCmd(scaleX, scaleY, scaleZ, noSmooth), self)
end

function NMyselfPlayer:Server_SetDirCmd(mode, dir, noSmooth)
  self.ai:PushCommand(FactoryAICMD.Me_GetSetAngleYCmd(mode, dir, noSmooth), self)
end

function NMyselfPlayer:Server_SyncSkill(phaseData)
end

function NMyselfPlayer:Server_UseSkill(skillID, targetCreature, targetPosition)
  self:Client_UseSkill(skillID, targetCreature, targetPosition, nil, nil, nil, nil, true)
end

function NMyselfPlayer:Server_BreakSkill(skillID)
  redlog("Server_BreakSkill", skillID)
  if self.skill:GetSkillID() == skillID then
    self.disableSkillBroadcast = true
    self.skill:InterruptCast(self)
    self.disableSkillBroadcast = false
  end
  NMyselfPlayer.super.Server_BreakSkill(self, skillID)
end

function NMyselfPlayer:Server_CameraFlash()
end

function NMyselfPlayer:Server_SetHandInHand(masterID, running)
  helplog("Server_SetHandInHand:", masterID, running)
  if self.ai:GetFollowLeaderID(self) == masterID then
    self.ai:SetAuto_FollowHandInHandState(running, self)
  end
end

function NMyselfPlayer:Server_SetDoubleAction(masterID, running)
  helplog("NMyselfPlayer Server_SetDoubleAction", masterID, running)
  self.doubleaction_build = running
end

function NMyselfPlayer:Server_GetOnSeat(seatID, fromCreature)
  if not fromCreature then
    local isCustom = _Game.SceneSeatManager:SeatIsCustom(seatID)
    if not isCustom then
      return
    end
  end
  FunctionSystem.InterruptMyselfAll()
  self.ai:PushCommand(FactoryAICMD.GetGetOnSeatCmd(seatID, fromCreature), self)
end

local superUpdate = NMyselfPlayer.Update

function NMyselfPlayer:Update(time, deltaTime)
  superUpdate(self, time, deltaTime)
  if time > (self.nextInteractUpdateTime or 0) then
    self:CheckInteractMount()
    self.nextInteractUpdateTime = time + 1
  end
  if self.closeToWallCheck and time > self.nextClose2WallCheckTime then
    if self:CheckCloseToWall() then
      ServicePlayerProxy.Instance:CallReqHideUserCmd(true)
    else
      ServicePlayerProxy.Instance:CallReqHideUserCmd(false)
    end
    self.nextClose2WallCheckTime = time + UpdateInterval
  end
  if self.autoReloadCheck and time > self.nextCheckReloadTime then
    self:TryAutoReload(time, deltaTime)
    self.nextCheckReloadTime = time + ReloadCheckInterval
  end
  if self.beTauntGUID and time > self.nextRefreshTauntTime then
    self:_UpdateBeTaunt()
    self.nextRefreshTauntTime = time + RefreshTauntInterval
  end
  if self.heartlockCheck and time > self.nextCheckHeartLockTime then
    if not self.checkNpcRange or 0 >= self.checkNpcRange then
      self.heartlockCheck = false
    else
      SgAIManager.Me():CheckNpcRange(self.checkNpcRange, self:GetPosition())
    end
    self.nextCheckHeartLockTime = time + ReloadCheckInterval
  end
  if self.timeDiskCheck and time > self.nexttimeDiskCheckTime then
    self.nexttimeDiskCheckTime = time + ReloadCheckInterval
    self:UpdateTimeDisk(deltaTime)
  end
  if self.updateNormalAtk and time > self.nextUpdateNormalAtkTime then
    self:UpdateNormalAtk(time, deltaTime)
    self.nextUpdateNormalAtkTime = time + ReloadCheckInterval
  end
  BigWorld.BigWorldManager.Instance:Refresh(self.logicTransform.currentPosition)
end

function NMyselfPlayer:_UpdateArroundMyself(time, deltaTime)
end

function NMyselfPlayer:IsMySelf()
  return true
end

function NMyselfPlayer:InitAssetRole()
  NMyselfPlayer.super.InitAssetRole(self)
  local assetRole = self.assetRole
  assetRole:SetColliderEnable(false)
  FunctionCameraEffect.ResetFreeCameraFocusOffset(assetRole)
  assetRole:SetCallbackOnBodyChanged(FunctionCameraEffect.ResetFreeCameraFocusOffset)
  assetRole:DontDestroyOnLoad()
  LuaLuancher.Instance.myself = self.assetRole.complete
end

function NMyselfPlayer:GetDressParts()
  return self.data:GetDressParts()
end

function NMyselfPlayer:_ReDress()
  local parts, partsNoDestroy = self:GetDressParts()
  self:SetDressed(self:IsDressEnable())
  self.assetRole:Redress(parts, true)
  self:CheckBodyPlayShow(parts[Asset_Role.PartIndex.Body])
  self:DestroyDressParts(parts, partsNoDestroy)
end

function NMyselfPlayer:AllowDress()
  return true
end

function NMyselfPlayer:GetArroundLevel(p, distance)
  if nil == distance then
    distance = VectorUtility.DistanceXZ(self:GetPosition(), p)
  end
  if distance <= 0 then
    return 1
  end
  if distance < ArroundRange then
    local moveSpeed = self.logicTransform:GetMoveSpeed()
    if moveSpeed <= 0 then
      moveSpeed = 1
    end
    return math.ceil(distance * 2 / moveSpeed)
  end
  return 0
end

function NMyselfPlayer:InitSet()
end

function NMyselfPlayer:EnterScene()
  self:TryRecreatePartner()
  if self.enterScencePausedIdleAI then
    self.enterScencePausedIdleAI = false
    self:Client_ResumeIdleAI()
  end
  self:Client_EnterARegion(true)
end

function NMyselfPlayer:LeaveScene()
  EventManager.Me():PassEvent(MyselfEvent.LeaveScene)
  self:RemoveObjsWhenLeaveScene()
  if not self.enterScencePausedIdleAI then
    self.enterScencePausedIdleAI = true
    self:Client_PauseIdleAI()
  end
end

function NMyselfPlayer:ResetDefaultUseData()
  self.data.userdata:Set(UDEnum.PET_PARTNER, 0)
  self.userDataManager:CheckUpdateDataCall(self, UserData.CacheEUSERkey[UDEnum.PET_PARTNER], nil, 0)
end

function NMyselfPlayer:RemoveObjsWhenLeaveScene()
  self:_ClearTrackEffects()
  self:RemovePartner()
  self:RemoveHandNpc()
  self:ClearExpressNpc()
  self:ClearSkillSolo()
  self:_ClearCastWarningEffects()
  if not Game.MapManager:IsPVEMode_Roguelike() then
    self:ClearContractEffects()
  end
  self:ClearSpEffect()
end

function NMyselfPlayer:SetPartner(id)
  NMyselfPlayer.super.SetPartner(self, id)
  if self.partner then
    EventManager.Me():PassEvent(MyselfEvent.PartnerChange, id)
  else
    EventManager.Me():PassEvent(MyselfEvent.PartnerChange, nil)
  end
end

function NMyselfPlayer:TryRecreatePartner()
  local partnerID = self.data.userdata:Get(_UDEnum.PET_PARTNER)
  if partnerID and 0 < partnerID then
    self:SetPartner(partnerID)
  end
end

function NMyselfPlayer:OnAvatarPriorityChanged()
end

function NMyselfPlayer:RegisterRoleDress()
end

function NMyselfPlayer:UnregisterRoleDress()
end

function NMyselfPlayer:RegistCulling()
end

function NMyselfPlayer:UnRegistCulling()
end

function NMyselfPlayer:UpdateEpNodeDisplay(display)
  if self.assetRole then
    self.assetRole:SetEpNodesDisplay(display)
  end
  Game.PerformanceManager:SkinWeightHigh(display)
end

function NMyselfPlayer:TryCheckLockTarget(guid)
  if not guid then
    return
  end
  if not Game.AutoBattleManager.on then
    return
  end
  local tCreature = Game.Myself:GetLockTarget()
  if tCreature and tCreature.data and guid == tCreature.data.id then
    Game.Myself:Client_LockTarget(nil)
  else
    return
  end
end

function NMyselfPlayer:RefreshNightmareStatus()
  local lastIsNightmare = self.isNightmare
  self.isNightmare = Game.MapManager:IsNightmareMap(Game.MapManager:GetMapID())
  if self.isNightmare ~= lastIsNightmare then
    self:PlayNightmareEffect(self:GetNightmareLevel())
  end
end

function NMyselfPlayer:IsAtNightmareMap()
  return self.isNightmare == true
end

function NMyselfPlayer:GetNightmareLevel()
  return self.nightmareLevel or 0
end

function NMyselfPlayer:GetNightmarePlayerHeadChangePercent()
  return self.nightmareHeadChangePercent or 0
end

function NMyselfPlayer:SetNightmareLevel(level)
  if self.nightmareLevel ~= level then
    local headChangeCfg = GameConfig.Nightmare.PlayerHeadChangePercent
    if not headChangeCfg then
      redlog("Cannot Find GameConfig.Nightmare.PlayerHeadChangePercent!")
    end
    self.nightmareHeadChangePercent = headChangeCfg and headChangeCfg[Game.Myself:GetNightmareLevel()] or 0
  end
  self.nightmareLevel = level
end

local IsTargetMultiMountCanRide = function(player)
  local userdata = player.data.userdata
  if not userdata then
    return false
  end
  if not _Game.InteractNpcManager:TryCheckInteraceMountPosition(player.data.id) then
    return false
  end
  if player:IsInMyTeam() then
    return true
  end
  return false
end
local IsMultiMountRidable = function(teamPlayer)
  local userdata = teamPlayer.data.userdata
  if not userdata then
    return false
  end
  if not _Game.InteractNpcManager:TryCheckInteraceMountPosition(teamPlayer.data.id) then
    local ridingNpc = userdata:Get(_UDEnum.RIDING_NPC) or 0
    if ridingNpc and 0 < ridingNpc then
      return true
    end
    return false
  end
  return true
end

function NMyselfPlayer:CheckInteractMount()
  local curCharID = self.data.userdata:Get(_UDEnum.RIDING_CHARID) or 0
  if curCharID ~= 0 then
    _Game.InteractNpcManager:SetTargetInteractMountID(nil)
    return
  end
  local player = self.NSceneUserProxy_Instance:FindTeamMemberInRange(self:GetPosition(), self.multiMountSearchRange, IsMultiMountRidable)
  _Game.InteractNpcManager:SetTargetInteractMountID(player and player.data.id)
end

function NMyselfPlayer:GetCurChantTime()
  return self.skill:GetCurChantTime()
end

function NMyselfPlayer:LaunchCloseToWallCheck(buffeffect)
  local distance = buffeffect.distance
  if not distance then
    return
  end
  local data = self.data
  if not data then
    return
  end
  self.closeToWallCheck = true
  local level = self:GetBuffLevel()
  self.checkRange = CommonFun.calcBuffValue(data, data, distance.type, distance.a, distance.b, distance.c, distance.d, level, 0)
  self.nextClose2WallCheckTime = 0
end

function NMyselfPlayer:ShutDownCloseToWallCheck()
  self.closeToWallCheck = false
  self.checkRange = nil
end

function NMyselfPlayer:CheckCloseToWall(time, deltaTime)
  if self.checkRange then
    return NavMeshUtils.IsCloseToWall(self:GetPosition(), self.checkRange)
  else
    self.closeToWallCheck = false
    return false
  end
end

function NMyselfPlayer:LaunchAutoReloadCheck(skillID)
  self.skillID_AutoReload = skillID
  if not self.skillID_AutoReload or self.skillID_AutoReload <= 0 then
    self:ShutDownAutoReloadCheck()
    return
  end
  if not self._SkillProxy then
    self._SkillProxy = SkillProxy.Instance
  end
  if not self._SkillOptionManager then
    self._SkillOptionManager = Game.SkillOptionManager
  end
  self:RefreshAutoReloadStatus()
end

function NMyselfPlayer:RefreshAutoReloadStatus()
  if not self._SkillOptionManager then
    return
  end
  if self._SkillOptionManager:GetSkillOption_AutoReload() // 10 == 2 then
    self:ShutDownAutoReloadCheck()
    return
  end
  self.autoReloadCheck = true
  self.nextTryTime = 0
  self.nextCheckReloadTime = 0
end

function NMyselfPlayer:ShutDownAutoReloadCheck()
  self.autoReloadCheck = false
end

function NMyselfPlayer:TryAutoReload(time, deltaTime)
  if not self.autoReloadCheck then
    return
  end
  if self:PrepareAutoReload(time, deltaTime) and self.skillID_AutoReload and self._SkillProxy and self._SkillProxy:SkillCanBeUsedByID(self.skillID_AutoReload, true) then
    self:_TryUseSkill(time)
  end
end

function NMyselfPlayer:_TryUseSkill(time)
  if time < self.nextTryTime then
    return
  end
  self.nextTryTime = time + TryUseSkillInterval
  FunctionSkill.Me():TryUseSkill(self.skillID_AutoReload)
end

local lastSkillTime

function NMyselfPlayer:PrepareAutoReload(time, deltaTime)
  if self.data:IsTransformed() then
    return false
  end
  if self.skill.running then
    return false
  end
  local curBullets = MyselfProxy.Instance:GetCurBullets()
  local myself = _Game.Myself
  if curBullets >= myself.data:GetMaxBullets() then
    return false
  end
  if not self._SkillProxy then
    self._SkillProxy = SkillProxy.Instance
  end
  if self._SkillProxy:SkillInForgetTime(self.skillID_AutoReload) > 0 then
    return false
  end
  ReloadOption = self._SkillOptionManager:GetSkillOption_AutoReload()
  Reload_LT4 = ReloadOption // 10 == 0
  Reload_None = ReloadOption // 10 == 1
  if ReloadOption // 10 == 2 then
    self:ShutDownAutoReloadCheck()
    return
  end
  if curBullets then
    if curBullets < 4 and Reload_LT4 then
      return true
    end
    return curBullets <= 0 and Reload_None
  else
    return false
  end
end

function NMyselfPlayer:LaunchHeartLockCheck(range)
  self.heartlockCheck = true
  self.checkNpcRange = range or 0
  self.nextCheckHeartLockTime = 0
end

function NMyselfPlayer:ShutDownHeartLockCheck()
  self.heartlockCheck = false
  self.checkNpcRange = 0
  self.nextCheckHeartLockTime = 0
end

function NMyselfPlayer:Server_SyncShiftPoint(skillID, pos)
  if not pos then
    return
  end
  if self.skill:GetSkillID() == skillID and self.skill:IsCastingShiftPointSkill() then
    self.skill.phaseData:SetPositionXYZ(S2C_Number(pos.x), S2C_Number(pos.y), S2C_Number(pos.z))
  end
end

local bigGridNum = GameConfig.TimeDisk.bigGridNum or 1
local smallGridNum = GameConfig.TimeDisk.smallGridNum or 1
local TotalGrid = bigGridNum * smallGridNum
local MaxGrid = TotalGrid * 2

function NMyselfPlayer:LaunchTimeDisk()
  self.timeDiskCheck = true
  self.nexttimeDiskCheckTime = 0
end

function NMyselfPlayer:ShutDownTimeDisk()
  self.timeDiskCheck = false
  self.nexttimeDiskCheckTime = 0
end

local curTime, curgrid, info = 0, 0
local curDelta, totalDelta, maxDelta, suspendtime = 0, 0, 0, 0

function NMyselfPlayer:UpdateTimeDisk(deltatime)
  info = SkillProxy.Instance:GetTimeDiskInfo()
  curTime = ServerTime.CurServerTime()
  suspendtime = info and info.suspendtime or 0
  if curTime < suspendtime then
    if self:HasAllPartLoaded() then
      self:_UpdateTimeDisk(self, info:GetSmallGrid() / TotalGrid, info:GetCurGrid())
    end
    return
  end
  info:MoveGrid()
  curgrid = info:GetSmallGrid()
  info.isSun = curgrid < TotalGrid
  if self.data._skipTimeDisk then
    if info.isSun and curgrid < smallGridNum then
      info:ResetGrid(smallGridNum)
    elseif not info.isSun and curgrid >= smallGridNum and curgrid < smallGridNum + TotalGrid then
      info:ResetGrid(smallGridNum + TotalGrid)
    end
  end
  if self:HasAllPartLoaded() then
    self:_UpdateTimeDisk(self, info:GetSmallGrid() / TotalGrid, info:GetCurGrid())
  end
end

function NMyselfPlayer:SetTimeDisktInfo(creature)
  if self.sceneui and self.sceneui.roleBottomUI then
    self.sceneui.roleBottomUI:InitTimeDiskInfo()
  end
end

function NMyselfPlayer:_UpdateTimeDisk(creature, now, curGrid)
  local diskInfo = SkillProxy.Instance:GetTimeDiskInfo()
  if diskInfo.move == TIMEDISKMOVE_DEL then
    self:RemoveTimeDisk()
    redlog("RemoveTimeDisk")
  else
    self:UpdateGrid(creature, diskInfo, now, curGrid)
    self:TryPlayTimeDiskEffect(diskInfo:GetSmallGrid(), curGrid)
  end
end

function NMyselfPlayer:UpdateGrid(creature, diskInfo, now, curGrid)
  if self.sceneui and self.sceneui.roleBottomUI then
    self.sceneui.roleBottomUI:InitTimeDiskInfo(creature)
    self.sceneui.roleBottomUI:UpdateRotation(diskInfo.isSun, now, curGrid)
  end
end

function NMyselfPlayer:RemoveTimeDisk()
  if self.sceneui and self.sceneui.roleBottomUI then
    self.sceneui.roleBottomUI:RemoveTimeDisk()
  end
end

local TimeDiskEffectMap = {
  [6] = {
    path = EffectMap.Maps.TimeDiskEffect_Sun_2,
    epID = RoleDefines_EP.Back,
    offset = {
      0,
      0,
      0
    }
  },
  [18] = {
    path = EffectMap.Maps.TimeDiskEffect_Sun_2,
    epID = RoleDefines_EP.Back,
    offset = {
      0,
      0,
      0
    },
    removeStick = EffectMap.Maps.TimeDiskEffect_Sun_1
  },
  [12] = {
    path = EffectMap.Maps.TimeDiskEffect_Sun_3,
    epID = RoleDefines_EP.Back,
    offset = {
      0,
      0,
      0
    },
    stick = EffectMap.Maps.TimeDiskEffect_Sun_1
  },
  [36] = {
    path = EffectMap.Maps.TimeDiskEffect_Moon_2,
    epID = RoleDefines_EP.Back,
    offset = {
      0,
      0,
      0
    }
  },
  [48] = {
    path = EffectMap.Maps.TimeDiskEffect_Moon_2,
    epID = RoleDefines_EP.Back,
    offset = {
      0,
      0,
      0
    },
    removeStick = EffectMap.Maps.TimeDiskEffect_Moon_1
  },
  [42] = {
    path = EffectMap.Maps.TimeDiskEffect_Moon_3,
    epID = RoleDefines_EP.Back,
    offset = {
      0,
      0,
      0
    },
    stick = EffectMap.Maps.TimeDiskEffect_Moon_1
  }
}

function NMyselfPlayer:TryPlayTimeDiskEffect(smallGrid, curGrid)
  if TimeDiskEffectMap[smallGrid] then
    local effectConfig = TimeDiskEffectMap[smallGrid]
    self:PlayTimeDiskEffect(effectConfig.path, effectConfig.epID, effectConfig.offset)
    if effectConfig.stick then
      self:PlayTimeDiskEffect(effectConfig.stick, RoleDefines_EP.Bottom, effectConfig.offset, true)
    end
    if effectConfig.removeStick then
      self:RemoveTimeDiskEffect(effectConfig.removeStick)
    end
  end
end

function NMyselfPlayer:InitStarMap()
  if self.sceneui and self.sceneui.roleBottomUI then
    self.sceneui.roleBottomUI:InitStarMap()
  end
end

function NMyselfPlayer:UpdateStar(bufflayer)
  if self.sceneui and self.sceneui.roleBottomUI then
    self:InitStarMap()
    self.sceneui.roleBottomUI:UpdateStar(bufflayer)
  end
end

function NMyselfPlayer:RemoveStarMap()
  if self.sceneui and self.sceneui.roleBottomUI then
    self.sceneui.roleBottomUI:RemoveStarMap()
  end
end

function NMyselfPlayer:OpenStormBossLucky()
  return self.data and self.data:IsWildMvpLucky()
end

function NMyselfPlayer:SetDragonContract(fromID)
  self.dragonContract = fromID
end

function NMyselfPlayer:GetDragonContract()
  return self.dragonContract
end

function NMyselfPlayer:UpdateFeatherBuff(bufflayer)
  if self.sceneui and self.sceneui.roleBottomUI then
    self.sceneui.roleBottomUI:UpdateFeatherBuff(bufflayer)
  end
end

function NMyselfPlayer:RemoveFeatherBuff()
  if self.sceneui and self.sceneui.roleBottomUI then
    self.sceneui.roleBottomUI:RemoveFeatherGrid()
  end
end

function NMyselfPlayer:LaunchUpdateNormalAtk()
  self.updateNormalAtk = true
  self.nextUpdateNormalAtkTime = 0
end

function NMyselfPlayer:SetNextNormalAttack(skillID, time)
  local nextSkill = AtkSpdSerialSkills[skillID]
  if self.data:CheckEnergyBuffFull() then
    nextSkill = 2734001
  end
  local curServerTime = ServerTime.CurServerTime() / 1000 + 5
  self.nextNormalAttack = {skillID = nextSkill, time = curServerTime}
end

function NMyselfPlayer:UpdateNormalAtk()
  if not self.updateNormalAtk then
    return
  end
end

function NMyselfPlayer:GetFakeNormalAtkID()
  if not self.updateNormalAtk then
    return
  end
  local skillID = self.nextNormalAttack and self.nextNormalAttack.skillID
  local useTime = self.nextNormalAttack and self.nextNormalAttack.time
  local curServerTime = ServerTime.CurServerTime() / 1000
  if self.data:CheckEnergyBuffFull() then
    return skillID or 2734001
  end
  if useTime and useTime < curServerTime or not skillID then
    return MyselfProxy.Instance:GetFakeNormalAtkID()
  else
    return skillID
  end
end

function NMyselfPlayer:ShutDownUpdateNormalAtk()
  self.updateNormalAtk = false
end

function NMyselfPlayer:UpdateEnergyBuff(bufflayer)
  if self.sceneui and self.sceneui.roleBottomUI then
    self.sceneui.roleBottomUI:UpdateEnergyBuff(bufflayer)
  end
end

function NMyselfPlayer:RemoveEnergyBuff()
  if self.sceneui and self.sceneui.roleBottomUI then
    self.sceneui.roleBottomUI:RemoveEnergyGrid()
  end
end

function NMyselfPlayer:DoConstruct(asArray, data)
  NMyselfPlayer.super.super.DoConstruct(self, asArray, data)
  self:InitAssetRole()
  self:InitLogicTransform()
  self.sceneui = Creature_SceneUI.CreateAsTable(self)
  self.multiMountSearchRange = GameConfig.MultiMount and GameConfig.MultiMount.SearchRange or 3
  self.NSceneUserProxy_Instance = NSceneUserProxy.Instance
end

function NMyselfPlayer:DoDeconstruct(asArray)
  NMyselfPlayer.super.DoDeconstruct(self, asArray)
  if self.sceneui then
    self.sceneui:Destroy()
    self.sceneui = nil
  end
  self.cannotUseSkillChecker:Reset()
end

function NMyselfPlayer:OnObserverDestroyed(k, obj)
  NMyselfPlayer.super.OnObserverDestroyed(self, k, obj)
  if k == NMyselfPlayer.WeakKey_LockTarget then
    self:Client_LockTarget(nil)
  end
end
