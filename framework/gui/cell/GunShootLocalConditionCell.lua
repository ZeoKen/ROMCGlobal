local BaseCell = autoImport("BaseCell")
GunShootLocalConditionCell = class("GunShootLocalConditionCell", BaseCell)

function GunShootLocalConditionCell:Init()
  self:FindObjs()
end

function GunShootLocalConditionCell:FindObjs()
  self.number = self:FindComponent("cond", UILabel)
end

function GunShootLocalConditionCell:SetData(data)
  self.data = data
  if data then
    self.number.text = data.point
  end
end
