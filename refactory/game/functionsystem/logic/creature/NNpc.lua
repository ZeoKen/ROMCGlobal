autoImport("Creature_SceneUI")
NNpc = reusableClass("NNpc", NCreatureWithPropUserdata)
NNpc.PoolSize = 100
autoImport("NNpc_Effect")
autoImport("NNpc_Logic")
autoImport("PVPStatueInfo")
local Table_ActionAnime = Table_ActionAnime
local ForceRemoveDelay = 3
local SmoothRemoveDuration = 0.3
NNpc.MonsterDressDisableDistanceLevel = 1
local ActionForceDurationConfig = {
  [250010] = {
    [Asset_Role.ActionName.FunctionalShow] = 21.667,
    [Asset_Role.ActionName.FunctionalShow2] = 12.233
  },
  [250310] = {
    [Asset_Role.ActionName.FunctionalShow] = 5.0
  },
  [270300] = {
    [Asset_Role.ActionName.FunctionalShow] = 5.0
  }
}

function NNpc:ctor(aiClass)
  NNpc.super.ctor(self, aiClass)
  self.sceneui = nil
  self.userDataManager = Game.LogicManager_Npc_Userdata
  self.propmanager = Game.LogicManager_Npc_Props
  self.skill = ServerSkill.new()
  self.originalRotation = nil
end

function NNpc:GetCreatureType()
  return Creature_Type.Npc
end

function NNpc:GetSceneUI()
  return self.sceneui
end

function NNpc:Server_SetDirCmd(mode, dir, noSmooth)
  if mode == AI_CMD_SetAngleY.Mode.SetAngleY then
    self.originalRotation = dir
  end
  self.ai:PushCommand(FactoryAICMD.GetSetAngleYCmd(mode, dir, noSmooth), self)
end

function NNpc:Server_GetOnInteractNpc(mountid, charid)
  Game.InteractNpcManager:AddMountInter(self.data.id, mountid, charid)
end

function NNpc:RegisterInteractNpc()
  if self.data.staticData then
    local interactConfig = Table_InteractNpc[self.data.staticData.id]
    if self.data.isInteractLocal then
      InteractLocalManager.Me():RegisterInteractNpc(self.data.staticData.id, self.data.id)
    else
      if interactConfig then
        if interactConfig.Type == InteractNpc.InteractType.SceneObject then
          return
        end
        if interactConfig.Type == InteractNpc.InteractType.LocalServerSimple then
          self.data.isInteractLocalServer = true
          self.data.interactLocalServerNpcKey = self.data.uniqueid
          InteractLocalManager.Me():RegisterInteractServerNpc(self.data.staticData.id, self.data.interactLocalServerNpcKey)
          return
        elseif interactConfig.Type == InteractNpc.InteractType.LocalSimple then
          return
        elseif interactConfig.Type == InteractNpc.InteractType.LocalVisit or interactConfig.Type == InteractNpc.InteractType.LocalCollect or interactConfig.Type == InteractNpc.InteractType.LocalCollectHug then
          self.data.isInteractLocalServer = true
          self.data.interactLocalServerNpcKey = self.data.id
          InteractLocalManager.Me():RegisterInteractServerNpc(self.data.staticData.id, self.data.interactLocalServerNpcKey)
          return
        elseif interactConfig.Type == InteractNpc.InteractType.LocalHug then
          return
        end
      end
      Game.InteractNpcManager:RegisterInteractNpc(self.data.staticData.id, self.data.id)
    end
  end
end

function NNpc:UnregisterInteractNpc()
  if self.data.isInteractLocal then
    InteractLocalManager.Me():UnregisterInteractNpc(self.data.id)
    self.data.isInteractLocal = nil
  elseif self.data.isInteractLocalServer then
    InteractLocalManager.Me():UnregisterInteractServerNpc(self.data.interactLocalServerNpcKey)
    self.data.isInteractLocalServer = nil
    self.data.interactLocalServerNpcKey = nil
  else
    Game.InteractNpcManager:UnregisterInteractNpc(self.data.id)
  end
end

function NNpc:Server_PlayActionCmd(name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression, blendContext, ignoreWeapon)
  local config = ActionForceDurationConfig[self.data.staticData.id]
  if config and not forceDuration then
    forceDuration = config[name]
  end
  NNpc.super.Server_PlayActionCmd(self, name, normalizedTime, loop, fakeDead, forceDuration, freezeAtEnd, actionSpeed, spExpression, blendContext, ignoreWeapon)
