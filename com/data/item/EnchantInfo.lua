EnchantAttriQuality = {
  Good = "EnchantAttriQuality_Good",
  Normal = "EnchantAttriQuality_Normal",
  Bad = "EnchantAttriQuality_Bad"
}
local _getConfigStageconsumptionIndex = function(ratio)
  if ratio < 0.4 then
    return "1"
  elseif ratio < 0.6 then
    return "2"
  elseif ratio < 0.8 then
    return "3"
  elseif ratio < 0.9 then
    return "4"
  elseif ratio <= 1 then
    return "5"
  else
    return "5"
  end
end
local config = GameConfig.EnchantFunc
local QualitySortValue = {
  [EnchantAttriQuality.Good] = config and config.sort_value_quality_good or 5,
  [EnchantAttriQuality.Normal] = config and config.sort_value_quality_normal or 3,
  [EnchantAttriQuality.Bad] = config and config.sort_value_quality_bad or 1
}
local Epsilon = 1.0E-5
local BanBuffIdMap = {
  [500061] = 1,
  [500062] = 1,
  [500063] = 1,
  [500064] = 1,
  [500001] = 1,
  [500002] = 1,
  [500003] = 1,
  [500004] = 1
}
local BanBuff1 = {
  [500061] = 1,
  [500062] = 1,
  [500063] = 1,
  [500064] = 1
}
local BanBuff2 = {
  [500001] = 1,
  [500002] = 1,
  [500003] = 1,
  [500004] = 1
}
EnchantAttri = class("EnchantAttri")

function EnchantAttri:ctor(enchantType, attri, itemId, refreshIndex)
  self.itemId = itemId
  self.itemType = Table_Item[itemId].Type
  self.enchantType = enchantType
  self.type = attri.type
  self.refreshIndex = refreshIndex
  local attriValue = attri.serverValue or attri.value
  self.serverValue = attriValue
  self.propVO = EnchantEquipUtil.Instance:GetAttriPropVO(attri.type)
  self.value = self.propVO.isPercent and attriValue / 10 or attriValue
  self.name = self.propVO and self.propVO.displayName
  self.Quality = EnchantAttriQuality.Normal
  self.sortValue = 0
  self.typekey = self.propVO.name
  local enchantData = EnchantEquipUtil.Instance:GetEnchantData(self.enchantType, self.typekey, self.itemType)
  if not enchantData then
    redlog(string.format("(%s %s) not Find EnchantData", self.typekey, self.propVO.displayName))
    return
  end
  self.staticData = enchantData
  self.staticData4AttrUp = EnchantEquipUtil.Instance:GetEnchantData(SceneItem_pb.EENCHANTTYPE_SENIOR, self.typekey, self.itemType)
  if not self.staticData4AttrUp then
    redlog("未找到高级附魔配置 displayName|itemType ", self.propVO.displayName, self.itemType)
    return
  end
  local attriBound = self.staticData.AttrBound[1]
  local staticMaxAttrValue = attriBound[2]
  local staticMaxAttrValue4AttrUp = self.staticData4AttrUp.AttrBound[1][2]
  local isPercent = self.propVO.isPercent
  self.maxBuffLv = #self.staticData.AddAttr
  self.maxAttrValue = isPercent and staticMaxAttrValue * 100 or staticMaxAttrValue
  self.maxAttrValue4AttrUp = isPercent and staticMaxAttrValue4AttrUp * 100 or staticMaxAttrValue4AttrUp
  self.isMax = self.value >= self.maxAttrValue4AttrUp
  self.valueRatio = self.value / self.maxAttrValue4AttrUp
  local index = _getConfigStageconsumptionIndex(self.valueRatio)
  self.attUpCost = self.staticData4AttrUp["Stageconsumption" .. index]
  if self.staticData.ExpressionOfMaxUp then
    local maxJudge = self.staticData.ExpressionOfMaxUp * staticMaxAttrValue
    if isPercent then
      maxJudge = maxJudge * 100
    end
    if self:IsValuable() and maxJudge <= self.value then
      self.Quality = EnchantAttriQuality.Good
    end
  end
  if self.staticData.ExpressionOfMaxDown then
    local minJudge = self.staticData.ExpressionOfMaxDown * staticMaxAttrValue
    if isPercent then
      minJudge = minJudge * 100
    end
    if minJudge >= self.value then
      self.Quality = EnchantAttriQuality.Bad
    end
  end
  local max_sortValue = GameConfig.EnchantFunc and GameConfig.EnchantFunc.sort_value_max or 10
  self.sortValue = self.isMax and max_sortValue or QualitySortValue[self.Quality]
