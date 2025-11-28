DonateMatData = class("DonateMatData")

function DonateMatData:ctor(cfgData)
  self.materials = {}
  self.id = cfgData.id
  self.day = cfgData.Days
  if #cfgData.RewardItem > 1 and 1 < #cfgData.Require then
    self.materials.id = cfgData.Require[1]
    self.materials.count = cfgData.Require[2]
    self.rewardData = cfgData.RewardItem
  end
end
