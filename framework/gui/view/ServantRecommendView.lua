autoImport("WrapCellHelper")
autoImport("ServantRecommendCell")
autoImport("ServantRaidStatView")
autoImport("ServantProjectSmallCell")
autoImport("ServantProjectLevelListPopUp")
local BTN_BG_IMG = {
  "taskmanual_btn_1",
  "taskmanual_btn_2"
}
local BTN_BG_IMG2 = {
  "taskmanual_btn_3",
  "taskmanual_btn_3b"
}
ServantRecommendView = class("ServantRecommendView", SubView)
ServantRecommendView._ColorEffectBlue = Color(0.25882352941176473, 0.4823529411764706, 0.7568627450980392, 1)
ServantRecommendView._ColorTitleGray = ColorUtil.TitleGray
local ColorEffectOrange = ColorUtil.ButtonLabelOrange
local ColorEffectBlue = ColorUtil.ButtonLabelBlue
local Prefab_Path = ResourcePathHelper.UIView("ServantRecommendView")
local KJMC_QUEST_ID = 305000001
local KJMC_GUIDE_QUEST_ID = 99090033

function ServantRecommendView:Init()
  BattleTimeDataProxy.QueryBattleTimelenUserCmd()
  self:FindObjs()
  self:AddUIEvts()
  self:AddViewEvts()
  self.chooseTypeId = 1
  self.tipData = {}
  self:ShowUI(self.chooseTypeId)
  self:UpdateWeekLimited()
end

