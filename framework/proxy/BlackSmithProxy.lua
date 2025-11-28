autoImport("RefineTypeData")
BlackSmithProxy = class("BlackSmithProxy", pm.Proxy)
BlackSmithProxy.Instance = nil
BlackSmithProxy.NAME = "BlackSmithProxy"
BlackSmithProxy.RefineLimitQuality = 3
BlackSmithProxy.HRefinePropValueMap = {Refine = 1, MRefine = 0}

function BlackSmithProxy:ctor(proxyName, data)
  self.proxyName = proxyName or BlackSmithProxy.NAME
  if BlackSmithProxy.Instance == nil then
    BlackSmithProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:ParseRefineConfig()
  self:InitAdvancedEnchant()
  self:InitHighRefineCompose()
  self:IntiHighRefine()
end

function BlackSmithProxy:onRegister()
end

function BlackSmithProxy:onRemove()
end

function BlackSmithProxy:ParseRefineConfig()
  self.refineDataMap = {}
  local data, t, refineTypeData
  for k, v in pairs(Table_EquipRefine) do
    data = v
    for j = 1, #data.EuqipType do
      t = data.EuqipType[j]
      refineTypeData = self.refineDataMap[t]
      if not refineTypeData then
        refineTypeData = RefineTypeData.new(t)
        self.refineDataMap[t] = refineTypeData
      end
      refineTypeData:AddData(data)
    end
  end
end

function BlackSmithProxy:SearchMasterByLv(array, lv)
  for i = 1, #array do
    if array[i].Needlv == lv then
      return array[i]
    end
  end
  return nil
end

function BlackSmithProxy:GetNextStrengthMaster(data)
  return self.strengthMaster[(data and data.dynamicIndex or 0) + 1]
end

function BlackSmithProxy:GetNextRefineMaster(data)
  return self.refineMaster[(data and data.dynamicIndex or 0) + 1]
end

function BlackSmithProxy:GetStrengthMaster(lv)
  return self:SearchMasterByLv(self.strengthMaster, lv)
end

function BlackSmithProxy:GetRefineFashonEquips(valid_equiptype_map, sortRule)
  local result = {}
  local fashionEquips = BagProxy.Instance.fashionBag:GetItems()
  local equipInfo
  for i = 1, #fashionEquips do
    equipInfo = fashionEquips[i].equipInfo
    if equipInfo then
      if valid_equiptype_map then
        if valid_equiptype_map[equipInfo.equipData.EquipType] and equipInfo:CanRefine() then
          table.insert(result, fashionEquips[i])
        end
      elseif equipInfo:CanRefine() then
        table.insert(result, fashionEquips[i])
      end
    end
  end
  if sortRule then
    table.sort(result, sortRule)
  else
    BlackSmithProxy.SortEquips(result)
  end
  return result
end

function BlackSmithProxy:GetRefineEquips(valid_equiptype_map, includeFashion, sortRule)
  local result = {}
  if includeFashion then
    local fashionEquips = BagProxy.Instance.fashionBag:GetItems()
    local equipInfo
    for i = 1, #fashionEquips do
      equipInfo = fashionEquips[i].equipInfo
      if equipInfo then
        if valid_equiptype_map then
          if valid_equiptype_map[equipInfo.equipData.EquipType] and equipInfo:CanRefine() then
            table.insert(result, fashionEquips[i])
          end
        elseif equipInfo:CanRefine() then
          table.insert(result, fashionEquips[i])
        end
      end
    end
  end
  local roleEquips = BagProxy.Instance.roleEquip:GetItems()
  local equipInfo
  for i = 1, #roleEquips do
    equipInfo = roleEquips[i].equipInfo
    if equipInfo then
      if valid_equiptype_map then
        if valid_equiptype_map[equipInfo.equipData.EquipType] and equipInfo:CanRefine() then
          table.insert(result, roleEquips[i])
        end
      elseif equipInfo:CanRefine() then
        table.insert(result, roleEquips[i])
      end
    end
  end
  local roleShadowEquips = BagProxy.Instance.shadowBagData:GetItems()
  local equipInfo
  for i = 1, #roleShadowEquips do
    equipInfo = roleShadowEquips[i].equipInfo
    if equipInfo then
      if valid_equiptype_map then
        if valid_equiptype_map[equipInfo.equipData.EquipType] and equipInfo:CanRefine() then
          table.insert(result, roleShadowEquips[i])
        end
      elseif equipInfo:CanRefine() then
        table.insert(result, roleShadowEquips[i])
      end
    end
  end
  local items = BagProxy.Instance:GetBagEquipTab():GetItems()
  for i = 1, #items do
    equipInfo = items[i].equipInfo
    if equipInfo then
      if valid_equiptype_map then
        if valid_equiptype_map[equipInfo.equipData.EquipType] and equipInfo:CanRefine() then
          table.insert(result, items[i])
        end
      elseif equipInfo:CanRefine() then
        table.insert(result, items[i])
      end
    end
  end
  if sortRule then
    table.sort(result, sortRule)
  else
    BlackSmithProxy.SortEquips(result)
  end
  return result
end

function BlackSmithProxy:GetRefineMaster(lv)
  return self:SearchMasterByLv(self.refineMaster, lv)
end

function BlackSmithProxy:SetEquipOptDiscounts(etype, params)
  if etype == nil then
    redlog("etype cannot be nil.")
    return
  end
  self.equipOptDiscount_Map = self.equipOptDiscount_Map or {}
  local discounts = self.equipOptDiscount_Map[etype]
  if discounts == nil then
    discounts = {}
    self.equipOptDiscount_Map[etype] = discounts
  else
    TableUtility.ArrayClear(discounts)
  end
  if params and params[1] then
    for i = 1, #params do
      discounts[i] = params[i]
    end
  end
end

function BlackSmithProxy:GetEquipOptDiscounts(etype)
  if self.equipOptDiscount_Map == nil then
    return _EmptyTable
  end
  return self.equipOptDiscount_Map[etype]
end

function BlackSmithProxy.GetSafeRefineCostConfigName(islottery, isnewequip)
  return islottery and "SafeRefineEquipCostLottery" or isnewequip and "SafeRefineNewEquipCost" or "SafeRefineEquipCost"
end

function BlackSmithProxy.GetSafeRefineCostConfig(islottery, isnewequip, equipData)
  local name = BlackSmithProxy.GetSafeRefineCostConfigName(islottery, isnewequip)
  local cfg = GameConfig[name]
  if name == "SafeRefineNewEquipCost" then
    local index = equipData and equipData.NewEquipRefine
    cfg = cfg and index and cfg[index] or nil
  end
  return cfg, name
end

local safeRefineEquipCostItemIdGetter = {
  SafeRefineEquipCostLottery = function(equip)
    return BlackSmithProxy.GetMinCostMaterialID(equip.staticData.id)
  end,
  SafeRefineNewEquipCost = function(equip, refinelv)
    local cfg = BlackSmithProxy.GetSafeRefineCostConfig(nil, true, equip.equipInfo and equip.equipInfo.equipData)
    if cfg and cfg[refinelv] then
      return cfg[refinelv][1][1]
    end
  end,
  SafeRefineEquipCost = function(equip)
    return BlackSmithProxy.GetMinCostMaterialID(equip.staticData.id)
  end
}
local safeRefineEquipCostNumGetter = {
  SafeRefineEquipCostLottery = function(v)
    return v
  end,
  SafeRefineNewEquipCost = function(v, indiscount)
    return indiscount and v[1][3] or v[1][2]
  end,
  SafeRefineEquipCost = function(v, indiscount)
    return indiscount and v[2] or v[1]
  end
}

