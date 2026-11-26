autoImport("ExchangeShopItemData")
autoImport("ExchangeItemData")
ExchangeShopProxy = class("ExchangeShopProxy", pm.Proxy)
ExchangeShopProxy.Instance = nil
ExchangeShopProxy.NAME = "ExchangeShopProxy"
ExchangeShopProxy.GoodsTYPE = {
  OK = SessionShop_pb.EEXCHANGESTATUSTYPE_OK,
  EMPTY = SessionShop_pb.EEXCHANGESTATUSTYPE_EMPTY
}
local SortType, exchangeType = 3, 4
ExchangeShopProxy.EnchangeType = {
  COINS = 1,
  FRESS = 2,
  PROGRESS = 3,
  NO_PROGRESS = 4,
  Limited_PROGRESS = 5,
  MEDAL_PROGRESS = 6
}

function ExchangeShopProxy:Test()
  local data = {
    items = {
      {
        id = 6,
        status = 2,
        progress = 1,
        exchange_count = 0
      },
      {
        id = 1,
        status = 2,
        progress = 1,
        exchange_count = 0
      },
      {
        id = 7,
        status = 2,
        progress = 1,
        exchange_count = 0
      },
      {
        id = 8,
        status = 2,
        progress = 1,
        exchange_count = 0
      },
      {
        id = 9,
        status = 2,
        progress = 1,
        exchange_count = 0
      },
      {
        id = 10,
        status = 2,
        progress = 1,
        exchange_count = 0
      },
      {
        id = 2,
        status = 2,
        progress = 0,
        exchange_count = 0,
        left_time = 31214
      },
      {
        id = 3,
        status = 2,
        progress = 1,
        exchange_count = 20,
        left_time = 4352332
      },
      {
        id = 4,
        status = 2,
        progress = 1,
        exchange_count = 10,
        left_time = 232
      },
      {
        id = 5,
        status = 2,
        progress = 0,
        exchange_count = 0,
        left_time = 32145
      }
    },
    del_items = {},
    menu_open = true
  }
  self:UpdateExchange(data)
end

local _ArrayPushBack = TableUtility.ArrayPushBack
local _ClearArray = TableUtility.ArrayClear

function ExchangeShopProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ExchangeShopProxy.NAME
  if ExchangeShopProxy.Instance == nil then
    ExchangeShopProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function ExchangeShopProxy:GetShopGoodsWorth(shopid, itemid)
  local worthMap = self.shopGoodsWorthMap[shopid]
  if not worthMap then
    return nil
  end
  return worthMap[itemid]
end

function ExchangeShopProxy:IsFreyShop(shopid)
  return self.freyShopMap and self.freyShopMap[shopid] == true
end

function ExchangeShopProxy:GetFreyConfig(shopid, itemid)
  local configMap = self.freyConfigMap and self.freyConfigMap[shopid]
  return configMap and configMap[itemid]
end

local ARRAY_FIND_INDEX = TableUtility.ArrayFindIndex

function ExchangeShopProxy:IsFreyExchangeShielded(config)
  local shieldAreas = config and config.ExcludingArea
  if type(shieldAreas) ~= "table" then
    return false
  end
  local loopActProxy = LoopActIntegrationProxy and LoopActIntegrationProxy.Instance
  if not loopActProxy then
    return false
  end
  local branchName = loopActProxy:GetAreaAndServerName()
  local shieldAreaCfg = shieldAreas[branchName]
  if shieldAreaCfg == nil then
    return 0 < ARRAY_FIND_INDEX(shieldAreas, branchName)
  end
  local shielded = shieldAreaCfg ~= false
  return shielded
end

function ExchangeShopProxy:IsFreyExchangeShop(shopid)
  self:InitStaticData()
  return self:IsFreyShop(shopid)
end

