FunctionCreateRole_v3 = class("FunctionCreateRole_v3")
local defaultSpawnPosition = GameConfig.NewRole.DefaultRolePosition
if defaultSpawnPosition then
  defaultSpawnPosition = LuaVector3.New(defaultSpawnPosition[1], defaultSpawnPosition[2], defaultSpawnPosition[3])
else
  defaultSpawnPosition = LuaVector3.New(-0.433, -983.6, -2.37)
end
local defaultSpawnRotation = GameConfig.NewRole.DefaultRoleRotation
if defaultSpawnRotation then
  defaultSpawnRotation = LuaQuaternion.Euler(defaultSpawnRotation[1], defaultSpawnRotation[2], defaultSpawnRotation[3])
else
  defaultSpawnRotation = LuaQuaternion.Euler(0, 176, 0)
end
local cameraSettings = {}
local cameraConfigs = GameConfig.NewRole.CameraSettings
if cameraConfigs then
  for i, config in ipairs(cameraConfigs) do
    local viewports = {}
    for ii, vp in ipairs(config.ViewPorts) do
      viewports[ii] = LuaVector3.New(vp[1], vp[2], vp[3])
    end
    local focusPosition = config.FocusPosition
    cameraSettings[i] = {
      focusPosition = LuaVector3.New(focusPosition[1], focusPosition[2], focusPosition[3]),
      viewports = viewports
    }
  end
else
  cameraSettings[1] = {
    focusPosition = LuaVector3.New(-0.474, -982.217, -2.423),
    viewports = {
      LuaVector3.New(0.39, 0.72, 3.7),
      LuaVector3.New(0.38, 0.53, 1.3)
    }
  }
  cameraSettings[2] = {
    focusPosition = LuaVector3.New(-0.474, -982.217, -2.423),
    viewports = {
      LuaVector3.New(0.39, 0.72, 3.7),
      LuaVector3.New(0.38, 1.2, 1.4)
    }
  }
end
local cameraFocusDuration = cameraConfig and cameraConfig.FocusDuration or 0.3

function FunctionCreateRole_v3.Me()
  if nil == FunctionCreateRole_v3.me then
    FunctionCreateRole_v3.me = FunctionCreateRole_v3.new()
  end
  return FunctionCreateRole_v3.me
end

function FunctionCreateRole_v3:Launch()
  self:PreProcessHairConfig()
  self:PreProcessEyeConfig()
  self:LoadRoles()
  self:ChangeSelectedRole(1, 1)
  self:InitCamera()
  self:UpdateCameraFocus(0)
  FunctionCameraEffect.LockFov = true
end

function FunctionCreateRole_v3:Shutdown()
  self:Reset()
  self:UnloadRoles()
  self:UnloadConfigs()
  self:DestroyCamera()
  FunctionCameraEffect.LockFov = nil
end

function FunctionCreateRole_v3:PreProcessHairConfig()
  self.hairStyles = {
    [1] = {
      [1] = {},
      [2] = {}
    },
    [2] = {
      [1] = {},
      [2] = {}
    }
  }
  if GameConfig.NewRole.hair then
    for _, id in pairs(GameConfig.NewRole.hair) do
      local v = Table_HairStyle[id]
      if v then
        local race = v.Race
        local gender = v.Sex
        local genders = self.hairStyles[race]
        if genders then
          local styles = genders[gender]
          if styles then
            table.insert(styles, {
              id = v.id,
              Icon = v.Icon
            })
          end
        end
      end
    end
  end
  self.hairColors = {}
  if GameConfig.NewRole.haircolor then
    for _, id in ipairs(GameConfig.NewRole.haircolor) do
      local v = Table_HairColor[id]
      if v then
        table.insert(self.hairColors, {
          id = v.id,
          Color = v.Color
        })
      end
    end
  end
end