function BlackSmithProxy:GetSafeRefineClamp(islottery, targetequipinfo)
  if targetequipinfo then
    local cfg, name = BlackSmithProxy.GetSafeRefineCostConfig(islottery, targetequipinfo:IsNextGen(), targetequipinfo.equipData)
    if cfg then
      local min, max, s
      for lv, data in pairs(cfg) do
        s = safeRefineEquipCostNumGetter[name](data)
        if s ~= 0 then
          min = not min and lv or math.min(min, lv)
          max = not max and lv or math.max(max, lv)
        end
      end
      return min, max
    end
  end
  return 0, 0
end

function BlackSmithProxy:GetSafeRefineCostEquip(equip, refinelv, islottery)
  if not equip or not refinelv then
    return
  end
  local cfg, name = BlackSmithProxy.GetSafeRefineCostConfig(islottery, equip.equipInfo:IsNextGen(), equip.equipInfo.equipData)
  cfg = cfg and cfg[refinelv]
  if not cfg then
    return
  end
  local indiscount = self:GetEquipOptDiscounts(ActivityCmd_pb.GACTIVITY_SAFE_REFINE_DISCOUNT)
  indiscount = indiscount and indiscount[1] or false
  return safeRefineEquipCostItemIdGetter[name](equip, refinelv), safeRefineEquipCostNumGetter[name](cfg, indiscount)
end

function BlackSmithProxy.GetEquipMinVID(itemid)
  local lackEquipId
  local vidCache = EquipRepairProxy.Instance:GetEquipVIDCache(itemid)
  if vidCache then
    local minSlot
    for k, v in pairs(vidCache) do
      if minSlot == nil or k < minSlot then
        minSlot = k
        lackEquipId = v.id
      end
    end
  else
    lackEquipId = itemid
  end
  return lackEquipId
end

function BlackSmithProxy.GetMinCostMaterialID(itemid)
  local composeData = Table_EquipCompose[itemid]
  if composeData then
    itemid = composeData.Material[1].id
  end
  local equipType = Table_Equip[itemid] and Table_Equip[itemid].EquipType
  if equipType ~= 8 then
    itemid = BlackSmithProxy.GetEquipMinVID(itemid)
  end
  return itemid
end

function BlackSmithProxy.SortMaterialEquips(equipA, equipB)
  local slotA, slotB = equipA.cardSlotNum, equipB.cardSlotNum
  if slotA ~= slotB then
    return slotA < slotB
  end
  local equipInfoA, equipInfoB = equipA.equipInfo, equipB.equipInfo
  if equipInfoA.equiplv ~= equipInfoB.equiplv then
    return equipInfoA.equiplv < equipInfoB.equiplv
  end
  if equipInfoA.refinelv ~= equipInfoB.refinelv then
    return equipInfoA.refinelv < equipInfoB.refinelv
  end
  local equipA_hasEnchant = equipA.enchantInfo and equipA.enchantInfo:HasAttri() or false
  local equipB_hasEnchant = equipB.enchantInfo and equipB.enchantInfo:HasAttri() or false
  if equipA_hasEnchant ~= equipB_hasEnchant then
    return not equipA_hasEnchant
  end
  local equipA_CardNum = equipA:GetEquipedCardNum()
  local equipB_CardNum = equipB:GetEquipedCardNum()
  if equipA_CardNum ~= equipB_CardNum then
    return equipA_CardNum < equipB_CardNum
  end
  if equipInfoA.strengthlv2 ~= equipInfoB.strengthlv2 then
    return equipInfoA.strengthlv2 < equipInfoB.strengthlv2
  end
  if equipInfoA.strengthlv ~= equipInfoB.strengthlv then
    return equipInfoA.strengthlv < equipInfoB.strengthlv
  end
  return equipA.staticData.id < equipB.staticData.id
end

function BlackSmithProxy:GetMaterialEquips_ByEquipId(equipid, count, filterDamage, filterFunc, bagTypes, matchCall, matchCallParam, noCheckFavoriteMaterial)
  local equips
  if bagTypes == nil then
    equips = BagProxy.Instance:GetItemsByStaticID(equipid, BagProxy.BagType.MainBag)
  else
    equips = {}
    local bagData, items
    for i = 1, #bagTypes do
      bagData = BagProxy.Instance:GetBagByType(bagTypes[i])
      items = bagData:GetItems()
      for j = 1, #items do
        if items[j].staticData.id == equipid then
          table.insert(equips, items[j])
        end
      end
    end
  end
  if equips == nil or #equips == 0 then
    return _EmptyTable
  end
  table.sort(equips, BlackSmithProxy.SortMaterialEquips)
  local result = {}
  for i = 1, #equips do
    if equips[i].equipInfo.refinelv <= GameConfig.Item.material_max_refine then
      local valid
      if noCheckFavoriteMaterial then
        valid = true
      else
        valid = BagProxy.Instance:CheckIfFavoriteCanBeMaterial(equips[i]) ~= false
      end
      if filterFunc and valid then
        valid = filterFunc(equips[i])
      end
      if valid then
        if filterDamage then
          if not equips[i].equipInfo.damage then
            if matchCall then
              matchCall(matchCallParam, equips[i])
            end
            table.insert(result, equips[i])
          end
        else
          if matchCall then
            matchCall(matchCallParam, equips[i])
          end
          table.insert(result, equips[i])
        end
      end
    end
    if count and #result == count then
      break
    end
  end
  return result
end

local Func_CheckEquip_SameVID = function(itemA, itemB, includeSelf)
  if itemA == nil or itemB == nil then
    return false
  end
  if itemA.id == itemB.id then
    return includeSelf == true
  end
  if itemA.equipInfo == nil or itemB.equipInfo == nil then
    return false
  end
  local vid_a = itemA.equipInfo.equipData.VID
  local vid_b = itemB.equipInfo.equipData.VID
  if vid_a and vid_b then
    return math.floor(vid_a / 10000) == math.floor(vid_b / 10000) and vid_a % 1000 == vid_b % 1000
  end
  return false
end
local Func_CheckEquip_IsComposeMaterial = function(item, checkItem, includeSelf)
  local sid = item.staticData.id
  local sData = sid and Table_EquipCompose[sid]
  if sData == nil then
    return false
  end
  local mainEquipId = sData.Material[1].id
  local mainItem = ItemData.new("Temp", mainEquipId)
  return Func_CheckEquip_SameVID(mainItem, checkItem, includeSelf)
end
BlackSmithProxy.DoEquipsHaveSameVID = Func_CheckEquip_SameVID
local materialEquipsResult = {}

