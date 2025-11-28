local MainView = class("MainView", ContainerView)
MainView.ViewType = UIViewType.MainLayer
autoImport("HeadImageData")
autoImport("MainViewSkillPage")
autoImport("MainViewItemPage")
autoImport("MainViewInfoPage")
autoImport("MainViewMenuPage")
autoImport("MainUseEquipPopup")
autoImport("MainViewTeamPage")
autoImport("MainViewHeadPage")
autoImport("EndlessTowerConform")
autoImport("MainViewMiniMap")
autoImport("MainviewRaidTaskPage")
autoImport("MainViewChatMsgPage")
autoImport("MainViewAutoAimMonster")
autoImport("MainViewTraceInfoPage")
autoImport("MainViewAuctionPage")
autoImport("RaidCountMsg")
autoImport("MainviewActivityPage")
autoImport("MainViewRecallPage")
autoImport("MainviewInteractPage")
autoImport("QuestTraceCell")
autoImport("MainViewPlayerSelectBoard")
autoImport("MainViewDungeonInfoSubPage")
autoImport("MainView3TeamsPage")
autoImport("AdventureItemData")
autoImport("SignInCatEncounterView")
autoImport("AppStoreCodeRewardPopup")
autoImport("RecallWelcomePopup")
autoImport("CharacterEncounterView")
autoImport("CameraSelectView")
autoImport("OverseaHostHelper")
autoImport("NewContentPushView")
autoImport("GvgWaitQueue")
autoImport("MainViewObserverTwelvePVP")
autoImport("PvpObTeamPwsSubview")
autoImport("PvpObTeamPwsOthelloSubview")
autoImport("PvpObDesertWolfObSubview")
autoImport("DayloginAnniversaryPanel")
autoImport("DayloginNewbiePanel")
autoImport("MainViewAstralPage")
autoImport("MainViewAbyssLakePage")
autoImport("MainViewAbyssDragonPage")
autoImport("MainViewFairyTaleRaidPage")
MainViewShortCutBord = {
  "ShortCutGrid",
  "SkillBord"
}

function MainView:Init()
  self:AddSubView("skillShortCutPage", MainViewSkillPage)
  self.infoPage = self:AddSubView("infoPage", MainViewInfoPage)
  self.activityPage = self:AddSubView("activityPage", MainviewActivityPage)
  self.menuPage = self:AddSubView("menu", MainViewMenuPage)
  self:AddSubView("MainUseEquipPopup", MainUseEquipPopup)
  self:AddSubView("HeadPage", MainViewHeadPage)
  self:AddSubView("TeamPage", MainViewTeamPage)
  self:AddSubView("MainViewItemPage", MainViewItemPage)
  self.miniMapPage = self:AddSubView("MainViewMiniMap", MainViewMiniMap)
  self:AddSubView("MainviewRaidTaskPage", MainviewRaidTaskPage)
  self.chatMsgPage = self:AddSubView("MainViewChatMsgPage", MainViewChatMsgPage)
  self:AddSubView("TraceInfoBord", MainViewTraceInfoPage)
  self.autoAimMonster = self:AddSubView("MainViewAutoAimMonster", MainViewAutoAimMonster)
  self:AddSubView("MainViewRecallPage", MainViewRecallPage)
  if not GameConfig.SystemForbid.Auction then
    self:AddSubView("MainViewAuctionPage", MainViewAuctionPage)
  end
  self:AddSubView("MainviewInteractPage", MainviewInteractPage)
  self:AddSubView("MainViewPlayerSelectBoard", MainViewPlayerSelectBoard)
  self.mainBord = self:FindChild("MainBord")
  self.tempFunc = self:FindGO("TempFunction")
  self.settingBtn = self:FindGO("SettingButton", self.tempFunc)
  self.tempFunc:SetActive(false)
  self.tempMoreOpen = false
  self:FindObjs()
  self:AddBtnListener()
  self:MapViewListener()
  self:TestFloat()
  self.mainviewHeadRoot = self:FindGO("MainViewHeadTargets")
  self.showLoginViewSequence = false
