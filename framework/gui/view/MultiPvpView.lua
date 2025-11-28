autoImport("LeisureModelView")
autoImport("WarbandModelView")
autoImport("WarbandModelView_MultiServer")
autoImport("CupModeForbiddenPro")
MultiPvpView = class("MultiPvpView", SubView)
local TEXTURE = {
  "12pvp_bg_pic2",
  "12pvp_bg_pic5",
  "12pvp_bg"
}
local tick_interval = 5000
local _cellName = "CupModeForbiddenPro"
local _cellSize = 0.4

function MultiPvpView:Init()
  self.coreTabMap = ReusableTable.CreateTable()
  self:FindObjs()
  self:InitShow()
  self:AddEvts()
  self:ForbidWarband()
end

function MultiPvpView:AddEvts()
  self:AddListenEvt(PVPEvent.TwelveChamption_ScheduleChanged, self.RefreshScheduleStatus)
  self:AddListenEvt(ServiceEvent.MatchCCmdQueryTwelveSeasonInfoMatchCCmd, self.RefreshScheduleStatus)
  self:AddListenEvt(ServiceEvent.MatchCCmdQueryTwelveSeasonFinishMatchCCmd, self.clearTimeTick)
  self:AddListenEvt(PVPEvent.TwelveChamption_Fighting, self.UpdateFightingTime)
  self:AddListenEvt(ServiceEvent.MatchCCmdTwelveWarbandTreeMatchCCmd, self.HandleCupModeStepChoose)
end

function MultiPvpView:ForbidWarband()
  local warbandOpen = GameConfig.SystemForbid.WarbandForbid == nil
  self.warbandModelBtn:SetActive(warbandOpen)
  self.MultiPvpGrid:Reposition()
end

local ShowHelpDesc = function(id)
  local desc = Table_Help[id] and Table_Help[id].Desc or ZhString.Help_RuleDes
  TipsView.Me():ShowGeneralHelp(desc)
end

function MultiPvpView:FindObjs()
  self.gameObject = self:FindGO("MultiPvpView")
  self.leisureModelBtn = self:FindGO("LeisureModelBtn")
  self.leisureModelObj = self:FindGO("LeisureModelView")
  self.leisureTex = self:FindComponent("LeisureTex", UITexture)
  self.battleName = self:FindComponent("Name", UILabel, self.leisureModelBtn)
  self.battleName.text = ZhString.TwelvePVP_RelaxTabName
  self.twelvePVP_RuleBtn = self:FindGO("RuleBtn", self.leisureModelBtn)
  self:AddClickEvent(self.twelvePVP_RuleBtn, function(g)
    ShowHelpDesc(PanelConfig.LeisureModelView.id)
  end)
  self.MultiPvpGrid = self:FindComponent("MultiPvpGrid", UITable)
  self.warbandModelBtn = self:FindGO("WarbandModelBtn")
  self.warbandModelObj = self:FindGO("WarbandModelView")
  self.warbandTex = self:FindComponent("WarbandTex", UITexture)
  self.warbandDesc = self:FindComponent("WarTabDesc", UILabel)
  self:AddClickEvent(self.warbandDesc.gameObject, function()
    local param = WarbandProxy.Instance:GetForbiddenProStr()
    if not StringUtil.IsEmpty(param) then
      MsgManager.ConfirmMsgByID(28088, nil, nil, nil, param)
    end
  end)
  self.cupModeDescBG = self:FindGO("DescBG", self.warbandModelBtn)
  self.warbandRuleBtn = self:FindGO("RuleBtn", self.warbandModelBtn)
  self:AddClickEvent(self.warbandRuleBtn, function(g)
    ShowHelpDesc(PanelConfig.WarbandModelView.id)
  end)
  self.stepGrid = self:FindComponent("StepGrid", UIGrid, self.warbandModelBtn)
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
  self.stepBg = self:FindGO("StepBg", self.warbandModelBtn)
  self.stepBg_Sprite = self.stepBg:GetComponent(UISprite)
  self.cupModeArrow = self:FindComponent("Arrow", UISprite, self.warbandModelBtn)
  self.mergeServerCupModeTabGO = self:FindGO("MergeServerWarbandModeBtn", self.gameObject)
  self.mergeServerCupModeViewGO = self:FindGO("WarbandModelView_MultiServer", self.gameObject)
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
  self.freeModeBtn = self:FindGO("FreeModeBtn")
  self.freeModeObj = self:FindGO("FreeModeView")
  self.warbandTabName = self:FindComponent("Name", UILabel, self.warbandModelBtn)
  self.warbandTabName.text = ZhString.Warband_TabName
  self.warbandCommingSoonBtn = self:FindGO("WarbandCommingSoonBtn", self.gameObject)
  self.commingSoonTex = self:FindComponent("CommingSoonTex", UITexture, self.warbandCommingSoonBtn)
  self.commingSoonLab = self:FindComponent("CommingSoonLab", UILabel, self.warbandCommingSoonBtn)
  self.commingSoonLab.text = ZhString.TwelvePVP_ComingSoon
  self.warbandCommingSoonBtn:SetActive(false)
  self.customModeBtn = self:FindGO("CustomModeBtn")
  self.customModeObj = self:FindGO("MultiPvpCustomModeView")
  self.helpBtn = self:FindGO("HelpBtn", self.gameObject)
  self:AddClickEvent(self.helpBtn, function()
    if self.leisureModelObj.activeSelf then
      ShowHelpDesc(PanelConfig.LeisureModelView.id)
    elseif self.warbandModelObj.activeSelf then
      ShowHelpDesc(PanelConfig.WarbandModelView.id)
    elseif self.freeModeObj.activeSelf then
      ShowHelpDesc(929)
    elseif self.customModeObj.activeSelf then
      ShowHelpDesc(PanelConfig.LeisureModelView.id)
    end
  end)
  self.openLabel = self:FindGO("OpenLabel", self.gameObject):GetComponent(UILabel)
  self.openLabel_Bg = self:FindGO("OpenBg", self.openLabel.gameObject):GetComponent(UISprite)
  self.txt_season = self:FindGO("txt_season", self.openLabel.gameObject):GetComponent(UITexture)
  self.openLabel.gameObject:SetActive(false)
