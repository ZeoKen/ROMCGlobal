autoImport("ShopData")
ShopProxy = class("ShopProxy", pm.Proxy)
ShopProxy.Instance = nil
ShopProxy.NAME = "ShopProxy"

function ShopProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ShopProxy.NAME
  if ShopProxy.Instance == nil then
    ShopProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function ShopProxy:Init()
  self.info = {}
  self.callTime = {}
  self.nextResetTime = 0
end

function ShopProxy:CallQueryShopConfig(type, shopID, force)
  local currentTime = UnityUnscaledTime
  local nextValidTime
  local infoMap = self.info[type]
  if infoMap and infoMap[shopID] then
    nextValidTime = infoMap[shopID]:GetNextValidTime()
  end
  if force or nextValidTime == nil or currentTime >= nextValidTime then
    if infoMap == nil then
      infoMap = {}
      self.info[type] = infoMap
    end
    if infoMap[shopID] == nil then
      infoMap[shopID] = ShopData.new()
      self.info[type][shopID] = infoMap[shopID]
    end
    infoMap[shopID]:SetNextValidTime(5)
    helplog("CallQueryShopConfigCmd", type, shopID)
    ServiceSessionShopProxy.Instance:CallQueryShopConfigCmd(type, shopID)
    return true
  end
end

