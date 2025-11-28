Asset_RoleUtility = class("Asset_RoleUtility")

function Asset_RoleUtility.CreateRoleParts(staticData)
  if nil == staticData then
    return nil
  end
  local parts = Asset_Role.CreatePartArray()
  Asset_RoleUtility.SetRoleParts(staticData, parts)
  return parts
end

function Asset_RoleUtility.SetRoleParts(staticData, parts)
  if nil == staticData then
    return
  end
  local partIndex = Asset_Role.PartIndex
  parts[partIndex.Body] = staticData.Body or 0
  parts[partIndex.Hair] = staticData.Hair or 0
  parts[partIndex.LeftWeapon] = staticData.LeftHand or 0
  parts[partIndex.RightWeapon] = staticData.RightHand or 0
  parts[partIndex.Head] = staticData.Head or 0
  parts[partIndex.Wing] = staticData.Wing or 0
  parts[partIndex.Face] = staticData.Face or 0
  parts[partIndex.Tail] = staticData.Tail or 0
  parts[partIndex.Eye] = staticData.Eye or 0
  parts[partIndex.Mount] = staticData.Mount or 0
  parts[partIndex.Mouth] = staticData.Mouth or 0
  local partIndexEx = Asset_Role.PartIndexEx
  parts[partIndexEx.Gender] = staticData.Gender
  parts[partIndexEx.HairColorIndex] = staticData.HeadDefaultColor or 0
  parts[partIndexEx.EyeColorIndex] = staticData.EyeDefaultColor or 0
  parts[partIndexEx.BodyColorIndex] = staticData.BodyChangeColor or 0
end

function Asset_RoleUtility.CreateUserRoleParts(userData)
  if not userData then
    return
  end
  local parts = Asset_Role.CreatePartArray()
  Asset_RoleUtility.SetUserRoleParts(userData, parts)
  return parts
end

function Asset_RoleUtility.ReviseEyeByBody(parts)
  if not parts then
    return
  end
  local config, bodyType
  local partIndex = Asset_Role.PartIndex
  local bodyId = parts[partIndex.Body]
  if 0 < bodyId then
    config = Table_Body[bodyId]
    bodyType = config ~= nil and config.BodyType
  end
  if bodyType ~= nil then
    local eye_id = parts[partIndex.Eye]
    if not eye_id then
      return
    end
    local t = type(bodyType)
    if t == "number" then
    elseif t == "string" and string.find(bodyType, "hf_") then
      local eye_static = Table_Eye[eye_id]
      if not eye_static then
        return
      end
      local tempGender = 0
      local realGender = eye_static.Sex
      if bodyType == "hf_doram_002" then
        bodyType = 1
        tempGender = 2
      elseif bodyType == "hf_doram_001" then
        bodyType = 2
        tempGender = 1
      elseif bodyType == "hf_human_002" then
        bodyType = 3
        tempGender = 2
      elseif bodyType == "hf_human_001" then
        bodyType = 4
        tempGender = 1
      else
        bodyType = 0
      end
      if eye_id and 4 < eye_id and tempGender ~= realGender and nil ~= eye_static.PairItemID then
        parts[partIndex.Eye] = eye_static.PairItemID
      end
    end
  end
end

function Asset_RoleUtility.SetUserRoleParts(userData, parts)
  if not userData then
    return
  end
  local partIndex = Asset_Role.PartIndex
  parts[partIndex.Body] = userData:Get(UDEnum.BODY) or 0
  parts[partIndex.Hair] = userData:Get(UDEnum.HAIR) or 0
  parts[partIndex.LeftWeapon] = userData:Get(UDEnum.LEFTHAND) or 0
  parts[partIndex.RightWeapon] = userData:Get(UDEnum.RIGHTHAND) or 0
  parts[partIndex.Head] = userData:Get(UDEnum.HEAD) or 0
  parts[partIndex.Wing] = userData:Get(UDEnum.BACK) or 0
  parts[partIndex.Face] = userData:Get(UDEnum.FACE) or 0
  parts[partIndex.Tail] = userData:Get(UDEnum.TAIL) or 0
  parts[partIndex.Eye] = userData:Get(UDEnum.EYE) or 0
  parts[partIndex.Mount] = userData:Get(UDEnum.MOUNT) or 0
  parts[partIndex.Mouth] = userData:Get(UDEnum.MOUTH) or 0
  local partIndexEx = Asset_Role.PartIndexEx
  parts[partIndexEx.Gender] = userData:Get(UDEnum.SEX)
  parts[partIndexEx.HairColorIndex] = userData:Get(UDEnum.HAIRCOLOR) or 0
  parts[partIndexEx.EyeColorIndex] = userData:Get(UDEnum.EYECOLOR) or 0
  parts[partIndexEx.BodyColorIndex] = userData:Get(UDEnum.CLOTHCOLOR) or 0
