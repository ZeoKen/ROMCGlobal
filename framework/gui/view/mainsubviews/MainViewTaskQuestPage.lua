autoImport("TaskQuestCell")
autoImport("DeathPopView")
autoImport("QuestDetailTip")
MainViewTaskQuestPage = class("MainViewTaskQuestPage", SubView)
local tempVector3 = LuaVector3.Zero()

function MainViewTaskQuestPage:OnShow()
  if self.timetick ~= nil then
    self.timetick:ContinueTick()
  end
end

function MainViewTaskQuestPage:OnHide()
  if self.timetick ~= nil then
    self.timetick:StopTick()
  end
end

function MainViewTaskQuestPage:Init()
  self:AddViewEvts()
  self:initView()
  self:initData()
  self:RegisterGuide()
  self.currentMapId = 0
  self.isInFuben = false
  self.isInHand = false
  self.hasInitSelected = false
  self.curFolderState = true
end

function MainViewTaskQuestPage:initData()
  self.appearAmMap = {}
  self.onGoingQuestId = nil
  self.curProcessQuestId = nil
  self.mapLimitGroup = nil
end

function MainViewTaskQuestPage:initView()
  self.traceNewVer = false
  self.questTraceSymbol = self:FindGO("QuestTraceSymbol")
  self.questTraceSymbolTrans = self.questTraceSymbol.transform
  self.questTraceContainer = self:FindGO("QuestTraceContainer", self.questTraceSymbol).transform
  self.questTraceDistance = self:FindGO("Distance", self.questTraceSymbol):GetComponent(UILabel)
  self.questTraceDistanceTrans = self.questTraceDistance.transform
  WayPointerUtil.SetUISize(Screen.width * 0.6, Screen.height * 0.65)
  WayPointerUtil.SetWayPointRadiusRatio(0.35)
  WayPointerUtil.SetScreenSpaceOffset(0, 66)
  self.gameObject = self:FindGO("ClassicTraceBord")
  self.foldSymbol = self:FindGO("taskCellFoldSymbol")
  self.foldRedTip = self:FindGO("foldRedTip")
  self.taskBordFoldSymbol = self:FindGO("taskBordFoldSymbol")
  local taskCellFoldSymbolSp = self:FindComponent("taskCellFoldSymbol", UISprite)
  self.foldCt = self:FindGO("foldCt", self.gameObject)
  self.foldCtTrans = self.foldCt.transform
  self:AddClickEvent(self.taskBordFoldSymbol, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.QuestTracePanel
    })
  end)
  self:AddClickEvent(self.foldSymbol, function(...)
    self.curFolderState = not self.curFolderState
    if self.curFolderState then
      self:setQuestData()
    end
    for i = 1, #self.playTweens do
      local single = self.playTweens[i]
      single:Play(true)
    end
  end)
  self.playTweens = self.foldSymbol:GetComponents(UIPlayTween)
  self.rotationTwn = self.foldSymbol:GetComponent(TweenRotation)
  self.scrollview = self:FindGO("taskQuestScrollView", self.gameObject):GetComponent(UIScrollView)
  self.scHeight = self.scrollview.panel.baseClipRegion.w
  self.EffectPanel = self:FindGO("EffectPanel")
  self.taskBord = self:FindGO("taskBord", self.gameObject)
  self.taskQuestTable = self.taskBord:GetComponent(UITable)
  self.questList = UIGridListCtrl.new(self.taskQuestTable, TaskQuestCell, "TaskQuestCell")
  self.questList:AddEventListener(MouseEvent.MouseClick, self.questCellClick, self)
  self.questList:AddEventListener(MouseEvent.DoubleClick, self.questCellDoubleClick, self)
  local objLua = self.gameObject:GetComponent(GameObjectForLua)
  
  function objLua.onEnable()
    TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
      self:adjustScrollView()
    end, self, 3)
  end
  
  local taskQuestGO = self:FindGO("GameObject", self.gameObject)
  self.taskQuestTween = taskQuestGO:GetComponent(TweenPosition)
  self.taskQuestTweenTrans = self.taskQuestTween.gameObject.transform
  self.taskQuestBG = self:FindGO("taskQuestBG", taskQuestGO)
  self.noTracingTip = self:FindGO("noTracingTip")
  local noTracingTipObjForLua = self.noTracingTip:AddComponent(GameObjectForLua)
  
  function noTracingTipObjForLua.onEnable()
    TimeTickManager.Me():CreateOnceDelayTick(2000, function(owner, deltaTime)
      if self.noTracingTip.activeSelf then
        self:QuestTraceGuide()
      end
    end, self, 4)
  end
  
  function noTracingTipObjForLua.onDisable()
    if self.traceGuideEffect then
      GameObject.Destroy(self.traceGuideEffect)
      self.guideEffPath = nil
      self.traceGuideEffect = nil
    end
  end
  
  self:AddClickEvent(self.noTracingTip, function()
    if self.traceGuideEffect then
      if not Game.GameObjectUtil:ObjectIsNULL(self.traceGuideEffect) then
        Game.GOLuaPoolManager:AddToUIPool(self.guideEffPath, self.traceGuideEffect)
      end
      self.guideEffPath = nil
      self.traceGuideEffect = nil
      FunctionPlayerPrefs.Me():SetBool("TraceGuide" .. Game.Myself.data.id, true)
    end
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.QuestTracePanel
    })
  end)
  self.questTraceBoard = self:FindGO("QuestTraceBoard")
  self.questTraceBoardCell = QuestTraceCell.new(self.questTraceBoard)
  self.questTraceBoardCell.RefreshMark = MainViewTaskQuestPage.RefreshTraceMark
  self.traceMark_Icon = self:FindGO("TraceMark", self.questTraceBoard):GetComponent(UISprite)
  self:AddButtonEvent("QuestTraceClickDisappear", function()
    self.questTraceBoardCell:SetIsMainViewTrace(false)
    self.questTraceBoard:SetActive(false)
    self:questTraceCellClose()
  end)
  self.questNotice = self:FindGO("NewQuestNotice", self.gameObject)
  self.questNoticeLabel = self:FindGO("NoticeLabel", self.questNotice):GetComponent(UILabel)
  self.questNoticeLabel.text = ZhString.TaskQuestTip_NewQuest
  self.questNotice_Tween = self.questNotice:GetComponent(TweenPosition)
  self.questNotice_Tween:SetOnFinished(function()
    self.questNotice:SetActive(false)
  end)
  self:AddClickEvent(self.questNotice, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.QuestTracePanel
    })
  end)
  self:initView_extraInfoTrace()
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
      self:JumpToSkillView()
    end
  end)
  self.closeNotice = self:FindGO("CloseNotice", self.addPointNotice)
  self:AddClickEvent(self.closeNotice, function()
    self:HideNotice()
  end)
  self.noticeShowed = false
  self:TryShowNewPointNotice()
end

function MainViewTaskQuestPage:IsHeroProfess(profess)
  local myClassConfig = Table_Class[profess]
  return myClassConfig and myClassConfig.FeatureSkill
end

function MainViewTaskQuestPage:JumpToSkillView()
  local myProfess = SkillProxy.Instance:GetMyProfession()
  if self:IsHeroProfess(myProfess) then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.CharactorHeroSkill
    })
    return
  else
    local typeBranch = MyselfProxy.Instance:GetMyProfessionTypeBranch()
    local professTree = ProfessionProxy.Instance:GetProfessionTreeByClassId(myProfess)
    local mydepth = professTree and professTree:GetProfessDataByClassID(myProfess).depth or 0
    local professDatas = SkillProxy.Instance:GetProfessDatasByDepth(myProfess, mydepth - 1)
    local thirdTotalUsedPoints = 0
    for _, profess in pairs(professDatas) do
      thirdTotalUsedPoints = thirdTotalUsedPoints + profess.points
    end
    local config = GameConfig.ExtraSkill
    local thirdTotalPoints = config.point[typeBranch] or config.defaultPoint
    local thirdTotalUnusedPoints = thirdTotalPoints - thirdTotalUsedPoints
    local totalUnusedSkillPoints = Game.Myself.data.userdata:Get(UDEnum.SKILL_POINT)
    local fourthTotalUnusedPoints = totalUnusedSkillPoints - thirdTotalUnusedPoints
    if 1 <= fourthTotalUnusedPoints then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.CharactorFourthSkill
      })
      return
    else
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.CharactorProfessSkill
      })
      return
    end
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.SkillView
  })
  return
end

function MainViewTaskQuestPage:adjustScrollView(needMoveToTarget)
  self.questList:Layout()
  self.scrollview:RestrictWithinBounds(true)
  self:folderSymbol(self.curFolderState)
  local cellCtrl = self:getTraceCellByQuestId(self.onGoingQuestId)
  if not cellCtrl then
    self.scrollview:ResetPosition()
    return
  end
  local panel = self.scrollview.panel
  local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, cellCtrl.gameObject.transform)
  local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
  offset = Vector3(0, offset.y, 0)
  self.scrollview:MoveRelative(offset)
  local cells = self.questList:GetCells()
  if cells and cells[2] and cells[2].emptyCell and cells[1] then
    local delta = self.scHeight - cells[1]:GetBgHeight()
    cells[2]:ResizeWidget(0 < delta and delta or 0)
  end
end

function MainViewTaskQuestPage:Show(tarObj)
  MainViewTaskQuestPage.super.Show(self, tarObj)
  if not tarObj then
    self:ResetDatas()
  end
end

