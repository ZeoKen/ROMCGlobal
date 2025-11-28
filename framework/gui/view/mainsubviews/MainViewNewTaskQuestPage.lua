autoImport("DeathPopView")
autoImport("SingleQuestCell")
autoImport("TaskQuestCell")
MainViewNewTaskQuestPage = class("MainViewNewTaskQuestPage", SubView)
local showInterval = 5

function MainViewNewTaskQuestPage:Init()
  self.traceNewVer = false
  self:InitView()
  self:AddViewEvts()
  self:AddMapEvts()
  self:InitData()
end

function MainViewNewTaskQuestPage:InitView()
  self.gameObject = self:FindGO("TaskQuestBord")
  self.seperateTraceBord = self:FindGO("SeperateTraceBord")
  self.singleTraceQuestGO = self:FindGO("SingleTraceQuest")
  self.singleTraceQuest = SingleQuestCell.new(self.singleTraceQuestGO)
  self.singleTraceQuest_TweenAlpha = self.singleTraceQuestGO:GetComponent(TweenAlpha)
  self.singleTraceQuest_TweenPos = self.singleTraceQuestGO:GetComponent(TweenPosition)
  self.singleTraceQuest:AddEventListener(QuestEvent.QuestTraceShowList, self.openMultiQuestList, self)
  self.multiTraceQuest = self:FindGO("MultiTraceQuest")
  self.multiTraceQuest_TweenPos = self.multiTraceQuest:GetComponent(TweenPosition)
  self.multiTraceQuest_TweenAlpha = self.multiTraceQuest:GetComponent(TweenAlpha)
  self.scrollview = self:FindGO("taskQuestScrollView", self.multiTraceQuest):GetComponent(UIScrollView)
  
  function self.scrollview.onDragStarted()
    self.closeTickTime = ServerTime.CurServerTime() / 1000 + showInterval
  end
  
  self.noneMultiQuestTip = self:FindGO("NoneMultiQuestList")
  self.noneMultiQuestTipLabel = self:FindGO("NoneMultiQuestListLabel"):GetComponent(UILabel)
  self.taskBord = self:FindChild("taskBord", self.multiTraceQuest)
  self.taskQuestTable = self.taskBord:GetComponent(UITable)
  self.questList = UIGridListCtrl.new(self.taskQuestTable, TaskQuestCell, "TaskQuestCell")
  self.questList:AddEventListener(MouseEvent.MouseClick, self.questCellClick, self)
  local objLua = self.gameObject:GetComponent(GameObjectForLua)
  
  function objLua.onEnable()
    self:SetQuestData()
  end
  
  self.taskQuestBG = self:FindGO("bgShadow")
  self.taskQuestBG_TweenPos = self.taskQuestBG:GetComponent(TweenPosition)
  self.taskQuestBG_TweenScale = self.taskQuestBG:GetComponent(TweenScale)
  self.commonQuestBtn = self:FindGO("CommonQuestBtn")
  self.commonQuestBtn_Icon = self:FindGO("icon", self.commonQuestBtn):GetComponent(UISprite)
  self.commonQuestBtn_Bg = self:FindGO("bg", self.commonQuestBtn):GetComponent(UISprite)
  self.commonQuestBtn_Bg.CurrentState = 1
  self.specialQuestBtn = self:FindGO("SpecialQuestBtn")
  self.specialQuestBtn_Icon = self:FindGO("icon", self.specialQuestBtn):GetComponent(UISprite)
  self.specialQuestBtn_Bg = self:FindGO("bg", self.specialQuestBtn):GetComponent(UISprite)
  self.specialQuestBtn_Bg.CurrentState = 0
  self.newQuestTag = self:FindGO("NewQuest", self.specialQuestBtn)
  self.newQuestTag:SetActive(false)
  self.showDetailBtn = self:FindGO("ShowDetailBtn")
  self.newQuestNotice = self:FindGO("NewQuestNotice")
  self.noticeLabel = self:FindGO("NoticeLabel"):GetComponent(UILabel)
  self.notice_TweenPos = self.newQuestNotice:GetComponent(TweenPosition)
  self.addPointNotice = self:FindGO("AddPointNotice", self.gameObject)
  self.AddPointLabel = self:FindGO("AddPointLabel", self.addPointNotice):GetComponent(UILabel)
  self.pointNotice_Tween = self.addPointNotice:GetComponent(TweenPosition)
  self:AddClickEvent(self.addPointNotice, function()
    if self.lvType == SceneUserEvent.BaseLevelUp then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.Charactor,
        viewdata = {tab = 1}
      })
    elseif self.lvType == SceneUserEvent.JobLevelUp then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.SkillView
      })
    end
  end)
  self.closeNotice = self:FindGO("CloseNotice", self.addPointNotice)
  self:AddClickEvent(self.closeNotice, function()
    self:HideNotice()
  end)
end

function MainViewNewTaskQuestPage:AddViewEvts()
  self:AddClickEvent(self.commonQuestBtn, function()
    self:clickQuestSortBtn(1)
  end)
  self:AddClickEvent(self.specialQuestBtn, function()
    self.initNewTag = true
    self.newQuestTag:SetActive(false)
    self:clickQuestSortBtn(2)
  end)
  self:AddClickEvent(self.showDetailBtn, function()
    self:closeMultiQuestList()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.QuestTracePanel
    })
  end)
  self:AddClickEvent(self.newQuestNotice, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.QuestTracePanel
    })
  end)
end