end

function EnchantAttri:GetValueRatio()
  return self.valueRatio
end

function EnchantAttri:IsValuable()
  local compareValue = GameConfig.Exchange.GoodRate or 1.3
  local value = EnchantEquipUtil.Instance:GetPriceRate(self.typekey, self.itemType)
  return compareValue <= value
end

function EnchantAttri:GetAttriStr()
  local id = self.staticData.id
  local uniqID = self.staticData.UniqID
  local str = id .. uniqID .. self.value
  return str
end

EnchantInfo = class("EnchantInfo")
EnchantType = {
  Primary = SceneItem_pb.EENCHANTTYPE_PRIMARY,
  Medium = SceneItem_pb.EENCHANTTYPE_MEDIUM,
  Senior = SceneItem_pb.EENCHANTTYPE_SENIOR
}

function EnchantInfo:ctor(itemId, quench)
  self.itemId = itemId
  self.quench = quench
  self.enchantAttrs = {}
  self.combineEffectlist = {}
end

function EnchantInfo:SetMyServerData(serverData)
  self.minRatioAttrType = nil
  self.enchantUp_NextAttrValue = nil
  self.thirdAttrType = nil
  self.combineAttrMap = nil
  self.allAttrIsMax = nil
  self.enchantType = serverData.type
  EnchantInfo.SetServerData(serverData, self.enchantAttrs, self.combineEffectlist, self.itemId)
  self.attrSortValue = 0
  for i = 1, #self.enchantAttrs do
    self.attrSortValue = self.attrSortValue + self.enchantAttrs[i].sortValue
  end
  self.combineSortValue = self:GetCombineEffectSortValue()
end

function EnchantInfo:SetServerIndex(i)
  self.serverIndex = i
end

function EnchantInfo:SetMyServerAttri(enchantType, attri)
  return EnchantInfo.SetServerAttri(enchantType, attri, self.itemId)
end

function EnchantInfo:Clone()
  local retInfo = EnchantInfo.new(self.itemId)
  retInfo.enchantType = self.enchantType
  for i = 1, #self.enchantAttrs do
    retInfo.enchantAttrs[i] = EnchantInfo.SetServerAttri(self.enchantAttrs[i].enchantType, self.enchantAttrs[i], self.itemId)
  end
  for i = 1, #self.combineEffectlist do
    retInfo.combineEffectlist[i] = EnchantInfo.SetCombineEffect(self.combineEffectlist[i].buffid, self.combineEffectlist[i].configid)
  end
  return retInfo
end

local enchantAttrUpWorkLv
local _Separator = "[Quench]"

function EnchantInfo.SetCombineEffect(buffid, configid)
  if buffid then
    local cbeData = {}
    cbeData.buffid = buffid
    cbeData.configid = configid
    cbeData.buffData = Table_Buffer[buffid]
    if not cbeData.buffData then
      redlog(string.format("Not Have Buff(%s)", tostring(buffid)))
      return nil
    end
    cbeData.isWork = false
    enchantAttrUpWorkLv = enchantAttrUpWorkLv or config and config.enchantAttrUpWorkLv or 3
    cbeData.Condition = {}
    cbeData.buffLv = buffid % 10
    local sdata = EnchantEquipUtil.Instance:GetCombineEffect(configid)
    if sdata then
      cbeData.maxLvBuffId = buffid // 10 * 10 + #sdata.AddAttr
      cbeData.maxLvBuffData = Table_Buffer[cbeData.maxLvBuffId]
      cbeData.Condition = sdata.Condition
      if sdata.Condition.type == 1 then
        cbeData.WorkTip = string.format(ZhString.EnchantInfo_RefineCondition, sdata.Condition.refinelv)
      end
      cbeData.enchantData = sdata
      cbeData.combineAttrMap = {}
      cbeData.combineAttrMap[sdata.AttrType] = 1
      if sdata.AttrType2 and #sdata.AttrType2 > 0 then
        cbeData.combineAttrMap[sdata.AttrType2[1]] = 1
      else
        cbeData.isSpecial3rdAttr = true
      end
      cbeData.attrUpWork = cbeData.buffLv >= enchantAttrUpWorkLv and not cbeData.isSpecial3rdAttr and BanBuffIdMap[buffid] == nil
    end
    return cbeData
  end
