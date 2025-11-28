autoImport("WeeklyTaskItemCell")
WeeklyTaskCell = class("WeeklyTaskCell", BaseCell)

function WeeklyTaskCell:Init()
  self:FindObjs()
end

function WeeklyTaskCell:FindObjs()
  self.taskprogress = self:FindComponent("taskprogress", UILabel)
  self.listRewards = UIGridListCtrl.new(self:FindComponent("Rewards", UIGrid), WeeklyTaskItemCell, "WeeklyTaskItemCell")
  self.listRewards:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
end

local progress = 0

function WeeklyTaskCell:SetData(data)
  if data then
    self.data = data
    self.gameObject:SetActive(true)
    self.listRewards:ResetDatas(self.data.items)
    local cells = self.listRewards:GetCells()
    for k, v in pairs(cells) do
      v:ReScale(0.7)
      v:SetReceived(self.data.received)
    end
    progress = self.data.progress < self.data.staticData.Goal and self.data.progress or self.data.staticData.Goal
    self.taskprogress.text = string.format(self.data.staticData.TaskName, progress, self.data.staticData.Goal)
  else
    self.gameObject:SetActive(false)
  end
end

function WeeklyTaskCell:ClickItem(item)
  self:PassEvent(MouseEvent.MouseClick, item)
end
