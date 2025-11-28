autoImport("CupModeForbiddenPro")
CompetiveModeView = class("CompetiveModeView", SubView)
local CompetiveModeViewPath = ResourcePathHelper.UIView("CompetiveModeView")
local ViewName = "CompetiveModeView"
local TeamPwsViewName = "TeamPwsSubView"
local CupModeViewName = "CupModeView"
local FreeModeViewName = "TeamPwsFreeModeView"
local CustomModeViewName = "PvpCustomModeView"
local MergeServerCupModeViewName = "CupModeView_MultiServer"
local TabTextures = GameConfig.CompetiveMode and GameConfig.CompetiveMode.TabTextures or {
  "12pvp_bg_pic4",
  "12pvp_bg_pic5"
}
local TabNames = GameConfig.CompetiveMode and GameConfig.CompetiveMode.TabNames or ZhString.CompetiveModeTabNames
local tickInterval = 10000
local _cellName = "CupModeForbiddenPro"
local _cellSize = 0.4

function CompetiveModeView:OnEnter()
  CompetiveModeView.super.OnEnter(self)
  self:StartTick()
end

function CompetiveModeView:OnExit()
  CompetiveModeView.super.OnExit(self)
  self:StopTick()
end

function CompetiveModeView:OnDestroy()
  local picManager = PictureManager.Instance
  picManager:UnLoadPVP(TabTextures[1], self.teamPwsTex)
  picManager:UnLoadPVP(TabTextures[2], self.cupModeTex)
  picManager:UnLoadPVP(TeamPwsView.TexSeason, self.txt_season)
  self:StopTick()
  CompetiveModeView.super.OnDestroy(self)
end

function CompetiveModeView:Init()
  self:FindObjs()
  self:AddBtnEvts()
  self:AddViewEvts()
  self:InitShow()
end

function CompetiveModeView:LoadSubViews()
  self.rootGO = self:FindGO("TeamPwsView")
  local go = self:LoadPreferb_ByFullPath(CompetiveModeViewPath, self.rootGO, true)
  go.name = ViewName
  self.teamPwsView = self:AddSubView(TeamPwsViewName, TeamPwsView)
  self.cupModeView = self:AddSubView(CupModeViewName, CupModeView)
  self.freeModeView = self:AddSubView(FreeModeViewName, TeamPwsFreeModeView)
  self.customModeView = self:AddSubView(CustomModeViewName, PvpCustomModeView)
  self.multiCupModeView = self:AddSubView(MergeServerCupModeViewName, CupModeView_MultiServer)
end

