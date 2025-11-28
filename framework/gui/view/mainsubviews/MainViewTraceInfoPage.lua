autoImport("MainViewTaskQuestPage")
autoImport("MainViewGvgPage")
autoImport("CardRaidBord")
autoImport("MainviewGvgFinalPage")
autoImport("MainViewThanatosPage")
autoImport("MainViewThanksgivingRaidPage")
autoImport("MainViewRoguelikePage")
autoImport("MainViewTransferFightPage")
autoImport("MainViewTwelvePVPpage")
autoImport("MainViewRaidCountDownBordPage")
autoImport("MainViewRaidPuzzleBordPage")
autoImport("MainViewComodoRaid")
autoImport("MainViewNewTaskQuestPage")
autoImport("MainViewMultiBossBase")
autoImport("MainViewHeartLockPage")
autoImport("BossRaidBord")
autoImport("MainViewStarArkPage")
autoImport("MainViewHeroJourneyPage")
autoImport("MainViewFairylandPage")
MainViewTraceInfoPage = class("MainViewTraceInfoPage", SubView)

function MainViewTraceInfoPage:OnShow()
  self.taskBord:OnShow()
end

function MainViewTraceInfoPage:OnHide()
  self.taskBord:OnHide()
end

function MainViewTraceInfoPage:Init()
  self.traceNewVer = false
  self:AddViewEvts()
  self:initView()
end

function MainViewTraceInfoPage:initView()
  if not self.traceNewVer then
    self.taskBord = self:AddSubView("classicTaskBord", MainViewTaskQuestPage)
  else
    self.taskBord = self:AddSubView("TaskQuestBord", MainViewNewTaskQuestPage)
  end
  self.classTaskBordGO = self:FindGO("ClassicTraceBord")
  self.classTaskBordGO:SetActive(not self.traceNewVer)
  self.newTaskBordGO = self:FindGO("TaskQuestBord")
  self.newTaskBordGO:SetActive(self.traceNewVer)
  self.traceInfoBord = self:FindGO("TraceInfoBord")
  self.classicPvpFightBord = self:FindGO("ClassicPvpBord")
  self:InitAltManRaid()
  self:InitIPRaid()
end

