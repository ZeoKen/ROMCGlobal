autoImport("BaseTip")
autoImport("TeamMemberPreviewCell")
autoImport("HeadIconCell")
FramePreviewTip = class("FramePreviewTip", BaseTip)
FramePreviewEvent = {
  Close = "FramePreviewEvent_Close"
}
local pos = LuaVector3.Zero()

function FramePreviewTip:ctor(parent)
  FramePreviewTip.super.ctor(self, "FramePreviewTip", parent)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  self.closeButton = self:FindGO("CloseButton")
  self:AddClickEvent(self.closeButton, function(go)
    self:OnExit()
  end)
  self.panel = self.gameObject:GetComponent(UIPanel)
  local temp = self.gameObject.transform.parent:GetComponentInParent(UIPanel)
  if temp then
    self.panel.depth = temp.depth + 1
  end
  self.headObj = self:FindGO("HeadIconCell")
  self.headIconCell = MyHeadIconCell.new()
  self.headIconCell:CreateSelf(self.headObj)
  self.headIconCell:SetMinDepth(2)
  self.frameBgPart = self:FindGO("FrameBackgroundPart")
  self.tmObj = self:FindGO("TeamMemberPreviewCell", self.frameBgPart)
  self.tMPreviewCell = TeamMemberPreviewCell.new(self.tmObj)
  self.headframePart = self:FindGO("ChatframePart")
  self.myselfChatCell = self:FindGO("ChatRoomMySelfCell")
  self.myselfChatBG = self:FindGO("contentSpriteBg", self.myselfChatCell):GetComponent(UISprite)
  self.myselfChatBG = self:FindGO("contentSpriteBg", self.myselfChatCell):GetComponent(UITexture)
  for i = 1, 4 do
    self["myselfBgDecorate" .. i] = self:FindGO("bgDecorate" .. i, self.myselfChatCell)
    if self["myselfBgDecorate" .. i] then
      self["myselfBgDecorate" .. i .. "_Icon"] = self["myselfBgDecorate" .. i]:GetComponent(UITexture)
    end
  end
  self.myselfName = self:FindGO("name", self.myselfChatCell):GetComponent(UILabel)
  self.myselfChatContent = self:FindGO("chatContent", self.myselfChatCell):GetComponent(UILabel)
  self.myselfChatContent.text = ZhString.Chat_Hello
  self.myselfHeadObj = self:FindGO("HeadIconCell", self.myselfChatCell)
  self.myselfHeadIconCell = MyHeadIconCell.new()
  self.myselfHeadIconCell:CreateSelf(self.myselfHeadObj)
  self.myselfHeadIconCell:SetMinDepth(4)
  self.someoneChatCell = self:FindGO("ChatRoomSomeoneCell")
  self.someoneChatBG = self:FindGO("contentSpriteBg", self.someoneChatCell):GetComponent(UITexture)
  self.someoneChatContent = self:FindGO("chatContent", self.someoneChatCell):GetComponent(UILabel)
  self.someoneChatContent.text = ZhString.Chat_Hello
  for i = 1, 4 do
    self["someoneBgDecorate" .. i] = self:FindGO("bgDecorate" .. i, self.someoneChatCell)
    if self["someoneBgDecorate" .. i] then
      self["someoneBgDecorate" .. i .. "_Icon"] = self["someoneBgDecorate" .. i]:GetComponent(UITexture)
    end
  end
end

function FramePreviewTip:SetHeadIconCell(id)
  self.frameBgPart:SetActive(false)
  self.headObj:SetActive(true)
  self.headframePart:SetActive(false)
  self.headData = HeadImageData.new()
  self.headData:TransByMyself()
  if id then
    self.headData.iconData.portraitframe = id
  end
  if self.headData.iconData.type == HeadImageIconType.Avatar then
    self.headIconCell:SetData(self.headData.iconData)
  elseif self.headData.iconData.type == HeadImageIconType.Simple then
    self.headIconCell:SetSimpleIcon(self.headData.iconData.icon, self.headData.iconData.frameType)
  end
  self.headIconCell:SetPortraitFrame(id)
end

function FramePreviewTip:SetTeamMemberCell(id)
  self.frameBgPart:SetActive(true)
  self.headObj:SetActive(false)
  self.headframePart:SetActive(false)
  self.tMPreviewCell:SetData(id)
end

