autoImport("ChatRoomMySelfCell")
autoImport("ChatRoomSomeoneCell")
autoImport("ChatRoomSystemCell")
autoImport("ChatRoomRedPacketMyselfCell")
autoImport("ChatRoomRedPacketSomeoneCell")
autoImport("ChatRoomMyselfRecruitCell")
autoImport("ChatRoomSomeoneRecruitCell")
local baseCell = autoImport("BaseCell")
ChatRoomCombineCell = class("ChatRoomCombineCell", baseCell)

function ChatRoomCombineCell:Init()
  self:InitShow()
end

function ChatRoomCombineCell:InitShow()
  self.controlMap = {}
  self.controlMap[ChatTypeEnum.MySelfMessage] = ChatRoomMySelfCell
  self.controlMap[ChatTypeEnum.SomeoneMessage] = ChatRoomSomeoneCell
  self.controlMap[ChatTypeEnum.SystemMessage] = ChatRoomSystemCell
  self.controlMap[ChatTypeEnum.MyselfRedPacket] = ChatRoomRedPacketMyselfCell
  self.controlMap[ChatTypeEnum.SomeoneRedPacket] = ChatRoomRedPacketSomeoneCell
  self.controlMap[ChatTypeEnum.MyselfRecruit] = ChatRoomMyselfRecruitCell
  self.controlMap[ChatTypeEnum.SomeoneRecruit] = ChatRoomSomeoneRecruitCell
  self.cellMap = {}
  self.eventMap = {}
end

function ChatRoomCombineCell:SetData(data)
  self.data = data
  if data then
    local type = data:GetCellType()
    local control = self.controlMap[type]
    if control then
      if self.cellMap[type] == nil then
        self.cellMap[type] = control.CreateAsTable(self.gameObject)
        for eventType, eventHandler in pairs(self.eventMap) do
          self.cellMap[type]:AddEventListener(eventType, eventHandler.handler, eventHandler.owner)
        end
      end
      local cell = self.cellMap[type]
      cell:SetData(data)
      if self.lastCell and self.lastCell ~= cell then
        self.lastCell.gameObject:SetActive(false)
      end
      self.lastCell = cell
    end
  else
    for k, v in pairs(self.cellMap) do
      v.gameObject:SetActive(false)
    end
    self.lastCell = nil
  end
end

function ChatRoomCombineCell:CheckMoveToFirst()
  if self.lastCell then
    return self.lastCell.top.isVisible or false
  end
end

function ChatRoomCombineCell:AddEventListener(eventType, handler, handlerOwner)
  local eventHandler = self.eventMap[eventType]
  if not eventHandler then
    eventHandler = {}
    self.eventMap[eventType] = eventHandler
  end
  eventHandler.handler = handler
  eventHandler.owner = handlerOwner
end

function ChatRoomCombineCell:GetCurrentCell()
  return self.lastCell
end
