LotteryExtraBonusData = class("LotteryExtraBonusData")

function LotteryExtraBonusData:ctor(serverconfig, lotterytype)
  self.configmap = {}
  self.keylist = {}
  self.lotterytype = lotterytype
  self:SetData(serverconfig)
end

function LotteryExtraBonusData:SetData(data)
  if not data then
    return
  end
  local entry, single
  for i = 1, #data do
    single = data[i]
    self.configmap[single.lotterycount] = {}
    table.insert(self.keylist, single.lotterycount)
    if single.items then
      for j = 1, #single.items do
        entry = single.items[j]
        table.insert(self.configmap[single.lotterycount], {
          itemid = entry.id,
          count = entry.count
        })
      end
    end
  end
  table.sort(self.keylist)
end

function LotteryExtraBonusData:GetCurrentStage(received)
  if self.configmap and self.keylist then
    if received == 0 then
      return self.keylist[1], 1
    end
    for k, v in pairs(self.keylist) do
      if received < v then
        return v, k
      end
    end
  end
end

function LotteryExtraBonusData:GetDataList()
  local datalist, single = {}
  for i = 1, #self.keylist do
    single = {}
    single.key = self.keylist[i]
    single.itemids = self.configmap[single.key]
    single.lotterytype = self.lotterytype
    table.insert(datalist, single)
  end
  table.sort(datalist, function(a, b)
    return a.key < b.key
  end)
  return datalist
end

function LotteryExtraBonusData:GetMaxCount()
  return self.keylist[#self.keylist]
end

function LotteryExtraBonusData:GetKeyList()
  return self.keylist
end

function LotteryExtraBonusData:GetItemCount(lotterycount, itemid)
  return self.countMap[lotterycount][itemid]
end
