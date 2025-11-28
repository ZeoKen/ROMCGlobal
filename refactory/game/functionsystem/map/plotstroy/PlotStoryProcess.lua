autoImport("EventDispatcher")
autoImport("CameraAdditiveEffectManager")
PlotStoryProcess = class("PlotStoryProcess", EventDispatcher)
PlotStoryEvent = {
  End = "PlotStoryEvent_End",
  ShutDown = "PlotStoryEvent_ShutDown"
}
PlotViewShowType = {Enter = 1, Exit = 2}
local notify = function(ename, ebody, etype)
  GameFacade.Instance:sendNotification(ename, ebody, etype)
end
local tempPos, tempRot, tempLea = LuaVector3(), LuaQuaternion(), LuaVector3()
local tempNpcStartIdx = 70000000
local KeepSceneConfig = GameConfig.PlotQuestKeepScene
local videoTimeTickId = 9999

function PlotStoryProcess:ctor(plotid, config_Prefix)
  self.config_Prefix = config_Prefix or PlotConfig_Prefix.Quest
  local config = PlotStoryProcess._getStoryConfig(plotid, self.config_Prefix)
  if not config then
    self:ErrorLog_Plot(nil, plotid)
    return
  end
  self.running = false
  self.scene_effectid_map = {}
  self.config = config
  self.maxStep = 1
  for _, stepCfg in pairs(config) do
    self.maxStep = math.max(self.maxStep, stepCfg.id)
  end
  self.plotid = plotid
  self.nowStep = 1
  self.dialogState = 0
  self.typeFuncResult = {}
end

function PlotStoryProcess._getStoryConfig(plotid, config_Prefix)
  local configName = config_Prefix .. plotid
  local config = _G[configName]
  if not config then
    config = autoImport(configName)
    if type(config) ~= "table" then
      config = _G[configName]
    end
  end
  return config
end

function PlotStoryProcess:GetNowPlotAndStepId()
  return self.plotid, self.nowStep
end

function PlotStoryProcess:ErrorLog_Plot(step, plotid)
  LogUtility.Info(string.format("<color=red>Plot(plotid:%s stepid:%s) Error Config.</color>", tostring(self.plotid), tostring(step or self.nowStep or "NULL")))
end

function PlotStoryProcess:Launch(startStep)
  if self.running then
    return
  end
  self.running = true
  self.startStep = startStep
  self.nowStep = startStep or 1
  self.keep = false
  if KeepSceneConfig then
    for k, v in pairs(KeepSceneConfig) do
      if v >= self.plotid and k <= self.plotid then
        self.keep = k
        break
      end
    end
  end
  Game.PlotStoryManager:SetCameraPlotStyle(true)
  if Game.PerformanceManager then
    Game.PerformanceManager:SkinWeightHigh(true)
  end
  redlog("Plot Launch.", self.plotid)
end

function PlotStoryProcess:ShutDown(is_PQTL)
  if not self.running then
    return
  end
  self.running = false
  if self.scene_effectid_map then
    if not self.keep then
      for id, _ in pairs(self.scene_effectid_map) do
        NSceneEffectProxy.Instance:Client_RemoveSceneEffect(PlotStoryProcess._createSceneId(id, self.keep))
        self.scene_effectid_map[id] = nil
      end
    else
      helplog("keep scene", self.plotid)
    end
  end
  if self.ui_effect_map then
    TableUtility.TableClearByDeleter(self.ui_effect_map, function(v)
      v:Stop()
    end)
  end
  self:PassEvent(PlotStoryEvent.ShutDown, self)
  if Game.PlotStoryManager:IsSeqPlotProgressEnd() then
    Game.PlotStoryManager:SetCameraPlotStyle(false)
  end
  if Game.PerformanceManager then
    Game.PerformanceManager:SkinWeightHigh(false)
  end
  redlog("Plot ShutDown.", self.plotid)
end

function PlotStoryProcess:Update(time, deltaTime)
  if not self.running then
    return
  end
  self:UpdateSceneEffect(time, deltaTime)
  local stepCfg = self.config[self.nowStep]
  if not stepCfg then
    self:ErrorLog_Plot()
  else
    local typeFunc = self[stepCfg.Type]
    if typeFunc then
      if not stepCfg.Params then
        self:ErrorLog_Plot()
      end
      if not typeFunc(self, stepCfg.Params, time, deltaTime) then
        return
      end
    else
      self:ErrorLog_Plot()
    end
  end
  helplog(string.format("PlotStoryProcess Update %s->%s", self.nowStep, self.nowStep + 1))
  self.nowStep = self.nowStep + 1
  if self.nowStep > self.maxStep then
    self:PlotEnd()
  end
end

function PlotStoryProcess:SetEndCall(endCall, endCallParam)
  self.endCall = endCall
  self.endCallParam = endCallParam
end

function PlotStoryProcess:IsPlayEnd()
  return self.nowStep > self.maxStep
end

function PlotStoryProcess:PlotEnd()
  self:PassEvent(PlotStoryEvent.End, self)
  if self.containsCF then
    CameraFilterProxy.Instance:CFQuit(true)
    self.containsCF = nil
  end
  if self.endCall then
    self.endCall(self.endCallParam, self:IsPlayEnd(), self)
  end
  self.endCall = nil
  self.endCallParam = nil
end

function PlotStoryProcess:UpdateSceneEffect(time, deltaTime)
  NSceneEffectProxy.Instance:_UpdateProjectileEffect(time, deltaTime)
end

function PlotStoryProcess:_getTargetByParams(params)
  local tempTargets = {}
  if params.teammates and TeamProxy.Instance.myTeam then
    local memberlst = TeamProxy.Instance.myTeam:GetPlayerMemberList(true, true)
    if params.teammates == 10 then
      for i = 1, #memberlst do
        local role = NSceneUserProxy.Instance:Find(memberlst[i].id)
        if role then
          table.insert(tempTargets, role)
        end
      end
    elseif memberlst[params.teammates] then
      local role = NSceneUserProxy.Instance:Find(memberlst[params.teammates].id)
      if role then
        table.insert(tempTargets, role)
      end
    end
  elseif params.player == 1 then
    tempTargets[1] = Game.Myself
  elseif params.npcuid then
    local plotid = self.keep or self.plotid
    tempTargets[1] = Game.PlotStoryManager:GetNpcRole(plotid, params.istempnpc and tempNpcStartIdx + params.npcuid or params.npcuid)
  elseif params.groupid then
    tempTargets = Game.PlotStoryManager:GetNpcRoles_ByGroupId(params.groupid)
  elseif params.mapnpcid then
    local config = Table_InteractNpc[params.mapnpcid]
    if config and config.Type == InteractNpc.InteractType.SceneObject then
      local npc = Game.InteractNpcManager.interactNpcMap[params.mapnpcid]
      table.insert(tempTargets, npc)
    else
      local npcs = NSceneNpcProxy.Instance:FindNpcs(params.mapnpcid)
      if npcs then
        for _, npcRole in pairs(npcs) do
          if params.mapnpcuid then
            if params.mapnpcuid == npcRole.data.uniqueid then
              table.insert(tempTargets, npcRole)
            end
          else
            table.insert(tempTargets, npcRole)
          end
        end
      end
    end
  elseif params.uniqueid then
    local npcRoles = NSceneNpcProxy.Instance:FindNpcByUniqueId(params.uniqueid)
    if npcRoles then
      for i = 1, #npcRoles do
        table.insert(tempTargets, npcRoles[i])
      end
    end
  elseif params.objID then
    local type = params.objType
    if type then
      local target = Game.GameObjectManagers[type]:GetObject(params.objID)
      if target then
        table.insert(tempTargets, target)
      end
    end
  end
  return tempTargets
end

function PlotStoryProcess._createSceneId(id, keep)
  return string.format("Plot%s", tostring(id))
end

function PlotStoryProcess:_getRanomByWeight(config)
  local totalWeight = 0
  local steps = {}
  local weights = {}
  for i = 1, #config do
    local single = config[i]
    steps[i] = single[1]
    weights[i] = single[2]
    totalWeight = totalWeight + (single[2] or 0)
  end
  local compareWeight = math.random(1, totalWeight)
  local weightIndex = 1
  while 0 < totalWeight do
    totalWeight = totalWeight - weights[weightIndex]
    if compareWeight > totalWeight then
      return steps[weightIndex]
    end
    weightIndex = weightIndex + 1
  end
  return 0
end

local setRolePartAnimatorCullingMode = function(assetRole, partid, mode)
  local trans = assetRole:GetPartObject(partid)
  trans = trans and trans.transform
  if not trans then
    return
  end
  local npcRoleAnimators = trans:GetComponentsInChildren(Animator, true)
  for i = 1, #npcRoleAnimators do
    npcRoleAnimators[i].cullingMode = mode
  end
end

