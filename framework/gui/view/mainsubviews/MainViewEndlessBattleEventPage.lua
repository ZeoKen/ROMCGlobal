local _EventProxy, _Lang
local Win_Desc = {
  [Camp_Vampire] = ZhString.EndlessBattleEvent_VampireWin,
  [Camp_Human] = ZhString.EndlessBattleEvent_HumanWin,
  [Camp_Neutral] = ZhString.EndlessBattleEvent_Neutral
}
local Win_Desc_BgColor = {
  [Camp_Vampire] = "6d2820",
  [Camp_Human] = "264d94",
  [Camp_Neutral] = "4d4e4f"
}
local BgTextureName = "battlefield_bg_bottem_01"
autoImport("EndlessBattleOccupyPointPerTip")
autoImport("EndlessBattleCellModule")
autoImport("QuestTraceSymbolCell")
local _CellConfig = {
  occupy = {
    prefab = "MainViewEndlessBattleEvent_OccupyCell",
    class = EBFProgressOccupyTypeCell
  },
  kill_monster = {
    prefab = "MainViewEndlessBattleEvent_KillMonsterCell",
    class = EBFProgressKillMonsterTypeCell
  },
  kill_boss = {
    prefab = "MainViewEndlessBattleEvent_KillBossCell",
    class = EBFProgressKillBossTypeCell
  },
  escort = {
    prefab = "MainViewEndlessBattleEvent_EscortCell",
    class = EBFProgressEscortTypeCell
  },
  coin = {
    prefab = "MainViewEndlessBattleEvent_KillMonsterCell",
    class = EBFProgressCoinTypeCell
  }
}
local _FixedFinalEventTime = "0s"
MainViewEndlessBattleEventPage = class("MainViewEndlessBattleEventPage", SubMediatorView)

function MainViewEndlessBattleEventPage:Init()
  self.overviewIsSimple = false
  self.detailIsSimple = false
  self.isCurSimple = false
  self.isOverview = nil
  self.firstEnterTrigger = false
  _Lang = OverSea.LangManager.Instance()
  _EventProxy = EndlessBattleFieldProxy.Instance
  self:ReLoadPerferb("view/MainViewEndlessBattleEventPage")
  self:AddViewEvts()
  self:InitView()
  self:InitEventsUI()
  self:Init_StatueRoot()
  self:InitShow()
  self:SetSchedule()
  self:InitTrace()
end

function MainViewEndlessBattleEventPage:TrySetLastestEventName(name, start_time)
  if not name or not start_time then
    return
  end
  if not self.last_start_time or start_time > self.last_start_time then
    self.last_event_name = name
    self.last_start_time = start_time
  end
end

local maxEvent = 6

