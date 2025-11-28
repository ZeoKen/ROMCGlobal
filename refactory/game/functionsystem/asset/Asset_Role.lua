autoImport("Table_DoramAvatar")
autoImport("Table_MercenaryCatAvatar")
local IS_RUNON_EDITOR = ApplicationInfo.IsRunOnEditor()
Asset_Role = class("Asset_Role", ReusableObject)
local FindCreature = SceneCreatureProxy.FindCreature
Asset_Role.ExpressionSwitch = false
Asset_Role.DefaultExpressionID = 1
local LoadStates = {Loading = 1, WaitMount = 2}
if not Asset_Role.Asset_Role_Inited then
  Asset_Role.PoolSize = 100
  Asset_Role.Gender = {Male = 1, Female = 2}
  Asset_Role.PartIndex = {
    Body = 1,
    Hair = 2,
    LeftWeapon = 3,
    RightWeapon = 4,
    Head = 5,
    Wing = 6,
    Face = 7,
    Tail = 8,
    Eye = 9,
    Mouth = 10,
    DefaultTail = 11,
    Mount = 12
  }
  Asset_Role.PartIndexEx = {
    Gender = 13,
    HairColorIndex = 14,
    EyeColorIndex = 15,
    SmoothDisplay = 16,
    BodyColorIndex = 17,
    LoadFirst = 18,
    SheathDisplay = 19,
    Layer = 20,
    SkinQuality = 21,
    MySelf = 22,
    Download = 23,
    DefaultBody = 24,
    DefaultMount = 25,
    DefaultHair = 26,
    DefaultEye = 27,
    DefaultLeftWeapon = 28,
    DefaultRightWeapon = 29,
    DefaultAll = 30,
    MountPart = 12000,
    MountPart0 = 12001,
    MountPart1 = 12002,
    MountPart2 = 12003,
    MountPart3 = 12004,
    MountColorIndex = 1200000,
    MountPart0ColorIndex = 1200001,
    MountPart1ColorIndex = 1200002,
    MountPart2ColorIndex = 1200003,
    MountPart3ColorIndex = 1200004
  }
  setmetatable(Asset_Role.PartIndexEx, {
    __index = Asset_Role.PartIndex
  })
  Asset_Role.PartCount = 12
  Asset_Role.ValidSubPartIndexMap = {
    [Asset_Role.PartIndex.Mount] = {
      Asset_Role.PartIndexEx.MountPart0,
      Asset_Role.PartIndexEx.MountColorIndex,
      Asset_Role.PartIndexEx.MountPart0ColorIndex,
      Asset_Role.PartIndexEx.MountPart1,
      Asset_Role.PartIndexEx.MountPart2,
      Asset_Role.PartIndexEx.MountPart3,
      Asset_Role.PartIndexEx.MountPart1ColorIndex,
      Asset_Role.PartIndexEx.MountPart2ColorIndex,
      Asset_Role.PartIndexEx.MountPart3ColorIndex
    }
  }
  Asset_Role.PartIndexUserDataMap = {
    [Asset_Role.PartIndex.Body] = UDEnum.BODY,
    [Asset_Role.PartIndex.Hair] = UDEnum.HAIR,
    [Asset_Role.PartIndex.LeftWeapon] = UDEnum.LEFTHAND,
    [Asset_Role.PartIndex.RightWeapon] = UDEnum.RIGHTHAND,
    [Asset_Role.PartIndex.Head] = UDEnum.HEAD,
    [Asset_Role.PartIndex.Wing] = UDEnum.BACK,
    [Asset_Role.PartIndex.Face] = UDEnum.FACE,
    [Asset_Role.PartIndex.Tail] = UDEnum.TAIL,
    [Asset_Role.PartIndex.Eye] = UDEnum.EYE,
    [Asset_Role.PartIndex.Mouth] = UDEnum.MOUTH,
    [Asset_Role.PartIndex.Mount] = UDEnum.MOUNT
  }
  Asset_Role.SubPartStartIndex = 1000
  Asset_Role.SubPartEndIndex = 99999
  Asset_Role.SubPartColorStartIndex = 100000
  Asset_Role.SubPartColorEndIndex = 1299999
  Asset_Role.ActionName = {
    Idle = "wait",
    IdleHandIn = "wait_HandIn",
    IdleInHand = "wait_InHand",
    IdleHold = "wait_HoldPet",
    IdleBeHolded = "wait_BeHold",
    Move = "walk",
    MoveHandIn = "walk_HandIn",
    MoveInHand = "walk_InHand",
    MoveHold = "walk_HoldPet",
    MoveBeHolded = "walk_BeHold",
    Sitdown = "sit_down",
    AttackIdle = "attack_wait",
    Attack = "attack",
    Hit = "hit",
    Die = "die",
    PlayShow = "playshow",
    Photograph = "shooting",
    Born = "born",
    UseMagic = "use_magic",
    UseMagic2 = "use_magic2",
    FunctionalShow = "functional_show",
    FunctionalShow2 = "functional_show2",
    Transform_F1_to_F2 = "transform_f1_to_f2",
    Transform_F2_to_F1 = "transform_f2_to_f1"
  }
  Asset_Role.ActionPrefix_Mount = "ride"
  Asset_Role.ActionPrefix_Moto = "motor"
  Asset_Role.ActionPrefix_Double_Motor = "double_motor"
  Asset_Role.ActionPrefix_RideShoulder = "back"
  Asset_Role.BodyType = {
    Doram_Old = 1,
    Doram_New = 2,
    Human_New = 3,
    Max = 100
  }
  Asset_Role.NotifyEvent = {
    Invisible = "AssetRole_Invisible",
    PartCreated = "AssetRole_PartCreated"
  }
  Asset_Role.LoadPriority = {
    [Asset_Role.PartIndex.Body] = 1000,
    [Asset_Role.PartIndex.Hair] = 1000,
    [Asset_Role.PartIndex.Head] = 1000,
    [Asset_Role.PartIndex.Face] = 1000,
    [Asset_Role.PartIndex.Eye] = 1000
  }
  Asset_Role.Asset_Role_Inited = true
end
local Table_Body = Table_Body
local Table_Eye = Table_Eye
local Table_MercenaryCatAvatar = Table_MercenaryCatAvatar
local Table_DoramAvatar = Table_DoramAvatar
local Table_ActionAnime = Table_ActionAnime
local Table_HairStyle = Table_HairStyle
local Table_RolePartOffset
local NotifyEventArgs = {}
local WeddingSuitBodyIdMap
local PartIndex = Asset_Role.PartIndexEx
local PartCount = Asset_Role.PartCount
local ActionName = Asset_Role.ActionName
local ActionPrefix_Mount = Asset_Role.ActionPrefix_Mount
local ActionPrefix_Moto = Asset_Role.ActionPrefix_Moto
local NotifyEvent = Asset_Role.NotifyEvent
local LoadPriority = Asset_Role.LoadPriority
local ActionPrefix_Double_Motor = Asset_Role.ActionPrefix_Double_Motor
local SubPartStartIndex = Asset_Role.SubPartStartIndex
local SubPartEndIndex = Asset_Role.SubPartEndIndex
local SubPartColorStartIndex = Asset_Role.SubPartColorStartIndex
local SubPartColorEndIndex = Asset_Role.SubPartColorEndIndex
local IsMainPartIndex = function(index)
  if index and 1 <= index and index <= PartCount then
    return true
  end
  return false
end
Asset_Role.IsMainPartIndex = IsMainPartIndex
local IsSubPartIndex = function(index)
  if index and index >= SubPartStartIndex and index <= SubPartEndIndex then
    return true
  end
  return false
end
Asset_Role.IsSubPartIndex = IsSubPartIndex
local IsSubPartColorIndex = function(index)
  return index and index >= SubPartColorStartIndex and index <= SubPartColorEndIndex or false
end
Asset_Role.IsSubPartColorIndex = IsSubPartColorIndex
local DecodeSubPartIndex = function(index)
  return index // 1000, index % 1000
end
Asset_Role.DecodeSubPartIndex = DecodeSubPartIndex
local EncodeSubPartIndex = function(mainPartIndex, subPartIndex)
  return mainPartIndex * 1000 + subPartIndex
end
Asset_Role.EncodeSubPartIndex = EncodeSubPartIndex
local GetSubPartStartIndex = function(partIndex)
  return partIndex // 1000 * 1000
end
Asset_Role.GetSubPartStartIndex = GetSubPartStartIndex
local GetMainPartIndex = function(partIndex)
  return partIndex // 1000
end
Asset_Role.GetMainPartIndex = GetMainPartIndex
local GetSubPartIndex = function(partIndex)
  return partIndex % 1000
end
Asset_Role.GetSubPartIndex = GetSubPartIndex
local TryGetMainPartIndex = function(partIndex)
  local mainPartIndex = partIndex
  if IsSubPartIndex(partIndex) then
    local mainPart = Asset_Role.GetMainPartIndex(partIndex)
    mainPartIndex = EncodeSubPartIndex(mainPart, 0)
  end
  return mainPartIndex
end
Asset_Role.TryGetMainPartIndex = TryGetMainPartIndex
local EncodePartColorIndex = function(mainPartIndex, subPartIndex)
  return mainPartIndex * 100000 + subPartIndex
end
Asset_Role.EncodePartColorIndex = EncodePartColorIndex
local DecodePartColorIndex = function(partIndex)
  return partIndex // 100000, partIndex % 100000
end
Asset_Role.DecodePartColorIndex = DecodePartColorIndex
local IsNull = Slua.IsNull
local ShowWeaponTypeKey = {
  [1] = "ShowWeapon_1",
  [2] = "ShowWeapon_2",
  [3] = "ShowWeapon_3",
  [4] = "ShowWeapon_4",
  [5] = "ShowWeapon_5",
  [6] = "ShowWeapon_6"
}
local WeakDataKeys = {ActionEffect = 1}
local SuperAction = {
  [ActionName.Idle] = 1,
  [ActionName.Move] = 2,
  [ActionName.Hit] = 3,
  [ActionName.AttackIdle] = 4
}
local ReplaceDefault = {
  [PartIndex.Body] = PartIndex.DefaultBody,
  [PartIndex.Hair] = PartIndex.DefaultHair,
  [PartIndex.LeftWeapon] = PartIndex.DefaultLeftWeapon,
  [PartIndex.RightWeapon] = PartIndex.DefaultRightWeapon,
  [PartIndex.Eye] = PartIndex.DefaultEye,
  [PartIndex.Mount] = PartIndex.DefaultMount
}
local ActionSEKeys = {
  [ActionName.Idle] = "StandSE",
  [ActionName.Move] = "WalkSE",
  [ActionName.Attack] = "AttackSE",
  [ActionName.Hit] = "BeHitSE",
  [ActionName.Die] = "DieSE"
}
local RolePartShaderName = "RO/Role/PartOutline"
local IsDoram = function(bodyID)
  if bodyID ~= nil and 0 < bodyID then
    local bodyData = Table_Body[bodyID]
    return bodyData ~= nil and bodyData.AvatarBranch == 1
  end
  return false
end
local IsFileExist = function(index, id)
  local path = Game.AssetManager_Role:GetResPath(index, id)
  return Game.AssetLoadEventDispatcher:IsFileExist(ResourcePathHelper.ResourcePath(path))
end
local ReplaceBaseDefaultParts = function(parts)
  local defaultBody = parts[PartIndex.DefaultBody]
  if defaultBody ~= nil then
    parts[PartIndex.Body] = defaultBody
  end
  local defaultHair = parts[PartIndex.DefaultHair]
  if defaultHair ~= nil then
    parts[PartIndex.Hair] = defaultHair
  end
  local defaultEye = parts[PartIndex.DefaultEye]
  if defaultEye ~= nil then
    parts[PartIndex.Eye] = defaultEye
  end
end
local TryReplaceBaseDefaultParts = function(parts, index)
  local isFileExist
  if parts[PartIndex.Hair] == 0 then
    local defaultHair = parts[PartIndex.DefaultHair]
    if defaultHair ~= nil then
      isFileExist = IsFileExist(index, parts[index]) == 0
      if isFileExist then
        ReplaceBaseDefaultParts(parts)
      end
    end
  end
  if parts[PartIndex.Eye] == 0 then
    local defaultEye = parts[PartIndex.DefaultEye]
    if defaultEye ~= nil then
      if isFileExist == nil then
        isFileExist = IsFileExist(index, parts[index]) == 0
      end
      if isFileExist then
        ReplaceBaseDefaultParts(parts)
      end
    end
  end
end
local ResetSubPartOfMainPart = function(mainPartIndex, parts, force)
  local validSubPartIndexes = Asset_Role.ValidSubPartIndexMap[mainPartIndex]
  if validSubPartIndexes then
    for _, subPartIndex in ipairs(validSubPartIndexes) do
      if force or not parts[subPartIndex] then
        parts[subPartIndex] = 0
      end
    end
  end
end
local ReplaceDefaultPart = function(parts, index)
  local part = parts[index]
  if 0 < part then
    local defaultindex = ReplaceDefault[index]
    if defaultindex ~= nil then
      local default = parts[defaultindex]
      if default ~= nil and IsFileExist(index, part) == 0 then
        parts[index] = default
        ResetSubPartOfMainPart(index, parts, true)
      end
    end
  end
end
local GetBodyType = function(bodytype)
  if bodytype ~= nil and bodytype ~= "" then
    if bodytype == "hf_doram_002" then
      return 1, 1
    elseif bodytype == "hf_doram_001" then
      return 2, 0
    elseif bodytype == "hf_human_002" then
      return 3, 1
    elseif bodytype == "hf_human_001" then
      return 4, 0
    else
      return 0, 0
    end
  else
    return 0, 0
  end
end

function Asset_Role.CreatePartArray()
  local array = ReusableTable.CreateRolePartArray()
  for i = 1, PartCount do
    array[i] = 0
  end
  return array
end

function Asset_Role.DestroyPartArray(array)
  ReusableTable.DestroyRolePartArray(array)
end

function Asset_Role.CreateSubPartTable()
  local tbl = ReusableTable.CreateRolePartTable()
  for i = 1, PartCount do
    tbl[i] = ReusableTable.CreateRolePartTable()
  end
  return tbl
end

function Asset_Role.DestroySubPartTable(tbl)
  for _, subTable in pairs(tbl) do
    ReusableTable.DestroyRolePartTable(subTable)
  end
  ReusableTable.DestroyRolePartTable(tbl)
end

local tempVector3 = LuaVector3.Zero()
local tempPartArray = Asset_Role.CreatePartArray()
local tempPartArray_1 = Asset_Role.CreatePartArray()
local hackAssetManager

function Asset_Role.Create(parts, assetManager, onCreatedCallback, onCreatedCallbackArgs, mountForm)
  hackAssetManager = assetManager
  local args = ReusableTable.CreateArray()
  args[1] = parts
  args[2] = onCreatedCallback
  args[3] = onCreatedCallbackArgs
  args[4] = mountForm
  local obj = ReusableObject.Create(Asset_Role, true, args)
  hackAssetManager = nil
  ReusableTable.DestroyAndClearArray(args)
  return obj
end

local tempPlayActionParams = {
  [1] = nil,
  [2] = nil,
  [3] = 1,
  [4] = 0,
  [5] = false,
  [6] = false,
  [7] = nil,
  [8] = nil,
  [9] = 0,
  [10] = nil,
  [11] = nil,
  [12] = false,
  [13] = 0,
  [14] = false,
  [15] = nil,
  [16] = nil,
  [17] = nil,
  [18] = nil
}

function Asset_Role.GetPlayActionParams(name, defaultName, speed)
  tempPlayActionParams[1] = name
  tempPlayActionParams[2] = defaultName or name
  tempPlayActionParams[3] = speed
  tempPlayActionParams[4] = 0
  tempPlayActionParams[5] = false
  tempPlayActionParams[6] = false
  tempPlayActionParams[7] = nil
  tempPlayActionParams[8] = nil
  tempPlayActionParams[11] = nil
  tempPlayActionParams[12] = false
  tempPlayActionParams[13] = 0
  tempPlayActionParams[14] = false
  tempPlayActionParams[15] = nil
  tempPlayActionParams[16] = nil
  tempPlayActionParams[17] = nil
  tempPlayActionParams[18] = nil
  return tempPlayActionParams
end

function Asset_Role.ClearPlayActionParams(params)
  params[7] = nil
  params[8] = nil
end

function Asset_Role.ApplyMask(parts, mask, index)
  if nil ~= Table_PetAvatar and nil ~= Table_PetAvatar[parts[PartIndex.Body]] then
    return
  end
  if nil == mask then
    return
  end
  if 0 ~= BitUtil.band(mask, 0) then
    parts[PartIndex.Face] = 0
  end
  if 0 ~= BitUtil.band(mask, 1) then
    parts[PartIndex.Hair] = 0
  end
  if 0 ~= BitUtil.band(mask, 2) then
    parts[PartIndex.Mouth] = 0
  end
  if 0 ~= BitUtil.band(mask, 3) then
    parts[PartIndex.Eye] = 0
  end
  if 0 ~= BitUtil.band(mask, 4) then
    parts[PartIndex.Head] = 0
  end
  if 0 ~= BitUtil.band(mask, 5) then
    parts[PartIndex.DefaultTail] = -10086
  end
end

function Asset_Role.ApplyBodyExtraParts(parts)
  local bodyConfig = Table_BodyExtraPart and Table_BodyExtraPart[parts[PartIndex.Body]]
  if not bodyConfig then
    return
  end
  local extraParts = bodyConfig.ExtraParts
  if extraParts then
    for partID, part in pairs(extraParts) do
      if parts[partID] <= 0 then
        parts[partID] = part
      end
    end
  end
  local extraParts = bodyConfig.ForceExtraParts
  if extraParts then
    for partID, part in pairs(extraParts) do
      parts[partID] = part
    end
  end
