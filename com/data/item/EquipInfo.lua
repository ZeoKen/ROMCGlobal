EquipInfo = class("EquipInfo")
EquipTypeEnum = {
  Weapon = 1,
  Cloth = 2,
  Shield = 3,
  Cloak = 4,
  Shoes = 5,
  Ring = 6,
  Necklace = 7,
  Accessory = 8,
  Back = 9,
  Mount = 12
}
local _Type_HeadEquip = {
  [8] = 1,
  [9] = 1,
  [10] = 1,
  [11] = 1,
  [13] = 1
}
local forbitFun = {
  Enchant = 1,
  Strength = 2,
  Refine = 4
}
local EquipFeatures = {Dragon = 1, Transformable = 4}
local _RefineMatValConfig
local RefineMaterialValue = function(lv)
  if not _RefineMatValConfig then
    _RefineMatValConfig = GameConfig.SafeRefineNewConfig and GameConfig.SafeRefineNewConfig.refine_material_value or {}
  end
  return _RefineMatValConfig[lv]
end
local _NoviceRefineMatValConfig
local NoviceRefineMaterialValConfig = function(lv)
  if not _NoviceRefineMatValConfig then
    _NoviceRefineMatValConfig = GameConfig.SafeRefineNewConfig.novice_refine_material_value or {}
  end
  return _NoviceRefineMatValConfig[lv]
end
local _DamageRefineMatValConfig
local DamageRefineMatValConfig = function(lv)
  if not _DamageRefineMatValConfig then
    _DamageRefineMatValConfig = GameConfig.SafeRefineNewConfig and GameConfig.SafeRefineNewConfig.damage_refine_material_value or {}
  end
  return _DamageRefineMatValConfig[lv]
end
local _Novice_DamageRefineMatValConfig
local Novice_DamageRefineMatValConfig = function(lv)
  if not _Novice_DamageRefineMatValConfig then
    _Novice_DamageRefineMatValConfig = GameConfig.SafeRefineNewConfig and GameConfig.SafeRefineNewConfig.damage_novice_refine_material_value or {}
  end
  return _Novice_DamageRefineMatValConfig[lv]
end
EquipInfo.EquipFeature = EquipFeatures

function EquipInfo.IsMountTransformable(mountId)
  local config = Table_Equip[mountId]
  if config then
    return config.Feature and config.Feature & EquipFeatures.Transformable == EquipFeatures.Transformable
  end
end

function EquipInfo.GetDisplayBody(id)
  local displayRace = MyselfProxy.Instance:GetMyRace()
  local equipData = Table_Equip[id]
  local displayBody = equipData and equipData.Body[displayRace]
  if not displayBody and equipData and equipData.Body.female and equipData.Body.male then
    displayBody = isMale and equipData.Body.male[displayRace] or equipData.Body.female[displayRace]
  end
  return displayBody
end

function EquipInfo.IsEquipOfFeature(equipId, feature)
  local config = Table_Equip[equipId]
  if config and feature then
    return config.Feature and config.Feature & feature == feature
  end
end

function EquipInfo:ctor(staticData)
  self.equiped = 0
  self.equipData = nil
  self.upgradeData = nil
  self.upgrade_MaxLv = 0
  self.professCanUse = nil
  self:ResetData(staticData)
end

function EquipInfo:ResetData(staticData)
  self.equipData = staticData
  self.upgradeData = staticData and Table_EquipUpgrade[staticData.id]
  if self.upgradeData then
    self.upgrade_MaxLv = 0
    while self:GetUpgradeMaterialsByEquipLv(self.upgrade_MaxLv + 1) ~= nil do
      self.upgrade_MaxLv = self.upgrade_MaxLv + 1
    end
    if self.upgrade_MaxLv ~= 0 and self.upgradeData.Product then
      self.upgrade_MaxLv = self.upgrade_MaxLv - 1
    end
  end
  self:Set()
  self:InitEquipCanUse()
  if Table_Artifact and Table_Artifact[staticData.id] then
    self.artifact_lv = Table_Artifact[staticData.id].Level
  end
end

