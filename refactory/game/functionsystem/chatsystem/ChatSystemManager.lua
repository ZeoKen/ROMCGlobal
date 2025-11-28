ChatSystemManager = class("ChatSystemManager")
local NotifyInterval = 0.5

function ChatSystemManager:ctor()
end

function ChatSystemManager:CheckChatContent(content)
  if content == "/memo" then
    helplog("存储临时储存点")
    ServiceUserEventProxy.Instance:CallSystemStringUserEvent(UserEvent_pb.ESYSTEMSTRING_MEMO)
    return true
  end
  return false
end

function ChatSystemManager:CheckCanDestroy(datas)
  for i = #datas, 1, -1 do
    if datas[i]:CanDestroy() then
      if datas[i].__cname ~= "RecruitTeamData" then
        ReusableObject.Destroy(datas[i])
      end
      table.remove(datas, i)
    end
  end
end

function ChatSystemManager:AddNotifyChat(channel)
  self.dirtyChannel = channel
end

function ChatSystemManager:Update(time, deltaTime)
  if self.dirtyChannel == nil then
    return
  end
  if self.notifyTime ~= nil and time < self.notifyTime then
    return
  end
  self.notifyTime = time + NotifyInterval
  local data = ChatRoomProxy.Instance:GetMessagesByChannel(self.dirtyChannel) or ChatZoomProxy.Instance:Message()
  if data then
    local length = #data
    if 0 < length then
      GameFacade.Instance:sendNotification(ServiceEvent.ChatCmdChatRetCmd, data[length])
    end
  end
  self.dirtyChannel = nil
end
