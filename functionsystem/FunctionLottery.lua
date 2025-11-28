autoImport("NewMixLotteryGroup")
local _redtip_free, _redtip_daily_reward
local _TableClear = TableUtility.TableClear
local _Pattern = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
local _GenderField = {
  [1] = "male",
  [2] = "female"
}
local _RaceField = {
  [1] = "Human",
  [2] = "Cat"
}
local HeadwearSortID = {
  Magic = 3,
  Head = 2,
  Coin = 1
}
FunctionLottery = class("FunctionLottery", EventDispatcher)

function FunctionLottery.Me()
  if nil == FunctionLottery.me then
    FunctionLottery.me = FunctionLottery.new()
  end
  return FunctionLottery.me
end

function FunctionLottery:ctor()
  self:Init()
end

function FunctionLottery:Init()
  _redtip_free = SceneTip_pb.EREDSYS_LOTTERY_FREE
  _redtip_daily_reward = SceneTip_pb.EREDSYS_LOTTERY_DAILY_REWARD
  self.dressMap = {}
  self.mixLotteryStaticData = {}
  self.cache_item_price = {}
  self.mixFilterData = {}
  self:ResetMixShopPurchase()
  self:PreprocessMixLotteryFilter()
  self:PreprocessGroupGender()
end

function FunctionLottery:PreprocessGroupGender()
  self.ignoreGenderGroup = {}
  local config = GameConfig.MixLottery.IgnoreGenderGroups
  if config then
    for i = 1, #config do
      self.ignoreGenderGroup[config[i]] = 1
    end
  end
end

function FunctionLottery:IsIgnoreGender(groupid)
  return nil ~= self.ignoreGenderGroup[groupid]
end

function FunctionLottery:PreprocessMixLotteryFilter()
  local config = GameConfig.MixLottery.LotteryFilter
  if not config then
    return
  end
  self.mixLotteryGroupStaticData = {}
  local all_weight = config[0].Weight
  for k, v in pairs(config) do
    self.mixLotteryGroupStaticData[k] = NewMixLotteryGroup.new(k, v, all_weight)
  end
end

function FunctionLottery:ResetMixFilterData()
  _TableClear(self.mixFilterData)
  self.mixFilterData[0] = self.mixLotteryGroupStaticData[0]:GetConfigName()
  local sdata = self.mixLotteryGroupStaticData
  local allRate = 0
  local combineCoinRate = GameConfig.Lottery.MixLotteryCombineCoinRate == 1
  for k, v in pairs(sdata) do
    if k ~= 0 and k ~= LotteryProxy.MixCoinGroup then
      local configName = v:GetConfigName()
      local tempRate = v:GetRate() * 10000
      local combineCoinRateValid = not LotteryProxy.IsNewMixLottery(self.mixLotteryType) or combineCoinRate
      if combineCoinRateValid and v:AllGet() then
        self.mixFilterData[k] = configName
      else
        self.mixFilterData[k] = configName .. " " .. tempRate * 100 .. "%"
        allRate = allRate + tempRate * 100
      end
    end
  end
  local coinMixLotteryGroup = self.mixLotteryGroupStaticData[LotteryProxy.MixCoinGroup]
  local reward_configName = coinMixLotteryGroup:GetConfigName()
  coinMixLotteryGroup:SetRate((100 - allRate) / 1000000)
  self.mixFilterData[LotteryProxy.MixCoinGroup] = reward_configName .. " " .. 100 - allRate .. "%"
end

function FunctionLottery:GetMixLotteryFilter()
  return self.mixFilterData
end

function FunctionLottery:GetRateByGroup(group)
  local sdata = self.mixLotteryGroupStaticData[group]
  if sdata then
    return sdata.rate or 0
  end
  return 0
end

function FunctionLottery:SetRate(group, rate)
  local sdata = self.mixLotteryGroupStaticData[group]
  if sdata then
    sdata:SetRate(rate)
  end
end

function FunctionLottery:GetUngetCnt(group)
  local sdata = self.mixLotteryGroupStaticData[group]
  if sdata then
    return sdata.ungetCount
  end
end

function FunctionLottery:UpdateUngetCnt(group, cnt)
  local sdata = self.mixLotteryGroupStaticData[group]
  if sdata then
    sdata:UpdateUngetCnt(cnt)
  end
end

function FunctionLottery:GetGroupid(t)
  for k, v in pairs(self.mixLotteryGroupStaticData) do
    if v:MatchType(t) then
      return k
    end
  end
  return nil
end

function FunctionLottery:OpenNewLotteryByType(t)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.LotteryMainView,
    viewdata = {lotteryType = t}
  })
end

