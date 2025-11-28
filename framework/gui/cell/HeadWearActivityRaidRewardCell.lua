local BaseCell = autoImport("BaseCell")
HeadWearActivityRaidRewardCell = class("HeadWearActivityRaidRewardCell", BaseCell)

function HeadWearActivityRaidRewardCell:Init()
  HeadWearActivityRaidRewardCell.super.Init(self)
  self:FindObjs()
end

function HeadWearActivityRaidRewardCell:FindObjs()
  self.roundLabel = self:FindGO("RoundLabel"):GetComponent(UILabel)
  self.rewardScrollView = self:FindGO("RewardScrollView"):GetComponent(UIScrollView)
  self.rewardGrid = self:FindGO("RewardGrid"):GetComponent(UIGrid)
  self.rewardGridCtrl = UIGridListCtrl.new(self.rewardGrid, BagItemCell, "BagItemCell")
  self.rewardGridCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickReward, self)
  self.processLabel = self:FindGO("ProcessLabel"):GetComponent(UILabel)
  local rewardPanel = self:FindComponent("RewardScrollView", UIPanel)
  local upPanel = UIUtil.GetComponentInParents(self.gameObject, UIPanel)
  if upPanel and rewardPanel then
    rewardPanel.depth = upPanel.depth + 1
  end
end

function HeadWearActivityRaidRewardCell:SetData(data)
  self.data = data
  self.floor = data.floor
  self.rewardid = data.rewardID
  self.roundLabel.text = string.format("Round.%s", self.floor)
  local rewardList = {}
  self:UpdateRewards(self.rewardid, rewardList)
  self.rewardGridCtrl:ResetDatas(rewardList)
  local scrollView = UIUtil.GetComponentInParents(self.gameObject, UIScrollView)
  local cells = self.rewardGridCtrl:GetCells()
  for i = 1, #cells do
    local single = cells[i]
    single:SwitchDragScrollView(scrollView)
  end
  self.maxProcess = data.max
  self.processLabel.text = 0 .. "/" .. data.max
end

function HeadWearActivityRaidRewardCell:SetProcess(count)
  self.processLabel.text = count .. "/" .. self.maxProcess
end

function HeadWearActivityRaidRewardCell:UpdateRewards(rewardid, array)
  local list = ItemUtil.GetRewardItemIdsByTeamId(rewardid)
  if list then
    for i = 1, #list do
      local single = list[i]
      local hasAdd = false
      for j = 1, #array do
        local temp = array[j]
        if temp.id == single.id then
          temp.num = temp.num + single.num
          hasAdd = true
          break
        end
      end
      if not hasAdd then
        local itemData = ItemData.new("Reward", single.id)
        if itemData then
          itemData:SetItemNum(single.num)
          if single.refinelv and itemData:IsEquip() then
            itemData.equipInfo:SetRefine(single.refinelv)
          end
          table.insert(array, itemData)
        end
      end
    end
  end
end

function HeadWearActivityRaidRewardCell:handleClickReward(cellCtrl)
  self:PassEvent(UICellEvent.OnCellClicked, cellCtrl)
end
