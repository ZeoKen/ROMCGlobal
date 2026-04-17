SnowCrownProxy = class("SnowCrownProxy", pm.Proxy)
SnowCrownProxy.Instance = nil
SnowCrownProxy.NAME = "SnowCrownProxy"
SnowCrownProxy.SNOW_CROWN_ITEM_ID = 45563
SnowCrownProxy.ModeEnum = {
  Min = 0,
  Atk = 1,
  Def = 2,
  Ele = 3
}

function SnowCrownProxy:ctor(proxyName, data)
  self.proxyName = proxyName or SnowCrownProxy.NAME
  if SnowCrownProxy.Instance == nil then
    SnowCrownProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function SnowCrownProxy:Init()
  self.snowData = nil
  self.currentGuid = nil
  self.snowManualData = {
    positions = {},
    stoneBook = {}
  }
end

function SnowCrownProxy:ParseServerItemData(serverItemData)
  if not serverItemData then
    return nil
  end
  if not serverItemData.base then
    return nil
  end
  if not serverItemData.base.id or serverItemData.base.id == 0 then
    return
  end
  local itemData = ItemData.new(serverItemData.base.guid, serverItemData.base.id)
  itemData:ParseFromServerData(serverItemData)
  return itemData
end

function SnowCrownProxy:GetHashTableCount(t)
  if not t then
    return 0
  end
  local count = 0
  for _ in pairs(t) do
    count = count + 1
  end
  return count
end

SnowCrownProxy.EquipOperEnum = {
  MIN = 0,
  STORE = 1,
  TAKEOUT = 2
}
SnowCrownProxy.StoneOperEnum = {
  MIN = 0,
  STORE = 1,
  TAKEOUT = 2,
  LEVELUP = 3
}

function SnowCrownProxy:RequestQuerySnowManual()
  if ServiceSnowCmdProxy.Instance then
    ServiceSnowCmdProxy.Instance:CallQuerySnowManualSnowCmd()
  end
end

