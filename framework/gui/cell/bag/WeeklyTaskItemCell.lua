autoImport("ColliderItemCell")
WeeklyTaskItemCell = class("WeeklyTaskItemCell", ColliderItemCell)

function WeeklyTaskItemCell:Init()
  WeeklyTaskItemCell.super.Init(self)
  self:AddCellClickEvent()
  self.received = self:FindGO("received")
  self.canReceiveFlag = self:FindGO("FlagSp")
end

function WeeklyTaskItemCell:SetData(data)
  WeeklyTaskItemCell.super.SetData(self, data)
end

function WeeklyTaskItemCell:SetReceived(received)
  self.received:SetActive(received or false)
end

function WeeklyTaskItemCell:SetCanReceive(canReceive)
  self.canReceiveFlag:SetActive(canReceive or false)
end
