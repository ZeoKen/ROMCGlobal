PvpContainerView = class("PvpContainerView", ContainerView)
PvpContainerView.ViewType = UIViewType.ChasingViewLayer
autoImport("TeamPwsView")
autoImport("FreeBattleView")
autoImport("ClassicBattleView")
autoImport("MultiPvpView")
autoImport("CupModeView")
autoImport("CupModeView_MultiServer")
autoImport("CompetiveModeView")
autoImport("PvpTypeCell")
autoImport("TeamPwsFreeModeView")
autoImport("MultiPvpFreeModeView")
autoImport("MobaPVPView")
autoImport("MobaPvpFreeModeView")
autoImport("PvpCustomModeView")
autoImport("MultiPvpCustomModeView")
local tempVector3 = LuaVector3.Zero()

function PvpContainerView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end

function PvpContainerView:FindObjs()
  self.backBtn = self:FindGO("BackBtn")
  self.pvpTypeChooseRoot = self:FindGO("PvpTypeChooseRoot")
  self.pvpTypeScrollView = self:FindGO("PvpTypeScrollView", self.pvpTypeChooseRoot):GetComponent(UIScrollView)
  self.pvpTypeGrid = self:FindGO("PvpTypeGrid", self.pvpTypeChooseRoot):GetComponent(UIGrid)
  self.competiveModeToggle = self:FindGO("CompetiveModeToggle")
  self.mulitiPvpToggle = self:FindGO("MulitiPvpToggle")
  self.classicModeToggle = self:FindGO("ClassicModeToggle")
  self.mobaModeToggle = self:FindGO("MobaModeToggle")
  self.bgRoot = {}
  self.bgRoot[11] = self:FindGO("BgRoot", self.competiveModeToggle)
  self.bgRoot[14] = self:FindGO("BgRoot", self.mulitiPvpToggle)
  self.bgRoot[13] = self:FindGO("BgRoot", self.classicModeToggle)
  self.bgRoot[15] = self:FindGO("BgRoot", self.mobaModeToggle)
  self.competiveModeToggle_Texture = self:FindGO("BgTexture", self.competiveModeToggle):GetComponent(UITexture)
  self.mulitiPvpToggle_Texture = self:FindGO("BgTexture", self.mulitiPvpToggle):GetComponent(UITexture)
  self.classicModeToggle_Texture = self:FindGO("BgTexture", self.classicModeToggle):GetComponent(UITexture)
  self.mobaModeToggle_Texture = self:FindGO("BgTexture", self.mobaModeToggle):GetComponent(UITexture)
  self.competiveModeToggle_OpenLabel = self:FindGO("OpenLabel", self.competiveModeToggle):GetComponent(UILabel)
  self.competiveModeToggle_OpenLabelBg = self:FindGO("OpenBg", self.competiveModeToggle_OpenLabel.gameObject):GetComponent(UISprite)
  self.competiveModeToggle_txt_season = self:FindGO("txt_season", self.competiveModeToggle_OpenLabel.gameObject):GetComponent(UITexture)
  self.mulitiPvpToggle_OpenLabel = self:FindGO("OpenLabel", self.mulitiPvpToggle):GetComponent(UILabel)
  self.mulitiPvpToggle_OpenLabelBg = self:FindGO("OpenBg", self.mulitiPvpToggle_OpenLabel.gameObject):GetComponent(UISprite)
  self.mulitiPvpToggle_txt_season = self:FindGO("txt_season", self.mulitiPvpToggle_OpenLabel.gameObject):GetComponent(UITexture)
  self.mobaModeToggle_LabelGO = self:FindGO("OpenLabel", self.mobaModeToggle)
  self.subViewContainer = self:FindGO("SubViewContainer")
  self.subViewContainer_TweenAlpha = self.subViewContainer:GetComponent(TweenAlpha)
  self.competiveViewObj = self:FindGO("TeamPwsView")
  self.classicBattleViewObj = self:FindGO("ClassicBattleView")
  self.multiPvpViewObj = self:FindGO("MultiPvpView")
  self.mobaPvpViewObj = self:FindGO("MobaPVPView")
  self:AddClickEvent(self.backBtn, function()
    if not self.pageStep or self.pageStep == 1 then
      self:CloseSelf()
    else
      self:SwitchViewStatus(1)
    end
  end)
  self.curPvpTypeCell = self:FindGO("CurPvpTypeCell")
  self.curPvpType_Texture = self:FindGO("Texture", self.curPvpTypeCell):GetComponent(UITexture)
  self.curPvpType_Label = self:FindGO("Label", self.curPvpTypeCell):GetComponent(UILabel)
  self.curPvpTypeCell_TweenPos = self.curPvpTypeCell:GetComponent(TweenPosition)
  self.bgTexture1 = self:FindGO("BgTexture"):GetComponent(UITexture)
  self.bgTexture2 = self:FindGO("BgTexture2"):GetComponent(UITexture)
