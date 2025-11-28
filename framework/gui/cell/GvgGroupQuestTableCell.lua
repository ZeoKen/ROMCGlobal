GvgGroupQuestTableCell = class("GvgQuestTableCell", GvgQuestTableCell)

function GvgGroupQuestTableCell:SetData(data)
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
      self.questName.text = string.format(ZhString.MainViewGvgPage_GvgQuestTip_Complete, config.title)
    else
      self.questName.text = config.title
    end
    self.rewardName.text = string.format(config.desc, progress)
    local reward = config.reward
    if reward ~= nil then
      for i = 1, #reward do
        self.rewards[i].countLab.text = "x" .. reward[i][2]
        local item = Table_Item[reward[i][1]]
        if item ~= nil then
          local icon = item.Icon or ""
          IconManager:SetItemIcon(icon, self.rewards[i].icon)
        end
      end
    end
  end
end
