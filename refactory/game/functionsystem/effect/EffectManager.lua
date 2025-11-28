EffectManager = class("EffectManager")
EffectManager.AutoDestroyMaxCount = 500
local TableClear = TableUtility.TableClear
local EffectTypes = {
  E_Cast = 1,
  E_Attack = 2,
  E_Fire = 3,
  E_Hit = 4,
  E_Miss = 5,
  E_CastLock = 6,
  LP_Effect = 7,
  LP_Point_Effect = 8,
  LP_Reading_Effect = 9,
  LP_Main_Hit_Effect = 10,
  LP_Treatment_Hit_Effect = 11,
  LP_Trap_Effect = 12,
  LP_Pre_Attack_Effect = 13
}
EffectManager.EffectTypes = EffectTypes
EffectManager.FilterType = {All = 1}
EffectManager.EffectType = {Loop = 1, OneShot = 2}
local EffectLimitConfig = GameConfig.EffectLimitConfig or {
  [1] = {
    MaxS = 80,
    MaxA = 60,
    MaxB = 40,
    MaxMapS = 80,
    MaxMapA = 40,
    MaxMapB = 20
  },
  [2] = {
    MaxS = 60,
    MaxA = 40,
    MaxB = 20,
    MaxMapS = 60,
    MaxMapA = 30,
    MaxMapB = 10
  },
  [3] = {
    MaxS = 40,
    MaxA = 20,
    MaxB = 10,
    MaxMapS = 40,
    MaxMapA = 20,
    MaxMapB = 5
  }
}
local SpecSkillEffectLimit = GameConfig.SpecSkillEffectLimit or {}
local MaxS = EffectLimitConfig[1].MaxS
local MaxA = EffectLimitConfig[1].MaxA
local MaxB = EffectLimitConfig[1].MaxB
local MaxMapS = EffectLimitConfig[1].MaxMapS
local MaxMapA = EffectLimitConfig[1].MaxMapA
local MaxMapB = EffectLimitConfig[1].MaxMapB
local EffectLodLevel = 0

function EffectManager.SetEffectLodLevel(lodLevel)
  if lodLevel < 0 then
    lodLevel = 0
  elseif 2 < lodLevel then
    lodLevel = 2
  end
  local config = EffectLimitConfig[lodLevel + 1]
  MaxS = config.MaxS
  MaxA = config.MaxA
  MaxB = config.MaxB
  MaxMapS = config.MaxMapS
  MaxMapA = config.MaxMapA
  MaxMapB = config.MaxMapB
  EffectLodLevel = lodLevel
end

function EffectManager:ctor()
  self.effect_list = {}
  self.effects = {}
  self.autoDestroyEffects = {}
  self.isFilter = false
  self.effectStat = {}
  self.skillNpcs = {}
end

function EffectManager:Filter(filterType)
  self.isFilter = true
  for k, autoDestroyEffect in pairs(self.autoDestroyEffects) do
    self.autoDestroyEffects[k] = nil
    autoDestroyEffect:Stop()
  end
  for k, effect in pairs(self.effects) do
    effect:SetActive(false, Asset_Effect.DeActiveOpt.Filter)
  end
end

function EffectManager:UnFilter(filterType)
  self.isFilter = false
  for k, effect in pairs(self.effects) do
    effect:SetActive(true, Asset_Effect.DeActiveOpt.Filter)
  end
end

function EffectManager:IsFiltered()
  return self.isFilter
end

function EffectManager:RegisterEffect(effect, autoDestroy)
  if effect == nil then
    return
  end
  if self.effects[effect.id] == nil and self.autoDestroyEffects[effect.id] == nil then
    local priority = effect:GetPriority()
    if priority and 0 <= priority then
      local path = effect.args[1]
      if path then
        self:ChangeEffectCount(path, 1, effect:IsMapEffect(), effect:GetLodLevel())
      end
    end
  end
  if autoDestroy then
    self.effects[effect.id] = nil
    self.autoDestroyEffects[effect.id] = effect
    if #self.effect_list > EffectManager.AutoDestroyMaxCount then
      local id = self.effect_list[1]
      local effect = self.autoDestroyEffects[id]
      if effect ~= nil then
        effect:Destroy()
      end
    end
    self:AddOrUpdateEffectIdToList(effect.id)
  else
    self.effects[effect.id] = effect
  end
end

function EffectManager:AddOrUpdateEffectIdToList(id)
  for i = #self.effect_list, 1, -1 do
    if id == self.effect_list[i] then
      table.remove(self.effect_list, i)
      break
    end
  end
  table.insert(self.effect_list, id)
end

function EffectManager:RemoveEffectIdInList(id)
  for i = #self.effect_list, 1, -1 do
    if id == self.effect_list[i] then
      return table.remove(self.effect_list, i), i
    end
  end
  return nil
end

function EffectManager:UnRegisterEffect(effect)
  if effect ~= nil then
    if self.effects[effect.id] ~= nil or self.autoDestroyEffects[effect.id] ~= nil then
      local priority = effect:GetPriority()
      if priority and 0 <= priority then
        local path = effect.args[1]
        if path then
          self:ChangeEffectCount(path, -1, effect:IsMapEffect(), effect:GetLodLevel())
        end
      end
    end
    self.effects[effect.id] = nil
    if self.autoDestroyEffects[effect.id] then
      self:RemoveEffectIdInList(effect.id)
    end
    self.autoDestroyEffects[effect.id] = nil
  end