end

function Asset_RoleUtility.CreateMyRoleParts()
  return Asset_RoleUtility.CreateUserRoleParts(Game.Myself and Game.Myself.data.userdata)
end

function Asset_RoleUtility.SetMyRoleParts(parts)
  return Asset_RoleUtility.SetUserRoleParts(Game.Myself and Game.Myself.data.userdata, parts)
end

function Asset_RoleUtility.CreateNpcRoleParts(npcid)
  if nil == Table_Npc[npcid] then
    redlog("Asset_RoleUtility CreateNpcRoleParts Npc表未配，id： ", npcid)
    return
  end
  return Asset_RoleUtility.CreateRoleParts(Table_Npc[npcid])
end

function Asset_RoleUtility.SetNpcRoleParts(npcid, parts)
  return Asset_RoleUtility.SetRoleParts(Table_Npc[npcid], parts)
end

function Asset_RoleUtility.CreateNpcRole(npcid)
  local npcParts = Asset_RoleUtility.CreateNpcRoleParts(npcid)
  local assetRole = Asset_Role.Create(npcParts)
  assetRole:PlayAction_Idle()
  Asset_Role.DestroyPartArray(npcParts)
  return assetRole
end

function Asset_RoleUtility.CreateMonsterRoleParts(monsterid)
  if nil == Table_Monster[monsterid] then
    redlog("Asset_RoleUtility CreateMonsterRoleParts Monster表未配，id： ", monsterid)
    return
  end
  return Asset_RoleUtility.CreateRoleParts(Table_Monster[monsterid])
end

function Asset_RoleUtility.SetMonsterRoleParts(monsterid, parts)
  Asset_RoleUtility.SetRoleParts(Table_Monster[monsterid], parts)
end

function Asset_RoleUtility.CreateMonsterRole(monsterid)
  local monsterParts = Asset_RoleUtility.CreateMonsterRoleParts(monsterid)
  local assetRole = Asset_Role.Create(monsterParts)
  Asset_Role.DestroyPartArray(monsterParts)
  return assetRole
end

function Asset_RoleUtility.CreateNpcOrMonsterRoleParts(staticID)
  if nil == Table_Monster[staticID] and nil == Table_Npc[staticID] then
    redlog("Asset_RoleUtility CreateNpcOrMonsterRoleParts Monster、Npc 表未找到 ", staticID)
    return
  end
  return Asset_RoleUtility.CreateRoleParts(Table_Monster[staticID] or Table_Npc[staticID])
end

function Asset_RoleUtility.SetNpcOrMonsterRoleParts(monsterid, parts)
  if nil == Table_Monster[monsterid] and nil == Table_Npc[monsterid] then
    redlog("Asset_RoleUtility SetNpcOrMonsterRoleParts Monster、Npc 表未找到 ", monsterid)
    return
  end
  Asset_RoleUtility.SetRoleParts(Table_Monster[monsterid] or Table_Npc[monsterid], parts)
end

