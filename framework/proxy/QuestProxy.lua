QuestProxy = class("QuestProxy", pm.Proxy)
QuestProxy.Instance = nil
QuestProxy.NAME = "QuestProxy"
autoImport("QuestData")
autoImport("EOtherData")
autoImport("WholeQuestData")
autoImport("TraceData")
QuestProxy.BossStep = {
  Visit = BossCmd_pb.EBOSSSTEP_VISIT,
  Summon = BossCmd_pb.EBOSSSTEP_SUMMON,
  Dialog = BossCmd_pb.EBOSSSTEP_DIALOG,
  Boss = BossCmd_pb.EBOSSSTEP_BOSS,
  Clear = BossCmd_pb.EBOSSSTEP_CLEAR,
  End = BossCmd_pb.EBOSSSTEP_END
}
local tempArray = {}

function QuestProxy:ctor(proxyName, data)
  self.proxyName = proxyName or QuestProxy.NAME
  if QuestProxy.Instance == nil then
    QuestProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.questList = {}
  self.dialogMessage = {}
  self.detailList = {}
  self.DailyQuestData = {}
  self.traceDatas = {}
  self.fubenQuestMap = {}
  self.menuDatas = {}
  self:initMenuQuestReward()
  self.worldbossQuest = {}
  self.questDebug = false
  self.lastQuestID = nil
  self.worldQuestTreasure = {}
  self.DaHuangQuestMap = {}
  self.worldQuestCountList = {}
  self.tempQuestStatusUpdateList = {}
  self.previewSaleRoleTask = {}
  self.previewSaleTaskAllComplate = false
  self.questStoryIndex = {}
  self.questOnceRewardMap = {}
  self.notifyQuestList = {}
  self.mapTreasure = {}
end

function QuestProxy:SelfDebug(msg)
  if false then
    helplog("QuestProxy:" .. msg)
  end
end

