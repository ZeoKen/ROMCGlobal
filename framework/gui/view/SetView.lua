SetView = class("SetView", ContainerView)
autoImport("SetViewSubPage")
autoImport("SetViewSystemState")
autoImport("SetViewEffectState")
autoImport("SetViewSecurityPage")
autoImport("SetViewSwitchRolePage")
autoImport("SetViewServicePage")
autoImport("SetViewServiceTWPage")
autoImport("SetViewServiceKRPage")
autoImport("SetViewServiceWWPage")
autoImport("SetViewServiceNAPage")
autoImport("SetViewServiceEUPage")
autoImport("SetViewServiceNOPage")
autoImport("SetViewServiceNOTWPage")
autoImport("SetViewServiceNOENPage")
SetView.ViewType = UIViewType.NormalLayer
SetView.PlayerHeadCellResId = ResourcePathHelper.UICell("PlayerHeadCell")
SetView.SetToggleCellResId = ResourcePathHelper.UICell("SetToggleCell")
SetView.TabIcons = {
  "tab_icon_31",
  "tab_icon_32",
  "tab_icon_01",
  "setv4"
}
local BattleTimeStringColor = {}

function SetView:Init()
  self:AddViewEvt()
  self:InitData()
  self:FindObj()
  self:AddSubPages()
  self:AddButtonEvt()
  self:InitShow()
  self:SetSaveBtnStatus()
end

function SetView:AddViewEvt()
  self:AddListenEvt(ServiceEvent.NUserBattleTimelenUserCmd, self.HandleTimelen)
  self:AddListenEvt(ServiceEvent.SceneUser3BattleTimeOffUserCmd, self.UpdateBattleTimeSwitch)
  self:AddListenEvt(ServiceEvent.SceneUser3PlayTimeOffUserCmd, self.UpdatePlayTimeSwitch)
  EventManager.Me():AddEventListener(SetViewEvent.SaveBtnStatus, self.SetSaveBtnStatus, self)
end

function SetView:InitData()
  BattleTimeStringColor[1] = "[41c419]%s[-]"
  BattleTimeStringColor[2] = "[ffc945]%s[-]"
  BattleTimeStringColor[3] = "[cf1c0f]%s[-]"
  self.pages = {}
end

function SetView:FindObj()
  self.gameTime = self:FindComponent("GameTime", UILabel)
  self.playTime = self:FindComponent("PlayTime", UILabel)
  self.gameTimeGrid = self:FindComponent("GameTimeGrid", UIGrid)
  local gridObj = self.gameTimeGrid.gameObject
  self.tutorObj = self:FindGO("Tutor", gridObj)
  self.musicObj = self:FindGO("Music", gridObj)
  self.powerObj = self:FindGO("Power", gridObj)
  self.tutorLabel = self:FindComponent("Label", UILabel, self.tutorObj)
  self.musicLabel = self:FindComponent("Label", UILabel, self.musicObj)
  self.powerLabel = self:FindComponent("Label", UILabel, self.powerObj)
  self.gameTimeDetail = self:FindGO("GameTimeDetail")
  self.gameTimeDetailGrid = self:FindComponent("GameTimeDetailGrid", UIGrid)
  self.gameTimeDetailBg = self:FindComponent("DetailBg", UISprite, self.gameTimeDetail)
  gridObj = self.gameTimeDetailGrid.gameObject
  self.tutorDetailObj = self:FindGO("Tutor", gridObj)
  self.musicDetailObj = self:FindGO("Music", gridObj)
  self.powerDetailObj = self:FindGO("Power", gridObj)
  self.tutorDetailLabel = self:FindComponent("Detail", UILabel, self.tutorDetailObj)
  self.musicDetailLabel = self:FindComponent("Detail", UILabel, self.musicDetailObj)
  self.powerDetailLabel = self:FindComponent("Detail", UILabel, self.powerDetailObj)
  self.battleTimeSlider = self:FindComponent("BattleTimeSlider", UISlider)
  self.subPageScrollView = self:FindComponent("SubPageScrollView", UIScrollView)
  self.togglesParent = self:FindGO("toggles")
  self.toggleGrid = self.togglesParent:GetComponent(UIGrid)
  self.playTimeSlider = self:FindComponent("PlayTimeSlider", UISlider)
  self:InitSwitchComponents()
  self:AddOrRemoveGuideId("CloseButton", 475)
  self:AddHelpButtonEvent()