function CompetiveModeView:FindObjs()
  self:LoadSubViews()
  self.tabScrollView = self:FindComponent("TabScrollView", UIScrollView, self.rootGO)
  self.tabGrid = self:FindComponent("TabGrids", UITable, self.rootGO)
  self.teamPwsTabGO = self:FindGO("TeamPwsTab", self.rootGO)
  self.teamPwsViewGO = self:FindGO(TeamPwsViewName, self.rootGO)
  self.teamPwsTex = self:FindComponent("Tex", UITexture, self.teamPwsTabGO)
  self.teamPwsName = self:FindComponent("Name", UILabel, self.teamPwsTabGO)
  self.teamPwsRuleGO = self:FindGO("RuleBtn", self.teamPwsTabGO)
  self.weekLabel = self:FindComponent("Desc", UILabel, self.teamPwsTabGO)
  self.teamPwsDescBG = self:FindGO("DescBG", self.teamPwsTabGO)
  self.weekLabel.gameObject:SetActive(false)
  self.teamPwsDescBG:SetActive(false)
  self.cupModeTabGO = self:FindGO("CupModeTab", self.rootGO)
  self.cupModeViewGO = self:FindGO(CupModeViewName, self.rootGO)
  self.cupModeTex = self:FindComponent("Tex", UITexture, self.cupModeTabGO)
  self.cupModeName = self:FindComponent("Name", UILabel, self.cupModeTabGO)
  self.cupModeDesc = self:FindComponent("Desc", UILabel, self.cupModeTabGO)
  self:AddClickEvent(self.cupModeDesc.gameObject, function()
    local param = CupMode6v6Proxy.Instance:GetForbiddenProStr()
    if not StringUtil.IsEmpty(param) then
      MsgManager.ConfirmMsgByID(28088, nil, nil, nil, param)
    end
  end)
  self.cupModeRuleGO = self:FindGO("RuleBtn", self.cupModeTabGO)
  self.cupModeDescBG = self:FindGO("DescBG", self.cupModeTabGO)
  self.stepGrid = self:FindComponent("StepGrid", UIGrid, self.cupModeTabGO)
  self.rankBtn = self:FindGO("RankBtn", self.stepGrid.gameObject)
  self.rankBtnLabel = self:FindComponent("Label", UILabel, self.rankBtn)
  self.rankBtnDot = self:FindComponent("Dot", UISprite, self.rankBtn)
  self.preRoundBtn = self:FindGO("PreRoundBtn", self.stepGrid.gameObject)
  self.preRoundLabel = self:FindComponent("Label", UILabel, self.preRoundBtn)
  self.preRoundDot = self:FindComponent("Dot", UISprite, self.preRoundBtn)
  self.mainRoundBtn = self:FindGO("MainRoundBtn", self.stepGrid.gameObject)
  self.mainRoundLabel = self:FindComponent("Label", UILabel, self.mainRoundBtn)
  self.mainRoundDot = self:FindComponent("Dot", UISprite, self.mainRoundBtn)
  self.finalRoundBtn = self:FindGO("FinalRoundBtn", self.stepGrid.gameObject)
  self.finalRoundLabel = self:FindComponent("Label", UILabel, self.finalRoundBtn)
  self.finalreRoundDot = self:FindComponent("Dot", UISprite, self.finalRoundBtn)
  self.stepBg = self:FindGO("StepBg", self.cupModeTabGO)
  self.stepBg_Sprite = self.stepBg:GetComponent(UISprite)
  self.cupModeArrow = self:FindComponent("Arrow", UISprite, self.cupModeTabGO)
  self.mergeServerCupModeTabGO = self:FindGO("MergeServerCupModeTab", self.rootGO)
  self.mergeServerCupModeViewGO = self:FindGO(MergeServerCupModeViewName, self.rootGO)
  self.mergeServerCupModeTex = self:FindComponent("Tex", UITexture, self.mergeServerCupModeTabGO)
  self.mergeServerCupModeName = self:FindComponent("Name", UILabel, self.mergeServerCupModeTabGO)
  self.mergeServerCupModeDesc = self:FindComponent("Desc", UILabel, self.mergeServerCupModeTabGO)
  self:AddClickEvent(self.mergeServerCupModeDesc.gameObject, function()
    local param = CupMode6v6Proxy_MultiServer.Instance:GetForbiddenProStr()
    if not StringUtil.IsEmpty(param) then
      MsgManager.ConfirmMsgByID(28088, nil, nil, nil, param)
    end
  end)
  self.mergeServerCupModeRuleGO = self:FindGO("RuleBtn", self.mergeServerCupModeTabGO)
  self.mergeServerCupModeeDescBG = self:FindGO("DescBG", self.mergeServerCupModeTabGO)
  self.mergeServerStepGrid = self:FindComponent("StepGrid", UIGrid, self.mergeServerCupModeTabGO)
  self.mergeServerRankBtn = self:FindGO("RankBtn", self.mergeServerStepGrid.gameObject)
  self.mergeServerRankBtnLabel = self:FindComponent("Label", UILabel, self.mergeServerRankBtn)
  self.mergeServerRankBtnDot = self:FindComponent("Dot", UISprite, self.mergeServerRankBtn)
  self.mergeServerpreRoundBtn = self:FindGO("PreRoundBtn", self.mergeServerStepGrid.gameObject)
  self.mergeServerpreRoundLabel = self:FindComponent("Label", UILabel, self.mergeServerpreRoundBtn)
  self.mergeServerpreRoundDot = self:FindComponent("Dot", UISprite, self.mergeServerpreRoundBtn)
  self.mergeServermainRoundBtn = self:FindGO("MainRoundBtn", self.mergeServerStepGrid.gameObject)
  self.mergeServermainRoundLabel = self:FindComponent("Label", UILabel, self.mergeServermainRoundBtn)
  self.mergeServermainRoundDot = self:FindComponent("Dot", UISprite, self.mergeServermainRoundBtn)
  self.mergeServerfinalRoundBtn = self:FindGO("FinalRoundBtn", self.mergeServerStepGrid.gameObject)
  self.mergeServerfinalRoundLabel = self:FindComponent("Label", UILabel, self.mergeServerfinalRoundBtn)
  self.mergeServerfinalRoundDot = self:FindComponent("Dot", UISprite, self.mergeServerfinalRoundBtn)
  self.mergeServerStepBg = self:FindGO("StepBg", self.mergeServerCupModeTabGO)
  self.mergeServerStepBg_Sprite = self.mergeServerStepBg:GetComponent(UISprite)
  self.mergeServercupModeArrow = self:FindComponent("Arrow", UISprite, self.mergeServerCupModeTabGO)
  local crossServerEnter = GameConfig.TeamSeasonTime and GameConfig.TeamSeasonTime.CrossServerEnter
  if crossServerEnter then
    self.mergeServerCupModeTabGO:SetActive(true)
  else
    self.mergeServerCupModeTabGO:SetActive(false)
  end
  self.freeModeTabGO = self:FindGO("FreeModeTab", self.rootGO)
  self.freeModeViewGO = self:FindGO(FreeModeViewName, self.rootGO)
  self.freeModeTex = self:FindComponent("Tex", UITexture, self.freeModeTabGO)
  self.freeModeName = self:FindComponent("Name", UILabel, self.freeModeTabGO)
  self.freeModeRuleGO = self:FindGO("RuleBtn", self.freeModeTabGO)
  self.freeModeDescBG = self:FindGO("DescBG", self.freeModeTabGO)
  self.freeModeDescBG:SetActive(false)
  self.customModeTabGO = self:FindGO("CustomModeTab", self.rootGO)
  self.customModeViewGO = self:FindGO(CustomModeViewName, self.rootGO)
  self.customModeTex = self:FindComponent("Tex", UITexture, self.customModeTabGO)
  self.customModeName = self:FindComponent("Name", UILabel, self.customModeTabGO)
  self.customModeRuleGO = self:FindGO("RuleBtn", self.customModeTabGO)
  self.customModeDescBG = self:FindGO("DescBG", self.customModeTabGO)
  self.customModeDescBG:SetActive(false)
  self.helpBtn = self:FindGO("HelpBtn", self.rootGO)
  self.openLabel = self:FindGO("OpenLabel", self.rootGO):GetComponent(UILabel)
  self.openLabel_Bg = self:FindGO("OpenBg", self.openLabel.gameObject):GetComponent(UISprite)
  self.txt_season = self:FindGO("txt_season", self.openLabel.gameObject):GetComponent(UITexture)
  self.openLabel.gameObject:SetActive(false)