function MainViewEndlessBattleEventPage:SetSchedule(last_event_name, start_time)
  if self.statueMaxEndTime then
    return
  end
  self:TrySetLastestEventName(last_event_name, start_time)
  local nextEventTime = EndlessBattleFieldProxy.Instance:GetNextEventTime()
  if self.nextEventTime ~= nextEventTime then
    self.nextEventTime = nextEventTime
    self:ClearScheduleTimeTick()
    self.scheduleTimeTick = TimeTickManager.Me():CreateTick(0, 1000, function()
      local events = EndlessBattleFieldProxy.Instance:GetEventList()
      local num = math.min(#events + 1, maxEvent)
      local countdown = math.max(nextEventTime - math.floor(ServerTime.CurServerTime() / 1000), 0)
      local nextEventId = EndlessBattleFieldProxy.Instance:GetNextEventId()
      if self.isOverview then
        if self.isCurSimple then
          self.o_SimpleScheduleLab.text = string.format(ZhString.EndlessBattleEvent_StartEventCountdown_Simple, countdown)
        elseif not self.firstEnterTrigger then
          self.o_DetailScheduleLab.text = string.format(ZhString.EndlessBattleEvent_EventDesc, self.last_event_name or "")
        elseif num == maxEvent then
          self.o_DetailScheduleLab.text = string.format(ZhString.EndlessBattleEvent_StartEventCountdown, countdown, ZhString.EndlessBattleEvent_Final, num, maxEvent)
        else
          local config = nextEventId and Table_EndlessBattleFieldEvent[nextEventId]
          local eventName = config and config.Name or nil
          if eventName then
            self.o_DetailScheduleLab.text = string.format(ZhString.EndlessBattleEvent_StartEventCountdown, countdown, eventName, num, maxEvent)
          else
            self.o_DetailScheduleLab.text = string.format(ZhString.EndlessBattleEvent_StartEventCountdown_NoNextEvent, countdown, num, maxEvent)
          end
        end
      elseif self.isCurSimple then
        self.d_SimpleScheduleLab.text = string.format(ZhString.EndlessBattleEvent_StartEventCountdown_Simple, countdown)
      elseif not self.firstEnterTrigger then
        self.d_DetailScheduleLab.text = string.format(ZhString.EndlessBattleEvent_EventDesc, self.last_event_name or "")
      elseif num == maxEvent then
        self.d_DetailScheduleLab.text = string.format(ZhString.EndlessBattleEvent_StartEventCountdown, countdown, ZhString.EndlessBattleEvent_Final, num, maxEvent)
      else
        local config = nextEventId and Table_EndlessBattleFieldEvent[nextEventId]
        local eventName = config and config.Name or nil
        if eventName then
          self.d_DetailScheduleLab.text = string.format(ZhString.EndlessBattleEvent_StartEventCountdown, countdown, eventName, num, maxEvent)
        else
          self.d_DetailScheduleLab.text = string.format(ZhString.EndlessBattleEvent_StartEventCountdown_NoNextEvent, countdown, num, maxEvent)
        end
      end
      if countdown == 0 then
        self:SetSchedule()
      end
    end, self, 2)
  end
end

function MainViewEndlessBattleEventPage:ClearScheduleTimeTick()
  if self.scheduleTimeTick then
    TimeTickManager.Me():ClearTick(self, 2)
    self.scheduleTimeTick = nil
  end
  self.nextEventTime = nil
end

function MainViewEndlessBattleEventPage:InitTrace()
  self.traceSymbolCtrl = {}
  local interval = FunctionPerformanceSetting.Me():GetTargetFrameRateInterval()
  TimeTickManager.Me():CreateTick(0, interval, self.RefreshEventPos, self, 5)
end

function MainViewEndlessBattleEventPage:RefreshEventPos()
  local myPos = Game.Myself:GetPosition()
  local maxShowCount = 10
  local activeEvents = EndlessBattleFieldProxy.Instance:GetActiveEvents()
  for i = 1, maxShowCount do
    if activeEvents[i] then
      local event_id = activeEvents[i].eventId
      local eventConfig = Table_EndlessBattleFieldEvent[event_id]
      if eventConfig and eventConfig.AreaCenter then
        local targetPos = LuaVector3.New(eventConfig.AreaCenter[1], eventConfig.AreaCenter[2], eventConfig.AreaCenter[3])
        if not self.traceSymbolCtrl[i] then
          local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("QuestTraceSymbolCell"))
          cellpfb.transform:SetParent(self.traceContainer.transform, false)
          self.traceSymbolCtrl[i] = QuestTraceSymbolCell.new(cellpfb)
        end
        local range = eventConfig.AreaRange or 10
        local _tempData = {pos = targetPos, range = range}
        self.traceSymbolCtrl[i]:SetData(_tempData)
      end
    elseif self.traceSymbolCtrl[i] then
      self.traceSymbolCtrl[i]:SetData()
    end
  end
end

