NewRechargeTShopData = class("NewRechargeTShopData")
local _ViewTab = 1

function NewRechargeTShopData:ctor()
  self.shopItemList = {}
  self.cacheSortMap = {}
end

function NewRechargeTShopData:GetShopItemList(sort)
  TableUtility.ArrayClear(self.shopItemList)
  local inner = GameConfig.NewRecharge.Tabs[_ViewTab].Inner
  local config
  for _, v in pairs(inner) do
    if v.ID == sort then
      config = v
      break
    end
  end
  for k, v in pairs(Table_ShopShow) do
    if config.Params.ShopShowType ~= nil and v.Sort == config.Params.ShopShowType then
      if v.Type == 2 and self.IsDepositItem(v.ShopID) and self.IsDepositItemCanShow(v.ShopID) then
        Table_ShopShow[k].confType = 1
        table.insert(self.shopItemList, Table_ShopShow[k])
      elseif v.Type == 1 and self.IsShopItem(v.ShopID) and self.IsShopItemCanShow(v.ShopID) then
        Table_ShopShow[k].confType = 2
        table.insert(self.shopItemList, Table_ShopShow[k])
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
        local info_x = NewRechargeProxy.Ins:GenerateShopGoodsInfo(x.ShopID)
        local info_y = NewRechargeProxy.Ins:GenerateShopGoodsInfo(y.ShopID)
        local count_x = info_x:GetLimitCanBuyCount()
        local count_y = info_y:GetLimitCanBuyCount()
        local isSoldOut_x = count_x and count_x <= 0 or false
        local isSoldOut_y = count_y and count_y <= 0 or false
        if isSoldOut_x == isSoldOut_y then
          return x.Order < y.Order
        end
        return not isSoldOut_x
      end
      if x ~= nil and y ~= nil then
        return x.Order < y.Order
      end
      return false
    end)
    for i = 1, #self.shopItemList do
      self.cacheSortMap[self.shopItemList[i].id] = i
    end
  end
  if sort == 1 then
  end
  return self.shopItemList
end

function NewRechargeTShopData.IsDepositItem(depositItemId)
  return Table_Deposit and Table_Deposit[depositItemId] ~= nil or false
end

function NewRechargeTShopData.IsShopItem(shopItemId)
  return true
end

function NewRechargeTShopData.IsDepositItemCanShow(depositItemId)
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

function NewRechargeTShopData.IsShopItemCanShow(shopItemId)
  autoImport("NewRechargeTHotData")
  return NewRechargeTHotData.IsShopItemCanShow(shopItemId)
end