function ExchangeShopProxy:InitStaticData()
  if self.init then
    return
  end
  local serverFlag = MyselfProxy.Instance:GetServerId()
  if Table_FreyExchange then
    for _, freyCfg in pairs(Table_FreyExchange) do
      local shopid = freyCfg.ShopID
      local itemid = freyCfg.CostItemID
      if shopid and itemid and not self:IsFreyExchangeShielded(freyCfg) and ItemUtil.CheckDateValidByItemId(itemid) then
        if not self.freyConfigMap[shopid] then
          self.freyConfigMap[shopid] = {}
        end
        self.freyConfigMap[shopid][itemid] = freyCfg
        if not self.shopGoodsWorthMap[shopid] then
          self.shopGoodsWorthMap[shopid] = {}
        end
        self.shopGoodsWorthMap[shopid][itemid] = {
          freyCfg.ReceiveItemID,
          freyCfg.ReceiveItemNum,
          freyCfg.RefineRecovery
        }
        if nil == self.goodsMap[shopid] then
          self.goodsMap[shopid] = {}
        end
        local config = {ItemID = itemid}
        local itemData = ExchangeItemData.new(config)
        _ArrayPushBack(self.goodsMap[shopid], itemData)
        self.freyShopMap[shopid] = true
      end
    end
  end
  if Table_ExchangeWorth then
    for k, v in pairs(Table_ExchangeWorth) do
      if (v.ServerID == _EmptyTable or 0 ~= ARRAY_FIND_INDEX(v.ServerID, serverFlag)) and ItemUtil.CheckDateValidByItemId(v.ItemID) then
        if not self.shopGoodsWorthMap[v.GoodsID] then
          self.shopGoodsWorthMap[v.GoodsID] = {}
        end
        self.shopGoodsWorthMap[v.GoodsID][v.ItemID] = v.Worth
        if not v.GoodsID then
          return
        end
        for i = 1, #v.GoodsID do
          local goodID = v.GoodsID[i]
          if nil == self.goodsMap[goodID] then
            self.goodsMap[goodID] = {}
          end
          local itemData = ExchangeItemData.new(v)
          _ArrayPushBack(self.goodsMap[goodID], itemData)
        end
      end
    end
  end
  self.init = true
end

function ExchangeShopProxy:Init()
  self.shopDataMap = {}
  self.dataArray = {}
  self.chooseMap = {}
  self.chooseCount = 0
  self.goodsMap = {}
  self.shopGoodsWorthMap = {}
  self.freyShopMap = {}
  self.freyConfigMap = {}
  self.freyChooseMap = {}
end

function ExchangeShopProxy:UpdateExchange(server_data)
  self.shopDataChanged = true
  for i = 1, #server_data.items do
    self.shopDataMap[server_data.items[i].id] = ExchangeShopItemData.new(server_data.items[i])
  end
  for i = 1, #server_data.del_items do
    self.shopDataMap[server_data.del_items[i]] = nil
  end
end

function ExchangeShopProxy:CanOpen()
  for k, v in pairs(self.shopDataMap) do
    if v.staticData and v.staticData.Source == 1 and v.status ~= ExchangeShopProxy.GoodsTYPE.EMPTY then
      return true
    end
  end
  return false
end

function ExchangeShopProxy:HandleResetData(server_data)
  self.shopDataChanged = true
  self:ClearData()
  for i = 1, #server_data.items do
    self.shopDataMap[server_data.items[i].id] = ExchangeShopItemData.new(server_data.items[i])
  end
end

function ExchangeShopProxy:ClearData()
  TableUtility.TableClear(self.shopDataMap)
  self.init = false
  TableUtility.TableClear(self.goodsMap)
  TableUtility.TableClear(self.shopGoodsWorthMap)
  TableUtility.TableClear(self.freyShopMap)
  TableUtility.TableClear(self.freyConfigMap)
  self.shopDataChanged = true
  self:ResetChoose()
end

function ExchangeShopProxy:GetRewardByGoods(id)
  if self:IsFreyShop(id) then
    local configMap = self.freyConfigMap[id]
    for _, config in pairs(configMap or _EmptyTable) do
      return config.ReceiveItemID
    end
    return nil
  end
  local array = self.goodsMap[id]
  if not array or 0 == #array or not array[1].config then
    return nil
  end
  return array[1].config.Worth[1]
end

function ExchangeShopProxy:GetFreyGoods(shopid)
  self:InitStaticData()
  local resultByGuid = {}
  local result = {}
  local configMap = self.freyConfigMap[shopid]
  if not configMap then
    return result
  end
  local packageTypes = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.exchange_shop or _EmptyTable
  for itemid, _ in pairs(configMap) do
    for i = 1, #packageTypes do
      local items = BagProxy.Instance:GetItemsByStaticID(itemid, packageTypes[i])
      for j = 1, #(items or _EmptyTable) do
        local item = items[j]
        if item and not resultByGuid[item.id] and not BagProxy.Instance:CheckIsFavorite(item) then
          item.freyExchange = true
          resultByGuid[item.id] = item
        end
      end
    end
  end
  for _, item in pairs(resultByGuid) do
    _ArrayPushBack(result, item)
  end
  return result
