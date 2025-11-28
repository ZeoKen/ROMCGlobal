EquipFun = {}
local EquipPos = CommonFun.EquipPos
local _CheckSpiritType_1or2 = function(id)
  local staticEquip = Table_Equip[id]
  if staticEquip then
    return staticEquip.SpiritType == 1 or staticEquip.SpiritType == 2
  end
  return false
end
local _CheckEquipIsNew = function(id)
  local staticEquip = Table_Equip[id]
  return nil ~= staticEquip and staticEquip.IsNew == 1
end
local _CheckEquipIsNotNew = function(id)
  local staticEquip = Table_Equip[id]
  return nil ~= staticEquip and staticEquip.IsNew ~= 1
end
local _CheckEquipIsWeapon = function(id)
  local staticEquip = Table_Equip[id]
  return nil ~= staticEquip and staticEquip.EquipType == 1
end
local _CheckIsEquipCompose = function(id)
  return nil ~= Table_EquipCompose[id]
end

function EquipFun.Common_CheckPutOnEquip(main_equip_id, srcUser, pos)
  local shadow_equip_id = srcUser:getEquip(CommonFun.PackType.EPACKTYPE_SHADOWEQUIP, pos)
  shadow_equip_id = shadow_equip_id.id
  if shadow_equip_id == 0 then
    return 0
  end
  if srcUser:HasBuffID(137860) and _CheckEquipIsWeapon(main_equip_id) then
    return 0
  end
  if _CheckIsEquipCompose(shadow_equip_id) then
    if _CheckEquipIsNew(main_equip_id) then
      return 0
    else
      return 43357
    end
  end
  if _CheckSpiritType_1or2(shadow_equip_id) then
    if _CheckEquipIsNotNew(main_equip_id) then
      return 0
    else
      return 43358
    end
  end
end

function EquipFun.CanEquip_Shadow_Shield(shadow_equip_id, srcUser, pos)
  if srcUser:HasBuffID(137860) then
    return 0
  end
  if srcUser:GetClassID() == 685 then
    local equipinfo = srcUser:getEquip(CommonFun.PackType.EPACKTYPE_EQUIP, pos)
    if equipinfo.id ~= 0 and _CheckEquipIsWeapon(equipinfo.id) then
      return 0
    end
  end
  return EquipFun.Common_CheckPutOnViceEquip(shadow_equip_id, srcUser, pos)
end

function EquipFun.Common_CheckPutOnViceEquip(shadow_equip_id, srcUser, pos)
  local main_equip_id = srcUser:getEquip(CommonFun.PackType.EPACKTYPE_EQUIP, pos)
  main_equip_id = main_equip_id.id
  if main_equip_id == 0 then
    if _CheckIsEquipCompose(shadow_equip_id) or _CheckSpiritType_1or2(shadow_equip_id) then
      return 0
    else
      return 43359
    end
  end
  if _CheckEquipIsNew(main_equip_id) then
    if _CheckIsEquipCompose(shadow_equip_id) then
      return 0
    else
      return 43360
    end
  elseif _CheckSpiritType_1or2(shadow_equip_id) then
    return 0
  else
    return 43361
  end
end

function EquipFun.DefaultSuccess()
  return 0
end

function EquipFun.GetEquipID(srcUser, package_type, pos)
  local equipinfo = srcUser:getEquip(package_type, pos)
  return equipinfo.id
end

function EquipFun.CanEquip_Accessory1(id, srcUser, pos)
  local shadow_equip_Accessory1 = EquipFun.GetEquipID(srcUser, CommonFun.PackType.EPACKTYPE_SHADOWEQUIP, pos)
  if shadow_equip_Accessory1 == 0 then
    return 0
  end
  if _CheckIsEquipCompose(shadow_equip_Accessory1) then
    if _CheckEquipIsNew(id) then
      return 0
    else
      return 43357
    end
  end
  if _CheckSpiritType_1or2(shadow_equip_Accessory1) then
    if _CheckEquipIsNotNew(id) then
      return 0
    else
      return 43358
    end
  end
  return -1
end

function EquipFun.CanEquip_Accessory2(id, srcUser, pos)
  local shadow_equip_Accessory2 = EquipFun.GetEquipID(srcUser, CommonFun.PackType.EPACKTYPE_SHADOWEQUIP, pos)
  if shadow_equip_Accessory2 == 0 then
    return 0
  end
  if _CheckIsEquipCompose(shadow_equip_Accessory2) then
    if _CheckEquipIsNew(id) then
      return 0
    else
      return 43357
    end
  end
  if _CheckSpiritType_1or2(shadow_equip_Accessory2) then
    if _CheckEquipIsNotNew(id) then
      return 0
    else
      return 43358
    end
  end
  return -1
end

function EquipFun.CanEquip_Shadow_Accessory1(id, srcUser, pos)
  local main_equip_Accessory1 = EquipFun.GetEquipID(srcUser, CommonFun.PackType.EPACKTYPE_EQUIP, pos)
  if main_equip_Accessory1 == 0 then
    if _CheckIsEquipCompose(id) or _CheckSpiritType_1or2(id) then
      return 0
    else
      return 43359
    end
  end
  if _CheckEquipIsNotNew(main_equip_Accessory1) then
    if _CheckSpiritType_1or2(id) then
      return 0
    else
      return 43361
    end
  end
  if _CheckEquipIsNew(main_equip_Accessory1) then
    if _CheckIsEquipCompose(id) then
      return 0
    else
      return 43360
    end
  end
  return -1