function EquipInfo:Set(serverData)
  self.strengthlv = serverData and serverData.strengthlv or 0
  self.strengthlv2 = serverData and serverData.strengthlv2 or 0
  self.refinelv = serverData and serverData.refinelv or 0
  self.extra_refine_value = serverData and serverData.extra_refine_value or 0
  self.refineexp = serverData and serverData.refineexp or 0
  self.damage = serverData and serverData.damage or false
  self.equiplv = serverData and serverData.lv or 0
  self.color = serverData and serverData.color
  self.maxCardSlot = nil
  self.cardslot = serverData and serverData.cardslot or 0
  self.breakstarttime = serverData and serverData.breakstarttime
  self.breakendtime = serverData and serverData.breakendtime
  if self.breakstarttime and self.breakendtime then
    self.breakduration = self.breakendtime - self.breakstarttime
  else
    self.breakduration = nil
  end
  if not self.uniqueEffect then
    local eudata = self.equipData.UniqueEffect
    self.uniqueEffect = {}
    if eudata then
      for k, v in pairs(eudata) do
        for vk, vv in pairs(v) do
          if vk ~= "type" then
            self.uniqueEffect = TableUtil.InsertArray(self.uniqueEffect, vv)
          end
        end
      end
    end
    if 0 < #self.uniqueEffect then
      self.activeUniqueEffect = {}
    end
  end
  if not self.pvp_uniqueEffect then
    self.pvp_uniqueEffect = {}
    local epvpudata = self.equipData.PVPUniqueEffect
    if epvpudata and epvpudata ~= _EmptyTable then
      for k, v in pairs(epvpudata) do
        for vk, vv in pairs(v) do
          if vk ~= "type" then
            self.pvp_uniqueEffect = TableUtil.InsertArray(self.pvp_uniqueEffect, vv)
          end
        end
      end
    end
  end
  if self.activeUniqueEffect and serverData and serverData.buffid then
    for i = 1, #serverData.buffid do
      self.activeUniqueEffect[serverData.buffid[i]] = true
    end
  end
  self.randomEffect = self.randomEffect or {}
  TableUtility.TableClear(self.randomEffect)
  self.randomEffectBaodi = self.randomEffectBaodi or {}
  TableUtility.TableClear(self.randomEffectBaodi)
  if serverData and serverData.attrs then
    local attr, time
    for i = 1, #serverData.attrs do
      attr = serverData.attrs[i]
      self.randomEffect[attr.id] = attr.value / 1000
      local times = {}
      for j = 1, #attr.times do
        time = attr.times[j]
        if time.refresh_times and 0 < #time.refresh_times then
          times[time.formula_id] = time.refresh_times[1]
        elseif 0 < time.refresh_time then
          times[time.formula_id] = time.refresh_time
        end
      end
      self.randomEffectBaodi[attr.id] = times
    end
  end
  self.quench_per = serverData and serverData.quenchper
end

local _Beleliever_RefineNeedValue
local Beleliever_RefineNeedValue = function()
  if not _Beleliever_RefineNeedValue then
    _Beleliever_RefineNeedValue = GameConfig.SafeRefineNewConfig.lottery_refine_need_value
  end
  return _Beleliever_RefineNeedValue
end
local _RefineNeedValue, _Discount_RefineNeedValue
local _InitRefineNeedValue = function()
  _RefineNeedValue = {}
  _Discount_RefineNeedValue = {}
  local ORefineNeedValue = GameConfig.SafeRefineNewConfig and GameConfig.SafeRefineNewConfig.refine_need_value or {}
  for k, v in pairs(ORefineNeedValue) do
    _RefineNeedValue[k] = v[1]
    _Discount_RefineNeedValue[k] = v[2]
  end
end
local RefineNeedValue = function()
  if not _RefineNeedValue then
    _InitRefineNeedValue()
  end
  return _RefineNeedValue
end
local Discount_RefineNeedValue = function()
  if not _Discount_RefineNeedValue then
    _InitRefineNeedValue()
  end
  return _Discount_RefineNeedValue
end
local _RefineNewCostItem
local RefineNewCostItem = function()
  if not _RefineNewCostItem then
    _RefineNewCostItem = GameConfig.SafeRefineNewConfig and GameConfig.SafeRefineNewConfig.new_equip_cost
  end
  return _RefineNewCostItem
