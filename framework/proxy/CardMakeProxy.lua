autoImport("CardRandomMakeData")
autoImport("CardMakeData")
CardMakeProxy = class("CardMakeProxy", pm.Proxy)
CardMakeProxy.Instance = nil
CardMakeProxy.NAME = "CardMakeProxy"
CardMakeProxy.MakeType = {
  Random = SceneItem_pb.EEXCHANGECARDTYPE_DRAW,
  Compose = SceneItem_pb.EEXCHANGECARDTYPE_COMPOSE,
  Decompose = SceneItem_pb.EEXCHANGECARDTYPE_DECOMPOSE,
  BossCompose = SceneItem_pb.EEXCHANGECARDTYPE_BOSSCOMPOSE,
  MvpCardCompose = SceneItem_pb.EEXCHANGECARDTYPE_MVPCOMPOSE,
  DungeonMvpCardCompose = SceneItem_pb.EEXCHANGECARDTYPE_MVPCOMPOSE_2
}
local tempList = {}
local filter = {}
local _getCardList = {}
local _getItemList = {}
local packageCheck = GameConfig.PackageMaterialCheck.exchange
local _ArrayPushBack = TableUtility.ArrayPushBack
local _ArrayClear = TableUtility.ArrayClear
local _CreateTable = ReusableTable.CreateTable
local _DestroyAndClearTable = ReusableTable.DestroyAndClearTable
local CheckInvalid = function(id)
  if Table_FuncState[138] and 0 ~= TableUtility.ArrayFindIndex(Table_FuncState[138].ItemID, id) and not FunctionUnLockFunc.checkFuncStateValid(138) then
    return true
  end
  if Table_FuncState[118] and 0 ~= TableUtility.ArrayFindIndex(Table_FuncState[118].ItemID, id) and not FunctionUnLockFunc.checkFuncStateValid(118) then
    return true
  end
  return false
end

function CardMakeProxy:ctor(proxyName, data)
  self.proxyName = proxyName or CardMakeProxy.NAME
  if CardMakeProxy.Instance == nil then
    CardMakeProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function CardMakeProxy:Init()
  self.randomCardList = {}
  self.filterRandomCardList = {}
  self.chooseRandomCardList = {}
  self.randomGetList = {}
  self.filterCardList = {}
  self.decomposeCardList = {}
  self.filterDecomposeCardList = {}
  self.bosscomposelist = {}
  self.filterbosscomposelist = {}
  self.bossRateUpCards = {}
  self.mvpcomposelist = {}
  self.filtermvpcomposelist = {}
  self.mvpRateUpCards = {}
  self.dungeonMvpComposeList = {}
  self.filterDungeonMvpComposeList = {}
  self.dungeonMvpRateUpCards = {}
  self.cardConfig = {
    [self.MakeType.Random] = {
      name = EffectMap.Maps.Randomcard,
      audio = AudioMap.Maps.Randomcard,
      skipType = SKIPTYPE.CardRandomMake,
      tabIndex = 1700
    },
    [self.MakeType.Compose] = {
      name = EffectMap.Maps.Compoundcard,
      audio = AudioMap.Maps.Compoundcard,
      skipType = SKIPTYPE.CardMake,
      tabIndex = 1701
    },
    [self.MakeType.Decompose] = {
      name = EffectMap.Maps.Randomcard,
      audio = AudioMap.Maps.Randomcard,
      skipType = SKIPTYPE.CardDecompose,
      tabIndex = 1702
    },
    [self.MakeType.BossCompose] = {
      name = EffectMap.Maps.Compoundcard,
      audio = AudioMap.Maps.Compoundcard,
      skipType = SKIPTYPE.BossCardCompose,
      tabIndex = 1703
    },
    [self.MakeType.MvpCardCompose] = {
      name = EffectMap.Maps.Compoundcard,
      audio = AudioMap.Maps.Compoundcard,
      skipType = SKIPTYPE.MvpCardCompose,
      tabIndex = 1704
    },
    [self.MakeType.DungeonMvpCardCompose] = {
      name = EffectMap.Maps.Compoundcard,
      audio = AudioMap.Maps.Compoundcard,
      skipType = SKIPTYPE.DungeonMvpCardCompose,
      tabIndex = 1705
    }
  }
end

