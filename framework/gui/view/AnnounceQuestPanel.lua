AnnounceQuestPanel = class("AnnounceQuestPanel", ContainerView)
autoImport("AnnounceQuestPanelCell")
AnnounceQuestPanel.ViewType = UIViewType.NormalLayer
AnnounceQuestPanel.skillid = 50040001
AnnounceQuestPanel.ExitTag = false
local tempArray = {}
local mateArray = {}

function AnnounceQuestPanel:Init()
  self:initView()
  self:initData()
  self:addListEventListener()
  AnnounceQuestPanel.ExitTag = false
  EventManager.Me():AddEventListener(AppStateEvent.OrientationChange, self.HandleOrientationChange, self)
end

function AnnounceQuestPanel:OnEnter()
  self.super.OnEnter(self)
  local func = function()
    if AnnounceQuestPanel.ExitTag then
      return
    end
    self:Show()
    self:AlertConfirmMsg()
    ServiceQuestProxy.Instance:CallQuestList(SceneQuest_pb.EQUESTLIST_CANACCEPT, self.wantedId)
  end
  if self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.npcTarget then
    local viewdata = self.viewdata.viewdata
    local trans = viewdata.npcTarget.assetRole.completeTransform
    self.announceGuid = viewdata.npcTarget.data:GetGuid()
    local viewPort = CameraConfig.Ann_ViewPort
    local rotation = CameraController.singletonInstance.targetRotationEuler
    rotation = Vector3(CameraConfig.Ann_ViewRotationX, rotation.y, rotation.z)
    self:CameraFaceTo(trans, viewPort, rotation, nil, nil, func)
  else
    func()
  end
  if self.TramShowbgTexture then
    PictureManager.Instance:SetUI("share_meizi", self.TramShowbgTexture)
  end
  self:SetUpTextures()
end

function AnnounceQuestPanel:OnHide()
  local manager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
  manager_Camera:ActiveMainCamera(true)
end

function AnnounceQuestPanel:AlertConfirmMsg()
  local prefsKey = "AnnounceQuestPanel_HasPrompt"
  local value = PlayerPrefs.GetInt(prefsKey, 0)
  if value == 0 then
    MsgManager.ConfirmMsgByID(33004)
    PlayerPrefs.SetInt(prefsKey, 1)
  end
end

function AnnounceQuestPanel:OnShow()
  local manager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
  manager_Camera:ActiveMainCamera(true)
end

function AnnounceQuestPanel:OnExit()
  self:CameraReset()
  TimeTickManager.Me():ClearTick(self)
  MsgManager.CloseConfirmMsgByID(903)
  EventManager.Me():RemoveEventListener(AppStateEvent.OrientationChange, self.HandleOrientationChange, self)
  self:UnloadTextures()
  self.super.OnExit(self)
  AnnounceQuestPanel.ExitTag = true
end

function AnnounceQuestPanel:initView()
  self.TramShowbgTexture = self:FindComponent("TramShowbgTexture", UITexture)
  self.CloseButtoon = self:FindGO("CloseCt")
  self.refreshTimeLabel = self:FindComponent("refreshTimeLabel", UILabel)
  self:Hide()
  self.leftAction = self:FindGO("leftAction")
  self.rightAction = self:FindGO("rightAction")
  self:Hide(self.rightAction)
  self:Hide(self.leftAction)
  self.panelMask = self:FindGO("panelMask")
  self:Hide(self.panelMask)
  self.ScrollView = self:FindComponent("ScrollView", UIScrollView)
  
  function self.ScrollView.onStoppedMoving()
    self:checkBtnEnabled()
  end
  
  self.contentContainer = self:FindComponent("ContentContainer", UIGrid)
  local isInWantedQuestActivity = QuestProxy.Instance:isInWantedQuestInActivity()
  if isInWantedQuestActivity then
    self.questListCtl = UIGridListCtrl.new(self.contentContainer, AnnounceQuestPanelCell, "AnnounceQuestActivityPanelCell")
  else
    self.questListCtl = UIGridListCtrl.new(self.contentContainer, AnnounceQuestPanelCell, "AnnounceQuestPanelCell")
  end
  self.questListCtl:AddEventListener(MouseEvent.MouseClick, self.questClick, self)
  self.questListCtl:AddEventListener(AnnounceQuestPanelCell.PassEvent_FastCompleteBtn, self.CellEvent_FastBtnClick, self)
  self.bgTexture = self:FindComponent("bgTexture", UITexture)
  self.bgCt = self:FindGO("bgCt")
  self.frameTexPrefix = "Rewardtask_bg_"
  self.frameTextures = {}
  self.frameTextures[self.frameTexPrefix .. "left"] = self:FindComponent("left", UITexture, self.bgCt)
  self.frameTextures[self.frameTexPrefix .. "up"] = self:FindComponent("up", UITexture, self.bgCt)
  self.frameTextures[self.frameTexPrefix .. "right"] = self:FindComponent("right", UITexture, self.bgCt)
  self.frameTextures[self.frameTexPrefix .. "down"] = self:FindComponent("down", UITexture, self.bgCt)
  local label = self:FindComponent("Label", UISprite)
  if label then
    IconManager:SetArtFontIcon("Rewardtask_bg_txt", label)
  end
  label = self:FindComponent("Label2", UISprite)
  if label then
    IconManager:SetArtFontIcon("Rewardtask_bg_txt2", label)
  end