function MainViewTaskQuestPage:ResetDatas()
  self:RefreshMapLimitQuest()
  if self.gameObject.activeSelf then
    self:setQuestData()
  end
  self:ResetDatas_extraInfoTrace()
end

function MainViewTaskQuestPage:AddViewEvts()
  self:AddListenEvt(ServiceEvent.QuestQuestUpdate, self.QuestQuestUpdate)
  self:AddListenEvt(ServiceEvent.QuestQuestList, self.QuestQuestList)
  self:AddListenEvt(ServiceEvent.QuestQuestStepUpdate, self.QuestQuestStepUpdate)
  self:AddListenEvt(ServiceEvent.QuestQueryOtherData, self.QuestQueryOtherData)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.ItemUpdate)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.ItemUpdate)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.handlePlayerMapChange)
  self:AddListenEvt(MyselfEvent.DeathBegin, self.handleDeathStatus)
  self:AddListenEvt(QuestEvent.ProcessChange, self.ProcessChange)
  self:AddListenEvt(QuestEvent.RemoveHelpQuest, self.RemoveHelpQuest)
  self:AddListenEvt(QuestEvent.UpdateAnnounceQuestList, self.UpdateAnnounceQuestList)
  self:AddListenEvt(QuestEvent.RemoveGuildQuestList, self.RemoveGuildQuestList)
  self:AddListenEvt(QuestEvent.UpdateGuildQuestList, self.UpdateGuildQuestList)
  self:AddListenEvt(QuestEvent.ShowManualGoEffect, self.HandleManualGoEffect)
  self:AddListenEvt(QuestEvent.QuestDelete, self.questDelete)
  self:AddListenEvt(QuestEvent.QuestAdd, self.questAdd)
  self:AddListenEvt(ServiceEvent.QuestMapStepSyncCmd, self.handleDahuangQuestStepSyncUpdate)
  self:AddListenEvt(ServiceEvent.QuestMapStepUpdateCmd, self.handleDahuangQuestStepUpdate)
  self:AddListenEvt(MainViewEvent.MiniMapSettingChange, self.setQuestData)
  self:AddListenEvt(MyselfEvent.LevelUp, self.setQuestData)
  self:AddListenEvt(ServiceEvent.NUserNewMenu, self.handleNewMenu)
  self:AddListenEvt(ServiceEvent.QuestClientTraceListQuestCmd, self.RecvClientTraceList)
  self:AddListenEvt("ClickBigMapBoardQuestCell", self.recvCellClick)
  self:AddListenEvt(MyselfEvent.ReliveStatus, self.HandleMyselfRelive)
  self:AddListenEvt(QuestEvent.QuestRepairMode, self.HandleQuestRepairMode)
  self:AddListenEvt(QuestEvent.QuestTraceOff, self.adjustScrollView)
  self:AddListenEvt(QuestEvent.QuestTraceSwitch, self.questTraceSwitch)
  self:AddListenEvt(GuideEvent.AdjustQuestList, self.focusOnTargetQuest)
  self:AddListenEvt(QuestEvent.QuestTracePanelOff, self.QuestQuestUpdate)
  self:AddListenEvt(QuestEvent.QuestTraceNotice, self.QuestNotice)
  self:AddListenEvt(ServiceEvent.ScenePetBoKiStateQueryPetCmd, self.setQuestData)
  self:AddListenEvt(EscortEvent.EscortInfoChanged, self.ResetDatas_extraInfoTrace)
  self:AddListenEvt(HotKeyEvent.QuestGuide, self.HandleHotKeyQuestGuide)
  local eventManager = EventManager.Me()
  eventManager:AddEventListener(MyselfEvent.SceneGoToUserCmdHanded, self.SceneGoToUserCmd, self)
  eventManager:AddEventListener(FunctionQuest.UpdateTraceInfo, self.updateTraceInfo, self)
  eventManager:AddEventListener(FunctionQuest.RemoveTraceInfo, self.RemoveTraceInfo, self)
  eventManager:AddEventListener(FunctionQuest.AddTraceInfo, self.AddTraceInfo, self)
  eventManager:AddEventListener(HandEvent.MyStartHandInHand, self.MyStartHandInHand, self)
  eventManager:AddEventListener(HandEvent.MyStopHandInHand, self.MyStopHandInHand, self)
  eventManager:AddEventListener(MyselfEvent.MissionCommandChanged, self.handleMissionCommand, self)
  eventManager:AddEventListener(LoadSceneEvent.FinishLoadScene, self.OnFinishLoadScene, self)
  eventManager:AddEventListener(ServiceEvent.ItemGetCountItemCmd, self.OnInvadeItemUpdate, self)
  if not self.traceNewVer then
    eventManager:AddEventListener(QuestManualEvent.BeforeGoClick, self.ShowQuestTraceBorad, self)
    eventManager:AddEventListener(ServantImproveEvent.BeforeGoClick, self.ShowServantImproveQuestTraceBorad, self)
    eventManager:AddEventListener(ServantImproveEvent.GotomodeTrace, self.ShowServantImproveQuestTraceBorad, self)
  end
  self:AddListenEvt(MyselfEvent.LevelUp, self.NewPointNotice)
  self:AddListenEvt(ServiceEvent.QuestAbyssDragonInfoNtfQuestCmd, self.ResetDatas_extraInfoTrace)
  self:AddListenEvt(ServiceEvent.QuestAbyssDragonHpUpdateQuestCmd, self.SetDragonHp)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.HandleVarUpdate)
  self:AddListenEvt(MainViewEvent.SpaceDragonCellClick, self.OnClickDragonCell)
end

function MainViewTaskQuestPage:SetDragonHp(note)
  if self.extraInfoCells then
    local cell = self.extraInfoCells.SpaceDragon
    if cell then
      cell:UpdateHp(data)
      return
    end
  end
end

function MainViewTaskQuestPage:SetDragonReward(note)
  if self.extraInfoCells then
    local cell = self.extraInfoCells.SpaceDragon
    if cell then
      cell:SetRewardGrid()
    end
  end
end

function MainViewTaskQuestPage:HandleVarUpdate(note)
  self:SetDragonReward()
end

function MainViewTaskQuestPage:UpdateGuildQuestList(note)
  local upQuests = note.body
  for k, v in pairs(upQuests) do
    local cell, index = self:getTraceCellByQuestId(k)
    if cell and cell.data then
      resetPos = true
      cell:SetData(cell.data)
    end
  end
  if resetPos then
    self.questList:Layout()
  end
  self:selectShowDirQuest(self.onGoingQuestId, true)
end

function MainViewTaskQuestPage:RemoveGuildQuestList(note)
  local rmQuests = note.body
  for k, v in pairs(rmQuests) do
    local cell, index = self:getTraceCellByQuestId(k)
    if cell then
      resetPos = true
      self.questList:RemoveCell(index)
    end
  end
  if resetPos then
    self.questList:Layout()
    self.scrollview:InvalidateBounds()
    self.scrollview:RestrictWithinBounds(true)
  end
end

function MainViewTaskQuestPage:RemoveHelpQuest(note)
  local ids = note.body
  if type(ids) == "number" then
    ids = {ids}
  end
  for i = 1, #ids do
    ServiceSessionTeamProxy.Instance:CallAcceptHelpWantedTeamCmd(ids[i], true)
  end
end

function MainViewTaskQuestPage:UpdateAnnounceQuestList(note)
  local questId = note.body
  local cell = self:getTraceCellByQuestId(questId)
  local data = QuestProxy.Instance:getQuestDataByIdAndType(questId)
  if cell and data then
    cell:SetData(data)
    local updateList = cell.bgSizeChanged
    if updateList then
      self.taskQuestTable.repositionNow = true
    end
  end
  self:selectShowDirQuest(self.onGoingQuestId, true)
end

function MainViewTaskQuestPage:removeAppearAnm(id)
  self.appearAmMap[id] = nil
end

function MainViewTaskQuestPage:checkCellIsVisible(widget)
  local panel = self.scrollview.panel
  if panel then
    return panel:IsVisible(widget)
  end
end

function MainViewTaskQuestPage.effectLoaded(effectObj, pos)
  if not LuaGameObject.ObjectIsNull(effectObj) then
    effectObj.transform.localPosition = pos
  end
end

function MainViewTaskQuestPage:playTaskAppearAnm(cell)
  if cell and cell.data and cell.data.getIfShowAppearAnm and cell.data:getIfShowAppearAnm() and not self.appearAmMap[cell.data.id] and self:checkCellIsVisible(cell.title) then
    self.appearAmMap[cell.data.id] = true
    LuaVector3.Better_Set(tempVector3, LuaGameObject.InverseTransformPointByTransform(self.EffectPanel.transform, cell.title.transform, Space.World))
    self:PlayUIEffect(EffectMap.UI.Refresh, self.EffectPanel, true, MainViewTaskQuestPage.effectLoaded, tempVector3)
    TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
      if not cell.data then
        return
      end
      self:removeAppearAnm(cell.data.id)
      cell.data:setIfShowAppearAnm(false)
    end, self, 2)
  else
  end
end

function MainViewTaskQuestPage:ItemUpdate()
  if not self.curFolderState then
    return
  end
  local cells = self.questList:GetCells()
  local refresh = false
  for j = 1, #cells do
    local cell = cells[j]
    local data = cell.data
    if data and QuestProxy.Instance:checkUpdateWithItemUpdate(data) then
      local questData = QuestProxy.Instance:getQuestDataByIdAndType(data.id, SceneQuest_pb.EQUESTLIST_ACCEPT)
      if questData then
        cell:SetData(questData)
        refresh = true
      end
    end
  end
  if refresh then
    self:setQuestData()
    self:selectShowDirQuest(self.onGoingQuestId, true)
  end