end

function MainView:TestFloat()
  local testButton = self:FindGO("TestFloat")
  self.index = 0
  self:AddClickEvent(testButton, function(g)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PlayerRefluxBackView
    })
  end)
  self:AddDoubleClickEvent(testButton, function(g)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PlayerRefluxView
    })
  end)
end

function MainView:CheckMaskName()
  if FunctionMaskWord.Me():CheckMaskWord(Game.Myself.data.name, GameConfig.MaskWord.PlayerName) then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ChangeNameView
    })
  end
end

function MainView:FindObjs()
  self.panel = self.gameObject:GetComponent(UIPanel)
  self.topFuncs = self:FindChild("TopRightFunc")
  self.moreBord = self:FindChild("MoreBord")
  self.mapBord = self:FindChild("MapBord")
  self.Anchor_DownLeft = self:FindGO("Anchor_DownLeft")
  self.raidMsgRoot = self:FindGO("RaidMsgPos")
end

function MainView:SetMainViewState(stateIndex)
  if stateIndex == 1 then
    self.moreBord:SetActive(false)
    self.mapBord:SetActive(false)
  end
end

function MainView:OnEnter()
  MainView.super.OnEnter(self)
  if FunctionUnLockFunc.Me():CheckCanOpen(100062) then
    self:LaunchLoginViewSequence()
  end
  FunctionGuide.Me():checkClientGuide()
  GvgProxy.Instance:ManualQuerySettleInfo()
  ServiceSceneUser3Proxy.Instance:CallAuthQueryUserCmd()
  ServiceUserEventProxy.Instance:CallQuerySpeedUpUserEvent()
  ServiceItemProxy.Instance:CallQueryBossCardComposeRateCmd()
end

function MainView:OnExit()
  MainView.super.OnExit(self)
end

function MainView:LaunchLoginViewSequence()
  if not self.loginViewSequence then
    self.loginViewSequence = ViewSequenceManager.Me():CreateViewSequence(self)
  end
  if AppStoreCodeRewardPopup.CanShow() then
    self.loginViewSequence:Append("AppStoreCodeRewardPopup")
  end
  if CharacterEncounterView.CanShow() then
    self.loginViewSequence:Append("CharacterEncounterView")
  end
  if RecallWelcomePopup.CanShow() then
    self.loginViewSequence:Append("RecallWelcomePopup")
  end
  if ActivityDetailPanel.CanShow() then
    local activities = ActivityDataProxy.Instance:getActiveActivitys()
    if type(activities) == "table" and next(activities) then
      self.loginViewSequence:Append("ActivityDetailPanel", {
        groupId = activities[1].id
      })
    end
  end
  if SignInCatEncounterView.CanShow() then
    self.loginViewSequence:Append("SignInCatEncounterView")
    self.loginViewSequence:Append("NewServerSignInMapView")
    self.loginViewSequence:Append("SignInCatEncounterView", {isPlayFarewellAnim = true})
  end
  if NewContentPushView.CanShow() then
    self.loginViewSequence:Append("NewContentPushView", {
      callback = function()
        ServiceNUserProxy.Instance:CallNtfPlayActUserCmd(nil, false)
        self:sendNotification(NewContentPushEvent.ShowDoujinshi)
      end
    })
    NewContentPushView.SetAutoOpened()
  end
  local novicecanshow = NoviceShopProxy.Instance:CanShow()
  if novicecanshow then
    self.loginViewSequence:Append("NoviceShopNotifPanel")
  end
  local lotterycanshow = LotteryProxy.Instance:CanShow()
  redlog("lotterycanshow", lotterycanshow)
  if lotterycanshow then
    self.loginViewSequence:Append("LotteryBannerView")
  end
  local newbieLoginIDs = DayloginNewbiePanel.CanShow()
  if newbieLoginIDs then
    for i = 1, #newbieLoginIDs do
      self.loginViewSequence:Append("DayloginNewbiePanel", {
        id = newbieLoginIDs[i],
        mediatorName = "DayloginNewbiePanel_" .. newbieLoginIDs[i]
      })
    end
  end
  if NoviceBattlePassProxy.Instance:GetReturnRewardItems() ~= nil and NoviceBattlePassProxy.Instance:IsReturnBPAvailable() then
    self.loginViewSequence:Append("ReturnRewardView")
  end
  self.loginViewSequence:Launch()
  self.showLoginViewSequence = true
