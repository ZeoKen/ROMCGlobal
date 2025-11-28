autoImport("ActivityData")
FunctionActivity = class("FunctionActivity")
local math_floor = math.floor
local tempArray = {}
FunctionActivity.LogEnable = false
FunctionActivity.TraceType = {
  NeedRefresh = 0,
  Refreshed = 1,
  Update = 2
}
local MapManager
local f_GetType = ActivityData.GetTraceQuestDataType
local f_GetId = ActivityData.CreateIdByType

function FunctionActivity.Me()
  if nil == FunctionActivity.me then
    FunctionActivity.me = FunctionActivity.new()
  end
  return FunctionActivity.me
end

function FunctionActivity:ctor()
  self.activityDataMap = {}
  self.tracedActivityMap = {}
  self.countDownDataMap = {}
  self.activityExceptDataMap = {}
  self:InitKFC_GroupEffect()
  self:AddEvts()
  MapManager = Game.MapManager
end

function FunctionActivity:AddEvts()
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles, self.CheckGroupEffect, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneRemoveRoles, self.CheckRemoveGroupEffect, self)
end

function FunctionActivity:CheckRemoveGroupEffect(ids)
  local groupEffectUserMap = NSceneUserProxy.Instance.groupEffectUser
  if not groupEffectUserMap then
    return
  end
  for i = 1, #ids do
    if groupEffectUserMap[ids[i]] then
      NSceneUserProxy.Instance:FindGroupUserByPath()
      break
    end
  end
end

function FunctionActivity:CheckGroupEffect(roles)
  local activeFunc = FunctionActivity.Me()
  for i = 1, #roles do
    local userdata = roles[i].data.userdata
    local head = userdata:Get(UDEnum.HEAD) or 0
    local mount = userdata:Get(UDEnum.MOUNT) or 0
    if activeFunc:CheckIsKfcEffectEquip(head) or activeFunc:CheckIsKfcEffectEquip(mount) then
      NSceneUserProxy.Instance:FindGroupUserByPath()
      break
    end
  end
end

function FunctionActivity:GetMapEvents(mapid)
  TableUtility.ArrayClear(tempArray)
  for activityType, activityData in pairs(self.activityDataMap) do
    if activityData.mapid == mapid then
      table.insert(tempArray, activityData)
    end
  end
  return tempArray
end

function FunctionActivity:Launch(activityType, mapid, startTime, endTime)
  if FunctionActivity.LogEnable then
    local logStr = ""
    logStr = "活动开启 --> "
    local dateFormat = "%m:%d %H:%M:%S秒"
    logStr = logStr .. string.format(" | activityType:%s | 地图Id:%s | 开始时间:%s | 结束时间:%s | 当前时间:%s | ", tostring(activityType), tostring(mapid), os.date(dateFormat, startTime), os.date(dateFormat, endTime), os.date(dateFormat, ServerTime.CurServerTime() / 1000))
    helplog(logStr)
  end
  local activityData = self.activityDataMap[activityType]
  if activityData == nil then
    activityData = self:AddActivityData(activityType, mapid, startTime, endTime)
  else
    activityData:UpdateInfo(mapid, startTime, endTime)
  end
  if activityData:IsShowInMenu() then
    GameFacade.Instance:sendNotification(MainViewEvent.MenuActivityOpen, activityType)
  end
  if activityType == GameConfig.MvpBattle.ActivityID then
    GameFacade.Instance:sendNotification(MainViewEvent.UpdateMatchBtn)
  elseif activityType == GameConfig.Activity.SaveCapra.ActivityID then
    GameFacade.Instance:sendNotification(MainViewEvent.SaveKapraUpdate)
  elseif MoroccTimeProxy.Instance:CheckActivityValid(activityType) then
    GameFacade.Instance:sendNotification(MoroccTimeEvent.ActivityOpen)
  elseif GameConfig.Activity.BigCatInvade and activityType == GameConfig.Activity.BigCatInvade.ActivityID then
    GameFacade.Instance:sendNotification(MainViewEvent.BigCatInvadeUpdate)
  end
  self:UpdateNowMapTraceInfo()
end

function FunctionActivity:UpdateState(activityType, state, starttime, endtime)
  local activityData = self.activityDataMap[activityType]
  if activityData then
    activityData:SetState(state, starttime, endtime)
    self:UpdateNowMapTraceInfo()
  else
    errorLog(string.format("Activity:%s not Launch when Recv StateUpdate", tostring(activityType)))
  end
end

function FunctionActivity:UpdateActExceptData(data)
  local ids = data.ids
  if ids and 0 < #ids then
    for i = 1, #ids do
      local activityType = ids[i]
      local exceptData = self.activityExceptDataMap[activityType]
      if not exceptData or exceptData ~= 1 then
        self.activityExceptDataMap[activityType] = 1
      end
    end
  end
  self:UpdateNowMapTraceInfo()
end