function MainViewNewTaskQuestPage:AddMapEvts()
  self:AddListenEvt(ServiceEvent.QuestQuestUpdate, self.QuestQuestUpdate)
  self:AddListenEvt(ServiceEvent.QuestQuestList, self.QuestQuestList)
  self:AddListenEvt(ServiceEvent.QuestQuestStepUpdate, self.QuestQuestStepUpdate)
  self:AddListenEvt(QuestEvent.QuestDelete, self.questDelete)
  self:AddListenEvt(QuestEvent.QuestAdd, self.questAdd)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.ItemUpdate)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.ItemUpdate)
  self:AddListenEvt(QuestEvent.ProcessChange, self.ProcessChange)
  self:AddListenEvt(QuestEvent.QuestTraceSwitch, self.questTraceSwitch)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.handlePlayerMapChange)
  EventManager.Me():AddEventListener(QuestManualEvent.BeforeGoClick, self.taskBookQuestTrace, self)
  EventManager.Me():AddEventListener(ServantImproveEvent.BeforeGoClick, self.servantQuestTrace, self)
  EventManager.Me():AddEventListener(ServantImproveEvent.GotomodeTrace, self.servantQuestTrace, self)
  EventManager.Me():AddEventListener(MyselfEvent.MissionCommandChanged, self.handleMissionCommand, self)
  self:AddListenEvt(MyselfEvent.LevelUp, self.NewPointNotice, self)
end

function MainViewNewTaskQuestPage:InitData()
  self.closeTickTime = ServerTime.CurServerTime() / 1000
  self.onGoingQuestId = nil
  self.curSort = 1
  self.initNewTag = false
end

function MainViewNewTaskQuestPage:SetQuestData()
  if self.singleTraceQuest and self.singleTraceQuest.data ~= nil then
    local questId = self.singleTraceQuest.data.id
    local lockTrace = self.singleTraceQuest.lockTrace
    if lockTrace then
      self:ShowDirAndDis()
      return
    end
    local data = QuestProxy.Instance:getQuestDataByIdAndType(questId)
    if data then
      self.singleTraceQuest:SetData(data)
      self:ShowDirAndDis()
    else
      self.singleTraceQuest:SetNoneStatus()
    end
  else
    self.singleTraceQuest:SetNoneStatus()
  end
end

function MainViewNewTaskQuestPage:adjustScrollView()
  local panel = self.scrollview.panel
  local cellCtrl = self:getTraceCellByQuestId(self.onGoingQuestId)
  if not cellCtrl or cellCtrl.indexInList == 1 then
    redlog("第一个 不滑")
    return
  end
  local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, cellCtrl.gameObject.transform)
  local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
  offset = Vector3(0, offset.y + 50, 0)
  self.scrollview:MoveRelative(offset)
  xdlog("滑动", offset.y)
  cellCtrl:setISShowDir(true)
end

function MainViewNewTaskQuestPage:updateTaskQuestBordStatus()
  if self.closeTickTime - ServerTime.CurServerTime() / 1000 < 0 then
    TimeTickManager.Me():ClearTick(self, 1)
    self.questList:RemoveAll()
    if self.singleTraceQuest.groupid then
      xdlog("关闭后  该任务有组合id")
      self.singleTraceQuest:SetData(self.singleTraceQuest.questData)
      self:closeMultiQuestList()
      return
    end
    local isShowDirAndDis = QuestProxy.Instance:checkIsShowDirAndDis(self.singleTraceQuest.data)
    xdlog("isShowDirAndDis", isShowDirAndDis)
    if isShowDirAndDis then
      if self.singleTraceQuest.data.id ~= self.onGoingQuestId then
        self:stopShowDirAndDis(self.onGoingQuestId)
      end
      self:closeMultiQuestList()
      local data = QuestProxy.Instance:getQuestDataByIdAndType(self.singleTraceQuest.data.id)
      if not data then
        redlog("no data")
      end
      self.singleTraceQuest:SetData(self.singleTraceQuest.data)
      self:ShowDirAndDis()
    else
      self:closeMultiQuestList()
      self.singleTraceQuest:SetNoneStatus()
    end
  end
end

function MainViewNewTaskQuestPage:RefreshQuestTraceMapLimit()
  if not self.mapLimitGroup then
    return
  end
  local questIns = QuestProxy.Instance
  local questId = self.singleTraceQuest.data and self.singleTraceQuest.data.id
  if questId then
    local questData = questIns:getQuestDataByIdAndType(questId)
    local isValid = questIns:isQuestMapHide(questData, self.mapLimitGroup)
    if not isValid then
      self:stopShowDirAndDis(self.onGoingQuestId)
      local list = questIns:getValidAcceptQuestList(true, self.mapLimitGroup)
      local single = list and list[1]
      self.singleTraceQuest:SetData(single)
      self:ShowDirAndDis()
    end
  end
end

function MainViewNewTaskQuestPage:QuestQuestUpdate(note)
  xdlog("QuestQuestUpdate")
  if self.singleTraceQuest and self.singleTraceQuest.data ~= nil then
    local questId = self.singleTraceQuest.data.id
    local data = QuestProxy.Instance:getQuestDataByIdAndType(questId)
    if data and data.trace then
      self:SetQuestData()
    else
      self.singleTraceQuest:SetNoneStatus()
    end
  else
    self.singleTraceQuest:SetNoneStatus()
  end
  QuestProxy.Instance:checkIfNeedRemoveGuideView()
end