end

function ExchangeShopProxy:ResetChoose()
  TableUtility.TableClear(self.chooseMap)
  TableUtility.TableClear(self.freyChooseMap)
  self.chooseCount = 0
end

function ExchangeShopProxy:AddChooseItems(id, isnormal)
  if not isnormal and type(id) == "table" and id.id and id.staticData then
    local guid = id.id
    if not (not id.freyPlaceholder and guid) or guid == "exchange" or BagProxy.Instance:CheckIsFavorite(id) then
      return
    end
    local current = self.freyChooseMap[guid] or 0
    local maxCount = id.num or 1
    if current < maxCount then
      self.freyChooseMap[guid] = current + 1
      self.chooseCount = self.chooseCount + 1
    end
    return
  end
  if self.chooseMap[id] then
    if isnormal then
      if self.chooseMap[id] < ExchangeShopProxy.GetOwnCount(id) then
        self.chooseMap[id] = self.chooseMap[id] + 1
        self.chooseCount = self.chooseCount + 1
      else
        MsgManager.ShowMsgByID(3554, Table_Item[id].NameZh)
        return
      end
    else
      self.chooseMap[id] = self.chooseMap[id] + 1
      self.chooseCount = self.chooseCount + 1
    end
  else
    self.chooseMap[id] = 1
    self.chooseCount = self.chooseCount + 1
  end
end

function ExchangeShopProxy:MinusChooseItem(id)
  if type(id) == "table" and id.id and id.staticData then
    local guid = id.id
    local current = self.freyChooseMap[guid]
    if not current then
      return
    end
    if 1 < current then
      self.freyChooseMap[guid] = current - 1
    else
      self.freyChooseMap[guid] = nil
    end
    self.chooseCount = self.chooseCount - 1
    return
  end
  if not self.chooseMap[id] then
    return
  end
  if 1 < self.chooseMap[id] then
    self.chooseMap[id] = self.chooseMap[id] - 1
  else
    self.chooseMap[id] = nil
  end
  self.chooseCount = self.chooseCount - 1
end

function ExchangeShopProxy:GetSelectedCount(itemData)
  if not itemData then
    return 0
  end
  if itemData.id and self.freyChooseMap[itemData.id] then
    return self.freyChooseMap[itemData.id]
  end
  local staticId = itemData.staticData and itemData.staticData.id or itemData
  return self.chooseMap[staticId] or 0
end

function ExchangeShopProxy:_getChooseItem(isFrey)
  local chooseItem = {}
  if isFrey then
    for guid, num in pairs(self.freyChooseMap) do
      local itemData = BagProxy.Instance:GetItemByGuid(guid, GameConfig.PackageMaterialCheck.exchange_shop)
      if itemData and itemData.staticData and not BagProxy.Instance:CheckIsFavorite(itemData) then
        local item = SessionShop_pb.FreyExchangeItemInfo()
        item.id = itemData.staticData.id
        item.num = num
        item.guid = guid
        _ArrayPushBack(chooseItem, item)
      end
    end
    return chooseItem
  end
  for k, v in pairs(self.chooseMap) do
    local item = SessionShop_pb.ExchangeItemInfo()
    item.id = k
    item.num = v
    _ArrayPushBack(chooseItem, item)
  end
  return chooseItem
end

function ExchangeShopProxy:GetExchangeShopData()
  if #self.dataArray <= 0 or self.shopDataChanged then
    _ClearArray(self.dataArray)
    for _, v in pairs(self.shopDataMap) do
      if v:IsExchangeShop() then
        _ArrayPushBack(self.dataArray, v)
      end
    end
    table.sort(self.dataArray, function(l, r)
      return self:SortFunc(l, r)
    end)
    self.shopDataChanged = false
  end
  return self.dataArray
end