function MainViewTraceInfoPage:AddViewEvts()
  self:AddListenEvt(MainViewEvent.AddDungeonInfoBord, self.HandleAddDungeonInfoBord)
  self:AddListenEvt(MainViewEvent.RemoveDungeonInfoBord, self.HandleRemoveDungeonInfoBord)
  EventManager.Me():AddEventListener(MainViewEvent.AddDungeonInfoBord, self.HandleAddDungeonInfoBord, self)
  EventManager.Me():AddEventListener(MainViewEvent.RemoveDungeonInfoBord, self.HandleRemoveDungeonInfoBord, self)
  self:AddListenEvt(MyselfEvent.DeathStatus, self.HandleMyselfDeath)
  self:AddListenEvt(MyselfEvent.ReliveStatus, self.HandleMyselfRelive)
  self:AddListenEvt(GVGEvent.GVGDungeonLaunch, self.HandleGuildGvg)
  self:AddListenEvt(ServiceEvent.FuBenCmdGuildFireInfoFubenCmd, self.HandleGuildGvg)
  self:AddListenEvt(ServiceEvent.FuBenCmdGvgRaidStateUpdateFubenCmd, self.HandleGuildGvg)
  self:AddListenEvt(GVGEvent.GVGDungeonShutDown, self.HandleGuildGvg)
  self:AddListenEvt(PVEEvent.HeroJourney_Launch, self.HandleHeroJourney)
  self:AddListenEvt(PVEEvent.HeroJourney_Shutdown, self.HideHeroJourney)
  self:AddListenEvt(PVEEvent.HeroJourney_RemoveCD, self.HideHeroJourney)
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncStartFightStateCmd, self.HandleHeroJourney)
  self:AddListenEvt(PVPEvent.PVP_TransferFightLaunch, self.HandleTransferFightDungeonLaunch)
  self:AddListenEvt(PVPEvent.PVP_TransferFightShutDown, self.HandleTransferFightDungeonShutDown)
  self:AddListenEvt(ServiceEvent.FuBenCmdSuperGvgSyncFubenCmd, self.HandleGVGFinalLaunch)
  self:AddListenEvt(GVGEvent.GVG_FinalFightShutDown, self.HandleGVGFinalShutDown)
  self:AddListenEvt(PVEEvent.PVE_ThanatosLaunch, self.HandleThanatosLaunch)
  self:AddListenEvt(PVEEvent.PVE_ThanatosShutdown, self.HandleThanatosShutDown)
  self:AddListenEvt(PVEEvent.ThanksgivingRaid_Launch, self.HandleEnterThanksgivingRaid)
  self:AddListenEvt(PVEEvent.ThanksgivingRaid_Shutdown, self.HandleExitThanksgivingRaid)
  self:AddListenEvt(ServiceEvent.FuBenCmdThanksGivingMonsterFuBenCmd, self.HandleUpdateThanksgivingRaid)
  self:AddListenEvt(PVEEvent.Roguelike_Launch, self.HandleEnterRoguelike)
  self:AddListenEvt(PVEEvent.Roguelike_Shutdown, self.HandleExitRoguelike)
  self:AddListenEvt(ServiceEvent.RoguelikeCmdRoguelikeRaidInfoCmd, self.HandleUpdateRoguelike)
  self:AddListenEvt(ServiceEvent.RoguelikeCmdRoguelikeScoreModelCmd, self.HandleUpdateRoguelike)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(PVPEvent.TeamTwelve_Launch, self.HandleTeamTwelveLaunch)
  self:AddListenEvt(PVPEvent.TeamTwelve_ShutDown, self.HandleTeamTwelveShutdown)
  self:AddListenEvt(PVEEvent.Einherjar_Launch, self.HandleCountDownStart)
  self:AddListenEvt(PVEEvent.Einherjar_Shutdown, self.HandleCountDownEnd)
  self:AddListenEvt(PVEEvent.EndlessTowerPrivate_Launch, self.HandleCountDownStart)
  self:AddListenEvt(PVEEvent.EndlessTowerPrivate_Shutdown, self.HandleCountDownEnd)
  self:AddListenEvt(MainViewEvent.HideMapForbidNode, self.OnHideMapForbidNode)
  self:AddListenEvt(MainViewEvent.ShowMapForbidNode, self.OnShowMapForbidNode)
  self:AddListenEvt(MyselfEvent.ObservationModeStart, self.OnHideMapForbidNode)
  self:AddListenEvt(MyselfEvent.ObservationModeEnd, self.OnShowMapForbidNode)
  self:AddListenEvt(PVPEvent.EndlessBattleField_Launch, self.EndlessBattleBoardLaunch)
  self:AddListenEvt(ServiceEvent.FuBenCmdEBFEventDataUpdateCmd, self.EndlessBattleBoardUpdate)
  self:AddListenEvt(PVPEvent.EndlessBattleField_Shutdown, self.EndlessBattleBoardShutDown)
  self:AddListenEvt(MainViewEvent.NewPlayerHide, self.HandleHideUIUserCmd)
  self:AddListenEvt(PVEEvent.RaidPuzzle_Launch, self.HandleMayPalaceStart)
  self:AddListenEvt(PVEEvent.RaidPuzzle_Shutdown, self.HandleMayPalaceEnd)
  self:AddListenEvt(PVEEvent.ComodoRaid_Launch, self.HandleComodoRaidLaunch)
  self:AddListenEvt(PVEEvent.ComodoRaid_Shutdown, self.HandleComodoRaidShutdown)
  self:AddListenEvt(PVEEvent.MultiBossRaid_Launch, self.HandleMultiBossRaidLaunch)
  self:AddListenEvt(PVEEvent.MultiBossRaid_Shutdown, self.HandleMultiBossRaidShutdown)
  self:MapCardEvent()
  self:MapTeamPvpRaidEvent()
  self:AddTwelvePvpEvent()
  self:AddListenEvt(PVEEvent.HeartLockRaid_Launch, self.HandleHeartLockLaunch)
  self:AddListenEvt(PVEEvent.HeartLockRaid_Shutdown, self.HandleHeartLockShutdown)
  self:AddListenEvt(PVEEvent.DemoRaid_Launch, self.OnDemoRaidLaunch)
  self:AddListenEvt(PVEEvent.DemoRaidRaid_Shutdown, self.OnDemoRaidShutdown)
  self:BossRaidMapEvent()
  self:AddListenEvt(PVEEvent.StarArk_Launch, self.HandleStarArkLaunch)
  self:AddListenEvt(PVEEvent.StarArk_Shutdown, self.HandleStarArkShutdown)
  self:AddListenEvt(PVPEvent.TripleTeams_Launch, self.HandleTripleTeamsLaunch)
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncTripleCampInfoFuBenCmd, self.HandleTripleTeamsLaunch)
  self:AddListenEvt(PVPEvent.TripleTeams_Shutdown, self.HandleTripleTeamsShutdown)
  self:AddListenEvt(PVEEvent.Astral_Launch, self.HandleAstralRaidLaunch)
  self:AddListenEvt(PVEEvent.Astral_Shutdown, self.HandleAstralRaidShutdown)
  self:AddListenEvt(PVEEvent.SpeceTimeIllusion_Launch, self.HandleSpaceTimeIllusionLaunch)
  self:AddListenEvt(PVEEvent.SpeceTimeIllusion_Shutdown, self.HandleSpaceTimeIllusionShutdown)
  self:AddListenEvt(PVEEvent.FairyTale_Launch, self.HandleFairyTaleRaidLaunch)
  self:AddListenEvt(PVEEvent.FairyTale_Shutdown, self.HandleFairyTaleRaidShutdown)
