EffectWorker_OnFloor = class("EffectWorker_OnFloor", ReusableObject)
local Priority = {
  S = 0,
  A = 1,
  B = 2
}
local GetEffectPriority = function(creature)
  if creature == Game.Myself then
    return Priority.S
  end
  return Priority.B
end
local GetEffectPath = function(paths, creature)
  if paths == nil then
    return nil
  end
  local priority = GetEffectPriority(creature)
  local path, lodLevel = Game.EffectManager:GetEffectPath(paths, priority)
  return path, lodLevel, priority
end
local _OnEffectCreated = function(effectHandle, effectWorker)
  if not effectWorker then
    return
  end
  effectWorker:OnEffectCreated(effectHandle)
end

function EffectWorker_OnFloor.Create(ID)
  return ReusableObject.Create(EffectWorker_OnFloor, true, ID)
end

function EffectWorker_OnFloor:ctor()
  self.effect = nil
end

function EffectWorker_OnFloor:SetArgs(args, creature)
  if nil ~= self.effect then
    return
  end
  local path, lodLevel, priority = GetEffectPath(self.path, creature)
  if path == nil then
    return
  end
  self.effect = Asset_Effect.PlayAt(path, creature:GetPosition(), _OnEffectCreated, self, nil, lodLevel, priority)
end

function EffectWorker_OnFloor:OnEffectCreated(effectHandle)
  effectHandle.enabled = false
  self.effectHandle = effectHandle
end

function EffectWorker_OnFloor:Update(time, deltaTime, creature)
end

function EffectWorker_OnFloor:DoConstruct(asArray, ID)
  local performData = Table_SpEffect[ID].Perform
  self.path = Game.PreprocessEffectPaths(StringUtil.Split(performData.effect, ","))
  self.effect = nil
end

function EffectWorker_OnFloor:DoDeconstruct(asArray)
  if nil ~= self.effect then
    self.effect:RemoveCreatedCallBack()
    if not LuaGameObject.ObjectIsNull(self.effectHandle) then
      self.effectHandle.enabled = true
      local animator = self.effect:GetComponent(Animator)
      if nil ~= animator then
        animator:Play("end")
        Game.AssetManager_Effect:AddAutoDestroyEffect(self.effect)
      else
        self.effect:Destroy()
      end
    else
      self.effect:Destroy()
    end
    self.effect = nil
  end
  self.effectHandle = nil
  self.path = nil
end
