Buff = class("Buff", ReusableObject)
Buff.PoolSize = 50
Buff.Type = {Base = 1, State = 2}
local tempArgs = {
  [1] = nil,
  [2] = nil,
  [3] = nil
}
local GetArgs = function(layer, level, active)
  tempArgs[1] = layer
  tempArgs[2] = level
  tempArgs[3] = active
  return tempArgs
end

function Buff.Create(layer, level, active)
  local args = GetArgs(layer, level, active)
  return ReusableObject.Create(Buff, false, args)
end

function Buff:SetLayer(layer)
  self.layer = layer or 1
end

function Buff:GetLayer()
  return self.layer or 1
end

function Buff:SetActive(active)
  self.active = active
end

function Buff:GetActive()
  return self.active
end

function Buff:SetLevel(level)
  self.level = level or 0
end

function Buff:GetLevel()
  return self.level or 0
end

function Buff:GetType()
  return Buff.Type.Base
end

function Buff:SetFromID(fromID)
  self.fromID = fromID
end

function Buff:GetFromID()
  return self.fromID or 0
end

function Buff:DoConstruct(asArray, args)
  self.layer = args[1]
  self.level = args[2]
  self.active = args[3]
end

function Buff:DoDeconstruct(asArray)
  self.layer = nil
  self.active = nil
  self.level = nil
  if self.fromID then
    self.fromID = nil
  end
end