function ServantRecommendView:FindObjs()
  self:LoadSubView()
  self.scrollView = self:FindComponent("ScrollView", UIScrollView)
  local wrapConfig = {
    wrapObj = self:FindGO("ItemWrap"),
    pfbNum = 6,
    cellName = "ServantRecommendCell",
    control = ServantRecommendCell
  }
  self.cellCtl = WrapCellHelper.new(wrapConfig)
  self.cellCtl:AddEventListener(ServantRecommendView.ShowHideClickBlock, self.project_ShowHideClickBlock, self)
  self.calendarBtn = self:FindGO("CalendarTog")
  self.raidstatBtn = self:FindGO("RaidStatTog")
  self:RegisterRedTipCheck(ServantRaidStatProxy.WholeRedTipID, self.raidstatBtn, 9, {-10, 0})
  self.recommendBtn = self:FindGO("RecommendTog")
  self:RegisterRedTipCheck(ServantRecommendProxy.WholeRedTipID, self.recommendBtn, 9, {-10, 0})
  self.calendarBtnImg = self.calendarBtn:GetComponent(UISprite)
  self.raidstatBtnImg = self.raidstatBtn:GetComponent(UISprite)
  self.recommendBtnImg = self.recommendBtn:GetComponent(UISprite)
  self.calendarLab = self:FindComponent("Lab", UILabel, self.calendarBtn)
  self.calendarLab.text = ZhString.Servant_Calendar_CalendarTogLab
  self.raidstatLab = self:FindComponent("Lab", UILabel, self.raidstatBtn)
  self.raidstatLab.text = ZhString.Servant_Calendar_RaidStatTogLab
  self.recommendLab = self:FindComponent("Lab", UILabel, self.recommendBtn)
  self.recommendLab.text = ZhString.Servant_Calendar_RecommendTogLab
  self.calPos = self:FindGO("calendarViewPos")
  self.raidstatPos = self:FindGO("raidstatViewPos")
  self.recomPos = self:FindGO("recommendPos")
  self.helpBtn = self:FindGO("HelpBtn")
  self:SetBtn(1)
  local dailyObj = self:FindGO("DailyToggle")
  self.dailyToggle = dailyObj:GetComponent(UIToggle)
  self.dailyLab = dailyObj:GetComponent(UILabel)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SERVANT_RECOMMNED_DAY, dailyObj, 6, {0, 6})
  self.dailyLab.text = ZhString.Servant_Recommend_PageDaily
  local weekObj = self:FindGO("WeeklyToggle")
  self.weeklyToggle = weekObj:GetComponent(UIToggle)
  self.weeklyLab = weekObj:GetComponent(UILabel)
  self.weeklyLab.text = ZhString.Servant_Recommend_PageWeek
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SERVANT_RECOMMNED_WEEK, weekObj, 6, {0, 6})
  local guideObj = self:FindGO("GuideToggle")
  self.guideToggle = guideObj:GetComponent(UIToggle)
  self.guideLab = guideObj:GetComponent(UILabel)
  self.guideLab.text = ZhString.Servant_Recommend_PageGuide
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SERVANT_RECOMMNED_FOREVER, guideObj, 6, {0, 6})
  local shortcutObj = self:FindGO("ShortCutToggle")
  self.shortcutToggle = shortcutObj:GetComponent(UIToggle)
  self.shortcutLab = shortcutObj:GetComponent(UILabel)
  self.shortcutLab.text = ZhString.Servant_Recommend_PageShortCut
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SERVANT_RECOMMNED_SHORTCUT, shortcutObj, 6, {0, 6})
  local projectObj = self:FindGO("ProjectToggle")
  if NoviceTarget2023Proxy.Enable ~= true and GameConfig.NewTopic and GameConfig.NewTopic.UnLockMenuId and FunctionUnLockFunc.Me():CheckCanOpen(GameConfig.NewTopic.UnLockMenuId) then
    projectObj:SetActive(true)
  else
    projectObj:SetActive(false)
  end
  self.projectToggle = projectObj:GetComponent(UIToggle)
  self.projectLab = projectObj:GetComponent(UILabel)
  local pid = FunctionPlayerPrefs.Me():GetInt("Servant_Recommend_PageProject", 1)
  self.projectLab.text = ZhString.Servant_Recommend_PageProject .. tostring(pid)
  self:RegisterRedTipCheck(SignIn21Proxy.REDTIP_PROJECT_LIST, projectObj, 6, {0, 6})
  self.projectPopup = self:FindGO("projPopup", projectObj)
  local projectPopup_closecomp = self.projectPopup:GetComponent(CloseWhenClickOtherPlace)
  
  function projectPopup_closecomp.callBack(go)
    self:ShowHideProjectSmallListPopup(false)
  end
  
  self.projPopupBtnArrow = self:FindGO("projPopupBtnArrow", projectObj)
  self.projPopupBtn = self:FindGO("projPopupBtn", projectObj)
  self:AddClickEvent(self.projPopupBtn, function()
    self:ShowHideProjectSmallListPopup()
  end)
  self.projectPopupBg = self:FindComponent("bg", UISprite, self.projectPopup)
  local grid = self:FindComponent("selectGrid", UIGrid, self.projectPopup)
  self.projectSmallList = UIGridListCtrl.new(grid, ServantProjectSmallCell, "ServantProjectSmallCell")
  self.projectSmallList:AddEventListener(MouseEvent.MouseClick, self.On_projectSmallList_clickCell, self)
  self.projectProgress = self:FindGO("ProjectProgress")
  self.project_shandian_value = self:FindComponent("shandian_value", UILabel, self.projectProgress)
  local project_shandian_icon = self:FindComponent("shandian_btn", UISprite, self.projectProgress)
  IconManager:SetItemIcon("item_181", project_shandian_icon)
  self.project_liwu_meiling = self:FindGO("meiling", self.projectProgress)
  self.project_liwu_lingle = self:FindGO("lingle", self.projectProgress)
  local liwu = self:FindGO("liwu", self.projectProgress)
  self:AddClickEvent(liwu, function()
    self:Project_GetReward()
  end)
  self:RegisterRedTipCheck(SignIn21Proxy.REDTIP_PROJECT_BOX, liwu, 6, {0, 6})
  self.project_liwu_effc = self:FindGO("liwu_effc", self.projectProgress)
  self.project_liwu_effc:SetActive(false)
  self.ProjectProgressPopup = self:FindGO("ProjectProgressPopup")
  self.project_jiesuotishi = self:FindGO("jiesuotishi", self.projectProgress)
  self.project_jiesuotishi:GetComponent(UILabel).text = ZhString.Servant_Recommend_PageProject_hint
  self.project_jiesuotishi:SetActive(false)
  self.project_clickBlocker = self:FindGO("clickBlocker", self.projectProgress)
  self.itemContainer = self:FindGO("ItemContainer"):GetComponent(UIWidget)
  self.toShopBtn = self:FindGO("ToShop")
  local sp = self:FindComponent("__1", UISprite, self.toShopBtn)
  if sp and not IconManager:SetItemIcon("icon_136", sp) then
    IconManager:SetUIIcon("icon_136", sp)
  end
  self:AddClickEvent(self.toShopBtn, function()
    self:ToShopView()
  end)
  self.weekLimitedLab = self:FindComponent("WeekLimitedLab", UILabel)
  self.fixedWeekLimitedLab = self:FindComponent("FixedWeekLimitedLab", UILabel)
  self.fixedWeekLimitedLab.text = ZhString.Servant_Recommend_WeeklyLimited
  self.favoriteItem = self:FindComponent("FavoriteItem", UISprite)
  self.empty = self:FindGO("Empty")
  self.emptyLab = self:FindComponent("EmptyLab", UILabel)
  self.emptyLab.text = ZhString.Servant_Recommend_EmptyWeek
  self:Hide(self.raidstatBtn)
  self:Hide(guideObj)
  self:Hide(shortcutObj)
