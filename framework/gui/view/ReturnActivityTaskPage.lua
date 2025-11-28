ReturnActivityTaskPage = class("ReturnActivityTaskPage", SubView)
ReturnActivityTaskPage.ViewType = UIViewType.NormalLayer
autoImport("ReturnActivityDailyRewardCell")
autoImport("ReturnActivityTaskCell")
local viewPath = ResourcePathHelper.UIView("ReturnActivityTaskPage")
local textureDecoratePath = "Sevenroyalfamilies_bg_decoration"
local effectPath = "ufx_returnactivity_prf"
local tempScale = LuaVector3.One()
local decorateTextureNameMap = {
  DecorateBoli4BG = "returnactivity_bg_08",
  DecorateBoli4 = "returnactivity_bg_boli_04",
  DecorateBoli2 = "returnactivity_bg_boli_02"
}
local picIns = PictureManager.Instance

function ReturnActivityTaskPage:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:InitDatas()
end

function ReturnActivityTaskPage:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container.taskPageObj, true)
  obj.name = "ReturnActivityTaskPage"
end

function ReturnActivityTaskPage:FindObjs()
  self:LoadSubView()
  self.gameObject = self:FindGO("ReturnActivityTaskPage")
  self.loginInfosPart = self:FindGO("LoginInfos")
  self.showDetailBtn = self:FindGO("ShowDetailBtn", self.loginInfosPart)
  RedTipProxy.Instance:RegisterUI(SceneTip_pb.EREDSYS_USERRETURN_LOGIN_AWARD, self.showDetailBtn, 50, {-5, -5})
  self.loginDaysLabel = self:FindGO("LoginDaysLabel", self.loginInfosPart):GetComponent(UILabel)
  self.tipContainer = self:FindGO("TipContainer", self.loginInfosPart)
  self.tipContainer_TweenAlpha = self.tipContainer:GetComponent(TweenAlpha)
  self.tipLabel = self:FindGO("TipLabel", self.tipContainer):GetComponent(UILabel)
  self.buffGrid = self:FindGO("BuffGrid")
  self.buffCell = {}
  for i = 1, 3 do
    self.buffCell[i] = self:FindGO("BuffCell" .. i, self.buffGrid)
  end
  self.effectContainer = self:FindGO("EffectContainer", self.loginInfosPart)
  self.boliBtn = self:FindGO("DecorateBoli4")
  self.loginRewardsPart = self:FindGO("LoginRewards")
  self.closeDetailBtn = self:FindGO("CloseDetailBtn", self.loginRewardsPart)
  self.rewardScrollView = self:FindGO("RewardScrollView", self.loginRewardsPart):GetComponent(UIScrollView)
  self.rewardGrid = self:FindGO("RewardGrid", self.loginRewardsPart):GetComponent(UIGrid)
  self.rewardGridCtrl = UIGridListCtrl.new(self.rewardGrid, ReturnActivityDailyRewardCell, "ReturnActivityDailyRewardCell")
  self.rewardGridCtrl:AddEventListener(ReturnActivityEvent.ClickDailyReward, self.HandleClickDailyReward, self)
  self.rewardGridCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleSignIn, self)
  self.rewardBG1 = self:FindGO("RewardBG1"):GetComponent(UISprite)
  self.rewardBG2 = self:FindGO("RewardBG2"):GetComponent(UISprite)
  self.taskInfos = self:FindGO("TaskInfos")
  self.togs = {}
  self.togsRedTips = {}
  for i = 1, 3 do
    self.togs[i] = self:FindGO("Tog" .. i, self.taskInfos):GetComponent(UIToggle)
    self.togsRedTips[i] = self:FindGO("RedTipCell", self.togs[i].gameObject)
  end
  self.taskScrollView = self:FindGO("TaskScrollView", self.gameObject):GetComponent(UIScrollView)
  self.taskPanel = self:FindGO("TaskScrollView", self.gameObject):GetComponent(UIPanel)
  self.taskGrid = self:FindGO("TaskGrid", self.gameObject):GetComponent(UIGrid)
  self.taskGridCtrl = UIGridListCtrl.new(self.taskGrid, ReturnActivityTaskCell, "ReturnActivityTaskCell")
  self.taskGridCtrl:AddEventListener(ReturnActivityEvent.ClickGoBtn, self.ClickGoTo, self)
  self.taskGridCtrl:AddEventListener(ReturnActivityEvent.ClickTaskReward, self.HandleClickTaskReward, self)
  self.refreshTip = self:FindGO("RefreshTip")
  self.refreshTipLabel = self:FindGO("RefreshTipLabel"):GetComponent(UILabel)
  for objName, _ in pairs(decorateTextureNameMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  self.loginInfosPart:SetActive(false)
  self.loginRewardsPart:SetActive(true)
  self.closeDetailBtn:SetActive(false)
  self.costGO = self:FindGO("Cost", self.gameObject)
  self.costLabel = self:FindGO("CostLabel", self.costGO):GetComponent(UILabel)
  self.costIcon = self:FindGO("CostIcon", self.costGO):GetComponent(UISprite)
  self.taskBg = self:FindGO("TaskBg", self.gameObject):GetComponent(UISprite)
end

function ReturnActivityTaskPage:AddEvts()
  for i = 1, 3 do
    EventDelegate.Add(self.togs[i].onChange, function()
      if self.togs[i].value then
        self.taskTogIndex = i
        self:HandleClickTypeTog(i)
      end
    end)
  end
  for i = 1, 3 do
    self:AddClickEvent(self.buffCell[i], function()
      local config = self.gameConfig.Feature[self.curActivityID]
      local text = config and config["BuffDesc_" .. i] or ""
      self.tipLabel.text = text
      self.tipContainer_TweenAlpha:ResetToBeginning()
      self.tipContainer_TweenAlpha:PlayForward()
    end)
  end
  self:AddClickEvent(self.showDetailBtn, function()
    self.loginInfosPart:SetActive(false)
    self.loginRewardsPart:SetActive(true)
    TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
      self:AdjustScrollView()
    end, self, 9)
  end)
  self:AddClickEvent(self.closeDetailBtn, function()
    self.loginInfosPart:SetActive(true)
    self.loginRewardsPart:SetActive(false)
  end)
  self:AddClickEvent(self.boliBtn, function()
    ReturnActivityProxy.Instance:TryGetLoginReward()
  end)
