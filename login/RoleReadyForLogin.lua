autoImport("CSharpObjectForLogin")
RoleReadyForLogin = class("RoleReadyForLogin")
local luaVector3 = LuaVector3.Zero()
local m_mountTransform = {}
m_mountTransform.position = {
  x = 1.6,
  y = -1.8,
  z = -3
}
m_mountTransform.eulerAngles = {
  x = 0,
  y = 148.8,
  z = 0
}
local m_roleTransform = {}
m_roleTransform.position = {
  x = 0.735,
  y = -1.67,
  z = -4.3
}
m_roleTransform.eulerAngles = {
  x = 0,
  y = -180,
  z = 0
}
local m_falconTransform = {}
m_falconTransform.position = {
  x = 1.75,
  y = 0.6,
  z = -1.78
}
m_falconTransform.eulerAngles = {
  x = 0,
  y = -163.3,
  z = 0
}
RoleReadyForLogin.ins = nil

function RoleReadyForLogin.Ins()
  if RoleReadyForLogin.ins == nil then
    RoleReadyForLogin.ins = RoleReadyForLogin.new()
  end
  return RoleReadyForLogin.ins
end

function RoleReadyForLogin:ctor()
  self:Construct()
end

function RoleReadyForLogin:Construct()
  self.allModelsController = {}
  self.currentRoleID = 0
  self.currentModelsController = nil
end

function RoleReadyForLogin:Deconstruct()
  self:Release()
end

local colorTemp = LuaColor.New(0.19607843137254902, 0.19607843137254902, 0.19607843137254902, 0.0392156862745098)