end

function EnchantInfo:GetCombineAttrMap()
  if not self.combineEffectlist or not next(self.combineEffectlist) then
    return
  end
  if not self.combineAttrMap then
    for i = 1, #self.combineEffectlist do
      self.combineAttrMap = self.combineEffectlist[i].combineAttrMap
      if self.combineAttrMap then
        break
      end
    end
  end
  return self.combineAttrMap
end

function EnchantInfo:UpdateCombineEffectWork(refinelv)
  for i = 1, #self.combineEffectlist do
    EnchantInfo._UpdateCombineEffectWork(self.combineEffectlist[i], refinelv)
  end
end

function EnchantInfo._UpdateCombineEffectWork(combineEffect, refinelv)
  if combineEffect and combineEffect.Condition and combineEffect.Condition.type == 1 then
    combineEffect.isWork = EnchantInfo.CombineEffectWorkPredicate(combineEffect, refinelv)
  end
end

function EnchantInfo:CheckAttrUpWorkValid()
  local combineEffect = self.combineEffectlist
  if not combineEffect or not next(combineEffect) then
    return false
  end
  local buffid
  for i = 1, #combineEffect do
    buffid = combineEffect[i].buffid
    if buffid then
      if BanBuff1[buffid] then
        return false, ZhString.Enchant_BuffInValid1
      elseif BanBuff2[buffid] then
        return false, ZhString.Enchant_BuffInValid2
      end
    end
    if combineEffect[i].attrUpWork then
      if self:CheckAllAttrIsMax() then
        return false, ZhString.EnchantAttrUp_AllMAX
      end
      return true
    end
  end
  return false
end

function EnchantInfo:GetCombineEffectSortValue()
  local combineEffect = self.combineEffectlist
  if not combineEffect or not next(combineEffect) then
    return 0
  end
  for i = 1, #combineEffect do
    if combineEffect[i].buffLv then
      return combineEffect[i].buffLv
    end
  end
  return 0
end

function EnchantInfo:CheckThirdAttrResetValid()
  local combineEffect = self.combineEffectlist
  if not combineEffect or not next(combineEffect) then
    return false
  end
  local buffid
  for i = 1, #combineEffect do
    buffid = combineEffect[i].buffid
    if buffid then
      if BanBuff1[buffid] then
        return false, ZhString.Enchant_BuffInValid1
      elseif BanBuff2[buffid] then
        return false, ZhString.Enchant_BuffInValid2
      end
    end
    if combineEffect[i].isSpecial3rdAttr then
      return false
    end
  end
  return true
end

function EnchantInfo:GetMinRatioAttrType()
  if not self.minRatioAttrType then
    local minRatio = 9999
    local attrs = self.enchantAttrs
    for i = 1, #attrs do
      if attrs[i].valueRatio < minRatio - Epsilon then
        minRatio = attrs[i].valueRatio
        self.minRatioAttrType = attrs[i].type
        local liftvalue = attrs[i].staticData4AttrUp.Liftvalue
        liftvalue = attrs[i].propVO.isPercent and liftvalue * 100 or liftvalue
        self.enchantUp_NextAttrValue = math.min(liftvalue + attrs[i].value, attrs[i].maxAttrValue4AttrUp)
      end
    end
  end
  return self.minRatioAttrType
end

