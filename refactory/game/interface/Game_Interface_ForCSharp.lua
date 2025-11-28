local _Game = Game

function Game.Command_ED(cmdID)
end

local frameCount = 0

function Game.Update(time, deltaTime, unscaledTime, realtimeSinceStartup)
  if _Game.State == _Game.EState.Finished then
    LogUtility.Info("Game.Update() EState.Finished return")
    return
  end
  UnityTime = time
  UnityDeltaTime = deltaTime
  UnityUnscaledTime = unscaledTime
  UnityRealtimeSinceStartup = realtimeSinceStartup
  frameCount = frameCount + 1
  UnityFrameCount = frameCount
  Game.DataStructureManager:Update(time, deltaTime)
  Game.FunctionSystemManager:Update(time, deltaTime)
  Game.GUISystemManager:Update(time, deltaTime)
  Game.GCSystemManager:Update(time, deltaTime)
end

function Game.LateUpdate(time, deltaTime, unscaledTime, realtimeSinceStartup)
  if _Game.State == _Game.EState.Finished then
    LogUtility.Info("Game.LateUpdate() EState.Finished return")
    return
  end
  UnityTime = time
  UnityDeltaTime = deltaTime
  UnityUnscaledTime = unscaledTime
  UnityRealtimeSinceStartup = realtimeSinceStartup
  Game.FunctionSystemManager:LateUpdate(time, deltaTime)
  Game.GUISystemManager:LateUpdate(time, deltaTime)
end

function Game.OnSceneAwake(sceneInitializer)
end

function Game.OnSceneStart(sceneInitializer)
  LogUtility.DebugInfoFormat(sceneInitializer, "<color=green>OnSceneStart({0}, {1})</color>", sceneInitializer, UnityFrameCount)
  SceneProxy.Instance:LoadedSceneAwaked()
end

function Game.OnCharacterSelectorStart(selector)
  if GameConfig.CreateRole and GameConfig.CreateRole.UseNewVersion and GameConfig.CreateRole.UseNewVersion > 0 then
    FunctionNewCreateRole.Me():Launch()
  else
    FunctionSelectCharacter.Me():Launch(selector)
  end
end

function Game.OnCharacterSelectorDestroy()
  if GameConfig.CreateRole and GameConfig.CreateRole.UseNewVersion and GameConfig.CreateRole.UseNewVersion > 0 then
    FunctionNewCreateRole.Me():Shutdown()
    if Game.PerformanceManager then
      Game.PerformanceManager:SkinWeightHigh(false)
    end
  else
    FunctionSelectCharacter.Me():Shutdown()
  end
end

function Game.SetWeatherInfo(r, g, b, a, scale)
  Game.EnviromentManager:SetWeatherInfo(r, g, b, a, scale)
end

function Game.SetWeatherAnimationEnable(enable)
  Game.EnviromentManager:SetWeatherAnimationEnable(enable)
end

function Game.RegisterGameObject(obj)
  local manager = Game.GameObjectManagers[obj.type]
  if manager == nil then
    redlog("LuaGameObject Type is not implement." .. tostring(obj.type))
    return true
  end
  local ret = manager:RegisterGameObject(obj)
  return ret
end

function Game.UnregisterGameObject(obj)
  local manager = Game.GameObjectManagers[obj.type]
  if manager == nil then
    return
  end
  local ret = manager:UnregisterGameObject(obj)
  LogUtility.DebugInfoFormat(obj, "<color=blue>UnregisterGameObject({0})</color>: {1}", obj, ret)
  return ret
end

function Game.Creature_Fire(guid)
  local creature = SceneCreatureProxy.FindCreature(guid)
  if nil == creature then
    return
  end
  creature.skill:Fire(creature)
end

function Game.Creature_Interrupt(guid)
  local creature = SceneCreatureProxy.FindCreature(guid)
  if nil == creature then
    return
  end
  local Myself = Game.Myself
  local isCurrentCommand_Skill = Myself:Client_IsCurrentCommand_Skill()
  local hasSkillFree = CDProxy.Instance:CheckAutoSkillFree()
  if Myself == creature and isCurrentCommand_Skill and Game.AutoBattleManager.on and (hasSkillFree or Myself:IsSpecialInterruptSkill()) then
    creature.skill:End(creature)
  end
  creature.skill:Interrupt(creature)
