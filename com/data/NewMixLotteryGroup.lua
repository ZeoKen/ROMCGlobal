NewMixLotteryGroup = class("NewMixLotteryGroup")

function NewMixLotteryGroup:ctor(group, data, weight)
  self.group = group
  self.configName = data.Name
  if group == 0 then
    return
  end
  self.ungetCount = 0
  self.price = data.Price
  self.rate = data.Weight / weight / 10000
  self.types = data.Type
  self.typeMap = {}
  if self.types then
    for i = 1, #self.types do
      self.typeMap[self.types[i]] = 1
    end
  end
end

function NewMixLotteryGroup:UpdateUngetCnt(c)
  self.ungetCount = c
end

function NewMixLotteryGroup:AllGet()
  return self.ungetCount == 0
end

function NewMixLotteryGroup:GetConfigName()
  return self.configName
end

function NewMixLotteryGroup:SetRate(rate)
  self.rate = rate
end

function NewMixLotteryGroup:GetRate()
  return self.rate
end

function NewMixLotteryGroup:MatchType(t)
  return nil ~= self.typeMap and nil ~= self.typeMap[t]
end
