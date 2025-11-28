autoImport("SupplyDepotData")
NoviceShopProxy = class("NoviceShopProxy", pm.Proxy)
NoviceShopProxy.Instance = nil
NoviceShopProxy.NAME = "NoviceShopProxy"
local DepositConfig = GameConfig.FirstDeposit
local VersionConfig = DepositConfig and DepositConfig.VersionConfig or {}
local tempTable = {}
NoviceShopProxy.GoodsTypeEnum = {Deposit = 1, Shop = 2}
NoviceShopProxy.RewardState = {
  Lock = 0,
  Unlock = 1,
  Finished = 2
}
NoviceShopProxy.RedTipID = SceneTip_pb.EREDSYS_FIRST_DEPOSIT

function NoviceShopProxy:ctor(proxyName, data)
  self.proxyName = proxyName or NoviceShopProxy.NAME
  if NoviceShopProxy.Instance == nil then
    NoviceShopProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
end

function NoviceShopProxy:RecvFirstDepositInfo(data)
  if data then
    self.actEndTime = data.end_time
    self.accumlated_deposit = data.accumlated_deposit
    self.first_deposit_rewarded = data.first_deposit_rewarded
    self.version = data.version
    redlog("RecvFirstDepositInfo", self.version, self.actEndTime, self.accumlated_deposit)
    self:InitRewardConfig()
    if not self.finishedReward then
      self.finishedReward = {}
    else
      TableUtility.TableClear(self.finishedReward)
    end
    if data.got_gear then
      for i = 1, #data.got_gear do
        self.finishedReward[data.got_gear[i]] = 1
      end
    end
    if self.first_deposit_rewarded then
      self.finishedReward[-1] = 1
    else
      self.finishedReward[-1] = nil
    end
    local nextDeposit
    for index, v in pairs(self.rewardConfig) do
      if v.price == -1 then
        if self.accumlated_deposit > 0 then
          self.rewardConfig[index].state = self.RewardState.Unlock
        end
      elseif v.price <= self.accumlated_deposit then
        self.rewardConfig[index].state = self.RewardState.Unlock
      elseif v.price >= 0 and (not nextDeposit or nextDeposit > v.price) then
        nextDeposit = v.price
      end
      if self.finishedReward[v.price] == 1 then
        self.rewardConfig[index].state = self.RewardState.Finished
      end
    end
    if nextDeposit then
      self.nextDeposit = nextDeposit
    else
      self.nextDeposit = nil
    end
  end
end

function NoviceShopProxy:GetShopConfig()
  if self.version then
    local currentVersion = VersionConfig[self.version]
    if not currentVersion then
      redlog("NoviceShopProxy:GetShopConfig", "fail to get VersionConfig. version is:", self.version)
    end
    return DepositConfig.ShopType, currentVersion and currentVersion.ShopID
  end
end

function NoviceShopProxy:CallQueryShopConfig(noJump)
  if not self.callCount then
    self.callCount = 0
  end
  self.noviceshop_type, self.noviceshop_id = self:GetShopConfig()
  local shopData = ShopProxy.Instance:GetShopDataByTypeId(self.noviceshop_type, self.noviceshop_id)
  local goods = shopData and shopData:GetGoods() or {}
  HappyShopProxy.Instance.shopType, HappyShopProxy.Instance.params = self.noviceshop_type, self.noviceshop_id
  if not shopData or not next(goods) then
    HappyShopProxy.Instance.shopType, HappyShopProxy.Instance.params = self.noviceshop_type, self.noviceshop_id
    ShopProxy.Instance:CallQueryShopConfig(self.noviceshop_type, self.noviceshop_id)
  elseif not noJump then
    self:TryOpenPanel()
  end
end

function NoviceShopProxy:RecvQueryShopConfig(servicedata)
  local type = servicedata.type
  local shopID = servicedata.shopid
  if type == self.noviceshop_type and shopID == self.noviceshop_id then
    self:TryOpenPanel()
  end
end

function NoviceShopProxy:TryOpenPanel()
  if UIManagerProxy.Instance:HasUINode(PanelConfig.NoviceCombineView) then
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.NoviceCombineView,
    viewdata = {tab = 5}
  })
end

