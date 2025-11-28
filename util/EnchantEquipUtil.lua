EnchantMenuType = {
  Default = 0,
  SixBaseAttri = 1,
  BaseAttri = 2,
  DefAttri = 3,
  CombineAttri = 4
}
Enchant1rdAttri = {
  "Str",
  "Agi",
  "Vit",
  "Int",
  "Dex",
  "Luk"
}
Enchant2rdAttri = {
  "Hp",
  "Sp",
  "MaxHp",
  "MaxHpPer",
  "MaxSp",
  "MaxSpPer",
  "Atk",
  "AtkPer",
  "MAtk",
  "MAtkPer",
  "Def",
  "DefPer",
  "MDef",
  "MDefPer",
  "Hit",
  "Cri",
  "Flee",
  "AtkSpd",
  "CriRes",
  "CriDamPer",
  "CriDefPer",
  "HealEncPer",
  "BeHealEncPer",
  "DamIncrease",
  "DamReduc",
  "DamRebound",
  "MDamRebound",
  "Vampiric",
  "EquipASPD"
}
Enchant3rdAttri = {
  "SilenceDef",
  "FreezeDef",
  "StoneDef",
  "StunDef",
  "BlindDef",
  "PoisonDef",
  "SlowDef",
  "ChaosDef",
  "CurseDef"
}
EnchantData = class("EnchantData")

function EnchantData:ctor()
  self.datas = {}
end

function EnchantData:Get(itemType)
  local rateKey = itemType and GameConfig.NewClassEquip.EnchantEquipTypeRateMap[itemType]
  if not rateKey then
    return self.datas[1], false
  end
  for i = #self.datas, 1, -1 do
    if EnchantData.CanGet(self.datas[i], itemType) then
      return self.datas[i], true
    end
  end
  return self.datas[1], false
end

function EnchantData:Add(equipEnchant_config)
  table.insert(self.datas, equipEnchant_config)
end

function EnchantData.CanGet(data, itemType)
  local rateKey = itemType and GameConfig.NewClassEquip.EnchantEquipTypeRateMap[itemType]
  if not rateKey then
    return false
  end
  local cantEnchantMap = data.CantEnchant
  if cantEnchantMap[rateKey] ~= 1 then
    return true
  end
  return false
end

local exchangeNameMap = {Armour = "Armor", Shoes = "Shoe"}

function EnchantData:GetByEquipType(equipType)
  if not equipType then
    return self.datas[1], false
  end
  if exchangeNameMap[equipType] then
    equipType = exchangeNameMap[equipType]
  end
  local rateKey = equipType .. "Rate"
  for k, v in pairs(GameConfig.NewClassEquip.EnchantEquipTypeRateMap) do
    if v == rateKey then
      for i = #self.datas, 1, -1 do
        if EnchantData.CanGet(self.datas[i], k) then
          return self.datas[i], true
        end
      end
    end
  end
  return self.datas[1], false
end

EnchantEquipUtil = class("EnchantEquipUtil")
EnchantEquipUtil.Instance = nil

function EnchantEquipUtil:ctor()
  self:Init()
  EnchantEquipUtil.Instance = self
end

function EnchantEquipUtil:Init()
  self.dataMap = {}
  self.combineEffectMap = {}
  for typeKey, enchantType in pairs(EnchantType) do
    self.dataMap[enchantType] = {}
    self.combineEffectMap[enchantType] = {}
  end
  self.costMap = {}
  for key, data in pairs(Table_EquipEnchant) do
    local enchantData = self.dataMap[data.EnchantType][data.AttrType]
    if enchantData == nil then
      enchantData = EnchantData.new()
      self.dataMap[data.EnchantType][data.AttrType] = enchantData
    end
    enchantData:Add(data)
    local key, value = next(data.AttrType2)
    if key and value and data.ComBineAttr ~= "" then
      table.insert(self.combineEffectMap[data.EnchantType], data)
    end
    if not self.costMap[data.EnchantType] then
      self.costMap[data.EnchantType] = {}
      self.costMap[data.EnchantType].ItemCost = data.ItemCost
      self.costMap[data.EnchantType].ZenyCost = data.ZenyCost
    end
  end
  self.priceRateMap = {}
  local priceConfig = Table_EquipEnchantPrice or {}
  for _, data in pairs(priceConfig) do
    if data.AttrType then
      self.priceRateMap[data.AttrType] = data
    end
  end
end

function EnchantEquipUtil:GetEnchantDatasByEnchantType(enchantType)
  return self.dataMap[enchantType]
end

