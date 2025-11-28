RolePart_Damp = class("RolePart_Damp", ReusableObject)
RolePart_Damp.PoolSize = 100

function RolePart_Damp.Create()
  return ReusableObject.Create(RolePart_Damp, true, nil)
end

function RolePart_Damp:ctor()
  self.args = {
    [1] = nil,
    [2] = 0
  }
  self.params = nil
end

function RolePart_Damp:SetParams(assetRole, partIndex, params)
  self.args[1] = assetRole
  self.args[2] = partIndex
  self.params = params
  if self.comRolePartLogic then
    LuaGameObject.DestroyObject(self.comRolePartLogic)
  end
  self.comRolePartLogic = nil
  self.inited = true
  self.isWorking = false
end

function RolePart_Damp:_TryInitRolePartDamp()
  if self.comRolePartLogic then
    return true
  end
  local assetRole = self.args[1]
  local partIndex = self.args[2]
  if assetRole:GetPartID(partIndex) ~= assetRole:GetRealPartID(partIndex) then
    return
  end
  local rolePart = assetRole:GetPartObject(partIndex)
  if not rolePart then
    return
  end
  self.comRolePartLogic = rolePart.gameObject:AddComponent(RolePartLogic_Damp)
  local params = self.params
  local offset = params.offset or LuaGeometry.Const_V3_zero
  self.comRolePartLogic:Init(assetRole.completeTransform, offset, params.inner_range, params.outter_range, params.duration)
  self.isWorking = true
  return true
end

function RolePart_Damp:LateUpdate(time, deltaTime)
  if not self.inited or not self.comRolePartLogic and not self:_TryInitRolePartDamp() then
    return
  end
  local assetRole = self.args[1]
  if assetRole:NoLogic() then
    if self.isWorking then
      self.isWorking = false
      self.comRolePartLogic.enabled = false
    end
    return
  elseif not self.isWorking then
    self.isWorking = true
    self.comRolePartLogic.enabled = true
  end
end

function RolePart_Damp:DoConstruct(asArray, args)
end

function RolePart_Damp:DoDeconstruct(asArray)
  self.args[1] = nil
  self.args[2] = 0
  self.params = nil
  self.inited = nil
  self.isWorking = nil
  if self.comRolePartLogic then
    LuaGameObject.DestroyObject(self.comRolePartLogic)
  end
  self.comRolePartLogic = nil
end
