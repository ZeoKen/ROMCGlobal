autoImport("BaseCell")
autoImport("ActivityBattlePassItemCell")
ActivityBattlePassTaskCell = class("ActivityBattlePassTaskCell", BaseCell)
local TaskType = {
  NORMAL = 0,
  WEEK_CHALLENGE = 1,
  PRO = 2
}
local TypeName = {
  [TaskType.NORMAL] = ZhString.ActivityBPTaskNormal,
  [TaskType.WEEK_CHALLENGE] = ZhString.ActivityBPTaskWeekChallenge,
  [TaskType.PRO] = ZhString.ActivityBPTaskPro
}

function ActivityBattlePassTaskCell:Init()
  ActivityBattlePassTaskCell.super.Init(self)
  self:FindObjs()
end

function ActivityBattlePassTaskCell:FindObjs()
  self.descLabel = self:FindComponent("desc", UILabel)
  self.typeNameLabel = self:FindComponent("typeName", UILabel)
  self.extraDescLabel = self:FindComponent("extraDesc", UILabel)
  self.progressLabel = self:FindComponent("progress", UILabel)
  self.gotoBtn = self:FindGO("gotoBtn")
  self:AddClickEvent(self.gotoBtn, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.receivedCheck = self:FindGO("receivedCheck")
  self.locker = self:FindGO("Locker")
  local rewardGrid = self:FindComponent("RewardGrid", UIGrid)
  self.rewardList = UIGridListCtrl.new(rewardGrid, ActivityBattlePassItemCell, "ActivityBattlePassItemCell")
  local rewardPanel = self:FindComponent("RewardHolder", UIPanel)
  local upPanel = UIUtil.GetComponentInParents(self.gameObject, UIPanel)
  if upPanel and rewardPanel then
    rewardPanel.depth = upPanel.depth + 1
  end
end

function ActivityBattlePassTaskCell:SetData(data)
  self.id = data
  local staticData = Table_ActBpTarget[self.id]
  local info = ActivityBattlePassProxy.Instance:GetTaskData(staticData.ActID, self.id)
  self:SetCellData(info, staticData)
end

function ActivityBattlePassTaskCell:SetCellData(info, staticData)
  if staticData then
    self.descLabel.text = staticData.Description
    self.typeNameLabel.text = TypeName[staticData.Type]
    self.extraDescLabel.text = staticData.Title
    local targetNum = staticData.TargetNum
    local progress = info.progress
    if staticData.TargetType == "use_time" then
      targetNum = math.floor(targetNum / 60)
      progress = math.floor(progress / 60)
    end
    self.progressLabel.text = progress .. "/" .. targetNum
    local datas = ReusableTable.CreateArray()
    if staticData.Exp then
      local expItem = GameConfig.ActivityBattlePass[staticData.ActID].ExpItem
      local itemData = ItemData.new("Reward", expItem)
      if itemData then
        itemData:SetItemNum(staticData.Exp)
      end
      datas[#datas + 1] = itemData
    end
    if staticData.Reward then
      for i = 1, #staticData.Reward do
        self:SetReward(staticData.Reward[i], datas)
      end
    end
    self.rewardList:ResetDatas(datas)
    ReusableTable.DestroyAndClearArray(datas)
    local cells = self.rewardList:GetCells()
    for i = 1, #cells do
      local cell = cells[i]
      LuaGameObject.SetLocalScaleGO(cell.gameObject, 0.8, 0.8, 1)
    end
    if (not staticData.Goto or not staticData.Goto[1]) and (not staticData.Message or not staticData.Message[1]) then
      self:SetTaskState(staticData.Type, info.state, true)
      return
    end
  end
  self:SetTaskState(staticData.Type, info.state)
end

function ActivityBattlePassTaskCell:SetTaskState(type, state, hideGoTo)
  if type ~= TaskType.PRO then
    self.gotoBtn:SetActive(state == EACTQUESTSTATE.EACT_QUEST_DOING and not hideGoTo)
    self.receivedCheck:SetActive(state == EACTQUESTSTATE.EACT_QUEST_REWARDED)
    self.locker:SetActive(false)
  else
    local config = Table_ActBpTarget[self.id]
    local isPro = ActivityBattlePassProxy.Instance.isPro[config.ActID]
    self.gotoBtn:SetActive(state == EACTQUESTSTATE.EACT_QUEST_DOING and isPro and not hideGoTo)
    self.receivedCheck:SetActive(state == EACTQUESTSTATE.EACT_QUEST_REWARDED and isPro)
    self.locker:SetActive(not isPro)
  end
end

function ActivityBattlePassTaskCell:SetReward(rewardId, list)
  local itemIds = ItemUtil.GetRewardItemIdsByTeamId(rewardId)
  if itemIds then
    for i = 1, #itemIds do
      local single = itemIds[i]
      local hasAdd = false
      local item = TableUtility.ArrayFindByPredicate(list, function(item, data)
        return item.id == data.id
      end, single)
      if item then
        item.num = item.num + single.num
        hasAdd = true
      end
      if not hasAdd then
        local itemData = ItemData.new("Reward", single.id)
        if itemData then
          itemData:SetItemNum(single.num)
          if single.refinelv and itemData:IsEquip() then
            itemData.equipInfo:SetRefine(single.refinelv)
          end
          list[#list + 1] = itemData
        end
      end
    end
  end
end
