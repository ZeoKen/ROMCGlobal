LotteryInfoData = class("LotteryInfoData")

function LotteryInfoData:ctor(data)
  self.itemList = {}
  self:SetData(data)
end

function LotteryInfoData:SetData(data)
  if data then
    self.lotteryType = data.type
    self.npcId = data.npcid
    self.ticket = data.ticket
    self.count = data.count
    self.guid = data.guid
    TableUtility.ArrayClear(self.itemList)
    local items = data.items
    for i = 1, #items do
      local itemData = ItemData.new(items[i].guid, items[i].id)
      itemData:SetItemNum(items[i].count)
      self.itemList[#self.itemList + 1] = itemData
    end
    self.year = data.year
    self.month = data.month
  end
end

function LotteryInfoData:IsCoin()
  return self.ticket == 0 and self.guid == ""
end