function SnowCrownProxy:RecvQuerySnowManualSnowCmd(data)
  if not data then
    return
  end
  self.snowManualData.positions = {}
  self.snowManualData.stoneBook = {}
  if data.pos then
    for i = 1, #data.pos do
      local posData = data.pos[i]
      if posData and posData.id then
        local equipData = self:ParseServerItemData(posData.equip)
        self.snowManualData.positions[posData.id] = {
          id = posData.id,
          equip = equipData,
          stoneids = posData.stoneids or {}
        }
        xdlog("装备数据", posData.id, equipData and equipData.id or 0, posData.stoneids and #posData.stoneids)
      end
    end
  end
  if data.stone_book then
    for i = 1, #data.stone_book do
      local stoneData = data.stone_book[i]
      if stoneData and stoneData.id then
        self.snowManualData.stoneBook[stoneData.id] = {
          lv = stoneData.lv or 0,
          advlv = stoneData.advlv or 0,
          advexp = stoneData.advexp or 0,
          overflow = stoneData.overflow or 0
        }
      end
    end
  end
end

function SnowCrownProxy:RecvSnowManualUpdateSnowCmd(data)
  if not data or not data.updates then
    return
  end
  local progressChanges = {}
  local overflowChanges = {}
  for i = 1, #data.updates do
    local stoneData = data.updates[i]
    if stoneData and stoneData.id then
      local stoneId = stoneData.id
      local oldData = self.snowManualData.stoneBook[stoneId]
      local newData = {
        lv = stoneData.lv or 0,
        advlv = stoneData.advlv or 0,
        advexp = stoneData.advexp or 0,
        overflow = stoneData.overflow or 0
      }
      local progressInfo, overflowInfo = self:CompareStoneData(stoneId, oldData, newData)
      if progressInfo then
        table.insert(progressChanges, progressInfo)
      end
      if overflowInfo then
        table.insert(overflowChanges, overflowInfo)
      end
      self.snowManualData.stoneBook[stoneId] = {
        lv = newData.lv,
        advlv = newData.advlv,
        advexp = newData.advexp,
        overflow = 0
      }
    end
  end
  if 0 < #progressChanges or 0 < #overflowChanges then
    self:ShowGemRewardPopup(progressChanges, overflowChanges)
  end
  self:sendNotification(ServiceEvent.SnowCmdSnowManualUpdateSnowCmd)
end

function SnowCrownProxy:CompareStoneData(stoneId, oldData, newData)
  if not newData then
    return nil, nil
  end
  local isNewStone = oldData == nil
  local oldAdvlv = oldData and oldData.advlv or 0
  local oldAdvexp = oldData and oldData.advexp or 0
  local newAdvlv = newData.advlv or 0
  local newAdvexp = newData.advexp or 0
  local overflow = newData.overflow or 0
  local stoneConfig = Table_SnowStone and Table_SnowStone[stoneId]
  local itemConfig = stoneConfig and Table_Item and Table_Item[stoneId]
  local quality = itemConfig and itemConfig.Quality or 1
  local stoneAdvanceCount = GameConfig.Snow and GameConfig.Snow.StoneAdvanceCount or {}
  local maxCount = stoneAdvanceCount[newAdvlv + 1] or 1
  local progressInfo
  local hasProgressChange = isNewStone or newAdvlv ~= oldAdvlv or newAdvexp ~= oldAdvexp
  if hasProgressChange then
    local oldProgress = 0
    local newProgress = 0
    if oldAdvlv == newAdvlv then
      oldProgress = oldAdvexp / maxCount
      newProgress = newAdvexp / maxCount
    else
      newProgress = newAdvexp / maxCount
    end
    local progressDelta = newProgress - oldProgress
    progressInfo = {
      stoneId = stoneId,
      quality = quality,
      oldAdvlv = oldAdvlv,
      oldAdvexp = oldAdvexp,
      newAdvlv = newAdvlv,
      newAdvexp = newAdvexp,
      maxCount = maxCount,
      progressDelta = progressDelta,
      level = newData.lv,
      isNewStone = isNewStone
    }
  end
  local overflowInfo
  if 0 < overflow then
    overflowInfo = {
      stoneId = stoneId,
      quality = quality,
      overflow = overflow,
      level = newData.lv,
      newAdvlv = newAdvlv
    }
  end
  return progressInfo, overflowInfo
end

function SnowCrownProxy:ShowGemRewardPopup(progressChanges, overflowChanges)
  if (not progressChanges or #progressChanges == 0) and (not overflowChanges or #overflowChanges == 0) then
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.SnowGemRewardPopup,
    viewdata = {
      progressChanges = progressChanges or {},
      overflowChanges = overflowChanges or {}
    }
  })
end

function SnowCrownProxy:RecvSnowManualEquipUpdateSnowCmd(data)
  if not data or not data.pos then
    return
  end
  local pos = data.pos
  if not self.snowManualData.positions[pos] then
    self.snowManualData.positions[pos] = {
      id = pos,
      equip = nil,
      stoneids = {}
    }
  end
  self.snowManualData.positions[pos].equip = self:ParseServerItemData(data.update)
  xdlog("RecvSnowManualEquipUpdateSnowCmd | pos:", pos, "| hasEquip:", data.update ~= nil)
  self:sendNotification(ServiceEvent.SnowCmdSnowManualEquipUpdateSnowCmd, {pos = pos})
end

function SnowCrownProxy:RecvSnowManualStoneUpdateSnowCmd(data)
  if not data then
    return
  end
  local equipPos = data.equip_pos
  local stonePos = data.stone_pos
  local stoneId = data.update
  if not self.snowManualData.positions[equipPos] then
    self.snowManualData.positions[equipPos] = {
      id = equipPos,
      equip = nil,
      stoneids = {}
    }
  end
  self.snowManualData.positions[equipPos].stoneids[stonePos + 1] = stoneId
  xdlog("RecvSnowManualStoneUpdateSnowCmd | equipPos:", equipPos, "| stonePos:", stonePos, "| stoneId:", stoneId)
end

function SnowCrownProxy:RequestOperSnowEquip(oper, pos, equipGuid)
  xdlog("RequestOperSnowEquip", oper, pos, equipGuid)
  if ServiceSnowCmdProxy.Instance then
    ServiceSnowCmdProxy.Instance:CallOperSnowEquipSnowCmd(oper, pos, equipGuid)
  end