function MainViewEndlessBattleEventPage:AddViewEvts()
  self:AddListenEvt(TriggerEvent.Enter_EndlessBattleFieldEventArea, self.OnEnterArea)
  self:AddListenEvt(TriggerEvent.Leave_EndlessBattleFieldEventArea, self.OnExitArea)
  self:AddListenEvt(TriggerEvent.Remove_EndlessBattleFieldEventArea, self.OnRemoveArea)
  self:AddListenEvt(ServiceEvent.FuBenCmdEBFMiscDataUpdate, self.HandleMiscDataUpdate)
  self:AddListenEvt(EndlessBattleFieldEvent.EnterCalm, self.OnEnterCalm)
  self:AddListenEvt(EndlessBattleFieldEvent.StatueUpdate, self.Update_Statue)
  self:AddListenEvt(EndlessBattleFieldEvent.EnterFinal, self.Open_Statue)
  self:AddListenEvt(EndlessBattleFieldEvent.EnterEvent, self.OnEnterEvent)
  self:AddListenEvt(TriggerEvent.Enter_EndlessBattle_OccupyArea, self.OnEnterOccupyPoint)
  self:AddListenEvt(TriggerEvent.Leave_EndlessBattle_OccupyArea, self.OnLeaveOccupyPoint)
  self:AddListenEvt(TriggerEvent.Remove_EndlessBattle_OccupyArea, self.OnRemoveOccupyPoint)
  self:AddListenEvt(EndlessBattleFieldEvent.OccupyScoreUpdate, self.Update_PointScore)
  self:AddListenEvt(PVPEvent.EndlessBattleField_Event_End, self.UpdateEvent)
  self:AddListenEvt(PVPEvent.EndlessBattleField_Event_Update, self.HandleEventDataUpdate)
  self:AddListenEvt(PVPEvent.EndlessBattleField_Event_Start, self.HandleEventStart)
  self:AddListenEvt(ServiceEvent.FuBenCmdQueryPvpStatCmd, self.HandleQueryStatCmd)
end

function MainViewEndlessBattleEventPage:OnEnterArea(note)
  self:ClearDelayTick()
  self:EnterTriggle(note.body)
end

function MainViewEndlessBattleEventPage:OnExitArea(note)
  self:ClearDelayTick()
  self:ExitTriggle(note.body)
end

function MainViewEndlessBattleEventPage:OnRemoveArea(note)
  if self.data and self.data.uniqueId == note.body then
    self.delayTick = TimeTickManager.Me():CreateOnceDelayTick(3000, function(owner, deltaTime)
      self:ExitTriggle(self.data.uniqueId)
    end, self, 3)
  else
    self:ExitTriggle(note.body)
  end
end

function MainViewEndlessBattleEventPage:OnEnterCalm(note)
  self.firstEnterTrigger = false
  self.statueMaxEndTime = nil
  self:SetScore()
  self:Hide(self.eventRoot)
  self:EndStatueCD()
  self:Hide(self.statueCDLab)
  local calm_end_time = note.body
  FunctionEndlessBattleField.Me():AddCalmCD(calm_end_time, self.calmCdRoot)
end

function MainViewEndlessBattleEventPage:OnEnterEvent()
  self:Show(self.eventRoot)
  self:SetOverview(true)
  self:Hide_Statue()
  self.statBtnRoot = self.overviewStatBtnRoot
  self:SetStatBtnParent()
end

function MainViewEndlessBattleEventPage:HandleMiscDataUpdate()
  self:SetScore()
  self:SetSchedule()
end

function MainViewEndlessBattleEventPage:ManualPlayTween(tweens)
  if not tweens then
    return
  end
  for i = 1, #tweens do
    tweens[i]:Play(true)
  end
end

local StarPrefix = "battlefield_star_"

function MainViewEndlessBattleEventPage:SetScore()
  local human_value = EndlessBattleGameProxy.Instance:GetStatueValue(Camp_Human)
  local vampire_value = EndlessBattleGameProxy.Instance:GetStatueValue(Camp_Vampire)
  local human_score, vampire_score = self:GetCurScore()
  self.eventScore_d.text = string.format(ZhString.EndlessBattleEvent_Event_Score_Simple, human_score, vampire_score)
  local text = string.format(ZhString.EndlessBattleEvent_Score_Simple, human_value, vampire_value)
  self.score_o.text = text
  self.score_d.text = text
  self:SetStar(self.o_stars, human_value, vampire_value)
  self:SetStar(self.d_stars, human_value, vampire_value)
end

function MainViewEndlessBattleEventPage:SetStar(stars, human_value, vampire_value)
  for i = 1, EndlessEventCountExceptStatue do
    local index = 3
    if i <= human_value then
      index = 2
    else
      local vampire_index = EndlessEventCountExceptStatue + 1 - i
      if vampire_value >= vampire_index then
        index = 1
      end
    end
    stars[i].spriteName = StarPrefix .. tostring(index)
  end
end

