local effectDeleter = function(effect)
  effect:Destroy()
end
local vec3 = LuaVector3.Zero()
autoImport("EventDispatcher")
FunctionEndlessBattleField = class("FunctionEndlessBattleField")

function FunctionEndlessBattleField.Me()
  if nil == FunctionEndlessBattleField.me then
    FunctionEndlessBattleField.me = FunctionEndlessBattleField.new()
  end
  return FunctionEndlessBattleField.me
end

local FunctionEvent = class("FunctionEvent")

function FunctionEvent:ctor()
end

function FunctionEvent:OnEventStart(data)
end

function FunctionEvent:OnEventEnd(data)
end

function FunctionEvent:OnEventAreaEnter(data)
end

function FunctionEvent:OnEventAreaLeave(data)
end

function FunctionEvent:OnEventAreaRemove(data)
end

function FunctionEvent:Shutdown()
end

local FunctionCoin = class("FunctionCoin", FunctionEvent)

function FunctionCoin:ctor()
  self.users = {}
end

function FunctionCoin:OnEventAreaEnter(eventData)
end

function FunctionCoin:OnEventAreaLeave(eventData)
end

function FunctionCoin:OnEventAreaRemove(eventData)
end

function FunctionCoin:OnEventStart(eventData)
  EventManager.Me():AddEventListener(PlayerEvent.AddBuffDropItem, self.OnBuffChange, self)
  EventManager.Me():AddEventListener(PlayerEvent.RemoveBuffDropItem, self.OnBuffRemove, self)
  EventManager.Me():AddEventListener(PlayerEvent.UpdateBuffDropItem, self.OnBuffChange, self)
  TableUtility.TableClear(self.users)
end

function FunctionCoin:OnEventEnd(eventData)
  EventManager.Me():RemoveEventListener(PlayerEvent.AddBuffDropItem, self.OnBuffChange, self)
  EventManager.Me():RemoveEventListener(PlayerEvent.RemoveBuffDropItem, self.OnBuffRemove, self)
  EventManager.Me():RemoveEventListener(PlayerEvent.UpdateBuffDropItem, self.OnBuffChange, self)
  TableUtility.TableClearByDeleter(self.users, function(v)
    local coinBuff = GameConfig.EndlessBattleField and GameConfig.EndlessBattleField.CoinBuff
    local ncreature = NSceneUserProxy.Instance:Find(v)
    if ncreature then
      local roleTopUI = ncreature:GetSceneUI().roleTopUI
      if roleTopUI then
        roleTopUI:RemoveEBFCoinSceneUI()
      end
    end
  end)
end

function FunctionCoin:Shutdown()
end

function FunctionCoin:OnBuffChange(param)
  local ncreatureId, buffId, layer = param[1], param[2], param[3]
  local coinBuff = GameConfig.EndlessBattleField and GameConfig.EndlessBattleField.CoinBuff
  if buffId == coinBuff then
    local ncreature = NSceneUserProxy.Instance:Find(ncreatureId)
    ncreature = ncreature or NSceneNpcProxy.Instance:Find(ncreatureId)
    if ncreature then
      local layer = layer or ncreature:GetBuffLayer(buffId)
      if layer then
        local roleTopUI = ncreature:GetSceneUI().roleTopUI
        if roleTopUI then
          roleTopUI:UpdateEBFCoinSceneUI(layer)
        end
        self.users[ncreatureId] = ncreatureId
      end
    end
  end
end

function FunctionCoin:OnBuffRemove(param)
  local ncreatureId, buffId = param[1], param[2]
  local coinBuff = GameConfig.EndlessBattleField and GameConfig.EndlessBattleField.CoinBuff
  if buffId == coinBuff then
    local ncreature = NSceneUserProxy.Instance:Find(ncreatureId)
    ncreature = ncreature or NSceneNpcProxy.Instance:Find(ncreatureId)
    if ncreature then
      local roleTopUI = ncreature:GetSceneUI().roleTopUI
      if roleTopUI then
        roleTopUI:RemoveEBFCoinSceneUI()
      end
      self.users[ncreatureId] = nil
    end
  end
