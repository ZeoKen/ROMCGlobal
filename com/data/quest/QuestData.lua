QuestData = reusableClass("QuestData")
autoImport("QuestStep")
autoImport("QuestReward")
autoImport("QuestDataUtil")
local Table_FinishTraceInfo = Table_FinishTraceInfo
local ArrayClear = TableUtility.ArrayClear
autoImport("QuestTypeConfig")
QuestDataScopeType = {
  QuestDataScopeType_FUBEN = "fubenScope",
  QuestDataScopeType_CITY = "cityScope",
  QuestDataScopeType_DAHUANG = "dahuangScope"
}
QuestDataGuideType = {
  QuestDataGuideType_explain = 1,
  QuestDataGuideType_force = 2,
  QuestDataGuideType_unforce = 3,
  QuestDataGuideType_showDialog = 4,
  QuestDataGuideType_showDialog_Repeat = 5,
  QuestDataGuideType_showDialog_Anim = 6,
  QuestDataGuideType_force_with_arrow = 7,
  QuestDataGuideType_slide = 8
}
QuestData.AutoExecuteQuestAtInit = {
  QuestDataStepType.QuestDataStepType_CLIENT_PLOT,
  QuestDataStepType.QuestDataStepType_TALK,
  QuestDataStepType.QuestDataStepType_GUIDE,
  QuestDataStepType.QuestDataStepType_RAID,
  QuestDataStepType.QuestDataStepType_GUIDELOCKMONSTER,
  QuestDataStepType.QuestDataStepType_ILLUSTRATION,
  QuestDataStepType.QuestDataStepType_PLAY_CG,
  QuestDataStepType.QuestDataStepType_MEDIA,
  QuestDataStepType.QuestDataStepType_GUIDECHECK,
  QuestDataStepType.QuestDataStepType_WAITCLIENT,
  QuestDataStepType.QuestDataStepType_PARTNERMOVE,
  QuestDataStepType.QuestDataStepType_MUSICGAME,
  QuestDataStepType.QuestDataStepType_SHOWEVIDENCE,
  QuestDataStepType.QuestDataStepType_JOINT_REASON,
  QuestDataStepType.QuestDataStepType_EXCHANGE,
  "choose_branch",
  "game",
  QuestDataStepType.QuestDataStepType_TAPPING,
  "follow_npc",
  "cutscene",
  "checkmenu",
  "postcard",
  "remove_local_ai",
  "remove_local_interact",
  "waitui",
  "battlefield_area",
  "abyss_dragon"
}
QuestData.AutoTriggerQuest = {
  QuestDataStepType.QuestDataStepType_SELFIE,
  QuestDataStepType.QuestDataStepType_USE,
  QuestDataStepType.QuestDataStepType_PURIFY,
  QuestDataStepType.QuestDataStepType_MOVE,
  QuestDataStepType.QuestDataStepType_TALK,
  QuestDataStepType.QuestDataStepType_RAID,
  QuestDataStepType.QuestDataStepType_GUIDELOCKMONSTER,
  "steptrigger",
  QuestDataStepType.QuestDataStepType_SHARE,
  QuestDataStepType.QuestDataStepType_SHOT,
  QuestDataStepType.QuestDataStepType_GUIDE,
  QuestDataStepType.QuestDataStepType_PLAY_CAMERAPLOT,
  QuestDataStepType.QuestDataStepType_SHOWEVIDENCE,
  QuestDataStepType.QuestDataStepType_QWS_Shoot,
  QuestDataStepType.QuestDataStepType_JOINT_REASON,
  QuestDataStepType.QuestDataStepType_PICKING_SORT,
  "checkmenu",
  "area",
  "add_local_interact",
  "interact_local_ai",
  "interact_local_visit",
  "open_cannon",
  "effect"
}
QuestData.NoTraceQuestDataType = {
  QuestDataType.QuestDataType_TALK,
  QuestDataType.QuestDataType_MANUAL
}
QuestData.NoDirAndDisStepType = {
  QuestDataStepType.QuestDataStepType_CAMERA,
  QuestDataStepType.QuestDataStepType_LEVEL,
  QuestDataStepType.QuestDataStepType_INVADE,
  QuestDataStepType.QuestDataStepType_WAIT,
  QuestDataStepType.QuestDataStepType_PURIFY,
  QuestDataStepType.QuestDataStepType_REWARD,
  QuestDataStepType.QuestDataStepType_GUIDE,
  QuestDataStepType.QuestDataStepType_MEDIA,
  QuestDataStepType.QuestDataStepType_ILLUSTRATION,
  QuestDataStepType.QuestDataStepType_MULTIGM,
  QuestDataStepType.QuestDataStepType_CALL
}
QuestData.EffectTriggerStepType = {
  QuestDataStepType.QuestDataStepType_MOVE,
  QuestDataStepType.QuestDataStepType_USE,
  QuestDataStepType.QuestDataStepType_SELFIE,
  QuestDataStepType.QuestDataStepType_TALK
}
QuestData.CanExecuteWhenDeadStepType = {
  QuestDataStepType.QuestDataStepType_NEWCHAPTER,
  QuestDataStepType.QuestDataStepType_GUIDE,
  "puzzle",
  "puzzle_refresh",
  "puzzle_light",
  "puzzle_npc_sync_move"
}
QuestData.ShowTargetNamePrefixStepType = {
  QuestDataStepType.QuestDataStepType_KILL,
  QuestDataStepType.QuestDataStepType_GATHER,
  QuestDataStepType.QuestDataStepType_COLLECT
}
QuestData.ItemUpdateStepType = {
  QuestDataStepType.QuestDataStepType_ITEM,
  QuestDataStepType.QuestDataStepType_MONEY
}
QuestData.AutoExecuteQuest = {
  QuestDataStepType.QuestDataStepType_ITEM,
  QuestDataStepType.QuestDataStepType_TALK,
  QuestDataStepType.QuestDataStepType_KILL,
  QuestDataStepType.QuestDataStepType_GATHER,
  QuestDataStepType.QuestDataStepType_COLLECT,
  QuestDataStepType.QuestDataStepType_MONEY,
  QuestDataStepType.QuestDataStepType_MOVE,
  QuestDataStepType.QuestDataStepType_USE,
  QuestDataStepType.QuestDataStepType_SELFIE,
  QuestDataStepType.QuestDataStepType_VISIT,
  QuestDataStepType.QuestDataStepType_GUIDELOCKMONSTER,
  QuestDataStepType.QuestDataStepType_PLAY_CG,
  QuestDataStepType.QuestDataStepType_PLAY_CAMERAPLOT,
  QuestDataStepType.QuestDataStepType_DAILY,
  QuestDataStepType.QuestDataStepType_SEAL,
  QuestDataStepType.QuestDataStepType_NEWCHAPTER
}
QuestData.QuestDataTypeSortWeight = {
  [QuestDataType.QuestDataType_ACC_MAIN] = 90,
  [QuestDataType.QuestDataType_ACC_BRANCH] = 80,
  [QuestDataType.QuestDataType_MAIN] = 60,
  [QuestDataType.QuestDataType_WANTED] = 50,
  [QuestDataType.QuestDataType_SEALTR] = 40,
  [QuestDataType.QuestDataType_DAILY] = 30,
  [QuestDataType.QuestDataType_ELITE] = 20,
  [QuestDataType.QuestDataType_BRANCH] = 10
}
QuestData.NewQuestNoticeIgnore = {
  QuestDataStepType.QuestDataStepType_RAID,
  QuestDataStepType.QuestDataStepType_TALK
}

