autoImport("ItemData")
WeeklyTaskData = class("WeeklyTaskData")

function WeeklyTaskData:ctor(id)
  self.id = id
  self.staticData = Table_TwelvePvpTask[id]
  self.progress = 0
  self.received = false
  self.items = {}
end

function WeeklyTaskData:AddItemData(itemid, itemnum)
  local itemdata = ItemData.new("WeeklyTaskData", itemid)
  itemdata:SetItemNum(itemnum)
  self.items[#self.items + 1] = itemdata
end

function WeeklyTaskData:SetProgress(progress)
  self.progress = progress or 0
end

function WeeklyTaskData:SetStatus(received)
  self.received = received
end

function WeeklyTaskData:Reset()
  self.progress = 0
  self.received = false
end