end

function CompetiveModeView:_loadForbiddenProPfb()
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(_cellName))
  if nil == cellpfb then
    redlog("can not find cellpfb", _cellName)
    return
  end
  cellpfb.transform:SetParent(self.cupModeTabGO.transform, false)
  cellpfb.transform.localScale = LuaGeometry.GetTempVector3(_cellSize, _cellSize, _cellSize)
  return cellpfb
end

function CompetiveModeView:InitShow()
  local picManager = PictureManager.Instance
  picManager:SetPVP(TabTextures[1], self.teamPwsTex)
  picManager:SetPVP(TabTextures[2], self.cupModeTex)
  picManager:SetPVP(TeamPwsView.TexSeason, self.txt_season)
  if TabNames then
    self.teamPwsName.text = TabNames[1]
    self.cupModeName.text = TabNames[2]
    self.freeModeName.text = TabNames[3]
    self.customModeName.text = TabNames[4]
    self.mergeServerCupModeName.text = TabNames[5]
  end
  local tab = self.viewdata and self.viewdata.viewdata
  if tab and type(tab) == "string" then
    self:TabChangeHandler(tab)
  else
    local proxy = CupMode6v6Proxy.Instance
    local isCupModeSeason = proxy:IsCurSeasonRunning()
    if isCupModeSeason then
      self:TabChangeHandler(self.cupModeTabGO.name)
    else
      local isMultiServerCupModeSeason = CupMode6v6Proxy_MultiServer.Instance:IsCurSeasonRunning()
      if isMultiServerCupModeSeason then
        self:TabChangeHandler(self.mergeServerCupModeTabGO.name)
      else
        self:TabChangeHandler(self.teamPwsTabGO.name)
      end
    end
  end
  self:HandleCupModeStepChoose()
end

local ShowHelpDesc = function(id)
  local desc = Table_Help[id] and Table_Help[id].Desc or ZhString.Help_RuleDes
  TipsView.Me():ShowGeneralHelp(desc)
end