function QuestData:DoConstruct(asArray, scope)
  self.scope = scope
  self.process = 0
  self.steps = ReusableTable.CreateArray()
  self.names = ReusableTable.CreateArray()
  self.serverParams = ReusableTable.CreateArray()
  self.allrewardid = ReusableTable.CreateTable()
  self.preQuest = ReusableTable.CreateArray()
  self.mustPreQuest = ReusableTable.CreateArray()
  self.preMenu = ReusableTable.CreateArray()
  self.mustPreMenu = ReusableTable.CreateArray()
  self.staticData = nil
  self.pos = nil
  self.isMapStep = nil
end

function QuestData:Deconstruct()
  self._alive = false
  self.nInvadeStyle = nil
  self.finishData = nil
  self.type = nil
  self.questDataStepType = nil
  self.scope = nil
  self.process = 0
  self.pos = VectorUtility.Destroy(self.pos)
  self:DestroyRewards()
  self:DestroySteps()
  self:DestroyNames()
  self:DestroyServerParams()
  self:DestroyAllRewards()
  self:DestroyPreRewards()
  self:DestroyMustRewards()
end

function QuestData:ClearRewards()
  for i = #self.rewards, 1, -1 do
    ReusableTable.DestroyAndClearTable(self.rewards[i])
    self.rewards[i] = nil
  end