function MainViewNewTaskQuestPage:QuestQuestList()
  local id = LocalSaveProxy.Instance:getLastTraceQuestId()
  local data = QuestProxy.Instance:getQuestDataByIdAndType(id)
  if data then
    self.singleTraceQuest:SetData(data)
    self:ShowDirAndDis()
  end
  QuestProxy.Instance:checkIfNeedRemoveGuideView()
end

function MainViewNewTaskQuestPage:QuestQuestStepUpdate(note)
  local data = note.body
  local questId = data.id
  local curTraceQuestID = self.singleTraceQuest and self.singleTraceQuest.data and self.singleTraceQuest.data.id
  if not curTraceQuestID then
    redlog("当前无任务 挂")
    local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
    self.singleTraceQuest:SetData(questData)
  elseif curTraceQuestID and curTraceQuestID == questId then
    local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
    self.singleTraceQuest:SetData(questData)
    self:ShowDirAndDis()
  end
  QuestProxy.Instance:checkIfNeedRemoveGuideView()
end

function MainViewNewTaskQuestPage:ItemUpdate()
  if self.singleTraceQuest and self.singleTraceQuest.data ~= nil then
    local data = self.singleTraceQuest.data
    if data and QuestProxy.Instance:checkUpdateWithItemUpdate(data) then
      self:SetQuestData()
    end
  end
end

function MainViewNewTaskQuestPage:ProcessChange(note)
  local data = note.body
  local questId = data.id
  if self.singleTraceQuest and self.singleTraceQuest.data ~= nil and questId == self.singleTraceQuest.data.id then
    self:SetQuestData()
  end
end

function MainViewNewTaskQuestPage:handlePlayerMapChange(note)
  MyselfProxy.Instance:SetQuestRepairMode(false)
  self:RefreshMapLimitQuest()
  self:RefreshQuestTraceMapLimit()
  local curRaidId = ServicePlayerProxy.Instance:GetCurMapImageId() or 0
  if 0 ~= curRaidId then
    local raidConfig = Table_MapRaid[curRaidId]
    local showTrace = raidConfig and raidConfig.Feature and 0 < raidConfig.Feature & FeatureDefines_MapRaid.DefineAsCommonMap or false
    if not showTrace then
      self.isInFuben = true
      self.seperateTraceBord:SetActive(false)
      return
    end
  end
  if note.type == LoadSceneEvent.StartLoad then
    self.isInFuben = false
    self.seperateTraceBord:SetActive(true)
    self:closeMultiQuestList()
    return
  end
  local data = note.body
  if data.dmapID == 0 then
    if not self.isInHand then
      self.seperateTraceBord:SetActive(true)
      self:closeMultiQuestList()
    end
    self.isInFuben = false
    self:sendNotification(UIEvent.CloseUI, DeathPopView.ViewType)
  else
    local raidConfig = Table_MapRaid[data.dmapID]
    local showTrace = raidConfig and raidConfig.Feature and 0 < raidConfig.Feature & FeatureDefines_MapRaid.DefineAsCommonMap
    if not showTrace then
      self.isInFuben = true
      self.seperateTraceBord:SetActive(false)
    else
      self.isInFuben = false
      self.seperateTraceBord:SetActive(true)
      self:closeMultiQuestList()
    end
  end
end

function MainViewNewTaskQuestPage:questDelete(note)
  local data = note.body
  local curTraceQuestID = self.singleTraceQuest and self.singleTraceQuest.data and self.singleTraceQuest.data.id
  if not curTraceQuestID then
    return
  end
  for i = 1, #data do
    local single = data[i]
    if single.id == curTraceQuestID then
      if self:checkQuestTraceHide(single.id) then
        self.singleTraceQuest:SetNoneStatus()
      end
      FunctionQuest.Me():handleMissShutdown(single.id)
      break
    end
  end
end

function MainViewNewTaskQuestPage:questAdd(note)
  if not self.singleTraceQuest.curTracingQuestId or not self.singleTraceQuest.isMainTrace then
    redlog("非主线任务  不自动跳转继承")
    return
  end
  local data = note.body
  local tempQuestData = {}
  for i = 1, #data do
    local single = data[i]
    local qData
    local singleStatus = 0
    if QuestProxy.Instance:getQuestDataByIdAndType(single, SceneQuest_pb.EQUESTLIST_ACCEPT) then
      qData = QuestProxy.Instance:getQuestDataByIdAndType(single, SceneQuest_pb.EQUESTLIST_ACCEPT)
      singleStatus = 1
    elseif QuestProxy.Instance:getQuestDataByIdAndType(single, SceneQuest_pb.EQUESTLIST_SUBMIT) then
      qData = QuestProxy.Instance:getQuestDataByIdAndType(single, SceneQuest_pb.EQUESTLIST_SUBMIT)
      singleStatus = 2
    end
    if qData then
      local cellData = {
        questData = qData,
        type = qData.questListType,
        status = singleStatus
      }
      table.insert(tempQuestData, cellData)
    end
  end
  if tempQuestData and 0 < #tempQuestData then
    table.sort(tempQuestData, MainViewNewTaskQuestPage.QuestTraceItemSortFunc)
  else
    return
  end
  local questNotice = false
  for i = 1, #tempQuestData do
    local targetQuest = tempQuestData[i].questData
    if targetQuest and targetQuest.type == QuestDataType.QuestDataType_DAILY then
      self.singleTraceQuest:SetNoneStatus()
      self:NewQuestNotice(targetQuest)
      return
    end
    if targetQuest and targetQuest:IsPrequest(self.singleTraceQuest.curTracingQuestId) then
      if not self:checkQuestForceToIgnore(targetQuest.id) then
        self.singleTraceQuest:SetData(targetQuest)
        if tempQuestData[i].status == 2 then
          self.singleTraceQuest:SetNoneStatus()
        else
          self.singleTraceQuest:SetData(targetQuest)
          self:ShowDirAndDis()
          return
        end
      else
        self.singleTraceQuest:SetNoneStatus()
      end
    elseif not questNotice then
      self:NewQuestNotice(targetQuest)
      questNotice = true
    end
  end
