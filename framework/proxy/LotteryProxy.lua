autoImport("HeadLotteryData")
autoImport("LotteryMagicData")
autoImport("LotterySpaceTimeData")
autoImport("LotteryRecoverData")
autoImport("LotteryExtraBonusData")
autoImport("LotteryInfoData")
autoImport("LotteryDollData")
autoImport("MixLotteryItemData")
autoImport("LotteryActivityData")
autoImport("LotteryDressData")
autoImport("LotterySeries")
autoImport("LotteryShopSeries")
autoImport("LotteryPrayData")
LotteryProxy = class("LotteryProxy", pm.Proxy)
LotteryProxy.Instance = nil
LotteryProxy.NAME = "LotteryProxy"
LotteryProxy.Invalid_Year = 9999
LotteryProxy.MixCoinGroup = 999
LotteryType = {
  Head = SceneItem_pb.ELotteryType_Head,
  Equip = SceneItem_pb.ELotteryType_Equip,
  Card = SceneItem_pb.ELotteryType_Card,
  Magic = SceneItem_pb.ELotteryType_Magic,
  MagicSec = SceneItem_pb.ELotteryType_Magic_2,
  MagicThird = SceneItem_pb.ELotteryType_Magic_3,
  Mixed = SceneItem_pb.ELotteryType_MIX1,
  MixedSec = SceneItem_pb.ELotteryType_MIX2,
  MixedThird = SceneItem_pb.ELotteryType_MIX3,
  MixedFourth = SceneItem_pb.ELotteryType_MIX4,
  NewMix = SceneItem_pb.ELotteryType_NEW_MIX,
  NewCard = SceneItem_pb.ELotteryType_Card_New,
  NewCard_Activity = SceneItem_pb.ELotteryType_Card_Activity,
  SpaceTime = SceneItem_pb.ELotteryType_SpaceTime or 15
}
LotteryHeadwearType = {
  Magic_Min = 1,
  Fashion = 1,
  Male_Headwear = 2,
  Female_Headwear = 3,
  Scatter = 4,
  Wing = 5,
  Magic_Max = 5,
  Headwear_SSR = 11,
  Headwear_SR = 12,
  Headwear_R = 13
}
local EffectConfig = {}
local _MixLotteryMap = {
  [LotteryType.Mixed] = 1,
  [LotteryType.MixedSec] = 1,
  [LotteryType.MixedThird] = 1,
  [LotteryType.MixedFourth] = 1
}
local _NewMixLotteryMap = {
  [LotteryType.NewMix] = 1
}
local _NewCardMap = {
  [LotteryType.NewCard] = 1,
  [LotteryType.NewCard_Activity] = 1
}
local _CardLottery = {
  [LotteryType.Card] = 1,
  [LotteryType.NewCard] = 1,
  [LotteryType.NewCard_Activity] = 1
}
local _MagicLottery = {
  [LotteryType.Magic] = 1,
  [LotteryType.MagicSec] = 1,
  [LotteryType.MagicThird] = 1
}
local _VarMap = {
  [LotteryType.NewCard] = Var_pb.EACCVARTYPE_LOTTERY_CNT_CARD_NEW,
  [LotteryType.NewCard_Activity] = Var_pb.EACCVARTYPE_LOTTERY_CNT_CARD_ACTIVITY
}
local _ArrayPushBack = TableUtility.ArrayPushBack
local _ArrayClear = TableUtility.ArrayClear
local _TableClear = TableUtility.TableClear
local _CreateTable = ReusableTable.CreateTable
local _DestroyAndClearTable = ReusableTable.DestroyAndClearTable
local _InsertArray = TableUtil.InsertArray
local _HashToArray = TableUtil.HashToArray
local _TEN = 10
local _SortFunc_LotteryAct = function(a, b)
  if a.sortId == b.sortId then
    return a.lotteryType < b.lotteryType
  else
    return a.sortId < b.sortId
  end
end
local _SortFunc_MixShop = function(a, b)
  local a_sortId = a:CheckGot() and 0 or 1
  local b_sortId = b:CheckGot() and 0 or 1
  if a_sortId == b_sortId then
    return a.ShopOrder < b.ShopOrder
  else
    return a_sortId > b_sortId
  end
end
local _SortFunc_NewMixShop = function(a, b)
  local a_unique_period = a.unique_period
  local b_unique_period = b.unique_period
  local a_headwearType = a.headwearType
  local b_headwearType = b.headwearType
  local a_unlockSortId = a.unlockSortId
  local b_unlockSortId = b.unlockSortId
  if a_unlockSortId == b_unlockSortId then
    if a_unique_period == b_unique_period then
      if a_headwearType == b_headwearType then
        return a.goodsID < b.goodsID
      else
        return a_headwearType < b_headwearType
      end
    else
      return a_unique_period > b_unique_period
    end
  else
    return a_unlockSortId < b_unlockSortId
  end
end
local _FilterMixLotteryShop = function(resource, site, quality, onlyNoGet)
  if not resource or not next(resource) then
    return {}
  end
  local result = {}
  local getLimited
  for _, v in pairs(resource) do
    local itemStatic = v:GetItemData().staticData
    local siteLimited = site ~= 0 and itemStatic.Type ~= site
    local qualityLimited = quality ~= 0 and itemStatic.Quality ~= quality
    if onlyNoGet then
      getLimited = v:CheckGoodsGot()
    else
      getLimited = false
    end
    if not siteLimited and not qualityLimited and not getLimited then
      _ArrayPushBack(result, v)
    end
  end
  return result
end

function LotteryProxy:_FilterNewMixLotteryShop(site, onlyNoGet, year)
  local resource = self.mixShopDataList
  if not resource or not next(resource) then
    return {}
  end
  local result = {}
  local getLimited
  for _, v in pairs(resource) do
    local itemStatic = v:GetItemData().staticData
    local siteLimited = site and site ~= 0 and itemStatic.Type ~= site
    if onlyNoGet then
      getLimited = v:CheckGot(true)
    else
      getLimited = false
    end
    local filter_year = v:CheckPurchaseInvalid() and LotteryProxy.Invalid_Year or v.shop_year
    local yearLimited = nil ~= year and year ~= filter_year
    if not siteLimited and not getLimited and not yearLimited then
      _ArrayPushBack(result, v)
    end
  end
  return result
end

function LotteryProxy:HasNewMixLotteryShopData(site, onlyNoGet, year)
  return #self:_FilterNewMixLotteryShop(site, onlyNoGet, year) > 0
end

function LotteryProxy.IsMagicHeadwearType(t)
  return t and t >= LotteryHeadwearType.Magic_Min and t <= LotteryHeadwearType.Magic_Max
end

function LotteryProxy.IsNewCardLottery(type)
  return nil ~= _NewCardMap[type]
end

function LotteryProxy.IsOldMixLottery(t)
  return nil ~= _MixLotteryMap[t]
end

function LotteryProxy.IsNewMixLottery(t)
  return nil ~= _NewMixLotteryMap[t]
end

function LotteryProxy.IsMixLottery(t)
  return LotteryProxy.IsOldMixLottery(t) or LotteryProxy.IsNewMixLottery(t)
end

function LotteryProxy.IsRecoverType(t)
  return LotteryProxy.IsMagicLottery(t) or LotteryType.Head == t
end

function LotteryProxy.IsMagicLottery(t)
  return nil ~= _MagicLottery[t]
end

function LotteryProxy.IsOldCardLottery(t)
  return t == LotteryType.Card
end

function LotteryProxy.IsCardLottery(t)
  return LotteryProxy.IsOldCardLottery(t) or LotteryProxy.IsNewCardLottery(t)
end

function LotteryProxy.IsHeadLottery(t)
  return t == LotteryType.Head
end

function LotteryProxy.IsSpaceTimeLottery(t)
  return t == LotteryType.SpaceTime
end

function LotteryProxy.IsRecoverType(t)
  return LotteryProxy.IsMagicLottery(t) or LotteryType.Head == t
end

function LotteryProxy.IsNewLottery(t)
  return LotteryProxy.IsHeadLottery(t) or LotteryProxy.IsNewCardLottery(t) or LotteryProxy.IsMixLottery(t) or LotteryProxy.IsMagicLottery(t) or LotteryProxy.IsSpaceTimeLottery(t)
end

function LotteryProxy.IsSSR(itemData)
  if itemData == nil then
    return false
  end
  local staticData = itemData.staticData
  if not staticData then
    return false
  end
  local id = staticData.id
  if Table_Card[id] then
    return nil ~= LotteryProxy.Instance.ssrCardMap[id]
  end
  if staticData.Type == 501 then
    return true
  end
  if staticData.Quality >= 4 then
    return true
  end
end

function LotteryProxy.DressTypeFieldName(t)
  if LotteryProxy.IsMagicLottery(t) then
    return "Magic"
  elseif LotteryProxy.IsHeadLottery(t) then
    return "Head"
  elseif LotteryProxy.IsMixLottery(t) then
    return "Mix"
  elseif LotteryProxy.IsSpaceTimeLottery(t) then
    return "SpaceTime"
  end
end

function LotteryProxy.CheckGot(id)
  local _adventureDataProxy = AdventureDataProxy.Instance
  if _adventureDataProxy:IsHeadFashionStored(id, true) then
    return true
  elseif _adventureDataProxy:IsMountGet(id) then
    return true
  elseif _adventureDataProxy:CheckHeadFashionCanStoreByStaticID(id, true) then
    return true
  end
  return false
end

function LotteryProxy.CheckGoodsGroupGot(id)
  return not AdventureDataProxy.Instance:IsFashionNeverDisplay(id, true)
end

function LotteryProxy:ctor(proxyName, data)
  self.proxyName = proxyName or LotteryProxy.NAME
  if LotteryProxy.Instance == nil then
    LotteryProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function LotteryProxy:Init()
  self.lotteryActMap = {}
  self.openingLotteryActs = {}
  self.allLotteryActs = {}
  self.entranceLotteryActs = {}
  self.callTime = {}
  self.infoMap = {}
  self.recvInfo = {}
  self.recoverMap = {}
  self.headwearRecoverMap = {}
  self.filterCardList = {}
  self.extraMap = {}
  self.extraCount = {}
  self.extraBonusProgressMap = {}
  self:InitEquipLottery()
  self.lotteryAlways = {}
  self:PreProcessLotteryActivity()
  self:PreProcessTicket()
  self.freeTypes = {}
  self:ProcessNewCardLotteryDiscountCnt()
  self:InitDailyReward()
  self:InitMix()
  self.ssrCardMap = {}
  self.cardLotteryPrayMap = {}
  self.vipFreeMap = {}
end

function LotteryProxy:CheckForbiddenByNoviceServer(t)
  return FunctionUnLockFunc.CheckForbiddenByFuncState("lottery_forbidden", t)
end