function FunctionActivity:IsActivityRunning(activityType)
  local d = self.activityDataMap[activityType]
  if d == nil then
    return false
  end
  return d:InRunningTime()
end

function FunctionActivity:GetActivityData(activityType)
  return self.activityDataMap[activityType]
end

function FunctionActivity:AddActivityData(activityType, mapid, startTime, endTime)
  local activityData = ActivityData.new(activityType, mapid, startTime, endTime)
  self.activityDataMap[activityType] = activityData
  return activityData
end

function FunctionActivity:RemoveActivityData(activityType)
  local oldData = self.activityDataMap[activityType]
  self.activityDataMap[activityType] = nil
  if not oldData then
    return
  end
  if activityType == GameConfig.Activity.SaveCapra.ActivityID then
    GameFacade.Instance:sendNotification(MainViewEvent.SaveKapraUpdate)
  elseif GameConfig.Activity.BigCatInvade and activityType == GameConfig.Activity.BigCatInvade.ActivityID then
    GameFacade.Instance:sendNotification(MainViewEvent.BigCatInvadeUpdate)
  end
  if oldData:IsShowInMenu() then
    GameFacade.Instance:sendNotification(MainViewEvent.MenuActivityClose, activityType)
  end
  if MoroccTimeProxy.Instance:CheckActivityValid(activityType) then
    GameFacade.Instance:sendNotification(MoroccTimeEvent.ActivityClose)
  end
  oldData:Destroy()
end

local removeTraceCells = {}

function FunctionActivity:UpdateNowMapTraceInfo()
  for activityType, _ in pairs(self.tracedActivityMap) do
    if not self.activityDataMap[activityType] or self.activityExceptDataMap[activityType] == 1 then
      local data = {}
      data.id = f_GetId(activityType)
      data.type = f_GetType(activityType)
      table.insert(removeTraceCells, data)
      self.tracedActivityMap[activityType] = nil
    end
  end
  local tracedCount = 0
  local nowMapId = MapManager:GetMapID()
  for activityType, activityData in pairs(self.activityDataMap) do
    local needTrace = activityData:IsNeedTrace(nowMapId)
    if needTrace and self.activityExceptDataMap[activityType] ~= 1 then
      if activityData:IsTraceInfo_NeedUpdate() then
        self.tracedActivityMap[activityType] = FunctionActivity.TraceType.Update
      else
        self.tracedActivityMap[activityType] = FunctionActivity.TraceType.NeedRefresh
      end
      tracedCount = tracedCount + 1
    elseif self.tracedActivityMap[activityType] then
      local data = {}
      data.id = f_GetId(activityType)
      data.type = f_GetType(activityType)
      table.insert(removeTraceCells, data)
      self.tracedActivityMap[activityType] = nil
    end
  end
  if 0 < #removeTraceCells then
    QuestProxy.Instance:RemoveTraceCells(removeTraceCells)
    TableUtility.ArrayClear(removeTraceCells)
  end
  if tracedCount == 0 then
    self:RemoveTraceTimeTick()
  else
    self:AddTraceTimeTick()
  end
end

local cache_RunningMap = {}

function FunctionActivity:AddTraceTimeTick()
  if not self.traceTimeTick then
    TableUtility.TableClear(cache_RunningMap)
    self.traceTimeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateActivityTraceInfos, self, 1)
  end
end

function FunctionActivity:RemoveTraceTimeTick()
  if self.traceTimeTick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.traceTimeTick = nil
    TableUtility.TableClear(cache_RunningMap)
  end
end

local updateTraceCells = {}

function FunctionActivity:UpdateActivityTraceInfos()
  local needUpdate, activityData
  local nowMapId = MapManager:GetMapID()
  for traceAType, traceType in pairs(self.tracedActivityMap) do
    needUpdate = false
    activityData = self.activityDataMap[traceAType]
    local running = activityData:InRunningTime()
    if traceType == FunctionActivity.TraceType.NeedRefresh then
      self.tracedActivityMap[traceAType] = FunctionActivity.TraceType.Refreshed
      needUpdate = true
    elseif traceType == FunctionActivity.TraceType.Update and running then
      needUpdate = true
    end
    if activityData == nil then
      self.tracedActivityMap[traceAType] = nil
      redlog(string.format("activity(type:%s) accident break.", traceAType))
    end
    if running ~= cache_RunningMap[traceAType] then
      needUpdate = running
      if not running then
        local data = {}
        data.id = f_GetId(traceAType)
        data.type = f_GetType(traceAType)
        table.insert(removeTraceCells, data)
      end
      cache_RunningMap[traceAType] = running
    end
    if needUpdate then
      local traceInfo = activityData:GetTraceInfo(nowMapId)
      if traceInfo then
        if activityData.configData and activityData.configData.MenuId then
          if FunctionUnLockFunc.Me():CheckCanOpen(activityData.configData.MenuId) then
            table.insert(updateTraceCells, traceInfo)
          end
        else
          table.insert(updateTraceCells, traceInfo)
        end
      end
    end
  end
  if 0 < #updateTraceCells then
    QuestProxy.Instance:AddTraceCells(updateTraceCells)
    TableUtility.ArrayClear(updateTraceCells)
  end
  if 0 < #removeTraceCells then
    QuestProxy.Instance:RemoveTraceCells(removeTraceCells)
    TableUtility.ArrayClear(removeTraceCells)
  end