end

function NNpc:InitAssetRole()
  NNpc.super.InitAssetRole(self)
  local assetRole = self.assetRole
  assetRole:SetGUID(self.data.id)
  assetRole:SetName(self.data:GetOriginName())
  assetRole:SetClickPriority(self.data:GetClickPriority())
  local sData = self.data.staticData
  if sData == nil then
    return
  end
  if self.data:ForbidClientClient() then
    self:SetClickable(false)
  end
  assetRole:SetColliderEnable(not self.data:NoAccessable())
  assetRole:SetInvisible(false)
  assetRole:SetWeaponDisplay(true)
  assetRole:SetMountDisplay(true)
  assetRole:SetRenderEnable(true)
  assetRole:SetActionSpeed(1)
  assetRole:SetNpcDefaultExpression(sData.DefaultExpression, sData.ReplaceActionExpresssion)
  assetRole:SetShadowEnable(sData.move ~= 1)
  assetRole:SetShadowCastMode(sData.ShadowCastOff == nil)
  local scDis = sData.ShadowCastDistance
  if scDis and next(scDis) then
    assetRole:EnableShadowCastCheck(LuaGeometry.GetTempVector3(scDis[1], scDis[2], scDis[3]))
  else
    assetRole:DisableShadowCastCheck()
  end
  local newGvgStatue = GameConfig.GVGConfig.GvgStatue and GameConfig.GVGConfig.GvgStatue.StatueNpcID
  if sData.id == GameConfig.GVGConfig.StatueNpcID or nil ~= newGvgStatue and sData.id == newGvgStatue then
    assetRole:SetIgnoreExpression()
    local materialParams = GameConfig.ShaderConfig[7]
    if materialParams then
      self:SetMaterialInfo(materialParams)
      assetRole:SetMaterials(true)
      local faceRenderer = assetRole.complete.faceRenderer
      if faceRenderer then
        local lodGroup = faceRenderer.gameObject:GetComponent(LODGroup)
        if lodGroup then
          lodGroup:ForceLOD(1)
        end
      end
    end
  end
  local sType = self.data:GetPvpStatueType()
  if sType then
    assetRole:SetIgnoreExpression()
    local materialParams = GameConfig.ShaderConfig[7]
    if materialParams then
      self:SetMaterialInfo(materialParams)
      assetRole:SetMaterials(true)
      local faceRenderer = assetRole.complete.faceRenderer
      if faceRenderer then
        local lodGroup = faceRenderer.gameObject:GetComponent(LODGroup)
        if lodGroup then
          lodGroup:ForceLOD(1)
        end
      end
    end
  end
end

function NNpc:InitLogicPos(x, y, z, moveTo)
  if self.data:GetFeature_IgnoreNavmesh() then
    if moveTo then
      self:Logic_MoveXYZTo(x, y, z)
    else
      self:Logic_PlaceXYZTo(x, y, z)
    end
  elseif moveTo then
    self:Logic_NavMeshMoveXYZTo(x, y, z)
  else
    self:Logic_NavMeshPlaceXYZTo(x, y, z)
  end
end