function CardMakeProxy:RecvExchangeCardItemCmd(data)
  self.npcid = data.npcid
  local npcRole = SceneCreatureProxy.FindCreature(data.npcid)
  local isSelf = data.charid == Game.Myself.data.id
  local config = self.cardConfig[data.type]
  self.cardTabIndex = config.tabIndex
  if isSelf and self:IsSkipGetEffect(config.skipType) then
    self:ShowAward(data.cardid, data.items)
    return
  end
  if isSelf then
    self:ShowAward(data.cardid, data.items, true)
  end
  if npcRole then
    if isSelf then
      self:CameraReset()
      local viewPort = CameraConfig.CardMake_ViewPort
      local duration = CameraConfig.NPC_Dialog_DURATION
      self.cft = CameraEffectFocusTo.new(npcRole.assetRole.completeTransform, viewPort, duration)
      FunctionCameraEffect.Me():Start(self.cft)
      Game.Myself:Client_NoMove(true)
    end
    npcRole:Client_PlayAction("functional_action", nil, false)
    if self.effect then
      self.effect:Destroy()
      self.effect = nil
    end
    self.effect = npcRole:PlayEffect(nil, config.name, 0, nil, nil, true)
    if self.effect ~= nil then
      self.effect:RegisterWeakObserver(self)
    end
    npcRole:PlayAudio(config.audio)
    if isSelf then
      TimeTickManager.Me():CreateOnceDelayTick(GameConfig.Delay.card_exchange, function(owner, deltaTime)
        if 0 < #_getCardList then
          for i = 1, #_getCardList do
            local id = _getCardList[i]
            self:ShowFloatAward(id)
          end
          TableUtility.ArrayClear(_getCardList)
        elseif 0 < #_getItemList then
          self:ShowItemPop(_getItemList)
        end
        self:CameraReset()
        Game.Myself:Client_NoMove(false)
      end, self)
    end
  elseif isSelf then
    self:ShowAward(data.cardid, data.items)
  end
end

function CardMakeProxy:ObserverDestroyed(obj)
  if obj == self.effect then
    self.effect = nil
  end
end

function CardMakeProxy:ShowAward(cardid, items, isDelay)
  if items and 0 < #items then
    _ArrayClear(_getItemList)
    for i = 1, #items do
      local item = items[i]
      local itemData = ItemData.new(item.guid, item.id)
      itemData.num = item.count
      _ArrayPushBack(_getItemList, itemData)
    end
    if not isDelay then
      self:ShowItemPop(_getItemList)
    end
  elseif cardid then
    for i = 1, #cardid do
      local id = cardid[i]
      local itemData = ItemData.new("ExchangeCard", id)
      if isDelay then
        _ArrayPushBack(_getCardList, itemData)
      else
        self:ShowFloatAward(itemData)
      end
    end
  end
end

function CardMakeProxy:ShowFloatAward(itemData)
  if BagProxy.CheckIsCardTypeItem(itemData.staticData.Type) then
    local args = _CreateTable()
    args.disableMsg = true
    
    function args.leftBtnCallback()
      local npcRole = SceneCreatureProxy.FindCreature(self.npcid)
      if npcRole then
        local viewdata = {
          npcdata = npcRole,
          tabIndex = self.cardTabIndex
        }
        FunctionNpcFunc.JumpPanel(PanelConfig.CardContainerView, viewdata)
      end
    end
    
    FloatAwardView.addItemDatasToShow({itemData}, args)
    _DestroyAndClearTable(args)
  end
end

function CardMakeProxy:ShowItemPop(itemlist)
  self:sendNotification(UIEvent.ShowUI, {
    viewname = "PopUp10View"
  })
  self:sendNotification(SystemMsgEvent.MenuItemPop, itemlist)
end

function CardMakeProxy:CameraReset()
  if self.cft ~= nil then
    FunctionCameraEffect.Me():End(self.cft)
    self.cft = nil
  end
end

function CardMakeProxy:InitRandomCard()
  _ArrayClear(self.randomCardList)
  local timecheck_func = ItemUtil.CheckCardCanLotteryByTime
  for i = 1, #packageCheck do
    local items = BagProxy.Instance:GetBagItemsByTypes(Game.Config_ItemTypeGroup[BagProxy.ItemTypeGroup.Card], packageCheck[i])
    if items ~= nil then
      for j = 1, #items do
        local bagData = items[j]
        if bagData.staticData.Quality < 4 and not bagData:CheckItemCardType(Item_CardType.Raffle) and not BagProxy.Instance:CheckIsFavorite(bagData, packageCheck) and timecheck_func(bagData.staticData.id) then
          _ArrayPushBack(self.randomCardList, bagData:Clone())
        end
      end
    end
  end
  self:SortDecomposeCard(self.randomCardList)
end

