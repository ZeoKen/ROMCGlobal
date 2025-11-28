ActivityPuzzleProxy = class("ActivityPuzzleProxy", pm.Proxy)
ActivityPuzzleProxy.Instance = nil
ActivityPuzzleProxy.NAME = "ActivityPuzzleProxy"

function ActivityPuzzleProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ActivityPuzzleProxy.NAME
  if ActivityPuzzleProxy.Instance == nil then
    ActivityPuzzleProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.activityPuzzleDataMap = {}
  self.isInited = false
end

local GetActivityPuzzleData = function(activityId, puzzleId)
  for i, v in pairs(Table_ActivityPuzzle) do
    if v.ActivityID == activityId and v.PuzzleID == puzzleId then
      return v
    end
  end
  return nil
end

function ActivityPuzzleProxy:InitProxyData()
  TableUtility.TableClear(self.activityPuzzleDataMap)
end

function ActivityPuzzleProxy:GetActivityPuzzleDatas(actId)
  return self.activityPuzzleDataMap[actId]
end

function ActivityPuzzleProxy:GetActivityPuzzleItemData(actId, puzzleId)
  local puzzleData = self.activityPuzzleDataMap[actId]
  if puzzleData and puzzleData.puzzleItemMap then
    return puzzleData.puzzleItemMap[puzzleId]
  end
  return nil
end

function ActivityPuzzleProxy:GetActivityPuzzleDataList()
  local activityPuzzleDataList = {}
  if not self.activityPuzzleDataMap then
    return {}
  end
  local pid = 0
  for k, v in pairs(self.activityPuzzleDataMap) do
    table.insert(activityPuzzleDataList, v)
  end
  if #activityPuzzleDataList ~= 0 then
    table.sort(activityPuzzleDataList, function(l, r)
      return l.actid < r.actid
    end)
  end
  return activityPuzzleDataList
end

function ActivityPuzzleProxy:GetActivityPuzzleProgress(actId)
  local puzzleData = self.activityPuzzleDataMap[actId]
  local progress = 0
  if puzzleData then
    local itemList = puzzleData.puzzleItemList
    if itemList and 0 < #itemList then
      local lastBigestUnlockTime = 0
      for i = 1, #itemList do
        local staticData = GetActivityPuzzleData(itemList[i].actid, itemList[i].puzzled)
        if staticData and staticData.UnlockType == 100 and staticData.UnlockTime and lastBigestUnlockTime < staticData.UnlockTime then
          progress = itemList[i].process
          lastBigestUnlockTime = staticData.UnlockTime
        end
      end
    end
  end
  return progress
end

function ActivityPuzzleProxy:HandleRecvActivityPuzzleDataCmd(data)
  local actItems = data.actitem
  if actItems and 0 < #actItems then
    for i = 1, #actItems do
      local actItem = actItems[i]
      local activityId = actItem.actid
      if (not activityId or activityId == 0) and actItem.items and 0 < #actItem.items then
        activityId = actItem.items[1].actid
      end
      if activityId and activityId ~= 0 then
        local oldData = self.activityPuzzleDataMap[activityId]
        if not oldData then
          self.activityPuzzleDataMap[activityId] = ActivityPuzzleData.new(actItem, activityId)
        else
          oldData:updata(actItem, activityId)
        end
      end
    end
  end
end

function ActivityPuzzleProxy:InitActivityPuzzleData(id, startTime, endTime)
  if id and Table_ActivityInfo[id] then
    local actItem = {actid = id}
    local oldData = self.activityPuzzleDataMap[id]
    if not oldData then
      self.activityPuzzleDataMap[id] = ActivityPuzzleData.new(actItem, id, startTime, endTime)
    else
      oldData:SetDuration(startTime, endTime)
    end
  end
end

