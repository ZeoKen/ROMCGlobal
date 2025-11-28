LimitTimeQuestProxy = class("LimitTimeQuestProxy", pm.Proxy)
LimitTimeQuestProxy.Instance = nil
LimitTimeQuestProxy.NAME = "LimitTimeQuestProxy"

function LimitTimeQuestProxy:ctor(proxyName, data)
  self.proxyName = proxyName or LimitTimeQuestProxy.NAME
  if LimitTimeQuestProxy.Instance == nil then
    LimitTimeQuestProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function LimitTimeQuestProxy:Init()
  self.actGroupMap = {}
  self.missionStatusMap = {}
  self:InitMissionGroup()
end

function LimitTimeQuestProxy:InitMissionGroup()
  if not Table_MissionReward then
    return
  end
  for k, v in pairs(Table_MissionReward) do
    local actID = v.ActID
    local type = v.Type
    local index = v.Index
    local actMap = self.actGroupMap[actID] or {}
    local typeMap = actMap[type] or {}
    typeMap[index] = k
    actMap[type] = typeMap
    self.actGroupMap[actID] = actMap
  end
end

function LimitTimeQuestProxy:GetMissionStaticData(actid)
  if self.actGroupMap[actid] then
    return self.actGroupMap[actid]
  end
end

function LimitTimeQuestProxy:RecvMissionRewardInfoSyncCmd(data)
  local actid = data.act_id
  self.missionStatusMap[actid] = {
    rewards = {}
  }
  local questrewards = data.rewards
  if questrewards and 0 < #questrewards then
    for i = 1, #questrewards do
      local index = questrewards[i].index
      local status = questrewards[i].status
      self.missionStatusMap[actid].rewards[index] = status
    end
  end
  local isAllFinish = data.is_all_mission_finish
  self.missionStatusMap[actid].allFinish = isAllFinish
  self.missionStatusMap[actid].end_time = data.end_time
  self:RefreshManualRedTips()
end

function LimitTimeQuestProxy:CheckActIsValid(actid)
  if self.missionStatusMap[actid] then
    local endTime = self.missionStatusMap[actid].end_time
    if endTime and endTime > ServerTime.CurServerTime() / 1000 then
      return true
    end
  end
  return false
end

function LimitTimeQuestProxy:GetEndTime(actid)
  if self.missionStatusMap[actid] then
    return self.missionStatusMap[actid].end_time
  end
end

function LimitTimeQuestProxy:GetMissionRewardInfoByActID(actid)
  if self.missionStatusMap[actid] then
    return self.missionStatusMap[actid]
  end
end

function LimitTimeQuestProxy:GetRewardStatusByIndex(actid, index)
  if self.missionStatusMap[actid] then
    local reward = self.missionStatusMap[actid].rewards
    if reward and reward[index] then
      return reward[index]
    end
  end
  return 0
end

function LimitTimeQuestProxy:GetFinishCountByActID(actid)
  local result = {}
  local actMap = self.actGroupMap[actid]
  for _type, _indexMap in pairs(actMap) do
    if _type ~= "AllReward" then
      if not result[_type] then
        result[_type] = {finishCount = 0, totalCount = 0}
      end
      for _index, _ in pairs(_indexMap) do
        result[_type].totalCount = result[_type].totalCount + 1
        local status = self:GetRewardStatusByIndex(actid, _index)
        if status == 2 then
          result[_type].finishCount = result[_type].finishCount + 1
        end
      end
    end
  end
  return result
end

function LimitTimeQuestProxy:GetTotalProcessByActID(actid)
  local groupCount = self:GetFinishCountByActID(actid)
  if not groupCount then
    return
  end
  local process = 0
  local totalCount = 0
  for _type, _info in pairs(groupCount) do
    totalCount = totalCount + _info.totalCount
    process = process + _info.finishCount
  end
  return process, totalCount
end

