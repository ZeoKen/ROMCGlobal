autoImport("NoviceTarget2023LevelCell")
autoImport("WrapCellHelper")
autoImport("NoviceTarget2023Cell")
autoImport("NoviceTarget2023HelpPopupCell")
autoImport("NoviceTarget2023NodeCell")
NoviceTarget2023View = class("NoviceTarget2023View", ContainerView)
NoviceTarget2023View.ViewType = UIViewType.NormalLayer

function NoviceTarget2023View:Init()
  self:FindObjs()
  self:AddUIEvts()
  self:AddViewEvts()
  self.tipData = {}
  self:Project_ShowUI()
end

function NoviceTarget2023View:FindObjs()
  local levelPos = self:FindGO("levelPos")
  self.levelSv = self:FindComponent("ScrollView", UIScrollView, levelPos)
  self.projectSmallList = UIGridListCtrl.new(self:FindComponent("Grid", UITable, levelPos), NoviceTarget2023LevelCell, "NoviceTarget2023LevelCell")
  self.projectSmallList:AddEventListener(MouseEvent.MouseClick, self.On_projectSmallList_clickCell, self)
  local recommendPos = self:FindGO("recommendPos")
  self.scrollView = self:FindComponent("ScrollView", UIScrollView, recommendPos)
  local wrapConfig = {
    wrapObj = self:FindGO("ItemWrap", recommendPos),
    pfbNum = 6,
    cellName = "NoviceTarget2023Cell",
    control = NoviceTarget2023Cell
  }
  self.cellCtl = WrapCellHelper.new(wrapConfig)
  self.helpPanel = self:FindGO("HelpPanel")
  self.helpBtn = self:FindGO("HelpBtn")
  self.empty = self:FindGO("Empty")
  self.emptyLab = self:FindComponent("EmptyLab", UILabel)
  self.emptyLab.text = ""
  self.beforePanel = self:FindGO("BeforePanel")
  self.before_DescLab = self:FindComponent("curDESCLab", UILabel, self.beforePanel)
  self.before_LvLab = self:FindComponent("curLvLab", UILabel, self.beforePanel)
  self.before_progressSlider = self:FindComponent("ProgressSlider", UISlider, self.beforePanel)
  self.before_progressLab = self:FindComponent("ProgressText", UILabel, self.beforePanel)
  self.before_btn = self:FindComponent("Btn", UISprite, self.beforePanel)
  self:RegisterGuideTarget(ClientGuide.TargetType.novicetarget2023view_getbutton2, self.before_btn.gameObject)
  self.before_btnColider = self.before_btn:GetComponent(BoxCollider)
  self.before_btnLab = self:FindComponent("BtnText", UILabel, self.beforePanel)
  self.before_rewardScrollView = self:FindGO("RewardScrollView", self.beforePanel):GetComponent(UIScrollView)
  self.before_rewardGrid = self:FindGO("RewardGrid", self.beforePanel):GetComponent(UIGrid)
  self.before_rewardGridCtrl = UIGridListCtrl.new(self.before_rewardGrid, BagItemCell, "BagItemCell")
  self.before_rewardGridCtrl:AddEventListener(MouseEvent.MouseClick, self.BeforePanel_handleClickReward, self)
  local rewardPanel = self:FindComponent("RewardScrollView", UIPanel, self.beforePanel)
  local upPanel = UIUtil.GetComponentInParents(self.gameObject, UIPanel)
  if upPanel and rewardPanel then
    rewardPanel.depth = upPanel.depth + 2
  end
  self.bgTex = self:FindComponent("bgTexture", UITexture)
  self.bgTexName = "bg_view_1"
  if self.bgTex then
    PictureManager.Instance:SetUI(self.bgTexName, self.bgTex)
    PictureManager.ReFitFullScreen(self.bgTex, 1)
  end
  self.helpBgTexture = self:FindGO("HelpBgTexture", self.helpPanel):GetComponent(UITexture)
  PictureManager.Instance:SetUI("calendar_bg1_picture2", self.helpBgTexture)
  self.nodeGrid = self:FindGO("NodeGrid", self.beforePanel):GetComponent(UIGrid)
  self.nodeCtrl = UIGridListCtrl.new(self.nodeGrid, NoviceTarget2023NodeCell, "NoviceTarget2023NodeCell")
  self.nodeCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickNodeCell, self)
end