function ShopProxy:RecvQueryShopConfig(servicedata)
  local type = servicedata.type
  local shopID = servicedata.shopid
  local goods = servicedata.goods
  helplog("RecvQueryShopConfig,", type, shopID, #goods)
  local infoMap = self.info[type]
  if infoMap == nil then
    infoMap = {}
    self.info[type] = infoMap
  end
  if infoMap[shopID] == nil then
    infoMap[shopID] = ShopData.new(servicedata)
    self.info[type][shopID] = infoMap[shopID]
  else
    infoMap[shopID]:SetData(servicedata)
  end
  infoMap[shopID]:SetNextValidTime(60)
end

function ShopProxy:RecvServerLimitSellCountCmd(servicedata)
  local config = self:GetConfigByTypeId(servicedata.type, servicedata.shopID)
  if config then
    for i = 1, #servicedata.sell_infos do
      local data = servicedata.sell_infos[i]
      local shopItemData = config[data.id]
      if shopItemData ~= nil then
        shopItemData:SetCurProduceNum(data.sell_count)
      end
    end
  end
end

function ShopProxy:RecvShopDataUpdateCmd(servicedata)
  local infoMap = self.info[servicedata.type]
  if infoMap ~= nil then
    local shop = infoMap[servicedata.shopid]
    if shop ~= nil then
      shop:SetNextValidTime(0)
    end
  end
end

function ShopProxy:RecvUpdateShopConfigCmd(servicedata)
  local infoMap = self.info[servicedata.type]
  if infoMap ~= nil then
    local shop = infoMap[servicedata.shopid]
    if shop ~= nil then
      for i = 1, #servicedata.add_goods do
        shop:AddShopItemData(servicedata.add_goods[i])
      end
      for i = 1, #servicedata.del_goods_id do
        shop:RemoveShopItemData(servicedata.del_goods_id[i])
      end
    end
  end
end

function ShopProxy:GetConfigByType(type)
  return self.info[type] or {}
end

function ShopProxy:GetConfigByTypeId(type, shopID)
  local infoMap = self.info[type]
  if infoMap and infoMap[shopID] then
    return infoMap[shopID]:GetGoods()
  end
  return {}
end

function ShopProxy:GetShopDataByTypeId(type, shopID)
  local infoMap = self.info[type]
  if infoMap then
    return infoMap[shopID]
  end
  return nil
end

function ShopProxy:GetShopItemDataByTypeId(type, shopID, id)
  local config = self:GetConfigByTypeId(type, shopID)
  if config then
    return id and config[id]
  end
end

function ShopProxy:Server_SetShopSoldCountCmdInfo(server_items)
  if server_items == nil or #server_items == 0 then
    return
  end
  for i = 1, #server_items do
    local item = server_items[i]
    local shopData = self:GetShopDataByTypeId(item.type, item.shopid)
    helplog(item.type, item.shopid)
    if shopData then
      local shopItemData = shopData.goods[item.id]
      if shopItemData then
        helplog(item.count)
        shopItemData:SetSoldCount(item.count)
      end
    end
  end
end

function ShopProxy:SetNextRefreshTime(data)
  helplog("SetNextRefreshTime", data.nextResetTime)
  self.nextResetTime = data.nextResetTime
end

function ShopProxy:GetNextRefreshTime()
  return self.nextResetTime or 0
end

function ShopProxy:XDSDKPay(price, s_id, product_id, product_name, role_id, ext, product_count, order_id, on_pay_success, on_pay_fail, on_pay_cancel, on_pay_timeout, on_pay_product_illegal)
  EventManager.Me():PassEvent(ZenyShopEvent.OpenBoxCollider, nil)
  local on_pay_success_func = function()
    if on_pay_success then
      on_pay_success()
    end
    EventManager.Me():PassEvent(ZenyShopEvent.CloseBoxCollider, nil)
  end
  local on_pay_fail_func = function()
    if on_pay_fail then
      on_pay_fail()
    end
    EventManager.Me():PassEvent(ZenyShopEvent.CloseBoxCollider, nil)
  end
  local on_pay_cancel_func = function()
    if on_pay_cancel then
      on_pay_cancel()
    end
    EventManager.Me():PassEvent(ZenyShopEvent.CloseBoxCollider, nil)
  end
  local on_pay_timeout_func = function()
    if on_pay_timeout then
      on_pay_timeout()
    end
    EventManager.Me():PassEvent(ZenyShopEvent.CloseBoxCollider, nil)
  end
  local on_pay_product_illegal_func = function()
    if on_pay_product_illegal then
      on_pay_product_illegal()
    end
    EventManager.Me():PassEvent(ZenyShopEvent.CloseBoxCollider, nil)
  end
  FunctionSDK.Instance:XDSDKPay(price, s_id, product_id, product_name, role_id, ext, product_count, order_id, on_pay_success_func, on_pay_fail_func, on_pay_cancel_func, on_pay_timeout_func, on_pay_product_illegal_func)
end

function ShopProxy:SelfDebug(msg)
  if false then
    helplog(msg)
  end
end

function ShopProxy:IsThisItemCanBuyNow(id)
  local data = id and Table_Deposit[id]
  if data.After_Open_Server and ServerTime.CurServerTime() / 1000 < ServerTime.GetFormatServerOpenTime() + (data.After_Open_Server - 1) * 60 * 60 * 24 then
    return false
  end
  if data and data.TF_OpenTime and data.TF_CloseTime and data.Release_OpenTime and data.Release_CloseTime then
  else
    self:SelfDebug("配置表有问题 找严紫薇")
    return false
  end
  local platHide = data.PlatHide
  if platHide then
    local hideConfig = {
      [RuntimePlatform.IPhonePlayer] = 1,
      [RuntimePlatform.Android] = 2
    }
    local plat = ApplicationInfo.GetRunPlatform()
    local hideValue = hideConfig[plat] or 0
    if 0 < platHide & hideValue then
      return
    end
  end
  local StartDate, FinishDate
  if EnvChannel.IsTFBranch() then
    StartDate = data.TF_OpenTime
    FinishDate = data.TF_CloseTime
  else
    StartDate = data.Release_OpenTime
    FinishDate = data.Release_CloseTime
  end
  if StartDate and FinishDate then
    if StartDate == "" and FinishDate == "" then
      self:SelfDebug("永久")
      return true
    elseif KFCARCameraProxy.Instance:CheckDateValid(StartDate, FinishDate) then
      return true
    else
      self:SelfDebug("不在活动时间")
      return false
    end
  else
    self:SelfDebug("策划没配活动时间")
    return false
  end
end

function ShopProxy:GetDepositItemCanBuy(depositItemId)
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

function ShopProxy:GetDepositShowTimeInterval(id)
  local data = id and Table_Deposit[id]
  if not data or data.ShowTime ~= 1 then
    return 0, 0
  end
  local StartDate, FinishDate
  local retStartTick, retEndTick = 0, 0
  if EnvChannel.IsTFBranch() then
    if data.TF_OpenTime and data.TF_OpenTime ~= "" then
      retStartTick = StringUtil.FormatTime2TimeStamp2(data.TF_OpenTime)
    end
    if data.TF_CloseTime and data.TF_CloseTime ~= "" then
      retEndTick = StringUtil.FormatTime2TimeStamp2(data.TF_CloseTime)
    end
  else
    if data.Release_OpenTime and data.Release_OpenTime ~= "" then
      retStartTick = StringUtil.FormatTime2TimeStamp2(data.Release_OpenTime)
    end
    if data.Release_CloseTime and data.Release_CloseTime ~= "" then
      retEndTick = StringUtil.FormatTime2TimeStamp2(data.Release_CloseTime)
    end
  end
  return retStartTick, retEndTick
end

function ShopProxy:SetImproveShopTable(t)
  self.ImproveShopTable = t
end

function ShopProxy:GetImproveShopTable()
  return self.ImproveShopTable
end

function ShopProxy:SetChargeCntTable(data)
  self.ChargeCntTable = {}
  local info = data.info
  for i = 1, #info do
    local tmp = {}
    tmp.dataid = info[i].dataid
    tmp.count = info[i].count
    tmp.limit = info[i].limit
    table.insert(self.ChargeCntTable, tmp)
  end
end

function ShopProxy:ClearShopConfig(shoptype, shopid)
  if shoptype and shopid and self.info and self.info[shoptype] and self.info[shoptype][shopid] then
    self.info[shoptype][shopid] = nil
    self.info[shoptype] = nil
  end
end

function ShopProxy:RecvQueryAccChargeCntReward(serverDatas)
  local chargeInfos = self.accChargeCntRewardInfos or {}
  for _, info in pairs(chargeInfos) do
    ReusableTable.DestroyAndClearTable(info)
  end
  TableUtility.TableClear(chargeInfos)
  local lData, sData
  for i = 1, #serverDatas do
    lData, sData = ReusableTable.CreateTable(), serverDatas[i]
    lData.dataid = sData.dataid
    lData.count = sData.count
    lData.limit = sData.limit
    table.insert(chargeInfos, lData)
  end
  self.accChargeCntRewardInfos = chargeInfos
end

local depositCountRewardMap = {}

function ShopProxy:GetDepositCardRewardByDepositAndCount(deposit, isAccLimit, count)
  if not next(depositCountRewardMap) then
    local d1, d2, d3
    for _, d in pairs(Table_DepositCountReward) do
      d1 = depositCountRewardMap[d.DepositID] or {}
      d2 = d1[d.AccLimit] or {}
      d3 = d2[d.Count] or {}
      d3.rewardItems = d.RewardItems
      d3.desc = d.Des
      d3.desc2 = d.Des2
      if d.TF_Open then
        d3.TF_Open = d.TF_Open
      end
      if d.Release_Open then
        d3.Release_Open = d.Release_Open
      end
      d2[d.Count] = d3
      d1[d.AccLimit] = d2
      depositCountRewardMap[d.DepositID] = d1
    end
  end
  if not depositCountRewardMap[deposit] then
    return
  end
  isAccLimit = isAccLimit == true and 1 or 0
  if not depositCountRewardMap[deposit][isAccLimit] then
    return
  end
  if not depositCountRewardMap[deposit][isAccLimit][count] then
    return
  end
  local branchValid
  if EnvChannel.IsReleaseBranch() then
    if depositCountRewardMap[deposit][isAccLimit][count].Release_Open and depositCountRewardMap[deposit][isAccLimit][count].Release_Open == 1 then
      branchValid = true
    end
  elseif depositCountRewardMap[deposit][isAccLimit][count].TF_Open and depositCountRewardMap[deposit][isAccLimit][count].TF_Open == 1 then
    branchValid = true
  end
  if branchValid then
    return depositCountRewardMap[deposit][isAccLimit][count]
  end
end

function ShopProxy:updateWeekLimitNum(data)
  if data.success then
    for type, infoMap in pairs(self.info) do
      for shopID, shopData in pairs(infoMap) do
        local shopInfo = shopData.goods[data.id]
        if shopInfo then
          shopInfo.accAreadyBuyCount = data.accweeklimitshow
          shopInfo.sum_count = shopInfo.sum_count + data.count
          return
        end
      end
    end
  end
end