end
EquipInfo.MaxRefineVal = math.huge

function EquipInfo.SGetSafeRefineCostConfig(equipId, inDiscount)
  local equipData = Table_Equip[equipId]
  if not equipData then
    return
  end
  local costNums, costItems
  if LotteryProxy.Instance:IsLotteryEquip(equipId) then
    costNums = Beleliever_RefineNeedValue()
    costItems = nil
  else
    costNums = inDiscount and Discount_RefineNeedValue() or RefineNeedValue()
    if equipData.IsNew and equipData.IsNew > 0 then
      costItems = {
        RefineNewCostItem()[equipData.NewEquipRefine or 1]
      }
    end
  end
  return costNums, costItems
end

function EquipInfo:IsNoviceEquip()
  if not ISNoviceServerType then
    return false
  end
  if self.equipData then
    return self.equipData.IsNew == 1 and self.equipData.NewEquipRefine == 4
  end
  return false
end

function EquipInfo.SGetSafeRefineMatVal_SlotExtra(equipId)
  local minCostId = BlackSmithProxy.GetMinCostMaterialID(equipId)
  if not minCostId or equipId == minCostId then
    return 0
  end
  local sData = Table_Equip[minCostId]
  local beCostItem = sData.SubstituteID and Table_Compose[sData.SubstituteID] and Table_Compose[sData.SubstituteID].BeCostItem
  if beCostItem then
    if sData.IsNew and 0 < sData.IsNew then
      local _, costItemIds = EquipInfo.SGetSafeRefineCostConfig(equipId)
      if costItemIds then
        for i = 1, #beCostItem do
          if 0 < TableUtility.ArrayFindIndex(costItemIds, beCostItem[i].id) then
            return 0 < beCostItem[i].num and beCostItem[i].num - 1 or beCostItem[i].num
          end
        end
      end
    else
      for i = 1, #beCostItem do
        if beCostItem[i].id == minCostId then
          return 0 < beCostItem[i].num and beCostItem[i].num - 1 or beCostItem[i].num
        end
      end
    end
  end
  return 0
end

function EquipInfo:GetSafeRefineCostConfig(inDiscount)
  return EquipInfo.SGetSafeRefineCostConfig(self.equipData.id, inDiscount)
end

function EquipInfo:GetSafeRefineCostNum(tolv, inDiscount)
  local config = self:GetSafeRefineCostConfig(inDiscount)
  return config[tolv] or EquipInfo.MaxRefineVal
end

function EquipInfo:GetNoviceRefineDecomposeNum()
  if not self.refinelv or self.refinelv == 0 then
    return 0
  end
  local refineMatVal = self:IsNoviceEquip() and NoviceRefineMaterialValConfig(self.refinelv) or RefineMaterialValue(self.refinelv)
  return refineMatVal or 0
end

function EquipInfo:CalSafeRefineResult(addVal, inDiscount)
  local nowlv = self.refinelv
  local leftVal = self.extra_refine_value + addVal
  local nextlv = nowlv
  local costed = self:GetSafeRefineCostNum(nextlv + 1, inDiscount)
  if leftVal < costed then
    return nowlv, leftVal, costed
  end
  if leftVal == costed then
    return nowlv + 1, leftVal, costed
  end
  while leftVal >= costed do
    nextlv = nextlv + 1
    costed = self:GetSafeRefineCostNum(nextlv, inDiscount)
    leftVal = leftVal - costed
  end
  if leftVal < 0 then
    nextlv = nextlv - 1
  end
  local totalCost = 0
  for i = nextlv, nowlv + 1, -1 do
    totalCost = totalCost + self:GetSafeRefineCostNum(i, inDiscount)
  end
  return nextlv, addVal + self.extra_refine_value, totalCost
end

function EquipInfo:GetSafeRefineValInfo(inDiscount)
  if not self.refinelv then
    return 0, 0
  end
  local config = self:GetSafeRefineCostConfig(inDiscount)
  local max = config[self.refinelv + 1]
  if max == 0 then
    return self.extra_refine_value, 0
  end
  return self.extra_refine_value, max or EquipInfo.MaxRefineVal