end

function Asset_Role.PreprocessParts(parts, gender)
  local bodyID = parts[PartIndex.Body]
  if 0 < bodyID then
    local defaultBody = parts[PartIndex.DefaultBody]
    if defaultBody ~= nil and IsFileExist(PartIndex.Body, bodyID) == 0 then
      bodyID = defaultBody
      ReplaceBaseDefaultParts(parts)
    end
    local display = Game.Config_BodyDisplay[bodyID]
    if display then
      Asset_Role.ApplyMask(parts, display, PartIndex.Body)
    end
    Asset_Role.ApplyBodyExtraParts(parts)
    if parts[PartIndex.SheathDisplay] then
      local bodyData = Table_Body[bodyID]
      if bodyData ~= nil then
        local feature = bodyData.Feature
        if feature ~= nil and 0 < feature & FeatureDefines_Body.Fashion then
          local weaponID = parts[PartIndex.RightWeapon]
          if 0 < weaponID then
            local weaponData = Table_Equip[weaponID]
            if weaponData ~= nil and weaponData.SheathID then
              parts[PartIndex.LeftWeapon] = weaponData.SheathID
            end
          end
        end
      end
    end
  end
  local leftWeaponID = parts[PartIndex.LeftWeapon]
  if 0 < leftWeaponID then
    local weaponData = Table_Equip[leftWeaponID]
    if weaponData ~= nil and weaponData.Model == "" then
      parts[PartIndex.LeftWeapon] = 0
    end
  end
  local headID = parts[PartIndex.Head]
  if 0 < headID then
    local headData = Table_Equip[headID]
    if nil ~= headData then
      local display
      if 0 < bodyID and IsDoram(bodyID) then
        display = headData.display and headData.display[2] or headData.display and headData.display[1]
      else
        display = headData.display and headData.display[1]
      end
      Asset_Role.ApplyMask(parts, display, PartIndex.Head)
      local isFileExist
      if 0 ~= parts[PartIndex.Hair] then
        Asset_Role.ProcessSafeHair(parts, gender, headData)
      end
      TryReplaceBaseDefaultParts(parts, PartIndex.Head)
    end
  end
  local faceID = parts[PartIndex.Face]
  if 0 < faceID then
    local faceData = Table_Equip[faceID]
    if nil ~= faceData then
      local display
      if 0 < bodyID and IsDoram(bodyID) then
        display = faceData.display and faceData.display[2]
      else
        display = faceData.display and faceData.display[1]
      end
      Asset_Role.ApplyMask(parts, display, PartIndex.Face)
      Asset_Role.ProcessSafeHair(parts, gender, faceData)
      TryReplaceBaseDefaultParts(parts, PartIndex.Face)
    end
  end
  local tailID = parts[PartIndex.Tail]
  local defaultTailID = parts[PartIndex.DefaultTail]
  if 0 < tailID then
    local logic = Table_RolePartLogic[tailID]
    if logic ~= nil then
      if IsDoram(bodyID) and -1 < defaultTailID then
        parts[PartIndex.DefaultTail] = 400214
      end
    elseif defaultTailID < 0 then
      parts[PartIndex.Tail] = 0
    end
  end
  if defaultTailID < 0 then
    parts[PartIndex.DefaultTail] = 0
  end
  ReplaceDefaultPart(parts, PartIndex.Mount)
  ReplaceDefaultPart(parts, PartIndex.Eye)
  ReplaceDefaultPart(parts, PartIndex.LeftWeapon)
  ReplaceDefaultPart(parts, PartIndex.RightWeapon)
end

local propHairMap = {
  998,
  999,
  997,
  996,
  117,
  118,
  119,
  120
}

function Asset_Role.ProcessSafeHair(parts, gender, data)
  local hairID = parts[PartIndex.Hair]
  local bodyID = parts[PartIndex.Body]
  local invalidHairIDs, hairData = data.HairID, Table_HairStyle[hairID]
  local g = math.clamp((gender or 1) - 1, 0, 1)
  local r = (IsDoram(bodyID) and 1 or 0) << 1
  local f = (hairData and hairData.Feature == FeatureDefines_HairStyle.LongHair and 1 or 0) << 2
  local prop = g + r + f
  if nil ~= invalidHairIDs and 0 < #invalidHairIDs and 0 < TableUtility.ArrayFindIndex(invalidHairIDs, hairID) then
    parts[PartIndex.Hair] = propHairMap[prop + 1]
    local specialHairColor = GameConfig.HairColor and GameConfig.HairColor[hairID]
    if nil ~= specialHairColor then
      parts[PartIndex.HairColorIndex] = specialHairColor.model
    end
  end
end

function Asset_Role.ProcessEquipDisplayForbid(parts)
  local config, branch
  local part = parts[PartIndex.Body]
  if part ~= nil and 0 < part then
    config = Table_Body[part]
    branch = config ~= nil and config.AvatarBranch
  end
  if branch ~= nil then
    for i = 1, PartCount do
      part = parts[i]
      if part ~= nil and 0 < part then
        config = Table_Equip[part]
        if config ~= nil and config.DisplayForbid == 1 then
          parts[i] = 0
        end
      end
    end
  end
end

function Asset_Role.ProcessEquipDisplay(parts)
  local config, bodyType
  local part = parts[PartIndex.Body]
  if 0 < part then
    config = Table_Body[part]
    bodyType = config ~= nil and config.BodyType
  end
  if bodyType ~= nil then
    local t = type(bodyType)
    if t == "number" then
      for i = 1, PartCount do
        part = parts[i]
        if 0 < part then
          if i == PartIndex.Eye then
            config = Table_Eye[part]
            if config and config.DefaultColor then
              parts[PartIndex.EyeColorIndex] = config.DefaultColor
            end
          else
            config = Table_EquipDisplay[part]
          end
          if config ~= nil and config.Display then
            parts[i] = config.Display[bodyType] or part
          end
        end
      end
    elseif t == "string" then
      if string.find(bodyType, "hf_") then
        local tempGender = 0
        local bodyData = Table_Body[part]
        local realGender = bodyData and bodyData.Feature and 0 < bodyData.Feature & FeatureDefines_Body.Female
        bodyType, tempGender = GetBodyType(bodyType)
        local eyeIndex = parts[PartIndex.Eye]
        if eyeIndex and 0 < eyeIndex and eyeIndex < 5 and tempGender ~= realGender then
          if bodyType == 1 or bodyType == 2 then
            if tempGender == 1 then
              parts[PartIndex.Eye] = 4
            else
              parts[PartIndex.Eye] = 3
            end
          elseif bodyType == 3 or bodyType == 4 then
            if tempGender == 1 then
              parts[PartIndex.Eye] = 2
            else
              parts[PartIndex.Eye] = 1
            end
          end
        end
        for i = 1, PartCount do
          part = parts[i]
          if 0 < part then
            if i == PartIndex.Eye then
              config = Table_Eye[part]
              if config and config.DefaultColor then
                parts[PartIndex.EyeColorIndex] = config.DefaultColor
              end
            else
              config = Table_EquipDisplay[part]
            end
            if config ~= nil and config.Display then
              parts[i] = config.Display[bodyType] or part
            end
          end
        end
      else
        bodyType = tonumber(bodyType) or 0
        for i = 1, PartCount do
          part = parts[i]
          if 0 < part then
            if i == PartIndex.Eye then
              config = Table_Eye[part]
              if config and config.DefaultColor then
                parts[PartIndex.EyeColorIndex] = config.DefaultColor
              end
            else
              config = Table_EquipDisplay[part]
            end
            if config ~= nil and config.Display then
              parts[i] = config.Display[bodyType] or part
            end
          end
        end
      end
    end
  end
end

function Asset_Role.SetMountSubPart(parts, subPartIndex, partID)
  local partIndex = Asset_Role.EncodeSubPartIndex(Asset_Role.PartIndex.Mount, subPartIndex)
  parts[partIndex] = partID
end

function Asset_Role.SetMountPartColor(parts, subPartIndex, skin)
  local colorIndex = Asset_Role.EncodePartColorIndex(Asset_Role.PartIndex.Mount, subPartIndex)
  parts[colorIndex] = skin
end

function Asset_Role:DontDestroyOnLoad()
  GameObject.DontDestroyOnLoad(self.complete.gameObject)
  self.dontDestroyOnLoad = true
end

function Asset_Role:GetPartID(part)
  return self.partIDs[part]
end

function Asset_Role:GetRealPartID(part)
  return self.realPartIDs[part]
end

function Asset_Role:GetSubPartID(mainPartIndex, subPartIndex)
  if mainPartIndex and subPartIndex and self.subPartIDs then
    local subTbl = self.subPartIDs[mainPartIndex]
    if subTbl then
      return subTbl[subPartIndex]
    end
  end
end

function Asset_Role:GetSubPartIDsOfPart(mainPartIndex)
  if mainPartIndex then
    return self.subPartIDs[mainPartIndex]
  end
end

function Asset_Role:SetSubPartID(mainPartIndex, subPartIndex, resId)
  if mainPartIndex and subPartIndex then
    local subTbl = self.subPartIDs[mainPartIndex]
    if subTbl then
      subTbl[subPartIndex] = resId
    end
  end
end

function Asset_Role:GetRealSubPartID(mainPartIndex, subPartIndex)
  if mainPartIndex and subPartIndex then
    local subTbl = self.realSubPartIDs[mainPartIndex]
    if subTbl then
      return subTbl[subPartIndex]
    end
  end
end

function Asset_Role:SetRealSubPartID(mainPartIndex, subPartIndex, resId)
  if mainPartIndex and subPartIndex then
    local subTbl = self.realSubPartIDs[mainPartIndex]
    if subTbl then
      subTbl[subPartIndex] = resId
    end
  end
end

function Asset_Role:GetRealSubPartIDsOfPart(mainPartIndex)
  if mainPartIndex then
    return self.realSubPartIDs[mainPartIndex]
  end
end

function Asset_Role:GetPartColorIndex(partIndex)
  return self.partColorIndexes[partIndex]
end

function Asset_Role:SetPartColorIndex(partIndex, n)
  self.partColorIndexes[partIndex] = n
end

function Asset_Role:GetWeaponID()
  local weaponID = self.partIDs[PartIndex.RightWeapon]
  if 0 == weaponID then
    weaponID = self.partIDs[PartIndex.LeftWeapon]
  end
  return weaponID
end

function Asset_Role:GetPartObject(part)
  return self.partObjs[part]
end

function Asset_Role:GetRoleComplete()
  return self.complete
end

function Asset_Role:GetEP(epID)
  return self.complete:GetEP(epID)
end

function Asset_Role:GetEPPosition(epID)
  local success, x, y, z = self:GetPositionOfEP(epID)
  if success then
    return x, y, z
  end
end

function Asset_Role:GetEPOrRoot(epID)
  local epTransform = self.complete:GetEP(epID)
  if nil == epTransform then
    return self.completeTransform
  end
  return epTransform
end

function Asset_Role:GetEPOrRootPosition(epID)
  local success, x, y, z = self:GetPositionOfEP(epID)
  return x, y, z
end

function Asset_Role:GetPositionOfEP(epID)
  local data = self.epPositions[epID]
  if data == nil then
    data = ReusableTable.CreateTable()
    self.epPositions[epID] = data
  end
  local frameCount = UnityFrameCount
  if data.frameCount == frameCount then
    return data.success, data.x, data.y, data.z
  end
  data.success, data.x, data.y, data.z = self.complete:GetPositionOfEP_Lua(epID)
  data.frameCount = frameCount
  return data.success, data.x, data.y, data.z
end

function Asset_Role:GetCP(cpID)
  return self.complete:GetCP(cpID)
end

function Asset_Role:GetCPPosition(cpID)
  local success, x, y, z = self.complete:GetPositionOfCP_Lua(cpID)
  if success then
    return x, y, z
  end
end

function Asset_Role:GetCPOrRoot(cpID)
  local cpTransform = self.complete:GetCP(cpID)
  if nil == cpTransform then
    return self.completeTransform
  end
  return cpTransform
end

function Asset_Role:PutInCreatureToCP(cpID, creature, rideShoulderPrefix)
  cpID = cpID or 0
  if not self.cpCreatureMap then
    self.cpCreatureMap = {}
  end
  self.cpCreatureMap[cpID] = creature.data.id
  local parent = self:GetCPOrRoot(cpID)
  if not parent then
    redlog("PutInCreatureToCP return ")
    return false
  end
  if not creature.assetRole then
    redlog("PutInCreatureToCP return ")
    return
  end
  if not creature.assetRole.complete then
    redlog("PutInCreatureToCP return ")
    return
  end
  creature:SetParent(parent)
  if rideShoulderPrefix then
    self.rideShoulderPrefix = rideShoulderPrefix
  end
  return true
end

function Asset_Role:TakeOutCreatureInCP(cpID, newParent)
  if not self.cpCreatureMap then
    return
  end
  local creatureID = self.cpCreatureMap[cpID]
  self.cpCreatureMap[cpID] = nil
  self.rideShoulderPrefix = nil
  local creature = FindCreature(creatureID)
  if not creature then
    return
  end
  if not creature.assetRole then
    return
  end
  if not creature.assetRole.complete then
    return
  end
  creature:SetParent(newParent)
end

function Asset_Role:RefreshCreatureInCP()
  if not self.cpCreatureMap then
    return
  end
  local creature
  for cpID, creatureID in pairs(self.cpCreatureMap) do
    creature = FindCreature(creatureID)
    if creature then
      creature:SetParent(self:GetCPOrRoot(cpID))
    else
      self.cpCreatureMap[cpID] = nil
    end
  end
end

function Asset_Role:ResetCPCreatureMap()
  if not self.cpCreatureMap then
    return
  end
  self.cpCreatureMap = nil
end

function Asset_Role:GetCPOrRootPosition(epID)
  local success, x, y, z = self.complete:GetPositionOfCP_Lua(epID)
  return x, y, z
end

function Asset_Role:GetPartsInfo(parts)
  TableUtility.TableClear(parts)
  local partIDs = self.partIDs
  for i = 1, PartCount do
    parts[i] = partIDs[i]
    local subPartIDs = self.subPartIDs[i]
    if subPartIDs then
      for subIndex, resId in pairs(subPartIDs) do
        local encodedIndex = EncodeSubPartIndex(i, subIndex)
        if encodedIndex then
          parts[encodedIndex] = resId
        end
        local partColorIndex = EncodePartColorIndex(i, subIndex)
        if partColorIndex then
          parts[partColorIndex] = self:GetPartColorIndex(encodedIndex) or 0
        end
      end
    end
  end
  parts[PartIndex.Gender] = self.gender or 0
  parts[PartIndex.HairColorIndex] = self.hairColorIndex or 0
  parts[PartIndex.EyeColorIndex] = self.eyeColorIndex or 0
  parts[PartIndex.BodyColorIndex] = self.bodyColorIndex or 0
  parts[PartIndex.MountColorIndex] = self:GetPartColorIndex(PartIndex.Mount) or 0
  parts[PartIndex.Download] = self.isDownload
end

function Asset_Role:IgnoreHead(ignore)
  self.ignoreHead = ignore
end

function Asset_Role:IgnoreFace(ignore)
  self.ignoreFace = ignore
end

function Asset_Role:ReplaceDefaultAllParts(parts)
  local isAll = parts[PartIndex.DefaultAll]
  if not isAll then
    return
  end
  local part, isReplace
  for i = 1, PartCount do
    part = parts[i]
    if 0 < part and IsFileExist(i, part) == 0 then
      isReplace = true
      break
    end
  end
  if isReplace then
    TableUtility.ArrayShallowCopyWithCount(self.originPartIDs, parts, PartCount)
    for i = 1, PartCount do
      part = parts[i]
      if 0 < part and ReplaceDefault[i] ~= nil then
        local replacePart = parts[ReplaceDefault[i]]
        if replacePart then
          parts[i] = replacePart
        end
      end
    end
  end
end

function Asset_Role:RedressPart(partIndex, partID)
  if self.ignoreHead and PartIndex.Head == partIndex then
    partID = 0
  end
  if self.ignoreFace and PartIndex.Face == partIndex then
    partID = 0
  end
  self:GetPartsInfo(tempPartArray_1)
  if tempPartArray_1[partIndex] == partID then
    return
  end
  tempPartArray_1[partIndex] = partID
  self:Redress(tempPartArray_1)
end

function Asset_Role:RedressParts(partMap)
  if not partMap then
    return
  end
  self:GetPartsInfo(tempPartArray_1)
  local dirty = false
  for partIndex, resId in pairs(partMap) do
    if tempPartArray_1[partIndex] ~= resId then
      tempPartArray_1[partIndex] = resId
      dirty = true
    end
  end
  if dirty then
    self:Redress(tempPartArray_1)
  end
end

function Asset_Role:RedressWithCache(parts)
  local headID = parts[PartIndex.Head]
  if self.ignoreHead then
    parts[PartIndex.Head] = 0
  end
  if self.ignoreFace then
    parts[PartIndex.Face] = 0
  end
  local hairID = parts[PartIndex.Hair]
  local faceID = parts[PartIndex.Face]
  local gender = parts[PartIndex.Gender] or 0
  self:ReplaceDefaultAllParts(parts)
  Asset_Role.ProcessEquipDisplayForbid(parts)
  Asset_Role.PreprocessParts(parts, gender)
  Asset_Role.ProcessEquipDisplay(parts)
  local allInCache = true
  for i = 1, PartCount do
    if 0 ~= parts[i] and 0 >= self.assetManager:GetPartCacheCount(i, parts[i]) then
      allInCache = false
      break
    end
  end
  for i, v in pairs(parts) do
    if IsSubPartIndex(i) and v ~= 0 and 0 >= self.assetManager:GetPartCacheCount(i, parts[i]) then
      allInCache = false
      break
    end
  end
  if allInCache then
    self:_Redress(parts)
  end
  parts[PartIndex.Head] = headID
  parts[PartIndex.Hair] = hairID
  parts[PartIndex.Face] = faceID
  return allInCache