local fashionPreviewWeaponWithShield = {
  Sword = 1,
  Knife = 1,
  Mace = 1,
  Axe = 1,
  Spear = 1
}
local fashionPreviewProfessionWithShield = {
  [72] = 1,
  [73] = 1,
  [74] = 1,
  [75] = 1
}
local fashionPreviewDoubleHandWeaponPresets = {
  [1] = {
    Sword = 1,
    Knife = 1,
    Katar = 1,
    Axe = 1,
    Knuckle = 1,
    Staff = 1,
    Pistol = 1
  },
  [2] = {
    Sword = 1,
    predicate = function(id, class, sex, parts)
      local classBody = sex == 1 and Table_Class[class].MaleBody or Table_Class[class].FemaleBody
      return classBody == parts[Asset_Role.PartIndex.Body]
    end
  },
  [3] = {Pistol = 1}
}
local fashionPreviewDoubleHandProfession = {
  [31] = 1,
  [32] = 1,
  [33] = 1,
  [34] = 1,
  [35] = 1,
  [122] = 1,
  [123] = 1,
  [124] = 1,
  [125] = 1,
  [203] = 2,
  [204] = 2,
  [205] = 2,
  [173] = 1,
  [174] = 3,
  [175] = 3,
  [625] = 1,
  [785] = 1
}
local HeinrichWeaponType = {Sword = 1, Knife = 1}

function Asset_RoleUtility.SetFashionPreviewParts(id, class, sex, hideOther, parts)
  if not id then
    return
  end
  local partIndex = Asset_Role.PartIndex
  local itemPartIndex = ItemUtil.getItemRolePartIndex(id)
  local mountBody = GameConfig.Mount2Body[id]
  if mountBody then
    itemPartIndex = partIndex.Body
  end
  if itemPartIndex then
    if itemPartIndex == partIndex.Body then
      if mountBody then
        parts[itemPartIndex] = mountBody[sex] or parts[itemPartIndex]
      else
        parts[itemPartIndex] = Table_Equip[id] and Table_Equip[id].Body[Table_Class[class].Race] or parts[itemPartIndex]
      end
      Asset_RoleUtility.ReviseEyeByBody(parts)
    elseif itemPartIndex == partIndex.Hair then
      parts[itemPartIndex] = ShopDressingProxy.Instance:GetHairStyleIDByItemID(id)
    else
      parts[itemPartIndex] = id
    end
  end
  local equiptype = Table_Equip[id].Type
  if fashionPreviewProfessionWithShield[class] then
    if equiptype == "Shield" then
      local rightWeapon = parts[partIndex.RightWeapon]
      if rightWeapon ~= nil and rightWeapon ~= 0 then
        local rightWeaponType = Table_Equip[rightWeapon] and Table_Equip[rightWeapon].Type
        if not fashionPreviewWeaponWithShield[rightWeaponType] then
          parts[partIndex.RightWeapon] = 0
        end
      end
      parts[partIndex.LeftWeapon] = id
    elseif equiptype and not hideOther and fashionPreviewWeaponWithShield[equiptype] then
      local shieldSite = GameConfig.EquipType[3].site[1]
      local shieldItem = BagProxy.Instance.roleEquip:GetEquipBySite(shieldSite)
      if shieldItem and shieldItem.equipInfo and shieldItem.equipInfo.equipData.Type == "Shield" then
        parts[partIndex.LeftWeapon] = shieldItem.staticData.id
      end
    end
  elseif fashionPreviewDoubleHandProfession[class] then
    local preset = fashionPreviewDoubleHandWeaponPresets[fashionPreviewDoubleHandProfession[class]]
    if equiptype and preset and preset[equiptype] then
      local pp = preset.predicate
      parts[partIndex.LeftWeapon] = (not pp or pp(id, class, sex, parts)) and id or 0
    else
      parts[partIndex.LeftWeapon] = 0
    end
    parts[partIndex.RightWeapon] = id
  elseif class == 685 and HeinrichWeaponType[equiptype] and parts[partIndex.LeftWeapon] == 0 then
    parts[partIndex.LeftWeapon] = id
  end
end

function Asset_RoleUtility.GetSuffixReplaceMap(profess, body, sex)
  local classData = Table_Class[profess]
  if classData and classData.ActionSuffixMap and next(classData.ActionSuffixMap) then
    local bodyId = body or 0
    local classBody = sex == 1 and classData.MaleBody or classData.FemaleBody
    local bodyData = Table_Body[bodyId]
    if bodyData then
      if classData.Feature and 0 < classData.Feature & 2 and bodyId ~= classBody and TableUtility.ArrayFindIndex(GameConfig.Dual, bodyId) == 0 then
        return nil
      elseif bodyData.Feature and 0 < bodyData.Feature & FeatureDefines_Body.Fashion then
        return classData.ActionSuffixMap
      end
    end
  end
end