function BlackSmithProxy:GetMaterialEquips_ByVID(itemData, bagTypes, matchCall, matchCallParam, noCheckFavoriteMaterial, includeSelf, maxRefinelv)
  TableUtility.ArrayClear(materialEquipsResult)
  if itemData == nil or itemData.equipInfo == nil then
    return materialEquipsResult
  end
  local isComposeEquip = Table_EquipCompose[itemData.staticData.id] ~= nil
  local bagProxy = BagProxy.Instance
  maxRefinelv = maxRefinelv or GameConfig.Item.material_max_refine
  local item, valid
  if bagTypes == nil then
    local bagItems = bagProxy.bagData:GetItems()
    for i = 1, #bagItems do
      item = bagItems[i]
      if noCheckFavoriteMaterial then
        valid = true
      else
        valid = BagProxy.Instance:CheckIfFavoriteCanBeMaterial(item) ~= false
      end
      if isComposeEquip then
        valid = valid and Func_CheckEquip_IsComposeMaterial(itemData, item, includeSelf)
      else
        valid = valid and Func_CheckEquip_SameVID(itemData, item, includeSelf)
      end
      if item:IsEquip() and item.equipInfo:IsNextGen() then
        valid = valid and false
      end
      if valid and maxRefinelv >= item.equipInfo.refinelv then
        if matchCall then
          matchCall(matchCallParam, item)
        end
        table.insert(materialEquipsResult, item)
      end
    end
  else
    local bagData, bagItems
    for i = 1, #bagTypes do
      bagData = bagProxy:GetBagByType(bagTypes[i])
      bagItems = bagData:GetItems()
      for j = 1, #bagItems do
        item = bagItems[j]
        if noCheckFavoriteMaterial then
          valid = true
        else
          valid = BagProxy.Instance:CheckIfFavoriteCanBeMaterial(item) ~= false
        end
        if isComposeEquip then
          valid = valid and Func_CheckEquip_IsComposeMaterial(itemData, item, includeSelf)
        else
          valid = valid and Func_CheckEquip_SameVID(itemData, item, includeSelf)
        end
        if item:IsEquip() and item.equipInfo:IsNextGen() then
          valid = valid and false
        end
        if valid and maxRefinelv >= item.equipInfo.refinelv then
          if matchCall then
            matchCall(matchCallParam, item)
          end
          table.insert(materialEquipsResult, item)
        end
      end
    end
  end
  table.sort(materialEquipsResult, BlackSmithProxy.SortMaterialEquips)
  return materialEquipsResult
end

function BlackSmithProxy:GetMaterialEquips_ByNewEquipRefine(itemData, bagTypes, matchCall, matchCallParam, noCheckFavoriteMaterial, includeSelf, maxRefinelv)
  TableUtility.ArrayClear(materialEquipsResult)
  if itemData == nil or itemData.equipInfo == nil then
    return materialEquipsResult
  end
  local bagProxy = BagProxy.Instance
  maxRefinelv = maxRefinelv or GameConfig.Item.material_max_refine
  local item, valid
  if bagTypes == nil then
    local bagItems = bagProxy.bagData:GetItems()
    for i = 1, #bagItems do
      item = bagItems[i]
      if noCheckFavoriteMaterial then
        valid = true
      else
        valid = BagProxy.Instance:CheckIfFavoriteCanBeMaterial(item) ~= false
      end
      valid = valid and (item:IsEquip() and itemData.equipInfo.equipData.NewEquipRefine == itemData.equipInfo.equipData.NewEquipRefine or false)
      if item:IsEquip() and item.equipInfo:IsNextGen() then
        valid = valid and false
      end
      if valid and maxRefinelv >= item.equipInfo.refinelv then
        if matchCall then
          matchCall(matchCallParam, item)
        end
        table.insert(materialEquipsResult, item)
      end
    end
  else
    local bagData, bagItems
    for i = 1, #bagTypes do
      bagData = bagProxy:GetBagByType(bagTypes[i])
      bagItems = bagData:GetItems()
      for j = 1, #bagItems do
        item = bagItems[j]
        if noCheckFavoriteMaterial then
          valid = true
        else
          valid = BagProxy.Instance:CheckIfFavoriteCanBeMaterial(item) ~= false
        end
        valid = valid and (item:IsEquip() and item.equipInfo.equipData.NewEquipRefine == itemData.equipInfo.equipData.NewEquipRefine or false)
        if item:IsEquip() and item.equipInfo:IsNextGen() then
          valid = valid and false
        end
        if valid and maxRefinelv >= item.equipInfo.refinelv then
          if matchCall then
            matchCall(matchCallParam, item)
          end
          table.insert(materialEquipsResult, item)
        end
      end
    end
  end
  table.sort(materialEquipsResult, BlackSmithProxy.SortMaterialEquips)
  return materialEquipsResult
end

function BlackSmithProxy:MaxRefineLevelByData(staticData)
  if staticData == nil then
    return 0
  end
  local refineMaxLevel1
  local refineType = self.refineDataMap[staticData.Type]
  if refineType then
    refineMaxLevel1 = refineType:GetRefineMaxLevel(staticData.Quality)
  end
  local refineMaxLevel2
  local equipData = Table_Equip[staticData.id]
  if equipData then
    refineMaxLevel2 = equipData.RefineMaxlv
  end
  if refineMaxLevel1 then
    if refineMaxLevel2 then
      return math.min(refineMaxLevel1, refineMaxLevel2)
    end
    return refineMaxLevel1
  end
  return 0
end

function BlackSmithProxy:GetRefineData(itemType, quality, refineLevel)
  local refineType = self.refineDataMap[itemType]
  if refineType then
    if refineLevel == 0 then
      refineLevel = 1
    end
    return refineType:GetData(quality, refineLevel)
  end
  return nil
end

function BlackSmithProxy:GetComposeIDsByItemData(itemData, isSafe)
  local refineType = self.refineDataMap[itemData.staticData.Type]
  if refineType then
    local refinelv = itemData.equipInfo.refinelv
    refinelv = refinelv + 1
    local maxRefineLv = self:MaxRefineLevelByData(itemData.staticData)
    if refinelv > maxRefineLv then
      refinelv = maxRefineLv
    end
    local data = refineType:GetData(itemData.staticData.Quality, refinelv)
    if data then
      if isSafe then
        local safeRefineCost = itemData.equipInfo:IsNoviceEquip() and data.NoviceSafeRefineCost or data.SafeRefineCost
        for i = 1, #safeRefineCost do
          if safeRefineCost[i].color == itemData.staticData.Quality then
            return safeRefineCost[i].id
          end
        end
      else
        for i = 1, #data.RefineCost do
          if data.RefineCost[i].color == itemData.staticData.Quality then
            return data.RefineCost[i].id
          end
        end
      end
    end
  end
  return nil
end

function BlackSmithProxy:GetRefineComposeData(staticId, refinelv, isSafe)
  local sData = Table_Item[staticId]
  if not sData then
    return
  end
  local refineType = self.refineDataMap[sData.Type]
  if not refineType then
    return
  end
  local data = refineType:GetData(sData.Quality, refinelv)
  if not data then
    return
  end
  if isSafe then
    local equipInfo = EquipInfo.new(Table_Equip[staticId])
    local safeRefineCost = equipInfo:IsNoviceEquip() and data.NoviceSafeRefineCost or data.SafeRefineCost
    for i = 1, #safeRefineCost do
      if safeRefineCost[i].color == sData.Quality then
        local cid = safeRefineCost[i].id
        cid = cid and cid[1]
        if cid then
          return Table_Compose[cid]
        end
      end
    end
  else
    for i = 1, #data.RefineCost do
      if data.RefineCost[i].color == sData.Quality then
        local cid = data.RefineCost[i].id
        cid = cid and cid[1]
        if cid then
          return Table_Compose[cid]
        end
      end
    end
  end
  return nil
end

function BlackSmithProxy:GetExtraSuccesssByStaicID(staticID)
  for i = 1, #GameConfig.EquipRefineRate do
    if staticID == GameConfig.EquipRefineRate[i].itemid then
      return GameConfig.EquipRefineRate[i].rate
    end
  end
  return 0
end