end

function AnnounceQuestPanel:initData()
  self.currentQuestData = nil
  self.firstInit = true
  if self.viewdata.viewdata then
    self.wantedId = self.viewdata.viewdata.wanted
  else
    printRed("can't find wantedId in viewdata!")
  end
  self.hasGoingQuest = false
  self.startIndex = 1
  self:GenerateRefreshListTime()
  self.hasPlayAudio = false
end

function AnnounceQuestPanel:GenerateRefreshListTime()
  if self.listTime then
    TableUtility.ArrayClear(self.listTime)
  else
    self.listTime = {}
  end
  local currentTime = ServerTime.CurServerTime() / 1000
  local nextDayTime
  local timeTab = os.date("*t", currentTime)
  for i = 1, #GameConfig.Quest.refresh do
    local tmp = TableUtil.split(GameConfig.Quest.refresh[i], ":")
    local tb = {
      year = timeTab.year,
      month = timeTab.month,
      day = timeTab.day,
      hour = tmp[1],
      min = tmp[2],
      sec = 0,
      isdst = false
    }
    table.insert(self.listTime, os.time(tb))
    if i == 1 then
      tb = {
        year = timeTab.year,
        month = timeTab.month,
        day = timeTab.day + 1,
        hour = tmp[1],
        min = tmp[2],
        sec = 0,
        isdst = false
      }
      nextDayTime = os.time(tb)
    end
  end
  table.insert(self.listTime, nextDayTime)
end

function AnnounceQuestPanel:checkBtnEnabled()
  if self.questListData and #self.questListData > 0 then
    local cells = self.questListCtl:GetCells()
    local panel = self.ScrollView.panel
    if panel then
      local cell = cells[1]
      if panel:IsVisible(cell.baseExp) then
        self:Hide(self.leftAction)
      else
        self:Show(self.leftAction)
      end
      local index = #cells
      cell = cells[index]
      if panel:IsVisible(cell.jobExp) then
        self:Hide(self.rightAction)
      else
        self:Show(self.rightAction)
      end
    end
  else
    self:Hide(self.rightAction)
    self:Hide(self.leftAction)
  end
end

function AnnounceQuestPanel:getStartIndexByQuestId()
  local questId = self.questId
  if self.questListData and #self.questListData > 0 then
    if questId then
      for i = 1, #self.questListData do
        local single = self.questListData[i]
        if single.id == questId then
          return i
        end
      end
    else
      return 1
    end
  end
  self.questId = nil
end