end

local FunctionOccupy = class("FunctionOccupy", FunctionEvent)

function FunctionOccupy:ctor()
  self.triggleType = AreaTrigger_Common_ClientType.EndlessBattleField_Occupy
  self.pointTriggle = {}
  self.progressEffectMap = {}
  self.occupyEffectMap = {}
  self.successEffectMap = {}
  EventManager.Me():AddEventListener(EndlessBattleFieldEvent.PointUpdate, self.OccupyPointUpdate, self)
  EventManager.Me():AddEventListener(PVPEvent.EndlessBattleField_Event_PointOccypied, self.HandlePointOccupied, self)
end

function FunctionOccupy:OnEventStart(event_data)
  EndlessBattleDebug("[无尽战场] 祭坛事件开启")
  self:AddTriggle(event_data)
end

function FunctionOccupy:OnEventEnd(event_data)
  local static_point = event_data and event_data.staticData and event_data.staticData.Misc.occupy_points
  if not static_point then
    return
  end
  EndlessBattleDebug("[无尽战场] 祭坛事件结束")
  local triggleProxy = SceneTriggerProxy.Instance
  for id, _ in pairs(static_point) do
    triggleProxy:Remove(id)
    self.pointTriggle[id] = nil
    self:RemoveOccupyEffect(id)
    self:RemoveProgressEffect(id)
  end
end

function FunctionOccupy:OccupyPointUpdate(point_data)
  EndlessBattleDebug("[无尽战场] 祭坛据点更新")
  EndlessBattleDebugAll(point_data)
  self:SetOccupyEffect(point_data)
  self:SetProgressEffect(point_data)
end

function FunctionOccupy:HandlePointOccupied(pd)
  local id = pd and pd.id
  if not id then
    return
  end
  local effect = self.successEffectMap[id]
  if nil == effect then
    effect = self:AddSuccessEffect(pd)
    self.successEffectMap[id] = effect
  else
    local pos = pd:GetOccupyEffectPos()
    LuaVector3.Better_Set(vec3, pos[1], pos[2], pos[3])
    effect:ResetLocalPosition(vec3)
  end
  EndlessBattleDebug("[无尽战场] 加载祭坛成功特效")
end

function FunctionOccupy:AddSuccessEffect(point_data)
  local id = point_data and point_data.id
  if not id then
    return
  end
  local path = point_data:GetOccupySuccessEffect()
  if not path then
    return
  end
  local pos = point_data:GetOccupyEffectPos()
  LuaVector3.Better_Set(vec3, pos[1], pos[2], pos[3])
  EndlessBattleDebug("[无尽战场] 加载祭坛据点占领成功特效 据点id", id)
  return Asset_Effect.PlayAt(path, vec3)
end

function FunctionOccupy:Shutdown()
  EventManager.Me():RemoveEventListener(EndlessBattleFieldEvent.PointUpdate, self.OccupyPointUpdate, self)
  self:ClearTriggle()
  self:ClearEffect()
  EndlessBattleDebug("[无尽战场] 副本关闭清除祭坛相关")
end

function FunctionOccupy:ClearEffect()
  self:ClearOccupyEffect()
  self:ClearProgressEffect()
  self:ClearSuccessEffect()
end

function FunctionOccupy:OnEnterCalm()
  self:ClearTriggle()
  self:ClearEffect()
end

function FunctionOccupy:AddTriggle(event_data)
  local static_point = event_data and event_data.staticData and event_data.staticData.Misc.occupy_points
  if not static_point then
    return
  end
  local triggleProxy = SceneTriggerProxy.Instance
  for pointID, pointData in pairs(static_point) do
    local data = ReusableTable.CreateTable()
    data.id = pointID
    data.pos = pointData.center
    data.range = pointData.range
    data.type = self.triggleType
    EndlessBattleDebug("[无尽战场] 祭坛增加据点触发点", pointID)
    triggleProxy:Add(data)
    self.pointTriggle[pointID] = 1
    ReusableTable.DestroyTable(data)
  end