end

function Game.Creature_Dead(guid)
  local creature = SceneCreatureProxy.FindCreature(guid)
  if nil == creature then
    return
  end
  creature:PlayDeathEffect()
end

function Game.PlayEffect_OneShotAt(path, x, y, z)
  Asset_Effect.PlayOneShotAtXYZ(path, x, y, z)
end

function Game.PlayEffect_RemoveAutoDestroyPCall(luaInstanceID, isDestroyFromCSharp)
  Game.AssetManager_Effect:RemoveAutoDestroyEffect(luaInstanceID, isDestroyFromCSharp)
end

local rolePos = LuaVector3.Zero()

function Game.Input_ClickRole(guid)
  local myself = Game.Myself
  myself:Client_ManualControlled()
  local creature = SceneCreatureProxy.FindCreature(guid)
  if nil == creature then
    return
  end
  if myself.skill:IsCastingShiftPointSkill() then
    rolePos = creature:GetPosition()
    if rolePos then
      Game.Input_ClickTerrain(rolePos[1], rolePos[2], rolePos[3])
    end
    return
  end
  local _PvpObserveProxy = PvpObserveProxy.Instance
  if _PvpObserveProxy:IsAttaching() then
    return
  end
  if _PvpObserveProxy:IsGhost() then
    if creature:GetCreatureType() == Creature_Type.Player then
      _PvpObserveProxy:TrySelect(guid)
    end
    return
  end
  if creature:GetCreatureType() == Creature_Type.Pet and creature.data:IsCatchNpc_Detail() then
    FunctionVisitNpc.Me():AccessCatchingPet(creature)
    return
  end
  local camp = creature.data:GetCamp()
  if creature:GetCreatureType() == Creature_Type.Pet and creature.data:IsWarehouseNpc() then
    if myself:IsInWarehouse() or RoleDefines_Camp.FRIEND ~= camp then
      return
    else
      local accessRange = creature.data:GetAccessRange()
      myself:Client_AccessTarget(creature, nil, nil, AccessCustomType.Warehouse, accessRange)
      return
    end
  end
  if creature:GetCreatureType() == Creature_Type.Npc and RoleDefines_Camp.FRIEND == camp and Game.MapManager:IsPvPMode_TeamTwelve() and creature.data:IsTwelveBase_Detail() then
    Game.Myself:Client_LockTarget(creature)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TwelvePVPShopView
    })
    return
  end
  if RoleDefines_Camp.ENEMY == camp then
    myself:Client_LockTarget(creature)
    myself:Client_AutoAttackTarget(creature)
  elseif RoleDefines_Camp.NEUTRAL == camp then
    myself:Client_LockTarget(creature)
    myself:Client_AccessTarget(creature)
  elseif RoleDefines_Camp.FRIEND == camp then
    myself:Client_LockTarget(creature)
    if creature:GetCreatureType() == Creature_Type.Npc and creature.data:CanVisit() then
      myself:Client_AccessTarget(creature)
    end
  end
  Game.GameHealthProtector:OnClickRole(creature)
end

function Game.Input_ClickObject(obj)
  LogUtility.InfoFormat("<color=yellow>Input_ClickObject: </color>{0}, {1}, {2}", obj.type, obj.ID, obj.name)
  local objType = obj.type
  if Game.GameObjectType.SceneSeat == objType then
    Game.SceneSeatManager:ClickSeat(obj)
  elseif Game.GameObjectType.WeddingPhotoFrame == objType then
    Game.GameObjectManagers[objType]:OnClick(obj)
  elseif Game.GameObjectType.ScenePhotoFrame == objType then
    Game.GameObjectManagers[objType]:OnClick(obj)
  elseif Game.GameObjectType.SceneGuildFlag == objType then
    Game.GameObjectManagers[objType]:OnClick(obj)
  elseif Game.GameObjectType.Furniture == objType then
    Game.GameObjectManagers[objType]:OnClick(obj)
  elseif Game.GameObjectType.InteractCard == objType then
    Game.GameObjectManagers[objType]:OnClick(obj)
  elseif Game.GameObjectType.PhotoStand == objType then
    Game.GameObjectManagers[objType]:OnClick(obj)
  elseif Game.GameObjectType.StealthGame == objType then
    SgAIManager.Me():OnClickTrigger(obj)
  end
  Game.GameHealthProtector:OnClickObject(obj)
