autoImport("GlobalActivityProxy")
MidSummerActProxy = class("MidSummerActProxy", GlobalActivityProxy)
MidSummerActProxy.NAME = "MidSummerActProxy"
MidSummerActProxy.Config = GameConfig.FavoriteActivity
MidSummerActProxy.PeriodInteractTimesType = SceneItem_pb.EFAVORITEDESIRE_TYPE_CLICK_TIMES
MidSummerActProxy.RelationshipType = SceneItem_pb.EFAVORITEDESIRE_TYPE_DESIRE_TIMES
local tempTable, bagIns = {}

function MidSummerActProxy:InitStaticData()
  if self.desireSDataMap then
    return
  end
  self.desireSDataMap = {}
  local gActMap
  for _, d in pairs(Table_FavoriteDesire) do
    gActMap = self.desireSDataMap[d.GlobalActivityID] or {}
    gActMap[d.id] = d
    self.desireSDataMap[d.GlobalActivityID] = gActMap
  end
end

function MidSummerActProxy:GetStaticData(id, desireId)
  self:InitStaticData()
  local desireSData = id and self.desireSDataMap[id] or _EmptyTable
  if desireId then
    return desireSData[desireId] or _EmptyTable
  else
    return desireSData
  end
end

local staticDataBasicSortFunc = function(l, r)
  return l.id < r.id
end

function MidSummerActProxy:GetStaticDatasByPredicate(id, sortFunc, predicate, ...)
  local desireSData, hasComplete = self:GetStaticData(id), false
  TableUtility.TableClear(tempTable)
  for _, data in pairs(desireSData) do
    if not predicate or predicate(data, ...) then
      TableUtility.ArrayPushBack(tempTable, data)
      if self:CheckDesireComplete(id, data.id) then
        hasComplete = true
      end
    end
  end
  table.sort(tempTable, staticDataBasicSortFunc)
  local count = 0
  for i = 1, #tempTable do
    count = count + 1
    tempTable[i].__displayIndex = count
  end
  if sortFunc then
    table.sort(tempTable, sortFunc)
  end
  return tempTable, hasComplete
end

local staticDataSortFunc = function(l, r)
  local ins = MidSummerActProxy.Instance
  if ins.showingActId then
    local l1, r1 = ins:CheckDesireComplete(ins.showingActId, l.id) and 1 or 0, ins:CheckDesireComplete(ins.showingActId, r.id) and 1 or 0
    if l1 ~= r1 then
      return l1 > r1
    end
    local l2, r2 = ins:CheckDesireReceived(ins.showingActId, l.id) and 1 or 0, ins:CheckDesireReceived(ins.showingActId, r.id) and 1 or 0
    if l2 ~= r2 then
      return l2 < r2
    end
  end
  return staticDataBasicSortFunc(l, r)
end

function MidSummerActProxy:GetDesireStaticDatas(id)
  return self:GetStaticDatasByPredicate(id, staticDataSortFunc, function(data)
    return data.Type ~= MidSummerActProxy.RelationshipType
  end)
end

function MidSummerActProxy:GetRelationshipStaticDatas(id)
  return self:GetStaticDatasByPredicate(id, staticDataSortFunc, function(data)
    return data.Type == MidSummerActProxy.RelationshipType
  end)
end

function MidSummerActProxy:GetDesireData(id)
  id = id or self.showingActId
  return self.desireDataMap and id and self.desireDataMap[id] or _EmptyTable
end