function PlotStoryProcess._setCreatureAnimatorCullingMode(creature, mode)
  if not (creature and creature.assetRole) or Slua.IsNull(creature.assetRole.completeTransform) then
    return
  end
  creature.assetRole:SetExOnPartCreatedCallback(setRolePartAnimatorCullingMode, 0)
  local npcRoleAnimators = creature.assetRole.completeTransform:GetComponentsInChildren(Animator, true)
  for i = 1, #npcRoleAnimators do
    npcRoleAnimators[i].cullingMode = mode
  end
end

local tempArgs = {}

function PlotStoryProcess:place_to(params)
  local pos = params.pos
  if params._refParam and #params._refParam > 0 then
    local param = self:_getTargetByExParams(params._refParam[1])
    if param ~= nil and type(param) == "table" and #param == 3 and type(param[1]) == "number" and type(param[2]) == "number" and type(param[3]) == "number" then
      pos = param
    end
  end
  local ignoreNavMesh = params.ignoreNavMesh
  if not pos then
    LuaVector3.Better_Set(tempPos, 0, 0, 0)
  else
    LuaVector3.Better_Set(tempPos, pos[1], pos[2], pos[3])
  end
  local anchorTarget, isInteract
  local anchor = params.anchor_ep or params.anchor_cp
  if params.anchor_mapnpcid then
    local config = Table_InteractNpc[params.anchor_mapnpcid]
    if config and config.Type == InteractNpc.InteractType.SceneObject then
      anchorTarget = Game.InteractNpcManager.interactNpcMap[params.anchor_mapnpcid]
      isInteract = true
    end
    if not anchorTarget and params.anchor_mapnpcuid then
      anchorTarget = Game.PlotStoryManager:GetNpcRole(self.keep or self.plotid, params.istempnpc and tempNpcStartIdx + params.anchor_mapnpcuid or params.anchor_mapnpcuid)
    end
    if not anchorTarget then
      local npcs = NSceneNpcProxy.Instance:FindNpcs(params.anchor_mapnpcid)
      if npcs and params.anchor_mapnpcuid then
        for _, npcRole in pairs(npcs) do
          if params.anchor_mapnpcuid == npcRole.data.uniqueid then
            anchorTarget = npcRole
            break
          end
        end
      else
        anchorTarget = npcs and npcs[1]
      end
    end
  end
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    local target = targets[i]
    if anchorTarget and (params.anchor_ep or params.anchor_cp) then
      local npcguid
      if anchorTarget.data then
        npcguid = anchorTarget.data.id
      else
        npcguid = anchorTarget.id
      end
      if isInteract then
        Game.InteractNpcManager:AddMountInter(npcguid, params.anchor_ep or params.anchor_cp, target.data.id)
      elseif anchorTarget.assetRole then
        if params.anchor_ep then
          target:SetParent(anchorTarget.assetRole:GetEPOrRoot(params.anchor_ep))
        elseif params.anchor_cp then
          anchorTarget.assetRole:PutInCreatureToCP(params.anchor_cp, target)
          target:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, 0)
        else
          target:SetParent(anchorTarget.assetRole:GetCPOrRoot(nil))
        end
      end
    elseif anchorTarget then
      local npcguid
      if anchorTarget.data then
        npcguid = anchorTarget.data.id
      else
        npcguid = anchorTarget.id
      end
      if isInteract then
        Game.InteractNpcManager:DelMountInter(npcguid, target.data.id)
      else
        target:SetParent(nil)
      end
    else
      target:SetParent(nil)
      if target == Game.Myself then
        TableUtility.TableClear(tempArgs)
        FunctionSystem.InterruptMyselfAll()
        Game.Myself:Client_PlaceTo(tempPos, ignoreNavMesh)
        if params.dir then
          Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, params.dir)
        end
      else
        if ignoreNavMesh == nil then
          ignoreNavMesh = true
        end
        target:Server_SetPosCmd(tempPos, ignoreNavMesh)
        if params.dir then
          target:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, params.dir)
        end
      end
    end
    if Game.IsLocalEditorGame and params.pqtl_id and target then
      local oriName = target.assetRole.completeTransform.name
      local nameSp = string.split(oriName, "|")
      target.assetRole.completeTransform.name = nameSp[1] .. "|" .. params.pqtl_id
    end
  end
  return true
end

function PlotStoryProcess:summon(params)
  local npcuid = params.npcuid
  local npcid = params.npcid
  local npcname
  if npcid == nil and params.npcindex then
    local npcInfo = Game.PlotStoryManager:GetPlotCustomNpcInfo(self.config_Prefix, self.plotid, params.npcindex)
    if npcInfo then
      npcid = npcInfo.npcid
      npcname = npcInfo.name
    end
  end
  if npcuid == nil or npcid == nil then
    self:ErrorLog_Plot()
  end
  local plotid = self.keep or self.plotid
  local npcRole = Game.PlotStoryManager:GetNpcRole(plotid, npcuid)
  if not npcRole then
    local pos = params.pos
    local dir = params.dir or 0
    local forward_player = pos and pos.forward_player or params.forward_player
    if params._refParam and 0 < #params._refParam then
      local param = self:_getTargetByExParams(params._refParam[1])
      if param ~= nil then
        pos = param
      end
    end
    if not pos then
      LuaVector3.Better_Set(tempPos, 0, 0, 0)
    else
      LuaVector3.Better_Set(tempPos, pos[1], pos[2], pos[3])
    end
    tempPos[1] = math.floor(tempPos[1] * 1000) / 1000
    tempPos[2] = math.floor(tempPos[2] * 1000) / 1000
    tempPos[3] = math.floor(tempPos[3] * 1000) / 1000
    if forward_player ~= nil then
      local myself = Game.Myself
      local playerPos = myself and myself.assetRole and myself.assetRole.completeTransform.localPosition
      if forward_player then
        VectorUtility.Better_LookAt(tempPos, tempLea, playerPos)
      else
        VectorUtility.Better_LookAt(playerPos, tempLea, tempPos)
      end
      dir = tempLea.y
    end
    if npcid then
      npcRole = Game.PlotStoryManager:CreateNpcRole(plotid, npcuid, npcid, tempPos, params.groupid, npcname)
    end
    if npcRole ~= nil then
      npcRole:Server_SetPosXYZCmd(tempPos[1], tempPos[2], tempPos[3], nil, params.ignoreNavMesh)
      npcRole:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, dir, true)
      if params.alwaysAnimate then
        PlotStoryProcess._setCreatureAnimatorCullingMode(npcRole, 0)
      end
      local waitaction = function(parmaTable)
        local target = parmaTable
        if params.waitaction then
          target:Server_PlayActionCmd(params.waitaction, params.waitaction_startPct, params.waitaction_loop ~= false, nil, nil, params.waitaction_freezeAtEnd)
        else
          target:Server_PlayActionCmd("wait")
        end
      end
      waitaction(npcRole)
      if params.scale then
        npcRole:Server_SetScaleCmd(params.scale, true)
      else
        local scale = Table_Npc[npcid] and Table_Npc[npcid].Scale
        if scale then
          npcRole:Server_SetScaleCmd(scale, true)
        end
      end
      if params.fade_in then
        local from = params.fade_in_from or 0
        local to = params.fade_in_to or 1
        npcRole.assetRole:SetSmoothDisplayBody(0)
        npcRole.assetRole:AlphaFromTo(from, to, params.fade_in)
      end
    else
      redlog(tostring(npcid) .. "not Find In Table_Npc")
    end
  end
  if Game.IsLocalEditorGame and params.pqtl_id and npcRole then
    local oriName = npcRole.assetRole.completeTransform.name
    local nameSp = string.split(oriName, "|")
    npcRole.assetRole.completeTransform.name = nameSp[1] .. "|" .. params.pqtl_id
  end
  return true
end