end

function PvpContainerView:AddEvts()
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.HandleLoadScene)
  self:AddListenEvt(PVPEvent.PVPDungeonLaunch, self.HandleDungeonLaunch)
  self:AddListenEvt(PVPEvent.TeamPws_Launch, self.CloseSelf)
  self:AddListenEvt(PVPEvent.TeamPwsOthello_Launch, self.CloseSelf)
  self:AddListenEvt(PVPEvent.TeamTwelve_Launch, self.CloseSelf)
  self:AddListenEvt(CupModeEvent.SeasonInfo_6v6, self.RefreshScheduleStatus)
  self:AddListenEvt(CupModeEvent.ScheduleChanged_6v6, self.RefreshScheduleStatus)
  self:AddListenEvt(ServiceEvent.MatchCCmdQueryTeamPwsTeamInfoMatchCCmd, self.HandleQueryTeamPwsTeamInfo)
  self:AddListenEvt(PVPEvent.TwelveChamption_ScheduleChanged, self.RefreshScheduleStatus_12v12)
  self:AddListenEvt(ServiceEvent.MatchCCmdQueryTwelveSeasonInfoMatchCCmd, self.RefreshScheduleStatus_12v12)
end

function PvpContainerView:HandleDungeonLaunch(note)
  self:CloseSelf()
end

function PvpContainerView:AddViewEvts()
end

local PVPTYPE = {
  [11] = {
    name = "sports_6v6",
    text = "",
    desc = ZhString.PvpTypeName_TeamPws_Desc
  },
  [14] = {
    name = "sports_12v12",
    text = "",
    desc = ZhString.PvpTypeName_TwelvePVP_Desc
  },
  [13] = {
    name = "sports_jingdian",
    text = ZhString.PvpTypeName_Classic
  },
  [15] = {
    name = "sports_3v3v3",
    text = "",
    desc = ZhString.PvpTypeName_3v3v3_Desc
  }
}

