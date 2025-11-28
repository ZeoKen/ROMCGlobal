autoImport("LotteryDollData")
LotteryDollProxy = class("LotteryDollProxy", pm.Proxy)
LotteryDollProxy.Instance = nil
LotteryDollProxy.NAME = "LotteryDollProxy"
local _ArrayPushBack = TableUtility.ArrayPushBack
local _ArrayClear = TableUtility.ArrayClear

function LotteryDollProxy:ctor(proxyName, data)
  self.proxyName = proxyName or LotteryDollProxy.NAME
  if LotteryDollProxy.Instance == nil then
    LotteryDollProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function LotteryDollProxy:Init()
  self:InitLotteryDoll()
end

function LotteryDollProxy:InitLotteryDoll()
  self.lotteryDollInfo = {}
  self.lastQueryLotteryDollTime = 0
  self.lastBuyLotteryDollTime = 0
end

function LotteryDollProxy:UpdateLotteryDollInfo(allInfos, ownedInfos)
  if not allInfos then
    return
  end
  _ArrayClear(self.lotteryDollInfo)
  for _, v in ipairs(allInfos) do
    local data = LotteryDollData.new(v)
    data.rate = 0
    if ownedInfos then
      for _, ov in ipairs(ownedInfos) do
        if ov.id == v.id then
          data.owned = true
          data:UpdateData(ov)
          break
        end
      end
    end
    _ArrayPushBack(self.lotteryDollInfo, data)
  end
  self:SortLotteryDollData()
  self:RecalculateLotteryDollRates()
end

function LotteryDollProxy:UpdateOwnedLotteryDollInfo(newInfo)
  if not newInfo then
    return
  end
  for _, v in ipairs(self.lotteryDollInfo) do
    if v.id == newInfo.id then
      v:UpdateData(newInfo)
      if not v.owned then
        v.owned = true
        self:RecalculateLotteryDollRates()
        self:sendNotification(LotteryEvent.RecvLotteryDollResult, v)
      end
      break
    end
  end
end

function LotteryDollProxy:RecalculateLotteryDollRates()
  local totalWeight = 0
  for _, v in ipairs(self.lotteryDollInfo) do
    if not v.owned then
      totalWeight = totalWeight + v.weight
    end
  end
  for _, v in ipairs(self.lotteryDollInfo) do
    if v.owned then
      v.rate = 0
    else
      v.rate = totalWeight == 0 and 0 or v.weight / totalWeight * 100
    end
  end
end

function LotteryDollProxy.CompareLotteryDollData(a, b)
  return a.id < b.id
end

function LotteryDollProxy:SortLotteryDollData()
  if self.lotteryDollInfo then
    table.sort(self.lotteryDollInfo, LotteryDollProxy.CompareLotteryDollData)
  end
end

function LotteryDollProxy:IsAllItemOwned()
  if not self.lotteryDollInfo then
    return true
  end
  for _, v in ipairs(self.lotteryDollInfo) do
    if not v.owned then
      return false
    end
  end
  return true
end
