autoImport("Table_PetAvatar")
NPet = reusableClass("NPet", NNpc)
NPet.PoolSize = 10
local rolePartIndex = {
  Asset_Role.PartIndex.Head,
  Asset_Role.PartIndex.Face,
  Asset_Role.PartIndex.Mouth,
  Asset_Role.PartIndex.Wing,
  Asset_Role.PartIndex.Tail
}
local tempVector3 = LuaVector3.Zero()
local tempRot = LuaQuaternion()
local CampEffectKey = "CampEffect"
local GetPartCfg = function(id, cfg)
  if nil == next(cfg) then
    return
  end
  local equipId
  for k, partCfg in pairs(cfg) do
    for i = 1, #partCfg do
      if nil ~= partCfg[i] then
        equipId = partCfg[i].FakeID or partCfg[i].id
        if equipId == id then
          return partCfg[i]
        end
      end
    end
  end
end

function NPet:ctor(aiClass)
  NPet.super.ctor(self, AI_CreatureLookAt)
end

function NPet:GetCreatureType()
  return Creature_Type.Pet
end

function NPet:IsMyPet()
  return self.data.ownerID == Game.Myself.data.id
end

function NPet:IsMyTeammatePet()
  return TeamProxy.Instance:IsInMyTeam(self.data.ownerID)
end

function NPet:IsnotFriendPetOrMyGroundTeammatePet()
  local isnotFriendPet = not FriendProxy.Instance:IsFriend(self.data.ownerID)
  local isnotGroupTeammetePet = not TeamProxy.Instance:IsInMyGroup(self.data.ownerID)
  return isnotFriendPet and isnotGroupTeammetePet
end

function NPet:InitAssetRole()
  NPet.super.InitAssetRole(self)
  local assetRole = self.assetRole
  assetRole:SetGUID(self.data.id)
  assetRole:SetName(self.data:GetOriginName())
  assetRole:SetClickPriority(self.data:GetClickPriority())
  assetRole:SetShadowEnable(self.data.staticData.move ~= 1)
  assetRole:SetInvisible(false)
  assetRole:SetColliderEnable(self:IsColliderEnable())
  assetRole:SetWeaponDisplay(true)
  assetRole:SetMountDisplay(true)
  assetRole:SetRenderEnable(true)
  assetRole:SetActionSpeed(1)
end

function NPet:Logic_LookAt(creatureGUID)
  if creatureGUID == nil then
    creatureGUID = 0
  end
  self.ai:LookAt(creatureGUID)
end

function NPet:SetDressEnable(v)
  if self.data and v ~= self.data.dressEnable then
    self.data:SetDressEnable(v)
    self:ReDress()
  end
end

function NPet:SetOwner(owner)
  if owner then
    self.data:SetOwnerID(owner.data.id)
    self:SetDressEnable(owner:IsDressEnable())
    self.assetRole:SetColliderEnable(self:IsColliderEnable())
    self:SetCampEffect(owner.data:GetCamp())
  else
    self.data:SetOwnerID(nil)
    self:SetDressEnable(true)
    self:SetCampEffect()
  end
  self.foundOwner = true
  self:CatchNpcTryLookAt()
end

function NPet:GetOwner()
  return self.data.ownerID
end

function NPet:SetCampEffect(ownerCamp)
  self:RemoveEffect(CampEffectKey)
  if ownerCamp == nil then
    return
  end
  local config = GameConfig.Pet.CampEffect
  if config == nil then
    return
  end
  config = config[self.data.staticData.id]
  if config == nil then
    return
  end
  local camp = self:IsMyPet() and 1 or ownerCamp
  local path = config[camp]
  if path ~= nil then
    self:PlayEffect(CampEffectKey, path, 0, nil, true, true)
  end
end

function NPet:CreateData(serverData)
  return PetData.CreateAsTable(serverData)
end

function NPet:CatchNpcTryLookAt()
  if self.data:IsCatchNpc_Detail() then
    self:Logic_LookAt(self.data.ownerID)
  end
end

function NPet:_DelayDestroy()
  if not NScenePetProxy.Instance:RealRemove(self.data.id, true) then
    self:Destroy()
  end
end

function NPet:IsColliderEnable()
  local data = self.data
  if data:IsCatchNpc_Detail() then
    return true
  end
  if data:IsSkillNpc() then
    return true
  end
  if data:IsCopyNpc() then
    return true
  end
  if data:IsBoki_Detail() then
    return true
  end
  if data:IsSoulNpc() then
    return true
  end
  if data:IsFollowMaster() then
    return true
  end
  if data:IsFireWork() then
    return true
  end
  if data:IsPippi() then
    return true
  end
  if data:IsPhantom() then
    return true
  end
  if data:IsWarehouseNpc() then
    return true
  end
  return data:IsPet() and self:IsMyPet()