end

local maxLimited = GameConfig.Servant.recommend_max_coin or 4500

function ServantRecommendView:UpdateWeekLimited()
  local myServant = MyselfProxy.Instance:GetMyServantID()
  local favorCFG = HappyShopProxy.Instance:GetServantShopMap()
  local favoritemid = favorCFG and favorCFG[myServant] and favorCFG[myServant].npcFavoriteItemid or 5828
  local iconName = Table_Item[favoritemid] and Table_Item[favoritemid].Icon or ""
  IconManager:SetItemIcon(iconName, self.favoriteItem)
  local weeknum = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_SERVANT_RECOMMEND_COIN) or 0
  self.weekLimitedLab.text = string.format(ZhString.GuildBuilding_Submit_MatNum, weeknum, maxLimited)
end

function ServantRecommendView:PageToggleChange(toggle, label, toggleColor, normalColor, handler, param)
  EventDelegate.Add(toggle.onChange, function()
    if toggle.value then
      label.color = toggleColor
      if handler ~= nil then
        self.chooseTypeId = param
        handler(self, param)
      end
    else
      label.color = normalColor
    end
  end)
end

function ServantRecommendView:SetBtn(var)
  self.isCalendar = false
  if var == 2 then
    self.calendarLab.effectColor = ColorEffectBlue
    self.raidstatLab.effectColor = ColorEffectOrange
    self.recommendLab.effectColor = ColorEffectBlue
    self.calendarBtnImg.spriteName = BTN_BG_IMG[1]
    self.raidstatBtnImg.spriteName = BTN_BG_IMG2[2]
    self.recommendBtnImg.spriteName = BTN_BG_IMG[1]
  elseif var == 3 then
    self.isCalendar = true
    self.calendarLab.effectColor = ColorEffectOrange
    self.raidstatLab.effectColor = ColorEffectBlue
    self.recommendLab.effectColor = ColorEffectBlue
    self.calendarBtnImg.spriteName = BTN_BG_IMG[2]
    self.raidstatBtnImg.spriteName = BTN_BG_IMG2[1]
    self.recommendBtnImg.spriteName = BTN_BG_IMG[1]
  else
    self.calendarLab.effectColor = ColorEffectBlue
    self.raidstatLab.effectColor = ColorEffectBlue
    self.recommendLab.effectColor = ColorEffectOrange
    self.calendarBtnImg.spriteName = BTN_BG_IMG[1]
    self.raidstatBtnImg.spriteName = BTN_BG_IMG2[1]
    self.recommendBtnImg.spriteName = BTN_BG_IMG[2]
  end
end

