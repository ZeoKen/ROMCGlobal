PVPFactory = class("PVPFactory")
local _gameFacade
local notify = function(eventname, eventbody)
  if _gameFacade == nil then
    _gameFacade = GameFacade.Instance
  end
  _gameFacade:sendNotification(eventname, eventbody)
end
local HandleRolesBase = function(roles)
  local teamProxy = TeamProxy.Instance
  local _myProxy = MyselfProxy.Instance
  local _ObProxy = PvpObserveProxy.Instance
  local inOB = _myProxy:InOb()
  local role, teamid
  for i = 1, #roles do
    role = roles[i]
    if myself ~= role then
      teamid = role.data:GetTeamID()
      role.data:Camp_SetIsInPVP(true)
      local playerid = role.data.id
      if inOB then
        role.data:Camp_SetIsInMyTeam(_ObProxy:IsInFriendCamp(playerid))
        if _myProxy:IsObTarget(playerid) then
          FunctionPvpObserver.Me():SwitchToTarget(playerid)
        end
      else
        role.data:Camp_SetIsInMyTeam(teamProxy:IsInMyGroup(playerid))
      end
    end
  end
end
local HandleAddNpcs = function(npcs, npcDetailType)
  local teamProxy = TeamProxy.Instance
  for i = 1, #npcs do
    local npc = npcs[i]
    if npc.data.detailedType == npcDetailType then
      npc.data:Camp_SetIsInPVP(true)
      npc.data:Camp_SetIsInMyTeam(teamProxy:IsInMyGroup(npc.data.id))
    end
  end
end
local HandleRolesGVG = function(roles, isGVGStart, ignoreTeam, includeMercenary)
  local myselfData = Game.Myself.data
  local myselfTeamID = myselfData:GetRealTeamID()
  local myselfGuildData = includeMercenary and myselfData:GetMercenaryGuildData() or myselfData:GetGuildData()
  local role, teamid, guildData
  for i = 1, #roles do
    role = roles[i]
    if myself ~= role then
      teamid = role.data:GetTeamID()
      guildData = includeMercenary and role.data:GetMercenaryGuildData() or role.data:GetGuildData()
      role.data:Camp_SetIsInGVG(isGVGStart)
      if ignoreTeam ~= true then
        role.data:Camp_SetIsInMyTeam(TeamProxy.Instance:IsInMyGroup(role.data.id))
      end
      if myselfGuildData ~= nil and guildData ~= nil then
        role.data:Camp_SetIsInMyGuild(myselfGuildData.id == guildData.id)
      else
        role.data:Camp_SetIsInMyGuild(false)
      end
    end
  end
end
local HandleNpcsGVG = function(roles, isGVGStart, includeMercenary, isMetal)
  local myselfData = Game.Myself.data
  local myselfGuildData = includeMercenary and myselfData:GetMercenaryGuildData() or myselfData:GetGuildData()
  local role, guildData
  local gvgProxy = GvgProxy.Instance
  local mvpid = GvgProxy.Instance:GetCurMvpId()
  for k, role in pairs(roles) do
    if isMetal then
      if mvpid and mvpid ~= 0 and role.data.staticData.id == mvpid then
        role.data:Camp_SetIsInMyGuild(false)
      else
        role.data:Camp_SetIsInMyGuild(GvgProxy.Instance:IsDefSide())
      end
    else
      guildData = includeMercenary and role.data:GetMercenaryGuildData() or role.data:GetGuildData()
      role.data:Camp_SetIsInGVG(isGVGStart)
      if myselfGuildData ~= nil and guildData ~= nil then
        role.data:Camp_SetIsInMyGuild(myselfGuildData.id == guildData.id)
      else
        role.data:Camp_SetIsInMyGuild(false)
      end
    end
    if role.assetRole then
      role.assetRole:SetInvisible(gvgProxy:CheckMetalNpcBornHide(role.data.id) == true)
    end
    local npcid = role.data:GetNpcID()
    if npcid == GvgProxy.MetalID then
      if gvgProxy:IsCrystalInvincible() then
        role:PlayGvgCrystalInvincibleEffect()
      else
        role:DestroyGvgCrystalInvincibleEffect()
      end
    end
  end
end
local HandleAddPets = function(pets, isGVGStart, isTeamsPVP, isGroupPVP, isPVP3Teams)
  if not pets then
    return
  end
  local myselfID = Game.Myself.data.id
  local myselfTeamID = Game.Myself.data:GetTeamID()
  local myselfTeamData = TeamProxy.Instance.myTeam
  local ownerID, teamid, guildData, myGroupid
  if myselfTeamData then
    myGroupid = myselfTeamData:GetGroupID()
  end
  local myselfGuildData = Game.Myself.data:GetGuildData()
  for i = 1, #pets do
    local nPet = pets[i]
    if not isGVGStart and not isTeamsPVP and not isGroupPVP and not isPVP3Teams then
      ownerID = nPet.data.ownerID
      if ownerID == myselfID then
        nPet.data:SetCamp(RoleDefines_Camp.FRIEND)
      else
        nPet.data:SetCamp(RoleDefines_Camp.ENEMY)
      end
    else
      if isTeamsPVP then
        teamid = nPet.data:GetTeamID()
        if myselfTeamID == teamid then
          nPet.data:SetCamp(RoleDefines_Camp.FRIEND)
        else
          nPet.data:SetCamp(RoleDefines_Camp.ENEMY)
        end
      end
      if isGroupPVP then
        teamid = nPet.data:GetGroupTeamID()
        if myGroupid == teamid then
          nPet.data:SetCamp(RoleDefines_Camp.FRIEND)
        else
          nPet.data:SetCamp(RoleDefines_Camp.ENEMY)
        end
      end
      if isGVGStart then
        guildData = nPet.data:GetGuildData()
        if myselfGuildData and guildData then
          if myselfGuildData.id == guildData.id then
            nPet.data:SetCamp(RoleDefines_Camp.FRIEND)
          else
            nPet.data:SetCamp(RoleDefines_Camp.ENEMY)
          end
        else
          nPet.data:SetCamp(RoleDefines_Camp.ENEMY)
        end
      end
      if isPVP3Teams then
        teamid = nPet.data:GetTeamID()
        if teamid == myselfTeamID then
          nPet.data:SetCamp(RoleDefines_Camp.FRIEND)
        else
          nPet.data:SetCamp(RoleDefines_Camp.ENEMY)
        end
      end
    end
  end
end
local HandleRolesPVP = function(roles)
  if not roles then
    return
  end
  local myself = Game.Myself
  local myCamp = myself.data:GetNormalPVPCamp()
  local _TeamProxy = TeamProxy.Instance
  for i = 1, #roles do
    local role = roles[i]
    if role ~= myself then
      role.data:Camp_SetIsInPVP(true)
      role.data:Camp_SetIsInMyTeam(_TeamProxy:IsInMyGroup(role.data.id))
      local camp = role.data:GetNormalPVPCamp()
      role.data:Camp_SetInSameCamp(camp == myCamp)
    end
  end