function CardMakeProxy:GetRandomCard()
  return self.randomCardList
end

function CardMakeProxy:SortRandomCard(list)
  table.sort(list, CardMakeProxy._SortRandomCard)
end

function CardMakeProxy._SortRandomCard(l, r)
  if l.isChoose == r.isChoose then
    local staticDatal = l.itemData.staticData
    local staticDatar = r.itemData.staticData
    if staticDatal and staticDatar then
      if staticDatal.Quality == staticDatar.Quality then
        return staticDatal.id < staticDatar.id
      else
        return staticDatal.Quality < staticDatar.Quality
      end
    end
  else
    return l.isChoose
  end
end

function CardMakeProxy:FilterRandomCard(quality)
  if quality == 0 then
    self:SortRandomCard(self.randomCardList)
    return self.randomCardList
  end
  _ArrayClear(self.filterRandomCardList)
  for i = 1, #self.randomCardList do
    local data = self.randomCardList[i]
    if data.isChoose then
      _ArrayPushBack(self.filterRandomCardList, data)
    elseif data.itemData and data.itemData.staticData and data.itemData.staticData.Quality == quality then
      _ArrayPushBack(self.filterRandomCardList, data)
    end
  end
  self:SortRandomCard(self.filterRandomCardList)
  return self.filterRandomCardList
end

function CardMakeProxy:FilterRandomCardByQualities(qualities)
  if not qualities then
    self:SortDecomposeCard(self.randomCardList)
    return self.randomCardList
  end
  _ArrayClear(self.filterRandomCardList)
  for i = 1, #self.randomCardList do
    local data = self.randomCardList[i]
    if TableUtility.ArrayFindIndex(qualities, data.staticData.Quality) > 0 then
      _ArrayPushBack(self.filterRandomCardList, data)
    end
  end
  self:SortDecomposeCard(self.filterRandomCardList)
  return self.filterRandomCardList
end

function CardMakeProxy:CheckFilterRandomCardList(quality)
  if quality == 0 then
    return self.randomCardList
  end
  for i = #self.filterRandomCardList, 1, -1 do
    local data = self.filterRandomCardList[i]
    if not data.isChoose and data.itemData and data.itemData.staticData and data.itemData.staticData.Quality ~= quality then
      table.remove(self.filterRandomCardList, i)
    end
  end
  return self.filterRandomCardList
end

function CardMakeProxy:GetRandomChooseList()
  _ArrayClear(self.chooseRandomCardList)
  local data
  for i = 1, #self.randomCardList do
    data = self.randomCardList[i]
    if data.isChoose then
      _ArrayPushBack(self.chooseRandomCardList, data)
    end
  end
  return self.chooseRandomCardList
end

function CardMakeProxy:GetRandomChooseIdList()
  _ArrayClear(tempList)
  for i = 1, #self.chooseRandomCardList do
    _ArrayPushBack(tempList, self.chooseRandomCardList[i].itemData.id)
  end
  return tempList
end

function CardMakeProxy:GetRandomCost()
  local randomList = GameConfig.CardMake.RandomTip
  local data
  for i = 1, #Table_CardRate do
    _ArrayClear(tempList)
    for i = 1, #self.chooseRandomCardList do
      _ArrayPushBack(tempList, self.chooseRandomCardList[i].itemData.staticData.Quality)
    end
    data = Table_CardRate[i]
    for j = 1, #data.quality do
      TableUtility.ArrayRemove(tempList, data.quality[j])
    end
    if #tempList == 0 then
      return data.Cost
    end
  end
  return nil
end

function CardMakeProxy:InitRandomGetList()
  _ArrayClear(self.randomGetList)
  local timecheck_func = ItemUtil.CheckCardCanLotteryByTime
  for k, v in pairs(Table_Card) do
    if self:CheckServerID(v.ServerID) and not CheckInvalid(v.id) and timecheck_func(v.id) and self:CheckType(v.Type, Item_CardType.Get) then
      local data = ItemData.new("Card", v.id)
      _ArrayPushBack(self.randomGetList, data)
    end
  end
  table.sort(self.randomGetList, CardMakeProxy._SortRandomGet)
end

function CardMakeProxy._SortRandomGet(l, r)
  local staticDatal = l.staticData
  local staticDatar = r.staticData
  if staticDatal and staticDatar then
    if staticDatal.Quality == staticDatar.Quality then
      return staticDatal.id < staticDatar.id
    else
      return staticDatal.Quality > staticDatar.Quality
    end
  end
end

function CardMakeProxy:GetRandomGetList()
  return self.randomGetList