end

function Asset_Role:Redress(parts, isLoadFirst, showLayer)
  local headID = parts[PartIndex.Head]
  if self.ignoreHead then
    parts[PartIndex.Head] = 0
  end
  if self.ignoreFace then
    parts[PartIndex.Face] = 0
  end
  local hairID = parts[PartIndex.Hair]
  local faceID = parts[PartIndex.Face]
  local gender = parts[PartIndex.Gender] or 0
  local eyeID = parts[PartIndex.Eye] or 0
  self:ReplaceDefaultAllParts(parts)
  Asset_Role.ProcessEquipDisplayForbid(parts)
  Asset_Role.PreprocessParts(parts, gender)
  Asset_Role.ProcessEquipDisplay(parts)
  self:_Redress(parts, isLoadFirst, showLayer)
  parts[PartIndex.Head] = headID
  parts[PartIndex.Hair] = hairID
  parts[PartIndex.Face] = faceID
  parts[PartIndex.Eye] = eyeID
end

function Asset_Role:_Redress(parts, isLoadFirst)
  local oldBody = self:GetPartObject(PartIndex.Body)
  local bodyID = parts[PartIndex.Body]
  self.gender = parts[PartIndex.Gender] or 0
  self.needResizePart = IsDoram(bodyID)
  self.needResizeCatPart = nil ~= Table_MercenaryCatAvatar[bodyID]
  self:DestroyAllPartQueue()
  TableUtility.TableClear(tempPartArray)
  TableUtility.TableClear(self.loadState)
  for i = 1, PartCount do
    tempPartArray[i] = self:_SetPartID(i, parts[i])
  end
  for i = 1, PartCount do
    local oldID = tempPartArray[i]
    if parts[i] and parts[i] ~= 0 and oldID then
      self.loadState[i] = LoadStates.Loading
    end
    if oldID then
      ResetSubPartOfMainPart(i, parts)
    end
  end
  for i, resId in pairs(parts) do
    if IsSubPartIndex(i) then
      local mainPartIndex = GetMainPartIndex(i)
      local mainPartResId = self.partIDs[mainPartIndex]
      if mainPartResId and mainPartResId ~= 0 then
        local needLoad, lastResId = self:SetSubPart(i, resId, self.loadState[mainPartIndex])
        tempPartArray[i] = lastResId
        if needLoad then
          self.loadState[i] = LoadStates.Loading
        end
      end
      if mainPartIndex == PartIndex.Mount then
        local subPartIndex = GetSubPartIndex(i)
        local partColor = parts[EncodePartColorIndex(mainPartIndex, subPartIndex)]
        if partColor then
          self:SetPartColor(i, partColor)
        end
      end
    end
  end
  self:SetPartColor(PartIndex.Mount, parts[PartIndex.MountColorIndex] or 0)
  self.isDownload = parts[PartIndex.Download]
  for i = 1, PartCount do
    local oldID = tempPartArray[i]
    if nil ~= oldID then
      self:_CreatePart(i, oldID, isLoadFirst, self.isDownload)
    end
  end
  for i, resId in pairs(parts) do
    if IsSubPartIndex(i) and self.loadState[i] then
      self:CreateSubPart(i, resId, tempPartArray[i], isLoadFirst, self.isDownload)
    end
  end
  self:SetHairColor(parts[PartIndex.HairColorIndex] or 0)
  self:SetEyeColor(parts[PartIndex.EyeColorIndex] or 0)
  self:SetBodyColor(parts[PartIndex.BodyColorIndex] or 0)
  if nil == oldBody and 0 ~= bodyID then
    if self:_CanShowBody() then
      self:_DressHideBody(true)
    else
      self:_DressHideBody(false)
      self:_SmoothShowBody()
    end
  else
    self:_DressHideBody(false)
  end
  Game.LogicManager_RolePart:OnAssetRoleRedressed(self)
  self:ResizeParts()
  self:ResizeCatParts()
  if self.mountStatusChangeCallback then
    self.mountStatusChangeCallback(self.complete.mountEnable)
  end
end

function Asset_Role:SetPartsQuality(quality, setLod)
  self.complete:SetPartsQuality(quality, setLod, true)
end

function Asset_Role:SetSmoothDisplayBody(duration)
  self.smoothShowBody = duration
end

function Asset_Role:SetGUID(guid)
  self.complete.GUID = guid
end

function Asset_Role:GetGUID()
  return self.complete.GUID
end

function Asset_Role:SetClickPriority(p)
  self.complete.clickPriority = p
end

function Asset_Role:SetName(name)
  if IS_RUNON_EDITOR then
    self.complete.name = name
  end
end

function Asset_Role:SetPartColor(partIndex, n)
  if self.ignoreColor then
    return
  end
  local lastColorIndex = self:GetPartColorIndex(partIndex)
  if lastColorIndex == n then
    return
  end
  self:SetPartColorIndex(partIndex, n)
  if self.loadState[partIndex] then
    return
  end
  if IsMainPartIndex(partIndex) then
    if self.complete:SetPartColorIndex(partIndex - 1, n - 1) then
      local partObj = self.complete:GetPart(partIndex - 1)
      if partObj then
        partObj:SwitchColor(n - 1)
      end
    end
  elseif IsSubPartIndex(partIndex) then
    local mainPartIndex, subPartIndex = DecodeSubPartIndex(partIndex)
    local partObj = self.complete:GetSubPart(mainPartIndex - 1, subPartIndex - 1)
    if partObj then
      partObj:SwitchColor(n - 1)
    end
  end
end

function Asset_Role:SetHairColor(n)
  if self.ignoreColor then
    return
  end
  if 0 == n then
    local hairID = self.partIDs[PartIndex.Hair]
    if 0 ~= hairID then
      local data = Table_HairStyle[hairID]
      n = data ~= nil and data.DefaultColor or 0
    end
  end
  if n == self.hairColorIndex then
    return
  end
  self.hairColorIndex = n
  self.complete.hairColorIndex = n - 1
end

function Asset_Role:SetEyeColor(n)
  if self.ignoreColor then
    return
  end
  if 0 == n then
    local eyeID = self.partIDs[PartIndex.Eye]
    if 0 ~= eyeID then
      local data = Table_Eye[eyeID]
      if data ~= nil then
        n = data.DefaultColor
      end
      n = n or 0
    end
  end
  if n == self.eyeColorIndex then
    return
  end
  self.eyeColorIndex = n
  self.complete.eyeColorIndex = n - 1
end

function Asset_Role:SetBodyColor(n)
  if self.ignoreColor then
    return
  end
  if 0 == n then
    local bodyID = self.partIDs[PartIndex.Body]
    if 0 ~= bodyID then
      if Table_Body[bodyID] then
        n = Table_Body[bodyID].DefaultColor or 0
      else
        error("Not Find Body. ID:" .. bodyID)
      end
    end
  end
  if n == self.bodyColorIndex then
    return
  end
  self.bodyColorIndex = n
  if 1 <= n then
    self.complete.bodyColorIndex = n - 1
  end
end

function Asset_Role:SetLayer(layer)
  self.complete.layer = layer
  self:FixSubPartsLayer()
end

function Asset_Role:FixSubPartsLayer()
  local ret, _ = pcall(function()
    return RolePart.isSubPartLayerHandled
  end)
  if ret then
    return
  end
  for mainpartIndex, tbl in pairs(self.realSubPartIDs) do
    if tbl then
      for subPartIndex, resId in pairs(tbl) do
        if resId and resId ~= 0 then
          local partIndex = EncodeSubPartIndex(mainpartIndex, subPartIndex)
          local partObj = self.partObjs[partIndex]
          if partObj then
            partObj.layer = self.complete.layer
          end
        end
      end
    end
  end
end

function Asset_Role:GetInvisible()
  return self.forceInvisible or self.invisible
end

function Asset_Role:SetInvisible(invisible)
  if nil ~= self.forceInvisible then
    self.realInvisible = invisible
    invisible = invisible and self.forceInvisible
  end
  self:_SetInvisible(invisible)
end

function Asset_Role:SetForceInvisible(invisible)
  if self.forceInvisible == invisible then
    return
  end
  self.forceInvisible = invisible
  if nil ~= invisible then
    self.realInvisible = self.invisible
    if not self.realInvisible then
      self:_SetInvisible(invisible)
    end
  else
    self:_SetInvisible(self.realInvisible)
    self.realInvisible = nil
  end
end

function Asset_Role:_SetInvisible(invisible)
  if self.invisible == invisible then
    return
  end
  self.invisible = invisible
  self.complete.shadowInvisible = invisible
  self:SetBodyDisplay(not invisible)
  NotifyEventArgs.event = NotifyEvent.Invisible
  NotifyEventArgs.value = invisible and not self.hideBodyOnly
  self:NotifyObserver(NotifyEventArgs)
end

function Asset_Role:SetHideBodyOnly(val)
  self.hideBodyOnly = val
end

function Asset_Role:SetShadowEnable(enable)
  self.complete.shadowEnable = enable
end

function Asset_Role:SetShadowCastMode(value)
  self.complete.ShadowCastEnable = value
end

function Asset_Role:EnableShadowCastCheck(distance)
  self.complete:EnableShadowCastCheck(distance)
end

function Asset_Role:DisableShadowCastCheck()
  self.complete:DisableShadowCastCheck(distance)
end

function Asset_Role:GetColliderEnable()
  return self.forceColliderEnable or self.complete.colliderEnable
end

function Asset_Role:SetColliderEnable(enable)
  if nil ~= self.forceColliderEnable then
    self.realColliderEnable = enable
    enable = enable and self.forceColliderEnable
  end
  self.complete.colliderEnable = enable
end

function Asset_Role:SetForceColliderEnable(enable)
  if self.forceColliderEnable == enable then
    return
  end
  self.forceColliderEnable = enable
  if nil ~= enable then
    self.realColliderEnable = self.complete.colliderEnable
    if self.realColliderEnable then
      self.complete.colliderEnable = enable
    end
  else
    self.complete.colliderEnable = self.realColliderEnable
    self.realColliderEnable = nil
  end
end

function Asset_Role:ColliderEnable()
  return self.complete.colliderEnable
end

function Asset_Role:SetShowWarnRingEffect()
  self.showWarnRing = true
  if self.complete.body then
    self:CreateWarningRingEffect()
  end
end

function Asset_Role:CreateWarningRingEffect()
  local body = self.complete.body
  if not body or not body.collider then
    return
  end
  if self.warnRing then
    self.warnRing:Destroy()
    self.warnRing = nil
  end
  local colSize = body.collider.size
  if colSize.x > 0 and 0 < colSize.z then
    local size = ReusableTable.CreateTable()
    size.x = colSize.x
    size.y = colSize.z
    self.warnRing = Asset_Effect.CreateWarnRingOn(self.complete.transform, size)
    ReusableTable.DestroyAndClearTable(size)
  end
end

function Asset_Role:BodyDisplaying()
  return self.bodyDisplay and not self.dressHideBody
end

function Asset_Role:SetBodyDisplay(display)
  if self.bodyDisplay == display then
    return
  end
  self.bodyDisplay = display
  if not self.dressHideBody then
    self.complete.invisible = not display
    self:FixSubPartsLayer()
  end
end

function Asset_Role:_DressHideBody(hide)
  if self.dressHideBody == hide then
    return
  end
  self.dressHideBody = hide
  if hide then
    self.complete.invisible = true
    self:FixSubPartsLayer()
  elseif self.bodyDisplay then
    self.complete.invisible = false
    self:FixSubPartsLayer()
  end
end

function Asset_Role:_SmoothShowBody()
  if self:BodyDisplaying() and 0 < self.smoothShowBody then
    self:AlphaFromTo(0, self.alpha, self.smoothShowBody)
  end
end

function Asset_Role:WeaponDisplaying()
  return self.weaponDisplay and not self.actionHideWeapon
end

function Asset_Role:SetWeaponDisplay(display)
  if self.weaponDisplay == display then
    return
  end
  self.weaponDisplay = display
  if not self.actionHideWeapon then
    self.complete.weaponEnable = display
  end
end

function Asset_Role:_ActionHideWeapon(hide)
  if self.actionHideWeapon == hide then
    return
  end
  self.actionHideWeapon = hide
  if hide then
    self.complete.weaponEnable = false
  elseif self.weaponDisplay then
    self.complete.weaponEnable = true
  end
end

function Asset_Role:SetForceShowMount(b)
  self.forceShowMount = b
end

function Asset_Role:MountDisplaying()
  return self.mountDisplay and not self.actionHideMount
end

function Asset_Role:SetMountDisplay(display)
  if self.forceShowMount then
    display = true
  end
  if self.mountDisplay == display then
    return
  end
  self.mountDisplay = display
  if not self.actionHideMount then
    self:SetMountEnable(display)
  end
end

function Asset_Role:SetRideAction(rideAction)
  self.rideAction = rideAction
end

function Asset_Role:_ActionHideMount(hide, force)
  if self.forceShowMount then
    hide = false
  end
  if self.actionHideMount == hide then
    return
  end
  if self.isMoving and hide and not force then
    self.prepareHideMount = true
    return
  end
  self.actionHideMount = hide
  if hide then
    self:SetMountEnable(false)
  elseif self.mountDisplay then
    self:SetMountEnable(true)
  end
end

function Asset_Role:SetWingDisplay(display)
  if self.wingDisplay == display then
    return
  end
  self.wingDisplay = display
  local obj = self.partObjs[PartIndex.Wing]
  if obj ~= nil then
    obj.gameObject:SetActive(display)
  end
end

function Asset_Role:SetTailDisplay(display)
  if self.tailDisplay == display then
    return
  end
  self.tailDisplay = display
  local obj = self.partObjs[PartIndex.Tail]
  if obj ~= nil then
    obj.gameObject:SetActive(display)
  end
end

function Asset_Role:SetActionSpeed(speed)
  if self.actionSpeed == speed then
    return
  end
  self.actionSpeed = speed
  self.complete.actionSpeed = speed
end

function Asset_Role:SetSpeedScale(scale)
  if self.speedScale == scale then
    return
  end
  self.speedScale = scale or 1
  self.complete.actionSpeedScale = self.speedScale
end

function Asset_Role:SetSuffixReplaceMap(suffixReplace)
  self.suffixReplace = suffixReplace
end

function Asset_Role:AddPartForbidAction(part, name)
  local partObj = self.partObjs[part]
  if partObj ~= nil then
    local nameHash = ActionUtility.GetNameHash(name)
    partObj:AddForbidAction(nameHash)
  end
end

function Asset_Role:RemovePartForbidAction(part, name)
  local partObj = self.partObjs[part]
  if partObj ~= nil then
    local nameHash = ActionUtility.GetNameHash(name)
    partObj:RemoveForbidAction(nameHash)
  end
end

function Asset_Role:ClearPartForbidAction(part)
  local partObj = self.partObjs[part]
  if partObj ~= nil then
    partObj:ClearForbidAction()
  end
end

function Asset_Role:IsPlayingActionRaw(name)
  return self.actionRaw == name
end

function Asset_Role:HasActionRaw(name)
  if self.partObjs[PartIndex.Body] == nil then
    return false
  end
  local nameHash = ActionUtility.GetNameHash(name)
  return self.complete and self.complete:HasAction(nameHash)
end