function NoviceTarget2023View:OnExit()
  if self.bgTex then
    PictureManager.Instance:UnLoadUI(self.bgTexName, self.bgTex)
  end
  PictureManager.Instance:UnLoadUI("calendar_bg1_picture2", self.helpBgTexture)
  self:UnRegisterGuideTarget(ClientGuide.TargetType.novicetarget2023view_getbutton2)
end

function NoviceTarget2023View:AddUIEvts()
  self:AddClickEvent(self.helpBtn, function()
    if not self.helpPanelCell then
      self.helpPanelCell = NoviceTarget2023HelpPopupCell.new(self.helpPanel)
    end
    self.helpPanelCell:Show()
    self.helpPanelCell:ShowUI(1)
  end)
  self:AddButtonEvent("CloseButton", function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.before_btn.gameObject, function(obj)
    self:BeforePanel_OnClickBtn()
  end)
end

function NoviceTarget2023View:AddViewEvts()
  self:AddListenEvt(ServiceEvent.NUserRecommendServantUserCmd, self.RecvRecommendServant)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.HandleVarUpdate)
  self:AddListenEvt(ServiceEvent.QuestQuestUpdate, self.RecvRecommendServant)
  self:AddListenEvt(ServiceEvent.QuestQuestStepUpdate, self.HandleRecvQuestStepUpdate)
  self:AddListenEvt(ServiceEvent.NUserNoviceTargetUpdateUserCmd, self.HandleNoviceTargetUpdate)
  self:AddListenEvt(ServiceEvent.NUserNoviceTargetRewardUserCmd, self.HandleNoviceTargetUpdate)
  self:AddListenEvt(MyselfEvent.MyDataChange, function()
    self:Project_ShowUI()
  end)
  self:AddListenEvt(UICellEvent.OnCellClicked, self.HandleShowItemTip)
end