end
local HandlePetsPVP = function(pets)
  if not pets then
    return
  end
  local myCamp = Game.Myself.data:GetNormalPVPCamp()
  local myselfTeamID = Game.Myself.data:GetTeamID()
  local myselfTeamData = TeamProxy.Instance.myTeam
  local myGroupid = myselfTeamData and myselfTeamData:GetGroupID()
  for i = 1, #pets do
    local pet = pets[i]
    redlog("HandlePetsPVP", pet.data.staticData.id, myCamp, pet.master_pvp_camp)
    pet.data:Camp_SetIsInPVP(true)
    local teamid = pet.data:GetTeamID()
    local groupid = pet.data:GetGroupTeamID()
    pet.data:Camp_SetIsInMyTeam(myselfTeamID == teamid or myGroupid == groupid)
    pet.data:Camp_SetInSameCamp(pet.master_pvp_camp == myCamp)
  end
end
local SinglePVP = class("SinglePVP")

function SinglePVP:Launch()
  self.isSinglePVP = true
  PvpProxy.Instance:NotifyAddOrRemoveClassicPvpBord(true, PvpProxy.Type.Yoyo)
  notify(PVPEvent.PVPDungeonLaunch)
  notify(PVPEvent.PVP_ChaosFightLaunch)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddPets, self.HandleAddPets, self)
end

function SinglePVP:Shutdown()
  self.isSinglePVP = false
  PvpProxy.Instance:NotifyAddOrRemoveClassicPvpBord(false, PvpProxy.Type.Yoyo)
  notify(PVPEvent.PVPDungeonShutDown)
  notify(PVPEvent.PVP_ChaosFightShutDown)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddPets, self.HandleAddPets, self)
end

function SinglePVP:HandleAddRoles(roles)
  HandleRolesBase(roles)
end

function SinglePVP:HandleAddPets(pets)
  HandleAddPets(pets, false, false)
end

function SinglePVP:Update()
end

local TwoTeamPVP = class("TwoTeamPVP")

function TwoTeamPVP:Launch()
  self.isTwoTeamPVP = true
  PvpProxy.Instance:NotifyAddOrRemoveClassicPvpBord(true, PvpProxy.Type.DesertWolf)
  notify(PVPEvent.PVPDungeonLaunch)
  notify(PVPEvent.PVP_DesertWolfFightLaunch)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddPets, self.HandleAddPets, self)
end

function TwoTeamPVP:Shutdown()
  self.isTwoTeamPVP = false
  PvpProxy.Instance:NotifyAddOrRemoveClassicPvpBord(false, PvpProxy.Type.DesertWolf)
  notify(PVPEvent.PVPDungeonShutDown)
  notify(PVPEvent.PVP_DesertWolfFightShutDown)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddPets, self.HandleAddPets, self)
  PvpProxy.Instance:ResetDesertWolfRule()
  if Game.Myself ~= nil then
    Game.Myself:PlayTeamCircle(0)
  end
end

function TwoTeamPVP:HandleAddRoles(roles)
  HandleRolesBase(roles)
end

function TwoTeamPVP:HandleAddPets(pets)
  HandleAddPets(pets, false, true)
end

function TwoTeamPVP:Update()
end

local MvpFight = class("MvpFight")

function MvpFight:ctor()
  self.isMvpFight = true
end

function MvpFight:Launch()
  self.isMvpFight = true
  notify(PVPEvent.PVP_MVPFightLaunch)
  notify(MainViewEvent.AddDungeonInfoBord, "MVPFightInfoBord")
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddPets, self.HandleAddPets, self)
end

function MvpFight:Shutdown()
  self.isMvpFight = false
  notify(PVPEvent.PVP_MVPFightShutDown)
  notify(MainViewEvent.RemoveDungeonInfoBord, "MVPFightInfoBord")
  PvpProxy.Instance:ClearBosses()
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddPets, self.HandleAddPets, self)
end

function MvpFight:HandleAddRoles(roles)
  HandleRolesBase(roles)
end

function MvpFight:HandleAddPets(pets)
  HandleAddPets(pets, false, true)
end

function MvpFight:Update()
end

local TeamsPVP = class("TeamsPVP")

function TeamsPVP:Launch()
  self.isTeamsPVP = true
  PvpProxy.Instance:NotifyAddOrRemoveClassicPvpBord(true, PvpProxy.Type.GorgeousMetal)
  notify(PVPEvent.PVPDungeonLaunch)
  notify(PVPEvent.PVP_GlamMetalFightLaunch)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddPets, self.HandleAddPets, self)
end

function TeamsPVP:Shutdown()
  self.isTeamsPVP = false
  PvpProxy.Instance:NotifyAddOrRemoveClassicPvpBord(false, PvpProxy.Type.GorgeousMetal)
  notify(PVPEvent.PVPDungeonShutDown)
  notify(PVPEvent.PVP_GlamMetalFightShutDown)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddPets, self.HandleAddPets, self)
  if Game.Myself ~= nil then
    Game.Myself:PlayTeamCircle(0)
  end
end

function TeamsPVP:HandleAddRoles(roles)
  HandleRolesBase(roles)
end

function TeamsPVP:HandleAddPets(pets)
  HandleAddPets(pets, false, true)
end

function TeamsPVP:Update()
end

local GuildMetalGVG = class("GuildMetalGVG")

function GuildMetalGVG:ctor()
  self.isGVG = true
  self.calmDown = true
  self.pointTriggers = {}
end

function GuildMetalGVG:Launch()
  GvgProxy.Instance:ResetQueue()
  notify(GVGEvent.GVGDungeonLaunch)
  self:InitPointAreaTrigger()
  GvgProxy.Instance:FpsReEnterMap()
  Game.GameHealthProtector:CloseBloomAndFxaa()
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcs, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddPets, self.HandleAddPets, self)
  EventManager.Me():AddEventListener(ServiceEvent.GuildCmdEnterGuildGuildCmd, self.HandleSomeGuildChange, self)
  EventManager.Me():AddEventListener(ServiceEvent.GuildCmdExitGuildGuildCmd, self.HandleSomeGuildChange, self)
end

function GuildMetalGVG:Shutdown()
  local ins = GvgProxy.Instance
  ins:ClearFightInfo()
  ins:ClearQuestInfo()
  notify(GVGEvent.GVGDungeonShutDown)
  self:DeInitPointAreaTrigger()
  Game.GameHealthProtector:RecoverBloomAndMsaa()
  Game.GameHealthProtector:TryRestoreFpsCacheSetting()
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcs, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddPets, self.HandleAddPets, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.GuildCmdEnterGuildGuildCmd, self.HandleSomeGuildChange, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.GuildCmdExitGuildGuildCmd, self.HandleSomeGuildChange, self)
end

