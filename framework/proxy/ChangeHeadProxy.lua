autoImport("ChangeHeadData")
ChangeHeadProxy = class("ChangeHeadProxy", pm.Proxy)
ChangeHeadProxy.Instance = nil
ChangeHeadProxy.NAME = "ChangeHeadProxy"

function ChangeHeadProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ChangeHeadProxy.NAME
  if ChangeHeadProxy.Instance == nil then
    ChangeHeadProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function ChangeHeadProxy:Init()
  self.portraitList = {}
  self.frameList = {}
  self.backgroundList = {}
  self.chatframeList = {}
end

function ChangeHeadProxy:RecvQueryPortraitList(data)
  self:SyncChangeAvatarData(self.portraitList, ChangeHeadData.HeadCellType.Avatar, data)
end

function ChangeHeadProxy:RecvUpdatePortraitFrame(data)
  self:SyncChangeAvatarData(self.portraitList, ChangeHeadData.HeadCellType.Avatar, data)
end

function ChangeHeadProxy:RecvSyncAllPhotoFrame(data)
  self:SyncChangeHeadData(self.frameList, ChangeHeadData.HeadCellType.Portrait, data)
end

function ChangeHeadProxy:RecvSyncAllBackgroundFrame(data)
  self:SyncChangeHeadData(self.backgroundList, ChangeHeadData.HeadCellType.Frame, data)
end

function ChangeHeadProxy:RecvSyncUnlockChatFrame(data)
  self:SyncChangeHeadData(self.chatframeList, ChangeHeadData.HeadCellType.ChatFrame, data)
end

function ChangeHeadProxy:SyncChangeHeadData(list, type, data)
  if data.ids then
    for i = 1, #data.ids do
      local info = data.ids[i]
      local id = info.id
      if info.del then
        list[id] = nil
      else
        local changeHeadData = list[id]
        if not changeHeadData then
          changeHeadData = ChangeHeadData.new(id)
          list[id] = changeHeadData
        end
        changeHeadData:SetType(type)
        changeHeadData:SetEndTime(info.endtime)
      end
    end
  end
end

function ChangeHeadProxy:SetChooseData(type, isChoose, chooseData)
  local targetList
  if type == ChangeHeadData.HeadCellType.Avatar then
    targetList = self.portraitList
  elseif type == ChangeHeadData.HeadCellType.Portrait then
    targetList = self.frameList
  elseif type == ChangeHeadData.HeadCellType.Frame then
    targetList = self.backgroundList
  elseif type == ChangeHeadData.HeadCellType.ChatFrame then
    targetList = self.chatframeList
  end
  for id, headData in pairs(targetList) do
    if headData.id == chooseData then
      headData:SetChoose(true)
    else
      headData:SetChoose(false)
    end
  end
end

function ChangeHeadProxy:SyncChangeAvatarData(list, type, data)
  if data.portraits then
    for i = 1, #data.portraits do
      local info = data.portraits[i]
      local id = info.id
      if info.del then
        list[id] = nil
      else
        local changeHeadData = list[id]
        if not changeHeadData then
          changeHeadData = ChangeHeadData.new(id)
          list[id] = changeHeadData
        end
        changeHeadData:SetType(type)
        changeHeadData:SetEndTime(info.endtime)
      end
    end
  end
end

function ChangeHeadProxy:RecvUnlockPhotoFrame(data)
  if data.del then
    for i = #self.frameList, 1, -1 do
      if data.id == self.frameList[i].id then
        table.remove(self.frameList, i)
      end
    end
  else
    if #self.frameList == 0 then
      local empty = ChangeHeadData.new(0)
      empty:SetType(ChangeHeadData.HeadCellType.Portrait)
      TableUtility.ArrayPushBack(self.frameList, empty)
    end
    local changeHeadData = ChangeHeadData.new(data.id)
    changeHeadData:SetType(ChangeHeadData.HeadCellType.Portrait)
    TableUtility.ArrayPushBack(self.frameList, changeHeadData)
  end
end

function ChangeHeadProxy:RecvUnlockBackgroundFrame(data)
  if data.del then
    for i = #self.backgroundList, 1, -1 do
      if data.id == self.backgroundList[i].id then
        table.remove(self.backgroundList, i)
      end
    end
  else
    if #self.backgroundList == 0 then
      local empty = ChangeHeadData.new(0)
      empty:SetType(ChangeHeadData.HeadCellType.Frame)
      TableUtility.ArrayPushBack(self.backgroundList, empty)
    end
    local changeHeadData = ChangeHeadData.new(data.id)
    changeHeadData:SetType(ChangeHeadData.HeadCellType.Frame)
    TableUtility.ArrayPushBack(self.backgroundList, changeHeadData)
  end
end

function ChangeHeadProxy:GetListDatas(type, map)
  local result = {}
  local empty = ChangeHeadData.new(0)
  empty:SetType(type)
  TableUtility.ArrayPushBack(result, empty)
  for _, data in pairs(map) do
    TableUtility.ArrayPushBack(result, data)
  end
  return result
end

function ChangeHeadProxy:GetFrameList()
  return self:GetListDatas(ChangeHeadData.HeadCellType.Portrait, self.frameList)
end

function ChangeHeadProxy:GetBackgroundList()
  return self:GetListDatas(ChangeHeadData.HeadCellType.Frame, self.backgroundList)
end

function ChangeHeadProxy:GetChatframeList()
  return self:GetListDatas(ChangeHeadData.HeadCellType.ChatFrame, self.chatframeList)
end

function ChangeHeadProxy:GetPortraitList()
  return self:GetListDatas(ChangeHeadData.HeadCellType.Avatar, self.portraitList)
end