function NoviceShopProxy:GetShopItems()
  TableUtility.ArrayClear(tempTable)
  if self.version then
    local shop_type, shop_id = self:GetShopConfig()
    local shopData = ShopProxy.Instance:GetShopDataByTypeId(shop_type, shop_id)
    if shopData then
      local config = shopData:GetGoods()
      for k, v in pairs(config) do
        local entry = {}
        entry.goodsID = k
        entry.GoodsType = NoviceShopProxy.GoodsTypeEnum.Shop
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
        entry.GoodsType = NoviceShopProxy.GoodsTypeEnum.Deposit
        TableUtility.ArrayPushBack(tempTable, entry)
      end
    end
  else
    redlog("no version")
  end
  return tempTable
end

function NoviceShopProxy:UpdateRedTip()
  RedTipProxy.Instance:UpdateRedTip(NoviceShopProxy.RedTipID)
end

function NoviceShopProxy:GetEndDate()
  return self.actEndTime
end

function NoviceShopProxy:ClearEndDate()
  self.actEndTime = 0
end

function NoviceShopProxy:InitRewardConfig()
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
    local entry = {}
    entry.price = -1
    entry.itemid = config.FirstDepositReward[1]
    entry.count = config.FirstDepositReward[2]
    entry.state = self.RewardState.Lock
    self.rewardConfig[1] = entry
    local list = {}
    for price, v in pairs(config.AccumlatedDepositReward) do
      local single = {}
      single.price = price
      single.itemid = v[1]
      single.count = v[2]
      single.state = self.RewardState.Lock
      table.insert(list, single)
    end
    table.sort(list, function(l, r)
      return l.price < r.price
    end)
    for i = 1, #list do
      self.rewardConfig[i + 1] = list[i]
    end
  end
end

function NoviceShopProxy:GetRewardDataByID(id)
  return self.rewardConfig and self.rewardConfig[id]
end

function NoviceShopProxy:CheckAchieved(price)
  return self.finishedReward and self.finishedReward[price]
end

function NoviceShopProxy:GetNPCID()
  if self.version then
    return VersionConfig[self.version] and VersionConfig[self.version].NpcId
  end
end

function NoviceShopProxy:CheckValidTime()
  local endDate = self:GetEndDate()
  if not endDate or endDate <= 0 then
    return false
  end
  local lefttime = endDate - ServerTime.CurServerTime() / 1000
  return 0 < lefttime
end

function NoviceShopProxy:GetAccumulatedDeposit()
  return self.accumlated_deposit or 0
end

function NoviceShopProxy:GetAccumulatedNextStep()
  return self.nextDeposit
end

function NoviceShopProxy:InitCurrencyType()
  if self.version then
    local deposit = VersionConfig[self.version] and VersionConfig[self.version].DepositID
    if deposit then
      self.currencyType = Table_Deposit[deposit[1]].CurrencyType
    else
      redlog("not deposit")
    end
  else
    redlog("not version")
  end
end

function NoviceShopProxy:GetCurrencyType()
  if not self.currencyType then
    self:InitCurrencyType()
  end
  return self.currencyType or ""
end

function NoviceShopProxy:CanShow()
  local lastopen = LocalSaveProxy.Instance:GetNoviceShopOpened()
  local intime = self.actEndTime and self.actEndTime > ServerTime.CurServerTime() / 1000
  redlog("CanShow", lastopen, self.actEndTime, ServerTime.CurServerTime() / 1000)
  return (not lastopen or lastopen == 0) and intime
end

function NoviceShopProxy:UpdateaRedTip()
  local isInRed = RedTipProxy.Instance:InRedTip(SceneTip_pb.EREDSYS_PET_ADVENTURE)
  return isInRed
end

function NoviceShopProxy:UpdateaRewardTip()
  if self.rewardConfig then
    for index, value in pairs(self.rewardConfig) do
      if value.state == self.RewardState.Unlock then
        return true
      end
    end
  end
  return false
end

function NoviceShopProxy:isShopOpen()
  local shopType, shopId = self:GetShopConfig()
  local endTime = self:GetEndDate() or 0
  if shopType and shopId and endTime > ServerTime.CurServerTime() / 1000 then
    return true
  end
  return false
end