function PvpContainerView:InitShow()
  self.pvpTypeChooseRoot:SetActive(true)
  self.subViewContainer:SetActive(false)
  self.competiveModeView = self:AddSubView("CompetiveModeView", CompetiveModeView)
  self.classicBattleView = self:AddSubView("ClassicBattleView", ClassicBattleView)
  self.multiPvpView = self:AddSubView("MultiPvpView", MultiPvpView)
  self.mobaPvpView = self:AddSubView("MobaPVPView", MobaPVPView)
  self:AddTabChangeEvent(self.competiveModeToggle, self.competiveViewObj, PanelConfig.CompetiveModeView)
  self:AddTabChangeEvent(self.classicModeToggle, self.classicBattleViewObj, PanelConfig.ClassicBattleView)
  self:AddTabChangeEvent(self.mulitiPvpToggle, self.multiPvpViewObj, PanelConfig.MultiPvpView)
  self:AddTabChangeEvent(self.mobaModeToggle, self.mobaPvpViewObj, PanelConfig.MobaPVPView)
  local teamPwsOpen = not GameConfig.SystemForbid.TeamPws and not FunctionNpcFunc.Me():CheckSingleFuncForbidState(7)
  self.competiveModeToggle:GetComponent(Collider).enabled = teamPwsOpen
  local teamPwsFunstateValid = not Table_FuncState[7] or FunctionUnLockFunc.checkFuncStateValid(7)
  self.competiveModeToggle:SetActive(teamPwsFunstateValid)
  local pvp12Open = not GameConfig.SystemForbid.TwelvePvpForbid
  local twelveValid = false
  if ISNoviceServerType then
    twelveValid = not FunctionUnLockFunc.CheckForbiddenByFuncState("TwelvePvp") and not GameConfig.SystemForbid.pvp12
  else
    twelveValid = (not Table_FuncState[123] or FunctionUnLockFunc.checkFuncStateValid(123)) and not GameConfig.SystemForbid.pvp12
  end
  if twelveValid and (BranchMgr.IsJapan() or BranchMgr.IsEU()) then
    twelveValid = pvp12Open
  end
  self.mulitiPvpToggle:SetActive(twelveValid)
  local tripleValid = not Table_FuncState[1014] or FunctionUnLockFunc.checkFuncStateValid(1014)
  self.mobaModeToggle:SetActive(tripleValid)
  self.mobaModeToggle_LabelGO:SetActive(PvpProxy.Instance:IsTripleTeamPwsSeasonOpen())
  self.pvpTypeGrid:Reposition()
  local defaultTab = PanelConfig.ClassicBattleView.tab
  if teamPwsOpen and teamPwsFunstateValid then
    defaultTab = PanelConfig.CompetiveModeView.tab
  elseif twelveValid then
    defaultTab = PanelConfig.MultiPvpView.tab
  elseif teamRelaxOpen then
    defaultTab = PanelConfig.FreeBattleView.tab
  end
  self.curPvpTypeCell:SetActive(false)
  if self.viewdata.view and self.viewdata.view.tab then
    local tab = self.viewdata.view.tab
    if tab == PanelConfig.YoyoViewPage.tab or tab == PanelConfig.DesertWolfView.tab or tab == PanelConfig.GorgeousMetalView.tab then
      self:TabChangeHandler(PanelConfig.ClassicBattleView.tab)
      self.classicBattleView:TabChangeHandlerWithPanelID(tab)
    else
      self:TabChangeHandler(tab)
    end
  end
  self:UpdateTabDesc()
end

function PvpContainerView:TabChangeHandler(key)
  if self.currentKey ~= key then
    PvpContainerView.super.TabChangeHandler(self, key)
    self.currentKey = key
  end
  self:SwitchViewStatus(2)
end

function PvpContainerView:UpdateSubView(key)
  if key == PanelConfig.CompetiveModeView.tab then
    self.competiveModeView:UpdateView()
  elseif key == PanelConfig.FreeBattleView.tab then
    self.freeBattleView:UpdateView()
  elseif key == PanelConfig.ClassicBattleView.tab then
    self.classicBattleView:UpdateView()
  elseif key == PanelConfig.MultiPvpView.tab then
    self.multiPvpView:UpdateView()
  end
end

function PvpContainerView:handleClickPvpTypeCell(cellCtrl)
end

function PvpContainerView:SwitchViewStatus(index)
  if index == 1 then
    self.subViewContainer:SetActive(false)
    self.curPvpTypeCell:SetActive(true)
    self.curPvpTypeCell_TweenPos.to = self.curPvpTypeCell_TweenPos.from
    self.curPvpTypeCell_TweenPos.from = self.curPvpTypeCell.transform.localPosition
    self.curPvpTypeCell_TweenPos:ResetToBeginning()
    self.curPvpTypeCell_TweenPos:PlayForward()
    TimeTickManager.Me():ClearTick(self, 3)
    TimeTickManager.Me():CreateOnceDelayTick(200, function(owner, deltaTime)
      self.pvpTypeChooseRoot:SetActive(true)
      self.curPvpTypeCell:SetActive(false)
    end, self, 2)
  else
    self.pvpTypeChooseRoot:SetActive(false)
    if (not self.curTypeIndex or self.curTypeIndex ~= self.currentKey) and self.curTypeGO then
      GameObject.DestroyImmediate(self.curTypeGO)
      self.curTypeGO = nil
    end
    if not self.curTypeGO then
      local srcGO = self.bgRoot[self.currentKey]
      if srcGO then
        self.curTypeGO = self:CopyGameObject(srcGO, self.curPvpTypeCell)
        self.curTypeGO.transform.localPosition = LuaVector3.Zero()
      end
    end
    local tabObj = self.coreTabMap[self.currentKey]
    local fromPosX = 0
    if tabObj and tabObj.go then
      LuaVector3.Better_Set(tempVector3, LuaGameObject.GetPosition(tabObj.go.transform))
      self.curPvpTypeCell.transform.position = tempVector3
      self.curPvpTypeCell_TweenPos.from = self.curPvpTypeCell.transform.localPosition
    end
    self.curPvpTypeCell_TweenPos.to = LuaGeometry.GetTempVector3(-433, -27.6, 0)
    self.curPvpTypeCell:SetActive(true)
    self.curPvpTypeCell_TweenPos:ResetToBeginning()
    self.curPvpTypeCell_TweenPos:PlayForward()
    TimeTickManager.Me():ClearTick(self, 2)
    TimeTickManager.Me():CreateOnceDelayTick(200, function(owner, deltaTime)
      self.subViewContainer:SetActive(true)
      self.subViewContainer_TweenAlpha:ResetToBeginning()
      self.subViewContainer_TweenAlpha:PlayForward()
      self:UpdateSubView(self.currentKey)
      if self.curTypeGO then
        local descLabel = self:FindGO("Label", self.curTypeGO):GetComponent(UILabel)
        local desc = PVPTYPE[self.currentKey] and PVPTYPE[self.currentKey].desc
        if desc and desc ~= "" then
          descLabel.text = PVPTYPE[self.currentKey] and PVPTYPE[self.currentKey].desc
        end
      end
    end, self, 3)
  end
  self.pageStep = index