end

function MainView:AddBtnListener()
  self.showskill = false
  self:AddButtonEvent("changeBtn", function(go)
    self.showskill = not self.showskill
  end)
  self:AddClickEvent(self.settingBtn, function()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.SetView
    })
  end)
end

function MainView:MapViewListener()
  self:AddListenEvt(MainViewEvent.ShowOrHide, self.HandleShowOrHide)
  self:AddListenEvt(MainViewEvent.ShowOrHideHead, self.ShowOrHideHeadTargets)
  self:AddListenEvt(MainViewEvent.NewPlayerHide, self.HandleNewPlayerHide)
  self:AddListenEvt(ServiceEvent.QuestQuestStepUpdate, self.HandleStepUpdateQuestTraceBorad)
  self:AddListenEvt(QuestEvent.ProcessChange, self.UpdateQuestTraceBorad)
  self:AddListenEvt(QuestEvent.QuestDelete, self.questDelete)
  self:AddListenEvt(QuestEvent.QuestAdd, self.questAdd)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.SceneLoadHandler)
  self:AddListenEvt(MainViewEvent.ActiveShortCutBord, self.HandleActiveShortCutBord)
  self:AddListenEvt(MainViewEvent.ClearViewSequence, self.OnClearViewSequence)
  self:AddListenEvt(NewContentPushEvent.Push, self.OnNewContentPush)
  self:AddListenEvt(MainViewEvent.AddSubView, self.HandleAddSubView)
  self:AddListenEvt(MainViewEvent.RemoveSubView, self.HandleRemoveSubView)
  self:AddListenEvt(GVGEvent.GVG_QueueAdd, self.HandleGVGWaitQueue)
  self:AddListenEvt(GVGEvent.GVG_QueueUpdate, self.HandleGVGWaitQueue)
  self:AddListenEvt(GVGEvent.GVG_QueueRemove, self.HandleGVGWaitQueue)
  self:AddListenEvt(PVPEvent.TeamTwelve_Launch, self.HandleTwelveLaunch)
  self:AddListenEvt(PVPEvent.TeamTwelve_ShutDown, self.HandleTwelveShutdown)
  self:AddListenEvt(ServiceEvent.MatchCCmdObInitInfoFubenCmd, self.HandleOBPlayer)
  self:AddListenEvt(PlotStoryViewEvent.MainUIFadeIn, self.HandleUIFadeIn)
  EventManager.Me():AddEventListener(MainViewEvent.AddSubView, self.HandleAddSubView, self)
  EventManager.Me():AddEventListener(MainViewEvent.RemoveSubView, self.HandleRemoveSubView, self)
  EventManager.Me():AddEventListener(SystemMsgEvent.RaidAdd, self.OnRaidMsg, self)
  EventManager.Me():AddEventListener(SystemMsgEvent.RaidRemove, self.RemoveRaidMsg, self)
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.OnFinishLoadScene, self)
  self:AddListenEvt(PVPEvent.TeamPws_Launch, self.HandleTeamPwsLaunch)
  self:AddListenEvt(PVPEvent.TeamPws_ShutDown, self.HandleTeamPwsShutdown)
  self:AddListenEvt(PVPEvent.TeamPwsOthello_Launch, self.HandleTeamPwsOthelloLaunch)
  self:AddListenEvt(PVPEvent.TeamPwsOthello_ShutDown, self.HandleTeamPwsOthelloShutdown)
  self:AddListenEvt(PVPEvent.PVP_DesertWolfFightLaunch, self.HandleDesertWolfLaunch)
  self:AddListenEvt(PVPEvent.PVP_DesertWolfFightShutDown, self.HandleDesertWolfShutdown)
  self:AddListenEvt(ServiceEvent.ActivityCmdDaySigninInfoCmd, self.HandleDayLoginPopup)
  self:AddListenEvt(ServiceEvent.UserEventGiftTimeLimitActiveUserEvent, self.HandleTimeLimitShopPopup)
  self:AddListenEvt(MultiProfessionEvent.OpenPanel, self.HandleOpenJobPage)
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncTripleCampInfoFuBenCmd, self.HandlePvpTripleTeamsLaunch)
  self:AddListenEvt(PVPEvent.TripleTeams_Shutdown, self.HandlePvpTripleTeamsShutdown)
  self:AddListenEvt(PVPEvent.TripleTeams_Launch, self.HandleTripleTeamsLaunch)
  self:AddListenEvt(ServiceEvent.FuBenCmdAstralInfoSyncCmd, self.HandleAstralLaunch)
  self:AddListenEvt(PVEEvent.Astral_Shutdown, self.HandleAstralShutdown)
  self:AddListenEvt(TriggerEvent.EnterAybssLakeBattleArea, self.AbyssLakeBoardLaunch)
  self:AddListenEvt(TriggerEvent.RemoveAybssLakeBattleArea, self.AbyssLakeBoardShutDown)
  self:AddListenEvt(TriggerEvent.LeaveAybssLakeBattleArea, self.AbyssLakeBoardShutDown)
  self:AddListenEvt(ServiceEvent.MapAbyssBossUpdateCmd, self.AbyssLakeBoardUpdate)
  self:AddListenEvt(ServiceEvent.RaidCmdAbyssDragonInfoNtfRaidCmd, self.HandleUpdateAbyssDragonInfo)
  self:AddListenEvt(PVEEvent.AbyssDragon_Shutdown, self.HandleAbyssDragonRaidShutdown)
  self:AddListenEvt(ServiceEvent.RaidCmdAbyssDragonHpUpdateRaidCmd, self.HandleUpdateAbyssDragonHp)
  self:AddListenEvt(PVEEvent.FairyTale_Launch, self.HandleFairyTaleRaidLaunch)
  self:AddListenEvt(PVEEvent.FairyTale_Shutdown, self.HandleFairyTaleRaidShutdown)
  self:AddListenEvt(ServiceEvent.FuBenCmdFairyTaleRaidSyncCmd, self.HandleFairyTaleRaidSync)
