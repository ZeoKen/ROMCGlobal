BuffGroup = class("BuffGroup", ReusableObject)
BuffGroup.PoolSize = 5
local CreatureHideOpt = Asset_Effect.DeActiveOpt.CreatureHide
local AroundRadius = 1
local tempVector3 = LuaVector3.Zero()
local tempVector3_1 = LuaVector3.Zero()
local tempQuaternion = LuaQuaternion.Identity()
local tempList = {}
local OnEffectCreated = function(effectHandle, self, assetEffect)
  if not self then
    if assetEffect then
      assetEffect:Destroy()
    end
    return
  end
  self.effect = assetEffect
  self:_OnEffectCreated(effectHandle)
end

function BuffGroup.Create()
  return ReusableObject.Create(BuffGroup, false)
end

function BuffGroup:RegisterBuff(creature, buff)
  self.buffCount = self.buffCount + 1
  if self.buffCount == 1 then
    self:_Start(creature, buff)
  end
  local buffID = buff.staticData.id
  if self.effect == nil or self.effect:GetEffectHandle() == nil then
    if self.waitBuffs == nil then
      self.waitBuffs = ReusableTable.CreateTable()
    end
    self.waitBuffs[buffID] = buff.config.EffectGroup_around
  else
    self:_ApplyAroundEffects(buffID, buff.config.EffectGroup_around, creature)
  end
end

function BuffGroup:UnRegisterBuff(creature, buff)
  self.buffCount = self.buffCount - 1
  if self.buffCount == 0 then
    self:_End()
  else
    local buffID = buff.staticData.id
    if self.waitBuffs ~= nil then
      self.waitBuffs[buffID] = nil
    end
    self:_ApplyAroundEffects(buffID, nil, creature)
  end
end

function BuffGroup:SetEffectVisible(visible)
  if self.visible ~= visible then
    self.visible = visible
    if self.effect ~= nil then
      self.effect:SetActive(self.visible, CreatureHideOpt)
    end
  end
end

function BuffGroup:_Start(creature, buff)
  self:_PlayEffect(creature, buff)
end

function BuffGroup:_End()
  self:_DestroyAroundEffects()
  self:_DestroyEffect()
  self:_DestroyWaitBuffs()
end

function BuffGroup:_PlayEffect(creature, buff)
  if self.effect ~= nil then
    return
  end
  if Game.HandUpManager:IsInHandingUp() then
    return
  end
  self:CreateWeakData()
  if self:GetWeakData(1) ~= nil then
    return
  end
  local effectPath, lodLevel, priority = BuffState.GetEffectPath(buff.config.EffectGroup, creature)
  if effectPath == nil then
    return
  end
  self.effect = creature.assetRole:PlayEffectOn(effectPath, buff.staticData.EP, nil, OnEffectCreated, self, nil, nil, lodLevel, priority)
  if nil ~= self.effect then
    self:SetWeakData(1, self.effect)
    if false == self.visible then
      self.effect:SetActive(self.visible, CreatureHideOpt)
    end
  end
end

function BuffGroup:_OnEffectCreated(effectHandle)
  if self.effect == nil or self.effect:GetEffectHandle() ~= effectHandle then
    return
  end
  effectHandle.transform.rotation = LuaGeometry.Const_Qua_identity
  if self.waitBuffs ~= nil then
    for k, v in pairs(self.waitBuffs) do
      self:_ApplyAroundEffects(k, v)
    end
    self:_DestroyWaitBuffs()
  end
end

function BuffGroup:_ApplyAroundEffects(buffID, effectAround, creature)
  if self.effect == nil or self.effect:GetEffectHandle() == nil then
    self:_DestroyAroundEffects()
    return
  end
  if buffID == nil then
    return
  end
  if effectAround ~= nil then
    local parent = self.effect:GetEffectHandle().transform:GetChild(0)
    local effectPath, lodLevel, priority = BuffState.GetEffectPath(effectAround, creature)
    if effectPath ~= nil then
      self:_AddAroundEffect(buffID, effectPath, parent, lodLevel, priority)
    else
      self:_DestroyAroundEffect(buffID)
    end
  else
    self:_DestroyAroundEffect(buffID)
  end
end

function BuffGroup:_AddAroundEffect(buffID, effectPath, parent, lodLevel, priority)
  if self.aroundEffects == nil then
    self.aroundEffects = ReusableTable.CreateTable()
  end
  local effect = self.aroundEffects[buffID]
  if effect == nil then
    effect = Asset_Effect.PlayOn(effectPath, parent, nil, nil, nil, lodLevel, priority)
    self.aroundEffects[buffID] = effect
    self:_AdjustAroundEffects()
  end
end

function BuffGroup:_DestroyAroundEffect(buffID)
  if self.aroundEffects == nil then
    return
  end
  local effect = self.aroundEffects[buffID]
  if effect ~= nil then
    effect:Destroy()
    self.aroundEffects[buffID] = nil
    self:_AdjustAroundEffects()
  end
end

function BuffGroup:_AdjustAroundEffects()
  TableUtility.ArrayClear(tempList)
  for k, v in pairs(self.aroundEffects) do
    tempList[#tempList + 1] = v
  end
  local count = #tempList
  if 0 < count then
    local effect = tempList[1]
    if effect == nil then
      return
    end
    local pieceAngle = 360 / count
    local radius = AroundRadius
    local p0 = tempVector3
    p0[3] = radius
    effect:ResetLocalPosition(p0)
    if 1 < count then
      local r = tempQuaternion
      for i = 2, count do
        effect = tempList[i]
        tempVector3_1[2] = pieceAngle * (i - 1)
        LuaQuaternion.Better_SetEulerAngles(r, tempVector3_1)
        local p = tempVector3_1
        LuaQuaternion.Better_MulVector3(r, p0, p)
        effect:ResetLocalPosition(p)
      end
    end
  end
end

function BuffGroup:_DestroyEffect()
  if self.effect ~= nil then
    self.effect:Destroy()
    self.effect = nil
  end
end

function BuffGroup:_DestroyAroundEffects()
  if self.aroundEffects == nil then
    return
  end
  TableUtility.TableClearByDeleter(self.aroundEffects, ReusableObject.Destroy)
  ReusableTable.DestroyAndClearTable(self.aroundEffects)
  self.aroundEffects = nil
end

function BuffGroup:_DestroyWaitBuffs()
  if self.waitBuffs ~= nil then
    ReusableTable.DestroyTable(self.waitBuffs)
    self.waitBuffs = nil
  end
end

function BuffGroup:GetBuffCount()
  return self.buffCount
end

function BuffGroup:DoConstruct(asArray)
  self.visible = true
  self.buffCount = 0
end

function BuffGroup:DoDeconstruct(asArray)
  self:_End()
end

function BuffGroup:OnObserverDestroyed(k, obj)
  if k == 1 and self.effect == obj then
    self.effect = nil
    self:_DestroyAroundEffects()
  end
end