function CompetiveModeView:AddBtnEvts()
  self:AddTabChangeEvent(self.teamPwsTabGO, self.teamPwsViewGO, self.teamPwsView)
  self:AddTabChangeEvent(self.cupModeTabGO, self.cupModeViewGO, self.cupModeView)
  self:AddTabChangeEvent(self.freeModeTabGO, self.freeModeViewGO, self.freeModeView)
  self:AddTabChangeEvent(self.customModeTabGO, self.customModeViewGO, self.customModeView)
  self:AddTabChangeEvent(self.mergeServerCupModeTabGO, self.mergeServerCupModeViewGO, self.multiCupModeView)
  if self.teamPwsRuleGO then
    self:AddClickEvent(self.teamPwsRuleGO, function(go)
      ShowHelpDesc(PanelConfig.TeamPwsView.id)
    end)
  end
  if self.cupModeRuleGO then
    self:AddClickEvent(self.cupModeRuleGO, function(go)
      ShowHelpDesc(PanelConfig.CupModeView.id)
    end)
  end
  self:AddClickEvent(self.helpBtn, function()
    if self.teamPwsView.objRoot.activeSelf then
      ShowHelpDesc(PanelConfig.TeamPwsView.id)
    elseif self.cupModeView.rootGO.activeSelf then
      ShowHelpDesc(PanelConfig.CupModeView.id)
    elseif self.freeModeView.objRoot.activeSelf then
      ShowHelpDesc(PanelConfig.FreeBattleView.id)
    elseif self.multiCupModeView.rootGO.activeSelf then
      ShowHelpDesc(32633)
    end
  end)
  self:AddClickEvent(self.rankBtn, function()
    self:SwitchToRankPage(true)
  end)
  self:AddClickEvent(self.preRoundBtn, function()
    self:SwitchToStep(1, true)
  end)
  self:AddClickEvent(self.mainRoundBtn, function()
    self:SwitchToStep(2, true)
  end)
  self:AddClickEvent(self.finalRoundBtn, function()
    self:SwitchToStep(3, true)
  end)
  self:AddClickEvent(self.cupModeArrow.gameObject, function()
    if self.stepBg.activeSelf then
      self.cupModeArrow.flip = 2
      self.stepBg:SetActive(false)
    else
      self.cupModeArrow.flip = 0
      self.stepBg:SetActive(true)
    end
    self.tabGrid:Reposition()
  end)
  self:AddClickEvent(self.mergeServerRankBtn, function()
    self:SwitchToRankPage_MultiServer(true)
  end)
  self:AddClickEvent(self.mergeServerpreRoundBtn, function()
    self:SwitchToStep_MultiServer(1, true)
  end)
  self:AddClickEvent(self.mergeServermainRoundBtn, function()
    self:SwitchToStep_MultiServer(2, true)
  end)
  self:AddClickEvent(self.mergeServerfinalRoundBtn, function()
    self:SwitchToStep_MultiServer(3, true)
  end)
  self:AddClickEvent(self.mergeServercupModeArrow.gameObject, function()
    if self.mergeServerStepBg.activeSelf then
      self.mergeServercupModeArrow.flip = 2
      self.mergeServerStepBg:SetActive(false)
      self.tabScrollView:ResetPosition()
      local panel = self.tabScrollView.panel
      local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, self.mergeServerCupModeTabGO.transform)
      local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
      offset = Vector3(0, offset.y, 0)
      self.tabScrollView:MoveRelative(offset)
    else
      self.mergeServercupModeArrow.flip = 0
      self.mergeServerStepBg:SetActive(true)
      self.tabScrollView:ResetPosition()
      local panel = self.tabScrollView.panel
      local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, self.mergeServerfinalRoundBtn.transform)
      local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
      offset = Vector3(0, offset.y, 0)
      self.tabScrollView:MoveRelative(offset)
    end
    self.tabGrid:Reposition()
  end)
end

function CompetiveModeView:AddViewEvts()
  self:AddListenEvt(CupModeEvent.ScheduleChanged_6v6, self.RefreshScheduleStatus)
  self:AddListenEvt(CupModeEvent.SeasonInfo_6v6, self.RefreshScheduleStatus)
  self:AddListenEvt(CupModeEvent.SeasonFinish_6v6, self.OnSeasonFinish)
  self:AddListenEvt(ServiceEvent.MatchCCmdQueryTeamPwsTeamInfoMatchCCmd, self.HandleQueryTeamPwsTeamInfo)
  self:AddListenEvt(CupModeEvent.Tree_6v6, self.HandleTreeUpdate)
end

function CompetiveModeView:HandleTreeUpdate()
  xdlog("TreeUpdate")
  self:HandleCupModeStepChoose(false)
end

function CompetiveModeView:OnSeasonFinish()
  self:StopTick()
end

function CompetiveModeView:UpdateView()
  self:UpdateCurrentTabView()
  self:RestartTick()
  self:UpdateTabDesc()
  self:HandleCupModeStepChoose(true)
end

function CompetiveModeView:StartTick()
  if not self.timeTicker then
    self.tickId = self.tickId or 101
    self.timeTicker = TimeTickManager.Me():CreateTick(0, tickInterval, self.Tick, self, self.tickId)
  end
