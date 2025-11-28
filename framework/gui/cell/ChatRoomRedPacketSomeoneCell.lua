ChatRoomRedPacketSomeoneCell = reusableClass("ChatRoomRedPacketSomeoneCell", ChatRoomSomeoneCell)
ChatRoomRedPacketSomeoneCell.rid = ResourcePathHelper.UICell("ChatRoomRedPacketSomeoneCell")
local pos = LuaVector3.zero

function ChatRoomRedPacketSomeoneCell:FindObjs()
  ChatRoomRedPacketSomeoneCell.super.FindObjs(self)
  self.redPacketIcon = self:FindComponent("itemIcon", UISprite)
end

function ChatRoomRedPacketSomeoneCell:AddEvts()
  ChatRoomRedPacketSomeoneCell.super.AddEvts(self)
  self:AddClickEvent(self.contentSprite, function()
    self:OnChatMessageClick()
  end)
end

function ChatRoomRedPacketSomeoneCell:CreateSelf(parent)
  if parent then
    self.gameObject = self:CreateObj(ChatRoomRedPacketSomeoneCell.rid, parent)
  end
end

function ChatRoomRedPacketSomeoneCell:InitShow()
  ChatRoomRedPacketSomeoneCell.super.InitShow(self)
  self.contentWidth = 220
  self.chatContent.width = self.contentWidth
end

function ChatRoomRedPacketSomeoneCell:SetData(data)
  ChatRoomRedPacketSomeoneCell.super.SetData(self, data)
  self.redPacketId = data:GetRedPacketGUID()
  local redPacketIcon = data:GetRedPacketIcon()
  if redPacketIcon then
    IconManager:SetItemIcon(redPacketIcon, self.redPacketIcon)
    if RedPacketProxy.Instance:IsRedPacketContentExist(self.redPacketId) then
      self.redPacketIcon.alpha = 0.5
    else
      self.redPacketIcon.alpha = 1
    end
  end
  local bgWidth = self.contentSpriteBg.width
  self.contentSpriteBg.width = bgWidth + self.redPacketIcon.width
  self.senderId = data:GetAccId()
  self.senderName = data:GetName()
  local chatframeId = data:GetChatframeId()
  if chatframeId ~= 0 then
    self.contentSpriteBg.width = self.contentSpriteBg.width + 2
    LuaVector3.Better_Set(pos, self.contentSpriteBg.width + 27, -15, 0)
    self.bgDecorate1_Icon.transform.localPosition = pos
    LuaVector3.Better_Set(pos, self.contentSpriteBg.width + 25, -self.contentSpriteBg.height - 14, 0)
    self.bgDecorate2_Icon.transform.localPosition = pos
    LuaVector3.Better_Set(pos, -23, -self.contentSpriteBg.height - 10, 0)
    self.bgDecorate3_Icon.transform.localPosition = pos
  end
end

function ChatRoomRedPacketSomeoneCell:OnChatMessageClick()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.RedPacketView,
    viewdata = {
      redPacketId = self.redPacketId,
      senderId = self.senderId,
      senderName = self.senderName
    }
  })
end
