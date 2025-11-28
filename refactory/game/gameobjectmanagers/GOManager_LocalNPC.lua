LocalNPC = class("LocalNPC", ReusableObject)
if not LocalNPC.LocalNPC_inited then
  LocalNPC.LocalNPC_inited = true
  LocalNPC.PoolSize = 20
end
local tempVector3 = LuaVector3.Zero()

function LocalNPC.Create(obj)
  return ReusableObject.Create(LocalNPC, true, obj)
end

function LocalNPC:ctor()
end

function LocalNPC:GetID()
  return self.ID
end

function LocalNPC:GetNPCID()
  return self.staticData.id
end

function LocalNPC:DoConstruct(asArray, obj)
  self._obj = obj
  local npcID = tonumber(obj:GetProperty(0))
  local staticData = Table_Npc[npcID]
  if nil == staticData then
    staticData = Table_Monster[npcID]
    if nil == staticData then
      return
    end
  end
  local ID = obj.ID
  self.ID = ID
  self.staticData = staticData
  local deferredDoConstruct = "true" == obj:GetProperty(3)
  if deferredDoConstruct then
    self.deferred = true
    return
  end
  self:RealDoConstruct()
end

function LocalNPC:RealDoConstruct(withVisibility, callback, callbackArg)
  if not self._obj then
    return
  end
  local obj = self._obj
  local staticData = self.staticData
  local ID = self.ID
  local npcID = tonumber(obj:GetProperty(0))
  local idleAction = obj:GetProperty(1)
  local accessable = "true" == obj:GetProperty(2)
  local parent = obj:GetComponentProperty(0)
  local name = staticData.NameZh or staticData.Name
  if nil == name or "" == name then
    name = string.format("LocalNPC_%d", npcID)
  end
  local parts = Asset_RoleUtility.CreateRoleParts(staticData)
  parts[Asset_Role.PartIndexEx.SkinQuality] = Asset_RolePart.SkinQuality.Bone4
  local assetRole = Asset_Role.Create(parts)
  Asset_Role.DestroyPartArray(parts)
  parts = nil
  assetRole:SetGUID(ID)
  assetRole:SetName(name)
  assetRole:SetClickPriority(0)
  assetRole:SetShadowEnable(staticData.move ~= 1)
  assetRole:SetColliderEnable(accessable)
  assetRole:SetWeaponDisplay(true)
  assetRole:SetMountDisplay(true)
  assetRole:SetActionSpeed(1)
  assetRole:PlayAction_Simple(idleAction)
  if nil ~= parent then
    assetRole:SetParent(parent)
    assetRole:SetPosition(LuaGeometry.Const_V3_zero)
    assetRole:SetEulerAngleY(0)
    assetRole:SetScale(1)
  else
    local t = obj.transform
    LuaVector3.Better_Set(tempVector3, LuaGameObject.GetPosition(t))
    assetRole:SetPosition(tempVector3)
    LuaVector3.Better_Set(tempVector3, LuaGameObject.GetEulerAngles(t))
    assetRole:SetEulerAngles(tempVector3)
    LuaVector3.Better_Set(tempVector3, LuaGameObject.GetScale(t))
    assetRole:SetScale(tempVector3[2])
  end
  if withVisibility ~= nil then
    assetRole:SetInvisible(not withVisibility)
  end
  self.assetRole = assetRole
  self._obj = nil
  self.deferred = false
  if callback then
    if self.assetRole:_IsLoading() then
      self.assetRole:SetExOnCreatedCallback(function(assetRole, arg)
        if callback then
          callback(assetRole, arg)
        end
      end, callbackArg)
    else
      callback(self.assetRole, callbackArg)
    end
  end
end

function LocalNPC:DoDeconstruct(asArray)
  self.staticData = nil
  if nil ~= self.assetRole then
    self.assetRole:Destroy()
    self.assetRole = nil
  end
end

GOManager_LocalNPC = class("GOManager_LocalNPC")

function GOManager_LocalNPC:ctor()
  self.npcDatas = {}
  self.npcs = {}
end

function GOManager_LocalNPC:_AddNPC(obj, ID)
  if ProfessionProxy.IsDoramForbidden() and obj ~= nil then
    local npcID = tonumber(obj:GetProperty(0))
    if tonumber(npcID) == 806658 or tonumber(npcID) == 806659 then
      return
    end
  end
  local oldNPC = self.npcs[ID]
  if nil ~= oldNPC then
    oldNPC:Destroy()
  end
  if nil ~= obj then
    self.npcs[ID] = LocalNPC.Create(obj)
  else
    self.npcs[ID] = nil
  end
end

function GOManager_LocalNPC:Clear()
  TableUtility.TableClear(self.npcDatas)
  for k, v in pairs(self.npcs) do
    v:Destroy()
    self.npcs[k] = nil
  end
end

function GOManager_LocalNPC:SetNPCData(obj, ID)
  self.npcDatas[ID] = obj
  self:_AddNPC(obj, ID)
end

function GOManager_LocalNPC:ClearNPCData(obj)
  local objID = obj.ID
  local npcData = self.npcDatas[objID]
  if nil ~= npcData and npcData == obj then
    self:SetNPCData(nil, objID)
    return true
  end
  return false
end

function GOManager_LocalNPC:RegisterGameObject(obj)
  local objID = obj.ID
  Debug_AssertFormat(0 < objID, "RegisterLocalNPC({0}) invalid id: {1}", obj, objID)
  self:SetNPCData(obj, objID)
  return true
end

function GOManager_LocalNPC:UnregisterGameObject(obj)
  if not self:ClearNPCData(obj) then
    Debug_AssertFormat(false, "UnregisterLocalNPC({0}) failed: {1}", obj, obj.ID)
    return false
  end
  return true
end