function FunctionCreateRole_v3:PreProcessEyeConfig()
  self.eyeStyles = {
    [1] = {
      [1] = {},
      [2] = {}
    },
    [2] = {
      [1] = {},
      [2] = {}
    }
  }
  self.eyeColors = {}
  if GameConfig.NewRole.eye then
    for k, _ in pairs(GameConfig.NewRole.eye) do
      local eyeConfig = Table_Eye[k]
      if eyeConfig then
        local race = eyeConfig.Race
        local gender = eyeConfig.Sex
        local genders = self.eyeStyles[race]
        if genders then
          local styles = genders[gender]
          if styles then
            local colorStyle = self.eyeColors[k]
            if not colorStyle then
              colorStyle = {}
              self.eyeColors[k] = colorStyle
            end
            local eyeColor = eyeConfig.ShopEyeColor and eyeConfig.ShopEyeColor[1]
            if eyeColor then
              table.insert(colorStyle, {id = k, Color = eyeColor})
            end
            local iconColor = eyeConfig.EyeColor and eyeConfig.EyeColor[1]
            table.insert(styles, {
              id = k,
              Icon = eyeConfig.Icon,
              Color = iconColor
            })
          end
        end
      end
    end
  end
  for _, v in pairs(Table_Eye) do
    local colorStyle = self.eyeColors[v.StyleID]
    if colorStyle and not GameConfig.NewRole.eye[v.id] then
      local eyeColor = v.ShopEyeColor and v.ShopEyeColor[1]
      if eyeColor then
        table.insert(colorStyle, {
          id = v.id,
          Color = v.ShopEyeColor[1]
        })
      end
    end
  end
end

function FunctionCreateRole_v3:GetSelectedHairStyleConfigs()
  if not self.selectedRole then
    return
  end
  local raceIndex = self.selectedRaceIndex
  local genderIndex = self.selectedGenderIndex
  local genders = self.hairStyles[raceIndex]
  return genders and genders[genderIndex], self.selectedRole.selectedHairStyleId
end

function FunctionCreateRole_v3:GetSelectedHairColorConfigs()
  if not self.selectedRole then
    return
  end
  return self.hairColors, self.selectedRole.selectedHairColorId
end

function FunctionCreateRole_v3:GetSelectedEyeStyleConfigs()
  if not self.selectedRole then
    return
  end
  local raceIndex = self.selectedRaceIndex
  local genderIndex = self.selectedGenderIndex
  local genders = self.eyeStyles[raceIndex]
  return genders and genders[genderIndex], self.selectedRole.selectedEyeStyleId
end

function FunctionCreateRole_v3:GetSelectedEyeColorConfigs()
  if not self.selectedRole then
    return
  end
  return self.eyeColors[self.selectedRole.selectedEyeStyleId], self.selectedRole.selectedEyeColorId
end

function FunctionCreateRole_v3:UnloadConfigs()
  self.hairStyles = nil
  self.eyeColors = nil
  self.eyeStyles = nil
end

function FunctionCreateRole_v3:LoadRoles()
  if self.races then
    return
  end
  self.races = {}
  local roleOptions = GameConfig.NewRole.RoleOptions
  for k, v in ipairs(roleOptions) do
    local roles = {}
    local male = {}
    male.npcid = v.maleid
    male.action = v.maction
    self:LoadAsset(male)
    table.insert(roles, male)
    local female = {}
    female.npcid = v.femaleid
    female.action = v.faction
    self:LoadAsset(female)
    table.insert(roles, female)
    table.insert(self.races, roles)
  end
end

function FunctionCreateRole_v3:LoadAsset(role)
  local id = role.npcid
  local config = Table_Npc[id]
  local partIndex = Asset_Role.PartIndex
  local parts = Asset_Role.CreatePartArray()
  for k, v in pairs(partIndex) do
    local val = config[k]
    if val then
      parts[v] = val
    end
  end
  role.bodyColor = config.BodyDefaultColor or 0
  role.selectedHairStyleId = config.Hair or 0
  local hairConfig = Table_HairStyle[role.selectedHairStyleId]
  role.selectedHairColorId = config.HeadDefaultColor or 0
  role.selectedEyeColorId = config.Eye or 0
  local eyeConfig = Table_Eye[role.selectedEyeColorId]
  role.selectedEyeStyleId = eyeConfig and eyeConfig.StyleID or 0
  parts[Asset_Role.PartIndexEx.HairColorIndex] = role.selectedHairColorId
  parts[Asset_Role.PartIndexEx.Download] = true
  local model = Asset_Role.Create(parts, Game.AssetManager_Role, function(assetRole, args)
    args.created = true
    assetRole:SetInvisible(self:GetSelectedRole() ~= args)
  end, role)
  Asset_Role.DestroyPartArray(parts)
  model:SetInvisible(true)
  role.assetRole = model