end

function SnowCrownProxy:RequestOperSnowStone(oper, equipPos, stonePos, stoneId)
  xdlog("RequestOperSnowStone", oper, equipPos, stonePos, stoneId)
  if ServiceSnowCmdProxy.Instance then
    ServiceSnowCmdProxy.Instance:CallOperSnowStoneSnowCmd(oper, equipPos, stonePos, stoneId)
  end
end

function SnowCrownProxy:GetSlotEquipData(slotIndex)
  local posData = self.snowManualData.positions[slotIndex]
  if posData and posData.equip then
    return posData.equip
  end
  return nil
end

function SnowCrownProxy:GetSlotGemData(slotIndex, gemIndex)
  local posData = self.snowManualData.positions[slotIndex]
  if posData and posData.stoneids then
    local stoneId = posData.stoneids[gemIndex]
    if stoneId and 0 < stoneId then
      local bookData = self.snowManualData.stoneBook[stoneId]
      return {
        id = stoneId,
        level = bookData and bookData.lv or 0,
        starLevel = bookData and bookData.advlv or 0
      }
    end
  end
  return nil
end

function SnowCrownProxy:GetStoneBookData(stoneId)
  return self.snowManualData.stoneBook[stoneId]
end

function SnowCrownProxy:GetGemLevel(gemId)
  local bookData = self.snowManualData.stoneBook[gemId]
  if bookData then
    return bookData.lv or 0
  end
  return 0
end

function SnowCrownProxy:GetGemAdvanceLevel(gemId)
  local bookData = self.snowManualData.stoneBook[gemId]
  if bookData then
    return bookData.advlv or 0
  end
  return 0
end

function SnowCrownProxy:IsGemUnlocked(gemId)
  return self.snowManualData.stoneBook[gemId] ~= nil
end

function SnowCrownProxy:GetUnlockedGemIds()
  local unlockedIds = {}
  for id, _ in pairs(self.snowManualData.stoneBook) do
    unlockedIds[id] = true
  end
  return unlockedIds
end

function SnowCrownProxy:GetCrownIdByGroupId(groupId)
  if self.snowData and self.snowData.crowndata and self.snowData.crowndata.ids then
    for i = 1, #self.snowData.crowndata.ids do
      local id = self.snowData.crowndata.ids[i]
      if id // 100 == groupId then
        return id
      end
    end
  end
  return groupId * 100
end

function SnowCrownProxy:GetSnowCrownGuidFromBag()
  if not BagProxy.Instance then
    return nil
  end
  local item = BagProxy.Instance:GetItemByStaticID(SnowCrownProxy.SNOW_CROWN_ITEM_ID)
  if item and item.staticData and item.staticData.id == SnowCrownProxy.SNOW_CROWN_ITEM_ID then
    return item.id
  end
  local items = BagProxy.Instance:GetItemsByStaticID(SnowCrownProxy.SNOW_CROWN_ITEM_ID)
  if items and 0 < #items and items[1] then
    return items[1].id
  end
  if BagProxy.Instance.roleEquip then
    local equipItems = BagProxy.Instance.roleEquip:GetItems()
    if equipItems then
      for i = 1, #equipItems do
        local equipItem = equipItems[i]
        if equipItem and equipItem.staticData and equipItem.staticData.id == SnowCrownProxy.SNOW_CROWN_ITEM_ID then
          return equipItem.id
        end
      end
    end
  end
  return nil
end

function SnowCrownProxy:RecvSnowHeadQuerySnowCmd(data)
  if not data then
    return
  end
  self.currentGuid = self:GetSnowCrownGuidFromBag()
  if data.data and data.data.fashiondatas then
    for i = 1, #data.data.fashiondatas do
      local fashionData = data.data.fashiondatas[i]
      if fashionData then
        if fashionData.fashionids then
          xdlog("RecvSnowHeadQuerySnowCmd | pos:", fashionData.pos, "| fashionids:", TableUtil.TableToStrEx(fashionData.fashionids))
        end
        if fashionData.useid then
          xdlog("RecvSnowHeadQuerySnowCmd | pos:", fashionData.pos, "| useid:", fashionData.useid)
        end
      end
    end
  end
  xdlog("独立ID", self.currentGuid)
  if data.data then
    self.snowData = self:CacheSnowData(data.data)
  end
