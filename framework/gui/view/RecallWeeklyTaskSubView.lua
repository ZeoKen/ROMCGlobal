RecallWeeklyTaskSubView = class("RecallWeeklyTaskSubView", SubMediatorView)
autoImport("RecallWeeklyTaskCell")
local viewPath = ResourcePathHelper.UIView("RecallWeeklyTaskSubView")

function RecallWeeklyTaskSubView:Init()
  if self.inited then
    return
  end
  self:LoadSubView()
  self:AddMapEvts()
  self.gameObject = self:FindGO("RecallWeeklyTaskSubView")
  self.taskCells = {}
  self.inited = true
end

function RecallWeeklyTaskSubView:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container, true)
  obj.name = "RecallWeeklyTaskSubView"
end

function RecallWeeklyTaskSubView:FindObjs()
  self.titleLabel = self:FindGO("Title", self.gameObject):GetComponent(UILabel)
  self.helpBtn = self:FindGO("HelpBtn", self.gameObject)
  self.helpBtn:SetActive(true)
  self.timeLabel = self:FindGO("LeftTimeLabel", self.gameObject):GetComponent(UILabel)
  self.batchLabel = self:FindGO("BatchLabel", self.gameObject):GetComponent(UILabel)
  self.taskScrollView = self:FindGO("ScrollView", self.gameObject):GetComponent(UIScrollView)
  self.taskGrid = self:FindGO("Grid", self.gameObject):GetComponent(UIGrid)
  if not self.taskListCtrl then
    self.taskListCtrl = UIGridListCtrl.new(self.taskGrid, RecallWeeklyTaskCell, "RecallWeeklyTaskCell")
    self.taskListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleTaskCellClick, self)
  end
end

function RecallWeeklyTaskSubView:AddViewEvts()
  if self.helpBtn then
    self:AddClickEvent(self.helpBtn, function()
      self:HandleClickHelpBtn()
    end)
  end
end

function RecallWeeklyTaskSubView:AddMapEvts()
  self:AddDispatcherEvt(ServiceEvent.RecallCCmdWeeklyTaskQueryInfoRecallCmd, self.OnTaskDataUpdate)
  self:AddDispatcherEvt(ServiceEvent.RecallCCmdWeeklyTaskGetRewardRecallCmd, self.OnTaskDataUpdate)
end

function RecallWeeklyTaskSubView:InitDatas()
  if not self.activityIndex then
    redlog("RecallWeeklyTaskSubView: activityIndex not set")
    return
  end
  if not RecallWeeklyTaskProxy.Instance then
    redlog("RecallWeeklyTaskProxy未初始化")
    return
  end
  self.serverTaskData = RecallWeeklyTaskProxy.Instance:GetTaskData()
  if not self.serverTaskData then
    self.serverTaskData = {
      index = self.activityIndex,
      start_time = 0,
      tasks = {}
    }
    RecallWeeklyTaskProxy.Instance:RequestTaskData()
  end
  xdlog("周常任务数据初始化完成, 配置期数:", self.activityIndex)
  self:FindObjs()
  self:AddViewEvts()
end

function RecallWeeklyTaskSubView:RefreshPage()
  if not self.taskListCtrl then
    return
  end
  local taskDataList = {}
  if RecallWeeklyTaskProxy.Instance then
    taskDataList = RecallWeeklyTaskProxy.Instance:GetTaskDataListByIndex(self.activityIndex)
  end
  if self.activityIndex == 0 then
    self.titleLabel.text = ZhString.RecallIntegration_WeeklyTask_2Times
  else
    self.titleLabel.text = ZhString.RecallIntegration_WeeklyTask_4Times
  end
  self.taskListCtrl:RemoveAll()
  self.taskListCtrl:ResetDatas(taskDataList)
  if self.batchLabel and self.serverTaskData then
    local currentBatch = self.serverTaskData.index + 1 or 1
    local totalBatch = RecallInfoProxy.Instance:GetTotalBatchCount() or 1
    self.batchLabel.text = string.format(ZhString.RecallIntegration_BatchNumber or "第%d/%d期", currentBatch, totalBatch)
  end
  self:UpdateTimeDisplay()
end

function RecallWeeklyTaskSubView:UpdateTimeDisplay()
  if not self.timeLabel or not self.serverTaskData then
    return
  end
  local endTime = self.serverTaskData.end_time
  if endTime then
    local currentTime = ServerTime.CurServerTime() / 1000
    local leftTime = endTime - currentTime
    if 0 < leftTime then
      local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(leftTime)
      local timeText
      if 0 < day then
        timeText = string.format(ZhString.PlayerTip_ExpireTime, day)
        self.timeLabel.text = timeText .. ZhString.PlayerTip_Day
      else
        timeText = string.format("%02d:%02d:%02d", hour, min, sec)
        self.timeLabel.text = string.format(ZhString.PlayerTip_ExpireTime, timeText)
      end
    else
      self:StopUpdateTimer()
      self.timeLabel.text = ZhString.Activity_End
    end
  else
    self.timeLabel.text = ""
  end
