EffectWorker_WalkDust = class("EffectWorker_WalkDust", ReusableObject)
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

function EffectWorker_WalkDust.Create(ID)
  return ReusableObject.Create(EffectWorker_WalkDust, true, ID)
end

function EffectWorker_WalkDust:ctor()
  self.effects = nil
end

function EffectWorker_WalkDust:SetArgs(args, creature)
  if nil ~= self.effect then
    return
  end
  local path, lodLevel, priority = GetEffectPath(self.path, creature)
  if path == nil then
    return
  end
  if self.effects == nil then
    self.effects = {}
  end
  if self.ep1 then
    local effect = creature.assetRole:PlayEffectOn(path, self.ep1)
    table.insert(self.effects, effect)
  end
  if self.ep2 then
    local effect = creature.assetRole:PlayEffectOn(path, self.ep2)
    table.insert(self.effects, effect)
  end
end

function EffectWorker_WalkDust:Update(time, deltaTime, creature)
  if not creature or not self.effects then
    return
  end
  local isMoving = not not creature.assetRole.isMoving
  if self.lastMoving ~= isMoving then
    self.lastMoving = isMoving
    for _, v in ipairs(self.effects) do
      if v and v:Alive() then
        v:SetActive(isMoving)
      end
    end
  end
end

function EffectWorker_WalkDust:DoConstruct(asArray, ID)
  local performData = Table_SpEffect[ID].Perform
  self.path = Game.PreprocessEffectPaths(StringUtil.Split(performData.effect, ","))
  self.ep1 = performData.ep1
  self.ep2 = performData.ep2
  self.effects = nil
  self.lastMoving = nil
end

function EffectWorker_WalkDust:DoDeconstruct(asArray)
  if self.effects then
    for _, v in ipairs(self.effects) do
      if v and v:Alive() then
        v:Destroy()
      end
    end
  end
  self.path = nil
  self.ep1 = nil
  self.ep2 = nil
  self.effects = nil
  self.lastMoving = nil
end
