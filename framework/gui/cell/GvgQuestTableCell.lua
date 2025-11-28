local baseCell = autoImport("BaseCell")
GvgQuestTableCell = class("GvgQuestTableCell", baseCell)

function GvgQuestTableCell:Init()
  GvgQuestTableCell.super.Init(self)
  self.questName = self:FindComponent("questName", UILabel)
  local rewardRoot = self:FindGO("RewardCt")
  self.rewardName = self:FindComponent("rewardName", UILabel, rewardRoot)
  self.rewards = {
    [1] = {},
    [2] = {},
    [3] = {}
  }
  self.rewardGrid = self:FindGO("RewardGrid"):GetComponent(UIGrid)
  self.rewards[1].icon = self:FindComponent("rewardIcon1", UISprite, rewardRoot)
  self.rewards[1].countLab = self:FindComponent("rewardCount1", UILabel, rewardRoot)
  self.rewards[2].icon = self:FindComponent("rewardIcon2", UISprite, rewardRoot)
  self.rewards[2].countLab = self:FindComponent("rewardCount2", UILabel, rewardRoot)
  self.rewards[3].icon = self:FindComponent("rewardIcon3", UISprite, rewardRoot)
  self.rewards[3].countLab = self:FindComponent("rewardCount3", UILabel, rewardRoot)
end

function GvgQuestTableCell:SetData(data)
  self.data = data
  local type = data.type or 1
  if type == 1 then
    self:SetPersonalTask(data)
  elseif type == 2 then
    self:SetGroupTask(data)
  end
end

function GvgQuestTableCell:SetPersonalTask(data)
  local isInLeisure = data.isInLeisure
  local key = data.key
  local value = data.value
  local configData = GameConfig.GVGConfig.reward[GvgProxy.GvgQuestMap[key]]
  if configData then
    local index = 1
    local dataInfo
    local maxRound = index < #configData and #configData or index
    local multiple_reward
    local data = ActivityEventProxy.Instance:GetRewardByType(AERewardType.NewGVGPersonal)
    if data and data:GetMultiple() and data:GetMultiple() > 0 then
      multiple_reward = data:GetMultiple()
    end
    if key == FuBenCmd_pb.EGVGDATA_KILLUSER then
      self.rewardName.text = ZhString.MainViewGvgPage_GvgQuestTip_KillUser
      self.questName.text = string.format(ZhString.MainViewGvgPage_GvgQuestTip_KillUserDes, value)
      for i = 1, #configData do
        self.rewards[i].countLab.text = multiple_reward and "x" .. configData[i][2] * multiple_reward or "x" .. configData[i][2]
        local icon = Table_Item[configData[i][1]] and Table_Item[configData[i][1]].Icon or ""
        IconManager:SetItemIcon(icon, self.rewards[i].icon)
        self.rewards[i].icon:MakePixelPerfect()
        self.rewards[i].icon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.4, 0.4, 0.4)
      end
      return
    end
    while true do
      if configData[index] and value < configData[index].times or index > maxRound then
        if index > maxRound then
          dataInfo = configData[maxRound]
        else
          dataInfo = configData[index]
        end
        self.rewardName.text = string.format(dataInfo.desc, value <= dataInfo.times and value or dataInfo.times)
        if dataInfo.items then
          for i = 1, #dataInfo.items do
            if isInLeisure and dataInfo.items[i][1] == 913000 then
            else
              self.rewards[i].countLab.text = multiple_reward ~= nil and "x" .. dataInfo.items[i][2] * multiple_reward or "x" .. dataInfo.items[i][2]
              local icon = Table_Item[dataInfo.items[i][1]] and Table_Item[dataInfo.items[i][1]].Icon or ""
              IconManager:SetItemIcon(icon, self.rewards[i].icon)
              self.rewards[i].icon:MakePixelPerfect()
              self.rewards[i].icon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.4, 0.4, 0.4)
            end
          end
        end
        if value >= configData[maxRound].times then
          self.questName.text = string.format(configData.desc, ZhString.AnnounceQuestPanel_Complete)
          break
        end
        if key == FuBenCmd_pb.EGVGDATA_HONOR then
          do
            local str = string.format("%s/%s", value, GameConfig.GVGConfig.reward.max_honor)
            self.questName.text = string.format(configData.desc, str)
          end
          break
        end
        do
          local str = string.format("%s/%s", index - 1, maxRound)
          self.questName.text = string.format(configData.desc, str)
        end
        break
      end
      index = index + 1
    end
  end
end

function GvgQuestTableCell:SetGroupTask(data)
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
    if progress == config.need_count then
      self.questName.text = string.format(ZhString.MainViewGvgPage_GvgQuestTip_Complete, ZhString.GvgLandChallengeView_GroupTask2 .. config.title)
    else
      self.questName.text = ZhString.GvgLandChallengeView_GroupTask2 .. config.title
    end
    self.rewardName.text = string.format(config.desc, progress)
    local reward = config.reward
    if reward ~= nil then
      for i = 1, #reward do
        if isInLeisure and reward[i][1] == 913000 then
        else
          self.rewards[i].countLab.text = "x" .. reward[i][2]
          local item = Table_Item[reward[i][1]]
          if item ~= nil then
            local icon = item.Icon or ""
            IconManager:SetItemIcon(icon, self.rewards[i].icon)
            self.rewards[i].icon:MakePixelPerfect()
            self.rewards[i].icon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.4, 0.4, 0.4)
          end
        end
      end
    end
  end
end