end

function EquipInfo:GetSafeRefineMatVal_SlotExtra()
  if not self.baseRefineVal then
    self.baseRefineVal = EquipInfo.SGetSafeRefineMatVal_SlotExtra(self.equipData.id)
  end
  return self.baseRefineVal
end

function EquipInfo:GetNoviceSafeRefineMatVal()
  if not self.noviceBaseRefineVal then
    self.noviceBaseRefineVal = self.equipData.NewEquipDecompose[1][2]
  end
  return self.noviceBaseRefineVal
end

function EquipInfo:GetSafeRefineMatVal()
  local lvVal, safeBaseRefineVal
  if self:IsNoviceEquip() then
    safeBaseRefineVal = self:GetNoviceSafeRefineMatVal()
    lvVal = self.damage and Novice_DamageRefineMatValConfig(self.refinelv) or NoviceRefineMaterialValConfig(self.refinelv)
  else
    safeBaseRefineVal = self:GetSafeRefineMatVal_SlotExtra()
    lvVal = self.damage and DamageRefineMatValConfig(self.refinelv) or RefineMaterialValue(self.refinelv)
  end
  lvVal = lvVal or 0
  return safeBaseRefineVal + lvVal + self.extra_refine_value
end

function EquipInfo:GetReplaceValues()
  if self.equipData then
    return self.equipData.ReplaceValues or 0
  end
  return 0
end

function EquipInfo:GetEffect()
  if self.equipData then
    return next(self.equipData.Effect)
  end
  return nil, nil
end

function EquipInfo:GetBaseEffect()
  if self.equipData then
    return self.equipData.Effect
  end
  return nil
end

function EquipInfo:InitEquipCanUse()
  local equipType = GameConfig.EquipType
  if self.equipData ~= nil and self.equipData.EquipType then
    self.site = equipType[self.equipData.EquipType] and equipType[self.equipData.EquipType].site
    self:RefreshUseByProfess(true)
  else
    self.site = {}
  end
end

function EquipInfo:RefreshUseByProfess(ignoreBannedProfs)
  self.professCanUse = self.professCanUse or {}
  TableUtility.TableClear(self.professCanUse)
  for i = 1, #self.equipData.CanEquip do
    self.professCanUse[self.equipData.CanEquip[i]] = self.equipData.CanEquip[i]
  end
  if not ignoreBannedProfs then
    local bannedPros = ProfessionProxy.GetBannedProfessions()
    for p, _ in pairs(self.professCanUse) do
      if nil ~= bannedPros[p] then
        self.professCanUse[p] = nil
      end
    end
  end
end

function EquipInfo:CanUseByProfess(pro)
  self:RefreshUseByProfess()
  return self.professCanUse[0] ~= nil or self.professCanUse[pro] ~= nil
end

function EquipInfo:GetEquipType()
  if self.equipData ~= nil then
    return self.equipData.EquipType
  else
    return nil
  end
end

function EquipInfo:GetEquipSite()
  return self.site
end

function EquipInfo:GetUniqueEffect()
  if not self.activeUniqueEffect then
    return
  end
  local result, eff, temp = {}
  for i = 1, #self.uniqueEffect do
    eff = self.uniqueEffect[i]
    temp = {}
    temp.id = eff
    temp.active = self.activeUniqueEffect[eff]
    table.insert(result, temp)
  end
  return result
end

function EquipInfo:GetUniqueEffect_UI()
  if not self.activeUniqueEffect then
    return
  end
  local result, eff, temp, buffData = {}
  for i = 1, #self.uniqueEffect do
    eff = self.uniqueEffect[i]
    buffData = Table_Buffer[eff]
    if buffData and buffData.BuffEffect and buffData.BuffEffect.NoShow ~= 1 then
      temp = {}
      temp.id = eff
      temp.active = self.activeUniqueEffect[eff]
      table.insert(result, temp)
    end
  end
  return result
end

function EquipInfo:GetPvpUniqueEffect()
  if not self.activeUniqueEffect then
    return
  end
  local result, eff, temp = {}
  for i = 1, #self.pvp_uniqueEffect do
    eff = self.pvp_uniqueEffect[i]
    temp = {}
    temp.id = eff
    temp.active = self.activeUniqueEffect[eff]
    table.insert(result, temp)
  end
  return result