end

function PvpContainerView:OnEnter()
  PvpContainerView.super.OnEnter(self)
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.ChitchatLayer)
  self:PreQuerySome()
  PictureManager.Instance:SetPVP(PVPTYPE[11].name, self.competiveModeToggle_Texture)
  PictureManager.Instance:SetPVP(PVPTYPE[14].name, self.mulitiPvpToggle_Texture)
  PictureManager.Instance:SetPVP(PVPTYPE[13].name, self.classicModeToggle_Texture)
  PictureManager.Instance:SetPVP("sports_bg_bottom", self.bgTexture1)
  PictureManager.Instance:SetUI("calendar_bg1_picture2", self.bgTexture2)
  PictureManager.ReFitFullScreen(self.bgTexture1)
end

function PvpContainerView:PreQuerySome()
  ServiceMatchCCmdProxy.Instance:CallQueryTwelveSeasonInfoMatchCCmd(PvpProxy.Type.TwelvePVPChampion)
  ServiceMatchCCmdProxy.Instance:CallQueryTwelveSeasonInfoMatchCCmd(PvpProxy.Type.TwelvePVPBattle)
  ServiceMatchCCmdProxy.Instance:CallQueryTwelveSeasonInfoMatchCCmd(PvpProxy.Type.TeamPwsChampion)
  ServiceMatchCCmdProxy.Instance:CallQueryTeamPwsTeamInfoMatchCCmd()
end

function PvpContainerView:OnExit()
  PvpContainerView.super.OnExit(self)
  PictureManager.Instance:UnLoadPVP(PVPTYPE[11].name, self.competiveModeToggle_Texture)
  PictureManager.Instance:UnLoadPVP(PVPTYPE[14].name, self.mulitiPvpToggle_Texture)
  PictureManager.Instance:UnLoadPVP(PVPTYPE[13].name, self.classicModeToggle_Texture)
  PictureManager.Instance:UnLoadPVP("sports_bg_bottom", self.bgTexture1)
  PictureManager.Instance:UnLoadUI("calendar_bg1_picture2", self.bgTexture2)
  TimeTickManager.Me():ClearTick(self)
end

function PvpContainerView:HandleLoadScene()
  if PvpProxy.Instance:IsSelfInGuildBase() then
    self:CloseSelf()
  end
end

function PvpContainerView:HandleQueryTeamPwsTeamInfo(note)
  local serverData = note.body
  local _, pwsConfig = next(GameConfig.PvpTeamRaid)
  local nextOpenTime = serverData.opentime
  local curTime = ServerTime.CurServerTime() / 1000
  if not nextOpenTime then
    return
  end
  if nextOpenTime < curTime then
    return
  end
  local weekCount = math.ceil(serverData.count / (pwsConfig.EventCountPerWeek or 1))
  local strWeek
  self.teamPwsStr = string.format(ZhString.NewGVG_Season_Battle, weekCount)
  self:UpdateOpenLabel()
end

function PvpContainerView:RefreshScheduleStatus()
  self:UpdateTabDesc()
end