function ActivityPuzzleProxy:HandleRecvActivityIdUpdateCmd(data)
  local updateIds = data.update_ids
  if updateIds and 0 < #updateIds then
    for i = 1, #updateIds do
      local actItem = {
        actid = updateIds[i]
      }
      local oldData = self.activityPuzzleDataMap[actItem.actid]
      if not oldData then
        local activityPuzzleData = ActivityPuzzleData.new(actItem, actItem.actid)
        self.activityPuzzleDataMap[actItem.actid] = activityPuzzleData
      else
        oldData:updata(actItem, actItem.actid)
      end
    end
  end
  local delIds = data.del_ids
  if delIds and 0 < #delIds then
    for i = 1, #delIds do
      self.activityPuzzleDataMap[delIds[i]] = nil
    end
  end
end

function ActivityPuzzleProxy:HandleRecvUpdatePuzzleItemCmd(data)
  local actItems = data.items
  if actItems and 0 < #actItems then
    for i = 1, #actItems do
      local item = actItems[i]
      local itemList = {}
      itemList[1] = item
      local actItem = {
        actid = item.actid,
        items = itemList
      }
      local oldData = self.activityPuzzleDataMap[actItem.actid]
      if not oldData then
        local activityPuzzleData = ActivityPuzzleData.new(actItem, actItem.actid)
        self.activityPuzzleDataMap[actItem.actid] = activityPuzzleData
      else
        oldData:updata(actItem, actItem.actid)
      end
    end
  end
end

function ActivityPuzzleProxy:RecvActivityPuzzleList(params, startTime, endTime)
  for i = 1, #params do
    self:InitActivityPuzzleData(params[i], startTime, endTime)
  end
end

function ActivityPuzzleProxy:ClearActivityPuzzleList(params)
  if params and self.activityPuzzleDataMap then
    for i = 1, #params do
      if self.activityPuzzleDataMap[params[i]] then
        self.activityPuzzleDataMap[params[i]] = nil
      end
    end
  end
end

function ActivityPuzzleProxy:IsActivityRunning()
  return FunctionActivity.Me():IsActivityRunning(ActivityCmd_pb.GACTIVITY_PUZZLE) or FunctionActivity.Me():IsActivityRunning(ActivityCmd_pb.GACTIVITY_PUZZLE_2) or FunctionActivity.Me():IsActivityRunning(ActivityCmd_pb.GACTIVITY_PUZZLE_3) or FunctionActivity.Me():IsActivityRunning(ActivityCmd_pb.GACTIVITY_PUZZLE_4)
end

function ActivityPuzzleProxy:GetDuration(actid)
  if self.activityPuzzleDataMap and actid and self.activityPuzzleDataMap[actid] then
    return self.activityPuzzleDataMap[actid]:GetDuration()
  end
  return 0, 0
end

function ActivityPuzzleProxy:CheckUpdateRedtip(actid)
  if self.activityPuzzleDataMap and actid then
    local activitydata = self.activityPuzzleDataMap[actid]
    if activitydata then
      return activitydata:CheckUpdateRedtip()
    end
  end
  return false
end

local starttime = 1
local endtime = 1

function ActivityPuzzleProxy:GetPuzzleItemDate(staticData)
  if not staticData then
    return 0, 0
  end
  if staticData.goStarttime and staticData.goEndtime then
    return staticData.goStarttime, staticData.goEndtime
  end
  if EnvChannel.IsTFBranch() then
    if staticData.TFGoStartTime and staticData.TFGoStartTime ~= "" then
      local st_year, st_month, st_day, st_hour, st_min, st_sec = StringUtil.GetDateData(staticData.TFGoStartTime)
      starttime = os.time({
        day = st_day,
        month = st_month,
        year = st_year,
        hour = st_hour,
        min = st_min,
        sec = st_sec
      })
      staticData.goStarttime = starttime
    end
    if staticData.TFGoEndTime and staticData.TFGoEndTime ~= "" then
      local end_year, end_month, end_day, end_hour, end_min, end_sec = StringUtil.GetDateData(staticData.TFGoEndTime)
      endtime = os.time({
        day = end_day,
        month = end_month,
        year = end_year,
        hour = end_hour,
        min = end_min,
        sec = end_sec
      })
      staticData.goEndtime = endtime
    end
    return staticData.goStarttime, staticData.goEndtime
  end
  if EnvChannel.IsReleaseBranch() then
    if staticData.GoStartTime and staticData.GoStartTime ~= "" then
      local st_year, st_month, st_day, st_hour, st_min, st_sec = StringUtil.GetDateData(staticData.GoStartTime)
      starttime = os.time({
        day = st_day,
        month = st_month,
        year = st_year,
        hour = st_hour,
        min = st_min,
        sec = st_sec
      })
      staticData.goStarttime = starttime
    end
    if staticData.GoEndTime and staticData.GoEndTime ~= "" then
      local end_year, end_month, end_day, end_hour, end_min, end_sec = StringUtil.GetDateData(staticData.GoEndTime)
      endtime = os.time({
        day = end_day,
        month = end_month,
        year = end_year,
        hour = end_hour,
        min = end_min,
        sec = end_sec
      })
      staticData.goEndtime = endtime
    end
    return staticData.goStarttime, staticData.goEndtime
  end
  return 0, 0
