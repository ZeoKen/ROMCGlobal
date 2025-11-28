MessageBoardProxy = class("MessageBoardProxy", pm.Proxy)
MessageBoardProxy.Instance = nil
MessageBoardProxy.NAME = "MessageBoardProxy"

function MessageBoardProxy:ctor(proxyName, data)
  self.proxyName = proxyName or MessageBoardProxy.NAME
  if MessageBoardProxy.Instance == nil then
    MessageBoardProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function MessageBoardProxy:Init()
  self.MessageTipList = {}
  self.GuestTraceList = {}
  self.totalMessageNum = 0
  self.totalMessageNum = 0
end

function MessageBoardProxy:RecvBoardItemQueryHomeCmd(data)
  self:SetMessageTipList(data.items)
  self:SetMessageCount(data.totalcount)
  self:SetPageNum(data.page)
  self:SetValidStatus(data.available)
end

function MessageBoardProxy:SetMessageTipList(items)
  if items then
    helplog(#items)
    for i = 1, #items do
      self:AddOrUpdateMessageTipItem(items[i])
    end
  end
end

function MessageBoardProxy:AddOrUpdateMessageTipItem(item)
  if item then
    local time = item.time
    local messageItem = self.MessageTipList[time]
    if not messageItem then
      messageItem = {}
      messageItem.time = item.time
      messageItem.items = {}
      for i = 1, #item.items do
        local single = item.items[i]
        messageItem.items[#messageItem.items + 1] = single
      end
      self.MessageTipList[time] = messageItem
    else
      messageItem.items = item.items
    end
  end
end

function MessageBoardProxy:UpdateTips(serverData)
  helplog("UpdateTips", serverData.time, #serverData.updates)
  local time = serverData.time
  local items = serverData.updates
  if self.MessageTipList[time] then
    helplog(self.MessageTipList[time].items)
    for i = 1, #items do
      local single = items[i]
      self.MessageTipList[time].items[#self.MessageTipList[time].items + 1] = single
    end
  else
    redlog("列表中time时间戳不存在！")
  end
end

function MessageBoardProxy:DelectMessageTip(keys)
  if keys and 0 < #keys then
    for i = 1, #keys do
      local time = keys[i]
      self.MessageTipList[time] = nil
    end
  end
end

function MessageBoardProxy:ClearMessageTipItems()
  TableUtility.TableClear(self.MessageTipList)
end

function MessageBoardProxy:GetMessageTipList()
  if self.MessageTipList then
    local result = {}
    for _, item in pairs(self.MessageTipList) do
      table.insert(result, item)
    end
    table.sort(result, MessageBoardProxy.ReverseSortListByTime)
    return result
  end
end

function MessageBoardProxy.SortListByTime(a, b)
  if a.time ~= b.time then
    return a.time < b.time
  end
  return a.time < b.time
end

function MessageBoardProxy.ReverseSortListByTime(a, b)
  if a.time ~= b.time then
    return a.time > b.time
  end
  return a.time > b.time
end

function MessageBoardProxy:SetGuestTraceList(events)
  if events then
    for i = 1, #events do
      self:UpdateGuestTraceList(events[i])
    end
  end
end

function MessageBoardProxy:SetMessageCount(count)
  self.totalMessageNum = count
end

function MessageBoardProxy:GetMessageCount(count)
  return self.totalMessageNum
end

function MessageBoardProxy:SetPageNum(num)
  self.pageNum = num
end

function MessageBoardProxy:GetPageNum(count)
  return self.pageNum
end

function MessageBoardProxy:EditMessages(item)
end

function MessageBoardProxy:SetValidStatus(available)
  redlog("SetValidStatus", available)
  self.messageBoardValid = available
end

function MessageBoardProxy:GetValidStatus()
  return self.messageBoardValid
end

function MessageBoardProxy:UpdateGuestTraceList2(event)
  if event then
    local time = event.time
    local guestTraceItem = self.GuestTraceList[time]
    if not guestTraceItem then
      guestTraceItem = {}
      guestTraceItem.items = event.items
      guestTraceItem.time = event.time
      self.GuestTraceList[time] = guestTraceItem
    end
  end
end

function MessageBoardProxy:UpdateGuestTraceList(event)
  if event then
    local time = event.time
    local year = os.date("%Y", time)
    local month = os.date("%m", time)
    local day = os.date("%d", time)
    local combine = os.date("%Y-%m-%d", time)
    local dateItem = self.GuestTraceList[combine]
    if not dateItem then
      dateItem = {}
      dateItem.time = combine
      dateItem.dataList = {}
      dateItem.dataList[#dateItem.dataList + 1] = event
      self.GuestTraceList[combine] = dateItem
    else
      table.insert(dateItem.dataList, event)
    end
  end
end

function MessageBoardProxy:RemoveGuestTraceList()
  self.GuestTraceList = {}
end

function MessageBoardProxy:GetGuestTraceList()
  if self.GuestTraceList then
    local result = {}
    for _, item in pairs(self.GuestTraceList) do
      table.insert(result, item)
    end
    table.sort(result, MessageBoardProxy.SortListByTime)
    helplog("GetGuestTraceList,Length is ", #result)
    return result
  end
end

function MessageBoardProxy:SetListTags()
  if self.GuestTraceList then
    local result = {}
    for _, item in pairs(self.GuestTraceList) do
      local tempDay = os.date("%d", item.time)
      helplog(tempDay)
      if not result[tempDay] then
        table.insert(result, tempDay)
      end
      return result
    end
  end
end

function MessageBoardProxy:GetGuestTraceListByTime(time)
  if self.GuestTraceList and self.GuestTraceList[time] then
    return self.GuestTraceList[time]
  end
end

function MessageBoardProxy:SetTracePageInfo(serverData)
  self.curPage = serverData.page
  self.totalCount = serverData.totalcount
  self.visitCount = serverData.visitcount
  self.dayVisitCount = serverData.dayvisitcount
  helplog("SetTracePageInfo:", self.curPage, self.totalCount, self.visitCount, self.dayVisitCount)
end

function MessageBoardProxy:GetTracePageInfo()
end