end

function FunctionActivity:ShutDownActivity(activityType)
  if activityType == nil then
    redlog("activityType is nil")
    return
  end
  self:RemoveActivityData(activityType)
  self:UpdateNowMapTraceInfo()
end

function FunctionActivity:Reset()
  for activityType, activityData in pairs(self.activityDataMap) do
    self:RemoveActivityData(activityType)
  end
  self:UpdateNowMapTraceInfo()
end

function FunctionActivity:AddCountDownAct(id, startTime, endTime)
  local effectConfig = GameConfig.ActivityCountDown and GameConfig.ActivityCountDown[id]
  if effectConfig and effectConfig.restrictMapID and TableUtility.ArrayFindIndex(effectConfig.restrictMapID, Game.MapManager:GetMapID()) == 0 then
    return
  end
  local countDownData = self.countDownDataMap[id]
  if countDownData == nil then
    countDownData = {}
    self.countDownDataMap[id] = countDownData
  end
  countDownData.id = id
  countDownData.startTime = startTime
  countDownData.endTime = endTime
  if effectConfig then
    countDownData.effectPath = effectConfig.effectPath
    countDownData.finalEffectPath = effectConfig.finalEffectPath
    countDownData.effectNumberPrefix = effectConfig.effectNumberPrefix or "time_text_"
  end
  self:UpdateCountDownAct()
end

function FunctionActivity:RemoveCountDownAct(id)
  local countDownData = self.countDownDataMap[id]
  if countDownData == nil then
    return
  end
  self.countDownDataMap[id] = nil
  self:UpdateCountDownAct()
end

function FunctionActivity:UpdateCountDownAct()
  local nowServerTime = ServerTime.CurServerTime() / 1000
  local needUpdate = false
  for id, countDownData in pairs(self.countDownDataMap) do
    if nowServerTime < countDownData.endTime then
      needUpdate = true
    end
  end
  if needUpdate then
    if self.countDownTick == nil then
      self.countDownTick = TimeTickManager.Me():CreateTick(0, 33, self._UpdateCountDown, self, 2)
    end
  else
    self:RemoveCountDownTick()
  end
end

function FunctionActivity:_UpdateCountDown()
  local nowServerTime = ServerTime.CurServerTime() / 1000
  TableUtility.ArrayClear(tempArray)
  local leftSec
  for id, data in pairs(self.countDownDataMap) do
    if nowServerTime >= data.startTime then
      leftSec = math_floor(data.endTime - nowServerTime)
      if leftSec < 0 then
        table.insert(tempArray, id)
      elseif data.leftSec ~= leftSec then
        data.leftSec = leftSec
        self:PlayCountDownEffect(id, leftSec, data.effectPath, data.finalEffectPath, data.effectNumberPrefix)
      end
    end
  end
  for i = 1, #tempArray do
    self:RemoveCountDownAct(tempArray[i])
  end
end

function FunctionActivity:InitKFC_GroupEffect()
  self.kfcEffectMap = self.kfcEffectMap or {}
  local config = GameConfig.GroupEquip
  for effectName, groups in pairs(config) do
    for i = 1, #groups do
      for j = 1, #groups[i] do
        self.kfcEffectMap[groups[i][j]] = 1
      end
    end
  end
end

function FunctionActivity:CheckIsKfcEffectEquip(id)
  return nil ~= id and nil ~= self.kfcEffectMap[id]
end

function FunctionActivity:RemoveCountDownTick()
  if self.countDownTick == nil then
    return
  end
  TimeTickManager.Me():ClearTick(self, 2)
  self.countDownTick = nil
end

function FunctionActivity:PlayCountDownEffect(id, leftSec, effectPath, finalEffectPath, effectNumberPrefix)
  if finalEffectPath and leftSec == 0 then
    FloatingPanel.Instance:PlayMidEffect(finalEffectPath)
    return
  end
  local callBack = function(effectHandle)
    local timeNum = UIUtil.FindComponent("Num", UITexture, effectHandle.gameObject)
    if timeNum then
      PictureManager.Instance:SetUI((effectNumberPrefix or "time_text_") .. leftSec, timeNum)
    end
  end
  FloatingPanel.Instance:PlayMidEffect(effectPath, callBack)
end

function FunctionActivity:SetParams(activityType, params)
  if self.activityDataMap and self.activityDataMap[activityType] then
    self.activityDataMap[activityType]:SetParams(params)
  end
end

function FunctionActivity:GetParams(activityType)
  if self.activityDataMap and self.activityDataMap[activityType] then
    return self.activityDataMap[activityType]:GetParams()
  end
end