function MainViewEndlessBattleEventPage:InitView()
  self.calmCdRoot = self:FindGO("CalmCdRoot")
  self.eventRoot = self:FindGO("EventRoot")
  self.detailRoot = self:FindGO("DetailRoot", self.eventRoot)
  self.d_detail = self:FindGO("Detail", self.detailRoot)
  self.detailStatBtnRoot = self:FindGO("StatBtnRoot", self.detailRoot)
  local starGrid = self:FindGO("StarGrid", self.d_detail)
  self.d_stars = {}
  for i = 1, EndlessEventCountExceptStatue do
    self.d_stars[i] = self:FindComponent("Star" .. tostring(i), UISprite, starGrid)
  end
  self.d_simple = self:FindGO("Simple", self.detailRoot)
  self.eventIcon_s = self:FindComponent("Icon", UISprite, self.d_simple)
  self.leftTimeLab_s = self:FindComponent("Duration", UILabel, self.d_simple)
  self.score_d = self:FindComponent("ScoreLab", UILabel, self.d_simple)
  self.eventScore_d = self:FindComponent("EventScore", UILabel, self.d_simple)
  self.detailTweenTexture = self:FindComponent("DetailTweenBg", UITexture, self.detailRoot)
  PictureManager.Instance:SetBattleFieldTexture(BgTextureName, self.detailTweenTexture)
  self.detailTweenTrigger = self:FindGO("DetailTweenTrigger", self.detailRoot)
  self:AddClickEvent(self.detailTweenTrigger, function()
    self.detailIsSimple = not self.detailIsSimple
    self.isCurSimple = self.detailIsSimple
    self:UpdateSimpleDetail(self.detailIsSimple, self.d_detail, self.d_simple)
  end)
  self.d_csPlayTweens = self.detailTweenTrigger:GetComponents(UIPlayTween)
  self.d_DetailScheduleLab = self:FindComponent("ScheduleLab", UILabel, self.d_detail)
  self:AddClickEvent(self.d_DetailScheduleLab.gameObject, function()
    self:Trace()
  end)
  self.d_SimpleScheduleLab = self:FindComponent("ScheduleLab", UILabel, self.d_simple)
  self.commonRoot = self:FindGO("CommonRoot", self.d_detail)
  self.eventName = self:FindComponent("Name", UILabel, self.commonRoot)
  self.eventIcon = self:FindComponent("Icon", UISprite, self.commonRoot)
  self.eventDesc = self:FindComponent("Desc", UILabel, self.commonRoot)
  self.leftTimeLab = self:FindComponent("Duration", UILabel, self.commonRoot)
  self.winnerDesc = self:FindComponent("WinnerDesc", UILabel, self.commonRoot)
  self.winnerDescBg = self:FindComponent("WinnerDescBg", UISprite, self.winnerDesc.gameObject)
  self.overviewRoot = self:FindGO("OverViewRoot", self.eventRoot)
  self.o_detail = self:FindGO("Detail", self.overviewRoot)
  self.o_simple = self:FindGO("Simple", self.overviewRoot)
  self.overviewStatBtnRoot = self:FindGO("StatBtnRoot", self.overviewRoot)
  self.score_o = self:FindComponent("ScoreLab", UILabel, self.o_simple)
  self.o_DetailScheduleLab = self:FindComponent("ScheduleLab", UILabel, self.o_detail)
  self:AddClickEvent(self.o_DetailScheduleLab.gameObject, function()
    self:Trace()
  end)
  self.o_SimpleScheduleLab = self:FindComponent("ScheduleLab", UILabel, self.o_simple)
  self.overviewTweenTriggerObj = self:FindGO("OverviewTweenTrigger", self.overviewRoot)
  self.o_csPlayTweens = self.overviewTweenTriggerObj:GetComponents(UIPlayTween)
  self:AddClickEvent(self.overviewTweenTriggerObj, function()
    self.overviewIsSimple = not self.overviewIsSimple
    self.isCurSimple = self.overviewIsSimple
    self:UpdateSimpleDetail(self.overviewIsSimple, self.o_detail, self.o_simple)
  end)
  local starGrid = self:FindGO("StarGrid", self.o_detail)
  self.o_stars = {}
  for i = 1, EndlessEventCountExceptStatue do
    self.o_stars[i] = self:FindComponent("Star" .. tostring(i), UISprite, starGrid)
  end
  self.statBtn = self:FindGO("StatBtn")
  self:AddClickEvent(self.statBtn, function()
    self:OnStatBtnClick()
  end)
  local mapId = Game.MapManager:GetMapID()
  local isPve = GameConfig.EndlessBattleField and GameConfig.EndlessBattleField.PveRaidID == mapId or false
  self.statBtn:SetActive(not isPve)
  self.traceContainer = self:FindGO("FrontPanel")