end

function ReturnActivityTaskPage:AddMapEvts()
  self:AddListenEvt(ServiceEvent.ActivityCmdUserReturnInfoCmd, self.InitShow)
  self:AddListenEvt(ServiceEvent.ActivityCmdUserReturnQuestAddCmd, self.HandleRefreshTaskList)
  self:AddListenEvt(ServiceEvent.ActivityCmdUserReturnLoginAwardCmd, self.HandleRefreshLoginReward)
  self:AddListenEvt(ServiceEvent.ActivityCmdUserReturnQuestAwardCmd, self.HandleRefreshTaskList)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateMoney)
end

function ReturnActivityTaskPage:InitDatas()
  self.curActivityID = ReturnActivityProxy.Instance.curActID
  self.gameConfig = GameConfig.Return
  self.staticRewards = {}
  self:InitLoginReward()
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.config = self.curActivityID and GameConfig.Return.Feature[self.curActivityID]
  self.costID = self.config and self.config.ShopItemID
  local itemData = Table_Item[self.costID]
  IconManager:SetItemIcon(itemData.Icon, self.costIcon)
end

function ReturnActivityTaskPage:InitShow()
  self.loginDay = ReturnActivityProxy.Instance.loginDay or 1
  self.awardDays = ReturnActivityProxy.Instance:GetReturnLoginInfo()
  self.quests = ReturnActivityProxy.Instance:GetReturnTaskInfo()
  self.endTime = ReturnActivityProxy.Instance.activityEndTime
  self.loginDaysLabel.text = string.format(ZhString.ReturnActivityPanel_LoginDays, self.loginDay)
  self:RefreshLoginRewards()
  self:RefreshReturnTasks(self.taskTogIndex)
  self:RefreshRedTips()
  self:UpdateMoney()
end

function ReturnActivityTaskPage:UpdateMoney()
  local own = BagProxy.Instance:GetItemNumByStaticID(self.costID) or 0
  self.costLabel.text = StringUtil.NumThousandFormat(own)
end

function ReturnActivityTaskPage:InitTaskList()
  if Table_Mission then
    local taskList = {}
    for k, v in pairs(Table_Mission) do
      if not taskList[v.Tab] then
        taskList[v.Tab] = {}
      end
      table.insert(taskList[v.Tab], k)
    end
    self.staticTaskList = taskList
  end
end

