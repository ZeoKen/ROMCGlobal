RecallWelcomePopup = class("RecallWelcomePopup", ContainerView)
RecallWelcomePopup.ViewType = UIViewType.PopUpLayer
autoImport("RewardGridCell")

function RecallWelcomePopup.CanShow()
  local recallInfoProxy = RecallInfoProxy.Instance
  if recallInfoProxy then
    local batchCount = recallInfoProxy:GetTotalBatchCount()
    if 0 < batchCount then
      local offlineTimeStamp = recallInfoProxy.acc_offline_time
      if offlineTimeStamp and 0 < offlineTimeStamp then
        local prefKey = "RecallWelcome_" .. tostring(offlineTimeStamp)
        local hasShown = FunctionPlayerPrefs.Me():GetBool(prefKey, false, true)
        if hasShown then
          xdlog("RecallWelcomePopup.CanShow 该离线时间戳已弹过窗，跳过显示", offlineTimeStamp)
          return false
        end
        xdlog("RecallWelcomePopup.CanShow 首次为该离线时间戳弹窗", offlineTimeStamp)
        return true
      else
        xdlog("RecallWelcomePopup.CanShow 无有效离线时间戳")
        return false
      end
    end
  end
  return false
end

function RecallWelcomePopup:Init()
  self:InitData()
  self:FindObjs()
  self:AddViewEvts()
  self:AddMapEvts()
  self:InitShow()
end

function RecallWelcomePopup:InitData()
  self.rewardData = {}
  local showReward = GameConfig.UserRecall and GameConfig.UserRecall.ShowReward
  if showReward and 0 < #showReward then
    for i = 1, #showReward do
      local rewardInfo = showReward[i]
      if rewardInfo and 2 <= #rewardInfo then
        local itemId = rewardInfo[1]
        local count = rewardInfo[2]
        local itemData = ItemData.new("RewardPreview", itemId)
        table.insert(self.rewardData, {itemData = itemData, num = count})
      end
    end
  end
end

function RecallWelcomePopup:FindObjs()
  self.titleLabel = self:FindGO("Title", self.gameObject):GetComponent(UILabel)
  self.descLabel = self:FindGO("Text", self.gameObject):GetComponent(UILabel)
  self.confirmBtn = self:FindGO("ConfirmBtn", self.gameObject)
  self.helpBtn = self:FindGO("HelpBtn", self.gameObject)
  self.rewardScrollView = self:FindGO("RewardScrollView", self.gameObject):GetComponent(UIScrollView)
  self.rewardGrid = self:FindGO("Grid", self.gameObject):GetComponent(UIGrid)
  self.rewardListCtrl = UIGridListCtrl.new(self.rewardGrid, RewardGridCell, "RewardGridCellType2")
  self.rewardListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleRewardCellClick, self)
end

function RecallWelcomePopup:AddViewEvts()
  self:AddClickEvent(self.confirmBtn, function()
    self:HandleClickClose()
  end)
  if self.helpBtn then
    self:AddClickEvent(self.helpBtn, function()
      self:HandleClickHelpBtn()
    end)
  end
  if self.confirmBtn then
    self:AddClickEvent(self.confirmBtn, function()
      self:HandleClickConfirm()
    end)
  end
end

function RecallWelcomePopup:AddMapEvts()
end

function RecallWelcomePopup:InitShow()
  if self.titleLabel then
    self.titleLabel.text = ZhString.RecallWelcome_Title
  end
  if self.descLabel then
    local daysAway = 100
    local startTime = RecallInfoProxy.Instance.startTime
    local offlineTimeStamp = RecallInfoProxy.Instance.acc_offline_time
    if offlineTimeStamp and startTime > offlineTimeStamp then
      daysAway = math.floor((startTime - offlineTimeStamp) / 86400)
    end
    self.descLabel.text = string.format(ZhString.RecallWelcome_MainText, daysAway)
  end
  if self.rewardListCtrl and self.rewardData then
    self.rewardListCtrl:ResetDatas(self.rewardData)
    local rewardCount = #self.rewardData
    if rewardCount <= 5 then
      if self.rewardGrid then
        self.rewardGrid.pivot = UIWidget.Pivot.Center
        self.rewardGrid:Reposition()
      end
      if self.rewardScrollView then
        self.rewardScrollView:ResetPosition()
        self.rewardScrollView:SetDragAmount(0.5, 0.5, false)
      end
    else
      if self.rewardGrid then
        self.rewardGrid.pivot = UIWidget.Pivot.Left
        self.rewardGrid:Reposition()
      end
      if self.rewardScrollView then
        self.rewardScrollView:ResetPosition()
      end
    end
  end
end

function RecallWelcomePopup:HandleClickHelpBtn()
  if Table_Help[500002] then
    local helpConfig = Table_Help[500002]
    self:OpenHelpView(helpConfig)
  end
end

function RecallWelcomePopup:HandleClickClose()
  self:CloseSelf()
end

function RecallWelcomePopup:HandleClickConfirm()
  self:CloseSelf()
end

function RecallWelcomePopup:OnEnter()
  RecallWelcomePopup.super.OnEnter(self)
  self:MarkWelcomeShown()
end

function RecallWelcomePopup:OnExit()
  RecallWelcomePopup.super.OnExit(self)
end

function RecallWelcomePopup:MarkWelcomeShown()
  local recallInfoProxy = RecallInfoProxy.Instance
  if recallInfoProxy then
    local offlineTimeStamp = recallInfoProxy.acc_offline_time
    if offlineTimeStamp and 0 < offlineTimeStamp then
      local prefKey = "RecallWelcome_" .. tostring(offlineTimeStamp)
      FunctionPlayerPrefs.Me():SetBool(prefKey, true, true)
      FunctionPlayerPrefs.Me():Save()
      xdlog("RecallWelcomePopup:MarkWelcomeShown 已标记离线时间戳弹窗状态", offlineTimeStamp, prefKey)
    else
      xdlog("RecallWelcomePopup:MarkWelcomeShown 无有效离线时间戳，无法标记")
    end
  end
end

function RecallWelcomePopup.ClearWelcomeRecord(offlineTimeStamp)
  if offlineTimeStamp and 0 < offlineTimeStamp then
    local prefKey = "RecallWelcome_" .. tostring(offlineTimeStamp)
    FunctionPlayerPrefs.Me():DeleteKey(prefKey, true)
    FunctionPlayerPrefs.Me():Save()
    xdlog("RecallWelcomePopup.ClearWelcomeRecord 已清除离线时间戳弹窗记录", offlineTimeStamp, prefKey)
    return true
  end
  return false
end

function RecallWelcomePopup.ClearCurrentWelcomeRecord()
  local recallInfoProxy = RecallInfoProxy.Instance
  if recallInfoProxy then
    local offlineTimeStamp = recallInfoProxy.acc_offline_time
    return RecallWelcomePopup.ClearWelcomeRecord(offlineTimeStamp)
  end
  return false
end

function RecallWelcomePopup:HandleRewardCellClick(cellCtrl)
  if cellCtrl and cellCtrl.data and cellCtrl.data.itemData then
    local funcData = {}
    funcData.itemdata = cellCtrl.data.itemData
    self:ShowItemTip(funcData, cellCtrl.icon, NGUIUtil.AnchorSide.Right, {200, 0})
  end
end