end

function CompetiveModeView:StopTick()
  if self.timeTicker then
    self.timeTicker:Destroy()
    self.timeTicker = nil
    self.tickId = self.tickId + 1
  end
end

function CompetiveModeView:RestartTick()
  self:StopTick()
  self:StartTick()
end

function CompetiveModeView:Tick()
  local proxy = CupMode6v6Proxy.Instance
  proxy:TryUpdateScheduleStatus()
  local multiProxy = CupMode6v6Proxy_MultiServer.Instance
  multiProxy:TryUpdateScheduleStatus()
end

function CompetiveModeView:RefreshScheduleStatus()
  self:UpdateTabDesc()
end

function CompetiveModeView:UpdateTabDesc()
  local curServerTime = ServerTime.CurServerTime() / 1000
  local proxy = CupMode6v6Proxy.Instance
  local multiProxy = CupMode6v6Proxy_MultiServer.Instance
  self.cupModeDescBG:SetActive(false)
  local cupModeStr
  if proxy:IsSeasonNoOpen() or proxy:IsSeasonEnd() then
  elseif curServerTime < proxy.warbandStartTime then
    cupModeStr = CupModeProxy.CupModeStartTimeLeft(proxy.warbandStartTime)
  elseif proxy:IsInSignupTime() then
    cupModeStr = ZhString.Warband_Tab_TimeSignup
  else
    cupModeStr = ZhString.Warband_Tab_TimeToday
  end
  if cupModeStr ~= nil or multiProxy:IsSeasonNoOpen() or multiProxy:IsSeasonEnd() then
  elseif curServerTime < multiProxy.warbandStartTime then
    cupModeStr = CupModeProxy.CupModeStartTimeLeft(multiProxy.warbandStartTime)
  elseif multiProxy:IsInSignupTime() then
    cupModeStr = ZhString.Warband_Tab_TimeSignup_MultiServer
  else
    cupModeStr = ZhString.Warband_Tab_TimeToday
  end
  self.cupModeStr = cupModeStr
end

function CompetiveModeView:HandleQueryTeamPwsTeamInfo(note)
  local serverData = note.body
  local _, pwsConfig = next(GameConfig.PvpTeamRaid)
  local nextOpenTime = serverData.opentime
  local curTime = ServerTime.CurServerTime() / 1000
  self.weekLabel.gameObject:SetActive(false)
  if not nextOpenTime then
    return
  end
  if nextOpenTime < curTime then
    return
  end
  local weekCount = math.ceil(serverData.count / (pwsConfig.EventCountPerWeek or 1))
  local strWeek
  if 10 < weekCount then
    local first, second = math.modf(weekCount / 10)
    if 0 < second then
      strWeek = string.format("%s%s", ZhString.ChinaNumber[10], ZhString.ChinaNumber[math.floor(second * 10 + 0.5)])
    else
      strWeek = ZhString.ChinaNumber[10]
    end
    if 1 < first then
      strWeek = string.format("%s%s", ZhString.ChinaNumber[math.clamp(first, 1, 9)], strWeek)
    end
  else
    strWeek = 0 < weekCount and ZhString.ChinaNumber[weekCount] or weekCount
  end
  self.teamPwsStr = strWeek
  local season = serverData.season or 1
  PictureManager.Instance:SetPVP("pvp_icon_season_" .. season, self.txt_season)
end

function CompetiveModeView:UpdateOpenLabel()
  local str = ""
  if self.teamPwsStr and self.teamPwsStr ~= "" then
    str = str .. self.teamPwsStr
  end
  if self.cupModeStr and self.cupModeStr ~= "" then
    if str ~= "" then
      str = str .. "\n"
    end
    str = str .. self.cupModeStr
  end
  if str ~= "" then
    self.openLabel.gameObject:SetActive(true)
    self.openLabel.text = str
  else
    self.openLabel.gameObject:SetActive(false)
  end
  local printY = self.openLabel.printedSize.y
  self.openLabel_Bg.height = printY + 10
end