end

local tempVector3 = LuaVector3.Zero()
local pos = LuaVector3.Zero()

function Game.Input_ClickTerrain(x, y, z)
  if PvpObserveProxy.Instance:IsAttaching() then
    return
  end
  local myself = Game.Myself
  if myself.skill:IsCastingShiftPointSkill() then
    tempVector3:Set(x, y, z)
    local targetAngleY = VectorHelper.GetAngleByAxisY(myself:GetPosition(), tempVector3)
    myself.logicTransform:SetAngleY(targetAngleY)
    myself:Client_SetSkillDir(targetAngleY)
    myself.skill:ChangeTargetPosition(tempVector3)
    ProtolUtility.C2S_Vector3(tempVector3, pos)
    ServiceSkillProxy.Instance:CallSetCastPosSkillCmd(pos)
    return
  end
  if SgAIManager.Me():IsHiding() then
    return
  end
  Game.Myself:Client_ManualControlled()
  LuaVector3.Better_Set(tempVector3, x, y, z)
  Game.Myself:Client_MoveTo(tempVector3)
  Game.GameHealthProtector:OnClickTerrain(tempVector3)
end

function Game.SaveCustomCameraRotation(x, y, z)
  GameFacade.Instance:sendNotification(TouchEvent.ExitFreeCamera)
  LocalSaveProxy.Instance:SetFreeCameraRotation(x, y, z)
end

Game.JoyStickDir = LuaVector3.Zero()
Game.DisableJoyStick = false
local C2S_Number = ProtolUtility.C2S_Number
local targetPos = LuaVector3.Zero()

function Game.Input_JoyStick(x, y, z)
  if Game.DisableJoyStick then
    return
  end
  if PvpObserveProxy.Instance:IsAttaching() then
    PvpObserveProxy.Instance:TryBeGhost()
    return
  end
  Game.IsJoyStick = true
  local myself = Game.Myself
  myself:Client_ManualControlled()
  local dir = Game.JoyStickDir
  LuaVector3.Better_Set(dir, x, y, z)
  myself:Client_DirMove(dir)
  myself:Client_SetSkillDir(dir)
  Game.GameHealthProtector:OnInputJoyStick(dir)
end

function Game.Input_JoyStickEnd()
  Game.IsJoyStick = false
  Game.Myself:Client_DirMoveEnd()
  Game.GameHealthProtector:OnInputJoyStickEnd()
end

function Game.PQTL_Action_CMD(pqtl_id, caster, trigger_type, action_type, param_keys, param_values, need_result, reference_param, simple_blend_info, ff_pct, ff_time)
  PlotStoryTimeLineWrapper.ProcessCMD(pqtl_id, caster, trigger_type, action_type, param_keys, param_values, need_result, reference_param, simple_blend_info, ff_pct, ff_time)
end

function Game.PQTL_Action_Preload_CMD(pqtl_id, caster, trigger_type, action_type, param_keys, param_values, reference_param)
  PlotStoryTimeLineWrapper.ProcessPreloadCMD(pqtl_id, caster, trigger_type, action_type, param_keys, param_values, reference_param)
end

function Game.PQTL_Get_ExtraParam_CMD(pqtl_id, caster, key)
  return PlotStoryTimeLineWrapper.ProcessGetExtraParamCMD(pqtl_id, caster, key)
end

function Game.CSNotify_PQTLP_Start(pqtl_id, timeline_param_keys, timeline_param_values)
  if type(timeline_param_keys) == "userdata" then
    PlotStoryTimeLineWrapper.ProcessStartCMD(pqtl_id, timeline_param_keys, timeline_param_values)
  else
    local param = {freeView = timeline_param_keys, branch = timeline_param_values}
    Game.PlotStoryManager:CSNotify_PQTLP_Start(pqtl_id, param)
  end
end

function Game.CSNotify_PQTLP_End(pqtl_id, wait_stop_watching)
  Game.PlotStoryManager:CSNotify_PQTLP_End(pqtl_id, wait_stop_watching)
end