end

function FunctionOccupy:ClearTriggle()
  local triggleProxy = SceneTriggerProxy.Instance
  for id, _ in pairs(self.pointTriggle) do
    triggleProxy:Remove(id)
    EndlessBattleDebug("[无尽战场] 祭坛清除据点触发点", id)
  end
  TableUtility.TableClear(self.pointTriggle)
end

function FunctionOccupy:SetOccupyEffect(pd)
  local id = pd and pd.id
  if not id then
    return
  end
  local effect = self.occupyEffectMap[id]
  if nil == effect then
    effect = self:AddOccupyEffect(pd)
    self.occupyEffectMap[id] = effect
  else
    local path = pd:GetOccupyEffectPath()
    if effect:GetPath() ~= path then
      effect:Destroy()
      effect = self:AddOccupyEffect(pd)
      self.occupyEffectMap[id] = effect
    end
  end
end

function FunctionOccupy:AddOccupyEffect(point_data)
  local id = point_data and point_data.id
  if not id then
    return
  end
  local path = point_data:GetOccupyEffectPath()
  if not path then
    EndlessBattleDebug("[无尽战场] 祭坛添加据点占领特效失败")
    return
  end
  local pos = point_data:GetOccupyEffectPos()
  LuaVector3.Better_Set(vec3, pos[1], pos[2], pos[3])
  EndlessBattleDebug("[无尽战场] 祭坛增加据点占领特效，据点id|paths", id, path)
  local effect = Asset_Effect.PlayAt(path, vec3)
  local scale = point_data:GetScale()
  local rotation = point_data:GetRotation()
  effect:ResetLocalScale(scale)
  effect:ResetLocalEulerAngles(rotation)
  return effect
end

function FunctionOccupy:ClearOccupyEffect()
  TableUtility.TableClearByDeleter(self.occupyEffectMap, effectDeleter)
end

function FunctionOccupy:RemoveOccupyEffect(id)
  if self.occupyEffectMap[id] then
    self.occupyEffectMap[id]:Destroy()
    EndlessBattleDebug("[无尽战场] 祭坛移除据点特效，据点id", id)
    self.occupyEffectMap[id] = nil
  end
end

local tempVector2 = LuaVector2.New(0, 0)

function FunctionOccupy:SetProgressEffect(pd)
  local id = pd and pd.id
  if not id then
    return
  end
  local effect = self.progressEffectMap[id]
  if nil == effect then
    effect = self:AddProgressEffect(pd)
    self.progressEffectMap[id] = effect
  else
    local path = pd:GetProgressEffectPath()
    if effect:GetPath() ~= path then
      effect:Destroy()
      effect = self:AddProgressEffect(pd)
      self.progressEffectMap[id] = effect
    end
  end
  EndlessBattleDebug("[无尽战场] 祭坛特效进度", pd:GetProgress())
  tempVector2:Set(pd:GetProgress(), 0)
  self:SetEffectOffset(effect, tempVector2)
end

function FunctionOccupy:SetEffectOffset(effect, vec2)
  local parent = effect and effect.effectObj
  if parent then
    local meshRenderers = Game.GameObjectUtil:GetAllComponentsInChildren(parent, ParticleSystemRenderer, true)
    if meshRenderers then
      for i = 1, #meshRenderers do
        local material = meshRenderers[i].material
        if material:HasProperty("_MainTex") then
          material:SetTextureOffset("_MainTex", vec2)
        end
      end
    end
  end
end

function FunctionOccupy:AddProgressEffect(point_data)
  local id = point_data and point_data.id
  if not id then
    return
  end
  local path = point_data:GetProgressEffectPath()
  if not path then
    EndlessBattleDebug("[无尽战场] 加载进度特效失败")
    return
  end
  local pos = point_data:GetOccupyEffectPos()
  LuaVector3.Better_Set(vec3, pos[1], pos[2], pos[3])
  EndlessBattleDebug("[无尽战场] 祭坛增加据点进度特效，据点id|path", id, path)
  local effect = Asset_Effect.PlayAt(path, vec3)
  local scale = point_data:GetScale()
  local rotation = point_data:GetRotation()
  effect:ResetLocalScale(scale)
  effect:ResetLocalEulerAngles(rotation)
  return effect
