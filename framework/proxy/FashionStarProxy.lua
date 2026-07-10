FashionStarProxy = class("FashionStarProxy", pm.Proxy)
FashionStarProxy.Instance = nil
FashionStarProxy.NAME = "FashionStarProxy"
FashionStarProxy.EGiftState = {
  Init = 0,
  Active = 1,
  Reward = 2,
  Expire = 3
}

function FashionStarProxy:ctor(proxyName, data)
  self.proxyName = proxyName or FashionStarProxy.NAME
  if FashionStarProxy.Instance == nil then
    FashionStarProxy.Instance = self
    self:Init()
  end
  if data ~= nil then
    self:setData(data)
  end
end

function FashionStarProxy:Init()
  self.staticData = {}
  self.currentBatchId = nil
  self.currentConfigIds = {}
  self.defaultHeadId = nil
  self.currentConfigId = nil
  self.serverFashionStarMap = {}
  self.serverGiftInfoMap = {}
  self.equipBatchMap = {}
end

function FashionStarProxy:ProcessTable()
  if self.staticDataInitialized then
    return
  end
  local batchid, fashionId
  for k, v in pairs(Table_FashionStar) do
    batchid = v.BatchId
    local configs = self.staticData[batchid]
    configs = configs or {}
    configs[#configs + 1] = v.id
    self.staticData[batchid] = configs
    fashionId = v.Param and v.Param.FashionId
    if fashionId and next(fashionId) then
      for _, equipId in pairs(fashionId) do
        self.equipBatchMap[equipId] = batchid
      end
    end
  end
  for batchid, ids in pairs(self.staticData) do
    table.sort(ids)
  end
  self.staticDataInitialized = true
end

function FashionStarProxy:GetConfigByBatchId(batchid)
  self:ProcessTable()
  local ids = self.staticData and self.staticData[batchid]
  return ids
end

function FashionStarProxy:DoQuery()
  self.showMaxStarFashionFlag = true
  ServiceItemProxy.Instance:CallFashionStarQueryItemCmd()
end

function FashionStarProxy:GetFashionStarBatchByEquip(equip_id)
  if not equip_id then
    return nil
  end
  self:ProcessTable()
  return self.equipBatchMap[equip_id]
end

function FashionStarProxy:HandleQueryFashionStar(server_infos)
  if not server_infos then
    return
  end
  local maxStarBatchId, maxStar = 1, -1
  for i = 1, #server_infos do
    local server_info = server_infos[i]
    local batchid, star = server_info.batchid, server_info.star
    self.serverFashionStarMap[batchid] = star
    self.serverGiftInfoMap[batchid] = self:ParseGiftInfos(server_info.infos)
    if maxStar < star then
      maxStarBatchId = batchid
      maxStar = star
    end
  end
  self:TryOpenMaxStarFashion(maxStarBatchId)
end

function FashionStarProxy:TryOpenMaxStarFashion(maxStarBatchId)
  if not self.showMaxStarFashionFlag then
    return
  end
  self.showMaxStarFashionFlag = false
  if maxStarBatchId and 0 < maxStarBatchId then
    FunctionNpcFunc.JumpPanel(PanelConfig.FashionStarView, {
      viewdata = {batchid = maxStarBatchId}
    })
  end
end

function FashionStarProxy:GetUnlockedStar(batchid)
  return self.serverFashionStarMap[batchid]
end

function FashionStarProxy:CheckCurrentStarCanUpgrade(batchid, star)
  if not batchid or not star then
    return false
  end
  local unlockedStar = self:GetUnlockedStar(batchid)
  if not unlockedStar or unlockedStar == 0 then
    return star == 1
  else
    return unlockedStar == star - 1
  end
end

function FashionStarProxy:IsUnlocked(static_id)
  local staticData = Table_FashionStar[static_id]
  if not staticData then
    return false
  end
  local unlockedStar = self:GetUnlockedStar(staticData.BatchId)
  if not unlockedStar or unlockedStar == 0 then
    return false
  end
  return unlockedStar >= staticData.Star
end

function FashionStarProxy:SetCurrentConfigId(config_id)
  self.currentConfigId = config_id
end

function FashionStarProxy:SetCurrentBatchId(batchid)
  self.currentBatchId = batchid
  local gender = Game.Myself.data.userdata:Get(UDEnum.SEX)
  self.currentConfigIds = self:GetConfigByBatchId(batchid)
  if not self.currentConfigIds or not next(self.currentConfigIds) then
    return
  end
  self.initialConfigId = self.currentConfigIds[1]
  self.initialStaticData = Table_FashionStar[self.initialConfigId]
  if not self.initialStaticData then
    return
  end
  local initialParam = self.initialStaticData.Param
  if not initialParam then
    return
  end
  local initialDepositId = self.initialStaticData.Deposit
  if initialDepositId and 0 < initialDepositId then
    local depositItemId = Table_Deposit[initialDepositId].ItemId
    self.initialDepositItemData = ItemData.new(MaterialItemCell.MaterialType.Material, depositItemId)
  end
  local ClientItemId = initialParam.ClientItemId
  if ClientItemId and 0 < ClientItemId then
    self.initialItemData = ItemData.new(MaterialItemCell.MaterialType.Material, ClientItemId)
  end
  self.defaultFashionId = initialParam.FashionId and initialParam.FashionId[gender]
  if self.defaultFashionId and 0 < self.defaultFashionId then
    self.initialFashionItemData = ItemData.new(MaterialItemCell.MaterialType.Material, self.defaultFashionId)
  end
  self.defaultHeadId = initialParam.HeadEquipId and initialParam.HeadEquipId[gender]
  self.maxStarConfigId = self.currentConfigIds[#self.currentConfigIds]
  self.maxStarStaticData = Table_FashionStar[self.maxStarConfigId]
  if self.maxStarStaticData then
    self.maxStarFashionId = self.maxStarStaticData.Param and self.maxStarStaticData.Param.FashionId[gender]
    self.maxStarFashionItemData = ItemData.new(MaterialItemCell.MaterialType.Material, self.maxStarFashionId)
  end
end

function FashionStarProxy:GetMaxStarConfigId()
  return self.maxStarConfigId
end

function FashionStarProxy:GetMaxStarFashionItemData()
  return self.maxStarFashionItemData
end

function FashionStarProxy:GetInitialItemData()
  return self.initialItemData
end

function FashionStarProxy:GetInitialDepositItemData()
  return self.initialDepositItemData
end

function FashionStarProxy:GetInitialFashionItemData()
  return self.initialFashionItemData
end

function FashionStarProxy:GetDefaultFashionId()
  return self.defaultFashionId
end

function FashionStarProxy:GetDefaultHeadId()
  return self.defaultHeadId
end

function FashionStarProxy:GetCurrentConfigIds()
  return self.currentConfigIds
end

function FashionStarProxy:GetCurrentConfigId()
  return self.currentConfigId
end

function FashionStarProxy:Clear()
  self.currentConfigId = nil
  TableUtility.TableClear(self.serverFashionStarMap)
  TableUtility.TableClear(self.serverGiftInfoMap)
end

function FashionStarProxy:CanUpgradeStar(target_star)
  local config_id = self:GetCurrentConfigId()
  local staticData = Table_FashionStar[config_id]
  if not staticData then
    return false
  end
  if not self:CheckCurrentStarCanUpgrade(staticData.BatchId, target_star) then
    return false
  end
  local costs = staticData.ItemCost
  if not costs or not next(costs) then
    return false
  end
  local bagProxy = BagProxy.Instance
  for i = 1, #costs do
    local itemId = costs[i][1]
    local needCount = costs[i][2]
    local haveCount = bagProxy:GetItemNumByStaticID(itemId, GameConfig.PackageMaterialCheck.fashion_star)
    if needCount > haveCount then
      return false, 8
    end
  end
  return true
end

function FashionStarProxy:GetExtraDepositIds(config_id)
  local staticData = Table_FashionStar[config_id]
  if not staticData then
    return nil
  end
  local depositConfig = GameConfig.FashionStar and GameConfig.FashionStar.Deposit
  if not depositConfig then
    return nil
  end
  local batchid = staticData.BatchId
  local currentDepositId = staticData.Deposit
  local extraDeposits = {}
  local giftTimeLimitMap = depositConfig.GiftTimeLimit and depositConfig.GiftTimeLimit[batchid]
  if giftTimeLimitMap and 0 < #giftTimeLimitMap then
    local activeGiftInfos = self:GetActiveGiftInfos(batchid)
    if activeGiftInfos and next(activeGiftInfos) then
      local validGiftConfigMap = {}
      for i = 1, #giftTimeLimitMap do
        validGiftConfigMap[giftTimeLimitMap[i]] = true
      end
      for i = 1, #activeGiftInfos do
        local info = activeGiftInfos[i]
        local giftConfig = info and Table_GiftTimeLimit and Table_GiftTimeLimit[info.configId]
        local depositId = giftConfig and giftConfig.DepositId
        if info and validGiftConfigMap[info.configId] and depositId and 0 < depositId then
          self:_PushUniqueDepositId(extraDeposits, depositId)
        end
      end
    end
  end
  local giftBaseMap = depositConfig.GiftBase and depositConfig.GiftBase[batchid]
  local baseDepositIds = giftBaseMap and giftBaseMap[currentDepositId]
  if baseDepositIds and 0 < #baseDepositIds then
    for i = 1, #baseDepositIds do
      self:_PushUniqueDepositId(extraDeposits, baseDepositIds[i])
    end
  end
  if next(extraDeposits) then
    return extraDeposits
  end
  return nil
end

function FashionStarProxy:_PushUniqueDepositId(result, depositId)
  if not (result and depositId) or depositId <= 0 then
    return
  end
  for i = 1, #result do
    if result[i] == depositId then
      return
    end
  end
  result[#result + 1] = depositId
end

function FashionStarProxy:GetGiftConfigIdByDepositId(depositId)
  if not depositId or not Table_GiftTimeLimit then
    return nil
  end
  if Table_GiftTimeLimit[depositId] then
    return depositId
  end
  for id, config in pairs(Table_GiftTimeLimit) do
    if config.Type == 7 and config.DepositId == depositId then
      return id
    end
    if config.Type == 5 and config.SubType and config.SubType[1] == depositId then
      return id
    end
  end
  return nil
end

function FashionStarProxy:GetBatchGiftInfos(batchid)
  return self.serverGiftInfoMap and self.serverGiftInfoMap[batchid]
end

function FashionStarProxy:ParseGiftInfos(infos)
  if not infos or #infos == 0 then
    return nil
  end
  local parsedInfos = {}
  for i = 1, #infos do
    local info = infos[i]
    if info and info.id and 0 < info.id then
      local configId = info.id
      parsedInfos[#parsedInfos + 1] = {
        id = configId,
        time = info.time or 0,
        endTime = self:GetGiftEndTime(configId, info.time),
        state = info.state or FashionStarProxy.EGiftState.Init,
        configId = configId
      }
    end
  end
  if next(parsedInfos) then
    return parsedInfos
  end
  return nil
end

function FashionStarProxy:GetActiveGiftInfos(batchid)
  local giftInfos = self:GetBatchGiftInfos(batchid)
  if not giftInfos or #giftInfos == 0 then
    return nil
  end
  local activeInfos = {}
  local currentTime = math.floor((ServerTime.CurServerTime() or 0) / 1000)
  for i = 1, #giftInfos do
    local info = giftInfos[i]
    if self:IsGiftInfoValid(info, currentTime) then
      activeInfos[#activeInfos + 1] = info
    end
  end
  if next(activeInfos) then
    return activeInfos
  end
  return nil
end

function FashionStarProxy:IsGiftInfoValid(info, currentTime)
  if not (info and info.id) or info.id <= 0 then
    return false
  end
  local state = info.state
  if state == FashionStarProxy.EGiftState.Reward or state == FashionStarProxy.EGiftState.Expire then
    return false
  end
  if info.endTime and 0 < info.endTime and currentTime >= info.endTime then
    return false
  end
  return true
end

function FashionStarProxy:GetGiftEndTime(configId, unlockTime)
  if not (configId and unlockTime) or unlockTime <= 0 then
    return 0
  end
  local giftConfig = Table_GiftTimeLimit and Table_GiftTimeLimit[configId]
  local liveTime = giftConfig and giftConfig.LiveTime or 0
  if liveTime <= 0 then
    return unlockTime
  end
  return unlockTime + liveTime
end

function FashionStarProxy:GetGiftInfoByDepositId(batchid, depositId)
  if not batchid or not depositId then
    return nil
  end
  local giftInfos = self:GetBatchGiftInfos(batchid)
  if not giftInfos or #giftInfos == 0 then
    return nil
  end
  for i = 1, #giftInfos do
    local info = giftInfos[i]
    local giftConfig = info and Table_GiftTimeLimit and Table_GiftTimeLimit[info.configId]
    if giftConfig and giftConfig.DepositId == depositId then
      return info
    end
  end
  return nil
end

function FashionStarProxy:GetDepositEndTime(batchid, depositId)
  local info = self:GetGiftInfoByDepositId(batchid, depositId)
  return info and info.endTime or nil
end
