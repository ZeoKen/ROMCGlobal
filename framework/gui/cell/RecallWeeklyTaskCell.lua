RecallWeeklyTaskCell = class("RecallWeeklyTaskCell", BaseCell)
autoImport("PveDropItemData")
autoImport("PveDropItemCell")

function RecallWeeklyTaskCell:Init()
  self:FindObjs()
  self:AddViewEvts()
end

function RecallWeeklyTaskCell:FindObjs()
  self.taskIcon = self:FindComponent("Icon", UISprite, self.gameObject)
  self.taskNameLabel = self:FindComponent("Title", UILabel, self.gameObject)
  self.taskDescLabel = self:FindComponent("Desc", UILabel, self.gameObject)
  self.countLabel = self:FindComponent("CountLabel", UILabel, self.gameObject)
  local rewardScrollViewGO = self:FindGO("RewardScrollView")
  local rewardGridGO = self:FindGO("RewardGrid")
  self.rewardScrollView = rewardScrollViewGO:GetComponent(UIScrollView)
  self.rewardGrid = rewardGridGO:GetComponent(UIGrid)
  self.rewardGridCtrl = UIGridListCtrl.new(self.rewardGrid, PveDropItemCell, "PveDropItemCell")
  self.rewardGridCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickReward, self)
  local rewardPanel = self:FindComponent("RewardScrollView", UIPanel)
  local upPanel = UIUtil.GetComponentInParents(self.gameObject, UIPanel)
  if upPanel and rewardPanel then
    rewardPanel.depth = upPanel.depth + 1
  end
  self.gotoBtn = self:FindGO("GoToBtn", self.gameObject)
  self.getBtn = self:FindGO("GetBtn", self.gameObject)
  self.finishSymbol = self:FindGO("FinishSymbol", self.gameObject)
end

function RecallWeeklyTaskCell:AddViewEvts()
  if self.getBtn then
    self:AddClickEvent(self.getBtn, function()
      self:OnClickGetReward()
    end)
  end
  if self.gotoBtn then
    self:AddClickEvent(self.gotoBtn, function()
      self:OnClickGoto()
    end)
  end
end

function RecallWeeklyTaskCell:SetData(data)
  self.data = data
  if not data then
    return
  end
  local cfg = data.staticData
  if not cfg then
    redlog("RecallWeeklyTaskCell: 缺少静态配置数据", data.id)
    return
  end
  self.id = data.id
  self.status = data.status
  if self.taskIcon and cfg.Icon then
    local exitIcon = IconManager:SetUIIcon(cfg.Icon, self.taskIcon)
    if not exitIcon then
      exitIcon = IconManager:SetItemIcon(cfg.Icon, self.taskIcon)
      if not exitIcon then
        exitIcon = IconManager:SetFaceIcon(cfg.Icon, self.taskIcon)
        if not exitIcon then
          redlog("RecallWeeklyTaskCell: 未找到图标", cfg.Icon)
        end
      end
    end
    if exitIcon then
      self.taskIcon:MakePixelPerfect()
    end
  end
  if self.taskNameLabel and cfg.Title then
    self.taskNameLabel.text = cfg.Title
  end
  if self.taskDescLabel and cfg.Desc then
    self.taskDescLabel.text = cfg.Desc
  end
  if cfg.Reward then
    self:SetRewardDisplay(cfg.Reward)
  end
  self:UpdateProgress()
  self:UpdateStatus()
end

function RecallWeeklyTaskCell:SetRewardDisplay(rewardId)
  if not rewardId then
    return
  end
  local rewardList = ItemUtil.GetRewardItemIdsByTeamId(rewardId)
  if rewardList and 0 < #rewardList then
    local result = {}
    for i = 1, #rewardList do
      local itemData = PveDropItemData.new("Reward", rewardList[i].id)
      itemData:SetItemNum(rewardList[i].num)
      table.insert(result, itemData)
    end
    if self.rewardGridCtrl then
      self.rewardGridCtrl:RemoveAll()
      self.rewardGridCtrl:ResetDatas(result, nil, true)
      self.rewardScrollView:ResetPosition()
    end
  elseif self.rewardGridCtrl then
    self.rewardGridCtrl:RemoveAll()
  end
end

function RecallWeeklyTaskCell:UpdateProgress()
  if not self.data or not self.data.staticData then
    return
  end
  local cfg = self.data.staticData
  local maxTimes = cfg.CompleteCount or 1
  local completedCount = self:GetTaskProgress()
  if self.countLabel then
    self.countLabel.text = string.format(ZhString.RecallIntegration_WeeklyTask_CountLeft, maxTimes - completedCount)
  end
end

function RecallWeeklyTaskCell:GetTaskProgress()
  if self.data and self.data.complete_count then
    return self.data.complete_count
  end
  return 0
end

