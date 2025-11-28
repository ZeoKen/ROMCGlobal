DayLoginRewardTip = class("DayLoginRewardTip", CoreView)
autoImport("RewardGridCell")

function DayLoginRewardTip:ctor(go)
  DayLoginRewardTip.super.ctor(self, go)
  self:Init()
end

function DayLoginRewardTip:Init()
  self.titleLabel = self:FindGO("TitleLabel"):GetComponent(UILabel)
  self.todayScrollView = self:FindGO("TodayScrollView"):GetComponent(UIScrollView)
  self.todayGrid = self:FindGO("TodayGrid"):GetComponent(UIGrid)
  self.todayListCtrl = UIGridListCtrl.new(self.todayGrid, RewardGridCell, "RewardGridCell")
  self.todayListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickReward, self)
  self.tomorrowScrollView = self:FindGO("TomorrowScrollView"):GetComponent(UIScrollView)
  self.tomorrowGrid = self:FindGO("TomorrowGrid"):GetComponent(UIGrid)
  self.tomorrowListCtrl = UIGridListCtrl.new(self.tomorrowGrid, RewardGridCell, "RewardGridCell")
  self.tomorrowListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickReward, self)
  self.funcBtn = self:FindGO("FuncBtn")
  self.funcBtn_Label = self:FindGO("FuncLabel"):GetComponent(UILabel)
  self:AddClickEvent(self.funcBtn, function()
    self:CloseSelf()
  end)
  self.closeBtn = self:FindGO("CloseButton")
  self:AddClickEvent(self.closeBtn, function()
    self:CloseSelf()
  end)
  self.mask = self:FindGO("Mask")
  self:AddClickEvent(self.mask, function()
    self:CloseSelf()
  end)
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function DayLoginRewardTip:SetData(data)
  xdlog("SetData DayLoginRewardTip")
  local rewards = data.rewards
  if rewards and 0 < #rewards then
    local rewardList = {}
    for i = 1, #rewards do
      local reward = rewards[i]
      local data = {}
      data.itemData = ItemData.new("Reward", reward[1])
      if data.itemData then
        data.num = reward[2]
        table.insert(rewardList, data)
      end
    end
    self.todayListCtrl:ResetDatas(rewardList)
  end
  local nextRewards = data.nextRewards
  xdlog("nextreward count", #nextRewards)
  if nextRewards and 0 < #nextRewards then
    local rewardList = {}
    for i = 1, #nextRewards do
      local reward = nextRewards[i]
      local data = {}
      data.itemData = ItemData.new("Reward", reward[1])
      if data.itemData then
        data.num = reward[2]
        table.insert(rewardList, data)
      end
    end
    self.tomorrowListCtrl:ResetDatas(rewardList)
  end
  self.titleLabel.text = data.nextDayTip
  self.funcBtn_Label.text = data.nextDayConfirm
end

function DayLoginRewardTip:HandleClickReward(cellCtrl)
  if cellCtrl and cellCtrl.data then
    self.tipData.itemdata = cellCtrl.data.itemData
    self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Center, {-200, -100})
  end
end

function DayLoginRewardTip:HideSelf(bool)
  self.gameObject:SetActive(bool)
end

function DayLoginRewardTip:CloseSelf()
  self:HideSelf(false)
end