function ReturnActivityTaskPage:InitLoginReward()
  if not self.curActivityID or not self.gameConfig.Feature[self.curActivityID] then
    return false
  end
  local mySex = MyselfProxy.Instance:GetMySex()
  local loginRewards = self.gameConfig.Feature[self.curActivityID].SigninReward
  for i = 1, #loginRewards do
    local rewardInfo = loginRewards[i]
    local cellInfo = {id = i}
    local rewardList = {}
    local itemList
    if mySex == 2 and rewardInfo.FemaleItem then
      itemList = rewardInfo.FemaleItem
    else
      itemList = rewardInfo.Item
    end
    for j = 1, #itemList do
      local item = itemList[j]
      local data = {}
      data.itemData = ItemData.new("Reward", item[1])
      if data.itemData then
        data.num = item[2]
        table.insert(rewardList, data)
      end
    end
    cellInfo.rewards = rewardList
    if i == #loginRewards then
      cellInfo.hideDotLine = true
    end
    table.insert(self.staticRewards, cellInfo)
  end
  self.rewardGridCtrl:ResetDatas(self.staticRewards)
  self.rewardBG1.height = 4 + 86 * #self.staticRewards
  self.rewardBG2.height = 4 + 86 * #self.staticRewards
end

function ReturnActivityTaskPage:InitRefreshTimeTick(index)
  xdlog("index", index, self.timeTickIndex)
  if not self.timeTickIndex then
    self.timeTickIndex = index
  else
    if self.timeTickIndex == index then
      return
    end
    self.timeTickIndex = index
  end
  if self.timeTickIndex == 1 then
    self.nextRefreshTime = ClientTimeUtil.GetNextDailyRefreshTime()
    if self.nextRefreshTime >= self.endTime then
      self.nextRefreshTime = self.endTime
    end
    TimeTickManager.Me():ClearTick(self)
    TimeTickManager.Me():CreateTick(0, 1000, self.RefreshDailyLeftTime, self, 2)
  elseif self.timeTickIndex == 2 then
    self.nextRefreshTime = ClientTimeUtil.GetWeeklyRefreshTime()
    if self.nextRefreshTime >= self.endTime then
      self.nextRefreshTime = self.endTime
    end
    TimeTickManager.Me():ClearTick(self)
    TimeTickManager.Me():CreateTick(0, 1000, self.RefreshWeeklyLeftTime, self, 3)
  end
end

function ReturnActivityTaskPage:RefreshLoginRewards()
  if not self.awardDays then
    redlog("没有登录信息")
    return
  end
  local cells = self.rewardGridCtrl:GetCells()
  local rewardApplyValid = false
  for i = 1, #cells do
    if i <= self.loginDay then
      local isAward = TableUtility.ArrayFindIndex(self.awardDays, cells[i].id) > 0
      if isAward then
        cells[i]:SetStatus(isAward, 1)
      else
        cells[i]:SetStatus(isAward, 2)
      end
    else
      cells[i]:SetStatus(false, 3)
    end
  end
end

function ReturnActivityTaskPage:RefreshReturnTasks(index)
  if not self.quests then
    redlog("没有任务信息")
    return
  end
  self.refreshTip:SetActive(index == 1 or index == 2)
  if index == 1 or index == 2 then
    self.refreshTip:SetActive(true)
    self:ResizeTaskScrollView(1)
  else
    self.refreshTip:SetActive(false)
    self:ResizeTaskScrollView(2)
  end
  local taskList = {}
  for k, v in pairs(self.quests) do
    if v.type == index then
      table.insert(taskList, v)
    end
  end
  table.sort(taskList, function(l, r)
    if l.awarded == r.awarded then
      if l.finish == r.finish then
        return l.id < r.id
      else
        return l.finish == true
      end
    else
      return l.awarded == false
    end
  end)
  self.taskGridCtrl:ResetDatas(taskList)
  self.taskScrollView:ResetPosition()
  self:InitRefreshTimeTick(index)
end

function ReturnActivityTaskPage:RefreshRedTips()
  if not self.quests then
    return
  end
  for i = 1, 3 do
    local showRedTip = false
    for k, v in pairs(self.quests) do
      if v.type == i and v.finish == true and not v.awarded then
        showRedTip = true
        break
      end
    end
    self.togsRedTips[i]:SetActive(showRedTip)
  end
end

function ReturnActivityTaskPage:RefreshDailyLeftTime()
  local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(self.nextRefreshTime)
  local strFormat
  if self.nextRefreshTime == self.endTime then
    strFormat = ZhString.ReturnActivityPanel_DailyTaskEnd
  else
    strFormat = ZhString.ReturnActivityPanel_DailyTaskRefresh
  end
  self.refreshTipLabel.text = string.format(strFormat, leftHour, leftMin)
  if leftHour <= 0 and leftMin <= 0 and leftSec <= 0 then
    TimeTickManager.Me():ClearTick(self)
    self.taskGridCtrl:RemoveAll()
    ServiceActivityCmdProxy.Instance:CallUserReturnInfoCmd()
    self.nextRefreshTime = ClientTimeUtil.GetNextDailyRefreshTime()
  end
end