end

function MainView:SceneLoadHandler()
  self:RemoveRaidMsg()
  GvgProxy.Instance:ResetQueue()
  if Game.MapManager:IsPVEMode_ChasingScene() and not UIManagerProxy.Instance:HasUINode(PanelConfig.ChasingView) then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ChasingView
    })
  end
  self:CheckAybssLakeBoard()
end

function MainView:OnRaidMsg(evt)
  local data = evt.data
  if self.raidMsg == nil then
    self.raidMsg = RaidCountMsg.new(self.raidMsgRoot)
  end
  self.raidMsg:SetData(data)
end

function MainView:RemoveRaidMsg()
  if self.raidMsg then
    self.raidMsg:Exit()
    self.raidMsg = nil
  end
end

function MainView:HandleActiveShortCutBord(note)
  local active = note.body == true
  self:ActiveShortCutBord(active)
end

function MainView:ActiveShortCutBord(b)
  for i = 1, #MainViewShortCutBord do
    local go = self:FindGO(MainViewShortCutBord[i])
    if go then
      go:SetActive(b)
    end
  end
end

function MainView:HandleTopFuncActive(note)
  local data = note.body
  if data == nil then
    return
  end
  if note.type == LoadSceneEvent.FinishLoad then
    self.topFuncs:SetActive(data.dmapID == 0)
    self:SetMainViewState(1)
  end
end

function MainView:HandleShowOrHide(note)
  self:ShowOrHideBord(note.body)
  if note.body == true then
    self.chatMsgPage:OnShow()
  end
end