function FramePreviewTip:SetChatframe(id)
  self.contentWidth = 260
  self.frameBgPart:SetActive(false)
  self.headObj:SetActive(false)
  self.headframePart:SetActive(true)
  self.myselfName.text = Game.Myself.data:GetName()
  local headData = HeadImageData.new()
  headData:TransByMyself()
  if headData.iconData.type == HeadImageIconType.Avatar then
    self.myselfHeadIconCell:SetData(headData.iconData)
  elseif headData.iconData.type == HeadImageIconType.Simple then
    self.myselfHeadIconCell:SetSimpleIcon(headData.iconData.icon, headData.iconData.frameType)
  end
  local config = Table_UserChatFrame[id]
  if not config then
    redlog("Table_UserChatFrame缺少ID", id)
    return
  end
  PictureManager.Instance:SetChatRoomTexture(config.BubbleName, self.myselfChatBG)
  self.myselfChatBG.flip = 1
  PictureManager.Instance:SetChatRoomTexture(config.BubbleName, self.someoneChatBG)
  local decorateNameRoot = config.IconName
  for i = 1, 4 do
    self["myselfBgDecorate" .. i .. "_Icon"].gameObject:SetActive(true)
    PictureManager.Instance:SetChatRoomTexture(decorateNameRoot .. "_" .. i, self["myselfBgDecorate" .. i .. "_Icon"])
    self["myselfBgDecorate" .. i .. "_Icon"]:MakePixelPerfect()
  end
  for i = 1, 4 do
    self["someoneBgDecorate" .. i .. "_Icon"].gameObject:SetActive(true)
    PictureManager.Instance:SetChatRoomTexture(decorateNameRoot .. "_" .. i, self["someoneBgDecorate" .. i .. "_Icon"])
    self["someoneBgDecorate" .. i .. "_Icon"]:MakePixelPerfect()
  end
  if config.TextColor and config.TextColor ~= "" then
    local _, color = ColorUtil.TryParseHtmlString(config.TextColor)
    self.myselfChatContent.color = color
    self.someoneChatContent.color = color
  else
    self.myselfChatContent.color = LuaColor.black
    self.someoneChatContent.color = LuaColor.black
  end
  local size
  UIUtil.FitLabelHeight(self.myselfChatContent, self.contentWidth)
  size = self.myselfChatContent.localSize
  local sizeY = size.y
  if 50 < sizeY then
    pos[2] = 26
  else
    pos[2] = 0
  end
  self.myselfChatBG.height = sizeY + 25
  self.myselfChatBG.width = size.x + 47
  if self.myselfChatBG.width < 127 then
    self.myselfChatBG.width = 127
  end
  LuaVector3.Better_Set(pos, -self.myselfChatBG.width - 27, -15, 0)
  self.myselfBgDecorate1_Icon.transform.localPosition = pos
  LuaVector3.Better_Set(pos, -self.myselfChatBG.width - 25, -self.myselfChatBG.height - 14, 0)
  self.myselfBgDecorate2_Icon.transform.localPosition = pos
  LuaVector3.Better_Set(pos, 23, -self.myselfChatBG.height - 10, 0)
  self.myselfBgDecorate3_Icon.transform.localPosition = pos
  size = self.someoneChatContent.printedSize
  sizeY = size.y
  if 50 < sizeY then
    pos[2] = 26
  else
    pos[2] = 0
  end
  self.someoneChatBG.height = sizeY + 25
  self.someoneChatBG.width = size.x + 47
  if self.someoneChatBG.width < 127 then
    self.someoneChatBG.width = 127
  end
  LuaVector3.Better_Set(pos, self.someoneChatBG.width + 27, -15, 0)
  self.someoneBgDecorate1_Icon.transform.localPosition = pos
  LuaVector3.Better_Set(pos, self.someoneChatBG.width + 25, -self.someoneChatBG.height - 14, 0)
  self.someoneBgDecorate2_Icon.transform.localPosition = pos
  LuaVector3.Better_Set(pos, -23, -self.someoneChatBG.height - 10, 0)
  self.someoneBgDecorate3_Icon.transform.localPosition = pos
end

local tempV3 = LuaVector3()

function FramePreviewTip:SetAnchorPos(isright)
  if isright then
    tempV3[1] = 0
  else
    tempV3[1] = -392
  end
  self.gameObject.transform.localPosition = tempV3
end

function FramePreviewTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function FramePreviewTip:OnExit()
  GameObject.Destroy(self.gameObject)
  self:PassEvent(FramePreviewEvent.Close)
  if self.tMPreviewCell then
    self.tMPreviewCell:OnDestroy()
  end
  return true
end
