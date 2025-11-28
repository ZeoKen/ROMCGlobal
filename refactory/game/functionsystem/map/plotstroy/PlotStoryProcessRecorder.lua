PlotStoryProcessRecorder = class("PlotStoryProcessRecorder", EventDispatcher)

function PlotStoryProcessRecorder:ctor()
  for k, _ in pairs(self.Type) do
    self.recordHandlers[k] = self["Record_" .. k]
    self.restoreHandlers[k] = self["Restore_" .. k]
  end
end

function PlotStoryProcessRecorder:Launch(currentProcess)
  self.currentProcess = currentProcess
  self.pendingRestoreOp = {}
end

function PlotStoryProcessRecorder:ShutDown()
  TableUtility.TableClear(self.pendingRestoreOp)
end

function PlotStoryProcessRecorder:Restore()
  for k, v in pairs(self.pendingRestoreOp) do
    self.restoreHandlers[k](self, v)
  end
end

function PlotStoryProcessRecorder:Pre_place_to(param, ...)
end

function PlotStoryProcessRecorder:Post_place_to(param, ...)
end

function PlotStoryProcessRecorder:Post_action(param, ...)
  self:Record_Action(param, ...)
end

function PlotStoryProcessRecorder:Pre_set_dir(param, ...)
end

function PlotStoryProcessRecorder:Post_set_dir(param, ...)
end

function PlotStoryProcessRecorder:Pre_move(param, ...)
  self:Record_MoveSpd(param, ...)
  self:Record_MoveActionSpd(param, ...)
end

function PlotStoryProcessRecorder:Post_emoji(param, ...)
  self:Record_Emoji(param, ...)
end

function PlotStoryProcessRecorder:Pre_expression(param, ...)
  self:Record_Expression(param, ...)
end

function PlotStoryProcessRecorder:Pre_change_part(param, ...)
  self:Record_ChangePart(param, ...)
end

function PlotStoryProcessRecorder:Post_play_effect(param, ...)
  self:Record_Effect(param, ...)
end

function PlotStoryProcessRecorder:Post_play_effect_scene(param, ...)
  self:Record_EffectScene(param, ...)
end

function PlotStoryProcessRecorder:Post_shakescreen(param, ...)
  self:Record_ShakeScreen(param, ...)
end

function PlotStoryProcessRecorder:Post_fullScreenEffect(param, ...)
  self:Record_EffectFullScreen(param, ...)
end

function PlotStoryProcessRecorder:Post_play_effect_ui(param, ...)
  if not param.skip then
    return
  end
  self:Record_EffectUI(param, ...)
end

function PlotStoryProcessRecorder:Post_play_sound(param, ...)
  self:Record_Sound(param, ...)
end

function PlotStoryProcessRecorder:Post_change_bgm(param, ...)
  self:Record_Bgm(param, ...)
end

function PlotStoryProcessRecorder:Post_startfilter(param, ...)
  self:Record_SceneFilter(param, true, ...)
end

function PlotStoryProcessRecorder:Post_endfilter(param, ...)
  self:Record_SceneFilter(param, false, ...)
end

function PlotStoryProcessRecorder:Pre_addMapAnime(param, ...)
  self:Record_MapAnime(param, ...)
end

function PlotStoryProcessRecorder:Pre_sky(param, ...)
  self:Record_Sky(param, ...)
end

function PlotStoryProcessRecorder:Post_weather(param, ...)
  self:Record_Weather(param, ...)
end

function PlotStoryProcessRecorder:Post_start_manual_move(param, ...)
  self:Record_ManualMove(param, ...)
end

function PlotStoryProcessRecorder:Post_end_manual_move(param, ...)
  self:Restore_ManualMove(self.pendingRestoreOp[self.Type.ManualMove])
end