function RoleReadyForLogin:Iam(roleID)
  self:Hide()
  if self.allModelsController == nil then
    self.allModelsController = {}
  end
  if not table.ContainsKey(self.allModelsController, roleID) then
    local roleDetail = ServiceUserProxy.Instance:GetRoleInfoById(roleID)
    if roleDetail ~= nil then
      local modelsController = {}
      local parts = Asset_Role.CreatePartArray()
      parts[Asset_Role.PartIndex.Body] = roleDetail.body
      parts[Asset_Role.PartIndex.Hair] = roleDetail.hair
      parts[Asset_Role.PartIndex.LeftWeapon] = roleDetail.lefthand
      parts[Asset_Role.PartIndex.RightWeapon] = roleDetail.righthand
      parts[Asset_Role.PartIndex.Head] = roleDetail.head
      parts[Asset_Role.PartIndex.Wing] = roleDetail.back
      parts[Asset_Role.PartIndex.Face] = roleDetail.face
      parts[Asset_Role.PartIndex.Tail] = roleDetail.tail
      parts[Asset_Role.PartIndex.Eye] = roleDetail.eye
      parts[Asset_Role.PartIndex.Mouth] = roleDetail.mouth
      local gender = RoleConfig.Gender.None
      if roleDetail.gender == ProtoCommon_pb.EGENDER_FEMALE then
        gender = RoleConfig.Gender.Female
      elseif roleDetail.gender == ProtoCommon_pb.EGENDER_MALE then
        gender = RoleConfig.Gender.Male
      end
      parts[Asset_Role.PartIndexEx.Gender] = gender
      parts[Asset_Role.PartIndexEx.HairColorIndex] = roleDetail.haircolor
      parts[Asset_Role.PartIndexEx.EyeColorIndex] = roleDetail.eyecolor
      parts[Asset_Role.PartIndexEx.BodyColorIndex] = roleDetail.clothcolor
      local classData = Table_Class[roleDetail.profession]
      if classData ~= nil then
        parts[Asset_Role.PartIndexEx.SheathDisplay] = classData.Feature and classData.Feature & FeatureDefines_Class.Sheath > 0
      end
      parts[Asset_Role.PartIndexEx.SkinQuality] = Asset_RolePart.SkinQuality.Bone4
      parts[Asset_Role.PartIndexEx.Download] = true
      local assetRole = Asset_Role.Create(parts)
      assetRole:SetGUID(roleID)
      assetRole:SetName(roleDetail.name)
      assetRole:SetShadowEnable(false)
      assetRole:SetColliderEnable(false)
      assetRole:SetWeaponDisplay(true)
      assetRole:SetRenderEnable(true)
      assetRole:SetActionSpeed(1)
      assetRole:SetInvisible(false)
      assetRole:ChangeColorTo(colorTemp, 0)
      assetRole:PlayAction_Idle()
      self:RefreshBuffState(parts, assetRole, roleID)
      Asset_Role.DestroyPartArray(parts)
      local roleParent = CSharpObjectForLogin:Ins():GetRoleParnet()
      if roleParent then
        assetRole:SetParent(roleParent.transform)
      end
      assetRole:SetPosition(LuaVector3.Zero())
      assetRole:SetRotation(LuaQuaternion.Identity())
      assetRole:SetEpNodesDisplay(true)
      if classData ~= nil then
        assetRole:SetSuffixReplaceMap(classData.ActionSuffixMap)
      end
      Game.PerformanceManager:SkinWeightHigh(true)
      modelsController.role = assetRole
      if 0 < roleDetail.mount then
        local subparts, partColors = {}, {}
        MountFashionProxy.Instance:SetLocalSaveData(roleID, roleDetail.mount)
        MountFashionProxy.Instance:SetMountSubParts(subparts, roleDetail.mount)
        MountFashionProxy.Instance:SetMountPartColors(partColors, roleDetail.mount)
        modelsController.mount = Asset_RolePart.Create(Asset_Role.PartIndex.Mount, roleDetail.mount, function(rolePart, arg, assetRolePart)
          rolePart:EnableShadowCast(true, true)
        end, nil, Asset_RolePart.SkinQuality.Bone4, subparts, partColors)
        local mountParent = CSharpObjectForLogin:Ins():GetMountParent()
        if mountParent then
          modelsController.mount:ResetParent(mountParent.transform)
        end
        modelsController.mount:ResetLocalPositionXYZ(0, 0, 0)
        modelsController.mount:ResetLocalEulerAnglesXYZ(0, 0, 0)
      end
      if 0 < roleDetail.partnerid then
        local falconConf = Table_Npc[roleDetail.partnerid]
        if falconConf then
          local falconParts = Asset_Role.CreatePartArray()
          falconParts[1] = falconConf.Body
          local assetFalcon = Asset_Role.Create(falconParts)
          assetFalcon:SetGUID(roleDetail.partnerid)
          assetFalcon:SetName(falconConf.NameZh)
          assetFalcon:SetShadowEnable(false)
          assetFalcon:SetColliderEnable(false)
          assetFalcon:SetWeaponDisplay(false)
          assetFalcon:SetRenderEnable(true)
          assetFalcon:SetActionSpeed(1)
          assetFalcon:SetInvisible(false)
          assetFalcon:PlayAction_Idle()
          local scale = 1
          if Table_Npc[roleDetail.partnerid] then
            scale = Table_Npc[roleDetail.partnerid].Scale or 1
          end
          assetFalcon:SetScale(scale)
          Asset_Role.DestroyPartArray(parts)
          local npcFollowConfigure = Table_NPCFollow[roleDetail.partnerid]
          if npcFollowConfigure ~= nil then
            LuaVector3.Better_Set(luaVector3, npcFollowConfigure.ChooseUILocation[1], npcFollowConfigure.ChooseUILocation[2], npcFollowConfigure.ChooseUILocation[3])
            assetFalcon:SetPosition(luaVector3)
            LuaVector3.Better_Set(luaVector3, npcFollowConfigure.ChooseUIRotating[1], npcFollowConfigure.ChooseUIRotating[2], npcFollowConfigure.ChooseUIRotating[3])
            assetFalcon:SetEulerAngles(luaVector3)
          end
          modelsController.falcon = assetFalcon
        end
      end
      self.allModelsController[roleID] = modelsController
      self.currentRoleID = roleID
      self.currentModelsController = modelsController
    end
  else
    local modelsController = self.allModelsController[roleID]
    local role = modelsController.role
    local mount = modelsController.mount
    local falcon = modelsController.falcon
    role:SetInvisible(false)
    local roleParent = CSharpObjectForLogin:Ins():GetRoleParnet()
    if roleParent then
      role:SetParent(roleParent.transform)
    end
    role:SetPosition(LuaVector3.Zero())
    role:SetRotation(LuaQuaternion.Identity())
    if mount then
      self:ShowMount(mount)
      local mountParent = CSharpObjectForLogin:Ins():GetMountParent()
      if mountParent then
        mount:ResetParent(mountParent.transform)
      end
      mount:ResetLocalPositionXYZ(0, 0, 0)
      mount:ResetLocalEulerAnglesXYZ(0, 0, 0)
    end
    if falcon then
      falcon:SetInvisible(false)
    end
    self.currentRoleID = roleID
    self.currentModelsController = modelsController
  end
