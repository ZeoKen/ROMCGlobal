autoImport("DojoRewardData")
ExpRaidProxy = class("ExpRaidProxy", pm.Proxy)

function ExpRaidProxy:ctor(proxyName, data)
  self.proxyName = proxyName or "ExpRaidProxy"
  if not ExpRaidProxy.Instance then
    ExpRaidProxy.Instance = self
  end
  if data then
    self:setData(data)
  end
  self:Init()
end

function ExpRaidProxy:Init()
  self.raidType = 0
  self:InitShopNpcItemDatas()
  self:InitItemPriceMap()
end

function ExpRaidProxy:InitShop(npc, raidType)
  self.shopNpc = npc
  self.raidType = raidType
end

function ExpRaidProxy:InitShopNpcItemDatas()
  self.shopItemDataArr = self.shopItemDataArr or {}
  self.shopNpcItemDataMap = self.shopNpcItemDataMap or {}
  local npcId, itemData
  for _, data in pairs(Table_ExpRaidshop) do
    npcId = type(data.Npcid) ~= "table" and data.Npcid or data.Npcid[1]
    if not self.shopNpcItemDataMap[npcId] then
      self.shopNpcItemDataMap[npcId] = {}
    end
    itemData = ItemData.new(tostring(npcId), data.id)
    table.insert(self.shopNpcItemDataMap[npcId], itemData)
    table.insert(self.shopItemDataArr, itemData)
  end
  local comparer = function(l, r)
    return l.staticData.id < r.staticData.id
  end
  table.sort(self.shopItemDataArr, comparer)
  for _, itemDataTable in pairs(self.shopNpcItemDataMap) do
    table.sort(itemDataTable, comparer)
  end
end

function ExpRaidProxy:InitItemPriceMap()
  if not self.itemPriceMap then
    self.itemPriceMap = {}
    for _, data in pairs(Table_ExpRaidshop) do
      self.itemPriceMap[data.id] = data.Price
    end
  end
end

local MakeSortedArrayFromDataTable = function(dataTable, sortBy)
  local array = {}
  for _, data in pairs(dataTable) do
    table.insert(array, data)
  end
  table.sort(array, function(l, r)
    return l[sortBy] < r[sortBy]
  end)
  return array
end
local MakeSortedArrayFromExpRaidTable = function(sortBy)
  return MakeSortedArrayFromDataTable(Table_ExpRaid, sortBy)
end

function ExpRaidProxy:GetExpRaidDataArray()
  if not self.raidDataArray then
    self.raidDataArray = MakeSortedArrayFromExpRaidTable("id")
  end
  return self.raidDataArray
end

function ExpRaidProxy:GetRaidIdWithSuitableLevel(roleLevel)
  if not self.levelSortedRaidDataArray then
    self.levelSortedRaidDataArray = MakeSortedArrayFromExpRaidTable("Level")
  end
  for i = #self.levelSortedRaidDataArray, 1, -1 do
    local raidData = self.levelSortedRaidDataArray[i]
    if roleLevel >= raidData.Level then
      return raidData.id
    end
  end
  return 0
end

function ExpRaidProxy:GetExpRaidScore()
  return MyselfProxy.Instance:GetExpRaidScore()
end

function ExpRaidProxy:GetExpRaidScoreInRaid()
  return MyselfProxy.Instance:GetExpRaidScoreInRaid()
end

function ExpRaidProxy:GetAllExpRaidScore()
  return self:GetExpRaidScore() + self:GetExpRaidScoreInRaid()
end

function ExpRaidProxy:GetShopNpc()
  return self.shopNpc
end

function ExpRaidProxy:GetShopItemDataOfCurrentNpc()
  return self:GetShopItemDataOfNpc(self.shopNpc.data.staticData.id)
end

function ExpRaidProxy:GetShopItemDataOfNpc(npcId)
  return self.shopNpcItemDataMap[npcId]
end

function ExpRaidProxy:GetAllShopItemDatas()
  return self.shopItemDataArr
end

function ExpRaidProxy:GetPriceOfItem(itemId)
  return self.itemPriceMap[itemId]
end

function ExpRaidProxy:CheckIsShopItemUnlocked(itemData)
  local id = itemData and itemData.staticData and itemData.staticData.id
  if not id or id <= 0 then
    return
  end
  local data = Table_ExpRaidshop[id]
  if not data then
    return
  end
  return FunctionUnLockFunc.Me():CheckCanOpen(data.MenuID)
end

function ExpRaidProxy:CallBuyItem(itemId, count)
  FunctionSecurity.Me():NormalOperation(function()
    ServiceFuBenCmdProxy.Instance:CallBuyExpRaidItemFubenCmd(itemId, count)
  end)