end

function MainViewTraceInfoPage:HandleAddDungeonInfoBord(data)
  self.taskBord:Hide()
  self.container.HandleAddSubView(self, data)
end

function MainViewTraceInfoPage:HandleRemoveDungeonInfoBord(data)
  self.taskBord:Show()
  self.container.HandleRemoveSubView(self, data)
end

function MainViewTraceInfoPage:HandleMyselfDeath()
  if self.roguelikeBord then
    self.roguelikeBord:UpdateAll()
  end
end

function MainViewTraceInfoPage:HandleMyselfRelive()
  if self.roguelikeBord then
    self.roguelikeBord:UpdateAll()
  end
end

function MainViewTraceInfoPage:HandleGuildGvg()
  if GvgProxy.Instance:IsFireState() or GvgProxy.Instance:IsPerfectDefense() then
    self:_ShowMetalGVG()
  else
    self:_HideMetalGVG()
  end
end

function MainViewTraceInfoPage:_ShowMetalGVG()
  if not self.gvgBord then
    self.gvgBord = self:AddSubView("MainViewGvgPage", MainViewGvgPage)
    self.gvgBord:ResetParent(self.traceInfoBord)
  end
  self.gvgBord:Show()
  self.taskBord:Hide()
  self.curBord = self.gvgBord
end

function MainViewTraceInfoPage:_HideMetalGVG()
  if not self.gvgBord then
    return
  end
  self.gvgBord:Hide()
  self.taskBord:Show()
  self.curBord = nil
end

function MainViewTraceInfoPage:HandleTransferFightDungeonLaunch(note)
  self.taskBord:Hide()
  if not self.transferFightBord then
    self.transferFightBord = self:AddSubView("MainViewTransferFightPage", MainViewTransferFightPage)
    self.transferFightBord:ResetParent(self.traceInfoBord)
  elseif self.transferFightBord then
    self.transferFightBord:Show()
  end
  self.curBord = self.transferFightBord
end

function MainViewTraceInfoPage:HandleTransferFightDungeonShutDown(note)
  self.taskBord:Show()
  if self.transferFightBord then
    self.transferFightBord:Hide()
    self:RemoveSubView("MainViewTransferFightPage")
  end
  self.curBord = nil
end

function MainViewTraceInfoPage:HandleGVGFinalLaunch()
  if self.gvgFinalFight == nil then
    self.gvgFinalFight = self:AddSubView("MainviewGvgFinalPage", MainviewGvgFinalPage)
    self.gvgFinalFight:ResetParent(self.traceInfoBord)
    self.taskBord:Hide()
  end
end

function MainViewTraceInfoPage:HandleGVGFinalShutDown()
  if self.gvgFinalFight then
    self:RemoveSubView("MainviewGvgFinalPage")
    self.taskBord:Show()
  end
  self.gvgFinalFight = nil
end

function MainViewTraceInfoPage:AddCardRaidBord()
  if self.cardRaidBord == nil then
    self.cardRaidBord = CardRaidBord.CreateSelf(self.traceInfoBord)
    self.taskBord:Hide()
  end
end

function MainViewTraceInfoPage:RemoveCardRaidBord()
  if self.cardRaidBord then
    self.cardRaidBord:Destroy()
    self.taskBord:Show()
  end
  self.cardRaidBord = nil
end

function MainViewTraceInfoPage:MapCardEvent()
  self:AddListenEvt(ServiceEvent.PveCardUpdateProcessPveCardCmd, self.HandleCardRaidBordUpdate)
  self:AddListenEvt(ServiceEvent.PveCardSyncProcessPveCardCmd, self.HandleCardRaidBordUpdate)
  self:AddListenEvt(ServiceEvent.PveCardFinishPlayCardCmd, self.HandlePveCardFinish)
  self:AddListenEvt(PVEEvent.PVE_CardLaunch, self.AddCardRaidBord)
  self:AddListenEvt(PVEEvent.PVE_CardShutdown, self.RemoveCardRaidBord)
end

function MainViewTraceInfoPage:HandleCardRaidBordUpdate()
  if self.cardRaidBord == nil then
    return
  end
  self.cardRaidBord:UpdateCards()
end

function MainViewTraceInfoPage:HandlePveCardFinish()
  if self.cardRaidBord == nil then
    return
  end
  self.cardRaidBord:Finish()