function PlotStoryProcess:summon_temp_npc(params)
  local npcuid = params.reg_npcuid + tempNpcStartIdx
  local npcid = params.reg_npcid + tempNpcStartIdx
  local npcindex = params.reg_npcindex
  params.id = npcuid
  local npcname
  if npcid == nil and npcindex then
    local npcInfo = Game.PlotStoryManager:GetPlotCustomNpcInfo(self.config_Prefix, self.plotid, npcindex)
    if npcInfo then
      npcid = npcInfo.npcid
      npcname = npcInfo.name
    end
  end
  if npcuid == nil or npcid == nil then
    self:ErrorLog_Plot()
  end
  local npcRole = Game.PlotStoryManager:GetNpcRole(self.plotid, npcuid)
  if not npcRole then
    local pos = params.pos
    local dir = params.dir or 0
    local forward_player = pos.forward_player or params.forward_player
    if not pos then
      LuaVector3.Better_Set(tempPos, 0, 0, 0)
    else
      LuaVector3.Better_Set(tempPos, pos[1], pos[2], pos[3])
    end
    tempPos[1] = math.floor(tempPos[1] * 1000) / 1000
    tempPos[2] = math.floor(tempPos[2] * 1000) / 1000
    tempPos[3] = math.floor(tempPos[3] * 1000) / 1000
    if forward_player ~= nil then
      local myself = Game.Myself
      local playerPos = myself and myself.assetRole and myself.assetRole.completeTransform.localPosition
      if forward_player then
        VectorUtility.Better_LookAt(tempPos, tempLea, playerPos)
      else
        VectorUtility.Better_LookAt(playerPos, tempLea, tempPos)
      end
      dir = tempLea.y
    end
    if npcid then
      npcRole = Game.PlotStoryManager:CreateNpcRole(self.plotid, npcuid, npcid, tempPos, params.groupid, npcname, params)
    end
    if npcRole ~= nil then
      npcRole:Server_SetPosXYZCmd(tempPos[1], tempPos[2], tempPos[3], nil, params.ignoreNavMesh)
      npcRole:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, dir, true)
      if params.waitaction then
        npcRole:Server_PlayActionCmd(params.waitaction, nil, true)
      else
        npcRole:Server_PlayActionCmd("wait")
      end
    else
      redlog(tostring(npcid) .. "not Find In Table_Npc")
    end
    if params.scale then
      npcRole:Server_SetScaleCmd(params.scale, true)
    else
      local scale = Table_Npc[npcid] and Table_Npc[npcid].Scale
      if scale then
        npcRole:Server_SetScaleCmd(scale, true)
      end
    end
    if params.fade_in then
      local from = params.fade_in_from or 0
      local to = params.fade_in_to or 1
      npcRole.assetRole:SetSmoothDisplayBody(0)
      npcRole.assetRole:AlphaFromTo(from, to, params.fade_in)
    end
  end
  if Game.IsLocalEditorGame and params.pqtl_id and npcRole then
    local oriName = npcRole.assetRole.completeTransform.name
    local nameSp = string.split(oriName, "|")
    npcRole.assetRole.completeTransform.name = nameSp[1] .. "|" .. params.pqtl_id
  end
  return true
end

function PlotStoryProcess:remove_npc(params)
  local npcuid = params.istempnpc and tempNpcStartIdx + params.npcuid or params.npcuid
  if not npcuid then
    self:ErrorLog_Plot()
  else
    local plotid = self.keep or self.plotid
    if params.fade_out then
      local from = params.fade_out_from or 1
      local to = params.fade_out_to or 0
      local npcRoles = Game.PlotStoryManager:GetNpcRoles_ByGroupId(params.groupid)
      if npcRoles then
        for i = 1, #npcRoles do
          npcRoles[i]:SetSmoothDisplayBody(0)
          npcRoles[i]:AlphaFromTo(from, to, params.fade_out)
        end
      else
        local npcRole = Game.PlotStoryManager:GetNpcRole(plotid, npcuid)
        npcRole.assetRole:SetSmoothDisplayBody(0)
        npcRole.assetRole:AlphaFromTo(from, to, params.fade_out)
      end
      TimeTickManager.Me():CreateOnceDelayTick(params.fade_out * 1000, function()
        Game.PlotStoryManager:DestroyNpcRole(plotid, npcuid, params.groupid)
      end, self)
    else
      Game.PlotStoryManager:DestroyNpcRole(plotid, npcuid, params.groupid)
    end
  end
  return true
end

function PlotStoryProcess:show_npc(params)
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    targets[i]:Show()
  end
  return true
end

function PlotStoryProcess:hide_npc(params)
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    targets[i]:Hide()
  end
  return true
end

function PlotStoryProcess:set_visible(params)
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    targets[i]:SetVisible(params.is_true or false, params.reason)
  end
  return true
end

function PlotStoryProcess:action(params)
  local actionid = params.id
  if params.random_ids then
    actionid = RandomUtil.RandomInTable(params.random_ids)
  end
  local startPct = params.startPct
  if (not startPct or startPct == 0) and self.ff_pct and 0 < self.ff_pct then
    startPct = self.ff_pct
  end
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    local target = targets[i]
    local actionData = Table_ActionAnime[actionid]
    local loop = params.loop or false
    if actionData then
      do
        local actionName = actionData.Name
        local focusDuration = params.time and params.time / 1000
        local freezeAtEnd = params.freezeAtEnd
        local spExpression = params.spExpression
        local action = function(target)
          if target == Game.Myself then
            target:Client_PlayAction(actionName, startPct, loop, nil, focusDuration, freezeAtEnd, nil, spExpression, nil, true)
          elseif params.pos then
            if params.player ~= 1 then
              LuaVector3.Better_Set(tempPos, params.pos[1], params.pos[2], params.pos[3])
              target.ai:PushCommand(FactoryAICMD.GetActionMoveCmd(actionName, tempPos, focusDuration), self)
            end
          else
            target:Server_PlayActionCmd(actionName, startPct, loop, nil, focusDuration, freezeAtEnd, nil, spExpression, nil, true)
          end
        end
        action(target)
        PlotStoryProcess._setCreatureAnimatorCullingMode(target, 0)
      end
    end
  end
  return true
end

function PlotStoryProcess:set_dir(params)
  local dir = params.dir
  local dir_delta = params.dir_delta
  if not dir and not dir_delta then
    self:ErrorLog_Plot()
    return true
  end
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    local target = targets[i]
    if dir then
      if target == Game.Myself then
        Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, dir)
      else
        target:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, dir)
      end
    elseif target == Game.Myself then
      Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, Game.Myself:GetAngleY() + dir_delta)
    else
      target:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, target:GetAngleY() + dir_delta)
    end
    if Game.IsLocalEditorGame and params.pqtl_id and target then
      local oriName = target.assetRole.completeTransform.name
      local nameSp = string.split(oriName, "|")
      target.assetRole.completeTransform.name = nameSp[1] .. "|" .. params.pqtl_id
    end
  end
  return true
end

function PlotStoryProcess:move(params)
  local pos = params.pos
  if not pos then
    self:ErrorLog_Plot()
    return true
  end
  local move_action_name = params.custom_move_action and Table_ActionAnime[params.custom_move_action]
  move_action_name = move_action_name and move_action_name.Name
  local moveEndCall = params.moveEndCall
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    local target = targets[i]
    if target == Game.Myself then
      if Game.PlotStoryManager.inPQTL then
        if params.spd or params.spdFactor then
          local roleData = Game.Myself and Game.Myself.data
          if roleData then
            local moveSpdProp = roleData.props:GetPropByName("MoveSpd")
            local newSpd = (params.spd or moveSpdProp:GetValue()) * (params.spdFactor or 1)
            Game.Myself:Client_SetMoveSpeed(newSpd)
          end
        end
        if params.actionSpd then
          Game.Myself:Logic_SetMoveActionSpeed(params.actionSpd)
        end
      else
        if params.spd or params.spdFactor then
          Game.PlotStoryManager:SetRoleMoveSpd(Game.Myself, params.spd, params.spdFactor)
        else
          Game.PlotStoryManager:SetRoleDefaultMoveSpd(Game.Myself)
        end
        if params.actionSpd then
          Game.PlotStoryManager:SetRoleMoveActionSpd(Game.Myself, params.actionSpd)
        end
      end
      LuaVector3.Better_Set(tempPos, pos[1], pos[2], pos[3])
      TableUtility.TableClear(tempArgs)
      if Game.IsLocalEditorGame then
        Game.Myself:Client_MoveTo(tempPos, nil, moveEndCall, self, nil, nil, move_action_name)
      else
        tempArgs.targetPos = tempPos
        tempArgs.showClickGround = params.showClickGround
        tempArgs.allowExitPoint = true
        tempArgs.customMoveAction = move_action_name
        
        function tempArgs.callback(cmd, event)
          if MissionCommandMove.CallbackEvent.TeleportFailed == event then
            Game.Myself:Client_MoveTo(tempPos, nil, moveEndCall, self, nil, nil, move_action_name)
          else
          end
        end
        
        local cmd = MissionCommandFactory.CreateCommand(tempArgs, MissionCommandMove)
        if cmd then
          Game.Myself:Client_SetMissionCommand(cmd)
        end
      end
    else
      if Game.PlotStoryManager.inPQTL then
        if params.spd or params.spdFactor then
          local roleData = target and target.data
          if roleData then
            local moveSpdProp = roleData.props:GetPropByName("MoveSpd")
            local newSpd = (params.spd or moveSpdProp:GetValue()) * (params.spdFactor or 1)
            target:Client_SetMoveSpeed(newSpd)
          end
        end
        if params.actionSpd then
          target:Logic_SetMoveActionSpeed(params.actionSpd)
        end
      else
        if params.spd or params.spdFactor then
          Game.PlotStoryManager:SetRoleMoveSpd(target, params.spd, params.spdFactor)
        else
          Game.PlotStoryManager:SetRoleDefaultMoveSpd(target)
        end
        if params.actionSpd then
          Game.PlotStoryManager:SetRoleMoveActionSpd(target, params.actionSpd)
        end
      end
      target:Server_MoveToXYZCmd(pos[1] or 0, pos[2] or 0, pos[3] or 0, nil, nil, moveEndCall, move_action_name)
    end
    if Game.IsLocalEditorGame and params.pqtl_id and target then
      local oriName = target.assetRole.completeTransform.name
      local nameSp = string.split(oriName, "|")
      target.assetRole.completeTransform.name = nameSp[1] .. "|" .. params.pqtl_id
    end
  end
  return true
