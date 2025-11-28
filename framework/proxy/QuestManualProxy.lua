autoImport("FuncUnlockManulData")
QuestManualProxy = class("QuestManualProxy", pm.Proxy)
QuestManualProxy.Instance = nil
QuestManualProxy.NAME = "QuestManualProxy"

function QuestManualProxy:ctor(proxyName, data)
  self.proxyName = proxyName or QuestManualProxy.NAME
  if QuestManualProxy.Instance == nil then
    QuestManualProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:InitProxy()
end

function QuestManualProxy:InitProxy()
  self.manualDataVersionMap = {}
  self.lastVersion = 1
  self.lastTab = 0
  self.lastGenTab = 1
  self.currentStoryAudioIndex = 0
  self.continueQuestMap = {}
  self:InitContinueQuest()
  self:PreprocessPlotVoice()
  self.setEnd = false
  self.manualVersionGoal = {}
  self.versionGoalReward = {}
  self.mainStoryMap = {}
  self:InitMainStoryIndex()
  self.questStoryIndex = {}
  self.questStoryInfo = {}
  self.latestVersionSort = 0
end

function QuestManualProxy:InitProxyData()
  if self.manualDataVersionMap then
    TableUtility.TableClear(self.manualDataVersionMap)
  end
  if self.funcOpenMap then
    TableUtility.TableClear(self.funcOpenMap)
  end
  if self.funcOpenList then
    TableUtility.ArrayClear(self.funcOpenList)
  end
end

function QuestManualProxy:GetManualQuestDatas(version)
  self.recentVersion = version
  return self.manualDataVersionMap[version]
end

function QuestManualProxy:GetQuestNameDataById(questId)
  local questName = ""
  if self.recentVersion then
    local versionData = self.manualDataVersionMap[self.recentVersion]
    if versionData then
      questName = versionData.prequest[questId]
    end
  end
  return questName
end

function QuestManualProxy:HandleRecvQueryManualQuestCmd(data)
  local version = data.version
  local manual = data.manual
  if manual then
    local oldData = self.manualDataVersionMap[version]
    if not oldData then
      manualData = ManualData.new(manual, version)
      self.manualDataVersionMap[version] = manualData
    end
  end
end