function PvpContainerView:RefreshScheduleStatus_12v12()
  self:UpdateTabDesc_12v12()
end

function PvpContainerView:UpdateTabDesc()
  local curServerTime = ServerTime.CurServerTime() / 1000
  local proxy = CupMode6v6Proxy.Instance
  local cupModeStr
  if proxy:IsSeasonNoOpen() or proxy:IsSeasonEnd() then
  elseif curServerTime < proxy.warbandStartTime then
    cupModeStr = CupModeProxy.CupModeStartTimeLeft(proxy.warbandStartTime)
  elseif proxy:IsInSignupTime() then
    cupModeStr = ZhString.Warband_Tab_TimeSignup
  else
    cupModeStr = ZhString.Warband_Tab_TimeToday
  end
  local multiProxy = CupMode6v6Proxy_MultiServer.Instance
  if multiProxy:IsSeasonNoOpen() or multiProxy:IsSeasonEnd() then
  elseif curServerTime < multiProxy.warbandStartTime then
    cupModeStr = CupModeProxy.CupModeStartTimeLeft(multiProxy.warbandStartTime)
  elseif multiProxy:IsInSignupTime() then
    cupModeStr = ZhString.Warband_Tab_TimeSignup_MultiServer
  else
    cupModeStr = ZhString.Warband_Tab_TimeToday_MultiServer
  end
  self.cupModeStr = cupModeStr
  self:UpdateOpenLabel()
end

function PvpContainerView:UpdateTabDesc_12v12()
  local curServerTime = ServerTime.CurServerTime() / 1000
  local multiCupModeStr
  if WarbandProxy.Instance:IsSeasonNoOpen() or WarbandProxy.Instance:IsSeasonEnd() then
    multiCupModeStr = ""
  elseif curServerTime < WarbandProxy.Instance.warbandStartTime then
    multiCupModeStr = WarbandStartTimeLeft(WarbandProxy.Instance.warbandStartTime)
  elseif WarbandProxy.Instance:IsInSignupTime() then
    multiCupModeStr = ZhString.Warband_Tab_TimeSignup
  else
    multiCupModeStr = ZhString.Warband_Tab_TimeToday
  end
  self.multiCupModeStr = multiCupModeStr
  self:UpdateOpenLabel()
  local curSeason = WarbandProxy.Instance.curSeason
  if curSeason then
    PictureManager.Instance:SetPVP("pvp_icon_season_" .. curSeason, self.mulitiPvpToggle_txt_season)
  end
end

function PvpContainerView:UpdateOpenLabel()
  local str = ""
  local curSeason
  if self.teamPwsStr and self.teamPwsStr ~= "" then
    str = str .. self.teamPwsStr
    curSeason = PvpProxy.Instance.teamPwsSeason or 1
    PictureManager.Instance:SetPVP("pvp_icon_season_" .. curSeason, self.competiveModeToggle_txt_season)
  end
  if self.cupModeStr and self.cupModeStr ~= "" then
    if str ~= "" then
      str = str .. "\n"
    end
    str = str .. self.cupModeStr
    if CupMode6v6Proxy.Instance.curSeason then
      curSeason = CupMode6v6Proxy.Instance.curSeason
    elseif CupMode6v6Proxy_MultiServer.Instance.curSeason then
      curSeason = CupMode6v6Proxy_MultiServer.Instance.curSeason
    end
    PictureManager.Instance:SetPVP("pvp_icon_season_" .. curSeason, self.competiveModeToggle_txt_season)
  end
  if str ~= "" then
    self.competiveModeToggle_OpenLabel.gameObject:SetActive(true)
    self.competiveModeToggle_OpenLabel.text = str
  else
    self.competiveModeToggle_OpenLabel.gameObject:SetActive(false)
  end
  local printY = self.competiveModeToggle_OpenLabel.printedSize.y
  self.competiveModeToggle_OpenLabelBg.height = printY + 10
  str = ""
  if self.multiCupModeStr and self.multiCupModeStr ~= "" then
    str = str .. self.multiCupModeStr
  end
  if str ~= "" then
    self.mulitiPvpToggle_OpenLabel.gameObject:SetActive(true)
    self.mulitiPvpToggle_OpenLabel.text = str
  else
    self.mulitiPvpToggle_OpenLabel.gameObject:SetActive(false)
  end
end