function MainView:HandleNewPlayerHide(note)
  local headTarget = self:FindGO("MainViewHeadTargets")
  local data = note.body
  local on = data.open
  if on == 1 then
    if TableUtility.ArrayFindIndex(data.id, 1) > 0 then
      self:ShowOrHideBord(false)
    end
    if 0 < TableUtility.ArrayFindIndex(data.id, 2) then
      headTarget:SetActive(false)
    end
    if 0 < TableUtility.ArrayFindIndex(data.id, 7) then
      self.tempFunc:SetActive(true)
      if TableUtility.ArrayFindIndex(data.id, 1) > 0 then
        self.settingBtn.transform.localPosition = LuaGeometry.GetTempVector3(-50, -57, 0)
      else
        self.settingBtn.transform.localPosition = LuaGeometry.GetTempVector3(-208, -57, 0)
      end
    end
  else
    self:ShowOrHideBord(true)
    headTarget:SetActive(true)
    self.tempFunc:SetActive(false)
  end
end

function MainView:HandleAddSubView(data)
  if not data then
    LogUtility.Warning("Cannot get subview data. Adding SubView will be ignored.")
    return
  end
  local t, key, viewName, initParama, subViewData = (type(data))
  if t == "string" then
    key, viewName = data, data
  elseif t == "table" then
    data = data.body or data.data
    local t1 = type(data)
    if t1 == "string" then
      key, viewName = data, data
    elseif t1 == "table" then
      key, viewName, initParama, subViewData = data.key or data.viewName, data.viewName, data.initParama, data.subViewData
    end
  end
  if key then
    if self:GetSubView(key) then
      return
    end
    autoImport(viewName)
    local view = _G[viewName]
    if view then
      return self:AddSubView(key, view, initParama, subViewData)
    else
      LogUtility.WarningFormat("autoImport {0} failed. Adding SubView will be ignored.", viewName)
    end
  end
end

function MainView:HandleRemoveSubView(data)
  if not data then
    LogUtility.Warning("Cannot get subview data. Removing SubView will be ignored.")
    return
  end
  local t, key = (type(data))
  if t == "string" then
    key = data
  elseif t == "table" then
    key = data.body or data.data
  end
  if key then
    self:RemoveSubView(key)
  end
end

function MainView:HandleTwelveLaunch()
  if not PvpObserveProxy.Instance:IsRunning() then
    return
  end
  self.observerTwelvePVP = self:AddSubView("MainViewObserverTwelvePVP", MainViewObserverTwelvePVP)
  self.mainviewHeadRoot:SetActive(false)
end

function MainView:HandleOBPlayer()
  if PvpObserveProxy.Instance:IsRunning() then
    FunctionPlayerUI.Me():MaskAllUI(Game.Myself, PUIVisibleReason.OB)
    Game.Myself:SetVisible(false, LayerChangeReason.GmObserver)
    FunctionPvpObserver.Me():ResetViewPort()
  end
end

function MainView:HandleTwelveShutdown()
  if not PvpObserveProxy.Instance:IsRunning() then
    return
  end
  self.mainviewHeadRoot:SetActive(true)
  if self.observerTwelvePVP then
    Game.Myself:SetVisible(true, LayerChangeReason.GmObserver)
    FunctionPlayerUI.Me():UnMaskAllUI(Game.Myself, PUIVisibleReason.OB)
  end
  self:RemoveSubView("MainViewObserverTwelvePVP")
  self.observerTwelvePVP = nil
end

function MainView:HandleUIFadeIn(params)
  local duration = params.duration or 1
  self.viewFadeDuration = duration
end

function MainView:ShowOrHideBord(isShow)
  self.mainBord:SetActive(isShow)
  local skillBord = self:FindGO("SkillBord")
  skillBord:SetActive(isShow)
end

function MainView:HandleGVGWaitQueue()
  local inQueue = GvgProxy.Instance:GetQueueInfo()
  if inQueue then
    if not self.gvgQueue then
      self.gvgQueue = self:AddSubView("GvgWaitQueue", GvgWaitQueue)
    end
    self.gvgQueue:Update()
  else
    self:RemoveSubView("GvgWaitQueue")
    self.gvgQueue = nil
  end