end

function MainViewTraceInfoPage:InitAltManRaid()
  self:MapAltmanEvent()
end

function MainViewTraceInfoPage:MapAltmanEvent()
  self:AddListenEvt(ServiceEvent.TeamRaidCmdTeamRaidAltmanShowCmd, self.UpdateAltmanRaidInfo)
  self:AddListenEvt(PVEEvent.Altman_Launch, self.HandleEnterAltmanRaid)
  self:AddListenEvt(PVEEvent.Altman_Shutdown, self.HandleExitAltmanRaid)
end

local Altman_ForbidView = {
  11,
  351,
  1641
}

function MainViewTraceInfoPage:HandleEnterAltmanRaid(note)
  for i = 1, #Altman_ForbidView do
    UIManagerProxy.Instance:SetForbidView(Altman_ForbidView[i], 3606, true)
  end
  self:UpdateAltmanRaidInfo()
end

function MainViewTraceInfoPage:HandleExitAltmanRaid(note)
  for i = 1, #Altman_ForbidView do
    UIManagerProxy.Instance:UnSetForbidView(Altman_ForbidView[i])
  end
  self:HideAltmanRaidInfo()
end

function MainViewTraceInfoPage:GetAltmanInfoBord(noCreate)
  if noCreate then
    return self.altmanInfoBord
  end
  if self.altmanInfoBord == nil then
    autoImport("AltmanInfoBord")
    self.altmanInfoBord = AltmanInfoBord.new(self.traceInfoBord)
  end
  return self.altmanInfoBord
end

function MainViewTraceInfoPage:UpdateAltmanRaidInfo()
  if not Game.MapManager:IsPveMode_AltMan() then
    self:HideAltmanRaidInfo()
    return
  end
  local altmanInfoBord = self:GetAltmanInfoBord()
  altmanInfoBord:ShowSelf()
  altmanInfoBord:Refresh()
  self.taskBord:Hide()
end

function MainViewTraceInfoPage:HideAltmanRaidInfo()
  local altmanInfoBord = self:GetAltmanInfoBord(true)
  if altmanInfoBord then
    altmanInfoBord:HideSelf()
  end
  self.taskBord:Show()
end

function MainViewTraceInfoPage:MapTeamPvpRaidEvent()
  self:AddListenEvt(ServiceEvent.FuBenCmdTeamPwsInfoSyncFubenCmd, self.UpdateTeamPwsInfo)
  self:AddListenEvt(ServiceEvent.FuBenCmdUpdateTeamPwsInfoFubenCmd, self.UpdateTeamPwsInfo)
  self:AddListenEvt(PVPEvent.TeamPws_Launch, self.HandleEnterTeamPws)
  self:AddListenEvt(PVPEvent.TeamPws_ShutDown, self.HandExitTeamPws)
  self:AddListenEvt(ServiceEvent.FuBenCmdOthelloInfoSyncFubenCmd, self.UpdateOthelloInfo)
  self:AddListenEvt(PVPEvent.TeamPwsOthello_Launch, self.HandleEnterOthello)
  self:AddListenEvt(PVPEvent.TeamPwsOthello_ShutDown, self.HandExitOthello)
end

function MainViewTraceInfoPage:GetTeamPwsBord()
  if self.teamPwsBord then
    return self.teamPwsBord
  end
  local cls = TeamPwsBord
  if cls == nil then
    autoImport("TeamPwsBord")
    cls = TeamPwsBord
  end
  self.teamPwsBord = cls.new(self.traceInfoBord)
  return self.teamPwsBord
end

function MainViewTraceInfoPage:UpdateTeamPwsInfo()
  local bord = self:GetTeamPwsBord()
  bord:UpdateInfo()
end

function MainViewTraceInfoPage:HandleEnterTeamPws()
  local bord = self:GetTeamPwsBord()
  bord:Show()
  self.taskBord:Hide()
end

function MainViewTraceInfoPage:HandExitTeamPws()
  local bord = self:GetTeamPwsBord()
  bord:Hide()
  self.taskBord:Show()
end

function MainViewTraceInfoPage:HandleThanatosLaunch()
  if not self.thanatosBord then
    self.thanatosBord = self:AddSubView("MainViewThanatosPage", MainViewThanatosPage)
    self.thanatosBord:ResetParent(self.traceInfoBord)
  end
  self.taskBord:Hide()
  self.thanatosBord:Show()
  self.curBord = self.thanatosBord
end

function MainViewTraceInfoPage:HandleThanatosShutDown()
  self.taskBord:Show()
  if self.thanatosBord then
    self.thanatosBord:Hide()
  end
  self.curBord = nil
end