function BlackSmithProxy:InitHighRefineCompose()
  if Table_HighRefineMatCompose == nil then
    return
  end
  self.highRefineCompose_GroupMap = {}
  for id, data in pairs(Table_HighRefineMatCompose) do
    local groupId = data.GroupId
    local cache = self.highRefineCompose_GroupMap[groupId]
    if cache == nil then
      cache = {}
      self.highRefineCompose_GroupMap[groupId] = cache
    end
    table.insert(cache, data)
  end
  local sortFunc = function(l, r)
    return l[2] > r[2]
  end
  for groupid, datas in pairs(self.highRefineCompose_GroupMap) do
    for i = 1, #datas do
      local mainMats = datas[i].MainMaterial
      table.sort(mainMats, sortFunc)
      local subMats = datas[i].ViceMaterial
      table.sort(subMats, sortFunc)
    end
  end
end

function BlackSmithProxy:GetHighRefineComposeData(groupId)
  if self.highRefineCompose_GroupMap then
    return self.highRefineCompose_GroupMap[groupId]
  end
  return _EmptyTable
end

function BlackSmithProxy:IntiHighRefine()
  if Table_HighRefine == nil then
    return
  end
  self.highRefineData_Map = {}
  for id, data in pairs(Table_HighRefine) do
    local t = self.highRefineData_Map[data.PosType]
    if t == nil then
      t = {}
      self.highRefineData_Map[data.PosType] = t
    end
    local level = data.Level
    local levelType = math.floor(level / 1000)
    local tt = t[levelType]
    if tt == nil then
      tt = {}
      t[levelType] = tt
    end
    local singlelevel = level % 1000
    tt[singlelevel] = data
    local equalPos = data.EqualPos
    for i = 1, #equalPos do
      local t = self.highRefineData_Map[equalPos[i]]
      if t == nil then
        t = {}
        self.highRefineData_Map[equalPos[i]] = t
      end
      local level = data.Level
      local levelType = math.floor(level / 1000)
      local tt = t[levelType]
      if tt == nil then
        tt = {}
        t[levelType] = tt
      end
      local singlelevel = level % 1000
      tt[singlelevel] = data
    end
  end
end

function BlackSmithProxy:GetHighRefineData(posType, levelType, level)
  if self.highRefineData_Map == nil then
    return
  end
  if posType == nil then
    return
  end
  local t = self.highRefineData_Map[posType]
  if levelType == nil then
    return t
  end
  if t == nil then
    return nil
  end
  t = t[levelType]
  if level == nil then
    return t
  end
  if t == nil then
    return nil
  end
  return t[level]
end

function BlackSmithProxy:GetMaxHRefineTypeOrLevel(pos, ttype)
  if ttype == nil then
    local _, unlockTypes = self:GetHighRefinePoses()
    local types = unlockTypes and unlockTypes[pos]
    if types then
      local maxType = 0
      for i = 1, #types do
        maxType = math.max(types[i], maxType)
      end
      return maxType
    end
  end
  local ds = self:GetHighRefineData(pos, ttype)
  if ds then
    return #ds
  end
  return 0
end

function BlackSmithProxy:GetShowHRefineDatas(pos)
  local maxType = self:GetMaxHRefineTypeOrLevel(pos)
  local showlvType = maxType
  for i = 1, maxType do
    local nowlv = self:GetPlayerHRefineLevel(pos, i)
    if nowlv < 10 then
      showlvType = i
      break
    end
  end
  return self:GetHighRefineData(pos, showlvType), showlvType
end

function BlackSmithProxy:SetPlayerHRefineLevels(server_highRefineDatas)
  if server_highRefineDatas == nil then
    return
  end
  self.playerHRefineLevelMap = {}
  for i = 1, #server_highRefineDatas do
    self:SetPlayerHRefineLevel(server_highRefineDatas[i])
  end
end

function BlackSmithProxy:SetPlayerHRefineLevel(server_highRefineData)
  if server_highRefineData == nil then
    return
  end
  local t = self.playerHRefineLevelMap[server_highRefineData.pos]
  if t == nil then
    t = {}
    self.playerHRefineLevelMap[server_highRefineData.pos] = t
  end
  for j = 1, #server_highRefineData.level do
    local lv = server_highRefineData.level[j]
    local levelType = math.floor(lv / 1000)
    local reallevel = lv % 1000
    t[levelType] = reallevel
  end
end

function BlackSmithProxy:GetPlayerHRefineLevel(pos, levelType)
  if self.playerHRefineLevelMap == nil then
    return 0
  end
  local poslvs = self.playerHRefineLevelMap[pos]
  return poslvs and poslvs[levelType] or 0
end

local tempTotalEffectMap = {}

function BlackSmithProxy:Get_TotalHRefineEffect_Map(equipPos, typelevel, hrlevel, class, limitRefinelv)
  local datas = self:GetHighRefineData(equipPos, typelevel)
  TableUtility.TableClear(tempTotalEffectMap)
  local resuleEffectMap = tempTotalEffectMap
  for i = 1, hrlevel do
    local s_effectmap = self:get_SingleHRefineEffects_Map(datas[i], class, limitRefinelv)
    if s_effectmap then
      for ek, ev in pairs(s_effectmap) do
        if ek ~= "Job" then
          local ov = resuleEffectMap[ek] or 0
          resuleEffectMap[ek] = ov + ev
        end
      end
    end
  end
  return resuleEffectMap
end

function BlackSmithProxy:get_SingleHRefineEffects_Map(config_data, class, refinelv)
  if refinelv and refinelv < config_data.RefineLv then
    return
  end
  local effect = config_data.Effect
  for i = 1, #effect do
    local jobs = effect[i].Job
    for j = 1, #jobs do
      if jobs[j] == class then
        return effect[i]
      end
    end
  end
  return nil
end

local tempEffectMap = {}

function BlackSmithProxy:GetMyHRefineEffectMap(pos, refinelv, equiped_site)
  TableUtility.TableClear(tempEffectMap)
  if pos == nil then
    return tempEffectMap
  end
  if equiped_site and equiped_site == CommonFun.EquipPos.EEQUIPPOS_SHIELD and pos == CommonFun.EquipPos.EEQUIPPOS_WEAPON and Game.Myself.data:CheckHeinrichEquipWeaponOnShield() then
    return tempEffectMap
  end
  local resultEffectMap = tempEffectMap
  local myclass = MyselfProxy.Instance:GetMyProfession()
  local hrData = self:GetHighRefineData(pos)
  local maxType = hrData and #hrData or 0
  local attr, bit, singleEffectMap, val
  for k = 1, maxType do
    local level = self:GetPlayerHRefineLevel(pos, k)
    local effectmap = self:Get_TotalHRefineEffect_Map(pos, k, level, myclass, refinelv)
    for ek, ev in pairs(effectmap) do
      attr = self:GetHighRefineAttr(pos, k)
      if (ek == "Refine" or ek == "MRefine") and attr then
        for i = 1, self:GetPlayerHRefineLevel(pos, k) do
          bit = BitUtil.bandOneZero(attr, i - 1)
          singleEffectMap = self:get_SingleHRefineEffects_Map(self:GetHighRefineData(pos, k, i), myclass, refinelv)
          val = singleEffectMap and singleEffectMap[ek] or 0
          if bit == BlackSmithProxy.HRefinePropValueMap.Refine then
            resultEffectMap.Refine = (resultEffectMap.Refine or 0) + val
          elseif bit == BlackSmithProxy.HRefinePropValueMap.MRefine then
            resultEffectMap.MRefine = (resultEffectMap.MRefine or 0) + val
          end
        end
      else
        local v = resultEffectMap[ek] or 0
        resultEffectMap[ek] = v + ev
      end
    end
  end
  return resultEffectMap
end

function BlackSmithProxy:IsHighRefineUnlock()
  if EnvChannel.Channel.Name == EnvChannel.ChannelConfig.Alpha.Name or EnvChannel.Channel.Name == EnvChannel.ChannelConfig.Release.Name then
    return false
  end
  return true