end

function NPet:ReDress()
  if self._changeJobTimeFlag then
    return
  end
  NPet.super.ReDress(self)
  self._dressDirty = true
end

local GetLocalPosition = LuaGameObject.GetLocalPosition
local GetLocalScale = LuaGameObject.GetLocalScale
local tempLocalPos = LuaVector3.Zero()
local tempLocalScale = LuaVector3.Zero()

function NPet:ResetPos()
  if not self._dressDirty then
    return
  end
  if not self.assetRole then
    return
  end
  if self.assetRole:_IsLoading() then
    return
  end
  local bodyId = self.assetRole:GetPartID(Asset_Role.PartIndex.Body)
  local avatarStaticData = Table_PetAvatar[bodyId]
  if not avatarStaticData then
    return
  end
  for i = 1, #rolePartIndex do
    local data_id = self.assetRole:GetPartID(rolePartIndex[i])
    local partCfg = GetPartCfg(data_id, avatarStaticData)
    if partCfg then
      local cfgCp = tonumber(string.sub(partCfg.EquipPoint, -1))
      local part = self.assetRole:GetPartObject(rolePartIndex[i])
      if part then
        local pTransform = part.transform
        if rolePartIndex[i] - 1 ~= cfgCp then
          local cp = self.assetRole:GetCP(cfgCp)
          if nil ~= cp and pTransform.parent ~= cp then
            pTransform.parent = cp
          end
        end
        LuaVector3.Better_Set(tempLocalPos, GetLocalPosition(pTransform))
        LuaVector3.Better_Set(tempLocalScale, GetLocalScale(pTransform))
        LuaVector3.Better_Set(tempVector3, partCfg.Position[1], partCfg.Position[2], partCfg.Position[3])
        pTransform.localPosition = tempVector3
        LuaVector3.Better_Set(tempVector3, partCfg.Euler[1], partCfg.Euler[2], partCfg.Euler[3])
        LuaQuaternion.Better_SetEulerAngles(tempRot, tempVector3)
        pTransform.localRotation = tempRot
        LuaVector3.Better_Set(tempVector3, partCfg.Scale[1], partCfg.Scale[2], partCfg.Scale[3])
        pTransform.localScale = tempVector3
        self._dressDirty = false
      end
    end
  end
end

function NPet:PlayChangeJob()
  FunctionSystem.InterruptCreature(self)
  self:_PlayChangeJobBeginEffect()
end

function NPet:_PlayChangeJobBeginEffect()
  self._changeJobTimeFlag = UnityTime + 3
  self.assetRole:ChangeColorFromTo(LuaGeometry.Const_Col_whiteClear, LuaGeometry.Const_Col_white, 3)
  self:PlayEffect(nil, EffectMap.Maps.JobChange, 0, nil, false, true)
end

function NPet:Update(time, deltaTime)
  NPet.super.Update(self, time, deltaTime)
  self:_UpdateEffect(time, deltaTime)
  self:ResetPos()
end

function NPet:_UpdateEffect(time, deltaTime)
  self:_UpdateTrackEffect(time, deltaTime)
  if self._changeJobTimeFlag and time >= self._changeJobTimeFlag then
    self._changeJobTimeFlag = nil
    self:_PlayChangeJobFireEffect()
  end
end

function NPet:_PlayChangeJobFireEffect()
  self:ReDress()
  FunctionSystem.InterruptCreature(self)
  self.assetRole:ChangeColorFromTo(LuaGeometry.Const_Col_white, LuaGeometry.Const_Col_whiteClear, 0.3)
end

function NPet:IsPippi()
  return self.data:IsPippi()
end

function NPet:GetPosition()
  if self:IsPippi() then
    local upID = self.data:GetUpID()
    local role = SceneCreatureProxy.FindCreature(upID)
    if role then
      return role:GetPosition()
    end
  end
  return NPet.super.GetPosition(self)
end

function NPet:GetRealPosition()
  return NPet.super.GetPosition(self)
end

function NPet:DoConstruct(asArray, serverData)
  self.foundOwner = false
  NPet.super.DoConstruct(self, asArray, serverData)
  self:CatchNpcTryLookAt()
end

function NPet:DoDeconstruct(asArray)
  self._changeJobTimeFlag = nil
  self:RemoveEffect(CampEffectKey)
  NPet.super.DoDeconstruct(self, asArray)
end