function ReturnActivityTaskPage:RefreshWeeklyLeftTime()
  local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(self.nextRefreshTime)
  local strFormat
  if self.nextRefreshTime == self.endTime then
    if leftDay <= 0 then
      strFormat = ZhString.ReturnActivityPanel_WeeklyTaskEndHourMin
      self.refreshTipLabel.text = string.format(strFormat, leftHour, leftMin)
    else
      strFormat = ZhString.ReturnActivityPanel_WeeklyTaskEndDayHour
      self.refreshTipLabel.text = string.format(strFormat, leftDay, leftHour)
    end
  elseif leftDay <= 0 then
    strFormat = ZhString.ReturnActivityPanel_WeeklyTaskRefreshHourMin
    self.refreshTipLabel.text = string.format(strFormat, leftHour, leftMin)
  else
    strFormat = ZhString.ReturnActivityPanel_WeeklyTaskRefreshDayHour
    self.refreshTipLabel.text = string.format(strFormat, leftDay, leftHour)
  end
  if leftHour <= 0 and leftMin <= 0 and leftSec <= 0 then
    TimeTickManager.Me():ClearTick(self)
    self.taskGridCtrl:RemoveAll()
    ServiceActivityCmdProxy.Instance:CallUserReturnInfoCmd()
    self.nextRefreshTime = ClientTimeUtil.GetNextDailyRefreshTime()
  end
end

local profSVParam = {
  [1] = {
    offsetY = 0,
    height = 426,
    bgHeight = 432
  },
  [2] = {
    offsetY = -16,
    height = 458,
    bgHeight = 465
  }
}

function ReturnActivityTaskPage:ResizeTaskScrollView(type)
  local param = profSVParam[type]
  if not param then
    return
  end
  local clip = self.taskPanel.baseClipRegion
  local pos = self.taskPanel.gameObject.transform.localPosition
  local targetOffsetY = param.offsetY - pos.y
  self.taskPanel.clipOffset = LuaGeometry.GetTempVector2(self.taskPanel.clipOffset.x, targetOffsetY)
  self.taskPanel.baseClipRegion = LuaGeometry.GetTempVector4(clip.x, clip.y, clip.z, param.height)
  self.taskBg.height = param.bgHeight
end

function ReturnActivityTaskPage:HandleRefreshTaskList()
  self.quests = ReturnActivityProxy.Instance:GetReturnTaskInfo()
  self:RefreshRedTips()
  self:RefreshReturnTasks(self.taskTogIndex)
end

function ReturnActivityTaskPage:HandleRefreshLoginReward()
  xdlog("签到状态刷新")
  self.awardDays = ReturnActivityProxy.Instance:GetReturnLoginInfo()
  self:RefreshLoginRewards()
end

function ReturnActivityTaskPage:HandleClickTypeTog(index)
  self:RefreshReturnTasks(index)
end

function ReturnActivityTaskPage:ClickGoTo(cellCtrl)
  FuncShortCutFunc.Me():CallByID(cellCtrl.config.Goto.id, cellCtrl.config.Goto.Params)
  if self.container then
    self.container:CloseSelf()
  end
end

function ReturnActivityTaskPage:HandleClickDailyReward(cellCtrl)
  if cellCtrl and cellCtrl.data then
    self.tipData.itemdata = cellCtrl.data.itemData
    self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Center, {300, 0})
  end
end

function ReturnActivityTaskPage:HandleClickTaskReward(cellCtrl)
  if cellCtrl and cellCtrl.data then
    self.tipData.itemdata = cellCtrl.data.itemData
    self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Center, {-300, 0})
  end
end

function ReturnActivityTaskPage:HandleSignIn(cellCtrl)
  xdlog("执行签到")
  ReturnActivityProxy.Instance:TryGetLoginReward()
end

function ReturnActivityTaskPage:AdjustScrollView()
  local panel = self.rewardScrollView.panel
  local cells = self.rewardGridCtrl:GetCells()
  local cellCtrl = cells[self.loginDay]
  if not cellCtrl then
    return
  end
  local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, cellCtrl.gameObject.transform)
  local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
  offset = Vector3(0, offset.y, 0)
  self.rewardScrollView:MoveRelative(offset)
end

function ReturnActivityTaskPage:OnEnter()
  ReturnActivityTaskPage.super.OnEnter(self)
  if not self.inited then
    ServiceActivityCmdProxy.Instance:CallUserReturnInfoCmd()
    for objName, texName in pairs(decorateTextureNameMap) do
      picIns:SetReturnActivityTexture(texName, self[objName])
    end
    self.inited = true
  end
end

function ReturnActivityTaskPage:OnExit()
  TimeTickManager.Me():ClearTick(self)
  ReturnActivityTaskPage.super.OnExit(self)
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:UnloadReturnActivityTexture(texName, self[objName])
  end
end
