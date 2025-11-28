NewRechargeTHotData = class("NewRechargeTHotData")
local _Table_ShopShow, _NewRechargeProxy
local _ViewTab = 4

function NewRechargeTHotData:ctor()
  self.shopItemList = {}
  self.cacheSortMap = {}
  _Table_ShopShow = Table_ShopShow
  _NewRechargeProxy = NewRechargeProxy.Ins
  NewRechargeTHotData.GeneratePreBuyInfo()
end

local infoMap = {}

function NewRechargeTHotData:GetShopItemList(sort)
  TableUtility.ArrayClear(self.shopItemList)
  local inner = GameConfig.NewRecharge.Tabs[_ViewTab].Inner
  local config
  for _, v in pairs(inner) do
    if v.ID == sort then
      config = v
      break
    end
  end
  if not _Table_ShopShow then
    autoImport(Table_ShopShow)
    _Table_ShopShow = Table_ShopShow
  end
  for k, v in pairs(_Table_ShopShow) do
    if config and config.Params and config.Params.ShopShowType ~= nil and v.Sort == config.Params.ShopShowType then
      if v.Type == 2 and self.IsDepositItem(v.ShopID) and self.IsDepositItemCanShow(v.ShopID) then
        v.confType = 1
        local info = _NewRechargeProxy:GenerateDepositGoodsInfo(v.ShopID)
        local pre_post_check = true
        if self.IsDepositItem_PreBuy(v.ShopID) then
          pre_post_check = not info:IsSoldOut()
        elseif self.IsDepositItem_PostBuy(v.ShopID) then
          local preId = self.depositPreBuyInfoRev[v.ShopID]
          local pre_info = _NewRechargeProxy:GenerateDepositGoodsInfo(preId)
          pre_post_check = not pre_info or pre_info:IsSoldOut()
        end
        if pre_post_check then
          table.insert(self.shopItemList, v)
          infoMap[v.id] = info
        end
      elseif v.Type == 1 and self.IsShopItem(v.ShopID) and self.IsShopItemCanShow(v.ShopID) then
        v.confType = 2
        table.insert(self.shopItemList, v)
        infoMap[v.id] = _NewRechargeProxy:GenerateShopGoodsInfo(v.ShopID)
      end
    end
  end
  if NewRechargeProxy.Instance.useLastSort then
    table.sort(self.shopItemList, function(x, y)
      if x and y then
        local x_sortid = self.cacheSortMap[x.id]
        local y_sortid = self.cacheSortMap[y.id]
        if x_sortid and y_sortid then
          return x_sortid < y_sortid
        end
        return false
      else
        return false
      end
    end)
  else
    table.sort(self.shopItemList, function(x, y)
      if x.confType == 2 and y.confType == 2 then
        local count_x = infoMap[x.id]:GetLimitCanBuyCount()
        local count_y = infoMap[y.id]:GetLimitCanBuyCount()
        local isSoldOut_x = count_x and count_x <= 0 or false
        local isSoldOut_y = count_y and count_y <= 0 or false
        if isSoldOut_x == isSoldOut_y then
          return x.Order < y.Order
        end
        return not isSoldOut_x
      elseif x.confType == 1 and y.confType == 1 then
        local xSoldOut = infoMap[x.id]:IsSoldOut() and 0 or 1
        local ySoldOut = infoMap[y.id]:IsSoldOut() and 0 or 1
        if xSoldOut ~= ySoldOut then
          return xSoldOut > ySoldOut
        end
        local x_purchaseState = infoMap[x.id].purchaseState or 1
        local y_purchaseState = infoMap[y.id].purchaseState or 1
        if x_purchaseState ~= y_purchaseState then
          return x_purchaseState > y_purchaseState
        else
          if x_purchaseState == 0 then
            local xBatchIsBatch = infoMap[x.id].batch_is_Batch and 1 or 0
            local yBatchIsBatch = infoMap[y.id].batch_is_Batch and 1 or 0
            return xBatchIsBatch > yBatchIsBatch
          end
          return x.Order < y.Order
        end
      end
      if x and y then
        return x.Order < y.Order
      end
      return false
    end)
    for i = 1, #self.shopItemList do
      self.cacheSortMap[self.shopItemList[i].id] = i
    end
  end
  TableUtility.TableClear(infoMap)
  do return self.shopItemList end
  if config.Params.ShopShowType ~= nil and config.Params.ShopShowType == 7 then
    self:Append_BattlePassUpgradeDeposit(self.shopItemList)
    self:Append_NoviceBattlePassUpgradeDeposit(self.shopItemList)
    self:Append_ReturnBattlePassUpgradeDeposit(self.shopItemList)
  end
  return self.shopItemList