function AnnounceQuestPanel:addListEventListener()
  self:AddListenEvt(ServiceEvent.QuestQuestList, self.setQuestData)
  self:AddListenEvt(ServiceEvent.SessionTeamQuestWantedQuestTeamCmd, self.SessionTeamQuestWantedQuestTeamCmd)
  self:AddListenEvt(ServiceEvent.SessionTeamUpdateWantedQuestTeamCmd, self.SessionTeamUpdateWantedQuestTeamCmd)
  self:AddListenEvt(ServiceEvent.QuestQuestUpdate, self.setQuestData)
  self:AddListenEvt(ServiceEvent.QuestQuestStepUpdate, self.setQuestData)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.VarUpdateHandler)
  self:AddListenEvt(ServiceEvent.QuestQuestCanAcceptListChange, function()
    ServiceQuestProxy.Instance:CallQuestList(SceneQuest_pb.EQUESTLIST_CANACCEPT, self.wantedId)
  end)
  self:AddListenEvt(MyselfEvent.LevelUp, function()
    ServiceQuestProxy.Instance:CallQuestList(SceneQuest_pb.EQUESTLIST_CANACCEPT, self.wantedId)
  end)
  self:AddListenEvt(QuestEvent.UpdateAnnounceQuest, self.setQuestData)
  self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs, self.removeNpcHandle)
end

function AnnounceQuestPanel:removeNpcHandle(note)
  local body = note.body
  if body and 0 < #body then
    for i = 1, #body do
      if self.announceGuid == body[i] then
        self:CloseSelf()
        break
      end
    end
  end
end

function AnnounceQuestPanel:VarUpdateHandler()
  self.varupdated = true
  local submitCount = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_QUEST_WANTED)
  TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
    if self.varupdated then
      self:setQuestData()
    end
  end, self, 2)
end

function AnnounceQuestPanel:SessionTeamQuestWantedQuestTeamCmd()
  self:setQuestData()
end

function AnnounceQuestPanel:SessionTeamUpdateWantedQuestTeamCmd()
  self:setQuestData()
end

function AnnounceQuestPanel:setQuestData(note)
  self.varupdated = false
  self.hasGoingQuest = false
  self.questListData = QuestProxy.Instance:getWantedQuest()
  local index = self:getStartIndexByQuestId()
  local unAccept = false
  local finishCount = 0
  for i = 1, #self.questListData do
    local single = self.questListData[i]:getQuestListType()
    if single == SceneQuest_pb.EQUESTLIST_ACCEPT or single == SceneQuest_pb.EQUESTLIST_COMPLETE then
      self.hasGoingQuest = true
      if self.firstInit then
        index = i
      end
    elseif single == SceneQuest_pb.EQUESTLIST_CANACCEPT then
      unAccept = true
    elseif single == SceneQuest_pb.EQUESTLIST_SUBMIT then
      finishCount = finishCount + 1
    end
  end
  QuestProxy.Instance:setGoingWantedQuest(self.hasGoingQuest)
  local maxCount = QuestProxy.Instance:getMaxWanted()
  if finishCount > maxCount then
    finishCount = maxCount
  end
  self.submitCount = finishCount
  local extraCount = self:setQuestList(index)
  self.nextTime = self:getNextRefreshTime()
  TimeTickManager.Me():CreateTick(0, 1000, self.refreshTime, self, 1)
  if not self.hasPlayAudio then
    self.hasPlayAudio = true
    if unAccept or self.hasGoingQuest then
      if BranchMgr.IsJapan() then
        AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Normal)
      end
    elseif BranchMgr.IsJapan() then
      AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_AllCommit)
    end
  end
end

function AnnounceQuestPanel:checkIfNeedExtraQuest(questId)
  if self.questListData and #self.questListData > 0 then
    for i = 1, #self.questListData do
      local single = self.questListData[i]
      local result = single.id == questId and single:getQuestListType() ~= SceneQuest_pb.EQUESTLIST_SUBMIT
      if result then
        return false
      end
    end
  end
  return true
end

function AnnounceQuestPanel:checkIfHasExsit(questId, array)
  if array and 0 < #array then
    for i = 1, #array do
      local single = array[i]
      if single.id == questId then
        return true
      end
    end
  end
  return false
end