end

function BlackSmithProxy:GetHighRefinePoses()
  local gbData = GuildBuildingProxy.Instance:GetBuildingDataByType(GuildBuildingProxy.Type.EGUILDBUILDING_HIGH_REFINE)
  if gbData == nil then
    return
  end
  local unlockParam = gbData.staticData.UnlockParam
  local result = {}
  if unlockParam and unlockParam.hrefine_part then
    for site, _ in pairs(unlockParam.hrefine_part) do
      table.insert(result, site)
    end
    table.sort(result, function(a, b)
      return a < b
    end)
  end
  return result, unlockParam.hrefine_part
end

function BlackSmithProxy:IsGvgSeasonItem(id)
  local config = self.enchantMustBuffMappingId[id]
  if config then
    return config.UseType == "gvg"
  end
  return false
end

function BlackSmithProxy:InitAdvancedEnchant()
  self.advancedEnchantCostMap = {}
  self.enchantMustBuffMappingId = {}
  local posArr, cfg
  for _, d in pairs(Table_EnchantMustBuff) do
    self.enchantMustBuffMappingId[d.ItemID] = d
    posArr = d.Position
    for i = 1, #posArr do
      cfg = self.advancedEnchantCostMap[posArr[i]] or {}
      TableUtility.ArrayPushBack(cfg, {
        itemid = d.ItemID,
        num = 1,
        isMustBuff = true
      })
      self.advancedEnchantCostMap[posArr[i]] = cfg
    end
  end
  for _, d in pairs(Table_EnchantMinAttrImprove) do
    posArr = d.Position
    for i = 1, #posArr do
      cfg = self.advancedEnchantCostMap[posArr[i]] or {}
      TableUtility.ArrayPushBack(cfg, d.Cost)
      self.advancedEnchantCostMap[posArr[i]] = cfg
    end
  end
end

function BlackSmithProxy:GetAdvancedEnchantCostConfig(t)
  return t and self.advancedEnchantCostMap[t] or _EmptyTable
end

local errorEnchantCheckTemplate = {
  MaxSpPer = 0,
  MAtk = 0,
  EquipASPD = 0,
  DamIncrease = 0
}

function BlackSmithProxy.HasErrorEnchantInfo(itemData)
  local enchantInfo = itemData.enchantInfo
  if enchantInfo then
    local attris = enchantInfo:GetEnchantAttrs()
    local combineEffect = enchantInfo:GetCombineEffects()
    if #combineEffect == 0 then
      local temp = ReusableTable.CreateTable()
      TableUtility.TableShallowCopy(temp, errorEnchantCheckTemplate)
      for i = 1, #attris do
        if temp[attris[i].type] == 0 then
          temp[attris[i].type] = 1
        end
      end
      local result = temp.MaxSpPer == 1 and temp.MAtk == 1 or temp.DamIncrease or temp.EquipASPD == 1
      ReusableTable.DestroyAndClearTable(temp)
      if result then
        return true
      end
    end
  end
  return false
end

local _EnchantCost = {}

function BlackSmithProxy:GetEnchantCost(enchantType, itemType)
  TableUtility.ArrayClear(_EnchantCost)
  local actDiscount = self:GetEquipOptDiscounts(ActivityCmd_pb.GACTIVITY_ENCHATN_DISCOUNT)
  actDiscount = actDiscount and actDiscount[1]
  local homeDiscount = not actDiscount and HomeManager.Me():TryGetHomeWorkbenchDiscount("Enchant") or nil
  if math.Approximately(homeDiscount or 0, 100) then
    homeDiscount = nil
  end
  local costConfig = GameConfig.EquipEnchant and GameConfig.EquipEnchant.SpecialCost
  if costConfig then
    local config = costConfig[enchantType][itemType]
    if config ~= nil then
      local zenyCost
      for i = #config, 1, -1 do
        if config[i].itemid == 100 then
          zenyCost = config[i].num
        else
          table.insert(_EnchantCost, config[i])
        end
      end
      return _EnchantCost, zenyCost or 0, actDiscount, homeDiscount
    end
  end
  local cost = EnchantEquipUtil.Instance:GetEnchantCost(enchantType)
  if cost then
    table.insert(_EnchantCost, cost.ItemCost)
    return _EnchantCost, cost.ZenyCost or 0, actDiscount, homeDiscount
  end
end

local Enchant_UnlockMenuId = {
  [SceneItem_pb.EENCHANTTYPE_PRIMARY] = 71,
  [SceneItem_pb.EENCHANTTYPE_MEDIUM] = 72,
  [SceneItem_pb.EENCHANTTYPE_SENIOR] = 73
}

function BlackSmithProxy:CanBetter_EquipEnchantInfo()
  local unlockFunc = FunctionUnLockFunc.Me()
  local maxEnchantType
  for enchantType, menuId in pairs(Enchant_UnlockMenuId) do
    if unlockFunc:CheckCanOpen(menuId) and (maxEnchantType == nil or enchantType > maxEnchantType) then
      maxEnchantType = enchantType
    end
  end
  local roleEquipBag = BagProxy.Instance:GetRoleEquipBag()
  local items = roleEquipBag:GetItems()
  if #items == 0 then
    return false
  end
  if maxEnchantType == nil then
    return false
  end
  local item
  for i = 1, #items do
    item = items[i]
    if self:CheckItemEnchant_CanBetter(item, maxEnchantType) then
      return true
    end
  end
  return false
end

function BlackSmithProxy:CheckItemEnchant_CanBetter(item, maxEnchantType)
  local equipInfo = item and item.equipInfo
  if equipInfo == nil or not equipInfo:CanEnchant() then
    return false
  end
  local enchantInfo = item.enchantInfo
  local lcondition_enchantType = enchantInfo == nil and SceneItem_pb.EENCHANTTYPE_PRIMARY or enchantInfo.enchantType + 1
  if maxEnchantType and maxEnchantType < lcondition_enchantType then
    return false
  end
  local itemType = item.staticData.Type
  local enchantCost, zenyCost, actDiscount, homeDiscount = self:GetEnchantCost(lcondition_enchantType, itemType)
  if MyselfProxy.Instance:GetROB() < math.floor(zenyCost * (actDiscount or homeDiscount or 100) / 100 + 0.01) then
    return false
  end
  if enchantCost ~= nil then
    local bagProxy = BagProxy.Instance
    local search_bagtypes = bagProxy:Get_PackageMaterialCheck_BagTypes(BagProxy.MaterialCheckBag_Type.Enchant)
    for _, cost in pairs(enchantCost) do
      for itemid, needNum in pairs(cost) do
        local items = bagProxy:GetMaterialItems_ByItemId(itemid, search_bagtypes)
        local haveNum = 0
        for i = 1, #items do
          haveNum = haveNum + items[i].num
        end
        if haveNum < math.floor(needNum * (actDiscount or 100) / 100 + 0.01) then
          return false
        end
      end
    end
  end
  return true
end

function BlackSmithProxy:RecvHighRefineAttr(data)
  self.highRefineAttrMap = self.highRefineAttrMap or {}
  self.highRefineAttrMap[data.epos] = self.highRefineAttrMap[data.epos] or {}
  self.highRefineAttrMap[data.epos][data.type + 1] = data.value
end

function BlackSmithProxy:GetHighRefineAttr(posType, levelType, level)
  if not self.highRefineAttrMap then
    return
  end
  if not self.highRefineAttrMap[posType] then
    return
  end
  local value = self.highRefineAttrMap[posType][levelType]
  if not value or level == nil then
    return value
  end
  if level <= 0 or level > self:GetMaxHRefineTypeOrLevel(posType, levelType) then
    return
  end
  return BitUtil.bandOneZero(value, level - 1)