end

function NewRechargeTHotData.IsDepositItem(depositItemId)
  return Table_Deposit and Table_Deposit[depositItemId] ~= nil or false
end

function NewRechargeTHotData.IsShopItem(shopItemId)
  return true
end

function NewRechargeTHotData.IsDepositItemCanShow(depositItemId)
  local cfg = Table_Deposit[depositItemId]
  if not cfg then
    return false
  end
  if cfg.ServerID and cfg.ServerID ~= _EmptyTable then
    local server = FunctionLogin.Me():getCurServerData()
    local serverID = server ~= nil and server.linegroup or 0
    if 0 >= TableUtility.ArrayFindIndex(cfg.ServerID, serverID) then
      return false
    end
  end
  return ShopProxy.Instance:IsThisItemCanBuyNow(depositItemId)
end

function NewRechargeTHotData.IsShopItemCanShow(shopItemId)
  local shopItem = NewRechargeProxy.Instance:GetShopItemData(shopItemId)
  if shopItem then
    if shopItem:IsCycleGift() then
      local canBuyCount = HappyShopProxy.Instance:GetCanBuyCount(shopItem) or 0
      if shopItem:HasPreUnlockId() then
        local preCanBuyCount = 0
        local preShopItem = NewRechargeProxy.Instance:GetShopItemData(shopItem.unlockpreid or 0)
        if preShopItem then
          preCanBuyCount = HappyShopProxy.Instance:GetCanBuyCount(preShopItem)
        end
        return preCanBuyCount <= 0
      elseif shopItem:HasNextUnlockId() then
        return 0 < canBuyCount
      else
        return true
      end
    else
      return true
    end
  end
  return false
end

function NewRechargeTHotData:Append_BattlePassUpgradeDeposit(shopItemList)
  for _, v in pairs(Table_Deposit) do
    if BattlePassProxy.Instance:IsBattlePassUpgradeItem(v.id) and not BattlePassProxy.Instance:CheckBattlePassUpgradeDepositForbidShow(v.id) and ShopProxy.Instance:IsThisItemCanBuyNow(v.id) then
      table.insert(shopItemList, {
        ShopID = v.id,
        confType = 1,
        Sort = 1
      })
    end
  end
end

function NewRechargeTHotData:Append_NoviceBattlePassUpgradeDeposit(shopItemList)
  local depositId = GameConfig.NoviceBattlePass and GameConfig.NoviceBattlePass.DepositId
  local depositData = Table_Deposit[depositId]
  if depositData and NoviceBattlePassProxy.Instance:IsUpgradeCanShow() and ShopProxy.Instance:IsThisItemCanBuyNow(depositId) then
    table.insert(shopItemList, {
      ShopID = depositId,
      confType = 1,
      Sort = 1
    })
  end
end

function NewRechargeTHotData:Append_ReturnBattlePassUpgradeDeposit(shopItemList)
  local depositId = NoviceBattlePassProxy.Instance.returnDepositID
  if depositId and Table_Deposit[depositId] and NoviceBattlePassProxy.Instance:IsReturnUpgradeCanShow() and ShopProxy.Instance:IsThisItemCanBuyNow(depositId) then
    table.insert(shopItemList, {
      ShopID = depositId,
      confType = 1,
      Sort = 1
    })
  end
end

function NewRechargeTHotData.GeneratePreBuyInfo()
  if not NewRechargeTHotData.depositPreBuyInfo then
    NewRechargeTHotData.depositPreBuyInfo = {}
    NewRechargeTHotData.depositPreBuyInfoRev = {}
  else
    return
  end
  for k, v in pairs(Table_Deposit) do
    if v.PreBuyID and string.find(string.lower(v.ProductID), "battlepass") == nil and string.find(string.lower(v.DbColumn), "battlepass") == nil and string.find(string.lower(v.Picture), "battlepass") == nil then
      local preInfo = Table_Deposit[v.PreBuyID]
      if preInfo and NewRechargeTHotData.depositPreBuyInfo[v.PreBuyID] == nil then
        NewRechargeTHotData.depositPreBuyInfo[v.PreBuyID] = k
        NewRechargeTHotData.depositPreBuyInfoRev[k] = v.PreBuyID
      end
    end
  end
end

function NewRechargeTHotData.IsDepositItem_PreBuy(depositId)
  return NewRechargeTHotData.depositPreBuyInfo[depositId]
end

function NewRechargeTHotData.IsDepositItem_PostBuy(depositId)
  return NewRechargeTHotData.depositPreBuyInfoRev[depositId]
end