end

function MainViewNewTaskQuestPage:questTraceSwitch(note)
  local data = note.body
  local questData = QuestProxy.Instance:getQuestDataByIdAndType(data.id)
  if questData then
    self.singleTraceQuest:SetData(questData)
    self:ShowDirAndDis()
  end
end

function MainViewNewTaskQuestPage:NewQuestNotice(questData)
  xdlog("新任务推送！")
  local map = questData.map
  if not map then
    return
  end
  local mapData = Table_Map[map]
  if not mapData then
    redlog("任务指定地图Map中缺少配置！")
    return
  end
  self.notice_TweenPos:ResetToBeginning()
  self.notice_TweenPos:PlayForward()
  self.noticeLabel.text = string.format(ZhString.TaskQuestCell_NewQuestNotice, mapData.CallZh)
end

function MainViewNewTaskQuestPage:handleMissionCommand(note)
  local data = note.data
  local oldCmd = data[1]
  local newCmd = data[2]
  local oldQuestId, newQuestId
  if oldCmd then
    oldQuestId = oldCmd.args.custom
  end
  if newCmd then
    newQuestId = newCmd.args.custom
  end
  if oldQuestId and oldQuestId ~= newQuestId and self.singleTraceQuest then
    self.singleTraceQuest:setIsOngoing(false)
  end
  if newQuestId and oldQuestId ~= newQuestId and self.singleTraceQuest then
    self.singleTraceQuest:setIsOngoing(true)
  end
end

function MainViewNewTaskQuestPage:ShowDirAndDis()
  if self.singleTraceQuest and self.singleTraceQuest.data then
    local id = self.singleTraceQuest.data.id
    local data = self.singleTraceQuest.data
    self.onGoingQuestId = id
    local args = ReusableTable.CreateTable()
    local questData = data
    args.questData = questData
    args.owner = self.singleTraceQuest
    args.callback = self.singleTraceQuest.Update
    FunctionQuestDisChecker.Me():AddQuestCheck(args)
    ReusableTable.DestroyAndClearTable(args)
    FunctionQuest.Me():addQuestMiniShow(questData)
    FunctionQuest.Me():addMonsterNamePre(questData)
    LocalSaveProxy.Instance:setLastTraceQuestId(self.onGoingQuestId)
  end
end

function MainViewNewTaskQuestPage:ShowQuestListDirAndDis(cellCtrl)
  self.onGoingQuestId = cellCtrl.data.id
  if self.isInFuben then
    local curID = Game.MapManager:GetRaidID() or 0
    if curID ~= cellCtrl.data.map then
      return
    end
  end
  local args = ReusableTable.CreateTable()
  local questData = cellCtrl.data
  args.questData = questData
  args.owner = cellCtrl
  args.callback = cellCtrl.Update
  FunctionQuestDisChecker.Me():AddQuestCheck(args)
  ReusableTable.DestroyAndClearTable(args)
  FunctionQuest.Me():addQuestMiniShow(questData)
  FunctionQuest.Me():addMonsterNamePre(questData)
  cellCtrl:setISShowDir(true)
  LocalSaveProxy.Instance:setLastTraceQuestId(self.onGoingQuestId)
end

function MainViewNewTaskQuestPage:ShowCombinedQuestDirAndDis(cellCtrl)
  if cellCtrl.questList and #cellCtrl.questList > 0 then
    if cellCtrl.curChoose.id == self.onGoingQuestId and not noSwitch then
      cellCtrl:SwitchTracedQuestInCombinedGroup()
    end
    helplog("切换后的ID", cellCtrl.curChoose.id)
    self.onGoingQuestId = cellCtrl.curChoose.id
    cellCtrl.questData.curTraceQuest = self.onGoingQuestId
    if self.isInFuben then
      local curID = Game.MapManager:GetRaidID() or 0
      if curID ~= cellCtrl.data.map then
        return
      end
    end
    local args = ReusableTable.CreateTable()
    local questData = cellCtrl.curChoose
    args.questData = questData
    args.owner = cellCtrl
    args.callback = cellCtrl.Update
    FunctionQuestDisChecker.Me():AddQuestCheck(args)
    ReusableTable.DestroyAndClearTable(args)
    FunctionQuest.Me():addQuestMiniShow(questData)
    FunctionQuest.Me():addMonsterNamePre(questData)
    LocalSaveProxy.Instance:setLastTraceQuestId(self.onGoingQuestId)
  else
    redlog("questList长度不够")
    return
  end
end

function MainViewNewTaskQuestPage:stopShowDirAndDis(id)
  if not id then
    return
  end
  FunctionQuest.Me():stopQuestMiniShow(id)
  if self.singleTraceQuest and self.singleTraceQuest.data and self.singleTraceQuest.data.id == id then
    FunctionQuestDisChecker.RemoveQuestCheck(id)
    self.singleTraceQuest:SetNoneStatus()
  else
    redlog("steopshowdirand Dis 不满足条件")
  end
