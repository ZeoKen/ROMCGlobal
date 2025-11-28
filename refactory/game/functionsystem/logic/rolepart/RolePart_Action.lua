RolePart_Action = class("RolePart_Action", ReusableObject)
RolePart_Action.PoolSize = 100

function RolePart_Action.Create()
  return ReusableObject.Create(RolePart_Action, true, nil)
end

function RolePart_Action:ctor()
  self.args = {
    [1] = nil,
    [2] = 0
  }
  self.params = nil
end

function RolePart_Action:SetParams(assetRole, partIndex, params)
  self.args[1] = assetRole
  self.args[2] = partIndex
  self.params = params
end

function RolePart_Action:Work()
  local args = self.args
  local assetRole = args[1]
  local rolePart = assetRole:GetPartObject(args[2])
  if rolePart == nil then
    return
  end
  if self.params ~= nil then
    self:Reset()
    assetRole:AddPartForbidAction(args[2], self.params)
  end
end

function RolePart_Action:Reset()
  self.args[1]:ClearPartForbidAction(self.args[2])
end

function RolePart_Action:DoConstruct(asArray, args)
end

function RolePart_Action:DoDeconstruct(asArray)
  self:Reset()
  self.args[1] = nil
  self.args[2] = 0
  self.params = nil
end
