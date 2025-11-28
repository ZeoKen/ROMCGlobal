CurrentRecommendActivityData = class("CurrentRecommendActivityData")
autoImport("ActivityOverviewDetailData")

function CurrentRecommendActivityData:ctor(actData)
  self.name = nil
  self.photourl = nil
  self.items = {}
  self:SetData(actData)
end

function CurrentRecommendActivityData:SetData(actData)
  self.name = actData.name
  local aeurl = actData.photourls
  self.photourl = aeurl.url
  TableUtility.ArrayClear(self.items)
  local items = actData.items
  if items and 0 < #items then
    local singleActivities = {}
    for i = 1, #items do
      local single = items[i]
      local singleData = ActivityOverviewDetailData.new(single)
      singleActivities[#singleActivities + 1] = singleData
    end
    self.items = singleActivities
  end
  self.entrance = actData.entrance
end

function CurrentRecommendActivityData:GetActivityName()
  if self.name then
    return self.name
  else
    redlog("活动名不存在！")
  end
end

function CurrentRecommendActivityData:GetActivityPurikuraPath()
  if self.photourl then
    return self.photourl
  else
    redlog("活动图片路径不存在")
  end
end
