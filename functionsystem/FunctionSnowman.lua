FunctionSnowman = class("FunctionSnowman")

function FunctionSnowman.Me()
  if nil == FunctionSnowman.me then
    FunctionSnowman.me = FunctionSnowman.new()
  end
  return FunctionSnowman.me
end

function FunctionSnowman:ctor()
  self.triggers = {}
  self.snowmanAreaInfo = {}
  self.snowmanEffectMap = {}
  local areaInfo = Table_SnowRealmSnowman
  if areaInfo then
    for id, info in pairs(areaInfo) do
      self.snowmanAreaInfo[info.UniqueID] = info
    end
  end
end

function FunctionSnowman:Launch()
  local curMap = Game.MapManager:GetMapID()
  if curMap ~= 155 or self.isRunning then
    return
  end
  redlog("FunctionSnowman:Launch")
  self.isRunning = true
  EventManager.Me():AddEventListener(TriggerEvent.EnterSnowmanArea, self.HandleEnterSnowmanArea, self)
  EventManager.Me():AddEventListener(TriggerEvent.LeaveSnowmanArea, self.HandleLeaveSnowmanArea, self)
  EventManager.Me():AddEventListener(TriggerEvent.RemoveSnowmanArea, self.HandleRemoveSnowmanArea, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcs, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneRemoveNpcs, self.HandleRemoveNpcs, self)
  EventManager.Me():AddEventListener(ServiceEvent.MapSnowRealmSnowmanProgressCmd, self.HandleSnowRealmSnowmanProgress, self)
  self:CreateTriggers()
end

function FunctionSnowman:Shutdown()
  local curMap = Game.MapManager:GetMapID()
  if curMap ~= 155 or not self.isRunning then
    return
  end
  redlog("FunctionSnowman:Shutdown")
  self.isRunning = false
  EventManager.Me():RemoveEventListener(TriggerEvent.EnterSnowmanArea, self.HandleEnterSnowmanArea, self)
  EventManager.Me():RemoveEventListener(TriggerEvent.LeaveSnowmanArea, self.HandleLeaveSnowmanArea, self)
  EventManager.Me():RemoveEventListener(TriggerEvent.RemoveSnowmanArea, self.HandleRemoveSnowmanArea, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcs, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneRemoveNpcs, self.HandleRemoveNpcs, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.MapSnowRealmSnowmanProgressCmd, self.HandleSnowRealmSnowmanProgress, self)
  self:ClearTriggers()
  self:ClearSnowmanEffects()
end

function FunctionSnowman:HandleEnterSnowmanArea(id)
  redlog("【发送进入雪人区域协议】", id)
  ServiceMapProxy.Instance:CallSnowRealmSnowmanAreaChangeCmd(id)
end

function FunctionSnowman:HandleLeaveSnowmanArea(id)
  redlog("【发送离开雪人区域协议】", id)
  ServiceMapProxy.Instance:CallSnowRealmSnowmanAreaChangeCmd(0)
end

function FunctionSnowman:HandleRemoveSnowmanArea(id)
  TableUtility.ArrayRemove(self.triggers, id)
end