function GuildMetalGVG:InitPointAreaTrigger()
  GvgProxy.Instance:InitCurRaidStrongHold()
  GvgProxy.Instance:UpdateGvgStrongHoldSymbolDatas()
  local pointConfig = GvgProxy.Instance:GetCurRaidStrongHoldPointConfig()
  if not pointConfig then
    return
  end
  for k, v in pairs(pointConfig) do
    self:_AddMetalGvgTrigger(k, v.pos, v.range)
  end
  self:_InitSceneGuildFlag()
end

function GuildMetalGVG:_InitSceneGuildFlag()
  local flagManager = Game.GameObjectManagers[Game.GameObjectType.SceneGuildFlag]
  if not flagManager then
    return
  end
  for i = 1, 8 do
    local point_map = flagManager:GetPointMap(i)
    if point_map and next(point_map) then
      for config_point_id, _ in pairs(point_map) do
        flagManager:HideNewGvgFlag(config_point_id)
      end
    end
  end
end

function GuildMetalGVG:_AddMetalGvgTrigger(id, pos, range)
  local _pos = LuaVector3(pos[1], pos[2], pos[3])
  local trigger = ReusableTable.CreateTable()
  trigger.id = id
  trigger.type = AreaTrigger_Common_ClientType.MetalGvg_PointArea
  trigger.pos = _pos
  trigger.range = range or 6
  self.pointTriggers[id] = trigger
  SceneTriggerProxy.Instance:Add(trigger)
end

function GuildMetalGVG:DeInitPointAreaTrigger()
  for k, _ in pairs(self.pointTriggers) do
    self:_RemoveMetalGvgTrigger(k)
  end
  GvgProxy.Instance:ClearMetalNpcMap()
  self:_DeInitSceneGuildFlag()
end

function GuildMetalGVG:_DeInitSceneGuildFlag()
  local flagManager = Game.GameObjectManagers[Game.GameObjectType.SceneGuildFlag]
  if not flagManager then
    return
  end
  flagManager:ClearPointMap()
end

function GuildMetalGVG:_RemoveMetalGvgTrigger(id)
  local trigger = self.pointTriggers[id]
  if not trigger then
    return
  end
  SceneTriggerProxy.Instance:Remove(id)
  if trigger.pos then
    trigger.pos:Destroy()
    trigger.pos = nil
  end
  ReusableTable.DestroyTable(trigger)
  self.pointTriggers[id] = nil
end

function GuildMetalGVG:HandleSomeGuildChange(note)
  local roles = NSceneNpcProxy.Instance.userMap
  HandleNpcsGVG(roles, not self.calmDown, true, true)
end

function GuildMetalGVG:HandleAddRoles(roles)
  HandleRolesGVG(roles, not self.calmDown, nil, true)
end

function GuildMetalGVG:HandleAddNpcs(roles)
  HandleNpcsGVG(roles, not self.calmDown, true, true)
end

function GuildMetalGVG:HandleAddPets(pets)
  HandleAddPets(pets, true, false)
end

function GuildMetalGVG:SetCalmDown(val)
  if self.calmDown ~= val then
    self.calmDown = val
    self:SetRolesInGVG(not val)
    self:SetNpcsInGVG(not val)
  end
end

function GuildMetalGVG:SetRolesInGVG(val)
  local roles = NSceneUserProxy.Instance:GetAll()
  for k, v in pairs(roles) do
    v.data:Camp_SetIsInGVG(val)
  end
end

function GuildMetalGVG:SetNpcsInGVG(val)
  local roles = NSceneNpcProxy.Instance:GetAll()
  for k, v in pairs(roles) do
    v.data:Camp_SetIsInGVG(val)
  end
end

function GuildMetalGVG:Update()
end

local GuildDateBattle = class("GuildDateBattle", GuildMetalGVG)

function GuildDateBattle:ctor()
  self.isGuildDateBattle = true
  self.calmDown = true
  self.pointTriggers = {}
end

function GuildDateBattle:HandleAddRoles(roles)
  HandleRolesGVG(roles, not self.calmDown, nil, false)
end

function GuildDateBattle:HandleAddNpcs(roles)
  HandleNpcsGVG(roles, not self.calmDown, false, true)
end

function GuildDateBattle:HandleSomeGuildChange(note)
  local roles = NSceneNpcProxy.Instance.userMap
  HandleNpcsGVG(roles, not self.calmDown, false, true)
end

autoImport("PoringFightTipView")
local PoringFight = class("PoringFight")

function PoringFight:ctor()
  self.isPoringFight = true
end

function PoringFight:Launch()
  notify(PVPEvent.PVPDungeonLaunch)
  notify(PVPEvent.PVP_PoringFightLaunch)
  notify(MainViewEvent.AddDungeonInfoBord, "MainViewPolyFightPage")
  local fightInfo = PvpProxy.Instance:GetFightStatInfo()
  if fightInfo then
    fightInfo.ranks = {}
  end
  if self.cache_MyPos == nil then
    self.cache_MyPos = LuaVector3()
    local myPos = Game.Myself:GetPosition()
    LuaVector3.Better_Set(self.cache_MyPos, myPos[1], myPos[2], myPos[3])
  end
  self.initfight = false
  self:HandleMatchCCmdGodEndTimeCCmd()
  Game.AutoBattleManager:AutoBattleOff()
  local setting = FunctionPerformanceSetting.Me()
  local cacheSetting = setting:GetSetting()
  self.beforeSetting = {}
  self.beforeSetting[1] = cacheSetting.screenCount
  setting:SetBegin()
  setting:SetScreenCount(FunctionPerformanceSetting.Me():GetScreenCountByLevel(EScreenCountLevel.High))
  setting:SetEnd()
  Game.GameHealthProtector:SetForceMinPlayerCount(100)
  EventManager.Me():AddEventListener(MyselfEvent.TransformChange, self.OnTransformChangeHandler, self)
  EventManager.Me():AddEventListener(ServiceEvent.MatchCCmdPvpResultCCmd, self.PoringFightResult, self)
end

function PoringFight:PoringFightResult(data)
  local dataType = data and data.type
  if dataType == PvpProxy.Type.PoringFight then
    if _G.PoringFightTipView == nil then
      autoImport("PoringFightTipView")
    end
    notify(UIEvent.CloseUI, PoringFightTipView.ViewType)
  end
end