function ServantRecommendView:AddUIEvts()
  self:RegistShowGeneralHelpByHelpID(30000, self.helpBtn)
  self:AddClickEvent(self.calendarBtn, function(go)
    if not self.calendarView then
      self.calendarView = self:AddSubView("ServantCalendarView", ServantCalendarView)
    end
    self:SetBtn(3)
    self:Show(self.calPos)
    self:Hide(self.raidstatPos)
    self:Hide(self.recomPos)
    self.calendarView:OnClickWeekTog()
  end)
  self:AddClickEvent(self.raidstatBtn, function(go)
    if not self.raidstatView then
      self.raidstatView = self:AddSubView("ServantRaidStatView", ServantRaidStatView)
    end
    self:SetBtn(2)
    self:Hide(self.calPos)
    self:Show(self.raidstatPos)
    self:Hide(self.recomPos)
    self.container:SetMainTexture()
  end)
  self:AddClickEvent(self.recommendBtn, function(go)
    self:SetBtn(1)
    self:Hide(self.calPos)
    self:Hide(self.raidstatPos)
    self:Show(self.recomPos)
    self.container:SetMainTexture()
    self:ShowUI(self.chooseTypeId)
  end)
  self:PageToggleChange(self.dailyToggle, self.dailyLab, ServantRecommendView._ColorEffectBlue, ServantRecommendView._ColorTitleGray, self.ShowUI, 1)
  self:PageToggleChange(self.weeklyToggle, self.weeklyLab, ServantRecommendView._ColorEffectBlue, ServantRecommendView._ColorTitleGray, self.ShowUI, 2)
  self:PageToggleChange(self.guideToggle, self.guideLab, ServantRecommendView._ColorEffectBlue, ServantRecommendView._ColorTitleGray, self.ShowUI, 3)
  self:PageToggleChange(self.shortcutToggle, self.shortcutLab, ServantRecommendView._ColorEffectBlue, ServantRecommendView._ColorTitleGray, self.ShowUI, ServantRecommendProxy.TSHORTCUT)
  self:PageToggleChange(self.projectToggle, self.projectLab, ServantRecommendView._ColorEffectBlue, ServantRecommendView._ColorTitleGray, self.ShowUI, SignIn21Proxy.TPROJECT)
end

function ServantRecommendView:LoadSubView()
  local container = self:FindGO("recommendView")
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, container, true)
  obj.name = "ServantRecommendView"
end

function ServantRecommendView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.NUserRecommendServantUserCmd, self.RecvRecommendServant)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.HandleVarUpdate)
  self:AddListenEvt(ServiceEvent.QuestQuestUpdate, self.RecvRecommendServant)
  self:AddListenEvt(ServiceEvent.NUserBattleTimelenUserCmd, self.RecvRecommendServant)
  self:AddListenEvt(ServiceEvent.QuestQuestStepUpdate, self.HandleRecvQuestStepUpdate)
  self:AddListenEvt(ServiceEvent.NUserNoviceTargetUpdateUserCmd, self.Project_ShowUI)
  self:AddListenEvt(ServiceEvent.NUserNoviceTargetRewardUserCmd, self.Project_ShowUI)
  self:AddListenEvt(MyselfEvent.MyDataChange, function()
    if self.chooseTypeId ~= SignIn21Proxy.TPROJECT then
      return
    end
    self:Project_UpdateInfo()
  end)
  self:AddListenEvt(UICellEvent.OnCellClicked, self.HandleShowItemTip)
end

function ServantRecommendView:HandleVarUpdate()
  self:UpdateWeekLimited()
  self:RecvRecommendServant()
end

function ServantRecommendView:HandleRecvQuestStepUpdate(note)
  local questId = note.body.id
  if questId == KJMC_QUEST_ID or questId == KJMC_GUIDE_QUEST_ID then
    self:RecvRecommendServant()
  end
end

function ServantRecommendView:RecvRecommendServant(note)
  self:ShowUI(self.chooseTypeId)
end