end

ActivityPuzzleData = class("ActivityPuzzleData")

function ActivityPuzzleData:ctor(data, activityId, startTime, endTime)
  self.actid = activityId
  if not self.puzzleItemList then
    self.puzzleItemList = {}
    self.puzzleItemMap = {}
  end
  local ai = Table_ActivityInfo[self.actid]
  if ai and ai.Size then
    for i = 1, ai.Size do
      local newPuzzleItem = ActivityPuzzleItem.new()
      self.puzzleItemMap[i] = newPuzzleItem
      self.puzzleItemList[#self.puzzleItemList + 1] = newPuzzleItem
    end
  end
  if ai.Extra == 1 then
    local newPuzzleItem = ActivityPuzzleItem.new()
    self.puzzleItemMap[0] = newPuzzleItem
    self.puzzleItemList[#self.puzzleItemList + 1] = newPuzzleItem
  end
  if data then
    self:updata(data, activityId)
  end
  self.startTime = startTime
  self.endTime = endTime
end

function ActivityPuzzleData:updata(data, activityId)
  self.actid = activityId
  local puzzleItems = data.items
  if not self.puzzleItemList then
    self.puzzleItemList = {}
    self.puzzleItemMap = {}
  end
  if puzzleItems and 0 < #puzzleItems then
    for i = 1, #puzzleItems do
      local item = puzzleItems[i]
      if type(item) ~= "table" then
        item = {item}
      end
      local puzzleId = item.puzzled
      local oldPuzzleItem = self.puzzleItemMap[puzzleId]
      if oldPuzzleItem then
        oldPuzzleItem:updata(item)
      else
        local newPuzzleItem = ActivityPuzzleItem.new(item)
        self.puzzleItemMap[puzzleId] = newPuzzleItem
        self.puzzleItemList[#self.puzzleItemList + 1] = newPuzzleItem
      end
    end
  end
end

function ActivityPuzzleData:SetDuration(startTime, endTime)
  self.startTime = startTime
  self.endTime = endTime
end

function ActivityPuzzleData:GetDuration()
  return self.startTime, self.endTime
end

function ActivityPuzzleData:CheckUpdateRedtip()
  local count = 0
  if self.puzzleItemList then
    local length = #self.puzzleItemList
    for i = 1, length do
      if self.puzzleItemList[i].PuzzleState == PuzzleCmd_pb.EPUZZLESTATE_CANACTIVE then
        count = count + 1
      end
    end
  end
  return count <= 1
end

ActivityPuzzleItem = class("ActivityPuzzleItem")

function ActivityPuzzleItem:ctor(data)
  self.puzzled = 0
  self.process = 0
  self.PuzzleState = EPUZZLESTATE_MIN
  if data then
    self:updata(data)
  end
end

function ActivityPuzzleItem:updata(data)
  self.actid = data.actid
  self.puzzled = data.puzzled
  self.process = data.process
  self.PuzzleState = data.state
end

function ActivityPuzzleItem:IsUnlock()
  return self.PuzzleState == PuzzleCmd_pb.EPUZZLESTATE_CANACTIVE or self.PuzzleState == PuzzleCmd_pb.EPUZZLESTATE_ACTIVE
end
