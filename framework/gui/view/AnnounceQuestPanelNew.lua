AnnounceQuestPanelNew = class("AnnounceQuestPanelNew", ContainerView)
autoImport("AnnounceQuestPanelCellNew")
AnnounceQuestPanelNew.ViewType = UIViewType.NormalLayer
AnnounceQuestPanelNew.FirstEnterTag = false
AnnounceQuestPanelNew.ExitTag = false
local tempArray = {}

function AnnounceQuestPanelNew:Init()
  self:initView()
  self:initData()
  self:addListEventListener()
  AnnounceQuestPanelNew.ExitTag = false
  EventManager.Me():AddEventListener(AppStateEvent.OrientationChange, self.HandleOrientationChange, self)
end

function AnnounceQuestPanelNew:OnEnter()
  self.super.OnEnter(self)
  self.FirstEnterTag = true
  helplog("向服务器请求面板数据111" .. tostring(self.wantedId))
  ServiceQuestProxy.Instance:CallQuestList(SceneQuest_pb.EQUESTLIST_CANACCEPT, self.wantedId)
  PictureManager.Instance:SetUI("Rewardtask_bg", self.bgTexture)
end

function AnnounceQuestPanelNew:DelayOnEnter()
  if self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.npcTarget then
    local viewdata = self.viewdata.viewdata
    local func = function()
      if AnnounceQuestPanelNew.ExitTag then
        return
      end
      self:Show()
      local manager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
      manager_Camera:ActiveMainCamera(false)
    end
    local trans = viewdata.npcTarget.assetRole.completeTransform
    self.npcid = viewdata.npcTarget.data.staticData.id
    self.announceGuid = viewdata.npcTarget.data:GetGuid()
    local viewPort = CameraConfig.Ann_ViewPort
    local rotation = CameraController.singletonInstance.targetRotationEuler
    rotation = Vector3(CameraConfig.Ann_ViewRotationX, rotation.y, rotation.z)
    self:CameraFaceTo(trans, viewPort, rotation, nil, nil, func)
  end
end

function AnnounceQuestPanelNew:OnExit()
  self.super.OnExit(self)
  AnnounceQuestPanelNew.ExitTag = true
  local manager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
  manager_Camera:ActiveMainCamera(true)
  self:CameraReset()
  TimeTickManager.Me():ClearTick(self)
  MsgManager.CloseConfirmMsgByID(903)
  EventManager.Me():RemoveEventListener(AppStateEvent.OrientationChange, self.HandleOrientationChange, self)
  PictureManager.Instance:UnLoadUI("Rewardtask_bg", self.bgTexture)
end

function AnnounceQuestPanelNew:initView()
  self:Hide()
  self.Static = self:FindGO("Static")
  self.StaticNewCloseBtn = self:FindGO("NewCloseBtn", self.Static)
  self.StaticNewCloseBtnNCloseButton = self:FindGO("NCloseButton", self.StaticNewCloseBtn)
  self:AddClickEvent(self.StaticNewCloseBtnNCloseButton, function(obj)
    self:CloseSelf()
  end)
  self.bgTexture = self:FindGO("BGForNewLook"):GetComponent(UITexture)
  self.Dynamic = self:FindGO("Dynamic")
  self.DynamicbottomState = self:FindGO("bottomState", self.Dynamic)
  self.DynamicbottomStaterefreshTimeLabel = self:FindGO("refreshTimeLabel", self.DynamicbottomState)
  self.DynamicbottomStaterefreshTimeLabel_UILabel = self.DynamicbottomStaterefreshTimeLabel:GetComponent(UILabel)
  self.DynamicGridP = self:FindGO("GridP", self.Dynamic)
  self.DynamicGridP_UIGrid = self.DynamicGridP:GetComponent(UIGrid)
  self.DynamicGridP_UIGridListCtrl = UIGridListCtrl.new(self.DynamicGridP_UIGrid, AnnounceQuestPanelCellNew, "AnnounceQuestPanelCellNew")
  self.DynamicGridP_UIGridListCtrl:AddEventListener(MouseEvent.MouseClick, self.questClick, self)
end

function AnnounceQuestPanelNew:initData()
  self.currentQuestData = nil
  self.firstInit = true
  if self.viewdata.viewdata then
    self.wantedId = self.viewdata.viewdata.wanted
  else
    printRed("can't find wantedId in viewdata!")
  end
  self.hasGoingQuest = false
  self.startIndex = 1
  self.listTime = {}
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
  self.currentRatio = 0
  self.hasPlayAudio = false
end

function AnnounceQuestPanelNew:getStartIndexByQuestId()
  local questId = self.questId
  if self.questListData and #self.questListData > 0 then
    if questId then
      for i = 1, #self.questListData do
        local single = self.questListData[i]
        if single.quest.id == questId then
          return i
        end
      end
    else
      return 1
    end
  end
  self.questId = nil
end

function AnnounceQuestPanelNew:addListEventListener()
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.VarUpdateHandler)
  self:AddListenEvt(ServiceEvent.QuestQuestCanAcceptListChange, function()
    ServiceQuestProxy.Instance:CallQuestList(SceneQuest_pb.EQUESTLIST_CANACCEPT, self.wantedId)
  end)
  self:AddListenEvt(SceneUserEvent.LevelUp, function()
    ServiceQuestProxy.Instance:CallQuestList(SceneQuest_pb.EQUESTLIST_CANACCEPT, self.wantedId)
  end)
  self:AddListenEvt(QuestEvent.UpdateAnnounceQuest, self.setQuestData)
  self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs, self.removeNpcHandle)
  self:AddListenEvt(ServiceEvent.QuestQuestList, self.RecvQuestQuestList)
  self:AddListenEvt(ServiceEvent.QuestQuestUpdate, self.RecvQuestQuestUpdate)
  self:AddListenEvt(ServiceEvent.QuestQuestStepUpdate, self.RecvQuestQuestStepUpdate)
