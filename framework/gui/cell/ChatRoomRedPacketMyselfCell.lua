ChatRoomRedPacketMyselfCell = reusableClass("ChatRoomRedPacketMyselfCell", ChatRoomMySelfCell)
ChatRoomRedPacketMyselfCell.rid = ResourcePathHelper.UICell("ChatRoomRedPacketMyselfCell")
local pos = LuaVector3.Zero()

function ChatRoomRedPacketMyselfCell:FindObjs()
  ChatRoomRedPacketMyselfCell.super.FindObjs(self)
  self.redPacketIcon = self:FindComponent("itemIcon", UISprite)
end

function ChatRoomRedPacketMyselfCell:AddEvts()
  ChatRoomRedPacketMyselfCell.super.AddEvts(self)
  self:AddClickEvent(self.contentSprite, function()
    self:OnChatMessageClick()
  end)
end

function ChatRoomRedPacketMyselfCell:CreateSelf(parent)
  if parent then
    self.gameObject = self:CreateObj(ChatRoomRedPacketMyselfCell.rid, parent)
  end
end

function ChatRoomRedPacketMyselfCell:InitShow()
  ChatRoomRedPacketMyselfCell.super.InitShow(self)
  self.contentWidth = 220
  self.chatContent.width = self.contentWidth
end

function ChatRoomRedPacketMyselfCell:SetData(data)
  ChatRoomRedPacketMyselfCell.super.SetData(self, data)
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
  LuaVector3.Better_Set(pos, -self.contentSpriteBg.width - 27, -15, 0)
  self.bgDecorate1_Icon.transform.localPosition = pos
  LuaVector3.Better_Set(pos, -self.contentSpriteBg.width - 25, -self.contentSpriteBg.height - 14, 0)
  self.bgDecorate2_Icon.transform.localPosition = pos
  LuaVector3.Better_Set(pos, 23, -self.contentSpriteBg.height - 10, 0)
  self.bgDecorate3_Icon.transform.localPosition = pos
  self.senderId = data:GetAccId()
  self.senderName = data:GetName()
end

function ChatRoomRedPacketMyselfCell:OnChatMessageClick()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.RedPacketView,
    viewdata = {
      redPacketId = self.redPacketId,
      senderId = self.senderId,
      senderName = self.senderName
    }
  })
end