function LotteryProxy:RecordSSRCard(id, item_type)
  if nil ~= id and nil ~= Table_Card[id] and item_type == 2 then
    self.ssrCardMap[id] = 1
  end
end

function LotteryProxy:InitMix()
  self.mixLottery = {}
  self.mixShopGoodsGotCount = 0
  self.mixShopGoodsYearMap = {}
  self.mixShopYearList = {}
  self.mixShopDataList = {}
  self.mixShopGroupMap = {}
  self.mixShopGroupGenderMap = {}
  self.mixShopYearCntMap = {}
  self.seriesMap = {}
  self.shopSeriesMap = {}
end

function LotteryProxy:PreProcessLotteryActivity()
  local config = GameConfig.Lottery.activity
  if not config then
    return
  end
  for k, v in pairs(config) do
    if v.always then
      if not self:CheckForbiddenByNoviceServer() then
        self.lotteryAlways[k] = LotteryActivityData.new(k, true)
      else
        redlog("[Debug初心服]屏蔽常驻扭蛋类型：", k)
      end
    end
  end
end

function LotteryProxy:PreProcessTicket()
  local tickets = GameConfig.Lottery.Ticket
  self.magicLotteryItemMap = {}
  self.lotteryTypesActivityTicket = {}
  self.activityLotteryTickets = {}
  self.lotteryTypesTicket = {}
  for ltype, v in pairs(tickets) do
    if v.itemid then
      if v.itemid == 5800 then
        self.magicLotteryItemMap[#self.magicLotteryItemMap + 1] = ltype
      end
      local types = self.lotteryTypesTicket[v.itemid]
      if not types then
        types = {}
        self.lotteryTypesTicket[v.itemid] = types
      end
      types[#types + 1] = ltype
    end
    if v.actItemId then
      for i = 1, #v.actItemId do
        local actTicketId = v.actItemId[i]
        local lotteryTypes = self.lotteryTypesActivityTicket[actTicketId]
        if not lotteryTypes then
          lotteryTypes = {}
          self.lotteryTypesActivityTicket[actTicketId] = lotteryTypes
        end
        lotteryTypes[#lotteryTypes + 1] = ltype
        local activityLotteryTicket = self.activityLotteryTickets[ltype]
        if not activityLotteryTicket then
          activityLotteryTicket = {}
          self.activityLotteryTickets[ltype] = activityLotteryTicket
        end
        activityLotteryTicket[#activityLotteryTicket + 1] = actTicketId
      end
    end
  end
end

function LotteryProxy:GetLotteryTypeByTicket(id)
  local types = self.lotteryTypesActivityTicket[id]
  if types and next(types) then
    for i = 1, #types do
      if self:IsActOpen(types[i]) then
        return types[i]
      end
    end
  end
  types = self.lotteryTypesTicket[id]
  if types and next(types) then
    for i = 1, #types do
      if self:IsActOpen(types[i]) then
        return types[i]
      end
    end
  end
  return nil
end

function LotteryProxy:GetLimitedTimeTicketNumByLotteryType(t)
  local num = 0
  local _BagProxy = BagProxy.Instance
  local tickets = self.activityLotteryTickets[t]
  local _PackageCheck = GameConfig.PackageMaterialCheck.quench
  if tickets then
    for i = 1, #tickets do
      num = num + _BagProxy:GetItemNumByStaticID(tickets[i], _PackageCheck)
    end
  end
  return num
end

function LotteryProxy:GetAlwaysLottery()
  return self.lotteryAlways
end

function LotteryProxy:CallQueryLotteryInfo(type, force)
  local currentTime = UnityUnscaledTime
  local nextValidTime = self:_GetNextValidTime(type)
  if force or nextValidTime == nil or currentTime >= nextValidTime then
    self:SetNextValidTime(type, 5)
    helplog("CallQueryLotteryInfo: ", type)
    ServiceItemProxy.Instance:CallQueryLotteryInfo(nil, type)
  end
end

function LotteryProxy:CallLottery(lotteryType, year, month, npcId, price, costValue, skipValue, times, free)
  times = times or 1
  local discount
  price, discount = self:GetDiscountByCoinType(lotteryType, AELotteryDiscountData.CoinType.Coin, price * times, year, month)
  if price ~= costValue * times and discount and not discount:IsInActivity() then
    MsgManager.ConfirmMsgByID(25314, function()
      self:sendNotification(LotteryEvent.RefreshCost)
    end)
    return
  end
  if price > MyselfProxy.Instance:GetLottery() and not free then
    MsgManager.ConfirmMsgByID(3551, function()
      GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.PopUpLayer)
      FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
    end)
    return
  end
  local msgID
  if not self:CheckTodayCanBuy(lotteryType, times) then
    if LotteryProxy.IsMixLottery(lotteryType) or LotteryProxy.IsNewCardLottery(lotteryType) then
      msgID = 1 < times and 41459 or 41460
    else
      msgID = 3641
    end
    MsgManager.ShowMsgByID(msgID)
    return
  end
  redlog("ServiceItemProxy lotteryType", lotteryType)
  ServiceItemProxy.Instance:CallLotteryCmd(year, month, npcId, skipValue, price, nil, lotteryType, times, nil, nil, nil, nil, nil, nil, free)
end

function LotteryProxy:UpdateMonthlyVIPCnt(data)
  local t = data.type
  local freeCnt = self.vipFreeMap[t]
  if not freeCnt then
    freeCnt = {}
    self.vipFreeMap[t] = freeCnt
  end
  freeCnt.total = data.card_free_total_cnt
  freeCnt.used = data.card_free_used_cnt
end

function LotteryProxy:GetVipFreeCnt(type)
  local cnt = self.vipFreeMap[type]
  if cnt then
    return cnt.total, cnt.used
  end
  return nil
end

function LotteryProxy:RecvQueryLotteryInfo(servicedata)
  local type = servicedata.type
  helplog("[扭蛋] 打印服务器扭蛋QueryLotteryInfo数据,type ", type)
  TableUtil.Print(servicedata)
  if type == LotteryType.Head then
    self:SetNextValidTime(type, 60)
    if self.infoMap[type] == nil then
      self.infoMap[type] = HeadLotteryData.new()
    end
    self.infoMap[type]:SetData(servicedata)
  end
  self:UpdateMonthlyVIPCnt(servicedata)
  if LotteryProxy.IsMixLottery(type) then
    self:SetMixlotterycnts(servicedata.mixlotterycnts, servicedata.free_cnt)
  end
  local info
  for i = 1, #servicedata.infos do
    info = servicedata.infos[i]
    if type == LotteryType.Equip then
      local data = LotteryData.new(info)
      data:SortItemsByRate()
      self.infoMap[type] = data
    elseif LotteryProxy.IsMagicLottery(type) then
      local data = LotteryMagicData.new(info, type)
      self.infoMap[type] = data
    elseif type == LotteryType.Card then
      local data = LotteryData.new(info)
      data:SortItemsByQuality()
      self.infoMap[type] = data
    elseif LotteryProxy.IsSpaceTimeLottery(type) then
      local data = LotterySpaceTimeData.new(info, type)
      self.infoMap[type] = data
    end
  end
  if LotteryProxy.IsNewCardLottery(type) and servicedata.infos[1] then
    local data = LotteryData.new(servicedata.infos[1])
    for i = 2, #servicedata.infos do
      local info = servicedata.infos[i]
      if info then
        data:AddItems(info.subInfo)
      end
    end
    data:SortItemsByLotteryId()
    self.infoMap[type] = data
  end
  info = self.infoMap[type]
  if not info then
    return
  end
  info:SetTodayCount(servicedata.today_cnt, servicedata.max_cnt)
  info:SetTodayExtraCount(servicedata.today_extra_cnt, servicedata.max_extra_cnt)
  info:SetOnceMaxCount(servicedata.once_max_cnt)
  info:SetTodayTenCount(servicedata.today_ten_cnt, servicedata.max_ten_cnt)
  info:SetFreeCount(servicedata.free_cnt)
  if servicedata.safetyinfo and info.SetSafetyInfo then
    info:SetSafetyInfo(servicedata.safetyinfo)
  end
  helplog("RecvQueryLotteryInfo 单次抽取最大次数 | 今日十连次数 | 今日十连上限 | 免费次数 ", servicedata.once_max_cnt, servicedata.today_ten_cnt, servicedata.max_ten_cnt, servicedata.free_cnt)
end

function LotteryProxy:CheckTenLottery(t)
  if LotteryProxy.IsMixLottery(t) then
    return true
  end
  local data = self.infoMap[t]
  if data then
    return data.onceMaxCount == _TEN
  end
end

function LotteryProxy:RecvLotteryCmd(data)
  self.lotteryAction = false
  local lotteryType = data.type
  local npcRole = SceneCreatureProxy.FindCreature(data.npcid)
  local isSelf = data.charid == Game.Myself.data.id
  local effectConfig = EffectConfig[lotteryType]
  if isSelf then
    local infoData = LotteryInfoData.new(data)
    self.recvInfo[#self.recvInfo + 1] = infoData
    if infoData:IsCoin() then
      local info = self.infoMap[lotteryType]
      if info ~= nil then
        info:SetTodayCount(data.today_cnt)
        info:SetTodayExtraCount(data.today_extra_cnt)
        info:SetTodayTenCount(data.today_ten_cnt)
        if data.free then
          info:SetFreeCount(0)
        end
      end
      if LotteryProxy.IsMixLottery(lotteryType) and data.free then
        self.mixFreeCnt = 0
      end
    end
    if data.skip_anim then
      self:ShowFloatAward()
      return
    end
  elseif self.isOpenView then
    return
  end
  if LotteryProxy.IsNewLottery(lotteryType) then
    if not isSelf then
      return
    end
    self:sendNotification(LotteryEvent.NewLotteryAnimationStart)
    TimeTickManager.Me():CreateOnceDelayTick(GameConfig.Delay.lottery, function(owner, deltaTime)
      self:sendNotification(LotteryEvent.NewLotteryAnimationEnd)
      self:ShowFloatAward()
    end, self)
    return
  end
  if npcRole then
    if LotteryProxy.IsNewCardLottery(lotteryType) then
      self:sendNotification(LotteryEvent.RecvLotteryCardNewResult)
      TimeTickManager.Me():CreateOnceDelayTick(GameConfig.Delay.lottery, function(owner, deltaTime)
        self:ShowFloatAward()
      end, self)
    else
      local actionId = 200
      if effectConfig ~= nil and effectConfig.ActionId ~= nil then
        actionId = effectConfig.ActionId
      end
      self:PlayAction(npcRole, actionId)
      local effectName
      if effectConfig ~= nil and effectConfig.Effect ~= nil then
        effectName = effectConfig.Effect
      end
      if effectName ~= nil then
        if self.effect then
          self.effect:Destroy()
          self.effect = nil
        end
        self.effect = npcRole:PlayEffect(nil, effectName, 0, nil, nil, true)
        if self.effect ~= nil then
          self.effect:RegisterWeakObserver(self)
        end
      end
      local audioName
      if effectConfig ~= nil and effectConfig.Audio ~= nil then
        audioName = effectConfig.Audio
      end
      if audioName then
        npcRole:PlayAudio(audioName)
      end
      if isSelf then
        self:DelayedShowLotteryAward(npcRole, effectConfig)
      else
        self:RemoveOtherLT()
        self.otherLT = TimeTickManager.Me():CreateOnceDelayTick(GameConfig.Delay.lottery, function(owner, deltaTime)
          self:PlayIdleAction(npcRole, effectConfig)
          self:RemoveOtherLT()
        end, self)
      end
    end
  elseif isSelf then
    self:ShowFloatAward()
  end
end

function LotteryProxy:ObserverDestroyed(obj)
  if obj == self.effect then
    self.effect = nil
  end
end

function LotteryProxy:PlayAction(npc, actionId)
  if npc ~= nil and actionId ~= nil then
    local actionName
    local config = Table_ActionAnime[actionId]
    if config ~= nil then
      actionName = config.Name
    end
    if actionName ~= nil then
      npc:Client_PlayAction(actionName, nil, false)
    end
  end
end

function LotteryProxy:SetLotteryBuyCnt(c, t)
  self.today_cnt = c
  self.max_cnt = t
end

function LotteryProxy:GetLotteryBuyCnt()
  if not self.today_cnt then
    return 0, 0
  end
  return self.today_cnt, self.max_cnt
end

function LotteryProxy:PlayIdleAction(npcRole, effectConfig)
  local idleActionId
  if effectConfig ~= nil and effectConfig.IdleActionId ~= nil then
    idleActionId = effectConfig.IdleActionId
  end
  if idleActionId ~= nil then
    self:PlayAction(npcRole, idleActionId)
  end
end

function LotteryProxy:DelayedShowLotteryAward(npcRole, effectConfig)
  self:sendNotification(LotteryEvent.EffectStart)
  TimeTickManager.Me():CreateOnceDelayTick(GameConfig.Delay.lottery, function(owner, deltaTime)
    self:ShowFloatAward()
    if npcRole then
      self:PlayIdleAction(npcRole, effectConfig)
    end
    self:sendNotification(LotteryEvent.EffectEnd)
  end, self)
end

function LotteryProxy:HandleEscRecvinfo()
  if #self.recvInfo > 0 then
    table.remove(self.recvInfo, 1)
  end
end

function LotteryProxy:ShowFloatAward()
  if #self.recvInfo == 0 then
    return
  end
  local infoData = self.recvInfo[1]
  local list = infoData.itemList
  if #list == 0 then
    table.remove(self.recvInfo, 1)
    return
  end
  local count = infoData.count
  if count == 10 or count == 11 then
    table.remove(self.recvInfo, 1)
    local viewdata = {}
    viewdata.list = list
    viewdata.count = count
    if infoData:IsCoin() and not GameConfig.Lottery.ForbidLotteryAgain then
      local price = math.floor(self:GetCost(infoData.lotteryType, 10, infoData.year, infoData.month))
      viewdata.btnText = string.format(ZhString.Lottery_LotteryAgain, price)
      
      function viewdata.btnCallback()
        local dont = LocalSaveProxy.Instance:GetDontShowAgain(43262)
        if dont == nil then
          MsgManager.DontAgainConfirmMsgByID(43262, function()
            self:LotteryAgain(infoData, 10)
          end, nil, nil, price)
        else
          self:LotteryAgain(infoData, 10)
        end
      end
    end
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.LotteryResultView,
      viewdata = viewdata
    })
    return
  end
  local item = list[1]
  if infoData:IsCoin() then
    table.remove(self.recvInfo, 1)
    local args = _CreateTable()
    args.disableMsg = true
    args.closeWhenClickOtherPlace = true
    if not GameConfig.Lottery.ForbidLotteryAgain then
      args.quickCloseAnimation = true
      local total, used = LotteryProxy.Instance:GetVipFreeCnt(infoData.lotteryType)
      if total and used and used < total then
        args.leftBtnRichText = string.format(ZhString.Lottery_MonthlyVIP_FreeCnt_Format, used, total)
        
        function args.leftBtnCallback()
          self:LotteryAgain(infoData, 1, true)
        end
      else
        local cost = self:GetCost(infoData.lotteryType, 1, infoData.year, infoData.month)
        args.leftBtnRichText = string.format(ZhString.Lottery_LotteryAgain, cost)
        
        function args.leftBtnCallback()
          MsgManager.DontAgainConfirmMsgByID(43262, function()
            self:LotteryAgain(infoData, 1)
          end, nil, nil, cost)
        end
      end
    end
    FloatAwardView.addItemDatasToShow(list, args)
    FloatAwardView.ForceNewShare()
    _DestroyAndClearTable(args)
  else
    self:ShowNormalAward(list)
  end
  self:ShowAwardCount(item)
end

function LotteryProxy:LotteryAgain(infoData, times, free)
  local lotteryType = infoData.lotteryType
  local price = self:GetCost(lotteryType, times, infoData.year, infoData.month) / times
  self:CallLottery(lotteryType, infoData.year, infoData.month, infoData.npcId, price, price, true, times, free)
end

function LotteryProxy:ShowNormalAward(list)
  local args = _CreateTable()
  args.disableMsg = true
  FloatAwardView.addItemDatasToShow(list, args)
  FloatAwardView.ForceNewShare()
  _DestroyAndClearTable(args)
  table.remove(self.recvInfo, 1)
end

function LotteryProxy:RemoveOtherLT()
  if self.otherLT ~= nil then
    self.otherLT:Destroy()
    self.otherLT = nil
  end
end

function LotteryProxy:SetNextValidTime(type, time)
  type = type or 1
  self.callTime[type] = UnityUnscaledTime + time
end

function LotteryProxy:_GetNextValidTime(type)
  type = type or 1
  return self.callTime[type]
end

function LotteryProxy:GetInfo(type)
  return self.infoMap[type]
end

function LotteryProxy:HasFreeCnt(type)
  local cnt = self:GetFreeCnt(type)
  return 0 < cnt, cnt
end

function LotteryProxy:HasVipFreeCnt(type)
  if not NewRechargeProxy.Ins:AmIMonthlyVIP() then
    return false
  end
  local total, used = self:GetVipFreeCnt(type)
  if total and used and 0 < total and used < total then
    return true
  end
  return false
end

function LotteryProxy:CheckHasFree(type)
  return self:HasFreeCnt(type) or self:HasVipFreeCnt(type)
end

function LotteryProxy:GetFreeCnt(type)
  local checkRoleLevel = GameConfig.Lottery.FreeLevelLimit and GameConfig.Lottery.FreeLevelLimit[type]
  if checkRoleLevel and checkRoleLevel > MyselfProxy.Instance:RoleLevel() then
    return 0
  end
  if LotteryProxy.IsMixLottery(type) then
    return self:GetMixFreeCnt()
  else
    local data = self:GetInfo(type)
    if data then
      return data.freeCount or 0
    end
    return 0
  end
end

function LotteryProxy:GetMonthGroupId(year, month)
  if year and month then
    local id
    if 1 <= month and month <= 6 then
      id = 1
    elseif 7 <= month and month <= 12 then
      id = 2
    end
    return year * 10 + id
  end
  return nil
end

function LotteryProxy:GetHeadLottery()
  return self.infoMap[LotteryType.Head]
end

function LotteryProxy:GetInitializedDressData(t)
  if LotteryProxy.IsHeadLottery(t) then
    local data = self:GetHeadLottery()
    if data then
      return data:GetInitializedDressData()
    end
  elseif LotteryProxy.IsMagicLottery(t) or LotteryProxy.IsSpaceTimeLottery(t) then
    local data = self.infoMap[t]
    if data then
      return data:GetInitializedDressData()
    end
  elseif LotteryProxy.IsMixLottery(t) then
    return self.mixDressMap
  end
end

function LotteryProxy:GetHeadLotteryFilter()
  local info = self:GetHeadLottery()
  if info then
    return info:GetYearFilter()
  end
end

function LotteryProxy:IsHeadWearSingleMonth()
  local info = self:GetHeadLottery()
  if info then
    return info.isSingleMonth
  end
  return false
end

function LotteryProxy:GetHeadLotteryMonthFilter(year)
  local info = self:GetHeadLottery()
  if info then
    return info:GetMonthFilter(year)
  end
end

function LotteryProxy:GetHeadLotteryFreeCount()
  local info = self:GetHeadLottery()
  if info then
    return info.freeCount or 0
  end
  return 0
end

function LotteryProxy:GetConfigVipFreeCnt(t)
  if not self.vipLotteryType then
    self.vipLotteryType = {}
    local staticData = Table_DepositFunction[25]
    local param = staticData and staticData.Argument and staticData.Argument.param
    if param then
      local check = param.check
      local result = param.result
      if check and result then
        for i = 1, #check do
          self.vipLotteryType[check[i]] = result
        end
      end
    end
  end
  return self.vipLotteryType[t]
end

function LotteryProxy:GetHeadLotteryData(year, month)
  local info = self:GetHeadLottery()
  if not info then
    return
  end
  return info:GetLotteryData(year, month)
end

function LotteryProxy:GetData(type, year, month)
  local info = self.infoMap[type]
  if info ~= nil then
    local groupId = self:GetMonthGroupId(year, month)
    local monthGroupData = info:GetMonthGroupById(groupId)
    if monthGroupData ~= nil then
      return monthGroupData:GetData(year, month)
    end
  end
end

function LotteryProxy:GetRecover(type)
  if self.recoverMap[type] == nil then
    self.recoverMap[type] = {}
  else
    _ArrayClear(self.recoverMap[type])
  end
  if type == LotteryType.Head then
    self.recoverMap[type] = self:GetFixedHeadwearRecover()
  else
    local lotteryData = self.infoMap[type]
    if lotteryData ~= nil then
      local items = BagProxy.Instance:GetMainBag():GetItems()
      self:CheckAddItems(type, lotteryData, items, true)
      local walletsitems = BagProxy.Instance:GetwalletBagData(3, false, 1)
      self:CheckAddItems(type, lotteryData, walletsitems, true)
      local furnitureItems = BagProxy.Instance:GetFurnitureBag():GetItems()
      self:CheckAddItems(type, lotteryData, furnitureItems, true)
    end
  end
  return self.recoverMap[type]
end

function LotteryProxy:CheckAddItems(type, lotteryData, items, addFixed)
  if not (type and lotteryData) or not items then
    return
  end
  local staticId
  local cacheBagItemMap = {}
  local _BagProxy = BagProxy.Instance
  local _Table_HeadwearRepair = Table_HeadwearRepair
  for i = 1, #items do
    local bagData = items[i]
    local isFavorite = _BagProxy:CheckIsFavorite(bagData)
    if not isFavorite and _BagProxy:CheckIfFavoriteCanBeMaterial(bagData) ~= false then
      staticId = bagData.staticData.id
      local lotteryItemData
      if type == LotteryType.Head then
        lotteryItemData = self:GetLotteryItemDataFromHeadList(staticId, lotteryData:GetAllLotteryDataList())
      else
        lotteryItemData = lotteryData:GetLotteryItemData(staticId)
      end
      if lotteryItemData ~= nil and lotteryItemData.recoverPrice ~= 0 then
        local data = LotteryRecoverData.new(bagData:Clone())
        data:SetInfo(lotteryItemData, type)
        _ArrayPushBack(self.recoverMap[type], data)
        cacheBagItemMap[staticId] = 1
      end
      if addFixed then
        local repairConfig = _Table_HeadwearRepair[staticId]
        if nil == cacheBagItemMap[staticId] and repairConfig and repairConfig.IsHeadwear == 2 and repairConfig.Price and repairConfig.Price ~= _EmptyTable then
          local priceConfig = repairConfig.Price
          for i = 1, #priceConfig do
            local recoverData = LotteryRecoverData.new(bagData:Clone())
            local lotteryItemInfo = {
              recoverItemid = priceConfig[i][1],
              recoverPrice = priceConfig[i][2]
            }
            recoverData:SetInfo(lotteryItemInfo, type)
            _ArrayPushBack(self.recoverMap[type], recoverData)
          end
        end
      end
    end
  end
end

function LotteryProxy:GetFixedHeadwearRecover()
  if self.headwearRecoverMap == nil then
    self.headwearRecoverMap = {}
  else
    _ArrayClear(self.headwearRecoverMap)
  end
  local items = BagProxy.Instance:GetMainBag():GetItems()
  self:_AddFixedHeadLotterywearRecoverData(items)
  local walletsitems = BagProxy.Instance:GetwalletBagData(3, false, 1)
  self:_AddFixedHeadLotterywearRecoverData(walletsitems)
  local furnitureItems = BagProxy.Instance:GetFurnitureBag():GetItems()
  self:_AddFixedHeadLotterywearRecoverData(furnitureItems)
  return self.headwearRecoverMap
end

function LotteryProxy:_AddFixedHeadLotterywearRecoverData(items)
  if not items then
    return
  end
  local _Table_HeadwearRepair = Table_HeadwearRepair
  local _BagProxy = BagProxy.Instance
  for i = 1, #items do
    local item = items[i]
    if _BagProxy:CheckIfFavoriteCanBeMaterial(item) ~= false then
      local headwearRepairConfig = _Table_HeadwearRepair[item.staticData.id]
      if headwearRepairConfig and headwearRepairConfig.IsHeadwear == 1 and headwearRepairConfig.Price and headwearRepairConfig.Price ~= _EmptyTable then
        local priceConfig = headwearRepairConfig.Price
        for i = 1, #priceConfig do
          local data = LotteryRecoverData.new(item:Clone())
          local lotteryItemData = {
            recoverItemid = priceConfig[i][1],
            recoverPrice = priceConfig[i][2]
          }
          data:SetInfo(lotteryItemData, LotteryType.Head)
          _ArrayPushBack(self.headwearRecoverMap, data)
        end
      end
    end
  end
end

function LotteryProxy:GetLotteryItemDataFromHeadList(itemid, list)
  for i = 1, #list do
    local data = list[i]:GetLotteryItemData(itemid)
    if data ~= nil then
      return data
    end
  end
  return nil
end

function LotteryProxy:GetDiscountByCoinType(lotteryType, cointype, price, year, month)
  local discount = ActivityEventProxy.Instance:GetLotteryDiscountByCoinType(lotteryType, cointype, year, month)
  if discount ~= nil and price ~= nil then
    price = math.floor(price * (discount:GetDiscount() / 100))
  end
  return price, discount
end

function LotteryProxy:GetRecoverTotalPrice(selectList, type)
  local total = 0
  local recoverList = self.recoverMap[type]
  if recoverList then
    for i = 1, #selectList do
      for j = 1, #recoverList do
        local recover = recoverList[j]
        if selectList[i] == recover.itemData.id then
          total = total + recover:GetCost()
          break
        end
      end
    end
  end
  return total
end

function LotteryProxy:GetRecoverTotalCost(selectList, type)
  local total = 0
  local recoverDataList = self.recoverMap[type]
  if recoverDataList then
    for i = 1, #selectList do
      for j = 1, #recoverDataList do
        if selectList[i] == recoverDataList[j].itemData.id then
          total = total + recoverDataList[j]:GetTotalCost()
          break
        end
      end
    end
  end
  return total
end

function LotteryProxy:GetRecoverPriceMap(selectList, type)
  local priceMap = {}
  local recoverDataList = self.recoverMap[type]
  if recoverDataList then
    for i = 1, #selectList do
      for j = 1, #recoverDataList do
        local id = selectList[i]
        local itemid = recoverDataList[j].costItem
        local singleCost = recoverDataList[j]:GetTotalCost()
        if id == recoverDataList[j].itemData.id then
          local cost = priceMap[itemid]
          if not cost then
            priceMap[itemid] = singleCost
          else
            priceMap[itemid] = cost + singleCost
          end
        end
      end
    end
  end
  return priceMap
end

function LotteryProxy:GetHeadwearRepairRecover(selectList)
  local recoverList = {}
  if self.headwearRecoverMap then
    for i = 1, #selectList do
      for j = 1, #self.headwearRecoverMap do
        local recover = self.headwearRecoverMap[j]
        if selectList[i] == recover.itemData.id then
          if not recoverList[recover.costItem] then
            recoverList[recover.costItem] = recover:GetTotalCost()
          else
            recoverList[recover.costItem] = recoverList[recover.costItem] + recover:GetTotalCost()
          end
        end
      end
    end
  end
  return recoverList
end

function LotteryProxy:GetHeadwearRecoverTotalPrice(selectList)
  local total = 0
  local recoverList = self.headwearRecoverMap
  if recoverList then
    for i = 1, #selectList do
      for j = 1, #recoverList do
        local recover = recoverList[j]
        if selectList[i] == recover.itemData.id then
          total = total + recover:GetCost()
          break
        end
      end
    end
  end
  return total
end

function LotteryProxy:GetRecoverData(type, id)
  local recoverList = self.recoverMap[type]
  if recoverList then
    for i = 1, #recoverList do
      if id == recoverList[i].itemData.id then
        return recoverList[i]
      end
    end
  end
end

function LotteryProxy:GetHeadwearRecoverData(id)
  local recoverList = self.headwearRecoverMap
  if recoverList then
    local recover
    for i = 1, #recoverList do
      recover = recoverList[i]
      if id == recover.itemData.id then
        xdlog("指定可回收头饰", id)
        return recover
      end
    end
  end
end

function LotteryProxy:FilterCard(quality)
  local info = self.infoMap[LotteryType.Card]
  if info == nil then
    return nil
  end
  _ArrayClear(self.filterCardList)
  local timecheck_func = ItemUtil.CheckCardCanLotteryByTime
  local items = info.items
  if quality == 0 then
    for i = 1, #items do
      local data = items[i]
      local item = data:GetItemData()
      if timecheck_func(item.staticData.id) then
        _ArrayPushBack(self.filterCardList, data)
      end
    end
  else
    for i = 1, #items do
      local data = info.items[i]
      local item = data:GetItemData()
      if item.staticData and item.staticData.Quality == quality and timecheck_func(item.staticData.id) then
        _ArrayPushBack(self.filterCardList, data)
      end
    end
  end
  table.sort(self.filterCardList, LotteryData.SortItemByQuality)
  return self.filterCardList
end

local LOTTERY_TO_SKIP_TYPE_MAP

function LotteryProxy:GetSkipType(lotteryType)
  if not LOTTERY_TO_SKIP_TYPE_MAP then
    LOTTERY_TO_SKIP_TYPE_MAP = {
      [LotteryType.Head] = SKIPTYPE.LotteryHeadwear,
      [LotteryType.Equip] = SKIPTYPE.LotteryEquip,
      [LotteryType.Card] = SKIPTYPE.LotteryCard,
      [LotteryType.Magic] = SKIPTYPE.LotteryMagic,
      [LotteryType.MagicSec] = SKIPTYPE.LotteryMagicSec,
      [LotteryType.MagicThird] = SKIPTYPE.LotteryMagicThird,
      [LotteryType.Mixed] = SKIPTYPE.LotteryMixed,
      [LotteryType.MixedSec] = SKIPTYPE.LotteryMixedSec,
      [LotteryType.MixedThird] = SKIPTYPE.LotteryMixedThird,
      [LotteryType.MixedFourth] = SKIPTYPE.LotteryMixedFourth,
      [LotteryType.NewMix] = SKIPTYPE.LotteryNewMixed,
      [LotteryType.NewCard] = SKIPTYPE.LotteryCard_New,
      [LotteryType.NewCard_Activity] = SKIPTYPE.LotteryCard_New,
      [LotteryType.SpaceTime] = SKIPTYPE.LotterySpaceTime
    }
  end
  local skipType = LOTTERY_TO_SKIP_TYPE_MAP[lotteryType]
  if skipType then
    return skipType
  end
  return nil
end

function LotteryProxy:IsSkipGetEffect(type)
  if type ~= nil then
    return LocalSaveProxy.Instance:GetSkipAnimation(type)
  end
end

function LotteryProxy:ProcessNewCardLotteryDiscountCnt()
  self.newCardDisountCntMap = {}
  local card_config = GameConfig.Lottery.CardLottery
  if not card_config then
    return
  end
  local priceMap
  for t, v in pairs(card_config) do
    priceMap = v.CardNewPrice
    local discount_cnt = 0
    for cnt, _ in pairs(priceMap) do
      if cnt > discount_cnt then
        discount_cnt = cnt
      end
    end
    self.newCardDisountCntMap[t] = discount_cnt - 1
  end
end

local _AccMap = {
  [31] = Var_pb.EACCVARTYPE_LOTTERY_CNT_CARD_NEW,
  [32] = Var_pb.EACCVARTYPE_LOTTERY_CNT_CARD_ACTIVITY
}

function LotteryProxy:CheckNewCardDiscountValid(t)
  local todayCnt = MyselfProxy.Instance:GetAccVarValueByType(_AccMap[t]) or 0
  local maxDiscountCnt = self:GetNewCardDiscountCnt(t)
  return todayCnt < maxDiscountCnt
end

function LotteryProxy:GetNewCardDiscountCnt(t)
  return self.newCardDisountCntMap[t] or 0
end

function LotteryProxy:SetIsOpenView(isOpen)
  self.isOpenView = isOpen
end

function LotteryProxy:GetSpecialEquipCount(selectList, type)
  local isExist = false
  local totalTicket = 0
  local recoverList = self.recoverMap[type]
  if recoverList then
    for i = 1, #selectList do
      for j = 1, #recoverList do
        local recover = recoverList[j]
        if selectList[i] == recover.itemData.id and ShopMallProxy.Instance:JudgeSpecialEquip(recover.itemData) then
          isExist = true
          totalTicket = totalTicket + recover.specialCost
          break
        end
      end
    end
  end
  return isExist, totalTicket
end

function LotteryProxy:GetSpecialHeadwearEquipCount(selectList)
  local isExist = false
  local totalTicket = 0
  local recoverList = self.headwearRecoverMap
  if recoverList then
    for i = 1, #selectList do
      for j = 1, #recoverList do
        local recover = recoverList[j]
        if selectList[i] == recover.itemData.id and ShopMallProxy.Instance:JudgeSpecialEquip(recover.itemData) then
          isExist = true
          totalTicket = totalTicket + recover.specialCost * recover.selectCount
          break
        end
      end
    end
  end
  return isExist, totalTicket
end

function LotteryProxy:CheckTodayCanBuy(type, times)
  if BranchMgr.IsChina() and LotteryProxy.IsMixLottery(type) then
    if times == 1 then
      return self.mixTodayCount < self.mixMaxCount
    else
      return self.mixTodayTenCount < self.mixTenMaxCount
    end
  end
  local info = self.infoMap[type]
  if info ~= nil then
    if info.maxCount == 0 then
      return true
    end
    if times == 1 then
      return info.todayCount + times <= info.maxCount
    elseif times == 10 then
      if info.maxTenCount == 0 then
        return true
      end
      return info.todayTenCount + 1 <= info.maxTenCount
    end
  end
  return true
end

function LotteryProxy:DownloadMagicPicFromUrl(picUrl)
  local urlFileName = string.match(picUrl, ".+/([^/]*%.%w+)$")
  local sb = LuaStringBuilder.CreateAsTable()
  sb:Append(IOPathConfig.Paths.PUBLICPIC.LotteryPicture)
  sb:Append("/")
  sb:Append(urlFileName)
  local localPath = sb:ToString()
  if localPath then
    local currentTime = math.floor(ServerTime.CurServerTime() / 1000)
    local bytes = DiskFileManager.Instance:LoadFile(localPath, currentTime)
    if bytes then
      local localMd5 = MyMD5.HashBytes(bytes)
      local urlMd5 = string.match(picUrl, ".+/([^/]*)%.%w+$")
      if urlMd5 == localMd5 then
        sb:Destroy()
        return bytes
      end
    end
    sb:Clear()
    sb:Append(ApplicationHelper.persistentDataPath)
    sb:Append("/TempDownloadLottery/")
    local tempPath = sb:ToString()
    FileHelper.CreateDirectory(tempPath)
    sb:Destroy()
    tempPath = tempPath .. urlFileName
    if tempPath then
      if FileHelper.ExistFile(tempPath) then
        FileHelper.DeleteFile(tempPath)
      end
      do
        local funcOnProgress = function(progress)
        end
        local funcOnSuccess = function()
          local bytes = FileHelper.LoadFile(tempPath)
          local currentTime = math.floor(ServerTime.CurServerTime() / 1000)
          DiskFileManager.Instance:SaveFile(localPath, bytes, currentTime)
          FileHelper.DeleteFile(tempPath)
          self:sendNotification(LotteryEvent.MagicPictureComplete, {picUrl = picUrl, bytes = bytes})
          EventManager.Me():PassEvent(LotteryEvent.MagicPictureComplete, {picUrl = picUrl, bytes = bytes})
        end
        local funcOnFail = function(errorMessage)
          if FileHelper.ExistFile(tempPath) then
            FileHelper.DeleteFile(tempPath)
          end
        end
        if FunctionCloudFile.IsActive() then
          FunctionCloudFile.Me():Download(picUrl, tempPath, false, funcOnProgress, function(isSuccess, errorMessage)
            if isSuccess then
              funcOnSuccess()
            else
              funcOnFail(errorMessage)
            end
          end)
        else
          do
            local taskRecordID = CloudFile.CloudFileManager.Ins:Download(picUrl, tempPath, false, funcOnProgress, funcOnSuccess, funcOnFail, nil)
          end
        end
      end
    end
  end
end

function LotteryProxy:LoadFromLocal(picUrl)
  local urlFileName = string.match(picUrl, ".+/([^/]*%.%w+)$")
  local sb = LuaStringBuilder.CreateAsTable()
  sb:Append(IOPathConfig.Paths.PUBLICPIC.LotteryPicture)
  sb:Append("/")
  sb:Append(urlFileName)
  local localPath = sb:ToString()
  sb:Destroy()
  if localPath then
    local currentTime = math.floor(ServerTime.CurServerTime() / 1000)
    local bytes = DiskFileManager.Instance:LoadFile(localPath, currentTime)
    if bytes then
      local localMd5 = MyMD5.HashBytes(bytes)
      local urlMd5 = string.match(picUrl, ".+/([^/]*)%.%w+$")
      if urlMd5 == localMd5 then
        return bytes
      end
    end
  end
end

function LotteryProxy.SortEquipLottery(a, b)
  local alevel, blevel = a.Level, b.Level
  return alevel[1] < b.Level[1]
end

function LotteryProxy:InitEquipLottery()
  if not Table_EquipLottery then
    return
  end
  self.equipLottery_Map = {}
  for _, data in pairs(Table_EquipLottery) do
    local itemid = data.ItemId
    if not self.equipLottery_Map[itemid] then
      self.equipLottery_Map[itemid] = {}
    end
    table.insert(self.equipLottery_Map[itemid], data)
  end
  for _, datas in pairs(self.equipLottery_Map) do
    table.sort(datas, LotteryProxy.SortEquipLottery)
  end
end

function LotteryProxy:GetEquipLotteryShowDatas(itemid)
  if self.equipLottery_Map == nil then
    return
  end
  local config = self.equipLottery_Map[itemid]
  if config then
    local mylevel = MyselfProxy.Instance:RoleLevel()
    local index
    for i = 1, #config do
      local level_regin = config[i].Level
      if mylevel >= level_regin[1] and mylevel <= level_regin[2] then
        index = i
        break
      end
    end
    if index then
      return config[index], config[index + 1]
    end
  end
end

function LotteryProxy:IsLotteryEquip(itemid)
  if self.equipLottery_Map == nil then
    return false
  end
  return self.equipLottery_Map[itemid] ~= nil
end

function LotteryProxy:ShowAwardCount(itemData)
  local itemType = itemData.staticData.Type
  local isCountShow = itemType == 800 or itemType == 810 or itemType == 830 or itemType == 840 or itemType == 850 or itemType == 501
  if itemData and isCountShow then
    local itemId = itemData.staticData.id
    local itemFind = BagProxy.Instance:GetItemByGuid(itemData.id)
    local itemTotalCount = BagProxy.Instance:GetAllItemNumByStaticID(itemId)
    local carCount = BagProxy.Instance:GetItemNumByStaticID(itemId, BagProxy.BagType.Barrow)
    itemTotalCount = itemTotalCount + carCount
    local adventureCheckId = itemId
    local equipData = Table_Equip[itemId]
    if equipData and equipData.GroupID then
      adventureCheckId = equipData.GroupID
    end
    if AdventureDataProxy.Instance:IsFashionStored(adventureCheckId) then
      itemTotalCount = itemTotalCount + 1
    end
    if not itemFind then
      itemTotalCount = itemTotalCount + 1
    end
    if 1 < itemTotalCount then
      FloatAwardView.showHaveCount(itemTotalCount)
    else
      FloatAwardView.hideHaveCount()
    end
  else
    FloatAwardView.hideHaveCount()
  end
end

function LotteryProxy.CheckPocketLotteryEnabled()
  return GameConfig.Lottery.IsCarry == 1
end

function LotteryProxy:SetPocketLotteryViewShowing(isShowing)
  self.isPocketLotteryViewShowing = isShowing
end

function LotteryProxy:IsPocketLotteryViewShowing()
  return self.isPocketLotteryViewShowing or false
end

function LotteryProxy:GetPocketLotteryActivityInfo()
  if not LotteryProxy.CheckPocketLotteryEnabled() then
    return nil
  end
  return self.pocketLotteryActivityMap
end

function LotteryProxy:RecvQueryLotteryExtraBonusItemCmd(data)
  if not data.etype then
    return
  end
  self.extraCount[data.etype] = data.lotterycount or 0
  if data.extrabonus then
    local receivedbonus = self.extraBonusProgressMap[data.etype] or {}
    TableUtility.ArrayClear(receivedbonus)
    for i = 1, #data.extrabonus do
      table.insert(receivedbonus, data.extrabonus[i])
    end
    table.sort(receivedbonus)
    self.extraBonusProgressMap[data.etype] = receivedbonus
  end
end

function LotteryProxy:RecvQueryLotteryExtraBonusCfgCmd(data)
  if not data.etype then
    return
  end
  if data.extrabonus and #data.extrabonus > 0 then
    self.extraMap[data.etype] = LotteryExtraBonusData.new(data.extrabonus, data.etype)
  end
end

function LotteryProxy:GetCurrentExtraStageByType(lotteryType)
  local extradata = self.extraMap[lotteryType]
  if extradata then
    local receivedbonus = self.extraBonusProgressMap[lotteryType] or {}
    if #receivedbonus == 0 then
      return extradata:GetCurrentStage(0)
    else
      return extradata:GetCurrentStage(receivedbonus[#receivedbonus])
    end
  end
end

function LotteryProxy:GetCurrentExtraCount(lotteryType)
  return self.extraCount[lotteryType]
end

function LotteryProxy:GetSpaceTimeLotteryData()
  local info = self.infoMap[LotteryType.SpaceTime]
  if info ~= nil then
    return info.items
  end
  return _EmptyTable
end

function LotteryProxy:FilterMagic(type, filterType)
  local info = self.infoMap[type]
  if info ~= nil then
    local filterMagicList = info:FilterMagic(filterType)
    return filterMagicList
  end
  return _EmptyTable
end

function LotteryProxy:_CheckFilterCondition(condition, itemid)
  if condition == nil then
    return true
  end
  if condition == "Unlock" then
    local id = itemid
    local equip = Table_Equip[id]
    if equip and equip.GroupID then
      id = equip.GroupID
    end
    if not AdventureDataProxy.Instance:IsFashionOrMountUnlock(id) then
      return true
    end
  end
  return false
end

function LotteryProxy:GetMaxExtraCount(lotteryType)
  local extradata = self.extraMap[lotteryType]
  return extradata and extradata:GetMaxCount() or 0
end

function LotteryProxy:CheckReceive(lotteryType, id)
  local receivedbonus = self.extraBonusProgressMap[lotteryType]
  if receivedbonus and id then
    for k, v in pairs(receivedbonus) do
      if id == v then
        return true
      end
    end
  end
  return false
end

function LotteryProxy:GetExtraBonusList(lotteryType)
  local extradata = self.extraMap[lotteryType]
  return extradata and extradata:GetDataList()
end

function LotteryProxy:GetKeyList(lotteryType)
  local extradata = self.extraMap[lotteryType]
  return extradata and extradata:GetKeyList() or _EmptyTable
end

function LotteryProxy:CheckCanUseTicket()
  for i = 1, #self.magicLotteryItemMap do
    if self.lotteryActMap[self.magicLotteryItemMap[i]] then
      return true
    end
  end
  return false
end

function LotteryProxy:SetMixlotterycnts(serverCntData, free_cnt)
  self.mixFreeCnt = free_cnt or 0
  for i = 1, #serverCntData do
    if serverCntData[i].etype == SceneItem_pb.EMIXLOTTERY_USECOIN_ONCE then
      self.mixTodayCount = serverCntData[i].today_cnt
      self.mixMaxCount = serverCntData[i].max_cnt
    elseif serverCntData[i].etype == SceneItem_pb.ECOINLOTTERY_TYPE_TENCOMBOS then
      self.mixTodayTenCount = serverCntData[i].today_cnt
      self.mixTenMaxCount = serverCntData[i].max_cnt
    end
  end
  if self.mixLottery and nil ~= next(self.mixLottery) then
    for groupId, tabDataList in pairs(self.mixLottery) do
      local ungetCount = 0
      for i = 1, #tabDataList do
        if not tabDataList[i]:CheckGoodsGroupGot() then
          ungetCount = ungetCount + 1
        end
      end
      FunctionLottery.Me():UpdateUngetCnt(groupId, ungetCount)
    end
  end
end

function LotteryProxy:GetMixFreeCnt()
  return self.mixFreeCnt or 0
end

function LotteryProxy:GetMixCnts()
  return self.mixTodayCount, self.mixMaxCount, self.mixTodayTenCount, self.mixTenMaxCount
end

function LotteryProxy:HandleRecvMixLotteryArchiveCmd(serverData)
  if not serverData then
    return
  end
  local init = serverData.data_index == 0
  local last = serverData.last_data == true
  if init then
    self.recvLotteryType = serverData.type
    self.recvIsNewMix = LotteryProxy.IsNewMixLottery(self.recvLotteryType)
    self.mixLotteryPrice = serverData.price or 0
    self.mixLotteryOnceMaxCount = serverData.once_max_cnt or 10
    _TableClear(self.mixLottery)
    _TableClear(self.mixShopGoodsYearMap)
  end
  _TableClear(self.seriesMap)
  _TableClear(self.shopSeriesMap)
  self.seriesUnGotPeriods = {}
  for i = 1, #serverData.groups do
    local group = serverData.groups[i]
    local serverItems = group.items
    local groupId = group.groupid
    local grouprate = self.recvIsNewMix and FunctionLottery.Me():GetRateByGroup(groupId) or group.grouprate
    local itemData = {}
    local ungetCount = 0
    for j = 1, #serverItems do
      local mixLotteryItemData = MixLotteryItemData.new(self.recvLotteryType, groupId, grouprate, serverItems[j])
      if self.recvIsNewMix then
        if mixLotteryItemData:InPool() then
          itemData[#itemData + 1] = mixLotteryItemData
          self:SetSeriesData(mixLotteryItemData)
          if not mixLotteryItemData:CheckGoodsGroupGot() then
            ungetCount = ungetCount + 1
          end
        end
        if mixLotteryItemData:InShop() then
          self:SetShopSeries(mixLotteryItemData)
          local year = mixLotteryItemData.shop_year
          local goods = self.mixShopGoodsYearMap[year]
          if not goods then
            goods = {}
            self.mixShopGoodsYearMap[year] = goods
          end
          _ArrayPushBack(goods, mixLotteryItemData)
        end
      else
        itemData[#itemData + 1] = mixLotteryItemData
        self:SetSeriesData(mixLotteryItemData)
        if not mixLotteryItemData:CheckGoodsGroupGot() then
          ungetCount = ungetCount + 1
        end
      end
    end
    if self.recvIsNewMix then
      table.sort(itemData, MixLotteryItemData.NewMixSortFunc)
    else
      table.sort(itemData, MixLotteryItemData.SortFunc)
      FunctionLottery.Me():SetRate(group, grouprate)
    end
    FunctionLottery.Me():UpdateUngetCnt(groupId, ungetCount)
    local groupItems = self.mixLottery[groupId]
    if not groupItems then
      groupItems = {}
      self.mixLottery[groupId] = groupItems
    end
    for i = 1, #itemData do
      _ArrayPushBack(groupItems, itemData[i])
    end
  end
  if last then
    for _, v in pairs(self.seriesMap) do
      v:Sort()
    end
    FunctionLottery.Me():ResetMixFilterData()
    self:ResetMixLotteryList(self.recvLotteryType)
    if self.recvIsNewMix then
      self:SetMixDressData()
      self:ResetMixShopData()
    end
  end
end

function LotteryProxy:SetSeriesData(data)
  local period = data.unique_period
  if not period or period == 0 then
    return
  end
  local seriesData = self.seriesMap[period]
  if not seriesData then
    seriesData = LotterySeries.new(period, data)
    self.seriesMap[period] = seriesData
  end
  seriesData:Add(data)
end

function LotteryProxy:SetShopSeries(data)
  local period = data.unique_period
  if not period or period == 0 then
    return
  end
  if not data.headwearRepairStaticData then
    return
  end
  local seriesData = self.shopSeriesMap[period]
  if not seriesData then
    seriesData = LotteryShopSeries.new(period, data)
    self.shopSeriesMap[period] = seriesData
  end
  seriesData:Add(data)
end

function LotteryProxy:GetYearMonthGotCount(year, month)
  local series = {}
  local got_cnt_result, cnt_result = 0, 0
  local cnt, all_cnt
  for k, v in pairs(self.shopSeriesMap) do
    if v:MatchYearMonth(year, month) then
      cnt, all_cnt = v:GetCount()
      got_cnt_result, cnt_result = got_cnt_result + cnt, cnt_result + all_cnt
    end
  end
  return got_cnt_result, cnt_result
end

function LotteryProxy:SetMixDressData()
  self.seriesMapIncludeFashion = {}
  for k, v in pairs(self.seriesMap) do
    if v:HasFashion() then
      self.seriesMapIncludeFashion[k] = v
      if not v:IsFashionGot() then
        self.seriesUnGotPeriods[k] = 1
      end
    end
  end
  self.mixDressMap = {}
  local seriesMap = nil == next(self.seriesUnGotPeriods) and self.seriesMapIncludeFashion or self.seriesUnGotPeriods
  local periodList = {}
  for period, _ in pairs(seriesMap) do
    _ArrayPushBack(periodList, period)
  end
  local periodCount = #periodList
  if periodCount < 1 then
    return
  end
  local random_period_index = math.random(1, periodCount)
  local random_period = periodList[random_period_index]
  local randomSeries = self.seriesMap[random_period]
  local random_fashion = randomSeries:GetRandomFashion()
  self.mixDressMap[Asset_Role.PartIndex.Body] = EquipInfo.GetDisplayBody(random_fashion:GetRealItemID())
end

function LotteryProxy:ResetMixShopData()
  _ArrayClear(self.mixShopDataList)
  _TableClear(self.mixShopGroupMap)
  _TableClear(self.mixShopGroupGenderMap)
  _ArrayClear(self.mixShopYearList)
  _TableClear(self.mixShopYearCntMap)
  self.mixShopGoodsCnt = 0
  self.mixShopGoodsGotCount = 0
  self.allGot = true
  for year, array in pairs(self.mixShopGoodsYearMap) do
    _ArrayPushBack(self.mixShopYearList, year)
    table.sort(array, function(a, b)
      if a.genderSortId == b.genderSortId then
        return a.goodsID < b.goodsID
      else
        return a.genderSortId < b.genderSortId
      end
    end)
  end
  table.sort(self.mixShopYearList, function(a, b)
    return b < a
  end)
  self.mixShopYearCntMap[LotteryProxy.Invalid_Year] = {total = 0, got = 0}
  for i = 1, #self.mixShopYearList do
    local year = self.mixShopYearList[i]
    local goods = self.mixShopGoodsYearMap[year]
    self.mixShopYearCntMap[year] = {total = 0, got = 0}
    for j = 1, #goods do
      local groupid = goods[j].group_id
      local got
      if groupid then
        local groupData = self.mixShopGroupMap[groupid]
        if not groupData then
          groupData = {}
          self.mixShopGroupMap[groupid] = groupData
          _ArrayPushBack(groupData, goods[j])
          _ArrayPushBack(self.mixShopDataList, goods[j])
          self:_SetGotCount(year, goods[j])
        else
          _ArrayPushBack(groupData, goods[j])
        end
      else
        _ArrayPushBack(self.mixShopDataList, goods[j])
        self:_SetGotCount(year, goods[j])
      end
    end
  end
  for _, list in pairs(self.mixShopGroupMap) do
    table.sort(list, function(a, b)
      return a.goodsID < b.goodsID
    end)
  end
  if self:HasNewMixLotteryShopData(nil, true, LotteryProxy.Invalid_Year) then
    self.allGot = false
  end
end

function LotteryProxy:_SetGotCount(year, goods)
  local get = goods:CheckGoodsGroupGot(true)
  if not get then
    self.allGot = false
  end
  if not goods:CheckPurchaseInvalid() then
    if get then
      self.mixShopYearCntMap[year].got = self.mixShopYearCntMap[year].got + 1
      self.mixShopGoodsGotCount = self.mixShopGoodsGotCount + 1
    end
    self.mixShopYearCntMap[year].total = self.mixShopYearCntMap[year].total + 1
    self.mixShopGoodsCnt = self.mixShopGoodsCnt + 1
  else
    local _Invalid_Year = LotteryProxy.Invalid_Year
    if get then
      self.mixShopYearCntMap[_Invalid_Year].got = self.mixShopYearCntMap[_Invalid_Year].got + 1
    end
    self.mixShopYearCntMap[_Invalid_Year].total = self.mixShopYearCntMap[_Invalid_Year].total + 1
  end
end

function LotteryProxy:GetHeadByFashion(data)
  local period = data and data.unique_period
  if not period then
    return
  end
  local seriesData = self.seriesMap[period]
  if seriesData then
    return seriesData:GetHeadByFashion(data:GetRealItemID())
  end
end

function LotteryProxy:GetGoodsByGender(id, sex)
  if self.mixShopGroupGenderMap[id] and self.mixShopGroupGenderMap[id][sex] then
    return self.mixShopGroupGenderMap[id][sex]
  end
  local list = self.mixShopGroupMap[id]
  if nil ~= list and nil ~= next(list) then
    if nil == self.mixShopGroupGenderMap[id] then
      self.mixShopGroupGenderMap[id] = {}
    end
    for i = 1, #list do
      local equip_id = list[i].goodsID
      local sex_equip = Table_Equip[equip_id] and Table_Equip[equip_id].SexEquip or 1
      if sex_equip == sex then
        local data = self.mixShopGroupGenderMap[id][sex_equip]
        if not data then
          data = {}
          self.mixShopGroupGenderMap[id][sex_equip] = data
        end
        _ArrayPushBack(data, list[i])
      end
    end
  end
  return self.mixShopGroupGenderMap[id][sex]
end

function LotteryProxy:GetShopGoodsYears()
  local result = {}
  for k, v in pairs(self.mixShopYearCntMap) do
    if v.total > 0 then
      result[#result + 1] = k
    end
  end
  table.sort(result, function(a, b)
    return b < a
  end)
  return result
end

function LotteryProxy:CalcValidYear(site, year)
  if self.allGot then
    return nil
  end
  if self:HasNewMixLotteryShopData(site, true, year) then
    return year
  end
  local curIndex = 1
  local yearList = self.mixShopYearList
  for i = 1, #yearList do
    if yearList[i] == year then
      curIndex = i
      break
    end
  end
  for i = curIndex, #yearList do
    if self:HasNewMixLotteryShopData(site, true, yearList[i]) then
      return yearList[i]
    end
  end
  for i = curIndex, 1, -1 do
    if self:HasNewMixLotteryShopData(site, true, yearList[i]) then
      return yearList[i]
    end
  end
  if self:HasNewMixLotteryShopData(site, true, LotteryProxy.Invalid_Year) then
    return LotteryProxy.Invalid_Year
  end
  return nil
end

function LotteryProxy:GetShopGoodsProcessByYear(year)
  return self.mixShopYearCntMap and self.mixShopYearCntMap[year]
end

function LotteryProxy:ResetMixLotteryList(t)
  if nil == self.mixLotteryList then
    self.mixLotteryList = {}
  else
    _ArrayClear(self.mixLotteryList)
  end
  for _, datas in pairs(self.mixLottery) do
    _InsertArray(self.mixLotteryList, datas)
  end
  table.sort(self.mixLotteryList, MixLotteryItemData.SortFunc)
end

local filter = {}

function LotteryProxy.GetLotteryFilter(config)
  _ArrayClear(filter)
  for k, v in pairs(config) do
    table.insert(filter, k)
  end
  table.sort(filter)
  return filter
end

local filterResult, filterData = {}

function LotteryProxy:FilterMixLottery(group, onlyNoGet, maunal)
  if group == 0 then
    filterData = self.mixLotteryList
  else
    filterData = self.mixLottery and self.mixLottery[group]
  end
  if not filterData then
    return {}
  end
  local getLimited
  _ArrayClear(filterResult)
  for i = 1, #filterData do
    if onlyNoGet then
      getLimited = v:CheckGoodsGot()
    else
      getLimited = false
    end
    if not getLimited then
      _ArrayPushBack(filterResult, filterData[i])
    end
  end
  if maunal and not onlyNoGet then
    table.sort(filterResult, MixLotteryItemData.SortFunc)
  end
  return filterResult
end

function LotteryProxy:FilterMixLotteryShop(type, site, quality, onlyNoGet)
  _ArrayClear(filterResult)
  local staticData = FunctionLottery.Me():GetMixStaticData(type)
  if not staticData then
    return {}
  end
  local shopConfig = ShopProxy.Instance:GetConfigByTypeId(staticData.ShopType, staticData.ShopID)
  filterResult = _FilterMixLotteryShop(shopConfig, site, quality, onlyNoGet)
  return filterResult
end

function LotteryProxy:FilterNewMixLotteryShop(site, onlyNoGet)
  _ArrayClear(filterResult)
  filterResult = self:_FilterNewMixLotteryShop(site, onlyNoGet)
  table.sort(filterResult, function(a, b)
    return _SortFunc_NewMixShop(a, b)
  end)
  local _series
  for i = 1, #filterResult do
    _series = filterResult[i].unique_id
    filterResult[i]:SetSeriesFlag(tempSeries ~= _series)
    if tempSeries ~= _series then
      tempSeries = _series
    end
  end
  return filterResult
end

function LotteryProxy:RecvLotteryActivityNtf(infoList)
  redlog("-------------------------RecvLotteryActivityNtf")
  TableUtil.Print(infoList)
  self.hasLotteryEntrance = nil
  TableUtility.TableClear(self.lotteryActMap)
  local isJp = BranchMgr.IsJapan()
  for i = 1, #infoList do
    local t = infoList[i].type
    if not self:CheckForbiddenByNoviceServer(t) then
      if LotteryProxy.IsNewLottery(t) then
        self.lotteryActMap[t] = LotteryActivityData.new(infoList[i].type, infoList[i].open, infoList[i].starttime, infoList[i].endtime)
        if not self.hasLotteryEntrance and self.lotteryActMap[t]:CheckIsInEntrance() and self.lotteryActMap[t].open and not isJp then
          self.hasLotteryEntrance = true
        end
      end
    else
      redlog("[Debug初心服] 屏蔽扭蛋类型：", t)
    end
  end
  self:HandleLotteryActivityNtf()
end

function LotteryProxy:HandleLotteryActivityNtf()
  _ArrayClear(self.allLotteryActs)
  _HashToArray(self.lotteryActMap, self.allLotteryActs)
  _HashToArray(self.lotteryAlways, self.allLotteryActs)
  table.sort(self.allLotteryActs, _SortFunc_LotteryAct)
  _ArrayClear(self.openingLotteryActs)
  local lotteryActivityConfig = GameConfig.Lottery.activity
  for i = 1, #self.allLotteryActs do
    if self.allLotteryActs[i].open and lotteryActivityConfig[self.allLotteryActs[i].lotteryType] then
      _ArrayPushBack(self.openingLotteryActs, self.allLotteryActs[i])
    end
  end
  self:_setEntranceLotteryActs()
end

function LotteryProxy:_setEntranceLotteryActs()
  _ArrayClear(self.entranceLotteryActs)
  if self.hasLotteryEntrance then
    for i = 1, #self.openingLotteryActs do
      if self.openingLotteryActs[i]:CheckIsInEntrance() then
        _ArrayPushBack(self.entranceLotteryActs, self.openingLotteryActs[i])
      end
    end
  end
end

function LotteryProxy:CheckHasLotteryEntrance()
  return self.hasLotteryEntrance == true
end

function LotteryProxy:GetAllActiveLottery()
  return self.allLotteryActs
end

function LotteryProxy:IsOpen(type)
  local acts = self.openingLotteryActs
  if not acts then
    return false
  end
  for i = 1, #acts do
    if acts[i].lotteryType == type then
      return true
    end
  end
  return false
end

function LotteryProxy:IsActOpen(t)
  for i = 1, #self.allLotteryActs do
    if self.allLotteryActs[i].open and self.allLotteryActs[i].lotteryType == t then
      return true
    end
  end
  return false
end

function LotteryProxy:GetOpenActivityLottery()
  return self.openingLotteryActs
end

function LotteryProxy:GetEntranceLotteryActs()
  return self.entranceLotteryActs
end

function LotteryProxy:GetActivityLotteryData()
  return self.curLotteryActivityData
end

function LotteryProxy:SetCurNewLottery(t)
  self.curNewLotteryType = t
  if t then
    self.curLotteryActivityData = self.lotteryActMap[t] or self.lotteryAlways[t]
  else
    self.curLotteryActivityData = nil
  end
end

function LotteryProxy:CheckLotteryOpen(t)
  if not self.lotteryActMap and not self.lotteryAlways then
    return false
  end
  local data = self.lotteryActMap[t] or self.lotteryAlways[t]
  if not data then
    return false
  end
  return data.open == true
end

function LotteryProxy:GetNextLottery(forword)
  local list = self:GetOpenActivityLottery()
  if not next(list) or not self.curNewLotteryType then
    return
  end
  local index
  for i = 1, #list do
    if list[i].lotteryType == self.curNewLotteryType then
      index = i
      break
    end
  end
  if not index then
    return
  end
  if forword then
    if index >= #list then
      return list[1]
    else
      return list[index + 1]
    end
  elseif index <= 1 then
    return list[#list]
  else
    return list[index - 1]
  end
end

function LotteryProxy:GetLotteryHeadIds()
  return self.lotteryHeadIds
end

function LotteryProxy:HandleLotteryHeadItem(data)
  if not data then
    return
  end
  self.lotteryHeadIds = self.lotteryHeadIds or {}
  _ArrayClear(self.lotteryHeadIds)
  for i = 1, #data do
    _ArrayPushBack(self.lotteryHeadIds, data[i])
  end
end

function LotteryProxy:RecvLotteryBannerInfo(infoList)
  self.lotteryBanner = self.lotteryBanner or {}
  local open, ltype, starttime
  for i = 1, #infoList do
    open = infoList[i].open
    ltype = infoList[i].type
    starttime = infoList[i].starttime
    if ltype then
      if open then
        redlog("ltype", ltype, starttime)
        self.lotteryBanner[ltype] = starttime
      else
        self.lotteryBanner[ltype] = 0
      end
    end
  end
end

local DateStr = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"

function LotteryProxy:GetBannerList()
  if not self.bannerList then
    self.bannerList = {}
  else
    TableUtility.ArrayClear(self.bannerList)
  end
  local validDate, validEnd = "", ""
  if self.lotteryBanner then
    local BannerConfig = GameConfig.LotteryBanner
    for lotterytype, starttime in pairs(self.lotteryBanner) do
      if 0 < starttime then
        local typeConfig = BannerConfig[lotterytype]
        if typeConfig then
          for i = 1, #typeConfig do
            if EnvChannel.IsReleaseBranch() then
              validDate = typeConfig[i].ValidDate
              validEnd = typeConfig[i].EndDate
            elseif EnvChannel.IsTFBranch() then
              validDate = typeConfig[i].TFValidDate
              validEnd = typeConfig[i].TFEndDate
            end
            if not StringUtil.IsEmpty(validDate) and not StringUtil.IsEmpty(validEnd) and self.freeTypes[lotterytype] then
              local year, month, day, hour, min, sec = validDate:match(DateStr)
              local startDate = os.time({
                day = day,
                month = month,
                year = year,
                hour = hour,
                min = min,
                sec = sec
              })
              year, month, day, hour, min, sec = validEnd:match(DateStr)
              local endData = os.time({
                day = day,
                month = month,
                year = year,
                hour = hour,
                min = min,
                sec = sec
              })
              if starttime >= startDate and starttime < endData then
                local single = {}
                single.type = lotterytype
                single.styleID = typeConfig[i].styleID
                single.validDate = validDate
                single.validEnd = validEnd
                table.insert(self.bannerList, single)
              end
            end
          end
        end
      end
    end
  end
  table.sort(self.bannerList, function(a, b)
    return a.styleID > b.styleID
  end)
  return self.bannerList
end

function LotteryProxy:CanShow()
  if not self.lotteryBanner then
    redlog("CanShow false")
    return false
  end
  local bList = self:GetBannerList()
  if not bList or #bList == 0 then
    redlog("CanShow false")
    return false
  end
  local freeFlag = false
  for ltype, v in pairs(self.freeTypes) do
    local dont = LocalSaveProxy.Instance:GetBannerDontShowAgain(ltype)
    redlog("ltype", ltype, show)
    if not dont then
      redlog("CanShow false")
      return true
    end
  end
  redlog("CanShow false")
  return false
end

local deltaday = 86400

function LotteryProxy:IsSameDay(timestampOld, timestampNew)
  local offset = (5 - ServerTime.SERVER_TIMEZONE) * 60 * 60
  return timestampNew - offset - (timestampOld - offset) < deltaday
end

function LotteryProxy:GetCardByItemtype(lotterytype, itemtype)
  local info = self.infoMap[lotterytype]
  if info == nil then
    return nil
  end
  _ArrayClear(self.filterCardList)
  local timecheck_func = ItemUtil.CheckCardCanLotteryByTime
  local items = info.items
  if itemtype == 0 then
    for i = 1, #items do
      local data = items[i]
      local item = data:GetItemData()
      if timecheck_func(item.staticData.id) then
        _ArrayPushBack(self.filterCardList, data)
      else
        redlog("not in time")
      end
    end
  else
    for i = 1, #items do
      local data = info.items[i]
      local item = data:GetItemData()
      if data.itemType and data.itemType == itemtype then
        if timecheck_func(item.staticData.id) then
          _ArrayPushBack(self.filterCardList, data)
        else
          redlog("not in time")
        end
      end
    end
  end
  return self.filterCardList
end

local CardConfig = GameConfig.Lottery.CardLottery

function LotteryProxy:CalculteCardCost(tp, count, times)
  if not tp or not CardConfig[tp] then
    return nil
  end
  local priceConfig = CardConfig[tp].CardNewPrice
  local priceList = {}
  for cnt, prc in pairs(priceConfig) do
    table.insert(priceList, {count = cnt, price = prc})
  end
  table.sort(priceList, function(l, r)
    return l.count < r.count
  end)
  local usedCount, amount = 1, 0
  for i = 1, times do
    amount = amount + self:GetCurrentCardCost(count + usedCount, times, priceList)
    usedCount = usedCount + 1
  end
  return amount
end

function LotteryProxy:GetCurrentCardCost(currentTime, times, priceList)
  local lastPrice = priceList[1].price
  for i = 1, #priceList do
    if currentTime < priceList[i].count then
      return lastPrice
    else
      lastPrice = priceList[i].price
    end
  end
  if times < currentTime then
    return lastPrice
  end
  return lastPrice
end

function LotteryProxy:GetUpDuration(lotterytype)
  local info = self.infoMap[lotterytype]
  if not info then
    return nil
  end
  return info:GetUpDuration()
end

function LotteryProxy:RecvLotteryDataSyncItemCmd(data)
  if data and data.free_types then
    TableUtility.TableClear(self.freeTypes)
    for i = 1, #data.free_types do
      self.freeTypes[data.free_types[i]] = true
      redlog("free_types", data.free_types[i])
    end
  end
end

function LotteryProxy:HandleSyncCardLotteryPray(server_data)
  redlog("--------------------------------------HandleSyncCardLotteryPray")
  TableUtil.Print(server_data)
  if not server_data then
    return
  end
  local t = server_data.lotterytype
  local prayData = self.cardLotteryPrayMap[t]
  if not prayData then
    prayData = LotteryPrayData.new(t)
    self.cardLotteryPrayMap[t] = prayData
  end
  prayData:ResetData(server_data)
end

function LotteryProxy:GetCardUpData(type)
  if not LotteryProxy.IsCardLottery(type) then
    return
  end
  local data = self.infoMap[type]
  if not data then
    return
  end
  return data:GetUpData() or {}
end

function LotteryProxy:GetCardPrayData(t)
  return self.cardLotteryPrayMap[t]
end

function LotteryProxy:CheckCardLotteryPrayOpen(t)
  local pray_data = self.cardLotteryPrayMap[t]
  if pray_data then
    return pray_data:IsOpen()
  end
  return false
end

function LotteryProxy:GetPrayInfo(t)
  local pray_data = self.cardLotteryPrayMap[t]
  if pray_data then
    return pray_data:GetPrayInfo()
  end
  return nil
end

local _sortDailyFunc = function(l, r)
  return l.Day < r.Day
end

function LotteryProxy:InitDailyReward()
  self.syncDailyRewardMap = {}
  self.curDailyRewardMap = {}
  self:InitStaticDailyReward()
end

function LotteryProxy:InitStaticDailyReward()
  self.staticDaily = {}
  self.staticActivityID2LotteryType = {}
  self.staticDailyBetterDay = {}
  local actID
  for _, cfg in pairs(Table_LotteryDailyReward) do
    actID = cfg.ActivityID
    if nil == self.staticDailyBetterDay[actID] then
      self.staticDailyBetterDay[actID] = {}
    end
    if not self.staticDaily[actID] then
      self.staticDaily[actID] = {}
      local lotteryTypeMap = {}
      for i = 1, #cfg.LotteryType do
        lotteryTypeMap[cfg.LotteryType[i]] = 1
      end
      self.staticActivityID2LotteryType[actID] = lotteryTypeMap
    end
    _ArrayPushBack(self.staticDaily[actID], cfg)
    if cfg.BetterDay and cfg.BetterDay == 1 then
      _ArrayPushBack(self.staticDailyBetterDay[actID], cfg)
    end
  end
  for _, configList in pairs(self.staticDaily) do
    table.sort(configList, _sortDailyFunc)
  end
  for _, list in pairs(self.staticDailyBetterDay) do
    table.sort(list, _sortDailyFunc)
  end
end

function LotteryProxy:GetStaticDailyReward(activityid, day)
  local list = self.staticDaily[activityid]
  if list then
    return list[day]
  end
end

function LotteryProxy:AddDailyReward(activityid, endtime)
  self.curDailyRewardMap[activityid] = endtime
end

function LotteryProxy:RemoveDailyReward(activityid)
  self.curDailyRewardMap[activityid] = nil
end

function LotteryProxy:GetDailyRewardEndTime(id)
  return self.curDailyRewardMap[id]
end

function LotteryProxy:GetCurDailyLotteryActID()
  return self.curDailyLotteryActID
end

function LotteryProxy:TryGetDailyReward(lottery_type)
  self.rewardDay, self.rewardTime = nil, nil
  for actid, _ in pairs(self.curDailyRewardMap) do
    local typeMap = self.staticActivityID2LotteryType[actid]
    if nil ~= typeMap[lottery_type] then
      self.rewardDay, self.rewardTime = self:GetSyncDailyRewardData(actid)
      local day = self.rewardTime == 0 and 1 or self.rewardDay
      self:_SetDailyLotteryReward(actid, day)
      self.curDailyLotteryActID = actid
      break
    end
  end
  return self.rewardDay, self.rewardTime
end

function LotteryProxy:RecvLotteryDailyRewardSyncItem(data)
  local rewards = data.dailyrewards
  if not rewards then
    return
  end
  for i = 1, #rewards do
    self:_updateDailyReward(rewards[i])
  end
end

function LotteryProxy:GetDailyRewardDayLength(id)
  return #self.staticDaily[id]
end

function LotteryProxy:_updateDailyReward(reward)
  local id, rewardDay, rewardTime = reward.activityid, reward.rewardday, reward.rewardtime
  local intervalDay
  local maxDay = self:GetDailyRewardDayLength(id)
  rewardDay = rewardDay >= maxDay and 1 or rewardDay + 1
  local data = self.syncDailyRewardMap[id]
  if data then
    data[1] = rewardDay
    data[2] = rewardTime
  else
    self.syncDailyRewardMap[id] = {rewardDay, rewardTime}
  end
end

function LotteryProxy:GetSyncDailyRewardData(id)
  local data = self.syncDailyRewardMap[id]
  if data then
    return data[1], data[2]
  else
    return 1, 0
  end
end

function LotteryProxy:GetNearlyBetterDay(id)
  if not self.rewardDay then
    return
  end
  local list = self.staticDailyBetterDay[id]
  if not list or not next(list) then
    return
  end
  if list[#list].Day == self.rewardDay then
    return list[1], list[1].Day + 1
  else
    for i = 1, #list do
      if list[i].Day > self.rewardDay then
        return list[i], list[i].Day - self.rewardDay + 1
      end
    end
  end
end

function LotteryProxy:_SetDailyLotteryReward(id, day)
  local config = self:GetStaticDailyReward(id, day)
  if config then
    self.nextItemData = ItemData.new("nextDailyReward", config.ItemID)
    self.nextItemData:SetItemNum(config.ItemCount)
  end
  local bestRewardConfig
  bestRewardConfig, self.betteryIntervalDay = self:GetNearlyBetterDay(id)
  if bestRewardConfig then
    self.bestItemData = ItemData.new("bestDailyReward", bestRewardConfig.ItemID)
    self.bestItemData:SetItemNum(bestRewardConfig.ItemCount)
  end
end

function LotteryProxy:GetDailyRewardItemData()
  return self.nextItemData, self.bestItemData
end

function LotteryProxy:GetCost(lotteryType, times, year, month)
  if times == 1 then
    local hasFreeCnt = self:CheckHasFree(lotteryType)
    if hasFreeCnt then
      return 0
    end
  end
  local cost = 0
  if LotteryProxy.IsMixLottery(lotteryType) then
    cost = self.mixLotteryPrice
  elseif LotteryProxy.IsNewCardLottery(lotteryType) then
    local todayCount = MyselfProxy.Instance:GetAccVarValueByType(_VarMap[lotteryType]) or 0
    return self:CalculteCardCost(lotteryType, todayCount, times)
  end
  local data = self:GetInfo(lotteryType)
  if data then
    if LotteryProxy.IsHeadLottery(lotteryType) then
      local head = data:GetLotteryData(year, month)
      if head then
        cost = head.price
      end
    else
      cost = data.price
    end
  end
  cost = self:GetDiscountByCoinType(lotteryType, AELotteryDiscountData.CoinType.Coin, cost, year, month)
  return cost * times
end