end

function MainViewTaskQuestPage:QuestQueryOtherData()
  local cells = self.questList:GetCells()
  local refresh = false
  for j = 1, #cells do
    local cell = cells[j]
    local data = cell.data
    if data and QuestDataType.QuestDataType_DAILY == data.type then
      local questData = QuestProxy.Instance:getQuestDataByIdAndType(data.id, SceneQuest_pb.EQUESTLIST_ACCEPT)
      if questData then
        cell:SetData(questData)
        refresh = true
      end
    end
  end
  if refresh then
    self:selectShowDirQuest(self.onGoingQuestId, true)
  end
end

function MainViewTaskQuestPage:QuestQuestUpdate(note)
  if not self.curFolderState then
    return
  end
  local data = note.body
  local items = data and data.items
  local delectCell = self:GetDeleteTraceCell(items)
  if delectCell then
    TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
      self:setQuestData()
    end, self, 5)
  else
    TimeTickManager.Me():ClearTick(self, 5)
    self:setQuestData()
  end
  self:selectShowDirQuest(self.onGoingQuestId)
  self:TryFoldSymboleWithFubenQuest()
  self:TryRefreshFixedTrigger()
  local curTraceID = self.questTraceBoardCell.questId
  local data = QuestProxy.Instance:getQuestDataByIdAndType(curTraceID)
  if not data then
    self.questTraceBoard:SetActive(false)
    self:questTraceCellClose()
    FunctionQuest.Me():handleMissShutdown(curTraceID)
  end
end

function MainViewTaskQuestPage:questDelete(note)
  local data = note.body
  for i = 1, #data do
    local single = data[i]
    if single.id == self.questTraceBoardCell.questId then
      if self:checkQuestTraceHide(single.id) then
        self.questTraceBoardCell.questId = nil
      end
      self.showQuestTraceCell = false
      self.questTraceBoard:SetActive(false)
      self:questTraceCellClose()
      FunctionQuest.Me():handleMissShutdown(single.id)
      break
    end
  end
  local needRefreshList = false
  for i = 1, #data do
    local single = data[i]
    self:removeAppearAnm(single.id)
    local cell = self:getTraceCellByQuestId(single.id)
    if cell then
      needRefreshList = true
    end
  end
  if needRefreshList then
    self:setQuestData()
  end
end

function MainViewTaskQuestPage:questAdd(note)
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
    table.sort(tempQuestData, MainViewTaskQuestPage.QuestTraceItemSortFunc)
  else
    return
  end
  local switchQuestID
  for i = 1, #tempQuestData do
    local questData = tempQuestData[i] and tempQuestData[i].questData
    if questData and (questData:IsPrequest(self.curProcessQuestId) or questData:checkMustPrequest(self.curProcessQuestId)) and QuestProxy.Instance:checkIsShowDirAndDis(questData) then
      xdlog("派生任务", questData.id, questData.traceTitle)
      if not switchQuestID then
        switchQuestID = questData.id
        self.onGoingQuestId = questData.id
      end
      if questData.finishData then
        QuestProxy.Instance:AddTraceList(questData.finishData.QuestKey)
      else
        QuestProxy.Instance:AddTraceList(questData.id)
      end
    end
  end
  for i = 1, #tempQuestData do
    local questData = tempQuestData[i] and tempQuestData[i].questData
    if QuestProxy.Instance:checkIsShowDirAndDis(questData) and questData:getQuestListType() == SceneQuest_pb.EQUESTLIST_ACCEPT and QuestProxy.Instance:isQuestCanBeShowTrace(questData.type) and questData.id ~= switchQuestID then
      self:QuestNotice()
      break
    end
  end
end

function MainViewTaskQuestPage:TryFoldSymboleWithFubenQuest(questData)
  local curID = Game.MapManager:GetRaidID() or 0
  if questData then
    if curID == questData.map then
      self:folderSymbol(true)
    end
  else
    local cells = self.questList:GetCells()
    for j = 1, #cells do
      local cell = cells[j]
      local questData = cell.data
      if questData and curID == questData.map then
        self:folderSymbol(true)
        return
      end
    end
  end
end

function MainViewTaskQuestPage:GetNewTraceCell(items)
  if not items then
    return
  end
  for i = 1, #items do
    local item = items[i]
    local update = item.update
    local type = item.type
    if type == SceneQuest_pb.EQUESTLIST_ACCEPT and 0 < #update then
      return self:GetMinIndexTraceCell(update)
    end
    if type == SceneQuest_pb.EQUESTLIST_SUBMIT and 0 < #update then
      return self:GetMinIndexTraceCell(update)
    end
  end
end

function MainViewTaskQuestPage:GetDeleteTraceCell(items)
  if not items then
    return
  end
  for i = 1, #items do
    local str = ""
    local item = items[i]
    local del = item.del
    local type = item.type
    if type == SceneQuest_pb.EQUESTLIST_ACCEPT and 0 < #del then
      return self:GetMinIndexTraceCellByQuestID(del)
    end
    if type == SceneQuest_pb.EQUESTLIST_SUBMIT and 0 < #del then
      return self:GetMinIndexTraceCellByQuestID(del)
    end
  end
end

function MainViewTaskQuestPage:GetMinIndexTraceCell(items)
  if not items then
    return
  end
  local topIndex = 99999
  local topCell
  for i = 1, #items do
    local single = items[i]
    local cell, index = self:getTraceCellByQuestId(single.id)
    if cell and cell.groupid then
      topIndex = index
      topCell = cell
    end
    if cell and cell.data and QuestProxy.Instance:checkIsShowDirAndDis(cell.data) and index < topIndex then
      topIndex = index
      topCell = cell
    end
  end
  return topCell
end

function MainViewTaskQuestPage:GetMinIndexTraceCellByQuestID(questids)
  if not questids then
    return
  end
  local topIndex = 9999
  local topCell
  for i = 1, #questids do
    local cell, index = self:getTraceCellByQuestId(questids[i])
    if cell and cell.data and QuestProxy.Instance:checkIsShowDirAndDis(cell.data) and topIndex > index then
      topIndex = index
      topCell = cell
    end
  end
  return topCell
end

function MainViewTaskQuestPage:QuestQuestStepUpdate(note)
  self:HandleStepUpdateQuestTraceBorad(note)
  local data = note.body
  local questId = data.id
  local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
  local traceStr = questData and questData:parseTranceInfo() or ""
  self:setQuestData(questData == nil)
  if traceStr == "" then
    return
  end
  if questData and (questData:IsPrequest(self.curProcessQuestId) or questData:checkMustPrequest(self.curProcessQuestId)) and QuestProxy.Instance:checkIsShowDirAndDis(questData) then
    self.onGoingQuestId = questData.id
  end
  self:selectShowDirQuest(self.onGoingQuestId)
  self:TryFoldSymboleWithFubenQuest()
end

function MainViewTaskQuestPage:ProcessChange(note)
  self:UpdateQuestTraceBorad(note)
  local data = note.body
  local questId = data.id
  local cell = self:getTraceCellByQuestId(questId)
  if cell then
    if cell.groupid then
      self:setQuestData()
      if questId ~= self.onGoingQuestId then
        helplog("onGoingQuestId", self.onGoingQuestId)
        cell:SetCurrentChooseQuest(questId)
        cell:UpdateCombinedQuestTraceInfo()
        self:stopShowDirAndDis(self.onGoingQuestId)
        self:ShowCombinedQuestDirAndDis(cell, true)
        return
      end
    else
      local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId, SceneQuest_pb.EQUESTLIST_ACCEPT)
      if questData then
        cell:SetData(questData)
        local updateList = cell.bgSizeChanged
        if updateList then
          self.taskQuestTable.repositionNow = true
        end
      end
    end
  end
  local isAutoBattle = Game.AutoBattleManager.on
  if not isAutoBattle and questId ~= self.onGoingQuestId and cell and cell.data and QuestProxy.Instance:checkIsShowDirAndDis(cell.data) then
    self:stopShowDirAndDis(self.onGoingQuestId)
    self:ShowDirAndDis(cell)
    return
  end
  self:selectShowDirQuest(self.onGoingQuestId, true)
end

function MainViewTaskQuestPage:selectShowDirQuest(id, noMove)
  local result = self:ShowDirAndDisByQuestId(id, noMove)
  if result then
    return true
  end
  return false
end

function MainViewTaskQuestPage:RemoveTraceInfo(traceData)
  if traceData then
    local id = traceData.id
    local type = traceData.type
    local cell, index = self:getTraceCellByQuestId(id, type)
    local resetPos = false
    if cell then
      resetPos = true
      self.questList:RemoveCell(index)
    end
    if resetPos then
      self.questList:Layout()
      self.scrollview:InvalidateBounds()
      self.scrollview:RestrictWithinBounds(true)
    end
  end
end