end

local bosscomposeId = GameConfig.Card.composeid

function CardMakeProxy:InitCard()
  self.cardList = {}
  self.cardMap = {}
  for k, v in pairs(Table_Compose) do
    if v.Category == 7 and v.id ~= bosscomposeId then
      local data = CardMakeData.new(k)
      if data.itemData and data.itemData.staticData and not CheckInvalid(data.itemData.staticData.id) then
        _ArrayPushBack(self.cardList, data)
        self.cardMap[data.itemData.staticData.id] = data
      end
    end
  end
end

function CardMakeProxy:GetMakeCardData(itemId)
  if not self.cardList then
    self:InitCard()
  end
  return self.cardMap[itemId]
end

function CardMakeProxy:GetCard()
  return self.cardList
end

function CardMakeProxy:SortCard(list)
  table.sort(list, CardMakeProxy._SortCard)
end

function CardMakeProxy._SortCard(l, r)
  local composel = Table_Compose[l.id]
  local composer = Table_Compose[r.id]
  local staticDatal = l.itemData.staticData
  local staticDatar = r.itemData.staticData
  if staticDatal and staticDatar then
    local isUnlockl = AdventureDataProxy.Instance:IsCardUnlock(staticDatal.id)
    local isUnlockr = AdventureDataProxy.Instance:IsCardUnlock(staticDatar.id)
    if CardMakeProxy.sortOwned then
      if isUnlockl == isUnlockr then
        if composel.IsTop == composer.IsTop then
          if staticDatal.Quality == staticDatar.Quality then
            return staticDatal.id < staticDatar.id
          else
            return staticDatal.Quality > staticDatar.Quality
          end
        else
          return composel.IsTop == 1
        end
      else
        return not isUnlockl
      end
    elseif CardMakeProxy.sortMakeable then
      local isMakeablel = l:IsMakeable()
      local isMakeabler = r:IsMakeable()
      if isMakeablel == isMakeabler then
        if composel.IsTop == composer.IsTop then
          if staticDatal.Quality == staticDatar.Quality then
            return staticDatal.id < staticDatar.id
          else
            return staticDatal.Quality > staticDatar.Quality
          end
        else
          return composel.IsTop == 1
        end
      else
        return isMakeablel
      end
    elseif composel.IsTop == composer.IsTop then
      if staticDatal.Quality == staticDatar.Quality then
        return staticDatal.id < staticDatar.id
      else
        return staticDatal.Quality > staticDatar.Quality
      end
    else
      return composel.IsTop == 1
    end
  end
end

function CardMakeProxy:FilterCard(type)
  if self.cardList == nil then
    self:InitCard()
  end
  _ArrayClear(self.filterCardList)
  local timecheck_func = ItemUtil.CheckCardCanComposeByTime
  if type == 0 then
    for i = 1, #self.cardList do
      local d = self.cardList[i]
      if timecheck_func(d.itemData.staticData.id) then
        _ArrayPushBack(self.filterCardList, d)
      end
    end
  else
    for i = 1, #self.cardList do
      local data = self.cardList[i]
      if data.itemData and data.itemData.staticData and data.itemData.staticData.Type == type and timecheck_func(data.itemData.staticData.id) then
        _ArrayPushBack(self.filterCardList, data)
      end
    end
  end
  self:SortCard(self.filterCardList)
  return self.filterCardList
end

function CardMakeProxy:FilterCardByTypes(types)
  if self.cardList == nil then
    self:InitCard()
  end
  _ArrayClear(self.filterCardList)
  local timecheck_func = ItemUtil.CheckCardCanComposeByTime
  if not types or #types == 0 then
    for i = 1, #self.cardList do
      local d = self.cardList[i]
      if timecheck_func(d.itemData.staticData.id) then
        _ArrayPushBack(self.filterCardList, d)
      end
    end
  else
    for i = 1, #self.cardList do
      local data = self.cardList[i]
      if 0 < TableUtility.ArrayFindIndex(types, data.itemData.staticData.Type) and timecheck_func(data.itemData.staticData.id) then
        _ArrayPushBack(self.filterCardList, data)
      end
    end
  end
  self:SortCard(self.filterCardList)
  return self.filterCardList
end

function CardMakeProxy:CanMake()
  if self.chooseData then
    return self.chooseData:CanMake()
  else
    return false
  end
end

function CardMakeProxy:GetFilter(filterData)
  _ArrayClear(filter)
  for k, v in pairs(filterData) do
    table.insert(filter, k)
  end
  table.sort(filter, function(l, r)
    return l < r
  end)
  return filter