end

function QuestData:ClearSteps()
  for i = #self.steps, 1, -1 do
    local stepData = self.steps[i]
    local staticData = stepData.staticData
    ReusableTable.DestroyAndClearTable(staticData)
    stepData.staticData = nil
    ReusableTable.DestroyAndClearTable(stepData)
    self.steps[i] = nil
  end
  self.staticData = nil
end

function QuestData:DestroyRewards()
  if self.rewards then
    self:ClearRewards()
    ReusableTable.DestroyAndClearArray(self.rewards)
    self.rewards = nil
  end
end

function QuestData:DestroyPreRewards()
  if self.preQuest then
    ReusableTable.DestroyAndClearArray(self.preQuest)
    self.preQuest = nil
  end
end

function QuestData:DestroyMustRewards()
  if self.mustPreQuest then
    ReusableTable.DestroyAndClearArray(self.mustPreQuest)
    self.mustPreQuest = nil
  end
end

function QuestData:DestroySteps()
  if self.steps then
    self:ClearSteps()
    ReusableTable.DestroyAndClearArray(self.steps)
    self.steps = nil
  end
end

function QuestData:DestroyNames()
  if self.names then
    ReusableTable.DestroyAndClearArray(self.names)
    self.names = nil
  end
end

function QuestData:DestroyServerParams()
  if self.serverParams then
    ReusableTable.DestroyAndClearArray(self.serverParams)
    self.serverParams = nil
  end
end

function QuestData:DestroyAllRewards()
  if self.allrewardid then
    ReusableTable.DestroyAndClearTable(self.allrewardid)
    self.allrewardid = nil
  end
end

function QuestData:setQuestData(questData)
  self:update(questData)
end