end

function MainView:ShowOrHideHeadTargets(note)
  local isShow = note.body
  self.mainviewHeadRoot:SetActive(isShow)
end

function MainView:OnShow()
  if self.viewMap then
    for _, viewCtl in pairs(self.viewMap) do
      if viewCtl and viewCtl.OnShow then
        viewCtl:OnShow()
      end
    end
  end
  if self.viewFadeDuration then
    self.panel.alpha = 0
    local ta = TweenAlpha.Begin(self.gameObject, self.viewFadeDuration, 1)
    ta.delay = 2
    self.viewFadeDuration = nil
  end
end

function MainView:OnHide()
  if self.viewMap then
    for _, viewCtl in pairs(self.viewMap) do
      if viewCtl and viewCtl.OnHide then
        viewCtl:OnHide()
      end
    end
  end
end

function MainView:OnFinishLoadScene()
  self:OnNewContentPush()
  if not PvpObserveProxy.Instance:IsRunning() then
    GameFacade.Instance:sendNotification(MainViewEvent.NewPlayerHide, {open = 2})
  end
  self:CheckInvalidReservation()
  if not self.showLoginViewSequence and FunctionUnLockFunc.Me():CheckCanOpen(100062) then
    self:LaunchLoginViewSequence()
  end
end

function MainView:CheckInvalidReservation()
  if #ServantCalendarProxy.Instance.invalidReservation <= 0 then
    return
  end
  MsgManager.ConfirmMsgByID(7318, function()
    ServantCalendarProxy.Instance:ClearInvalidReservation()
  end, nil, nil)
end

function MainView:OnClearViewSequence()
  self:TryInterruptLoginViewSequence(false)
end

function MainView:TryInterruptLoginViewSequence(closeCurrent)
  if not self.loginViewSequence then
    return
  end
  self.loginViewSequence:Interrupt(closeCurrent)
  self.loginViewSequence = nil
  ViewSequenceManager.Me():ClearViewSequence(self)
end

function MainView:OnNewContentPush()
  if NewContentPushView.CanShow() then
    if self.loginViewSequence and self.loginViewSequence.isWorking == true then
      if not self.loginViewSequence:IsHaveView("NewContentPushView") then
        self.loginViewSequence:Append("NewContentPushView", {
          callback = function()
            ServiceNUserProxy.Instance:CallNtfPlayActUserCmd(nil, false)
            self:sendNotification(NewContentPushEvent.ShowDoujinshi)
          end
        })
      end
    else
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.NewContentPushView,
        viewdata = {
          callback = function()
            ServiceNUserProxy.Instance:CallNtfPlayActUserCmd(nil, false)
            self:sendNotification(NewContentPushEvent.ShowDoujinshi)
          end
        }
      })
      if BranchMgr.IsJapan() then
        self:sendNotification(NewContentPushEvent.ShowDoujinshi)
      end
    end
    NewContentPushView.SetAutoOpened()
  end
end

function MainView:checkQuestTraceHide(questid)
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

function MainView:HandlePvpObLaunch(key, view, initParams)
  redlog("[ob] HandlePvpObLaunch", key, PvpObserveProxy.Instance:IsRunning())
  if not PvpObserveProxy.Instance:IsRunning() then
    return
  end
  self.mainviewHeadRoot:SetActive(false)
  self.pvpObObj = self:AddSubView(key, view, initParams)
  local obConfig = GameConfig.ObModeConfig
  if obConfig and (key == "PvpObTeamPwsSubview" or key == "PvpObTeamPwsOthelloSubview") and obConfig.HideChatRoom == 1 then
    self.chatMsgPage:HandlePoringFightBegin()
  end
end

