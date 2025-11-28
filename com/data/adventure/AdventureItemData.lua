autoImport("EquipInfo")
autoImport("AdventureAppendData")
AdventureItemData = class("AdventureItemData")
local CheckInvalid = function(id)
  if Table_FuncState[136] and 0 ~= TableUtility.ArrayFindIndex(Table_FuncState[136].ItemID, id) and not FunctionUnLockFunc.checkFuncStateValid(136) then
    return true
  end
  return false
end

function AdventureItemData:ctor(serverData, type)
  self.type = type
  self.cardSlotNum = 0
  self.num = 0
  self.tabData = nil
  self.staticId = serverData.id
  self.savedItemDatas = {}
  self.savedItemDatasMap = {}
  self:updateManualData(serverData)
  self:initStaticData(self.staticId, serverData)
  self.isAdventureItemData = true
end

function AdventureItemData:test()
  if #self.setAppendDatas > 0 then
    self.status = SceneManual_pb.EMANUALSTATUS_UNLOCK_STEP
    for i = 1, #self.setAppendDatas do
      local single = self.setAppendDatas[i]
      single.finish = true
      single.rewardget = false
    end
  end
end

function AdventureItemData:GetFoodSData()
end

function AdventureItemData:IsLimitUse()
  return false
end

function AdventureItemData:isCollectionGroup()
  if self.type == nil then
    return true
  end
end

function AdventureItemData:canBeClick()
  if self.status == SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT then
    return true
  end
  local tmpList = ReusableTable.CreateArray()
  local cps = self:getCompleteNoRewardAppend(tmpList)
  local haveReward = false
  if cps and 0 < #cps then
    haveReward = true
  end
  ReusableTable.DestroyAndClearArray(tmpList)
  return haveReward
end