function NNpc:InitAction(serverData)
  local data = self.data
  local assetRole = self.assetRole
  if serverData.isbirth and data.staticData then
    local BirthTime = data.staticData.BirthTime
    if BirthTime and 0 < BirthTime then
      self:Server_PlayActionCmd(Asset_Role.ActionName.Born, nil, false, false, BirthTime)
      return true
    end
  end
  local actionid = serverData.motionactionid
  if actionid and actionid ~= 0 then
    local actionData = Table_ActionAnime[actionid]
    if actionData then
      local actionType = serverData.action_type or SceneUser2_pb.EUSERACTIONTYPE_MOTION
      if actionType == SceneUser2_pb.EUSERACTIONTYPE_MOTION then
        assetRole:PlayAction_SimpleLoop(actionData.Name)
      else
        assetRole:PlayAction_Simple(actionData.Name)
      end
      self.ai:SetNoIdleAction()
      return true
    end
  end
  local puzzlemotionid = serverData.puzzlemotionid
  if puzzlemotionid and puzzlemotionid ~= 0 then
    local actionData = Table_ActionAnime[puzzlemotionid]
    if actionData then
      assetRole:PlayAction_Simple(actionData.Name)
      self.ai:SetNoIdleAction()
      return true
    end
  end
  local defaultGear = data:GetDefaultGear()
  if defaultGear ~= nil then
    local actionName = string.format("state%d", defaultGear)
    assetRole:PlayAction_Simple(actionName)
    return true
  end
  local timeControlGear = data:GetTimeControlGear()
  if timeControlGear ~= nil then
    local actionName = string.format("state%d", timeControlGear)
    assetRole:PlayAction_Simple(actionName)
    self.ai:SetNoIdleAction()
    return true
  end
  local staticId = data.staticData.id
  if staticId == GameConfig.GVGConfig.StatueNpcID then
    GvgProxy.Instance:UpdateStatuePose(nil, self)
  end
  local newGvgStatue = GameConfig.GVGConfig.GvgStatue and GameConfig.GVGConfig.GvgStatue.StatueNpcID
  if staticId == newGvgStatue then
    local statue_city_id = GvgProxy.GetStatueCity(data.uniqueid)
    if nil ~= statue_city_id then
      local is_empty = GvgProxy.Instance:CheckMyGroupCityStatueEmpty(statue_city_id)
      if is_empty then
        assetRole:SetInvisible(true)
      else
        assetRole:SetInvisible(false)
        GvgProxy.Instance:InitializeStatuePos(statue_city_id, self)
      end
    end
  end
  if staticId == GameConfig.GvgNewConfig.roadblock_npcid then
    GvgProxy.Instance:InitObstacleAction(self)
  end
  if staticId == GvgProxy.LobbyFlagNPCID then
    GvgProxy.Instance:TryResetLobbyFlag()
  end
  local sType = self.data:GetPvpStatueType()
  if sType then
    local info = PvpProxy.Instance:GetStatueInfo(sType)
    if info then
      info:UpdatePose(nil, self)
    end
  end
  return false
end

function NNpc:InitTextMesh()
  local config = GameConfig.TextMesh
  if config ~= nil then
    local data = self.data
    local info = config[data.staticData.id]
    if info ~= nil then
      local effect = info.effect
      if effect ~= nil then
        Game.GameObjectManagers[Game.GameObjectType.TextMesh]:SpawnEffect(self, effect, data.name, 0, true, true)
      end
      local model = info.model
      if model ~= nil then
        local text = data.name
        if data:IsGvgStatuePedestal() then
          local info = GvgProxy.Instance:GetStatueInfo()
          text = info and info.guildname or ""
        end
        if data:IsNewGvgStatuePedestal() then
          local group_id = GuildProxy.Instance:GetMyGuildGvgGroup()
          if not group_id or group_id == 0 then
            group_id = GvgProxy.Instance.curMapGvgGroupId
          end
          local statue_city_id = GvgProxy.GetStatueCity(data.uniqueid)
          text = GvgProxy.Instance:GetGuildNameByStatusCity(group_id, statue_city_id) or ""
        end
        if data:IsTriplePed() then
          local info = PvpProxy.Instance:GetStatueInfo(PvpProxy.StatueType.Triple)
          text = info and info.statueInfo.username or ""
        end
        if data:IsTeamPwsPed() then
          local info = PvpProxy.Instance:GetStatueInfo(PvpProxy.StatueType.Teampws)
          text = info and info.statueInfo.username or ""
        end
        if data:IsTwelvePed() then
          local info = PvpProxy.Instance:GetStatueInfo(PvpProxy.StatueType.Twelve)
          text = info and info.statueInfo.username or ""
        end
        local body = self.assetRole:GetPartObject(Asset_Role.PartIndex.Body)
        if body ~= nil then
          Game.GameObjectManagers[Game.GameObjectType.TextMesh]:SpawnModel(body.gameObject, text)
        end
      end
    end
  end
end

function NNpc:ClearTextMesh()
  local config = GameConfig.TextMesh
  if config ~= nil then
    local info = config[self.data.staticData.id]
    if info ~= nil then
      local model = info.model
      if model ~= nil then
        local body = self.assetRole:GetPartObject(Asset_Role.PartIndex.Body)
        if body ~= nil then
          Game.GameObjectManagers[Game.GameObjectType.TextMesh]:Clear(body.gameObject:GetInstanceID())
        end
      end
    end
  end
end