end

function MultiPvpView:_loadForbiddenProPfb()
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(_cellName))
  if nil == cellpfb then
    redlog("can not find cellpfb", _cellName)
    return
  end
  cellpfb.transform:SetParent(self.warbandModelBtn.transform, false)
  cellpfb.transform.localScale = LuaGeometry.GetTempVector3(_cellSize, _cellSize, _cellSize)
  return cellpfb
end

function MultiPvpView:InitTex()
  PictureManager.Instance:SetPVP(TEXTURE[1], self.leisureTex)
  PictureManager.Instance:SetPVP(TEXTURE[2], self.warbandTex)
  PictureManager.Instance:SetPVP(TEXTURE[3], self.commingSoonTex)
end

function MultiPvpView:InitShow()
  self.leisureModelView = self:AddSubView("LeisureModelView", LeisureModelView)
  self.warbandModelView = self:AddSubView("WarbandModelView", WarbandModelView)
  self.freeModeView = self:AddSubView("MultiPvpFreeModeView", MultiPvpFreeModeView)
  self.customModeView = self:AddSubView("MultiPvpCustomModeView", MultiPvpCustomModeView)
  self.multiWarbandModelView = self:AddSubView("WarbandModelView_MultiServer", WarbandModelView_MultiServer)
  self:AddTabChangeEvent(self.leisureModelBtn, self.leisureModelObj, self.leisureModelView)
  self:AddTabChangeEvent(self.warbandModelBtn, self.warbandModelObj, self.warbandModelView)
  self:AddTabChangeEvent(self.freeModeBtn, self.freeModeObj, self.freeModeView)
  self:AddTabChangeEvent(self.customModeBtn, self.customModeObj, self.customModeView)
  if self.viewdata.viewdata and self.viewdata.viewdata.tab then
    self:TabChangeHandlerWithPanelID(self.viewdata.viewdata.tab)
  else
    self:TabChangeHandler(self.leisureModelBtn.name)
  end
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
    self.MultiPvpGrid:Reposition()
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
    else
      self.mergeServercupModeArrow.flip = 0
      self.mergeServerStepBg:SetActive(true)
    end
    self.MultiPvpGrid:Reposition()
  end)
  self:UpdateTabDesc()
  self:HandleCupModeStepChoose()
end

function MultiPvpView:AddTabChangeEvent(toggleObj, targetObj, script)
  local key = toggleObj.name
  if not self.coreTabMap[key] then
    local table = ReusableTable.CreateTable()
    table.obj = targetObj
    table.script = script
    table.tabGO = toggleObj
    self.coreTabMap[key] = table
    self:AddClickEvent(toggleObj, function(go)
      self:TabChangeHandler(go.name)
    end)
  end
end

