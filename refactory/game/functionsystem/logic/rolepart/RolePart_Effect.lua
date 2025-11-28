RolePart_Effect = class("RolePart_Effect", ReusableObject)
RolePart_Effect.PoolSize = 100

function RolePart_Effect.Create()
  return ReusableObject.Create(RolePart_Effect, true, nil)
end

function RolePart_Effect:ctor()
  self.args = {
    [1] = nil,
    [2] = 0
  }
  self.params = nil
end

function RolePart_Effect:SetParams(assetRole, partIndex, params)
  self.args[1] = assetRole
  self.args[2] = partIndex
  self.params = params
end

function RolePart_Effect:Work()
  local args = self.args
  local assetRole = args[1]
  local rolePart = assetRole:GetPartObject(args[2])
  if rolePart == nil then
    return
  end
  if self.params ~= nil then
    self:Reset()
    self.effect = Asset_Effect.PlayOn(self.params, rolePart.transform)
  end
end

function RolePart_Effect:Reset()
  if self.effect then
    self.effect:Destroy()
    self.effect = nil
  end
end

function RolePart_Effect:DoConstruct(asArray, args)
end

function RolePart_Effect:DoDeconstruct(asArray)
  self:Reset()
  self.args[1] = nil
  self.args[2] = 0
  self.params = nil
end