function CompetiveModeView:TabChangeHandler(key, forceExpand)
  CompetiveModeView.super.TabChangeHandler(self, key)
  xdlog("key", key)
  for k, v in pairs(self.coreTabMap) do
    if v.tabGO then
      local bg = self:FindComponent("Bg", UISprite, v.tabGO)
      local name = self:FindComponent("Name", UILabel, v.tabGO)
      if k == key then
        bg.spriteName = "sports_btn_liang"
        name.color = LuaGeometry.GetTempVector4(0.34901960784313724, 0.21176470588235294, 0.07450980392156863, 1)
      else
        bg.spriteName = "sports_btn_an"
        name.color = LuaColor.White()
      end
    end
  end
  self.helpBtn:SetActive(not self.customModeView.objRoot.activeSelf)
  if key == "CupModeTab" then
    if forceExpand and self.cupModeArrow.gameObject.activeSelf then
      self.cupModeArrow.flip = 0
      self.stepBg:SetActive(true)
    elseif self.curPageKey == key and not forceExpand then
      if self.cupModeArrow.gameObject.activeSelf then
        self.cupModeArrow.flip = self.stepBg.activeSelf and 2 or 0
        self.stepBg:SetActive(not self.stepBg.activeSelf)
      end
    elseif self.preCupModeStep and 0 < self.preCupModeStep then
      self:SwitchToStep(self.preCupModeStep, true)
    else
      self:SwitchToRankPage()
    end
    self.tabGrid:Reposition()
    self:SwitchToStep_MultiServer(0)
  elseif key == "MergeServerCupModeTab" then
    if forceExpand and self.mergeServercupModeArrow.gameObject.activeSelf then
      self.mergeServercupModeArrow.flip = 0
      self.mergeServerStepBg:SetActive(true)
      local panel = self.tabScrollView.panel
      local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, self.mergeServerfinalRoundBtn.transform)
      local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
      offset = Vector3(0, offset.y, 0)
      self.tabScrollView:MoveRelative(offset)
    elseif self.curPageKey == key and not forceExpand then
      if self.mergeServercupModeArrow.gameObject.activeSelf then
        local targetCell = self.mergeServerStepBg.activeSelf and self.mergeServerCupModeTabGO or self.mergeServerfinalRoundBtn
        self.mergeServercupModeArrow.flip = self.mergeServerStepBg.activeSelf and 2 or 0
        self.mergeServerStepBg:SetActive(not self.mergeServerStepBg.activeSelf)
        self.tabScrollView:ResetPosition()
        local panel = self.tabScrollView.panel
        local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, targetCell.transform)
        local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
        offset = Vector3(0, offset.y, 0)
        self.tabScrollView:MoveRelative(offset)
      end
    elseif self.preCupModeStep_multiServer and 0 < self.preCupModeStep_multiServer then
      self:SwitchToStep_MultiServer(self.preCupModeStep_multiServer, true)
    else
      self:SwitchToRankPage_MultiServer()
    end
    self.tabGrid:Reposition()
    self:SwitchToStep(0)
  else
    self:SwitchToStep(0)
    self:SwitchToStep_MultiServer(0)
  end
  self.curPageKey = key
end