function MultiPvpView:TabChangeHandlerWithPanelID(tabID)
  if tabID == PanelConfig.LeisureModelView.tab then
    self:TabChangeHandler(self.leisureModelBtn.name)
  elseif tabID == PanelConfig.WarbandModelView.tab then
    self:TabChangeHandler(self.warbandModelBtn.name)
  else
    self:TabChangeHandler(self.leisureModelBtn.name)
  end
end

local WarbandStartTimeLeft = function(t)
  local day, hour, min = ClientTimeUtil.GetFormatRefreshTimeStr(t)
  if 0 < day then
    return string.format(ZhString.Warband_Tab_DayTimeLeft, day)
  elseif 0 < hour then
    return string.format(ZhString.Warband_Tab_HourTimeLeft, hour)
  elseif 0 < min then
    return string.format(ZhString.Warband_Tab_MinTimeLeft, min)
  else
    return ZhString.Warband_Tab_SecTimeLeft
  end
end

function MultiPvpView:RefreshScheduleStatus(note)
  local serverData = note and note.body
  self:UpdateTabDesc()
  self.warbandModelView:UpdateScheduleStatus()
  self.multiWarbandModelView:UpdateScheduleStatus()
  local curSeason = serverData and serverData.season or 1
  if curSeason then
    PictureManager.Instance:SetPVP("pvp_icon_season_" .. curSeason, self.txt_season)
  end
end

function MultiPvpView:UpdateTabDesc()
  local multiCupModeStr
  local curServerTime = ServerTime.CurServerTime() / 1000
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
end

function MultiPvpView:TabChangeHandler(key, forceExpand)
  if self.currentKey ~= key then
    if self.currentKey then
      self.coreTabMap[self.currentKey].obj:SetActive(false)
    end
    self.coreTabMap[key].obj:SetActive(true)
    self.coreTabMap[key].script:UpdateView()
    self.currentKey = key
  end
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
  if key == "WarbandModelBtn" then
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
    self.MultiPvpGrid:Reposition()
    self:SwitchToStep_MultiServer(0)
  elseif key == "MergeServerWarbandModeBtn" then
    if self.mergeServercupModeArrow.gameObject.activeSelf then
      self.mergeServercupModeArrow.flip = 0
      self.mergeServerStepBg:SetActive(true)
      self.MultiPvpGrid:Reposition()
    end
    if self.curPageKey ~= key then
      self:SwitchToRankPage_MultiServer()
    end
    self:SwitchToStep(0)
  end
  self.curPageKey = key
end

function MultiPvpView:UpdateView()
  self.coreTabMap[self.currentKey].script:UpdateView()
  self:clearTimeTick()
  self.timeTick = TimeTickManager.Me():CreateTick(0, tick_interval, self._tick, self)
  self:HandleCupModeStepChoose(true)
end

function MultiPvpView:OnExit()
  self:clearTimeTick()
  MultiPvpView.super.OnExit(self)
end

function MultiPvpView:OnDestroy()
  for k, v in pairs(self.coreTabMap) do
    ReusableTable.DestroyAndClearTable(v)
  end
  ReusableTable.DestroyAndClearTable(self.coreTabMap)
  self:clearTimeTick()
  MultiPvpView.super.OnDestroy(self)
end

function MultiPvpView:clearTimeTick()
  if self.timeTick then
    self.timeTick:Destroy()
    self.timeTick = nil
  end
end

function MultiPvpView:_tick()
  WarbandProxy.Instance:TryUpdateScheduleStatus()
end

function MultiPvpView:UpdateFightingTime()
  if self.warbandModelView then
    self.warbandModelView:UpdateFightingTime()
  end
  if self.multiWarbandModelView then
    self.multiWarbandModelView:UpdateFightingTime()
  end
end

function MultiPvpView:UpdateOpenLabel()
  local str = ""
  if self.multiCupModeStr and self.multiCupModeStr ~= "" then
    str = str .. self.multiCupModeStr
  end
  if str ~= "" then
    self.openLabel.gameObject:SetActive(true)
    self.openLabel.text = str
    local printY = self.openLabel.printedSize.y
    self.openLabel_Bg.height = printY + 10
  else
    self.openLabel.gameObject:SetActive(false)
  end
end