end

function PlotStoryProcess:talk(params)
  local text = params.text
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    local target = targets[i]
    local sceneUI = target:GetSceneUI()
    if sceneUI and text then
      sceneUI.roleTopUI:Speak(text, target, true)
    end
  end
  return true
end

function PlotStoryProcess:emoji(params)
  local emojiid = params.id
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    local target = targets[i]
    local sceneUI = target:GetSceneUI()
    local emojiData = Table_Expression[emojiid]
    if sceneUI and emojiData then
      sceneUI.roleTopUI:PlayEmoji(emojiData.NameEn, nil, nil, target)
    end
  end
  return true
end

function PlotStoryProcess:talk(params)
  local talkid = params.talkid
  if not talkid then
    self:ErrorLog_Plot()
  else
    local msg = DialogUtil.GetDialogData(talkid) and DialogUtil.GetDialogData(talkid).Text
    local targets = self:_getTargetByParams(params)
    for i = 1, #targets do
      local target = targets[i]
      local sceneUI = target:GetSceneUI()
      if sceneUI then
        sceneUI.roleTopUI:Speak(msg, target, true)
      end
    end
  end
  return true
end

function PlotStoryProcess:expression(params)
  local expression_id = params.id
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    local target = targets[i]
    if target and target.assetRole then
      target.assetRole:SetExpression(expression_id, true)
    end
  end
  return true
end

function PlotStoryProcess:add_object(params)
  local id = params.id
  local name = params.name
  local pos = params.pos
  local dir = params.dir
  local asset = Game.AssetManager:Load(ResourcePathHelper.RoleBody(name))
  if asset then
    local go = GameObject.Instantiate(asset)
    name = name .. "_" .. id
    go.name = name
    if pos then
      LuaVector3.Better_Set(tempPos, pos[1], pos[2], pos[3])
    else
      LuaVector3.Better_Set(tempPos, 0, 0, 0)
    end
    go.transform.position = tempPos
    dir = dir or 0
    LuaVector3.Better_Set(tempPos, 0, dir, 0)
    go.transform.eulerAngles = tempPos
    local body = go:GetComponent(RolePartBody)
    if body then
      local shadowCastOn = params.shadowCastOn
      if shadowCastOn == nil then
        shadowCastOn = true
      end
      body:EnableShadowCast(shadowCastOn)
    end
    if not self.pqtl_object_map then
      self.pqtl_object_map = {}
    end
    self.pqtl_object_map[name] = go
    local objID = params.LuaGameObjectID
    local objType = params.LuaGameObjectType
    if objID then
      local luaGo = go:AddComponent(LuaGameObject)
      luaGo.ID = objID
      luaGo.type = objType
      Game.RegisterGameObject(luaGo)
    end
  end
  return true
end

function PlotStoryProcess:remove_object(params)
  local id = params.id
  local name = params.name
  name = name .. "_" .. id
  if self.pqtl_object_map then
    local go = self.pqtl_object_map[name]
    if go and not LuaGameObject.ObjectIsNull(go) then
      GameObject.Destroy(go)
      Game.AssetManager:UnloadAsset(ResourcePathHelper.RoleBody(params.name))
      self.pqtl_object_map[name] = nil
    end
  end
  return true
end

PlotStoryProcess.ChangePartInvisibleReason = 912912

function PlotStoryProcess:change_part(params)
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    local target = targets[i]
    self:ChangeTargetRolePartByParam(target, params)
  end
  return true
end

local rolePartStrIndexList = {
  "Body",
  "BodyColorIndex",
  "Hair",
  "HairColorIndex",
  "Head",
  "Eye",
  "EyeColorIndex",
  "Mouth",
  "LeftHand",
  "RightHand",
  "Wing",
  "Tail",
  "Mount"
}
local PartIndex = Asset_Role.PartIndexEx
local tempPartArray = Asset_Role.CreatePartArray()
local setPartArrayByParam = function(partArray, params)
  if not partArray then
    return
  end
  local rolePartStrIndex
  for i = 1, #rolePartStrIndexList do
    rolePartStrIndex = rolePartStrIndexList[i]
    if params[rolePartStrIndex] then
      partArray[PartIndex[rolePartStrIndex]] = params[rolePartStrIndex]
    end
  end
end

function PlotStoryProcess:ChangeTargetRolePartByParam(target, params)
  if target and target.assetRole then
    if params.clone == 1 then
      Game.Myself.assetRole:GetPartsInfo(tempPartArray)
      tempPartArray[PartIndex.Mount] = 0
    else
      target.assetRole:GetPartsInfo(tempPartArray)
    end
    setPartArrayByParam(tempPartArray, params)
    target.assetRole:Redress(tempPartArray)
    if params.Partner ~= true then
      target:SetPartnerVisible(false, self.ChangePartInvisibleReason)
    end
    if params.Pet == 0 then
      local npet = PetProxy.Instance:GetMySceneNpet()
      if npet then
        npet:SetVisible(false, self.ChangePartInvisibleReason)
      end
    end
  end
end

local beginPos = LuaVector3.Zero()
local targetPostion = LuaVector3.Zero()

function PlotStoryProcess:play_effect(params)
  local path = params.path
  local ep = params.ep or 0
  local projectile = params.toEp
  local targets = self:_getTargetByParams(params)
  local myself = Game.Myself
  local loop = params.loop or false
  if 0 < #targets then
    for i = 1, #targets do
      local target = targets[i]
      if projectile and projectile.time then
        if projectile.ep and projectile.me == 1 then
          local posx, posy, posz = myself.assetRole:GetEPOrRootPosition(projectile.ep)
          LuaVector3.Better_Set(targetPostion, posx, posy, posz)
          posx, posy, posz = target.assetRole:GetEPOrRootPosition(ep)
          LuaVector3.Better_Set(beginPos, posx, posy, posz)
        elseif projectile.tag then
          local posx, posy, posz = target.assetRole:GetEPOrRootPosition(ep)
          LuaVector3.Better_Set(beginPos, posx, posy, posz)
          LuaVector3.Better_Set(targetPostion, projectile.tag[1], projectile.tag[2], projectile.tag[3])
        end
        local speed = LuaVector3.Distance(beginPos, targetPostion) / projectile.time
        target:PlayProjectileEffect(ep .. path, path, beginPos, speed * 1000, targetPostion, true)
      else
        local effect = target:PlayEffect(ep .. path, path, ep, nil, loop, true, nil, nil, true)
        if effect ~= nil then
          if params.speed then
            effect:SetPlaybackSpeed(params.speed)
          end
          if params.scale then
            local scale = params.scale
            effect:ResetLocalScaleXYZ(scale, scale, scale)
          end
          if target == Game.Myself then
            Game.PlotStoryManager:AddMyTempEffect(ep .. path)
          end
        end
      end
    end
  else
  end
  return true
end

function PlotStoryProcess:remove_effect(params)
  local path = params.path
  local ep = params.ep or 0
  if path and ep then
    local targets = self:_getTargetByParams(params)
    if targets then
      for i = 1, #targets do
        targets[i]:RemoveEffect(ep .. path)
        if targets[i] == Game.Myself then
          Game.PlotStoryManager:RemoveMyTempEffect(ep .. path)
        end
      end
    else
      redlog("no npcRole")
    end
  end
  return true
end

function PlotStoryProcess:play_effect_scene(params)
  local id = params.id
  local path = params.path
  local pos = params.pos
  if params._refParam and #params._refParam > 0 then
    local param = self:_getTargetByExParams(params._refParam[1])
    if param ~= nil then
      pos = param
    end
  end
  LuaVector3.Better_Set(tempPos, pos[1], pos[2], pos[3])
  local onshot = params.onshot
  local dir = params.dir
  local scale = params.scale
  local speed = params.speed
  local effectid = PlotStoryProcess._createSceneId(id, self.keep)
  local projectile = params.toEp
  local local_pqtl_cb = function(ae)
    if Game.IsLocalEditorGame and params.pqtl_id then
      local effectTrans = ae:GetComponent(Transform)
      local oriName = effectTrans.name
      local nameSp = string.split(oriName, "|")
      effectTrans.name = nameSp[1] .. "|" .. params.pqtl_id
    end
  end
  local assetEffect
  if projectile and projectile.pos and projectile.time then
    local tempPos2 = LuaGeometry.GetTempVector3(projectile.pos[1] or 0, projectile.pos[2] or 0, projectile.pos[3] or 0)
    local projectilespeed = LuaVector3.Distance(tempPos, tempPos2) / projectile.time
    NSceneEffectProxy.Instance:PlayProjectileEffect(effectid, path, tempPos, projectilespeed * 1000, tempPos2, true)
  else
    assetEffect = NSceneEffectProxy.Instance:Client_AddSceneEffect(effectid, tempPos, path, onshot, dir, scale, speed, local_pqtl_cb)
  end
  if self.scene_effectid_map and not onshot then
    self.scene_effectid_map[id] = 1
  end
  return true, effectid, assetEffect, assetEffect and assetEffect.guid_ts