function MidSummerActProxy:GetCurrentRelationLevelAndConfig(id)
  id = id or self.showingActId
  local sData = self:GetStaticData(id)
  if next(sData) then
    local arr, cfg, desireId = ReusableTable.CreateArray(), self:GetRelationConfig(id)
    for lv, lData in pairs(cfg) do
      desireId = lData[1]
      if desireId == 0 or self:CheckDesireReceived(id, desireId) then
        TableUtility.ArrayPushBack(arr, lv)
      end
    end
    table.sort(arr)
    local rslt = arr[#arr]
    ReusableTable.DestroyAndClearArray(arr)
    return rslt, cfg[rslt]
  end
  return 0, nil
end

function MidSummerActProxy:GetRelationConfig(id, level)
  local cfg = id and self.Config[id]
  cfg = cfg and cfg.RelationLevel
  if level then
    return cfg and cfg[level]
  else
    return cfg
  end
end

function MidSummerActProxy:RecvDesire(id, data)
  if not self:CheckActivityId(id) then
    LogUtility.WarningFormat("Received wrong activity id = {0}!!!", id)
    return
  end
  self.desireDataMap = self.desireDataMap or {}
  id = id or data.activityid
  local localData = self.desireDataMap[id] or {}
  localData.id = id
  localData.level = data.level or 0
  localData.exp = data.exp or 0
  localData.favorite = data.favorite_item
  localData.isFavoriteShow = data.show_favorite
  localData.interactTimes = data.interact_times
  localData.interacted = data.has_interact
  local map = localData.gotRewardMap or {}
  for i = 1, #data.rewardids do
    map[data.rewardids[i]] = true
  end
  localData.gotRewardMap = map
  map = localData.desireCountMap or {}
  for i = 1, #data.desires do
    map[data.desires[i].type] = data.desires[i].count
  end
  localData.desireCountMap = map
  self.desireDataMap[id] = localData
end

function MidSummerActProxy:OnRemoveActivity(id)
  if self.desireDataMap then
    self.desireDataMap[id] = nil
  end
end

local checkReceived = function(desireData, staticData)
  return desireData.gotRewardMap[staticData.id] or false
end

function MidSummerActProxy:CheckDesireReceived(id, desireId)
  return self:CheckDesireByPredicate(id, desireId, checkReceived)
end

local checkComplete = function(desireData, staticData)
  if checkReceived(desireData, staticData) then
    return false
  end
  local count = desireData.desireCountMap[staticData.Type] or 0
  return count >= staticData.Count
end

function MidSummerActProxy:CheckDesireComplete(id, desireId)
  return self:CheckDesireByPredicate(id, desireId, checkComplete)
end

local checkUnlock = function(desireData, staticData)
  if checkReceived(desireData, staticData) or checkComplete(desireData, staticData) then
    return true
  end
  return desireData.level >= (staticData.HeartNum or 0)
end

function MidSummerActProxy:CheckDesireUnlock(id, desireId)
  return self:CheckDesireByPredicate(id, desireId, checkUnlock)
end

function MidSummerActProxy:CheckDesireByPredicate(id, desireId, predicate, ...)
  if id then
    local desireData = self:GetDesireData(id)
    if next(desireData) and desireId then
      local staticData = self:GetStaticData(id, desireId)
      if next(staticData) then
        return predicate(desireData, staticData, ...)
      end
    end
  end
  return false
end

function MidSummerActProxy:CheckCanGainFavorability(id)
  local rslt = false
  self:_TryActionByActId(id, function(actId, self)
    local times = self:GetDesireData(actId).interactTimes or 0
    rslt = times < self.Config[actId].TapMax
  end, self)
  return rslt
end

local addGift = function(items, sId, count)
  if count and count < 1 then
    return
  end
  local sitem = NetConfig.PBC and {} or SceneItem_pb.SItem()
  sitem.id, sitem.count = sId, count or 1
  table.insert(items, sitem)
end

function MidSummerActProxy:GiveOneGift(gift, id)
  self:_TryActionByActId(id, function(actId, giftId, self)
    local level = self:GetDesireData(actId).level
    if level and level >= self.Config[actId].HeartMax then
      MsgManager.ShowMsgByIDTable(42003)
    end
    if not bagIns then
      bagIns = BagProxy.Instance
    end
    local itemNum = bagIns:GetItemNumByStaticID(giftId, GameConfig.PackageMaterialCheck.favorite_pack)
    if 0 < itemNum then
      local items = ReusableTable.CreateArray()
      addGift(items, giftId)
      ServiceItemProxy.Instance:CallFavoriteGiveItemCmd(actId, items, false)
      ReusableTable.DestroyAndClearArray(items)
    else
      MsgManager.ShowMsgByIDTable(25418, Table_Item[giftId].NameZh)
    end
  end, gift, self)
end

function MidSummerActProxy:GiveAllGift(id)
  self:_TryActionByActId(id, function(actId, self)
    local level = self:GetDesireData(actId).level
    if level and level >= self.Config[actId].HeartMax then
      MsgManager.ShowMsgByIDTable(42003)
    end
    local reusable, itemNum = ReusableTable.CreateArray()
    if not bagIns then
      bagIns = BagProxy.Instance
    end
    for sId, _ in pairs(self.Config[actId].GiftItem) do
      itemNum = bagIns:GetItemNumByStaticID(sId, GameConfig.PackageMaterialCheck.favorite_pack)
      if 0 < itemNum then
        addGift(reusable, sId, itemNum)
      end
    end
    ServiceItemProxy.Instance:CallFavoriteGiveItemCmd(actId, reusable, true)
    ReusableTable.DestroyAndClearArray(reusable)
  end, self)
end

local getRewardAction = function(actId, rewardId)
  ServiceItemProxy.Instance:CallFavoriteRewardItemCmd(actId, rewardId)
end

function MidSummerActProxy:GetReward(reward, id)
  self:_TryActionByActId(id, getRewardAction, reward)
end

local periodInteractQueueMap, period = {}, 60

function MidSummerActProxy:Interact(id)
  self:_TryActionByActId(id, function(actId, self)
    if self:CheckCanGainFavorability(actId) then
      ServiceItemProxy.Instance:CallFavoriteInteractItemCmd(actId)
    end
    local count, t, dData = MidSummerActProxy.PeriodInteract(actId), MidSummerActProxy.PeriodInteractTimesType, self:GetDesireData(actId)
    local record = dData.desireCountMap and dData.desireCountMap[t] or 0
    redlog("NowCount", count, "Record", record)
    if count > record then
      ServiceItemProxy.Instance:CallFavoriteDesireConditionItemCmd(actId, count, t)
    end
  end, self)
end

local queryAction = function(actId)
  ServiceItemProxy.Instance:CallFavoriteQueryItemCmd(actId)
end

function MidSummerActProxy:Query(id)
  self:_TryActionByActId(id, queryAction)
end

function MidSummerActProxy.PeriodInteract(id)
  if not id then
    return
  end
  local q = periodInteractQueueMap[id] or LuaQueue.new()
  local nowTime = math.floor(ServerTime.CurClientTime() / 1000)
  redlog("ClickNowTime", nowTime)
  TableUtil.Print(q.container)
  q:Push(nowTime)
  while nowTime - q:Peek() >= period do
    q:Pop()
    redlog("Popped")
    TableUtil.Print(q.container)
  end
  periodInteractQueueMap[id] = q
  return q:Count()
end