end

function FunctionOccupy:RemoveProgressEffect(id)
  if self.progressEffectMap[id] then
    self.progressEffectMap[id]:Destroy()
    EndlessBattleDebug("[无尽战场] 祭坛移除据点进度特效，据点id", id)
    self.progressEffectMap[id] = nil
  end
end

function FunctionOccupy:ClearProgressEffect()
  TableUtility.TableClearByDeleter(self.progressEffectMap, effectDeleter)
end

function FunctionOccupy:ClearSuccessEffect()
  TableUtility.TableClearByDeleter(self.successEffectMap, effectDeleter)
end

local FunctionStatue = class("FunctionStatue", FunctionEvent)

function FunctionStatue:ctor()
  self.listenMonsterId = {}
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcs, self)
end

function FunctionStatue:OnEventStart(event_data)
  self.eventData = event_data
  local statueMap = EndlessBattleGameProxy.Instance:GetStatueData()
  for camp, statue in pairs(statueMap) do
    local statue_id = statue:GetMonsterID()
    local score = statue:GetScore()
    self.listenMonsterId[statue_id] = {score, camp}
  end
end

function FunctionStatue:OnEventEnd(event_data)
  EndlessBattleGameProxy.Instance:SetWinner(event_data.winner)
end

function FunctionStatue:Shutdown()
  TableUtility.TableClear(self.listenMonsterId)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcs, self)
end

function FunctionStatue:HandleAddNpcs(npcs)
  for i = 1, #npcs do
    local nnpc = npcs[i]
    local id = nnpc.data and nnpc.data.staticData and nnpc.data.staticData.id
    if id then
      local arg = self.listenMonsterId[id]
      if arg then
        nnpc:PlayEBStatueEffect(arg[1], arg[2])
      end
    end
  end
end

local EventTypeClass = {
  coin = FunctionCoin,
  occupy = FunctionOccupy,
  statue = FunctionStatue
}
local guide_effect_path = "Common/113TaskAperture_map"
local guide_Circle_effect_path = "Skill/sfx_sc_jfzc_round_yellow_01_prf"

function FunctionEndlessBattleField:ctor()
  self.eventHandlers = {}
  self.guideEffect = {}
  self.guideCircleEffect = {}
end

function FunctionEndlessBattleField:Launch()
  EndlessBattleDebug("[无尽战场] Func Launch")
  EventManager.Me():AddEventListener(PVPEvent.EndlessBattleField_Event_Start, self.OnEventStart, self)
  EventManager.Me():AddEventListener(PVPEvent.EndlessBattleField_Event_End, self.OnEventEnd, self)
  EventManager.Me():AddEventListener(TriggerEvent.Enter_EndlessBattleFieldEventArea, self.OnEventAreaEnter, self)
  EventManager.Me():AddEventListener(TriggerEvent.Leave_EndlessBattleFieldEventArea, self.OnEventAreaLeave, self)
  EventManager.Me():AddEventListener(TriggerEvent.Remove_EndlessBattleFieldEventArea, self.OnEventAreaRemove, self)
  EventManager.Me():AddEventListener(EndlessBattleFieldEvent.EnterCalm, self.OnEnterCalm, self)
  EventManager.Me():AddEventListener(EndlessBattleFieldEvent.PreLaunchStatue, self.AddStatueEventEffect, self)
  EventManager.Me():AddEventListener(AppStateEvent.BackToLogo, self.SettingBackToLogo, self)
end

function FunctionEndlessBattleField:SettingBackToLogo()
  self:Shutdown()
end