end

function PlotStoryProcess:remove_effect_scene(params)
  local id = params.id
  local effectid = PlotStoryProcess._createSceneId(id, self.keep)
  if NSceneEffectProxy.Instance:SceneHasEffect(effectid) then
    NSceneEffectProxy.Instance:Client_RemoveSceneEffect(PlotStoryProcess._createSceneId(id, self.keep))
    if self.scene_effectid_map then
      self.scene_effectid_map[id] = nil
    end
  end
  return true
end

function PlotStoryProcess:shakescreen(params)
  local range = params.amplitude / 100
  local duration = params.time / 1000
  Game.PlotStoryManager.screenShakeToken = CameraAdditiveEffectManager.Me():StartShake(range, duration)
  return true
end

function PlotStoryProcess:fullScreenEffect(params)
  if params and params.on == true then
    if not Game.Myself.data.attrEffect3:BlindnessState() then
      local data = {}
      data.effect = params.path
      data.notAdaptFullScreen = params.notAdaptFullScreen
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.FullScreenEffectView,
        viewdata = data
      })
    end
  elseif params and params.on == false then
    EventManager.Me():DispatchEvent(UIEvent.RemoveFullScreenEffect)
    GameFacade.Instance:sendNotification(UIEvent.RemoveFullScreenEffect)
  end
  return true
end

function PlotStoryProcess:play_effect_ui(params)
  local id = params.id
  local path = params.path
  if path == nil then
    redlog("play_effect_ui: params error!")
    return true
  end
  helplog("play_effect_ui", path)
  local assetEffect = FloatingPanel.Instance:PlayMidEffect(path, nil, params.loop)
  if params.loop then
    if not self.ui_effect_map then
      self.ui_effect_map = {}
    end
    if not id then
      redlog("循环播放的ui特效的id未填！！！")
    else
      self.ui_effect_map[id] = assetEffect
    end
  end
  return true, assetEffect, assetEffect and assetEffect.guid_ts
end

function PlotStoryProcess:play_trail_effect(params)
  local targets = self:_getTargetByParams(params)
  if not targets or #targets == 0 then
    redlog("no find targets.")
    return true
  end
  local effectPath = params.path
  local speed = params.speed or GameConfig.SceneDropItem.ItemPickBallSpeed
  local audio = params.audio
  local pos
  if params.pos then
    pos = params.pos
  elseif params.frommonster then
    local c = SceneCreatureProxy.FindCreature(params.frommonster)
    if c then
      pos = c:GetPosition()
    end
  end
  if not pos then
    redlog("no pos")
    return true
  end
  local bezierRadius = params.bezierradius
  for i = 1, #targets do
    if bezierRadius then
      targets[i]:PlayPickUpTrackEffect(effectPath, pos, speed, audio, bezierRadius, true)
    else
      targets[i]:PlayPickUpTrackEffect(effectPath, pos, speed, audio)
    end
  end
  return true
end

function PlotStoryProcess:remove_effect_ui(params)
  if not self.ui_effect_map then
    return true
  end
  local id = params.id
  local assetEffect = self.ui_effect_map[id]
  if assetEffect then
    assetEffect:Stop()
    self.ui_effect_map[id] = nil
  end
  return true
end

function PlotStoryProcess:camera_filter(params)
  if params and params.filterid and params.on then
    local cfData
    for k, v in pairs(Table_CameraFilters) do
      if v.id == params.filterid then
        cfData = v
        break
      end
    end
    if cfData then
      self.containsCF = true
      CameraFilterProxy.Instance:CFSetEffectAndSpEffect(cfData.FilterName, cfData.SpecialEffectsName, true)
    end
  else
    self.containsCF = nil
    CameraFilterProxy.Instance:CFQuit(true)
  end
  return true
end

local USE_ASYNC_VER = true

function PlotStoryProcess:play_sound(params)
  local path = params.path
  local manage_info = {
    oneShotAudioManageList = nil,
    loopAudioId = nil,
    oneShot2DAudioPlay = nil
  }
  if not path then
    self:ErrorLog_Plot()
  elseif USE_ASYNC_VER then
    AudioUtility.AsyncGetAudioClip(path, nil, function(clip, context)
      if nil == clip then
        return
      end
      local the_self = context[1]
      if the_self == nil or the_self.running ~= true then
        return
      end
      local params = context[2]
      local manage_info = context[3]
      local tempPos = context[4]
      local loop = params.loop
      local audioindex = params.audio_index
      local targets = the_self:_getTargetByParams(params)
      if 0 < #targets then
        manage_info.oneShotAudioManageList = {}
        for i = 1, #targets do
          local target = targets[i]
          local ep = params.ep or RoleDefines_EP.Top
          tempPos:Set(target.assetRole:GetEPOrRootPosition(ep))
          local osAudio = AudioHelper.PlayOneShotAt(clip, tempPos[1], tempPos[2], tempPos[3], AudioSourceType.CUTSCENE_Sfx)
          TableUtility.ArrayPushBack(manage_info.oneShotAudioManageList, osAudio)
        end
      elseif loop then
        if not audioindex then
          return true
        end
        local audioid = PlotStoryProcess._createSceneId(audioindex, the_self.keep)
        if NSceneEffectProxy.Instance:CheckAudio(audioid) then
          return true
        end
        tempPos:Set(0, 0, 0)
        local audioSource = AudioHelper.PlayLoop_At(clip, tempPos[1], tempPos[2], tempPos[3], 0, AudioSourceType.CUTSCENE_Sfx)
        NSceneEffectProxy.Instance:AddAudio(audioid, audioSource)
        manage_info.loopAudioId = audioid
      else
        manage_info.oneShot2DAudioPlay = AudioHelper.PlayOneShot2D(clip, AudioSourceType.CUTSCENE_Sfx)
      end
    end, {
      self,
      params,
      manage_info,
      tempPos
    })
  else
    local loop = params.loop
    local audioindex = params.audio_index
    local targets = self:_getTargetByParams(params)
    if 0 < #targets then
      manage_info.oneShotAudioManageList = {}
      for i = 1, #targets do
        local target = targets[i]
        local ep = params.ep or RoleDefines_EP.Top
        tempPos:Set(target.assetRole:GetEPOrRootPosition(ep))
        TableUtility.ArrayPushBack(manage_info.oneShotAudioManageList, AudioUtility.PlayOneShotAt_Path(path, tempPos[1], tempPos[2], tempPos[3], AudioSourceType.CUTSCENE_Sfx))
      end
    elseif loop then
      if not audioindex then
        return true
      end
      local audioid = PlotStoryProcess._createSceneId(audioindex, self.keep)
      if NSceneEffectProxy.Instance:CheckAudio(audioid) then
        return true
      end
      local clip = AudioUtility.GetAudioClip(path)
      tempPos:Set(0, 0, 0)
      local audioSource = AudioHelper.PlayLoop_At(clip, tempPos[1], tempPos[2], tempPos[3], 0, AudioSourceType.CUTSCENE_Sfx)
      NSceneEffectProxy.Instance:AddAudio(audioid, audioSource)
      manage_info.loopAudioId = audioid
    else
      manage_info.oneShot2DAudioPlay = AudioUtility.PlayOneShot2D_Path(path, AudioSourceType.CUTSCENE_Sfx)
    end
  end
  return true, manage_info
end

function PlotStoryProcess:stop_sound(params)
  local audioindex = params.audio_index
  if not audioindex then
    return true
  end
  local audioid = PlotStoryProcess._createSceneId(audioindex, self.keep)
  NSceneEffectProxy.Instance:RemoveAudio(audioid)
  return true
end

function PlotStoryProcess:change_bgm(params)
  if params.stop then
    FunctionBGMCmd.Me():StopMissionBgm(params.defaultFromStart)
  else
    local path = params.path
    if not path then
      self:ErrorLog_Plot()
    else
      local time = params.time or 0
      FunctionBGMCmd.Me():PlayMissionBgm(path, time)
      if params.checkBgmMute then
        local mute = FunctionBGMCmd.Me():IsMute()
        local volume = FunctionBGMCmd.Me():GetVolume()
        if mute or volume == 0 then
          notify(PlotStoryViewEvent.ShowBgmButton)
        end
      end
    end
  end
  return true
end

function PlotStoryProcess:play_video(params)
  if VideoPanel.Instance and VideoPanel.Instance:IsPlaying() then
    LogUtility.Info("<color=yellow>Cannot play video during plot while another video is playing!</color>")
    return false
  end
  local path, audioOverlay = params.path, params.audio_overlay
  local fadeIn, fadeOut = params.fade_in or 0, params.fade_out or 0
  local startVideoHide, endVideoHide = params.start_video_hide or 0, params.end_video_hide or 0
  if path then
    local hasAlphaCtrl = 0 < fadeIn + fadeOut + startVideoHide + endVideoHide
    local clickAction = self.plotStoryShowSkip == false and VideoPanelClickAction.Nothing or VideoPanelClickAction.ShowCtrl
    VideoPanel.PlayVideo(path .. ".mp4", clickAction, hasAlphaCtrl and function()
      TimeTickManager.Me():ClearTick(self, videoTimeTickId)
    end or nil, audioOverlay)
    if VideoPanel.Instance and hasAlphaCtrl then
      VideoPanel.Instance:SetTextureAlpha(0 < startVideoHide + fadeIn and 0 or 1)
      self.videoStartCheckingTime, self.videoFadeIn, self.videoFadeOut, self.startVideoHide, self.endVideoHide = 0, fadeIn, fadeOut, startVideoHide, endVideoHide
      TimeTickManager.Me():CreateTick(0, 16, self._check_video_start, self, videoTimeTickId)
    end
  else
    self:ErrorLog_Plot()
  end
  return true
