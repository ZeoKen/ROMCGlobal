autoImport("SupplyDepotData")
AccumulativeShopProxy = class("AccumulativeShopProxy", pm.Proxy)
AccumulativeShopProxy.Instance = nil
AccumulativeShopProxy.NAME = "AccumulativeShopProxy"
local VersionConfig = {}
local tempTable = {}
AccumulativeShopProxy.GoodsTypeEnum = {Deposit = 1, Shop = 2}
AccumulativeShopProxy.RewardState = {
  Lock = 0,
  Unlock = 1,
  Finished = 2
}
AccumulativeShopProxy.RedTipID = 10733

function AccumulativeShopProxy:ctor(proxyName, data)
  self.proxyName = proxyName or AccumulativeShopProxy.NAME
  if AccumulativeShopProxy.Instance == nil then
    AccumulativeShopProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  GameConfig.AccumulativeDeposit = GameConfig.FirstDeposit
  VersionConfig = Table_AccumDeposit
end

function AccumulativeShopProxy:RecvAccumDepositInfo(data)
  if data then
    self.actEndTime = data.end_time
    self.accumlated_deposit = data.accumlated_deposit
    self.version = data.cur_act
    redlog("RecvAccumDepositInfo", self.version, self.actEndTime, self.accumlated_deposit)
    self:InitRewardConfig()
    if not self.finishedReward then
      self.finishedReward = {}
    else
      TableUtility.TableClear(self.finishedReward)
    end
    if data.gotten_rewards then
      for i = 1, #data.gotten_rewards do
        self.finishedReward[data.gotten_rewards[i]] = 1
      end
    end
    for index, v in pairs(self.rewardConfig) do
      if v.price == -1 then
        if self.accumlated_deposit > 0 then
          self.rewardConfig[index].state = self.RewardState.Unlock
        end
      else
        local reach = false
        if math.floor(v.price) ~= v.price or math.floor(self.accumlated_deposit) ~= self.accumlated_deposit then
          local l_up = math.RoundDecimalPlaces(v.price, 2)
          local r_up = math.RoundDecimalPlaces(self.accumlated_deposit, 2)
          reach = l_up <= r_up
        else
          reach = v.price <= self.accumlated_deposit
        end
        if reach then
          self.rewardConfig[index].state = self.RewardState.Unlock
        end
      end
      if self.finishedReward[v.idx] == 1 then
        self.rewardConfig[index].state = self.RewardState.Finished
      end
    end
  end
end

function AccumulativeShopProxy:RecvAccumDepositReward(data)
  if not self.rewardConfig or not self.finishedReward then
    redlog("AccumulativeShopProxy:RecvAccumDepositReward", "not ever RecvAccumDepositInfo")
    return
  end
  if data and data.get_reward then
    self.finishedReward[data.get_reward] = 1
    for index, v in pairs(self.rewardConfig) do
      if self.finishedReward[v.idx] == 1 then
        self.rewardConfig[index].state = self.RewardState.Finished
      end
    end
  end
end

function AccumulativeShopProxy:GetShopConfig()
  if self.version then
    local currentVersion = VersionConfig[self.version]
    if not currentVersion then
      redlog("AccumulativeShopProxy:GetShopConfig", "fail to get VersionConfig. version is:", self.version)
    end
    return 0, currentVersion and currentVersion.ShopID
  end
end

function AccumulativeShopProxy:CallQueryShopConfig()
  self.noviceshop_type, self.noviceshop_id = self:GetShopConfig()
  local shopData = ShopProxy.Instance:GetShopDataByTypeId(self.noviceshop_type, self.noviceshop_id)
  local goods = shopData and shopData:GetGoods() or {}
  HappyShopProxy.Instance.shopType, HappyShopProxy.Instance.params = self.noviceshop_type, self.noviceshop_id
  if not shopData or not next(goods) then
    HappyShopProxy.Instance.shopType, HappyShopProxy.Instance.params = self.noviceshop_type, self.noviceshop_id
    ShopProxy.Instance:CallQueryShopConfig(self.noviceshop_type, self.noviceshop_id)
  else
    if UIManagerProxy.Instance:HasUINode(PanelConfig.NoviceShopView) then
      return
    end
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.NoviceShopView
    })
  end
end

function AccumulativeShopProxy:RecvQueryShopConfig(servicedata)
  local type = servicedata.type
  local shopID = servicedata.shopid
  if type == self.noviceshop_type and shopID == self.noviceshop_id then
    if UIManagerProxy.Instance:HasUINode(PanelConfig.NoviceShopView) then
      return
    end
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.NoviceShopView
    })
  end
end