function Game.PQTL_Action_Curve_CMD(pqtl_id, caster, curvePos, targetType)
  PlotStoryTimeLineWrapper.ProcessCurveCMD(pqtl_id, caster, curvePos, targetType)
end

function Game.PQTL_CameraMoveToDefaultPos(eulerX, eulerY, duration, curve)
  FunctionCameraEffect.Me():CameraMoveToDefaultPos(eulerX, eulerY, duration, curve, nil)
end

function Game.PQTL_BigWorldLoadingMask_CMD(pqtl_id, isShow)
  Game.PlotStoryManager:CSNotify_PQTLP_LoadingMask(pqtl_id, isShow)
end

function Game.PQTL_BigWorldLoadingFinishHalt_CMD(pqtl_id, caster)
  Game.PlotStoryManager:CSNotify_PQTLP_FinishHalt(pqtl_id, caster)
end

function Game.UpdateEnableMoveAxisDirty()
  return Game.HotKeyManager:UpdateEnableMoveAxisDirty()
end

function Game.OnApplicationWantsToQuit()
  MsgManager.ConfirmMsgByID(43480, function()
    AspectRatioController.Instance:ApplicationRawQuit()
  end)
end

function Game.OnScreenShotSaved(path)
  MsgManager.ShowMsgByID(43509, path)
  local msgConfig = Table_Sysmsg[43509]
  if msgConfig then
    local text = msgConfig.Text
    text = string.format(text, path)
    MsgManager.ChatSystemChannelMsgTableParam(nil, text)
  end
end

function Game.Debug_Creature(guid)
  LogUtility.InfoFormat("<color=yellow>[Debug_Creature] Begin</color>: {0}", guid)
  reAutoImport("NCreature_Debug")
  local creature = SceneCreatureProxy.FindCreature(guid)
  if nil == creature then
    LogUtility.InfoFormat("No Creature: {0}", guid)
    return
  end
  creature:Debug()
end

function Game.TestHandInHand(guid)
  local creature = SceneCreatureProxy.FindCreature(guid)
  if nil == creature then
    LogUtility.InfoFormat("No Creature: {0}", guid)
    return
  end
  if Game.Myself == creature then
    local followLeaderGUID = creature:Client_GetFollowLeaderID()
    if 0 ~= followLeaderGUID then
      local followType = 0
      if not creature.ai.autoAI_FollowLeader.subAI_HandInHand.on then
        followType = 1
      end
      creature:Client_SetFollowLeader(followLeaderGUID, followType)
      LogUtility.InfoFormat("Test HandInHand: {0}, {1}", creature.ai.autoAI_FollowLeader.subAI_HandInHand.on, creature.data and creature.data:GetName() or "No Name")
    else
      LogUtility.InfoFormat("HandInHand not following: {0}", creature.data and creature.data:GetName() or "No Name")
    end
  elseif nil ~= creature.data and creature.data:GetFeature_BeHold() then
    if nil ~= creature.ai.idleAI_BeHolded then
      if 0 == creature.ai.idleAI_BeHolded.masterGUID then
        if nil ~= Game.Myself then
          creature.ai.idleAI_BeHolded:Request_Set(Game.Myself.data.id)
        end
      else
        creature.ai.idleAI_BeHolded:Request_Set(0)
      end
      LogUtility.InfoFormat("Test BeHolded: {0}, {1}", creature.ai.idleAI_BeHolded.masterGUID, creature.data and creature.data:GetName() or "No Name")
    else
      LogUtility.InfoFormat("No BeHolded AI: {0}", creature.data and creature.data:GetName() or "No Name")
    end
  elseif nil ~= creature.ai.idleAI_HandInHand then
    if 0 == creature.ai.idleAI_HandInHand.masterGUID then
      if nil ~= Game.Myself then
        creature.ai.idleAI_HandInHand:Request_Set(Game.Myself.data.id)
      end
    else
      creature.ai.idleAI_HandInHand:Request_Set(0)
    end
    LogUtility.InfoFormat("Test HandInHand: {0}, {1}", creature.ai.idleAI_HandInHand.masterGUID, creature.data and creature.data:GetName() or "No Name")
  else
    LogUtility.InfoFormat("No HandInHand AI: {0}", creature.data and creature.data:GetName() or "No Name")
  end
