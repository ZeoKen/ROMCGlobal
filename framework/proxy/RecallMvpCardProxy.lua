RecallMvpCardProxy = class("RecallMvpCardProxy", pm.Proxy)
RecallMvpCardProxy.Instance = nil
RecallMvpCardProxy.NAME = "RecallMvpCardProxy"
local RecallActivityType = 7

function RecallMvpCardProxy:ctor(proxyName, data)
  self.proxyName = proxyName or RecallMvpCardProxy.NAME
  if RecallMvpCardProxy.Instance == nil then
    RecallMvpCardProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function RecallMvpCardProxy:Init()
  self.rateUpCards = {}
  self.cardList = {}
  self.filterCardList = {}
end

function RecallMvpCardProxy:InitCardList(datas)
  if not datas then
    return
  end
  for i = 1, #datas do
    local serverData = datas[i]
    local weight = serverData.weight
    local totalWeight = serverData.total_weight
    local card = ItemData.new("RecallMvpCard", serverData.id)
    card.RateShow = weight * 100 / totalWeight
    self.cardList[#self.cardList + 1] = card
  end
end

function RecallMvpCardProxy:UpdateMvpCards(data)
  redlog("UpdateMvpCards", data.card_pool and #data.card_pool, data.up_card_pool and #data.up_card_pool, data.start_time, data.end_time)
  if #self.cardList == 0 then
    self:InitCardList(data.card_pool)
  end
  if data.up_card_pool then
    TableUtility.ArrayClear(self.rateUpCards)
    for i = 1, #data.up_card_pool do
      local id = data.up_card_pool[i]
      local card = ItemData.new("RecallMvpCard", id)
      self.rateUpCards[#self.rateUpCards + 1] = card
    end
  end
  if data.up_card and 0 < data.up_card then
    self:SetSelfChooseUpCard(data.up_card)
  else
    self.selfChooseUpCard = nil
  end
  self.index = data.index + 1
  self.configIndex = RecallInfoProxy.Instance:GetIndex(self.index)
  self.startTime = data.start_time
  self.isEnd = data.end_time and data.end_time > 0 or false
  self:SetUpTimes(data.rand_count)
end

function RecallMvpCardProxy:GetRateUpCards()
  return self.rateUpCards
end

function RecallMvpCardProxy:GetCardList()
  return self.cardList
end

function RecallMvpCardProxy:GetSelfChooseUpCard()
  return self.selfChooseUpCard
end

function RecallMvpCardProxy:GetUpTimes()
  return self.upTimes
end

function RecallMvpCardProxy:SetUpTimes(rand_count)
  self.upTimes = rand_count or 0
end

function RecallMvpCardProxy:SetSelfChooseUpCard(cardId)
  if not self.selfChooseUpCard then
    self.selfChooseUpCard = ItemData.new("RecallMvpCard", cardId)
  else
    self.selfChooseUpCard:ResetData("RecallMvpCard", cardId)
  end
  local card = TableUtility.ArrayFindByPredicate(self.cardList, function(v, args)
    return v.staticData.id == args
  end, cardId)
  if card then
    self.selfChooseUpCard.RateShow = card.RateShow
  end
end

function RecallMvpCardProxy:FilterCardListByTypes(types)
  TableUtility.ArrayClear(self.filterCardList)
  if not types or #types == 0 then
    for i = 1, #self.cardList do
      local card = self.cardList[i]
      TableUtility.ArrayPushBack(self.filterCardList, card)
    end
  else
    for i = 1, #self.cardList do
      local card = self.cardList[i]
      if 0 < TableUtility.ArrayFindIndex(types, card.staticData.Type) then
        TableUtility.ArrayPushBack(self.filterCardList, card)
      end
    end
  end
  return self.filterCardList
end

function RecallMvpCardProxy:GetStartTime()
  return self.startTime
end

function RecallMvpCardProxy:GetEndTime()
  local config = Table_UserRecall[RecallActivityType * 1000 + self.configIndex]
  if config and self.startTime then
    local curDailyRefreshTime = ClientTimeUtil.GetDailyRefreshTimeByTimeStamp(self.startTime)
    local endTime = curDailyRefreshTime + config.ContinueDay * 24 * 60 * 60
    return endTime
  end
end

function RecallMvpCardProxy:IsEnd()
  return self.isEnd
end

function RecallMvpCardProxy:GetCurIndex()
  return self.index
end

function RecallMvpCardProxy:IsActivityValid()
  return #self.cardList > 0 and 0 < #self.rateUpCards and not self.isEnd
end
