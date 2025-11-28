AERewardItemData = class("AERewardItemData")

function AERewardItemData:ctor(data)
  self:SetData(data)
end

function AERewardItemData:SetData(data)
  if data ~= nil then
    self.multipledaycount = data.multipledaycount
    self.multipleacclimitcharid = data.multipleacclimitcharid
    self.extradaycount = data.daycount
    self.extradaylimitfunc = data.extraacclimitfunc
    self.acclimitcharid = data.acclimitcharid
  end
end

function AERewardItemData:GetMultipleDayCount()
  return self.multipledaycount
end

function AERewardItemData:GetMultipleAcclimitCharid()
  return self.multipleacclimitcharid
end

function AERewardItemData:GetExtraDayCount()
  return self.extradaycount
end

function AERewardItemData:GetExtraAccDayLimitFunc()
  return self.extradaylimitfunc
end

function AERewardItemData:GetAccLimitCharID()
  return self.acclimitcharid
end