end

function SetView:InitSwitchComponents()
  self:InitSwitch(BattleTimeDataProxy.ESwitchType.BATTLE, {
    labelName = "BattleTimeSwitchLab",
    labelText = ISNoviceServerType and ZhString.SetViewBattleTimeSwitch_Novice or ZhString.SetViewBattleTimeSwitch,
    coliderName = "BattleTimeColider",
    objName = "BattleTimeSwitchObj"
  })
  self:InitSwitch(BattleTimeDataProxy.ESwitchType.PLAY, {
    labelName = "PlayTimeSwitchLab",
    labelText = ZhString.SetViewPlayTimeSwitch,
    coliderName = "PlayTimeColider",
    objName = "PlayTimeSwitchObj"
  })
end

function SetView:InitSwitch(switchType, config)
  local switchComponents = {}
  switchComponents.label = self:FindComponent(config.labelName, UILabel)
  switchComponents.label.text = config.labelText
  switchComponents.colider = self:FindGO(config.coliderName, switchComponents.label.gameObject)
  self:AddClickEvent(switchComponents.colider, function()
    BattleTimeDataProxy.Instance:QuerySwitch(switchType)
  end)
  switchComponents.obj = self:FindGO(config.objName, switchComponents.colider)
  self["switch_" .. switchType] = switchComponents
  self:UpdateSwitch(switchType)
end

function SetView:UpdateSwitch(switchType)
  local components = self["switch_" .. switchType]
  if not components then
    return
  end
  local on = BattleTimeDataProxy.Instance:CheckSwitchOn(switchType)
  if on then
    self:Show(components.obj)
  else
    self:Hide(components.obj)
  end
end

function SetView:UpdateBattleTimeSwitch()
  self:UpdateSwitch(BattleTimeDataProxy.ESwitchType.BATTLE)
end

function SetView:UpdatePlayTimeSwitch()
  self:UpdateSwitch(BattleTimeDataProxy.ESwitchType.PLAY)
end

function SetView:AddSubPages()
  self.setViewSystemState = self:AddSubPage("SetViewSystemState", ZhString.SetView_SystemTabName)
  self:AddSubPage("SetViewEffectState", ZhString.SetView_EffectTabName)
  self:AddSubPage("SetViewSecurityPage", ZhString.SetViewSecurityPage_TabText)
  if BranchMgr.IsJapan() then
    self:AddSubPage("SetViewServicePage", ZhString.SetViewTabAbout)
  elseif BranchMgr.IsTW() then
    self:AddSubPage("SetViewServiceTWPage", ZhString.SetViewTabCustomerService)
  elseif BranchMgr.IsKorea() then
    self:AddSubPage("SetViewServiceKRPage", ZhString.SetViewTabCustomerService)
  elseif BranchMgr.IsSEA() then
    self:AddSubPage("SetViewServiceWWPage", ZhString.SetViewTabCustomerService)
  elseif BranchMgr.IsNO() then
    self:AddSubPage("SetViewServiceNOPage", ZhString.SetViewTabCustomerService, "view/SetViewServiceWWPage")
  elseif BranchMgr.IsNOTW() then
    self:AddSubPage("SetViewServiceNOTWPage", ZhString.SetViewTabCustomerService, "view/SetViewServiceWWPage")
  elseif BranchMgr.IsNA() then
    self:AddSubPage("SetViewServiceNAPage", ZhString.SetViewTabCustomerService)
  elseif BranchMgr.IsEU() then
    self:AddSubPage("SetViewServiceEUPage", ZhString.SetViewTabCustomerService)
  elseif BranchMgr.IsNOEN() then
    self:AddSubPage("SetViewServiceNOENPage", ZhString.SetViewTabCustomerService, "view/SetViewServiceWWPage")
  end
  self.switchRolePage = self:AddSubView("SetViewSwitchRolePage", SetViewSwitchRolePage)
end

function SetView:AddButtonEvt()
  self:AddButtonEvent("BackLoginBtn", function()
    Game.Me():BackToLogo()
  end)
  self.saveBtn = self:FindGO("SaveBtn")
  self:AddClickEvent(self.saveBtn, function()
    self:Save()
  end)
  local callback = function()
    self.gameTimeDetail:SetActive(true)
    self.gameTimeDetailGrid:Reposition()
  end
  self:AddClickEvent(self.tutorObj, callback)
  self:AddClickEvent(self.musicObj, callback)
  self:AddClickEvent(self.powerObj, callback)