function AnnounceQuestPanel:setQuestList(index)
  local extraCount = 0
  local extraQuests = ShareAnnounceQuestProxy.Instance:getAllMembersQuest()
  tempArray = {}
  local acceptCount = 0
  if self.questListData and 0 < #self.questListData then
    for i = 1, #self.questListData do
      local single = self.questListData[i]
      if single:getQuestListType() == SceneQuest_pb.EQUESTLIST_ACCEPT then
        acceptCount = acceptCount + 1
      end
      table.insert(tempArray, self.questListData[i])
    end
  end
  if not index then
    self.startIndex = 1 + extraCount
  else
    self.startIndex = index + extraCount
  end
  local maxCount = QuestProxy.Instance:getMaxWanted()
  local acceptValid = maxCount > self.submitCount + acceptCount and true or false
  if tempArray and 0 < #tempArray then
    self.questListCtl:ResetDatas(tempArray)
    self:moveScrView()
    local cells = self.questListCtl:GetCells()
    for i = 1, #cells do
      local single = cells[i]
      if single.data:getQuestListType() == SceneQuest_pb.EQUESTLIST_CANACCEPT and not acceptValid then
        single:SetDisableAccept()
      end
    end
    if self.ifNeedPlayRatioUp then
      for i = 1, #cells do
        local single = cells[i]
        local panel = self.ScrollView.panel
        if panel and panel:IsVisible(single.publishName) then
          single:playRatioUpAnm()
        end
      end
      self.ifNeedPlayRatioUp = false
    end
  else
    self.questListCtl:ResetDatas()
  end
end

function AnnounceQuestPanel:moveScrView()
  if self.startIndex and self.startIndex ~= 1 then
    local cells = self.questListCtl:GetCells()
    local cell = cells[self.startIndex]
    if not cell then
      return
    end
    TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
      local panel = self.ScrollView.panel
      if not panel then
        return
      end
      local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, cell.gameObject.transform)
      local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
      offset = Vector3(offset.x, 0, 0)
      self.ScrollView:MoveRelative(offset)
    end, self, 3)
  else
    self.questListCtl:Layout()
  end
end

function AnnounceQuestPanel:refreshTime()
  local deltaTime = math.abs(self.nextTime - ServerTime.CurServerTime() / 1000)
  local hour = math.floor(deltaTime / 3600)
  local timeStr
  if hour == 0 then
    timeStr = "00"
  elseif hour < 10 then
    timeStr = "0" .. hour
  else
    timeStr = hour
  end
  timeStr = timeStr .. ":"
  local minute = math.floor((deltaTime - hour * 3600) / 60)
  if minute == 0 then
    timeStr = timeStr .. "00"
  elseif minute < 10 then
    timeStr = timeStr .. "0" .. minute
  else
    timeStr = timeStr .. minute
  end
  timeStr = timeStr .. ":"
  local second = math.floor(deltaTime - hour * 3600 - minute * 60)
  if second == 0 then
    timeStr = timeStr .. "00"
  elseif second < 10 then
    timeStr = timeStr .. "0" .. second
  else
    timeStr = timeStr .. second
  end
  local curSmit = self.submitCount and self.submitCount or 0
  local maxWanted = QuestProxy.Instance:getMaxWanted()
  local str = curSmit .. "/" .. maxWanted
  local actData = ActivityEventProxy.Instance:GetRewardByType(AERewardType.WantedQuest)
  local userData = ActivityEventProxy.Instance:GetUserDataByType(AERewardType.WantedQuest)
  local curCount = userData and userData:GetExtraDayCount() or 0
  local extradaylimit = actData and actData.extraDayLimit
  local extraRewardValid = actData and actData:CheckExtraRewardValid()
  if curCount and extradaylimit then
    if curCount > extradaylimit then
      curCount = extradaylimit
    end
    local extraStr = curCount .. "/" .. extradaylimit
    self.refreshTimeLabel.text = string.format(ZhString.AnnounceQuestPanel_ExtraBottomLabel, str, extraStr, timeStr)
  else
    self.refreshTimeLabel.text = string.format(ZhString.AnnounceQuestPanel_BottomLabel, str, timeStr)
  end
end

function AnnounceQuestPanel:getNextRefreshTime()
  local currentTime = ServerTime.CurServerTime() / 1000
  for i = 1, #self.listTime do
    if currentTime < self.listTime[i] then
      return self.listTime[i]
    end
  end
  self:GenerateRefreshListTime()
  self:getNextRefreshTime()
end

function AnnounceQuestPanel:playQuestCompleteAnim(cell)
  local ratio = QuestProxy.Instance:getWantedQuestRatio(self.submitCount)
  local nextRatio = QuestProxy.Instance:getWantedQuestRatio(self.submitCount + 1)
  if ratio ~= nextRatio then
    self.ifNeedPlayRatioUp = true
  end
  self:PlayUISound(AudioMap.UI.stamp)
  self:Show(self.panelMask)
  cell:playAnim()
  TimeTickManager.Me():CreateOnceDelayTick(3000, function(owner, deltaTime)
    if not self:ObjIsNil(self.panelMask) then
      self:Hide(self.panelMask)
    end
  end, self, 4)
  ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_SUBMIT, cell.data.id)
