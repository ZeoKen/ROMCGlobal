autoImport("PaySignConfig")
PaySignGlobalActData = class("PaySignGlobalActData")

function PaySignGlobalActData:ctor(data)
  self.id = data.id
  self.configData = PaySignConfig.new(data.id)
  self.isNoviceMode = self.configData:IsNoviceMode()
  self.open = data.open
  self.starttime = data.starttime
  self.endtime = data.endtime
  self.type = data.type
  if nil == data.params or 1 ~= #data.params then
    redlog("付费签到开启时间未配置，globalActivityID : ", data.id)
    return
  end
  self.lotteryTime = data.params[1]
end

function PaySignGlobalActData:IsActTimeValid()
  if not self.isNoviceMode then
    local curTime = ServerTime.CurServerTime() / 1000
    return self.open and curTime > self.starttime and curTime < self.endtime
  else
    return self:CheckNoviceModeStart()
  end
end

function PaySignGlobalActData:IsLotteryTimeValid()
  local curTime = ServerTime.CurServerTime() / 1000
  if not self.isNoviceMode then
    return self.open and curTime > self.starttime and curTime < self.lotteryTime
  else
    return self.open and self:CheckNoviceModeStart() and self.noviceBuyTime == 0 and curTime > self.noviceStartTime and curTime < self.noviceBuyEndTime
  end
end

function PaySignGlobalActData:SetNoviceMode(st, bt)
  if not self.isNoviceMode then
    return
  end
  self.noviceStartTime = st
  self.noviceBuyEndTime = st + self.lotteryTime
  self.noviceBuyTime = bt or 0
end

function PaySignGlobalActData:CheckNoviceModeStart()
  return self.noviceStartTime and self.noviceStartTime > 0
end
