NoviceTarget2023Proxy = class("NoviceTarget2023Proxy", pm.Proxy)
local tempTable = {}
NoviceTarget2023Proxy.Enable = true

function NoviceTarget2023Proxy:ctor(proxyName, data)
  self.proxyName = proxyName or "NoviceTarget2023Proxy"
  if NoviceTarget2023Proxy.Instance == nil then
    NoviceTarget2023Proxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function NoviceTarget2023Proxy:Init()
  self.unlockedDay = {}
  self:InitStaticData()
  EventManager.Me():AddEventListener(MyselfEvent.MyDataChange, self.RefreshUnlockedDay, self)
end

function NoviceTarget2023Proxy:__TestRecvData()
  local datas = {
    {
      id = 301,
      progress = 10,
      state = 1
    }
  }
  local data = {datas = datas, day = 4}
  ServiceNUserProxy.Instance:RecvNoviceTargetUpdateUserCmd(data)
  local datas2 = {
    {day = 1, num = 5}
  }
  local data2 = {datas = datas2}
  ServiceNUserProxy.Instance:RecvNoviceTargetRewardUserCmd(data2)
end

local levelPointMap, dayTargetDataMap = {}, {}
local levelPointPerDayMap = {}
local sortFunc = function(l, r)
  local ls, rs = l.Sort or math.huge, r.Sort or math.huge
  return ls < rs
end
local dayGap = 10

function NoviceTarget2023Proxy:InitStaticData()
  local noviceTargetCFG = GameConfig.NewTopic
  self.currentVersion = 2 or noviceTargetCFG.CurVersion or 0
  self.NextTopicNeedPer = noviceTargetCFG.NextTopicNeedPer
  self.cfg = noviceTargetCFG.VersionCfg[self.currentVersion]
  self.dayList = {}
  self.DayNames = {}
  local dayData
  local cfgTable = self:GetCfgTable()
  local dayNames = self.cfg.DayNames
  for _, d in pairs(cfgTable) do
    if d.Day and dayNames[d.Day] then
      dayData = dayTargetDataMap[d.Day] or {}
      TableUtility.ArrayPushBack(dayData, d)
      dayTargetDataMap[d.Day] = dayData
      if TableUtility.ArrayFindIndex(self.dayList, d.Day) == 0 then
        TableUtility.ArrayPushBack(self.dayList, d.Day)
      end
      if d.Sort == 1 and dayNames[d.Day] then
        self.DayNames[d.Day] = dayNames[d.Day]
      end
    end
  end
  table.sort(self.dayList, function(l, r)
    return l < r
  end)
  if not self.cfg or not self.cfg.ProcessReward then
    return
  end
  for _dayIndex, _rewardInfo in pairs(self.cfg.ProcessReward) do
    local info = {
      times = {},
      static = _rewardInfo
    }
    for k, _ in pairs(_rewardInfo) do
      table.insert(info.times, k)
    end
    table.sort(info.times, function(l, r)
      return l < r
    end)
    levelPointPerDayMap[_dayIndex] = info
  end
  for _, tData in pairs(dayTargetDataMap) do
    table.sort(tData, sortFunc)
  end
  self:RefreshUnlockedDay()
end

function NoviceTarget2023Proxy:GetCfgTable()
  if not self.cfgTable then
    self.cfgTable = _G[self.cfg.TableName]
  end
  return self.cfgTable
end

function NoviceTarget2023Proxy:GetLevelPointStatusByDay(day, time)
  local rewardedList = self.processRewardStatus and self.processRewardStatus[day] or {}
  local currentLevelPoint = self:GetTargetCompleteCountOfDay(day)
  local rewarded = TableUtility.ArrayFindIndex(rewardedList, time) > 0
  local curLvReward = levelPointPerDayMap[day].static[time]
  return rewarded, curLvReward
end

function NoviceTarget2023Proxy:GetLevelPointRewarded(day, dayTimes)
  local rewardedList = self.processRewardStatus and self.processRewardStatus[day] or {}
  return TableUtility.ArrayFindIndex(rewardedList, dayTimes) > 0
end

function NoviceTarget2023Proxy:GetLevelTimesByDay(day)
  local times = levelPointPerDayMap[day] and levelPointPerDayMap[day].times
  return times
end

function NoviceTarget2023Proxy:GetProcessRewardAllGet(day)
  local times = self:GetLevelTimesByDay(day)
  local currentLevelPoint = self:GetTargetCompleteCountOfDay(day, true)
  if times and 0 < #times then
    local allGet = true
    for i = 1, #times do
      if currentLevelPoint >= times[i] then
        local rewarded, _ = self:GetLevelPointRewarded(day, times[i])
        if not rewarded then
          allGet = false
        end
      end
    end
    return allGet
  else
    return false
  end
end

function NoviceTarget2023Proxy:GetMaxLevel()
  return self.MaxDay
end

function NoviceTarget2023Proxy:GetTargetDataByDay(day)
  return dayTargetDataMap[day]
end

function NoviceTarget2023Proxy:GetTodayTargetData()
  return self:GetTargetDataByDay(self.today)