end

function MainViewEndlessBattleEventPage:Trace()
  local trace_event_id
  local events = EndlessBattleFieldProxy.Instance:GetEventList()
  local num = math.min(#events + 1, maxEvent)
  if not self.firstEnterTrigger then
    if 0 < #events then
      trace_event_id = events[#events].eventId
    end
  elseif num == maxEvent then
    trace_event_id = Game.EB_StatueEventId
  else
    local nextEventId = EndlessBattleFieldProxy.Instance:GetNextEventId()
    if nextEventId and Table_EndlessBattleFieldEvent[nextEventId] then
      trace_event_id = nextEventId
    end
  end
  EndlessBattleGameProxy.Instance:TryTraceEvent(trace_event_id)
end

function MainViewEndlessBattleEventPage:UpdateSimpleDetail(is_simple, dObj, sObj)
  if is_simple then
    self:Show(sObj)
    self:Hide(dObj)
  else
    self:Hide(sObj)
    self:Show(dObj)
  end
  if self.detailIsSimple then
    LuaGameObject.SetLocalPositionGO(self.detailStatBtnRoot, -169, -230, 0)
  else
    LuaGameObject.SetLocalPositionGO(self.detailStatBtnRoot, -169, -287, 0)
  end
end

function MainViewEndlessBattleEventPage:InitShow()
  self.mainViewTrans = self.gameObject.transform.parent
  local traceInfoParent = GameObjectUtil.Instance:DeepFindChild(self.mainViewTrans.gameObject, "Anchor_Left")
  self.trans:SetParent(traceInfoParent.transform)
  self.trans.localPosition = LuaGeometry.Const_V3_zero
  self:SetOverview(true)
  self:SetStatBtnParent()
end

function MainViewEndlessBattleEventPage:EnterTriggle(unique_id)
  if not unique_id then
    return
  end
  local event_data = _EventProxy:GetEventDataByUniqueId(unique_id)
  if not event_data then
    return
  end
  if not event_data.staticData then
    return
  end
  self.firstEnterTrigger = true
  if self.statueMaxEndTime then
    return
  end
  self:SetOverview(false)
  self:ResetUIEventData(event_data)
  if not self.inStatueState then
    self:SetStatBtnParent()
  end
end

function MainViewEndlessBattleEventPage:ExitTriggle(unique_id)
  if self.data and self.data.uniqueId ~= unique_id then
    return
  end
  self:_ClearTick()
  self:ResetUIEventData(nil)
  self:SetOverview(true)
  if not self.inStatueState then
    self:SetStatBtnParent()
  end
end

function MainViewEndlessBattleEventPage:SetOverview(isOverview)
  if self.isOverview == isOverview then
    return
  end
  self.isOverview = isOverview
  local cacheSimple, dObj, sObj
  if isOverview then
    cacheSimple = self.overviewIsSimple
    dObj = self.o_detail
    sObj = self.o_simple
    self:HideCurEventDetailRoot()
    self:Hide(self.detailRoot)
    self:Show(self.overviewRoot)
    self.statBtnRoot = self.overviewStatBtnRoot
  else
    cacheSimple = self.detailIsSimple
    dObj = self.d_detail
    sObj = self.d_simple
    self:Hide(self.overviewRoot)
    self:Show(self.detailRoot)
    self.statBtnRoot = self.detailStatBtnRoot
  end
  self:UpdateSimpleDetail(self.isCurSimple, dObj, sObj)
  if self.isCurSimple ~= cacheSimple then
    if isOverview then
      self:ManualPlayTween(self.o_csPlayTweens)
      self.overviewIsSimple = self.isCurSimple
    else
      self:ManualPlayTween(self.d_csPlayTweens)
      self.detailIsSimple = self.isCurSimple
    end
  end
end

function MainViewEndlessBattleEventPage:InitEventsUI()
  self.eventUIRoot = {}
  self.eventUIRoot.occupy = self:FindGO("OccupyRoot", self.detailRoot)
  self.eventUIRoot.kill_monster = self:FindGO("KillMonsterRoot", self.detailRoot)
  self.eventUIRoot.kill_boss = self:FindGO("KillBossRoot", self.detailRoot)
  self.eventUIRoot.coin = self:FindGO("CoinRoot", self.detailRoot)
  self.eventUIRoot.escort = self:FindGO("EscortRoot", self.detailRoot)
end

function MainViewEndlessBattleEventPage:ResetUIEventData(data)
  self.data = data
  self:UpdateEvent()
end

function MainViewEndlessBattleEventPage:UpdateEvent()
  if not self.data then
    return
  end
  local t = self.data.staticData.Type
  self:HideCurEventDetailRoot()
  self.curEventDetailRoot = self.eventUIRoot[t]
  self:Show(self.curEventDetailRoot)
  self:UpdateCommonInfo()
  self.cell = t .. "cell"
  if not self[self.cell] then
    local class = _CellConfig[t] and _CellConfig[t].class
    if class then
      self[self.cell] = class.new(_CellConfig[t].prefab, self.eventUIRoot[t])
    end
  end
  if self[self.cell] then
    self[self.cell]:SetData(self.data)
  end
  self:SetScore()
end

function MainViewEndlessBattleEventPage:GetCurScore()
  local curCell = self[self.cell]
  if curCell then
    return curCell.simpleHumanScoreText or 0, curCell.simpleVampireScoreText or 0
  end
  return 0, 0
end

function MainViewEndlessBattleEventPage:HideCurEventDetailRoot()
  if self.curEventDetailRoot then
    self:Hide(self.curEventDetailRoot)
  end
end

function MainViewEndlessBattleEventPage:UpdateCommonInfo()
  self:_ClearTick()
  if not self.data then
    return
  end
  local staticData = self.data and self.data.staticData
  if not staticData then
    return
  end
  self.eventName.text = _Lang:GetLangByKey(staticData.Name or "")
  self.eventDesc.text = _Lang:GetLangByKey(staticData.Desc or "")
  self:UpdateWin()
  self.eventIcon.spriteName = staticData.Icon
  self.eventIcon:MakePixelPerfect()
  self.eventIcon_s.spriteName = staticData.Icon
  self.eventIcon_s:MakePixelPerfect()
  self.tick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateLeftTime, self, 1)
end

function MainViewEndlessBattleEventPage:ClearDelayTick()
  if self.delayTick then
    TimeTickManager.Me():ClearTick(self, 3)
    self.delayTick = nil
  end
end

function MainViewEndlessBattleEventPage:UpdateWin()
  local data = self.data
  if not data then
    return
  end
  if data.isEnd then
    local winDesc = Win_Desc[data.winner]
    self.eventDesc.gameObject:SetActive(false)
    self.winnerDesc.gameObject:SetActive(true)
    self.winnerDesc.text = winDesc
    local _, c = ColorUtil.TryParseHexString(Win_Desc_BgColor[self.data.winner])
    if _ then
      self.winnerDescBg.color = c
    end
  else
    self.winnerDesc.gameObject:SetActive(false)
    self.eventDesc.gameObject:SetActive(true)
    self.eventDesc.text = _Lang:GetLangByKey(data.staticData.Desc or "")
  end
end

function MainViewEndlessBattleEventPage:HandleEventDataUpdate(note)
  local unique_id = note.body
  EndlessBattleDebug("[无尽战场] 收到更新事件", unique_id)
  if not self.data or self.data.uniqueId ~= unique_id then
    return
  end
  EndlessBattleDebug("[无尽战场] 更新事件", unique_id)
  local data = _EventProxy:GetEventDataByUniqueId(unique_id)
  self:ResetUIEventData(data)
end

function MainViewEndlessBattleEventPage:HandleEventStart(note)
  local unique_id = note.body
  local data = _EventProxy:GetEventDataByUniqueId(unique_id)
  if not data then
    return
  end
  local event_name = data.staticData.Name
  local type = data.staticData.Type
  if EndlessBattleGameProxy.Instance:IsFinalEvent(data.eventId) then
    self.statueMaxEndTime = data.maxEndTime
    self:ClearScheduleTimeTick()
    self:SetOverview(true)
    self:SetFinalEventDesc(event_name)
  else
    self:SetSchedule(event_name, data.startTime)
  end
end

function MainViewEndlessBattleEventPage:SetFinalEventDesc(event_name)
  local str = string.format(ZhString.EndlessBattleEvent_EventDesc, event_name)
  self.o_DetailScheduleLab.text = str
  self.d_DetailScheduleLab.text = str
  self.o_SimpleScheduleLab.text = _FixedFinalEventTime
  self.d_SimpleScheduleLab.text = _FixedFinalEventTime
end

function MainViewEndlessBattleEventPage:UpdateLeftTime()
  if not self.data then
    return
  end
  local cur_time = ServerTime.CurServerTime() / 1000
  local left_time = self.data.maxEndTime - cur_time
  local events = EndlessBattleFieldProxy.Instance:GetEventList()
  if events and #events == EndlessEventCountExceptStatue then
    local finalEvtTime = EndlessBattleFieldProxy.Instance:GetNextEventTime()
    local leftFinalEvtTime = finalEvtTime - cur_time
    left_time = math.min(left_time, leftFinalEvtTime)
  end
  if left_time < 0 then
    left_time = 0
    self:_ClearTick()
  end
  left_time = math.floor(left_time)
  local min, sec = ClientTimeUtil.GetFormatSecTimeStr(left_time)
  local leftTimeLab = self.isCurSimple and self.leftTimeLab_s or self.leftTimeLab
  leftTimeLab.text = string.format(ZhString.MainViewGvgPage_LeftTime, min, sec)
end

function MainViewEndlessBattleEventPage:_ClearTick()
  if self.tick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.tick = nil
  end
end

function MainViewEndlessBattleEventPage:ClearAllTick()
  TimeTickManager.Me():ClearTick(self)
  self.tick = nil
  self.scheduleTimeTick = nil
end

function MainViewEndlessBattleEventPage:OnExit()
  self:Exit()
  MainViewEndlessBattleEventPage.super.OnExit(self)
end

function MainViewEndlessBattleEventPage:Exit()
  self:ClearAllTick()
  self:ClearStatueCell()
  self:_ClearOccupyTip()
  PictureManager.Instance:UnloadBattleFieldTexture(BgTextureName, self.detailTweenTexture)
end

function MainViewEndlessBattleEventPage:HandleQueryStatCmd()
  self.queryStatLocked = false
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.EndlessBattleFieldResultPopUp,
    viewdata = {
      isEnd = not self.isManualQueryStat
    }
  })
