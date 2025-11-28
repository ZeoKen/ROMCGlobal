autoImport("ChatRoomCell")
ChatRoomMySelfCell = reusableClass("ChatRoomMySelfCell", ChatRoomCell)
ChatRoomMySelfCell.rid = ResourcePathHelper.UICell("ChatRoomMySelfCell")
local pos = LuaVector3.Zero()

function ChatRoomMySelfCell:CreateSelf(parent)
  if parent then
    self.gameObject = self:CreateObj(ChatRoomMySelfCell.rid, parent)
  end
  self.chatframeId = nil
end

function ChatRoomMySelfCell:SetData(data)
  ChatRoomMySelfCell.super.SetData(self, data)
  if self.returnSymbol.activeSelf and data:IsReturnUser() then
    LuaVector3.Better_Set(pos, LuaGameObject.GetLocalPosition(self.adventureTrans))
    pos[1] = pos.x - self.adventure.printedSize.x - 30
    self.nameTrans.localPosition = pos
  else
    LuaVector3.Better_Set(pos, LuaGameObject.GetLocalPosition(self.adventureTrans))
    pos[1] = pos.x - self.adventure.printedSize.x - 5
    self.nameTrans.localPosition = pos
  end
  local chatframeId = data:GetChatframeId()
  if chatframeId and chatframeId ~= 0 then
    if self.chatframeId ~= chatframeId then
      local config = Table_UserChatFrame[chatframeId]
      if config then
        self.contentSpriteBg.flip = 1
        PictureManager.Instance:SetChatRoomTexture(config.BubbleName, self.contentSpriteBg)
        local decorateNameRoot = config.IconName
        for i = 1, 4 do
          self["bgDecorate" .. i .. "_Icon"].gameObject:SetActive(true)
          PictureManager.Instance:SetChatRoomTexture(decorateNameRoot .. "_" .. i, self["bgDecorate" .. i .. "_Icon"])
          self["bgDecorate" .. i .. "_Icon"]:MakePixelPerfect()
        end
        self.chatframeId = chatframeId
        if config.TextColor and config.TextColor ~= "" then
          local _, color = ColorUtil.TryParseHtmlString(config.TextColor)
          self.chatContent.color = color
        else
          self.chatContent.color = LuaColor.black
        end
      end
    end
    LuaVector3.Better_Set(pos, -self.contentSpriteBg.width - 27, -15, 0)
    self.bgDecorate1_Icon.transform.localPosition = pos
    LuaVector3.Better_Set(pos, -self.contentSpriteBg.width - 25, -self.contentSpriteBg.height - 14, 0)
    self.bgDecorate2_Icon.transform.localPosition = pos
    LuaVector3.Better_Set(pos, 23, -self.contentSpriteBg.height - 10, 0)
    self.bgDecorate3_Icon.transform.localPosition = pos
  else
    for i = 1, 4 do
      self["bgDecorate" .. i .. "_Icon"].gameObject:SetActive(false)
    end
    self.contentSpriteBg.flip = 1
    PictureManager.Instance:SetChatRoomTexture("new-chatroom_bg_2", self.contentSpriteBg)
    self.chatContent.color = LuaColor.black
    self.chatframeId = nil
  end
end