end

function PlotStoryProcess:_check_video_start(delta)
  self.videoStartCheckingTime = self.videoStartCheckingTime + delta
  if self.videoStartCheckingTime > 8000 then
    LogUtility.Info("<color=red>Starting playing video failed.</color>")
    TimeTickManager.Me():ClearTick(self, videoTimeTickId)
    return
  end
  local curTime = VideoPanel.Instance:GetPlayingVideoCurrentTime()
  if 0 < curTime then
    LogUtility.Info("Start playing video.")
    TimeTickManager.Me():CreateOnceDelayTick(16, function(self)
      TimeTickManager.Me():ClearTick(self, videoTimeTickId)
      self.videoDuration = VideoPanel.Instance:GetPlayingVideoDuration()
      TimeTickManager.Me():CreateTick(0, 16, self._video_fade_action, self, videoTimeTickId)
    end, self)
  end
end

function PlotStoryProcess:_video_fade_action()
  local v = VideoPanel.Instance
  local curTime = v:GetPlayingVideoCurrentTime()
  if curTime <= self.startVideoHide then
    v:SetTextureAlpha(0)
  elseif curTime <= self.startVideoHide + self.videoFadeIn then
    v:SetTextureAlpha((curTime - self.startVideoHide) / self.videoFadeIn)
  elseif curTime <= self.videoDuration - self.videoFadeOut - self.endVideoHide then
    v:SetTextureAlpha(1)
  elseif curTime <= self.videoDuration - self.endVideoHide then
    v:SetTextureAlpha((self.videoDuration - self.endVideoHide - curTime) / self.videoFadeOut)
  elseif 0 < self.endVideoHide then
    v:SetTextureAlpha(0)
  end
end

function PlotStoryProcess:dialog(params)
  if self.dialogState == 0 then
    self.dialogState = 1
    local viewName = "DialogView"
    if params.isExtendDialog then
      viewName = "ExtendDialogView"
    end
    local viewdata = {
      viewname = viewName,
      dialoglist = params.dialog,
      keepOpen = params.keepOpen,
      viewdata = {
        reEntnerNotDestory = params.reEnter
      }
    }
    
    function viewdata.callback(owner)
      owner.dialogState = 2
    end
    
    viewdata.callbackData = self
    notify(UIEvent.ShowUI, viewdata)
    if params.roleSpeak and not params.isExtendDialog then
      self:_dialog_roleSpeak(params)
    end
  end
  if self.dialogState == 2 then
    self.dialogState = 0
    return true
  end
  return false
end

function PlotStoryProcess:_dialog_roleSpeak(params)
  local targets = self:_getTargetByParams(params)
  if targets and 0 < #targets then
    local did = type(params.dialog) == "table" and params.dialog[1] or params.dialog
    local data = DialogUtil.GetDialogData(did)
    if data then
      targets[1]:GetSceneUI().roleTopUI:Speak(data.Text, targets[1], true)
    end
  end
end

function PlotStoryProcess:addbutton(params)
  local id, eventtype = params.id, params.eventtype
  if id and eventtype then
    local func = self["button_" .. eventtype]
    if func then
      local buttonData = {}
      buttonData.id = params.id
      buttonData.clickEvent = func
      buttonData.clickEventParam = self
      buttonData.text = params.text
      buttonData.textID = params.textID
      if buttonData.textID then
        local data = DialogUtil.GetDialogData(buttonData.textID)
        if data and data.Text then
          buttonData.text = data.Text
        end
      end
      buttonData.pos = params.pos
      buttonData.isInvisible = params.isInvisible
      buttonData.buttonSize = params.buttonSize
      buttonData.removeWhenClick = true
      Game.PlotStoryManager:AddButton(self.plotid, params.id, buttonData)
    end
  else
    self:ErrorLog_Plot()
  end
  return true
end

function PlotStoryProcess:showview(params)
  local panelid, showtype = params.panelid, params.showtype
  if panelid then
    if showtype == PlotViewShowType.Enter then
      local viewdata = params.viewdata
      local param
      if viewdata then
        param = {}
        for i = 1, #viewdata do
          local data = viewdata[i]
          param[data.key] = data.value
        end
      end
      Game.PlotStoryManager:AddUIView(panelid, nil, param, params.panelKeep)
    else
      Game.PlotStoryManager:CloseUIView(panelid, params.forceClose)
    end
  end
  return true
end

function PlotStoryProcess:play_subtitle(params)
  notify(PlotStoryViewEvent.PlaySubTitle, params)
  return true
end

function PlotStoryProcess:hide_subtitle(params)
  notify(PlotStoryViewEvent.HideSubTitle, params)
  return true
end

function PlotStoryProcess:play_narrator(params)
  notify(PlotStoryViewEvent.PlayNarrator, params)
  return true
end

function PlotStoryProcess:chapter(params)
  if not (params.inTime and params.outTime) or not params.time then
    return true
  end
  if not BranchMgr.IsChina() then
    GameFacade.Instance:sendNotification(MainViewEvent.ClearViewSequence)
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.ChapterEditableView,
    viewdata = {
      inTime = params.inTime,
      outTime = params.outTime,
      time = params.time,
      color = params.mask_color,
      alpha = params.mask_alpha,
      chapter = params.chapter
    }
  })
  return true
end

function PlotStoryProcess:show_mask(params)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.ChapterEditableView,
    viewdata = {
      inTime = params.inTime,
      color = params.mask_color,
      alpha = params.mask_alpha,
      outTime = params.outTime,
      time = params.time
    }
  })
  return true
end

function PlotStoryProcess:hide_mask(params)
  notify(PlotStoryViewEvent.HideMask, params.outTime)
  return true
end

function PlotStoryProcess:show_bw_loading_mask(params)
  notify(PlotStoryViewEvent.StartBWLoadingMask, params)
  return true
end

function PlotStoryProcess:hide_bw_loading_mask(params)
  notify(PlotStoryViewEvent.StopBWLoadingMask, params)
  return true
end

function PlotStoryProcess:add_ui_prefab(params)
  notify(PlotStoryViewEvent.AddUIPrefab, params)
  return true
end

function PlotStoryProcess:remove_ui_prefab(params)
  notify(PlotStoryViewEvent.RemoveUIPrefab, params)
  return true
end

function PlotStoryProcess:start_qte(params)
  if params.panelConfig and PanelConfig[params.panelConfig] then
    FunctionQTE.Me():StartQTE(self.plotid, PanelConfig[params.panelConfig], false, params.theme_cfg or 1, nil, nil)
  end
  return true
end

function PlotStoryProcess:qte_step(params)
  params.plotProcess = self
  if params.type then
    FunctionQTE.Me():AddStep(params, nil)
  end
  return true
end

function PlotStoryProcess:main_ui_fade_in(params)
  notify(PlotStoryViewEvent.MainUIFadeIn, params)
  return true
end

function PlotStoryProcess:qte_permanent_start(params)
  params.plotProcess = self
  if params.AS_play_sound then
    FunctionQTE.Me():AddQTEPeriodCustomAction(params, nil)
    return true
  end
  FunctionQTE.Me():AddQTEPeriodClick(params, nil)
  return true
end

function PlotStoryProcess:qte_permanent_end(params)
  FunctionQTE.Me():RemoveQTEPeriodClick(params)
end

function PlotStoryProcess:add_picture(params)
  notify(PlotStoryViewEvent.AddPicture, params)
  return true
end

function PlotStoryProcess:remove_picture(params)
  notify(PlotStoryViewEvent.RemovePicture, params)
  return true
end

function PlotStoryProcess:startfilter(params)
  local filter = params.fliter or params.filter
  FunctionSceneFilter.Me():StartFilter(filter)
  if params.isApplyDefault then
    FunctionSceneFilter.Me():SetApplyDefaultSceneFilterId(filter)
  end
  Game.PlotStoryManager:RecordPlotStorySceneFilter(filter)
  return true
end

function PlotStoryProcess:endfilter(params)
  local filter = params.fliter or params.filter
  FunctionSceneFilter.Me():EndFilter(filter)
  Game.PlotStoryManager:RemovePlotStorySceneFilter(filter)
  return true
end