function LimitTimeQuestProxy:GetQuestStatusInfo(staticid)
  local staticData = Table_MissionReward[staticid]
  if not staticData then
    return
  end
  local actid = staticData.ActID
  local type = staticData.Type
  local rewardStatus = self:GetRewardStatusByIndex(actid, staticData.Index)
  local _tempData = {id = staticid, status = rewardStatus}
  if rewardStatus == 2 then
    _tempData.cellStatus = 3
  elseif type == "Main" then
    local version = staticData.Main_Version
    local index = staticData.Main_Index
    if version ~= "" and index then
      local indexInfo = QuestManualProxy.Instance:GetStoryIndexInfo(version, index)
      local status = indexInfo and indexInfo.status or 0
      if status == 2 then
        local curQuests = indexInfo.curQuestData
        if curQuests and 0 < #curQuests then
          local questid = curQuests[1].questData and curQuests[1].questData.id
          _tempData.questid = questid
          local traceTitle = curQuests[1].questData and curQuests[1].questData.traceTitle
          if traceTitle and traceTitle ~= "" then
            _tempData.name = traceTitle
          end
        end
        _tempData.cellStatus = 1
      elseif status == 3 then
        if rewardStatus == 2 then
          _tempData.cellStatus = 3
        else
          _tempData.cellStatus = 2
        end
      else
        _tempData.cellStatus = 4
      end
    else
      redlog("主线配置错误  请检查Main_Version / Main_Index")
    end
  elseif type == "Branch" or type == "Collection" then
    local questList = staticData.Quests
    local inProcess = false
    local isAllFinish = true
    for i = 1, #questList do
      local questData = QuestProxy.Instance:getQuestDataByIdAndType(questList[i], SceneQuest_pb.EQUESTLIST_ACCEPT)
      if questData then
        isAllFinish = false
        inProcess = true
        _tempData.questid = questData.id
        break
      else
        local submitQuestData = QuestProxy.Instance:getQuestDataByIdAndType(questList[i], SceneQuest_pb.EQUESTLIST_SUBMIT)
        if not submitQuestData then
          isAllFinish = false
          break
        end
      end
    end
    if isAllFinish then
      if rewardStatus == 2 then
        _tempData.cellStatus = 3
      else
        _tempData.cellStatus = 2
      end
    elseif inProcess then
      _tempData.cellStatus = 1
    else
      _tempData.cellStatus = 4
    end
  end
  return _tempData
end

local redtipid = SceneTip_pb.EREDSYS_MISSION_REWARD or 10766
LimitTimeQuestProxy.QuestTypeMap = {
  Main = 1,
  Branch = 2,
  Collection = 3
}

function LimitTimeQuestProxy:RefreshManualRedTips()
  if not self.missionStatusMap then
    return
  end
  local _subtipID = {}
  for _actid, _info in pairs(self.missionStatusMap) do
    local entranceConfig = GameConfig.LimitTimeQuestReward and GameConfig.LimitTimeQuestReward[_actid]
    local menuUnlock = ActivityIntegrationProxy.Instance:CheckMenuUnlock(_actid)
    local timeValid = self:CheckActIsValid(_actid)
    if entranceConfig ~= nil and menuUnlock and timeValid then
      local reward = _info.rewards
      local groupData = self:GetMissionStaticData(_actid)
      local _mainActidActive = false
      for _type, _indexMap in pairs(groupData) do
        for _index, _staticID in pairs(_indexMap) do
          local questInfo = self:GetQuestStatusInfo(_staticID)
          if questInfo and questInfo.cellStatus == 2 then
            local pageIndex = LimitTimeQuestProxy.QuestTypeMap[_type]
            if pageIndex and TableUtility.ArrayFindIndex(_subtipID, pageIndex) == 0 then
              _mainActidActive = true
              table.insert(_subtipID, _actid * 100 + pageIndex)
            end
          end
        end
      end
      local process, total = self:GetTotalProcessByActID(_actid)
      if process == total and not self.missionStatusMap[_actid].allFinish then
        _mainActidActive = true
        table.insert(_subtipID, _actid * 100 + 99)
      end
      if _mainActidActive then
        table.insert(_subtipID, _actid)
      end
    end
  end
  if 0 < #_subtipID then
    RedTipProxy.Instance:UpdateRedTip(redtipid, _subtipID)
  else
    RedTipProxy.Instance:RemoveWholeTip(redtipid)
  end
end
