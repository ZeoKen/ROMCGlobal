autoImport("ItemData")
PveDropItemData = class("PveDropItemData", ItemData)
PveDropItemData.Type = {
  E_Extra = 0,
  E_Normal = 1,
  E_Weekly = 2,
  E_First = 3,
  E_Probability = 4,
  E_HeadWear = 5,
  E_Pve = 9,
  E_Pve_Card = 10,
  E_Pve_Card_NoFirst = 11,
  E_Pve_Sweep = 12,
  E_Pve_ThreeStars = 13,
  E_WeekFirstPass = 14
}
local reward_type = PveDropItemData.Type
local needSort_type = {
  [reward_type.E_Pve] = 1,
  [reward_type.E_Pve_Card] = 1,
  [reward_type.E_Pve_Card_NoFirst] = 1,
  [reward_type.E_WeekFirstPass] = 1
}

function PveDropItemData.CheckNeedInsert(t)
  return nil ~= needSort_type[t]
end

PveDropItemData.BossRewardSortId = {
  Equip = 1,
  Material = 2,
  Pic = 3,
  Card = 4,
  Other = 5
}

function PveDropItemData:ctor(id, staticId)
  PveDropItemData.super.ctor(self, id, staticId)
  if not Table_Item[staticId] then
    redlog("Pve reward配置错误,未找到ItemID : ", staticId)
  end
  self:SetBossRewardSortId()
end

function PveDropItemData:SetBossRewardSortId()
  if self:IsEquipMaterial() then
    self.bossSortId = PveDropItemData.BossRewardSortId.Material
  elseif self:IsPic() then
    self.bossSortId = PveDropItemData.BossRewardSortId.Pic
  elseif self:IsCard() then
    self.bossSortId = PveDropItemData.BossRewardSortId.Card
  elseif self:IsEquip() then
    self.bossSortId = PveDropItemData.BossRewardSortId.Equip
  else
    self.bossSortId = PveDropItemData.BossRewardSortId.Other
  end
end

function PveDropItemData:SetType(t)
  self.dropType = t
end

function PveDropItemData:SetSpecialBgName(sp)
  if not sp then
    return
  end
  self.specialBgName = sp
end

function PveDropItemData:SetOwnPveId(ownerid)
  self.ownerid = ownerid
end

function PveDropItemData:SetRate(rate)
  self.rate = rate
end

function PveDropItemData:IsPickup()
  return PveEntranceProxy.Instance:IsPickup(self.ownerid)
end

function PveDropItemData:SetRange(min, max)
  if not min or not max then
    return
  end
  self.min_num = min
  self.max_num = max
end

function PveDropItemData:SetReceived(received)
  self.received = received
end

local _format = "%d~%d"

function PveDropItemData:GetNumDesc()
  if self.min_num and self.max_num then
    return string.format(_format, self.min_num, self.max_num)
  elseif self.rate and self.rate > 0 and self.rate ~= 10000 then
    local numRatio = self.rate / 10000
    local num1 = math.floor(1 * numRatio)
    local num2 = math.floor(1 * numRatio + 1) * self.num
    return string.format(_format, num1, num2)
  end
  return self.num and 1 < self.num and tostring(self.num) or ""
end