function ExchangeShopProxy:SortFunc(a, b)
  if a == nil or b == nil then
    return false
  end
  local aGift = a.isGift
  local bGift = b.isGift
  local aGoodID = a.goodsId
  local bGoodID = b.goodsId
  local aSpecialType = a.staticData.Type == SortType
  local bSpecialType = b.staticData.Type == SortType
  if a.status ~= b.status then
    return a.status < b.status
  else
    if aGift and bGift then
      return aGoodID < bGoodID
    end
    if aGift or bGift then
      return aGift == true
    end
    if a.staticData.Type == exchangeType and b.staticData.Type == exchangeType then
      return aGoodID < bGoodID
    end
    if a.staticData.Type == exchangeType or b.staticData.Type == exchangeType then
      return a.staticData.Type == exchangeType
    end
    if aSpecialType and bSpecialType then
      return aGoodID > bGoodID
    end
    if aSpecialType or bSpecialType then
      return aSpecialType
    end
    if aSpecialType == false and bSpecialType == false then
      return aGoodID < bGoodID
    end
  end
end

function ExchangeShopProxy.GetOwnCount(itemid)
  local package = GameConfig.PackageMaterialCheck.exchange_shop
  local count = 0
  for i = 1, #package do
    count = count + BagProxy.Instance:GetItemNumByStaticID(itemid, package[i])
  end
  return count
end

function ExchangeShopProxy:GetChooseCount()
  return self.chooseCount
end

function ExchangeShopProxy:GetChooseNum(shopid)
  if self:IsFreyShop(shopid) then
    local rewardCount = 0
    for guid, num in pairs(self.freyChooseMap) do
      local itemData = BagProxy.Instance:GetItemByGuid(guid, GameConfig.PackageMaterialCheck.exchange_shop)
      local config = itemData and self:GetFreyConfig(shopid, itemData.staticData and itemData.staticData.id)
      if itemData and config and not BagProxy.Instance:CheckIsFavorite(itemData) then
        rewardCount = rewardCount + (config.ReceiveItemNum or 0) * num
        local refineLv = itemData.equipInfo and itemData.equipInfo.refinelv or 0
        if config.RefineRecovery and 0 < refineLv and CommonFun and CommonFun.calcFreyExchangeRefineRecovery then
          rewardCount = rewardCount + CommonFun.calcFreyExchangeRefineRecovery(refineLv) * num
        end
      end
    end
    return rewardCount
  end
  local worthMap = self.shopGoodsWorthMap[shopid]
  if not worthMap then
    return 0
  end
  local chooseCount, rewardCount, extraCount = 0, 0, 0
  local worth_config
  for reward_item_id, reward_num in pairs(self.chooseMap) do
    chooseCount = chooseCount + reward_num
    worth_config = worthMap[reward_item_id]
    if worth_config and worth_config[1] then
      rewardCount = rewardCount + worth_config[2] * reward_num
    end
  end
  return rewardCount
end

function ExchangeShopProxy:HasChosenFreyRefineOrCard()
  local package = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.exchange_shop
  for guid, _ in pairs(self.freyChooseMap) do
    local itemData = BagProxy.Instance:GetItemByGuid(guid, package)
    if itemData and not BagProxy.Instance:CheckIsFavorite(itemData) then
      local refineLv = itemData.equipInfo and itemData.equipInfo.refinelv or 0
      if 0 < refineLv or itemData:HasEquipedCard() then
        return true
      end
    end
  end
  return false
end

function ExchangeShopProxy:CallExchange(id)
  if self:IsFreyExchangeShop(id) then
    local chooseItem = self:_getChooseItem(true)
    if 0 < #chooseItem then
      ServiceSessionShopProxy.Instance:CallFreyExchangeShopCmd(id, chooseItem)
    end
    return
  end
  if nil == Table_ExchangeShop[id] then
    ServiceSessionShopProxy.Instance:CallFreyExchangeShopCmd(id, self:_getChooseItem(true))
    return
  end
  local eType = Table_ExchangeShop[id] and Table_ExchangeShop[id].ExchangeType
  local chooseItem = eType and eType ~= 1 and self:_getChooseItem() or nil
  ServiceSessionShopProxy.Instance:CallExchangeShopItemCmd(id, chooseItem)
end

function ExchangeShopProxy:GetShopDataByExchangeId(id)
  return self.shopDataMap[id]
end