function QuestManualProxy:OpenPuzzle(version, index)
  local versionData = self.manualDataVersionMap[version]
  if versionData then
    local openPuzzles = versionData.main.puzzle.open_puzzles
    openPuzzles[#openPuzzles + 1] = index
    local curentPuzzleCount = #openPuzzles
    local colectAwardList = self:GetQuestPuzzleCollectListByVersion(version)
    local unlockPuzzles = versionData.main.puzzle.unlock_puzzles
    for i = 1, #colectAwardList do
      if curentPuzzleCount == colectAwardList[i].indexss then
        unlockPuzzles[#unlockPuzzles + 1] = curentPuzzleCount
      end
    end
  end
end

function QuestManualProxy:CheckPuzzleAwardLock(version, index)
  local versionData = self.manualDataVersionMap[version]
  if versionData then
    local unlockPuzzles = versionData.main.puzzle.unlock_puzzles
    for i = 1, #unlockPuzzles do
      if unlockPuzzles[i] == index then
        return false
      end
    end
  end
  return true
end

function QuestManualProxy:GetQuestPuzzleCollectListByVersion(version)
  local puzzleList = {}
  for k, v in pairs(Table_QuestPuzzle) do
    if v.version == version and v.type == "collect" then
      puzzleList[#puzzleList + 1] = v
    end
  end
  return puzzleList
end

function QuestManualProxy:SetCurrentStoryAudioIndex(value)
  self.currentStoryAudioIndex = value
end

function QuestManualProxy:GetCurrentStoryAudioIndex()
  return self.currentStoryAudioIndex
end

function QuestManualProxy:CheckContinueNeed(versionId, tabId)
  local continueQuestId = 0
  if self.continueQuestMap[versionId] then
    continueQuestId = self.continueQuestMap[versionId][tabId]
  end
  local versionDatas = self:GetManualQuestDatas(versionId)
  if versionDatas and versionDatas.main.questList and 0 < #versionDatas.main.questList then
    for i = 1, #versionDatas.main.questList do
      local single = versionDatas.main.questList[i]
      if (single.type == SceneQuest_pb.EQUESTLIST_COMPLETE or single.type == SceneQuest_pb.EQUESTLIST_SUBMIT) and single.questData and single.questData.id == continueQuestId then
        xdlog("相同任务", tabId)
        return true
      end
    end
  end
  return false
end

QuestName = class("QuestName")

function QuestName:ctor(serverdata)
  if serverdata then
    self.id = serverdata.id
    self.name = serverdata.name
    self.questlisttype = serverdata.type
  end
end

function QuestName:GetQuestName()
  return self.name
end

function QuestName:isComplete()
  return self.questlisttype == SceneQuest_pb.EQUESTLIST_COMPLETE or self.questlisttype == SceneQuest_pb.EQUESTLIST_SUBMIT
end

ManualData = class("ManualData")

function ManualData:ctor(data, version)
  self.version = version
  self:updata(data)
end

function ManualData:updata(data)
  self.prequest = {}
  if data.prequest and #data.prequest > 0 then
    for i = 1, #data.prequest do
      local quest = data.prequest[i]
      local qdata = QuestName.new(quest)
      self.prequest[quest.id] = qdata
    end
  end
  if data.main then
    self.main = {}
    self.main.questList = {}
    local mainItems = data.main.items
    if mainItems and 0 < #mainItems then
      helplog("主线手动数据总长度", #mainItems)
      for i = 1, #mainItems do
        self.main.questList[#self.main.questList + 1] = QuestManualItem.new(mainItems[i], self.prequest)
      end
    end
    if data.main.puzzle then
      self.main.puzzle = QuestPuzzle.new(data.main.puzzle)
    end
    local mainStoryids = data.main.mainstoryid
    if type(mainStoryids) == "table" then
      if mainStoryids and 0 < #mainStoryids then
        self.main.mainstoryid = {}
        for i = 1, #mainStoryids do
          self.main.mainstoryid[#self.main.mainstoryid + 1] = mainStoryids[i]
        end
      end
    else
      self.main.mainstoryid = mainStoryids
    end
    if data.main.previews then
      self.main.questPreviewList = {}
      local previewItems = data.main.previews
      if previewItems and 0 < #previewItems then
        for i = 1, #previewItems do
          self.main.questPreviewList[#self.main.questPreviewList + 1] = QuestPreviewItem.new(previewItems[i])
        end
        table.sort(self.main.questPreviewList, function(l, r)
          return l.index < r.index
        end)
      end
    end
  end
  if data.branch then
    self.branch = {}
    local questShops = data.branch.shops
    for i = 1, #questShops do
      self.branch[#self.branch + 1] = BranchQuestManualItem.new(questShops[i], self.prequest)
    end
  end
  if data.story and data.story.previews then
    self.storyQuestList = {}
    local storyItems = data.story.previews
    if storyItems and 0 < #storyItems then
      for i = 1, #storyItems do
        self.storyQuestList[#self.storyQuestList + 1] = QuestPreviewItem.new(storyItems[i])
      end
    end
    self.poemCompleteList = {}
    local completelist = data.story.submit_ids
    local len = #completelist
    local k = 0
    for i = 1, len do
      k = completelist[i]
      self.poemCompleteList[k] = k
    end
  end
  if data.plotvoice then
    self.plotVoiceQuestList = {}
    for i = 1, #data.plotvoice do
      table.insert(self.plotVoiceQuestList, data.plotvoice[i])
    end
  end
end

function ManualData:CheckContinueNeed()
  return self.needContinue
end

function QuestManualProxy:InitFunctionOpening()
  if not self.funcOpenMap then
    self.funcOpenMap = {}
  else
    TableUtility.TableClear(self.funcOpenMap)
  end
  if not self.funcOpenList then
    self.funcOpenList = {}
  else
    TableUtility.TableClear(self.funcOpenList)
  end
end

function QuestManualProxy:GetFunctionOpeningData(categoryIndex)
  if self.funcOpenMap then
    return self.funcOpenMap[categoryIndex]
  end
  return nil
end

function QuestManualProxy:GetCategoryList()
  return self.funcOpenList
end

function QuestManualProxy:RecvManualFunctionQuestCmd(serverdata)
  if serverdata.items then
    local displayRace = MyselfProxy.Instance:GetMyRace()
    self:InitFunctionOpening()
    local datas = serverdata.items
    for i = 1, #datas do
      local single = datas[i]
      local key = Table_FunctionOpening[single.id].Type
      local configRace = Table_FunctionOpening[single.id].Race
      local funcState
      if Table_FunctionOpening[single.id].FuncState and not FunctionUnLockFunc.checkFuncStateValid(Table_FunctionOpening[single.id].FuncState) then
        funcState = false
      else
        funcState = true
      end
      if configRace == displayRace and funcState then
        if not self.funcOpenMap[key] then
          self.funcOpenMap[key] = {}
          table.insert(self.funcOpenList, key)
        end
        local fdata = FuncUnlockManulData.new(single)
        table.insert(self.funcOpenMap[key], fdata)
      end
    end
    if self.funcOpenList and #self.funcOpenList > 0 then
      table.sort(self.funcOpenList, function(l, r)
        return l < r
      end)
    end
  end
end

function QuestManualProxy:CheckProgress(categoryIndex)
  if self.funcOpenMap then
    local tempC = self.funcOpenMap[categoryIndex]
    local total = #tempC
    local current = 0
    local stop = 0
    for i = 1, total do
      if FunctionUnLockFunc.Me():CheckCanOpen(tempC[i].menuid) then
        current = current + 1
      elseif not tempC[i]:GetCurrentTraceQuest() then
        stop = stop + 1
      end
    end
    return current, total, total - current == stop
  end
end

function QuestManualProxy:GetVersionlist()
  local questversion = ReusableTable.CreateArray()
  local myPro = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  for k, v in pairs(Table_QuestVersion) do
    local copy = {}
    if v.ClassID and #v.ClassID ~= 0 then
      local findFlag = false
      for i = 1, #v.ClassID do
        if myPro == v.ClassID[i] then
          findFlag = true
          break
        end
      end
      if findFlag then
        TableUtility.TableShallowCopy(copy, v)
        TableUtility.ArrayPushBack(questversion, copy)
      end
    else
      TableUtility.TableShallowCopy(copy, v)
      TableUtility.ArrayPushBack(questversion, copy)
    end
  end
  table.sort(questversion, function(l, r)
    return l.id < r.id
  end)
  return questversion
end

function QuestManualProxy:InitContinueQuest()
  for k, v in pairs(Table_MainStory) do
    if v.ToBeContinued and v.ToBeContinued == 1 then
      redlog("tonumber(v.version)", v.version, v.QuestID[1])
      if not self.continueQuestMap[v.version] then
        self.continueQuestMap[v.version] = {}
      end
      local tab = v.Tab or 1
      self.continueQuestMap[v.version][tab] = v.QuestID[1]
    end
  end
end

function QuestManualProxy:GetContinueQuest(version)
  if self.continueQuestMap[version] then
    return self.continueQuestMap[version]
  end
end

function QuestManualProxy:GetPlotQuestList(version)
  return self.manualDataVersionMap[version] and self.manualDataVersionMap[version].plotVoiceQuestList
end

function QuestManualProxy:PreprocessPlotVoice()
  if not self.plotVoiceMap then
    self.plotVoiceMap = {}
  else
    TableUtility.TableClear(self.plotVoiceMap)
  end
  local versionid
  for k, v in pairs(Table_PlotVoice) do
    versionid = v.Version
    if not self.plotVoiceMap[versionid] then
      self.plotVoiceMap[versionid] = {}
      self.plotVoiceMap[versionid] = PlotVoiceData.new(versionid, v.Map, k)
    else
      self.plotVoiceMap[versionid]:Update(versionid, v.Map, k)
    end
  end
end

function QuestManualProxy:GetPlotVoiceData(versionid)
  return self.plotVoiceMap[versionid]
end

local pData, mapquestIndex
local pQuestID = 1
local pQuestlist

function QuestManualProxy:CheckPlotQuestComplete(version, mapID)
  pData = self.plotVoiceMap[version]
  mapquestIndex = pData:GetMapQuestList(mapID)
  pQuestlist = self:GetPlotQuestList(version)
  local completeCount = 0
  for i = 1, #mapquestIndex do
    pQuestID = Table_PlotVoice[mapquestIndex[i]].QuestID
    for j = 1, #pQuestlist do
      if pQuestID == pQuestlist[j] then
        completeCount = completeCount + 1
      end
    end
  end
  return completeCount == #mapquestIndex
end

function QuestManualProxy:CheckPlotCompleteByQuestID(version, questid)
  pData = self.plotVoiceMap[version]
  pQuestlist = self:GetPlotQuestList(version)
  for j = 1, #pQuestlist do
    if questid == pQuestlist[j] then
      return true
    end
  end
  return false
end

function QuestManualProxy:InitMainStoryIndex()
  if not Table_MainQuestStory then
    return
  end
  for k, v in pairs(Table_MainQuestStory) do
    local version = v.version
    if not self.mainStoryMap[version] then
      self.mainStoryMap[version] = {}
    end
    local curVersion = self.mainStoryMap[version]
    local index = v.index
    if not curVersion.indexList then
      curVersion.indexList = {}
    end
    if index then
      local id = v.id
      curVersion.indexList[index] = id
      local levelRange = v.LvRange
      if levelRange ~= _EmptyTable then
        local minValue = math.min(unpack(levelRange))
        local maxValue = math.max(unpack(levelRange))
        if not curVersion.minLevel or minValue < curVersion.minLevel then
          curVersion.minLevel = minValue
        end
        if not curVersion.maxLevel or maxValue > curVersion.maxLevel then
          curVersion.maxLevel = maxValue
        end
      end
      if not curVersion.maxIndex then
        curVersion.maxIndex = 1
      else
        curVersion.maxIndex = curVersion.maxIndex + 1
      end
    end
  end
end

function QuestManualProxy:RecvUpdateQuestStoryIndexQuestCmd(data)
  local version = data.version
  if not self.questStoryInfo[version] then
    self.questStoryInfo[version] = {}
  end
  local indexs = data.indexs
  if indexs and 0 < #indexs then
    for i = 1, #indexs do
      local indexInfo = indexs[i]
      local index = indexInfo.index
      if self.questStoryInfo[version][index] then
        TableUtility.TableClear(self.questStoryInfo[version][index])
        self.questStoryInfo[version][index] = nil
      end
      local indexData = {
        status = indexInfo.index_status
      }
      local rewards = indexInfo.rewards
      if rewards and 0 < #rewards then
        indexData.rewards = {}
        for j = 1, #rewards do
          local rewardList = rewards[j].reward
          for k = 1, #rewardList do
            if rewardList[k].replace_reward and rewardList[k].replace_reward ~= 0 then
              table.insert(indexData.rewards, rewardList[k].replace_reward)
            end
          end
        end
      end
      local curQuestCount = 0
      local preQuestCount = 0
      if indexInfo.index_status ~= 3 then
        local curItem = indexInfo.cur_item
        if curItem and 0 < #curItem then
          indexData.curQuestData = {}
          for j = 1, #curItem do
            local singlePreQuestData = QuestPConfigItem.new(curItem[j])
            table.insert(indexData.curQuestData, singlePreQuestData)
            curQuestCount = curQuestCount + 1
          end
        end
        local preQuestData = indexInfo.pre_item
        if preQuestData and 0 < #preQuestData then
          indexData.preQuestData = {}
          for j = 1, #preQuestData do
            local singlePreQuestData = QuestPConfigItem.new(preQuestData[j])
            table.insert(indexData.preQuestData, singlePreQuestData)
            preQuestCount = preQuestCount + 1
          end
        end
        local subQuestData = indexInfo.sub_item
        if subQuestData and 0 < #subQuestData then
          indexData.subQuestData = {}
          for j = 1, #subQuestData do
            local singleSubQuestData = QuestPConfigItem.new(subQuestData[j])
            table.insert(indexData.subQuestData, singleSubQuestData)
          end
        end
      end
      if indexInfo.index_status == 3 then
        local versionInfo = self.mainStoryMap[version]
        local staticID = versionInfo and versionInfo.indexList and versionInfo.indexList[index]
        local staticData = staticID and Table_MainQuestStory[staticID]
        if staticData and staticData.Mstory == _EmptyTable then
          indexData.hideInList = true
        end
      else
        indexData.hideInList = false
      end
      self.questStoryInfo[version][index] = indexData
    end
  end
  local hideVersion = true
  for index, indexData in pairs(self.questStoryInfo[version]) do
    if not indexData.hideInList then
      hideVersion = false
      break
    end
  end
  if hideVersion then
    TableUtility.TableClear(self.questStoryInfo[version])
    self.questStoryInfo[version] = nil
    return
  end
  local isInProcess = self:IsVersionInProcess(version)
  if isInProcess then
    for k, v in pairs(Table_QuestVersion) do
      if (not v.Tab or v.Tab == 1) and v.version == version then
        local nextSort = v.sortid + 1
        if nextSort > self.latestVersionSort then
          self.latestVersionSort = nextSort
        end
      end
    end
  end
end

function QuestManualProxy:GetStoryVersionInfo(version)
  if self.questStoryInfo[version] then
    return self.questStoryInfo[version]
  end
end

function QuestManualProxy:GetStoryIndexInfo(version, index)
  if not self.questStoryInfo[version] then
    return
  end
  return self.questStoryInfo[version][index]
end

function QuestManualProxy:GetQuestIndexStatus(version, index)
  if not version then
    return
  end
  if not index then
    return
  end
  local versionInfo = self.questStoryInfo[version]
  local indexInfo = versionInfo and versionInfo[index]
  local status = indexInfo and indexInfo.status or 0
  return status
end

function QuestManualProxy:GetVersionIndexProcess(version)
  if not self.mainStoryMap[version] then
    redlog("version不存在", version)
    return 0, 0
  end
  local versionInfo = self.questStoryInfo[version]
  local maxIndex = 0
  local curFinishCount = 0
  for k, v in pairs(versionInfo) do
    if not v.hideInList then
      maxIndex = maxIndex + 1
      if v.status == 3 then
        curFinishCount = curFinishCount + 1
      end
    end
  end
  return curFinishCount, maxIndex
end

function QuestManualProxy:IsVersionInProcess(version)
  local versionInfo = self:GetStoryVersionInfo(version)
  if versionInfo then
    for index, indexData in pairs(versionInfo) do
      local status = indexData.status
      if status == 2 or status == 3 then
        return true
      end
    end
  end
  return false
end

function QuestManualProxy:GetStoryConfigByVersion(version)
  if self.mainStoryMap[version] then
    return self.mainStoryMap[version]
  end
end

function QuestManualProxy:GetStoryConfigByIndex(version, index)
  if self.mainStoryMap[version] and self.mainStoryMap[version].indexList[index] then
    return self.mainStoryMap[version].indexList[index]
  end
end

function QuestManualProxy:GetStoryConfig(version, index)
  if self.mainStoryMap[version] and self.mainStoryMap[version][index] then
    return self.mainStoryMap[version][index]
  end
end

PlotVoiceData = class("PlotVoiceData")

function PlotVoiceData:ctor(version, mapID, index)
  self.mapQuest = {}
  self.mapID = mapID
  self.version = version
  self.maplist = {}
  self:Update(version, mapID, index)
end

function PlotVoiceData:Update(version, mapID, index)
  local single = {}
  single.mapID = mapID
  single.version = version
  if not self.mapQuest[mapID] then
    self.mapQuest[mapID] = {}
    table.insert(self.maplist, single)
  end
  table.insert(self.mapQuest[mapID], index)
end

function PlotVoiceData:GetMapList()
  return self.maplist
end

function PlotVoiceData:GetMapQuestList(mapID)
  return self.mapQuest[mapID]
end

QuestManualItem = class("QuestManualItem")

function QuestManualItem:ctor(data, questNames)
  self:updata(data, questNames)
end

function QuestManualItem:updata(data, questNames)
  self.type = data.type
  if data.data then
    local questData = QuestData.new()
    questData:DoConstruct(false, QuestDataScopeType.QuestDataScopeType_CITY)
    questData:setQuestData(data.data)
    questData:setQuestListType(data.type)
    self.questData = questData
    local qdata = questNames and questNames[data.data.id]
    if qdata then
      self.questPreName = qdata:GetQuestName()
    end
  end
  local questSubs = data.subs
  if questSubs and 0 < #questSubs then
    helplog("questsubs's num", #questSubs)
    self.questSubs = {}
    for i = 1, #questSubs do
      self.questSubs[#self.questSubs + 1] = QuestManualItem.new(questSubs[i], questNames)
    end
  end
end

QuestPuzzle = class("QuestPuzzle")

function QuestPuzzle:ctor(data)
  self:updata(data)
end

function QuestPuzzle:updata(data)
  self.version = data.version
  self.open_puzzles = {}
  local openedPuzzles = data.open_puzzles
  if openedPuzzles and 0 < #openedPuzzles then
    for i = 1, #openedPuzzles do
      self.open_puzzles[#self.open_puzzles + 1] = openedPuzzles[i]
    end
  end
  self.unlock_puzzles = {}
  local unlockPuzzles = data.unlock_puzzles
  if unlockPuzzles and 0 < #unlockPuzzles then
    for i = 1, #unlockPuzzles do
      self.unlock_puzzles[#self.unlock_puzzles + 1] = unlockPuzzles[i]
    end
  end
end

BranchQuestManualItem = class("BranchQuestManualItem")

function BranchQuestManualItem:ctor(data, prequest)
  self:updata(data, prequest)
end

function BranchQuestManualItem:updata(data, prequest)
  self.itemid = data.itemid
  local questList = data.quests
  if questList and 0 < #questList then
    self.questList = {}
    for i = 1, #questList do
      self.questList[#self.questList + 1] = QuestManualItem.new(questList[i], prequest)
    end
  end
end

QuestPreviewItem = class("QuestPreviewItem")

function QuestPreviewItem:ctor(data)
  self:updata(data)
end

function QuestPreviewItem:updata(data)
  self.questid = data.questid
  self.name = data.name
  self.complete = data.complete
  self.RewardGroup = data.RewardGroup
  local rewardIds = data.allrewardid
  self.allrewardid = {}
  if rewardIds and 0 < #rewardIds then
    for i = 1, #rewardIds do
      self.allrewardid[#self.allrewardid + 1] = rewardIds[i]
    end
  end
  self.index = data.index or 0
end

QuestPConfigItem = class("QuestPConfigItem")

function QuestPConfigItem:ctor(data)
  self:updata(data)
end

function QuestPConfigItem:updata(data)
  self.questType = data.status
  local config = data.config
  self.questid = config.QuestID * 10000 + config.GroupID
  local questData = QuestData.new()
  questData:DoConstruct(false, QuestDataScopeType.QuestDataScopeType_CITY)
  local stepData = {config = config}
  questData:updateByIdAndStep(self.questid, nil, stepData)
  self.questData = questData
  self.questName = config.Name
  self.level = config.Level
  self.traceInfo = config.TraceInfo
  self.preQuest = {}
  self.mustPreQuest = {}
  self.preMenu = {}
  self.mustPreMenu = {}
  TableUtility.ArrayShallowCopy(self.preQuest, config and config.PreQuest or {})
  TableUtility.ArrayShallowCopy(self.mustPreQuest, config and config.MustPreQuest or {})
  TableUtility.ArrayShallowCopy(self.preMenu, config and config.PreMenu or {})
  TableUtility.ArrayShallowCopy(self.mustPreMenu, config and config.MustPreMenu or {})
end

function QuestPConfigItem:parseTranceInfo()
  if not BranchMgr.IsChina() then
    self.traceInfo = OverSea.LangManager.Instance():GetLangByKey(self.traceInfo)
  end
  local tableValue = QuestDataUtil.getTranceInfoTable(self, self.params, nil)
  if tableValue == nil then
    return "parse table text is nil:" .. self.traceInfo
  end
  local result = self.traceInfo and string.gsub(self.traceInfo, "%[(%w+)]", tableValue) or ""
  local guildnum = TeamProxy.Instance:GetGuildNumInTeam()
  result = string.gsub(result, "%[guildnum]", guildnum)
  local index = 1
  result = string.gsub(result, "%[(%w+)]", function(str)
    local value = self.names and self.names[index]
    index = index + 1
    return value
  end)
  if self.type == QuestDataType.QuestDataType_GUILDQUEST and self.time then
    local deltaTime = self.time - ServerTime.CurServerTime() / 1000
    if 0 <= deltaTime and deltaTime <= 3600 then
      result = string.format(ZhString.TaskQuestCell_GuildTimeOut, result, math.floor(deltaTime / 60))
    end
  end
  if QuestProxy.Instance:isCountDownQuest(self) then
    local deltaTime = self.staticData.EndTime - ServerTime.CurServerTime() / 1000
    if 0 <= deltaTime and deltaTime <= 3600 then
      result = string.format(ZhString.TaskQuestCell_GuildTimeOut, result, math.floor(deltaTime / 60))
    end
  end
  return result
end