function Asset_Role:PlayActionRaw(params)
  if not params[6] and self.actionRaw == params[1] then
    return
  end
  local name = params[1]
  if nil == name or "" == name then
    name = ActionName.Idle
  end
  local defaultName = params[2]
  if nil == defaultName or "" == defaultName then
    defaultName = ActionName.Idle
  end
  if self.rideShoulderPrefix then
    self.actionRaw = name
  else
    self.actionRaw = name
  end
  self.actionRaw = name
  self.actionRawTime = UnityTime
  self.actionRawDuration = params[10]
  self.actionIsLoop = params[5]
  self.actioncallback = params[16] and params[7] or nil
  self.actioncallbackarg = params[16] and params[8] or nil
  local showWeapon = true
  local bodyID = self:GetPartID(PartIndex.Body)
  if not bodyID then
    return
  end
  if 0 < bodyID then
    local testName = name
    if not self:HasActionRaw(testName) then
      if name ~= defaultName then
        testName = defaultName
        if not self:HasActionRaw(testName) then
          testName = nil
        end
      else
        testName = nil
      end
    end
    if nil ~= testName then
      if Table_Body[bodyID] == nil then
        error("Not Find Body. ID:" .. bodyID)
      end
      local showWeaponType = Table_Body[bodyID].ShowWeaponType
      local key = showWeaponType and ShowWeaponTypeKey[showWeaponType]
      local actionConfig = Game.Config_Action[testName]
      if nil ~= actionConfig then
        showWeapon = key ~= nil and 1 == actionConfig[key]
      end
    end
  end
  if not WeddingSuitBodyIdMap then
    WeddingSuitBodyIdMap = {}
    if GameConfig.Wedding.WeddingSuit then
      for _, body in pairs(GameConfig.Wedding.WeddingSuit) do
        WeddingSuitBodyIdMap[body] = true
      end
    end
  end
  if WeddingSuitBodyIdMap[bodyID] then
    showWeapon = false
  end
  if name == Table_ActionAnime[95].Name then
    showWeapon = true
    self:GetPartsInfo(tempPartArray_1)
    self.tmpLeftWeaponPartIdForProposal = tempPartArray_1[PartIndex.LeftWeapon]
    self.tmpRightWeaponPartIdForProposal = tempPartArray_1[PartIndex.RightWeapon]
    tempPartArray_1[PartIndex.LeftWeapon] = 0
    tempPartArray_1[PartIndex.RightWeapon] = GameConfig.Wedding.FlowerID or 0
    self:Redress(tempPartArray_1, true)
  elseif self.tmpLeftWeaponPartIdForProposal then
    self:GetPartsInfo(tempPartArray_1)
    tempPartArray_1[PartIndex.LeftWeapon] = self.tmpLeftWeaponPartIdForProposal
    tempPartArray_1[PartIndex.RightWeapon] = self.tmpRightWeaponPartIdForProposal
    self:Redress(tempPartArray_1, true)
    self.tmpLeftWeaponPartIdForProposal = nil
    self.tmpRightWeaponPartIdForProposal = nil
  end
  self:SetWeaponDisplay(showWeapon)
  if nil ~= params[3] then
    self.actionSpeed = params[3]
  elseif nil == self.actionSpeed then
    self.actionSpeed = 1
  end
  local nameHash = ActionUtility.GetNameHash(name)
  local defaultNameHash = ActionUtility.GetNameHash(defaultName)
  if self.doActionCbIfBreak then
    self.complete:ActionCallback()
  end
  self.doActionCbIfBreak = params[11]
  local funcPlayAction = params[14] and self.complete.StopBaseAndPlayAction or self.complete.PlayAction
  funcPlayAction(self.complete, nameHash, defaultNameHash, self.actionSpeed, params[4], params[5], params[7], params[8], params[13])
  self:PlayActionEffect(name, bodyID)
  if params[12] == nil or type(params[12]) == "boolean" then
    if not params[12] or not self.curExpressionID then
      self:PlayActionExpression(name)
    end
  elseif type(params[12]) ~= "number" or 0 >= params[12] then
  else
    self:PlayActionExpressionById(params[12], true)
  end
  self:PlayActionSE(self.action)
  if self:IsMountTransformable() and not self.isMountTransforming then
    self:Mount_PlayOwnAction(name, defaultName, self.actionSpeed, params[4])
  end
end

function Asset_Role:MoveActionStopped()
  self.isMoving = false
  if self.prepareHideMount then
    self.prepareHideMount = false
    self:_ActionHideMount(true)
  end
end

function Asset_Role:StopBaseAction()
  self.action = nil
  self.actionRaw = nil
  self.isMoving = false
  self.complete:StopBaseAction()
end

function Asset_Role:StopBlendAction()
  self.complete:StopAction(1)
end

function Asset_Role:PlayActionRaw_Simple(name, defaultName, speed)
  self:PlayActionRaw(Asset_Role.GetPlayActionParams(name, defaultName, speed))
end

function Asset_Role:PlayActionRaw_SimpleLoop(name, defaultName, speed)
  local params = Asset_Role.GetPlayActionParams(name, defaultName, speed)
  params[5] = true
  self:PlayActionRaw(params)
end

function Asset_Role:GetActionSuffix()
  local weaponID = self:GetWeaponID()
  if 0 ~= weaponID then
    if nil == self.tableEquip[weaponID] then
      return nil
    end
    local weaponType = self.tableEquip[weaponID].Type
    if nil ~= weaponType and "" ~= weaponType then
      if self.suffixReplace ~= nil then
        local suffixReplaced = self.suffixReplace[weaponType]
        if nil ~= suffixReplaced and "" ~= suffixReplaced then
          return suffixReplaced
        end
      end
      return weaponType
    end
  end
  return nil
end

function Asset_Role:GetFullAction(name, ignoreMount)
  local namePrefix
  local nameSuffix = self:GetActionSuffix()
  if not ignoreMount and self:MountDisplaying() then
    local mountID = self.partIDs[PartIndex.Mount] or 0
    namePrefix = Asset_Role.GetRidePrefix(mountID)
  elseif nil == nameSuffix then
    return name
  end
  if self.rideShoulderPrefix then
    namePrefix = self.rideShoulderPrefix
    nameSuffix = self.rideShoulderSuffix
  end
  return ActionUtility.BuildName(name, namePrefix, nameSuffix)
end

function Asset_Role.GetRidePrefix(mountID)
  local config = Table_Mount[mountID]
  local interactConfig = Table_InteractMount[mountId]
  if config then
    if config.ActionPrefix and config.ActionPrefix ~= "" then
      return config.ActionPrefix
    elseif config.IsMoto then
      if interactConfig then
        return ActionPrefix_Double_Motor
      else
        return ActionPrefix_Moto
      end
    end
  end
  return ActionPrefix_Mount
end

function Asset_Role:IsPlayingAction(name)
  return self.action == name
end

function Asset_Role:HasAction(name)
  return self:HasActionRaw(self:GetFullAction(name))
end

function Asset_Role:HasActionIgnoreMount(name)
  return self:HasActionRaw(self:GetFullAction(name, true))
end

function Asset_Role:HasPreAction(name)
  local bodyID = self.partIDs[PartIndex.Body]
  if 0 < bodyID and IsDoram(bodyID) then
    local forbidAction = GameConfig.Wedding.DoramForbidAction[name]
    if forbidAction ~= nil and forbidAction[bodyID] == 1 then
      return false
    end
  end
  return self:HasActionRaw(name)
end

function Asset_Role:ConvertActionName(name, ignoreWeapon, ignoreMount)
  local namePrefix
  local nameSuffix = not ignoreWeapon and self:GetActionSuffix() or nil
  local fullName = name
  local noMount = false
  if SuperAction[name] == nil and not self.isMountTransforming and not self.rideAction then
    noMount = true
  end
  local objMount = self.partObjs[PartIndex.Mount]
  local mountID = self.partIDs[PartIndex.Mount] or 0
  local ridePrefix = Asset_Role.GetRidePrefix(mountID)
  if (not noMount or ignoreMount) and nil ~= objMount then
    local tempName = ActionUtility.BuildName(name, ridePrefix)
    if self.actionHideMount then
      if self:HasPreAction(tempName) then
        self:_ActionHideMount(false)
      elseif nil ~= nameSuffix then
        tempName = ActionUtility.BuildName(name, ridePrefix, nameSuffix)
        if self:HasPreAction(tempName) then
          self:_ActionHideMount(false)
          fullName = tempName
          nameSuffix = nil
        end
      end
    elseif not self:HasPreAction(tempName) then
      if nil ~= nameSuffix then
        tempName = ActionUtility.BuildName(name, ridePrefix, nameSuffix)
        if not self:HasPreAction(tempName) then
          self:_ActionHideMount(true, isMoveAction)
        end
      else
        self:_ActionHideMount(true, isMoveAction)
      end
    end
    if self:MountDisplaying() then
      namePrefix = ridePrefix
      fullName = tempName
    end
  else
    self:_ActionHideMount(true, isMoveAction)
  end
  if self.rideShoulderPrefix then
    namePrefix = self.rideShoulderPrefix
    nameSuffix = self.rideShoulderSuffix
  end
  if nil ~= nameSuffix then
    local tempName = ActionUtility.BuildName(name, namePrefix, nameSuffix)
    if self:HasPreAction(tempName) then
      fullName = tempName
    end
  end
  return fullName
end

function Asset_Role:_PrePlayAction(params)
  local isMoveAction = params[1] == ActionName.Move
  if params[13] == 0 then
    self.isMoving = isMoveAction
  end
  if not params[6] and self.action == params[1] then
    return false
  end
  local name = params[1]
  if nil == name or "" == name then
    name = ActionName.Idle
  end
  local defaultName = params[2]
  if nil == defaultName or "" == defaultName then
    defaultName = ActionName.Idle
  end
  self.action = name
  self.actionDefault = defaultName
  self.prepareHideMount = false
  local ignoreWeapon = params[18]
  name = self:ConvertActionName(name, ignoreWeapon)
  if ActionName.Die == params[1] then
    self:StartPlayActionDie()
  else
    self:EndPlayActionDie()
  end
  params[1] = name
  return true
end

function Asset_Role:PlayAction(params)
  if not self:_PrePlayAction(params) then
    return
  end
  if params[17] ~= nil then
    if self.actionParams == nil then
      self.actionParams = ReusableTable.CreateTable()
    end
    TableUtility.TableShallowCopy(self.actionParams, params)
    self.actionParams[17] = params[17] + UnityFrameCount
    return
  elseif self.actionParams ~= nil then
    TableUtility.TableClear(self.actionParams)
  end
  self:PlayActionRaw(params)
end

function Asset_Role:PlayAction_Simple(name, defaultName, speed)
  self:PlayAction(Asset_Role.GetPlayActionParams(name, defaultName, speed))
end

function Asset_Role:PlayAction_SimpleLoop(name, defaultName, speed)
  local params = Asset_Role.GetPlayActionParams(name, defaultName, speed)
  params[5] = true
  self:PlayAction(params)
end

function Asset_Role:PlayAction_Idle()
  self:PlayAction_Simple(ActionName.Idle)
end

function Asset_Role:PlayAction_Move()
  self:PlayAction_Simple(ActionName.Move)
end

function Asset_Role:PlayAction_Sitdown()
  self:PlayAction_Simple(ActionName.Sitdown)
end

function Asset_Role:PlayAction_AttackIdle()
  self:PlayAction_Simple(ActionName.AttackIdle)
end

function Asset_Role:PlayAction_Attack()
  self:PlayAction_Simple(ActionName.Attack)
end

function Asset_Role:PlayAction_Hit()
  self:PlayAction_Simple(ActionName.Hit)
end

function Asset_Role:PlayAction_Die()
  self:PlayAction_Simple(ActionName.Die)
end

function Asset_Role:PlayAction_PlayShow()
  self:PlayAction_Simple(ActionName.PlayShow)
end

function Asset_Role:StartPlayActionDie()
  if self.actionDiePlaying then
    return
  end
  self.actionDiePlaying = true
  self:DoSpectialHeadDie()
end

function Asset_Role:EndPlayActionDie()
  if not self.actionDiePlaying then
    return
  end
  self.actionDiePlaying = false
  self:UndoSpectialHeadDie()
end

function Asset_Role:DoSpectialAssesoryDie_(partID)
  if nil == Table_AssesoriesDie then
    return false
  end
  local partObj = self.partObjs[partID]
  if nil == partObj then
    return false
  end
  local assesoryID = self.partIDs[partID]
  local dieConfig = Table_AssesoriesDie[assesoryID]
  if nil == dieConfig then
    return false
  end
  LuaVector3.Better_Set(tempVector3, 0, 0, 0)
  local bodyID = self.partIDs[PartIndex.Body]
  local bodyConfig = Table_Body[bodyID]
  if nil ~= bodyConfig and nil ~= bodyConfig.AssesoriesDiePoint and #bodyConfig.AssesoriesDiePoint >= 3 then
    LuaVector3.Add(tempVector3, bodyConfig.AssesoriesDiePoint)
  end
  if nil ~= dieConfig.CheepCoordinate and 3 <= #dieConfig.CheepCoordinate then
    LuaVector3.Add(tempVector3, dieConfig.CheepCoordinate)
  end
  local objTransform = partObj.transform
  objTransform.parent = self.completeTransform
  objTransform.localPosition = tempVector3
  objTransform.localRotation = LuaGeometry.Const_V3_zero
  objTransform.localScale = LuaGeometry.Const_V3_one
  return true
end

function Asset_Role:UndoSpectialAssesoryDie_(partID)
  local partObj = self.partObjs[partID]
  if nil == partObj then
    return
  end
  local objTransform = partObj.transform
  if objTransform.parent == self.completeTransform then
    self:ResetPart(objTransform, partID)
  end
end

function Asset_Role:DoSpectialHeadDie()
  local i = 0
  if self:DoSpectialAssesoryDie_(PartIndex.Head) then
    i = i + 1
  end
  if self:DoSpectialAssesoryDie_(PartIndex.Wing) then
    i = i + 1
  end
  if self:DoSpectialAssesoryDie_(PartIndex.Tail) then
    i = i + 1
  end
  self.ignoreLogic = 0 < i
end

function Asset_Role:UndoSpectialHeadDie()
  self.ignoreLogic = nil
  self:UndoSpectialAssesoryDie_(PartIndex.Head)
  self:UndoSpectialAssesoryDie_(PartIndex.Wing)
  self:UndoSpectialAssesoryDie_(PartIndex.Tail)
end

function Asset_Role:NoLogic()
  return self.ignoreLogic
end

function Asset_Role:SetParent(p, worldPositionStays)
  worldPositionStays = worldPositionStays or false
  self.completeTransform:SetParent(p, worldPositionStays)
  if self.dontDestroyOnLoad then
    GameObject.DontDestroyOnLoad(self.complete.gameObject)
  end
end

function Asset_Role:SetPosition(p)
  self.complete:SetLocalPosition(p)
end

function Asset_Role:RefreshLightMapColor()
  for _, part in pairs(self.partObjs) do
    if not Slua.IsNull(part) then
      part:RefreshLightMapColor()
    end
  end
end

function Asset_Role:SetRotation(quaternion)
  self.completeTransform.localRotation = quaternion
end

function Asset_Role:SetEulerAngles(p)
  self.completeTransform.localEulerAngles = p
end

function Asset_Role:SetEulerAngleY(v)
  LuaVector3.Better_Set(tempVector3, 0, v, 0)
  self.completeTransform.localEulerAngles = tempVector3
end

function Asset_Role:SetScale(scale)
  LuaVector3.Better_Set(tempVector3, scale, scale, scale)
  self.completeTransform.localScale = tempVector3
end

function Asset_Role:SetScaleXYZ(x, y, z)
  LuaVector3.Better_Set(tempVector3, x, y, z)
  self.completeTransform.localScale = tempVector3
end

function Asset_Role:RotateTo(p)
  LuaGameObject.LocalRotateToByAxisY(self.completeTransform, p)
end

function Asset_Role:RotateDelta(delta)
  LuaGameObject.LocalRotateDeltaByAxisY(self.completeTransform, delta)
end

function Asset_Role:GetPositionXYZ()
  return LuaGameObject.GetPosition(self.completeTransform)
end

function Asset_Role:GetEulerAnglesXYZ()
  return LuaGameObject.GetEulerAngles(self.completeTransform)
end

function Asset_Role:GetScaleXYZ()
  return LuaGameObject.GetScale(self.completeTransform)
end

function Asset_Role:TransformPoint(p, ret)
  ret:Set(LuaGameObject.TransformPoint(self.completeTransform, p))
end

function Asset_Role:InverseTransformPoint(p, ret)
  ret:Set(LuaGameObject.InverseTransformPointByVector3(self.completeTransform, p))
end

function Asset_Role:PlayActionEffect(action, bodyID)
  local oldActionEffect = self:GetWeakData(WeakDataKeys.ActionEffect)
  if oldActionEffect ~= nil then
    oldActionEffect:Destroy()
    self:SetWeakData(WeakDataKeys.ActionEffect)
  end
  if 0 < bodyID then
    local configs = Game.Config_ActionEffect[bodyID]
    if configs == nil then
      return
    end
    for i = 1, #configs do
      local config = Table_ActionEffect[configs[i]]
      if config ~= nil and config.NameAction == action then
        local effectConfig = Table_ActionEffectSetUp[config.EffectID]
        if effectConfig ~= nil then
          if effectConfig.Loop == 1 then
            local effect
            if effectConfig.EPFollow == 1 then
              effect = self:PlayEffectOn(effectConfig.Path, effectConfig.EPID, nil, nil, nil, nil, nil, nil, nil, nil, true)
            else
              effect = self:PlayEffectAt(effectConfig.Path, effectConfig.EPID, nil, nil, nil, nil, nil, nil, nil, nil, true)
            end
            self:CreateWeakData()
            self:SetWeakData(WeakDataKeys.ActionEffect, effect)
          elseif effectConfig.EPFollow == 1 then
            self:PlayEffectOneShotOn(effectConfig.Path, effectConfig.EPID, nil, nil, nil, nil, nil, nil, nil, nil, true)
          else
            self:PlayEffectOneShotAt(effectConfig.Path, effectConfig.EPID, nil, nil, nil, nil, nil, nil, nil, nil, true)
          end
        end
      end
    end
  end
end

function Asset_Role:PlayEffectOneShotAt(path, epID, offset, callback, callbackArg, scale, cpID, lodLevel, priority, effectType, delay)
  if self:GetInvisible() and not self.hideBodyOnly then
    return nil
  end
  local parent = self:_GetEffectParent(epID, cpID)
  if parent ~= nil then
    LuaVector3.Better_Set(tempVector3, LuaGameObject.GetPosition(parent))
  else
    LuaVector3.Better_Set(tempVector3, LuaGameObject.GetPosition(self.completeTransform))
  end
  if nil ~= offset then
    LuaVector3.Add(tempVector3, offset)
  end
  local effect = Asset_Effect.PlayOneShotAt(path, tempVector3, callback, callbackArg, scale, lodLevel, priority, effectType, nil, delay)
  return effect
end

