local PrayConfigData = class("PrayConfigData")

function PrayConfigData:ctor(serviceData)
  self.id = serviceData.prayid
  self.staticData = Table_Guild_Faith[self.id]
  self.lv = serviceData.praylv
  self.type = serviceData.type
  local serviceAttr = serviceData.attrs
  if serviceAttr and 0 < #serviceAttr then
    local attrId = serviceAttr[1].type
    self.attrStaticData = Table_RoleData[attrId]
    self.attrValue = serviceAttr[1].value
    if 1 < #serviceAttr then
      local attrId2 = serviceAttr[2].type
      self.attrStaticData2 = Table_RoleData[attrId2]
      self.attrValue2 = serviceAttr[2].value
    end
  else
    self.attrValue = 0
  end
  local itemInfo = serviceData.costs
  if itemInfo and 0 < #itemInfo then
    local item = ItemData.new(itemInfo[1].guid, itemInfo[1].id)
    item.num = itemInfo[1].count
    self.itemCost = item
    if 1 < #itemInfo then
      local item2 = ItemData.new(itemInfo[2].guid, itemInfo[2].id)
      item2.num = itemInfo[2].count
      self.itemCost2 = item2
    end
  end
end

GvGPvpPrayData = class("GvGPvpPrayData")

function GvGPvpPrayData:ctor(data)
  self.nextPrays = {}
  self.staticId = data.pray
  self.staticData = Table_Guild_Faith[self.staticId]
  self.faithType = self.staticData.Type
  self.lv = data.lv
  self.curPray = PrayConfigData.new(data.cur)
  if #data.next > 0 then
    self.nextPray = PrayConfigData.new(data.next[1])
    self:SetNextPrayArray(data.next)
  else
    self.nextPray = nil
    TableUtility.ArrayClear(self.nextPrays)
  end
  self:_SetPrayType()
  if self.type then
    self.id = 0 == self.curPray.lv and self.nextPray.id or self.curPray.id
  end
  self:SetCostName()
end

function GvGPvpPrayData:SetCostName()
  self.costName = ""
  if self.nextPray and self.nextPray.itemCost then
    self.costName = self.nextPray.itemCost.staticData.NameZh
  elseif self.curPray and self.curPray.itemCost then
    self.costName = self.curPray.itemCost.staticData.NameZh
  end
end

function GvGPvpPrayData:_SetPrayType()
  if 0 == self.curPray.lv then
    if self.nextPray then
      self.type = self.nextPray.type
    end
  else
    self.type = self.curPray.type
  end
end

function GvGPvpPrayData:IsMax(pray_count)
  if self:IsRealMax() then
    return true
  end
  return self:IsLimitedByLevelConfig(pray_count)
end

function GvGPvpPrayData:IsLimitedByLevelConfig(pray_count)
  local uplv = GuildPrayProxy.Instance:GetMaxConfigPrayLv(self.faithType)
  if uplv and uplv <= self.lv then
    return true
  end
  if pray_count then
    return uplv <= self.lv + pray_count
  end
  return false
end

function GvGPvpPrayData:IsRealMax()
  return not self.nextPray or 0 == self.nextPray.lv
end

local args = {}