function FunctionSnowman:CreateTriggers()
  local areaInfo = Table_SnowRealmSnowman
  if areaInfo then
    for id, info in pairs(areaInfo) do
      local pos = {
        info.AreaPos[1],
        info.AreaPos[2],
        info.AreaPos[3]
      }
      local trigger = ReusableTable.CreateTable()
      trigger.id = id
      trigger.pos = pos
      trigger.range = info.AreaRange
      trigger.type = AreaTrigger_Common_ClientType.Snowman_Area
      SceneTriggerProxy.Instance:Add(trigger)
      ReusableTable.DestroyTable(trigger)
      self.triggers[#self.triggers + 1] = id
    end
  end
end

function FunctionSnowman:ClearTriggers()
  TableUtility.ArrayClearByDeleter(self.triggers, function(id)
    SceneTriggerProxy.Instance:Remove(id)
  end)
end

function FunctionSnowman:HandleAddNpcs(npcs)
  if not npcs then
    return
  end
  for i = 1, #npcs do
    local npc = npcs[i]
    local uniqueid = npc.data and npc.data.uniqueid
    if self.snowmanAreaInfo[uniqueid] then
      self:SetSnowmanProcess(npc)
    end
  end
end

function FunctionSnowman:HandleRemoveNpcs(npcs)
  if not npcs then
    return
  end
  for i = 1, #npcs do
    local guid = npcs[i]
    local npc = NSceneNpcProxy.Instance:Find(guid)
    local uniqueid = npc and npc.data and npc.data.uniqueid
    if self.snowmanEffectMap[uniqueid] then
      self:DestroySnowmanEffect(uniqueid)
    end
  end
end

function FunctionSnowman:HandleSnowRealmSnowmanProgress(data)
  redlog("FunctionSnowman:HandleSnowRealmSnowmanProgress areaId=" .. tostring(data.snowman_id), "show_vfx=" .. tostring(data.show_vfx))
  local areaId = data.snowman_id
  local config = Table_SnowRealmSnowman[areaId]
  local uniqueid = config and config.UniqueID
  local npcs = NSceneNpcProxy.Instance:FindNpcByUniqueId(uniqueid)
  if npcs then
    for i = 1, #npcs do
      local npc = npcs[i]
      if data.show_vfx then
        self:PlaySnowmanEffect(npc)
      else
        self:SetSnowmanProcess(npc)
      end
    end
  end
  if not data.show_vfx then
    local maxProgress = config and config.MaxProgress or 0
    if maxProgress <= data.progress or not data.activated then
      InteractLocalManager.Me():DestroyInteractGroup(areaId)
    end
  end
end

function FunctionSnowman:SetSnowmanProcess(creature)
  if not creature then
    return
  end
  if not creature.data then
    return
  end
  local info = self.snowmanAreaInfo[creature.data.uniqueid]
  local areaID = info and info.id
  if not areaID then
    return
  end
  local roleTopUI = creature:GetSceneUI().roleTopUI
  if roleTopUI then
    local process = SnowmanProxy.Instance:GetSnowmanProcess(areaID)
    local totalProcess = info and info.MaxProgress or 0
    roleTopUI:UpdateSnowmanProcess(process, totalProcess)
  end
end

function FunctionSnowman:PlaySnowmanEffect(creature)
  if not creature then
    return
  end
  local id = creature.data.uniqueid
  local name = GameConfig.SnowRealm and GameConfig.SnowRealm.SnowmanProgressEffect and GameConfig.SnowRealm.SnowmanProgressEffect.Name or "sfx_snowman_xuehua_prf"
  local path = EffectMap.Maps[name]
  if not path then
    return
  end
  local loopTime = GameConfig.SnowRealm and GameConfig.SnowRealm.SnowmanProgressEffect and GameConfig.SnowRealm.SnowmanProgressEffect.LoopTime or 5
  local effect = self.snowmanEffectMap[id]
  if effect then
    TimeTickManager.Me():ClearTick(self, id)
  else
    effect = Asset_Effect.PlayOn(path, creature.assetRole.completeTransform)
    self.snowmanEffectMap[id] = effect
  end
  TimeTickManager.Me():CreateOnceDelayTick(loopTime * 1000, function(owner, deltaTime)
    local effect = self.snowmanEffectMap[id]
    if effect then
      effect:Destroy()
    end
    self.snowmanEffectMap[id] = nil
    self:SetSnowmanProcess(creature)
  end, self, id)
end

function FunctionSnowman:DestroySnowmanEffect(id)
  local effect = self.snowmanEffectMap[id]
  if effect then
    effect:Destroy()
    self.snowmanEffectMap[id] = nil
  end
  TimeTickManager.Me():ClearTick(self, id)
end

function FunctionSnowman:ClearSnowmanEffects()
  TableUtility.TableClearByDeleter(self.snowmanEffectMap, function(effect)
    effect:Destroy()
  end)
  TimeTickManager.Me():ClearTick(self)
end
