autoImport("WeeklyTaskCell")
TripleTeamPwsTargetCell = class("TripleTeamPwsTargetCell", WeeklyTaskCell)

function TripleTeamPwsTargetCell:SetData(data)
  self.data = data
  if data then
    local datas = ReusableTable.CreateArray()
    for i = 1, #data.Rewards do
      local id = data.Rewards[i].itemid
      local num = data.Rewards[i].num
      local item = ItemData.new(nil, id)
      item.num = num
      datas[i] = item
    end
    self.listRewards:ResetDatas(datas)
    ReusableTable.DestroyArray(datas)
    local target = data.Goal
    local progress = PvpProxy.Instance:GetTripleTeamPwsTargetProgressByType(data.TaskType) or 0
    local reward_progress = PvpProxy.Instance:GetTripleTeamPwsTargetRewardProgressByType(data.TaskType) or 0
    progress = math.min(progress, target)
    local received = target <= reward_progress
    local canReceive = target <= progress and not received
    local cells = self.listRewards:GetCells()
    for k, v in pairs(cells) do
      v:ReScale(0.9)
      v:SetReceived(received)
      v:SetCanReceive(canReceive)
    end
    self.taskprogress.text = string.format(data.TaskName, progress, target)
  end
end