function ServantRecommendView:ShowTexture()
  if self.isCalendar then
    local _, m = ServantCalendarProxy.Instance:ViewDate()
    self.container:SetSeasonTexture(m)
  else
    self.container:SetMainTexture()
  end
end

function ServantRecommendView:ShowUI(type)
  if self.fixedWeekLimitedLab == nil then
    return
  end
  if type == SignIn21Proxy.TPROJECT then
    self:Project_ShowUI()
    return
  else
    self.fixedWeekLimitedLab.gameObject:SetActive(true)
    self.toShopBtn:SetActive(true)
    self.projectProgress:SetActive(false)
    self.emptyLab.text = ZhString.Servant_Recommend_EmptyWeek
    self.project_curSmallIndex = nil
    if self.scrollView.panel then
      self.scrollView.panel.baseClipRegion = LuaGeometry.GetTempVector4(-22, -30, 1048, 546)
    end
  end
  local resultList = {}
  local doubleData
  if type == 1 then
    doubleData = ServantRecommendProxy.Instance:GetRecommendDataByType(6)
  elseif type == 2 then
    doubleData = ServantRecommendProxy.Instance:GetRecommendDataByType(9)
  end
  if doubleData and 0 < #doubleData then
    for i = 1, #doubleData do
      table.insert(resultList, doubleData[i])
    end
  end
  local data = ServantRecommendProxy.Instance:GetRecommendDataByType(type)
  if data and 0 < #data then
    for i = 1, #data do
      table.insert(resultList, data[i])
    end
  end
  table.sort(resultList, function(l, r)
    if l == nil or r == nil then
      return false
    end
    local lFinished = l.status == ServantRecommendProxy.STATUS.FINISHED
    local rFinished = r.status == ServantRecommendProxy.STATUS.FINISHED
    local lReceive = l.status == ServantRecommendProxy.STATUS.RECEIVE
    local rReceive = r.status == ServantRecommendProxy.STATUS.RECEIVE
    local lGo = l.status == ServantRecommendProxy.STATUS.GO
    local rGo = r.status == ServantRecommendProxy.STATUS.GO
    local lDouble = l.double
    local rDouble = r.double
    local sameRecycle = l.staticData.Recycle == r.staticData.Recycle
    if lDouble and rDouble then
      if sameRecycle then
        if l.staticData.Sort and r.staticData.Sort then
          return l.staticData.Sort < r.staticData.Sort
        elseif l.staticData.Sort or r.staticData.Sort then
          return l.staticData.Sort ~= nil
        else
          return l.staticData.id < r.staticData.id
        end
      else
        return l.staticData.Recycle > r.staticData.Recycle
      end
    end
    if lDouble or rDouble then
      return lDouble == true and not lFinished
    end
    if lReceive and rReceive then
      if sameRecycle then
        if l.staticData.Sort and r.staticData.Sort then
          return l.staticData.Sort < r.staticData.Sort
        elseif l.staticData.Sort or r.staticData.Sort then
          return l.staticData.Sort ~= nil
        else
          return l.staticData.id < r.staticData.id
        end
      else
        return l.staticData.Recycle > r.staticData.Recycle
      end
    end
    if lReceive or rReceive then
      return lReceive == true
    end
    if lGo and rGo then
      if sameRecycle then
        if l.staticData.Sort and r.staticData.Sort then
          return l.staticData.Sort < r.staticData.Sort
        elseif l.staticData.Sort or r.staticData.Sort then
          return l.staticData.Sort ~= nil
        else
          return l.staticData.id < r.staticData.id
        end
      else
        return l.staticData.Recycle > r.staticData.Recycle
      end
    end
    if lGo or rGo then
      return lGo == true
    end
    if lFinished and rFinished then
      if sameRecycle then
        if l.staticData.Sort and r.staticData.Sort then
          return l.staticData.Sort < r.staticData.Sort
        elseif l.staticData.Sort or r.staticData.Sort then
          return l.staticData.Sort ~= nil
        else
          return l.staticData.id < r.staticData.id
        end
      else
        return l.staticData.Recycle > r.staticData.Recycle
      end
    end
    if lFinished or rFinished then
      return lFinished == false
    end
  end)
  self.empty:SetActive(#resultList <= 0)
  self.cellCtl:ResetDatas(resultList)
  self.scrollView:ResetPosition()
  ServantRecommendProxy.Instance:UpdateWholeRedTip()
end

function ServantRecommendView:ToShopView()
  FuncShortCutFunc.Me():CallByID(4085)
end

function ServantRecommendView:ShowHideProjectSmallListPopup(show)
  if not self.projectPopup or Slua.IsNull(self.projectPopup) then
    return
  end
  if show == nil then
    show = not self.projectPopup.activeSelf
  end
  if show then
    if self.projPopupBtnArrow and not Slua.IsNull(self.projPopupBtnArrow) then
      self.projPopupBtnArrow.transform.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, 90)
    end
    self.projectPopup:SetActive(true)
    self:RefreshProjectSmallList()
  else
    if self.projPopupBtnArrow and not Slua.IsNull(self.projPopupBtnArrow) then
      self.projPopupBtnArrow.transform.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, -90)
    end
    self.projectPopup:SetActive(false)
  end