end

function RoleReadyForLogin:Show()
  if self.currentModelsController ~= nil then
    local role = self.currentModelsController.role
    role:SetInvisible(false)
    local mount = self.currentModelsController.mount
    if mount then
      self:ShowMount(mount)
    end
    local falcon = self.currentModelsController.falcon
    if falcon then
      falcon:SetInvisible(false)
    end
  end
end

function RoleReadyForLogin:Hide()
  if self.currentModelsController ~= nil then
    local role = self.currentModelsController.role
    role:SetInvisible(true)
    local mount = self.currentModelsController.mount
    if mount then
      self:HideMount(mount)
    end
    local falcon = self.currentModelsController.falcon
    if falcon then
      falcon:SetInvisible(true)
    end
  end
end

function RoleReadyForLogin:ShowMount(assetMount)
  if assetMount ~= nil then
    LuaVector3.Better_Set(luaVector3, m_mountTransform.position.x, m_mountTransform.position.y, m_mountTransform.position.z)
    assetMount:ResetLocalPosition(luaVector3)
  end
end

function RoleReadyForLogin:HideMount(assetMount)
  if assetMount ~= nil then
    LuaVector3.Better_Set(luaVector3, m_mountTransform.position.x, m_mountTransform.position.y + 10000, m_mountTransform.position.z)
    assetMount:ResetLocalPosition(luaVector3)
  end
end

function RoleReadyForLogin:RotateDelta(deltaEulerAngle)
  if self.currentModelsController ~= nil then
    local role = self.currentModelsController.role
    role:RotateDelta(deltaEulerAngle)
  end
end

function RoleReadyForLogin:RefreshBuffState(parts, role, guid)
  if not self.buffEffSet then
    self.buffEffSet = {}
  end
  if self.buffEffSet[guid] then
    return
  end
  self.buffEffSet[guid] = 1
  for _partType, _index in pairs(Asset_Role.PartIndex) do
    if parts[_index] and 0 < parts[_index] then
      local equipData = Table_Equip[parts[_index]]
      local fashionBuff = equipData and equipData.FashionBuff
      if fashionBuff and 0 < #fashionBuff then
        self:BuffTableImport()
        for i = 1, #fashionBuff do
          local buffData = Table_Buffer[fashionBuff[i]]
          local buffStateID = buffData and buffData.BuffStateID
          if buffStateID then
            local buffStateData = Table_BuffState[buffStateID]
            local path = buffStateData.Effect
            role:PlayEffectOn(path, buffStateData.EP)
          end
        end
      end
    end
  end
end

function RoleReadyForLogin:BuffTableImport()
  if not self.inited then
    autoImport("Table_Buffer")
    autoImport("Table_BuffState")
    self.inited = true
  end
end

function RoleReadyForLogin:Release()
  self.currentModelsController = nil
  Game.PerformanceManager:SkinWeightHigh(false)
  if self.allModelsController ~= nil then
    for k, v in pairs(self.allModelsController) do
      local modelsController = v
      modelsController.role:SetEpNodesDisplay(false)
      modelsController.role:Destroy()
      if modelsController.mount ~= nil then
        modelsController.mount:Destroy()
      end
      if modelsController.falcon ~= nil then
        modelsController.falcon:Destroy()
      end
    end
    self.allModelsController = nil
  end
  self.buffEffSet = nil
end

function RoleReadyForLogin:Reset()
  self:Release()
end