PlotStoryProcessRecorder.Type = {
  Pos = "Pos",
  Dir = "Dir",
  Move = "Move",
  MoveSpd = "MoveSpd",
  MoveActionSpd = "MoveActionSpd",
  Action = "Action",
  Emoji = "Emoji",
  Expression = "Expression",
  ChangePart = "ChangePart",
  Effect = "Effect",
  EffectScene = "EffectScene",
  EffectFullScreen = "EffectFullScreen",
  EffectUI = "EffectUI",
  ShakeScreen = "ShakeScreen",
  Sound = "Sound",
  Bgm = "Bgm",
  SceneFilter = "SceneFilter",
  MapAnime = "MapAnime",
  Sky = "Sky",
  Weather = "Weather",
  ManualMove = "ManualMove"
}
PlotStoryProcessRecorder.recordHandlers = {}
PlotStoryProcessRecorder.restoreHandlers = {}

function PlotStoryProcessRecorder:Record_MoveSpd(...)
  local params = {
    ...
  }
  params = params[1]
  if not self.pendingRestoreOp[self.Type.MoveSpd] then
    self.pendingRestoreOp[self.Type.MoveSpd] = {}
  end
  local info = self.pendingRestoreOp[self.Type.MoveSpd]
  local targets = self.currentProcess._getTargetByParams(self.currentProcess, params)
  for i = 1, #targets do
    local target = targets[i]
    local uid, roleMoveSpdProp = target.data.id, target.data.props and target.data.props:GetPropByName("MoveSpd")
    if not info[uid] then
      info[uid] = roleMoveSpdProp and roleMoveSpdProp:GetValue()
    end
  end
end

function PlotStoryProcessRecorder:Record_MoveActionSpd(...)
  local params = {
    ...
  }
  params = params[1]
  if not self.pendingRestoreOp[self.Type.MoveActionSpd] then
    self.pendingRestoreOp[self.Type.MoveActionSpd] = {}
  end
  local info = self.pendingRestoreOp[self.Type.MoveActionSpd]
  local targets = self.currentProcess._getTargetByParams(self.currentProcess, params)
  for i = 1, #targets do
    local target = targets[i]
    local uid, oriActionSpd = target.data.id, target:Logic_GetMoveActionSpeed()
    if not info[uid] then
      info[uid] = oriActionSpd
    end
  end
end

function PlotStoryProcessRecorder:Record_Action(...)
  local params = {
    ...
  }
  if params[1] then
    if not self.pendingRestoreOp[self.Type.Action] then
      self.pendingRestoreOp[self.Type.Action] = {}
    end
    TableUtility.ArrayPushBack(self.pendingRestoreOp[self.Type.Action], params)
  end
end

function PlotStoryProcessRecorder:Record_Emoji(...)
  local params = {
    ...
  }
  if params[1] then
    if not self.pendingRestoreOp[self.Type.Emoji] then
      self.pendingRestoreOp[self.Type.Emoji] = {}
    end
    TableUtility.ArrayPushBack(self.pendingRestoreOp[self.Type.Emoji], params)
  end
end

function PlotStoryProcessRecorder:Record_Expression(...)
  local params = {
    ...
  }
  params = params[1]
  if not self.pendingRestoreOp[self.Type.Expression] then
    self.pendingRestoreOp[self.Type.Expression] = {}
  end
  local info = self.pendingRestoreOp[self.Type.Expression]
  local targets = self.currentProcess._getTargetByParams(self.currentProcess, params)
  for i = 1, #targets do
    local target = targets[i]
    local uid, assetRole = target.data.id, target.assetRole
    if not info[uid] then
      info[uid] = assetRole and assetRole:GetExpression()
    end
  end
end

function PlotStoryProcessRecorder:Record_ChangePart(...)
  local params = {
    ...
  }
  params = params[1]
  if params and params.keepChange then
    return
  end
  if not self.pendingRestoreOp[self.Type.ChangePart] then
    self.pendingRestoreOp[self.Type.ChangePart] = {}
  end
  local info = self.pendingRestoreOp[self.Type.ChangePart]
  local targets = self.currentProcess._getTargetByParams(self.currentProcess, params)
  for i = 1, #targets do
    local target = targets[i]
    local uid, assetRole = target.data.id, target.assetRole
    if not info[uid] then
      local tempPartArray = Asset_Role.CreatePartArray()
      assetRole:GetPartsInfo(tempPartArray)
      info[uid] = {
        Parts = tempPartArray,
        PartnerInvisible = params.Partner ~= true,
        PetInvisible = params.Pet == 0
      }
    end
  end