end

function SnowCrownProxy:CacheSnowData(sourceData)
  if not sourceData then
    return nil
  end
  local cachedData = {}
  cachedData.batch = sourceData.batch
  cachedData.level = sourceData.level
  cachedData.open = sourceData.open
  cachedData.usemode = sourceData.usemode
  if sourceData.modedatas then
    cachedData.modedatas = {}
    for i = 1, #sourceData.modedatas do
      local modeData = sourceData.modedatas[i]
      if modeData then
        local cachedModeData = {
          mode = modeData.mode,
          activateids = {}
        }
        if modeData.activateids then
          for j = 1, #modeData.activateids do
            cachedModeData.activateids[j] = modeData.activateids[j]
          end
        end
        cachedData.modedatas[i] = cachedModeData
      end
    end
  end
  if sourceData.fashiondatas then
    cachedData.fashiondatas = {}
    for i = 1, #sourceData.fashiondatas do
      local fashionData = sourceData.fashiondatas[i]
      if fashionData then
        local cachedFashionData = {}
        for k, v in pairs(fashionData) do
          if type(v) == "table" then
            if v[1] then
              cachedFashionData[k] = {}
              for j = 1, #v do
                cachedFashionData[k][j] = v[j]
              end
            else
              cachedFashionData[k] = {}
              for key, val in pairs(v) do
                cachedFashionData[k][key] = val
              end
            end
          else
            cachedFashionData[k] = v
          end
        end
        cachedData.fashiondatas[i] = cachedFashionData
      end
    end
  end
  if sourceData.crowndata then
    cachedData.crowndata = {}
    if sourceData.crowndata.ids then
      cachedData.crowndata.ids = {}
      for i = 1, #sourceData.crowndata.ids do
        cachedData.crowndata.ids[i] = sourceData.crowndata.ids[i]
      end
    end
  end
  return cachedData
end

function SnowCrownProxy:GetCurrentLevel()
  if self.snowData and self.snowData.level then
    return self.snowData.level
  end
  return 0
end

function SnowCrownProxy:GetCurrentBatch()
  if self.snowData and self.snowData.batch then
    return self.snowData.batch
  end
  return 1
end

function SnowCrownProxy:GetCurrentUseMode()
  if self.snowData and self.snowData.usemode then
    return self.snowData.usemode
  end
  return SnowCrownProxy.ModeEnum.Atk
end

function SnowCrownProxy:ModeEnumToString(modeEnum)
  if modeEnum == SnowCrownProxy.ModeEnum.Atk then
    return "Atk"
  elseif modeEnum == SnowCrownProxy.ModeEnum.Def then
    return "Def"
  elseif modeEnum == SnowCrownProxy.ModeEnum.Ele then
    return "Element"
  end
  return "Atk"
end

function SnowCrownProxy:StringToModeEnum(modeString)
  if modeString == "Atk" then
    return SnowCrownProxy.ModeEnum.Atk
  elseif modeString == "Def" then
    return SnowCrownProxy.ModeEnum.Def
  elseif modeString == "Element" then
    return SnowCrownProxy.ModeEnum.Ele
  end
  return SnowCrownProxy.ModeEnum.Atk
end

function SnowCrownProxy:GetActivatedIdsByMode(modeEnum)
  if not self.snowData or not self.snowData.modedatas then
    return {}
  end
  for i = 1, #self.snowData.modedatas do
    local modeData = self.snowData.modedatas[i]
    if modeData and modeData.mode == modeEnum and modeData.activateids then
      return modeData.activateids
    end
  end
  return {}
end

