AbyssQuestProxy = class("AbyssQuestProxy", pm.Proxy)
AbyssQuestProxy.Instance = nil
AbyssQuestProxy.NAME = "AbyssQuestProxy"

function AbyssQuestProxy:ctor(proxyName, data)
  self.proxyName = proxyName or AbyssQuestProxy.NAME
  if AbyssQuestProxy.Instance == nil then
    AbyssQuestProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.abyssAreaInfos = {}
end

function AbyssQuestProxy:QueryAbyssQuestList(data)
  local areaId = data.cur_area
  local info = self.abyssAreaInfos[areaId]
  if not info then
    info = {}
    self.abyssAreaInfos[areaId] = info
  end
  info.prestigeLv = data.cur_prestige_lv
  info.curHelpNum = data.cur_help_count
  info.totalHelpNum = data.cur_help_totalcount
  redlog("AbyssQuestProxy:QueryAbyssQuestList", areaId, data.cur_prestige_lv, data.cur_help_count, data.cur_help_totalcount)
  if not info.questList then
    info.questList = {}
  end
  TableUtility.ArrayClear(info.questList)
  local list = data.list.list
  for i = 1, #list do
    local single = list[i]
    local questData = QuestData.CreateAsArray(QuestDataScopeType.QuestDataScopeType_CITY)
    questData:setQuestData(single)
    redlog("questData", questData.id)
    info.questList[#info.questList + 1] = questData
  end
end

function AbyssQuestProxy:GetQuestList(areaId)
  local info = self.abyssAreaInfos[areaId]
  return info and info.questList
end

function AbyssQuestProxy:GetAreaPrestigeLevel(areaId)
  local info = self.abyssAreaInfos[areaId]
  return info and info.prestigeLv
end

function AbyssQuestProxy:GetCurHelpNum(areaId)
  local info = self.abyssAreaInfos[areaId]
  return info and info.curHelpNum or 0
end

function AbyssQuestProxy:GetTotalHelpNum(areaId)
  local info = self.abyssAreaInfos[areaId]
  return info and info.totalHelpNum or 0
end

function AbyssQuestProxy:UpdateAbyssHelpCount(data)
  local info = self.abyssAreaInfos[data.area]
  if info then
    info.curHelpNum = data.count
  end
end

function AbyssQuestProxy:FindFirstCanAcceptQuest(areaId)
  local info = self.abyssAreaInfos[areaId]
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

function AbyssQuestProxy:FindFirstInProgressQuest(areaId)
  local info = self.abyssAreaInfos[areaId]
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