function PoringFight:HandleMatchCCmdGodEndTimeCCmd(data)
  if self.initfight then
    return false
  end
  self.initfight = true
  self:RemoveLt()
  local endtime = PvpProxy.Instance:GetGodEndTime() or 0
  local leftSec = math.ceil(endtime - ServerTime.CurServerTime() / 1000)
  helplog("ServerTime.CurServerTime()", os.date("%Y-%m-%d-%H-%M-%S", endtime), os.date("%Y-%m-%d-%H-%M-%S", ServerTime.CurServerTime() / 1000), leftSec)
  if leftSec and 0 < leftSec then
    notify(MainViewEvent.ShowOrHide, false)
    self:DoCameraEffect()
    MsgManager.ShowMsgByIDTable(3608, {leftSec})
    self.effectlt = TimeTickManager.Me():CreateOnceDelayTick(leftSec * 1000, function(owner, deltaTime)
      notify(MainViewEvent.ShowOrHide, true)
      self:CameraReset()
      self:RemoveLt()
    end, self)
  end
end

function PoringFight:OnTransformChangeHandler()
  local props = Game.Myself.data.props
  local monsterId = props:GetPropByName("TransformID"):GetValue()
  helplog("OnTransformChangeHandler : ", monsterId)
  if monsterId == 20004 then
    notify(UIEvent.JumpPanel, {
      view = PanelConfig.PoringFightTipView
    })
  else
    notify(UIEvent.CloseUI, PoringFightTipView.ViewType)
  end
end

function PoringFight:GetRestrictViewPort(oriViewPort)
  local vp_x, vp_y, vp_z = oriViewPort[1], oriViewPort[2], oriViewPort[3]
  local viewWidth = UIManagerProxy.Instance:GetUIRootSize()[1]
  vp_x = 0.5 - (0.5 - vp_x) * 1280 / viewWidth
  if self.temp_ViewPort == nil then
    self.temp_ViewPort = LuaVector3()
  end
  LuaVector3.Better_Set(self.temp_ViewPort, vp_x, vp_y, vp_z)
  return self.temp_ViewPort
end

function PoringFight:DoCameraEffect()
  local rot_V3 = LuaVector3()
  local myTrans = Game.Myself.assetRole.completeTransform
  if myTrans then
    LuaVector3.Better_Set(rot_V3, CameraConfig.FoodMake_Rotation_OffsetX, CameraConfig.FoodMake_Rotation_OffsetY, 0)
    self:CameraFaceTo(myTrans, CameraConfig.FoodMake_ViewPort, nil, nil, rot_V3)
  end
  FunctionSystem.InterruptMyself()
end

function PoringFight:CameraFaceTo(transform, viewPort, rotation, duration, rotateOffset, listener)
  if nil == CameraController.singletonInstance then
    return
  end
  viewPort = viewPort or CameraConfig.UI_ViewPort
  rotation = rotation or CameraController.singletonInstance.targetRotationEuler
  duration = duration or CameraConfig.UI_Duration
  self.cft = CameraEffectFaceTo.new(transform, nil, self:GetRestrictViewPort(viewPort), rotation, duration, listener)
  if rotateOffset then
    self.cft:SetRotationOffset(rotateOffset)
  end
  FunctionCameraEffect.Me():Start(self.cft)
end

function PoringFight:CameraReset()
  if self.cft ~= nil then
    FunctionCameraEffect.Me():End(self.cft)
    self.cft = nil
  end
end

function PoringFight:RemoveLt()
  if self.effectlt then
    self.effectlt:Destroy()
    self.effectlt = nil
  end
end

function PoringFight:Update()
  if self.cft and self:I_IsMove() then
    self:CameraReset()
  end
end

function PoringFight:I_IsMove()
  local role = Game.Myself
  if role then
    local nowMyPos = role:GetPosition()
    if not nowMyPos then
      return false
    end
    if VectorUtility.DistanceXZ_Square(self.cache_MyPos, nowMyPos) > 1.0E-4 then
      LuaVector3.Better_Set(self.cache_MyPos, nowMyPos[1], nowMyPos[2], nowMyPos[3])
      return true
    end
  end
  return false
end

function PoringFight:Shutdown()
  if self.cache_MyPos then
    LuaVector3.Destroy(self.cache_MyPos)
    self.cache_MyPos = nil
  end
  notify(MainViewEvent.ShowOrHide, true)
  self:CameraReset()
  self:RemoveLt()
  notify(PVPEvent.PVPDungeonShutDown)
  notify(PVPEvent.PVP_PoringFightShutdown)
  notify(MainViewEvent.RemoveDungeonInfoBord, "MainViewPolyFightPage")
  local fightInfo = PvpProxy.Instance:GetFightStatInfo()
  if fightInfo then
    fightInfo.ranks = {}
  end
  EventManager.Me():RemoveEventListener(MyselfEvent.TransformChange, self.OnTransformChangeHandler, self)
  local setting = FunctionPerformanceSetting.Me()
  setting:SetBegin()
  setting:SetScreenCount(self.beforeSetting[1])
  setting:SetEnd()
  self.beforeSetting = nil
  Game.GameHealthProtector:SetForceMinPlayerCount(5)
end

function PVPFactory.GetSinglePVP()
  return SinglePVP.new()
end

function PVPFactory.GetTwoTeamPVP()
  return TwoTeamPVP.new()
end

function PVPFactory.GetTeamsPVP()
  return TeamsPVP.new()
end

function PVPFactory.GetGuildMetalGVG()
  return GuildMetalGVG.new()
end

function PVPFactory.GetGuildDateBattle()
  return GuildDateBattle.new()
end

function PVPFactory.GetPoringFight()
  return PoringFight.new()
end

function PVPFactory.GetMvpFight()
  return MvpFight.new()
end

local GvgDroiyan = class("GvgDroiyan")

function GvgDroiyan:ctor()
  self.isGvgDroiyan = true
  self.triggerDatas = {}
end

function GvgDroiyan:Launch()
  GvgProxy.Instance:ResetQueue()
  notify(GVGEvent.GVG_FinalFightLaunch)
  self:InitFightForeAreaTriggers()
  GvgProxy.Instance:FpsReEnterMap()
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcs, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddPets, self.HandleAddPets, self)
end

function GvgDroiyan:InitFightForeAreaTriggers()
  local config = GameConfig.GvgDroiyan and GameConfig.GvgDroiyan.RobPlatform
  if config == nil then
    config = {
      [1] = {
        pos = {
          0,
          0,
          0
        }
      },
      [2] = {
        pos = {
          0,
          0,
          0
        }
      },
      [3] = {
        pos = {
          0,
          0,
          0
        }
      }
    }
  end
  for guid, v in pairs(config) do
    self:AddGvgDroiyan_FightForeArea_Trigger(guid, v.pos, v.RobPlatform_Area)
  end
end