end

function BlackSmithProxy:UpdateEquipRecovery(datas)
  if not self.recoveryTimesMap then
    self.recoveryTimesMap = {}
    for k, _ in pairs(GameConfig.EquipRecovery) do
      if type(k) == "number" then
        self.recoveryTimesMap[k] = {
          pos = k,
          times = 0,
          timesPlus = 0
        }
      end
    end
  end
  local pos, timesPlus, times
  for i = 1, #datas do
    pos, timesPlus, times = datas[i].pos, datas[i].super_recovery_times or 0, datas[i].recovery_times or 0
    self.recoveryTimesMap[pos] = self.recoveryTimesMap[pos] or {}
    self.recoveryTimesMap[pos].times = times
    self.recoveryTimesMap[pos].timesPlus = timesPlus
  end
end

function BlackSmithProxy:GetEquipRecoveryTimes(pos, isPlus)
  if not self.recoveryTimesMap or not pos then
    return -1
  end
  local key = isPlus and "timesPlus" or "times"
  return self.recoveryTimesMap[pos] and self.recoveryTimesMap[pos][key] or -1
end

function BlackSmithProxy.GetStaticEquipRecoveryEndTimeString()
  return GameConfig.EquipRecovery[EnvChannel.IsTFBranch() and "TfEndTime" or "EndTime"]
end

function BlackSmithProxy.GetStaticEquipRecoveryEndTime()
  local endTimeStr = BlackSmithProxy.GetStaticEquipRecoveryEndTimeString()
  if endTimeStr then
    local year, month, day, hour, min, sec = endTimeStr:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
    return os.time({
      day = day,
      month = month,
      year = year,
      hour = hour,
      min = min,
      sec = sec
    })
  end
end

function BlackSmithProxy.CheckEquipRecoveryTime()
  local endTime = BlackSmithProxy.GetStaticEquipRecoveryEndTime()
  return endTime ~= nil and endTime >= ServerTime.CurServerTime() / 1000
end

local refineEquipTypeMap = {}

function BlackSmithProxy.GetRefineEquipTypeMap()
  if not next(refineEquipTypeMap) then
    for k, _ in pairs(GameConfig.EquipType) do
      refineEquipTypeMap[k] = 1
    end
  end
  return refineEquipTypeMap
end

local fashionRefineEquipTypeMap = {}

function BlackSmithProxy.GetFashionRefineEquipTypeMap()
  local buildingData = GuildBuildingProxy.Instance:GetBuildingDataByType(GuildBuildingProxy.Type.EGUILDBUILDING_MAGIC_SEWING)
  if buildingData then
    local unlockParam = buildingData.staticData and buildingData.staticData.UnlockParam
    local equipConfig = unlockParam.equip
    if equipConfig and equipConfig.refine_type then
      for i = 1, #equipConfig.refine_type do
        fashionRefineEquipTypeMap[equipConfig.refine_type[i]] = 1
      end
    end
  end
  return fashionRefineEquipTypeMap
end

local refineTypeMap = {}

function BlackSmithProxy.GetAllRefineEquipTypeMap()
  if not next(refineTypeMap) then
    for k, _ in pairs(GameConfig.EquipType) do
      refineTypeMap[k] = 1
    end
  end
  return refineTypeMap
end

function BlackSmithProxy.GetEquipBuffUpLevel(site, playerId, buffUpType, limit)
  if not Game.Myself then
    return false
  end
  playerId = playerId or Game.Myself.data.id
  local player = SceneCreatureProxy.FindCreature(playerId)
  if player == nil then
    return 0, 0, 0
  end
  BlackSmithProxy._UpdateEquipBuffUpUpdateLevelMap(player, buffUpType)
  local t = type(site)
  if t == "number" then
    return BlackSmithProxy._GetEquipBuffUpLevel(site, playerId, buffUpType, limit)
  else
    local result = {}
    if t == "table" and next(site) then
      for _, s in pairs(site) do
        result[s] = BlackSmithProxy._GetEquipBuffUpLevel(s, playerId, buffUpType, limit)
      end
    elseif t == "nil" or t == "table" and not next(site) then
      for _, data in pairs(GameConfig.EquipType) do
        for _, s in pairs(data.site) do
          result[s] = BlackSmithProxy._GetEquipBuffUpLevel(s, playerId, buffUpType, limit)
        end
      end
    end
    if next(result) then
      return result
    end
  end
  return 0, 0, 0
end

function BlackSmithProxy.GetStrengthBuffUpLevel(site, playerId, limit)
  return BlackSmithProxy.GetEquipBuffUpLevel(site, playerId, "Strength", limit)
end

function BlackSmithProxy.GetRefineBuffUpLevel(site, playerId, limit)
  return BlackSmithProxy.GetEquipBuffUpLevel(site, playerId, "Refine", limit)
end

local tempResult, tempTotal, ExtraMax = -1, 0, 18

function BlackSmithProxy.CalculateBuffUpLevel(initLv, maxLv, withLimitUpLevel, withoutLimitUpLevel, capLevel, withExtraLimitUpLevel)
  withLimitUpLevel = withLimitUpLevel or 0
  withoutLimitUpLevel = withoutLimitUpLevel or 0
  withExtraLimitUpLevel = withExtraLimitUpLevel or 0
  withExtraLimitUpLevel = math.min(withExtraLimitUpLevel, ExtraMax)
  maxLv = maxLv + withoutLimitUpLevel
  tempTotal = initLv + withLimitUpLevel + withoutLimitUpLevel + withExtraLimitUpLevel
  if 0 < withExtraLimitUpLevel then
    tempResult = math.min(tempTotal, ExtraMax)
    maxLv = tempResult
  end
  if capLevel and 0 < capLevel then
    tempResult = math.min(tempTotal, capLevel)
  else
    tempResult = tempTotal
  end
  return math.min(tempResult, maxLv), maxLv
end

local equipBuffUpTypeMap = {
  Strength = "UpgradeStrengthLv",
  Refine = "UpgradeRefineLv"
}
local equipBuffUpPredicateName = {
  Strength = "CanStrength",
  Refine = "CanRefine"
}
local buffTable
local tryGetEquipBuffUpEffectData = function(buffId, buffUpType)
  if not buffTable then
    buffTable = Table_Buffer
  end
  local eff = buffTable[buffId] and buffTable[buffId].BuffEffect
  if eff and eff.type == equipBuffUpTypeMap[buffUpType] then
    return eff
  end
end
local equipBuffUpLastUpdateTimeMap, equipBuffUpUpdateLevelMap, refineBuffLevelCaps = {}, {}, {}
local withLimitKey, withoutLimitKey, withExtraLimitKey = 1, 0, 2
local LimitMap = {
  [0] = withoutLimitKey,
  [1] = withLimitKey,
  [2] = withExtraLimitKey
}
local equipBuffUpLevelResult = {}