function FunctionEndlessBattleField:Shutdown()
  EndlessBattleDebug("[无尽战场] Func Shutdown")
  TableUtility.TableClearByDeleter(self.eventHandlers, function(v)
    v:Shutdown()
  end)
  EventManager.Me():RemoveEventListener(PVPEvent.EndlessBattleField_Event_Start, self.OnEventStart, self)
  EventManager.Me():RemoveEventListener(PVPEvent.EndlessBattleField_Event_End, self.OnEventEnd, self)
  EventManager.Me():RemoveEventListener(TriggerEvent.Enter_EndlessBattleFieldEventArea, self.OnEventAreaEnter, self)
  EventManager.Me():RemoveEventListener(TriggerEvent.Leave_EndlessBattleFieldEventArea, self.OnEventAreaLeave, self)
  EventManager.Me():RemoveEventListener(TriggerEvent.Remove_EndlessBattleFieldEventArea, self.OnEventAreaRemove, self)
  EventManager.Me():RemoveEventListener(EndlessBattleFieldEvent.EnterCalm, self.OnEnterCalm, self)
  EventManager.Me():RemoveEventListener(EndlessBattleFieldEvent.PreLaunchStatue, self.AddStatueEventEffect, self)
  EventManager.Me():RemoveEventListener(AppStateEvent.BackToLogo, self.SettingBackToLogo, self)
  self:ClearCalmCD()
  self:ClearGuideEffect()
  EndlessBattleFieldProxy.Instance:ClearEBF()
  EndlessBattleGameProxy.Instance:Reset(true)
end

function FunctionEndlessBattleField:OnEventStart(uniqueId)
  local eventData = EndlessBattleFieldProxy.Instance:GetEventDataByUniqueId(uniqueId)
  if eventData then
    local type = eventData.staticData.Type
    local handler = self.eventHandlers[type]
    if not handler then
      local funcClass = EventTypeClass[type]
      if funcClass then
        handler = funcClass.new()
        self.eventHandlers[type] = handler
      end
    end
    if handler then
      handler:OnEventStart(eventData)
    end
    local id = eventData.eventId
    if not EndlessBattleGameProxy.Instance:IsFinalEvent(id) then
      self:AddNormalEventEffect(eventData)
    else
      self:AddStatueEventEffect(id)
    end
  end
end

function FunctionEndlessBattleField:OnEventAreaEnter(uniqueId)
  local eventData = EndlessBattleFieldProxy.Instance:GetEventDataByUniqueId(uniqueId)
  if eventData then
    local type = eventData.staticData.Type
    local handler = self.eventHandlers[type]
    if handler then
      handler:OnEventAreaEnter(eventData)
    end
    ServiceFuBenCmdProxy.Instance:CallEBFEventAreaUpdateCmd(true, eventData.eventId)
    self:SetGuideEffectActive(uniqueId, eventData.eventId, false)
  end
end

function FunctionEndlessBattleField:OnEventAreaLeave(uniqueId)
  local eventData = EndlessBattleFieldProxy.Instance:GetEventDataByUniqueId(uniqueId)
  if eventData then
    local type = eventData.staticData.Type
    local handler = self.eventHandlers[type]
    if handler then
      handler:OnEventAreaLeave(eventData)
    end
    self:SetGuideEffectActive(uniqueId, eventData.eventId, true)
    ServiceFuBenCmdProxy.Instance:CallEBFEventAreaUpdateCmd(false, eventData.eventId)
  end
end

function FunctionEndlessBattleField:OnEventAreaRemove(uniqueId)
  local eventData = EndlessBattleFieldProxy.Instance:GetEventDataByUniqueId(uniqueId)
  if eventData then
    local type = eventData.staticData.Type
    local handler = self.eventHandlers[type]
    if handler then
      handler:OnEventAreaRemove(eventData)
    end
  end
end

function FunctionEndlessBattleField:OnEnterCalm()
  for _, handler in pairs(self.eventHandlers) do
    if handler.OnEnterCalm then
      handler:OnEnterCalm()
    end
  end
  self:ClearGuideEffect()
end