local _EffectLoadComplete = function(effectHandle, tempParam, effect)
  local self, epID, cpID, callBack, callbackArg = tempParam[1], tempParam[2], tempParam[3], tempParam[4], tempParam[5]
  if epID ~= 0 or cpID and cpID ~= 0 then
    local parent, noBody = self:_GetEffectParent(epID, cpID)
    if parent ~= nil then
      effect:ResetParent(parent)
    elseif noBody then
      effect:ResetParent(self.complete.tempOwner)
    else
      effect:ResetParent(self.completeTransform)
    end
  else
    effect:ResetParent(self.completeTransform)
  end
  if self:GetInvisible() and not self.hideBodyOnly then
    effect:ResetLayer(self.complete.layer)
  end
  if callBack then
    callBack(effectHandle, callbackArg, effect)
  end
  ReusableTable.DestroyAndClearTable(tempParam)
end

function Asset_Role:PlayEffectOneShotOn(path, epID, offset, callback, callbackArg, scale, cpID, lodLevel, priority, effectType, delay)
  if self:GetInvisible() and not self.hideBodyOnly then
    return nil
  end
  local tempParam = ReusableTable.CreateTable()
  tempParam[1] = self
  tempParam[2] = epID
  tempParam[3] = cpID
  tempParam[4] = callback
  tempParam[5] = callbackArg
  local effect = Asset_Effect.PlayOneShotOn(path, nil, _EffectLoadComplete, tempParam, scale, lodLevel, priority, effectType, nil, delay)
  if nil ~= offset then
    effect:ResetLocalPosition(offset)
  end
  effect:ObserveRole(self, epID, cpID)
  return effect
end

function Asset_Role:PlayEffectAt(path, epID, offset, callback, callbackArg, scale, cpID, lodLevel, priority, effectType, syncAction)
  local x, y, z
  local parent = self:_GetEffectParent(epID, cpID)
  if parent ~= nil then
    x, y, z = LuaGameObject.GetPosition(parent)
  else
    x, y, z = LuaGameObject.GetPosition(self.completeTransform)
  end
  local effect = Asset_Effect.PlayAtXYZ(path, x, y, z, callback, callbackArg, scale, lodLevel, priority, effectType, syncAction)
  if offset ~= nil then
    effect:ResetLocalPosition(offset)
  end
  return effect
end

function Asset_Role:PlayEffectOn(path, epID, offset, callback, callbackArg, scale, cpID, lodLevel, priority, effectType, syncAction)
  local tempParam = ReusableTable.CreateTable()
  tempParam[1] = self
  tempParam[2] = epID
  tempParam[3] = cpID
  tempParam[4] = callback
  tempParam[5] = callbackArg
  local effect = Asset_Effect.PlayOn(path, nil, _EffectLoadComplete, tempParam, scale, lodLevel, priority, effectType, syncAction)
  if nil ~= offset then
    effect:ResetLocalPosition(offset)
  end
  effect:ObserveRole(self, epID, cpID)
  return effect
end

function Asset_Role:_GetEffectParent(epID, cpID)
  if self.partObjs[PartIndex.Body] == nil then
    return nil, true
  end
  if cpID ~= nil and 0 < cpID then
    return self:GetCP(cpID), false
  end
  if epID ~= nil and 0 < epID then
    return self:GetEP(epID), false
  end
  return nil, false
end

function Asset_Role:PlaySEOneShotOn(path, atype, skipCount, delay)
  if delay ~= nil and delay ~= 0 then
    local list = self.waitingSE
    if list == nil then
      list = ReusableTable.CreateTable()
      self.waitingSE = list
    end
    local data = list[path]
    if data == nil then
      data = ReusableTable.CreateTable()
      list[path] = data
    end
    data.atype = atype
    data.skipCount = skipCount
    data.time = UnityTime + delay
    return self.audioSource
  end
  if AudioUtility.IsForceAssetRoleSE2D then
    AudioUtility.PlayOneShot2D_Path(path, atype)
  else
    AudioUtility:PlayOneShotOn(path, self.audioSource, atype or AudioSourceType.ONESHOTSE, skipCount)
  end
  return self.audioSource
end

function Asset_Role:PlaySEOn(path, atype, loop, skipCount)
  self.isLoopSfx = loop
  if loop then
    NSceneUserProxy:AddLoopSfxUser(self:GetGUID())
  end
  if AudioUtility.IsForceAssetRoleSE2D then
    AudioUtility.PlayLoop_At(path, 0, 0, 0, 0, atype)
  else
    AudioUtility:PlayOn(path, self.audioSource, loop, atype or AudioSourceType.ONESHOTSE, skipCount)
  end
  return self.audioSource
end

function Asset_Role:UpdateVolume(volume)
  if self.audioSource and self.isLoopSfx then
    self.audioSource.volume = volume
  end
end

function Asset_Role:ClearWaitingSE()
  if self.waitingSE == nil then
    return
  end
  for k, v in pairs(self.waitingSE) do
    ReusableTable.DestroyAndClearTable(v)
  end
  ReusableTable.DestroyAndClearTable(self.waitingSE)
  self.waitingSE = nil
end

function Asset_Role:PlayActionSE(name)
  if self.partObjs[PartIndex.Body] == nil then
    return
  end
  local bodyID = self.partIDs[PartIndex.Body]
  local config = Table_Body[bodyID]
  if config == nil then
    return
  end
  local param = ActionSEKeys[name]
  local path
  if param then
    path = config[param]
    if path == "" then
      return
    end
  else
    local actionSEConfig = config.ActionSE
    if actionSEConfig and not TableUtil.TableIsEmpty(actionSEConfig) then
      local actionConfig = Game.Config_Action[name]
      if actionConfig and actionSEConfig[actionConfig.id] then
        path = actionSEConfig[actionConfig.id]
      end
    end
  end
  if path and path ~= "" then
    self:PlaySEOneShotOn(path)
  end
end

function Asset_Role:SetSEMaxDistance(distance)
  if self.semaxdistance == distance then
    return
  end
  self.semaxdistance = distance
  self.audioSource.maxDistance = distance
end

function Asset_Role:ResetSEMaxDistance()
  if self.semaxdistance ~= nil then
    self:SetSEMaxDistance(10)
    self.semaxdistance = nil
  end
end

function Asset_Role:CurBodySupportExpression()
  return self.bodyData and self.bodyData.BodyType ~= ""
end

function Asset_Role:GetExpression()
  if self:CurBodySupportExpression() then
    return self.curExpressionID or 1
  end
end

function Asset_Role:SetExpression(expressionID, force)
  if self.ignoreExpression then
    return
  end
  if not force and not Asset_Role.ExpressionSwitch and self.curExpressionID == Asset_Role.DefaultExpressionID and not self.replaceActExpression then
    return
  end
  if not (expressionID ~= self.curExpressionID or force) or expressionID < 1 then
    return
  end
  self.curExpressionID = expressionID
  if not self:CurBodySupportExpression() or self:IsPartFirstLoading(PartIndex.Eye) then
    return
  end
  local body = self:GetPartObject(PartIndex.Body)
  local faceRenderer = self.complete.faceRenderer
  if not faceRenderer or not body then
    return
  end
  if self.isMySelf then
    local lodGroup = faceRenderer.gameObject:GetComponent(LODGroup)
    if lodGroup then
      lodGroup:ForceLOD(0)
    end
  end
  local matID = math.ceil(expressionID / 4)
  local offsetID = math.fmod(expressionID, 4)
  if matID ~= self.curFaceMatID or force then
    local material
    if self.bodyData.BodyType then
      local t = type(self.bodyData.BodyType)
      if t == "number" then
        local bodyType = tonumber(self.bodyData.BodyType) or 0
        local bodyRaceType = bodyType > Asset_Role.BodyType.Max and bodyType or bodyType == Asset_Role.BodyType.Human_New and 2 or 1
        material = self.assetManager:GetFaceMatetial(bodyRaceType, self.bodyData.Feature and 0 < self.bodyData.Feature & FeatureDefines_Body.Female, matID)
      elseif t == "string" then
        if string.find(self.bodyData.BodyType, "hf_") then
          local bodyType = self.bodyData.BodyType
          material = self.assetManager:GetFaceMatetialNew(bodyType, matID)
        else
          local bodyType = tonumber(self.bodyData.BodyType) or 0
          local bodyRaceType = bodyType > Asset_Role.BodyType.Max and bodyType or bodyType == Asset_Role.BodyType.Human_New and 2 or 1
          material = self.assetManager:GetFaceMatetial(bodyRaceType, self.bodyData.Feature and 0 < self.bodyData.Feature & FeatureDefines_Body.Female, matID)
        end
      end
    end
    if not material then
      return
    end
    if matID == 1 then
      body:ReplaceOriginMaterial(material, faceRenderer, 0)
    else
      local children = faceRenderer:GetComponentsInChildren(Renderer)
      if children ~= nil then
        for i = 1, #children do
          body:ReplaceOriginMaterial(material, children[i], 0)
        end
      end
    end
    self:RefreshLightMapColor()
    self.curFaceMatID = matID
  end
  local offset = LuaGeometry.GetTempVector2(math.fmod(offsetID, 2) == 0 and 0.5 or 0, 0 < offsetID and offsetID < 3 and 0 or 0.5)
  if not body:ChangeMaterialOffset(faceRenderer, 0, offset) then
    return
  end
  self:PlayEyeActionByCurExpression()
end

function Asset_Role:PlayActionExpression(name)
  if not self:CurBodySupportExpression() or self.bodyData.Feature and self.bodyData.Feature & FeatureDefines_Body.ForbidActionExpression > 0 then
    return
  end
  local actionConfig = Game.Config_Action[name]
  self:SetExpression(self.replaceActExpression and self.npcDefaultExpression or actionConfig and actionConfig.Expression or 1)
end

function Asset_Role:PlayActionExpressionById(expressionId, force)
  if not self:CurBodySupportExpression() or self.bodyData.Feature and self.bodyData.Feature & FeatureDefines_Body.ForbidActionExpression > 0 then
    return
  end
  self:SetExpression(expressionId or 1, force)
end

function Asset_Role:PlayEyeActionByCurExpression()
  local bodyEye = self:GetPartObject(PartIndex.Eye)
  if not (self.curExpressionID and bodyEye) or self:IsPartFirstLoading(PartIndex.Body) then
    return
  end
  local expressionData = Table_RoleExpression and Table_RoleExpression[self.curExpressionID]
  local name = expressionData and expressionData.EyeAction
  local defaultNameHash = ActionUtility.GetNameHash(ActionName.Idle)
  local nameHash = name and ActionUtility.GetNameHash(name) or defaultNameHash
  bodyEye:PlayAction(nameHash, defaultNameHash)
end

function Asset_Role:Mount_PlayAction(actionid)
  local actionConfig = Table_ActionAnime[actionid]
  local bodyMount = self.complete.mount
  if not actionConfig or not bodyMount then
    return
  end
  local name = actionConfig and actionConfig.Name or ActionName.Idle
  local defaultNameHash = ActionUtility.GetNameHash(ActionName.Idle)
  local nameHash = name and ActionUtility.GetNameHash(name) or defaultNameHash
  self:SetPartHaveOwnAction(PartIndex.Mount, true)
  bodyMount:PlayAction(nameHash, defaultNameHash)
end

function Asset_Role:SetMountForm(newForm)
  self:SetMountTransformStartForm(self:GetMountForm())
  self.mountForm = newForm
end

function Asset_Role:GetMountForm()
  return self.mountForm or 1
end

function Asset_Role:GetMountTransformStartForm()
  return self.mountTransformStartForm
end

function Asset_Role:SetMountTransformStartForm(newForm)
  self.mountTransformStartForm = newForm
end

function Asset_Role:Mount_HasAction(mountPart, nameHash)
  if not mountPart then
    return false
  end
  local animator = mountPart.animators[1]
  if not animator then
    return false
  end
  return animator:HasState(0, nameHash)
end

function Asset_Role:Mount_PlayOwnAction(name, defaultName, speed, normalizedTime)
  local mountPart = self.complete.mount
  if not mountPart or not mountPart.partAction then
    return false
  end
  local nameHash = ActionUtility.GetNameHash(name)
  if not self:Mount_HasAction(mountPart, nameHash) then
    name = ActionName.Idle
    defaultName = ActionName.Idle
  end
  name, defaultName = self:GetMountActionName(name, defaultName)
  nameHash = ActionUtility.GetNameHash(name)
  local defaultNameHash = ActionUtility.GetNameHash(defaultName)
  mountPart:PlayAction(nameHash, defaultNameHash, speed or 1, self.complete.actionSpeedScale or 1, normalizedTime or 0)
end

function Asset_Role:GetMountActionName(name, defaultName)
  local mountForm = self:GetMountForm()
  if mountForm and 1 < mountForm and self:IsMountTransformable() and mountForm == 2 then
    name = name .. "_f2"
    defaultName = defaultName .. "_f2"
  end
  return name, defaultName
end

function Asset_Role:GetMountTransformActionName()
  local mountForm = self:GetMountTransformStartForm() or self:GetMountForm()
  if mountForm == 2 then
    return ActionName.Transform_F2_to_F1
  end
  return ActionName.Transform_F1_to_F2
end

function Asset_Role:Mount_PlayTransformAction(callback, callbackArgs, speed, normalizedTime)
  if not self:IsMountTransformable() then
    return false
  end
  local mountPart = self.complete.mount
  if not mountPart or not mountPart.gameObject.activeInHierarchy then
    return false
  end
  local defaultNameHash = ActionUtility.GetNameHash(ActionName.Idle)
  local actionName = self:GetMountTransformActionName()
  local nameHash = ActionUtility.GetNameHash(actionName)
  self.isMountTransforming = true
  self.lastMountTransformStartForm = self:GetMountTransformStartForm()
  self:SetMountHaveOwnAction(true)
  mountPart:PlayAction(nameHash, defaultNameHash, speed or 1, normalizedTime or 0, callback, callbackArgs)
  return true
end

function Asset_Role:Mount_OnTransformActionFinished()
  if self.isMountTransforming then
    self.isMountTransforming = nil
    self:SetRestoreActionNextFrame(true)
    if self.lastMountTransformStartForm == self:GetMountTransformStartForm() then
      self:SetMountTransformStartForm(self:GetMountForm())
    end
    self.lastMountTransformStartForm = nil
  end
end

function Asset_Role:IsMountTransformable()
  local mountId = self.partIDs[PartIndex.Mount]
  if mountId and EquipInfo.IsMountTransformable(mountId) then
    return true
  end
  return false
end

function Asset_Role:SetMountHaveOwnAction(b)
  if self.partsHaveOwnAction then
    self.partsHaveOwnAction[PartIndex.Mount] = 0
  end
  self:SetPartHaveOwnAction(PartIndex.Mount, b)
end

function Asset_Role:Mount_DetermineOwnAction()
  if self:IsMountTransformable() then
    self:SetMountHaveOwnAction(true)
  else
    self:SetMountHaveOwnAction(false)
  end
end

function Asset_Role:Mount_ResetTransformState()
  self:Mount_OnTransformActionFinished()
  self:Mount_DetermineOwnAction()
  self:SetRestoreActionNextFrame(false)
  self:SetMountTransformStartForm(1)
  self.lastMountTransformStartForm = nil
end

function Asset_Role:SetRenderEnable(enable)
  self.complete.renderEnable = enable
end

function Asset_Role:AlphaTo(alpha, duration)
  alpha = math.clamp(alpha, 0, 1)
  duration = math.max(duration, 0)
  self.alpha = alpha
  self.complete:AlphaTo(alpha, duration)
end

function Asset_Role:AlphaFromTo(fromAlpha, toAlpha, duration)
  fromAlpha = math.clamp(fromAlpha, 0, 1)
  toAlpha = math.clamp(toAlpha, 0, 1)
  duration = math.max(duration, 0)
  self.alpha = toAlpha
  self.complete:AlphaFromTo(fromAlpha, toAlpha, duration)
end

function Asset_Role:ChangeColorTo(color, duration)
  self.complete:ChangeColorTo(color, duration)
end

function Asset_Role:ChangeColorFromTo(fromColor, toColor, duration)
  self.complete:ChangeColorFromTo(fromColor, toColor, duration)
end

function Asset_Role:ActiveMulColor(color)
  self.complete:SetMulColor(true, color)
end

function Asset_Role:DeactiveMulColor()
  self.complete:SetMulColor(false, ColorUtil.NGUIWhite)
end

function Asset_Role:IgnoreTerrainLightColor(ignore)
  self.complete.ignoreTerrainLightColor = ignore
end

function Asset_Role:SetForceDestroy(isForceDestroy)
  self.isForceDestroy = isForceDestroy
end

function Asset_Role:_DestroyPartObject(part, oldID, undress)
  self:DestroySubPartsOfPart(part, undress)
  local oldPartObj = self.partObjs[part]
  self:ReSetEPNode(part)
  self.partObjs[part] = nil
  if nil ~= oldPartObj then
    self:RestoreShader(part, oldPartObj)
    if undress then
      self.complete:SetPart(part - 1, nil, undress)
    end
    if self.skinQuality ~= Asset_RolePart.SkinQuality.Auto then
      oldPartObj:SetPartsQuality(Asset_RolePart.SkinQuality.Auto, false)
    end
    if self.isMySelf and not IsNull(oldPartObj) then
      local lodGroup = oldPartObj.gameObject:GetComponent(LODGroup)
      if lodGroup then
        lodGroup:ForceLOD(-1)
      end
      pcall(function()
        oldPartObj:SetTextureRequestedMipmapLevel(-1)
      end)
    end
    self.assetManager:DestroyPart(part, self.realPartIDs[part], oldPartObj, self.isForceDestroy)
    self.realPartIDs[part] = nil
    if undress then
      if PartIndex.Mount == part then
        if self:MountDisplaying() then
          self:RestoreAction()
        elseif self.isMoving then
          self:PlayAction_Move()
        end
      elseif PartIndex.LeftWeapon == part or PartIndex.RightWeapon == part then
        self:RestoreWeaponAction()
      end
    end
  end