function NoviceTarget2023View:BeforePanel_RefreshView()
  local currentLevelPoint = NoviceTarget2023Proxy.Instance:GetTargetCompleteCountOfDay(self.project_curSmallIndex, true)
  self.before_rewardGridCtrl:RemoveAll()
  self.before_rewardGridCtrl:ResetDatas(rewardList, nil, true)
  self.before_rewardGridCtrl:ResetPosition()
  local lv_text = NoviceTarget2023Proxy.Instance:GetDayNames(self.project_curSmallIndex)
  local dayTimes = NoviceTarget2023Proxy.Instance:GetLevelTimesByDay(self.project_curSmallIndex) or {}
  self.before_LvLab.text = currentLevelPoint .. "/" .. dayTimes[#dayTimes]
  local dayCompletedCount = NoviceTarget2023Proxy.Instance:GetTargetCompleteCountOfDay(self.project_curSmallIndex, true)
  local curSliderValue = 0
  for i = 1, #dayTimes do
    if dayCompletedCount >= dayTimes[i] then
      curSliderValue = curSliderValue + 1 / #dayTimes
    else
      local lastTimePoint = dayTimes[i - 1] or 0
      curSliderValue = curSliderValue + (dayCompletedCount - lastTimePoint) / (dayTimes[i] - lastTimePoint) / #dayTimes
      break
    end
  end
  self.before_progressSlider.value = curSliderValue
  local nodeList = {}
  self.nodeGrid.cellWidth = 1112 / #dayTimes
  self.nodeCtrl:SetEmptyDatas(#dayTimes + 1)
  self.nodeGrid:Reposition()
  local nodeCells = self.nodeCtrl:GetCells()
  for i = 1, #nodeCells do
    if i == 1 then
      nodeCells[i].gameObject:SetActive(false)
    else
      local time = dayTimes and dayTimes[i - 1]
      local _rewarded, _curReward = NoviceTarget2023Proxy.Instance:GetLevelPointStatusByDay(self.project_curSmallIndex, time)
      local tempData = {
        rewarded = _rewarded,
        curReward = _curReward,
        process = time,
        canRecv = currentLevelPoint >= time and not _rewarded or false
      }
      nodeCells[i]:SetData(tempData)
    end
  end
  self.before_btn.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 0.8)
end

function NoviceTarget2023View:BeforePanel_OnClickBtn()
  ServiceNUserProxy.Instance:CallNoviceTargetRewardUserCmd(nil, self.project_curSmallIndex)
end

function NoviceTarget2023View:BeforePanel_handleClickReward(cellCtrl)
  if cellCtrl and cellCtrl.data then
    local item_data = cellCtrl.data
    local tipData = {}
    tipData.itemdata = item_data
    tipData.funcConfig = FunctionItemFunc.CheckBeVIP(item_data) == ItemFuncState.Active and _TipFunc or _EmptyTable
    self:ShowItemTip(tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Left, {-230, 0})
  end
end

function NoviceTarget2023View:handleClickNodeCell(cellCtrl)
  local data = cellCtrl and cellCtrl.data
  if data.canRecv then
    local process = data.process
    xdlog("领奖", process, self.project_curSmallIndex)
    ServiceNUserProxy.Instance:CallNoviceTargetRewardUserCmd(nil, self.project_curSmallIndex, process)
  else
    local itemData = cellCtrl.itemCell and cellCtrl.itemCell.data
    local tipData = {}
    tipData.itemdata = itemData
    tipData.funcConfig = FunctionItemFunc.CheckBeVIP(item_data) == ItemFuncState.Active and _TipFunc or _EmptyTable
    self:ShowItemTip(tipData, cellCtrl.widget, NGUIUtil.AnchorSide.Left, {-200, 0})
  end
end

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
NoviceTarget2023View._ColorEffectBlue = Color(0.25882352941176473, 0.4823529411764706, 0.7568627450980392, 1)
NoviceTarget2023View._ColorEffectOrange = Color(0.7686274509803922, 0.5254901960784314, 0, 1)
NoviceTarget2023View._ColorTitleGray = Color(0.39215686274509803, 0.40784313725490196, 0.4627450980392157, 1)
local ColorEffectOrange = ColorUtil.ButtonLabelOrange
local ColorEffectBlue = ColorUtil.ButtonLabelBlue
local KJMC_QUEST_ID = 305000001
local KJMC_GUIDE_QUEST_ID = 99090033

function NoviceTarget2023View:HandleVarUpdate()
  self:RecvRecommendServant()
end

function NoviceTarget2023View:HandleRecvQuestStepUpdate(note)
  local questId = note.body.id
  if questId == KJMC_QUEST_ID or questId == KJMC_GUIDE_QUEST_ID then
    self:RecvRecommendServant()
  end
end

function NoviceTarget2023View:RecvRecommendServant(note)
  self:Project_ShowUI()
end

function NoviceTarget2023View:HandleNoviceTargetUpdate(note)
  xdlog(NoviceTarget2023Proxy.Instance:IsDayHas_REWARDED_NOT_GET(self.project_curSmallIndex), NoviceTarget2023Proxy.Instance:GetProcessRewardAllGet(self.project_curSmallIndex))
  if not NoviceTarget2023Proxy.Instance:IsDayHas_REWARDED_NOT_GET(self.project_curSmallIndex) and NoviceTarget2023Proxy.Instance:GetProcessRewardAllGet(self.project_curSmallIndex) then
    xdlog("刷新页签")
    self.firstInit = false
  end
  self:Project_ShowUI()
end

local cellheight = 45

function NoviceTarget2023View:RefreshProjectSmallList()
  local list = NoviceTarget2023Proxy.Instance:GetProjectSmallList()
  self.projectSmallList:ResetDatas(list)
  local cells = self.projectSmallList:GetCells()
end

function NoviceTarget2023View:On_projectSmallList_clickCell(cell)
  if cell.data.s_lock then
    MsgManager.ShowMsgByID(43455, cell.data.level)
    return
  end
  self:Project_SwitchDay(cell.id, nil, true)
end

local maxShowLevelCell = 9

function NoviceTarget2023View:Project_SwitchDay(day, dont_Project_UpdateList, dont_resetleveltab)
  self:RefreshProjectSmallList()
  local cells = self.projectSmallList:GetCells()
  local dayValid = false
  for i = #cells, 1, -1 do
    if cells[i].id == day then
      dayValid = true
      break
    end
  end
  if not dayValid then
    day = cells and cells[#cells].id
  end
  local needRepos = self.project_curSmallIndex ~= day
  if self.project_curSmallIndex ~= day then
    self.project_curSmallIndex = day
    for i = 1, #cells do
      cells[i]:SetSelected(false)
    end
  end
  if 0 < day then
    for i = 1, #cells do
      if cells[i].id == day then
        cells[i]:SetSelected(true)
      end
    end
  end
  local cellsCount = #cells
  local halfShowLevelCell = math.floor(maxShowLevelCell / 2)
  if not dont_resetleveltab then
    self.levelSv:ResetPosition()
  end
  if cellsCount < maxShowLevelCell then
  elseif not dont_resetleveltab then
    local selectCell = cells[day]
    local panel = self.levelSv.panel
    if day <= halfShowLevelCell then
      selectCell = cells[1]
    elseif day >= cellsCount - halfShowLevelCell then
      selectCell = cells[cellsCount]
    else
      selectCell = nil
    end
    if selectCell ~= nil then
      local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, selectCell.gameObject.transform)
      local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
      offset = LuaGeometry.GetTempVector3(offset.x, 0, 0)
      self.levelSv:MoveRelative(offset)
    else
      local cw = math.min(day, cellsCount - day) - 1
      local l_cell = cells[day - cw]
      local r_cell = cells[day + cw]
      local l_bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, l_cell.gameObject.transform)
      local l_offset = panel:CalculateConstrainOffset(l_bound.min, l_bound.max)
      local r_bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, r_cell.gameObject.transform)
      local r_offset = panel:CalculateConstrainOffset(r_bound.min, r_bound.max)
      local offset = LuaGeometry.GetTempVector3((l_offset.x + r_offset.x) / 2, 0, 0)
      self.levelSv:MoveRelative(offset)
    end
  end
  FunctionPlayerPrefs.Me():SetInt("NoviceTarget2023_PageProject", self.project_curSmallIndex)
  self:BeforePanel_RefreshView()
  if dont_Project_UpdateList ~= true then
    self:Project_UpdateList(needRepos)
  end