end

function PlotStoryProcessRecorder:Record_Effect(...)
  local params = {
    ...
  }
  if params[1] then
    if not self.pendingRestoreOp[self.Type.Effect] then
      self.pendingRestoreOp[self.Type.Effect] = {}
    end
    TableUtility.ArrayPushBack(self.pendingRestoreOp[self.Type.Effect], params)
  end
end

function PlotStoryProcessRecorder:Record_EffectScene(...)
  local params = {
    ...
  }
  if params[1] then
    if not self.pendingRestoreOp[self.Type.EffectScene] then
      self.pendingRestoreOp[self.Type.EffectScene] = {}
    end
    TableUtility.ArrayPushBack(self.pendingRestoreOp[self.Type.EffectScene], params)
  end
end

function PlotStoryProcessRecorder:Record_ShakeScreen(...)
  self.pendingRestoreOp[self.Type.ShakeScreen] = 1
end

function PlotStoryProcessRecorder:Record_EffectFullScreen(...)
  self.pendingRestoreOp[self.Type.EffectFullScreen] = 1
end

function PlotStoryProcessRecorder:Record_EffectUI(...)
  local params = {
    ...
  }
  if params[2] then
    if not self.pendingRestoreOp[self.Type.EffectUI] then
      self.pendingRestoreOp[self.Type.EffectUI] = {}
    end
    TableUtility.ArrayPushBack(self.pendingRestoreOp[self.Type.EffectUI], params)
  end
end

function PlotStoryProcessRecorder:Record_Sound(...)
  local params = {
    ...
  }
  if 1 < #params then
    if not self.pendingRestoreOp[self.Type.Sound] then
      self.pendingRestoreOp[self.Type.Sound] = {}
    end
    TableUtility.ArrayPushBack(self.pendingRestoreOp[self.Type.Sound], params)
  end
end

function PlotStoryProcessRecorder:Record_Bgm(...)
  self.pendingRestoreOp[self.Type.Bgm] = 1
end

function PlotStoryProcessRecorder:Record_SceneFilter(...)
  local params = {
    ...
  }
  local isEnable = params[2]
  if params[1] and isEnable ~= nil then
    if not self.pendingRestoreOp[self.Type.SceneFilter] then
      self.pendingRestoreOp[self.Type.SceneFilter] = {}
    end
    local info = self.pendingRestoreOp[self.Type.SceneFilter]
    local filter = params[1].fliter or params[1].filter
    if type(filter) == "number" then
      if isEnable then
        if TableUtility.ArrayFindIndex(info, filter) == 0 then
          TableUtility.ArrayPushBack(info, filter)
        end
      else
        TableUtility.ArrayRemove(info, filter)
      end
    elseif type(filter) == "table" then
      local f
      for i = 1, #filter do
        f = filter[i]
        if isEnable then
          if TableUtility.ArrayFindIndex(info, f) == 0 then
            TableUtility.ArrayPushBack(info, f)
          end
        else
          TableUtility.ArrayRemove(info, f)
        end
      end
    end
    if params[1].isApplyDefault then
      info.isApplyDefault = true
    end
  end
end

function PlotStoryProcessRecorder:Record_MapAnime(...)
  local params = {
    ...
  }
  if params[1] then
    if not self.pendingRestoreOp[self.Type.MapAnime] then
      self.pendingRestoreOp[self.Type.MapAnime] = {}
    end
    local info = self.pendingRestoreOp[self.Type.MapAnime]
    local curState = Game.GameObjectManagers[Game.GameObjectType.SceneBossAnime] and Game.GameObjectManagers[Game.GameObjectType.SceneBossAnime].GetCurAnimState and Game.GameObjectManagers[Game.GameObjectType.SceneBossAnime]:GetCurAnimState(params[1].objID)
    if curState then
      info[params[1].objID] = curState
    end
  end
