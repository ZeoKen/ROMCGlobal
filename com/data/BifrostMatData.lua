local SingleBifrostMatData = class("SingleBifrostMatData")

function SingleBifrostMatData:ctor()
  self.materials = {}
end

function SingleBifrostMatData:SetBifrostMatData(cfgData, index)
  self.id = index
  if #cfgData.ContributeItem > 0 and 0 < #cfgData.RewardItem and 1 < #cfgData.ContributeItem[1] then
    self.materials.id = cfgData.ContributeItem[1][1]
    self.materials.count = cfgData.ContributeItem[1][2]
    self.rewardData = cfgData.RewardItem[1]
  end
end

BifrostMatData = class("BifrostMatData")

function BifrostMatData:ctor(id, cfgData)
  self.uiMatData = {}
  if cfgData then
    for i = 1, #cfgData do
      local mData = SingleBifrostMatData.new()
      mData:SetBifrostMatData(cfgData[i], i)
      self.uiMatData[#self.uiMatData + 1] = mData
    end
  end
end