end

function ExpRaidProxy:CallBeginRaid()
  ServiceFuBenCmdProxy.Instance:CallBeginFireFubenCmd()
end

function ExpRaidProxy:RecvExpRaidResult(data)
  if not data then
    LogUtility.Warning("RecvExpRaidResult with data == nil")
    return
  end
  LogUtility.InfoFormat("Recv ExpRaidResult baseExp:{0}, jobExp:{1}, closeTime:{2}", data.baseexp, data.jobexp, data.closetime)
  LogUtility.InfoFormat("NowTime:{0}", math.floor(ServerTime.CurServerTime() / 1000))
  if not (data.baseexp and data.jobexp) or not data.closetime then
    LogUtility.Warning("RecvExpRaidResult with wrong data")
    return
  end
  self:CopyExpRaidResultData(data)
  self:sendNotification(UIEvent.ShowUI, {
    viewname = "BattleResultView",
    callback = function()
      self:sendNotification(UIEvent.JumpPanel, self.showResultNotifyBody)
    end
  })
end

function ExpRaidProxy:CopyExpRaidResultData(data)
  if not self.showResultNotifyBody then
    self.showResultNotifyBody = {}
    self.showResultNotifyBody.view = PanelConfig.ExpRaidResultView
    self.showResultNotifyBody.viewdata = {}
  end
  local viewdata = self.showResultNotifyBody.viewdata
  viewdata.baseexp = data.baseexp
  viewdata.jobexp = data.jobexp
  viewdata.closetime = data.closetime
  self.rewardDataArray = self.rewardDataArray or {}
  if next(self.rewardDataArray) then
    TableUtility.ArrayClear(self.rewardDataArray)
  end
  if data.items then
    for i = 1, #data.items do
      table.insert(self.rewardDataArray, DojoRewardData.new(data.items[i]))
    end
  end
  viewdata.items = self.rewardDataArray
end

function ExpRaidProxy:CheckIsMatching()
  local matchStatus, t = PvpProxy.Instance:GetCurMatchStatus()
  return matchStatus ~= nil and t == PvpProxy.Type.ExpRaid
end

function ExpRaidProxy:CheckBattleTimelenAndRemainingTimes()
  return BattleTimeDataProxy.Instance:CheckBattleTimelen() and self.remainingCount ~= nil and self.remainingCount > 0
end

function ExpRaidProxy:CheckShowBaseActivity(raidId, useRaidStartRoleLevel)
  local lv = raidId and Table_ExpRaid[raidId] and Table_ExpRaid[raidId].ExtrabaseLV or 0
  local myLv
  if useRaidStartRoleLevel then
    local raid = Game.DungeonManager.currentDungeon
    myLv = raid and raid.isExpRaid and raid.raidStartRoleLevel
  end
  if type(myLv) ~= "number" then
    myLv = MyselfProxy.Instance:RoleLevel()
  end
  return lv > myLv
end

function ExpRaidProxy:RecvExpRaidTimesLeft(data)
  self.remainingCount = data.rewardtimes or 0
  self.totalCount = data.totaltimes or 0
end

function ExpRaidProxy:GetExpRaidTimesLeft()
  return self.remainingCount, self.totalCount
end

function ExpRaidProxy:GetRewardSetting()
  local bitNum = PlayerPrefs.GetInt(LocalSaveProxy.SAVE_KEY.ExpRaidRewardChoose, 0)
  if not self.expRaidRewardSwitch then
    self.expRaidRewardSwitch = {}
    local i = 1
    for k, v in pairs(Table_ExpRaid) do
      local data = {}
      local value = self:GetBitByInt(bitNum, i)
      data.value = value
      data.id = i
      i = i + 1
      self.expRaidRewardSwitch[k] = data
    end
  end
  return bitNum
end

function ExpRaidProxy:GetSingleRewardSetting(i)
  if self.expRaidRewardSwitch[i] then
    return self.expRaidRewardSwitch[i].value
  end
end

function ExpRaidProxy:SaveRewardSetting(i)
  if self.expRaidRewardSwitch[i] then
    self.expRaidRewardSwitch[i].value = not self.expRaidRewardSwitch[i].value
  end
  local bitNum = 0
  for k, v in pairs(self.expRaidRewardSwitch) do
    bitNum = self:GetIntByBit(bitNum, v.id, not v.value)
  end
  PlayerPrefs.SetInt(PlayerPrefsExpRaidRewardChoose, bitNum)
end

function ExpRaidProxy:GetBitByInt(num, index)
  return num >> index & 1 == 0
end

function ExpRaidProxy:GetIntByBit(num, index, b)
  if b then
    num = num + (1 << index)
  end
  return num
end