end

function MainViewEndlessBattleEventPage:OnStatBtnClick()
  if self.queryStatLocked then
    MsgManager.ShowMsgByID(2247)
    return
  end
  self.queryStatLocked = true
  ServiceFuBenCmdProxy.Instance:CallQueryPvpStatCmd()
end

function MainViewEndlessBattleEventPage:SetStatBtnParent()
  if not self.statBtnRoot then
    return
  end
  self.statBtn.transform:SetParent(self.statBtnRoot.transform, false)
  LuaGameObject.SetLocalPositionGO(self.statBtn, 0, 0, 0)
end

function MainViewEndlessBattleEventPage:Init_StatueRoot()
  local statueRoot = self:FindGO("StatueRoot")
  self:Show(statueRoot)
  self.statueCell = MainViewEB_Statue.new(statueRoot)
  self:Hide_Statue()
  self.statueStatBtnRoot = self:FindGO("StatBtnRoot", statueRoot)
  self.statueCDLab = self:FindComponent("StatueCDLab", UILabel, statueRoot)
  self:Hide(self.statueCDLab)
end

function MainViewEndlessBattleEventPage:Open_Statue()
  self:Show(self.statueCell)
  self:Hide(self.eventRoot)
  self.inStatueState = true
  self.statBtnRoot = self.statueStatBtnRoot
  self:SetStatBtnParent()
  self:StartStatueCD()