end

function AnnounceQuestPanel:checkWantedTick(data)
  if not (data and data.wantedData) or data.wantedData.IsActivity == 1 then
    return
  end
  local dont = LocalSaveProxy.Instance:GetDontShowAgain(55)
  local itemId = 5503
  local itemData = BagProxy.Instance:GetItemByStaticID(itemId, 17)
  local own = BagProxy.Instance:GetItemNumByStaticID(itemId, GameConfig.PackageMaterialCheck.default)
  local cost = 5
  if own < cost then
    MsgManager.ShowMsgByID(38199)
    return
  end
  if dont == nil then
    MsgManager.DontAgainConfirmMsgByID(55, function()
      if BranchMgr.IsJapan() then
        AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Accept)
      end
      ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_QUICK_SUBMIT_BOARD, self.questId)
    end, function()
      if BranchMgr.IsJapan() then
        AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Accept)
      end
      ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_ACCEPT, self.questId)
    end, nil, itemData:GetName(true, true))
  else
    if BranchMgr.IsJapan() then
      AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Accept)
    end
    ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_QUICK_SUBMIT_BOARD, self.questId)
  end
end

function AnnounceQuestPanel:questClick(obj)
  if not obj then
    return
  end
  local data = obj.data
  self.questId = data.id
  if not self.questId then
    return
  end
  if data:getQuestListType() == SceneQuest_pb.EQUESTLIST_COMPLETE then
    self:playQuestCompleteAnim(obj)
    if BranchMgr.IsJapan() then
      AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Commit)
    end
  elseif data:getQuestListType() == SceneQuest_pb.EQUESTLIST_CANACCEPT then
    if self.submitCount >= QuestProxy.Instance:getMaxWanted() then
      MsgManager.ShowMsgByIDTable(901)
      return
    end
    if BranchMgr.IsJapan() then
      AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Accept)
    end
    ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_ACCEPT, self.questId)
  elseif data:getQuestListType() == SceneQuest_pb.EQUESTACTION_ACCEPT then
    if data.staticData and data.staticData.Params and data.staticData.Params.ifAccessFc then
      QuestProxy.Instance:notifyQuestState(data.scope, data.id)
      self:playQuestCompleteAnim(obj)
      if BranchMgr.IsJapan() then
        AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Commit)
      end
    else
      MsgManager.ConfirmMsgByID(903, function()
        ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_ABANDON_GROUP, self.questId)
        ServiceQuestProxy.Instance:CallQuestList(SceneQuest_pb.EQUESTLIST_CANACCEPT, self.wantedId)
      end, nil)
    end
  end
end

function AnnounceQuestPanel:CellEvent_FastBtnClick(obj)
  if not obj then
    return
  end
  local data = obj.data
  self.questId = data.id
  if not self.questId then
    return
  end
  if data:getQuestListType() == SceneQuest_pb.EQUESTLIST_CANACCEPT then
    if self.submitCount >= QuestProxy.Instance:getMaxWanted() then
      MsgManager.ShowMsgByIDTable(901)
      return
    elseif self:checkWantedTick(data) then
      return
    end
  end
end

function AnnounceQuestPanel:HandleOrientationChange(note)
  if note.data == nil then
    return
  end
  self.contentContainer:Reposition()
end

function AnnounceQuestPanel:SetUpTextures()
  self.bgTexName = "bg_view_2"
  if self.bgTexture then
    PictureManager.Instance:SetUI(self.bgTexName, self.bgTexture)
    PictureManager.ReFitFullScreen(self.bgTexture, 1)
  end
  for k, v in pairs(self.frameTextures) do
    PictureManager.Instance:SetUI(k, v)
  end
end

function AnnounceQuestPanel:UnloadTextures()
  if self.bgTexture then
    PictureManager.Instance:UnLoadUI(self.bgTexName, self.bgTexture)
  end
  for k, v in pairs(self.frameTextures) do
    PictureManager.Instance:UnLoadUI(k, v)
  end
end