function FunctionEndlessBattleField:OnEventEnd(uniqueId)
  local eventData = EndlessBattleFieldProxy.Instance:GetEventDataByUniqueId(uniqueId)
  if eventData then
    local type = eventData.staticData.Type
    local handler = self.eventHandlers[type]
    if handler then
      handler:OnEventEnd(eventData)
    end
    EndlessBattleDebug("[无尽战场] 清除单次事件光柱特效及范围特效，事件uniqueID", uniqueId)
    self:RemoveGuideEffect(self.guideEffect, uniqueId)
    self:RemoveGuideEffect(self.guideCircleEffect, uniqueId)
    self:HandleBattleResult(eventData)
  end
end

function FunctionEndlessBattleField:HandleBattleResult(eventData)
  if EndlessBattleFieldProxy.Instance:IsAllSync() then
    return
  end
  if not eventData or EndlessBattleGameProxy.Instance:IsFinalEvent(eventData.eventId) then
    return
  end
  local cur_server_time = ServerTime.CurServerTime() / 1000
  if self.recvEventEndTime and cur_server_time - self.recvEventEndTime <= 3 then
    self.recvEventEndTime = cur_server_time
    GameFacade.Instance:sendNotification(PVPEvent.EndlessBattleField_MultiEvent_End, eventData)
  else
    self.recvEventEndTime = cur_server_time
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "EndlessBattleResultView",
      viewdata = {data = eventData}
    })
  end
end

function FunctionEndlessBattleField:AddCalmCD(time, parent)
  if self.cd == nil then
    autoImport("EndlessBattleCdMsg")
    self.cd = EndlessBattleCdMsg.new(parent)
  end
  self.cd:SetData("%s", {time = time, decimal = 0})
end

function FunctionEndlessBattleField:ClearCalmCD()
  if self.cd then
    self.cd:DestroySelf()
  end
  self.cd = nil
end

function FunctionEndlessBattleField:AddGuideEffect(cache_map, path, event_data, scale)
  local center = event_data and event_data.staticData and event_data.staticData.AreaCenter
  local uniqueId = event_data and event_data.uniqueId
  self:_AddGuideEffect(cache_map, path, uniqueId, center, scale)
end

function FunctionEndlessBattleField:_AddGuideEffect(cache_map, path, unique_id, center, scale)
  if not (cache_map and path and unique_id) or not center then
    return
  end
  if nil ~= cache_map[unique_id] then
    return
  end
  LuaVector3.Better_Set(vec3, center[1], center[2], center[3])
  local effect = Asset_Effect.PlayAt(path, vec3)
  if scale then
    effect:ResetLocalScale(scale)
  end
  cache_map[unique_id] = effect
end

function FunctionEndlessBattleField:AddNormalEventEffect(eventData)
  self:AddGuideEffect(self.guideEffect, guide_effect_path, eventData)
  local scale = eventData.staticData.AreaRange / 20
  local circle_scale = {
    scale,
    scale,
    scale
  }
  self:AddGuideEffect(self.guideCircleEffect, guide_Circle_effect_path, eventData, circle_scale)
end

function FunctionEndlessBattleField:AddStatueEventEffect(id)
  local staticData = id and Table_EndlessBattleFieldEvent[id]
  if not staticData then
    return
  end
  local center = staticData.AreaCenter
  self:_AddGuideEffect(self.guideEffect, guide_effect_path, id, center)
  local scale = staticData.AreaRange / 20
  local circle_scale = {
    scale,
    scale,
    scale
  }
  self:_AddGuideEffect(self.guideCircleEffect, guide_Circle_effect_path, id, center, circle_scale)
end

function FunctionEndlessBattleField:RemoveGuideEffect(cache_map, uniqueId)
  local effect = cache_map[uniqueId]
  if effect then
    effect:Destroy()
  end
  cache_map[uniqueId] = nil
end

function FunctionEndlessBattleField:SetGuideEffectActive(uniqueId, event_id, active)
  local effect = self.guideEffect[uniqueId]
  effect = effect or self.guideEffect[event_id]
  if not effect then
    return
  end
  effect:SetActive(active)
end

function FunctionEndlessBattleField:ClearGuideEffect()
  TableUtility.TableClearByDeleter(self.guideEffect, effectDeleter)
  TableUtility.TableClearByDeleter(self.guideCircleEffect, effectDeleter)
end