function MainViewTaskQuestPage:AddTraceInfo(traceData)
  if traceData then
    local id = traceData.id
    local type = traceData.type
    local list = QuestProxy.Instance:getValidAcceptQuestList(true)
    local traceDatas = QuestProxy.Instance:getTraceDatas()
    if traceDatas then
      for i = 1, #traceDatas do
        local single = traceDatas[i]
        table.insert(list, single)
      end
    end
    QuestProxy.Instance:SetTraceCellCount(#list)
    self:sortTraceDatas(list)
    local index = 1
    for j = 1, #list do
      local data = list[j]
      if id == data.id and type == data.type then
        index = j
        break
      end
    end
    local cell = self.questList:AddCell(traceData, index)
    cell.gameObject.transform:SetSiblingIndex(index - 1)
    self.questList:Layout()
    self.scrollview:InvalidateBounds()
    self.scrollview:RestrictWithinBounds(true)
  end
end

function MainViewTaskQuestPage:updateTraceInfo(traceData)
  if traceData then
    local id = traceData.id
    local type = traceData.type
    local cell = self:getTraceCellByQuestId(id, type)
    local resetPos = false
    if cell then
      cell:SetData(traceData)
      resetPos = cell.bgSizeChanged
    end
    if resetPos then
      self.questList:Layout()
    end
  end
end

function MainViewTaskQuestPage:MyStartHandInHand(isSelf)
  local handed, handowner = Game.Myself:IsHandInHand()
  self.isInHand = true
  if handed and not handowner then
    self:folderSymbol(false)
  end
end

function MainViewTaskQuestPage:MyStopHandInHand(isSelf)
  self.isInHand = false
  if not self.isInFuben then
    local handed, handowner = Game.Myself:IsHandInHand()
    if handed and not handowner then
      self:folderSymbol(true)
    end
  end
end

function MainViewTaskQuestPage:questCellDoubleClick(cellCtrl)
  if cellCtrl.groupid then
    self:stopShowDirAndDis(self.onGoingQuestId)
    self:ShowCombinedQuestDirAndDis(cellCtrl, false)
    Game.QuestMiniMapEffectManager:ShowMiniMapDirEffect(cellCtrl.curChoose.id)
    FunctionQuest.Me():executeQuest(cellCtrl.curChoose)
  end
end

function MainViewTaskQuestPage:questCellClick(cellCtrl)
  if cellCtrl.taskQuestType == "SpaceDragon" then
    self:stopShowDirAndDis(self.onGoingQuestId)
    cellCtrl:setISShowDir(true)
    return
  else
    self:UnClickDragonCell()
  end
  if not cellCtrl or not cellCtrl.data then
    return
  end
  if QuestProxy.Instance.questDebug then
    FunctionQuest.Me():executeQuest(cellCtrl.data, true)
    QuestProxy.Instance.lastQuestID = cellCtrl.data.id
    return
  end
  xdlog("当前选中任务", cellCtrl.data.id, cellCtrl.data.map)
  if Game.MapManager:IsRaidMode(true) and not Game.DungeonManager:IsPVPMode_EndlessBattleField() then
    local curID = Game.MapManager:GetRaidID() or 0
    if curID ~= cellCtrl.data.map then
      MsgManager.ShowMsgByIDTable(27002)
      GameFacade.Instance:sendNotification(GuideEvent.MapGuide_Change)
      return
    end
  end
  if cellCtrl.data.questListType == SceneQuest_pb.EQUESTLIST_CANACCEPT then
    return
  end
  local staticData = Table_Map[Game.MapManager:GetMapID()]
  if staticData ~= nil and WorldMapProxy.Instance:IsCloneMap() then
    ServiceMapProxy.Instance:CallChangeCloneMapCmd(staticData.CloneMap)
    return
  end
  local isShowDirAndDis = QuestProxy.Instance:checkIsShowDirAndDis(cellCtrl.data)
  if cellCtrl.groupid then
    self:stopShowDirAndDis(self.onGoingQuestId)
    self:ShowCombinedQuestDirAndDis(cellCtrl, true)
    Game.QuestMiniMapEffectManager:ShowMiniMapDirEffect(cellCtrl.curChoose.id)
    FunctionQuest.Me():executeQuest(cellCtrl.curChoose)
    return
  end
  if isShowDirAndDis then
    if cellCtrl.data.id ~= self.onGoingQuestId then
      self:stopShowDirAndDis(self.onGoingQuestId)
    end
    xdlog("hidelist", cellCtrl.data:IsHideInList())
    if not cellCtrl.data:IsHideInList() then
      self:ShowDirAndDis(cellCtrl)
    else
      self.onGoingQuestId = cellCtrl.data.id
      self.curProcessQuestId = cellCtrl.data.id
      cellCtrl:setISShowDir(true)
      return
    end
    Game.QuestMiniMapEffectManager:ShowMiniMapDirEffect(cellCtrl.data.id)
    FunctionQuest.Me():executeQuest(cellCtrl.data)
  else
    Game.QuestMiniMapEffectManager:ShowMiniMapDirEffect(cellCtrl.data.id)
    FunctionQuest.Me():executeQuest(cellCtrl.data, true)
  end
  self:RequestQuestTraceSymbol(cellCtrl.data.id)
end

function MainViewTaskQuestPage:recvCellClick(note)
  if not note or not note.body then
    return
  end
  local cellCtrl = note.body.cellCtrl
  if QuestProxy.Instance.questDebug then
    FunctionQuest.Me():executeQuest(cellCtrl.data)
    QuestProxy.Instance.lastQuestID = cellCtrl.data.id
    return
  end
  if self.isInFuben then
    local curID = Game.MapManager:GetRaidID() or 0
    if curID ~= cellCtrl.data.map then
      MsgManager.ShowMsgByIDTable(27002)
      return
    end
  end
  helplog("ClickTarget's QuestID", cellCtrl.data.id)
  local isShowDirAndDis = QuestProxy.Instance:checkIsShowDirAndDis(cellCtrl.data)
  if isShowDirAndDis then
    if cellCtrl.data.id ~= self.onGoingQuestId then
      self:stopShowDirAndDis(self.onGoingQuestId)
    end
    self:ShowDirAndDis(cellCtrl, true)
  else
    FunctionQuest.Me():executeQuest(cellCtrl.data)
  end
end

function MainViewTaskQuestPage:ShowDirAndDis(cellCtrl, noMove)
  self.onGoingQuestId = cellCtrl.data.id
  self.curProcessQuestId = cellCtrl.data.id
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
  if noMove or self:ObjIsNil(cellCtrl.gameObject) then
    return
  end
  local panel = self.scrollview.panel
  local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, cellCtrl.gameObject.transform)
  local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
  offset = Vector3(0, offset.y, 0)
  self.scrollview:MoveRelative(offset)
end

function MainViewTaskQuestPage:ShowCombinedQuestDirAndDis(cellCtrl, noSwitch)
  if cellCtrl.questList and #cellCtrl.questList > 0 then
    if cellCtrl.curChoose.id == self.onGoingQuestId and not noSwitch then
      cellCtrl:SwitchTracedQuestInCombinedGroup()
    end
    self.onGoingQuestId = cellCtrl.curChoose.id
    self.curProcessQuestId = cellCtrl.curChoose.id
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
    cellCtrl:setISShowDir(true)
    LocalSaveProxy.Instance:setLastTraceQuestId(self.onGoingQuestId)
    local panel = self.scrollview.panel
    local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, cellCtrl.gameObject.transform)
    local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
    offset = Vector3(0, offset.y, 0)
    self.scrollview:MoveRelative(offset)
  else
    redlog("questList长度不够")
    return
  end
end

function MainViewTaskQuestPage:getTraceCellByQuestId(id, type)
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

function MainViewTaskQuestPage:ShowDirAndDisByQuestId(id, noMove)
  if not id then
    return
  end
  local cellCtrl = self:getTraceCellByQuestId(id)
  if cellCtrl and QuestProxy.Instance:checkIsShowDirAndDis(cellCtrl.data) then
    self:ShowDirAndDis(cellCtrl, noMove)
    return true
  end
  self.onGoingQuestId = nil
  return false
end

function MainViewTaskQuestPage:stopShowDirAndDis(id)
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

function MainViewTaskQuestPage:handleMissionCommand(note)
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
  if oldQuestId and oldQuestId ~= newQuestId then
    local cell = self:getTraceCellByQuestId(oldQuestId)
    if cell then
      cell:setIsOngoing(false)
    end
  end
  if newQuestId and oldQuestId ~= newQuestId then
    local cell = self:getTraceCellByQuestId(newQuestId)
    if cell then
      cell:setIsOngoing(true)
    end
  end
end