function MainView:HandlePvpObShutdown(key)
  redlog("[ob] HandlePvpObShutdown", key, PvpObserveProxy.Instance:IsRunning())
  if not PvpObserveProxy.Instance:IsRunning() then
    return
  end
  Game.Myself:SetVisible(true, LayerChangeReason.GmObserver)
  FunctionPlayerUI.Me():UnMaskAllUI(Game.Myself, PUIVisibleReason.OB)
  self.mainviewHeadRoot:SetActive(true)
  self:RemoveSubView(key)
  self.pvpObObj = nil
  local obConfig = GameConfig.ObModeConfig
  if obConfig and (key == "PvpObTeamPwsSubview" or key == "PvpObTeamPwsOthelloSubview") and obConfig.HideChatRoom == 1 then
    self.chatMsgPage:HandlePoringFightEnd()
  end
end

function MainView:HandleTeamPwsLaunch()
  self:HandlePvpObLaunch("PvpObTeamPwsSubview", PvpObTeamPwsSubview, {
    proxy = TeamPwsPvpProxy.Instance
  })
end

function MainView:HandleTeamPwsShutdown()
  self:HandlePvpObShutdown("PvpObTeamPwsSubview")
end

function MainView:HandleTeamPwsOthelloLaunch()
  self:HandlePvpObLaunch("PvpObTeamPwsOthelloSubview", PvpObTeamPwsOthelloSubview, {
    proxy = TeamPwsPvpProxy.Instance
  })
end

function MainView:HandleTeamPwsOthelloShutdown()
  self:HandlePvpObShutdown("PvpObTeamPwsOthelloSubview")
end

function MainView:HandleDesertWolfLaunch()
  self:HandlePvpObLaunch("PvpObDesertWolfSubview", PvpObDesertWolfObSubview, {
    proxy = DesertWolfProxy.Instance
  })
end

function MainView:HandleDesertWolfShutdown()
  self:HandlePvpObShutdown("PvpObDesertWolfSubview")
end

function MainView:HandleDayLoginPopup(note)
  local data = note.body
  local show = data.tip
  if not show then
    redlog("不用弹窗")
    return
  end
  if UIManagerProxy.Instance:HasUINodeByName(PanelConfig.DayloginNewbiePanel) then
    return
  end
  if not self.loginViewSequence then
    self.loginViewSequence = ViewSequenceManager.Me():CreateViewSequence(self)
  end
  local infos = data.infos
  if infos and 0 < #infos then
    local newIncome = false
    for i = 1, #infos do
      local single = infos[i]
      local activity = DailyLoginProxy.Instance:GetDaySignInActivity(single.activityid)
      if not activity or single.novicetype then
      elseif activity.redtip then
        local alreadyInSequence = false
        if self.loginViewSequence.sequence and self.loginViewSequence.sequenceViewDatas then
          for j = 1, #self.loginViewSequence.sequence do
            if self.loginViewSequence.sequence[j] == "DayloginNewbiePanel" then
              local vdata = self.loginViewSequence.sequenceViewDatas[j]
              if vdata and vdata.id == single.activityid then
                alreadyInSequence = true
                break
              end
            end
          end
        end
        if not alreadyInSequence then
          newIncome = true
          self.loginViewSequence:Append("DayloginNewbiePanel", {
            id = single.activityid,
            mediatorName = "DayloginNewbiePanel_" .. single.activityid
          })
        end
      end
    end
    if newIncome and ViewSequenceManager.Me():GetWorkingViewSequenceCount() == 0 then
      self.loginViewSequence:Launch()
    end
  end
end

function MainView:HandleTimeLimitShopPopup(note)
  local data = note.body
  local activeID = data.id
  if not self.loginViewSequence then
    self.loginViewSequence = ViewSequenceManager.Me():CreateViewSequence(self)
  end
  self.newInStock = activeID
  local goods = TimeLimitShopProxy.Instance.timeLimitGoods
  if goods and 0 <= #goods then
    xdlog("有商品")
    local newIncome = false
    for i = 1, #goods do
      local single = goods[i]
      if single == self.newInStock and not self.loginViewSequence:IsHaveView("TimeLimitShopView") and not UIManagerProxy.Instance:GetNodeByViewName("TimeLimitShopView") then
        newIncome = true
        self.loginViewSequence:Append("TimeLimitShopView")
        TimeLimitShopProxy.Instance.showView = false
      end
    end
    if newIncome and ViewSequenceManager.Me():GetWorkingViewSequenceCount() == 0 then
      self.loginViewSequence:Launch()
    end
  else
    redlog("无商品")
  end
