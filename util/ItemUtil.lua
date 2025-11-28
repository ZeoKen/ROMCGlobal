ItemUtil = {}
ItemUtil.staticRewardDropsItems = {}
local InitEquipPos = function()
  if not ItemUtil.equipPosInited then
    ItemUtil.equipPosInited = true
    ItemUtil.EquipPosConfig = {
      [1] = SceneItem_pb.EEQUIPPOS_SHIELD,
      [2] = SceneItem_pb.EEQUIPPOS_ARMOUR,
      [3] = SceneItem_pb.EEQUIPPOS_ROBE,
      [4] = SceneItem_pb.EEQUIPPOS_SHOES,
      [5] = SceneItem_pb.EEQUIPPOS_ACCESSORY1,
      [6] = SceneItem_pb.EEQUIPPOS_ACCESSORY2,
      [7] = SceneItem_pb.EEQUIPPOS_WEAPON,
      [8] = SceneItem_pb.EEQUIPPOS_HEAD,
      [9] = SceneItem_pb.EEQUIPPOS_FACE,
      [10] = SceneItem_pb.EEQUIPTYPE_MOUTH,
      [11] = SceneItem_pb.EEQUIPPOS_BACK,
      [12] = SceneItem_pb.EEQUIPPOS_TAIL,
      [13] = SceneItem_pb.EEQUIPPOS_MOUNT,
      [14] = SceneItem_pb.EEQUIPPOS_BARROW,
      [15] = SceneItem_pb.EEQUIPPOS_ARTIFACT,
      [16] = SceneItem_pb.EEQUIPPOS_ARTIFACT_HEAD,
      [17] = SceneItem_pb.EEQUIPPOS_ARTIFACT_BACK,
      [19] = SceneItem_pb.EEQUIPPOS_ARTIFACT_RING1
    }
    ItemUtil.EquipExtractionMinPos = 101
    ItemUtil.EquipExtractionOffense = 101
    ItemUtil.EquipExtractionDefense = 102
    ItemUtil.EquipExtraxtionMaxPos = 102
  end
end
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
local _CheckIsEquipCompose = function(id)
  return nil ~= Table_EquipCompose[id]
end

function ItemUtil.GetRewardItemIdsByTeamId(teamId)
  local reward_config = Game.Config_RewardTeam and Game.Config_RewardTeam[teamId]
  if not reward_config then
    return nil
  end
  if nil == reward_config.FemaleItem or nil == next(reward_config.FemaleItem) then
    if reward_config.Item then
      local typeBranch = MyselfProxy.Instance:GetMyProfessionTypeBranch()
      typeBranch = typeBranch == 0 and 1 or typeBranch
      local array = {}
      for i = 1, #reward_config.Item do
        if not reward_config.Item[i].class or 0 < TableUtility.ArrayFindIndex(reward_config.Item[i].class, typeBranch) then
          table.insert(array, reward_config.Item[i])
        end
      end
      return array
    else
      return reward_config
    end
  else
    local myGender = MyselfProxy.Instance:GetMySex()
    local itemList
    if myGender == ProtoCommon_pb.EGENDER_MALE then
      itemList = reward_config.Item
    else
      itemList = reward_config.FemaleItem
    end
    if itemList and 0 < #itemList then
      local typeBranch = MyselfProxy.Instance:GetMyProfessionTypeBranch()
      typeBranch = typeBranch == 0 and 1 or typeBranch
      local array = {}
      for i = 1, #itemList do
        if not itemList[i].class or 0 < TableUtility.ArrayFindIndex(itemList[i].class, typeBranch) then
          table.insert(array, itemList[i])
        end
      end
      return array
    end
  end
end

function ItemUtil.GetRewardTeamIdsByItemId(itemId)
  return ItemIdTeamIdsMap[itemId]
end

function ItemUtil.getAssetPartByItemData(itemId, parent)
  local partIndex = ItemUtil.getItemRolePartIndex(itemId)
  if partIndex then
    local subparts, partColors
    if partIndex == Asset_Role.PartIndex.Mount then
      subparts, partColors = {}, {}
      MountFashionProxy.Instance:SetMountSubParts(subparts, itemId)
      MountFashionProxy.Instance:SetMountPartColors(partColors, itemId)
    end
    local model = Asset_RolePart.Create(partIndex, itemId, function(rolePart, arg, assetRolePart)
      assetRolePart:ResetParent(parent.transform)
      LogUtility.InfoFormat("getAssetPartByItemData parent.layer:{0}", LogUtility.ToString(parent.layer))
      assetRolePart:SetLayer(parent.layer)
    end, nil, nil, subparts, partColors)
    return model
  end
end

function ItemUtil.CheckDateValidByItemId(id)
  local staticData = Table_Item[id]
  if staticData == nil then
    redlog("not find itemid", id)
    return
  end
  local array = {}
  array[1] = staticData.ValidDate
  array[2] = staticData.TFValidDate
  return ItemUtil.CheckDateValid(array)
end

function ItemUtil.CheckDateValidByAchievementId(id)
  local staticData = Table_Achievement[id]
  local array = {}
  if staticData then
    array[1] = staticData.ValidDate
    array[2] = staticData.TFValidDate
    return ItemUtil.CheckDateValid(array)
  end
end

function ItemUtil.calcSecretLandBuff(lv, params)
  if not params or nil == next(params) or #params ~= 3 then
    return 0
  end
  if not lv or lv == 0 then
    return 0
  end
  local b = params[1]
  local c = params[2] - params[1]
  local d = params[3] - params[2]
  local result = 0
  result = lv * b + math.max(lv - 30, 0) * c + math.max(lv - 60, 0) * d
  return result
end