function BlackSmithProxy._GetEquipBuffUpLevel(site, playerId, buffUpType, limit)
  if not buffUpType then
    return 0
  end
  if type(limit) == "table" then
    TableUtility.ArrayClear(equipBuffUpLevelResult)
    for i = 1, #limit do
      equipBuffUpLevelResult[#equipBuffUpLevelResult + 1] = BlackSmithProxy._GetEquipBuffUpUpdateLevel(site, playerId, buffUpType, limit[i])
    end
    return unpack(equipBuffUpLevelResult)
  end
  return BlackSmithProxy._GetEquipBuffUpUpdateLevel(site, playerId, buffUpType, limit)
end

function BlackSmithProxy:GetEquipCapLevel(site, playerId)
  if not Game.Myself then
    return false
  end
  local pID = playerId or Game.Myself.data.id
  refineBuffLevelCaps[pID] = refineBuffLevelCaps[pID] or {}
  local levelCapsMap = refineBuffLevelCaps[pID]
  TableUtility.TableClear(levelCapsMap)
  local player = SceneCreatureProxy.FindCreature(pID)
  if player ~= nil then
    local type = equipBuffUpTypeMap.Refine
    local map = player.data:GetBuffTypes(type)
    if map ~= nil then
      for k, v in pairs(map) do
        local config = Table_Buffer[k]
        if config ~= nil then
          local eff = config.BuffEffect
          for _, pos in pairs(eff.equipPos) do
            local uplevel = 0
            if eff.toLevel then
              levelCapsMap[pos] = eff.toLevel
            end
          end
        end
        refineBuffLevelCaps[pID] = levelCapsMap
      end
    end
  end
  return levelCapsMap[site]
end

function BlackSmithProxy.CheckHasEquipBuffUp(playerId, buffUpType)
  if playerId then
    local player, eff = SceneCreatureProxy.FindCreature(playerId)
    if player and player.buffs then
      for buffId, _ in pairs(player.buffs) do
        eff = tryGetEquipBuffUpEffectData(buffId, buffUpType)
        if eff then
          return true, player
        end
      end
    end
  end
  return false
end

function BlackSmithProxy.CheckShowEquipBuffUpLevel(itemData, playerId, buffUpType)
  if not Game.Myself then
    return false
  end
  local equipInfo = itemData and itemData.equipInfo
  local predicateName = buffUpType and equipBuffUpPredicateName[buffUpType]
  local predicate = predicateName and EquipInfo[predicateName]
  if equipInfo and predicate and predicate(equipInfo) then
    local hasBuff, player = BlackSmithProxy.CheckHasEquipBuffUp(playerId or Game.Myself.data.id, buffUpType)
    if hasBuff then
      if player == Game.Myself then
        local bagData = BagProxy.Instance:GetBagByType(BagProxy.BagType.RoleEquip)
        local myItem = bagData:GetItemByGuid(itemData.id)
        if myItem then
          return true
        end
      else
        return true
      end
    end
  end
  return false
end

function BlackSmithProxy.CheckShowStrengthBuffUpLevel(itemData, playerId)
  return BlackSmithProxy.CheckShowEquipBuffUpLevel(itemData, playerId, "Strength")
end

function BlackSmithProxy.CheckShowRefineBuffUpLevel(itemData, playerId)
  return BlackSmithProxy.CheckShowEquipBuffUpLevel(itemData, playerId, "Refine")
end

function BlackSmithProxy.CheckCanEquipBuffUpLevel(itemData, playerId, buffUpType)
  if itemData == nil or buffUpType == nil then
    return false
  end
  local equipInfo = itemData.equipInfo
  if equipInfo == nil then
    return false
  end
  local predicateName = equipBuffUpPredicateName[buffUpType]
  if predicateName == nil then
    return false
  end
  local predicate = EquipInfo[predicateName]
  if predicate == nil then
    return false
  end
  if not predicate(equipInfo) then
    return false
  end
  local myself = Game.Myself
  if myself == nil then
    return false
  end
  local player
  if playerId ~= nil then
    player = SceneCreatureProxy.FindCreature(playerId)
    if player == nil then
      return false
    end
  else
    player = myself
  end
  if player == myself then
    local bagData = BagProxy.Instance:GetBagByType(BagProxy.BagType.RoleEquip)
    local myItem = bagData:GetItemByGuid(itemData.id)
    if not myItem then
      return false
    end
  end
  return true
end

function BlackSmithProxy._UpdateEquipBuffUpUpdateLevelMap(player, buffUpType)
  local playerId = player.data.id
  if not (equipBuffUpLastUpdateTimeMap[playerId] and equipBuffUpLastUpdateTimeMap[playerId][buffUpType]) or UnityFrameCount > equipBuffUpLastUpdateTimeMap[playerId][buffUpType] then
    equipBuffUpUpdateLevelMap[playerId] = equipBuffUpUpdateLevelMap[playerId] or {}
    local typeLevelMap = equipBuffUpUpdateLevelMap[playerId][buffUpType] or {}
    local levelCapsMap = refineBuffLevelCaps[playerId] or {}
    TableUtility.TableClear(typeLevelMap)
    local bufftype = equipBuffUpTypeMap[buffUpType]
    if bufftype ~= nil then
      local map = player.data:GetBuffTypes(bufftype)
      if map ~= nil then
        local config, eff, limitKey
        for k, v in pairs(map) do
          config = Table_Buffer[k]
          if config ~= nil then
            eff = config.BuffEffect
            limitKey = LimitMap[eff.limit or 0]
            local uplevel = 0
            local bufflayer = player:GetBuffLayer(k) or 1
            if type(eff.upLevel) == "table" then
              local sourcePlayer = SceneCreatureProxy.FindCreature(player.data:GetBuffFromID(k))
              uplevel = (CommonFun.calcBuffValue(sourcePlayer and sourcePlayer.data, player.data, eff.upLevel.type, eff.upLevel.a, eff.upLevel.b, eff.upLevel.c, eff.upLevel.d, player:GetBuffLevel(), 0) or 0) * bufflayer
            elseif eff.upLevel then
              uplevel = eff.upLevel * bufflayer
            end
            uplevel = math.floor(uplevel)
            for _, pos in pairs(eff.equipPos) do
              typeLevelMap[pos] = typeLevelMap[pos] or {}
              if eff.toLevel then
                levelCapsMap[pos] = eff.toLevel
              end
              typeLevelMap[pos][limitKey] = (typeLevelMap[pos][limitKey] or 0) + uplevel
            end
          end
        end
      end
    end
    equipBuffUpUpdateLevelMap[playerId][buffUpType] = typeLevelMap
    refineBuffLevelCaps[playerId] = levelCapsMap
    local typeTimeMap = equipBuffUpLastUpdateTimeMap[playerId] or {}
    typeTimeMap[buffUpType] = UnityFrameCount
    equipBuffUpLastUpdateTimeMap[playerId] = typeTimeMap
  end
end

function BlackSmithProxy._GetEquipBuffUpUpdateLevel(site, playerId, buffUpType, limit)
  local map = equipBuffUpUpdateLevelMap[playerId][buffUpType][site]
  if map then
    local withLimitUpLevel, withoutLimitUpLevel = map[withLimitKey] or 0, map[withoutLimitKey] or 0
    if limit == 0 or limit == false then
      return withoutLimitUpLevel
    elseif limit then
      return map[limit] or 0
    else
      return withLimitUpLevel + withoutLimitUpLevel
    end
  end
  return 0
end

function BlackSmithProxy.Equip_DefaultSortRule(a, b)
  if a.equiped and b.equiped and a.equiped ~= b.equiped then
    return a.equiped > b.equiped
  end
  local aSData, bSData = a.staticData, b.staticData
  local aEquipInfo, bEquipInfo = a.equipInfo, b.equipInfo
  if aEquipInfo and bEquipInfo then
    if aSData.id ~= bSData.id then
      local a_site = aEquipInfo.site and aEquipInfo.site[1] or 1
      local b_site = bEquipInfo.site and bEquipInfo.site[1] or 1
      if a_site ~= b_site then
        return a_site < b_site
      end
      if aSData.Type ~= bSData.Type then
        return aSData.Type < bSData.Type
      end
      if aSData.Quality ~= bSData.Quality then
        return aSData.Quality > bSData.Quality
      end
      local a_CanEquip = a:CanEquip() and 1 or 0
      local b_CanEquip = b:CanEquip() and 1 or 0
      if a_CanEquip ~= b_CanEquip then
        return a_CanEquip > b_CanEquip
      end
      local a_slotnum = aEquipInfo:GetCardSlot()
      local b_slotnum = bEquipInfo:GetCardSlot()
      if a_slotnum ~= b_slotnum then
        return a_slotnum > b_slotnum
      end
      return aSData.id > bSData.id
    end
    if aEquipInfo.refinelv ~= bEquipInfo.refinelv then
      return aEquipInfo.refinelv > bEquipInfo.refinelv
    end
    if aEquipInfo.equiplv ~= bEquipInfo.equiplv then
      return aEquipInfo.equiplv > bEquipInfo.equiplv
    end
    local a_enchantInfo = a.enchantInfo
    local b_enchantInfo = b.enchantInfo
    if a_enchantInfo or b_enchantInfo then
      if a_enchantInfo and b_enchantInfo then
        return (a:HasGoodEnchantAttri() and 1 or 0) > (b:HasGoodEnchantAttri() and 1 or 0)
      end
      a_enchantInfo = a_enchantInfo and 1 or 0
      b_enchantInfo = b_enchantInfo and 1 or 0
      return a_enchantInfo > b_enchantInfo
    end
  end
  return aSData.id > bSData.id
end

function BlackSmithProxy.SortEquips(datas)
  table.sort(datas, BlackSmithProxy.Equip_DefaultSortRule)
end

function BlackSmithProxy:GetSafeRefineCostEquipInfo(item, tolv)
  if not item or not tolv then
    return
  end
  local indiscount = self:GetEquipOptDiscounts(ActivityCmd_pb.GACTIVITY_SAFE_REFINE_DISCOUNT)
  local costNumConfig, costItemIds = item.equipInfo:GetSafeRefineCostConfig(indiscount)
  local needNum = 0
  if costNumConfig then
    local equipInfo = item.equipInfo
    local refinelv = equipInfo and equipInfo.refinelv or 1
    if refinelv and tolv > refinelv and costNumConfig[refinelv + 1] then
      for i = refinelv + 1, tolv do
        if not costNumConfig[i] then
          break
        end
        needNum = needNum + costNumConfig[i]
      end
      needNum = needNum - equipInfo.extra_refine_value
    end
  end
  return needNum, costItemIds, BlackSmithProxy.GetMinCostMaterialID(item.staticData.id)
end

function BlackSmithProxy:GetSafeRefineClampNew(item)
  local indiscount = self:GetEquipOptDiscounts(ActivityCmd_pb.GACTIVITY_SAFE_REFINE_DISCOUNT)
  local costNumConfig, costItemIds = item.equipInfo:GetSafeRefineCostConfig(indiscount)
  local min, max = math.huge, 0
  for k, v in pairs(costNumConfig) do
    if k > max and 0 < v then
      max = k
    end
    if k < min and 0 < v then
      min = k
    end
  end
  return min, max
end

function BlackSmithProxy:DoFitEquipRefineVal(datas, lackVal, checkFunc, checkFuncParam)
  if not datas or #datas == 0 then
    return
  end
  local dataVals = {}
  for i = 1, #datas do
    if not checkFunc or checkFunc(checkFuncParam, datas[i]) then
      table.insert(dataVals, {
        index = i,
        id = datas[i].id,
        num = datas[i].num,
        val = datas[i]:IsEquip() and datas[i].equipInfo:GetSafeRefineMatVal() or 1
      })
    end
  end
  table.sort(dataVals, function(a, b)
    return a.val < b.val
  end)
  local retDatas = {}
  local fillVal = 0
  local tempVal, tempNum
  for i = 1, #dataVals do
    tempVal = dataVals[i].val
    tempNum = math.ceil((lackVal - fillVal) / tempVal)
    if tempNum <= 0 then
      break
    end
    tempNum = math.min(tempNum, dataVals[i].num)
    fillVal = fillVal + tempNum * tempVal
    table.insert(retDatas, {
      id = datas[i].id,
      index = dataVals[i].index,
      num = tempNum,
      val = dataVals[i].val
    })
    if lackVal <= fillVal then
      break
    end
  end
  while 0 < #retDatas and lackVal < fillVal do
    local retData = retDatas[1]
    tempVal = retData.val
    tempNum = retData.num
    if lackVal > fillVal - tempVal * tempNum then
      retData.num = retData.num - math.floor((fillVal - lackVal) / tempVal)
      break
    else
      fillVal = fillVal - tempVal * tempNum
      table.remove(retDatas, 1)
    end
  end
  return retDatas
end

function BlackSmithProxy:GetRefineTickets(sortRule, bagTypes)
  Game.Preprocess_RefineTicket()
  local rets = {}
  for ticketType, ticketMap in pairs(Game.RefineTicketMap) do
    for sid, useItem in pairs(ticketMap) do
      local tickests = BagProxy.Instance:GetItemsByStaticID(sid, bagTypes)
      if tickests then
        for i = 1, #tickests do
          table.insert(rets, tickests[i])
        end
      end
    end
  end
  for sid, useItem in pairs(Game.OldRefineTicketMap) do
    local tickests = BagProxy.Instance:GetItemsByStaticID(sid, bagTypes)
    if tickests then
      for i = 1, #tickests do
        table.insert(rets, tickests[i])
      end
    end
  end
  if sortRule then
    table.sort(rets, sortRule)
  end
  return rets
end

function BlackSmithProxy.GetRefineTicketType(equip)
  if not equip or not equip.equipInfo then
    return
  end
  local hsDecomposeID = false
  if equip.equipInfo.equipData.DecomposeID then
    hsDecomposeID = true
  else
    local comoposeData = Table_EquipCompose[equip.staticData.id]
    local m1 = comoposeData and comoposeData.Material[1] and comoposeData.Material[1].id
    if m1 and Table_Equip[m1] and Table_Equip[m1].DecomposeID then
      hsDecomposeID = true
    end
    if not hasDecomposeID then
      local srcIDs, srcType = BagProxy.GetSurceEquipIds(equip.staticData.id)
      if srcIDs then
        local s1
        for i = 1, #srcIDs do
          s1 = srcIDs[i]
          if s1 and Table_Equip[s1] and Table_Equip[s1].DecomposeID then
            hsDecomposeID = true
            break
          end
        end
      end
    end
  end
  return CommonFun.GetRefineTicketType(equip.equipInfo:IsNextGen(), equip.equipInfo:GetEquipType(), hsDecomposeID)
end

function BlackSmithProxy.IsTicketCanUseFor(ticket, equip)
  if not ticket or not equip then
    return false
  end
  if equip.equipInfo.damage then
    return false
  end
  local useData = Table_UseItem[ticket.staticData.id]
  if not useData then
    return false
  end
  local useEffect = useData.UseEffect
  if useEffect and useEffect.type == "refine" then
    if useEffect.item_types and TableUtility.ArrayFindIndex(useEffect.item_types, equip.staticData.Type) > 0 then
      if useEffect.only_no_exchange == 1 then
        return not ItemData.CheckItemCanTrade(equip.staticData.id)
      end
      return true
    end
    return false
  end
  local ticketType = useEffect and useEffect.ticket_type
  if not ticketType then
    return false
  end
  if useEffect.refine_lv <= equip.equipInfo.refinelv then
    return false
  end
  return BlackSmithProxy.GetRefineTicketType(equip) == ticketType
end