end

function NoviceTarget2023Proxy:RefreshUnlockedDay()
  if not self.cfg or not self.cfg.UnlockLevel then
    return
  end
  TableUtility.ArrayClear(self.unlockedDay)
  local roleLv = MyselfProxy.Instance:RoleLevel()
  for _dayIndex, _level in pairs(self.cfg.UnlockLevel) do
    if _level <= roleLv then
      table.insert(self.unlockedDay, _dayIndex)
    end
  end
  table.sort(self.unlockedDay, function(l, r)
    return l < r
  end)
end

function NoviceTarget2023Proxy:RecvNoviceTargetUpdate(datas, dels, today)
  self:RefreshUnlockedDay()
  self.targetProgressMap = self.targetProgressMap or {}
  self.targetStateMap = self.targetStateMap or {}
  local d
  for i = 1, #datas do
    d = datas[i]
    self.targetProgressMap[d.id] = d.progress
    self.targetStateMap[d.id] = d.state
  end
  if dels then
    for i = 1, #dels do
      d = dels[i]
      self.targetProgressMap[d] = nil
      self.targetStateMap[d] = nil
    end
  end
end

function NoviceTarget2023Proxy:CheckServerDataValid()
  return true
end

function NoviceTarget2023Proxy:CheckUnlocked()
  return true
end

function NoviceTarget2023Proxy:GetTargetProgress(id)
  return self.targetProgressMap and self.targetProgressMap[id]
end

function NoviceTarget2023Proxy:GetTargetState(id)
  return self.targetStateMap and self.targetStateMap[id]
end

function NoviceTarget2023Proxy:GetTargetCompleteCountOfDay(day, finishAll)
  local datas = self:GetTargetDataByDay(day)
  if not datas or not next(datas) then
    return 0
  end
  local completed, data = 0
  for i = 1, #datas do
    data = datas[i]
    if data.id < GameConfig.NoviceTargetPointCFG.UnlockFunctionId then
      completed = completed + (self:GetTargetState(data.id) == SceneUser2_pb.ENOVICE_TARGET_REWARDED and 1 or not finishAll and self:GetTargetState(data.id) == SceneUser2_pb.ENOVICE_TARGET_FINISH and 1 or 0)
    end
  end
  return completed
end

function NoviceTarget2023Proxy:IsAllTargetOfDayComplete(day, finishAll)
  local datas = self:GetTargetDataByDay(day)
  if not datas or not next(datas) then
    return false
  end
  local completed, data = true
  for i = 1, #datas do
    data = datas[i]
    if data.id < GameConfig.NoviceTargetPointCFG.UnlockFunctionId then
      completed = completed and self:GetTargetState(data.id) == SceneUser2_pb.ENOVICE_TARGET_REWARDED or not finishAll and completed and self:GetTargetState(data.id) == SceneUser2_pb.ENOVICE_TARGET_FINISH
    end
  end
  return completed
end

function NoviceTarget2023Proxy:IsAllTargetComplete()
  local complete = true
  for i = 1, #self.dayList do
    local dayIndex = self.dayList[i]
    complete = complete and self:IsAllTargetOfDayComplete(dayIndex, true)
  end
  return complete
end

function NoviceTarget2023Proxy:HasUnrewardedTarget()
  if not self.targetStateMap then
    return
  end
  local b = false
  for _, state in pairs(self.targetStateMap) do
    if state == SceneUser2_pb.ENOVICE_TARGET_FINISH then
      b = true
      break
    end
  end
  return b
end

