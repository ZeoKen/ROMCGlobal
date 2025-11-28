autoImport("RolePart_RootOffset")
autoImport("RolePart_Damp")
autoImport("RolePart_PlayShow")
autoImport("RolePart_Effect")
autoImport("RolePart_Action")
local Table_PetAvatar = Table_PetAvatar
local Table_RolePartLogic = Table_RolePartLogic
LogicManager_RolePart = class("LogicManager_RolePart")
local Logics = {
  [1] = RolePart_RootOffset,
  [2] = RolePart_Damp,
  [3] = RolePart_PlayShow
}
local _CreatureRolePartArray = function()
  local array = ReusableTable.CreateRolePartArray()
  for i = 1, Asset_Role.PartCount do
    array[i] = nil
  end
  return array
end
local _DestroyRolePartArray = ReusableTable.DestroyRolePartArray

function LogicManager_RolePart:ctor()
  self.logics = {}
  self.effects = {}
  self.actions = {}
end

function LogicManager_RolePart:OnAssetRoleRedressed(assetRole)
  local observed = false
  local rolePartLogics = self.logics[assetRole]
  if nil == rolePartLogics then
    rolePartLogics = _CreatureRolePartArray()
  else
    observed = true
  end
  local logicCount = 0
  local bodyId = assetRole:GetPartID(Asset_Role.PartIndex.Body)
  local petAvatarInfo = Table_PetAvatar[bodyId]
  for i = 1, Asset_Role.PartCount do
    local logic = rolePartLogics[i]
    local rolePartID = assetRole:GetPartID(i)
    if 0 ~= rolePartID then
      local logicInfo = Table_RolePartLogic[rolePartID]
      if nil ~= logicInfo and nil == petAvatarInfo then
        local LogicClass = Logics[logicInfo.Logic]
        if LogicClass ~= nil then
          if nil ~= logic and LogicClass ~= logic.class then
            logic:Destroy()
            logic = nil
          end
          if nil == logic then
            logic = LogicClass.Create()
          end
          logic:SetParams(assetRole, i, logicInfo.Params)
          logicCount = logicCount + 1
        else
          helplog("LogicManager_RolePart OnAssetRoleRedressed : Table_RolePartLogic ", rolePartID, " Logic ", logicInfo.Logic, " has not support!!!")
        end
      elseif nil ~= logic then
        logic:Destroy()
        logic = nil
      end
    elseif nil ~= logic then
      logic:Destroy()
      logic = nil
    end
    rolePartLogics[i] = logic
  end
  if 0 == logicCount then
    _DestroyRolePartArray(rolePartLogics)
    rolePartLogics = nil
    if observed then
      self:TryUnregisterWeakObserver(assetRole)
    end
  else
    assetRole:RegisterWeakObserver(self)
  end
  self.logics[assetRole] = rolePartLogics
end

function LogicManager_RolePart:OnAssetRolePartCreated(assetRole, part)
  local roleParts = self.effects[assetRole]
  if roleParts ~= nil then
    local effect = roleParts[part]
    if effect ~= nil then
      effect:Work()
    end
  end
  roleParts = self.actions[assetRole]
  if roleParts ~= nil then
    local action = roleParts[part]
    if action ~= nil then
      action:Work()
    end
  end
end

function LogicManager_RolePart:LateUpdate(time, deltaTime)
  for assetRole, rolePartLogics in pairs(self.logics) do
    for i = 1, Asset_Role.PartCount do
      local logic = rolePartLogics[i]
      if nil ~= logic then
        logic:LateUpdate(time, deltaTime)
      end
    end
  end
end

function LogicManager_RolePart:TryUnregisterWeakObserver(assetRole)
  if not self:_CheckObserver(self.logics, assetRole) and not self:_CheckObserver(self.effects, assetRole) and not self:_CheckObserver(self.actions, assetRole) then
    assetRole:UnregisterWeakObserver(self)
  end
end

function LogicManager_RolePart:_CheckObserver(array, assetRole)
  local roleParts = array[assetRole]
  if roleParts ~= nil then
    for i = 1, Asset_Role.PartCount do
      if roleParts[i] ~= nil then
        return true
      end
    end
  end
  return false
end

function LogicManager_RolePart:ObserverDestroyed(assetRole)
  self:_DestroyRolePart(self.logics, assetRole)
  self:_DestroyRolePart(self.effects, assetRole)
  self:_DestroyRolePart(self.actions, assetRole)
end

function LogicManager_RolePart:_DestroyRolePart(array, assetRole)
  local roleParts = array[assetRole]
  if nil ~= roleParts then
    for i = Asset_Role.PartCount, 1, -1 do
      local rolePart = roleParts[i]
      if nil ~= rolePart then
        rolePart:Destroy()
      end
      roleParts[i] = nil
    end
    _DestroyRolePartArray(roleParts)
  end
  array[assetRole] = nil
end

function LogicManager_RolePart:AddRolePartEffect(assetRole, part, effect)
  self:_AddRolePart(self.effects, RolePart_Effect, assetRole, part, effect)
end

function LogicManager_RolePart:RemoveRolePartEffect(assetRole, part)
  self:_RemoveRolePart(self.effects, assetRole, part)
end

function LogicManager_RolePart:AddRolePartForbidAction(assetRole, part, action)
  self:_AddRolePart(self.actions, RolePart_Action, assetRole, part, action)
end

function LogicManager_RolePart:RemoveRolePartForbidAction(assetRole, part)
  self:_RemoveRolePart(self.actions, assetRole, part)
end

function LogicManager_RolePart:_AddRolePart(array, class, assetRole, part, params)
  local roleParts = array[assetRole]
  if roleParts == nil then
    roleParts = _CreatureRolePartArray()
    array[assetRole] = roleParts
    assetRole:RegisterWeakObserver(self)
  end
  local rolePart = roleParts[part]
  if rolePart ~= nil then
    rolePart:Destroy()
    rolePart = nil
  end
  rolePart = class.Create()
  rolePart:SetParams(assetRole, part, params)
  rolePart:Work()
  roleParts[part] = rolePart
end

function LogicManager_RolePart:_RemoveRolePart(array, assetRole, part)
  local roleParts = array[assetRole]
  if roleParts == nil then
    return
  end
  local rolePart = roleParts[part]
  if rolePart == nil then
    return
  end
  rolePart:Destroy()
  roleParts[part] = nil
  local canDestroy = true
  for i = 1, Asset_Role.PartCount do
    if roleParts[i] ~= nil then
      canDestroy = false
      break
    end
  end
  if canDestroy then
    _DestroyRolePartArray(roleParts)
    roleParts = nil
    array[assetRole] = roleParts
  end
  self:TryUnregisterWeakObserver(assetRole)
end