function MainViewTraceInfoPage:EndlessBattleBoardLaunch()
  if nil ~= self.endlessBattleBord then
    return
  end
  EndlessBattleDebug("[无尽战场] 加载无尽战场主界面")
  autoImport("MainViewEndlessBattleEventPage")
  self.endlessBattleBord = self:AddSubView("MainViewEndlessBattleEventPage", MainViewEndlessBattleEventPage)
  self.endlessBattleBord:Hide()
  self.curBord = self.endlessBattleBord
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.EndlessBattleFieldBannerView
  })
end

function MainViewTraceInfoPage:EndlessBattleBoardUpdate()
  if self.endlessBattleBord then
    self.endlessBattleBord:Show()
  end
end

function MainViewTraceInfoPage:EndlessBattleBoardShutDown()
  if nil == self.endlessBattleBord then
    return
  end
  EndlessBattleDebug("[无尽战场] 移除无尽战场主界面")
  self:RemoveSubView("MainViewEndlessBattleEventPage")
  self.endlessBattleBord = nil
  self.curBord = nil
end

function MainViewTraceInfoPage:InitIPRaid()
  self:MapIPRaidEvent()
end

function MainViewTraceInfoPage:MapIPRaidEvent()
  self:AddListenEvt(PVEEvent.IPRaid_Launch, self.HandleEnterIPRaid)
  self:AddListenEvt(PVEEvent.IPRaid_Shutdown, self.HandleExitIPRaid)
  self:AddListenEvt(ServiceEvent.FuBenCmdKumamotoOperFubenCmd, self.HandleIPRaidInfoUpdate)
  self:AddListenEvt(ServiceEvent.FuBenCmdEndTimeSyncFubenCmd, self.HandleIPRaidEndTimeUpdate)
end

local IPRaid_ForbidView = {
  11,
  351,
  1641
}

function MainViewTraceInfoPage:HandleEnterIPRaid(note)
  redlog("HandleEnterIPRaid")
  for i = 1, #IPRaid_ForbidView do
    UIManagerProxy.Instance:SetForbidView(IPRaid_ForbidView[i], 3606, true)
  end
  self:UpdateIPRaidInfo()
end

function MainViewTraceInfoPage:HandleExitIPRaid(note)
  for i = 1, #IPRaid_ForbidView do
    UIManagerProxy.Instance:UnSetForbidView(IPRaid_ForbidView[i])
  end
  self:HideIPRaidInfo()
end

function MainViewTraceInfoPage:GetIPRaidInfoBord(noCreate)
  if noCreate then
    return self.iPRaidBord
  end
  if self.iPRaidBord == nil then
    autoImport("IPRaidBord")
    self.iPRaidBord = IPRaidBord.new(self.traceInfoBord)
  end
  return self.iPRaidBord
end

function MainViewTraceInfoPage:UpdateIPRaidInfo()
  if not Game.MapManager:IsPveMode_IPRaid() then
    self:HideIPRaidInfo()
    return
  end
  local iPRaidBord = self:GetIPRaidInfoBord()
  if iPRaidBord then
    iPRaidBord:ShowSelf()
    iPRaidBord:Refresh()
  end
  self.taskBord:Hide()
end

function MainViewTraceInfoPage:HideIPRaidInfo()
  local iPRaidBord = self:GetIPRaidInfoBord(true)
  if iPRaidBord then
    iPRaidBord:HideSelf()
  end
  self.taskBord:Show()
end

function MainViewTraceInfoPage:HandleIPRaidInfoUpdate(note)
  local iPRaidBord = self:GetIPRaidInfoBord()
  if iPRaidBord and GameConfig.KumamotoBear.Integralshow ~= 0 then
    iPRaidBord:HideSelf()
    return
  end
  if note and note.body and note.body.type == FuBenCmd_pb.EKUMAMOTOOPER_SCORE and iPRaidBord then
    iPRaidBord:RefreshRank(note.body.value)
  end
end

function MainViewTraceInfoPage:HandleIPRaidEndTimeUpdate(note)
  local iPRaidBord = self:GetIPRaidInfoBord()
  if iPRaidBord and GameConfig.KumamotoBear.Integralshow ~= 0 then
    iPRaidBord:HideSelf()
    return
  end
  if note and note.body and note.body and note.body.endtime then
    redlog("endtime", note.body.endtime)
    iPRaidBord:RefreshLeftTime(note.body.endtime)
  end
end

function MainViewTraceInfoPage:HandleEnterThanksgivingRaid()
  if not self.thanksgivingBord then
    self.thanksgivingBord = self:AddSubView("MainViewThanksgivingRaidPage", MainViewThanksgivingRaidPage)
  end
  self.taskBord:Hide()
  self.thanksgivingBord:Show()
  self.curBord = self.thanksgivingBord