end

function EquipInfo:GetRandomEffectMap()
  if not self.randomEffect or not next(self.randomEffect) then
    return
  end
  return self.randomEffect
end

local randomEffectListSortFunc = function(l, r)
  return l.id < r.id
end

function EquipInfo:GetRandomEffectList()
  local map = self:GetRandomEffectMap()
  if not map then
    return
  end
  local result = {}
  for k, v in pairs(map) do
    table.insert(result, {id = k, value = v})
  end
  table.sort(result, randomEffectListSortFunc)
  return result
end

function EquipInfo:GetRandomEffectById(id)
  local map = self:GetRandomEffectMap()
  if not map then
    return
  end
  return map[id]
end

function EquipInfo:IsWeapon()
  return self.equipData.EquipType == EquipTypeEnum.Weapon
end

function EquipInfo:BasePropStr()
  local effects = {
    {
      effect = self.equipData.Effect,
      name = "normal",
      lv = 1
    }
  }
  return PropUtil.FormatEffectsByProp(effects, false, " +")
end

function EquipInfo:RefineAndStrInfo(refinelv, strengthlv)
  refinelv = refinelv or self.refinelv
  strengthlv = strengthlv or self.strengthlv
  if whole == nil then
    whole = true
  end
  if same == nil then
    same = true
  end
  local effects = {
    {
      effect = self.equipData.Effect,
      name = "normal",
      lv = 1
    },
    {
      effect = self.equipData.EffectAdd,
      name = "str",
      lv = strengthlv
    },
    {
      effect = self.equipData.RefineEffect,
      name = "refine",
      lv = refinelv
    }
  }
  return PropUtil.FormatEffectsByProp(effects, false, " +")
end

function EquipInfo:StrengthInfo(level, whole, valueColorStr)
  level = level or self.strengthlv
  if whole == nil then
    whole = true
  end
  if whole then
    local effects = {
      {
        effect = self.equipData.Effect,
        name = "normal",
        lv = 1
      },
      {
        effect = self.equipData.EffectAdd,
        name = "str",
        lv = level
      }
    }
    return PropUtil.FormatEffectsByProp(effects, true, " +", nil, valueColorStr)
  else
    local effectAdd = self.equipData.EffectAdd
    local effects = {}
    for k, v in pairs(effectAdd) do
      local data = {}
      data.name = k
      data.value = v
      table.insert(effects, data)
    end
    return PropUtil.FormatEffects(effects, level, " +", nil, valueColorStr)
  end
end

function EquipInfo:RefineInfo(level, whole, same, sperator)
  level = level or self.refinelv
  sperator = sperator or " +"
  if whole == nil then
    whole = false
  end
  if same == nil then
    same = true
  end
  if whole then
    local effects = {
      {
        effect = self.equipData.Effect,
        name = "normal",
        lv = 1
      },
      {
        effect = self.equipData.RefineEffect,
        name = "refine",
        lv = level
      }
    }
    return PropUtil.FormatEffectsByProp(effects, same, sperator)
  else
    local effectAdd = self.equipData.RefineEffect
    local effects = {}
    for k, v in pairs(effectAdd) do
      local data = {}
      data.name = k
      data.value = v
      table.insert(effects, data)
    end
    return PropUtil.FormatEffects(effects, level, sperator)
  end
end

function EquipInfo:SetRefine(refinelv)
  self.refinelv = refinelv
end

function EquipInfo:SetEquipStrengthLv(lv)
  self.strengthlv = lv
end

function EquipInfo:SetEquipGuildStrengthLv(lv)
  self.strengthlv2 = lv
end

function EquipInfo:GetUpgradeMaterialsByEquipLv(equiplv)
  if nil == self.upgradeData then
    return nil
  end
  equiplv = equiplv or self.equiplv
  local materialsKey = "Material_" .. tostring(equiplv)
  local materials = self.upgradeData[materialsKey]
  if materials and 0 < #materials then
    return materials
  end
  return nil
end