function GvGPvpPrayData:GetAddAttrValue()
  if self:IsMax() then
    args[1] = false
    args[2] = self.curPray.staticData.AttrName
    args[12] = self.curPray.staticData.Name
    local cur = self.curPray.attrValue
    args[3] = self.curPray.attrStaticData.IsPercent == 1 and string.format("%s%%", cur / 100) or cur / 10000
  else
    args[1] = true
    args[2] = self.nextPray.staticData.AttrName
    args[12] = self.nextPray.staticData.Name
    local curAttrValue = self.curPray.attrValue
    local nextAttrVal = self.nextPray.attrValue
    local IsPercent = self.nextPray.attrStaticData and self.nextPray.attrStaticData.IsPercent or self.curPray.attrStaticData.IsPercent
    args[3] = IsPercent == 1 and string.format("%s%%", curAttrValue / 100) or curAttrValue / 10000
    local deltaValue = nextAttrVal - curAttrValue
    args[4] = IsPercent == 1 and string.format("%s%%", deltaValue / 100) or deltaValue / 10000
    if self.nextPray.itemCost then
      args[5] = self.nextPray.itemCost.num
      args[6] = self.nextPray.itemCost.staticData.NameZh
      args[10] = self.nextPray.itemCost.staticData.id
    end
    if self.nextPray.itemCost2 then
      args[8] = self.nextPray.itemCost2.num
      args[9] = self.nextPray.itemCost2.staticData.NameZh
    end
  end
  args[7] = self.type
  args[11] = self.staticData and self.staticData.ColorID
  return args
end

function GvGPvpPrayData:SetNextPrayArray(nexts)
  for i = 1, #nexts do
    local data = PrayConfigData.new(nexts[i])
    self.nextPrays[#self.nextPrays + 1] = data
  end
end

local _Max_PrayCount = GameConfig.Guild.max_pray_count or 20
local _GuildCertificateId = GameConfig.Guild.praydeduction[1]
local _GuildCertificateZenyRate = GameConfig.Guild.praydeduction[2]

function GvGPvpPrayData:CalcMaxPrayCount(useCertificate)
  if not self.nextPray then
    return 0
  end
  local own
  if useCertificate then
    local ownCertificate = BagProxy.Instance:GetItemNumByStaticID(_GuildCertificateId, GameConfig.PackageMaterialCheck.guilddonate)
    own = BagProxy.Instance:GetItemNumByStaticID(self.nextPray.itemCost.staticData.id) + _GuildCertificateZenyRate * ownCertificate
  else
    own = BagProxy.Instance:GetItemNumByStaticID(self.nextPray.itemCost.staticData.id)
  end
  local c = 0
  local length = math.min(_Max_PrayCount, #self.nextPrays)
  local uplv = GuildPrayProxy.Instance:GetMaxConfigPrayLv(self.faithType)
  local lvLength = uplv - self.lv
  length = math.min(lvLength, length)
  for i = 1, length do
    c = c + self.nextPrays[i].itemCost.num
    if own < c then
      return i - 1
    elseif i == length then
      return i
    end
  end
  return 0
end

local max_args = {}

function GvGPvpPrayData:GetMaxPrayParam(useCertificate, useMax)
  if self:IsMax() then
    max_args[1] = false
    max_args[2] = self.curPray.staticData.AttrName
  else
    local maxCount = self:CalcMaxPrayCount(useCertificate)
    max_args[1] = maxCount
    max_args[2] = self.nextPray.staticData.AttrName
    local IsPercent = self.nextPray.attrStaticData and self.nextPray.attrStaticData.IsPercent
    local maxAttrValue, maxCost = 0, 0
    if useMax and 0 < maxCount then
      maxAttrValue = self.nextPrays[maxCount].attrValue
      for i = 1, maxCount do
        maxCost = maxCost + self.nextPrays[i].itemCost.num
      end
    else
      maxAttrValue, maxCost = self.nextPray.attrValue, self.nextPray.itemCost.num
    end
    local curAttrValue = self.curPray.attrValue
    local deltaValue = maxAttrValue - curAttrValue
    max_args[4] = IsPercent == 1 and string.format("%s%%", deltaValue / 100) or deltaValue / 10000
    max_args[5] = maxCost
    max_args[6] = self.nextPray.itemCost.staticData.NameZh
    if max_args[5] == GameConfig.MoneyId.Zeny then
      local costMoney = math.floor(max_args[5] / _GuildCertificateZenyRate)
      local own = BagProxy.Instance:GetItemNumByStaticID(self.nextPray.itemCost.staticData.id)
      costMoney = math.min(costMoney, own)
      max_args[7] = costMoney
    end
  end
  return max_args
end