end

function MainViewTraceInfoPage:HandleExitThanksgivingRaid()
  self.taskBord:Show()
  if self.thanksgivingBord then
    self.thanksgivingBord:Hide()
  end
  self.curBord = nil
end

function MainViewTraceInfoPage:HandleUpdateThanksgivingRaid(note)
  if not self.thanksgivingBord then
    return
  end
  self.thanksgivingBord:UpdateAll(note.body)
end

function MainViewTraceInfoPage:GetOthelloBord()
  if self.othelloBord then
    return self.othelloBord
  end
  local cls = OthelloPVPBord
  if cls == nil then
    autoImport("OthelloPVPBord")
    cls = OthelloPVPBord
  end
  self.othelloBord = cls.new(self.traceInfoBord)
  return self.othelloBord
end

function MainViewTraceInfoPage:UpdateOthelloInfo()
  local bord = self:GetOthelloBord()
  bord:UpdateInfo()
end

function MainViewTraceInfoPage:HandleEnterOthello()
  local bord = self:GetOthelloBord()
  bord:Show()
  self.taskBord:Hide()
end

function MainViewTraceInfoPage:HandExitOthello()
  local bord = self:GetOthelloBord()
  bord:Hide()
  self.taskBord:Show()
end

function MainViewTraceInfoPage:HandleEnterRoguelike()
  if not self.roguelikeBord then
    self.roguelikeBord = self:AddSubView("MainViewRoguelikePage", MainViewRoguelikePage)
  end
  self.taskBord:Hide()
  self.roguelikeBord:Show()
  self.curBord = self.roguelikeBord
end

function MainViewTraceInfoPage:HandleExitRoguelike()
  self.taskBord:Show()
  if self.roguelikeBord then
    self.roguelikeBord:Hide()
  end
  self.curBord = nil
end

function MainViewTraceInfoPage:HandleUpdateRoguelike()
  if self.roguelikeBord then
    self.roguelikeBord:UpdateAll()
  end
end

function MainViewTraceInfoPage:HandleItemUpdate()
  if self.roguelikeBord then
    self.roguelikeBord:UpdateAll()
  end
end

function MainViewTraceInfoPage:AddTwelvePvpEvent()
  self:AddListenEvt(TwelvePVPEvent.UpdateFrontlineTowerHP, self.UpdateTwelveInfo)
  self:AddListenEvt(TwelvePVPEvent.UpdateFrontlineTowerID, self.UpdateTwelveInfo)
  self:AddListenEvt(TwelvePVPEvent.UpdateCrystalExp, self.UpdateTwelveInfo)
  self:AddListenEvt(TwelvePVPEvent.UpdateGold, self.UpdateTwelveInfo)
  self:AddListenEvt(TwelvePVPEvent.UpdateEndTime, self.UpdateTwelveInfo)
  self:AddListenEvt(ServiceEvent.FuBenCmdRaidItemSyncCmd, self.UpdateTwelveInfo)
  self:AddListenEvt(ServiceEvent.FuBenCmdRaidItemUpdateCmd, self.UpdateTwelveInfo)
  self:AddListenEvt(ServiceEvent.FuBenCmdTwelvePvpBuildingHpUpdateCmd, self.UpdateTwelveInfo)
end

function MainViewTraceInfoPage:HandleTeamTwelveLaunch()
  if PvpObserveProxy.Instance:IsRunning() then
    return
  end
  if not self.twelvePVPpage then
    self.twelvePVPpage = self:AddSubView("MainViewTwelvePVPpage", MainViewTwelvePVPpage)
  end
  self.taskBord:Hide()
  self.twelvePVPpage:Show()
  self.twelvePVPpage:ResetDatas()
  self.curBord = self.twelvePVPpage
end

function MainViewTraceInfoPage:HandleTeamTwelveShutdown()
  if PvpObserveProxy.Instance:IsRunning() then
    return
  end
  self.taskBord:Show()
  if self.twelvePVPpage then
    self.twelvePVPpage:Hide()
  end
  self.curBord = nil
end

function MainViewTraceInfoPage:UpdateTwelveInfo()
end

function MainViewTraceInfoPage:HandleCountDownStart()
  self.taskBord:Hide()
  if not self.commonCountDownBord then
    self.commonCountDownBord = self:AddSubView("MainViewRaidCountDownBordPage", MainViewRaidCountDownBordPage)
    self.commonCountDownBord:ResetParent(self.traceInfoBord)
  elseif self.commonCountDownBord then
    self.commonCountDownBord:Show()
  end
  self.curBord = self.commonCountDownBord
end

function MainViewTraceInfoPage:HandleCountDownEnd()
  self.taskBord:Show()
  if self.commonCountDownBord then
    self.commonCountDownBord:Hide()
    self:RemoveSubView("MainViewRaidCountDownBordPage")
  end
  self.commonCountDownBord = nil
  self.curBord = nil