end

local tempArray = {}

function Game.Debug_SetAttrs(guid, types, values)
  local creature = SceneCreatureProxy.FindCreature(guid)
  if nil == creature then
    LogUtility.InfoFormat("No Creature: {0}", guid)
    return
  end
  LogUtility.InfoFormat("Creature({0}) SetAttr", creature.data and creature.data:GetName() or "NoName")
  for i = 1, #types do
    local t = LogicManager_Creature_Props.NameMapID[types[i]]
    local v = values[i]
    LogUtility.InfoFormat("\t{0}: {1}", types[i], v)
    tempArray[i] = {type = t, value = v}
  end
  creature:Server_SetAttrs(tempArray)
  TableUtility.ArrayClear(tempArray)
end

function Game.OnDrawGizmos()
  Game.AreaTrigger_ExitPoint:OnDrawGizmos()
  local mapCellManager = Game.LogicManager_MapCell
  if mapCellManager then
    mapCellManager:OnDrawGizmos()
  end
end

function Game.Push_OnReceiveNotification(jsonStr)
  helplog("Push_OnReceiveNotification", jsonStr)
  GameFacade.Instance:sendNotification(PushEvent.OnReceiveNotification, jsonStr)
end

function Game.Push_OnReceiveMessage(jsonStr)
  helplog("Push_OnReceiveMessage", jsonStr)
  GameFacade.Instance:sendNotification(PushEvent.OnReceiveMessage, jsonStr)
end

function Game.Push_OnOpenNotification(jsonStr)
  helplog("Push_OnOpenNotification", jsonStr)
  GameFacade.Instance:sendNotification(PushEvent.OnOpenNotification, jsonStr)
end

function Game.Push_OnJPushTagOperateResult(result)
  helplog("Push_OnJPushTagOperateResult", result)
  GameFacade.Instance:sendNotification(PushEvent.OnJPushTagOperateResult, result)
end

function Game.Push_OnJPushAliasOperateResult(result)
  helplog("Push_OnJPushAliasOperateResult", result)
  GameFacade.Instance:sendNotification(PushEvent.OnJPushAliasOperateResult, result)
end

function Game.HandleLowMemory()
  local poolManager = Game.GOLuaPoolManager
  if poolManager then
    poolManager:HandleLowMemory()
  end
end

function Game.SpeedUpPoolRelease()
  local poolManager = Game.GOLuaPoolManager
  if poolManager then
    poolManager:SpeedUpPoolRelease()
  end
end

function Game.SendLongNetDelay(msgid, time)
  ServiceLoginUserCmdProxy.Instance:CallClientInfoUserCmd(nil, nil, time, msgid)
end

function Game.onGMEInitCB(isSuccess, code)
  GmeVoiceProxy.Instance:onGMEInitCB(isSuccess, code)
end

function Game.onGMEDestroyCB()
  GmeVoiceProxy.Instance:onGMEDestroyCB()
end

function Game.onEnterRoomCompleteCB(code, infoMsg)
  GmeVoiceProxy.Instance:onEnterRoomCompleteCB(code, infoMsg)
end

function Game.onExitRoomCompleteCB()
  GmeVoiceProxy.Instance:onExitRoomCompleteCB()
end

function Game.onEventCallBack(type, subType, data)
  GmeVoiceProxy.Instance:onEventCallBack(type, subType, data)
end

function Game.onCommonEventCallback(type, param0, param1)
  GmeVoiceProxy.Instance:onCommonEventCallback(type, param0, param1)
end

function Game.onRoomChangeQualityCallback(nQualityEVA, fLostRate, nDealy)
  GmeVoiceProxy.Instance:onRoomChangeQualityCallback(nQualityEVA, fLostRate, nDealy)
end

function Game.onAudioReadyCallback()
  GmeVoiceProxy.Instance:onAudioReadyCallback()
end

function Game.onRoomTypeChangedEventCB(nRoomType)
  GmeVoiceProxy.Instance:onRoomTypeChangedEventCB(nRoomType)
end

function Game.onRoomDisconnectCB(code, infoMsg)
  GmeVoiceProxy.Instance:onRoomDisconnectCB(code, infoMsg)
end

function Game.AudioClipFinish(audioType, clipName)
end