function AdventureItemData:updateManualData(serverData)
  if self.type == SceneManual_pb.EMANUALTYPE_ITEM then
    self.status = SceneManual_pb.EMANUALSTATUS_UNLOCK
  else
    self.status = serverData.status
  end
  self.attrUnlock = serverData.unlock
  self.store = serverData.store
  if serverData.data_params and self.type == SceneManual_pb.EMANUALTYPE_SCENERY then
    self:updateSceneData(serverData.data_params)
  end
  if serverData.quests then
    self:updateAppendData(serverData.quests)
  end
  local storeditems = serverData.storeditems
  TableUtility.TableClear(self.savedItemDatas)
  TableUtility.TableClear(self.savedItemDatasMap)
  if storeditems and 0 < #storeditems then
    local serverItem, itemData
    for i = 1, #storeditems do
      serverItem = storeditems[i].base
      if serverItem.id and serverItem.id ~= 0 then
        itemData = ItemData.new(serverItem.guid, serverItem.id)
        itemData:ParseFromServerData(storeditems[i])
        self.savedItemDatas[#self.savedItemDatas + 1] = itemData
        self.savedItemDatasMap[itemData.staticData.id] = true
      end
    end
  end
  local item = serverData.item
  if self.equipInfo and item and item.id and item.id ~= 0 then
    self:SetStrength(item)
    self.equipInfo:SetRefine(item.equip.refinelv)
  end
  if self.equipInfo then
    self.equipInfo:SetRefine(self:TryGetRefineLv(serverData.storeditems))
  end
  self.cup_name = self:TryGetCupName(self.savedItemDatas)
  if Table_Card[self.staticId] then
    self:SetCardLevel()
  end
end

function AdventureItemData:TryGetCupName(savedItemDatas)
  local config = GameConfig.GVGConfig.season_diff
  for i = 1, #config do
    if self.staticId == config[i].champion_cup_item then
      if savedItemDatas[1] ~= nil and savedItemDatas[1].cup_name then
        return savedItemDatas[1].cup_name
      else
        return ZhString.AdventureTip_CupDefaultName
      end
    end
  end
end

function AdventureItemData:updateSceneData(params)
  self.anglez = params[1] or 0
  self.anglez = tonumber(self.anglez)
  self.time = params[2] == "" and 0 or params[2] or 0
  self.time = tonumber(self.time)
  self.roleId = params[3]
  if not self.oldRoleId then
    self.oldRoleId = self.roleId
  end
  if self.roleId then
    self.roleId = tonumber(self.roleId)
  end
  if self.oldRoleId then
    self.oldRoleId = tonumber(self.oldRoleId)
  end
  MySceneryPictureManager.Instance():log("updateSceneData:", self.staticId, tostring(self.roleId), tostring(self.time), self.anglez, self.oldRoleId)
end

function AdventureItemData:updateAppendData(appends)
  self.setAppendDatas = self.setAppendDatas or {}
  for i = 1, #appends do
    local single = appends[i]
    local appData = self:getAppendDataById(single.id)
    if appData then
      appData:updateData(single)
    else
      appData = AdventureAppendData.new(single)
      if appData and appData.staticData then
        table.insert(self.setAppendDatas, appData)
      end
    end
  end
  table.sort(self.setAppendDatas, function(l, r)
    return l.staticId < r.staticId
  end)
end

function AdventureItemData:getAppendDataById(appendId)
  if self.setAppendDatas then
    for i = 1, #self.setAppendDatas do
      local single = self.setAppendDatas[i]
      if single.staticId == appendId then
        return single
      end
    end
  end
end

function AdventureItemData:setIsSelected(isSelected)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
  end
end

function AdventureItemData:TryGetRefineLv(savedItemDatas)
  if savedItemDatas then
    for _, v in pairs(savedItemDatas) do
      if v and v.equip and v.equip.refinelv then
        return v.equip.refinelv
      end
    end
  end
  return 0
end

function AdventureItemData:initStaticData(staticId, serverData)
  self.staticId = staticId
  self.validDateArray = {}
  if self.type == SceneManual_pb.EMANUALTYPE_NPC then
    self.staticData = Table_Npc[staticId]
  elseif self.type == SceneManual_pb.EMANUALTYPE_MONSTER or self.type == SceneManual_pb.EMANUALTYPE_MATE or self.type == SceneManual_pb.EMANUALTYPE_PET then
    self.staticData = Table_Monster[staticId]
    if self.type == SceneManual_pb.EMANUALTYPE_PET then
      self.validDateArray = ItemUtil.GetValidDateByPetId(staticId)
    end
  elseif self.type == SceneManual_pb.EMANUALTYPE_MAP then
    self.staticData = Table_Map[staticId]
  elseif self.type == SceneManual_pb.EMANUALTYPE_ACHIEVE then
    self.staticData = Table_Achievement[staticId]
  elseif self.type == SceneManual_pb.EMANUALTYPE_SCENERY then
    self.staticData = Table_Viewspot[staticId]
  elseif self.type == SceneManual_pb.EMANUALTYPE_PRESTIGE then
    self.staticData = Table_Prestige[staticId]
  else
    self.staticData = Table_Item[staticId]
    if not self.staticData then
      return
    end
    self.validDateArray[1] = self.staticData.ValidDate
    self.validDateArray[2] = self.staticData.TFValidDate
    local equipData = Table_Equip[staticId]
    if equipData ~= nil then
      self.equipInfo = EquipInfo.new(equipData)
      local item = serverData.item
      if item then
        self:SetStrengthLv(item)
        self.equipInfo:SetRefine(item.equip.refinelv)
      end
      self.equipInfo:SetRefine(self:TryGetRefineLv(serverData.storeditems))
    else
      self.equipInfo = nil
    end
    self.cardInfo = Table_Card[staticId]
    self.monthCardInfo = Table_MonthCard[staticId]
    if serverData.data_params and #serverData.data_params > 0 then
      self.monthCardURl = serverData.data_params[1]
    end
    self.furnitureInfo = Table_HomeFurniture[staticId]
    self.homeMaterialInfo = Table_HomeFurnitureMaterial[staticId]
  end
  if self.staticData and self.staticData.AdventureValue and 0 < self.staticData.AdventureValue then
    self.AdventureValue = self.staticData.AdventureValue
  else
    self.AdventureValue = 0
  end
end

function AdventureItemData:SetStrengthLv(server_item)
  local guid, pos = server_item.base.guid, server_item.base.index
  local lv = BagProxy.Instance:GetItemSiteStrengthLv(guid, pos)
  self.equipInfo:SetEquipStrengthLv(lv)
end

function AdventureItemData:SetStrengthLv(server_item)
  local guid, pos = server_item.base.guid, server_item.base.index
  local lv = BagProxy.Instance:GetItemSiteStrengthLv(guid, pos)
  self.equipInfo:SetEquipStrengthLv(lv)
end

function AdventureItemData:SetStrengthLv(server_item)
  local guid, pos = server_item.base.guid, server_item.base.index
  local lv = BagProxy.Instance:GetItemSiteStrengthLv(guid, pos)
  self.equipInfo:SetEquipStrengthLv(lv)
end

function AdventureItemData:SetStrengthLv(server_item)
  local guid, pos = server_item.base.guid, server_item.base.index
  local lv = BagProxy.Instance:GetItemSiteStrengthLv(guid, pos)
  self.equipInfo:SetEquipStrengthLv(lv)
end

function AdventureItemData:SetCardSlot()
  if self.equipInfo then
    self.cardSlotNum = self.equipInfo:GetCardSlot()
    self.maxCardSlot = self.equipInfo:GetMaxCardSlot()
  end
end

function AdventureItemData:GetMaxCardSlot()
  if self.maxCardSlot then
    return self.maxCardSlot
  end
end

function AdventureItemData:CanEquip()
  return false
end

function AdventureItemData:getAdventureValue()
  return self.AdventureValue
end

function AdventureItemData:GetName()
  local result = ""
  if self.staticData then
    if self.type == SceneManual_pb.EMANUALTYPE_SCENERY then
      result = self.staticData.SpotName
    elseif self.type == SceneManual_pb.EMANUALTYPE_CARD then
      result = ZhString.AdventureHomePage_CardName
    elseif self:IsWeapon() or self:IsShield() then
      local name = self.staticData.NameZh
      local pos = string.find(name, "[[%d]")
      result = pos and string.sub(name, 1, pos - 1) or name
    else
      result = self.staticData.NameZh
    end
  end
  return OverSea.LangManager.Instance():GetLangByKey(result)
end

function AdventureItemData:IsEquip()
  return self.equipInfo ~= nil
end

function AdventureItemData:IsWeapon()
  return self.equipInfo ~= nil and self.equipInfo:IsWeapon()
end

function AdventureItemData:IsShield()
  local equipType = self.equipInfo and self.equipInfo:GetEquipType()
  return (equipType and equipType == EquipTypeEnum.Shield) == true
end

function AdventureItemData:IsTrolley()
  return self.staticData.Type == 91
end

function AdventureItemData:IsFashion()
  if self.staticData and self.staticData.Type then
    return BagProxy.fashionType[self.staticData.Type]
  end
end

function AdventureItemData:IsMount()
  return self.staticData.Type == 90 or self:IsPetMount()
end

function AdventureItemData:IsPetMount()
  return (self.staticData.Type == 101 and self.equipInfo and self.equipInfo:IsMount()) == true
end

function AdventureItemData:IsFurniture()
  return self.furnitureInfo ~= nil
end

function AdventureItemData:IsHomeMaterial()
  return self.homeMaterialInfo ~= nil
end

function AdventureItemData:IsNew()
  return self.isNew or false
end

function AdventureItemData:IsLimitPackageByLv()
  if NewRechargeProxy.Ins:AmIMonthlyVIP() or Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL) >= (GameConfig.AdventureEquipStoreLv or 40) then
    return false
  end
  local equipType = self.equipInfo and self.equipInfo:GetEquipType()
  if not equipType then
    return false
  end
  return equipType == EquipTypeEnum.Weapon or equipType == EquipTypeEnum.Shield