end

function PlotStoryProcessRecorder:Record_Sky(...)
  if not self.pendingRestoreOp[self.Type.Sky] then
    self.pendingRestoreOp[self.Type.Sky] = Game.EnviromentManager:GetBaseID()
  end
end

function PlotStoryProcessRecorder:Record_Weather(...)
  self.pendingRestoreOp[self.Type.Weather] = 1
end

function PlotStoryProcessRecorder:Record_ManualMove(...)
  local params = {
    ...
  }
  local record = self.pendingRestoreOp[self.Type.ManualMove]
  if not record then
    record = {}
    self.pendingRestoreOp[self.Type.ManualMove] = record
  end
  for i = 2, #params do
    record[#record + 1] = params[i]
  end
end

function PlotStoryProcessRecorder:Restore_MoveSpd(info)
  local target
  for k, v in pairs(info) do
    target = SceneCreatureProxy.FindCreature(k)
    if target and target.assetRole then
      local moveSpdProp = target.data.props:GetPropByName("MoveSpd")
      moveSpdProp:SetValue(v * 1000)
      target:Client_SetMoveSpeed(moveSpdProp:GetValue())
    end
  end
end

function PlotStoryProcessRecorder:Restore_MoveActionSpd(info)
  for k, v in pairs(info) do
    local target = SceneCreatureProxy.FindCreature(k)
    if target then
      target:Logic_SetMoveActionSpeed(v)
    end
  end
end

function PlotStoryProcessRecorder:Restore_Action(info)
  for k = 1, #info do
    local params = info[k][1]
    local targets = self.currentProcess._getTargetByParams(self.currentProcess, params)
    for i = 1, #targets do
      local target = targets[i]
      if target == Game.Myself then
        target:Client_PlayAction(target:GetIdleAction())
      else
        target:Server_PlayActionCmd(target:GetIdleAction())
      end
    end
  end
end

function PlotStoryProcessRecorder:Restore_Emoji(info)
  for k = 1, #info do
    local params = info[k][1]
    local targets = self.currentProcess._getTargetByParams(self.currentProcess, params)
    for i = 1, #targets do
      local target = targets[i]
      local sceneUI = target:GetSceneUI()
      if sceneUI then
        sceneUI.roleTopUI:DestroySpine()
      end
    end
  end
end

function PlotStoryProcessRecorder:Restore_Expression(info)
  local target
  for k, v in pairs(info) do
    target = SceneCreatureProxy.FindCreature(k)
    if target and target.assetRole then
      target.assetRole:SetExpression(v)
    end
  end
end

function PlotStoryProcessRecorder:Restore_ChangePart(info)
  local rolePartArray, partnerInvisible, petInvisible, target
  for k, _ in pairs(info) do
    rolePartArray = info[k].Parts
    partnerInvisible = info[k].PartnerInvisible
    petInvisible = info[k].PetInvisible
    target = SceneCreatureProxy.FindCreature(k)
    if target then
      target.assetRole:Redress(rolePartArray)
      if partnerInvisible then
        target:SetPartnerVisible(true, PlotStoryProcess.ChangePartInvisibleReason)
      end
      if petInvisible then
        local npet = PetProxy.Instance:GetMySceneNpet()
        if npet then
          npet:SetVisible(true, PlotStoryProcess.ChangePartInvisibleReason)
        end
      end
    end
    Asset_Role.DestroyPartArray(rolePartArray)
  end
end

function PlotStoryProcessRecorder:Restore_Effect(info)
  for k = 1, #info do
    local params = info[k][1]
    local path = params.path
    local ep = params.ep or 0
    local targets = self.currentProcess._getTargetByParams(self.currentProcess, params)
    for i = 1, #targets do
      local target = targets[i]
      if target then
        target:RemoveEffect(ep .. path)
      end
    end
  end
end

function PlotStoryProcessRecorder:Restore_EffectScene(info)
  for k = 1, #info do
    local effectid = info[k][2]
    local oneShot_assetEffect = info[k][3]
    local oneShot_assetEffect_guid_ts = info[k][4]
    if oneShot_assetEffect and oneShot_assetEffect.guid_ts == oneShot_assetEffect_guid_ts then
      oneShot_assetEffect:Stop()
    elseif effectid then
      NSceneEffectProxy.Instance:Client_RemoveSceneEffect(effectid)
    end
  end
end

function PlotStoryProcessRecorder:Restore_ShakeScreen(info)
  if info == 1 then
    CameraAdditiveEffectManager.Me():ForceEndShake()
  end
end

function PlotStoryProcessRecorder:Restore_EffectFullScreen(info)
  if info == 1 then
    EventManager.Me():DispatchEvent(UIEvent.RemoveFullScreenEffect)
    GameFacade.Instance:sendNotification(UIEvent.RemoveFullScreenEffect)
  end
end

function PlotStoryProcessRecorder:Restore_EffectUI(info)
  local _info
  for k = 1, #info do
    if info[k] then
      _info = info[k]
      if _info[2] and _info[3] and _info[2].guid_ts == _info[3] then
        _info[2]:Stop()
      end
    end
  end
end

function PlotStoryProcessRecorder:Restore_Sound(info)
  for k = 1, #info do
    local params = info[k]
    local manage_info = params[2]
    local oneShotAudioManageList = manage_info.oneShotAudioManageList
    local loopAudioId = manage_info.loopAudioId
    local oneShot2DAudioPlay = manage_info.oneShot2DAudioPlay
    if oneShotAudioManageList and 0 < #oneShotAudioManageList then
      for i = 1, #oneShotAudioManageList do
        local obj = oneShotAudioManageList[i]
        if not Game.GameObjectUtil:ObjectIsNULL(obj) then
          obj:Destroy()
        end
      end
    end
    if loopAudioId then
      NSceneEffectProxy.Instance:RemoveAudio(loopAudioId)
    end
    if not Game.GameObjectUtil:ObjectIsNULL(oneShot2DAudioPlay) then
      AudioUtility.StopOneShot2D_Clip(oneShot2DAudioPlay)
    end
  end
end

function PlotStoryProcessRecorder:Restore_Bgm(info)
  if info == 1 and not FunctionBGMCmd.Me():IsDefaultBGM() then
    FunctionBGMCmd.Me():StopMissionBgm()
  end
end

function PlotStoryProcessRecorder:Restore_SceneFilter(info)
  for i = 1, #info do
    FunctionSceneFilter.Me():EndFilter(info[i])
  end
  if info.isApplyDefault then
    FunctionSceneFilter.Me():SetApplyDefaultSceneFilterId(nil)
  end
  TableUtility.ArrayClear(info)
end

function PlotStoryProcessRecorder:Restore_MapAnime(info)
  for k, v in pairs(info) do
    Game.GameObjectManagers[Game.GameObjectType.SceneBossAnime]:ExplicitlyPlaySceneAnime(k, v, 1)
  end
end

function PlotStoryProcessRecorder:Restore_Sky(info)
  if info then
    Game.MapManager:SetEnviroment(info)
  end
end

function PlotStoryProcessRecorder:Restore_Weather(info)
  if info == 1 then
    Game.PlotStoryManager:RestoreToServerWeather()
  end
end

function PlotStoryProcessRecorder:Restore_ManualMove(info)
  local target = info and info[1]
  if target then
    local moveSpd = info[2]
    local moveActionSpd = info[3]
    local moveActionName = info[4]
    target:Client_SetMoveSpeed(moveSpd)
    target:Logic_SetMoveActionSpeed(moveActionSpd)
    target:Client_SetMoveToCustomActionName(moveActionName)
  end
  self.pendingRestoreOp[self.Type.ManualMove] = nil
end