end

function EquipFun.CanEquip_Shadow_Accessory2(id, srcUser, pos)
  local main_equip_Accessory2 = EquipFun.GetEquipID(srcUser, CommonFun.PackType.EPACKTYPE_EQUIP, pos)
  if main_equip_Accessory2 == 0 then
    if _CheckIsEquipCompose(id) or _CheckSpiritType_1or2(id) then
      return 0
    else
      return 43359
    end
  end
  if _CheckEquipIsNotNew(main_equip_Accessory2) then
    if _CheckSpiritType_1or2(id) then
      return 0
    else
      return 43361
    end
  end
  if _CheckEquipIsNew(main_equip_Accessory2) then
    if _CheckIsEquipCompose(id) then
      return 0
    else
      return 43360
    end
  end
  return -1
end

EquipFun.EquipCheckFunc = {
  [EquipPos.EEQUIPPOS_SHIELD] = EquipFun.Common_CheckPutOnEquip,
  [EquipPos.EEQUIPPOS_ARMOUR] = EquipFun.Common_CheckPutOnEquip,
  [EquipPos.EEQUIPPOS_ROBE] = EquipFun.Common_CheckPutOnEquip,
  [EquipPos.EEQUIPPOS_SHOES] = EquipFun.Common_CheckPutOnEquip,
  [EquipPos.EEQUIPPOS_ACCESSORY1] = EquipFun.CanEquip_Accessory1,
  [EquipPos.EEQUIPPOS_ACCESSORY2] = EquipFun.CanEquip_Accessory2,
  [EquipPos.EEQUIPPOS_WEAPON] = EquipFun.DefaultSuccess,
  [EquipPos.EEQUIPPOS_HEAD] = EquipFun.DefaultSuccess,
  [EquipPos.EEQUIPPOS_FACE] = EquipFun.DefaultSuccess,
  [EquipPos.EEQUIPPOS_MOUTH] = EquipFun.DefaultSuccess,
  [EquipPos.EEQUIPPOS_BACK] = EquipFun.DefaultSuccess,
  [EquipPos.EEQUIPPOS_TAIL] = EquipFun.DefaultSuccess,
  [EquipPos.EEQUIPPOS_MOUNT] = EquipFun.DefaultSuccess,
  [EquipPos.EEQUIPPOS_BARROW] = EquipFun.DefaultSuccess,
  [EquipPos.EEQUIPPOS_ARTIFACT] = EquipFun.DefaultSuccess,
  [EquipPos.EEQUIPPOS_ARTIFACT_HEAD] = EquipFun.DefaultSuccess,
  [EquipPos.EEQUIPPOS_ARTIFACT_BACK] = EquipFun.DefaultSuccess,
  [EquipPos.EEQUIPPOS_ARTIFACT_RING1] = EquipFun.DefaultSuccess
}
EquipFun.ShadowEquipCheckFunc = {
  [EquipPos.EEQUIPPOS_SHIELD] = EquipFun.CanEquip_Shadow_Shield,
  [EquipPos.EEQUIPPOS_ARMOUR] = EquipFun.Common_CheckPutOnViceEquip,
  [EquipPos.EEQUIPPOS_ROBE] = EquipFun.Common_CheckPutOnViceEquip,
  [EquipPos.EEQUIPPOS_SHOES] = EquipFun.Common_CheckPutOnViceEquip,
  [EquipPos.EEQUIPPOS_ACCESSORY1] = EquipFun.CanEquip_Shadow_Accessory1,
  [EquipPos.EEQUIPPOS_ACCESSORY2] = EquipFun.CanEquip_Shadow_Accessory2,
  [EquipPos.EEQUIPPOS_WEAPON] = EquipFun.DefaultSuccess,
  [EquipPos.EEQUIPPOS_HEAD] = EquipFun.DefaultSuccess,
  [EquipPos.EEQUIPPOS_FACE] = EquipFun.DefaultSuccess,
  [EquipPos.EEQUIPPOS_MOUTH] = EquipFun.DefaultSuccess,
  [EquipPos.EEQUIPPOS_BACK] = EquipFun.DefaultSuccess,
  [EquipPos.EEQUIPPOS_TAIL] = EquipFun.DefaultSuccess,
  [EquipPos.EEQUIPPOS_MOUNT] = EquipFun.DefaultSuccess,
  [EquipPos.EEQUIPPOS_BARROW] = EquipFun.DefaultSuccess,
  [EquipPos.EEQUIPPOS_ARTIFACT] = EquipFun.DefaultSuccess,
  [EquipPos.EEQUIPPOS_ARTIFACT_HEAD] = EquipFun.DefaultSuccess,
  [EquipPos.EEQUIPPOS_ARTIFACT_BACK] = EquipFun.DefaultSuccess,
  [EquipPos.EEQUIPPOS_ARTIFACT_RING1] = EquipFun.DefaultSuccess
}

function EquipFun.CanEquip(package_type, pos, id, srcUser)
  if not srcUser then
    return -1
  end
  if package_type == CommonFun.PackType.EPACKTYPE_EQUIP then
    local func = EquipFun.EquipCheckFunc[pos]
    if func then
      return func(id, srcUser, pos)
    end
  else
    local func = EquipFun.ShadowEquipCheckFunc[pos]
    if func then
      return func(id, srcUser, pos)
    end
  end
  return -1
end