function EnchantEquipUtil:GetEnchantData(enchantType, attri, itemType)
  if not attri or not enchantType then
    errorLog(string.format("GetEnchantData Parama Error (%s %s)", tostring(enchantType), tostring(attri)))
    return
  end
  local edatas = self.dataMap[enchantType]
  if edatas == nil then
    return
  end
  local enchantData = edatas[attri]
  if enchantData == nil then
    return
  end
  return enchantData:Get(itemType)
end

function EnchantEquipUtil:GetAttriPropVO(attriType)
  local pro = RolePropsContainer.config[attriType]
  if nil == pro then
    errorLog(string.format("NO This Attri %s", tostring(attriType)))
  end
  return pro
end

function EnchantEquipUtil:GetMenuType(attriType)
  for pos, type in pairs(Enchant1rdAttri) do
    if attriType == type then
      return EnchantMenuType.SixBaseAttri, pos
    end
  end
  for pos, type in pairs(Enchant2rdAttri) do
    if attriType == type then
      return EnchantMenuType.BaseAttri, pos
    end
  end
  for pos, type in pairs(Enchant3rdAttri) do
    if attriType == type then
      return EnchantMenuType.DefAttri, pos
    end
  end
  errorLog(string.format("(%s) Not Config In EnchantEquipUtil'TopConfig", attriType))
  return EnchantMenuType.Default, 1
end

function EnchantEquipUtil:GetEnchantCost(enchantType)
  return self.costMap[enchantType]
end

function EnchantEquipUtil:GetCombineEffects(enchantType)
  return self.combineEffectMap[enchantType]
end

function EnchantEquipUtil:GetCombineEffect(uniqueId)
  for _, data in pairs(Table_EquipEnchant) do
    if data.UniqID == uniqueId then
      return data
    end
  end
  return nil
end

function EnchantEquipUtil:GetPriceRate(attriType, itemType)
  if attriType then
    local data = self.priceRateMap[attriType]
    if data then
      local key = GameConfig.NewClassEquip.EnchantEquipTypeRateMap[itemType]
      if data[key] then
        return data[key]
      end
    end
  end
  return 0
end

function EnchantEquipUtil:CanGetCombineEffect(data, itemType)
  local canGet1 = EnchantData.CanGet(data, itemType)
  if not canGet1 then
    return
  end
  local attri2 = data.AttrType2[1]
  if attri2 == nil then
    return canGet1
  end
  local rateKey = itemType and GameConfig.NewClassEquip.EnchantEquipTypeRateMap[itemType]
  if not rateKey or data.NoShowEquip[rateKey] == 1 then
    return false
  end
  local enchantType = data.EnchantType
  local data2, canGet2 = self:GetEnchantData(enchantType, attri2, itemType)
  if data2 == nil then
    return false
  end
  return canGet2
end

function EnchantEquipUtil:SetCurrentEnchantId(itemid)
  self.curEnchantItemId = itemid
end

function EnchantEquipUtil:GetCurEnchantId()
  return self.curEnchantItemId
end

local EquipClass = {
  SpearRate = 1,
  SwordRate = 1,
  StaffRate = 1,
  KatarRate = 1,
  BowRate = 1,
  MaceRate = 1,
  AxeRate = 1,
  BookRate = 1,
  KnifeRate = 1,
  InstrumentRate = 1,
  LashRate = 1,
  PotionRate = 1,
  GloveRate = 1,
  DartsRate = 1,
  PistolRate = 1,
  RifleRate = 1,
  ArmorRate = 1,
  ShieldRate = 1,
  RobeRate = 1,
  ShoeRate = 1,
  AccessoryRate = 1,
  OrbRate = 1,
  EikonRate = 1,
  BracerRate = 1,
  BraceletRate = 1,
  TrolleyRate = 1,
  HeadRate = 2,
  WingRate = 2,
  FaceRate = 2,
  TailRate = 2,
  MouthRate = 2
}

function EnchantEquipUtil:CheckEquipEnchantBuff(buffid, equipKey, configs)
  if not configs then
    return false
  end
  local classtype = EquipClass[equipKey]
  local checks = configs[classtype]
  if checks and next(checks) then
    local check1 = checks[1]
    local staticData1 = self:GetCombineEffect(check1)
    if staticData1 and staticData1.NoShowEquip then
      for key, value in pairs(staticData1.NoShowEquip) do
        if key == equipKey then
          return false
        end
      end
    end
    if staticData1 and staticData1.CantEnchant then
      for key, value in pairs(staticData1.CantEnchant) do
        if key == equipKey then
          return false
        end
      end
    end
    local check2 = checks[2]
    local staticData2 = self:GetCombineEffect(check2)
    if staticData2 and staticData2.CantEnchant then
      for key, value in pairs(staticData2.CantEnchant) do
        if key == equipKey then
          return false
        end
      end
    end
    return true
  else
    return false
  end
  return false
end