function SnowCrownProxy:GetNodeDatasByBatchAndMode(batch, modeEnum)
  local nodeDatas = {}
  local activatedIds = self:GetActivatedIdsByMode(modeEnum)
  local activatedIdsMap = {}
  for i = 1, #activatedIds do
    activatedIdsMap[activatedIds[i]] = true
  end
  for id, config in pairs(Table_SnowMode) do
    if config.Batch == batch and config.Mode == modeEnum then
      local isUnlocked = activatedIdsMap[id] == true
      table.insert(nodeDatas, {
        id = id,
        config = config,
        isActivated = isUnlocked,
        isUnlocked = isUnlocked
      })
    end
  end
  table.sort(nodeDatas, function(a, b)
    local idA = a.id or 0
    local idB = b.id or 0
    return idA < idB
  end)
  return nodeDatas
end

SnowCrownProxy.StageMenuIdMap = {
  [1] = nil,
  [2] = 19393,
  [3] = 19394
}

function SnowCrownProxy:IsStageUnlocked(stage)
  local currentBatch = self:GetCurrentBatch()
  return stage <= currentBatch
end

function SnowCrownProxy:GetStageLabelText(stage)
  local isUnlocked = self:IsStageUnlocked(stage)
  if isUnlocked then
    if GameConfig.Snow and GameConfig.Snow.BatchInfo and GameConfig.Snow.BatchInfo[stage] then
      local name = GameConfig.Snow.BatchInfo[stage].name
      if name and name ~= "" then
        return name
      end
    end
    local stageTextKey = "CrownCustomPage_Stage" .. stage
    return ZhString[stageTextKey] or "阶段" .. stage
  else
    local menuId = SnowCrownProxy.StageMenuIdMap[stage]
    if menuId and Table_Menu[menuId] then
      return Table_Menu[menuId].text or ""
    end
    return ""
  end
end

function SnowCrownProxy:GetFashionDatas()
  if self.snowData and self.snowData.fashiondatas then
    return self.snowData.fashiondatas
  end
  return {}
end

function SnowCrownProxy:GetTotalAttrsByMode(modeEnum)
  if not self.snowData then
    return {}
  end
  local activatedIds = self:GetActivatedIdsByMode(modeEnum)
  if not activatedIds or #activatedIds == 0 then
    return {}
  end
  local activatedIdsMap = {}
  for i = 1, #activatedIds do
    activatedIdsMap[activatedIds[i]] = true
  end
  local attrSumMap = {}
  for id, config in pairs(Table_SnowMode) do
    if config.Mode == modeEnum and activatedIdsMap[id] and config.Attr then
      for attrName, attrValue in pairs(config.Attr) do
        if not attrSumMap[attrName] then
          attrSumMap[attrName] = 0
        end
        attrSumMap[attrName] = attrSumMap[attrName] + (attrValue or 0)
      end
    end
  end
  local attrList = {}
  for varName, totalValue in pairs(attrSumMap) do
    local propConfig = Game.Config_PropName and Game.Config_PropName[varName]
    local roleDataId = propConfig and propConfig.id or 9999
    table.insert(attrList, {
      varName = varName,
      value = totalValue,
      roleDataId = roleDataId,
      propConfig = propConfig
    })
  end
  table.sort(attrList, function(a, b)
    return a.roleDataId < b.roleDataId
  end)
  return attrList
end

function SnowCrownProxy:RequestLevelUp()
  if ServiceSnowCmdProxy.Instance then
    ServiceSnowCmdProxy.Instance:CallSnowHeadLvupSnowCmd(nil)
  end
end

function SnowCrownProxy:RequestActive(id)
  if not id then
    return
  end
  if ServiceSnowCmdProxy.Instance then
    ServiceSnowCmdProxy.Instance:CallSnowHeadActiveSnowCmd(nil, id)
  end
end

function SnowCrownProxy:RequestModeChange(modeEnum)
  if ServiceSnowCmdProxy.Instance then
    ServiceSnowCmdProxy.Instance:CallSnowHeadModeChangeSnowCmd(nil, modeEnum)
  end
end

function SnowCrownProxy:RequestQuery()
  if ServiceSnowCmdProxy.Instance then
    ServiceSnowCmdProxy.Instance:CallSnowHeadQuerySnowCmd()
  end
end