end

function AdventureItemData:Clone()
  local id = self.savedItemDatas[1] and self.savedItemDatas[1].id
  local sId = self.staticData and self.staticData.id or 0
  if id == nil or id == "" then
    id = "Adventure" .. sId
  end
  local item = ItemData.new(id, sId)
  if item.equipInfo then
    item.equipInfo:Clone(self.equipInfo)
  end
  item.isAdv = true
  item.cardLv = self.cardLv
  return item
end

function AdventureItemData:getCompleteNoRewardAppend(tarList)
  local list = tarList or {}
  if self.setAppendDatas then
    for i = 1, #self.setAppendDatas do
      local single = self.setAppendDatas[i]
      if single.finish and not single.rewardget then
        table.insert(list, single)
      end
    end
  end
  if 0 < #list then
    table.sort(list, function(a, b)
      if not a or not b then
        return false
      end
      return a:IsPreAppendOf(b)
    end)
  end
  return list
end

function AdventureItemData:getNoRewardAppend()
  local list = {}
  if self.setAppendDatas then
    for i = 1, #self.setAppendDatas do
      local single = self.setAppendDatas[i]
      if not single.rewardget then
        table.insert(list, single)
      end
    end
  end
  return list
end

function AdventureItemData:getNoRewardKillAppend()
  local list = {}
  if self.setAppendDatas then
    for i = 1, #self.setAppendDatas do
      local single = self.setAppendDatas[i]
      if single:isKill() and not single.rewardget then
        table.insert(list, single)
      end
    end
  end
  return list