function ItemUtil.calcSecretLandHpBuff(lv, params)
  if not params or nil == next(params) then
    return 0
  end
  if not lv or lv == 0 then
    return 0
  end
  local value = 0
  local result = 0
  for i = 1, #params do
    if params[i] and value < params[i] then
      if 1 < i then
        result = result + math.max(lv - (i - 1) * 10, 0) * (params[i] - value)
      else
        result = result + lv * params[i]
      end
      value = params[i]
    end
  end
  return result
end

function ItemUtil.GetValidDateByPetId(petid)
  local validDateArray = {}
  local itemid = Table_Pet[petid] and Table_Pet[petid].EggID
  if itemid then
    local staticdata = Table_Item[itemid]
    if staticdata then
      validDateArray[1] = staticdata.ValidDate
      validDateArray[2] = staticdata.TFValidDate
    end
  end
  return validDateArray
end

function ItemUtil.CheckDateValid(validArray)
  if not (validArray and #validArray == 2 and validArray[1]) or not validArray[2] then
    return true
  end
  if StringUtil.IsEmpty(validArray[1]) and StringUtil.IsEmpty(validArray[2]) then
    return true
  end
  local validDate
  if EnvChannel.IsTFBranch() then
    validDate = validArray[2]
  else
    validDate = validArray[1]
  end
  if not StringUtil.IsEmpty(validDate) then
    local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
    local year, month, day, hour, min, sec = validDate:match(p)
    local dateTab = ReusableTable.CreateTable()
    dateTab.year = year
    dateTab.month = month
    dateTab.day = day
    dateTab.hour = hour
    dateTab.min = min
    dateTab.sec = sec
    local startDate = os.time(dateTab)
    ReusableTable.DestroyAndClearTable(dateTab)
    local curServerTime = ServerTime.CurServerTime()
    if curServerTime and startDate > curServerTime / 1000 then
      return false
    end
  end
  return true
end

function ItemUtil.getComposeMaterialsByComposeID(id)
  local compData = Table_Compose[id]
  local all, materials, failStay = {}, {}, {}
  if compData then
    if compData.BeCostItem then
      for i = 1, #compData.BeCostItem do
        local id = compData.BeCostItem[i].id
        local num = compData.BeCostItem[i].num
        local tempItem = ItemData.new("Compose", id)
        tempItem.num = num
        table.insert(all, tempItem)
      end
    end
    if compData.FailStayItem then
      local indexMap = {}
      for i = 1, #compData.FailStayItem do
        local index = compData.FailStayItem[i]
        if index then
          indexMap[index] = 1
        end
      end
      for i = 1, #all do
        if indexMap[i] then
          table.insert(failStay, all[i])
        else
          table.insert(materials, all[i])
        end
      end
    end
  end
  return all, materials, failStay
end

function ItemUtil.checkEquipIsWeapon(type)
  for i = 1, #Table_WeaponType do
    local single = Table_WeaponType[i]
    if single.NameEn == type then
      return true
    end
  end
end

function ItemUtil.CheckBuffNeedShow(id)
  if Table_Buffer[id] and Table_Buffer[id].BuffEffect and Table_Buffer[id].BuffEffect.NoShow == 1 then
    return true
  end
  return false
end

function ItemUtil.checkIsFashion(itemId)
  local itemData = Table_Item[itemId]
  if itemData then
    for k, v in pairs(GameConfig.ItemFashion) do
      for i = 1, #v.types do
        local single = v.types[i]
        if single == itemData.Type then
          return true
        end
      end
    end
  end
end

function ItemUtil.getEquipPos(equipId)
  if Table_Item[equipId] then
    local type = Table_Item[equipId].Type
    for k, v in pairs(GameConfig.CardComposeType) do
      for kk, vv in pairs(v.types) do
        if vv == type then
          return k
        end
      end
    end
  end
end

function ItemUtil.getFashionDefaultEquipFunc(data)
  if data.bagtype == BagProxy.BagType.RoleFashionEquip then
    return FunctionItemFunc.Me():GetFunc("GetoutFashion")
  elseif data.bagtype == BagProxy.BagType.RoleEquip then
    return FunctionItemFunc.Me():GetFunc("Discharge")
  elseif data.bagtype == BagProxy.BagType.MainBag then
    return FunctionItemFunc.Me():GetFunc("Dress")
  end
end

function ItemUtil.getBufferDescById(bufferid)
  local isEmpty = StringUtil.IsEmpty
  local buffData = Table_Buffer[bufferid]
  if buffData then
    local noShow = buffData.BuffEffect and buffData.BuffEffect.NoShow == 1
    if not noShow then
      local bufferStr = buffData.Dsc
      if isEmpty(bufferStr) then
        bufferStr = buffData.BuffName .. ZhString.ItemUtil_NoBufferDes
      end
      return OverSea.LangManager.Instance():GetLangByKey(bufferStr)
    else
      return ""
    end
  else
    LogUtility.WarningFormat("Cannot find desc of buffer {0}", bufferid)
    return ""
  end
end

function ItemUtil.getBufferDescByIdNotConfigDes(bufferid)
  local result = ""
  local config = Table_Buffer[bufferid]
  if config and config.BuffEffect and config.BuffEffect.type == "AttrChange" then
    for key, value in pairs(config.BuffEffect) do
      local kprop = RolePropsContainer.config[key]
      if kprop and kprop.displayName and 0 < value then
        result = result .. kprop.displayName .. " [c][9fc33dff]+" .. value .. "[-][/c] "
      end
    end
  end
  return result
end

function ItemUtil.getFashionItemRoleBodyPart(itemid, isMale)
  local equipData = Table_Equip[itemid]
  if not equipData or not equipData.GroupID then
    return equipData
  end
  local GroupID = equipData.GroupID
  local equipDatas = AdventureDataProxy.Instance.fashionGroupData[GroupID]
  if not equipDatas or #equipDatas == 0 then
    return
  end
  for i = 1, #equipDatas do
    local single = equipDatas[i]
    if isMale and single.RealShowModel == 1 then
      return single
    elseif not isMale and single.RealShowModel == 2 then
      return single
    end
  end
  return equipDatas[1]
end

function ItemUtil.getExactFashionItemRoleBodyPart(itemid)
  local equipData = Table_Equip[itemid]
  if not equipData or not equipData.GroupID then
    return equipData
  end
  local GroupID = equipData.GroupID
  local equipDatas = AdventureDataProxy.Instance.fashionGroupData[GroupID]
  if not equipDatas or #equipDatas == 0 then
    return
  end
  for i = 1, #equipDatas do
    local single = equipDatas[i]
    if single.id == itemid then
      return single
    end
  end
  return equipDatas[1]
end

local EquipType2BodyIndex, ItemType2BodyIndex
local _inited = false
local _InitRolePartConfig = function()
  if _inited then
    return
  end
  _inited = true
  EquipType2BodyIndex = {
    [1] = Asset_Role.PartIndex.RightWeapon,
    [21] = Asset_Role.PartIndex.RightWeapon,
    [3] = Asset_Role.PartIndex.LeftWeapon,
    [8] = Asset_Role.PartIndex.Head,
    [9] = Asset_Role.PartIndex.Wing,
    [10] = Asset_Role.PartIndex.Face,
    [11] = Asset_Role.PartIndex.Tail,
    [13] = Asset_Role.PartIndex.Mouth
  }
  ItemType2BodyIndex = {
    [820] = Asset_Role.PartIndex.Hair,
    [821] = Asset_Role.PartIndex.Hair,
    [822] = Asset_Role.PartIndex.Hair,
    [823] = Asset_Role.PartIndex.Eye,
    [824] = Asset_Role.PartIndex.Eye
  }
end

function ItemUtil.getItemRolePartIndex(itemid)
  _InitRolePartConfig()
  if Table_Mount[itemid] then
    return Asset_Role.PartIndex.Mount
  end
  local equipData = Table_Equip[itemid]
  if equipData then
    local typeId = equipData.EquipType
    if EquipType2BodyIndex[typeId] then
      return EquipType2BodyIndex[typeId]
    end
    if equipData.Body and nil ~= next(equipData.Body) then
      return Asset_Role.PartIndex.Body
    end
    local mtype = equipData.Type
    if mtype == "Head" then
      return Asset_Role.PartIndex.Head
    elseif mtype == "Wing" then
      return Asset_Role.PartIndex.Wing
    end
  end
  local itemType = Table_Item[itemid].Type
  if ItemType2BodyIndex[itemType] then
    return ItemType2BodyIndex[itemType]
  end
  return 0
end

function ItemUtil.AddItemsTrace(datas)
  local traceDatas = {}
  for i = 1, #datas do
    local data = datas[i]
    local staticId = data.staticData.id
    local cell = QuestProxy:GetTraceCell(QuestDataType.QuestDataType_ITEMTR, data.staticData.id)
    if not cell then
      local odata = GainWayTipProxy.Instance:GetItemOriginMonster(staticId)
      local itemName = odata.name
      local haveNum = BagProxy.Instance:GetAllItemNumByStaticID(staticId)
      local origin = odata.origins and odata.origins[1]
      if origin then
        local traceData = {
          type = QuestDataType.QuestDataType_ITEMTR,
          questDataStepType = QuestDataStepType.QuestDataStepType_MOVE,
          id = staticId,
          map = origin.mapID,
          pos = origin.pos,
          traceTitle = ZhString.MainViewSealInfo_TraceTitle,
          traceInfo = string.format(ZhString.ItemUtil_ItemTraceInfo, itemName, haveNum)
        }
        table.insert(traceDatas, traceData)
      else
        errorLog(string.format(ZhString.ItemUtil_NoMonsterDrop, staticId))
      end
    end
  end
  if 0 < #traceDatas then
    QuestProxy.Instance:AddTraceCells(traceDatas)
  end
end

function ItemUtil.CancelItemTrace(data)
  QuestProxy.Instance:RemoveTraceCell(QuestDataType.QuestDataType_ITEMTR, data.staticData.id)
end

function ItemUtil.CheckItemIsSpecialInAdventureAppend(itemType)
  for i = 1, #GameConfig.AdventureAppendSpecialItemType do
    local single = GameConfig.AdventureAppendSpecialItemType[i]
    if single == itemType then
      return true
    end
  end
end

function ItemUtil.GetComposeItemByBlueItem(itemData)
  if itemData and 50 == itemData.Type then
    local compose = Table_Compose[itemData.id]
    if compose then
      return compose.Product.id
    end
  end
end

function ItemUtil.GetDeath_Dead_Reward(monsterId)
  local tempArray, tempMap = {}, ReusableTable.CreateTable()
  local Dead_Reward, single, Extra_Reward
  local deadbossCfg = Game.Config_Deadboss[monsterId]
  if deadbossCfg then
    for _, v in pairs(deadbossCfg) do
      Dead_Reward = v.Dead_Reward
      for i = 1, #Dead_Reward do
        single = Dead_Reward[i]
        if not tempMap[single] then
          tempArray[#tempArray + 1] = single
          tempMap[single] = 1
        end
      end
      Extra_Reward = v.ExtraReward or {}
      for i = 1, #Extra_Reward do
        single = Extra_Reward[i]
        if not tempMap[single] then
          tempArray[#tempArray + 1] = single
          tempMap[single] = 1
        end
      end
    end
  end
  ReusableTable.DestroyAndClearTable(tempMap)
  if 1 < #tempArray then
    return tempArray
  else
    return nil
  end
end

function ItemUtil.GetWorldBoss_Reward(monsterId)
  if GameConfig.Card.worldboss and GameConfig.Card.worldboss[monsterId] then
    return GameConfig.Card.worldboss[monsterId].Dead_Reward
  end
end

function ItemUtil.GetMaxQuenchPer(site)
  if not ItemUtil.maxQuenchPerMap then
    ItemUtil.maxQuenchPerMap = {}
    local config = GameConfig.ShadowEquip.Upgrade
    if config then
      for pos, siteMap in pairs(config) do
        ItemUtil.maxQuenchPerMap[pos] = 0
        for per, _ in pairs(siteMap) do
          if per > ItemUtil.maxQuenchPerMap[pos] then
            ItemUtil.maxQuenchPerMap[pos] = per
          end
        end
      end
    end
  end
  return ItemUtil.maxQuenchPerMap[site]
end

function ItemUtil.GetDeath_Drops(monsterId)
  if ItemUtil.staticRewardDropsItems[monsterId] then
    return ItemUtil.staticRewardDropsItems[monsterId]
  end
  local tempArray = {}
  local staticData = Table_Monster[monsterId]
  if not staticData then
    return
  end
  local numLimit = false
  local Dead_Reward = staticData.Dead_Reward
  Dead_Reward = 0 < #Dead_Reward and Dead_Reward or nil
  if not Dead_Reward then
    Dead_Reward = ItemUtil.GetDeath_Dead_Reward(monsterId)
    numLimit = true
  end
  local worldbossReward = ItemUtil.GetWorldBoss_Reward(monsterId)
  if not Dead_Reward and not worldbossReward then
    return
  end
  if Dead_Reward then
    ItemUtil.GetRewardItemListByRewardGroup(Dead_Reward, tempArray, numLimit)
  end
  if worldbossReward then
    ItemUtil.GetRewardItemListByRewardGroup(worldbossReward, tempArray, numLimit)
  end
  ItemUtil.staticRewardDropsItems[monsterId] = tempArray
  return ItemUtil.staticRewardDropsItems[monsterId]
end

function ItemUtil.GetRewardItemListByRewardGroup(grouplist, array, numLimit)
  if grouplist and 0 < #grouplist then
    for i = 1, #grouplist do
      local singleRewardTeamID = grouplist[i]
      local list = ItemUtil.GetRewardItemIdsByTeamId(singleRewardTeamID)
      if list then
        for j = 1, #list do
          local single = list[j]
          local hasAdd = false
          for j = 1, #array do
            local tmp = array[j]
            if tmp.itemData.id == single.id then
              if not numLimit then
                tmp.num = tmp.num + single.num
              end
              hasAdd = true
              break
            end
          end
          if not hasAdd then
            local data = {}
            data.itemData = Table_Item[single.id]
            if data.itemData then
              data.num = single.num
              table.insert(array, data)
            end
          end
        end
      end
    end
  end
end

function ItemUtil.GetEquipEnchantEffectSucRate(attriType)
end

local useCodeItemId

function ItemUtil.SetUseCodeCmd(data)
  useCodeItemId = data.id
end

function ItemUtil.HandleUseCodeCmd(data)
  if useCodeItemId and data.guid == useCodeItemId then
    useCodeItemId = nil
    local functionSdk = FunctionLogin.Me():getFunctionSdk()
    local url
    if functionSdk and functionSdk:getToken() then
      url = string.format(ZhString.KFCShareURL, Game.Myself.data.id, data.code, functionSdk:getToken())
    else
      url = ZhString.KFCShareURL_BeiFen
    end
    ApplicationInfo.OpenUrl(url)
  end
end

function ItemUtil.CheckIfNeedRequestUseCode(data)
  local type = data.staticData.Type
  if type and (type == 4000 or type == 4200 or type == 4201) then
    return true
  end
  return false
end

local seaon_equip = GameConfig.GVGConfig.season_equip

function ItemUtil.IsGVGSeasonEquip(id)
  return nil ~= seaon_equip and nil ~= seaon_equip[id]
end

local CONFIGTIME_FORMAT = "%Y-%m-%d %H:%M:%S"
local getNowTimeString = function()
  return os.date(CONFIGTIME_FORMAT, ServerTime.CurServerTime() / 1000)
end

function ItemUtil.CheckCardCanComposeByTime(cardId)
  return ItemUtil.CheckCardCanGetByTime(cardId, "TFComposeDate", "ComposeDate")
end

function ItemUtil.CheckCardCanLotteryByTime(cardId)
  return ItemUtil.CheckCardCanGetByTime(cardId, "TFLotteryDate", "LotteryDate")
end

function ItemUtil.CheckCardCanGetByTime(cardId, tfkey, releaseKey)
  local sData = Table_Card[cardId]
  if sData == nil then
    return false
  end
  local timeKey
  if EnvChannel.IsTFBranch() then
    timeKey = tfkey
  else
    timeKey = releaseKey
  end
  if timeKey == nil then
    return true
  end
  local ct = sData[timeKey]
  if ct == nil or #ct == 0 then
    return true
  end
  local nowTimeStr = getNowTimeString()
  if #ct == 1 then
    return nowTimeStr > ct[1]
  elseif #ct == 2 then
    return nowTimeStr > ct[1] and nowTimeStr <= ct[2]
  end
  return false
end

function ItemUtil.CheckRecipeIsValidByTime(recipeId)
  return ItemUtil.CheckRecipeCanUseByTime(recipeId, "TFValidDate", "ValidDate", "Item")
end

function ItemUtil.CheckFoodCanMakeByTime(recipeId)
  return ItemUtil.CheckRecipeCanUseByTime(recipeId, "TFStartTime", "ReleaseStartTime", "Recipe")
end

function ItemUtil.CheckRecipeCanUseByTime(recipeId, tfKey, releaseKey, searchTableName)
  local recipeData = Table_Recipe[recipeId]
  if recipeData == nil then
    return false
  end
  if recipeData.Product == 551019 then
    return false
  end
  local timeKey
  if EnvChannel.IsTFBranch() then
    timeKey = tfKey
  else
    timeKey = releaseKey
  end
  if timeKey == nil then
    return true
  end
  local searchTable = recipeData
  if searchTableName == "Item" then
    searchTable = Table_Item[recipeData.Product]
  end
  local validDate = searchTable[timeKey]
  if StringUtil.IsEmpty(validDate) then
    return true
  end
  return validDate < getNowTimeString()
end

local bagItemDataFunctionCD, cdProxy

function ItemUtil.GetCdTime(item)
  if type(item) ~= "table" then
    return 0
  end
  if not bagItemDataFunctionCD then
    bagItemDataFunctionCD = FunctionCDCommand.Me():GetBagItemDataCDProxy(BagProxy.Instance)
    cdProxy = CDProxy.Instance
  end
  local cd = bagItemDataFunctionCD:TryGetItemClientUseSkillInId(item)
  if not cd then
    if item.cdGroup then
      cd = cdProxy:GetItemGroupInCD(item.cdGroup)
    else
      cd = cdProxy:GetItemInCD(item.staticData.id)
    end
  end
  return cd and cd:GetCd() or 0
end

local itemIdCollectionNameMap = {}

function ItemUtil.GetCollectionNameByItemId(itemId)
  if not itemIdCollectionNameMap[itemId] then
    itemIdCollectionNameMap[itemId] = ""
    local teamIds, cName = ItemUtil.GetRewardTeamIdsByItemId(itemId)
    if teamIds then
      for i = 1, #teamIds do
        cName = AdventureDataProxy.Instance.advRewardCollectionNameMap[teamIds[i]]
        if cName then
          itemIdCollectionNameMap[itemId] = cName
        end
      end
    end
  end
  return itemIdCollectionNameMap[itemId]
end

local EQUIP_MAXINDEX

function ItemUtil.EquipMaxIndex()
  if not EQUIP_MAXINDEX then
    EQUIP_MAXINDEX = 0
    InitEquipPos()
    for index, _ in pairs(ItemUtil.EquipPosConfig) do
      if index > EQUIP_MAXINDEX then
        EQUIP_MAXINDEX = index
      end
    end
  end
  return EQUIP_MAXINDEX
end

function ItemUtil.GetEposByIndex(index)
  InitEquipPos()
  return index and ItemUtil.EquipPosConfig[index] or nil
end

function ItemUtil.GetItemSite(itemData)
  local site = BagProxy.Instance:GetToEquipPos()
  if itemData and (itemData.equipInfo or itemData:IsMount()) then
    local poses = itemData.equipInfo:GetEquipSite()
    if poses then
      local posIsRight = false
      for _, sc in pairs(poses) do
        if sc == site then
          posIsRight = true
          break
        end
      end
      if not posIsRight then
        local nullPos, lowPos, lowEquipScore
        for _, pos in pairs(poses) do
          local equip = BagProxy.Instance.roleEquip:GetEquipBySite(pos)
          if not equip then
            nullPos = pos
            break
          else
            local score = equip.equipInfo:GetReplaceValues()
            if not lowEquipScore then
              lowEquipScore = score
              lowPos = pos
            elseif score < lowEquipScore then
              lowEquipScore = score
              lowPos = pos
            end
          end
        end
        site = nullPos or lowPos
      end
    end
  end
  return site
end

function ItemUtil.GetItemTypeName(itemStaticData, prefix)
  local itemTypeId = itemStaticData.Type
  local isYuanGu = Table_Equip and Table_Equip[itemStaticData.id]
  isYuanGu = isYuanGu and isYuanGu.SpiritType
  local typeName
  if isYuanGu then
    typeName = GameConfig.Equip and GameConfig.Equip.AncientEquipItemType and GameConfig.Equip.AncientEquipItemType[itemTypeId]
    if not typeName then
      return ""
    end
  else
    local typeConfig = Table_ItemType[itemTypeId]
    if not typeConfig then
      return ""
    end
    typeName = typeConfig.Name
  end
  prefix = prefix or ZhString.ItemTip_ItemType
  return prefix .. OverSea.LangManager.Instance():GetLangByKey(typeName)
end

function ItemUtil.GetRefineAttrPreview(equipInfo, refineCeil, nospace)
  if equipInfo then
    local refineEffect, currentLv = equipInfo.equipData.RefineEffect, equipInfo.refinelv
    local nextRefineLv = refineCeil or currentLv + 1
    local effectName, effectAddValue = next(refineEffect)
    if effectName and effectAddValue then
      local proName = GameConfig.EquipEffect[effectName], effectAddValue * currentLv
      local pro, isPercent = Game.Config_PropName[effectName], false
      if pro then
        isPercent = pro.IsPercent == 1
        proName = proName or pro.PropName
      end
      proName = proName .. ZhString.EquipRefineBord_EffectSperator
      local currentRefineValueText, nextRefineValueText
      local fmtStr = nospace and "+" or " +"
      if isPercent then
        currentRefineValueText = string.format("%s%s%%", fmtStr, effectAddValue * currentLv * 100)
        nextRefineValueText = string.format("%s%s%%", fmtStr, effectAddValue * nextRefineLv * 100)
      else
        currentRefineValueText = string.format("%s%s", fmtStr, effectAddValue * currentLv)
        nextRefineValueText = string.format("%s%s", fmtStr, effectAddValue * nextRefineLv)
      end
      return proName, currentRefineValueText, nextRefineValueText
    end
  end
  return "", "", ""
end

function ItemUtil.GetAttributeNameFromAbbreviation(str_abbreviation)
  return Game.Config_PropName[str_abbreviation] and Game.Config_PropName[str_abbreviation].PropName or nil
end

function ItemUtil.CheckCardPreviewValid(itemid)
  local config = GameConfig.NewPveRaid and GameConfig.NewPveRaid.PveCardPreview
  return nil ~= config and nil ~= config[itemid]
end

function ItemUtil.CheckItemDisplayValid(itemid)
  local config = Table_ItemDisplay[itemid]
  return nil ~= config
end

function ItemUtil.GetDeductionMaterialDatas(itemid)
  if not itemid then
    return
  end
  if ItemUtil.cacheDeductionMaterialDatas and ItemUtil.cacheDeductionMaterialDatas[itemid] then
    return ItemUtil.cacheDeductionMaterialDatas[itemid]
  end
  local datas = {}
  for k, v in pairs(Table_DeductionMaterial) do
    if v.Deduction == itemid then
      local data = {
        type = "DeductionMaterial",
        id = v.id,
        Cost = v.Deduction,
        CostNum = v.CostNum,
        TargetNum = v.TargetNum,
        Targets = {}
      }
      local targets = {}
      if v.DisplayTargetItem and #v.DisplayTargetItem > 0 then
        data.RepTarget = v.DisplayTargetItem[1]
        targets = v.DisplayTargetItem
      else
        data.RepTarget = v.TargetItem[1]
        targets = v.TargetItem
      end
      for i = 1, #targets do
        local itemdata = ItemData.new("CardRewardPreview", targets[i])
        itemdata:SetItemNum(1)
        data.Targets[i] = itemdata
      end
      datas[#datas + 1] = data
    end
  end
  ItemUtil.cacheDeductionMaterialDatas = ItemUtil.cacheDeductionMaterialDatas or {}
  ItemUtil.cacheDeductionMaterialDatas[itemid] = datas
  return datas
end

function ItemUtil.GetCardBookData(itemid, row)
  if not itemid then
    return
  end
  local wrapData = ItemUtil.cacheCardBook and ItemUtil.cacheCardBook[itemid]
  if not wrapData then
    ItemUtil.cacheCardBook = ItemUtil.cacheCardBook or {}
    local datas, tempdata = {}, {}
    local config = Table_UseItem[itemid]
    if config and config.UseEffect and config.UseEffect.class_weight and type(config.UseEffect.class_weight) == "table" then
      local totalWeight = 0
      for _, v in pairs(config.UseEffect.class_weight) do
        totalWeight = totalWeight + v
      end
      for k, v in pairs(config.UseEffect.class_weight) do
        local data = {
          class = k,
          weight = v / totalWeight * 100,
          cards = {}
        }
        datas[#datas + 1] = data
        tempdata[k] = data
      end
      for _, v in pairs(Table_Card) do
        if v.BookClass and v.BookClass ~= 0 and v.BookWeight and v.BookWeight ~= 0 then
          local data = tempdata[v.BookClass]
          if data then
            local itemdata = ItemData.new("CardRewardPreview", v.id)
            itemdata:SetItemNum(1)
            data.cards[#data.cards + 1] = itemdata
          end
        end
      end
    end
    for i = #datas, 1, -1 do
      if #datas[i].cards == 0 then
        table.remove(datas, i)
      end
    end
    wrapData = {}
    for i = 1, #datas do
      local _class = datas[i].class
      local _weight = datas[i].weight
      local _data_cards = datas[i].cards
      local row_cards = TableUtil.Array2RowArray(_data_cards, row)
      if row_cards then
        for j = 1, #row_cards do
          if j == 1 then
            local _data = {
              class = _class,
              weight = _weight,
              isTitle = true
            }
            wrapData[#wrapData + 1] = _data
          end
          local _data = {
            class = _class,
            cards = row_cards[j]
          }
          wrapData[#wrapData + 1] = _data
        end
      end
    end
    ItemUtil.cacheCardBook[itemid] = wrapData
  end
  return wrapData
end

local _DeductionMaterial

function ItemUtil.CheckDeductionMaterialValid(itemid)
  autoImport("Table_DeductionMaterial")
  if not Table_DeductionMaterial then
    return false
  end
  if not _DeductionMaterial then
    _DeductionMaterial = {}
    for _, v in pairs(Table_DeductionMaterial) do
      _DeductionMaterial[v.Deduction] = true
    end
  end
  return _DeductionMaterial[itemid] or false
end

function ItemUtil.CheckOpenCardBookValid(itemid)
  local config = Table_UseItem[itemid]
  return config and config.UseEffect and config.UseEffect.type == "openCardBook" or false
end

function ItemUtil.SetManualQuenchValue(v)
  ItemUtil.manualQuenchValue = v
end

function ItemUtil.SetQuenchViewOpen(open)
  ItemUtil.QuenchOpen = open
end

function ItemUtil.GetEnchantResetCost(itemtype)
  if not (GameConfig.EnchantFunc and GameConfig.EnchantFunc.headItems) or not GameConfig.EnchantFunc.resetItem then
    redlog("【附魔重置】消耗材料配置错误，检查配置GameConfig.EnchantFunc.headItems GameConfig.EnchantFunc.resetItem")
    return
  end
  return GameConfig.EnchantFunc.headItems[itemtype] or GameConfig.EnchantFunc.resetItem
end

local million = 1000000
local billion = 1000000000

function ItemUtil.CalcUnionNum(num)
  local result
  local b = math.modf(num / billion)
  local m = math.modf(num / million)
  if 0 < b then
    result = tostring(b) .. "B"
  elseif 0 < m then
    result = tostring(m) .. "M"
  else
    result = tostring(num)
  end
  return result
end

function ItemUtil.GetValue(num)
  local int, floor = math.modf(num)
  return 0 < floor and num or int
end

local _Separator = "[Quench]"
local _QuenchViewStrFormat = "[c][38C300]%s[-][/c]"

function ItemUtil.GetBuffDesc(static_desc, quenchper)
  static_desc = static_desc or ""
  static_desc = OverSea.LangManager.Instance():GetLangByKey(static_desc)
  if string.match(static_desc, _Separator) then
    quenchper = quenchper or 1
    quenchper = math.clamp(quenchper, 0, 1)
    local desc = string.split(static_desc, _Separator)
    local separatorResult = ""
    local _Format = string.format
    local getValue = ItemUtil.GetValue
    for i = 1, #desc do
      if nil ~= tonumber(desc[i]) then
        local value = getValue(desc[i] * quenchper)
        if ItemUtil.manualQuenchValue then
          separatorResult = separatorResult .. _Format(_QuenchViewStrFormat, value)
        else
          separatorResult = separatorResult .. value
        end
      else
        separatorResult = separatorResult .. desc[i]
      end
    end
    return separatorResult
  else
    return static_desc
  end
end

function ItemUtil.GetExtraHp(item)
  local func = ItemFun.calcExtraRefineLvToBaseHp
  if not func then
    redlog("ItemFun.calcExtraRefineLvToBaseHp配置未传")
    return 0
  end
  if not item or not item:IsServerShadowEquip() then
    return 0
  end
  local quenchper = item:GetQuenchPer() or 0
  local _bagProxy = BagProxy.Instance
  local equip_bagData = _bagProxy.roleEquip
  local shadow_equip_bagData = _bagProxy.shadowBagData
  local pos = shadow_equip_bagData:GetSite(item.id)
  local equip_item = equip_bagData:GetEquipBySite(pos)
  local shadow_equip_item = shadow_equip_bagData:GetEquipBySite(pos)
  local equip_refineLv = equip_item and equip_item.equipInfo and equip_item.equipInfo.refinelv or 0
  local shadow_equip_refineLv = shadow_equip_item and shadow_equip_item.equipInfo and shadow_equip_item.equipInfo.refinelv or 0
  local hp = func(pos, equip_refineLv, shadow_equip_refineLv, quenchper)
  if 0 < hp then
    local int, floor = math.modf(hp)
    if 0 < floor then
      return hp
    else
      return int
    end
  end
  return hp
end

function ItemUtil.HasMappingPos(pos)
  return pos and pos >= SceneItem_pb.EEQUIPPOS_SHIELD and pos <= SceneItem_pb.EEQUIPPOS_ACCESSORY2
end

function ItemUtil.IsExtractionPos(pos)
  return pos and pos >= ItemUtil.EquipExtractionMinPos and pos <= ItemUtil.EquipExtraxtionMaxPos
end

function ItemUtil.IsPersonalArtifactPos(pos)
  return pos and pos == SceneItem_pb.EEQUIPPOS_ARTIFACT_RING1
end

function ItemUtil.GetRewardSelectContent(itemid)
  if not itemid then
    return
  end
  local useItemData = Table_UseItem[itemid]
  local useEffect = useItemData and useItemData.UseEffect
  if useEffect.type == "headwear_box" then
    local giftStaticData = Table_Item[itemid]
    local headwears = Game.HeadwearBoxItems[itemid]
    if not headwears then
      redlog("头饰自选异常 ItemID:", itemid)
      return
    end
    local rewards = {}
    local myGender = MyselfProxy.Instance:GetMySex()
    local configEquipGender = Game.Config_EquipGender
    for i = 1, #headwears do
      local itemId = headwears[i]
      local config = Table_HeadwearRepair[itemId]
      if config then
        if myGender == 2 and configEquipGender[itemId] then
          itemId = configEquipGender[itemId]
        end
        rewards[i] = {itemId, 1}
      end
    end
    if GameConfig.HeadwearBoxExtraItems and GameConfig.HeadwearBoxExtraItems.ExtraItem then
      local extraItems = GameConfig.HeadwearBoxExtraItems.ExtraItem[giftStaticData.Quality]
      if extraItems then
        for i = 1, #extraItems do
          local extra = extraItems[i]
          rewards[#rewards + 1] = {
            extra[1],
            extra[2]
          }
        end
      end
    end
    return rewards
  end
end

function ItemUtil.GetMemoryTag(itemData)
  local equipMemoryData = itemData.equipMemoryData
  if not equipMemoryData then
    return
  end
  local maxAttrCount = equipMemoryData.maxAttrCount or 1
  local attrs = equipMemoryData and equipMemoryData.memoryAttrs
  local descStr = ""
  local unlockedCount = 0
  for i = 1, maxAttrCount do
    if attrs[i] then
      local attrConfig = Game.ItemMemoryEffect[attrs[i].id]
      if attrConfig then
        local staticId = attrConfig.level and attrConfig.level[1]
        local staticData = staticId and Table_ItemMemoryEffect[staticId]
        local previewDesc = staticData and staticData.PreviewDesc
        descStr = descStr .. OverSea.LangManager.Instance():GetLangByKey(previewDesc)
        if descStr ~= "" and i < #attrs then
          descStr = descStr .. ZhString.ItemTip_ChAnd
        end
      else
        unlockedCount = unlockedCount + 1
      end
    else
      unlockedCount = unlockedCount + 1
    end
  end
  if 0 < unlockedCount then
    if descStr ~= "" then
      descStr = descStr .. ZhString.ItemTip_ChAnd
    end
    descStr = descStr .. string.format(ZhString.EquipMemory_UnlockCount, unlockedCount)
  end
  return descStr
end

local _Seperator = "[AttrValue]"
local _SeperatorWax = "[WaxEffect]"

function ItemUtil.GetMemoryEffectInfo(attrId, excess_lv)
  local attrConfig = Game.ItemMemoryEffect[attrId]
  if attrConfig then
    local attrInfo = {}
    local _buffName
    local _buffFormatStr = ""
    if attrConfig.level then
      for _level, _staticId in pairs(attrConfig.level) do
        local _attrValue = {}
        local staticData = Table_ItemMemoryEffect[_staticId]
        local buffids = staticData and staticData.BuffID
        if buffids then
          local chosenBuffIds = {}
          if type(buffids) == "table" then
            if not buffids[0] and 0 < #buffids then
              for i = 1, #buffids do
                table.insert(chosenBuffIds, buffids[i])
              end
            else
              local targetStage = tonumber(excess_lv) or 0
              local maxKey
              for k, _ in pairs(buffids) do
                if type(k) == "number" and k <= targetStage and (not maxKey or k > maxKey) then
                  maxKey = k
                end
              end
              if maxKey ~= nil then
                local targetBuffIds = buffids[maxKey]
                if type(targetBuffIds) == "table" then
                  local firstBuffId = next(targetBuffIds) and targetBuffIds[next(targetBuffIds)]
                  if firstBuffId then
                    table.insert(chosenBuffIds, firstBuffId)
                  end
                else
                  table.insert(chosenBuffIds, targetBuffIds)
                end
              elseif buffids[0] ~= nil then
                local targetBuffIds = buffids[0]
                if type(targetBuffIds) == "table" then
                  local firstBuffId = next(targetBuffIds) and targetBuffIds[next(targetBuffIds)]
                  if firstBuffId then
                    table.insert(chosenBuffIds, firstBuffId)
                  end
                else
                  table.insert(chosenBuffIds, targetBuffIds)
                end
              elseif buffids[1] ~= nil then
                local targetBuffIds = buffids[1]
                if type(targetBuffIds) == "table" then
                  local firstBuffId = next(targetBuffIds) and targetBuffIds[next(targetBuffIds)]
                  if firstBuffId then
                    table.insert(chosenBuffIds, firstBuffId)
                  end
                else
                  table.insert(chosenBuffIds, targetBuffIds)
                end
              end
            end
          end
          if 0 < #chosenBuffIds then
            for i = 1, #chosenBuffIds do
              local buffInfo = Table_Buffer[chosenBuffIds[i]]
              _buffName = _buffName or buffInfo.BuffName
              local _desc = string.split(OverSea.LangManager.Instance():GetLangByKey(buffInfo.Dsc), _Seperator)
              for j = 1, #_desc do
                if tonumber(_desc[j]) ~= nil then
                  table.insert(_attrValue, _desc[j])
                end
              end
              if _buffFormatStr == "" then
                for j = 1, #_desc do
                  if tonumber(_desc[j]) ~= nil then
                    _buffFormatStr = _buffFormatStr .. "[AttrValue]"
                  else
                    _buffFormatStr = _buffFormatStr .. _desc[j]
                  end
                end
              end
            end
            attrInfo[_level] = {BuffName = _buffName, FormatStr = _buffFormatStr}
            attrInfo[_level].AttrValue = {}
            TableUtility.ArrayShallowCopy(attrInfo[_level].AttrValue, _attrValue)
          end
        end
      end
    end
    return attrInfo
  end
end

function ItemUtil.BuildMemoryEffectAggregate(attrId, stages)
  local attrConfig = Game.ItemMemoryEffect[attrId]
  if not attrConfig then
    return nil
  end
  if not stages or type(stages) ~= "table" then
    return nil
  end
  local aggregate = {
    BuffName = nil,
    FormatStr = nil,
    AttrValue = {}
  }
  for stage, count in pairs(stages) do
    local info = ItemUtil.GetMemoryEffectInfo(attrId, stage)
    if info and info[1] then
      if not aggregate.BuffName then
        aggregate.BuffName = info[1].BuffName
      end
      if not aggregate.FormatStr then
        aggregate.FormatStr = info[1].FormatStr
      end
      if info[1].AttrValue then
        for idx, v in ipairs(info[1].AttrValue) do
          local addVal = (tonumber(v) or 0) * (tonumber(count) or 0)
          aggregate.AttrValue[idx] = (aggregate.AttrValue[idx] or 0) + addVal
        end
      end
    end
  end
  return aggregate
end

function ItemUtil.GetMemoryWaxDesc(attrId, wax_level, enablecolor, disablecolor)
  local waxLevelDesc = {}
  local enablecolor = enablecolor or "[c][1E9D00]%s[-][/c]"
  local disablecolor = disablecolor or "[c][6C6C6C]%s[-][/c]"
  local attrConfig = Game.ItemMemoryEffect[attrId]
  if attrConfig and attrConfig.level then
    for _level, _staticId in pairs(attrConfig.level) do
      local staticData = Table_ItemMemoryEffect[_staticId]
      local waxDesc = staticData and staticData.WaxDesc
      if waxDesc and waxDesc ~= "" then
        local _desc = string.split(waxDesc, _SeperatorWax)
        local tempStr = ""
        for i = 1, #_desc do
          if string.find(_desc[i], "/") then
            local _valueStr = ""
            local _values = string.split(_desc[i], "/")
            for j = 1, #_values do
              if wax_level == j then
                _valueStr = _valueStr .. string.format(enablecolor, _values[j])
              else
                _valueStr = _valueStr .. string.format(disablecolor, _values[j])
              end
              if j < #_values then
                _valueStr = _valueStr .. "/"
              end
            end
            tempStr = tempStr .. _valueStr
          else
            tempStr = tempStr .. _desc[i]
          end
        end
        for i = _level, 3 do
          if not waxLevelDesc[i] then
            waxLevelDesc[i] = tempStr
          else
            waxLevelDesc[i] = waxLevelDesc[i] .. "  " .. tempStr
          end
        end
      end
    end
  end
  return waxLevelDesc
end