end

function Asset_Role:_CancelLoading(part, oldID)
  self:CancelCreateSubPartsOfPart(part)
  local oldPartLoadTag = self.loadTags[part]
  self.loadTags[part] = nil
  if nil ~= oldPartLoadTag then
    if self.partIDs[part] == oldID then
      self.partIDs[part] = nil
    end
    self.assetManager:CancelCreatePart(part, oldID, oldPartLoadTag)
  end
end

function Asset_Role:_SetPartID(part, ID)
  local oldID = self.partIDs[part]
  if oldID == ID then
    return nil
  end
  self.partIDs[part] = ID
  if PartIndex.Body == part then
    self.lastChangeBodyFrame = UnityFrameCount
  end
  if 0 ~= oldID then
    self:_CancelLoading(part, oldID)
    self.loadState[part] = nil
    if 0 ~= ID then
    else
      if PartIndex.Body == part then
        local oldObj = self.partObjs[part]
        if nil ~= oldObj then
          oldObj:MoveEffectToTransform(self.complete.tempOwner)
        end
      end
      self:_DestroyPartObject(part, nil, true)
    end
  end
  return oldID
end

function Asset_Role:_CreatePart(part, oldID, isLoadFirst, isDownload)
  local ID = self.partIDs[part]
  if 0 ~= ID then
    local loadTag = self.assetManager:CreatePart(part, ID, self.RecvPartCreated, self, oldID, isLoadFirst, isDownload)
    if nil ~= loadTag then
      self.loadTags[part] = loadTag
    end
  end
end

function Asset_Role:TryDressSubPart(partIndex, partObj, resId, lastResId)
  local lastObj = self.partObjs[partIndex]
  local mainPartIndex, subPartIndex = DecodeSubPartIndex(partIndex)
  self:DestroySubPart(partIndex, true)
  if partObj then
    self.complete:SetSubPart(mainPartIndex - 1, subPartIndex - 1, partObj, true)
    partObj:RefreshLightMapColor()
    local partColorIndex = self:GetPartColorIndex(partIndex)
    if partColorIndex then
      partObj:SwitchColor(partColorIndex - 1)
    end
    if self.skinQuality ~= Asset_RolePart.SkinQuality.Auto then
      partObj:SetPartsQuality(self.skinQuality, false)
    end
    if self.isMySelf then
      local lodGroup = partObj.gameObject:GetComponent(LODGroup)
      if lodGroup then
        lodGroup:ForceLOD(0)
      end
      pcall(function()
        partObj:SetTextureRequestedMipmapLevel(0)
      end)
    end
  end
  self.partObjs[partIndex] = partObj
  self:SetRealSubPartID(mainPartIndex, subPartIndex, resId)
  self:ReplaceShader(part, partObj)
  self:SetPartMaterial(part, partObj, true)
end

function Asset_Role:SetSubPart(partIndex, resId, force)
  local mainPartIndex, subPartIndex = DecodeSubPartIndex(partIndex)
  local lastResId = self:GetSubPartID(mainPartIndex, subPartIndex)
  if lastResId == resId and not force then
    return false
  end
  local needLoadRes = resId and resId ~= 0
  if lastResId and lastResId ~= 0 then
    self:CancelCreateSubPart(partIndex, lastResId)
    if not needLoadRes and not force then
      self:DestroySubPart(partIndex, true)
    end
  end
  self:SetSubPartID(mainPartIndex, subPartIndex, resId)
  return needLoadRes, lastResId
end

function Asset_Role:CreateSubPart(partIndex, resId, lastResId, isLoadFirst, isDownload)
  if not resId or resId == 0 then
    return
  end
  local loadTag = self.assetManager:CreatePart(partIndex, resId, self.RecvPartCreated, self, lastResId, isLoadFirst, isDownload)
  if loadTag then
    self.loadTags[partIndex] = loadTag
  end
end

function Asset_Role:DestroySubPartsOfPart(mainPartIndex, undress)
  local subPartMap = self:GetRealSubPartIDsOfPart(mainPartIndex)
  if subPartMap then
    for subPartIndex, resId in pairs(subPartMap) do
      local partIndex = EncodeSubPartIndex(mainPartIndex, subPartIndex)
      self:DestroySubPart(partIndex, undress)
    end
  end
end

function Asset_Role:DestroySubPart(partIndex, undress)
  local partObj = self.partObjs[partIndex]
  self:ReSetEPNode(partIndex)
  self.partObjs[partIndex] = nil
  if nil ~= partObj then
    self:RestoreShader(partIndex, partObj)
    local mainPartIndex, subPartIndex = DecodeSubPartIndex(partIndex)
    if undress then
      self.complete:SetSubPart(mainPartIndex - 1, subPartIndex - 1, nil, undress)
    end
    if self.skinQuality ~= Asset_RolePart.SkinQuality.Auto then
      partObj:SetPartsQuality(Asset_RolePart.SkinQuality.Auto, false)
    end
    if self.isMySelf and not IsNull(partObj) then
      local lodGroup = partObj.gameObject:GetComponent(LODGroup)
      if lodGroup then
        lodGroup:ForceLOD(-1)
      end
      pcall(function()
        partObj:SetTextureRequestedMipmapLevel(-1)
      end)
    end
    local lastResId = self:GetRealSubPartID(mainPartIndex, subPartIndex)
    self:SetRealSubPartID(mainPartIndex, subPartIndex, nil)
    self.assetManager:DestroyPart(partIndex, lastResId, partObj, self.isForceDestroy)
  end
end

function Asset_Role:CancelCreateSubPartsOfPart(mainPartIndex)
  local subPartMap = self:GetSubPartIDsOfPart(mainPartIndex)
  if subPartMap then
    for subPartIndex, resId in pairs(subPartMap) do
      local partIndex = EncodeSubPartIndex(mainPartIndex, subPartIndex)
      if resId and resId ~= 0 then
        self:CancelCreateSubPart(partIndex, resId)
      end
    end
  end
end

function Asset_Role:CancelCreateSubPart(partIndex, resId)
  local partTag = self.loadTags[partIndex]
  self.loadTags[partIndex] = nil
  self.loadState[partIndex] = nil
  if partTag then
    local mainPartIndex, subPartIndex = DecodeSubPartIndex(partIndex)
    if self:GetSubPartID(mainPartIndex, subPartIndex) == resId then
      self:SetSubPartID(mainPartIndex, subPartIndex, nil)
    end
    self.assetManager:CancelCreatePart(partIndex, resId, partTag)
  end
end

function Asset_Role:SetCallbackOnBodyChanged(callback)
  self.cbOnBodyChanged = callback
end

function Asset_Role:QueueUpMainPart(tag, partObj, partIndex, resId, lastResId)
  local queue = self.partQueues[partIndex]
  if not queue then
    queue = ReusableTable.CreateRolePartTable()
    self.partQueues[partIndex] = queue
  end
  local tbl = ReusableTable.CreateRolePartTable()
  tbl.tag = tag
  tbl.partObj = partObj
  if partObj then
    GameObject.DontDestroyOnLoad(partObj.gameObject)
  end
  tbl.partIndex = partIndex
  tbl.resId = resId
  tbl.lastResId = lastResId
  table.insert(queue, 1, tbl)
end

function Asset_Role:QueueUpSubPart(tag, partObj, partIndex, resId, lastResId)
  local mainPartIndex, subPartIndex = DecodeSubPartIndex(partIndex)
  local queue = self.partQueues[mainPartIndex]
  if not queue then
    queue = ReusableTable.CreateRolePartTable()
    self.partQueues[mainPartIndex] = queue
  end
  local tbl = ReusableTable.CreateRolePartTable()
  tbl.tag = tag
  tbl.partObj = partObj
  if partObj then
    GameObject.DontDestroyOnLoad(partObj.gameObject)
  end
  tbl.partIndex = partIndex
  tbl.resId = resId
  tbl.lastResId = lastResId
  table.insert(queue, tbl)
end

function Asset_Role:DestroyAllPartQueue()
  for k, _ in pairs(self.partQueues) do
    self:DestroyPartQueue(k)
  end
end

function Asset_Role:DestroyPartQueue(mainPartIndex)
  local queue = self.partQueues[mainPartIndex]
  if not queue then
    return
  end
  for _, tbl in pairs(queue) do
    if tbl.resId and tbl.resId ~= 0 then
      self.assetManager:DestroyPart(tbl.partIndex, tbl.resId, tbl.partObj)
    end
    ReusableTable.DestroyAndClearRolePartTable(tbl)
  end
  ReusableTable.DestroyAndClearRolePartTable(queue)
  self.partQueues[mainPartIndex] = nil
end

function Asset_Role:ExtractPartQueue(mainPartIndex)
  local queue = self.partQueues[mainPartIndex]
  self.partQueues[mainPartIndex] = nil
  return queue
end

function Asset_Role:HasLoadingSubParts(mainPartIndex)
  if self.loadState[mainPartIndex] == LoadStates.Loading then
    return true
  end
  local subPartMap = self:GetSubPartIDsOfPart(mainPartIndex)
  if subPartMap then
    for subPartIndex, resId in pairs(subPartMap) do
      if resId and resId ~= 0 then
        local partIndex = EncodeSubPartIndex(mainPartIndex, subPartIndex)
        if self.loadState[partIndex] == LoadStates.Loading then
          return true
        end
      end
    end
  end
  return false
end

function Asset_Role:TryDressWholePart(mainPartIndex)
  if self:HasLoadingSubParts(mainPartIndex) then
    return
  end
  local queue = self:ExtractPartQueue(mainPartIndex)
  for _, tbl in ipairs(queue) do
    if IsMainPartIndex(tbl.partIndex) then
      self:OnPartCreated(tbl.tag, tbl.partObj, tbl.partIndex, tbl.resId, tbl.lastResId)
    elseif IsSubPartIndex(tbl.partIndex) then
      self:OnSubPartCreated(tbl.tag, tbl.partObj, tbl.partIndex, tbl.resId, tbl.lastResId)
    end
    ReusableTable.DestroyAndClearRolePartTable(tbl)
  end
  ReusableTable.DestroyAndClearRolePartTable(queue)
end

function Asset_Role:RecvPartCreated(tag, partObj, partIndex, resId, lastResId)
  if IsMainPartIndex(partIndex) then
    self:RecvMainPartCreated(tag, partObj, partIndex, resId, lastResId)
  elseif IsSubPartIndex(partIndex) then
    self:RecvSubPartCreated(tag, partObj, partIndex, resId, lastResId)
  end
end

function Asset_Role:RecvMainPartCreated(tag, partObj, partIndex, resId, lastResId)
  if self.partIDs[partIndex] ~= resId or self.loadTags[partIndex] ~= tag then
    self.assetManager:DestroyPart(partIndex, resId, partObj)
    return
  end
  self.loadTags[partIndex] = nil
  self.loadState[partIndex] = LoadStates.WaitMount
  self:QueueUpMainPart(tag, partObj, partIndex, resId, lastResId)
  self:TryDressWholePart(partIndex)
end

function Asset_Role:RecvSubPartCreated(tag, partObj, partIndex, resId, lastResId)
  local mainPartIndex, subPartIndex = DecodeSubPartIndex(partIndex)
  if self:GetSubPartID(mainPartIndex, subPartIndex) ~= resId or self.loadTags[partIndex] ~= tag then
    self.assetManager:DestroyPart(partIndex, resId, partObj)
    return
  end
  self.loadTags[partIndex] = nil
  self.loadState[partIndex] = LoadStates.WaitMount
  self:QueueUpSubPart(tag, partObj, partIndex, resId, lastResId)
  self:TryDressWholePart(mainPartIndex)
end

function Asset_Role:OnSubPartCreated(tag, partObj, partIndex, resId, lastResId)
  if not partObj then
    LogUtility.WarningFormat("Load Role Part Failed: part={0}, ID={1},name={2}", partIndex, resId, self.assetManager.__cname)
  end
  self:TryDressSubPart(partIndex, partObj, resId, lastResId)
  if self.ExOnPartCreatedCallback ~= nil then
    self.ExOnPartCreatedCallback(self, partIndex, self.ExOnPartCreatedCallbackArgs)
  end
  self.loadState[partIndex] = nil
  self:CheckExOnCreatedCallback()
  NotifyEventArgs.event = NotifyEvent.PartCreated
  NotifyEventArgs.value = partIndex
  self:NotifyObserver(NotifyEventArgs)
end

function Asset_Role:OnPartCreated(tag, obj, part, ID, oldID)
  if nil == obj then
    LogUtility.WarningFormat("Load Role Part Failed: part={0}, ID={1},name={2}", part, ID, self.assetManager.__cname)
  end
  self:_TryDressPart(part, obj, oldID, ID)
  if part == PartIndex.Body then
    if self.showWarnRing then
      self:CreateWarningRingEffect()
    end
    local lastSupportExpression = self:CurBodySupportExpression()
    self.bodyData = Table_Body[ID]
    local curSupportExpression = self:CurBodySupportExpression()
    if lastSupportExpression ~= curSupportExpression then
      self:SetPartHaveOwnAction(PartIndex.Eye, curSupportExpression)
    end
    self:SetExpression(self.replaceActExpression and self.npcDefaultExpression or self.curExpressionID or 1, true)
    self:RefreshCreatureInCP()
    if self.cbOnBodyChanged then
      self.cbOnBodyChanged(self)
    end
  elseif part == PartIndex.Eye then
    self:SetExpression(self.curExpressionID or 1, true)
  end
  if self.epNodesDisplay then
    self:UpdateEpNodesDisplay(part, obj)
  end
  Game.LogicManager_RolePart:OnAssetRolePartCreated(self, part)
  if self.needResizePart then
    local doramConfig = Table_DoramAvatar[ID]
    self:DelayResetPartPos(obj, doramConfig)
  end
  if self.needResizeCatPart then
    local bodyID = self.partIDs[PartIndex.Body]
    local config = bodyID and Table_MercenaryCatAvatar[bodyID] and Table_MercenaryCatAvatar[bodyID][ID]
    self:DelayResetPartPos(obj, config, true)
  end
  self:SetHeadPosByGender()
  if self.ExOnPartCreatedCallback ~= nil then
    self.ExOnPartCreatedCallback(self, part, self.ExOnPartCreatedCallbackArgs)
  end
  self.loadState[part] = nil
  self:CheckExOnCreatedCallback()
  NotifyEventArgs.event = NotifyEvent.PartCreated
  NotifyEventArgs.value = part
  self:NotifyObserver(NotifyEventArgs)
end

function Asset_Role:CheckExOnCreatedCallback()
  local isLoading = false
  for part, state in pairs(self.loadState) do
    if state then
      isLoading = true
      break
    end
  end
  if not isLoading and self.ExOnCreatedCallback ~= nil then
    self.ExOnCreatedCallback(self, self.ExOnCreatedCallbackArgs)
  end
end

function Asset_Role:SetExOnPartCreatedCallback(cb, cbArgs)
  self.ExOnPartCreatedCallback = cb
  self.ExOnPartCreatedCallbackArgs = cbArgs
end

function Asset_Role:ClearExOnPartCreatedCallback()
  self.ExOnPartCreatedCallback = nil
  self.ExOnPartCreatedCallbackArgs = nil
end

function Asset_Role:SetExOnCreatedCallback(cb, cbArgs)
  self.ExOnCreatedCallback = cb
  self.ExOnCreatedCallbackArgs = cbArgs
end

function Asset_Role:ClearExOnCreatedCallback()
  self.ExOnCreatedCallback = nil
  self.ExOnCreatedCallbackArgs = nil
end

function Asset_Role:DelayResetPartPos(obj, config, _isMercenaryCat)
  local isMercenaryCat = _isMercenaryCat or false
  if config and obj then
    if not config.Position then
      error(string.format("配置错误 id:%s\n%s", tostring(config.id), debug.traceback()))
    end
    local roleOrnamentsTrans = obj.gameObject:GetComponent("RoleOrnamentsTrans")
    if roleOrnamentsTrans == nil or isMercenaryCat then
      local objTransform = obj.transform
      LuaVector3.Better_Set(tempVector3, config.Position[1], config.Position[2], config.Position[3])
      objTransform.localPosition = tempVector3
      LuaVector3.Better_Set(tempVector3, config.Euler[1], config.Euler[2], config.Euler[3])
      objTransform.localEulerAngles = tempVector3
      LuaVector3.Better_Set(tempVector3, config.Scale[1], config.Scale[2], config.Scale[3])
      objTransform.localScale = tempVector3
    end
  end
end

function Asset_Role:SetEpNodesDisplay(display)
  if self.epNodesDisplay == display or not self.bodyDisplay then
    return
  end
  self.epNodesDisplay = display
  self:UpdateEpNodesDisplay()
end

function Asset_Role:UpdateEpNodesDisplay(PartID, PartObj)
  if not next(self.partObjs) then
    return
  end
  if not self.EpNodesObjs then
    self.EpNodesObjs = ReusableTable.CreateRolePartTable()
  end
  if PartID and PartObj then
    self:SetEPNode(PartID, PartObj)
    return
  end
  for PartID, PartObj in pairs(self.partObjs) do
    self:SetEPNode(PartID, PartObj)
  end
end

function Asset_Role:SetEPNode(PartID, PartObj)
  local cmp = self.EpNodesObjs[PartID]
  if not IsNull(cmp) then
    local _LODLevel = PerformanceManager.LODLevel
    cmp.level = self.epNodesDisplay and _LODLevel.High or _LODLevel.Mid
  else
    self.EpNodesObjs[PartID] = RoleUtil.UpdateEPNodesDisplay(PartObj, self.epNodesDisplay)
  end
