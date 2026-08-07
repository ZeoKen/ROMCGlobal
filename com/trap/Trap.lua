Trap = reusableClass("Trap")
Trap.PoolSize = 20
local CullingIDUtility = CullingIDUtility

function Trap:Init(guid, skillID, masterID, pos, dir, entertime)
  self.id = guid
  self.skillID = skillID
  self.masterID = masterID
  self.entertime = entertime
  self.pos = ProtolUtility.S2C_Vector3(pos)
  self.rotation = ProtolUtility.S2C_Number(dir)
  local skillinfo = Game.LogicManager_Skill:GetSkillInfo(skillID)
  local masterCreature
  if nil ~= masterID and 0 ~= masterID then
    masterCreature = SceneCreatureProxy.FindCreature(masterID)
    if masterCreature and masterCreature.data:GetCamp() == RoleDefines_Camp.ENEMY and skillinfo:IsTrap() and not skillinfo:NoReadingEffect() and not skillinfo:FollowUser() then
      local path, lodLevel, priority, effectType = skillinfo:GetWarnRingEffectPath(masterCreature)
      if path ~= nil then
        local effect = Asset_Effect.PlayAt(path, self.pos, nil, nil, nil, lodLevel, priority, effectType)
        local size = ReusableTable.CreateTable()
        skillinfo:GetWarnRingSize(masterCreature, size)
        effect:ResetLocalScaleXYZ(size.x, 1, size.y)
        ReusableTable.DestroyAndClearTable(size)
        effect:ResetLocalEulerAnglesXYZ(0, self.rotation, 0)
        effect:SetActive(self.active)
        self.warnRingEffect = effect
      end
    end
  end
  self:_SpawnCullingID()
  local path, lodLevel, priority, effectType = skillinfo:GetTrapEffectPath(masterCreature)
  self:_CreateEffect(path, self.pos, lodLevel, priority, effectType, nil, skillinfo:IsOneShotTrap())
  self:_InitRangeGrow(skillinfo)
end

local _Distance = LuaVector3.Distance

function Trap:Refresh(serverData)
  if serverData.pos then
    ProtolUtility.Better_S2C_Vector3(serverData.pos, self.pos)
    if self:LerpEffectPos() then
      self.moveTick = TimeTickManager.Me():CreateTick(0, 16, Trap.LerpEffectPosTick, self, 1)
    end
  end
end

function Trap:LerpEffectPosTick(time, deltatime)
  if not self:LerpEffectPos() then
    self:ClearMoveTick()
  end
end

local tempVector3 = LuaVector3.Zero()

function Trap:LerpEffectPos()
  if not self.effect then
    return false
  end
  local ePos = self.effect:GetLocalPosition()
  if VectorUtility.DistanceXZ(ePos, self.pos) < 0.05 then
    return false
  end
  tempVector3:Set(ePos[1], ePos[2], ePos[3])
  tempVector3:LerpTo(self.pos, 0.5)
  self:SetPos(tempVector3[1], tempVector3[2], tempVector3[3], true)
  return true
end

function Trap:ClearMoveTick()
  if self.moveTick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.moveTick = nil
  end
end

function Trap:_InitRangeGrow(skillinfo)
  self.rangeGrow = nil
  self:ClearRangeTick()
  local lp = skillinfo and skillinfo.logicParam
  if not (lp and lp.range_inc_per_tick) or not lp.max_range then
    return
  end
  self.rangeGrow = {
    initRange = lp.range or 0,
    inc = lp.range_inc_per_tick,
    maxRange = lp.max_range,
    interval = lp.interval and 0 < lp.interval and lp.interval or 1
  }
  if not self:_RefreshGrowRange() then
    self.rangeTick = TimeTickManager.Me():CreateTick(0, self.rangeGrow.interval * 1000, Trap.RangeGrowTick, self, 2)
  end
end

function Trap:_RefreshGrowRange()
  local g = self.rangeGrow
  if not g then
    return true
  end
  local elapsedSec = 0
  if self.entertime and 0 < self.entertime then
    elapsedSec = ServerTime.CurServerTime() / 1000 - self.entertime
    if elapsedSec < 0 then
      elapsedSec = 0
    end
  end
  local tickCount = math.floor(elapsedSec / g.interval)
  local curRange = math.min(g.initRange + tickCount * g.inc, g.maxRange)
  self:_ApplyRangeScale(curRange)
  return curRange >= g.maxRange
end

function Trap:_ApplyRangeScale(range)
  if not self.effect or not self.rangeGrow then
    return
  end
  local base = self.rangeGrow.initRange
  if base and 0 < base then
    local s = range / base
    self.effect:ResetLocalScaleXYZ(s, 1, s)
  end
end

function Trap:RangeGrowTick(time, deltatime)
  if self:_RefreshGrowRange() then
    self:ClearRangeTick()
  end
end

function Trap:ClearRangeTick()
  if self.rangeTick then
    TimeTickManager.Me():ClearTick(self, 2)
    self.rangeTick = nil
  end
end

function Trap:_SpawnCullingID()
  self.cullingID = self.id
end

function Trap:_ClearCullingID()
  self.cullingID = nil
end

local OnEffectCreated = function(effectHandler, trap, assetEffect)
  if assetEffect then
    assetEffect:ResetLocalEulerAnglesXYZ(0, trap.rotation, 0)
  end
end

function Trap:_CreateEffect(path, pos, lodLevel, priority, effectType, callBack, isOneShot)
  if not path then
    return
  end
  if isOneShot then
    if not self.active then
      return
    end
    Asset_Effect.PlayOneShotAt(path, pos, OnEffectCreated, self, nil, lodLevel, priority, effectType)
    return
  end
  self.effect = Asset_Effect.PlayAt(path, pos, OnEffectCreated, self)
  self.effect:SetActive(self.active)
end

function Trap:CullingStateChange(visible, distanceLevel)
  if visible ~= nil then
    local active = visible ~= 0 and true or false
    self:SetActive(active)
  end
end

function Trap:SetActive(v)
  if self.active == v then
    return
  end
  self.active = v
  if self.effect ~= nil then
    self.effect:SetActive(v)
  end
  if self.warnRingEffect ~= nil then
    self.warnRingEffect:SetActive(v)
  end
end

function Trap:SetPos(x, y, z, noUpdateSelfPos)
  if not noUpdateSelfPos then
    self.pos:Set(x, y, z)
  end
  if self.effect then
    self.effect:ResetLocalPosition(self.pos)
  end
  if self.warnRingEffect then
    self.warnRingEffect:ResetLocalPosition(self.pos)
  end
end

function Trap:SetScale(x, y, z)
  y = y or x
  z = z or x
end

function Trap:SetRotation(y)
  self.rotation = y
  if self.effect then
    self.effect:ResetLocalEulerAnglesXYZ(0, self.rotation, 0)
  end
  if self.warnRingEffect then
    self.warnRingEffect:ResetLocalEulerAnglesXYZ(0, self.rotation, 0)
  end
end

function Trap:DoConstruct(asArray, serverData)
  self.active = true
end

function Trap:DoDeconstruct(asArray)
  self:ClearMoveTick()
  self:ClearRangeTick()
  self.rangeGrow = nil
  self:_ClearCullingID()
  if self.pos then
    self.pos:Destroy()
    self.pos = nil
  end
  if self.effect then
    self.effect:Destroy()
    self.effect = nil
  end
  if self.warnRingEffect then
    self.warnRingEffect:Destroy()
    self.warnRingEffect = nil
  end
end
