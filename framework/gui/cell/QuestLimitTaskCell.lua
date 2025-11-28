local BaseCell = autoImport("BaseCell")
QuestLimitTaskCell = class("QuestLimitTaskCell", BaseCell)
autoImport("RewardGridCell")

function QuestLimitTaskCell:Init()
  self:FindObjs()
end

function QuestLimitTaskCell:FindObjs()
  self.desc = self:FindGO("Label"):GetComponent(UILabel)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.rewardBtn = self:FindGO("RewardBtn")
  self.lockedSymbol = self:FindGO("Locked")
  self.finishSymbol = self:FindGO("FinishSymbol")
  self.rewardGrid = self:FindGO("RewardGrid"):GetComponent(UIGrid)
  self.rewardCtrl = UIGridListCtrl.new(self.rewardGrid, RewardGridCell, "RewardGridCellType2")
  self.rewardCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickReward, self)
  self:AddClickEvent(self.confirmBtn, function()
    self:PassEvent(UICellEvent.OnCellClicked, self)
  end)
  self:AddClickEvent(self.rewardBtn, function()
    self:PassEvent(UICellEvent.OnRightBtnClicked, self)
  end)
end

function QuestLimitTaskCell:SetData(data)
  self.data = data
  local id = data.id
  local staticData = id and Table_MissionReward[id]
  if staticData then
    if data.name then
      self.desc.text = data.name
    else
      self.desc.text = staticData.QuestName
    end
    local cellStatus = data.cellStatus or 4
    self:SetStatus(cellStatus)
    local myGener = MyselfProxy.Instance:GetMySex()
    local rewards
    if myGener == 1 then
      rewards = staticData.MaleReward
    elseif myGener == 2 then
      rewards = staticData.FeMaleReward
    end
    if rewards and 0 < #rewards then
      local rewardList = {}
      for i = 1, #rewards do
        local itemData = ItemData.new("Reward", rewards[i][1])
        table.insert(rewardList, {
          itemData = itemData,
          num = rewards[i][2]
        })
      end
      self.rewardCtrl:ResetDatas(rewardList)
    end
  end
end

function QuestLimitTaskCell:SetStatus(type)
  if type == 1 then
    self.confirmBtn:SetActive(true)
    self.rewardBtn:SetActive(false)
    self.finishSymbol:SetActive(false)
    self.lockedSymbol:SetActive(false)
  elseif type == 2 then
    self.confirmBtn:SetActive(false)
    self.rewardBtn:SetActive(true)
    self.finishSymbol:SetActive(false)
    self.lockedSymbol:SetActive(false)
  elseif type == 3 then
    self.confirmBtn:SetActive(false)
    self.rewardBtn:SetActive(false)
    self.finishSymbol:SetActive(true)
    self.lockedSymbol:SetActive(false)
  elseif type == 4 then
    self.confirmBtn:SetActive(false)
    self.rewardBtn:SetActive(false)
    self.finishSymbol:SetActive(false)
    self.lockedSymbol:SetActive(true)
  end
end

function QuestLimitTaskCell:HandleClickReward(cellCtrl)
  xdlog("PassEvent HandleClickReward")
  self:PassEvent(UICellEvent.OnMidBtnClicked, cellCtrl)
end