function MainViewTaskQuestPage:setQuestData(resetPos, noAppearAm)
  local questIns = QuestProxy.Instance
  questIns:checkIfNeedRemoveGuideView()
  if not Game.Myself or not Game.Myself then
    self.questList:RemoveAll()
    return
  end
  local totalList = questIns:getValidAcceptQuestList(nil, self.mapLimitGroup)
  local totalValidQuestCount = #totalList
  local curWorldQuestGroup = Game.MapManager:getCurWorldQuestGroup()
  local isCurWorldGroupAllFinish = Game.MapManager:GetWorldQuestProcessAllFinish(curWorldQuestGroup)
  local list = {}
  if totalList and 0 < #totalList then
    for i = 1, #totalList do
      local single = totalList[i]
      if single.nInvadeStyle then
        table.insert(list, single)
      else
        local status = questIns:CheckQuestIsTrace(single.id)
        if curWorldQuestGroup and not isCurWorldGroupAllFinish then
          if status and status == 3 then
            local version = Table_WorldQuest[single.id] and Table_WorldQuest[single.id].Version
            if version == curWorldQuestGroup then
              table.insert(list, single)
            end
          elseif status and status == 1 then
            table.insert(list, single)
          end
        elseif status and status == 1 then
          table.insert(list, single)
        end
      end
    end
  end
  local traceDatas = questIns:getTraceDatas()
  if traceDatas and not self.mapLimitGroup then
    for i = 1, #traceDatas do
      table.insert(list, traceDatas[i])
    end
  end
  questIns:SetTraceCellCount(#list)
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
  if not list or #list == 0 then
    if 0 < self:GetCount_extraInfoTrace() then
      self:Show(self.taskQuestBG)
      self:Hide(self.noTracingTip)
    elseif 0 < totalValidQuestCount then
      self:Show(self.taskQuestBG)
      self:Show(self.noTracingTip)
    else
      self:Hide(self.taskQuestBG)
      self:Hide(self.noTracingTip)
    end
    self.questList:RemoveAll()
    return
  else
    self:Show(self.taskQuestBG)
    self:Hide(self.noTracingTip)
  end
  list = self:sortRepeatedData(list)
  self:sortTraceDatas(list)
  if #list == 1 then
    list[#list + 1] = {emptyCell = true}
  end
  self.questList:ResetDatas(list)
  self.taskQuestTable.repositionNow = true
  questIns:checkIfNeedStopMissionTrigger()
  if resetPos then
    self.scrollview:ResetPosition()
  end
  local curCmdData = FunctionQuest.Me():getCurCmdData()
  if curCmdData then
    self:setQuestIsOngoing(curCmdData, true)
  end
  if not noAppearAm then
    self:playAppearAnm()
  end
  if questIns.questDebug and questIns.lastQuestID then
    local questData = questIns:GetQuestDataBySameQuestID(questIns.lastQuestID)
    if questData then
      FunctionQuest.Me():executeQuest(questData)
      return
    end
    local cells = self.questList:GetCells()
    local cell = cells[1]
    if cell then
      questData = cell.data
    else
      questData = questIns:GetCanAutoExeQuest()
    end
    if questData then
      FunctionQuest.Me():executeQuest(questData)
      questIns.lastQuestID = questData.id
    end
  end
end

function MainViewTaskQuestPage:sortRepeatedData(list)
  local tempResult = ReusableTable.CreateTable()
  local Result = ReusableTable.CreateTable()
  local finishList = QuestProxy.Instance:getQuestListInOrder(SceneQuest_pb.EQUESTLIST_SUBMIT)
  if 0 < #list then
    for i = 1, #list do
      local single = list[i]
      local questid = list[i].id
      local singleItem = tempResult[questid]
      if single.finishData then
        local traceGroupID = single.finishData.QuestKey
        if not tempResult[traceGroupID] then
          tempResult[traceGroupID] = {}
          tempResult[traceGroupID].isCombined = true
          tempResult[traceGroupID].curTraceQuest = self.onGoingQuestId
          tempResult[traceGroupID].groupid = traceGroupID
          tempResult[traceGroupID].nInvadeStyle = QuestProxy.Instance:GetNInvadeTraceStyle(traceGroupID)
          tempResult[traceGroupID].nInvadeFinishTraceList = QuestProxy.Instance:GetNInvadeTraceList(traceGroupID)
          if tempResult[traceGroupID].nInvadeStyle then
            tempResult[traceGroupID].SortOrder = 999
          end
          if not tempResult[traceGroupID].type then
            tempResult[traceGroupID].type = single.type
          end
          if not tempResult[traceGroupID].orderId then
            tempResult[traceGroupID].orderId = questid
          end
          if not tempResult[traceGroupID].IconFromServer then
            tempResult[traceGroupID].IconFromServer = single.staticData and single.staticData.IconFromServer
          end
          tempResult[traceGroupID].questList = {}
          single.isFinish = false
          table.insert(tempResult[traceGroupID].questList, single)
        else
          single.isFinish = false
          table.insert(tempResult[traceGroupID].questList, single)
        end
      else
        if single.type == QuestDataType.QuestDataType_SPACEDRAGON then
          single.SortOrder = 9999
        end
        tempResult[questid] = single
        tempResult[questid].isCombined = false
      end
    end
  end
  for i = 1, #finishList do
    local single = finishList[i]
    if single.finishData then
      local traceGroupID = single.finishData.QuestKey
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

function MainViewTaskQuestPage:playAppearAnm()
  local cells = self.questList:GetCells()
  for i = 1, #cells do
    local single = cells[i]
    local data = single.data
    if data then
      self:playTaskAppearAnm(single)
    end
  end
end

local func = function(t1, t2)
  local t1SortOrder = t1.SortOrder or 0
  local t2SortOrder = t2.SortOrder or 0
  if t1SortOrder ~= t2SortOrder then
    return t1SortOrder > t2SortOrder
  end
  if t1.type == t2.type then
    if t1.type == QuestDataType.QuestDataType_WANTED then
      return t1.time > t2.time
    else
      if not QuestSymbolSortWeight then
        return t1.orderId < t2.orderId
      end
      local leftWeight = t1.staticData and t1.staticData.IconFromServer and QuestSymbolSortWeight[t1.staticData.IconFromServer] or 0
      local rightWeight = t2.staticData and t2.staticData.IconFromServer and QuestSymbolSortWeight[t2.staticData.IconFromServer] or 0
      if leftWeight == rightWeight then
        return t1.orderId < t2.orderId
      else
        return leftWeight > rightWeight
      end
    end
  elseif t1.type ~= t2.type then
    local leftWeight, rightWeight
    if QuestSymbolSortWeight then
      leftWeight = t1.IconFromServer and QuestSymbolSortWeight[t1.IconFromServer] or t1.staticData and t1.staticData.IconFromServer and QuestSymbolSortWeight[t1.staticData.IconFromServer] or 0
      rightWeight = t2.IconFromServer and QuestSymbolSortWeight[t2.IconFromServer] or t2.staticData and t2.staticData.IconFromServer and QuestSymbolSortWeight[t2.staticData.IconFromServer] or 0
      if leftWeight ~= rightWeight then
        return leftWeight > rightWeight
      end
    end
    if QuestDataTypeSortWeight then
      leftWeight = QuestDataTypeSortWeight[t1.type] or 0
      rightWeight = QuestDataTypeSortWeight[t2.type] or 0
      if leftWeight ~= rightWeight then
        return leftWeight > rightWeight
      end
    end
    return t1.orderId < t2.orderId
  end
end

function MainViewTaskQuestPage:sortTraceDatas(questList)
  if questList ~= nil and #questList ~= 0 then
    table.sort(questList, func)
  end
end

function MainViewTaskQuestPage:addItemTraces(list, itemTrs)
  if itemTrs then
    for i = 1, #itemTrs do
      local single = itemTrs[i]
      table.insert(list, single)
    end
  end
end

function MainViewTaskQuestPage:handleDeathStatus(note)
end

function MainViewTaskQuestPage:FuBenCmdTrackFuBenUserCmd(note)
  self.isInFuben = true
  self:folderSymbol(false)
end

function MainViewTaskQuestPage:folderSymbol(state)
  if not self.playTweens then
    return
  end
  local curID = Game.MapManager:GetRaidID() or 0
  self.curFolderState = state
  if not state and self.rotationTwn.tweenFactor == 0 and not self:CheckIfHasRaidQuest() then
    for i = 1, #self.playTweens do
      local single = self.playTweens[i]
      single:Play(true)
    end
  elseif state and self.rotationTwn.tweenFactor == 1 then
    for i = 1, #self.playTweens do
      local single = self.playTweens[i]
      single:Play(true)
    end
  end
end

function MainViewTaskQuestPage:CheckIfHasRaidQuest()
  local cells = self.questList:GetCells()
  if not cells or #cells == 0 then
    return
  end
  local curID = Game.MapManager:GetRaidID() or 0
  for i = 1, #cells do
    local single = cells[i]
    local data = single.data
    if data and curID == data.map then
      return true
    end
  end
end

function MainViewTaskQuestPage:OnExit()
  MainViewTaskQuestPage.super.OnExit(self)
  EventManager.Me():RemoveEventListener(FunctionQuest.UpdateTraceInfo, self.updateTraceInfo, self)
  EventManager.Me():RemoveEventListener(FunctionQuest.RemoveTraceInfo, self.RemoveTraceInfo, self)
  EventManager.Me():RemoveEventListener(FunctionQuest.AddTraceInfo, self.AddTraceInfo, self)
  EventManager.Me():RemoveEventListener(HandEvent.MyStartHandInHand, self.MyStartHandInHand, self)
  EventManager.Me():RemoveEventListener(HandEvent.MyStopHandInHand, self.MyStopHandInHand, self)
  EventManager.Me():RemoveEventListener(HandEvent.SceneGoToUserCmdHanded, self.SceneGoToUserCmd, self)
  EventManager.Me():RemoveEventListener(MyselfEvent.MissionCommandChanged, self.handleMissionCommand, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.ItemGetCountItemCmd, self.OnInvadeItemUpdate, self)
  TimeTickManager.Me():ClearTick(self)
end

function MainViewTaskQuestPage:handlePlayerMapChange(note)
  MyselfProxy.Instance:SetQuestRepairMode(false)
  Game.MapManager:SetCurWorldQuestGroup()
  self:RefreshMapLimitQuest()
  self:RefreshFakeWorldQuestTrace()
  self:setQuestData(true)
  self:ActiveQuestTraceSymbol(false)
  local currentDungeon = Game.DungeonManager.currentDungeon
  local raidTraceValidMap = GameConfig.RaidTrace and GameConfig.RaidTrace.Type or {}
  local curRaidId = ServicePlayerProxy.Instance:GetCurMapImageId() or 0
  if 0 ~= curRaidId then
    local raidConfig = Table_MapRaid[curRaidId]
    local showTrace = raidConfig and raidConfig.Feature and 0 < raidConfig.Feature & 2 or false
    if not showTrace then
      self.isInFuben = true
      self:SetAllQuestCellSelected(false)
      if currentDungeon then
        if 0 < TableUtility.ArrayFindIndex(raidTraceValidMap, raidConfig.Type) then
          GameFacade.Instance:sendNotification(MainViewEvent.AddDungeonInfoBord, "MainViewRaidInfoPage")
        end
      else
        GameFacade.Instance:sendNotification(MainViewEvent.AddDungeonInfoBord, "MainViewRaidInfoPage")
      end
      return
    end
  end
  if note.type == LoadSceneEvent.StartLoad then
    self.isInFuben = false
    self:folderSymbol(true)
    self:selectShowDirQuest(self.onGoingQuestId)
    GameFacade.Instance:sendNotification(MainViewEvent.RemoveDungeonInfoBord, "MainViewRaidInfoPage")
    return
  end
  self:MapChange()
  local data = note.body
  if data.dmapID == 0 then
    if not self.isInHand then
      self:folderSymbol(true)
    end
    self.isInFuben = false
    GameFacade.Instance:sendNotification(MainViewEvent.RemoveDungeonInfoBord, "MainViewRaidInfoPage")
    self:sendNotification(UIEvent.CloseUI, DeathPopView.ViewType)
  else
    local raidConfig = Table_MapRaid[data.dmapID]
    local showTrace = raidConfig and raidConfig.Feature and 0 < raidConfig.Feature & 2
    if not showTrace then
      self.isInFuben = true
      self:SetAllQuestCellSelected(false)
      if currentDungeon then
        if 0 < TableUtility.ArrayFindIndex(raidTraceValidMap, raidConfig.Type) then
          GameFacade.Instance:sendNotification(MainViewEvent.AddDungeonInfoBord, "MainViewRaidInfoPage")
        end
      else
        GameFacade.Instance:sendNotification(MainViewEvent.AddDungeonInfoBord, "MainViewRaidInfoPage")
      end
    else
      self.isInFuben = false
      self:folderSymbol(true)
      GameFacade.Instance:sendNotification(MainViewEvent.RemoveDungeonInfoBord, "MainViewRaidInfoPage")
    end
  end
  QuestProxy.Instance:RemoveDahuangQuestDataByMapId(Game.MapManager:GetMapID())
end

function MainViewTaskQuestPage:OnFinishLoadScene()
  if not PvpObserveProxy.Instance:IsRunning() then
    if Game.MapManager:IsMapForbid() then
      self:HideMapForbidNode()
    else
      self:ShowMapForbidNode()
    end
  end
end

function MainViewTaskQuestPage:HideMapForbidNode()
  self.questTraceBoard:SetActive(false)
  self:sendNotification(MainViewEvent.HideMapForbidNode)
end

function MainViewTaskQuestPage:ShowMapForbidNode()
  if self.questTraceBoardCell and self.questTraceBoardCell.isMainViewTrace and self.showQuestTraceCell then
    if not self.questTraceBoardCell:CheckHideSelf() then
      self:questTraceCellShow()
    else
      self:questTraceCellClose()
    end
    self.questTraceBoard:SetActive(not self.questTraceBoardCell:CheckHideSelf())
  end
  self:sendNotification(MainViewEvent.ShowMapForbidNode)
end

function MainViewTaskQuestPage:SetAllQuestCellSelected(bRet)
  local cells = self.questList:GetCells()
  for i = 1, #cells do
    cells[i]:setISShowDir(bRet)
  end
  if not bRet then
    self:stopShowDirAndDis(self.onGoingQuestId)
  end
end

function MainViewTaskQuestPage:HandleManualGoEffect(note)
  local body = note.body
  if not body or not body.questid then
    return
  end
  local questId = body.questid
  local cellCtrl = self:getTraceCellByQuestId(questId)
  if not cellCtrl then
    return
  end
  self:stopShowDirAndDis(self.onGoingQuestId)
  local args = ReusableTable.CreateTable()
  local questData = cellCtrl.data
  args.questData = questData
  args.owner = cellCtrl
  args.callback = cellCtrl.Update
  FunctionQuestDisChecker.Me():AddQuestCheck(args)
  ReusableTable.DestroyAndClearTable(args)
  cellCtrl:setISShowDir(true)
  self.onGoingQuestId = cellCtrl.data.id
  self.curProcessQuestId = cellCtrl.data.id
  LocalSaveProxy.Instance:setLastTraceQuestId(self.onGoingQuestId)
  if cellCtrl and QuestProxy.Instance:checkIsShowDirAndDis(cellCtrl.data) then
    self:ShowDirAndDis(cellCtrl, noMove)
  end
  if not self:ObjIsNil(cellCtrl.gameObject) then
    local panel = self.scrollview.panel
    local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, cellCtrl.gameObject.transform)
    local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
    offset = Vector3(0, offset.y, 0)
    self.scrollview:MoveRelative(offset)
  end
end

function MainViewTaskQuestPage:MapChange()
  local cellCtrl = self:getTraceCellByQuestId(self.onGoingQuestId)
  if cellCtrl and cellCtrl.data then
    if self.isInFuben then
      local curID = Game.MapManager:GetRaidID() or 0
      if curID ~= cellCtrl.data.map then
        FunctionQuest.Me():refreshQuestMiniShow()
        return
      end
    end
    FunctionQuest.Me():addQuestMiniShow(cellCtrl.data)
    self:RequestQuestTraceSymbol(cellCtrl.data.id)
  elseif self.isInFuben then
    FunctionQuest.Me():refreshQuestMiniShow()
  end
end

function MainViewTaskQuestPage:SceneGoToUserCmd()
  self:MapChange()
end

function MainViewTaskQuestPage:QuestQuestList(note)
  if not self.hasInitSelected then
    self:setQuestData(true)
    local id = LocalSaveProxy.Instance:getLastTraceQuestId()
    local selectSuc = self:selectShowDirQuest(id)
    if selectSuc then
      self.hasInitSelected = true
      self.onGoingQuestId = id
    end
  else
    self:setQuestData(false)
  end
  self:TryFoldSymboleWithFubenQuest()
  self:TryRefreshFixedTrigger()
end

function MainViewTaskQuestPage:CheckWorldQuestMap()
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

function MainViewTaskQuestPage:handleDahuangQuestStepSyncUpdate(note)
  local list, needRefresh = QuestProxy.Instance:GetTraceDahuangQuestData()
  if needRefresh then
    self:setQuestData()
    self.onGoingQuestId = list[1] and list[1].id
    self.curProcessQuestId = self.onGoingQuestId
    local panel = self.scrollview.panel
    local cellCtrl = self:getTraceCellByQuestId(list[1].id)
    if not cellCtrl then
      return
    end
    local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, cellCtrl.gameObject.transform)
    local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
    offset = Vector3(0, offset.y, 0)
    self.scrollview:MoveRelative(offset)
  end
