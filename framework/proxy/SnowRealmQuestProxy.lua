SnowRealmQuestProxy = class("SnowRealmQuestProxy", pm.Proxy)
SnowRealmQuestProxy.Instance = nil
SnowRealmQuestProxy.NAME = "SnowRealmQuestProxy"

function SnowRealmQuestProxy:ctor(proxyName, data)
  self.proxyName = proxyName or SnowRealmQuestProxy.NAME
  if SnowRealmQuestProxy.Instance == nil then
    SnowRealmQuestProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.snowRealmAreaInfos = {}
end

function SnowRealmQuestProxy:QuerySnowRealmQuestList(data)
  local areaId = data.cur_area
  local info = self.snowRealmAreaInfos[areaId]
  if not info then
    info = {}
    self.snowRealmAreaInfos[areaId] = info
  end
  info.crownLevel = data.cur_artifact_lv
  info.curHelpNum = data.used_help_count
  info.totalHelpNum = data.cur_help_total_count
  if not info.questList then
    info.questList = {}
  end
  TableUtility.ArrayClear(info.questList)
  local list = data.list.list
  for i = 1, #list do
    local single = list[i]
    local questData = QuestData.CreateAsArray(QuestDataScopeType.QuestDataScopeType_CITY)
    questData:setQuestData(single)
    info.questList[#info.questList + 1] = questData
  end
end

function SnowRealmQuestProxy:GetQuestList(areaId)
  local info = self.snowRealmAreaInfos[areaId]
  return info and info.questList
end

function SnowRealmQuestProxy:GetSnowCrownLevel(areaId)
  local info = self.snowRealmAreaInfos[areaId]
  return info and info.crownLevel or 0
end

function SnowRealmQuestProxy:GetCurHelpNum(areaId)
  local info = self.snowRealmAreaInfos[areaId]
  return info and info.curHelpNum or 0
end

function SnowRealmQuestProxy:GetTotalHelpNum(areaId)
  local info = self.snowRealmAreaInfos[areaId]
  return info and info.totalHelpNum or 0
end

function SnowRealmQuestProxy:UpdateSnowRealmHelpCount(data)
  local info = self.snowRealmAreaInfos[data.area]
  if info then
    info.curHelpNum = data.used_count
    info.totalHelpNum = data.total_count
  end
end

function SnowRealmQuestProxy:FindFirstCanAcceptQuest(areaId)
  local info = self.snowRealmAreaInfos[areaId]
  if info and info.questList then
    for i = 1, #info.questList do
      local questData = info.questList[i]
      local result = QuestProxy.Instance:checkQuestHasAccept(questData.id)
      if not result then
        return questData
      end
    end
  end
end

function SnowRealmQuestProxy:FindFirstInProgressQuest(areaId)
  local info = self.snowRealmAreaInfos[areaId]
  if info and info.questList then
    for i = 1, #info.questList do
      local questData = info.questList[i]
      local result, type = QuestProxy.Instance:checkQuestHasAccept(questData.id)
      if result and (type == SceneQuest_pb.EQUESTLIST_COMPLETE or type == SceneQuest_pb.EQUESTLIST_ACCEPT) then
        return questData
      end
    end
  end
end