end

function Asset_Role:ReSetEPNode(PartID)
  if not self.EpNodesObjs then
    return
  end
  local cmp = self.EpNodesObjs[PartID]
  if not IsNull(cmp) then
    cmp.level = PerformanceManager.LODLevel.Mid
  end
  self.EpNodesObjs[PartID] = nil
end

function Asset_Role:RestoreAction()
  self.complete:ActionCallback()
  self:SetRestoreActionNextFrame(false)
  if nil ~= self.action and nil ~= self.actionRaw then
    local config = Game.Config_Action[self.actionRaw]
    if nil ~= config then
      local restoreType = config.RestoreType
      if 1 == restoreType then
        local params = Asset_Role.GetPlayActionParams(self.action, self.actionDefault)
        params[7] = function(creatureGUID, arg)
          local params = Asset_Role.GetPlayActionParams(ActionName.Idle)
          params[12] = true
          self:PlayAction(params)
        end
        params[6] = true
        params[12] = true
        self:PlayAction(params)
      elseif 2 == restoreType then
        local params = Asset_Role.GetPlayActionParams(self.action, self.actionDefault)
        params[5] = self.actionIsLoop == true
        params[6] = true
        params[12] = true
        self:PlayAction(params)
      elseif 3 == restoreType then
        local params = Asset_Role.GetPlayActionParams(self.action, self.actionDefault)
        params[4] = 1
        params[5] = self.actionIsLoop == true
        params[6] = true
        params[12] = true
        self:PlayAction(params)
      elseif 4 == restoreType then
        local normalizedTime = 1
        local time = UnityTime - self.actionRawTime
        if 0 <= time and self.actionRawDuration and time < self.actionRawDuration then
          normalizedTime = time / self.actionRawDuration
        end
        local params = Asset_Role.GetPlayActionParams(self.action, self.actionDefault)
        params[4] = normalizedTime
        params[5] = self.actionIsLoop == true
        params[6] = true
        params[12] = true
        self:PlayAction(params)
      end
    else
      LogUtility.InfoFormat("<color=red>Action no config: </color>{0}", self.actionRaw)
    end
  end
end

function Asset_Role:RestoreWeaponAction()
  if UnityFrameCount == self.lastChangeBodyFrame then
    return
  end
  if nil ~= self.action and nil ~= self.actionRaw then
    local config = Game.Config_Action[self.actionRaw]
    if nil ~= config then
      if 1 == config.CheckMatching then
        local params = Asset_Role.GetPlayActionParams(self.action, self.actionDefault)
        params[5] = self.actionIsLoop == true
        params[6] = true
        params[7] = self.actioncallback
        params[8] = self.actioncallbackarg
        self:_PrePlayAction(params)
        params[6] = false
        self:PlayActionRaw(params)
        Asset_Role.ClearPlayActionParams(params)
      end
    else
      LogUtility.InfoFormat("<color=red>Action no config: </color>{0}", self.actionRaw)
    end
  end
end

function Asset_Role:_IsLoading()
  for _, tag in pairs(self.loadTags) do
    if tag ~= nil then
      return true
    end
  end
  return false
end

function Asset_Role:IsPartLoading(part)
  return self.loadTags[part] ~= nil
end

function Asset_Role:IsPartFirstLoading(part)
  return self:IsPartLoading(part) and not self:GetPartObject(part)
end

function Asset_Role:_CanShowBody()
  for k, v in pairs(LoadPriority) do
    if self.loadTags[k] ~= nil then
      return true
    end
  end
  return false
end

function Asset_Role:_TryFlipRightWeapon(obj)
  if nil ~= obj then
    local weaponID = self.partIDs[PartIndex.RightWeapon]
    if weaponID ~= 0 then
      local weaponData = self.tableEquip[weaponID]
      if nil ~= weaponData then
        local weaponType = weaponData.Type
        if "Katar" == weaponType or "Knuckle" == weaponType or "Pistol" == weaponType then
          Game.SetLocalRotationObj(obj, 0, 0, 1, 0)
          Game.SetLocalScaleObj(obj, 1, -1, 1)
        end
      end
    end
  end
end

function Asset_Role:_TryDressPart(part, obj, oldID, ID)
  local oldObj = self.partObjs[part]
  if PartIndex.Body == part and nil ~= oldObj then
    if nil ~= obj then
      oldObj:MoveEffect(obj)
    else
      oldObj:MoveEffectToTransform(self.complete.tempOwner)
    end
  end
  self:_DestroyPartObject(part, oldID, true)
  if nil ~= obj then
    self.complete:SetPart(part - 1, obj, true)
    obj:RefreshLightMapColor()
    if PartIndex.Body == part then
      if self.forceShowMount then
        self.complete.mountEnable = true
      end
      local defaultTail = self.partObjs[PartIndex.DefaultTail]
      if defaultTail ~= nil then
        self:ResetPart(defaultTail.transform, PartIndex.Tail)
      end
      local bodyID = self.partIDs[PartIndex.Body]
      local offsetCfg, partID
      for i, partObj in pairs(self.partObjs) do
        if 1 < i and i <= PartCount then
          if i == PartIndex.Hair then
            local hairID = self.partIDs[PartIndex.Hair]
            local hairVersion = hairID and Table_HairStyle[hairID] and Table_HairStyle[hairID].Version
            if hairVersion then
              local hairOffset = Table_Body[ID] and Table_Body[ID].HairOffset
              hairOffset = hairOffset and hairOffset[hairVersion]
              if hairOffset and self.partObjs[PartIndex.Hair] then
                LuaGameObject.SetLocalPositionObj(self.partObjs[PartIndex.Hair], hairOffset[1], hairOffset[2], hairOffset[3])
              end
            end
          elseif i ~= PartIndex.Body and i ~= PartIndex.DefaultTail and i ~= PartIndex.Mount then
            partID = self.partIDs[i]
            offsetCfg = Table_RolePartOffset and Table_RolePartOffset[i] and Table_RolePartOffset[i][partID]
            offsetCfg = offsetCfg and (offsetCfg[bodyID] or offsetCfg[0])
            if offsetCfg then
              LuaGameObject.SetLocalPositionObj(partObj, offsetCfg[1], offsetCfg[2], offsetCfg[3])
            end
          end
        end
      end
    elseif PartIndex.DefaultTail == part then
      self:ResetPart(obj.transform, PartIndex.Tail)
    elseif PartIndex.Hair == part then
      local hairVersion = Table_HairStyle[ID] and Table_HairStyle[ID].Version
      if hairVersion then
        local bodyID = self.partIDs[PartIndex.Body]
        local hairOffset = bodyID and Table_Body[bodyID].HairOffset
        hairOffset = hairOffset and hairOffset[hairVersion]
        if hairOffset then
          LuaGameObject.SetLocalPositionObj(obj, hairOffset[1], hairOffset[2], hairOffset[3])
        end
      end
    elseif PartIndex.Mount == part then
      local partColorIndex = self:GetPartColorIndex(part)
      if partColorIndex then
        obj:SwitchColor(partColorIndex - 1)
      end
    else
      local bodyID = self.partIDs[PartIndex.Body]
      local offsetCfg = Table_RolePartOffset and Table_RolePartOffset[part] and Table_RolePartOffset[part][ID]
      offsetCfg = offsetCfg and (offsetCfg[bodyID] or offsetCfg[0])
      if offsetCfg then
        LuaGameObject.SetLocalPositionObj(obj, offsetCfg[1], offsetCfg[2], offsetCfg[3])
      end
    end
    self:ResizeParts()
    self:ResizeCatParts()
    if self.skinQuality ~= Asset_RolePart.SkinQuality.Auto then
      obj:SetPartsQuality(self.skinQuality, false)
    end
    if self.isMySelf then
      local lodGroup = obj.gameObject:GetComponent(LODGroup)
      if lodGroup then
        lodGroup:ForceLOD(0)
      end
      pcall(function()
        obj:SetTextureRequestedMipmapLevel(0)
      end)
    end
  end
  self.partObjs[part] = obj
  self.realPartIDs[part] = ID
  if PartIndex.Mount == part then
    self:Mount_ResetTransformState()
  end
  if obj and self:IsPartHaveOwnAction(part) then
    obj.partAction = true
  end
  if PartIndex.Body == part then
    if self.actionDiePlaying then
      self:DoSpectialHeadDie()
    end
    self:RestoreAction()
    self:_TryFlipRightWeapon(self.partObjs[PartIndex.RightWeapon])
  elseif PartIndex.Mount == part then
    self:RestoreAction()
  elseif PartIndex.LeftWeapon == part then
    self:RestoreWeaponAction()
  elseif PartIndex.RightWeapon == part then
    self:RestoreWeaponAction()
    self:_TryFlipRightWeapon(obj)
  elseif PartIndex.Head == part then
    if self.actionDiePlaying then
      self:DoSpectialHeadDie()
    end
    self:SetHeadPosByGender()
  end
  if PartIndex.Wing == part then
    if self.wingDisplay == false and obj ~= nil then
      obj.gameObject:SetActive(false)
    end
  elseif PartIndex.Tail == part and self.tailDisplay == false and obj ~= nil then
    obj.gameObject:SetActive(false)
  end
  if not self:_CanShowBody() then
    local bodyHidding = self.dressHideBody
    self:_DressHideBody(false)
    if bodyHidding then
      self:_SmoothShowBody()
    end
  end
  self:ReplaceShader(part, obj)
  self:SetPartMaterial(part, obj, true)
  self:_TryDressOriginPart(part, ID)
end

function Asset_Role:_TryDressOriginPart(part, oldID)
  local originid = self.originPartIDs[part]
  if 0 < originid and originid ~= oldID then
    self.originPartIDs[part] = 0
    self:_SetPartID(part, originid)
    self:_CreatePart(part, oldID, nil, true)
  end
end

function Asset_Role:SetLogicIgnoreScale(isIgnore)
  self.isLogicIngoreScale = isIgnore
end

function Asset_Role:IsLogicIngoreScale()
  return self.isLogicIngoreScale == true
end

function Asset_Role:SetHeadPosByGender()
  local headobj = self.partObjs[PartIndex.Head]
  if headobj == nil then
    return
  end
  local bodyID = self.partIDs[PartIndex.Body]
  local isDoram = IsDoram(bodyID)
  if isDoram or self.needResizeCatPart then
    return
  end
  local roleOrnamentsTrans = headobj.gameObject:GetComponent("RoleOrnamentsTrans")
  if roleOrnamentsTrans then
    local bodyType = 0
    local config = Table_Body[bodyID]
    if config ~= nil then
      bodyType = GetBodyType(config.BodyType)
    end
    roleOrnamentsTrans:SetOrnamentsTrans(bodyType)
  end
end

function Asset_Role:ResizeParts()
  if self.needResizePart then
    for index, id in pairs(self.partIDs) do
      local doramConfig = Table_DoramAvatar[id]
      self:DelayResetPartPos(self.partObjs[index], doramConfig)
    end
  end
end

function Asset_Role:ResizeCatParts()
  if self.needResizeCatPart then
    local bodyID = self.partIDs[PartIndex.Body]
    local config = bodyID and Table_MercenaryCatAvatar[bodyID]
    if config then
      for index, id in pairs(self.partIDs) do
        self:DelayResetPartPos(self.partObjs[index], config[id], true)
      end
    end
  end
end

function Asset_Role:ResetPart(objTransform, partID)
  local cp = self:GetCP(partID - 1)
  if nil ~= cp then
    objTransform.parent = cp
    objTransform.localPosition = LuaGeometry.Const_V3_zero
    objTransform.localRotation = LuaGeometry.Const_V3_zero
    objTransform.localScale = LuaGeometry.Const_V3_one
  end
end

function Asset_Role:SetMountEnable(enable)
  self.complete.mountEnable = enable
  if self.mountStatusChangeCallback ~= nil then
    self.mountStatusChangeCallback(enable)
  end
end

function Asset_Role:MountStatusChangeCallback(callback)
  self.mountStatusChangeCallback = callback
end

function Asset_Role:SetSimplifyRolePart(on)
  if self.simplifyRolePart == on then
    return
  end
  if Game.Myself and Game.Myself.assetRole == self then
    return
  end
  self.complete:SimplifyRoleParts(on)
  self.simplifyRolePart = on
end

function Asset_Role:SetEnableVisibleByCameraPos(on)
  self.complete.enableVisibleByCameraPos = on
  self:FixSubPartsLayer()
end

Asset_Role.PartShadow = {
  [1] = {},
  [2] = {
    PartIndex.Body,
    PartIndex.Hair,
    PartIndex.Face,
    PartIndex.Mount
  },
  [3] = {
    PartIndex.Body,
    PartIndex.Hair,
    PartIndex.LeftWeapon,
    PartIndex.RightWeapon,
    PartIndex.Head,
    PartIndex.Face,
    PartIndex.Wing,
    PartIndex.Tail,
    PartIndex.DefaultTail,
    PartIndex.Mount
  }
}

function Asset_Role:SetEnableVisibleByCameraPos(on)
  self.complete.enableVisibleByCameraPos = on
  self:FixSubPartsLayer()
end

function Asset_Role:ApplyShadowConfig()
  self.complete:ApplyShadowCastByConfig()
end

function Asset_Role:IsPlayShowForbidden()
  if self.partIDs then
    local hairID = self.partIDs[PartIndex.Hair]
    if 0 ~= hairID then
      local data = Table_HairStyle[hairID]
      if data and data.Feature then
        return 0 < data.Feature & 1
      end
    end
    local headID = self.partIDs[PartIndex.Head]
    if 0 ~= headID then
      local data = Table_Equip[headID]
      if data and data.Feature then
        return 0 < data.Feature & 2
      end
    end
  end
  return false
end

function Asset_Role:SetPartHaveOwnAction(partIndex, haveOwnAction)
  if not self.partsHaveOwnAction then
    self.partsHaveOwnAction = ReusableTable.CreateTable()
  end
  local lastCount = self.partsHaveOwnAction[partIndex] or 0
  local curCount = lastCount + (haveOwnAction and 1 or -1)
  self.partsHaveOwnAction[partIndex] = curCount
  if curCount == 1 and lastCount < 1 then
    local partObj = self:GetPartObject(partIndex)
    if partObj then
      partObj.partAction = true
    end
  elseif curCount == 0 and 0 < lastCount then
    local partObj = self:GetPartObject(partIndex)
    if partObj then
      partObj.partAction = false
    end
  end
end

function Asset_Role:IsPartHaveOwnAction(partIndex)
  return self.partsHaveOwnAction and 0 < (self.partsHaveOwnAction[partIndex] or 0)
end

function Asset_Role:ClearPartOwnActions()
  if not self.partsHaveOwnAction then
    return
  end
  local partObj
  for partIndex, count in pairs(self.partsHaveOwnAction) do
    partObj = self:GetPartObject(partIndex)
    if partObj then
      partObj.partAction = false
    end
  end
  ReusableTable.DestroyAndClearTable(self.partsHaveOwnAction)
  self.partsHaveOwnAction = nil
end

function Asset_Role:FireEffectOnWeaponEP(effectPath, weaponEP, isfollow, lodLevel, priority, effectType)
  local leftWeapon = self.complete.leftWeapon
  local rightWeapon = self.complete.rightWeapon
  local lefteffect, righeffect, leftEP, rightEP
  if leftWeapon then
    leftEP = leftWeapon:GetEP(weaponEP) or self:GetEPOrRoot(weaponEP)
    LuaVector3.Better_Set(tempVector3, LuaGameObject.GetPosition(leftEP))
    if not isfollow then
      lefteffect = Asset_Effect.PlayOneShotAt(effectPath, tempVector3, nil, nil, nil, lodLevel, priority, effectType)
    else
      lefteffect = Asset_Effect.PlayOneShotOn(effectPath, leftEP, nil, nil, nil, lodLevel, priority, effectType)
    end
  end
  if rightWeapon then
    rightEP = rightWeapon:GetEP(weaponEP) or self:GetEPOrRoot(weaponEP)
    LuaVector3.Better_Set(tempVector3, LuaGameObject.GetPosition(rightEP))
    if not isfollow then
      righeffect = Asset_Effect.PlayOneShotAt(effectPath, tempVector3, nil, nil, nil, lodLevel, priority, effectType)
    else
      righeffect = Asset_Effect.PlayOneShotOn(effectPath, rightEP, nil, nil, nil, lodLevel, priority, effectType)
    end
  end
  return lefteffect, righeffect
end

function Asset_Role:GetWeaponFireEP(weaponEP)
  local rightWeapon = self.complete.rightWeapon
  local rightEP
  if rightWeapon then
    rightEP = rightWeapon:GetEP(weaponEP)
    if rightEP then
      return LuaGameObject.GetPosition(rightEP)
    end
  end
  return self:GetEPOrRootPosition(weaponEP)
end

function Asset_Role:AddOutlineProcess()
  if self.complete and self.complete.gameObject then
    self.outline = self.complete.gameObject:GetComponent(PostProcessOutline)
    if not self.outline then
      self.outline = self.complete.gameObject:AddComponent(PostProcessOutline)
    end
    if self.outline then
      self.outline.enabled = false
    end
  end
end

function Asset_Role.CheckBodyGender(roleA, roleB)
  local bodyA = roleA and roleA:GetPartID(PartIndex.Body)
  local bodyB = roleB and roleB:GetPartID(PartIndex.Body)
  local map = Game.Config_BodyGender
  local genderA = bodyA and map[bodyA]
  local genderB = bodyB and map[bodyB]
  if not genderA or not genderB then
    return false
  end
  return genderA == genderB
end