end

function MainViewNewTaskQuestPage:stopShowQuestListDirAndDis(id)
  if not id then
    return
  end
  FunctionQuest.Me():stopQuestMiniShow(id)
  local cells = self.questList:GetCells()
  for j = 1, #cells do
    local cell = cells[j]
    local data = cell.data
    if cell.curChoose and cell.curChoose.id == id then
      FunctionQuestDisChecker.RemoveQuestCheck(id)
      cell:setISShowDir(false)
      break
    end
    if data and id == data.id then
      FunctionQuestDisChecker.RemoveQuestCheck(id)
      cell:setISShowDir(false)
      break
    end
  end
end

function MainViewNewTaskQuestPage:getTraceCellByQuestId(id, type)
  if not id then
    return
  end
  local cells = self.questList:GetCells()
  if Table_FinishTraceInfo and Table_FinishTraceInfo[id] then
    local groupid = Table_FinishTraceInfo[id].QuestKey
    for i = 1, #cells do
      local cell = cells[i]
      if cell.groupid and cell.groupid == groupid then
        return cell, i
      end
    end
  end
  for j = 1, #cells do
    local cell = cells[j]
    local data = cell.data
    if data and id == data.id and not type then
      return cell, j
    elseif data and id == data.id and type == data.type then
      return cell, j
    end
  end
end

function MainViewNewTaskQuestPage:openMultiQuestList(cellCtrl)
  self.singleTraceQuest_TweenAlpha:PlayForward()
  self.singleTraceQuest_TweenPos:PlayForward()
  self.multiTraceQuest_TweenPos:PlayForward()
  self.multiTraceQuest_TweenAlpha:PlayForward()
  self.taskQuestBG_TweenScale:PlayForward()
  self.taskQuestBG_TweenPos:PlayForward()
  self.singleTraceQuest:ShowChooseEffect(false)
  self:SetTracedQuestList()
  self.closeTickTime = ServerTime.CurServerTime() / 1000 + showInterval
  TimeTickManager.Me():CreateTick(0, 1000, self.updateTaskQuestBordStatus, self, 1)
  if not self.initNewTag then
    local isNew = self:CheckTraceNewTag()
    self.newQuestTag:SetActive(isNew)
  end
end

function MainViewNewTaskQuestPage:closeMultiQuestList()
  self.singleTraceQuest_TweenAlpha:PlayReverse()
  self.singleTraceQuest_TweenPos:PlayReverse()
  self.multiTraceQuest_TweenPos:PlayReverse()
  self.multiTraceQuest_TweenAlpha:PlayReverse()
  self.taskQuestBG_TweenScale:PlayReverse()
  self.taskQuestBG_TweenPos:PlayReverse()
  self.singleTraceQuest:ShowChooseEffect(true)
  TimeTickManager.Me():ClearTick(self, 1)
end

