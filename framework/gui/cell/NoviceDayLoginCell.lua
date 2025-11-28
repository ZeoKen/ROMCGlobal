autoImport("DayloginCell")
NoviceDayLoginCell = class("NoviceDayLoginCell", DayloginCell)

function NoviceDayLoginCell:FindObjs()
  self.dayLabel = self:FindGO("DayLabel"):GetComponent(UILabel)
  self.finishSymbol = self:FindGO("FinishSymbol")
  self.itemGrid = self:FindGO("ItemGrid"):GetComponent(UIGrid)
  self.itemGridCtrl = UIGridListCtrl.new(self.itemGrid, RewardGridCell, "RewardGridCellType2")
  self.itemGridCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickReward, self)
  self.funcBtn = self:FindGO("FuncBtn", self.processInfo)
  self.funcBtn_Icon = self.funcBtn:GetComponent(UISprite)
  self.funcBtn_Label = self:FindGO("Label", self.funcBtn):GetComponent(UILabel)
  self.funcBtn_BoxCollider = self.funcBtn:GetComponent(BoxCollider)
  self.funcBtn_Label.text = ZhString.PaySignRewardView_Receive
  self:AddClickEvent(self.funcBtn, function()
    self:PassEvent(UICellEvent.OnRightBtnClicked, self)
  end)
  self.lockSymbol = self:FindGO("LockSymbol")
end

function NoviceDayLoginCell:SetData(data)
  self.data = data
  self.dayLabel.text = "DAY " .. (self.indexInList or 7)
  local active = data.active
  local received = data.received
  self.finishSymbol:SetActive(false)
  if not active then
    self.lockSymbol:SetActive(true)
    self.funcBtn:SetActive(false)
    self.finishSymbol:SetActive(false)
  else
    self.lockSymbol:SetActive(false)
    if received then
      self.funcBtn:SetActive(false)
      self.finishSymbol:SetActive(true)
    else
      self.funcBtn:SetActive(true)
    end
  end
  self.itemGridCtrl:RemoveAll()
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
      self.itemGridCtrl:ResetDatas(rewardList)
    end
  end
end