end

function MainViewTraceInfoPage:HandleHeroJourney()
  local show = FunctionPve.Me():CheckShowFightCD()
  if show then
    local endTime, npcID, duration = FunctionPve.Me():TrySetStartFightInfo()
    if not endTime or not npcID then
      self:HideHeroJourney()
    elseif FunctionPve.Me():IsFightPause() then
      self:PauseHeroJournery()
    else
      self:ShowHeroJourney(endTime, npcID, duration)
    end
  else
    self:HideHeroJourney()
  end
end

function MainViewTraceInfoPage:ShowHeroJourney(time_stamp, npc_id, duration)
  if not self.heroJourneyBord then
    self.heroJourneyBord = self:AddSubView("MainViewHeroJourney", MainViewHeroJourneyPage)
  elseif self.heroJourneyBord then
    self.heroJourneyBord:Show()
  end
  self.heroJourneyBord:UpdatePage({
    time_stamp,
    npc_id,
    duration
  })
  self.taskBord:Hide()
  self.curBord = self.heroJourneyBord
end

function MainViewTraceInfoPage:PauseHeroJournery()
  if not self.heroJourneyBord then
    return
  end
  self.heroJourneyBord:PauseTick()
end

function MainViewTraceInfoPage:HideHeroJourney()
  if not self.heroJourneyBord then
    return
  end
  self.heroJourneyBord:Hide()
  self.taskBord:Show()
  self.curBord = nil
end

function MainViewTraceInfoPage:OnHideMapForbidNode()
  self.traceInfoBord:SetActive(false)
end

function MainViewTraceInfoPage:OnShowMapForbidNode()
  self.traceInfoBord:SetActive(true)
end

function MainViewTraceInfoPage:HandleHideUIUserCmd(note)
  local data = note.body
  local on = data.open
  if on and on == 1 then
    if TableUtility.ArrayFindIndex(data.id, 8) > 0 then
      self.traceInfoBord:SetActive(false)
    end
  else
    self.traceInfoBord:SetActive(true)
  end
end

function MainViewTraceInfoPage:HandleMayPalaceStart()
  self.taskBord:Hide()
  if not self.MayPalaceCtrl then
    local container = self:FindGO("TraceInfoBord")
    self.mayPalaceBord = self:LoadPreferb_ByFullPath("GUI/v1/part/MayPalaceInfoBord", container)
    self.mayPalaceCtrl = MainViewRaidPuzzleBordPage.new(self.mayPalaceBord)
  end
  self.curBord = self.mayPalaceBord
end

function MainViewTraceInfoPage:HandleMayPalaceEnd()
  self.taskBord:Show()
  GameObject.DestroyImmediate(self.mayPalaceBord)
  if self.mayPalaceCtrl then
    self.mayPalaceCtrl:OnHide()
    self.mayPalaceCtrl = nil
  end
  self.curBord = nil
end

function MainViewTraceInfoPage:HandleComodoRaidLaunch()
  if not self.comodoRaidPage then
    self.comodoRaidPage = self:AddSubView("MainViewComodoRaid", MainViewComodoRaid)
  end
  self.taskBord:Hide()
  self.comodoRaidPage:Show()
  self.comodoRaidPage:ResetDatas()
  self.curBord = self.comodoRaidPage
end

function MainViewTraceInfoPage:HandleComodoRaidShutdown()
  self.taskBord:Show()
  if self.comodoRaidPage then
    self.comodoRaidPage:Hide()
  end
  self.curBord = nil
end

function MainViewTraceInfoPage:HandleMultiBossRaidLaunch()
  if not self.multiBossRaidPage then
    self.multiBossRaidPage = self:AddSubView("MainViewMultiBossBase", MainViewMultiBossBase)
  end
  self.taskBord:Hide()
  self.multiBossRaidPage:Show()
  self.multiBossRaidPage:ResetDatas()
  self.curBord = self.multiBossRaidPage
end

function MainViewTraceInfoPage:HandleMultiBossRaidShutdown()
  self.taskBord:Show()
  if self.multiBossRaidPage then
    self.multiBossRaidPage:Hide()
  end
  self.curBord = nil
end

function MainViewTraceInfoPage:HandleHeartLockLaunch()
  if not self.heartLockPage then
    self.heartLockPage = self:AddSubView("MainViewHeartLockPage", MainViewHeartLockPage)
    self.heartLockPage:ResetParent(self.traceInfoBord)
  end
  self.taskBord:Hide()
  self.heartLockPage:Show()
  self.curBord = self.heartLockPage
end