end

function FunctionCreateRole_v3:UnloadRoles()
  if self.races then
    for _, race in ipairs(self.races) do
      for _, role in ipairs(race) do
        if role and role.assetRole then
          role.assetRole:Destroy()
        end
      end
    end
  end
  self.races = nil
end

function FunctionCreateRole_v3:GetRole(raceIndex, genderIndex)
  if not (raceIndex and genderIndex) or not self.races then
    return nil
  end
  local roles = self.races[raceIndex]
  if not roles then
    return nil
  end
  return roles[genderIndex]
end

function FunctionCreateRole_v3:Init()
end

function FunctionCreateRole_v3:Reset()
  self.selectedRaceIndex = nil
  self.selectedGenderIndex = nil
  self.selectedDressingTabIndex = nil
  self.selectedRole = nil
end

function FunctionCreateRole_v3:InitCamera()
  local cameraCtrl = CameraController.Instance or CameraController.singletonInstance
  if cameraCtrl then
    self:DoInitCamera(cameraCtrl)
  else
    self:StartInitCameraTick()
  end
  self.selectedDressingTabIndex = 1
end

function FunctionCreateRole_v3:DoInitCamera(cameraCtrl)
  if not cameraCtrl then
    return
  end
  local fakeFocusTarget = GameObject("FakeFocusTarget")
  self.fakeFocusTransform = fakeFocusTarget.transform
  cameraCtrl:SetDefault()
  cameraCtrl.activeCamera.transform.rotation = LuaQuaternion.Identity()
end

function FunctionCreateRole_v3:DestroyCamera()
  if self.fakeFocusTransform then
    LuaGameObject.DestroyGameObject(self.fakeFocusTransform)
    self.fakeFocusTransform = nil
  end
  self:StopInitCameraTick()
end

function FunctionCreateRole_v3:StartInitCameraTick()
  if not self.initCameraTimer then
    self.initCameraTimer = TimeTickManager.Me():CreateTick(0, 1, function()
      local cameraCtrl = CameraController.Instance or CameraController.singletonInstance
      if cameraCtrl then
        self:DoInitCamera(cameraCtrl)
        self:StopInitCameraTick()
        self:UpdateCameraFocus(0)
      end
    end, self)
  end
end

function FunctionCreateRole_v3:StopInitCameraTick()
  if self.initCameraTimer then
    self.initCameraTimer:Destroy()
    self.initCameraTimer = nil
  end
end

function FunctionCreateRole_v3:UpdateCameraFocus(duration)
  if not self.fakeFocusTransform then
    return
  end
  duration = duration or 0
  local cameraSetting = cameraSettings[self.selectedRaceIndex]
  if not cameraSetting or not cameraSetting.viewports then
    return
  end
  local viewport = cameraSetting.viewports[self.selectedDressingTabIndex or 1]
  if not viewport then
    return
  end
  self.fakeFocusTransform.position = cameraSetting.focusPosition
  local cameraCtrl = CameraController.Instance or CameraController.singletonInstance
  if cameraCtrl then
    cameraCtrl:FocusTo(self.fakeFocusTransform, viewport, duration, nil, false)
  end
end

function FunctionCreateRole_v3:ChangeDressingTab(newTabIndex)
  if self.selectedDressingTabIndex == newTabIndex then
    return
  end
  self.selectedDressingTabIndex = newTabIndex
  self:UpdateCameraFocus(cameraFocusDuration)
end

function FunctionCreateRole_v3:GetSelectedRole()
  return self.selectedRole
end

function FunctionCreateRole_v3:IsDoramSelected()
  return self.selectedRaceIndex == 2
end

