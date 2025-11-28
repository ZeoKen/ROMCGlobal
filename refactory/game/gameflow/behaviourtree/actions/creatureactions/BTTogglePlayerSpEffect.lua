BTTogglePlayerSpEffect = class("BTTogglePlayerSpEffect", BTAction)
BTTogglePlayerSpEffect.TypeName = "TogglePlayerSpEffect"
BTDefine.RegisterAction(BTTogglePlayerSpEffect.TypeName, BTTogglePlayerSpEffect)

function BTTogglePlayerSpEffect:ctor(config)
  BTTogglePlayerSpEffect.super.ctor(self, config)
  self.effectId = config.effectId
  self.duration = config.duration
  self.serviceKey = config.serviceKey
  self.onBBKey = config.onBBKey
  self.offBBKey = config.offBBKey
  self.targetGuid = 0
end

function BTTogglePlayerSpEffect:Dispose()
  BTTogglePlayerSpEffect.super.Dispose(self)
end

function BTTogglePlayerSpEffect:Exec(time, deltaTime, context)
  local ret = BTTogglePlayerSpEffect.super.Exec(self, time, deltaTime, context)
  if ret ~= 0 then
    return ret
  end
  if not context then
    return 0
  end
  local bb = context.blackboard
  if not bb then
    return 0
  end
  if not bb:IsKeyDirty(self.serviceKey) then
    return 0
  end
  bb = bb[self.serviceKey]
  if not bb then
    return 0
  end
  local guids = bb[self.onBBKey]
  local tp = type(guids)
  if tp == "table" then
    for k, _ in pairs(guids) do
      self:AddSpEffect(k)
    end
  elseif tp == "integer" then
    self:AddSpEffect(guids)
  end
  guids = bb[self.offBBKey]
  tp = type(guids)
  if tp == "table" then
    for k, _ in pairs(guids) do
      self:RemoveSpEffect(k)
    end
  elseif tp == "integer" then
    self:RemoveSpEffect(guids)
  end
  return 0
end

function BTTogglePlayerSpEffect:AddSpEffect(guid)
  local creature = NSceneUserProxy.Instance:Find(guid)
  if not creature then
    return
  end
  creature:Client_AddSpEffect(self.targetGuid, self.effectId or 0, self.duration or 0)
end

function BTTogglePlayerSpEffect:RemoveSpEffect(guid)
  local creature = NSceneUserProxy.Instance:Find(guid)
  if not creature then
    return
  end
  creature:Client_RemoveSpEffect(creature:GetClientSpEffectKey(self.targetGuid, self.effectId))
end
