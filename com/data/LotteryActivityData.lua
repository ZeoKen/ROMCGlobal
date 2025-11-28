LotteryActivityData = class("LotteryActivityData")
LotteryActivityData.ESortID = {
  ActiveMagic = 1,
  Card = 2,
  Head = 3,
  Mix = 4,
  Magic = 5,
  SpaceTime = 6
}

function LotteryActivityData:ctor(type, open, st, et)
  self.lotteryType = type
  self.open = open
  self.startTime = st
  self.endTime = et
  self:SetData()
  redlog("-----------------LotteryActivityData type open : ", type, open)
end

function LotteryActivityData:SetData()
  local config = GameConfig.Lottery.activity
  if config then
    config = config[self.lotteryType]
    if config then
      self.name = config.activityName
      self.texture = config.textureName
      if config.always then
        self.time = ""
      else
        self.time = ClientTimeUtil.GetTimeDate(self.startTime, self.endTime)
      end
      self.maunalTimeDesc = config.maunalTimeDesc
      self.isInLotteryEntrance = config.inLotteryEntrance == true
      self:SetSortId(config)
    end
  end
end

function LotteryActivityData:CheckTimeValid()
  local serverTime = ServerTime.CurServerTime() / 1000
  return serverTime > self.startTime and serverTime < self.endTime
end

function LotteryActivityData:CheckIsInEntrance()
  return self.isInLotteryEntrance == true
end

function LotteryActivityData:SetSortId(config)
  if config.isActiveMagic then
    self.sortId = LotteryActivityData.ESortID.ActiveMagic
  elseif LotteryProxy.IsCardLottery(self.lotteryType) then
    self.sortId = LotteryActivityData.ESortID.Card
  elseif LotteryProxy.IsHeadLottery(self.lotteryType) then
    self.sortId = LotteryActivityData.ESortID.Head
  elseif LotteryProxy.IsMixLottery(self.lotteryType) then
    self.sortId = LotteryActivityData.ESortID.Mix
  elseif LotteryProxy.IsMagicLottery(self.lotteryType) then
    self.sortId = LotteryActivityData.ESortID.Magic
  elseif LotteryProxy.IsSpaceTimeLottery(self.lotteryType) then
    self.sortId = LotteryActivityData.ESortID.SpaceTime
  end
end