end

function MainViewTaskQuestPage:handleDahuangQuestStepUpdate(note)
  local data = note.body
  local delList = data.del_stepid
  local list, needRefresh = QuestProxy.Instance:GetTraceDahuangQuestData()
  if delList and 0 < #delList then
    for i = 1, #delList do
      local single = delList[i]
      if Table_MapStep[single] and Table_MapStep[single].Params and Table_MapStep[single].Params.TraceInfo then
        needRefresh = true
        break
      end
    end
  end
  if needRefresh then
    self:setQuestData()
    self.onGoingQuestId = list and list[1] and list[1].id or nil
    self.curProcessQuestId = self.onGoingQuestId
    local panel = self.scrollview.panel
    local cellCtrl = self:getTraceCellByQuestId(self.onGoingQuestId)
    if not cellCtrl then
      return
    end
    local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, cellCtrl.gameObject.transform)
    local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
    offset = Vector3(0, offset.y, 0)
    self.scrollview:MoveRelative(offset)
  end
end

function MainViewTaskQuestPage:TryRefreshFixedTrigger()
  local config = Game.Config_TaskLimit
  if not config then
    return
  end
  local mapId = Game.MapManager:GetMapID()
  local ids = config[mapId]
  if not ids then
    return
  end
  Game.AreaTrigger_Common:Refresh_RaidCheckArea()
end

function MainViewTaskQuestPage:questTraceCellShow()
  self.taskQuestTween.from = LuaGeometry.GetTempVector3(-150, -67, 0)
  self.taskQuestTween.to = LuaGeometry.GetTempVector3(200, -67, 0)
  LuaVector3.Better_Set(tempVector3, LuaGameObject.GetLocalPosition(self.taskQuestTweenTrans))
  tempVector3[2] = -67
  self.taskQuestTweenTrans.localPosition = tempVector3
  LuaVector3.Better_Set(tempVector3, LuaGameObject.GetLocalPosition(self.foldCtTrans))
  tempVector3[2] = -215
  self.foldCtTrans.localPosition = tempVector3
end

function MainViewTaskQuestPage:questTraceCellClose()
  self.taskQuestTween.from = LuaGeometry.GetTempVector3(-150, 0, 0)
  self.taskQuestTween.to = LuaGeometry.GetTempVector3(200, 0, 0)
  LuaVector3.Better_Set(tempVector3, LuaGameObject.GetLocalPosition(self.taskQuestTweenTrans))
  tempVector3[2] = 0
  self.taskQuestTweenTrans.localPosition = tempVector3
  LuaVector3.Better_Set(tempVector3, LuaGameObject.GetLocalPosition(self.foldCtTrans))
  tempVector3[2] = -150
  self.foldCtTrans.localPosition = tempVector3