end

function SetView:InitShow()
  self.gameTimeDetail:SetActive(false)
  self:_ForEachPage(function(key, page)
    page:SetPageActive(false)
  end)
  self:InitPortrait()
  BattleTimeDataProxy.QueryBattleTimelenUserCmd()
end

function SetView:OnEnter()
  SetView.super.OnEnter(self)
  local setViewConfig = GameConfig.SetViewPages
  setViewConfig = setViewConfig or GameConfig.SetViewPages
  if setViewConfig then
    for pageName, _ in pairs(setViewConfig) do
      local page = self:GetPageByName(pageName)
      if page then
        page:SetPageActive(true)
      end
    end
  end
  self.toggleGrid:Reposition()
  local firstKey = 0
  for i = 1, 999 do
    if self.pages[i]:GetPageActive() then
      firstKey = i
      break
    end
  end
  self:TabChangeHandler(firstKey)
end

function SetView:AddSubPage(pageName, tabLabelText, prefabPath, openCheck)
  local page = self:AddSubView(pageName, _G[pageName], prefabPath or "view/" .. pageName)
  openCheck = openCheck or PanelConfig[pageName]
  local key = openCheck and openCheck.tab or 0
  self.pages[key] = page
  page:SetTab(tabLabelText, SetView.TabIcons[key])
  self:AddTabChangeEvent(page.tabGO, page.gameObject, openCheck)
  return page
end

function SetView:TabChangeHandler(key)
  if self.state ~= key then
    SetView.super.TabChangeHandler(self, key)
    if self.state ~= nil then
      self:SwitchOff(self.state)
    end
    self:SwitchOn(key)
  end
end

function SetView:SwitchOn(key)
  self.subPageScrollView:ResetPosition()
  self.pages[key]:SwitchOn()
  self.state = key
end

function SetView:SwitchOff(key)
  self.pages[key]:SwitchOff()
  self.state = nil
end

function SetView:InitPortrait()
  if not self.targetCell then
    local headCellObj = self:FindGO("SetPortraitCell")
    self.headCellObj = Game.AssetManager_UI:CreateAsset(SetView.PlayerHeadCellResId, headCellObj)
    self.headCellObj.transform.localPosition = LuaGeometry.Const_V3_zero
    self.headCellObj.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 0.8)
    self.targetCell = PlayerFaceCell.new(self.headCellObj)
    self.targetCell:HideHpMp()
    self.targetCell:HideLevel()
  end
  local headData = HeadImageData.new()
  headData:TransByMyself()
  self.targetCell:SetData(headData)
end

function SetView:GetPageByName(pageName)
  local result
  self:_ForEachPage(function(key, page)
    if page.__cname == pageName then
      result = page
    end
  end)
  return result
end

function SetView:HandleTimelen(note)
  local data = note.body
  if data then
    self:SetGameTime(data)
  end
end