function QuestData:update(questData)
  self.time = questData.time
  self.complete = questData.complete
  self.trace = questData.trace
  self.detailid = questData.detailid
  self.acceptlv = questData.acceptlv
  self.finishcount = questData.finishcount
  self.accepttime = questData.accepttime
  self.version = questData.version
  self.done = questData.done or false
  self.predone = questData.predone
  self.tracestatus = questData.trace_status
  self.newstatus = questData.new_status
  if self.steps then
    self:ClearSteps()
  end
  local steps = questData.steps
  if steps and 0 < #steps then
    for i = 1, #steps do
      local stepData = self:parseStaticDataByStepData(steps[i])
      self.steps[#self.steps + 1] = stepData
    end
  end
  local rewards = questData.rewards
  if rewards and 0 < #rewards then
    if self.rewards then
      self:ClearRewards()
    else
      self.rewards = ReusableTable.CreateArray()
    end
    for i = 1, #rewards do
      local single = rewards[i]
      local reward = ReusableTable.CreateTable()
      reward.id = single.id
      reward.count = single.count
      self.rewards[#self.rewards + 1] = reward
    end
  else
    self:DestroyRewards()
  end
  local stepData = steps and steps[1] or nil
  self:updateByIdAndStep(questData.id, questData.step, stepData)
end

function QuestData:updateProcess()
  if self.steps then
    local stepData = self.steps[1]
    if stepData then
      self.process = stepData.process
    end
  end
end

function QuestData:setIfShowAppearAnm(bArg)
  self.ifShowAppearAnm = bArg
end

function QuestData:getIfShowAppearAnm()
  return self.ifShowAppearAnm
end

function QuestData:updateRaidData(id, RaidServerData, uniqueid)
  self.id = id
  local stepData = self:parseRaidStaticDataByStepData(RaidServerData)
  stepData.staticData.uniqueid = uniqueid
  self.staticData = stepData.staticData
  self.finishData = Table_FinishTraceInfo[id]
  if self.finishData then
    self.nInvadeStyle = QuestProxy.Instance:GetNInvadeTraceStyle(self.finishData.QuestKey)
  else
    self.nInvadeStyle = nil
  end
  if self.staticData == nil then
    helplog("error table_raid id:", id)
    return
  end
  if self.staticData ~= nil then
    self.params = self.staticData.Params
  end
  if self.params ~= nil then
    local vect = self.params.pos
    if vect ~= nil then
      if vect[1] and vect[2] and vect[3] then
        if not self.pos then
          self.pos = LuaVector3.Zero()
        end
        LuaVector3.Better_Set(self.pos, vect[1], vect[2], vect[3])
      else
        self.pos = VectorUtility.Destroy(self.pos)
        printRed("questData pox x or y or z is nil")
      end
    else
      self.pos = VectorUtility.Destroy(self.pos)
    end
    if self.params.cutscene_id and self.params.cutscene_id ~= 0 then
      self.staticData.Auto = 1
      if self.params.noskip and self.params.noskip < 1000 then
        local cond1 = self.scope == QuestDataScopeType.QuestDataScopeType_FUBEN
        local cond21 = TeamProxy.Instance:CheckIHaveLeaderAuthority()
        local cond22 = TeamProxy.Instance:IHaveTeam() and TeamProxy.Instance:IsSameMapWithNowLeader()
        if cond1 and (cond21 or cond22) then
          self.params.noskip = self.params.noskip + 1000
        end
      end
    end
  end
  if self.staticData.Map == 0 then
    self.staticData.Map = nil
  end
  self.map = self.staticData.Map
  self.questDataStepType = self.staticData.Content
  self.traceTitle = self.staticData.Name
  self.whetherTrace = self.staticData.WhetherTrace
  self.traceInfo = self.staticData.TraceInfo
  self.headicon = self.params.headicon
end

function QuestData:updateByIdAndStep(id, step, stepDataServer)
  self.id = id
  self.step = step
  local stepData = self:parseStaticDataByStepData(stepDataServer)
  self.finishData = Table_FinishTraceInfo[id]
  if self.finishData then
    self.nInvadeStyle = QuestProxy.Instance:GetNInvadeTraceStyle(self.finishData.QuestKey)
  else
    self.nInvadeStyle = nil
  end
  if not stepData or not stepData.staticData then
    return
  end
  local delData = self.steps[1]
  if delData then
    ReusableTable.DestroyAndClearTable(delData.staticData)
    delData.staticData = nil
    ReusableTable.DestroyAndClearTable(delData)
    self.steps[1] = nil
    self.staticData = nil
  end
  self.steps[1] = stepData
  if self.names then
    ArrayClear(self.names)
  end
  Game.transArray(stepDataServer.names)
  local names = stepDataServer.names
  if names and 0 < #names then
    for i = 1, #names do
      local single = names[i]
      self.names[#self.names + 1] = single
    end
  end
  if self.serverParams then
    ArrayClear(self.serverParams)
  end
  local params = stepDataServer.params
  if params and 0 < #params then
    for i = 1, #params do
      local single = params[i]
      self.serverParams[#self.serverParams + 1] = single
    end
  end
  if self.allrewardid then
    TableUtility.TableClear(self.allrewardid)
  end
  local allrewardid = stepDataServer.config.allreward
  if allrewardid and 0 < #allrewardid then
    for i = 1, #allrewardid do
      local single = allrewardid[i]
      self.allrewardid[single.questid] = {}
      local rewards = single.reward
      for j = 1, #rewards do
        TableUtility.ArrayPushBack(self.allrewardid[single.questid], rewards[j].origin_reward)
      end
    end
  end
  if self.preQuest then
    ArrayClear(self.preQuest)
  end
  local preQuests = stepDataServer.config.PreQuest
  if preQuests and 0 < #preQuests then
    for i = 1, #preQuests do
      local single = preQuests[i]
      self.preQuest[#self.preQuest + 1] = single
    end
  end
  if self.mustPreQuest then
    ArrayClear(self.mustPreQuest)
  end
  local mustPreQuests = stepDataServer.config.MustPreQuest
  if mustPreQuests and 0 < #mustPreQuests then
    for i = 1, #mustPreQuests do
      local single = mustPreQuests[i]
      self.mustPreQuest[#self.mustPreQuest + 1] = single
    end
  end
  if self.preMenu then
    ArrayClear(self.preMenu)
  end
  local preMenus = stepDataServer.config.PreMenu
  if preMenus and 0 < #preMenus then
    for i = 1, #preMenus do
      local single = preMenus[i]
      self.preMenu[#self.preMenu + 1] = single
    end
  end
  if self.mustPreMenu then
    ArrayClear(self.mustPreMenu)
  end
  local mustPreMenus = stepDataServer.config.MustPreMenu
  if mustPreMenus and 0 < #mustPreMenus then
    for i = 1, #mustPreMenus do
      local single = mustPreMenus[i]
      self.mustPreMenu[#self.mustPreMenu + 1] = single
    end
  end
  self.orderId = id
  if self.scope == QuestDataScopeType.QuestDataScopeType_FUBEN then
    return
  else
    self.staticData = stepData.staticData
    self.type = self.staticData.Type
    if self.type == QuestDataType.QuestDataType_WANTED then
      self.wantedData = Table_WantedQuest[id]
    else
      self.wantedData = nil
    end
  end
  self.params = self.staticData.Params
  if self.params ~= nil then
    local vect = self.params.pos
    if vect ~= nil then
      if vect[1] and vect[2] and vect[3] then
        if not self.pos then
          self.pos = LuaVector3.Zero()
        end
        LuaVector3.Better_Set(self.pos, vect[1], vect[2], vect[3])
      else
        self.pos = VectorUtility.Destroy(self.pos)
      end
    else
      self.pos = VectorUtility.Destroy(self.pos)
    end
  end
  if self.staticData.Map == 0 then
    self.staticData.Map = nil
  end
  self.map = self.staticData.Map
  self.questDataStepType = self.staticData.Content
  self.traceTitle = self.staticData.Name
  self.whetherTrace = self.staticData.WhetherTrace
  self.traceInfo = self.staticData.TraceInfo
  self:updateProcess()
  self:processParams()
end

local uint64_to_int64 = function(uint64)
  local int64_max = 9223372036854775807
  if uint64 > int64_max then
    return uint64 - 2 * int64_max - 2
  else
    return uint64
  end
end

function QuestData:processParams()
  if self.questDataStepType == QuestDataStepType.QuestDataStepType_TALK and self.staticData.Params.method == "1" and #self.serverParams > 0 and self.staticData.Params.dialog then
    TableUtility.ArrayClear(self.staticData.Params.dialog)
    for i = 2, #self.serverParams do
      local single = self.serverParams[i]
      self.staticData.Params.dialog[#self.staticData.Params.dialog + 1] = single
    end
  elseif self.questDataStepType == "add_local_interact" and #self.serverParams > 0 then
    for i = 1, #self.serverParams do
      local value = self.serverParams[i]
      local m = math.ceil(i / 3)
      local n = (i - 1) % 3 + 1
      self.params.pos[m][n] = value / 1000
    end
  end
end

function QuestData:parseRaidStaticDataByStepData(RaidPConfig)
  if not RaidPConfig then
    return
  end
  local staticData = ReusableTable.CreateTable()
  staticData.RaidID = RaidPConfig.RaidID
  staticData.starID = RaidPConfig.starID
  staticData.Auto = RaidPConfig.Auto
  staticData.Name = RaidPConfig.Name
  staticData.DescInfo = RaidPConfig.DescInfo
  staticData.Content = RaidPConfig.Content
  staticData.TraceInfo = RaidPConfig.TraceInfo
  staticData.WhetherTrace = RaidPConfig.WhetherTrace
  staticData.FinishJump = RaidPConfig.FinishJump
  staticData.FailJump = RaidPConfig.FailJump
  staticData.Params = QuestDataUtil.parseParams(RaidPConfig.params.params, staticData.Content)
  local stepData = ReusableTable.CreateTable()
  stepData.staticData = staticData
  stepData.process = stepData.process or 0
  stepData.EndTime = stepData.EndTime or 0
  return stepData
end

function QuestData:parseStaticDataByStepData(stepDataServer)
  if not stepDataServer then
    return
  end
  local config = stepDataServer.config
  local staticData = ReusableTable.CreateTable()
  staticData.RewardGroup = config.RewardGroup
  staticData.SubGroup = config.SubGroup
  staticData.FinishJump = config.FinishJump
  staticData.FailJump = config.FailJump
  staticData.Map = config.Map
  staticData.WhetherTrace = config.WhetherTrace
  staticData.Auto = config.Auto
  staticData.FirstClass = config.FirstClass
  staticData.Class = config.Class
  staticData.Type = config.Type
  staticData.QuestName = config.QuestName
  staticData.Name = config.Name
  staticData.Content = config.Content
  staticData.TraceInfo = config.TraceInfo
  staticData.Level = config.Level
  staticData.Prefixion = config.Prefixion
  staticData.PreNoShow = config.PreNoShow
  staticData.Risklevel = config.Risklevel
  staticData.Joblevel = config.Joblevel
  staticData.CookerLv = config.CookerLv
  staticData.TasterLv = config.TasterLv
  staticData.EndTime = config.EndTime or 0
  staticData.CreateTime = config.CreateTime
  staticData.IconFromServer = config.Icon
  staticData.ColorFromServer = config.Color
  staticData.headIcon = config.Headicon or 0
  staticData.Version = config.version
  if staticData.Type ~= QuestDataType.QuestDataType_Raid_Talk and (staticData.Content == QuestDataStepType.QuestDataStepType_RAID or staticData.Content == QuestDataStepType.QuestDataStepType_TALK or staticData.Content == QuestDataStepType.QuestDataStepType_PLAY_CAMERAPLOT) and staticData.Map ~= 0 and staticData.TraceInfo == "" then
    local mapRaidConfig = Table_MapRaid[staticData.Map]
    if not mapRaidConfig or mapRaidConfig.Type ~= 6 then
      local mapData = Table_Map[staticData.Map]
      local str = string.format(ZhString.TaskQuestCell_TraceGuide, mapData.CallZh)
      staticData.TraceInfo = str
    end
  end
  staticData.hide = config.Hide
  staticData.Params = QuestDataUtil.parseParams(config.params.params, staticData.Content)
  local stepactions = config.stepactions
  if stepactions and 0 < #stepactions then
    local actions = {}
    for i = 1, #stepactions do
      local stepAction = stepactions[i]
      local actionParams = QuestDataUtil.parseActionParams(stepAction.params)
      table.insert(actions, actionParams)
    end
    staticData.stepactions = actions
  end
  local stepData = ReusableTable.CreateTable()
  stepData.staticData = staticData
  stepData.process = stepDataServer.process
  if staticData.Content == QuestDataStepType.QuestDataStepType_SHARE and stepDataServer.params and 0 < #stepDataServer.params then
    stepData.shareTips = {}
    for _, param in ipairs(stepDataServer.params) do
      stepData.shareTips[#stepData.shareTips + 1] = param
    end
  end
  return stepData
end

function QuestData:setQuestListType(questListType)
  self.questListType = questListType
end

function QuestData:cloneSelf()
  local data = QuestData.new()
  data.scope = self.scope
  data.questListType = self.questListType
  data.questDataStepType = self.questDataStepType
  data.traceTitle = self.traceTitle
  data.whetherTrace = self.whetherTrace
  data.traceInfo = self.traceInfo
  data.pos = self.pos and LuaVector3.Better_Clone(self.pos) or nil
  data.map = self.map
  data.type = self.type
  data.orderId = self.orderId
  data.params = self.params
  data.id = self.id
  data.names = self.names
  data.step = self.step
  data.ifShowAppearAnm = self.ifShowAppearAnm
  data.time = self.time
  data.complete = self.complete
  data.trace = self.trace
  data.detailid = self.detailid
  data.rewards = self.rewards
  data.steps = self.steps
  data.acceptlv = self.acceptlv
  data.finishcount = self.finishcount
  data.scope = self.scope
  data.process = self.process
  data.version = self.version
  data.staticData = self.staticData
  data.accepttime = self.accepttime
  return data
end

function QuestData:getQuestListType()
  return self.questListType
end

function QuestData:checkWantedQuestStep()
  if self.type == QuestDataType.QuestDataType_WANTED then
    local params = self.params and self.params or {}
    local isComplete = params.mark_team_wanted == 1
    if isComplete then
      return true
    end
  end
end

function QuestData:parseTranceInfo(step)
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

local tRet = {}

function QuestData:getProcessInfo()
  TableUtility.TableClear(tRet)
  local questType = self.questDataStepType
  if questType == QuestDataStepType.QuestDataStepType_KILL then
    local process = self.process
    local id = self.params.monster
    local groupId = self.params.groupId
    local totalNum = self.params.num
    local infoTable = Table_Monster[id]
    if infoTable == nil then
      infoTable = Table_Npc[id]
    end
    tRet.process = process
    tRet.totalNum = totalNum
    if infoTable ~= nil then
      tRet.name = infoTable.NameZh and OverSea.LangManager.Instance():GetLangByKey(infoTable.NameZh)
    end
    return tRet
  elseif questType == QuestDataStepType.QuestDataStepType_COLLECT then
    local id = self.params.monster
    local process = self.process
    local totalNum = self.params.num
    local infoTable = Table_Monster[id]
    if infoTable == nil then
      infoTable = Table_Npc[id]
    end
    tRet.process = process
    tRet.totalNum = totalNum
    if infoTable ~= nil then
      tRet.name = infoTable.NameZh and OverSea.LangManager.Instance():GetLangByKey(infoTable.NameZh)
    end
    return tRet
  elseif questType == QuestDataStepType.QuestDataStepType_GATHER then
    local process = self.process
    local rewards = ItemUtil.GetRewardItemIdsByTeamId(self.params.reward)
    if not rewards or not rewards[1] then
      errorLog("questId:" .. self.id .. "rewardId:" .. (self.params.reward or 0) .. " 该奖励任务不存在此奖励")
      return nil
    end
    local itemId = rewards[1].id
    local totalNum = self.params.num
    local infoTable = Table_Item[tonumber(itemId)]
    tRet.process = process
    tRet.totalNum = totalNum
    if infoTable ~= nil then
      tRet.name = infoTable.NameZh
    end
    return tRet
  elseif questType == QuestDataStepType.QuestDataStepType_ITEM then
    local item = self.params.item and self.params.item[1]
    local itemId = item and item.id or 0
    local totalNum = item and item.num or 0
    local process = BagProxy.Instance:GetItemNumByStaticID(itemId) or 0
    local infoTable = Table_Item[tonumber(itemId)]
    tRet.process = process
    tRet.totalNum = totalNum
    if infoTable ~= nil then
      tRet.name = infoTable.NameZh
    end
    return tRet
  end
end

function QuestData:IsPrequest(prequestid)
  if self.preQuest then
    for i = 1, #self.preQuest do
      if self.preQuest[i] == prequestid then
        return true
      end
    end
  end
  return false
end

function QuestData:checkMustPrequest(mustprequestid)
  if self.mustPreQuest then
    for i = 1, #self.mustPreQuest do
      if self.mustPreQuest[i] == mustprequestid then
        return true
      end
    end
  end
  return false
end

function QuestData:IsHideInList()
  if self.staticData ~= nil then
    local showSymbol = self.staticData.Params.ShowSymbol
    if showSymbol and showSymbol == 3 then
      return true
    end
    return false
  end
  return false
end

function QuestData:GetMapRaid()
  return self.params.id
end

function QuestData:updateDahuangData(questData)
  self.id = questData.id
  local stepData = self:parseDahuangStaticDataByStepData(questData)
  self.staticData = stepData.staticData
  if self.staticData == nil then
    helplog("error table_mapQuest id:", id)
    return
  end
  if self.staticData ~= nil then
    self.params = self.staticData.Params
  end
  if self.params ~= nil then
    local vect = self.params.pos
    if vect ~= nil then
      if vect[1] and vect[2] and vect[3] then
        if not self.pos then
          self.pos = LuaVector3.Zero()
        end
        LuaVector3.Better_Set(self.pos, vect[1], vect[2], vect[3])
      else
        self.pos = VectorUtility.Destroy(self.pos)
        printRed("questData pox x or y or z is nil")
      end
    else
      self.pos = VectorUtility.Destroy(self.pos)
    end
  end
  self.traceTitle = self.params.TraceTitle
  self.traceInfo = self.params.TraceInfo or ""
  self.map = self.staticData.Map
  self.questDataStepType = self.staticData.Content
  self.type = QuestDataType.QuestDataType_DAHUANG
  self.orderId = questData.id
  self.whetherTrace = self.params.WhetherTrace or 1
end

function QuestData:parseDahuangStaticDataByStepData(questConfig)
  if not questConfig then
    return
  end
  local staticData = ReusableTable.CreateTable()
  staticData.Auto = questConfig.Auto or 0
  staticData.Content = questConfig.Content
  staticData.Params = questConfig.Params
  staticData.StartCondition = questConfig.StartCondition
  local stepData = ReusableTable.CreateTable()
  stepData.staticData = staticData
  stepData.process = stepData.process or 0
  stepData.EndTime = stepData.EndTime or 0
  return stepData
end

function QuestData:getCurrentStepData()
  return self:getStepDataByStep(self.step)
end

function QuestData:getStepDataByStep(step)
  if not self.steps or #self.steps == 0 then
    return
  end
  return self.steps[1]
end

function QuestData:setQuestDoneStatus()
  self.done = true
end

function QuestData:SetNewTag(bool)
  self.isNew = bool
end

function QuestData:SetQuestTraceStatus(status)
  self.tracestatus = status
end

function QuestData:SetQuestNewStatus(status)
  self.newstatus = status
end
