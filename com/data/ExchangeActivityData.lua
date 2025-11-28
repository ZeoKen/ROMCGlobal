autoImport("ExchangeGiftData")
ExchangeActivityData = class("ExchangeActivityData")

function ExchangeActivityData:ctor(serverdata)
  self.activityid = serverdata.activityid
  self.times = serverdata.times
  self.materials = {}
  if serverdata.gifts_info then
    for i = 1, #serverdata.gifts_info do
      local itemInfo = ExchangeGiftData.new(serverdata.gifts_info[i])
      table.insert(self.materials, itemInfo)
    end
  end
  redlog("ExchangeActivityData====1", self.activityid, self.times, self.materials and #self.materials)
end

function ExchangeActivityData:GetTimes()
  return self.times
end

function ExchangeActivityData:GetMaterials()
  table.sort(self.materials, function(a, b)
    if a.quality == b.quality then
      return a.require_item.id < b.require_item.id
    else
      return a.quality > b.quality
    end
  end)
  return self.materials
end
