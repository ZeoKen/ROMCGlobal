AreaTrigger_Buff = reusableClass("AreaTrigger_Buff")
local UpdateInterval = 1
local DistanceXZ_Square = VectorUtility.DistanceXZ_Square
local IgnoreRange = -1
AreaTrigger_Buff.SeeHide = 1

function AreaTrigger_Buff:DoConstruct(asArray, data)
  self.nextUpdateTime = 0
  self.checks = {}
  self.checkLaunchCall = {}
  self.checkLaunchCall[AreaTrigger_Buff.SeeHide] = self.LaunchSeeHide
  self.checkShutdownCall = {}
  self.checkShutdownCall[AreaTrigger_Buff.SeeHide] = self.ShutdownSeeHide
  self.triggers = {}
  self.triggerEnterCall = {}
  self.triggerEnterCall[AreaTrigger_Buff.SeeHide] = self.EnterSeeHide
  self.triggerExitCall = {}
  self.triggerExitCall[AreaTrigger_Buff.SeeHide] = self.ExitSeeHide
  self.triggerRemoveCall = {}
  self:CreateWeakData()
end

function AreaTrigger_Buff:Launch()
  if self.running then
    return
  end
  self.running = true
end

function AreaTrigger_Buff:Shutdown()
  if not self.running then
    return
  end
  self.running = false
  self:Clear()
end

function AreaTrigger_Buff:Update(time, deltaTime)
  if not self.running then
    return
  end
  if time < self.nextUpdateTime then
    return
  end
  self.nextUpdateTime = time + UpdateInterval
  local trigger, creature
  for k, v in pairs(self.checks) do
    trigger = self.triggers[k]
    if trigger ~= nil then
      local myselfPosition = Game.Myself:GetPosition()
      for key, value in pairs(trigger) do
        creature = SceneCreatureProxy.FindCreature(key)
        if creature ~= nil then
          if v == IgnoreRange or DistanceXZ_Square(myselfPosition, creature:GetPosition()) <= v * v then
            self:EnterArea(k, key, value, creature)
          else
            self:ExitArea(k, key, value, creature)
          end
        end
      end
    end
  end
end

function AreaTrigger_Buff:EnterArea(type, id, reached, creature)
  if reached then
    return
  end
  local trigger = self.triggers[type]
  if trigger == nil then
    return
  end
  trigger[id] = true
  local call = self.triggerEnterCall[type]
  if call ~= nil then
    call(self, creature)
  end
end

function AreaTrigger_Buff:ExitArea(type, id, reached, creature)
  if not reached then
    return
  end
  local trigger = self.triggers[type]
  if trigger == nil then
    return
  end
  trigger[id] = false
  local call = self.triggerExitCall[type]
  if call ~= nil then
    call(self, creature)
  end
end

function AreaTrigger_Buff:LaunchCheck(type)
  local call = self.checkLaunchCall[type]
  if call ~= nil then
    call(self)
  end
end

function AreaTrigger_Buff:ShutdownCheck(type)
  local call = self.checkShutdownCall[type]
  if call ~= nil and call(self) then
    self:ClearTriggers(type)
  end
end

function AreaTrigger_Buff:AddTrigger(type, id)
  local trigger = self.triggers[type]
  if trigger == nil then
    trigger = {}
    self.triggers[type] = trigger
  end
  trigger[id] = false
end

function AreaTrigger_Buff:RemoveTrigger(type, id)
  local trigger = self.triggers[type]
  if trigger == nil then
    return
  end
  trigger[id] = nil
end

function AreaTrigger_Buff:ClearTriggers(type)
  local trigger = self.triggers[type]
  if trigger == nil then
    return
  end
  for k, v in pairs(trigger) do
    creature = SceneCreatureProxy.FindCreature(k)
    if creature ~= nil then
      self:ExitArea(type, k, v, creature)
    end
  end
end

function AreaTrigger_Buff:ClearTrigger(id)
  for k, v in pairs(self.triggers) do
    v[id] = nil
  end
end

function AreaTrigger_Buff:Clear()
  local _TableClear = TableUtility.TableClear
  _TableClear(self.triggers)
end

function AreaTrigger_Buff:LaunchSeeHide()
  if Game.MapManager:IsPVPRaidMode() then
    return
  end
  local range = self:GetSeeHideMaxRange()
  self.checks[AreaTrigger_Buff.SeeHide] = range ~= nil and range or nil
end

function AreaTrigger_Buff:ShutdownSeeHide()
  local range = self:GetSeeHideMaxRange()
  local value = range ~= nil and range or nil
  self.checks[AreaTrigger_Buff.SeeHide] = value
  return value == nil
end

function AreaTrigger_Buff:EnterSeeHide(creature)
  local hideValue = creature.data.props:GetPropByName("Hiding"):GetValue()
  if hideValue == 2 then
    return
  end
  creature:Show()
end

function AreaTrigger_Buff:ExitSeeHide(creature)
  creature:Hide()
end

function AreaTrigger_Buff:GetSeeHideMaxRange()
  local myself = Game.Myself
  local list = myself.data:GetBuffActiveListByType(BuffType.SeeHide)
  if list == nil then
    return nil
  end
  local data, range
  local maxRange = 0
  for i = 1, #list do
    data = Table_Buffer[list[i]]
    if data ~= nil then
      if data.BuffEffect.nine == 1 then
        return IgnoreRange
      else
        range = self:GetSeeHideRange(myself, data.BuffEffect)
        if range ~= nil and maxRange < range then
          maxRange = range
        end
      end
    end
  end
  return maxRange
end

function AreaTrigger_Buff:GetSeeHideRange(creature, buffeffect)
  local range = buffeffect.range
  local rangetype = type(range)
  if rangetype == "number" then
    return range
  end
  if rangetype == "table" then
    local data = creature.data
    local level = creature:GetBuffLevel()
    return CommonFun.calcBuffValue(data, data, range.type, range.a, range.b, range.c, range.d, level, 0)
  end
  return nil
end