function CompetiveModeView:HandleCupModeStepChoose(forceRefresh)
  xdlog("预选赛数据列表更新")
  local forceRefresh = forceRefresh == nil and true or forceRefresh
  local proxy = CupMode6v6Proxy.Instance
  local isCrossServer = proxy.isCrossServer
  local validCount = 0
  if proxy:IsSeasonNoOpen() or proxy:IsSeasonEnd() or proxy:IsSigthupPending() or proxy:GetCurStage() == 4 then
    redlog("普通杯赛未开始", proxy:IsSeasonNoOpen(), proxy:IsSeasonEnd(), proxy:IsSigthupPending())
    self.cupModeArrow.flip = 2
    local preRoundData = proxy:GetPreRoundGroupTabData()
    local hasPreRound = preRoundData and 0 < #preRoundData and true or false
    local mainRoundData = proxy:GetGroupTabData()
    local hasMainRound = mainRoundData and 0 < #mainRoundData and true or false
    local finalRoundData = proxy:GetFinalRoundGroupTabData()
    local hasFinalRound = finalRoundData and 0 < #finalRoundData and true or false
    xdlog("数据", hasPreRound, hasMainRound, hasFinalRound)
    if hasPreRound then
      validCount = validCount + 1
    end
    if hasMainRound then
      validCount = validCount + 1
    end
    if hasFinalRound then
      validCount = validCount + 1
    end
    if hasPreRound or hasMainRound or hasFinalRound then
      validCount = validCount + 1
    end
    self.preRoundBtn:SetActive(hasPreRound)
    self.mainRoundBtn:SetActive(hasMainRound)
    self.finalRoundBtn:SetActive(hasFinalRound)
    self.rankBtn:SetActive(hasPreRound or hasMainRound or hasFinalRound)
    self.stepBg:SetActive(false)
    self.cupModeArrow.gameObject:SetActive(hasPreRound or hasMainRound or hasFinalRound)
    self:SwitchToRankPage()
  else
    xdlog("普通杯赛进行中", proxy:IsSeasonNoOpen(), proxy:IsSeasonEnd(), proxy:IsSigthupPending())
    if forceRefresh then
      self.cupModeArrow.flip = 0
    end
    local preRoundData = proxy:GetPreRoundGroupTabData()
    local hasPreRound = preRoundData and 0 < #preRoundData and true or false
    local mainRoundData = proxy:GetGroupTabData()
    local hasMainRound = mainRoundData and 0 < #mainRoundData and true or false
    local finalRoundData = proxy:GetFinalRoundGroupTabData()
    local hasFinalRound = finalRoundData and 0 < #finalRoundData and true or false
    if hasPreRound then
      validCount = validCount + 1
    end
    if hasMainRound then
      validCount = validCount + 1
    end
    if hasFinalRound then
      validCount = validCount + 1
    end
    self.rankBtn:SetActive(false)
    self.preRoundBtn:SetActive(hasPreRound)
    self.mainRoundBtn:SetActive(hasMainRound)
    self.finalRoundBtn:SetActive(hasMainRound)
    self.stepGrid.gameObject:SetActive(hasPreRound or hasMainRound)
    self.stepBg:SetActive(hasPreRound or hasMainRound)
    self.cupModeArrow.gameObject:SetActive(hasPreRound or hasMainRound)
    local curStage = proxy:GetCurStage() or 0
    if 3 < curStage then
      self:SwitchToStep(3, forceRefresh)
    else
      self:SwitchToStep(curStage, forceRefresh)
    end
  end
  self.stepBg_Sprite.height = 20 + validCount * 55
  self.stepGrid:Reposition()
  local proxy = CupMode6v6Proxy_MultiServer.Instance
  local validCount = 0
  if proxy:IsSeasonNoOpen() or proxy:IsSeasonEnd() or proxy:IsSigthupPending() or proxy:GetCurStage() == 4 then
    validCount = 0
    self.mergeServercupModeArrow.flip = 2
    local preRoundData = proxy:GetPreRoundGroupTabData()
    local hasPreRound = preRoundData and 0 < #preRoundData and true or false
    local mainRoundData = proxy:GetGroupTabData()
    local hasMainRound = mainRoundData and 0 < #mainRoundData and true or false
    local finalRoundData = proxy:GetFinalRoundGroupTabData()
    local hasFinalRound = finalRoundData and 0 < #finalRoundData and true or false
    if hasPreRound then
      validCount = validCount + 1
    end
    if hasMainRound then
      validCount = validCount + 1
    end
    if hasFinalRound then
      validCount = validCount + 1
    end
    if hasPreRound or hasMainRound or hasFinalRound then
      validCount = validCount + 1
    end
    self.mergeServerpreRoundBtn:SetActive(hasPreRound)
    self.mergeServermainRoundBtn:SetActive(hasMainRound)
    self.mergeServerfinalRoundBtn:SetActive(hasFinalRound)
    self.mergeServerRankBtn:SetActive(hasPreRound or hasMainRound or hasFinalRound)
    self.mergeServerStepBg:SetActive(false)
    self.mergeServercupModeArrow.gameObject:SetActive(hasPreRound or hasMainRound or hasFinalRound)
    self:SwitchToRankPage_MultiServer()
    if proxy:IsSigthupPending() then
      local panel = self.tabScrollView.panel
      local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, self.mergeServerCupModeTabGO.transform)
      local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
      offset = Vector3(0, offset.y, 0)
      self.tabScrollView:MoveRelative(offset)
    end
  else
    xdlog("跨服进行中")
    self.mergeServercupModeArrow.flip = 0
    local preRoundData = proxy:GetPreRoundGroupTabData()
    local hasPreRound = preRoundData and 0 < #preRoundData and true or false
    local mainRoundData = proxy:GetGroupTabData()
    local hasMainRound = mainRoundData and 0 < #mainRoundData and true or false
    local finalRoundData = proxy:GetFinalRoundGroupTabData()
    local hasFinalRound = finalRoundData and 0 < #finalRoundData and true or false
    if hasPreRound then
      validCount = validCount + 1
    end
    if hasMainRound then
      validCount = validCount + 1
    end
    if hasFinalRound then
      validCount = validCount + 1
    end
    self.mergeServerRankBtn:SetActive(false)
    self.mergeServerpreRoundBtn:SetActive(hasPreRound)
    self.mergeServermainRoundBtn:SetActive(hasMainRound)
    self.mergeServerfinalRoundBtn:SetActive(hasFinalRound)
    self.mergeServerStepGrid.gameObject:SetActive(hasPreRound or hasMainRound or hasFinalRound)
    self.mergeServerStepBg:SetActive(hasPreRound or hasMainRound or hasFinalRound)
    self.mergeServercupModeArrow.gameObject:SetActive(hasPreRound or hasMainRound or hasFinalRound)
    local curStage = proxy:GetCurStage() or 0
    if 3 < curStage then
      self:SwitchToStep_MultiServer(3, forceRefresh)
    else
      self:SwitchToStep_MultiServer(curStage, forceRefresh)
    end
    local panel = self.tabScrollView.panel
    local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, self.mergeServerfinalRoundBtn.transform)
    local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
    offset = Vector3(0, offset.y, 0)
    self.tabScrollView:MoveRelative(offset)
  end
  self.mergeServerStepBg_Sprite.height = 20 + validCount * 55
  self.mergeServerStepGrid:Reposition()
  self.tabGrid:Reposition()