end

function AnnounceQuestPanelNew:RecvQuestQuestList(note)
  helplog("RecvQuestQuestList")
  self:setQuestData(note)
  if self.FirstEnterTag then
    self.FirstEnterTag = false
    if self.questListData and not QuestProxy.Instance:checkIsAllVersionQuestSubmitted(self.npcid) then
      self:DelayOnEnter()
    else
      self:CloseSelf()
      MsgManager.ShowMsgByIDTable(33002)
    end
  end
end

function AnnounceQuestPanelNew:RecvQuestQuestUpdate(note)
  helplog("RecvQuestQuestUpdate")
  self:setQuestData(note)
end

function AnnounceQuestPanelNew:RecvQuestQuestStepUpdate(note)
  helplog("RecvQuestQuestStepUpdate")
  self:setQuestData(note)
end

function AnnounceQuestPanelNew:removeNpcHandle(note)
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

function AnnounceQuestPanelNew:VarUpdateHandler()
  self.varupdated = true
  local submitCount = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_QUEST_WANTED)
  TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
    if self.varupdated then
      self:setQuestData()
    end
  end, self)
end

function AnnounceQuestPanelNew:questClick(obj)
  if not obj then
    return
  end
  self.questId = obj.data.id
  if obj.data:getQuestListType() == SceneQuest_pb.EQUESTLIST_COMPLETE then
    ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_SUBMIT, self.questId)
    if BranchMgr.IsJapan() then
      AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Commit)
    end
    ServiceQuestProxy.Instance:CallQuestList(SceneQuest_pb.EQUESTLIST_CANACCEPT)
  elseif obj.data:getQuestListType() == SceneQuest_pb.EQUESTLIST_CANACCEPT then
    if BranchMgr.IsJapan() then
      AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Accept)
    end
    ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_ACCEPT, self.questId)
  elseif obj.data:getQuestListType() == SceneQuest_pb.EQUESTACTION_ACCEPT then
    if obj.data.staticData and obj.data.staticData.Params and obj.data.staticData.Params.ifAccessFc then
      QuestProxy.Instance:notifyQuestState(obj.data.scope, obj.data.id)
      ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_SUBMIT, self.questId)
      if BranchMgr.IsJapan() then
        AudioUtil.Play2DRandomSound(AudioMap.Maps.AnnounceQuestPanel_Commit)
      end
      ServiceQuestProxy.Instance:CallQuestList(SceneQuest_pb.EQUESTLIST_CANACCEPT)
    elseif self.questId then
      MsgManager.ConfirmMsgByID(33003, function()
        local findNpc = false
        for k, v in pairs(GameConfig.Quest.NewWantedNpcType) do
          if TableUtility.ArrayFindIndex(v, obj.versionTaskData.Type) > 0 then
            local npcs = NSceneNpcProxy.Instance:FindNpcs(k)
            if npcs and 0 < #npcs then
              findNpc = true
              break
            end
          end
        end
        if findNpc then
          ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_ABANDON_GROUP, self.questId)
          ServiceQuestProxy.Instance:CallQuestList(SceneQuest_pb.EQUESTLIST_CANACCEPT, self.wantedId)
        end
      end, nil)
    end
  end
end

function AnnounceQuestPanelNew:playQuestCompleteAnim(cell)
  self:PlayUISound(AudioMap.UI.stamp)
  self:Show(self.panelMask)
  cell:playAnim()
  TimeTickManager.Me():CreateOnceDelayTick(3000, function(owner, deltaTime)
    if not self:ObjIsNil(self.panelMask) then
      self:Hide(self.panelMask)
    end
  end, self)
  ServiceQuestProxy.Instance:CallQuestAction(SceneQuest_pb.EQUESTACTION_SUBMIT, cell.data.id)
end

function AnnounceQuestPanelNew:setQuestData(note)
  self.npcid = self.viewdata.viewdata.npcTarget.data.staticData.id
  self.questListData = QuestProxy.Instance:getVersionQuest(self.npcid)
  helplog("setQuestData#self.questListData:" .. #self.questListData)
  self:setQuestList()
  self.nextTime = self:getNextRefreshTime()
  TimeTickManager.Me():CreateTick(0, 1000, self.refreshTime, self, 1)
end

function AnnounceQuestPanelNew:checkIsAllQuestCommited()
  if self.questListData and #self.questListData > 0 then
    for i = 1, #self.questListData do
      local single = self.questListData[i]
      if single.quest:getQuestListType() ~= SceneQuest_pb.EQUESTLIST_SUBMIT then
        return false
      end
    end
  end
  return true
end

function AnnounceQuestPanelNew:checkIfHasExsit(questId, array)
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

function AnnounceQuestPanelNew:setQuestList(index)
  self.DynamicGridP_UIGridListCtrl:ResetDatas(self.questListData)
end

function AnnounceQuestPanelNew:refreshTime()
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
  local str = curSmit .. "/" .. QuestProxy.Instance:getMaxWanted()
  self.DynamicbottomStaterefreshTimeLabel_UILabel.text = ZhString.AnnounceQuestPanel_RefreshTime .. timeStr
end

function AnnounceQuestPanelNew:getNextRefreshTime()
  local currentTime = ServerTime.CurServerTime() / 1000
  for i = 1, #self.listTime do
    if currentTime < self.listTime[i] then
      return self.listTime[i]
    end
  end
end

function AnnounceQuestPanelNew:HandleOrientationChange(note)
  if note.data == nil then
    return
  end
end