function SetView:SetGameTime(data)
  local battleTimeMgr = BattleTimeDataProxy.Instance
  local timeLen = battleTimeMgr:Timelen()
  local timeTotal = battleTimeMgr:TotalTimeLen()
  local musicTime = battleTimeMgr:MusicTime()
  local tutorTime = battleTimeMgr:TutorTime()
  local powerTime = battleTimeMgr:PowerTime()
  local color = battleTimeMgr:GetStatus()
  local playTimeLen = battleTimeMgr:UsedPlayTime()
  local playTotalTimeLen = battleTimeMgr:TotalPlayTime()
  local gameTime_str = ISNoviceServerType and ZhString.Set_GameTime_DailyValidKillCount or ZhString.Set_GameTime
  self.gameTime.text = string.format(gameTime_str, string.format(BattleTimeStringColor[color], timeLen), timeTotal)
  self.battleTimeSlider.value = 0
  if 0 < timeTotal then
    self.battleTimeSlider.value = timeLen < timeTotal and timeLen / timeTotal or 1
  end
  self:SetGameTimePart(self.tutorObj, self.tutorLabel, tutorTime)
  self:SetGameTimePart(self.musicObj, self.musicLabel, musicTime)
  self:SetGameTimePart(self.powerObj, self.powerLabel, powerTime)
  self.gameTimeGrid:Reposition()
  local showDetailNum = 0
  showDetailNum = showDetailNum + (self:_SetGameTimePart(self.tutorDetailObj, self.tutorDetailLabel, tutorTime, "Set_GameTutorTimeTip") and 1 or 0)
  showDetailNum = showDetailNum + (self:_SetGameTimePart(self.musicDetailObj, self.musicDetailLabel, musicTime, "Set_GameMusicTimeTip") and 1 or 0)
  showDetailNum = showDetailNum + (self:_SetGameTimePart(self.powerDetailObj, self.powerDetailLabel, powerTime, "Set_GamePowerTimeTip") and 1 or 0)
  self.gameTimeDetailGrid:Reposition()
  self.gameTimeDetailBg.height = 98 + showDetailNum * 36
  local str = battleTimeMgr:UseDailyPlayTime() and ZhString.SetView_PlayTime_Daily or ZhString.SetView_PlayTime
  self.playTime.text = string.format(str, playTimeLen, playTotalTimeLen)
  self.playTimeSlider.value = 0
  if 0 < playTotalTimeLen then
    self.playTimeSlider.value = playTimeLen < playTotalTimeLen and playTimeLen / playTotalTimeLen or 1
  else
    self.playTimeSlider.value = 1
  end
end

function SetView:SetGameTimePart(obj, label, time)
  return self:_SetGameTimePart(obj, label, time, "Set_GameTimeTipFormat")
end

function SetView:_SetGameTimePart(obj, label, time, formatKey)
  time = time or 0
  local isShow = 0 < time
  if obj then
    obj:SetActive(isShow)
  end
  if label and isShow then
    label.text = string.format(formatKey and ZhString[formatKey] or "%s", time)
  end
  return isShow
end

function SetView:SetSaveBtnStatus()
  if self.pages ~= nil then
    local isChanged = false
    for i = 1, #self.pages do
      if self.pages[i].IsChanged ~= nil and not isChanged then
        isChanged = self.pages[i]:IsChanged()
      end
    end
    if self.saveBtn == nil then
      local SaveBtn = self:FindGO("SaveBtn")
      self.saveBtn = SaveBtn
    end
    local collider = self.saveBtn:GetComponent(BoxCollider)
    local btn = self.saveBtn:GetComponent(UISprite)
    collider.enabled = isChanged and true or false
    if btn ~= nil then
      btn.color = isChanged and ColorUtil.NGUIWhite or ColorUtil.NGUIShaderGray
    end
    local label = self:FindGO("Label", self.saveBtn):GetComponent(UILabel)
    label.effectColor = isChanged and ColorUtil.ButtonLabelOrange or ColorUtil.TitleGray
  end
end

function SetView:Save()
  self:_ForEachPage(function(key, page)
    page:Save()
  end)
  MsgManager.FloatMsg(nil, Table_Sysmsg[34009].Text)
  local collider = self.saveBtn:GetComponent(BoxCollider)
  local btn = self.saveBtn:GetComponent(UISprite)
  collider.enabled = false
  if btn ~= nil then
    btn.color = ColorUtil.NGUIShaderGray
  end
  local label = self:FindGO("Label", self.saveBtn):GetComponent(UILabel)
  if label ~= nil then
    label.effectColor = ColorUtil.TitleGray
  end
  BattleTimeDataProxy.QueryBattleTimeCostSelectCmd(self.setViewSystemState.gameTimeSetting)
end

function SetView:_ForEachPage(action, args)
  for i = 1, #self.pages do
    action(i, self.pages[i], args)
  end
end

function SetView:AddHelpButtonEvent()
  self.helpButton = self:FindGO("GameTimeHelpButton")
  self:AddClickEvent(self.helpButton, function(go)
    self:OnClickHelpBtn()
  end)
end

function SetView:OnClickHelpBtn()
  local datas
  datas = {
    Table_Help[GameConfig.Setting.GametimeHelpId],
    Table_Help[GameConfig.Setting.PlaytimeHelpId]
  }
  if nil == next(datas) then
    return
  end
  TipsView.Me():ShowTip(SettingViewHelp, datas, "SettingViewHelp")
end