function PlotStoryProcess:goto_scene(params)
  if params and params.map and Table_Map[params.map] and params.pos then
    local data = {}
    data.dmapID = 0
    data.mapID = params.map
    data.mapName = Table_Map[params.map].NameZh
    data.pos = {
      x = params.pos[1],
      y = params.pos[2],
      z = params.pos[3]
    }
    Game.changeSceneData = data
    FunctionChangeScene.Me():TryLoadScene(data)
  end
  return true
end

function PlotStoryProcess:addMapAnime(params)
  if params.sceneBossAnimeID then
    local cfg = Table_SceneBossAnime and Table_SceneBossAnime[params.sceneBossAnimeID]
    if cfg then
      params.objID = cfg.ObjID
      params.anim = cfg.Name
    end
  end
  if params.objID and params.anim then
    Game.GameObjectManagers[Game.GameObjectType.SceneBossAnime]:ExplicitlyPlaySceneAnime(params.objID, params.anim, params.startFrom)
  else
    redlog("addMapAnime objID 或 anim 不存在")
  end
  return true
end

function PlotStoryProcess:sky(params)
  if params and params.id and params.sec then
    LogUtility.InfoFormat("<color=green>PQ SkyChange: </color>{0}, {1}", params.id, params.sec)
    Game.MapManager:SetEnviroment(params.id, params.sec)
  end
  return true
end

function PlotStoryProcess:weather(params)
  if params and params.id > 0 then
    Game.PlotStoryManager:LocalChangeWeather(params.id)
  else
    Game.PlotStoryManager:RestoreToServerWeather()
  end
  return true
end

local bstart = true
local startTime = 0

function PlotStoryProcess:onoff_camerapoint(params)
  local groupid, active = params.groupid, params.on
  if groupid == nil then
    bstart = true
    return true
  end
  helplog("onoff_camerapoint:", groupid, active)
  if active == true then
    if FunctionCameraEffect.Me():IsFreeCameraLocked() then
      CameraPointManager.Instance:EnableGroup(groupid)
      Game.PlotStoryManager:RecordPlotStoryOnCameraPoint(groupid)
      return true
    end
    local dt = params.returnDefaultTime or 10
    if dt == 0 then
      dt = 10
    end
    if bstart then
      FunctionCameraEffect.Me():ReturnDefault(dt / 1000)
      startTime = RealTime.time
      bstart = false
    end
    local deltaT = dt <= 1000 and 1 or 3
    if RealTime.time - startTime >= dt / 1000 + deltaT then
      bstart = true
      CameraPointManager.Instance:EnableGroup(groupid)
      Game.PlotStoryManager:RecordPlotStoryOnCameraPoint(groupid)
      return true
    end
  else
    Game.MapManager:UpdateCameraState(CameraController.Instance)
    CameraPointManager.Instance:DisableGroup(groupid)
    Game.PlotStoryManager:RemovePlotStoryOnCameraPoint(groupid)
    return true
  end
end

function PlotStoryProcess:start_camera_focus(params)
  local viewPort = params.viewPort or CameraConfig.NPC_FuncPanel_ViewPort
  local duration = params.duration or CameraConfig.NPC_Dialog_DURATION
  local targets = self:_getTargetByParams(params)
  local target = targets[1]
  local trans = target:GetRoleComplete().transform
  local cameraController = CameraController.singletonInstance
  if cameraController then
    local rotation = cameraController.cameraRotationEuler
    if not FunctionCameraEffect:IsFreeCameraLocked() then
      rotation.x = CameraConfig.NPC_Dialog_RotationX or 30
      cameraController.FreeDefaultInfo.rotation = rotation
    end
    local vp, offset = self:AdjustViewPort(viewPort, rotation.x)
    self.cft = CameraEffectFocusAndRotateTo.new(trans, offset, vp, rotation, duration)
  else
    local vp, offset = self:AdjustViewPort(viewPort)
    self.cft = CameraEffectFocusTo.new(trans, vp, duration)
    self.cft:SetFocusOffset(offset)
  end
  FunctionCameraEffect.Me():Start(self.cft)
  return true
end

function PlotStoryProcess:AdjustViewPort(viewPort, angleX)
  local vp = LuaVector3.New(viewPort[1], viewPort[2], viewPort[3])
  local viewWidth = UIManagerProxy.Instance:GetUIRootSize()[1]
  vp[1] = 0.5 - (0.5 - vp[1]) * 1280 / viewWidth
  return FunctionCameraEffect.Me():AdjustCameraViewportAndFocusoffset(CameraController.singletonInstance, vp, nil, angleX)
end

function PlotStoryProcess:end_camera_focus(params)
  local duration = params.duration
  if self.cft then
    if duration then
      self.cft.duration = duration
    end
    FunctionCameraEffect.Me():End(self.cft)
    self.cft = nil
  end
  Game.Myself:UpdateEpNodeDisplay(false)
  return true
end

function PlotStoryProcess:game_event(params)
  local config = params.eventGroupID
  config = Table_PlotGameEvent and Table_PlotGameEvent[config]
  if config and config.eventName then
    EventManager.Me():DispatchEvent(config.eventName, config.eventArgs)
    GameFacade.Instance:sendNotification(config.eventName, config.eventArgs)
  end
  return true
end

local wait_checkCount, wait_checkInterval = 0, 5

function PlotStoryProcess:wait_loaded(params)
  wait_checkCount = wait_checkCount + 1
  if wait_checkCount % wait_checkInterval ~= 1 then
    return false
  end
  if params.maxCheckCount and wait_checkCount > params.maxCheckCount then
    wait_checkCount = 0
    return true
  end
  if not params.player or Game.Myself and Game.Myself.assetRole and not Game.Myself.assetRole:_IsLoading() then
  else
    return false
  end
  if params.npcuid and 0 < #params.npcuid then
    local npc
    for i = 1, #params.npcuid do
      npc = Game.PlotStoryManager:GetNpcRole(self.plotid, math.ceil(params.npcuid[i]))
      if npc and npc.assetRole and npc:IsDressed() and not npc.assetRole:_IsLoading() then
      else
        return false
      end
    end
  end
  wait_checkCount = 0
  return true
end

function PlotStoryProcess:claim_cross_scene(params)
  self.crossSceneParams = params
  self.endMaskInfo = nil
end

local parseSceneObjectParams = function(owner, params)
  if params._refParam and #params._refParam > 0 then
    local param = owner:_getTargetByExParams(params._refParam[1])
    params.objID = param.id
    params.objType = param.type
  end
end

function PlotStoryProcess:play_object_anim(params)
  local anim = params.anim
  local progress = params.startFrom or 0
  parseSceneObjectParams(self, params)
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    local target = targets[i]
    local animator = target:GetComponent(Animator)
    if animator and anim then
      GameObjectUtil.SetBehaviourEnabled(animator, true)
      animator:Play(anim, -1, progress)
    end
  end
  return true
end

function PlotStoryProcess:stop_object_anim(params)
  parseSceneObjectParams(self, params)
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    local target = targets[i]
    local animator = target:GetComponent(Animator)
    if animator then
      GameObjectUtil.SetBehaviourEnabled(animator, false)
    end
  end
  return true
end

function PlotStoryProcess:play_effect_on_object(params)
  parseSceneObjectParams(self, params)
  local path = params.path
  local ep = params.ep
  local scale = params.scale
  local objID = params.objID
  local objType = params.objType
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    local target = targets[i]
    target = ep and Game.GameObjectUtil:DeepFind(target.gameObject, "EP_" .. ep) or target
    local effect
    local cb = function(effectHandle, args, effect)
      effect:ResetParent(target.transform)
    end
    if params.loop then
      effect = Asset_Effect.PlayOn(path, nil, cb, nil, scale)
      local key = objType .. "_" .. objID
      key = ep and key .. "_" .. ep or key
      self.sceneObjectEffectMap[key] = effect
    else
      effect = Asset_Effect.PlayOneShotOn(path, nil, cb, nil, scale)
    end
    if params.speed then
      effect:SetPlaybackSpeed(params.speed)
    end
  end
  return true
end

function PlotStoryProcess:remove_effect_on_object(params)
  parseSceneObjectParams(self, params)
  local objID = params.objID
  local objType = params.objType
  local ep = params.ep
  local key = objType .. "_" .. objID
  key = ep and key .. "_" .. ep or key
  local effect = self.sceneObjectEffectMap[key]
  if effect then
    effect:Destroy()
    self.sceneObjectEffectMap[key] = nil
  end
  return true
end

