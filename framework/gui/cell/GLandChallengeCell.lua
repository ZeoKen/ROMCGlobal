local baseCell = autoImport("BaseCell")
GLandChallengeCell = class("GLandChallengeCell", BaseCell)
autoImport("PveDropItemCell")
autoImport("BagItemCell")
local _TypeConfig = {
  [1] = {
    Name = ZhString.GvgLandChallengeView_PersonalTask,
    Color = LuaColor.New(0.5529411764705883, 0.788235294117647, 0.9490196078431372, 1)
  },
  [2] = {
    Name = ZhString.GvgLandChallengeView_GroupTask,
    Color = LuaColor.New(0.9647058823529412, 0.6627450980392157, 0.3411764705882353, 1)
  }
}

function GLandChallengeCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function GLandChallengeCell:FindObjs()
  self.bg = self:FindGO("Bg"):GetComponent(UISprite)
  self.name = self:FindGO("Name"):GetComponent(UILabel)
  self.desc = self:FindGO("Desc"):GetComponent(UILabel)
  self.rewardScrollView = self:FindGO("RewardScrollView"):GetComponent(UIScrollView)
  self.rewardGrid = self:FindGO("RewardGrid"):GetComponent(UIGrid)
  self.rewardGridCtrl = UIGridListCtrl.new(self.rewardGrid, BagItemCell, "BagItemCell")
  self.rewardGridCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickReward, self)
  self.typeBg = self:FindGO("TypeBg"):GetComponent(UISprite)
  self.typeLabel = self:FindGO("TypeLabel"):GetComponent(UILabel)
end

function GLandChallengeCell:SetData(data)
  self.data = data
  self.isInLeisure = data.isInLeisure
  local type = data.type or 1
  self:SetType(type)
  self:SetFinish(false)
  if type == 1 then
    self:SetPersonalTask(data)
  elseif type == 2 then
    self:SetGroupTask(data)
  end
end

function GLandChallengeCell:SetType(type)
  local config = _TypeConfig[type]
  if not config then
    return
  end
  self.typeBg.color = config.Color
  self.typeLabel.text = config.Name
end

function GLandChallengeCell:SetPersonalTask(data)
  local key = data.key
  local value = data.value
  local configData = GameConfig.GVGConfig.reward[GvgProxy.GvgQuestMap[key]]
  if configData then
    local index = 1
    local dataInfo
    local maxRound = index < #configData and #configData or index
    local multiple_reward = 1
    local data = ActivityEventProxy.Instance:GetRewardByType(AERewardType.NewGVGPersonal)
    if data and data:GetMultiple() and data:GetMultiple() > 0 then
      multiple_reward = data:GetMultiple()
    end
    if key == FuBenCmd_pb.EGVGDATA_KILLUSER then
      self.desc.text = ZhString.MainViewGvgPage_GvgQuestTip_KillUser
      self.name.text = string.format(ZhString.MainViewGvgPage_GvgQuestTip_KillUserDes, value)
      local rewardList = {}
      for i = 1, #configData do
        if self.isInLeisure and configData[i][1] == 913000 then
        else
          local itemData = PveDropItemData.new("Reward", configData[i][1])
          itemData:SetItemNum(configData[i][2] * multiple_reward)
          table.insert(rewardList, itemData)
        end
      end
      self.rewardGridCtrl:ResetDatas(rewardList)
      return
    end
    while true do
      if configData[index] and value < configData[index].times or index > maxRound then
        if index > maxRound then
          dataInfo = configData[maxRound]
        else
          dataInfo = configData[index]
        end
        self.desc.text = string.format(dataInfo.desc, value <= dataInfo.times and value or dataInfo.times)
        if dataInfo.items then
          local rewardList = {}
          for i = 1, #dataInfo.items do
            if self.isInLeisure and dataInfo.items[i][1] == 913000 then
            else
              local itemData = PveDropItemData.new("Reward", dataInfo.items[i][1])
              itemData:SetItemNum(dataInfo.items[i][2])
              table.insert(rewardList, itemData)
            end
          end
          self.rewardGridCtrl:ResetDatas(rewardList)
        end
        if value >= configData[maxRound].times then
          self.name.text = string.format(configData.desc, ZhString.AnnounceQuestPanel_Complete)
          self:SetFinish(true)
          break
        end
        if key == FuBenCmd_pb.EGVGDATA_HONOR then
          do
            local str = string.format("%s/%s", value, GameConfig.GVGConfig.reward.max_honor)
            self.name.text = string.format(configData.desc, str)
          end
          break
        end
        do
          local str = string.format("%s/%s", index - 1, maxRound)
          self.name.text = string.format(configData.desc, str)
        end
        break
      end
      index = index + 1
    end
  end
end

function GLandChallengeCell:SetGroupTask(data)
  local config
  for k, v in pairs(GameConfig.GVGConfig.GvgTask) do
    if v.taskid == data.taskid then
      config = v
      break
    end
  end
  if config ~= nil then
    local progress = data.progress
    if config.task_type == GuildCmd_pb.EGVGGUILDTASK_POINT_TIME or config.task_type == GuildCmd_pb.EGVGGUILDTASK_POINT_FIGHT then
      progress = progress // 60
    elseif config.task_type == GuildCmd_pb.EGVGGUILDTASK_PERFECT_DEFENSE and 0 < progress then
      progress = config.need_count
    end
    self.desc.text = string.format(config.desc, progress)
    local reward = config.reward
    if reward ~= nil then
      local rewardList = {}
      for i = 1, #reward do
        if self.isInLeisure and reward[i][1] == 913000 then
        else
          local itemData = PveDropItemData.new("Reward", reward[i][1])
          itemData:SetItemNum(reward[i][2])
          table.insert(rewardList, itemData)
        end
      end
      self.rewardGridCtrl:ResetDatas(rewardList)
    end
    if progress >= config.need_count then
      self:SetFinish(true)
      self.name.text = string.format(ZhString.MainViewGvgPage_GvgQuestTip_Complete, config.title)
    else
      self.name.text = config.title
    end
  end
end

function GLandChallengeCell:SetFinish(bool)
  self.bg.alpha = bool and 0.5 or 1
  local cells = self.rewardGridCtrl:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      cells[i]:SetCheckMarkActive(bool)
    end
  end
end

function GLandChallengeCell:handleClickReward(cellCtrl)
  if cellCtrl then
    self:PassEvent(MouseEvent.DoubleClick, cellCtrl)
  end
end
