FuncUnlockManulData = class("FuncUnlockManulData")

function FuncUnlockManulData:ctor(serverdata)
  self.id = serverdata.id
  self.completelist = {}
  TableUtility.ArrayShallowCopy(self.completelist, serverdata.finishid or {})
  self.replaceName = serverdata.name
  self.replaceMapid = serverdata.mapid
  self:Update(serverdata)
end

function FuncUnlockManulData:Update(serverdata)
  local config = Table_FunctionOpening[self.id]
  self.name = config.Name
  self.type = config.Type
  self.menuid = config.MenuId
  self.preqruest = config.MustPreQuest
  self.order = config.Index
  self.items = {}
  if config.Itemid then
    TableUtility.ArrayShallowCopy(self.items, config.Itemid)
  end
  self.conditiontip = config.GetCondition
  self.unlockCondition = config.UnlockCondition
  self.icon = config.IconId
  self.desc = config.Describe
  self.spDescribe = config.SpDescribe
  if config.QuestId then
    self:ProcessQuests(config.QuestId)
  end
  if serverdata.data and serverdata.data.id ~= 0 then
    local questData = QuestData.new()
    questData:DoConstruct(false, QuestDataScopeType.QuestDataScopeType_CITY)
    questData:setQuestData(serverdata.data)
    questData:setQuestListType(SceneQuest_pb.EQUESTLIST_ACCEPT)
    self.questData = questData
  end
end

function FuncUnlockManulData:ProcessQuests(configQuestId)
  if not configQuestId then
    return
  end
  local pro = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  local num = #configQuestId
  self.questlist = {}
  if num == 1 then
    TableUtility.ArrayShallowCopy(self.questlist, configQuestId[1])
    return
  end
  for i = 1, num do
    local single = configQuestId[i]
    for j = 2, #single do
      if single[1] == pro or single[1] == 0 then
        table.insert(self.questlist, single[j])
      end
    end
  end
end

function FuncUnlockManulData:GetCurrentTraceQuest()
  local findFlag = false
  local temp
  if not self.questlist then
    return nil
  end
  for i = 1, #self.questlist do
    findFlag = false
    temp = QuestProxy.Instance:getQuestDataByIdAndType(self.questlist[i])
    if temp then
      return temp
    end
    if self.questData then
      return self.questData
    end
    for j = 1, #self.completelist do
      if self.questlist[i] == self.completelist[j] then
        findFlag = true
        break
      end
    end
    if findFlag and i + 1 < #self.questlist then
      temp = QuestProxy.Instance:getQuestDataByIdAndType(self.questlist[i])
      if temp then
        return temp
      end
    end
  end
  if self.preqruest then
    temp = QuestProxy.Instance:getQuestDataByIdAndType(self.preqruest)
    if temp then
      return temp
    end
  end
  return nil
end

function FuncUnlockManulData:CheckComplete()
  if not self.completelist then
    return false
  end
  local findFlag = false
  for j = 1, #self.questlist do
    findFlag = false
    for i = 1, #self.completelist do
      if self.questlist[i] == self.completelist[j] then
        findFlag = true
        break
      end
    end
  end
  return findFlag
end