end

function CardMakeProxy:IsCostGreatCard(composeId)
  local data = Table_Compose[composeId]
  if data then
    for i = 1, #data.BeCostItem do
      local itemid = data.BeCostItem[i].id
      if Table_Card[itemid] ~= nil then
        local staticData = Table_Item[itemid]
        if staticData and staticData.Quality >= 4 then
          return true
        end
      end
    end
  end
  return false
end

function CardMakeProxy:CheckType(type, index)
  if type == nil or index == nil then
    return false
  end
  return 0 < type & index
end

function CardMakeProxy:SetChoose(data)
  self.chooseData = data
end

function CardMakeProxy:GetChoose()
  return self.chooseData
end

function CardMakeProxy:CheckCanMake(materialData)
  if materialData and self.chooseData then
    return self.chooseData:CheckCanMake(materialData)
  end
  return false
end

function CardMakeProxy:CheckMaterialSlotCanMake(materialSlotId)
  if self.chooseData then
    return self.chooseData:CheckMaterialSlotCanMake(materialSlotId)
  end
  return false
end

function CardMakeProxy:IsSkipGetEffect(type)
  return LocalSaveProxy.Instance:GetSkipAnimation(type)
end

function CardMakeProxy:GetItemNumByStaticID(itemid)
  local _BagProxy = BagProxy.Instance
  local count = 0
  for i = 1, #packageCheck do
    count = count + _BagProxy:GetItemNumByStaticID(itemid, packageCheck[i])
  end
  return count
end

function CardMakeProxy:GetItemNumByStaticIDExceptFavoriteCard(itemId)
  local items = self:GetItemsByStaticIDAndPredicate(itemId, function(itemData)
    if not itemData or not itemData.staticData then
      return false
    end
    if Table_Card[itemData.staticData.id] and BagProxy.Instance:CheckIsFavorite(itemData) then
      return false
    end
    return true
  end)
  if not items then
    return 0
  end
  local sum = 0
  for i = 1, #items do
    sum = sum + items[i].num or 0
  end
  return sum
end

function CardMakeProxy:GetItemsByStaticIDAndPredicate(itemId, predicate, args, checkPackage)
  local _BagProxy, arrayPushBack = BagProxy.Instance, TableUtility.ArrayPushBack
  local result, tmp = {}
  local _packageCheck = checkPackage or packageCheck
  for i = 1, #_packageCheck do
    tmp = _BagProxy:GetItemsByStaticID(itemId, _packageCheck[i])
    if tmp and next(tmp) then
      for j = 1, #tmp do
        if predicate(tmp[j], args) then
          arrayPushBack(result, tmp[j])
        end
      end
    end
  end
  return result
end

function CardMakeProxy:InitDecomposeCard()
  _ArrayClear(self.decomposeCardList)
  local _BagProxy = BagProxy.Instance
  for i = 1, #packageCheck do
    local items = _BagProxy:GetBagItemsByTypes(Game.Config_ItemTypeGroup[BagProxy.ItemTypeGroup.Card], packageCheck[i])
    if items ~= nil then
      for j = 1, #items do
        local bagData = items[j]
        if not bagData:CheckItemCardType(Item_CardType.Decompose) and not _BagProxy:CheckIsFavorite(bagData) and bagData:CanCardDecompose() then
          _ArrayPushBack(self.decomposeCardList, bagData:Clone())
        end
      end
    end
  end
  self:SortDecomposeCard(self.decomposeCardList)
end

function CardMakeProxy:GetDecomposeCard()
  return self.decomposeCardList
end

function CardMakeProxy:FilterDecomposeCard(quality)
  if quality == 0 then
    self:SortDecomposeCard(self.decomposeCardList)
    return self.decomposeCardList
  end
  _ArrayClear(self.filterDecomposeCardList)
  for i = 1, #self.decomposeCardList do
    local data = self.decomposeCardList[i]
    if data:GetCardQuality() == quality then
      _ArrayPushBack(self.filterDecomposeCardList, data)
    end
  end
  self:SortDecomposeCard(self.filterDecomposeCardList)
  return self.filterDecomposeCardList
end

function CardMakeProxy:FilterDecomposeCardByQualities(qualities)
  if not qualities then
    self:SortDecomposeCard(self.decomposeCardList)
    return self.decomposeCardList
  end
  _ArrayClear(self.filterDecomposeCardList)
  for i = 1, #self.decomposeCardList do
    local data = self.decomposeCardList[i]
    local quality = data:GetCardQuality()
    if TableUtility.ArrayFindIndex(qualities, quality) > 0 then
      _ArrayPushBack(self.filterDecomposeCardList, data)
    end
  end
  self:SortDecomposeCard(self.filterDecomposeCardList)
  return self.filterDecomposeCardList