function FunctionLottery:OpenLotteryEntrance()
  local _LotteryMgr = LotteryProxy.Instance
  local lotteryData = _LotteryMgr:GetEntranceLotteryActs()
  if not next(lotteryData) then
    return
  end
  local redTipProxy = RedTipProxy.Instance
  local freeType, type
  for i = 1, #lotteryData do
    type = lotteryData[i].lotteryType
    if redTipProxy:IsNew(_redtip_free, type) then
      freeType = type
      break
    end
  end
  if nil ~= freeType then
    self:OpenNewLotteryByType(freeType)
  else
    self:OpenNewLotteryByType(lotteryData[1].lotteryType)
  end
end

function FunctionLottery:ClearDressMap()
  _TableClear(self.dressMap)
  self.dressType = nil
end

function FunctionLottery:InitDressMap(initialized_data, dress_type)
  if nil == initialized_data or nil == next(initialized_data) then
    return false
  end
  if self.dressType == dress_type then
    return false
  end
  self.dressType = dress_type
  self:ClearDressMap()
  TableUtility.TableShallowCopy(self.dressMap, initialized_data)
  return true
end

function FunctionLottery:InitDefaultDress(t)
  if not t then
    return nil
  end
  local _DefaultDressConfig = GameConfig.Lottery.TryOn
  if not _DefaultDressConfig then
    return nil
  end
  local lotteryConfig = _DefaultDressConfig[t]
  if not lotteryConfig then
    return nil
  end
  local _MyGender = MyselfProxy.Instance:GetMySex()
  local _MyProfession = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  local _MyRace = ProfessionProxy.GetRaceByProfession(_MyProfession)
  local gender = _GenderField[_MyGender]
  local race = _RaceField[_MyRace]
  local dressConfig = lotteryConfig[race] and lotteryConfig[race][gender]
  if not dressConfig or #dressConfig == 0 then
    return nil
  end
  local tempDressConfig = {}
  for i = 1, #dressConfig do
    if not LotteryProxy.CheckGot(dressConfig[i][2]) then
      tempDressConfig[#tempDressConfig + 1] = dressConfig[i]
    end
  end
  local random_config = nil == next(tempDressConfig) and dressConfig or tempDressConfig
  local random_index = math.random(1, #random_config)
  local dressList = random_config[random_index]
  local result = {}
  local displayRace = MyselfProxy.Instance:GetMyRace()
  for i = 1, #dressList do
    local partIndex = ItemUtil.getItemRolePartIndex(dressList[i])
    if partIndex == Asset_Role.PartIndex.Body then
      local equipData = Table_Equip[dressList[i]]
      local displayBody = equipData and equipData.Body[displayRace]
      if not displayBody and equipData and equipData.Body.female and equipData.Body.male then
        displayBody = isMale and equipData.Body.male[displayRace] or equipData.Body.female[displayRace]
      end
      result[partIndex] = displayBody
    else
      result[partIndex] = dressList[i]
    end
  end
  return result
end

function FunctionLottery:UpdateDressMap(partIndex, id)
  local cacheID = self.dressMap[partIndex]
  if not cacheID or cacheID ~= id then
    self.dressMap[partIndex] = id
  else
    self.dressMap[partIndex] = nil
  end
end

function FunctionLottery:GetDressID(partIndex)
  return self.dressMap[partIndex]
end

function FunctionLottery:GetDressingDesc(itemid)
  local partIndex = ItemUtil.getItemRolePartIndex(itemid)
  if 0 == partIndex then
    return ZhString.Lottery_NoDress
  elseif self:CheckEquipInPreview(itemid) then
    return ZhString.Lottery_InDress
  else
    return ""
  end
end

function FunctionLottery:CheckEquipInPreview(itemid)
  local partIndex = ItemUtil.getItemRolePartIndex(itemid)
  if 0 ~= partIndex then
    if Asset_Role.PartIndex.Body == partIndex then
      local _myselfProxy = MyselfProxy.Instance
      local myRace = _myselfProxy:GetMyRace()
      local equipData = Table_Equip[itemid]
      itemid = equipData and equipData and equipData.Body[myRace]
      if not itemid and equipData.Body.female and equipData.Body.male then
        local mySex = _myselfProxy:GetMySex()
        itemid = mySex == 1 and equipData.Body.male[myRace] or equipData.Body.female[myRace]
      end
    end
    return self.dressMap[partIndex] == itemid
  end
end

function FunctionLottery:GetMixLotteryShopCostID()
  if not self.mix_cost_id then
    self.mix_cost_id = GameConfig.MixLottery and GameConfig.MixLottery.Replaceid or 6771
  end
  return self.mix_cost_id
end

function FunctionLottery:InitMixShop(type, nnpc)
  self.mixLotteryType = type
  if LotteryProxy.IsNewMixLottery(type) then
    return
  end
  local cfg = GameConfig.MixLottery
  if not cfg then
    redlog("混合扭蛋未找到配置 GameConfig.MixLottery ")
    return
  end
  local mixConfig = cfg.MixLotteryShop and cfg.MixLotteryShop[type]
  if not mixConfig then
    redlog("混合扭蛋未找到配置 GameConfig.MixLottery.MixLotteryShop, error lotteryType: ", type)
    return
  end
  if nil == self.mixLotteryStaticData[type] then
    local shop_config = {}
    shop_config.ShopType = cfg.ShopType
    shop_config.ShopID = mixConfig.ShopID
    self.mixLotteryStaticData[type] = shop_config
  end
  HappyShopProxy.Instance:InitShop(nnpc, mixConfig.ShopID, self.mixLotteryStaticData[type].ShopType)
  return self.mixLotteryStaticData[type]
end

function FunctionLottery:GetRecentMixLotteryType()
  return self.mixLotteryType
end

function FunctionLottery:GetMixStaticData(type)
  return self.mixLotteryStaticData[type]
end

function FunctionLottery:MixLotteryRateShow()
  if not self.showMixRate then
    self.showMixRate = GameConfig.Lottery.MixLotteryRateShow == 1
  end
  return self.showMixRate
end

function FunctionLottery:ResetMixShopPurchase()
  self.mix_shop_goods_data = nil
end

function FunctionLottery:SetChooseGroupShopData(data)
  self.chooseGroupShopData = data
end

function FunctionLottery:DoPurchase()
  if not self.mix_shop_goods_data then
    return
  end
  local goods_id = self.mix_shop_goods_data.goodsID
  local goods_price = self:GetPrice(goods_id)
  ServiceItemProxy.Instance:CallBuyMixLotteryItemCmd(goods_id, goods_price)
end

function FunctionLottery:GetGroupidPrice(goods_id)
  local groupId
  local price = self.cache_item_price[goods_id]
  if not price then
    local sData = Table_HeadwearRepair[goods_id]
    local type = sData and sData.Type
    if not type then
      return
    end
    local _lotteryMixConfig = Game.HeadwearRepairTypeTable[type]
    if not _lotteryMixConfig then
      if type ~= LotteryHeadwearType.Wing then
        redlog("GameConfig.MixLottery.LotteryFilter 未配置Type，错误HeadwearRepair ID: ", goods_id)
      end
      return
    end
    price = _lotteryMixConfig.Price
    if not price then
      redlog("GameConfig.MixLottery.LotteryFilter 未配置价格， Type: ", type)
      return
    end
    self.cache_item_price[goods_id] = price
  end
  return price
end

function FunctionLottery:SetCurMixShopGoods(data)
  self.mix_shop_goods_data = data
end

function FunctionLottery:GetPrice(id)
  return self.cache_item_price[id]
end

function FunctionLottery:GetYearMonth(id)
  local staticData = Table_HeadwearRepair[id]
  if staticData then
    local time = staticData.SellTime
    local year, month, day, hour, min, sec = time:match(_Pattern)
    return tonumber(year), tonumber(month), tonumber(day)
  else
  end
end

function FunctionLottery:GetShopSiteFilter()
  if not self.shopSitefilter then
    self.shopSitefilter = {}
    local config = GameConfig.MixLottery.EquipFilter
    for k, _ in pairs(config) do
      self.shopSitefilter[#self.shopSitefilter + 1] = k
    end
    table.sort(self.shopSitefilter)
  end
  return self.shopSitefilter
end

function FunctionLottery.SetDressData(t, array, hash)
  if not LotteryProxy.IsNewLottery(t) then
    return nil
  end
  if not array or not next(array) then
    return nil
  end
  if not hash then
    hash = {}
  else
    _TableClear(hash)
  end
  for i = 1, #array do
    local type = array[i].headwearType
    if type and LotteryDressData.CheckValid(t, type) then
      local real_id = array[i]:GetRealItemID()
      local partIndex = ItemUtil.getItemRolePartIndex(real_id)
      if partIndex ~= 0 then
        local part_data = hash[partIndex]
        if not part_data then
          part_data = LotteryDressData.new(type)
          part_data:SetData(array[i])
          hash[partIndex] = part_data
        else
          part_data:CompareTo(array[i])
        end
      end
    end
  end
  local result = {}
  for k, v in pairs(hash) do
    result[k] = v.equipID
  end
  return result
end

function FunctionLottery:GetGroupIDRateSortID(id)
  local groupId, headwearSortID, rate
  local headwearRepairStaticData = Table_HeadwearRepair[id]
  if headwearRepairStaticData then
    local headwearType = headwearRepairStaticData.Type
    if headwearType then
      groupId = self:GetGroupid(headwearType)
      headwearSortID = LotteryProxy.IsMagicHeadwearType(headwearType) and HeadwearSortID.Magic or HeadwearSortID.Head
    else
      groupId = LotteryProxy.MixCoinGroup
      headwearSortID = HeadwearSortID.Coin
    end
  else
    groupId = LotteryProxy.MixCoinGroup
    headwearSortID = HeadwearSortID.Coin
  end
  rate = self:GetRateByGroup(groupId) * 10000
  return groupId, rate, headwearSortID
end