function QuestProxy:initMenuQuestReward()
  for k, v in pairs(Table_Menu) do
    if v.Condition.quest and #v.Condition.quest > 0 and v.Show == 1 then
      for i = 1, #v.Condition.quest do
        local questId = v.Condition.quest[i]
        local id = self:getQuestID(questId)
        local datas = self.menuDatas[id] or {}
        datas[#datas + 1] = v
        self.menuDatas[id] = datas
      end
    end
  end
end

function QuestProxy:CleanAllQuest()
  for k, v in pairs(self.questList) do
    for i = #v, 1, -1 do
      FunctionQuest.Me():stopTrigger(v[i])
      ReusableObject.Destroy(v[i])
      v[i] = nil
    end
  end
  Game.FacadeManager:Notify(ServiceEvent.QuestQuestList)
  TableUtility.TableClear(self.notifyQuestList)
end

function QuestProxy:tryRemoveQuestId(id, type)
  if type == nil then
    type = SceneQuest_pb.EQUESTLIST_ACCEPT
  end
  local list = self.questList[type]
  if not list then
    return
  end
  for j = 1, #list do
    local oldSingle = list[j]
    if oldSingle.id == id then
      FunctionQuest.Me():stopTrigger(oldSingle)
      ReusableObject.Destroy(oldSingle)
      table.remove(list, j)
      break
    end
  end
end

function QuestProxy:QuestQuestList(data)
  local type = data.type
  local list = self.questList[type] or {}
  if type == SceneQuest_pb.EQUESTLIST_CANACCEPT then
    list = {}
  end
  if data.clear and 0 < #list then
    for k, v in pairs(list) do
      FunctionQuest.Me():stopTrigger(v)
      ReusableObject.Destroy(v)
    end
    TableUtility.ArrayClear(list)
  end
  for i = 1, #data.list do
    local single = data.list[i]
    if single.id ~= 0 then
      self:tryRemoveQuestId(single.id, type)
      local questData = QuestData.CreateAsArray(QuestDataScopeType.QuestDataScopeType_CITY)
      questData:setQuestData(single)
      questData:setQuestListType(type)
      table.insert(list, questData)
      FunctionQuest.Me():handleQuestInit(questData)
    end
  end
  self.questList[type] = list
  self:RefreshValidClientTraceList(data.list)
  self:RefreshFakeWorldQuestTrace(data.list)
  TableUtility.TableClear(self.notifyQuestList)
end

function QuestProxy:getDetailDataById(id)
  for i = 1, #self.detailList do
    local single = self.detailList[i]
    if single.questId == id then
      return single, i
    end
  end
end

function QuestProxy:getQuestListInOrder(type, ifNeedSort)
  local questList = {}
  if not self.questList[type] then
    return questList
  end
  questList = {
    unpack(self.questList[type])
  }
  if not ifNeedSort then
    return questList
  end
  if questList ~= nil and #questList ~= 0 then
    table.sort(questList, function(t1, t2)
      if t1.type == t2.type then
        if t1.type == QuestDataType.QuestDataType_WANTED then
          return t1.time > t2.time
        else
          return t1.orderId < t2.orderId
        end
      elseif t1.type == QuestDataType.QuestDataType_WANTED then
        return true
      elseif t2.type == QuestDataType.QuestDataType_WANTED then
        return false
      elseif t1.type == QuestDataType.QuestDataType_MAIN then
        return true
      elseif t2.type == QuestDataType.QuestDataType_MAIN then
        return false
      else
        return t1.type == QuestDataType.QuestDataType_DAILY
      end
    end)
  end
  return questList
end

function QuestProxy:QuestDialogMessage(data)
  self.dialogMessage.questid = data.questid
  self.dialogMessage.step = data.step
  local message, single
  for i = 1, #data.messages do
    single = data.messages[i]
    message = DMessage.new(single.speaker, single.message)
    self.dialogMessage.messages = self.dialogMessage.messages or {}
    table.insert(self.dialogMessage.messages, message)
  end
end

function QuestProxy:QuestQuestUpdate(data)
  local items = data.items
  if not items then
    return
  end
  for i = 1, #items do
    local item = items[i]
    local del = item.del
    local update = item.update
    local type = item.type
    local list = self.questList[type] or {}
    if del then
      local delList = {}
      for i = 1, #del do
        local single = del[i]
        local questData, index = self:getQuestDataByIdAndType(single, type)
        if questData ~= nil then
          if type == SceneQuest_pb.EQUESTLIST_ACCEPT then
            FunctionQuest.Me():stopTrigger(questData)
          end
          table.remove(list, index)
          table.insert(delList, questData)
        end
        self:ClearQuestNotifyStamp(single)
      end
      if #delList ~= 0 then
        GameFacade.Instance:sendNotification(QuestEvent.QuestDelete, delList)
        FunctionVideoStorage.Me():HandleTask(delList)
        for i = 1, #delList do
          local data = delList[i]
          ReusableObject.Destroy(data)
          delList[i] = nil
        end
      end
    end
    if update then
      local addList = {}
      for i = 1, #update do
        local single = update[i]
        if single.id then
          local oldData, index = self:getQuestDataByIdAndType(single.id, type)
          if oldData ~= nil then
            FunctionQuest.Me():stopTrigger(oldData)
            table.remove(list, index)
            ReusableObject.Destroy(oldData)
          else
            table.insert(addList, single.id)
          end
          local questData = QuestData.CreateAsArray(QuestDataScopeType.QuestDataScopeType_CITY)
          questData:setQuestData(single)
          questData:setQuestListType(type)
          table.insert(list, questData)
          if questData.staticData ~= nil then
            questData:setIfShowAppearAnm(true)
          end
          if type == SceneQuest_pb.EQUESTLIST_ACCEPT then
            FunctionQuest.Me():handleAutoQuest(questData)
            if questData.questDataStepType == QuestDataStepType.QuestDataStepType_CAMERA then
              FunctionQuest.Me():handleCameraQuestStart(questData.pos)
            end
          end
          self:ClearQuestNotifyStamp(single.id)
        else
          errorLog("quset id is nil")
        end
      end
      if #addList ~= 0 then
        self:HandleQuestUpdateAutoTrace(addList)
        GameFacade.Instance:sendNotification(QuestEvent.QuestAdd, addList)
      end
    end
    self.questList[type] = list
  end
end

function QuestProxy:getGuildQuestByContentAndType(content, type)
  if not content then
    return
  end
  local result
  local listType = type or SceneQuest_pb.EQUESTLIST_ACCEPT
  local list = self.questList[listType]
  if list == nil then
    return
  end
  TableUtility.ArrayClear(tempArray)
  for i = 1, #list do
    local single = list[i]
    if single.questDataStepType == content and single.type == QuestDataType.QuestDataType_GUILDQUEST then
      tempArray[#tempArray + 1] = tempArray
    end
  end
  return tempArray
end

function QuestProxy:getQuestDataByIdAndType(id, type, scope)
  if not id then
    return
  end
  local questData, index
  if type or scope ~= QuestDataScopeType.QuestDataScopeType_FUBEN then
    questData, index = self:getQuestDataFromCityScope(id, type)
  end
  if questData then
    return questData, index
  elseif scope == QuestDataScopeType.QuestDataScopeType_DAHUANG then
    return self:getQuestDataFromDahuangScope(id)
  else
    return self:getQuestDataFromFubenScope(id)
  end
end

function QuestProxy:GetQuestDataBySameQuestID(id)
  local data = self:getQuestDataByIdAndType(id)
  if data then
    return data
  end
  local list = self.questList[SceneQuest_pb.EQUESTLIST_ACCEPT]
  if not list then
    return
  end
  local questID = self:getQuestID(id)
  for i = 1, #list do
    local single = list[i]
    local ID = self:getQuestID(single.id)
    if ID == questID then
      return single
    end
  end
  for _, questData in pairs(self.fubenQuestMap) do
    local ID = self:getQuestID(questData.id)
    if ID == questID then
      return questData
    end
  end
end

function QuestProxy:getQuestDataFromCityScope(id, type)
  local listType = type or SceneQuest_pb.EQUESTLIST_ACCEPT
  local list = self.questList[listType]
  if not list then
    return
  end
  for i = 1, #list do
    local single = list[i]
    if single.id == id then
      return single, i
    end
  end
end

function QuestProxy:getQuestDataFromFubenScope(id)
  for _, questData in pairs(self.fubenQuestMap) do
    if questData.id == id then
      return questData
    end
  end
end

function QuestProxy:getQuestDataFromDahuangScope(id)
  for _, questData in pairs(self.DaHuangQuestMap) do
    if questData.id == id then
      return questData
    end
  end
end

function QuestProxy:checkQuestHasAccept(id)
  if not id then
    return false
  end
  local result = self:getQuestDataByIdAndType(id, SceneQuest_pb.EQUESTLIST_ACCEPT)
  if result then
    return true, 1
  end
  result = self:getQuestDataByIdAndType(id, SceneQuest_pb.EQUESTLIST_SUBMIT)
  if result then
    return true, 2
  end
  result = self:getQuestDataByIdAndType(id, SceneQuest_pb.EQUESTLIST_COMPLETE)
  if result then
    return true, 3
  end
  return false
end

function QuestProxy:GetTraceCellCount()
  return self.TraceCellCount
end

function QuestProxy:SetTraceCellCount(count)
  self.TraceCellCount = count
end

function QuestProxy:checkDialogQuestByNpcParams(npcId, npc)
  if type(npc) == "table" then
    for i = 1, #npc do
      if npc[i] == npcId then
        return true
      end
    end
  elseif npc == npcId then
    return true
  end
  return false
end

function QuestProxy:checkDialogQuestByParams(npcId, questData)
  if questData then
    local npc = questData.params.npc
    if type(npc) == "table" then
      for i = 1, #npc do
        if npc[i] == npcId then
          return true
        end
      end
    elseif npc == npcId then
      return true
    end
    local npcFunctionId = questData.params.npcfunctionid
    if npcFunctionId then
      local npcData = Table_Npc[npcId]
      local npcFunc = npcData and npcData.NpcFunction
      if npcFunc then
        for i = 1, #npcFunc do
          local funcType = npcFunc[i].type
          if funcType == npcFunctionId then
            return true
          end
        end
      end
    end
    return false
  end
end

function QuestProxy:getDialogQuestListByNpcId(npcId, uniqueid)
  local list = {}
  local currentMap = SceneProxy.Instance.currentScene
  local sourceTable = self.questList[SceneQuest_pb.EQUESTLIST_ACCEPT]
  if sourceTable then
    for i = 1, #sourceTable do
      local single = sourceTable[i]
      if single.params then
        local npc = single.params.npc
        if single.questDataStepType == QuestDataStepType.QuestDataStepType_VISIT and self:checkDialogQuestByParams(npcId, single) and (single.params.uniqueid == nil or single.params.uniqueid == uniqueid and currentMap:IsSameMapOrRaid(single.map)) and self:checkGuildQuest(single) and self:isCountDownQuestValid(single) then
          table.insert(list, single)
        end
      else
      end
    end
  end
  for key, single in pairs(self.fubenQuestMap) do
    if single.params then
      local npc = single.params.npc
      if single.questDataStepType == QuestDataStepType.QuestDataStepType_VISIT and self:checkDialogQuestByParams(npcId, single) and (single.params.uniqueid == nil or single.params.uniqueid == uniqueid) then
        table.insert(list, single)
      end
    end
  end
  for key, value in pairs(self.traceDatas) do
    for i = 1, #value do
      local single = value[i]
      if single.params then
        local npc = single.params.npc
        if type(npc) == "table" then
          npc = npc[1]
        end
        if single.questDataStepType == QuestDataStepType.QuestDataStepType_VISIT and npc == npcId and (single.params.uniqueid == nil or single.params.uniqueid == uniqueid and currentMap:IsSameMapOrRaid(single.map)) and self:checkGuildQuest(single) and self:isCountDownQuestValid(single) then
          table.insert(list, single)
        end
      else
        printRed("error !!!Quest Params is nil in id:" .. single.id)
      end
    end
  end
  for key, single in pairs(self.DaHuangQuestMap) do
    if single.params then
      local npc = single.params.npc
      if self:isVisitTypeQuest(single) and self:checkDialogQuestByParams(npcId, single) and (single.params.uniqueid == nil or single.params.uniqueid == uniqueid) then
        table.insert(list, single)
      end
    end
  end
  return list
end

function QuestProxy:isVisitTypeQuest(questData)
  if questData.questDataStepType == QuestDataStepType.QuestDataStepType_VISIT or questData.questDataStepType == "stepvisit" then
    return true
  else
    return false
  end
end

function QuestProxy:isCountDownQuestValid(questData)
  if not questData or not questData.staticData then
    return false
  end
  local endTime = questData.staticData.EndTime
  if not endTime then
    error(string.format("任务id：%s 任务类型: %s 没有配置字段：EndTime", questData.id, questData.questDataStepType))
  end
  if 0 ~= endTime then
    local serverT = ServerTime.CurServerTime() / 1000
    if endTime <= serverT then
      return false
    end
  end
  return true
end

function QuestProxy:isCountDownQuest(questData)
  if not (questData and questData.staticData) or not questData.staticData.EndTime then
    return false
  end
  local endTime = questData.staticData.EndTime or 0
  return 0 ~= endTime
end

function QuestProxy:checkGuildQuest(questData)
  if questData and questData.type == QuestDataType.QuestDataType_GUILDQUEST then
    local serverT = ServerTime.CurServerTime() / 1000
    if not GuildProxy.Instance:IHaveGuild() then
      return false
    elseif serverT >= questData.time then
      return false
    end
  end
  return true
end

function QuestProxy:getSymbolDQListByNpcId(npcId, uniqueid, list)
  list = list or self:getDialogQuestListByNpcId(npcId, uniqueid)
  for i = #list, 1, -1 do
    if list[i] and list[i].staticData then
      if list[i].staticData.TraceInfo ~= "" or list[i].headicon and list[i].headicon ~= 0 then
      else
        do
          local right = list[i].staticData.Params and list[i].staticData.Params.symbol == 1
          if not right then
            table.remove(list, i)
          else
          end
        end
      end
    else
      table.remove(list, i)
    end
  end
  return list
end

function QuestProxy:getCollectQuestListByNpcId(npcId)
  return self:getQuestListByIdAndType(npcId, QuestDataStepType.QuestDataStepType_COLLECT)
end

function QuestProxy:getQuestListByIdAndType(npcId, qtype)
  local list = {}
  local allData = self.questList[SceneQuest_pb.EQUESTLIST_ACCEPT]
  if allData == nil then
    return
  end
  for i = 1, #allData do
    local single = allData[i]
    if single.questDataStepType == qtype and qtype == QuestDataStepType.QuestDataStepType_COLLECT and npcId == single.staticData.Params.monster then
      table.insert(list, single)
    end
  end
  for _, single in pairs(self.fubenQuestMap) do
    if single.questDataStepType == QuestDataStepType.QuestDataStepType_COLLECT and npcId == single.params.monster then
      table.insert(list, single)
    end
  end
  for _, single in pairs(self.DaHuangQuestMap) do
    if single.questDataStepType == QuestDataStepType.QuestDataStepType_COLLECT and npcId == single.params.monster then
      table.insert(list, single)
    end
  end
  return list
end

function QuestProxy:getQuestListByStepType(stepType)
  local list = {}
  local allData = self.questList[SceneQuest_pb.EQUESTLIST_ACCEPT]
  if not allData then
    return
  end
  for i = 1, #allData do
    local single = allData[i]
    if single.questDataStepType == stepType then
      list[#list + 1] = single
    end
  end
  return list
end

function QuestProxy:notifyQuestState(scope, id, subgroup, specified_starid)
  local questData = self:getQuestDataByIdAndType(id, nil, scope)
  if questData and questData.staticData then
    if questData.scope == QuestDataScopeType.QuestDataScopeType_FUBEN then
      ServiceFuBenCmdProxy.Instance:CallFubenStepSyncCmd(id, nil, subgroup, nil, questData.staticData.uniqueid)
    elseif questData.scope == QuestDataScopeType.QuestDataScopeType_CITY then
      helplog("questData.scope = city")
      if not self:IsQuestInNotifyCD(questData.id) then
        ServiceQuestProxy.Instance:CallRunQuestStep(questData.id, specified_starid, subgroup, questData.step)
      else
        redlog("任务推送频次过快", questData.id)
      end
      if (questData.questDataStepType == QuestDataStepType.QuestDataStepType_VISIT or questData.questDataStepType == QuestDataStepType.QuestDataStepType_TALK) and (not self.notifyQuestList[questData.id] or self.notifyQuestList[questData.id] < ServerTime.CurServerTime() / 1000 + 10) then
        self.notifyQuestList[questData.id] = ServerTime.CurServerTime() / 1000
      end
    elseif questData.scope == QuestDataScopeType.QuestDataScopeType_DAHUANG then
      helplog("大荒魔物召唤推进,Stepid == >", id, subgroup)
      ServiceQuestProxy.Instance:CallMapStepFinishCmd(id, subgroup)
    end
  else
    helplog("QuestProxy:notifyQuestState( id,subgroup) call" .. id)
  end
end

function QuestProxy:GetNotifyTimeStamp(questId)
  return self.notifyQuestList[questId]
end

function QuestProxy:IsQuestInNotifyCD(questId)
  local timeStamp = self:GetNotifyTimeStamp(questId)
  if not timeStamp then
    return false
  end
  return timeStamp + 10 > ServerTime.CurServerTime() / 1000
end

function QuestProxy:ClearQuestNotifyStamp(questId)
  if questId and self.notifyQuestList[questId] then
    redlog("清除任务推送CD", questId)
    self.notifyQuestList[questId] = nil
  end
end

function QuestProxy:QuestQuestStepUpdate(data)
  local questId = data.id
  local questData = self:getQuestDataByIdAndType(questId)
  if questData == nil then
    return
  end
  local stepChange = false
  local symbol = questData.staticData and questData.staticData.Params and questData.staticData.Params.symbol
  local isShowBefore = not symbol or symbol ~= 1 or false
  self:ClearQuestNotifyStamp(questId)
  FunctionQuest.Me():stopTrigger(questData)
  if questData.step ~= data.step then
    questData:setIfShowAppearAnm(true)
    stepChange = true
    local curProcessId = LocalSaveProxy.Instance:getLastTraceQuestId()
    if curProcessId and curProcessId == questData.id then
      FunctionQuest.Me():handleMissShutdown(questData.id)
    end
  end
  questData:updateByIdAndStep(questId, data.step, data.data)
  questData:setQuestDoneStatus()
  FunctionQuest.Me():handleAutoQuest(questData)
  local isShowNow = self:checkIsShowDirAndDis(questData)
  if questData.questDataStepType == QuestDataStepType.QuestDataStepType_CAMERA then
    FunctionQuest.Me():handleCameraQuestStart(questData.pos)
  end
  if not isShowBefore and isShowNow and self:isQuestCanBeShowTrace(questData.type) and self:checkCanShowNewNotice(questData) then
    GameFacade.Instance:sendNotification(QuestEvent.QuestTraceNotice)
  end
  if isShowNow and stepChange then
    if not Table_WorldQuest[questId] then
      self:AddTraceList(questId)
    elseif questData.map and questData.map == Game.MapManager:GetMapID() then
      self:AddTraceList(questId)
    end
  end
  if stepChange then
    GameFacade.Instance:sendNotification(ServiceEvent.QuestQuestStepUpdate, data)
  else
    GameFacade.Instance:sendNotification(QuestEvent.ProcessChange, data)
  end
end

function QuestProxy:checkIfNeedStopMissionTrigger()
  local index = 0
  local allData = self.questList[SceneQuest_pb.EQUESTLIST_ACCEPT]
  if allData then
    for i = 1, #allData do
      local single = allData[i]
      if self:checkIfNeedAutoTrigger(single) then
        index = index + 1
      end
    end
  end
end

function QuestProxy:checkIfNeedRemoveGuideView()
  local index = 0
  local closeGuide = true
  local allData = self.questList[SceneQuest_pb.EQUESTLIST_ACCEPT]
  if not allData then
    FunctionGuide.Me():stopGuide()
    return
  end
  local instance = GuideMaskView.Instance
  if not instance then
    return
  end
  local curGuideID = instance.currentGuideId
  local delayGuideID = instance.delayQuestData and instance.delayQuestData.params.guideID or nil
  for i = 1, #allData do
    local single = allData[i]
    if single.questDataStepType == QuestDataStepType.QuestDataStepType_GUIDE then
      index = index + 1
      local guideId = single.params.guideID
      local guideType = single.params.type
      local guideData = Table_GuideID[guideId]
      if guideData then
        if guideData.id == curGuideID then
          closeGuide = false
        elseif guideData.id == delayGuideID then
          closeGuide = false
        elseif guideData.Preguide and guideData.Preguide == curGuideID then
          closeGuide = false
        end
      else
        LogUtility.Info("can't find guide data by id:")
      end
    elseif single.questDataStepType == QuestDataStepType.QuestDataStepType_GUIDECHECK then
      closeGuide = false
    end
    if self:needKeepAutoCompleteGuideOpen(single.questDataStepType) then
      closeGuide = false
    end
  end
  if instance:IsCurrentGuideItemsInBag() then
    closeGuide = false
  end
  if closeGuide and instance.guideData and instance.guideData.questData then
    FunctionGuide.Me():stopGuide()
  end
end

function QuestProxy:needKeepAutoCompleteGuideOpen(stepType)
  if stepType and CloseGuideQuestStepTypes and CloseGuideQuestStepTypes[stepType] == 1 then
    return false
  end
  local instance = GuideMaskView.Instance
  if instance:isAutoComplete() then
    return true
  end
  return false
end

function QuestProxy:checkIfNeedRemoveGuideViewBySingleQuest(questData)
  local closeGuide = true
  local instance = GuideMaskView.Instance
  if not questData or not instance then
    return
  end
  local curGuideID = instance.currentGuideId
  local delayGuideID = instance.delayQuestData and instance.delayQuestData.params.guideID or nil
  if questData.questDataStepType == QuestDataStepType.QuestDataStepType_GUIDE then
    local guideId = questData.params.guideID
    local guideType = questData.params.type
    local guideData = Table_GuideID[guideId]
    if guideData then
      if guideData.id == curGuideID then
        closeGuide = false
      elseif guideData.id == delayGuideID then
        closeGuide = false
      end
    else
      LogUtility.Info("can't find guide data by id:")
    end
  elseif questData.questDataStepType == QuestDataStepType.QuestDataStepType_GUIDECHECK then
    closeGuide = false
  end
  if instance:IsCurrentGuideItemsInBag() then
    closeGuide = false
  end
  if self:needKeepAutoCompleteGuideOpen(questData.questDataStepType) then
    closeGuide = false
  end
  if closeGuide then
    FunctionGuide.Me():stopGuide()
  end
end

function QuestProxy:checkIfNeedAutoExcuteAtInit(questData)
  for i = 1, #QuestData.AutoExecuteQuestAtInit do
    local single = QuestData.AutoExecuteQuestAtInit[i]
    if single == questData.questDataStepType and not self:checkIfNeedMoveAction(questData) then
      return true
    end
  end
end

function QuestProxy:checkIfNeedMoveAction(questData)
  if not questData.map then
    return false
  end
  local currentMapID = Game.MapManager:GetMapID()
  if questData.map == currentMapID and not questData.pos then
    return false
  end
end

function QuestProxy:checkIfNeedMoveAction(questData)
  if not questData.map then
    return false
  end
  local currentMapID = Game.MapManager:GetMapID()
  if questData.map == currentMapID and not questData.pos then
    return false
  end
end

function QuestProxy:checkIfNeedMoveAction(questData)
  if not questData.map then
    return false
  end
  local currentMapID = Game.MapManager:GetMapID()
  if questData.map == currentMapID and not questData.pos then
    return false
  end
end

function QuestProxy:checkIfNeedAutoTrigger(questData)
  for i = 1, #QuestData.AutoTriggerQuest do
    local single = QuestData.AutoTriggerQuest[i]
    if single == questData.questDataStepType then
      return true
    end
  end
end

function QuestProxy:checkIfNeedEffectTrigger(questData)
  for i = 1, #QuestData.EffectTriggerStepType do
    local single = QuestData.EffectTriggerStepType[i]
    if single == questData.questDataStepType then
      return true
    end
  end
end

function QuestProxy:isQuestTraceById(questId)
  local questData = self:getDetailDataById(questId)
  if questData and questData.trace then
    return true
  elseif not questData then
    return true
  end
end

function QuestProxy:isQuestComplete(id)
  local type = SceneQuest_pb.EQUESTLIST_SUBMIT
  local questData, _ = self:getQuestDataByIdAndType(id, type)
  return questData ~= nil
end

function QuestProxy:getStaticDataById(id, step)
  return nil
end

function QuestProxy:getAreaTriggerIdByQuestId(id)
  local questId = math.floor(id / GameConfig.Quest.ratio)
  local groupId = id - questId * GameConfig.Quest.ratio
  local id = questId * (GameConfig.Quest.ratio + 1) + groupId
  return id
end

function QuestProxy:isMainQuestCompleteByStepId(orderid)
  local type = SceneQuest_pb.EQUESTLIST_ACCEPT
  local list = self.questList[type]
  for i = 1, #list do
    local single = list[i]
    if single.type == QuestDataType.QuestDataType_MAIN then
      if orderid < single.orderId then
        return true
      else
        return false
      end
    end
  end
  return true
end

function QuestProxy:getWholeQuestDataInList(list, storyId)
  for k, v in pairs(list) do
    for i = 1, #v do
      local single = v[i]
      if single.questId == storyId then
        return single
      end
    end
  end
end

function QuestProxy:checkLevelInRange(cur, min, max)
  if cur < min or max < cur then
    return false
  else
    return true
  end
end

function QuestProxy:getVersionQuest(npcid)
  local list = {}
  local typeList = {
    SceneQuest_pb.EQUESTLIST_COMPLETE,
    SceneQuest_pb.EQUESTLIST_ACCEPT,
    SceneQuest_pb.EQUESTLIST_SUBMIT,
    SceneQuest_pb.EQUESTLIST_CANACCEPT
  }
  local userData = Game.Myself.data.userdata
  local nowRoleLevel = userData:Get(UDEnum.ROLELEVEL)
  local map = {}
  local npcRestrictType
  if npcid and GameConfig.Quest and GameConfig.Quest.NewWantedNpcType then
    npcRestrictType = GameConfig.Quest.NewWantedNpcType[npcid]
  end
  for i = 1, #typeList do
    local questType = typeList[i]
    local questList = self.questList[questType]
    if questList then
      for j = 1, #questList do
        local single = questList[j]
        if not single.type or single.type == QuestDataType.QuestDataType_VERSION then
          local nwTask
          for _, v in pairs(Table_NewWanted) do
            if v.QuestID == single.id and (not npcRestrictType or TableUtility.ArrayFindIndex(npcRestrictType, v.Type) > 0) then
              nwTask = v
              break
            end
          end
          if nwTask then
            local questLink = nwTask.QuestLink
            local ori = map[questLink]
            if not ori then
              map[questLink] = {
                quest = single,
                nwid = nwTask.id
              }
            elseif ori.nwid < nwTask.id then
              map[questLink] = {
                quest = single,
                nwid = nwTask.id
              }
            elseif ori.nwid == nwTask.id then
              local pL = self:getVersionQuestCoverPriority(ori.quest)
              local pR = self:getVersionQuestCoverPriority(single)
              if pL < pR then
                map[questLink] = {
                  quest = single,
                  nwid = nwTask.id
                }
              end
            end
          end
        end
      end
    end
  end
  for k, v in pairs(map) do
    table.insert(list, v)
  end
  table.sort(list, function(l, r)
    local pL = self:getVersionQuestSortPriority(l.quest)
    local pR = self:getVersionQuestSortPriority(r.quest)
    if pL ~= pR then
      return pL > pR
    end
    return l.quest.time > r.quest.time
  end)
  for i = #list, 3, -1 do
    table.remove(list, i)
  end
  table.sort(list, function(l, r)
    return l.nwid < r.nwid
  end)
  return list
end

function QuestProxy:getVersionQuestCoverPriority(single)
  local priority = 0
  if single:getQuestListType() == SceneQuest_pb.EQUESTLIST_CANACCEPT then
    priority = 1
  elseif single:getQuestListType() == SceneQuest_pb.EQUESTLIST_ACCEPT then
    priority = 2
  elseif single:getQuestListType() == SceneQuest_pb.EQUESTLIST_COMPLETE then
    priority = 3
  elseif single:getQuestListType() == SceneQuest_pb.EQUESTLIST_SUBMIT then
    priority = 4
  end
  return priority
end

function QuestProxy:getVersionQuestSortPriority(single)
  local priority = 0
  if single:getQuestListType() == SceneQuest_pb.EQUESTLIST_CANACCEPT then
    priority = 2
  elseif single:getQuestListType() == SceneQuest_pb.EQUESTLIST_ACCEPT then
    priority = 3
  elseif single:getQuestListType() == SceneQuest_pb.EQUESTLIST_COMPLETE then
    priority = 4
  elseif single:getQuestListType() == SceneQuest_pb.EQUESTLIST_SUBMIT then
    priority = 1
  end
  return priority
end

function QuestProxy:checkIsAllVersionQuestSubmitted(npcid)
  local npcRestrictType
  if npcid and GameConfig.Quest and GameConfig.Quest.NewWantedNpcType then
    npcRestrictType = GameConfig.Quest.NewWantedNpcType[npcid]
  end
  local submittedQuest = self.questList[SceneQuest_pb.EQUESTLIST_SUBMIT]
  if not submittedQuest or #submittedQuest == 0 then
    return false
  end
  local nwTasks = {}
  if npcRestrictType then
    for _, v in pairs(Table_NewWanted) do
      if v.Type and 0 < TableUtility.ArrayFindIndex(npcRestrictType, v.Type) then
        nwTasks[v.QuestID] = 1
      end
    end
  else
    for _, v in pairs(Table_NewWanted) do
      nwTasks[v.QuestID] = 1
    end
  end
  for i = 1, #submittedQuest do
    local single = submittedQuest[i]
    if single.type == "version" then
      nwTasks[single.id] = nil
    end
  end
  for k, v in pairs(nwTasks) do
    if v then
      return false
    end
  end
  return true
end

function QuestProxy:getWantedQuest()
  local list = {}
  local typeList = {
    SceneQuest_pb.EQUESTLIST_COMPLETE,
    SceneQuest_pb.EQUESTLIST_ACCEPT,
    SceneQuest_pb.EQUESTLIST_SUBMIT,
    SceneQuest_pb.EQUESTLIST_CANACCEPT
  }
  for i = 1, #typeList do
    local questType = typeList[i]
    local questList = self.questList[questType]
    self:AddWantedQuestToList(questType, list, questList)
  end
  table.sort(list, function(l, r)
    if l.wantedData and r.wantedData then
      local lAct = l.wantedData.IsActivity or 0
      local rAct = r.wantedData.IsActivity or 0
      if lAct == rAct then
        return l.id > r.id
      else
        return lAct > rAct
      end
    end
  end)
  return list
end

function QuestProxy:AddWantedQuestToList(questType, list, questList)
  if not questList then
    return
  end
  for j = 1, #questList do
    local single = questList[j]
    local valid = self:FilterWantedQuest(questType, single, list)
    if valid then
      table.insert(list, single)
    end
  end
end

function QuestProxy:FilterWantedQuest(questType, single, list)
  if single.type ~= QuestDataType.QuestDataType_WANTED or not single.wantedData then
    return
  end
  local minLevel = 0
  local maxLevel = 9999
  local userData = Game.Myself.data.userdata
  local nowRoleLevel = userData:Get(UDEnum.ROLELEVEL)
  if single.wantedData then
    minLevel = single.wantedData.LevelRange[1]
    maxLevel = single.wantedData.LevelRange[2]
  end
  if questType == SceneQuest_pb.EQUESTLIST_CANACCEPT and self:checkLevelInRange(nowRoleLevel, minLevel, maxLevel) then
    local tmpData = self:getWantedQuestDataByIdAndType(single.id, SceneQuest_pb.EQUESTLIST_SUBMIT)
    if not tmpData then
      tmpData = QuestProxy.getWantedQuestDataById(single.id, list)
      if not tmpData then
        return true
      end
    end
  elseif questType == SceneQuest_pb.EQUESTLIST_SUBMIT or questType == SceneQuest_pb.EQUESTLIST_ACCEPT or questType == SceneQuest_pb.EQUESTLIST_COMPLETE then
    return true
  end
end

function QuestProxy:getWantedQuestDataByIdAndType(id, type)
  local questList = self.questList[type]
  if not questList then
    return
  end
  for j = 1, #questList do
    local single = questList[j]
    if single.type == QuestDataType.QuestDataType_WANTED and id == single.id then
      return single
    end
  end
end

function QuestProxy.getWantedQuestDataById(id, list)
  if not list then
    return
  end
  for j = 1, #list do
    local single = list[j]
    if id == single.id then
      return single, j
    end
  end
end

function QuestProxy:getIllustrationQuest(mapId)
  local type = SceneQuest_pb.EQUESTLIST_ACCEPT
  local list = QuestProxy.Instance.questList[type]
  if not list then
    return
  end
  for i = 1, #list do
    local single = list[i]
    if single.questDataStepType == QuestDataStepType.QuestDataStepType_ILLUSTRATION and single.map == mapId then
      return single
    end
  end
end

function QuestProxy:getQuestListByMapAndSymbol(mapId)
  local type = SceneQuest_pb.EQUESTLIST_ACCEPT
  local playerLevel = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
  local list = QuestProxy.Instance.questList[type]
  local resultList = {}
  if not list then
    return resultList
  end
  for i = 1, #list do
    local single = list[i]
    if (single.map == nil or single.map == mapId) and single.staticData and single.params and (single.params.symbol or single.staticData.TraceInfo ~= "") and self:checkGuildQuest(single) and self:isCountDownQuestValid(single) then
      resultList[#resultList + 1] = single
    end
  end
  return resultList
end

function QuestProxy:getMiniMapQuestListByMap(mapId)
  local type = SceneQuest_pb.EQUESTLIST_ACCEPT
  local list = QuestProxy.Instance.questList[type]
  local playerLevel = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
  local resultList = {}
  if not list then
    return resultList
  end
  local isCurMapDahuang = self:CheckQuestInDahuang(mapId)
  for i = 1, #list do
    local single = list[i]
    if isCurMapDahuang then
      if (single.map == nil or self:CheckQuestInDahuang(single.map) and single.staticData) and single.params and (single.params.symbol or single.staticData.TraceInfo ~= "") and self:checkGuildQuest(single) and self:isCountDownQuestValid(single) then
        resultList[#resultList + 1] = single
      end
    elseif (single.map == nil or single.map == mapId and single.staticData) and single.params and (single.params.symbol or single.staticData.TraceInfo ~= "") and self:checkGuildQuest(single) and self:isCountDownQuestValid(single) then
      resultList[#resultList + 1] = single
    end
  end
  return resultList
end

function QuestProxy:CheckQuestInDahuang(mapId)
  if GameConfig and GameConfig.Quest then
    if GameConfig.Quest.worldquestmap and type(GameConfig.Quest.worldquestmap[1].map) == "table" then
      local mapGroup = GameConfig.Quest.worldquestmap
      for k, v in pairs(mapGroup) do
        for i = 1, #v.map do
          if curMapId == v.map[i] then
            return true
          end
        end
      end
      return false
    end
    return false
  end
end

function QuestProxy:getDailyQuestData(type)
  return self.DailyQuestData[type]
end

function QuestProxy:setDailyQuestData(data)
  local type = data.type
  local eOtherData = EOtherData.new(data.data)
  self.DailyQuestData[type] = eOtherData
end

function QuestProxy:AddTraceCells(cells)
  if cells then
    for i = 1, #cells do
      local single = cells[i]
      self:AddTraceCell(single)
    end
  end
end

function QuestProxy:AddTraceCell(traceData)
  local traceCell = self:GetTraceCell(traceData.type, traceData.id)
  if not traceCell then
    traceCell = TraceData.new()
    traceCell:UpdateByTraceData(traceData)
    local list = self.traceDatas[traceData.type] or {}
    table.insert(list, traceCell)
    self.traceDatas[traceData.type] = list
    FunctionQuest.Me():addTraceView(traceCell)
  else
    traceCell:UpdateByTraceData(traceData)
    FunctionQuest.Me():updateTraceView(traceCell)
  end
end

function QuestProxy:RemoveTraceCell(type, id)
  local traceCell, index = self:GetTraceCell(type, id)
  local list = self.traceDatas[type]
  if list and traceCell then
    table.remove(list, index)
    FunctionQuest.Me():removeTraceView(traceCell)
  end
end

function QuestProxy:RemoveTraceCells(datas)
  if not datas or #datas == 0 then
    return
  end
  for i = 1, #datas do
    local data = datas[i]
    local type = data.type
    local id = data.id
    self:RemoveTraceCell(type, id)
  end
end

function QuestProxy:GetTraceCell(type, id)
  local list = self.traceDatas[type]
  if not list or #list == 0 then
    return
  end
  for i = 1, #list do
    local single = list[i]
    if single.id == id then
      return single, i
    end
  end
end

function QuestProxy:UpdateTraceProcess(type, id, process)
  local traceCell, index = self:GetTraceCell(type, id)
  if traceCell then
    traceCell.process = process
    FunctionQuest.Me():updateTraceView(traceCell)
  end
end

function QuestProxy:UpdateTraceInfo(type, id, traceInfo)
  local traceCell, index = self:GetTraceCell(type, id)
  if traceCell then
    traceCell.traceInfo = traceInfo
    FunctionQuest.Me():updateTraceView(traceCell)
  end
end

function QuestProxy:hasQuestAccepted(questId)
  local type = SceneQuest_pb.EQUESTLIST_ACCEPT
  local list = QuestProxy.Instance.questList[type]
  if not list then
    return
  end
  for i = 1, #list do
    local single = list[i]
    if single.id == questId then
      return true
    end
  end
end

function QuestProxy:getTraceDatas()
  local list = {}
  for k, v in pairs(self.traceDatas) do
    if v and 0 < #v then
      for i = 1, #v do
        local single = v[i]
        table.insert(list, single)
      end
    end
  end
  return list
end

function QuestProxy:isInWantedQuestInActivity()
  if self.maxWantedCount and self.maxWantedCount ~= 0 then
    return true
  end
end

function QuestProxy:setMaxWanted(data)
  local maxcount = data.maxcount
  self.maxWantedCount = maxcount
end

function QuestProxy:getMaxWanted()
  if self.maxWantedCount and self.maxWantedCount ~= 0 then
    return self.maxWantedCount
  end
  return 3
end

function QuestProxy:getTraceDatasByType(type)
  return self.traceDatas[type]
end

function QuestProxy:hasGoingWantedQuest()
  return self.hasGoingQuest
end

function QuestProxy:setGoingWantedQuest(result)
  self.hasGoingQuest = result
end

function QuestProxy:isQuestCanBeShowTrace(type)
  for i = 1, #QuestData.NoTraceQuestDataType do
    local single = QuestData.NoTraceQuestDataType[i]
    if single == type then
      return false
    end
  end
  return true
end

function QuestProxy:checkCanShowNewNotice(questData)
  for i = 1, #QuestData.NewQuestNoticeIgnore do
    local single = QuestData.NewQuestNoticeIgnore[i]
    if single == questData.questDataStepType then
      return false
    end
  end
  return true
end

function QuestProxy:getWantedQuestRatio(submitCount)
  local ratio
  submitCount = submitCount or MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_QUEST_WANTED)
  submitCount = submitCount or 0
  local ratio = GameConfig.Quest.proportion[submitCount + 1]
  if not ratio then
    ratio = GameConfig.Quest.proportion[#GameConfig.Quest.proportion]
    printRed("can't find ratio by complete count:Var_pb.EVARTYPE_QUEST_WANTED:", submitCount)
  end
  return ratio
end

function QuestProxy:updateFubenQuestData(dataId, delete, raidConfig, uniqueid)
  local questData = self.fubenQuestMap[dataId]
  RaidPuzzleManager.Me():RemoveQuestTrigger(questData)
  if delete then
    self:removeFubenQuestData(dataId)
    return
  end
  if questData then
    return
  end
  questData = QuestData.CreateAsArray(QuestDataScopeType.QuestDataScopeType_FUBEN)
  self.fubenQuestMap[dataId] = questData
  questData:updateRaidData(dataId, raidConfig, uniqueid)
  questData.map = Game.MapManager:GetMapID()
  if not questData.staticData then
    errorLog(string.format("QuestProxy:updateFubenQuestData,can't find in Table_Raid by id:%s", tostring(dataId)))
  else
    FunctionQuest.Me():handleAutoTrigger(questData)
    FunctionQuest.Me():handleAutoExcute(questData)
    self:checkIfNeedRemoveGuideViewBySingleQuest(questData)
    if questData.staticData and questData.staticData.WhetherTrace ~= 1 and self:checkIsShowDirAndDisByQuestType(questData.questDataStepType) then
      local pos = questData.pos
      pos = pos and pos or FunctionQuestDisChecker.Me():getDestPostByUniqueId(questData.params.uniqueid)
      if pos then
        FunctionQuestDisChecker.Me():AddQuestCheck({questData = questData})
        if questData.params.invisible and questData.params.invisible == 1 then
        else
          FunctionQuest.Me():addQuestMiniShow(questData)
        end
      end
    end
    if not (questData and questData.params and questData.params.filtername) or questData.params.filtername.on == 1 then
    end
  end
end

function QuestProxy:getTraceFubenQuestData()
  for _, questData in pairs(self.fubenQuestMap) do
    if questData.staticData then
      local traceInfo = questData.staticData.TraceInfo
      if traceInfo ~= nil and traceInfo ~= "" then
        return questData
      end
    else
    end
  end
end

function QuestProxy:removeFubenQuestData(step)
  local questData = self.fubenQuestMap[step]
  if questData then
    if questData.id == 1120620001 then
      redlog("移除任务1120620001")
    end
    FunctionQuest.Me():stopTrigger(questData)
    FunctionQuest.Me():stopQuestMiniShow(questData.id)
    if questData.staticData and questData.staticData.Params then
      local cutscene_id = questData.staticData.Params.cutscene_id
      if cutscene_id and cutscene_id ~= 0 then
        Game.PlotStoryManager:Shutdown(true)
      end
    end
    ReusableObject.Destroy(questData)
    self.fubenQuestMap[step] = nil
  end
end

function QuestProxy:clearFubenQuestData()
  for key, data in pairs(self.fubenQuestMap) do
    FunctionQuest.Me():stopTrigger(data)
    FunctionQuest.Me():stopQuestMiniShow(data.id)
    ReusableObject.Destroy(data)
    self.fubenQuestMap[key] = nil
  end
  RaidPuzzleManager.Me():ClearQuestMap()
end

function QuestProxy:UpdateFubenProgress(data)
  helplog("UpdateFubenProgress:Id and progress", data.id, data.starid, data.progress)
  local questData = self.fubenQuestMap[data.starid]
  if questData then
    questData.process = data.progress
  else
    redlog("任务不存在")
  end
end

function QuestProxy:checkIsShowDirAndDisByQuestType(type)
  for i = 1, #QuestData.NoDirAndDisStepType do
    local single = QuestData.NoDirAndDisStepType[i]
    if single == type then
      return false
    end
  end
  return true
end

function QuestProxy:checkIsShowDirAndDisByQuestId(id)
  local questData = self:getQuestDataByIdAndType(id)
  if questData then
    return self:checkIsShowDirAndDis(questData)
  end
end

function QuestProxy:checkIsShowDirAndDis(questData)
  if questData then
    local bRet = false
    local traceStr = questData:parseTranceInfo()
    if traceStr ~= "" and self:checkIsShowDirAndDisByQuestType(questData.questDataStepType) and not questData.hideDirAndDis then
      bRet = true
    end
    return bRet
  end
end

function QuestProxy:checkMainQuestAutoExcute(questData)
  if questData and self:checkIsShowDirAndDisByQuestType(questData.questDataStepType) and questData.type == QuestDataType.QuestDataType_MAIN and questData.staticData and questData.staticData.Version then
    return true
  end
  return false
end

function QuestProxy:checkCanExcuteWhenDead(questData)
  if questData then
    local type = questData.questDataStepType
    for i = 1, #QuestData.CanExecuteWhenDeadStepType do
      local single = QuestData.CanExecuteWhenDeadStepType[i]
      if single == type then
        return true
      end
    end
    return false
  end
end

function QuestProxy:checkUpdateWithItemUpdate(questData)
  if questData then
    local type = questData.questDataStepType
    for i = 1, #QuestData.ItemUpdateStepType do
      local single = QuestData.ItemUpdateStepType[i]
      if single == type then
        return true
      end
    end
    return false
  end
end

function QuestProxy:addOrRemoveLockMonsterGuide(data)
  if not self.guideList then
    self.guideList = {}
  end
  if data then
    self.guideList[data.questId] = data.monsterId
  end
end

function QuestProxy:checkIfShowMonsterNamePre(questData)
  if questData and self:checkIsShowDirAndDis(questData) then
    local type = questData.questDataStepType
    for i = 1, #QuestData.ShowTargetNamePrefixStepType do
      local single = QuestData.ShowTargetNamePrefixStepType[i]
      if single == type then
        return true
      end
    end
  end
  return false
end

function QuestProxy:getQuestID(questID)
  local questId = questID / GameConfig.Quest.ratio
  questId = math.floor(questId)
  questId = questId == 0 and questID or questId
  return questId
end

function QuestProxy:getValidReward(questData)
  local questId = questData.id
  local id = self:getQuestID(questId)
  return self.menuDatas[id]
end

function QuestProxy:getValidAcceptQuestList(isTrace, mapLimitGroup)
  local questDataList = QuestProxy.Instance:getQuestListInOrder(SceneQuest_pb.EQUESTLIST_ACCEPT)
  local list = {}
  local playerLevel = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
  for i = 1, #questDataList do
    local single = questDataList[i]
    if single.staticData then
      local questType = single.type
      local validQuest = QuestProxy.Instance:checkGuildQuest(single)
      if questType == QuestDataType.QuestDataType_GUILDQUEST and validQuest then
        Game.QuestGuildManager:AddQuestEffect(single)
      end
      validQuest = QuestProxy.Instance:isCountDownQuestValid(single)
      local mapLimitQuest = false
      if mapLimitGroup then
        mapLimitQuest = QuestProxy.Instance:isQuestMapHide(single, mapLimitGroup)
      end
      if questType == QuestDataType.QuestDataType_COUNT_DOWN and validQuest then
        Game.QuestCountDownManager:AddQuestEffect(single)
      end
      local bFilterCt = single.staticData.TraceInfo ~= "" and validQuest and (not mapLimitGroup or mapLimitQuest)
      if isTrace ~= nil then
        bFilterCt = bFilterCt and self:CheckQuestIsTrace(single.id) ~= 2
      end
      if single.nInvadeStyle or bFilterCt then
        if single.staticData.FirstClass == destProfession then
          table.insert(list, single)
        elseif QuestProxy.Instance:isQuestCanBeShowTrace(questType) then
          table.insert(list, single)
        end
      end
    end
  end
  if isTrace == nil then
    table.sort(list, function(t1, t2)
      local lv1 = t1.staticData.Level or 0
      local lv2 = t2.staticData.Level or 0
      if lv1 == lv2 then
        return t1.time > t2.time
      else
        return lv1 > lv2
      end
    end)
  end
  return list
end

function QuestProxy:getLockMonsterGuideByMonsterId(monsterId)
  if not self.guideList then
    return
  end
  TableUtility.ArrayClear(tempArray)
  for k, v in pairs(self.guideList) do
    if monsterId == v then
      tempArray[#tempArray + 1] = k
    end
  end
  return tempArray
end

function QuestProxy:getAllPrequest(questData)
  if not questData then
    return
  end
  TableUtility.ArrayClear(tempArray)
  local preQuest = questData.preQuest
  local mustPreQuest = questData.mustPreQuest
  if #preQuest == 0 and #mustPreQuest == 0 then
    return tempArray
  end
  local questDataList = self.questList[SceneQuest_pb.EQUESTLIST_ACCEPT]
  for i = 1, #questDataList do
    local single = questDataList[i]
    if single.id ~= questData.id then
      local beSame = self:checkSameList(preQuest, single.preQuest)
      if beSame and self:checkSameList(mustPreQuest, single.mustPreQuest) then
        tempArray[#tempArray + 1] = {
          type = single.questListType,
          questData = single
        }
      end
    end
  end
  return tempArray
end

function QuestProxy:checkSameList(fList, sList)
  local sameSize = #fList == #sList
  if not sameSize then
    return false
  end
  local find = true
  for i = 1, #fList do
    local single = fList[i]
    find = TableUtility.ArrayFindIndex(sList, single) ~= 0
    if not find then
      return false
    end
  end
  return find
end

function QuestProxy:HasSameQuestID(questId)
  local list = self.questList[SceneQuest_pb.EQUESTLIST_ACCEPT]
  if not list then
    return false
  end
  local questID = self:getQuestID(questId)
  for j = 1, #list do
    local questData = list[j]
    local id = self:getQuestID(questData.id)
    if questID == id then
      return true
    end
  end
  return false
end

function QuestProxy:getSameQuestID(questId)
  local list = self.questList[SceneQuest_pb.EQUESTLIST_ACCEPT]
  if not list then
    return
  end
  local questID = self:getQuestID(questId)
  for j = 1, #list do
    local questData = list[j]
    local id = self:getQuestID(questData.id)
    if questID == id then
      return questData
    end
  end
end

function QuestProxy:GetValidQuestBySameQuestID(questId)
  local list = self.questList[SceneQuest_pb.EQUESTLIST_ACCEPT]
  if not list then
    return
  end
  local questID = self:getQuestID(questId)
  for j = 1, #list do
    local questData = list[j]
    local id = self:getQuestID(questData.id)
    if questID == id and self:checkIsShowDirAndDis(questData) then
      return questData
    end
  end
end

function QuestProxy:getQuestDataByQuestID(questId)
  local list = self.questList[SceneQuest_pb.EQUESTLIST_ACCEPT]
  if not list then
    return
  end
  for i = 1, #list do
    local questData = list[i]
    local id = self:getQuestID(questData.id)
    if questId == id then
      return questData
    end
  end
end

function QuestProxy:checkWantedQuestIsMarkedTeam(questId, step)
  if not self.guideList then
    return
  end
  TableUtility.ArrayClear(tempArray)
  for k, v in pairs(self.guideList) do
    if monsterId == v then
      tempArray[#tempArray + 1] = k
    end
  end
  return tempArray
end

function QuestProxy:RecvStepSyncBossCmd(serverdata)
  if serverdata.params then
    self.worldbossQuest = QuestDataUtil.parseBossStepParams(serverdata.params.params, serverdata.step)
  end
  if serverdata.step and serverdata.step == QuestProxy.BossStep.Dialog then
    self:PlayBossStepDialog(self.worldbossQuest.yes_dialogs)
  end
end

function QuestProxy:PlayBossStepDialog(dlist)
  if dlist then
    local viewdata = {
      viewname = "DialogView",
      dialoglist = dlist,
      callback = self.callNextBossStep
    }
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
    return
  end
end

function QuestProxy:callNextBossStep()
  ServiceBossCmdProxy.Instance:CallStepSyncBossCmd(nil)
end

function QuestProxy:getCurRaidQuest()
  local resultList = {}
  for key, questData in pairs(self.fubenQuestMap) do
    if not questData.hideInFuben then
      resultList[#resultList + 1] = questData
    end
  end
  local list = self.questList[SceneQuest_pb.EQUESTLIST_ACCEPT]
  if list and 0 < #list then
    for i = 1, #list do
      local single = list[i]
      if single.type == QuestDataType.QuestDataType_Raid_Talk then
        resultList[#resultList + 1] = single
      end
    end
  end
  return resultList
end

function QuestProxy:RemoveWorldQuest()
  helplog("RemoveWorldQuest")
  local listType = SceneQuest_pb.EQUESTLIST_ACCEPT
  local list = self.questList[listType]
  if not list then
    return
  end
  local delList = {}
  for i = 1, #list do
    local single = list[i]
    if single.type == "world" or single.type == "acc_world" or single.type == "acc_daily_world" then
      table.insert(delList, single)
    end
  end
  if #delList ~= 0 then
    GameFacade.Instance:sendNotification(QuestEvent.QuestDelete, delList)
    for i = 1, #delList do
      self:tryRemoveQuestId(delList[i].id, listType)
    end
  end
end

function QuestProxy:RecvWorldQuestTreasure(data)
  local treasures = data.treasures
  self.worldQuestTreasure = {}
  if treasures and 0 < #treasures then
    for i = 1, #data.treasures do
      local single = data.treasures[i]
      local temp = {}
      temp.npcid = single.npcid
      temp.questid = single.questid
      temp.pos = ProtolUtility.S2C_Vector3(single.pos)
      self.worldQuestTreasure[single.npcid] = temp
    end
  end
end

function QuestProxy:GetWorldQuestTreasure()
  if self.worldQuestTreasure then
    local result = {}
    for _, treasures in pairs(self.worldQuestTreasure) do
      if treasures then
        table.insert(result, treasures)
      end
    end
    return result
  end
end

function QuestProxy:RemoveWorldQuestTreasure()
  if self.worldQuestTreasure then
    TableUtility.TableClear(self.worldQuestTreasure)
  end
end

function QuestProxy:RemoveSingleWorldQuestTreause(npcid)
  if npcid and self.worldQuestTreasure[npcid] then
    self.worldQuestTreasure[npcid] = nil
  end
end

function QuestProxy:CheckWorldQuestProcess()
  local listType = SceneQuest_pb.EQUESTLIST_SUBMIT
  local list = self.questList[listType]
  local count = 0
  if list and 0 < #list then
    for i = 1, #list do
      local single = list[i]
      if Table_WorldQuest and Table_WorldQuest[single.id] and single.type ~= "worldtreasure" then
        count = count + 1
      end
    end
  end
  return count
end

function QuestProxy:SetWorldQuestProcess(data)
  self.worldQuestProcess = data.param1 or 0
  helplog("self.worldQuestProcess", self.worldQuestProcess)
end

function QuestProxy:GetWorldQuestProcess()
  if self.worldQuestProcess then
    return self.worldQuestProcess
  end
  return 0
end

function QuestProxy:updateDahuangQuestData(data)
  local list = data.stepid
  for i = 1, #list do
    local stepid = list[i]
    self:updateSingleQuestData(stepid)
  end
end

function QuestProxy:updateSingleQuestData(stepid)
  if Table_MapStep[stepid] then
    helplog("当前同步添加大荒魔物任务step", stepid)
    local questData = QuestData.CreateAsArray(QuestDataScopeType.QuestDataScopeType_DAHUANG)
    questData:updateDahuangData(Table_MapStep[stepid])
    questData.map = Table_MapStep[stepid].MapID
    questData.isMapStep = true
    self.DaHuangQuestMap[stepid] = questData
    if not questData.staticData then
      errorLog(string.format("QuestProxy:updateFubenQuestData,can't find in Table_Raid by id:%s", tostring(dataId)))
    else
      FunctionQuest.Me():handleAutoTrigger(questData)
      FunctionQuest.Me():handleAutoExcute(questData)
    end
  else
    redlog("stepid" .. stepid .. "无法在Table_MapQuest中搜寻到")
  end
end

function QuestProxy:MapQuestUpdate(data)
  local delList = data.del_stepid
  local addList = data.add_stepid
  if delList then
    for i = 1, #delList do
      local delStepId = delList[i]
      if self.DaHuangQuestMap[delStepId] then
        helplog("删除任务,并取消触发点" .. delStepId)
        FunctionQuest.Me():stopTrigger(self.DaHuangQuestMap[delStepId])
        self.DaHuangQuestMap[delStepId] = nil
      end
    end
    GameFacade.Instance:sendNotification(QuestEvent.DelDahuangEvent, delList)
  end
  if addList then
    for i = 1, #addList do
      local addStepId = addList[i]
      self:updateSingleQuestData(addStepId)
    end
  end
end

function QuestProxy:updateStepVisitQuestData(questId)
  if self.DaHuangQuestMap[questId] then
    local single = self.DaHuangQuestMap[questId]
    local dialog = single.params.dialog
    if 1 <= #dialog then
      table.remove(dialog, 1)
    end
    self.DaHuangQuestMap[questId].params.dialog = dialog
  end
end

function QuestProxy:RemoveDahuangQuestDataByMapId(CurMapId)
  for key, data in pairs(self.DaHuangQuestMap) do
    if data.map ~= CurMapId then
      FunctionQuest.Me():stopTrigger(data)
      ReusableObject.Destroy(data)
      self.DaHuangQuestMap[key] = nil
    end
  end
end

function QuestProxy:GetTraceDahuangQuestData()
  local resultList = ReusableTable.CreateTable()
  for key, data in pairs(self.DaHuangQuestMap) do
    if data.traceInfo ~= "" then
      table.insert(resultList, data)
    end
  end
  if resultList and 0 < #resultList then
    return resultList, true
  else
    return nil, false
  end
end

function QuestProxy:CheckQuestShow(data, playerLevel)
  local questData = data
  if questData.staticData and data.staticData.IconFromServer and (data.staticData.IconFromServer == 5 or data.staticData.IconFromServer == 20) then
    return true
  end
  if questData.done then
    return true
  elseif questData.staticData.hide == 1 then
    return true
  elseif questData.staticData.hide == 2 then
    return false
  else
    local level = questData.staticData.Level or 0
    if level == 0 then
      return true
    end
    if playerLevel - questData.staticData.Level >= 10 then
      return false
    else
      return true
    end
  end
end

function QuestProxy:GetCanAcceptMainQuestList()
  local questDataList = QuestProxy.Instance:getQuestListInOrder(SceneQuest_pb.EQUESTLIST_CANACCEPT)
  local list = {}
  for i = 1, #questDataList do
    local single = questDataList[i]
    if single.staticData and single.staticData.Version and single.predone then
      table.insert(list, single)
    end
  end
  return list
end

function QuestProxy:GetCanAcceptMainQuestListByVersion(Version)
  local questDataList = QuestProxy.Instance:getQuestListInOrder(SceneQuest_pb.EQUESTLIST_CANACCEPT)
  local list = {}
  for i = 1, #questDataList do
    local single = questDataList[i]
    if single.staticData and single.staticData.Version and single.staticData.Version == Version then
      table.insert(list, single)
    end
  end
  return list
end

function QuestProxy:isQuestMapHide(questData, group)
  local config = Table_QuestMapHide[group]
  if not config then
    return false
  end
  local questShowList = config.ShowQuest
  if questShowList and 0 < #questShowList then
    for i = 1, #questShowList do
      if questData.id == questShowList[i] then
        return true
      end
    end
  end
  return false
end

function QuestProxy:RecvWorldCountList(data)
  TableUtility.TableClear(self.worldQuestCountList)
  local list = data.list
  if list and 0 < #list then
    for i = 1, #list do
      local finishList = list[i]
      self.worldQuestCountList[finishList.groupid] = finishList.count
      xdlog("世界进度", finishList.groupid, finishList.count)
    end
  end
end

function QuestProxy:GetWorldCount(groupid)
  if not self.worldQuestCountList then
    return 0
  end
  return self.worldQuestCountList[groupid] or 0
end

function QuestProxy:RefreshValidClientTraceList(questDatas)
  local traceUpdateList = {}
  for i = 1, #questDatas do
    local single = questDatas[i]
    if single.trace_status == 1 then
      local questData = self:GetQuestDataBySameQuestID(single.id)
      if questData then
        if questData.staticData and questData.staticData.TraceInfo == "" then
          questData:SetQuestTraceStatus(2)
          local data = {
            questid = questData.id,
            status = 2
          }
          table.insert(traceUpdateList, data)
        elseif questData.type == "worldboss" then
          local status = LocalSaveProxy.Instance:GetWorldBossQuestTrace(questData.id)
          xdlog("检测周常是否合法", status)
          if single.trace_status ~= status then
            local data = {
              questid = questData.id,
              status = status
            }
            table.insert(traceUpdateList, data)
          end
        end
      end
    end
  end
  if 0 < #traceUpdateList then
    local str = ""
    for i = 1, #traceUpdateList do
      str = str .. traceUpdateList[i].questid .. ","
    end
    xdlog("追踪=1的非法列表", str)
    self:AddQuestStatusList(traceUpdateList)
  end
end

function QuestProxy:CheckQuestIsTrace(questid)
  local questData = self:GetQuestDataBySameQuestID(questid)
  if questData then
    return questData.tracestatus
  end
  return 0
end

function QuestProxy:CheckTraceLimit(isAdd)
  return false
end

function QuestProxy:AddTraceList(questid)
  local questData = self:GetQuestDataBySameQuestID(questid)
  if questData then
    questData:SetQuestTraceStatus(1)
    local data = {questid = questid, status = 1}
    self:AddQuestStatusList({data})
    self:callQuestStatus()
  end
end

function QuestProxy:AddQuestsToTraceList(questids)
  local traceUpdateList = {}
  for i = 1, #questids do
    local questid = questids[i]
    local questData = self:GetQuestDataBySameQuestID(questid)
    if questData then
      questData:SetQuestTraceStatus(1)
    end
    local data = {questid = questid, status = 1}
    table.insert(traceUpdateList, data)
  end
  if traceUpdateList and 0 < #traceUpdateList then
    self:AddQuestStatusList(traceUpdateList)
  end
end

function QuestProxy:RemoveTraceList(questid)
  local questData = self:GetQuestDataBySameQuestID(questid)
  if questData then
    questData:SetQuestTraceStatus(2)
    local data = {questid = questid, status = 2}
    self:AddQuestStatusList({data})
  end
end

function QuestProxy:RemoveTraceListByIDs(questids)
  local traceUpdateList = {}
  for i = 1, #questids do
    local questid = questids[i]
    local questData = self:GetQuestDataBySameQuestID(questid)
    if questData then
      questData:SetQuestTraceStatus(2)
    end
    local data = {questid = questid, status = 2}
    table.insert(traceUpdateList, data)
  end
  if traceUpdateList and 0 < #traceUpdateList then
    self:AddQuestStatusList(traceUpdateList)
  end
end

function QuestProxy:RemoveClientNewQuest(questid)
  local questData = self:GetQuestDataBySameQuestID(questid)
  if questData and questData.newstatus ~= 2 then
    local data = {questid = questid, status = 2}
    xdlog("移除new标记", questid)
    questData:SetQuestNewStatus(2)
    ServiceQuestProxy.Instance:CallSetQuestStatusQuestCmd(nil, {data})
  end
end

function QuestProxy:RemoveClientNewQuestByQuesIds(questids)
  local newUpdateList = {}
  for i = 1, #questids do
    local questid = questids[i]
    local questData = self:GetQuestDataBySameQuestID(questid)
    if questData.newstatus ~= 2 then
      questData:SetQuestNewStatus(2)
      local data = {questid = questid, status = 2}
      table.insert(newUpdateList, data)
    end
  end
  if 0 < #newUpdateList then
    ServiceQuestProxy.Instance:CallSetQuestStatusQuestCmd(nil, newUpdateList)
  end
end

function QuestProxy:HandleQuestUpdateAutoTrace(questids)
  local traceUpdateList = {}
  for i = 1, #questids do
    local questData = self:GetQuestDataBySameQuestID(questids[i])
    if questData and questData.tracestatus == 0 then
      local status
      if Table_WorldQuest[questData.id] then
        status = 3
      elseif questData.type == "worldboss" then
        local savedStatus = LocalSaveProxy.Instance:GetWorldBossQuestTrace(questData.id)
        if savedStatus then
          xdlog("111111111111111周常已记录，重置为记录状态", savedStatus)
          status = savedStatus
        else
          status = 1
        end
      else
        status = 1
      end
      local data = {
        questid = questData.id,
        status = status
      }
      questData:SetQuestTraceStatus(status)
      table.insert(traceUpdateList, data)
    end
  end
  if 0 < #traceUpdateList then
    self:AddQuestStatusList(traceUpdateList)
  end
end

function QuestProxy:RefreshFakeTrace(group)
  local acceptList = self.questList[SceneQuest_pb.EQUESTLIST_ACCEPT]
  local traceUpdateList = {}
  if acceptList and 0 < #acceptList then
    for i = 1, #acceptList do
      local single = acceptList[i]
      local config = Table_WorldQuest[single.id]
      if config and config.Version == group and single.tracestatus == 0 then
        single:SetQuestTraceStatus(3)
        local data = {
          questid = single.id,
          status = 3
        }
        table.insert(traceUpdateList, data)
      end
    end
  end
  if traceUpdateList and 0 < #traceUpdateList then
    self:AddQuestStatusList(traceUpdateList)
  end
end

function QuestProxy:RefreshFakeWorldQuestTrace(questDatas)
  local traceUpdateList = {}
  for i = 1, #questDatas do
    local single = questDatas[i]
    if single.trace_status == 0 then
      local questData = self:getQuestDataByIdAndType(single.id)
      if questData and self:checkIsShowDirAndDis(questData) then
        local status = 0
        if Table_WorldQuest[single.id] then
          status = 3
        elseif questData and questData.type == "worldboss" then
          local savedStatus = LocalSaveProxy.Instance:GetWorldBossQuestTrace(questData.id)
          if savedStatus then
            status = savedStatus
          else
            status = 1
          end
        else
          status = 1
        end
        if questData then
          questData:SetQuestTraceStatus(status)
        end
        local data = {
          questid = single.id,
          status = status
        }
        table.insert(traceUpdateList, data)
      end
    end
  end
  if traceUpdateList and 0 < #traceUpdateList then
    self:AddQuestStatusList(traceUpdateList)
  end
end

function QuestProxy:AddQuestStatusList(list)
  if list and 0 < #list then
    xdlog("AddQuestStatusList", #list)
    for i = 1, #list do
      self.tempQuestStatusUpdateList[list[i].questid] = list[i].status
    end
    self.nextTraceStatusValidTime = ServerTime.CurServerTime() / 1000 + 4
    self.traceStatusTick = TimeTickManager.Me():CreateTick(0, 1000, self.tryCallQuestStatus, self, 10)
  end
end

function QuestProxy:tryCallQuestStatus()
  if ServerTime.CurServerTime() / 1000 < self.nextTraceStatusValidTime then
    return
  end
  self:callQuestStatus()
end

function QuestProxy:callQuestStatus()
  local list = {}
  for k, v in pairs(self.tempQuestStatusUpdateList) do
    local data = {questid = k, status = v}
    table.insert(list, data)
  end
  TableUtility.TableClear(self.tempQuestStatusUpdateList)
  ServiceQuestProxy.Instance:CallSetQuestStatusQuestCmd(list)
  TimeTickManager.Me():ClearTick(self, 10)
  self.traceStatusTick = nil
end

function QuestProxy:RecvQueryQuestHeroQuestCmd(data)
  TableUtility.TableClear(self.previewSaleRoleTask)
  for i = 1, #data.items do
    self.previewSaleRoleTask[#self.previewSaleRoleTask + 1] = {}
    self.previewSaleRoleTask[#self.previewSaleRoleTask].id = data.items[i].id
    self.previewSaleRoleTask[#self.previewSaleRoleTask].status = data.items[i].status
    self.previewSaleRoleTask[#self.previewSaleRoleTask].first = {}
    for f = 1, #data.items[i].first do
      self.previewSaleRoleTask[#self.previewSaleRoleTask].first[f] = {}
      self.previewSaleRoleTask[#self.previewSaleRoleTask].first[f].questid = data.items[i].first[f].questid
      self.previewSaleRoleTask[#self.previewSaleRoleTask].first[f].config = {}
      self.previewSaleRoleTask[#self.previewSaleRoleTask].first[f].config.Level = data.items[i].first[f].config.Level
      self.previewSaleRoleTask[#self.previewSaleRoleTask].first[f].config.Name = data.items[i].first[f].config.Name
      self.previewSaleRoleTask[#self.previewSaleRoleTask].first[f].config.StartTime = data.items[i].first[f].config.StartTime
      self.previewSaleRoleTask[#self.previewSaleRoleTask].first[f].config.ID = data.items[i].first[f].config.ID
      if data.items[i].first[f].config.MustPreQuest then
        self.previewSaleRoleTask[#self.previewSaleRoleTask].first[f].config.MustPreQuest = {}
        self.previewSaleRoleTask[#self.previewSaleRoleTask].first[f].config.MustPreQuest[1] = data.items[i].first[f].config.MustPreQuest[1]
      end
      if data.items[i].first[f].config.PreQuest then
        self.previewSaleRoleTask[#self.previewSaleRoleTask].first[f].config.PreQuest = {}
        self.previewSaleRoleTask[#self.previewSaleRoleTask].first[f].config.PreQuest[1] = data.items[i].first[f].config.PreQuest[1]
      end
    end
  end
  self.previewSaleTaskAllComplate = true
  for p = 1, #self.previewSaleRoleTask do
    if self.previewSaleRoleTask[p].status ~= EQUESTHEROSTATUS.EQUESTHEROSTATUS_DONE then
      self.previewSaleTaskAllComplate = false
      break
    end
  end
end

function QuestProxy:RecvUpdateQuestHeroQuestCmd(data)
  if data and data.items then
    for i = 1, #data.items do
      if #self.previewSaleRoleTask > 0 then
        for p = 1, #self.previewSaleRoleTask do
          if self.previewSaleRoleTask[p].id == data.items[i].id then
            self.previewSaleRoleTask[p].id = data.items[i].id
            self.previewSaleRoleTask[p].status = data.items[i].status
            for f = 1, #data.items[i].first do
              self.previewSaleRoleTask[p].first[f] = {}
              self.previewSaleRoleTask[p].first[f].questid = data.items[i].first[f].questid
              self.previewSaleRoleTask[p].first[f].config = {}
              self.previewSaleRoleTask[p].first[f].config.Level = data.items[i].first[f].config.Level
              self.previewSaleRoleTask[p].first[f].config.Name = data.items[i].first[f].config.Name
              self.previewSaleRoleTask[p].first[f].config.StartTime = data.items[i].first[f].config.StartTime
              self.previewSaleRoleTask[p].first[f].config.ID = data.items[i].first[f].config.ID
              if data.items[i].first[f].config.MustPreQuest then
                self.previewSaleRoleTask[p].first[f].config.MustPreQuest = {}
                self.previewSaleRoleTask[p].first[f].config.MustPreQuest[1] = data.items[i].first[f].config.MustPreQuest[1]
              end
              if data.items[i].first[f].config.PreQuest then
                self.previewSaleRoleTask[p].first[f].config.PreQuest = {}
                self.previewSaleRoleTask[p].first[f].config.PreQuest[1] = data.items[i].first[f].config.PreQuest[1]
              end
            end
            break
          end
        end
      else
        TableUtility.TableClear(self.previewSaleRoleTask)
        for i = 1, #data.items do
          self.previewSaleRoleTask[#self.previewSaleRoleTask + 1] = {}
          self.previewSaleRoleTask[#self.previewSaleRoleTask].id = data.items[i].id
          self.previewSaleRoleTask[#self.previewSaleRoleTask].status = data.items[i].status
          self.previewSaleRoleTask[#self.previewSaleRoleTask].first = {}
          for f = 1, #data.items[i].first do
            self.previewSaleRoleTask[#self.previewSaleRoleTask].first[f] = {}
            self.previewSaleRoleTask[#self.previewSaleRoleTask].first[f].questid = data.items[i].first[f].questid
            self.previewSaleRoleTask[#self.previewSaleRoleTask].first[f].config = {}
            self.previewSaleRoleTask[#self.previewSaleRoleTask].first[f].config.Level = data.items[i].first[f].config.Level
            self.previewSaleRoleTask[#self.previewSaleRoleTask].first[f].config.Name = data.items[i].first[f].config.Name
            self.previewSaleRoleTask[#self.previewSaleRoleTask].first[f].config.StartTime = data.items[i].first[f].config.StartTime
            self.previewSaleRoleTask[#self.previewSaleRoleTask].first[f].config.ID = data.items[i].first[f].config.ID
            if data.items[i].first[f].config.MustPreQuest then
              self.previewSaleRoleTask[#self.previewSaleRoleTask].first[f].config.MustPreQuest = {}
              self.previewSaleRoleTask[#self.previewSaleRoleTask].first[f].config.MustPreQuest[1] = data.items[i].first[f].config.MustPreQuest[1]
            end
            if data.items[i].first[f].config.PreQuest then
              self.previewSaleRoleTask[#self.previewSaleRoleTask].first[f].config.PreQuest = {}
              self.previewSaleRoleTask[#self.previewSaleRoleTask].first[f].config.PreQuest[1] = data.items[i].first[f].config.PreQuest[1]
            end
          end
        end
        self.previewSaleTaskAllComplate = true
        for p = 1, #self.previewSaleRoleTask do
          if self.previewSaleRoleTask[p].status ~= EQUESTHEROSTATUS.EQUESTHEROSTATUS_DONE then
            self.previewSaleTaskAllComplate = false
            break
          end
        end
      end
    end
  end
end

local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
local parseStamp = function(str)
  local year, month, day, hour, min, sec = str:match(p)
  return os.time({
    year = year,
    month = month,
    day = day,
    hour = hour,
    min = min,
    sec = sec
  })
end

function QuestProxy:IsPreviewSaleRoleTaskOpen()
  local isTFBranch = EnvChannel.IsTFBranch()
  local isTimeOpen = false
  if #self.previewSaleRoleTask > 0 then
    for p = 1, #self.previewSaleRoleTask do
      local cfg = Table_QuestHero[self.previewSaleRoleTask[p].id]
      local startTime = ServerTime.CurServerTime() / 1000 or 0
      local cfgstartTime
      if isTFBranch == true then
        cfgstartTime = parseStamp(cfg.TFStartTime)
      else
        cfgstartTime = parseStamp(cfg.StartTime)
      end
      local offlineSec = startTime - cfgstartTime
      if 0 < offlineSec then
        isTimeOpen = true
        break
      end
    end
    if self.previewSaleTaskAllComplate == true then
      isTimeOpen = false
    end
  end
  return isTimeOpen
end

function QuestProxy:PreviewSaleRoleTask()
  return self.previewSaleRoleTask
end

function QuestProxy:GetPreviewSaleRoleTaskName(MustPreQuestID)
  local taskName = ""
  for i = 1, #self.previewSaleRoleTask do
    for f = 1, #self.previewSaleRoleTask[i].first do
      if self.previewSaleRoleTask[i].first[f].questid == MustPreQuestID then
        taskName = self.previewSaleRoleTask[i].first[f].config.Name
        break
      end
    end
    if taskName ~= "" then
      break
    end
  end
  return taskName
end

function QuestProxy:SyncVisitNpcInfo(data)
  redlog("SyncVisitNpcInfo", innerString(data))
  if not self.syncsceneNpcMap then
    self.syncsceneNpcMap = {}
  else
    TableUtility.TableClear(self.syncsceneNpcMap)
  end
  if data then
    if data.visit then
      self.syncsceneNpcMap[data.npctempid or 0] = data.charid or 0
    else
      self.syncsceneNpcMap[data.npctempid or 0] = nil
    end
  end
end

function QuestProxy:CheckVisitNpcAvailable(npcguid, charid)
  local curCharID = self.syncsceneNpcMap and self.syncsceneNpcMap[npcguid]
  return not curCharID or curCharID == 0 or curCharID == charid
end

function QuestProxy:RecvUpdateOnceRewardQuestCmd(data)
  local items = data.item
  if items and 0 < #items then
    TableUtility.TableClear(self.questOnceRewardMap)
    for i = 1, #items do
      local questid = items[i].questid
      self.questOnceRewardMap[questid] = {}
      local rewards = items[i].reward or {}
      for j = 1, #rewards do
        self.questOnceRewardMap[questid][rewards[j].origin_reward] = rewards[j].replace_reward
      end
    end
  end
end

function QuestProxy:GetOnceRewardByQuestID(questid)
  if self.questOnceRewardMap and self.questOnceRewardMap[questid] then
    return self.questOnceRewardMap[questid]
  end
end

function QuestProxy:GetReplacedRewardByQuestData(questData)
  local allrewards = questData.allrewardid
  local result = {}
  for questid, rewards in pairs(allrewards) do
    local onceRewardMap = QuestProxy.Instance:GetOnceRewardByQuestID(questid)
    for i = 1, #rewards do
      if onceRewardMap and onceRewardMap[rewards[i]] then
        table.insert(result, onceRewardMap[rewards[i]])
      else
        table.insert(result, rewards[i])
      end
    end
  end
  return result
end

function QuestProxy:RefreshWorldQuestNewSymbol()
  if not Table_WorldQuest then
    return
  end
  local groupStatus = {}
  local todoList = {}
  local questList = self.questList[SceneQuest_pb.EQUESTLIST_ACCEPT] or {}
  local branchCheckList = GameConfig.Quest.worldquestRelated
  for i = 1, #questList do
    local questData = questList[i]
    local questid = questData.id
    local staticData = Table_WorldQuest[questid]
    local version = staticData and staticData.Version
    if version and questData.newstatus ~= 2 then
      if not groupStatus[version] then
        groupStatus[version] = Game.MapManager:GetWorldQuestProcessAllFinish(version) and 1 or 0
      end
      if groupStatus[version] == 1 then
        local data = {questid = questid, status = 2}
        questData:SetQuestNewStatus(2)
        table.insert(todoList, data)
      end
    elseif branchCheckList then
      for version, list in pairs(branchCheckList) do
        if questData.newstatus ~= 2 and 0 < TableUtility.ArrayFindIndex(list, questid) then
          if not groupStatus[version] then
            groupStatus[version] = Game.MapManager:GetWorldQuestProcessAllFinish(version) and 1 or 0
          end
          if groupStatus[version] == 1 then
            local data = {questid = questid, status = 2}
            questData:SetQuestNewStatus(2)
            table.insert(todoList, data)
          end
        end
      end
    end
  end
  if 0 < #todoList then
    ServiceQuestProxy.Instance:CallSetQuestStatusQuestCmd(nil, todoList)
  end
end

function QuestProxy:mInitNInvadeTraceInfo()
  if self.NInvadeTraceListMap then
    return
  end
  if not GameConfig.MonsterInvasion then
    GameConfig.MonsterInvasion = {
      LimitMaxNum = {
        [51] = {180, 1000}
      }
    }
  end
  self.NInvadeTraceStyle = {}
  for questKey, limitItem in pairs(GameConfig.MonsterInvasion.LimitMaxNum) do
    self.NInvadeTraceStyle[questKey] = {
      LimitItem = limitItem,
      NoAccept = ZhString.QuestProxy_Activity_NoAccess,
      Accept = ZhString.QuestProxy_Activity_Accept,
      Choose = ZhString.QuestProxy_Activity_Choose,
      Finish = ZhString.QuestProxy_Activity_Finish
    }
  end
  self.NInvadeTraceListMap = {}
  for k, v in pairs(Table_FinishTraceInfo) do
    if self.NInvadeTraceStyle[v.QuestKey] then
      if not self.NInvadeTraceListMap[v.QuestKey] then
        self.NInvadeTraceListMap[v.QuestKey] = {v}
      else
        table.insert(self.NInvadeTraceListMap[v.QuestKey], v)
      end
    end
  end
  local sortRule = function(a, b)
    return a.id < b.id
  end
  for groupId, questList in pairs(self.NInvadeTraceListMap) do
    table.sort(questList, sortRule)
  end
end

function QuestProxy:GetNInvadeTraceStyle(questKey)
  self:mInitNInvadeTraceInfo()
  return self.NInvadeTraceStyle[questKey]
end

function QuestProxy:GetNInvadeTraceList(questKey)
  self:mInitNInvadeTraceInfo()
  return self.NInvadeTraceListMap[questKey]
end

function QuestProxy:RecvSyncTreasureBoxNumCmd(data)
  local mapid = data.mapid
  if mapid then
    self.mapTreasure[mapid] = {
      gotten_num = data.gotten_num,
      total_num = data.total_num
    }
    xdlog("同步宝箱数据", mapid, data.gotten_num, data.total_num)
  end
end

function QuestProxy:GetTreasureBoxData(mapid)
  if self.mapTreasure[mapid] then
    return self.mapTreasure[mapid]
  end
end