function AccumulativeShopProxy:GetShopItems()
  TableUtility.ArrayClear(tempTable)
  if self.version then
    local shop_type, shop_id = self:GetShopConfig()
    local shopData = ShopProxy.Instance:GetShopDataByTypeId(shop_type, shop_id)
    if shopData then
      local config = shopData:GetGoods()
      for k, v in pairs(config) do
        local entry = {}
        entry.goodsID = k
        entry.GoodsType = AccumulativeShopProxy.GoodsTypeEnum.Shop
        TableUtility.ArrayPushBack(tempTable, entry)
      end
    end
    table.sort(tempTable, function(l, r)
      return l.goodsID < r.goodsID
    end)
    local currentVersion = VersionConfig[self.version]
    if currentVersion.DepositID then
      for i = 1, #currentVersion.DepositID do
        local entry = {}
        entry.depositID = currentVersion.DepositID[i]
        entry.GoodsType = AccumulativeShopProxy.GoodsTypeEnum.Deposit
        TableUtility.ArrayPushBack(tempTable, entry)
      end
    end
  else
    redlog("no version")
  end
  return tempTable
end

function AccumulativeShopProxy:UpdateRedTip()
  RedTipProxy.Instance:UpdateRedTip(AccumulativeShopProxy.RedTipID)
end

function AccumulativeShopProxy:GetEndDate()
  redlog("Accumu GetEndDate", self.actEndTime)
  return self.actEndTime
end

function AccumulativeShopProxy:ClearEndDate()
  self.actEndTime = 0
end

function AccumulativeShopProxy:InitRewardConfig()
  if self.version then
    if not self.rewardConfig then
      self.rewardConfig = {}
    else
      TableUtility.ArrayClear(self.rewardConfig)
    end
    local config = VersionConfig[self.version]
    if not config then
      return
    end
    for i = 1, #config.Reward do
      local single = {}
      single.price = 0
      if config.Reward[i].any_deposit then
        single.price = -1
      elseif config.Reward[i].need_deposit then
        single.price = config.Reward[i].need_deposit
      end
      single.itemid = config.Reward[i].reward[1]
      single.count = config.Reward[i].reward[2]
      single.state = self.RewardState.Lock
      single.idx = i
      single.extraTip = config.Reward[i].extraTip
      table.insert(self.rewardConfig, single)
    end
    table.sort(self.rewardConfig, function(l, r)
      return l.price < r.price
    end)
  end
end

function AccumulativeShopProxy:GetRewardDataByID(id)
  return self.rewardConfig and self.rewardConfig[id]
end

function AccumulativeShopProxy:CheckAchieved(price)
  return self.finishedReward and self.finishedReward[price]
end

function AccumulativeShopProxy:GetNPCID()
  if self.version then
    return VersionConfig[self.version] and VersionConfig[self.version].ShowNpc
  end
end

function AccumulativeShopProxy:GetADText()
  if self.version then
    return VersionConfig[self.version] and VersionConfig[self.version].AdText
  end
end

function AccumulativeShopProxy:CheckValidTime()
  local endDate = self:GetEndDate()
  if not endDate or endDate <= 0 then
    return false
  end
  local lefttime = endDate - ServerTime.CurServerTime() / 1000
  return 0 < lefttime
end

function AccumulativeShopProxy:GetAccumulatedDeposit()
  return self.accumlated_deposit or 0
end

function AccumulativeShopProxy:InitCurrencyType()
  if self.version then
    local deposit = VersionConfig[self.version] and VersionConfig[self.version].DepositID
    if deposit then
      self.currencyType = Table_Deposit[deposit[1]].CurrencyType
    else
      redlog("not deposit")
      self.currencyType = VersionConfig[self.version] and VersionConfig[self.version].CurrencyType
    end
    if not self.currencyType then
      for _, v in pairs(Table_Deposit) do
        if v.CurrencyType then
          self.currencyType = v.CurrencyType
          break
        end
      end
    end
  else
    redlog("not version")
  end
end

function AccumulativeShopProxy:GetCurrencyType()
  if not self.currencyType then
    self:InitCurrencyType()
  end
  return self.currencyType or "￥"
end

function AccumulativeShopProxy:CanShow()
  local lastopen = LocalSaveProxy.Instance:GetNoviceShopOpened()
  local intime = self.actEndTime and self.actEndTime > ServerTime.CurServerTime() / 1000
  redlog("CanShow", lastopen, self.actEndTime, ServerTime.CurServerTime() / 1000)
  return (not lastopen or lastopen == 0) and intime
end

function AccumulativeShopProxy:UpdateaRedTip()
  local isInRed = RedTipProxy.Instance:InRedTip(SceneTip_pb.EREDSYS_PET_ADVENTURE)
  return isInRed
end

function AccumulativeShopProxy:UpdateaRewardTip()
  if self.rewardConfig then
    for index, value in pairs(self.rewardConfig) do
      if value.state == self.RewardState.Unlock then
        return true
      end
    end
  end
  return false
end
