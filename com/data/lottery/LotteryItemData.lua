local _rateFormat = "%s%%"
LotteryItemData = class("LotteryItemData")

function LotteryItemData:ctor(data)
  self:SetData(data)
end

function LotteryItemData:SetData(data)
  if data then
    self.id = data.id
    self.lottery_id = data.lottery_id
    self.itemid = data.itemid
    self.female_itemid = data.female_itemid
    self.count = data.count
    self.timeShow = data.time_show
    self.recoverPrice = data.recover_price
    self.recoverItemid = data.recover_itemid
    self.rate = data.rate
    self.rarity = data.rarity
    if data.cur_batch then
      self.isCurBatch = 1
    else
      self.isCurBatch = 0
    end
    self.itemType = data.itemtype or 0
    LotteryProxy.Instance:RecordSSRCard(self.itemid, self.itemType)
    self.safety_rate = data.safety_rate or 0
    if data.up_begin and 0 < data.up_begin then
      self.up_begin = data.up_begin
    else
      self.up_begin = nil
    end
    if data.up_end and 0 < data.up_end then
      self.up_end = data.up_end
    else
      self.up_end = nil
    end
    local _id = self:GetRealItemID()
    self.headwearRepairStaticData = Table_HeadwearRepair[_id]
    if nil == self.headwearRepairStaticData then
    end
    self.headwearType = self.headwearRepairStaticData and self.headwearRepairStaticData.Type
  end
end

function LotteryItemData:ResetServerItemRate(totalRate, cumulativeRate)
  self.rate = totalRate - cumulativeRate
  self.isLastServerItem = true
end

function LotteryItemData:HasConfigTime()
  return self.timeShow and self.timeShow > 0
end

function LotteryItemData:GetRealItemID()
  local itemData = self:GetItemData()
  return itemData and itemData.staticData and itemData.staticData.id
end

function LotteryItemData:GetItemData()
  if self.itemData == nil then
    local itemid = self.itemid
    if self.female_itemid and self.female_itemid ~= 0 then
      local sex = Game.Myself.data.userdata:Get(UDEnum.SEX) or 1
      if sex == 2 then
        itemid = self.female_itemid
      end
    end
    self.itemData = ItemData.new("LotteryItem", itemid)
    self.itemData.num = self.count
  end
  return self.itemData
end

function LotteryItemData:GetRate()
  if self.rate then
    if BranchMgr.IsJapan() then
      local tempRate = math.floor(self.rate / 100 + 0.5) / 100
      if tempRate < 0.01 then
        tempRate = 0.01
      end
      return tempRate
    elseif BranchMgr.IsKorea() then
      return self.rate / 10000000
    else
      return self.rate / 10000
    end
  end
  return 0
end

function LotteryItemData:GetUIRate()
  return string.format(ZhString.Lottery_DetailRate, self:GetRate())
end

function LotteryItemData:CheckGoodsGot()
  local id = self:GetRealItemID()
  return LotteryProxy.CheckGot(id)
end

function LotteryItemData:CheckGoodsGroupGot()
  local id = self:GetRealItemID()
  return LotteryProxy.CheckGoodsGroupGot(id)
end

function LotteryItemData:GetOriginRate()
  return self.rate - self.safety_rate, self.safety_rate
end

function LotteryItemData:GetDisplayRate()
  local baseRate, safetyRate = self:GetOriginRate()
  local tempRate, tempSafety = 0, 0
  if BranchMgr.IsJapan() then
    tempRate = math.floor(baseRate / 100 + 0.5) / 100
    tempSafety = math.floor(safetyRate / 100 + 0.5) / 100
    tempRate = math.max(tempRate, 0.01)
  elseif BranchMgr.IsKorea() then
    tempRate = baseRate / 10000000
    tempSafety = safetyRate / 10000000
  else
    tempRate = baseRate / 10000
    tempSafety = safetyRate / 10000
  end
  return tempRate, tempSafety
end

function LotteryItemData:GetUpDuration()
  return self.up_begin, self.up_end
end