end

function EffectManager:ClearAllStat()
  TableClear(self.effectStat)
  TableClear(self.skillNpcs)
end

function EffectManager:GetEffectCount(name)
  return self.effectStat[name] or 0
end

function EffectManager:ChangeEffectCountInner(key, val)
  local newVal = self:GetEffectCount(key) + val
  if newVal <= 0 then
    newVal = nil
  end
  self.effectStat[key] = newVal
end

function EffectManager:ChangeEffectCount(name, val, isMapEffect, lodLevel)
  self:ChangeEffectCountInner(name, val)
  if isMapEffect then
    self:ChangeTotalMapEffectCount(val)
    if lodLevel and lodLevel < 2 then
      self:ChangeTotalHQMapEffectCount(val)
    end
  else
    self:ChangeTotalEffectCount(val)
    if lodLevel and lodLevel < 2 then
      self:ChangeTotalHQEffectCount(val)
    end
  end
end

function EffectManager:GetTotalEffectCount()
  return self.effectStat.TOTAL_EFFECT or 0
end

function EffectManager:ChangeTotalEffectCount(val)
  self:ChangeEffectCountInner("TOTAL_EFFECT", val)
end

function EffectManager:GetTotalHQEffectCount()
  return self.effectStat.TOTAL_HQ_EFFECT or 0
end

function EffectManager:ChangeTotalHQEffectCount(val)
  self:ChangeEffectCountInner("TOTAL_HQ_EFFECT", val)
end

function EffectManager:ClearEffectCount(path)
  self.effectStat[path] = nil
end

function EffectManager:GetTotalMapEffectCount()
  return self.effectStat.TOTAL_MAP_EFFECT or 0
end

function EffectManager:ChangeTotalMapEffectCount(val)
  self:ChangeEffectCountInner("TOTAL_MAP_EFFECT", val)
end

function EffectManager:GetTotalHQMapEffectCount()
  return self.effectStat.TOTAL_HQ_MAP_EFFECT or 0
end

function EffectManager:ChangeTotalHQMapEffectCount(val)
  self:ChangeEffectCountInner("TOTAL_HQ_MAP_EFFECT", val)
end

local Effect_TempScale = 1
local Effect_ScalePattern = "(%[s%]([%d%.]+)%[/s%])"
local F_ScalePattern = function(s1, s2)
  if s2 then
    Effect_TempScale = tonumber(s2) or 1
  else
    Effect_TempScale = 1
  end
  return ""
end

function EffectManager:GetEffectPath(paths, priority, effectType)
  if not paths then
    return nil, -1
  end
  local lodLevel = self:GetLodLevel(priority, effectType)
  if lodLevel < 0 then
    return nil, lodLevel
  end
  local effectPath = paths[lodLevel + 1]
  if effectPath then
    local singleLimit = SpecSkillEffectLimit[effectPath]
    local curCount = self:GetEffectCount(effectPath)
    if singleLimit ~= nil and singleLimit < curCount then
      return nil, -1
    end
  end
  Effect_TempScale = 1
  effectPath = effectPath and effectPath:gsub(Effect_ScalePattern, F_ScalePattern)
  effectPath = effectPath or paths[1]
  return effectPath, lodLevel, Effect_TempScale
end

function EffectManager:GetLodLevel(priority, effectType)
  local lodLevel = EffectLodLevel
  local isMapEffect = effectType == Asset_Effect.EffectTypes.Map and true or false
  if not priority or priority < 0 then
    return lodLevel
  end
  if priority == 0 then
    return lodLevel
  end
  local totalHQEffectCount = isMapEffect and self:GetTotalHQMapEffectCount() or self:GetTotalHQEffectCount()
  local totalEffectCount = isMapEffect and self:GetTotalMapEffectCount() or self:GetTotalEffectCount()
  if priority == 1 then
    local maxS = isMapEffect and MaxMapS or MaxS
    if totalEffectCount >= maxS then
      return -1
    else
      local maxA = isMapEffect and MaxMapA or MaxA
      if totalHQEffectCount >= maxA then
        lodLevel = 2
      end
    end
  else
    local maxA = isMapEffect and MaxMapA or MaxA
    if totalEffectCount >= maxA then
      return -1
    else
      local maxB = isMapEffect and MaxMapB or MaxB
      if totalHQEffectCount >= maxB then
        lodLevel = 2
      end
    end
  end
  return lodLevel
end

function EffectManager:RegisterNpc(npc)
  if not npc or not npc.data then
    return
  end
  local npcId = npc.data.id
  if not npcId then
    return
  end
  if not self.skillNpcs[npcId] then
    self.skillNpcs[npcId] = 1
    self:ChangeEffectCount(npcId, 1, true, EffectLodLevel)
  end
end

function EffectManager:UnregisterNpc(npc)
  if not npc or not npc.data then
    return
  end
  local npcId = npc.data.id
  if not npcId then
    return
  end
  if self.skillNpcs[npcId] then
    self.skillNpcs[npcId] = nil
    self:ChangeEffectCount(npcId, -1, true, EffectLodLevel)
  end
end

function EffectManager:GetNpcLevel(priority)
  local lodLevel = self:GetLodLevel(priority, Asset_Effect.EffectTypes.Map)
  return 0 <= lodLevel and true or false
end

function EffectManager:PrintEffectCount()
  for k, v in pairs(self.effectStat) do
    redlog("[effect]", k, v)
  end
end
