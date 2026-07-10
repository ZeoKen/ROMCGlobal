local pos = LuaVector3.Zero()
autoImport("TeamMemberPreviewCell")
autoImport("HeadIconCell")
FashionStarPage3 = class("FashionStarPage3", SubView)

function FashionStarPage3:Init()
  self.index = 1
  self:InitUI()
end

function FashionStarPage3:InitUI()
  self.backGroundFrameRoot = self:FindGO("BackgroundFrameRoot")
  self.tmObj = self:FindGO("TeamMemberPreviewCell", self.backGroundFrameRoot)
  self.tMPreviewCell = TeamMemberPreviewCell.new(self.tmObj)
  self.chatFrameRoot = self:FindGO("ChatFrameRoot")
  self.myselfChatCell = self:FindGO("ChatRoomMySelfCell")
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
  self.headRoot = self:FindGO("HeadRoot")
  self.headDisplayIconCell = MyHeadIconCell.new()
  self.headDisplayIconCell:CreateSelf(self.headRoot)
  self.headDisplayIconCell:SetMinDepth(4)
  self.chatMySelfHeadObj = self:FindGO("HeadContainer", self.myselfChatCell)
  self.chatMyselfHeadIconCell = MyHeadIconCell.new()
  self.chatMyselfHeadIconCell:CreateSelf(self.chatMySelfHeadObj)
  self.chatMyselfHeadIconCell:SetMinDepth(4)
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
  self.indexGo = {}
  self.indexGo[1] = self.headRoot
  self.indexGo[2] = self.chatFrameRoot
  self.indexGo[3] = self.backGroundFrameRoot
end

function FashionStarPage3:OnShow()
  self:UpdateUIByIndex()
  self:SetUI()
end

function FashionStarPage3:SetUI()
  if self.setUI then
    return
  end
  self.setUI = true
  local configId = FashionStarProxy.Instance:GetCurrentConfigId()
  local config = Table_FashionStar[configId]
  if not config then
    return
  end
  local param = config.Param
  local userPortraitFrame_id, userChatFrame_id, userBackground_id = param.UserPortraitFrame, param.UserChatFrame, param.UserBackground
  self:SetHeadIconCell(userPortraitFrame_id)
  self:SetChatFrame(userChatFrame_id)
  self.tMPreviewCell:SetData(userBackground_id)
end

function FashionStarPage3:UpdateUIByIndex()
  for i = 1, #self.indexGo do
    self.indexGo[i].gameObject:SetActive(i == self.index)
    self.container:UpdateDescription(string.format(ZhString["UpgradeAppearance_ButtomTip_Page3_" .. self.index], self.container.fashionName))
  end
end

function FashionStarPage3:OnClickSwitch(isPre)
  if isPre then
    self.index = self.index - 1
    if self.index < 1 then
      self.index = #self.indexGo
    end
  else
    self.index = self.index + 1
    if self.index > #self.indexGo then
      self.index = 1
    end
  end
  self:UpdateUIByIndex()
end

function FashionStarPage3:SetHeadIconCell(id)
  self.headData = HeadImageData.new()
  self.headData:TransByMyself()
  if id then
    self.headData.iconData.portraitframe = id
  end
  if self.headData.iconData.type == HeadImageIconType.Avatar then
    self.headDisplayIconCell:SetData(self.headData.iconData)
  elseif self.headData.iconData.type == HeadImageIconType.Simple then
    self.headDisplayIconCell:SetSimpleIcon(self.headData.iconData.icon, self.headData.iconData.frameType)
  end
  self.headDisplayIconCell:SetPortraitFrame(id)
end

function FashionStarPage3:SetChatFrame(id)
  self.contentWidth = 260
  self.myselfName.text = Game.Myself.data:GetName()
  local headData = HeadImageData.new()
  headData:TransByMyself()
  if headData.iconData.type == HeadImageIconType.Avatar then
    self.chatMyselfHeadIconCell:SetData(headData.iconData)
  elseif headData.iconData.type == HeadImageIconType.Simple then
    self.chatMyselfHeadIconCell:SetSimpleIcon(headData.iconData.icon, headData.iconData.frameType)
  end
  local config = Table_UserChatFrame[id]
  if not config then
    redlog("Table_UserChatFrame 未配置ID:", id)
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

function FashionStarPage3:OnExit()
  if self.tMPreviewCell then
    self.tMPreviewCell:OnDestroy()
  end
  return true
end
