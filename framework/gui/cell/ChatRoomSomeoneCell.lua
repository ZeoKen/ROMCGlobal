autoImport("ChatRoomCell")
ChatRoomSomeoneCell = reusableClass("ChatRoomSomeoneCell", ChatRoomCell)
ChatRoomSomeoneCell.rid = ResourcePathHelper.UICell("ChatRoomSomeoneCell")
local pos = LuaVector3.zero

function ChatRoomSomeoneCell:Deconstruct()
  self.bgIndex = nil
  self.isTeam = false
  ChatRoomSomeoneCell.super.Deconstruct(self)
end

function ChatRoomSomeoneCell:CreateSelf(parent)
  if parent then
    self.gameObject = self:CreateObj(ChatRoomSomeoneCell.rid, parent)
  end
end

function ChatRoomSomeoneCell:FindObjs()
  ChatRoomSomeoneCell.super.FindObjs(self)
  self.zoneGO = self:FindGO("Zone")
  self.zone = self.zoneGO:GetComponent(UILabel)
  self.bg = self:FindGO("contentSpriteBg"):GetComponent(UITexture)
end

function ChatRoomSomeoneCell:SetData(data)
  ChatRoomSomeoneCell.super.SetData(self, data)
  if data ~= nil then
    local serverid = data:GetServerId()
    if serverid and serverid ~= MyselfProxy.Instance:GetServerId() then
      self.zoneGO:SetActive(true)
      self.zone.text = data:GetServerId()
    else
      self.zoneGO:SetActive(false)
    end
    self:_SetBg(data)
    if self.returnSymbol.activeSelf and data:IsReturnUser() then
      LuaVector3.Better_Set(pos, LuaGameObject.GetLocalPosition(self.adventureTrans))
      pos[1] = pos.x + self.adventure.printedSize.x + 26
      self.nameTrans.localPosition = pos
    else
      LuaVector3.Better_Set(pos, LuaGameObject.GetLocalPosition(self.adventureTrans))
      pos[1] = pos.x + self.adventure.printedSize.x + 5
      self.nameTrans.localPosition = pos
    end
  end
end

function ChatRoomSomeoneCell:_SetBg(data)
  local chatframeId = data:GetChatframeId()
  if not chatframeId or chatframeId == 0 then
    local isTeam = data:IsTeamGroup()
    if self.bgIndex or self.isTeam ~= isTeam then
      for i = 1, 4 do
        self["bgDecorate" .. i .. "_Icon"].gameObject:SetActive(false)
      end
      local bg = self.bg
      local spriteName = isTeam and "chatroom_bg_2" or "chatroom_bg_1"
      PictureManager.Instance:SetChatRoomTexture(spriteName, bg)
      self.isTeam = isTeam
      self.bgIndex = nil
    end
    self.chatContent.color = LuaColor.black
  else
    if not self.bgIndex or self.bgIndex ~= chatframeId then
      local config = Table_UserChatFrame[chatframeId]
      if config then
        local decorateNameRoot = config.IconName
        for i = 1, 4 do
          self["bgDecorate" .. i .. "_Icon"].gameObject:SetActive(true)
          PictureManager.Instance:SetChatRoomTexture(decorateNameRoot .. "_" .. i, self["bgDecorate" .. i .. "_Icon"])
          self["bgDecorate" .. i .. "_Icon"]:MakePixelPerfect()
        end
        local bg = self.bg
        PictureManager.Instance:SetChatRoomTexture(config.BubbleName, bg)
        self.bgIndex = chatframeId
        if config.TextColor and config.TextColor ~= "" then
          local _, color = ColorUtil.TryParseHtmlString(config.TextColor)
          self.chatContent.color = color
        else
          self.chatContent.color = LuaColor.black
        end
      end
    end
    self.contentSpriteBg.width = self.contentSpriteBg.width + 2
    LuaVector3.Better_Set(pos, self.contentSpriteBg.width + 27, -15, 0)
    self.bgDecorate1_Icon.transform.localPosition = pos
    LuaVector3.Better_Set(pos, self.contentSpriteBg.width + 25, -self.contentSpriteBg.height - 14, 0)
    self.bgDecorate2_Icon.transform.localPosition = pos
    LuaVector3.Better_Set(pos, -23, -self.contentSpriteBg.height - 10, 0)
    self.bgDecorate3_Icon.transform.localPosition = pos
  end
end