function MultiPvpView:HandleCupModeStepChoose(forceRefresh)
  xdlog("12v12 预选赛数据列表更新")
  local forceRefresh = forceRefresh == nil and true or forceRefresh
  local proxy = WarbandProxy.Instance
  local validCount = 0
  if proxy:IsSeasonNoOpen() or proxy:IsSeasonEnd() or proxy:IsSigthupPending() or proxy:GetCurStage() == 4 then
    redlog("12v12 常规杯赛未开启", proxy:GetCurStage())
    self.cupModeArrow.flip = 0
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
    self.preRoundBtn:SetActive(hasPreRound)
    self.mainRoundBtn:SetActive(hasMainRound)
    self.finalRoundBtn:SetActive(hasFinalRound)
    self.rankBtn:SetActive(hasPreRound or hasMainRound or hasFinalRound)
    self.stepBg:SetActive(false)
    self.cupModeArrow.gameObject:SetActive(hasPreRound or hasMainRound or hasFinalRound)
    self:SwitchToRankPage()
  else
    xdlog("12v12杯赛数据存在")
    if forceRefresh then
      self.cupModeArrow.flip = 0
    end
    self.rankBtn:SetActive(false)
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
    self.preRoundBtn:SetActive(hasPreRound)
    self.mainRoundBtn:SetActive(hasMainRound)
    self.finalRoundBtn:SetActive(hasFinalRound)
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
  local MergeServerWarbandValid = false
  if MergeServerWarbandValid then
    self.mergeServerCupModeTabGO:SetActive(true)
    local proxy = WarbandProxy_MultiServer.Instance
    local validCount = 0
    if proxy:IsSeasonNoOpen() or proxy:IsSeasonEnd() or proxy:IsSigthupPending() then
      self.mergeServerStepBg:SetActive(false)
      self.mergeServercupModeArrow.gameObject:SetActive(true)
      self.mergeServercupModeArrow.flip = 2
      self.mergeServerpreRoundBtn:SetActive(true)
      self.mergeServermainRoundBtn:SetActive(true)
      self.mergeServerfinalRoundBtn:SetActive(true)
      self.mergeServerRankBtn:SetActive(true)
      validCount = 4
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
      if hasFinalRound then
        self:SwitchToStep_MultiServer(3)
      elseif hasPreRound then
        self:SwitchToStep_MultiServer(1)
      else
        if hasMainRound then
          self:SwitchToStep_MultiServer(2)
        else
        end
      end
    end
    self.mergeServerStepBg_Sprite.height = 20 + validCount * 55
    self.mergeServerStepGrid:Reposition()
  else
    self.mergeServerCupModeTabGO:SetActive(false)
  end
  self.mergeServerStepGrid:Reposition()
  self.MultiPvpGrid:Reposition()
end

function MultiPvpView:SwitchToRankPage(switchToTab)
  self.preRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.preRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.mainRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.mainRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.finalRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.finalreRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.rankBtnLabel.color = LuaColor.White()
  self.rankBtnDot.color = LuaColor.White()
  if switchToTab then
    self:TabChangeHandler("WarbandModelBtn", true)
    self.warbandModelView:SetPageStatus(1)
  end
  self.preCupModeStep = 0
end

function MultiPvpView:SwitchToRankPage_MultiServer(switchToTab)
  self.mergeServerpreRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.mergeServerpreRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.mergeServermainRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.mergeServermainRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.mergeServerfinalRoundLabel.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.mergeServerfinalRoundDot.color = LuaGeometry.GetTempVector4(0.4, 0.5568627450980392, 0.8470588235294118, 1)
  self.mergeServerRankBtnLabel.color = LuaColor.White()
  self.mergeServerRankBtnDot.color = LuaColor.White()
  if switchToTab then
    self:TabChangeHandler("MergeServerWarbandModeBtn", true)
    self.multiWarbandModelView:SetPageStatus(1)
  end
  self.preCupModeStep_multiServer = 0
end

function MultiPvpView:SwitchToStep(index, switchToTab)
  if not index then
    return
  end
  if 0 < index then
    self.preCupModeStep = index
  end
  if 0 < index and switchToTab then
    self:TabChangeHandler("WarbandModelBtn", true)
    self.warbandModelView:SetPageStatus(2)
    self.warbandModelView.signupOpponentSubView:UpdateStepChoose(index)
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

function MultiPvpView:SwitchToStep_MultiServer(index, switchToTab)
  if not index then
    return
  end
  if 0 < index then
    self.preCupModeStep_multiServer = index
  end
  if 0 < index and switchToTab then
    self:TabChangeHandler("MergeServerWarbandModeBtn", true)
    self.multiWarbandModelView:SetPageStatus(2)
    self.multiWarbandModelView.signupOpponentSubView:UpdateStepChoose(index)
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