function NNpc:HandlerAssetRoleSuffixMap()
  if self.data:IsCopyNpc_Detail() or self.data:IsFollowMaster_Detail() then
    NNpc.super.HandlerAssetRoleSuffixMap(self)
  end
end

function NNpc:GetDressPriority()
  return LogicManager_RoleDress.Priority.Npc
end

function NNpc:SetDressEnable(v)
  local data = self.data
  if data.dressEnable ~= v and data:ShouldUpdateDressEnable() then
    data:SetDressEnable(v)
    self:ReDress()
  end
end

function NNpc:GetDressParts()
  if not self:IsDressEnable() then
    return NSceneNpcProxy.Instance:GetNpcEmptyParts(), true
  end
  local parts = self.data:GetDressParts()
  return parts, not self.data.useServerDressData
end

local superServer_SetPosCmd = NNpc.super.Server_SetPosCmd

function NNpc:Server_SetPosCmd(p, ignoreNavMesh)
  superServer_SetPosCmd(self, p, self.data:GetFeature_IgnoreNavmesh())
end

local superServer_MoveToCmd = NNpc.super.Server_MoveToCmd

function NNpc:Server_MoveToCmd(p, ignoreNavMesh, endCallback)
  superServer_MoveToCmd(self, p, self.data:GetFeature_IgnoreExtraNavmesh(), endCallback)
end

function NNpc:ReInitByServer(serverData)
  self.data:Set(serverData)
  self:Init(serverData, true)
end

function NNpc:CheckPosXZRoughlyEqual(p)
  local x = self.logicTransform.currentPosition.x
  local z = self.logicTransform.currentPosition.z
  local dx = x - p[1]
  local dz = z - p[3]
  return dx * dx + dz * dz < 1
end

function NNpc:IsReinitNoMove()
  local id = self.data.staticData.id
  return Table_InteractNpc[id] and Table_InteractNpc[id].Type > 5
end