end

function MainViewTaskQuestPage:RefreshMapLimitQuest()
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

function MainViewTaskQuestPage:handleNewMenu()
  self:RefreshMapLimitQuest()
  self:setQuestData(true)
end

function MainViewTaskQuestPage:RefreshFakeWorldQuestTrace()
  local worldQuestGroup = Game.MapManager:getCurWorldQuestGroup()
  QuestProxy.Instance:RefreshFakeTrace(worldQuestGroup)
end

function MainViewTaskQuestPage:RecvClientTraceList()
  xdlog("接收客户端追踪")
end

function MainViewTaskQuestPage:HandleMyselfRelive()
  local raidQuests = QuestProxy.Instance.fubenQuestMap
  for k, single in pairs(raidQuests) do
    if single.questDataStepType == "puzzle" then
      local action = single.params.action
      if action == "buffreward" then
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.RaidPuzzleChooseBuffView,
          viewdata = single
        })
      end
    end
  end
end

function MainViewTaskQuestPage:HandleQuestRepairMode(note)
  local data = note.body
  xdlog(data)
  self.foldRedTip:SetActive(data)
end

function MainViewTaskQuestPage:focusOnTargetQuest(note)
  local questID = note.body
  local cellCtrl = self:getTraceCellByQuestId(questID)
  if not cellCtrl then
    return
  end
  local panel = self.scrollview.panel
  local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, cellCtrl.gameObject.transform)
  local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
  offset = Vector3(0, offset.y, 0)
  self.scrollview:MoveRelative(offset)
end

function MainViewTaskQuestPage:ShowServantImproveQuestTraceBorad(note)
  self.questTraceBoard:SetActive(true)
  self.questTraceBoardCell:SetData(note.data)
  self.questTraceBoardCell:SetIsMainViewTrace(true)
  self.showQuestTraceCell = true
  EventManager.Me():DispatchEvent(ServantImproveEvent.GoClick, self)
  self:questTraceCellShow()
end

function MainViewTaskQuestPage:ShowShortCutTraceCell(note)
  self.questTraceBoard:SetActive(true)
  self.questTraceBoardCell:SetData(note.data)
  self.questTraceBoardCell:SetIsMainViewTrace(true)
  self.showQuestTraceCell = true
  EventManager.Me():DispatchEvent(ServantImproveEvent.GoClick, self)
  self:questTraceCellClose()
end

function MainViewTaskQuestPage:ShowQuestTraceBorad(cell)
  self.questTraceBoard:SetActive(true)
  self.questTraceBoardCell:SetData(cell.data.data)
  self.questTraceBoardCell:SetIsMainViewTrace(true)
  self.showQuestTraceCell = true
  EventManager.Me():DispatchEvent(QuestManualEvent.GoClick, self)
  self:questTraceCellShow()
end

function MainViewTaskQuestPage:QuestUpdateTraceBorad(note)
  if self.questTraceBoard.activeSelf then
    local newQuestData = QuestProxy.Instance:getSameQuestID(self.questTraceBoardCell.questId)
    if newQuestData then
      local cellData = {
        questData = newQuestData,
        type = newQuestData.questListType
      }
      self.questTraceBoardCell:SetData(cellData)
    end
  end
end

function MainViewTaskQuestPage:UpdateQuestTraceBorad(note)
  if self.questTraceBoardCell.isMainViewTrace then
    local data = note.body
    local questId = data.id
    if questId == self.questTraceBoardCell.questId then
      local newQuestData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
      if newQuestData then
        local cellData = {
          questData = newQuestData,
          type = newQuestData.questListType
        }
        self.questTraceBoardCell:SetData(cellData)
        if self.needClearCmd then
          FunctionQuest.Me():handleMissShutdown()
        end
        if newQuestData.questDataStepType == QuestDataStepType.QuestDataStepType_KILL or newQuestData.questDataStepType == QuestDataStepType.QuestDataStepType_GATHER then
          self.needClearCmd = true
        else
          self.needClearCmd = false
        end
      end
    end
  end
end

function MainViewTaskQuestPage:HandleStepUpdateQuestTraceBorad(note)
  if self.questTraceBoardCell.isMainViewTrace then
    local data = note.body
    local questId = data.id
    if questId == self.questTraceBoardCell.questId then
      local newQuestData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
      if newQuestData then
        if self.needClearCmd then
          FunctionSystem.InterruptMyselfAI()
        end
        if newQuestData.questDataStepType == QuestDataStepType.QuestDataStepType_KILL or newQuestData.questDataStepType == QuestDataStepType.QuestDataStepType_GATHER then
          self.needClearCmd = true
        else
          self.needClearCmd = false
        end
      end
    end
  end
  self:UpdateQuestTraceBorad(note)
end

function MainViewTaskQuestPage.QuestTraceItemSortFunc(a, b)
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

function MainViewTaskQuestPage:checkQuestForceToIgnore(questid)
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

function MainViewTaskQuestPage:RefreshTraceMark()
  if self.data.type == SceneQuest_pb.EQUESTLIST_ACCEPT then
    local result = self:CheckCanMove()
    if not result.hideall then
      self:SetTextureWhite(self.traceMark, Color(0.4549019607843137, 0.9686274509803922, 1))
      self.traceMark_BoxCollider.enabled = true
    else
      self:SetTextureGrey(self.traceMark)
      self.traceMark_BoxCollider.enabled = false
    end
    if not result.hideall then
      self.traceicon:SetActive(not result.canmove)
    end
    self.questState:SetActive(false)
  elseif self.data.type == SceneQuest_pb.EQUESTLIST_CANACCEPT then
    self:SetTextureGrey(self.traceMark)
    self.traceMark_BoxCollider.enabled = false
    self.questState:SetActive(false)
  elseif self.data.type == SceneQuest_pb.EQUESTLIST_SUBMIT then
    self:SetTextureGrey(self.traceMark)
    self.traceMark_BoxCollider.enabled = false
    self.questState:SetActive(true)
  elseif self.data.type == "branch" then
    local result = self:CheckCanMove()
    if not result.hideall then
      self:SetTextureWhite(self.traceMark, Color(0.4549019607843137, 0.9686274509803922, 1))
      self.traceMark_BoxCollider.enabled = true
    else
      self:SetTextureGrey(self.traceMark)
      self.traceMark_BoxCollider.enabled = false
    end
    if not result.hideall then
      self.traceicon:SetActive(not result.canmove)
    end
    self.questState:SetActive(false)
  else
    self:SetTextureGrey(self.traceMark)
    self.traceMark_BoxCollider.enabled = false
    self.questState:SetActive(false)
  end
end

function MainViewTaskQuestPage:TryTraceQuest(questData)
  if not questData then
    return
  end
  if questData.type == QuestDataType.QuestDataType_SEALTR or questData.type == QuestDataType.QuestDataType_ITEMTR or questData.type == QuestDataType.QuestDataType_HelpTeamQuest or questData.type == QuestDataType.QuestDataType_INVADE or questData.type == QuestDataType.QuestDataType_ACTIVITY_TRACEINFO or questData.type == QuestDataType.QuestDataType_DAHUANG then
    return
  end
  local data = {}
  data.data = {
    questData = questData,
    type = questData.questListType
  }
  EventManager.Me():DispatchEvent(QuestManualEvent.BeforeGoClick, data)
end

function MainViewTaskQuestPage:questTraceSwitch(note)
  local data = note.body
  if data then
    self:setQuestData()
    local str = string.format(ZhString.QuestTraceCell_TraceQuestTip, data.traceTitle)
    MsgManager.FloatMsg(nil, str)
    local cellCtrl = self:getTraceCellByQuestId(data.id)
    if cellCtrl and QuestProxy.Instance:checkIsShowDirAndDis(cellCtrl.data) then
      self:questCellClick(cellCtrl)
    else
      xdlog("不在列表，直接执行")
      FunctionQuest.Me():executeQuest(data)
    end
  end
end

function MainViewTaskQuestPage:checkQuestTraceHide(questid)
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

function MainViewTaskQuestPage:RegisterGuide()
  self:AddOrRemoveGuideId(self.traceMark_Icon.gameObject, 451)
  self:AddOrRemoveGuideId(self.noTracingTip, 494)
end

function MainViewTaskQuestPage:QuestTraceGuide()
  local hasShowGuide = FunctionPlayerPrefs.Me():GetBool("TraceGuide" .. Game.Myself.data.id) or false
  if not hasShowGuide then
    local instance = GuideMaskView.Instance
    if not instance and not self.traceGuideEffect then
      self.guideEffPath = ResourcePathHelper.EffectUI(EffectMap.UI.HlightBoxType2)
      self.traceGuideEffect = Game.AssetManager_UI:CreateAsset(self.guideEffPath, self.noTracingTip)
    end
  end
end

function MainViewTaskQuestPage:QuestNotice()
  self.questNotice:SetActive(true)
  self.questNotice_Tween:ResetToBeginning()
  self.questNotice_Tween:PlayForward()
  self:CheckPointNotice()
end