function Asset_Role:SetNpcDefaultExpression(npcDefaultExpression, replaceActExpression)
  self.npcDefaultExpression = npcDefaultExpression
  self.replaceActExpression = replaceActExpression == 1
end

function Asset_Role:SetIgnoreExpression()
  self.ignoreExpression = true
end

function Asset_Role:SetIgnoreColor()
  self.ignoreColor = true
end

function Asset_Role:SetShaderInfo(shaderName, shaderPath, shaderAssetName, texPath, texName)
  self:ClearShader()
  self.shaderName = shaderName
  self.shaderPath = shaderPath
  self.shaderAssetName = shaderAssetName
  self.texPath = texPath
  self.texName = texName
end

function Asset_Role:ClearShader()
  if self.cacheReplaceShader ~= nil then
    local obj
    for k, v in pairs(self.cacheReplaceShader) do
      if v == true then
        obj = self.partObjs[k]
        if obj ~= nil then
          self:RestoreShader(k, obj)
        end
      end
      self.cacheReplaceShader[k] = nil
    end
    self.cacheReplaceShader = nil
  end
  if self.shaderPath ~= nil then
    Game.AssetManager:UnloadAsset(self.shaderPath)
    self.shaderPath = nil
    self.shaderAssetName = nil
  end
  if self.texPath ~= nil then
    Game.AssetManager:UnloadAsset(self.texPath)
    self.texPath = nil
  end
  self.originShader = nil
  self.shaderName = nil
  self.texName = nil
  self.shader = nil
  self.texture = nil
end

function Asset_Role:ReplaceShader(part, obj)
  if self.shaderPath == nil then
    return
  end
  if obj == nil then
    return
  end
  if self.shader == nil or self.texPath ~= nil and self.texture == nil then
    if self.cacheReplaceShader == nil then
      self.cacheReplaceShader = ReusableTable.CreateTable()
      self.cacheReplaceShader[part] = false
      Game.AssetManager:LoadByTypeAsync(self.shaderPath, Shader, function(asset)
        self.shader = asset
        self:SetCacheShader()
      end, self.shaderAssetName)
      Game.AssetManager:LoadAssetAsync(self.texPath, Texture, Asset_Role.LoadTexture, self)
    else
      self.cacheReplaceShader[part] = false
    end
  else
    self.cacheReplaceShader[part] = true
    self:SetPartShader(part, obj, RolePartShaderName, self.shader, self.texName, self.texture)
  end
end

function Asset_Role.LoadTexture(owner, asset)
  owner.texture = asset
  owner:SetCacheShader()
end

function Asset_Role:SetCacheShader()
  if self.shader == nil or self.texPath ~= nil and self.texture == nil then
    return
  end
  local obj
  for k, v in pairs(self.cacheReplaceShader) do
    if v == false then
      self.cacheReplaceShader[k] = true
      obj = self.partObjs[k]
      if obj ~= nil then
        self:SetPartShader(k, obj, RolePartShaderName, self.shader, self.texName, self.texture)
      end
    end
  end
end

function Asset_Role:RestoreShader(part, obj)
  if self.shaderPath ~= nil then
    self:SetPartShader(part, obj, self.shaderName, self.originShader)
  end
  if self.materialKeyword ~= nil and obj ~= nil then
    if self.materialParams and not self.materialParams.parts[part] then
      return
    end
    local length, mat
    local smrs = obj.smrs
    for i = 1, #smrs do
      length = #obj.smrOriginMaterials[i]
      for j = 0, length - 1 do
        mat = obj:GetMaterialByRenderer(smrs[i], j)
        if mat then
          self:SetMaterial(mat, false)
        end
      end
    end
    local mrs = obj.mrs
    for i = 1, #mrs do
      length = #obj.mrOriginMaterials[i]
      for j = 0, length - 1 do
        mat = obj:GetMaterialByRenderer(mrs[i], j)
        if mat then
          self:SetMaterial(mat, false)
        end
      end
    end
    if self.materialSeted ~= nil then
      self.materialSeted[part] = nil
    end
  end
end

function Asset_Role:SetPartShader(part, obj, fromShaderName, shader, texName, texture)
  local length, mat
  local smrs = obj.smrs
  for i = 1, #smrs do
    length = #obj.smrOriginMaterials[i]
    for j = 0, length - 1 do
      mat = obj:GetMaterialByRenderer(smrs[i], j)
      if mat then
        self:SetMaterialShader(mat, fromShaderName, shader, texName, texture)
      end
    end
  end
  local mrs = obj.mrs
  for i = 1, #mrs do
    length = #obj.mrOriginMaterials[i]
    for j = 0, length - 1 do
      mat = obj:GetMaterialByRenderer(mrs[i], j)
      if mat then
        self:SetMaterialShader(mat, fromShaderName, shader, texName, texture)
      end
    end
  end
end

function Asset_Role:SetMaterialShader(mat, fromShaderName, shader, texName, texture)
  if self.originShader == nil and mat.shader.name == RolePartShaderName then
    self.originShader = mat.shader
  end
  if mat.shader.name ~= fromShaderName then
    return
  end
  mat.shader = shader
  if texName ~= nil then
    mat:SetTexture(texName, texture)
  end
end

function Asset_Role:SetMaterialInfo(keyword, texPath, texName, materialParams)
  self.materialKeyword = keyword
  if self.materialTexPath ~= texPath then
    self:ClearMaterialTexture()
  end
  self.materialTexPath = texPath
  self.materialTexName = texName
  self.materialParams = materialParams
end

function Asset_Role:ResetMaterials()
  if self.materialKeyword ~= nil then
    self:SetMaterials(false)
    self.materialKeyword = nil
  end
  self:ClearMaterialTexture()
  self.materialTexName = nil
  self.materialParams = nil
end

function Asset_Role:ClearMaterialTexture()
  if self.materialTexPath ~= nil then
    Game.AssetManager:UnloadAsset(self.materialTexPath)
    self.materialTexPath = nil
  end
  self.materialTexture = nil
  self.materialTextureLoaded = nil
  if self.materialSeted ~= nil then
    ReusableTable.DestroyAndClearTable(self.materialSeted)
    self.materialSeted = nil
  end
end

function Asset_Role:SetMaterials(enable)
  local seted = self.materialSeted
  for part, obj in pairs(self.partObjs) do
    if seted == nil or seted[part] ~= enable then
      self:SetPartMaterial(part, obj, enable)
    end
  end
end

function Asset_Role:SetPartMaterial(part, obj, enable)
  if self.materialKeyword == nil then
    return
  end
  if obj == nil then
    return
  end
  if self.materialParams and not self.materialParams.parts[part] then
    return
  end
  if self.materialTexture == nil then
    if self.materialTexPath ~= nil and not self.materialTextureLoaded then
      self.materialTextureLoaded = true
      Game.AssetManager:LoadAssetAsync(self.materialTexPath, Texture, Asset_Role.LoadMaterialTexture, self)
    end
  else
    if self.materialSeted == nil then
      self.materialSeted = ReusableTable.CreateTable()
    end
    self.materialSeted[part] = enable
    local length, mat
    local smrs = obj.smrs
    for i = 1, #smrs do
      length = #obj.smrOriginMaterials[i]
      for j = 0, length - 1 do
        mat = obj:GetMaterialByRenderer(smrs[i], j)
        if mat then
          self:SetMaterial(mat, enable)
        end
      end
    end
    local mrs = obj.mrs
    for i = 1, #mrs do
      length = #obj.mrOriginMaterials[i]
      for j = 0, length - 1 do
        mat = obj:GetMaterialByRenderer(mrs[i], j)
        if mat then
          self:SetMaterial(mat, enable)
        end
      end
    end
  end
end

function Asset_Role.LoadMaterialTexture(owner, asset)
  owner.materialTexture = asset
  owner:SetMaterials(true)
end

function Asset_Role:SetMaterial(mat, enable)
  if enable then
    mat:EnableKeyword(self.materialKeyword)
    local texName = self.materialTexName
    if texName ~= nil then
      mat:SetTexture(texName, self.materialTexture)
    end
    local params = self.materialParams
    if params ~= nil then
      local tintColor = params.TintColor
      if tintColor then
        mat:SetColor("_TintColor", LuaGeometry.GetTempColor(tintColor[1], tintColor[2], tintColor[3], tintColor[4]))
      end
      local outlineColor = params.OutlineColor
      if outlineColor then
        mat:SetColor("_OutlineColor", LuaGeometry.GetTempColor(outlineColor[1], outlineColor[2], outlineColor[3], outlineColor[4]))
      end
      local matcapStrength = params.MatcapStrength
      if matcapStrength then
        mat:SetFloat("_MatcapStrength", matcapStrength)
      end
      local matcapType = params.MatcapType
      if matcapType then
        mat:SetFloat("_MatcapType", matcapType)
      end
      local setValue = params.SetValue
      if setValue and mat:HasProperty("_ColorParam") then
        local colorParam = mat:GetVector("_ColorParam")
        local tmpColor = LuaGeometry.GetTempVector4(colorParam[1], setValue, colorParam[3], colorParam[4])
        mat:SetVector("_ColorParam", tmpColor)
      end
    end
  else
    local params = self.materialParams
    if params then
      local setValue = params.SetValue
      if setValue and mat:HasProperty("_ColorParam") then
        local colorParam = mat:GetVector("_ColorParam")
        local tmpColor = LuaGeometry.GetTempVector4(colorParam[1], 1, colorParam[3], colorParam[4])
        mat:SetVector("_ColorParam", tmpColor)
      end
    end
    mat:DisableKeyword(self.materialKeyword)
    local texName = self.materialTexName
    if texName ~= nil then
      mat:SetTexture(texName, nil)
    end
  end
end

function Asset_Role:SetRestoreActionNextFrame(b)
  self.restoreActionNextFrame = b
end

function Asset_Role:SetPartBodyAlpha(alpha)
  local body = self.partObjs[PartIndex.Body]
  if body then
    body:SetAlpha(alpha)
  end
end

function Asset_Role:Update(time, deltaTime)
  if self.restoreActionNextFrame then
    self:RestoreAction()
  end
  if self.actionParams ~= nil then
    local delay = self.actionParams[17]
    if delay ~= nil and delay < UnityFrameCount then
      self:PlayActionRaw(self.actionParams)
      TableUtility.TableClear(self.actionParams)
    end
  end
  if self.waitingSE ~= nil then
    for k, v in pairs(self.waitingSE) do
      if time > v.time then
        self:PlaySEOneShotOn(k, v.atype, v.skipCount)
        ReusableTable.DestroyAndClearTable(v)
        self.waitingSE[k] = nil
      end
    end
  end
end

function Asset_Role:SetRideShoulderPrefix(prefix)
  self.rideShoulderPrefix = prefix
  self.rideShoulderSuffix = prefix and "alinia" or nil
end

function Asset_Role:DoConstruct(asArray, args)
  local parts = args[1]
  Debug_AssertFormat(PartCount <= #parts, "Asset_Role args length invalid: {0}", #parts)
  self.assetManager = hackAssetManager or Game.AssetManager_Role
  self.tableEquip = self.assetManager.Table_Equip or Table_Equip
  self.partQueues = ReusableTable.CreateRolePartTable()
  self.partIDs = Asset_Role.CreatePartArray()
  self.realPartIDs = Asset_Role.CreatePartArray()
  self.originPartIDs = Asset_Role.CreatePartArray()
  self.partObjs = ReusableTable.CreateRolePartTable()
  self.subPartIDs = Asset_Role.CreateSubPartTable()
  self.realSubPartIDs = Asset_Role.CreateSubPartTable()
  self.partColorIndexes = ReusableTable.CreateRolePartTable()
  self.loadTags = ReusableTable.CreateRolePartTable()
  self.loadState = ReusableTable.CreateRolePartTable()
  self.epPositions = ReusableTable.CreateTable()
  self.EpNodesObjs = nil
  self.gender = 0
  self.hairColorIndex = 0
  self.eyeColorIndex = 0
  self.bodyColorIndex = 0
  self.complete = self.assetManager:CreateComplete()
  self.complete.ShadowCastEnable = true
  self.completeTransform = self.complete.transform
  self.audioSource = self.complete.audioSource
  self.weaponDisplay = false
  self.mountDisplay = false
  self.actionHideMount = false
  self.actionHideWeapon = false
  self.actionSpeed = nil
  self.action = nil
  self.actionDefault = nil
  self.actionRaw = nil
  self.actionDiePlaying = false
  self.rideAction = nil
  self.bodyDisplay = true
  self.dressHideBody = false
  self.smoothShowBody = parts[PartIndex.SmoothDisplay] or 0
  self.alpha = 1
  self.speedScale = 1
  self.prepareHideMount = false
  self.invisible = nil
  self.forceInvisible = nil
  self.realInvisible = nil
  self.forceColliderEnable = nil
  self.realColliderEnable = nil
  self.ignoreHead = nil
  self.ignoreFace = nil
  self.ignoreLogic = nil
  self.showWarnRing = false
  self.epNodesDisplay = false
  self.isLoadFirst = parts[PartIndex.LoadFirst]
  self.needResizePart = false
  self.doActionCbIfBreak = nil
  self.needResizeCatPart = false
  self.isForceDestroy = false
  self.showLayer = parts[PartIndex.Layer]
  self.isMoving = false
  self.ExOnCreatedCallback = args[2]
  self.ExOnCreatedCallbackArgs = args[3]
  self.isMySelf = parts[PartIndex.MySelf] or false
  self.skinQuality = self.isMySelf and Asset_RolePart.SkinQuality.Bone4 or parts[PartIndex.SkinQuality] or Asset_RolePart.SkinQuality.Auto
  self.npcDefaultExpression = nil
  self.replaceActExpression = false
  self.hideBodyOnly = false
  self:SetMountForm(args[4] or 1)
  self:SetMountTransformStartForm(self:GetMountForm())
  self:Redress(parts, self.isLoadFirst)
  self.isLoopSfx = false
  Table_RolePartOffset = GameConfig and GameConfig.RolePartOffset
  self.rideShoulderPrefix = nil
  self.rideShoulderSuffix = nil
end

function Asset_Role:ResetMountRole()
  self.complete.mountRole = nil
  self.complete:ResetMountRole()
end

function Asset_Role:SetMountRole(rolecompete)
  self.complete.MountRole = rolecompete
end

function Asset_Role:DoDeconstruct(asArray)
  self:ResetCPCreatureMap()
  self:ClearShader()
  self:ResetMaterials()
  self.mountStatusChangeCallback = nil
  self:ResetMountRole()
  self:SetEnableVisibleByCameraPos(false)
  for part = PartCount, 1, -1 do
    local oldID = self.partIDs[part]
    if oldID ~= nil then
      self:_CancelLoading(part, oldID)
    end
    self:_DestroyPartObject(part, nil, false)
  end
  self:DestroyAllPartQueue()
  ReusableTable.DestroyRolePartTable(self.partQueues)
  self.partQueues = nil
  if self.skinQuality ~= Asset_RolePart.SkinQuality.Auto then
    self.skinQuality = Asset_RolePart.SkinQuality.Auto
  end
  if self.warnRing then
    self.warnRing:_CancelLoading()
    self.warnRing:Destroy()
    self.warnRing = nil
  end
  self:ResetSEMaxDistance()
  self.showWarnRing = false
  self.assetManager:DestroyComplete(self.complete)
  self.complete = nil
  self.dontDestroyOnLoad = nil
  self.completeTransform = nil
  self.audioSource = nil
  self:ClearPartOwnActions()
  Asset_Role.DestroyPartArray(self.partIDs)
  self.partIDs = nil
  Asset_Role.DestroyPartArray(self.realPartIDs)
  self.realPartIDs = nil
  Asset_Role.DestroyPartArray(self.originPartIDs)
  self.originPartIDs = nil
  Asset_Role.DestroySubPartTable(self.subPartIDs)
  self.subPartIDs = nil
  Asset_Role.DestroySubPartTable(self.realSubPartIDs)
  self.realSubPartIDs = nil
  ReusableTable.DestroyRolePartTable(self.partObjs)
  self.partObjs = nil
  ReusableTable.DestroyRolePartTable(self.loadTags)
  self.loadTags = nil
  ReusableTable.DestroyRolePartTable(self.loadState)
  self.loadState = nil
  for k, v in pairs(self.epPositions) do
    ReusableTable.DestroyAndClearTable(v)
  end
  ReusableTable.DestroyAndClearTable(self.epPositions)
  self.epPositions = nil
  self:SetForceShowMount(false)
  if self.EpNodesObjs then
    ReusableTable.DestroyRolePartTable(self.EpNodesObjs)
  end
  self.EpNodesObjs = nil
  self.suffixReplace = nil
  self.epNodesDisplay = false
  self.needResizePart = false
  self.needResizeCatPart = false
  self.bodyData = nil
  self.curExpressionID = nil
  self.curFaceMatID = nil
  self.simplifyRolePart = nil
  self.cbOnBodyChanged = nil
  self.isForceDestroy = false
  self:ClearExOnPartCreatedCallback()
  self:ClearExOnCreatedCallback()
  self.ignoreExpression = nil
  self.ignoreColor = nil
  self.hideBodyOnly = false
  ReusableTable.DestroyAndClearRolePartTable(self.partColorIndexes)
  self.partColorIndexes = nil
  self.actioncallback = nil
  self.actioncallbackarg = nil
  if self.actionParams ~= nil then
    ReusableTable.DestroyAndClearTable(self.actionParams)
    self.actionParams = nil
  end
  self:ClearWaitingSE()
  self.isLoopSfx = false
  self.isDownload = nil
  self.rideShoulderPrefix = nil
  self.rideShoulderSuffix = nil
end