function GvgDroiyan:AddGvgDroiyan_FightForeArea_Trigger(guid, pos, triggerArea)
  self:RemoveFightForAreaTrigger(guid)
  local triggerData = ReusableTable.CreateTable()
  triggerData.id = guid
  triggerData.type = AreaTrigger_Common_ClientType.GvgDroiyan_FightForArea
  local triggerPos = LuaVector3(pos[1], pos[2], pos[3])
  triggerData.pos = triggerPos
  triggerData.range = triggerArea or 5
  self.triggerDatas[guid] = triggerData
  SceneTriggerProxy.Instance:Add(triggerData)
end

function GvgDroiyan:RemoveFightForAreaTrigger(guid)
  local triggerData = self.triggerDatas[guid]
  if triggerData == nil then
    return
  end
  SceneTriggerProxy.Instance:Remove(guid)
  if triggerData.pos then
    triggerData.pos:Destroy()
    triggerData.pos = nil
  end
  ReusableTable.DestroyTable(triggerData)
  self.triggerDatas[guid] = nil
end

function GvgDroiyan:ClearTirggerDatas()
  for guid, data in pairs(self.triggerDatas) do
    self:RemoveFightForAreaTrigger(guid)
  end
end

function GvgDroiyan:HandleAddRoles(roles)
  HandleRolesGVG(roles, true)
end

function GvgDroiyan:HandleAddNpcs(roles)
  HandleNpcsGVG(roles, true, nil, false)
end

function GvgDroiyan:HandleAddPets(pets)
  HandleAddPets(pets, true, false)
end

function GvgDroiyan:Update()
end

function GvgDroiyan:Shutdown()
  notify(GVGEvent.GVG_FinalFightShutDown)
  self:ClearTirggerDatas()
  Game.GameHealthProtector:TryRestoreFpsCacheSetting()
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcs, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddPets, self.HandleAddPets, self)
end

function PVPFactory.GetGvgDroiyan()
  return GvgDroiyan.new()
end

local TeamPws = class("TeamPws")

function TeamPws:ctor()
  self.isTeamPws = true
end

function TeamPws:Launch()
  helplog("TeamPws Launch")
  notify(PVPEvent.TeamPws_Launch)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddPets, self.HandleAddPets, self)
  EventManager.Me():AddEventListener(ServiceEvent.FuBenCmdTeamPwsStateSyncFubenCmd, self.SetFire, self)
  Game.HandUpManager:MaunalClose()
  local setting = FunctionPerformanceSetting.Me()
  local cacheSetting = setting:GetSetting()
  self.beforeSetting = {}
  self.beforeSetting[1] = cacheSetting.screenCount
  self.beforeSetting[2] = cacheSetting.skillEffect
  self.beforeSetting[3] = cacheSetting.showPeak
  setting:SetBegin()
  setting:SetScreenCount(FunctionPerformanceSetting.Me():GetScreenCountByLevel(EScreenCountLevel.High))
  setting:SetSkillEffect(true)
  setting:SetPeak(false)
  setting:SetEnd()
  Game.GameHealthProtector:SetForceMinPlayerCount(100)
end

function TeamPws:HandleAddRoles(roles)
  HandleRolesBase(roles)
end

function TeamPws:HandleAddPets(pets)
  HandleAddPets(pets, false, true)
end

function TeamPws:SetFire(data)
  self.isFire = data.fire
end

function TeamPws:CheckIsFire()
  return self.isFire == true
end

function TeamPws:Update()
end

function TeamPws:Shutdown()
  Game.HandUpManager:MaunalOpen()
  helplog("TeamPws Shutdown")
  notify(PVPEvent.TeamPws_ShutDown)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddPets, self.HandleAddPets, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.FuBenCmdTeamPwsStateSyncFubenCmd, self.SetFire, self)
  local setting = FunctionPerformanceSetting.Me()
  setting:SetBegin()
  setting:SetScreenCount(self.beforeSetting[1])
  setting:SetSkillEffect(self.beforeSetting[2])
  setting:SetPeak(self.beforeSetting[3])
  setting:SetEnd()
  self.beforeSetting = nil
  Game.GameHealthProtector:SetForceMinPlayerCount(5)
  self.isFire = nil
end

function PVPFactory.GetTeamPws()
  return TeamPws.new()
end

local TeamPwsOthello = class("TeamPwsOthello")

function TeamPwsOthello:ctor()
  self.isTeamPwsOthello = true
  self.triggerDatas = {}
end

function TeamPwsOthello:Launch()
  helplog("TeamPwsOthello Launch")
  notify(PVPEvent.TeamPwsOthello_Launch)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddPets, self.HandleAddPets, self)
  EventManager.Me():AddEventListener(ServiceEvent.FuBenCmdTeamPwsStateSyncFubenCmd, self.SetFire, self)
  Game.HandUpManager:MaunalClose()
  PvpProxy.Instance:LaunchAreaCheck()
  PvpProxy.Instance:InitOthelloOccupyData()
  local setting = FunctionPerformanceSetting.Me()
  local cacheSetting = setting:GetSetting()
  self.beforeSetting = {}
  self.beforeSetting[1] = cacheSetting.screenCount
  self.beforeSetting[2] = cacheSetting.skillEffect
  self.beforeSetting[3] = cacheSetting.showPeak
  setting:SetBegin()
  setting:SetScreenCount(FunctionPerformanceSetting.Me():GetScreenCountByLevel(EScreenCountLevel.High))
  setting:SetSkillEffect(true)
  setting:SetPeak(false)
  setting:SetEnd()
  self:InitOthelloCheckpointTriggers()
  Game.GameHealthProtector:SetForceMinPlayerCount(100)
end

function TeamPwsOthello:HandleAddRoles(roles)
  HandleRolesBase(roles)
end

function TeamPwsOthello:HandleAddPets(pets)
  HandleAddPets(pets, false, true)
end

function TeamPwsOthello:SetFire(data)
  self.isFire = data.fire
end

function TeamPwsOthello:CheckIsFire()
  return self.isFire == true
end

function TeamPwsOthello:Update()
end

function TeamPwsOthello:Shutdown()
  Game.HandUpManager:MaunalOpen()
  helplog("TeamPwsOthello Shutdown")
  notify(PVPEvent.TeamPwsOthello_ShutDown)
  PvpProxy.Instance:ShutdownAreaCheck()
  PvpProxy.Instance:ClearOthelloOccupyStatus()
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddPets, self.HandleAddPets, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.FuBenCmdTeamPwsStateSyncFubenCmd, self.SetFire, self)
  self:ClearTirggerDatas()
  local setting = FunctionPerformanceSetting.Me()
  setting:SetBegin()
  setting:SetScreenCount(self.beforeSetting[1])
  setting:SetSkillEffect(self.beforeSetting[2])
  setting:SetPeak(self.beforeSetting[3])
  setting:SetEnd()
  self.beforeSetting = nil
  Game.GameHealthProtector:SetForceMinPlayerCount(5)
  self.isFire = nil
end

function PVPFactory.GetTeamPwsOthello()
  return TeamPwsOthello.new()