end

function MainViewEndlessBattleEventPage:StartStatueCD()
  self:EndStatueCD()
  self:Show(self.statueCDLab)
  self.statueTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateStatueCD, self, 4)
end

function MainViewEndlessBattleEventPage:UpdateStatueCD()
  if not self.statueMaxEndTime then
    return
  end
  local cur_time = ServerTime.CurServerTime() / 1000
  local left_time = self.statueMaxEndTime - cur_time
  if left_time <= 0 then
    left_time = 0
    self.statueCDLab.text = string.format(ZhString.EndlessBattleEvent_StatueCD, 0, 0)
    self:EndStatueCD()
  end
  left_time = math.floor(left_time)
  local min, sec = ClientTimeUtil.GetFormatSecTimeStr(left_time)
  self.statueCDLab.text = string.format(ZhString.EndlessBattleEvent_StatueCD, min, sec)
end

function MainViewEndlessBattleEventPage:EndStatueCD()
  if self.statueTick then
    TimeTickManager.Me():ClearTick(self, 4)
  end
  self.statueTick = nil
end

function MainViewEndlessBattleEventPage:Hide_Statue()
  self:Hide(self.statueCell)
  self:Hide(self.statueCDLab)
  self.inStatueState = false
  self:EndStatueCD()
end