function MainViewTraceInfoPage:HandleHeartLockShutdown()
  self.taskBord:Show()
  if self.heartLockPage then
    self.heartLockPage:Hide()
  end
  self.curBord = nil
end

function MainViewTraceInfoPage:HandleQuestTraceSwitch(note)
  xdlog("HandleQuestTraceSwitch")
  self:RefreshMapLimitQuest()
  if self.mapLimitGroup then
    if not self.classicTaskBord then
      self.classicTaskBord = self:AddSubView("ClassicTraceBord", MainViewTaskQuestPage)
    end
    self.taskBord:Hide()
    self.classicTaskBord:Show()
    self.curBord = self.classicTaskBord
  else
    if self.classicTaskBord then
      self.classicTaskBord:Hide()
    end
    self.taskBord:Show()
    self.curBord = nil
  end
end

function MainViewTraceInfoPage:RefreshMapLimitQuest()
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

function MainViewTraceInfoPage:OnDemoRaidLaunch()
  self.taskBord:Hide()
end

function MainViewTraceInfoPage:OnDemoRaidShutdown()
  self.taskBord:Show()
end

function MainViewTraceInfoPage:AddBossRaidBord()
  if self.bossRaidBord == nil then
    self.bossRaidBord = BossRaidBord.CreateSelf(self.traceInfoBord)
    self.taskBord:Hide()
  end
end

function MainViewTraceInfoPage:RemoveBossRaidBord()
  if self.bossRaidBord then
    self.bossRaidBord:Destroy()
    self.taskBord:Show()
  end
  self.bossRaidBord = nil
end

function MainViewTraceInfoPage:CountdownUpdateBossRaidBord(data)
  if self.bossRaidBord then
    self.bossRaidBord:CountdownUpdateBossRaidBord(data)
  end
end

function MainViewTraceInfoPage:BossRaidMapEvent()
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncBossSceneInfo, self.HandleBossRaidBordUpdate)
  self:AddListenEvt(PVEEvent.BossRaid_Launch, self.AddBossRaidBord)
  self:AddListenEvt(PVEEvent.BossRaid_Shutdown, self.RemoveBossRaidBord)
  self:AddListenEvt(PVEEvent.BossRaid_CountdownUpdate, self.CountdownUpdateBossRaidBord)
  self:AddListenEvt(PVEEvent.NewHeadwearRaid_Launch, self.HandleNewHeadwearRaidLaunch)
end

function MainViewTraceInfoPage:HandleNewHeadwearRaidLaunch()
  self.taskBord:Hide()
end

function MainViewTraceInfoPage:HandleBossRaidBordUpdate()
  if self.bossRaidBord == nil then
    return
  end
  self.bossRaidBord:UpdateBoss()
end

function MainViewTraceInfoPage:HandleStarArkLaunch()
  if not self.starArkPage then
    self.starArkPage = self:AddSubView("MainViewStarArkPage", MainViewStarArkPage)
    self.starArkPage:ResetParent(self.traceInfoBord)
  end
  self.taskBord:Hide()
  self.starArkPage:Show()
  self.curBord = self.starArkPage
end

function MainViewTraceInfoPage:HandleStarArkShutdown()
  self.taskBord:Show()
  if self.starArkPage then
    self.starArkPage:Hide()
  end
  self.curBord = nil
end

function MainViewTraceInfoPage:HandleTripleTeamsLaunch()
  self.taskBord:Hide()
end

function MainViewTraceInfoPage:HandleTripleTeamsShutdown()
  self.taskBord:Show()
end

function MainViewTraceInfoPage:HandleAstralRaidLaunch()
  self.taskBord:Hide()
end

function MainViewTraceInfoPage:HandleAstralRaidShutdown()
  self.taskBord:Show()
end

function MainViewTraceInfoPage:HandleSpaceTimeIllusionLaunch()
  if not self.spaceTimeIllusionPage then
    self.spaceTimeIllusionPage = self:AddSubView("MainViewFairylandPage", MainViewFairylandPage)
    self.spaceTimeIllusionPage:ResetParent(self.traceInfoBord)
  end
  self.taskBord:Hide()
  self.spaceTimeIllusionPage:Show()
  self.curBord = self.spaceTimeIllusionPage
end

function MainViewTraceInfoPage:HandleSpaceTimeIllusionShutdown()
  self.taskBord:Show()
  if self.spaceTimeIllusionPage then
    self:RemoveSubView("MainViewFairylandPage")
    self.spaceTimeIllusionPage = nil
  end
  self.curBord = nil
end

function MainViewTraceInfoPage:HandleFairyTaleRaidLaunch()
  self.taskBord:Hide()
end

function MainViewTraceInfoPage:HandleFairyTaleRaidShutdown()
  self.taskBord:Show()
end