function MainViewTaskQuestPage:RequestQuestTraceSymbol(questid)
  self.currentQuestID = questid
  if questid ~= nil then
    self.disappearQuestTraceSymbolTime = UnityTime + 120
    self:ActiveQuestTraceSymbol(true)
    if self.timetick == nil then
      local interval = FunctionPerformanceSetting.Me():GetTargetFrameRateInterval()
      self.timetick = TimeTickManager.Me():CreateTick(0, interval, self.UpdateQuestTraceSymbol, self)
    end
  else
    self.disappearQuestTraceSymbolTime = nil
    self:ActiveQuestTraceSymbol(false)
    if self.timeTick ~= nil then
      self.timetick:Destroy()
      self.timetick = nil
    end
  end
end

function MainViewTaskQuestPage:ActiveQuestTraceSymbol(active)
  if self.questTraceSymbolActive ~= active then
    self.questTraceSymbolActive = active
    self.questTraceSymbol:SetActive(active)
    if active then
      self:PlayUIEffect(EffectMap.UI.QuestTraceSymbol, self.questTraceSymbol, true)
    end
  end
end

function MainViewTaskQuestPage:UpdateQuestTraceSymbol()
  if self.currentQuestID == nil then
    return
  end
  if not self.questTraceSymbolActive then
    return
  end
  if UnityTime >= self.disappearQuestTraceSymbolTime then
    self:RequestQuestTraceSymbol()
    return
  end
  local myPos = Game.Myself:GetPosition()
  local targetPos = FunctionQuestDisChecker.Me():getTargetPos(self.currentQuestID)
  if myPos == nil or targetPos == nil then
    self:RequestQuestTraceSymbol()
    return
  end
  local distance = VectorUtility.DistanceXZ(myPos, targetPos)
  if distance <= 1 then
    self:RequestQuestTraceSymbol()
    return
  end
  local mainCamera = Game.GameObjectManagers[Game.GameObjectType.Camera]:GetCamera(GOManager_Camera.CameraID.MainCamera)
  if mainCamera == nil then
    return
  end
  local uiCamera = UIManagerProxy.Instance.uiCamera
  if uiCamera == nil then
    return
  end
  local fromPos = LuaGeometry.GetTempVector3(myPos[1], myPos[2] + 1.3, myPos[3])
  local pos, angleZ, isOffScreen = WayPointerUtil.CalcWayPointerParamsForNGUI(mainCamera, uiCamera, fromPos, targetPos, true)
  self.questTraceSymbolTrans.position = pos
  if self.questTraceSymbolAngleZ == nil or 1 < self.questTraceSymbolAngleZ - angleZ or 1 < angleZ - self.questTraceSymbolAngleZ then
    self.questTraceSymbolAngleZ = angleZ
    self.questTraceContainer.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, angleZ)
    self.questTraceDistanceTrans.eulerAngles = LuaGeometry.GetTempVector3(0, 0, 0)
  end
  if self.questTraceSymbolDistance == nil or 1 < self.questTraceSymbolDistance - distance or 1 < distance - self.questTraceSymbolDistance then
    self.questTraceSymbolDistance = distance
    self.questTraceDistance.text = string.format("%dm", distance)
  end
end

function MainViewTaskQuestPage:OnInvadeItemUpdate(note)
  if not self.questList then
    return
  end
  local cells = self.questList:GetCells()
  for i = 1, #cells do
    cells[i]:UpdateInvadeProgress()
  end
end

function MainViewTaskQuestPage:GetCount_extraInfoTrace()
  local count = 0
  if self.extraInfoCells then
    for _, cell in pairs(self.extraInfoCells) do
      if cell.gameObject.activeSelf then
        count = count + 1
      end
    end
  end
  return count
end

function MainViewTaskQuestPage:initView_extraInfoTrace()
  self.extraTop = self:FindGO("extraTop", self.gameObject)
end

function MainViewTaskQuestPage:ResetDatas_extraInfoTrace()
  self:UpdateExtraInfoTrace_TypeEscort()
  self:UpdateExtraInfoTrace_TypeSpaceDragon()
  if self:GetCount_extraInfoTrace() > 0 then
    self:Show(self.taskQuestBG)
    self:Hide(self.noTracingTip)
  elseif self.gameObject.activeSelf then
    self:setQuestData()
  end
end

function MainViewTaskQuestPage:UpdateExtraInfoTrace_TypeEscort()
  local data = {
    data = FunctionTrainEscort.Me().escortActData,
    is_open = FunctionTrainEscort.Me().is_open,
    is_inEscortMap = FunctionTrainEscort.Me().is_inEscortMap,
    clientState = FunctionTrainEscort.Me().clientState
  }
  self:UpdateExtraInfoTrace("TrainEscort", data)
end

function MainViewTaskQuestPage:UpdateExtraInfoTrace(type, data)
  if self.extraInfoCells then
    local cell = self.extraInfoCells[type]
    if cell then
      cell:SetData(data)
      self.taskQuestTable.repositionNow = true
      return
    end
  end
  self:CreateExtraInfoTrace(type, data)
end

function MainViewTaskQuestPage:CreateExtraInfoTrace(type, data)
  local cell
  if type == "TrainEscort" then
    cell = self:CreateExtraInfoTrace_TrainEscort(data)
  end
  if type == "SpaceDragon" then
    cell = self:CreateExtraInfoTrace_SpaceDragon(data)
  end
  if cell then
    if not self.extraInfoCells then
      self.extraInfoCells = {}
    end
    self.extraInfoCells[type] = cell
    cell.gameObject.transform:SetSiblingIndex(0)
    self.taskQuestTable.repositionNow = true
    if cell.gameObject.activeInHierarchy then
      self.scrollview:InvalidateBounds()
      self.scrollview:RestrictWithinBounds(true)
      self.scrollview:ResetPosition()
    end
  end
end

function MainViewTaskQuestPage:CreateExtraInfoTrace_TrainEscort(data)
  local go = self:LoadPreferb("cell/TaskQuestExtraCell_TrainEscort", self.extraTop)
  autoImport("TaskQuestExtraCell_TrainEscort")
  local cell = TaskQuestExtraCell_TrainEscort.new(go)
  cell:SetData(data)
  return cell
end

function MainViewTaskQuestPage:HandleHotKeyQuestGuide()
  local cellCtrl = self:getTraceCellByQuestId(self.onGoingQuestId)
  if not cellCtrl then
    return
  end
  self:questCellClick(cellCtrl)
end

function MainViewTaskQuestPage:CheckPointNotice()
  self:HideNotice()
  if self.lvType then
    if self.noticeLt then
      TimeTickManager.Me():ClearTick(self, 20)
      self.noticeLt = nil
    end
    self.noticeLt = TimeTickManager.Me():CreateOnceDelayTick(3000, function(owner, deltaTime)
      self:TryShowNewPointNotice()
    end, self, 20)
  end
end

function MainViewTaskQuestPage:NewPointNotice(note)
  self:TryShowNewPointNotice()
end

function MainViewTaskQuestPage:TryShowNewPointNotice()
  local leftPt = Game.Myself.data.userdata:Get(UDEnum.TOTALPOINT) or 0
  if 15 <= leftPt then
    self.lvType = SceneUserEvent.BaseLevelUp
    self:ShowNewPointNotice()
    return
  end
  leftPt = Game.Myself.data.userdata:Get(UDEnum.SKILL_POINT) or 0
  if 2 <= leftPt then
    self.lvType = SceneUserEvent.JobLevelUp
    self:ShowNewPointNotice()
    return
  end
  self:HideNotice()
end

function MainViewTaskQuestPage:ShowNewPointNotice()
  if not self.lvType then
    return
  end
  if not self.noticeShowed then
    self.addPointNotice:SetActive(true)
    self.pointNotice_Tween:ResetToBeginning()
    self.pointNotice_Tween:PlayForward()
    self.noticeShowed = true
  end
  if self.lvType == SceneUserEvent.BaseLevelUp then
    self.AddPointLabel.text = ZhString.LevelUpNotice_Base
  elseif self.lvType == SceneUserEvent.JobLevelUp then
    self.AddPointLabel.text = ZhString.LevelUpNotice_Job
  end
end

function MainViewTaskQuestPage:HideNotice()
  self.noticeShowed = false
  self.pointNotice_Tween:ResetToBeginning()
  self.addPointNotice:SetActive(false)
end

function MainViewTaskQuestPage:UpdateExtraInfoTrace_TypeSpaceDragon()
  local data = AbyssFakeDragonProxy.Instance:GetDragonInfos()
  local curMap = Game.MapManager:GetMapID()
  if not data or curMap ~= 154 then
    if self.extraInfoCells and self.extraInfoCells.SpaceDragon then
      self.extraInfoCells.SpaceDragon:DestroySelf()
      self.extraInfoCells.SpaceDragon = nil
    end
    return
  end
  self:UpdateExtraInfoTrace("SpaceDragon", data)
end

function MainViewTaskQuestPage:CreateExtraInfoTrace_SpaceDragon(data)
  local go = self:LoadPreferb("cell/TaskQuestCell_SpaceDragon", self.extraTop)
  autoImport("TaskQuestCell_SpaceDragon")
  local cell = TaskQuestCell_SpaceDragon.new(go)
  cell:AddEventListener(MouseEvent.MouseClick, self.questCellClick, cell)
  cell:SetData(data)
  return cell
end

function MainViewTaskQuestPage:OnClickDragonCell(note)
  if not note or not note.body then
    return
  end
  local cellCtrl = note.body.cellCtrl
  self:questCellClick(cellCtrl)
end

function MainViewTaskQuestPage:UnClickDragonCell()
  local cellCtrl = self.extraInfoCells and self.extraInfoCells.SpaceDragon
  if cellCtrl then
    cellCtrl:setISShowDir(false)
  end
end