function MainViewEndlessBattleEventPage:Update_Statue()
  if not self.statueCell then
    return
  end
  self.statueCell:SetData()
end

function MainViewEndlessBattleEventPage:ClearStatueCell()
  if not self.statueCell then
    return
  end
  self.statueCell:Destroy()
end

function MainViewEndlessBattleEventPage:OnEnterOccupyPoint(note)
  local point_id = note.body
  EndlessBattleDebug("[无尽战场] 进入祭坛据点 ", point_id)
  self.curPointID = point_id
  self:_UpdateOccupyProgress(point_id)
end

function MainViewEndlessBattleEventPage:OnLeaveOccupyPoint(note)
  local point_id = note.body
  EndlessBattleDebug("[无尽战场] 离开祭坛据点 ", point_id)
  self.curPointID = nil
  self:_HideOccupyTip()
end

function MainViewEndlessBattleEventPage:OnRemoveOccupyPoint(note)
  local point_id = note.body
  EndlessBattleDebug("[无尽战场] 移除祭坛据点 ", point_id)
  self.curPointID = nil
  self:_ClearOccupyTip()
end

function MainViewEndlessBattleEventPage:Update_PointScore(note)
  local point_id = note.body
  if not point_id then
    return
  end
  if not self.curPointID then
    return
  end
  if self.curPointID ~= point_id then
    return
  end
  EndlessBattleDebug("[无尽战场] 更新祭坛据点 ", point_id)
  self:_UpdateOccupyProgress(point_id)
end

function MainViewEndlessBattleEventPage:_UpdateOccupyProgress(point_id)
  local pd = EndlessBattleGameProxy.Instance:GetPointData(point_id)
  if pd and pd:GetProgress() >= 0 then
    self:_UpdateOccupyTip(pd)
  else
    self:_HideOccupyTip()
  end
end

function MainViewEndlessBattleEventPage:_UpdateOccupyTip(pd)
  if not self.occupyPointPerTip then
    local tipContainer = self:FindGO("PointPctTipContainer")
    self.occupyPointPerTipObj = self:LoadPreferb_ByFullPath("GUI/v1/part/GVGPointPerTip", tipContainer)
    self.occupyPointPerTip = EndlessBattleOccupyPointPerTip.new(self.occupyPointPerTipObj)
  end
  self.occupyPointPerTip:Show()
  self.occupyPointPerTip:OnShow(pd)
end

function MainViewEndlessBattleEventPage:_HideOccupyTip(id)
  if self.occupyPointPerTip then
    self.occupyPointPerTip:Hide()
  end
end

function MainViewEndlessBattleEventPage:_ClearOccupyTip()
  if self.occupyPointPerTip then
    GameObject.DestroyImmediate(self.occupyPointPerTipObj)
    self.occupyPointPerTip = nil
  end
end