end

local cellheight = 45

function ServantRecommendView:RefreshProjectSmallList()
  local list = SignIn21Proxy.Instance:GetProjectSmallList()
  self.projectSmallList:ResetDatas(list)
  local cells = self.projectSmallList:GetCells()
  self.projectPopupBg.height = cellheight * #cells + 36
end

function ServantRecommendView:On_projectSmallList_clickCell(cell)
  if self.chooseTypeId ~= SignIn21Proxy.TPROJECT then
    self:Project_SwitchDay(cell.id, true)
    self.projectToggle.value = true
  else
    self:Project_SwitchDay(cell.id)
  end
  self:ShowHideProjectSmallListPopup(false)
end

function ServantRecommendView:Project_SwitchDay(day, dont_Project_UpdateList)
  self:RefreshProjectSmallList()
  local cells = self.projectSmallList:GetCells()
  day = math.min(#cells, day)
  local needRepos = self.project_curSmallIndex ~= day
  if self.project_curSmallIndex ~= day then
    self.project_curSmallIndex = day
    for i = 1, #cells do
      cells[i]:SetSelected(false)
    end
    if 0 < day then
      cells[day]:SetSelected(true)
    end
  end
  FunctionPlayerPrefs.Me():SetInt("Servant_Recommend_PageProject", self.project_curSmallIndex)
  self.projectLab.text = ZhString.Servant_Recommend_PageProject .. tostring(self.project_curSmallIndex)
  if dont_Project_UpdateList ~= true then
    self:Project_UpdateList(needRepos)
  end
end

function ServantRecommendView:Project_UpdateInfo()
  self.project_shandian_value.text = SignIn21Proxy.Instance:GetMyTargetPoint() .. "/" .. SignIn21Proxy.Instance:GetNextTargetPoint()
  if SignIn21Proxy.Instance:IsAllLevelRewardGet() then
    if self.ever_ling_liwu then
      self.project_liwu_meiling:SetActive(false)
      self.project_liwu_lingle:SetActive(true)
    else
      self.project_liwu_meiling:SetActive(true)
      self.project_liwu_lingle:SetActive(false)
    end
    self:Project_clearGiftEffect()
  else
    self.project_liwu_meiling:SetActive(true)
    self.project_liwu_lingle:SetActive(false)
    self:Project_creatGiftEffect()
  end
end

local tempVector3 = LuaVector3(80, 80, 80)

function ServantRecommendView:Project_creatGiftEffect()
  if not self.giftEffectGO then
    local _path = ResourcePathHelper.EffectUI(EffectMap.UI.ServantGift2)
    self.giftEffectGO = Game.AssetManager_UI:CreateAsset(_path, self.project_liwu_effc)
    self.giftEffectGO.transform.localPosition = LuaVector3.Zero()
    self.giftEffectGO.transform.localScale = LuaVector3.One()
  end
  self.project_liwu_effc:SetActive(true)
end

function ServantRecommendView:Project_clearGiftEffect()
  if self.giftEffectGO then
    GameObject.Destroy(self.giftEffectGO)
    self.giftEffectGO = nil
  end
  self.project_liwu_effc:SetActive(false)
end

function ServantRecommendView:Project_ShowUI()
  if self.chooseTypeId ~= SignIn21Proxy.TPROJECT then
    return
  end
  local pid = FunctionPlayerPrefs.Me():GetInt("Servant_Recommend_PageProject", 1)
  self:Project_SwitchDay(pid)
  self:Project_UpdateInfo()
  self.projectProgress:SetActive(true)
  self.fixedWeekLimitedLab.gameObject:SetActive(false)
  self.emptyLab.text = ZhString.Servant_Recommend_PageProject_Empty
  self.toShopBtn:SetActive(false)
  self.projectProgress:SetActive(true)
end

function ServantRecommendView:Project_UpdateList(needRepos)
  if self.project_curSmallIndex == nil then
    self.empty:SetActive(true)
    self.cellCtl:ResetDatas({})
    return
  end
  if self.scrollView.panel then
    if SignIn21Proxy.Instance:IsDayAbleToUnlockNext(self.project_curSmallIndex) then
      self.scrollView.panel.baseClipRegion = LuaGeometry.GetTempVector4(-22, -30, 1048, 546)
      self.project_jiesuotishi:SetActive(false)
    else
      self.scrollView.panel.baseClipRegion = LuaGeometry.GetTempVector4(-22, -10, 1048, 506)
      self.project_jiesuotishi:SetActive(true)
    end
  end
  local resultList = SignIn21Proxy.Instance:GetProjectList(self.project_curSmallIndex, true)
  local sign21Ins = SignIn21Proxy.Instance
  local s2 = function(d)
    if d == SceneUser2_pb.ENOVICE_TARGET_REWARDED then
      return -1
    elseif d == SceneUser2_pb.ENOVICE_TARGET_FINISH then
      return 1
    end
    return 0
  end
  table.sort(resultList, function(l, r)
    if l == nil or r == nil then
      return false
    end
    local l_state = sign21Ins:GetTargetState(l.id)
    local r_state = sign21Ins:GetTargetState(r.id)
    local lFinished = s2(l_state)
    local rFinished = s2(r_state)
    if lFinished and rFinished and lFinished ~= rFinished then
      return lFinished > rFinished
    end
    if l.Sort and r.Sort and l.Sort ~= r.Sort then
      return l.Sort < r.Sort
    else
      return l.id < r.id
    end
  end)
  self.empty:SetActive(#resultList <= 0)
  self.cellCtl:ResetDatas(resultList)
  if needRepos then
    self.scrollView:ResetPosition()
  end
  ServantRecommendProxy.Instance:UpdateWholeRedTip()
end

function ServantRecommendView:Project_GetReward()
  if SignIn21Proxy.Instance:IsAllLevelRewardGet() then
    if not self.levelListPage then
      self.levelListPage = self:AddSubView("ServantProjectLevelListPopUp", ServantProjectLevelListPopUp)
    end
    self.levelListPage:SetActive(true)
    self.levelListPage:AdjustScrollView()
  else
    self.ever_ling_liwu = true
    ServiceNUserProxy.Instance:CallNoviceTargetRewardUserCmd(nil, true)
  end
end

function ServantRecommendView:HandleShowItemTip(note)
  local data = note.body
  local itemid = data.itemid
  if itemid then
    self.tipData.itemdata = ItemData.new("Reward", itemid)
    self:ShowItemTip(self.tipData, self.itemContainer, NGUIUtil.AnchorSide.Center, {0, 0})
  end
end

ServantRecommendView.ShowHideClickBlock = "ServantRecommendView_ShowHideClickBlock"

function ServantRecommendView:project_ShowHideClickBlock(isShow)
  if self.project_clickBlocker and not Slua.IsNull(self.project_clickBlocker) then
    self.project_clickBlocker:SetActive(isShow)
  end
end