end

function MainView:HandleOpenJobPage()
  if not self.loginViewSequence then
    self.loginViewSequence = ViewSequenceManager.Me():CreateViewSequence(self)
  end
  local newIncome = false
  if not self.loginViewSequence:IsHaveView("MultiProfessionNewView") then
    newIncome = true
    self.loginViewSequence:Append("MultiProfessionNewView")
  end
  if newIncome and ViewSequenceManager.Me():GetWorkingViewSequenceCount() == 0 then
    self.loginViewSequence:Launch()
  end
end

function MainView:HandlePvpTripleTeamsLaunch()
  if not self.TripleTeamsPage then
    self.TripleTeamsPage = self:AddSubView("TripleTeamsPage", MainView3TeamsPage)
  end
end

function MainView:HandlePvpTripleTeamsShutdown()
  if self.TripleTeamsPage then
    self:RemoveSubView("TripleTeamsPage")
    self.TripleTeamsPage = nil
  end
  if not PvpObserveProxy.Instance:IsRunning() then
    return
  end
  Game.Myself:SetVisible(true, LayerChangeReason.GmObserver)
  FunctionPlayerUI.Me():UnMaskAllUI(Game.Myself, PUIVisibleReason.OB)
  self.mainviewHeadRoot:SetActive(true)
  self.chatMsgPage:HandlePoringFightEnd()
end

function MainView:HandleTripleTeamsLaunch()
  if not PvpObserveProxy.Instance:IsRunning() then
    return
  end
  self.mainviewHeadRoot:SetActive(false)
  self.chatMsgPage:HandlePoringFightBegin()
end

function MainView:HandleAstralLaunch()
  if not self.astralPage then
    self.astralPage = self:AddSubView("AstralPage", MainViewAstralPage)
  end
end

function MainView:HandleAstralShutdown()
  if self.astralPage then
    self:RemoveSubView("AstralPage")
    self.astralPage = nil
  end
end

function MainView:AbyssLakeBoardLaunch()
  if nil == self.abyssLakeBord then
    self.abyssLakeBord = self:AddSubView("MainViewAbyssLakePage", MainViewAbyssLakePage)
  end
  self:CheckAybssLakeBoard()
end

function MainView:AbyssLakeBoardShutDown()
  if nil == self.abyssLakeBord then
    return
  end
  self:RemoveSubView("MainViewAbyssLakePage")
  self.abyssLakeBord = nil
end

function MainView:AbyssLakeBoardUpdate()
end

function MainView:CheckAybssLakeBoard()
  if not self.abyssLakeBord then
    return
  end
  if Game.MapManager:IsRaidMode() then
    self.abyssLakeBord:Hide()
  else
    self.abyssLakeBord:Show()
  end
end

function MainView:HandleUpdateAbyssDragonInfo()
  if not self.abyssDragonPage then
    self.abyssDragonPage = self:AddSubView("AbyssDragonPage", MainViewAbyssDragonPage)
  end
  self.abyssDragonPage:RefreshView()
end

function MainView:HandleAbyssDragonRaidShutdown()
  if self.abyssDragonPage then
    self:RemoveSubView("AbyssDragonPage")
    self.abyssDragonPage = nil
  end
end

function MainView:HandleUpdateAbyssDragonHp()
end

function MainView:HandleFairyTaleRaidLaunch()
  if not self.fairyTaleRaidPage then
    self.fairyTaleRaidPage = self:AddSubView("FairyTaleRaidPage", MainViewFairyTaleRaidPage)
  end
end

function MainView:HandleFairyTaleRaidShutdown()
  if self.fairyTaleRaidPage then
    self:RemoveSubView("FairyTaleRaidPage")
    self.fairyTaleRaidPage = nil
  end
end

function MainView:HandleFairyTaleRaidSync(note)
end

return MainView