function EquipInfo:CanUpgrade()
  if self.upgradeData ~= nil then
    return self:GetUpgradeMaterialsByEquipLv(self.equiplv + 1) ~= nil
  end
  return false
end

function EquipInfo:CanUpgrade_ByClassDepth(classdepth, equiplv)
  if not self.upgradeData then
    return false
  end
  local classDepthLimit_2 = self.upgradeData.ClassDepthLimit_2
  if classDepthLimit_2 and classdepth < 2 and equiplv >= classDepthLimit_2 then
    return false, 2
  end
  return true
end

function EquipInfo:CanUpgradeInfoBeEffect_ByClassDepth(classdepth, equiplv)
  if not self.upgradeData then
    return false
  end
  local classDepthLimit_2 = self.upgradeData.ClassDepthLimit_2
  if classDepthLimit_2 and classdepth < 2 and equiplv and equiplv >= classDepthLimit_2 then
    return false, 2
  end
  return true
end

function EquipInfo:GetUpgradeBuffIdByEquipLv(equiplv)
  if nil == self.upgradeData then
    return nil
  end
  equiplv = equiplv or self.equiplv
  local buffKey = "BuffID_" .. tostring(equiplv)
  local data = self.upgradeData[buffKey]
  local buffid = {}
  local check_is_noshow = function(buff)
    if not buff then
      return
    end
    local data = Table_Buffer[buff]
    return data and data.BuffEffect and data.BuffEffect.NoShow == 1
  end
  if type(data) == "table" then
    for i = 1, #data do
      if not check_is_noshow(data[i]) then
        buffid[#buffid + 1] = data[i]
      end
    end
  elseif not check_is_noshow(data) then
    buffid[#buffid + 1] = data
  end
  return buffid
end

function EquipInfo:CanStrength()
  return self:CanStrength_ByStaticData()
end

function EquipInfo:CanStrength_ByStaticData()
  if self.equipData.ForbidFuncBit ~= nil and self.equipData.ForbidFuncBit & forbitFun.Strength > 0 then
    return false
  end
  if self.equipData and self.equipData.EquipType then
    local config = GameConfig.EquipType[self.equipData.EquipType]
    local sites = config and config.site
    sites = type(sites) == "table" and sites or {}
    return type(sites[1]) == "number" and sites[1] ~= 0
  end
  return false
end

function EquipInfo:CanRefine()
  return self:CanRefine_ByStaticData()
end

function EquipInfo:CanRefine_ByStaticData()
  if self.equipData.EquipType == 12 then
    return false
  end
  if self.equipData.ForbidFuncBit == nil then
    return true
  end
  return self.equipData.ForbidFuncBit & forbitFun.Refine <= 0
end

function EquipInfo:CanEnchant()
  if GameConfig.SystemForbid.FashionEquipEnchant then
    return false
  end
  return self:CanEnchant_ByStaticData()
end

function EquipInfo:CanEnchant_ByStaticData()
  if self.equipData.ForbidFuncBit == nil then
    return true
  end
  return self.equipData.ForbidFuncBit & forbitFun.Enchant <= 0
end

function EquipInfo:CanAncientRandom()
  return self:CanAncientRandom_ByStaticData()
end

function EquipInfo:CanAncientRandom_ByStaticData()
  if self.equipData.EquipType == 12 then
    return false
  end
  if not self.equipData.NewEquipRefine then
    return false
  end
  if not self.equipData.SpiritType then
    return false
  end
  if self.equipData.ForbidFuncBit == nil then
    return true
  end
  return self.equipData.ForbidFuncBit & forbitFun.Refine <= 0
end

function EquipInfo:CanAncientUpgrade()
  return self:CanAncientUpgrade_ByStaticData()
end

function EquipInfo:CanAncientUpgrade_ByStaticData()
  if self.equipData.EquipType == 12 then
    return false
  end
  if not self.equipData.NewEquipRefine then
    return false
  end
  if not self.equipData.SpiritType then
    return false
  end
  if self.equipData.Spirit == 1 then
    return false
  end
  if self.equipData.ForbidFuncBit == nil then
    return true
  end
  return self.equipData.ForbidFuncBit & forbitFun.Refine <= 0
end

function EquipInfo:MaxQunenchPer()
  if not self:CanQuench_ByStaticData() then
    return nil
  end
  if not self.maxQuenchPer then
    local siteConfig = GameConfig.EquipType[self.equipData.EquipType]
    local pos = siteConfig and siteConfig.site[1]
    if pos then
      self.maxQuenchPer = ItemUtil.GetMaxQuenchPer(pos)
    end
  end
  return self.maxQuenchPer
end

function EquipInfo:CanQuench_ByStaticData()
  if not self.site or #self.site == 0 then
    return false
  end
  if not self.quenchMenuUnlock then
    local unlockConfig = GameConfig.ShadowEquip and GameConfig.ShadowEquip.PosUnlock
    local menuid = unlockConfig and unlockConfig[self.site[1]] and unlockConfig[self.site[1]].UnlockMenu
    if menuid and FunctionUnLockFunc.Me():CheckCanOpen(menuid) then
      self.quenchMenuUnlock = true
    else
      return false
    end
  end
  if self.equipData.SpiritType then
    return true
  end
  local id = self.equipData.id
  if Table_EquipCompose[id] then
    return true
  end
  return false
end

function EquipInfo:Clone(other)
  self:Set(other)
  self.equiplv = other.equiplv
  self.site = other.site
  self.randomEffect = table.deepcopy(other.randomEffect)
  self.randomEffectBaodi = table.deepcopy(other.randomEffectBaodi)
  self.quench_per = other.quench_per
end

function EquipInfo:SetUpgradeCheckDirty()
  self.upgrade_checkdirty = true
end

function EquipInfo.GetEquipCheckTypes()
  local pacakgeCheck = GameConfig.PackageMaterialCheck
  local upgradeCheckTypes
  if pacakgeCheck then
    upgradeCheckTypes = pacakgeCheck.upgrade or pacakgeCheck.default
  else
    upgradeCheckTypes = {1, 9}
  end
  return upgradeCheckTypes
end

function EquipInfo:CheckCanUpgradeSuccess(isMyEquip, item_guid)
  if self.upgradeData == nil then
    return false
  end
  if not self:CanUpgrade() then
    return false
  end
  if self.upgrade_checkdirty == false then
    return self.canUpgrade_success
  end
  self.upgrade_checkdirty = false
  self.canUpgrade_success = false
  local equiplv = self.equiplv
  if isMyEquip then
    local myClass = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
    local classDepth = ProfessionProxy.Instance:GetDepthByClassId(myClass)
    if not self:CanUpgrade_ByClassDepth(classDepth, equiplv + 1) then
      return false
    end
  end
  local materialsKey = "Material_" .. equiplv + 1
  local cost = self.upgradeData[materialsKey]
  local _BlackSmithProxy, _BagProxy, searchItems = BlackSmithProxy.Instance, BagProxy.Instance
  for i = 1, #cost do
    local sc = cost[i]
    local searchNum = 0
    if sc.id ~= 100 then
      if ItemData.CheckIsEquip(sc.id) then
        searchItems = _BlackSmithProxy:GetMaterialEquips_ByEquipId(sc.id, nil, true, nil, self:GetEquipCheckTypes(), function(param, itemData)
          if itemData.equipInfo ~= self then
            searchNum = searchNum + itemData.num
          end
        end)
      else
        searchItems = _BagProxy:GetMaterialItems_ByItemId(sc.id, self.GetEquipCheckTypes())
        for j = 1, #searchItems do
          if _BagProxy:CheckIfFavoriteCanBeMaterial(searchItems[i]) ~= false then
            searchNum = searchNum + searchItems[j].num
          end
        end
      end
    else
      searchNum = Game.Myself.data.userdata:Get(UDEnum.SILVER)
    end
    if searchNum < sc.num then
      self.canUpgrade_success = false
      return false
    end
  end
  self.canUpgrade_success = true
  return true
end

function EquipInfo:IsMount()
  return self.equipData.EquipType == EquipTypeEnum.Mount
end

function EquipInfo:IsHeadEquipType()
  local t = self.equipData.EquipType
  return nil ~= _Type_HeadEquip[t]
end

function EquipInfo:IsArtifact()
  local etype = self.equipData.EquipType
  local cfg = GameConfig.EquipType[etype]
  if cfg == nil then
    return false
  end
  return cfg.equipBodyIndex == "Artifact"
end

function EquipInfo:IsRelics()
  local etype = self.equipData.EquipType
  local cfg = GameConfig.EquipType[etype]
  if cfg == nil then
    return false
  end
  return cfg.equipBodyIndex == "PersonalArtifact"
end

function EquipInfo:GetMyGroupFashionEquip()
  local equipSData = self.equipData
  if equipSData.id ~= equipSData.GroupID then
    return
  end
  local sDatas = AdventureDataProxy.Instance:GetFashionGroupEquipsByGroupId(equipSData.GroupID)
  local mySex = MyselfProxy.Instance:GetMySex()
  local d = sDatas[1]
  for i = 1, #sDatas do
    if sDatas[i].SexEquip == mySex then
      d = sDatas[i]
      break
    end
  end
  return d
end

function EquipInfo:IsMyDisplayForbid()
  if not Game.Myself.data:IsHuman() then
    return self.equipData.DisplayForbid and self.equipData.DisplayForbid > 0
  end
  return false
end

function EquipInfo:HasFeature(f)
  local feature = self.equipData.Feature
  return feature ~= nil and feature & f == f
end

function EquipInfo:IsBarrow()
  return self.equipData.Type == "Barrow"
end

function EquipInfo:IsNextGen()
  return self.equipData.IsNew ~= nil and self.equipData.IsNew > 0
end

function EquipInfo:GetUpgradeReplaceLv()
  if self.upgradeData and self.upgradeData.Product and self.upgrade_MaxLv then
    return self.upgrade_MaxLv + 1
  else
    return self.upgrade_MaxLv
  end
end

function EquipInfo:CanRefineTransfer()
  return self:IsNextGen() or self:IsHeadWearTypeTransferValid()
end

function EquipInfo:IsHeadWearTypeTransferValid()
  if self:IsHeadEquipType() then
    local searchMap = Table_HeadwearRepair[self.equipData.id]
    local canTransfer = searchMap and searchMap.RefineTransfer and searchMap.RefineTransfer == 1 or false
    return canTransfer
  end
  return false
end

function EquipInfo:GetSiteReplaceCost(cardslot)
  if not replaceCostCfg then
    return
  end
  cardslot = cardslot or self.cardslot or 0
  local costCfg = replaceCostCfg[cardslot + 1]
  if not costCfg then
    return
  end
  if not self.site or #self.site == 0 then
    return
  end
  return costCfg[self.site[1]]
end

function EquipInfo:GetCardSlot()
  if self.equipData.CardSlot and self.equipData.CardSlot > 0 then
    return self.equipData.CardSlot
  end
  return self.cardslot
end

function EquipInfo:GetMaxCardSlot()
  if self.maxCardSlot then
    return self.maxCardSlot
  end
  self.maxCardSlot = self.equipData.CardSlot or 0
  local sid = self.equipData.SubstituteID
  if sid then
    local cData = Table_Compose[sid]
    local nextEquipId = cData and cData.Product.id
    if not cData then
      redlog("no compose", sid)
    end
    if nextEquipId then
      while nextEquipId ~= nil and self.maxCardSlot < 5 do
        local eData = Table_Equip[nextEquipId]
        if eData and eData.CardSlot then
          self.maxCardSlot = eData.CardSlot
        end
        if eData and eData.SubstituteID then
          cData = Table_Compose[eData.SubstituteID]
          if cData then
            nextEquipId = cData.Product.id
          else
            nextEquipId = nil
          end
        else
          nextEquipId = nil
        end
      end
    end
  else
    local staticSlot = self.equipData.CardSlot or 0
    local dynamicSlot = self.cardslot or 0
    self.maxCardSlot = math.max(staticSlot, dynamicSlot)
    while self:GetSiteReplaceCost(self.maxCardSlot) and self.maxCardSlot < 5 do
      self.maxCardSlot = self.maxCardSlot + 1
    end
  end
  return self.maxCardSlot
end