function PlotStoryProcess:play_sound_on_object(params)
  parseSceneObjectParams(self, params)
  local id = params.id
  local path = params.path
  local loop = params.loop
  local ep = params.ep
  local audioSourceType = params.audioSourceType or AudioSourceType.SCENE
  local range = params.range or 2
  if not path then
    self:ErrorLog_Plot()
    return true
  end
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    local target = targets[i].gameObject
    target = ep and Game.GameObjectUtil:DeepFind(target, "EP_" .. ep) or target
    local x, y, z = LuaGameObject.GetPositionGO(target)
    LuaVector3.Better_Set(tempPos, x, y, z)
    local audioId = PlotStoryProcess._createSceneId(id, self.keep)
    if NSceneEffectProxy.Instance:CheckAudio(audioId) then
      return true
    end
    local clip = AudioUtility.GetAudioClip(path)
    local audioSource
    if loop then
      audioSource = AudioHelper.PlayLoop_At(clip, x, y, z, range, audioSourceType)
    else
      audioSource = AudioHelper.Play_At(clip, x, y, z, range, audioSourceType)
    end
    NSceneEffectProxy.Instance:AddAudio(audioId, audioSource)
    self.sceneObjectAudioIds[#self.sceneObjectAudioIds + 1] = audioId
  end
  return true
end

function PlotStoryProcess:stop_sound_on_object(params)
  local id = params.id
  if not id then
    return true
  end
  local audioId = PlotStoryProcess._createSceneId(id, self.keep)
  NSceneEffectProxy.Instance:RemoveAudio(audioId)
  TableUtility.ArrayRemove(self.sceneObjectAudioIds, audioId)
  return true
end

function PlotStoryProcess:camera(params)
  if params.type == nil or params.type == 0 then
    local tpos, trot
    if params.pos then
      LuaVector3.Better_Set(tempPos, params.pos[1], params.pos[2], params.pos[3])
      tpos = tempPos
    end
    if params.rotate then
      LuaQuaternion.Better_SetEulerAngles(tempRot, LuaGeometry.GetTempVector3(params.rotate[1], params.rotate[2], params.rotate[3]))
      trot = tempRot
    end
    Game.PlotStoryManager:SetCamera(tpos, trot, params.fieldview)
    Game.PlotStoryManager:SetCameraEndStay(params.endstay == 1)
  elseif params.type == 1 then
  end
  return true
end

function PlotStoryProcess:play_camera_anim(params)
  if params.name then
    time = params.time or 0
    Game.MapManager:SceneAnimationLaunch(params.name, time)
  end
  return true
end

function PlotStoryProcess:reset_camera(params)
  Game.MapManager:SceneAnimationShutdown(true)
  Game.PlotStoryManager:ActiveCameraControl(true, params.duration)
  return true
end

function PlotStoryProcess:button_goon(buttonData)
  if buttonData and buttonData.id then
    Game.PlotStoryManager:SetButtonState(self.plotid, buttonData.id, 2)
  end
end

function PlotStoryProcess:playdialog(params)
  notify(MyselfEvent.AddWeakDialog, DialogUtil.GetDialogData(params.id))
  return true
end

function PlotStoryProcess:npcscale(params)
  local scale = params.scale
  local speed = params.speed or 1
  if not scale then
    self:ErrorLog_Plot()
    return true
  end
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    local target = targets[i]
    target:Server_SetScaleSpeed(speed)
    target:Server_SetScaleCmd(scale, false)
  end
  return true
end

function PlotStoryProcess:scene_action(params)
  local name = params.name
  if name == nil then
    local actionid = params.id
    if actionid == nil then
      redlog("cmd:scene_action no config name or id.")
      return true
    end
    local actionData = Table_ActionAnime[actionid]
    name = actionData and actionData.Name or ""
  end
  local npcid, uniqueid = params.npcid, params.uniqueid
  if uniqueid then
    local npcs = NSceneNpcProxy.Instance:FindNpcByUniqueId(uniqueid)
    if npcs == nil or npcs[1] == nil then
      redlog(string.format("No Find Npc. UniqueId:%s", tostring(uniqueid)))
      return true
    end
    npcs[1]:Server_PlayActionCmd(name, nil, false)
    return true
  end
  local scene_objname = params.scene_objname
  if scene_objname then
    local sceneObj = GameObject.Find(scene_objname)
    if sceneObj == nil then
      redlog(string.format("not find sceneObj:%s", scene_objname))
      return true
    end
    local animator = sceneObj:GetComponent(Animator)
    if animator == nil then
      redlog(string.format("obj:%s not find animator", scene_objname))
      return true
    end
    animator:Play(name, -1, 0)
    return true
  end
  return true
end

function PlotStoryProcess:change_uv_speed(params)
  local id = params.id
  local path = params.path
  local effectid = PlotStoryProcess._createSceneId(id, self.keep)
  local meshName = params.meshName
  if NSceneEffectProxy.Instance:SceneHasEffect(effectid) then
    NSceneEffectProxy.Instance:Client_SetSceneEffectUVSpeed(effectid, meshName, params.speed)
  end
  return true
end

function PlotStoryProcess:changenpccolor(params)
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    local target = targets[i]
    if target then
      local eyecolor = params.eyecolor
      local haircolor = params.haircolor
      local bodycolor = params.bodycolor
      local assetRole = target.assetRole
      if haircolor then
        assetRole:SetHairColor(haircolor)
      end
      if bodycolor then
        assetRole:SetBodyColor(bodycolor)
      end
      if eyecolor then
        assetRole:SetEyeColor(eyecolor)
      end
    end
  end
  return true
end

function PlotStoryProcess:changejob(params)
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    local target = targets[i]
    if target then
      if params.body then
        target.data.userdata:Set(UDEnum.BODY, params.body)
      end
      target:PlayChangeJob()
    end
  end
  return true
end

local _waittime = 0

function PlotStoryProcess:wait_time(params, time, deltaTime)
  if not params.time then
    self:ErrorLog_Plot()
    _waittime = 0
    return true
  end
  _waittime = _waittime + math.floor(deltaTime * 1000)
  if _waittime >= params.time then
    _waittime = 0
    return true
  end
  return false
end

function PlotStoryProcess:wait_pos(params)
  local target
  if params.player == 1 then
    target = Game.Myself
  elseif params.npcuid then
    local plotid = self.keep or self.plotid
    target = Game.PlotStoryManager:GetNpcRole(plotid, params.istempnpc and tempNpcStartIdx + params.npcuid or params.npcuid)
  end
  if target then
    local pos = params.pos
    if pos then
      LuaVector3.Better_Set(tempPos, pos[1], pos[2], pos[3])
      local distance = params.distance or 1
      local targetPos = target:GetPosition()
      if targetPos then
        return LuaVector3.Distance_Square(targetPos, pos) <= distance * distance
      end
    else
      self:ErrorLog_Plot()
    end
  else
    self:ErrorLog_Plot()
  end
  return true
end

function PlotStoryProcess:wait_ui(params)
  local buttonid = params.button
  if buttonid then
    local buttonState = Game.PlotStoryManager:GetButtonState(self.plotid, buttonid)
    if buttonState == 2 then
      Game.PlotStoryManager:SetButtonState(self.plotid, buttonid, 0)
      return true
    else
      return false
    end
  end
  self:ErrorLog_Plot()
  return true
end

function PlotStoryProcess:wait_step(params)
  local stepid, plotid = params.stepid, params.plotid
  if stepid then
    local progress = self
    if plotid then
      progress = Game.PlotStoryManager:GetProgressById(plotid)
    end
    if progress then
      local _, nowstep = progress:GetNowPlotAndStepId()
      return stepid <= nowstep
    else
      self:ErrorLog_Plot()
    end
  end
  return true
end

function PlotStoryProcess:start_plot(params)
  local plotid = params.plotid
  if not plotid then
    self:ErrorLog_Plot()
  else
    Game.PlotStoryManager:Play(plotid, PlotConfig_Prefix.Anim, self.config_Prefix)
  end
  return true
end

function PlotStoryProcess:stop_plot(params)
  local plotid = params.plotid
  if not plotid then
    self:ErrorLog_Plot()
  else
    Game.PlotStoryManager:StopProgressById(plotid)
  end
  return true
end

function PlotStoryProcess:set_timescale(params)
  local timescale = params.timescale
  if type(timescale) ~= "number" then
    self:ErrorLog_Plot()
  else
    UnityEngine.Time.timeScale = timescale
  end
  return true
end

function PlotStoryProcess:exchangenpc(params)
end

function PlotStoryProcess:play_cameraPlot(params, time, deltaTime)
  return FunctionCameraEffect.Me():PlayCameraPlot(params.groupid)
end

function PlotStoryProcess:filter(params)
  local filter = params.filter
  if filter == nil then
    return true
  end
  local on = params.on
  if on == 1 then
    FunctionSceneFilter.Me():StartFilter(filter)
  else
    FunctionSceneFilter.Me():StartFilter(filter)
  end
  return true
end

function PlotStoryProcess:summon_mount_npc(params)
  local npcid = params.npcid or 0
  local plotid = self.keep or self.plotid
  local charid = Game.Myself.data.id
  local guid = Game.PlotStoryManager:CombineNpcKey(plotid, params.npcuid)
  Game.InteractNpcManager:AddInteractMountNPC(guid, npcid, charid)
  return true
end

function PlotStoryProcess:remove_mount_npc(params)
  local charid = Game.Myself.data.id
  Game.InteractNpcManager:DelInteractMountNPC(charid)
  return true
end

function PlotStoryProcess:random_jump(params)
  local config = params.id
  if not config then
    return true
  end
  local nextstep = self:_getRanomByWeight(config) or 0
  if nextstep > self.nowStep then
    self.nowStep = nextstep - 1
  end
  return true
end
