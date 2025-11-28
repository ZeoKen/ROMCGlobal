SignIn21Proxy = class("SignIn21Proxy", pm.Proxy)
local tempTable = {}

function SignIn21Proxy:ctor(proxyName, data)
  self.proxyName = proxyName or "SignIn21Proxy"
  if SignIn21Proxy.Instance == nil then
    SignIn21Proxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function SignIn21Proxy:Init()
  self.today = 0
  self:InitStaticData()
end

local levelPointMap, dayTargetDataMap = {}, {}
local sortFunc = function(l, r)
  local ls, rs = l.Sort or math.huge, r.Sort or math.huge
  return ls < rs
end

function SignIn21Proxy:InitStaticData()
  if NoviceTarget2023Proxy and NoviceTarget2023Proxy.Enable then
    return
  end
  local noviceTargetCFG = GameConfig.NewTopic
  self.currentVersion = noviceTargetCFG.CurVersion or 0
  self.NextTopicNeedPer = noviceTargetCFG.NextTopicNeedPer
  self.cfg = noviceTargetCFG.VersionCfg[self.currentVersion]
  self.MaxDay = 0
  self.DayNames = {}
  local dayData
  for _, d in pairs(_G[self.cfg.TableName]) do
    dayData = dayTargetDataMap[d.Day] or {}
    TableUtility.ArrayPushBack(dayData, d)
    dayTargetDataMap[d.Day] = dayData
    if d.Day > self.MaxDay then
      self.MaxDay = d.Day
    end
    if d.Sort == 1 and d.DayName then
      self.DayNames[d.Day] = d.DayName
    end
  end
  self.cfg = self.cfg and self.cfg.Reward
  if self.cfg then
    for i = 1, #self.cfg do
      levelPointMap[i] = self.cfg[i].score
    end
  end
  levelPointMap[0] = 0
  for _, tData in pairs(dayTargetDataMap) do
    table.sort(tData, sortFunc)
  end
end

function SignIn21Proxy:GetLevelFromTargetPoint(score)
  if not next(levelPointMap) then
    return
  end
  score = math.max(score or 0, 0)
  for i = 0, self:GetMaxLevel() - 1 do
    if score >= levelPointMap[i] and score < levelPointMap[i + 1] then
      return i
    end
  end
  return self:GetMaxLevel()
end

function SignIn21Proxy:GetProgressFromTargetPoint(score, calculatedLevel)
  calculatedLevel = calculatedLevel or self:GetLevelFromTargetPoint(score)
  if not calculatedLevel or not score then
    return
  end
  local nextLevelPoint = levelPointMap[calculatedLevel + 1]
  return nextLevelPoint and (score - levelPointMap[calculatedLevel]) / (nextLevelPoint - levelPointMap[calculatedLevel]) or 1
end

function SignIn21Proxy:GetLevelAndProgressFromTargetPoint(score)
  score = score or self:GetMyTargetPoint()
  local level = self:GetLevelFromTargetPoint(score)
  return level, self:GetProgressFromTargetPoint(score, level)
end

function SignIn21Proxy:GetRewardItemIdsFromTargetLevel(level)
  local cfg = self.cfg and self.cfg[level]
  return cfg
end

function SignIn21Proxy:GetMaxLevel()
  return #self.cfg
end

function SignIn21Proxy:GetTargetDataByDay(day)
  return dayTargetDataMap[day]
end

function SignIn21Proxy:GetTodayTargetData()
  return self:GetTargetDataByDay(self.today)
end

function SignIn21Proxy:RecvNoviceTargetUpdate(datas, dels, today)
  if NoviceTarget2023Proxy and NoviceTarget2023Proxy.Enable then
    return
  end
  self.today = today
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

function SignIn21Proxy:GetTargetProgress(id)
  return self.targetProgressMap[id]
end

function SignIn21Proxy:GetTargetState(id)
  return self.targetStateMap[id]
end

function SignIn21Proxy:IsAllTargetOfDayComplete(day, finishAll)
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

function SignIn21Proxy:IsAllTargetOfTodayComplete()
  return self:IsAllTargetOfDayComplete(self.today)
end

function SignIn21Proxy:IsAllTargetComplete()
  local complete = true
  for i = 1, self.MaxDay do
    complete = complete and self:IsAllTargetOfDayComplete(i, true)
  end
  return complete
end

function SignIn21Proxy:HasUnrewardedTarget()
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

function SignIn21Proxy:GetFirstDayWithUnrewardedTarget()
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
  local day = tempTable[1] and Table_NoviceTarget[tempTable[1]].Day or nil
  day = day and math.clamp(day, 1, self.today)
  return day
end

function SignIn21Proxy:GetMyTargetPoint()
  return Game.Myself.data.userdata:Get("NEW_TOPIC_SCORE") or 0
end

function SignIn21Proxy:GetMyRewardedLv()
  return Game.Myself.data.userdata:Get("NEW_TOPIC_REWARDED_LEVEL") or 0
end

SignIn21Proxy.TPROJECT = 998
SignIn21Proxy.REDTIP_PROJECT_LIST = 10735
SignIn21Proxy.REDTIP_PROJECT_BOX = 10737

function SignIn21Proxy:GetProjectSmallList()
  local list = {}
  for i = 1, math.min(self.MaxDay, self.today) do
    table.insert(list, {
      id = i,
      name = self.DayNames[i] or ZhString.Servant_Recommend_PageProject .. tostring(i),
      red = self:IsDayHas_REWARDED_NOT_GET(i)
    })
  end
  return list
end

function SignIn21Proxy:GetProjectProgressList()
  local list = {}
  local playerPoint = self:GetMyTargetPoint()
  local plyerRewardedLv = self:GetMyRewardedLv()
  for i = 1, #self.cfg do
    table.insert(list, {
      lv = i,
      overrideText = self.cfg[i].score,
      score = self.cfg[i].score,
      achieved = playerPoint >= self.cfg[i].score,
      lingle = i <= plyerRewardedLv,
      child = self.cfg[i].reward
    })
  end
  return list
end

function SignIn21Proxy:GetProjectList(small_id, rm_ENOVICE_TARGET_LOCKED)
  local datas = self:GetTargetDataByDay(small_id)
  local list = {}
  for i = 1, #datas do
    local state = self:GetTargetState(datas[i].id)
    if state == SceneUser2_pb.ENOVICE_TARGET_LOCKED and rm_ENOVICE_TARGET_LOCKED then
    else
      local data = {}
      TableUtility.TableShallowCopy(data, datas[i])
      data.ISPROJECT = true
      list[#list + 1] = data
    end
  end
  return list
end

function SignIn21Proxy:IsAllLevelRewardGet()
  local curLv = self:GetLevelFromTargetPoint(self:GetMyTargetPoint())
  local rewardLv = self:GetMyRewardedLv()
  return curLv <= rewardLv
end

function SignIn21Proxy:GetNextTargetPoint()
  local score = self:GetMyTargetPoint()
  for i = 1, #levelPointMap do
    if score <= levelPointMap[i] then
      return levelPointMap[i]
    end
  end
  return levelPointMap[#levelPointMap]
end

local unlock_pct = 0.8

function SignIn21Proxy:IsDayAbleToUnlockNext(day)
  if day > self.today then
    return false
  end
  if day >= self.MaxDay then
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
  return pct >= unlock_pct
end

function SignIn21Proxy:IsDayHas_REWARDED_NOT_GET(day)
  if day >= self.MaxDay then
    return false
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