function NoviceTarget2023Proxy:GetFirstDayWithUnrewardedTarget()
  if not self.targetStateMap then
    return
  end
  TableUtility.TableClear(tempTable)
  for id, state in pairs(self.targetStateMap) do
    if state == SceneUser2_pb.ENOVICE_TARGET_FINISH then
      TableUtility.ArrayPushBack(tempTable, id)
    end
  end
  table.sort(tempTable)
  local day = tempTable[1] and self:GetCfgTable()[tempTable[1]].Day or nil
  day = day and math.clamp(day, 1, self.unlockedDay and self.unlockedDay[#self.unlockedDay] or 1)
  return day
end

NoviceTarget2023Proxy.TPROJECT = 998
NoviceTarget2023Proxy.REDTIP_PROJECT_LIST = 10735
NoviceTarget2023Proxy.REDTIP_PROJECT_BOX = 10737

function NoviceTarget2023Proxy:GetProjectSmallList()
  if not self.smallList then
    self.smallList = {}
  else
    TableUtility.ArrayClear(self.smallList)
  end
  for i = 1, #self.dayList do
    local dayIndex = self.dayList[i]
    local name = self:GetDayNames(dayIndex)
    table.insert(self.smallList, {
      id = dayIndex,
      level = self.cfg.UnlockLevel[dayIndex],
      red = self:IsDayHas_REWARDED_NOT_GET(dayIndex) or not self:GetProcessRewardAllGet(dayIndex),
      s_lock = TableUtility.ArrayFindIndex(self.unlockedDay, dayIndex) == 0,
      s_fin = self:IsAllTargetOfDayComplete(dayIndex),
      name = name,
      isFirst = i == 1,
      isNumberLv = StringUtil.GetNumberInString(name) ~= nil
    })
  end
  return self.smallList
end

function NoviceTarget2023Proxy:GetDayNames(day)
  return self.cfg and self.cfg.DayNames and self.cfg.DayNames[day]
end

function NoviceTarget2023Proxy:GetProjectList(small_id, rm_ENOVICE_TARGET_LOCKED)
  local datas = self:GetTargetDataByDay(small_id)
  local list = {}
  for i = 1, #datas do
    local state = self:GetTargetState(datas[i].id)
    if state == SceneUser2_pb.ENOVICE_TARGET_LOCKED and rm_ENOVICE_TARGET_LOCKED then
    else
      local data = table.deepcopy(datas[i])
      data.ISPROJECT = true
      list[#list + 1] = data
    end
  end
  return list
end

function NoviceTarget2023Proxy:IsDayAbleToUnlockNext(day)
  local unlock_pct = GameConfig.NewTopic.NextTopicNeedPer / 100
  if day > self.today then
    return false
  end
  if day >= #self.dayList then
    return true
  end
  local dayDatas = dayTargetDataMap[day]
  if not dayDatas or not next(dayDatas) then
    return true
  end
  local passed_count = 0
  for i = 1, #dayDatas do
    if dayDatas[i].id then
      local a = self:GetTargetState(dayDatas[i].id)
      if a == SceneUser2_pb.ENOVICE_TARGET_FINISH or a == SceneUser2_pb.ENOVICE_TARGET_REWARDED then
        passed_count = passed_count + 1
      end
    end
  end
  local pct = passed_count / #dayDatas
  return unlock_pct <= pct
end

function NoviceTarget2023Proxy:IsDayHas_REWARDED_NOT_GET(day)
  if TableUtility.ArrayFindIndex(self.dayList, day) == 0 then
    return
  end
  local dayDatas = dayTargetDataMap[day]
  if not dayDatas or not next(dayDatas) then
    return false
  end
  for i = 1, #dayDatas do
    if dayDatas[i].id then
      local a = self:GetTargetState(dayDatas[i].id)
      if a == SceneUser2_pb.ENOVICE_TARGET_FINISH then
        return true
      end
    end
  end
  return false
end

function NoviceTarget2023Proxy:RecvNoviceTargetProgressReward(data)
  if not self.processRewardStatus then
    self.processRewardStatus = {}
  end
  for i = 1, #data do
    local unlockedList = {}
    TableUtility.ArrayShallowCopy(unlockedList, data[i].nums)
    self.processRewardStatus[data[i].day] = unlockedList
  end
end

function NoviceTarget2023Proxy:GetAllRewardDataStatus()
  local rewardList = {}
  local get = {}
  local notget = {}
  local cfgTable = self:GetCfgTable()
  local re, list, is_get, ta
  for id, d in pairs(cfgTable) do
    re = d.Reward
    is_get = self:GetTargetState(id) == SceneUser2_pb.ENOVICE_TARGET_REWARDED
    ta = is_get and get or notget
    for _, v in pairs(re) do
      list = ItemUtil.GetRewardItemIdsByTeamId(v)
      if list then
        for i = 1, #list do
          local single = list[i]
          if not ta[single.id] then
            ta[single.id] = 0
          end
          ta[single.id] = ta[single.id] + single.num
        end
      end
    end
  end
  local d, sr, rw
  for day, ddd in pairs(levelPointPerDayMap) do
    d = ddd.static
    sr = self.processRewardStatus and self.processRewardStatus[day] or {}
    for k, v in pairs(d) do
      is_get = 0 < TableUtility.ArrayFindIndex(sr, k)
      ta = is_get and get or notget
      rw = v
      for i = 1, #rw do
        local single = rw[i]
        if not ta[single[1]] then
          ta[single[1]] = 0
        end
        ta[single[1]] = ta[single[1]] + single[2]
      end
    end
  end
  local te = {}
  for k, v in pairs(get) do
    local itemData = ItemData.new("Reward", k)
    if itemData then
      itemData:SetItemNum(v)
      itemData.get = true
      table.insert(te, itemData)
    end
  end
  table.sort(te, function(l, r)
    if l.staticData.Quality == r.staticData.Quality then
      return l.staticData.id < r.staticData.id
    end
    return l.staticData.Quality > r.staticData.Quality
  end)
  for i = 1, #te do
    table.insert(rewardList, te[i])
  end
  te = {}
  for k, v in pairs(notget) do
    local itemData = ItemData.new("Reward", k)
    if itemData then
      itemData:SetItemNum(v)
      itemData.get = false
      table.insert(te, itemData)
    end
  end
  table.sort(te, function(l, r)
    if l.staticData.Quality == r.staticData.Quality then
      return l.staticData.id < r.staticData.id
    end
    return l.staticData.Quality > r.staticData.Quality
  end)
  for i = 1, #te do
    table.insert(rewardList, te[i])
  end
  return rewardList
end