end

function TeamPwsOthello:InitOthelloCheckpointTriggers()
  local raidconfig = DungeonProxy.Instance:GetOthelloConfigRaid()
  if raidconfig == nil then
    return
  end
  local config = raidconfig.points
  for index, v in pairs(config) do
    if v.type ~= 3 then
      self:AddOthelloCheckpointTrigger(index, v.pos, v.range)
    end
  end
end

function TeamPwsOthello:AddOthelloCheckpointTrigger(index, pos, triggerArea)
  self:RemoveOthelloCheckpointTrigger(index)
  local triggerData = ReusableTable.CreateTable()
  triggerData.id = index
  triggerData.type = AreaTrigger_Common_ClientType.Othello_Checkpoint
  local triggerPos = LuaVector3(pos[1], pos[2], pos[3])
  triggerData.pos = triggerPos
  triggerData.range = triggerArea or 5
  self.triggerDatas[index] = triggerData
  SceneTriggerProxy.Instance:Add(triggerData)
end

function TeamPwsOthello:RemoveOthelloCheckpointTrigger(index)
  local triggerData = self.triggerDatas[index]
  if triggerData == nil then
    return
  end
  SceneTriggerProxy.Instance:Remove(index)
  if triggerData.pos then
    triggerData.pos:Destroy()
    triggerData.pos = nil
  end
  ReusableTable.DestroyTable(triggerData)
  self.triggerDatas[index] = nil
end

function TeamPwsOthello:ClearTirggerDatas()
  for index, data in pairs(self.triggerDatas) do
    self:RemoveOthelloCheckpointTrigger(index)
  end
end

local TransferFight = class("TransferFight")

function TransferFight:ctor()
  self.isTransferFight = true
end

function TransferFight:Launch()
  notify(PVPEvent.PVPDungeonLaunch)
  notify(PVPEvent.PVP_TransferFightLaunch)
  Game.AutoBattleManager:AutoBattleOff()
  EventManager.Me():AddEventListener(ServiceEvent.FuBenCmdTransferFightRankFubenCmd, self.TransferFightResult, self)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TransferFightMonsterChooseView
  })
end

function TransferFight:TransferFightResult(data)
  local dataType = data and data.type
  if dataType == PvpProxy.Type.TransferFight then
    notify(UIEvent.CloseUI, TransferFightTipView.ViewType)
  end
end

function TransferFight:Update()
end

function TransferFight:Shutdown()
  notify(MainViewEvent.ShowOrHide, true)
  notify(PVPEvent.PVPDungeonShutDown)
  notify(PVPEvent.PVP_TransferFightShutDown)
end

function PVPFactory.GetTransferFight()
  return TransferFight.new()
end

local TeamTwelve = class("TeamTwelve")

function TeamTwelve:ctor()
  self.isTeamTwelve = true
end

function TeamTwelve:Launch()
  helplog("TeamTwelve Launch")
  TwelvePvPProxy.Instance:InitStatic()
  notify(PVPEvent.TeamTwelve_Launch)
  self.inited = false
  self.triggerDatas = {}
  self:InitShopTriggers()
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneRemoveRoles, self.HandleRemoveRoles, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcs, self)
  EventManager.Me():AddEventListener(TwelvePVPEvent.UpdateCarPoint, self.UpdateCarPoint, self)
  EventManager.Me():AddEventListener(TwelvePVPEvent.UpdatePushNum, self.UpdatePushNum, self)
  EventManager.Me():AddEventListener(MyselfEvent.TwelvePvpCampChange, self.UpdateCamp, self)
  EventManager.Me():AddEventListener(MyselfEvent.ObservationAddPlayer, self.HandleAddObPlayer, self)
  Game.HandUpManager:MaunalClose()
  self.isOb = PvpObserveProxy.Instance:IsRunning()
  local setting = FunctionPerformanceSetting.Me()
  local cacheSetting = setting:GetSetting()
  self.beforeSetting = {}
  self.beforeSetting[1] = cacheSetting.showPeak
  self.beforeSetting[2] = cacheSetting.screenCount
  setting:SetBegin()
  setting:SetPeak(false)
  setting:SetScreenCount(FunctionPerformanceSetting.Me():GetScreenCountByLevel(EScreenCountLevel.High))
  if self.isOb then
    self.beforeSetting[3] = cacheSetting.qualityLevel
    self.beforeSetting[4] = cacheSetting.targetFrameRate
    setting:SetQualityLevel(3)
    setting:SetFrameRate(2)
  end
  setting:SetEnd()
  Game.GameHealthProtector:SetForceMinPlayerCount(24)
  ModelEpPointRefs.lodLevelGlobal = LogicManager_MapCell.LODLevel.Low
  if Game.GameHealthProtector.ForceReduceConfig ~= nil and not self.isOb then
    Game.GameHealthProtector:ForceReduceConfig()
  end
  Asset_Effect.PreloadToPool(EffectMap.UI.ufx_12v12_up_blue)
  Asset_Effect.PreloadToPool(EffectMap.UI.ufx_12v12_up_red)
  Asset_Effect.PreloadToPool(EffectMap.UI.ufx_12v12_right)
  Asset_Effect.PreloadToPool(EffectMap.UI.ufx_12v12_left)
  Asset_Effect.PreloadToPool(EffectMap.UI.ufx_12v12_middle)
end

function TeamTwelve:Update()
end

function TeamTwelve:InitNPCConfig(force)
  if self.inited and not force then
    return
  end
  self.myCamp = MyselfProxy.Instance:GetTwelvePVPCamp()
  local configs = GameConfig.TwelvePvp.CampConfig[self.myCamp]
  if not configs then
    return
  end
  if not self.myCamps then
    self.myCamps = {}
  else
    TableUtility.TableClear(self.myCamps)
  end
  if not self.siegeCars then
    self.siegeCars = {}
  else
    TableUtility.TableClear(self.siegeCars)
  end
  if not configs then
    return
  end
  for i = 1, #configs.CampMonsters do
    self.myCamps[configs.CampMonsters[i]] = self.myCamp
  end
  for i = 1, #configs.DefenseTower do
    self.myCamps[configs.DefenseTower[i]] = self.myCamp
  end
  local BarrackConfig = configs.BarrackID or {}
  if BarrackConfig.defense then
    self.myCamps[BarrackConfig.defense] = self.myCamp
  end
  if BarrackConfig.attack then
    self.myCamps[BarrackConfig.attack] = self.myCamp
  end
  self.myCamps[configs.CrystalID] = self.myCamp
  self.inited = true
end

function TeamTwelve:HandleAddObPlayer(notes)
  local playerid = notes[1]
  local isFriendCamp = notes[2]
  local player = NSceneUserProxy.Instance:Find(playerid)
  if player then
    player.data:Camp_SetIsInMyTeam(isFriendCamp)
  end