end

function RecallWeeklyTaskSubView:HandleClickHelpBtn()
  if Table_Help[500005] then
    local helpConfig = Table_Help[500005]
    self:OpenHelpView(helpConfig)
  end
end

function RecallWeeklyTaskSubView:HandleTaskCellClick(cellCtrl)
  if not cellCtrl or not cellCtrl.data then
    return
  end
  local taskData = cellCtrl.data
  local taskStatus = taskData.status
  if taskStatus == 2 then
    self:GetTaskReward(taskData)
  else
    self:ShowTaskRewardPreview(taskData, cellCtrl.gameObject)
  end
end

function RecallWeeklyTaskSubView:GetTaskStatus(taskId)
  if RecallWeeklyTaskProxy.Instance then
    return RecallWeeklyTaskProxy.Instance:GetTaskStatus(taskId)
  end
  return 1
end

function RecallWeeklyTaskSubView:GetTaskReward(taskData)
  if not taskData or not taskData.id then
    return
  end
  xdlog("领取周常任务奖励:", taskData.id)
  if RecallWeeklyTaskProxy.Instance then
    RecallWeeklyTaskProxy.Instance:RequestTaskReward(taskData.id)
  else
    redlog("RecallWeeklyTaskProxy未初始化")
  end
end

function RecallWeeklyTaskSubView:ShowTaskRewardPreview(taskData, anchorObject)
  if not (taskData and taskData.staticData) or not taskData.staticData.Reward then
    return
  end
  local rewardId = taskData.staticData.Reward
  local rewardList = ItemUtil.GetRewardItemIdsByTeamId(rewardId)
  if rewardList and 0 < #rewardList then
    local firstReward = rewardList[1]
    if firstReward.id then
      local funcData = {}
      funcData.itemdata = ItemData.new("ItemData", firstReward.id)
      funcData.itemdata:SetItemNum(firstReward.num or 1)
      self:ShowItemTip(funcData, anchorObject, NGUIUtil.AnchorSide.Right, {200, 0})
    end
  end
end

function RecallWeeklyTaskSubView:OnTaskDataUpdate(data)
  if RecallWeeklyTaskProxy.Instance then
    self.serverTaskData = RecallWeeklyTaskProxy.Instance:GetTaskData()
  end
  self:InitActivityIndex()
  self:RefreshPage()
end

function RecallWeeklyTaskSubView:OnTaskRewardGet(data)
  xdlog("周常任务奖励领取成功", data)
end

function RecallWeeklyTaskSubView:StartUpdateTimer()
  self:StopUpdateTimer()
  TimeTickManager.Me():CreateTick(0, 1000, function()
    self:UpdateTimeDisplay()
  end, self, "TimeUpdate")
end

function RecallWeeklyTaskSubView:StopUpdateTimer()
  TimeTickManager.Me():ClearTick(self, "TimeUpdate")
end

function RecallWeeklyTaskSubView:OnEnter()
  if RecallWeeklyTaskProxy.Instance and RecallWeeklyTaskProxy.Instance:HasServerData() then
    local serverData = RecallWeeklyTaskProxy.Instance:GetTaskData()
    if serverData then
      self.activityIndex = serverData.index
    else
      redlog("RecallWeeklyTaskSubView:OnEnter 服务器数据为空")
      return
    end
  else
    redlog("RecallWeeklyTaskSubView:OnEnter 没有服务器数据")
    return
  end
  self:InitDatas()
  RecallWeeklyTaskSubView.super.OnEnter(self)
end

function RecallWeeklyTaskSubView:InitActivityIndex()
  if RecallWeeklyTaskProxy.Instance and RecallWeeklyTaskProxy.Instance:HasServerData() then
    local serverData = RecallWeeklyTaskProxy.Instance:GetTaskData()
    self.activityIndex = serverData and serverData.index or 1
  end
end

function RecallWeeklyTaskSubView:OnShow()
  self:RefreshPage()
  self:StartUpdateTimer()
end

function RecallWeeklyTaskSubView:OnHide()
  self:StopUpdateTimer()
end

function RecallWeeklyTaskSubView:OnExit()
  self:StopUpdateTimer()
  if self.taskListCtrl then
    self.taskListCtrl:RemoveAll()
    self.taskListCtrl = nil
  end
  if self.taskCells then
    for _, cell in pairs(self.taskCells) do
      if cell and cell.OnDestroy then
        cell:OnDestroy()
      end
    end
    TableUtility.ArrayClear(self.taskCells)
  end
  self.eventsRegistered = false
  RecallWeeklyTaskSubView.super.OnExit(self)
end