function EnchantInfo:GetAttrUpCostConfig()
  local minRatioAttrType = self:GetMinRatioAttrType()
  for i = 1, #self.enchantAttrs do
    if self.enchantAttrs[i].type == minRatioAttrType then
      return self.enchantAttrs[i].attUpCost
    end
  end
end

function EnchantInfo:CheckAllAttrIsMax()
  if nil == self.allAttrIsMax then
    self.allAttrIsMax = true
    for i = 1, #self.enchantAttrs do
      if not self.enchantAttrs[i].isMax then
        self.allAttrIsMax = false
        break
      end
    end
  end
  return self.allAttrIsMax
end

function EnchantInfo:GetThirdAttrType()
  local combineAttrMap = self:GetCombineAttrMap()
  if not combineAttrMap or not next(combineAttrMap) then
    return
  end
  if not self.thirdAttrType then
    for i = 1, #self.enchantAttrs do
      if not combineAttrMap[self.enchantAttrs[i].typekey] then
        self.thirdAttrType = self.enchantAttrs[i].type
      end
    end
  end
  return self.thirdAttrType
end

function EnchantInfo.CombineEffectWorkPredicate(combineEffect, refinelv)
  return refinelv >= combineEffect.Condition.refinelv
end

function EnchantInfo:GetEnchantAttrs()
  return self.enchantAttrs
end

function EnchantInfo:GetCombineEffects()
  return self.combineEffectlist
end

function EnchantInfo:HasAttri()
  return #self.enchantAttrs > 0
end

function EnchantInfo:HasNewGoodAttri()
  local hasGood = false
  for i = 1, #self.enchantAttrs do
    local attir = self.enchantAttrs[i]
    if attir.Quality == EnchantAttriQuality.Good then
      hasGood = true
      break
    end
  end
  hasGood = hasGood or #self.combineEffectlist > 0
  return hasGood
end

function EnchantInfo:IsShowWhenTrade()
  local itemType = Table_Item[self.itemId].Type
  local rateKey = GameConfig.NewClassEquip.EnchantEquipTypeRateMap[itemType]
  if rateKey and #self.combineEffectlist > 0 then
    for i = 1, #self.combineEffectlist do
      local combineEffect = self.combineEffectlist[i]
      if combineEffect.enchantData and combineEffect.enchantData.NoExchangeEnchant[rateKey] == 1 then
        return false
      end
      local buffid = combineEffect.buffid
      if buffid and BanBuffIdMap[buffid] then
        return false
      end
    end
    return true
  end
  return false
end

function EnchantInfo.SetServerAttri(enchantType, attri, itemId, refreshIndex)
  return EnchantAttri.new(enchantType, attri, itemId, refreshIndex)
end

function EnchantInfo.SetServerData(serverData, enchantAttrList, combineEffectList, itemId)
  if not (serverData and enchantAttrList) or not combineEffectList then
    return
  end
  TableUtility.ArrayClear(enchantAttrList)
  TableUtility.ArrayClear(combineEffectList)
  local attrs = serverData.attrs
  if attrs then
    for i = 1, #attrs do
      table.insert(enchantAttrList, EnchantInfo.SetServerAttri(serverData.type, attrs[i], itemId))
    end
  end
  local ebuffids = serverData.extras
  if ebuffids then
    local ebuff, cbeData
    for i = 1, #ebuffids do
      ebuff = ebuffids[i]
      cbeData = EnchantInfo.SetCombineEffect(ebuff.buffid, ebuff.configid)
      if cbeData then
        table.insert(combineEffectList, cbeData)
      end
    end
  end
end

function EnchantInfo:GetAttriStr()
  local str = ""
  for i = 1, #self.enchantAttrs do
    local singleStr = self.enchantAttrs[i]:GetAttriStr()
    str = str .. singleStr
  end
  return str
end

function EnchantInfo:GetCombineEffectStr()
  local str = ""
  for i = 1, #self.combineEffectlist do
    local cbeData = self.combineEffectlist[i]
    str = str .. cbeData.buffid .. cbeData.configid
  end
  return str
end