SnowCrownProxy.TestData = {
  guid = "test_guid_001",
  data = {
    batch = 2,
    level = 10,
    open = true,
    usemode = SnowCrownProxy.ModeEnum.Atk,
    modedatas = {
      {
        mode = SnowCrownProxy.ModeEnum.Atk,
        activateids = {
          1,
          3,
          5,
          7,
          9
        }
      },
      {
        mode = SnowCrownProxy.ModeEnum.Def,
        activateids = {
          46,
          48,
          50,
          52,
          54,
          56,
          58,
          60,
          62
        }
      },
      {
        mode = SnowCrownProxy.ModeEnum.Ele,
        activateids = {91, 93}
      }
    },
    fashiondatas = {
      {
        pos = 1,
        useid = 45563,
        fashionids = {45563, 45564}
      }
    },
    crowndata = {
      ids = {1001, 1002}
    }
  }
}

function SnowCrownProxy:GetEquippedHeadFashionIds(userData)
  if not userData then
    return {}
  end
  local bytes = userData:GetBytes(UDEnum.HEAD_FASHION)
  if not bytes or bytes == "" then
    return {}
  end
  local fashionIds = {}
  local rets = string.split(bytes, ";")
  for i = 1, #rets do
    local fashionId = tonumber(rets[i])
    if fashionId and 0 < fashionId then
      table.insert(fashionIds, fashionId)
    end
  end
  return fashionIds
end

function SnowCrownProxy:GetUnlockedFashionIdsByPos(pos)
  if not self.snowData or not self.snowData.fashiondatas then
    return {}
  end
  for i = 1, #self.snowData.fashiondatas do
    local fashionData = self.snowData.fashiondatas[i]
    if fashionData and fashionData.pos == pos and fashionData.fashionids then
      return fashionData.fashionids
    end
  end
  return {}
end

function SnowCrownProxy:GetEquippedFashionIdByPos(pos)
  if not self.snowData or not self.snowData.fashiondatas then
    return nil
  end
  for i = 1, #self.snowData.fashiondatas do
    local fashionData = self.snowData.fashiondatas[i]
    if fashionData and fashionData.pos == pos then
      local useid = fashionData.useid or 0
      return useid
    end
  end
  return nil
end

function SnowCrownProxy:GetFashionIdsByPos(pos)
  local fashionIds = {}
  for id, config in pairs(Table_SnowFashion) do
    if config.Pos == pos then
      table.insert(fashionIds, id)
    end
  end
  return fashionIds
end

function SnowCrownProxy:GetFashionDataListByPos(pos)
  local unlockedIndexes = self:GetUnlockedFashionIdsByPos(pos)
  local unlockedIndexMap = {}
  for i = 1, #unlockedIndexes do
    unlockedIndexMap[unlockedIndexes[i]] = true
  end
  local equippedIndex = self:GetEquippedFashionIdByPos(pos)
  local fashionList = {}
  for id, config in pairs(Table_SnowFashion) do
    if config.Pos == pos then
      local isUnlocked = config.Index and unlockedIndexMap[config.Index] == true
      local isEquipped = equippedIndex ~= nil and 0 < equippedIndex and config.Index and equippedIndex == config.Index
      local unlockDesc = ""
      if not isUnlocked and config.Menu then
        local menuConfig = Table_Menu[config.Menu]
        if menuConfig and menuConfig.Tip then
          unlockDesc = menuConfig.Tip
        end
      end
      local itemId = config.item
      table.insert(fashionList, {
        id = id,
        itemId = itemId,
        index = config.Index,
        isUnlocked = isUnlocked,
        isEquipped = isEquipped,
        unlockDesc = unlockDesc,
        config = config
      })
    end
  end
  table.sort(fashionList, function(a, b)
    if a.index and b.index then
      return (a.index or 0) < (b.index or 0)
    end
    return (a.id or 0) < (b.id or 0)
  end)
  return fashionList
end

function SnowCrownProxy:LoadTestData()
  local testData = SnowCrownProxy.TestData
  if testData and testData.data then
    self.currentGuid = testData.guid
    self.snowData = testData.data
    helplog("SnowCrownProxy:LoadTestData 已加载测试数据", "batch:", self.snowData.batch, "level:", self.snowData.level)
  end
end