end

function TeamTwelve:HandleAddRoles(roles)
  local teamProxy = TeamProxy.Instance
  local role, teamid
  local _ObProxy = PvpObserveProxy.Instance
  local _myProxy = MyselfProxy.Instance
  local inOB = _myProxy:InOb()
  local isInFriendCamp, playerid
  for i = 1, #roles do
    role = roles[i]
    if myself ~= role then
      playerid = role.data.id
      role.data:Camp_SetIsInPVP(true)
      if not inOB then
        local camp = role.data:GetTwelvePVPCamp()
        role.data:Camp_SetIsInMyTeam(camp and camp ~= 0 and camp == Game.Myself.data:GetTwelvePVPCamp())
      else
        role.data:Camp_SetIsInMyTeam(_ObProxy:IsInFriendCamp(playerid))
        if _myProxy:IsObTarget(playerid) then
          FunctionPvpObserver.Me():SwitchToTarget(playerid)
        end
        local sceneUI = role:GetSceneUI()
        if sceneUI and sceneUI.roleBottomUI then
          sceneUI.roleBottomUI:HandleOB(role)
        end
      end
    end
  end
end

function TeamTwelve:HandleRemoveRoles(roles)
  local _myProxy = MyselfProxy.Instance
  local inOB = _myProxy:InOb()
  if not inOB then
    return
  end
  for i = 1, #roles do
    if _myProxy:IsObTarget(roles[i]) then
      FunctionPvpObserver.Me():OnLeaveScene()
      break
    end
  end
end

function TeamTwelve:HandleAddNpcs(roles)
  self:InitNPCConfig()
  if not self.inited then
    return
  end
  local role
  local npcid = 1
  local campid = 1
  self.myCamp = MyselfProxy.Instance:GetTwelvePVPCamp()
  for k, role in pairs(roles) do
    npcid = role.data:GetNpcID()
    if role.data:IsPet() then
      local teamid = role.data:GetTeamID()
      local myselfTeamID = Game.Myself.data:GetTeamID()
      local myselfUniteteamid = TeamProxy.Instance.myTeam.uniteteamid
      if teamid and (teamid == myselfTeamID or teamid == myselfUniteteamid) then
        role.data:SetCamp(RoleDefines_Camp.FRIEND)
      else
        role.data:SetCamp(RoleDefines_Camp.ENEMY)
      end
    elseif role.data:IsBeingNpc_Detail() then
      role.data:Camp_SetIsInTwelveScene(role.master_pvp_camp ~= self.myCamp)
      role.data:Camp_SetIsInMyTeam(role.master_pvp_camp == self.myCamp)
    else
      role.data:Camp_SetIsInTwelveScene(self.myCamps[npcid] ~= self.myCamp)
      role.data:Camp_SetIsInMyTeam(self.myCamps[npcid] == self.myCamp)
      if role.data:IsSiegeCar() then
        campid = self.myCamps[npcid] and self.myCamp or 3 - self.myCamp
        self.siegeCars[campid] = role.data.id
        local sceneUI = role:GetSceneUI()
        if sceneUI then
          sceneUI.roleTopUI:SetSiegeCarInfo(role, campid)
        end
      end
    end
  end
end

function TeamTwelve:UpdateCamp()
  self.myCamp = MyselfProxy.Instance:GetTwelvePVPCamp()
  self:InitNPCConfig(true)
  if self.myCamps and self.myCamp then
    NSceneUserProxy.Instance:UpdateTwelveCamp(self.myCamp)
    NSceneNpcProxy.Instance:UpdateCamp(self.myCamps, self.myCamp)
  end
end

local camp, value

function TeamTwelve:UpdateCarPoint(data)
  if not self.siegeCars then
    return
  end
  camp = data[1]
  value = data[2]
  if self.siegeCars[camp] then
    local tCreature = SceneCreatureProxy.FindCreature(self.siegeCars[camp])
    if not tCreature then
      return
    end
    local sceneUI = tCreature:GetSceneUI()
    if sceneUI then
      sceneUI.roleTopUI:UpdateSiegeCarPoint(value)
    end
  end
end

function TeamTwelve:UpdatePushNum(data)
  if not self.siegeCars then
    return
  end
  camp = data[1]
  value = data[2]
  if self.siegeCars[camp] then
    local tCreature = SceneCreatureProxy.FindCreature(self.siegeCars[camp])
    if not tCreature then
      return
    end
    local sceneUI = tCreature:GetSceneUI()
    if sceneUI then
      sceneUI.roleTopUI:UpdateSiegeCarPushNum(value)
    end
  end
end

function TeamTwelve:InitShopTriggers()
  local raidconfig = GameConfig.TwelvePvp.TriggerArea
  if not raidconfig then
    return
  end
  for camp, v in pairs(raidconfig) do
    self:AddShopTrigger(camp, v.pos, v.range)
  end
end

function TeamTwelve:AddShopTrigger(index, pos, triggerArea)
  self:RemoveShopTrigger(index)
  local triggerData = ReusableTable.CreateTable()
  triggerData.id = index
  triggerData.type = AreaTrigger_Common_ClientType.TwelvePVP_ShopTrigger
  local triggerPos = LuaVector3(pos[1], pos[2], pos[3])
  triggerData.pos = triggerPos
  triggerData.range = triggerArea or 5
  self.triggerDatas[index] = triggerData
  SceneTriggerProxy.Instance:Add(triggerData)
end

function TeamTwelve:RemoveShopTrigger(index)
  local triggerData = self.triggerDatas[index]
  if triggerData == nil then
    return
  end
  SceneTriggerProxy.Instance:Remove(index)
  if triggerData.pos then
    triggerData.pos:Destroy()
    triggerData.pos = nil
  end
  ReusableTable.DestroyTable(triggerData)
  self.triggerDatas[index] = nil
end

function TeamTwelve:ClearTirggerDatas()
  for index, data in pairs(self.triggerDatas) do
    self:RemoveShopTrigger(index)
  end
end

local ShopType = GameConfig.TwelvePvp.ShopConfig.shoptype
local ShopID = GameConfig.TwelvePvp.ShopConfig.shopid