end

function NoviceTarget2023View:Project_UpdateInfo()
  return
end

function NoviceTarget2023View:Project_ShowUI()
  local pid
  local unlockedDay = NoviceTarget2023Proxy.Instance.unlockedDay
  local today = 1
  if unlockedDay and 0 < #unlockedDay then
    today = unlockedDay[#unlockedDay]
  end
  if not self.firstInit then
    self.firstInit = true
    local dayList = NoviceTarget2023Proxy.Instance.dayList or {}
    for i = 1, #dayList do
      if NoviceTarget2023Proxy.Instance:IsDayHas_REWARDED_NOT_GET(dayList[i]) or not NoviceTarget2023Proxy.Instance:GetProcessRewardAllGet(dayList[i]) then
        pid = dayList[i]
        break
      end
    end
  end
  pid = pid or math.min(today, math.max(FunctionPlayerPrefs.Me():GetInt("NoviceTarget2023_PageProject", 1), 1))
  self:Project_SwitchDay(pid)
  self:Project_UpdateInfo()
  self.emptyLab.text = ZhString.Servant_Recommend_PageProject_Empty
end

function NoviceTarget2023View:Project_UpdateList(needRepos)
  if self.project_curSmallIndex == nil then
    self.empty:SetActive(true)
    self.cellCtl:ResetDatas({})
    return
  end
  if self.scrollView.panel then
    if self.beforePanel and self.beforePanel.activeSelf then
      self.scrollView.panel.baseClipRegion = LuaGeometry.GetTempVector4(0, 13.4, 1200, 422.6)
    else
      self.scrollView.panel.baseClipRegion = LuaGeometry.GetTempVector4(0, -34, 1200, 524)
    end
  end
  local resultList = NoviceTarget2023Proxy.Instance:GetProjectList(self.project_curSmallIndex, true)
  local sign21Ins = NoviceTarget2023Proxy.Instance
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
    self.cellCtl:ResetPosition()
  end
  ServantRecommendProxy.Instance:UpdateWholeRedTip()
end

function NoviceTarget2023View:Project_GetReward()
  if NoviceTarget2023Proxy.Instance:IsAllLevelRewardGet() then
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

function NoviceTarget2023View:HandleShowItemTip(note)
  local data = note.body
  local itemid = data.itemid
  if itemid then
    self.tipData.itemdata = ItemData.new("Reward", itemid)
    self:ShowItemTip(self.tipData, self.itemContainer, NGUIUtil.AnchorSide.Center, {0, 0})
  end
end

NoviceTarget2023View.ShowHideClickBlock = "ServantRecommendView_ShowHideClickBlock"

function NoviceTarget2023View:project_ShowHideClickBlock(isShow)
  if self.project_clickBlocker and not Slua.IsNull(self.project_clickBlocker) then
    self.project_clickBlocker:SetActive(isShow)
  end
end
