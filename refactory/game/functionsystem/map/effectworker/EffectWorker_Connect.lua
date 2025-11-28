EffectWorker_Connect = class("EffectWorker_Connect", ReusableObject)
local FindCreature = SceneCreatureProxy.FindCreature
local tempVector3 = LuaVector3.Zero()
local Priority = {
  S = 0,
  A = 1,
  B = 2
}
local GetEffectPriority = function(creature1, creature2)
  local myself = Game.Myself
  if creature1 == myself or creature2 == myself then
    return Priority.S
  end
  return Priority.B
end
local GetEffectPath = function(paths, creature1, creature2)
  if paths == nil then
    return nil
  end
  local priority = GetEffectPriority(creature1, creature2)
  local path, lodLevel = Game.EffectManager:GetEffectPath(paths, priority)
  return path, lodLevel, priority
end
EffectWorker_Connect.EffectType = 1

function EffectWorker_Connect.Create(ID)
  return ReusableObject.Create(EffectWorker_Connect, true, ID)
end

local _MapManager

function EffectWorker_Connect:ctor()
  _MapManager = Game.MapManager
  self.guid2 = 0
  self.path = nil
  self.effect = nil
end

function EffectWorker_Connect:SetArgs(args, creature)
  self.guid2 = args[1]
  self.duration = args[2]
end

local _OnEffectCreated = function(effectHandler, self, asset_Effect)
  self.lineRenders = asset_Effect:GetComponentsInChildren(LineRenderer, true)
  self.effectLoadFailed = self.lineRenders == nil
end

function EffectWorker_Connect:Update(time, deltaTime, creature1)
  local creature2 = FindCreature(self.guid2)
  local skipDestroy = false
  if creature2 and creature2.assetRole.hideBodyOnly and _MapManager and _MapManager:IsPVEMode() then
    skipDestroy = true
  end
  if not skipDestroy and (nil == creature2 or true == creature2.assetRole:GetInvisible() or creature1 == creature2) then
    self:_DestroyEffect()
    return false
  end
  if not self.effect then
    local tEffect = self:_CreateEffect(_OnEffectCreated, self, creature1, creature2)
    if not tEffect then
      return false
    end
    self.effect = tEffect
  end
  if self.effectLoadFailed then
    return false
  end
  if self.lineRenders then
    if self.duration ~= nil then
      if self.elapseTime == nil then
        self.elapseTime = 0
      end
      self.elapseTime = self.elapseTime + deltaTime
      if self.elapseTime >= self.duration then
        self.elapseTime = nil
        return false
      end
    end
    if self.ep1 ~= nil and self.ep2 ~= nil then
      for i = 1, #self.lineRenders do
        local lineRender = self.lineRenders[i]
        lineRender.positionCount = 2
        LuaVector3.Better_Set(tempVector3, creature1.assetRole:GetEPOrRootPosition(self.ep1))
        lineRender:SetPosition(0, tempVector3)
        LuaVector3.Better_Set(tempVector3, creature2.assetRole:GetEPOrRootPosition(self.ep2))
        lineRender:SetPosition(1, tempVector3)
      end
    end
  end
end

function EffectWorker_Connect:_CreateEffect(callBack, callBackArgs, creature1, creature2)
  if nil ~= self.effect then
    return nil
  end
  local path, lodLevel, priority = GetEffectPath(self.path, creature1, creature2)
  if path == nil then
    return nil
  end
  return Asset_Effect.PlayAt(path, LuaGeometry.Const_V3_zero, callBack, callBackArgs, nil, lodLevel, priority)
end

function EffectWorker_Connect:_DestroyEffect()
  if nil == self.effect then
    return
  end
  local oldEffect = self.effect
  self.effect = nil
  self.lineRenders = nil
  self.ep1 = nil
  self.ep2 = nil
  if oldEffect:Alive() then
    oldEffect:Destroy()
  end
end

function EffectWorker_Connect:DoConstruct(asArray, ID)
  self.guid2 = 0
  self.effect = nil
  self.lineRenders = nil
  local performData = Table_SpEffect[ID].Perform
  self.path = Game.PreprocessEffectPaths(StringUtil.Split(performData.effect, ","))
  self.ep1 = performData.ep1
  self.ep2 = performData.ep2
end

function EffectWorker_Connect:DoDeconstruct(asArray)
  if nil ~= self.effect and self.effect:Alive() then
    self.effect:Destroy()
    self.effect = nil
  end
  self.lineRenders = nil
  self.effectLoadFailed = false
  self.path = nil
  self.duration = nil
  self.elapseTime = nil
end