end

function CardMakeProxy:SortDecomposeCard(list)
  table.sort(list, CardMakeProxy._SortDecomposeCard)
end

function CardMakeProxy._SortDecomposeCard(l, r)
  local staticDatal = l.staticData
  local staticDatar = r.staticData
  if staticDatal and staticDatar then
    local extraSortFunc = function(staticDatal, staticDatar)
      if GameConfig.CardMake.RandomMakeExtraSortItems then
        local indexl = TableUtility.ArrayFindIndex(GameConfig.CardMake.RandomMakeExtraSortItems, staticDatal.id)
        local indexr = TableUtility.ArrayFindIndex(GameConfig.CardMake.RandomMakeExtraSortItems, staticDatar.id)
        if 0 < indexl and 0 < indexr then
          return staticDatal.Quality < staticDatar.Quality
        elseif 0 < indexl or 0 < indexr then
          return 0 < indexl
        end
      end
    end
    if CardMakeProxy.sortPrice then
      local extraSortResult = extraSortFunc(staticDatal, staticDatar)
      if extraSortResult ~= nil then
        return extraSortResult
      end
      local _, pricel = FunctionItemTrade.Me():GetTradePriceCache(l)
      local _, pricer = FunctionItemTrade.Me():GetTradePriceCache(r)
      if pricel == pricer then
        if CardMakeProxy.sortDescend then
          return staticDatal.id > staticDatar.id
        else
          return staticDatal.id < staticDatar.id
        end
      elseif CardMakeProxy.sortDescend then
        return pricel > pricer
      else
        return pricel < pricer
      end
    elseif staticDatal.Quality == staticDatar.Quality then
      local extraSortResult = extraSortFunc(staticDatal, staticDatar)
      if extraSortResult ~= nil then
        return extraSortResult
      end
      if CardMakeProxy.sortDescend then
        return staticDatal.id > staticDatar.id
      else
        return staticDatal.id < staticDatar.id
      end
    elseif CardMakeProxy.sortDescend then
      return staticDatal.Quality > staticDatar.Quality
    else
      return staticDatal.Quality < staticDatar.Quality
    end
  end
end

function CardMakeProxy:GetDecomposeMaterialItemData()
  if self.decomposeMaterialItemData == nil then
    self.decomposeMaterialItemData = ItemData.new("CardDecompose", GameConfig.Card.decompose_item_id)
  end
  return self.decomposeMaterialItemData
end