function TeamTwelve:Shutdown()
  notify(PVPEvent.TeamTwelve_ShutDown)
  Game.HandUpManager:MaunalOpen()
  helplog("TeamTwelve Shutdown")
  ShopProxy.Instance:ClearShopConfig(ShopType, ShopID)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneRemoveRoles, self.HandleRemoveRoles, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcs, self)
  EventManager.Me():RemoveEventListener(TwelvePVPEvent.UpdateCarPoint, self.UpdateCarPoint, self)
  EventManager.Me():RemoveEventListener(TwelvePVPEvent.UpdatePushNum, self.UpdatePushNum, self)
  EventManager.Me():RemoveEventListener(MyselfEvent.TwelvePvpCampChange, self.UpdateCamp, self)
  EventManager.Me():RemoveEventListener(MyselfEvent.ObservationAddPlayer, self.HandleAddObPlayer, self)
  local setting = FunctionPerformanceSetting.Me()
  setting:SetBegin()
  setting:SetPeak(self.beforeSetting[1])
  setting:SetScreenCount(self.beforeSetting[2])
  if self.isOb then
    setting:SetQualityLevel(self.beforeSetting[3])
    setting:SetFrameRate(self.beforeSetting[4])
  end
  setting:SetEnd()
  self.beforeSetting = nil
  Game.GameHealthProtector:SetForceMinPlayerCount(nil)
  ModelEpPointRefs.lodLevelGlobal = LogicManager_MapCell.LODLevel.Mid
  if not self.isOb and Game.GameHealthProtector.ResetPerformConfig ~= nil then
    Game.GameHealthProtector:ResetPerformConfig()
  end
  TwelvePvPProxy.Instance:Reset()
end

function PVPFactory.GetTeamTwelve()
  return TeamTwelve.new()
end

local PVP3Teams = class("PVP3Teams")
local EDGE = LuaVector3.Zero()
local VECTOR = LuaVector3.Zero()
local PRODUCT1 = LuaVector3.Zero()
local PRODUCT2 = LuaVector3.Zero()
local PRODUCT3 = LuaVector3.Zero()
local PRODUCT4 = LuaVector3.Zero()
local isPosInRect = function(pos, rect)
  LuaVector3.Better_Sub(rect[2], rect[1], EDGE)
  LuaVector3.Better_Sub(pos, rect[1], VECTOR)
  LuaVector3.Better_Cross(EDGE, VECTOR, PRODUCT1)
  LuaVector3.Better_Sub(rect[3], rect[2], EDGE)
  LuaVector3.Better_Sub(pos, rect[2], VECTOR)
  LuaVector3.Better_Cross(EDGE, VECTOR, PRODUCT2)
  LuaVector3.Better_Sub(rect[4], rect[3], EDGE)
  LuaVector3.Better_Sub(pos, rect[3], VECTOR)
  LuaVector3.Better_Cross(EDGE, VECTOR, PRODUCT3)
  LuaVector3.Better_Sub(rect[1], rect[4], EDGE)
  LuaVector3.Better_Sub(pos, rect[4], VECTOR)
  LuaVector3.Better_Cross(EDGE, VECTOR, PRODUCT4)
  local dot1 = LuaVector3.Dot(PRODUCT1, PRODUCT2)
  local dot2 = LuaVector3.Dot(PRODUCT2, PRODUCT3)
  local dot3 = LuaVector3.Dot(PRODUCT3, PRODUCT4)
  local dot4 = LuaVector3.Dot(PRODUCT4, PRODUCT1)
  return 0 < dot1 and 0 < dot2 and 0 < dot3 and 0 < dot4
end
local findNpcsInRect = function(npcId, rect)
  local result = {}
  local npcs = NSceneNpcProxy.Instance:FindNpcs(npcId)
  if npcs then
    for i = 1, #npcs do
      local npc = npcs[i]
      local pos = npc:GetPosition()
      if isPosInRect(pos, rect) then
        result[#result + 1] = npc
      end
    end
  end
  return result
end

function PVP3Teams:ctor()
  self.isPVP3Teams = true
  self.hideNpcs = {}
  self.hideArea = GameConfig.Triple and GameConfig.Triple.HideArea
  self.hideNpcId = GameConfig.Triple and GameConfig.Triple.HideNpcId
  self.hideRectId = 0
end

function PVP3Teams:Launch()
  notify(PVPEvent.TripleTeams_Launch)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddPets, self.HandleAddPets, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcs, self)
end

function PVP3Teams:Update()
  if not self.hideArea then
    return
  end
  local myPos = Game.Myself:GetPosition()
  if self.hideRectId ~= 0 then
    local curRect = self.hideArea[self.hideRectId][2]
    if isPosInRect(myPos, curRect) then
      return
    end
    local npcs = self.hideNpcs[self.hideRectId]
    if npcs then
      for i = 1, #npcs do
        if npcs[i].assetRole then
          npcs[i].assetRole:SetPartBodyAlpha(1)
        end
      end
    end
    self.hideRectId = 0
    return
  end
  for i = 1, #self.hideArea do
    local rect = self.hideArea[i][2]
    if isPosInRect(myPos, rect) then
      local npcs = self.hideNpcs[i]
      if not npcs then
        npcs = findNpcsInRect(self.hideNpcId, rect)
        self.hideNpcs[i] = npcs
      end
      if npcs then
        for i = 1, #npcs do
          if npcs[i].assetRole then
            npcs[i].assetRole:SetPartBodyAlpha(0.5)
          end
        end
      end
      self.hideRectId = i
      return
    end
  end
end

function PVP3Teams:Shutdown()
  TableUtility.TableClearByDeleter(self.hideNpcs, function(npcs)
    TableUtility.ArrayClear(npcs)
  end)
  notify(PVPEvent.TripleTeams_Shutdown)
  TriplePlayerPvpProxy.Instance:Reset()
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddPets, self.HandleAddPets, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcs, self)
end

function PVP3Teams:HandleAddRoles(roles)
  HandleRolesBase(roles)
end

function PVP3Teams:HandleAddNpcs(npcs)
  HandleAddNpcs(npcs, NpcData.NpcDetailedType.TriplePvpRobot)
end

function PVP3Teams:HandleAddPets(pets)
  HandleAddPets(pets, false, false, false, true)
end

function PVPFactory.GetPVP3Teams()
  return PVP3Teams.new()
end

local PVPEndlessBattleField = class("PVPEndlessBattleField")

function PVPEndlessBattleField:ctor()
  self.isPVPEBF = true
end

function PVPEndlessBattleField:Launch()
  notify(PVPEvent.EndlessBattleField_Launch)
  FunctionEndlessBattleField.Me():Launch()
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddPets, self.HandleAddPets, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcs, self)
end

function PVPEndlessBattleField:Shutdown()
  notify(PVPEvent.EndlessBattleField_Shutdown)
  FunctionEndlessBattleField.Me():Shutdown()
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddPets, self.HandleAddPets, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcs, self)
end

function PVPEndlessBattleField:HandleAddRoles(roles)
  HandleRolesPVP(roles)
end

function PVPEndlessBattleField:HandleAddPets(pets)
  HandlePetsPVP(pets)
end

function PVPEndlessBattleField:HandleAddNpcs(npcs)
  HandleRolesPVP(npcs)
end

function PVPEndlessBattleField:Update()
end

function PVPFactory.GetPVPEndlessBattleField()
  return PVPEndlessBattleField.new()
end
