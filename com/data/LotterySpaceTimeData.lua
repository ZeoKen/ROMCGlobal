autoImport("LotteryData")
LotterySpaceTimeData = class("LotterySpaceTimeData", LotteryData)

function LotterySpaceTimeData:ctor(data, type)
  LotterySpaceTimeData.super.ctor(self, data)
  self.dressMap = FunctionLottery.SetDressData(type, self.items)
end

function LotterySpaceTimeData:GetInitializedDressData()
  return self.dressMap
end