function RecallWeeklyTaskCell:IsTaskComplete()
  if self.data and self.data.complete then
    return self.data.complete
  end
  return false
end

function RecallWeeklyTaskCell:IsTaskRewardGeted()
  if self.data and self.data.reward_geted then
    return self.data.reward_geted
  end
  return false
end

function RecallWeeklyTaskCell:UpdateStatus()
  if not self.data or not self.data.staticData then
    return
  end
  local cfg = self.data.staticData
  local completedCount = self:GetTaskProgress()
  local maxTimes = cfg.CompleteCount or 1
  local isComplete = self:IsTaskComplete()
  local isRewardGeted = self:IsTaskRewardGeted()
  local isMaxCompleted = completedCount >= maxTimes
  local isGotoEmpty = not cfg.Goto or cfg.Goto == "" or cfg.Goto == _EmptyTable
  local shouldShowFinishSymbol = false
  if isRewardGeted then
    if self.gotoBtn then
      self.gotoBtn:SetActive(false)
    end
    if self.getBtn then
      self.getBtn:SetActive(false)
    end
    if self.finishSymbol then
      self.finishSymbol:SetActive(true)
      shouldShowFinishSymbol = true
    end
  elseif isComplete then
    if self.gotoBtn then
      self.gotoBtn:SetActive(false)
    end
    if self.getBtn then
      self.getBtn:SetActive(true)
      self:SetGetBtnGray(false)
    end
    if self.finishSymbol then
      self.finishSymbol:SetActive(false)
    end
  elseif isMaxCompleted then
    if self.gotoBtn then
      self.gotoBtn:SetActive(false)
    end
    if self.getBtn then
      self.getBtn:SetActive(false)
    end
    if self.finishSymbol then
      self.finishSymbol:SetActive(true)
      shouldShowFinishSymbol = true
    end
  elseif isGotoEmpty then
    if self.gotoBtn then
      self.gotoBtn:SetActive(false)
    end
    if self.getBtn then
      self.getBtn:SetActive(true)
      self:SetGetBtnGray(true)
    end
    if self.finishSymbol then
      self.finishSymbol:SetActive(false)
    end
  else
    if self.gotoBtn then
      self.gotoBtn:SetActive(true)
    end
    if self.getBtn then
      self.getBtn:SetActive(false)
    end
    if self.finishSymbol then
      self.finishSymbol:SetActive(false)
    end
  end
  if self.countLabel then
    self.countLabel.gameObject:SetActive(not shouldShowFinishSymbol)
  end
end

function RecallWeeklyTaskCell:SetGetBtnGray(isGray)
  if not self.getBtn then
    return
  end
  if isGray then
    self:SetTextureGrey(self.getBtn)
  else
    self:SetTextureWhite(self.getBtn, Color(0.7686274509803922, 0.5254901960784314, 0 / 255, 1))
  end
end

function RecallWeeklyTaskCell:GetTaskStatus()
  if self.data and self.data.status then
    return self.data.status
  end
  return 1
end

function RecallWeeklyTaskCell:OnClickGetReward()
  if not self.data or not self.data.id then
    redlog("RecallWeeklyTaskCell:OnClickGetReward 任务数据无效")
    return
  end
  local taskId = self.data.id
  local isComplete = self:IsTaskComplete()
  local isRewardGeted = self:IsTaskRewardGeted()
  if not isComplete or isRewardGeted then
    redlog("RecallWeeklyTaskCell:OnClickGetReward 任务状态不可领取", taskId, "complete:", isComplete, "reward_geted:", isRewardGeted)
    return
  end
  xdlog("RecallWeeklyTaskCell:OnClickGetReward 请求领取任务奖励", taskId)
  if RecallWeeklyTaskProxy.Instance then
    RecallWeeklyTaskProxy.Instance:RequestTaskReward(taskId)
  else
    redlog("RecallWeeklyTaskProxy未初始化，无法领取奖励")
  end
end

function RecallWeeklyTaskCell:OnClickGoto()
  if not self.data or not self.data.staticData then
    return
  end
  local cfg = self.data.staticData
  local isGotoEmpty = not cfg.Goto or cfg.Goto == "" or cfg.Goto == _EmptyTable
  if isGotoEmpty then
    return
  end
  local gotoList = cfg.Goto
  FuncShortCutFunc.Me():CallByID(gotoList)
end

function RecallWeeklyTaskCell:handleClickReward(cellCtrl)
  if cellCtrl and cellCtrl.data then
    local item_data = cellCtrl.data
    local tipData = {}
    tipData.itemdata = item_data
    self:ShowItemTip(tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Right, {200, 0})
  end
end

function RecallWeeklyTaskCell:OnDestroy()
  if self.rewardGridCtrl then
    self.rewardGridCtrl:RemoveAll()
    self.rewardGridCtrl = nil
  end
  self.data = nil
  RecallWeeklyTaskCell.super.OnDestroy(self)
end