function FunctionCreateRole_v3:ChangeSelectedRole(newRaceIndex, newGenderIndex)
  if self.selectedRaceIndex == newRaceIndex and self.selectedGenderIndex == newGenderIndex then
    return false
  end
  local newRole = self:GetRole(newRaceIndex, newGenderIndex)
  if not newRole then
    return false
  end
  newRole.assetRole:SetInvisible(false)
  newRole.assetRole:SetPosition(defaultSpawnPosition)
  if self.selectedRole then
    newRole.assetRole:SetRotation(self.selectedRole.assetRole.completeTransform.rotation)
    self.selectedRole.assetRole:SetInvisible(true)
  else
    newRole.assetRole:SetRotation(defaultSpawnRotation)
  end
  if newRole.action then
    local actionParams = Asset_Role.GetPlayActionParams(newRole.action, "wait", 1)
    actionParams[6] = 1
    actionParams[7] = function()
      local params = Asset_Role.GetPlayActionParams("wait", "wait", 1)
      params[6] = 1
      newRole.assetRole:PlayActionRaw(params)
    end
    newRole.assetRole:PlayActionRaw(actionParams)
  end
  self.selectedRole = newRole
  self.selectedRaceIndex = newRaceIndex
  self.selectedGenderIndex = newGenderIndex
  self:UpdateCameraFocus(cameraFocusDuration)
  return true
end

function FunctionCreateRole_v3:ChangeRace(newRaceIndex)
  if not self:ChangeSelectedRole(newRaceIndex, self.selectedGenderIndex) then
    return false
  end
  return true
end

function FunctionCreateRole_v3:ChangeGender(newGenderIndex)
  if not self:ChangeSelectedRole(self.selectedRaceIndex, newGenderIndex) then
    return false
  end
  return true
end

function FunctionCreateRole_v3:ChangeHairStyle(newId)
  if not self.selectedRole or not self.selectedRole.created then
    return false
  end
  local lastSelectedId = self.selectedRole.selectedHairStyleId
  if lastSelectedId == newId then
    return false
  end
  self.selectedRole.assetRole:RedressPart(Asset_Role.PartIndex.Hair, newId)
  self.selectedRole.selectedHairStyleId = newId
  local hairConfig = Table_HairStyle[newId]
  if hairConfig and hairConfig.DefaultIconColor then
    self:ChangeHairColor(hairConfig.DefaultIconColor)
  end
  return true
end

function FunctionCreateRole_v3:ChangeHairColor(newId)
  if not self.selectedRole or not self.selectedRole.created then
    return false
  end
  local lastSelectedId = self.selectedRole.selectedHairColorId
  if lastSelectedId == newId then
    return false
  end
  self.selectedRole.assetRole:SetHairColor(newId)
  self.selectedRole.selectedHairColorId = newId
  return true
end

function FunctionCreateRole_v3:ChangeEyeStyle(newId)
  if not self.selectedRole or not self.selectedRole.created then
    return false
  end
  local lastSelectedId = self.selectedRole.selectedEyeStyleId
  if lastSelectedId == newId then
    return false
  end
  self.selectedRole.assetRole:RedressPart(Asset_Role.PartIndex.Eye, newId)
  self.selectedRole.selectedEyeStyleId = newId
  self.selectedRole.selectedEyeColorId = newId
  return true
end

function FunctionCreateRole_v3:ChangeEyeColor(newId)
  if not self.selectedRole or not self.selectedRole.created then
    return false
  end
  local lastSelectedId = self.selectedRole.selectedEyeColorId
  if lastSelectedId == newId then
    return false
  end
  self.selectedRole.assetRole:RedressPart(Asset_Role.PartIndex.Eye, newId)
  self.selectedRole.selectedEyeColorId = newId
  return true
end

function FunctionCreateRole_v3:RotateRole(delta)
  if self.selectedRole then
    self.selectedRole.assetRole:RotateDelta(delta)
  end
end

function FunctionCreateRole_v3:SendCreateRoleReq(nameUTF8, roleSlotIndex)
  if not self.selectedRole then
    return
  end
  local gender = self.selectedGenderIndex == 1 and ProtoCommon_pb.EGENDER_MALE or ProtoCommon_pb.EGENDER_FEMALE
  local profession = self.selectedRaceIndex == 1 and 1 or 150
  local hair = self.selectedRole.selectedHairStyleId or 0
  local hairColor = self.selectedRole.selectedHairColorId or 0
  local eye = self.selectedRole.selectedEyeColorId or 0
  local bodyColor = self.selectedRole.bodyColor or 0
  FunctionLogin.Me():createRole(nameUTF8, gender, profession, hair, hairColor, bodyColor, roleSlotIndex, eye)
end