function MainViewNewTaskQuestPage:SetTracedQuestList()
  local questIns = QuestProxy.Instance
  local list = questIns:getValidAcceptQuestList(true, self.mapLimitGroup)
  if self.curSort == 2 then
    local traceDatas = questIns:getTraceDatas()
    if traceDatas and not self.mapLimitGroup then
      for i = 1, #traceDatas do
        table.insert(list, traceDatas[i])
      end
    end
    QuestProxy.Instance:SetTraceCellCount(#list)
    local dahuangTrace = questIns:GetTraceDahuangQuestData()
    if dahuangTrace then
      for i = 1, #dahuangTrace do
        local single = dahuangTrace[i]
        table.insert(list, single)
      end
    end
    local acceptMainQuest = questIns:GetCanAcceptMainQuestList()
    if acceptMainQuest then
      for i = 1, #acceptMainQuest do
        table.insert(list, acceptMainQuest[i])
      end
    end
  end
  list = self:sortQuestList(list)
  self:sortPoriorty(list)
  self.questList:ResetDatas(list)
  self.noneMultiQuestTip:SetActive(list and #list == 0 or false)
  self.scrollview:ResetPosition()
  self:adjustScrollView()
end

local sortQuestType = {
  1,
  3,
  6,
  7,
  21,
  22
}

function MainViewNewTaskQuestPage:sortMultiQuestList(list)
  if not list or #list == 0 then
    return
  end
  local tempResult = {}
  for i = 1, #list do
    local single = list[i]
    local colorFromServer = single and single.staticData and single.staticData.ColorFromServer or 99
    if self.curSort == 1 then
      if single.trace and 0 < TableUtility.ArrayFindIndex(sortQuestType, colorFromServer) then
        table.insert(tempResult, single)
      end
    elseif self.curSort == 2 and TableUtility.ArrayFindIndex(sortQuestType, colorFromServer) == 0 then
      table.insert(tempResult, single)
    end
  end
  return tempResult
end

function MainViewNewTaskQuestPage:sortQuestList(list)
  local tempResult = ReusableTable.CreateTable()
  local Result = ReusableTable.CreateTable()
  local curMap = Game.MapManager:GetMapID()
  local worldGroup, isWorldMap = self:CheckWorldQuestMap()
  local finishList = QuestProxy.Instance:getQuestListInOrder(SceneQuest_pb.EQUESTLIST_SUBMIT)
  if 0 < #list then
    for i = 1, #list do
      local single = list[i]
      local questid = list[i].id
      local singleItem = tempResult[questid]
      if singleItem then
        redlog("出现重复ID!", questid)
      end
      if Table_FinishTraceInfo and Table_FinishTraceInfo[questid] then
        local traceGroupID = Table_FinishTraceInfo[questid].QuestKey
        if not tempResult[traceGroupID] then
          tempResult[traceGroupID] = {}
          tempResult[traceGroupID].isCombined = true
          tempResult[traceGroupID].curTraceQuest = self.onGoingQuestId
          tempResult[traceGroupID].groupid = traceGroupID
          if not tempResult[traceGroupID].type then
            tempResult[traceGroupID].type = single.type
          end
          if not tempResult[traceGroupID].orderId then
            tempResult[traceGroupID].orderId = questid
          end
          tempResult[traceGroupID].questList = {}
          single.isFinish = false
          table.insert(tempResult[traceGroupID].questList, single)
        else
          single.isFinish = false
          table.insert(tempResult[traceGroupID].questList, single)
        end
      elseif isWorldMap then
        if single.type == "world" or single.type == "worldboss" or single.type == "acc_world" or single.type == "acc_daily_world" then
          for i = 1, #GameConfig.Quest.worldquestmap[worldGroup].map do
            if GameConfig.Quest.worldquestmap[worldGroup].map[i] == single.map then
              tempResult[questid] = single
              tempResult[questid].isCombined = false
              break
            else
              FunctionQuestDisChecker.RemoveQuestCheck(single.id)
            end
          end
        else
          tempResult[questid] = single
          tempResult[questid].isCombined = false
        end
      elseif single.type == "world" or single.type == "worldboss" or single.type == "acc_world" or single.type == "acc_daily_world" then
        FunctionQuestDisChecker.RemoveQuestCheck(single.id)
      else
        tempResult[questid] = single
        tempResult[questid].isCombined = false
      end
    end
  end
  for i = 1, #finishList do
    local single = finishList[i]
    if Table_FinishTraceInfo and Table_FinishTraceInfo[single.id] then
      local traceGroupID = Table_FinishTraceInfo[single.id].QuestKey
      if tempResult[traceGroupID] then
        single.isFinish = true
        table.insert(tempResult[traceGroupID].questList, single)
      end
    end
  end
  for _, temp in pairs(tempResult) do
    table.insert(Result, temp)
  end
  return Result
end

function MainViewNewTaskQuestPage:questCellClick(cellCtrl)
  if not cellCtrl or not cellCtrl.data then
    return
  end
  if cellCtrl.data.type == "world" or cellCtrl.data.type == "worldboss" then
    xdlog("尝试移除点击")
    LocalSaveProxy.Instance:RemoveWorldQuestTrace(cellCtrl.data.id)
  end
  if cellCtrl.groupid then
    xdlog("任务有组")
    self:stopShowDirAndDis(self.onGoingQuestId)
    self:ShowCombinedQuestDirAndDis(cellCtrl)
    Game.QuestMiniMapEffectManager:ShowMiniMapDirEffect(cellCtrl.curChoose.id)
    local data = QuestProxy.Instance:getQuestDataByIdAndType(cellCtrl.data.id)
    self.singleTraceQuest:SetData(cellCtrl.questData)
    return
  end
  local canAutoExcute = QuestProxy.Instance:checkMainQuestAutoExcute(cellCtrl.data)
  xdlog("canAutoExcute", canAutoExcute, cellCtrl.data.id)
  if canAutoExcute then
    FunctionQuest.Me():executeQuest(cellCtrl.data)
  end
  if cellCtrl.data.id ~= self.onGoingQuestId then
    self:stopShowQuestListDirAndDis(self.onGoingQuestId)
  end
  local data = QuestProxy.Instance:getQuestDataByIdAndType(cellCtrl.data.id)
  if not data then
    redlog("no data")
  end
  self.singleTraceQuest:SetData(data)
  self:ShowQuestListDirAndDis(cellCtrl)
  self:ShowDirAndDis()
  Game.QuestMiniMapEffectManager:ShowMiniMapDirEffect(cellCtrl.data.id)
end

function MainViewNewTaskQuestPage:clickQuestSortBtn(type)
  self.curSort = type
  if type == 1 then
    self.commonQuestBtn_Bg.CurrentState = 1
    self.specialQuestBtn_Bg.CurrentState = 0
    self.commonQuestBtn_Icon.color = LuaGeometry.GetTempVector4(0.3843137254901961, 0.4392156862745098, 0.49019607843137253, 1)
    self.specialQuestBtn_Icon.color = LuaGeometry.GetTempVector4(0.7294117647058823, 0.7686274509803922, 0.8470588235294118, 1)
  elseif type == 2 then
    self.commonQuestBtn_Bg.CurrentState = 0
    self.specialQuestBtn_Bg.CurrentState = 1
    self.commonQuestBtn_Icon.color = LuaGeometry.GetTempVector4(0.7294117647058823, 0.7686274509803922, 0.8470588235294118, 1)
    self.specialQuestBtn_Icon.color = LuaGeometry.GetTempVector4(0.3843137254901961, 0.4392156862745098, 0.49019607843137253, 1)
  end
  self.closeTickTime = ServerTime.CurServerTime() / 1000 + showInterval
  self:SetTracedQuestList()
end

function MainViewNewTaskQuestPage:taskBookQuestTrace(cell)
  local isShowDirAndDis = QuestProxy.Instance:checkIsShowDirAndDis(cell.data.data.questData)
  if cell.data.data.questData.id ~= self.onGoingQuestId then
    self:stopShowDirAndDis(self.onGoingQuestId)
  end
  self:closeMultiQuestList()
  self.singleTraceQuest:SetData(cell.data.data.questData, true)
  self:ShowDirAndDis()
  self.questList:RemoveAll()
  EventManager.Me():DispatchEvent(QuestManualEvent.GoClick, self)
end

function MainViewNewTaskQuestPage:servantQuestTrace(note)
  local questData = note.data and note.data.questData
  if not questData then
    return
  end
  if questData.id ~= self.onGoingQuestId then
    self:stopShowDirAndDis(self.onGoingQuestId)
  end
  self.singleTraceQuest:SetData(questData, true)
  self:ShowDirAndDis()
  EventManager.Me():DispatchEvent(QuestManualEvent.GoClick, self)
end

function MainViewNewTaskQuestPage:checkQuestTraceHide(questid)
  local config = GameConfig.NoviceTargetPointCFG.CloseQuestTrace
  if config then
    if TableUtility.ArrayFindIndex(config, questid) > 0 then
      return true
    else
      return false
    end
  else
    return false
  end
end

function MainViewNewTaskQuestPage:checkQuestForceToIgnore(questid)
  local config = GameConfig.NoviceTargetPointCFG.ForceCloseQuest
  if config then
    if TableUtility.ArrayFindIndex(config, questid) > 0 then
      return true
    else
      return false
    end
  else
    return false
  end
end

function MainViewNewTaskQuestPage.QuestTraceItemSortFunc(a, b)
  local a_Quest = a.questData
  local b_Quest = b.questData
  if a_Quest.questListType == b_Quest.questListType then
    local a_QuestType = a_Quest.type
    local b_QuestType = b_Quest.type
    if a_QuestType == b_QuestType then
      return a_Quest.id < b_Quest.id
    else
      local leftWeight, rightWeight
      if QuestData.QuestDataTypeSortWeight[a_QuestType] then
        leftWeight = QuestData.QuestDataTypeSortWeight[a_QuestType]
      else
        leftWeight = 0
      end
      if QuestData.QuestDataTypeSortWeight[b_QuestType] then
        rightWeight = QuestData.QuestDataTypeSortWeight[b_QuestType]
      else
        rightWeight = 0
      end
      if leftWeight == 0 and rightWeight == 0 then
        return a.questData.id < b.questData.id
      else
        return leftWeight > rightWeight
      end
    end
  else
    return a_Quest.questListType < b_Quest.questListType
  end
end

local func = function(t1, t2)
  if t1.type == t2.type then
    if t1.staticData and t1.staticData.IconFromServer == 6 or t2.staticData and t2.staticData.IconFromServer == 6 then
      local leftWeight = 90
      if t1.staticData and t1.staticData.IconFromServer == 6 then
        leftWeight = 90
      else
        leftWeight = 0
      end
      local rightWeight = 90
      if t2.staticData and t2.staticData.IconFromServer == 6 then
        rightWeight = 90
      else
        rightWeight = 0
      end
      if leftWeight == 0 and rightWeight == 0 then
        return t1.orderId < t2.orderId
      elseif leftWeight == 90 and rightWeight == 90 then
        return t1.orderId < t2.orderId
      else
        return leftWeight > rightWeight
      end
    elseif t1.staticData and t1.staticData.IconFromServer == 6 then
      leftWeight = 90
    elseif t1.type == QuestDataType.QuestDataType_WANTED then
      return t1.time > t2.time
    elseif t1.staticData and t1.staticData.IconFromServer == 7 or t2.staticData and t2.staticData.IconFromServer == 7 then
      local leftWeight = 80
      if t1.staticData and t1.staticData.IconFromServer == 7 then
        leftWeight = 80
      else
        leftWeight = 0
      end
      local rightWeight = 80
      if t2.staticData and t2.staticData.IconFromServer == 7 then
        rightWeight = 80
      else
        rightWeight = 0
      end
      if leftWeight == 0 and rightWeight == 0 then
        return t1.orderId < t2.orderId
      elseif leftWeight == 80 and rightWeight == 80 then
        return t1.orderId < t2.orderId
      else
        return leftWeight > rightWeight
      end
    else
      return t1.orderId < t2.orderId
    end
  elseif t1.type ~= t2.type then
    local leftWeight = 200
    if t1.staticData and t1.staticData.IconFromServer == 6 then
      leftWeight = 100
    elseif t1.staticData and t1.staticData.IconFromServer == 7 then
      leftWeight = 80
    elseif t1.staticData and t1.staticData.IconFromServer == 5 then
      leftWeight = 70
    elseif t1.staticData and t1.staticData.IconFromServer == 1 then
      leftWeight = 60
    elseif t1.staticData and t1.staticData.IconFromServer == 2 then
      leftWeight = 30
    elseif t1.staticData and t1.staticData.IconFromServer == 3 then
      leftWeight = 10
    elseif t1.staticData and t1.staticData.IconFromServer == 4 then
      leftWeight = 20
    elseif t1.staticData and t1.staticData.IconFromServer == 20 then
      leftWeight = 90
    elseif t1.type == QuestDataType.QuestDataType_DAHUANG then
      leftWeight = 210
    elseif t1.type == QuestDataType.QuestDataType_INVADE then
      leftWeight = 200
    elseif t1.type == QuestDataType.QuestDataType_ACTIVITY_TRACEINFO then
      leftWeight = 180
    elseif t1.type == QuestDataType.QuestDataType_MAIN then
      leftWeight = 60
    elseif t1.type == QuestDataType.QuestDataType_WANTED then
      leftWeight = 50
    elseif t1.type == QuestDataType.QuestDataType_SEALTR then
      leftWeight = 40
    elseif t1.type == QuestDataType.QuestDataType_DAILY then
      leftWeight = 30
    elseif t1.type == QuestDataType.QuestDataType_ELITE then
      leftWeight = 20
    elseif t1.type == QuestDataType.QuestDataType_BRANCH then
      leftWeight = 10
    else
      leftWeight = 0
    end
    local rightWeight = 200
    if t2.staticData and t2.staticData.IconFromServer == 6 then
      rightWeight = 100
    elseif t2.staticData and t2.staticData.IconFromServer == 7 then
      rightWeight = 80
    elseif t2.staticData and t2.staticData.IconFromServer == 5 then
      rightWeight = 70
    elseif t2.staticData and t2.staticData.IconFromServer == 1 then
      rightWeight = 60
    elseif t2.staticData and t2.staticData.IconFromServer == 2 then
      rightWeight = 30
    elseif t2.staticData and t2.staticData.IconFromServer == 3 then
      rightWeight = 10
    elseif t2.staticData and t2.staticData.IconFromServer == 4 then
      rightWeight = 20
    elseif t2.staticData and t2.staticData.IconFromServer == 20 then
      rightWeight = 90
    elseif t2.type == QuestDataType.QuestDataType_DAHUANG then
      rightWeight = 210
    elseif t2.type == QuestDataType.QuestDataType_INVADE then
      rightWeight = 200
    elseif t2.type == QuestDataType.QuestDataType_ACTIVITY_TRACEINFO then
      rightWeight = 180
    elseif t2.type == QuestDataType.QuestDataType_MAIN then
      rightWeight = 60
    elseif t2.type == QuestDataType.QuestDataType_WANTED then
      rightWeight = 50
    elseif t2.type == QuestDataType.QuestDataType_SEALTR then
      rightWeight = 40
    elseif t2.type == QuestDataType.QuestDataType_DAILY then
      rightWeight = 30
    elseif t2.type == QuestDataType.QuestDataType_ELITE then
      rightWeight = 20
    elseif t2.type == QuestDataType.QuestDataType_BRANCH then
      rightWeight = 10
    else
      rightWeight = 0
    end
    if leftWeight == 0 and rightWeight == 0 then
      return t1.orderId < t2.orderId
    else
      return leftWeight > rightWeight
    end
  end
end

function MainViewNewTaskQuestPage:sortPoriorty(questList)
  if questList ~= nil and #questList ~= 0 then
    table.sort(questList, func)
  end
end

function MainViewNewTaskQuestPage:CheckTraceNewTag()
  local list = LocalSaveProxy.Instance:GetWorldQuestTraceList()
  if list then
    local isNew = false
    for k, v in pairs(list) do
      if v == false then
        isNew = true
        break
      end
    end
    return isNew
  end
  return false
end

function MainViewNewTaskQuestPage:CheckWorldQuestMap()
  local curMapId = Game.MapManager:GetMapID()
  if GameConfig and GameConfig.Quest then
    if GameConfig.Quest.worldquestmap and type(GameConfig.Quest.worldquestmap[1].map) == "table" then
      local mapGroup = GameConfig.Quest.worldquestmap
      for k, v in pairs(mapGroup) do
        for i = 1, #v.map do
          if curMapId == v.map[i] then
            return k, true
          end
        end
      end
      return nil, false
    end
    return nil, false
  end
end

function MainViewNewTaskQuestPage:RefreshMapLimitQuest()
  local curMap = Game.MapManager:GetMapID()
  local config = GameConfig.Quest.QuestHideMapGroup
  if not config then
    return
  end
  for k, v in pairs(config) do
    if v.map and #v.map > 0 then
      for i = 1, #v.map do
        if v.map[i] == curMap then
          local menuid = v.MenuID or 0
          if not FunctionUnLockFunc.Me():CheckCanOpen(menuid) then
            self.mapLimitGroup = k
            return
          end
        end
      end
    end
  end
  self.mapLimitGroup = nil
end

function MainViewNewTaskQuestPage:handleNewMenu(note)
  self:RefreshMapLimitQuest()
  local data = note.body
  if data then
    local list = data.list
    if list and 0 < #list then
      local groupid = self.mapLimitGroup or 1
      local refreshMenuId = GameConfig.Quest.QuestHideMapGroup[groupid].MenuID or 9961
      if 0 < TableUtility.ArrayFindIndex(list, refreshMenuId) then
        xdlog("Menu解锁")
      end
    end
  end
end

function MainViewNewTaskQuestPage:NewPointNotice(note)
  self.pointNotice_Tween:ResetToBeginning()
  self.pointNotice_Tween:PlayForward()
  local data = note.body
  self.lvType = data.lvType
  if lvType == SceneUserEvent.BaseLevelUp then
    self.AddPointLabel.text = ZhString.LevelUpNotice_Base
  elseif lvType == SceneUserEvent.JobLevelUp then
    self.AddPointLabel.text = ZhString.LevelUpNotice_Job
  end
end

function MainViewNewTaskQuestPage:HideNotice()
  self.pointNotice_Tween:ResetToBeginning()
end
