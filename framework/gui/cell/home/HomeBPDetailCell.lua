HomeBPDetailCell = class("HomeBPDetailCell", BaseCell)

function HomeBPDetailCell:Init()
  HomeBPDetailCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function HomeBPDetailCell:FindObjs()
  self.labDetails = self:FindComponent("Label", UILabel)
end

function HomeBPDetailCell:AddEvts()
end

function HomeBPDetailCell:SetData(data)
  self.data = data
  local haveData = data ~= nil
  if self.isActive ~= haveData then
    self.gameObject:SetActive(haveData)
    self.isActive = haveData
  end
  if not haveData then
    return
  end
  self.labDetails.text = data
end