function CardMakeProxy:GetRandomMakeMaterialItemData(choosedCards, list)
  local cardRateIds = {}
  local temp = ReusableTable.CreateTable()
  for i = 1, #choosedCards, 3 do
    local data = choosedCards[i]
    if data ~= BagItemEmptyType.Empty then
      for id, config in pairs(Table_CardRate) do
        local qualities = config.quality
        local index = TableUtility.TableFindKey(qualities, data.staticData.Quality)
        if index then
          temp[index] = qualities[index]
          qualities[index] = nil
          if choosedCards[i + 1] and choosedCards[i + 1] ~= BagItemEmptyType.Empty then
            index = TableUtility.TableFindKey(qualities, choosedCards[i + 1].staticData.Quality)
            if index then
              temp[index] = qualities[index]
              qualities[index] = nil
              if choosedCards[i + 2] and choosedCards[i + 2] ~= BagItemEmptyType.Empty then
                index = TableUtility.TableFindKey(qualities, choosedCards[i + 2].staticData.Quality)
                if index then
                  cardRateIds[#cardRateIds + 1] = id
                end
              end
            end
          end
        end
        for k, v in pairs(temp) do
          qualities[k] = v
        end
        TableUtility.TableClear(temp)
      end
    end
  end
  ReusableTable.DestroyTable(temp)
  local cost = 0
  local map = {}
  map[GameConfig.CardMake.RandomMakeItemId] = ItemData.new("RandomMakeItem", GameConfig.CardMake.RandomMakeItemId)
  for i = 1, #cardRateIds do
    local config = Table_CardRate[cardRateIds[i]]
    cost = cost + config.Cost
    local reward = map[config.Reward[1][1]]
    if not reward then
      reward = ItemData.new("CardReward", config.Reward[1][1])
      map[config.Reward[1][1]] = reward
      list[#list + 1] = reward
    end
    reward.num = reward.num + config.Reward[1][2]
    local extraReward = map[config.ExtraReward[1][1]]
    if not extraReward then
      extraReward = ItemData.new("CardExtraReward", config.ExtraReward[1][1])
      map[config.ExtraReward[1][1]] = extraReward
      list[#list + 1] = extraReward
    end
    extraReward.num = extraReward.num + config.ExtraReward[1][3]
    map[GameConfig.CardMake.RandomMakeItemId].num = map[GameConfig.CardMake.RandomMakeItemId].num + 1
  end
  list[#list + 1] = map[GameConfig.CardMake.RandomMakeItemId]
  return cost
end

function CardMakeProxy:InitBossComposeCard(rates)
  _ArrayClear(self.bosscomposelist)
  local timecheck_func = ItemUtil.CheckCardCanComposeByTime
  for i = 1, #rates do
    local id = rates[i].item_id
    local v = Table_Card[id]
    local vtype = v.Type
    if vtype and not CheckInvalid(id) and timecheck_func(id) and self:CheckItemCardType(vtype, Item_CardType.BossCompose) then
      local single = ItemData.new("BossCardCompose", id)
      single.RateShow = rates[i].rate
      _ArrayPushBack(self.bosscomposelist, single)
    end
  end
end

function CardMakeProxy:CheckItemCardType(vtype, item_CardType)
  return 0 < vtype & item_CardType
end

function CardMakeProxy:FilterBossComposeCard(type)
  _ArrayClear(self.filterbosscomposelist)
  if type == 0 then
    for i = 1, #self.bosscomposelist do
      local d = self.bosscomposelist[i]
      _ArrayPushBack(self.filterbosscomposelist, d)
    end
  else
    for i = 1, #self.bosscomposelist do
      local data = self.bosscomposelist[i]
      if data.staticData.Type then
      end
      if data and data.staticData and data.staticData.Type == type then
        _ArrayPushBack(self.filterbosscomposelist, data)
      end
    end
  end
  return self.filterbosscomposelist
end

function CardMakeProxy:FilterBossComposeCardByTypes(types)
  return self:FilterComposeCardByTypes(types, self.bosscomposelist, self.filterbosscomposelist)
end

function CardMakeProxy:CheckServerID(ServerIDs)
  if not ServerIDs or #ServerIDs == 0 then
    return true
  end
  local server = FunctionLogin.Me():getCurServerData()
  local linegroup = 0
  if server then
    linegroup = server.linegroup or 1
  end
  if ServerIDs then
    for n, m in pairs(ServerIDs) do
      if m == linegroup then
        return true
      end
    end
  end
  return false
end

function CardMakeProxy:SetDecomposeSortParam(isPrice, descend)
  CardMakeProxy.sortPrice = isPrice
  CardMakeProxy.sortDescend = descend
end

function CardMakeProxy:SetMakeSortParam(isOwned, isMakeable)
  CardMakeProxy.sortOwned = isOwned
  CardMakeProxy.sortMakeable = isMakeable
end

function CardMakeProxy:getItemsByFilterData(items, propData, keys)
  if not propData or #items == 0 then
    return items
  end
  local retDatas = {}
  local datas = AdventureDataProxy.Instance:getSinglePropDatas(propData, keys)
  local buffers = {}
  for i = 1, #items do
    local single = items[i]
    local staticData = single.itemData.staticData
    local beIn = false
    TableUtility.ArrayClear(buffers)
    if staticData and next(staticData.AdventureReward) then
      local buff = staticData.AdventureReward.buffid
      beIn = AdventureDataProxy.Instance:CheckBufferisRequire(buff, datas, propData.propId, keys)
      buffers[#buffers + 1] = buff
    end
    if not beIn and staticData and next(staticData.StorageReward) then
      local buff = staticData.StorageReward.buffid
      beIn = AdventureDataProxy.Instance:CheckBufferisRequire(buff, datas, propData.propId, keys)
      buffers[#buffers + 1] = buff
    end
    if not beIn and single.itemData.cardInfo then
      local buff = single.itemData.cardInfo.BuffEffect.buff
      beIn = AdventureDataProxy.Instance:CheckBufferisRequire(buff, datas, propData.propId, keys)
      buffers[#buffers + 1] = buff
    end
    if not beIn and single.itemData.equipInfo and single.itemData.equipInfo.equipData then
      local buff = single.itemData.equipInfo.equipData.UniqueEffect.buff
      beIn = AdventureDataProxy.Instance:CheckBufferisRequire(buff, datas, propData.propId, keys)
      buffers[#buffers + 1] = buff
    end
    if beIn then
      retDatas[#retDatas + 1] = single
    end
    if not beIn and propData.propId == 8 then
      local find = false
      for j = 1, #buffers do
        local single = buffers[j]
        find = AdventureDataProxy.Instance:CheckBufferisOtherRequire(single, keys)
        if find then
          break
        end
      end
      if not find then
        retDatas[#retDatas + 1] = single
      end
    end
  end
  return retDatas
end

function CardMakeProxy:InitComposeCard(datas)
  for i = 1, #datas do
    local data = datas[i]
    if data.type == self.MakeType.BossCompose then
      self:InitComposeCardData("BossCardCompose", data.rates, self.bosscomposelist, self.bossRateUpCards)
    elseif data.type == self.MakeType.MvpCardCompose then
      self:InitComposeCardData("MvpCardCompose", data.rates, self.mvpcomposelist, self.mvpRateUpCards)
    elseif data.type == self.MakeType.DungeonMvpCardCompose then
      self:InitComposeCardData("DungeonMvpCardCompose", data.rates, self.dungeonMvpComposeList, self.dungeonMvpRateUpCards)
    end
  end
end

function CardMakeProxy:InitComposeCardData(name, src, dest, rateUpList)
  _ArrayClear(dest)
  _ArrayClear(rateUpList)
  local timecheck_func = ItemUtil.CheckCardCanComposeByTime
  local curTime = ServerTime.CurServerTime() / 1000
  for i = 1, #src do
    local id = src[i].item_id
    if not CheckInvalid(id) and timecheck_func(id) then
      local single = ItemData.new(name, id)
      single.RateShow = src[i].rate
      if src[i].upstarttime and src[i].upendtime and curTime < src[i].upendtime and curTime >= src[i].upstarttime then
        single.upStartTime = src[i].upstarttime
        single.upEndTime = src[i].upendtime
        _ArrayPushBack(rateUpList, single)
      else
        _ArrayPushBack(dest, single)
      end
    end
  end
end

function CardMakeProxy:FilterMvpComposeCardByTypes(types)
  return self:FilterComposeCardByTypes(types, self.mvpcomposelist, self.filtermvpcomposelist)
end

function CardMakeProxy:FilterComposeCardByTypes(types, list, filterList)
  _ArrayClear(filterList)
  if not types or #types == 0 then
    for i = 1, #list do
      local d = list[i]
      _ArrayPushBack(filterList, d)
    end
  else
    for i = 1, #list do
      local data = list[i]
      if 0 < TableUtility.ArrayFindIndex(types, data.staticData.Type) then
        _ArrayPushBack(filterList, data)
      end
    end
  end
  return filterList
end

function CardMakeProxy:GetRateUpCardList(type)
  if type == self.MakeType.BossCompose then
    return self.bossRateUpCards
  elseif type == self.MakeType.MvpCardCompose then
    return self.mvpRateUpCards
  elseif type == self.MakeType.DungeonMvpCardCompose then
    return self.dungeonMvpRateUpCards
  end
end

function CardMakeProxy:IsHaveUpRateCards(type)
  local cards = self:GetRateUpCardList(type)
  return cards and 0 < #cards or false
end

function CardMakeProxy:FilterDungeonMvpComposeCardByTypes(types)
  return self:FilterComposeCardByTypes(types, self.dungeonMvpComposeList, self.filterDungeonMvpComposeList)
end

function CardMakeProxy:GetItemNumAsMaterial(itemId, checkPackage)
  local items = self:GetItemsByStaticIDAndPredicate(itemId, function(itemData)
    if itemData:IsCard() then
      if BagProxy.Instance:CheckIsFavorite(itemData, checkPackage) then
        return false
      end
      return not itemData.cardLv or itemData.cardLv == 0
    end
    return true
  end, nil, checkPackage)
  if not items then
    return 0
  end
  local sum = 0
  for i = 1, #items do
    sum = sum + items[i].num or 0
  end
  return sum
end

function CardMakeProxy:GetCardUpgradeUsedDiscountCount(act_id)
  return self.cardUpgradeUsedDiscountCount and self.cardUpgradeUsedDiscountCount[act_id] or 0
end

function CardMakeProxy:SetCardUpgradeUsedDiscountCount(act_id, count)
  if not self.cardUpgradeUsedDiscountCount then
    self.cardUpgradeUsedDiscountCount = {}
  end
  self.cardUpgradeUsedDiscountCount[act_id] = count
end
