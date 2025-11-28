NewRechargeTDepositData = class("NewRechargeTDepositData")
local table_Deposit
local _ViewTab = 3

function NewRechargeTDepositData:ctor()
  if not table_Deposit then
    table_Deposit = Table_Deposit
  end
  self.ROBItemList = {}
  self.ZenyItemList = {}
  _Table_ShopShow = Table_ShopShow
  _NewRechargeProxy = NewRechargeProxy.Ins
end

NewRechargeTDepositData.ROBItemList = nil
local shopIdComparer = function(x, y)
  return x.ShopID < y.ShopID
end
local infoMap = {}

function NewRechargeTDepositData:GetROBItemList(refresh)
  if refresh then
    TableUtility.ArrayClear(self.ROBItemList)
    local inner = GameConfig.NewRecharge.Tabs[_ViewTab].Inner
    local config
    for _, v in pairs(inner) do
      if v.ID == 1 then
        config = v
        break
      end
    end
    if config.Params.ShopShowType ~= nil then
      for k, v in pairs(Table_ShopShow) do
        if v.Sort == config.Params.ShopShowType and v.Type == 2 and self.IsDepositItem(v.ShopID) and self.IsDepositItemCanShow(v.ShopID) then
          Table_ShopShow[k].confType = 1
          table.insert(self.ROBItemList, Table_ShopShow[k])
          local info = _NewRechargeProxy:GenerateDepositGoodsInfo(v.ShopID)
          infoMap[v.id] = info
        end
      end
      table.sort(self.ROBItemList, function(x, y)
        local xSoldOut = infoMap[x.id]:IsSoldOut() and 0 or 1
        local ySoldOut = infoMap[y.id]:IsSoldOut() and 0 or 1
        if xSoldOut ~= ySoldOut then
          return xSoldOut > ySoldOut
        end
        local x_order = x.Order or 0
        local y_order = y.Order or 0
        if x_order ~= y_order then
          return x_order < y_order
        end
      end)
    else
      for k, v in pairs(table_Deposit) do
        if v.Type == 3 and v.Switch == 1 then
          table.insert(self.ROBItemList, {ShopID = k, confType = 1})
        end
      end
      table.sort(self.ROBItemList, function(x, y)
        local xData, yData = table_Deposit[x.ShopID], table_Deposit[y.ShopID]
        local xOrder, yOrder = xData and xData.SortingOrder or math.huge, yData and yData.SortingOrder or math.huge
        if xOrder ~= yOrder then
          return xOrder < yOrder
        end
        return shopIdComparer(x, y)
      end)
    end
  end
  return self.ROBItemList
end

function NewRechargeTDepositData.IsDepositItem(depositItemId)
  return Table_Deposit and Table_Deposit[depositItemId] ~= nil or false
end

function NewRechargeTDepositData.IsDepositItemCanShow(depositItemId)
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

NewRechargeTDepositData.ZenyItemList = nil

function NewRechargeTDepositData:GetZenyItemList(refresh)
  if refresh then
    TableUtility.ArrayClear(self.ZenyItemList)
    local inner = GameConfig.NewRecharge.Tabs[_ViewTab].Inner
    local config
    for _, v in pairs(inner) do
      if v.ID == 2 then
        config = v
        break
      end
    end
    if config and config.Params.ShopShowType ~= nil then
      for k, v in pairs(Table_ShopShow) do
        if v.Sort == config.Params.ShopShowType and v.Type == 2 and self.IsDepositItem(v.ShopID) and self.IsDepositItemCanShow(v.ShopID) then
          Table_ShopShow[k].confType = 1
          table.insert(self.ZenyItemList, Table_ShopShow[k])
          local info = _NewRechargeProxy:GenerateDepositGoodsInfo(v.ShopID)
          infoMap[v.id] = info
        end
      end
      table.sort(self.ZenyItemList, function(x, y)
        local xSoldOut = infoMap[x.id]:IsSoldOut() and 0 or 1
        local ySoldOut = infoMap[y.id]:IsSoldOut() and 0 or 1
        if xSoldOut ~= ySoldOut then
          return xSoldOut > ySoldOut
        end
        local x_order = x.Order or 0
        local y_order = y.Order or 0
        if x_order ~= y_order then
          return x_order < y_order
        end
      end)
    else
      for k, v in pairs(table_Deposit) do
        if v.Type == 1 and v.Switch == 1 and v.ActivityDiscount ~= 1 then
          table.insert(self.ZenyItemList, {ShopID = k, confType = 1})
        end
      end
      table.sort(self.ZenyItemList, shopIdComparer)
    end
  end
  return self.ZenyItemList
end