function NNpc:Init(serverData, reinit)
  self:InitAssetRole()
  local moveTo = reinit and not self:IsReinitNoMove() and not self:CheckPosXZRoughlyEqual({
    serverData.pos.x / 1000,
    serverData.pos.y / 1000,
    serverData.pos.z / 1000
  })
  local dir
  if serverData.dir ~= 0 then
    dir = serverData.dir
  end
  self:InitLogicTransform(serverData.pos.x, serverData.pos.y, serverData.pos.z, dir, 1, nil, nil, nil, moveTo)
  self:Server_SetUserDatas(serverData.datas, true)
  self:Server_SetAttrs(serverData.attrs)
  if not self.sceneui then
    self.sceneui = Creature_SceneUI.CreateAsTable(self)
  else
    self.sceneui:SetCreature(self)
  end
  self.sceneui.roleBottomUI:HandleChangeTitle(self)
  self.data:RefreshNightmareStatus()
  if serverData.pvp_champion_statue then
    local pvp_champion_statue = serverData.pvp_champion_statue
    local myserverID = ChangeZoneProxy.Instance:GetMyselfServerId()
    for i = 1, #pvp_champion_statue do
      if pvp_champion_statue[i].serverid == myserverID then
        self.statue_type = pvp_champion_statue[i].statue_type
        PvpProxy.Instance:SetStatueInfo(self.statue_type, pvp_champion_statue[i])
      else
        redlog("failed self.statue_type", self.statue_type, pvp_champion_statue[i].serverid, myserverID)
      end
    end
  end
  self:InitAction(serverData)
  self.bosstype = serverData.bosstype or self.data.bosstype
  self.data.serverBossType = self.bosstype
  self:InitBuffs(serverData)
  local color = self.data:HasOutline()
  if color then
    self.assetRole:AddOutlineProcess()
    self:RegisterInsightNpc()
  end
  local dest = serverData.dest
  if dest and not PosUtil.IsZero(dest) then
    self:Server_MoveToXYZCmd(dest.x, dest.y, dest.z, 1000)
  end
  local ses = self.data.staticData and self.data.staticData.SE
  if ses then
    self.assetRole:PlaySEOneShotOn(ses[math.random(1, #ses)])
  else
    local server_se = serverData.se
    if server_se and server_se ~= "" then
      if serverData.se_loop then
        self:PlayAudio(server_se, AudioSourceType.BUFF, true)
      else
        self:PlayAudio(server_se)
      end
    end
  end
  local semaxdistance = serverData.se_maxdistance
  if semaxdistance ~= nil and 0 < semaxdistance then
    self.assetRole:SetSEMaxDistance(semaxdistance)
  end
  if serverData.fadein and 0 < serverData.fadein and self.assetRole then
    self.assetRole:SetSmoothDisplayBody(0)
    local to = self.data.userdata:Get(UDEnum.ALPHA) or 1
    self.assetRole:AlphaFromTo(0, to, serverData.fadein / 1000)
  end
  self.data.isInteractLocal = serverData.isInteractLocal
  self:RegisterInteractNpc()
  local mounts = serverData.mounts
  if mounts then
    for i = 1, #mounts do
      self:Server_GetOnInteractNpc(mounts[i].mountid, mounts[i].charid)
    end
  end
  HomeManager.Me():SetRelativeCreature(self.data:GetRelativeFurnitureID(), self.data.id)
  self:UpdateWithRelativeFurniture()
  self.master_pvp_camp = serverData.master_pvp_camp
  local parterid = self.data.staticData.PartnerID
  if parterid ~= nil then
    self:SetPartner(parterid)
  end
  self.picQuad = serverData.pic_quad
  FunctionAbyssLake.Me():TrySetSummonProgress(self.data.uniqueid, self)
  self:TryUpdateRoadBlock()
  self:ResetCamp()
  self.data:SyncBuffSource(serverData.syncbuff)
end

function NNpc:ShowViewRange(range)
  if nil == self.effectControllerViewRange then
    self.effectControllerViewRange = ViewRangeEffect.CreateAsTable(self.data.id)
  end
  if nil ~= self.effectControllerViewRange then
    self.effectControllerViewRange:ShowRange(range)
  end
end

function NNpc:CreateData(serverData)
  return NpcData.CreateAsTable(serverData)
end

function NNpc:SetDeadTime()
  if self.deadTimeFlag ~= nil then
    return
  end
  self.deadTimeFlag = UnityTime + (GameConfig.MonsterBodyDisappear.DeadDispTime[self.data.staticData.id] or ForceRemoveDelay)
end

function NNpc:SetDelayRemove(delayTime, duration)
  if nil ~= self.delayRemoveTimeFlag then
    return
  end
  self.smoothRemoving = false
  if delayTime then
    self:SetClickable(false)
    self.delayRemoveTimeFlag = UnityTime + delayTime
    self.fadeOutRemoveDuration = duration or SmoothRemoveDuration
  else
    self.delayRemoveTimeFlag = nil
    self.fadeOutRemoveDuration = nil
  end
  if self.data and self.data:GetPushableObjID() then
    RaidPuzzleManager.Me():RemovePushObject(self)
  end
end

local superUpdate = NNpc.super.Update

function NNpc:Update(time, deltaTime)
  superUpdate(self, time, deltaTime)
  if self.delayRemoveTimeFlag ~= nil and time >= self.delayRemoveTimeFlag then
    if not self.smoothRemoving then
      if nil ~= self.forceRemoveTimeFlag then
        if time < self.forceRemoveTimeFlag and self.ai:IsDiePending() then
          return
        end
      elseif self.ai:IsDiePending() then
        self.forceRemoveTimeFlag = time + ForceRemoveDelay
        return
      end
      self.smoothRemoving = true
      local duration = self.fadeOutRemoveDuration or SmoothRemoveDuration
      self.delayRemoveTimeFlag = self.delayRemoveTimeFlag + duration
      self.assetRole:AlphaTo(0, duration)
    else
      self:_DelayDestroy()
    end
  end
  if self.deadTimeFlag ~= nil and time >= self.deadTimeFlag and self.assetRole ~= nil then
    NSceneNpcProxy.Instance:RemoveNpc(self)
    self:_DelayDestroy()
  end
end

function NNpc:_DelayDestroy()
  self.data:ClearClientData()
  if not NSceneNpcProxy.Instance:RealRemove(self.data.id, true) then
    self:Destroy()
  end
end

function NNpc:GetDressDisableDistanceLevel()
  if self.data:IsMonster() then
    return self.data.staticData.DistanceLevel or NNpc.MonsterDressDisableDistanceLevel
  end
  return NNpc.super.GetDressDisableDistanceLevel(self)
end

function NNpc:TrySetComodoBuildingData()
  if not self.data then
    return
  end
  if Game.MapManager:GetRaidID() ~= GameConfig.Manor.RaidID then
    return
  end
  if not ComodoBuildingProxy.CheckHasProduceTopUi(self.data.staticData.id) then
    return
  end
  local sceneUi = self:GetSceneUI()
  if sceneUi then
    sceneUi.roleTopUI:UpdateComodoBuildingProduce()
  end
end

function NNpc:TryBindPhotoStandInfo()
  if not self.data then
    return
  end
  if not FunctionPhotoStand.Me().isRunning then
    return
  end
  local slide = FunctionPhotoStand.Me().slide_info and FunctionPhotoStand.Me().slide_info[self.data.staticData.id]
  if not slide then
    return
  end
  local luago = self.assetRole and self.assetRole.complete and self.assetRole.complete.transform
  luago = luago and luago:GetComponentInChildren(LuaGameObject, true)
  if luago then
    local reg_key = FunctionPhotoStand.Me():RegisterNNpc(self)
    if reg_key then
      local GOManager = Game.GameObjectManagers
      local objManager = GOManager[Game.GameObjectType.PhotoStand]
      objManager:RegisterGameObject4NNpc(luago, reg_key)
    end
  end
end

function NNpc:TryUnbindPhotoStandInfo()
  if not self.data then
    return
  end
  if not FunctionPhotoStand.Me().isRunning then
    return
  end
  local slide = FunctionPhotoStand.Me().slide_info and FunctionPhotoStand.Me().slide_info[self.data.staticData.id]
  if not slide then
    return
  end
  local luago = self.assetRole and self.assetRole.complete and self.assetRole.complete.transform
  luago = luago and luago:GetComponentInChildren(LuaGameObject, true)
  if luago then
    local GOManager = Game.GameObjectManagers
    local objManager = GOManager[Game.GameObjectType.PhotoStand]
    objManager:UnregisterGameObject4NNpc(luago)
  end
end

function NNpc:SetSkillNpc(skillConfig)
  if skillConfig then
    self.sourceSkill = skillConfig
    local funcType = skillConfig.Logic_Param.function_type
    if funcType == "Bi_Transport" then
      self:_AddSkillTransportTrigger()
    end
  else
    self:_EndSkillNpc()
  end
end

function NNpc:_EndSkillNpc()
  if self.sourceSkill then
    local funcType = self.sourceSkill.Logic_Param.function_type
    if funcType == "Bi_Transport" then
      self:_RemoveSkillTransportTrigger()
    end
    self.sourceSkill = nil
  end
end

local triggerData = {}

function NNpc:_AddSkillTransportTrigger()
  triggerData.id = self.data.id
  triggerData.type = AreaTrigger_Skill.Transport
  triggerData.creature = self
  triggerData.reachDis = self.sourceSkill.Logic_Param.range
  local trigger = SkillAreaTrigger.CreateAsTable(triggerData)
  Game.AreaTrigger_Skill:AddCheck(trigger)
  TableUtility.TableClear(triggerData)
end

function NNpc:_RemoveSkillTransportTrigger()
  Game.AreaTrigger_Skill:RemoveCheck(self.data.id)
end

function NNpc:UpdateWithRelativeFurniture()
  local furnitureID = self.data:GetRelativeFurnitureID()
  if not HomeManager.Me():IsAtHome() or StringUtil.IsEmpty(furnitureID) then
    return
  end
  local nFurniture = HomeManager.Me():FindFurniture(furnitureID)
  if nFurniture then
    self:Logic_LockRotation(false)
    self.logicTransform:SetAngleY(nFurniture.assetFurniture:GetEulerAnglesY())
  end
  self:Logic_LockRotation(true)
end

function NNpc:GetBossType()
  return self.bosstype
end

function NNpc:SetForceUpdate(b)
  self.ai:SetForceUpdate(b)
end

function NNpc:SetCellCreatureIndex(cellCreatureIndex)
  self.maskUIBecauseCellCreatureCount = false
end

function NNpc:LookAt(p)
  if self.data:GetFeature_IgnoreLookAt() then
    return
  end
  NNpc.super.LookAt(self, p)
end

function NNpc:OnPartCreated(part)
  NNpc.super.OnPartCreated(self, part)
  local partner = self.partner
  if partner ~= nil then
    partner:OnMasterPartCreated(self, part)
  end
end

function NNpc:OnBodyCreated()
  NNpc.super.OnBodyCreated(self)
  self:InitTextMesh()
  self:TryBindPhotoStandInfo()
  if self.assetRole then
    local sData = self.data.staticData
    self.assetRole:IgnoreTerrainLightColor(sData.IgnoreLightColor == 1)
  end
  self:ResetRiderPos()
  if self.data:GetFeature_IgnoreDress() then
    self:PlayBirthCastAction()
  end
end

function NNpc:ResetRiderPos()
  local upID = self.data:GetUpID()
  if not upID or upID == 0 then
    return
  end
  local upRole = SceneCreatureProxy.FindCreature(upID)
  if upRole and upRole.assetRole then
    upRole.assetRole:SetMountRole(self.assetRole.complete)
  end
end

function NNpc:RegisterInsightNpc()
  local staticData = self.data and self.data.staticData
  if staticData and staticData.OutlineColor then
    Game.GameObjectManagers[Game.GameObjectType.InsightGO]:AddNPC(self.data.id, staticData.OutlineMenuID, self.assetRole.outline, self.data.staticData.id, staticData.OutlineColor.color)
  end
end

function NNpc:UnregisterInsightNpc()
  local staticData = self.data and self.data.staticData
  if staticData and staticData.OutlineColor then
    Game.GameObjectManagers[Game.GameObjectType.InsightGO]:RemoveNPC(self.data.id)
  end
end

function NNpc:IsRobotNpc()
  return self.data:IsRobotNpc()
end

function NNpc:UpdateTopUIBySetting(isSelected)
end

function NNpc:PlayAppearanceAnimation_OnInit()
  local appearanceAnimation = self.data:GetAppearanceAnimation()
  if not appearanceAnimation or appearanceAnimation <= 0 then
    return
  end
  self.data:ClearAppearanceAnimation()
  local raidId = Game.MapManager:GetRaidID()
  local playId = GameConfig.StarArk and GameConfig.StarArk.CutScene and GameConfig.StarArk.CutScene[raidId]
  if playId then
    local anchorPos = self:GetPosition()
    local dir = self:GetAngleY()
    local anchorDir = LuaVector3.Zero()
    LuaVector3.Better_Set(anchorDir, 0, dir, 0)
    self.appearanceAnimationInstanceId = Game.PlotStoryManager:Start_PQTLP(playId, function()
      self.appearanceAnimationInstanceId = nil
    end, nil, nil, false, nil, {
      target = self.data.id
    }, nil, nil, nil, nil, true, nil, anchorPos, anchorDir)
  end
end

function NNpc:StopAppearanceAnimation()
  if self.appearanceAnimationInstanceId then
    Game.PlotStoryManager:StopProgressById(self.appearanceAnimationInstanceId)
    self.appearanceAnimationInstanceId = nil
  end
end

function NNpc:InitByClient()
  local clientData = self.data.clientData
  if clientData == nil then
    return
  end
  local pos = LuaGeometry.GetTempVector3(clientData.pos.x / 1000, clientData.pos.y / 1000, clientData.pos.z / 1000)
  if not VectorUtility.AlmostEqual_3_XZ(pos, self:GetPosition()) then
    self:Server_MoveToCmd(pos)
  end
  self.data:_ClearBuffs()
  self:ClearBuff()
end

function NNpc:SyncPosAndDirToClientData()
  local pos = self:GetPosition()
  local dir = self:GetAngleY()
  self.data:SetClientDataPos(pos)
  self.data:SetClientDataDir(dir)
end

function NNpc:PlayBirthCastAction()
  local skillID = self.data.skillID
  if not skillID then
    return
  end
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillID)
  if skillInfo then
    local actionName = skillInfo:GetCastAction(self)
    local replaceActionName = skillInfo:GetFashionCastAct(self)
    if replaceActionName and replaceActionName ~= "" then
      actionName = replaceActionName
    end
    local playActionParams = Asset_Role.GetPlayActionParams(actionName, nil, 1)
    playActionParams[6] = true
    playActionParams[13] = skillInfo:AllowConcurrent(self) and 1 or 0
    self:Logic_PlayAction(playActionParams)
    Asset_Role.ClearPlayActionParams(playActionParams)
  end
end

function NNpc:TryUpdateRoadBlock()
  local roadblock_map = GameConfig.GvgNewConfig.roadblock_map
  local npcid = GameConfig.GvgNewConfig.roadblock_npcid
  if not roadblock_map or not npcid then
    return
  end
  local mapId = Game.MapManager:GetMapID()
  if TableUtility.ArrayFindIndex(roadblock_map, mapId) <= 0 then
    return
  end
  if GvgProxy.Instance:IsDefSide() then
    self:ClearRoadBlock()
    return
  end
  if npcid and self.data.staticData.id == npcid and Slua.IsNull(self.go_roadBlock) then
    self.go_roadBlockLoading = true
    Game.AssetManager_SceneItem:LoadItemAsync("RoadBlock", GameObject, function(owner, asset)
      if not self.go_roadBlockLoading then
        return
      end
      self.go_roadBlock = GameObject.Instantiate(asset)
      self.go_roadBlock.name = "RoadBlock"
      LuaGameObject.SetParent(self.go_roadBlock, self.assetRole.complete, false)
      self.go_roadBlockLoading = nil
    end)
  end
end

function NNpc:ClearRoadBlock()
  if not Slua.IsNull(self.go_roadBlock) then
    GameObject.Destroy(self.go_roadBlock)
  end
  self.go_roadBlock = nil
  self.go_roadBlockLoading = nil
end

function NNpc:RemoveSummonProgress()
  local roleTopUI = self:GetSceneUI().roleTopUI
  if roleTopUI then
    roleTopUI:RemoveSummonProgress()
  end
end

function NNpc:DoConstruct(asArray, serverData)
  self:CreateWeakData()
  NNpc.super.DoConstruct(self, asArray, self:CreateData(serverData))
  self:Init(serverData)
  if self:GetCreatureType() == Creature_Type.Npc and Game.MapManager:IsHomeMap(Game.MapManager:GetMapID()) then
    self.ai:DOPatrol(self)
  end
  Game.LogicManager_NpcTriggerAnim:OnAddNpc(self)
  self.delayRemoveTimeFlag = nil
  self.deadTimeFlag = nil
  self:TrySetComodoBuildingData()
  self:UpdateRoleRide()
end

function NNpc:ResetCamp()
  local roadblock_map = GameConfig.GvgNewConfig.roadblock_map
  if not roadblock_map then
    return
  end
  local npcid = GameConfig.GvgNewConfig.tower_npcid
  if not npcid or TableUtility.ArrayFindIndex(npcid, self.data.staticData.id) <= 0 then
    return
  end
  local mapId = Game.MapManager:GetMapID()
  if TableUtility.ArrayFindIndex(roadblock_map, mapId) <= 0 then
    return
  end
  self.data:Camp_SetIsInGVG(true)
  self.data:Camp_SetIsInMyGuild(GvgProxy.Instance:IsDefSide())
end

function NNpc:DoDeconstruct(asArray)
  self:ClearTextMesh()
  self:StopAppearanceAnimation()
  self:UnregisterInteractNpc()
  self:UnregisterInsightNpc()
  self:TryUnbindPhotoStandInfo()
  FunctionAbyssLake.Me():TrySetSummonProgress(self.data.uniqueid, self)
  HomeManager.Me():RemoveRelativeCreature(self.data:GetRelativeFurnitureID())
  if self.data:GetPushableObjID() then
    RaidPuzzleManager.Me():RemovePushObject(self)
  end
  self:Logic_LockRotation(false)
  self:_EndSkillNpc()
  self:UnRegistCulling()
  Game.LogicManager_NpcTriggerAnim:OnRemoveNpc(self)
  Game.AreaTrigger_Buff:ClearTrigger(self.data.id)
  NNpc.super.DoDeconstruct(self, asArray)
  self.delayRemoveTimeFlag = nil
  self.fadeOutRemoveDuration = nil
  self.forceRemoveTimeFlag = nil
  self.deadTimeFlag = nil
  self.smoothRemoving = false
  if self.effectControllerViewRange ~= nil then
    self.effectControllerViewRange:Destroy()
    self.effectControllerViewRange = nil
  end
  self.originalRotation = nil
  self.sceneui:Destroy()
  self.sceneui = nil
  self.assetRole:Destroy()
  self.assetRole = nil
  if Game.MapManager:IsHomeMap(Game.MapManager:GetMapID()) then
    self.ai:RemovePatrol()
  end
  self.pvpStatueInfo = nil
  self:ClearRoadBlock()
end