end

function CompetiveModeView:SwitchToRankPage(switchToTab)
  self.preRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.preRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.mainRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.mainRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.finalRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.finalreRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.rankBtnLabel.color = LuaColor.White()
  self.rankBtnDot.color = LuaColor.White()
  if switchToTab then
    self:TabChangeHandler("CupModeTab", true)
    self.cupModeView:SetPageStatus(1)
  end
  self.preCupModeStep = 0
end

function CompetiveModeView:SwitchToRankPage_MultiServer(switchToTab)
  self.mergeServerpreRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.mergeServerpreRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.mergeServermainRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.mergeServermainRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.mergeServerfinalRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.mergeServerfinalRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.mergeServerRankBtnLabel.color = LuaColor.White()
  self.mergeServerRankBtnDot.color = LuaColor.White()
  if switchToTab then
    self:TabChangeHandler("MergeServerCupModeTab", true)
    self.multiCupModeView:SetPageStatus(1)
  end
  self.preCupModeStep_multiServer = 0
end

function CompetiveModeView:SwitchToStep(index, switchToTab)
  if not index then
    return
  end
  if 0 < index then
    self.preCupModeStep = index
  end
  if 0 < index and switchToTab then
    self:TabChangeHandler("CupModeTab", true)
    self.cupModeView:SetPageStatus(2)
    self.cupModeView.scheduleSubview:UpdateStepChoose(index)
  end
  self.rankBtnLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.rankBtnDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  if index == 1 then
    self.preRoundLabel.color = LuaColor.White()
    self.preRoundDot.color = LuaColor.White()
    self.mainRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.mainRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.finalRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.finalreRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  elseif index == 2 then
    self.preRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.preRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.mainRoundLabel.color = LuaColor.White()
    self.mainRoundDot.color = LuaColor.White()
    self.finalRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.finalreRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  elseif index == 3 then
    self.preRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.preRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.mainRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.mainRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.finalRoundLabel.color = LuaColor.White()
    self.finalreRoundDot.color = LuaColor.White()
  elseif index == 0 then
    self.preRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.preRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.mainRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.mainRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.finalRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.finalreRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  end
end

function CompetiveModeView:SwitchToStep_MultiServer(index, switchToTab)
  if not index then
    return
  end
  if 0 < index then
    self.preCupModeStep_multiServer = index
  end
  if 0 < index and switchToTab then
    self:TabChangeHandler("MergeServerCupModeTab", true)
    self.multiCupModeView:SetPageStatus(2)
    self.multiCupModeView.scheduleSubview:UpdateStepChoose(index)
  end
  self.mergeServerRankBtnLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.mergeServerRankBtnDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  if index == 1 then
    self.mergeServerpreRoundLabel.color = LuaColor.White()
    self.mergeServerpreRoundDot.color = LuaColor.White()
    self.mergeServermainRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.mergeServermainRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.mergeServerfinalRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.mergeServerfinalRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  elseif index == 2 then
    self.mergeServerpreRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.mergeServerpreRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.mergeServermainRoundLabel.color = LuaColor.White()
    self.mergeServermainRoundDot.color = LuaColor.White()
    self.mergeServerfinalRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.mergeServerfinalRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  elseif index == 3 then
    self.mergeServerpreRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.mergeServerpreRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.mergeServermainRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.mergeServermainRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.mergeServerfinalRoundLabel.color = LuaColor.White()
    self.mergeServerfinalRoundDot.color = LuaColor.White()
  elseif index == 0 then
    self.mergeServerpreRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.mergeServerpreRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.mergeServermainRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.mergeServermainRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.mergeServerfinalRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
    self.mergeServerfinalRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  end
end