end

function AdventureItemData:getAppendDatas()
  return self.setAppendDatas
end

function AdventureItemData:getKillNum()
  local list = self:getNoRewardKillAppend()
  if list and 0 < #list then
    return
  end
  local maxProcess = 0
  local total = 0
  local extend = 0
  if self.setAppendDatas then
    for i = 1, #self.setAppendDatas do
      local single = self.setAppendDatas[i]
      if single:isKill() then
        local process = single.process
        local max = single.staticData.Params and single.staticData.Params[1] or 0
        if process and process ~= 0 and maxProcess < max then
          maxProcess = max
        end
      end
    end
    for i = 1, #self.setAppendDatas do
      local single = self.setAppendDatas[i]
      if single:isKill() then
        local process = single.process
        local max = single.staticData.Params and single.staticData.Params[1] or 0
        if maxProcess > max then
          total = total + max
        elseif max == maxProcess then
          total = total + max
          extend = process - max
        end
      end
    end
  end
  total = total + extend
  return total
end

function AdventureItemData:getCatId()
  return self.CatId
end

function AdventureItemData:setCatId(CatId)
  self.CatId = CatId
end

function AdventureItemData:CheckEquipCanShowInFashion()
  if not self.staticData.Condition then
    return false
  end
  if self:IsWeapon() or self:IsShield() then
    local config = GameConfig.AdventureHideEquips
    if self.status == SceneManual_pb.EMANUALSTATUS_DISPLAY and config and TableUtility.ArrayFindIndex(config, self.staticId) > 0 then
      return false
    end
  end
  return true
end

function AdventureItemData:CheckEquipCanShowInEquipCompose()
  return true
end

function AdventureItemData:GetAttrPercentByQuench()
  return 1
end

function AdventureItemData:IsValid()
  if self.type == SceneManual_pb.EMANUALTYPE_PRESTIGE then
    return FunctionUnLockFunc.Me():CheckCanOpen(self.staticData.MenuID)
  end
  local forbidden = false
  if self.cardInfo and CheckInvalid(self.cardInfo.id) then
    forbidden = true
  elseif self.type == SceneManual_pb.EMANUALTYPE_FURNITURE and CheckInvalid(self.staticId) then
    forbidden = true
  elseif self.type == SceneManual_pb.EMANUALTYPE_EQUIP and CheckInvalid(self.staticId) then
    forbidden = true
  elseif self.type == SceneManual_pb.EMANUALTYPE_COLLECTION and self.collectionGroupId == 50 then
    forbidden = self.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK_STEP or self.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK
  end
  if forbidden then
    return false
  else
    return ItemUtil.CheckDateValid(self.validDateArray)
  end
end

function AdventureItemData:setCollectionGroupId(groupId)
  self.collectionGroupId = groupId
end

function AdventureItemData:getCollectionGroupId()
  return self.collectionGroupId
end

function AdventureItemData:SetQuestId(questId)
  self.questId = questId
end

function AdventureItemData:GetQuestData()
  if self.questId then
    return QuestProxy.Instance:GetQuestDataBySameQuestID(self.questId)
  end
end

function AdventureItemData:CompareTo(item)
  if item then
    return self.battlepoint - item.battlepoint
  end
  return self.battlepoint
end

function AdventureItemData.GetCdTimeOfAnySavedItem(advItemData)
  if type(advItemData) == "table" and type(advItemData.savedItemDatas) == "table" then
    local item = advItemData.savedItemDatas[1]
    if item then
      return ItemUtil.GetCdTime(item)
    end
  end
  return 0
end

function AdventureItemData:SetVID()
  self.equipVID = Table_Equip[self.staticId] and Table_Equip[self.staticId].VID
  self.VIDType = math.floor(self.equipVID / 10000)
  self.VID = self.equipVID % 1000
end

function AdventureItemData:SetCardLevel()
  local itemData = self.savedItemDatas[1]
  self.cardLv = itemData and itemData.cardLv or 0
end

function AdventureItemData:GetCardQuality()
  if self.cardLv and self.cardLv >= 5 then
    return 5
  end
  return self.staticData.Quality
end

function AdventureItemData:GetCardAttrs(iconPrefix)
  local itemData = self.savedItemDatas[1]
  if itemData then
    return itemData:GetCardAttrs(iconPrefix)
  end
end
