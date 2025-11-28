autoImport("ChatEmojiPage")
autoImport("ChatActionPage")
autoImport("ChatTextEmojiPage")
autoImport("PresetTextPage")
autoImport("ChatItemPage")
autoImport("RedPacketPage")
ChatFunctionView = class("ChatFunctionView", SubView)
local PageConfig = {
  [1] = ChatEmojiPage,
  [2] = ChatActionPage,
  [3] = ChatTextEmojiPage,
  [4] = PresetTextPage,
  [5] = ChatItemPage,
  [6] = RedPacketPage
}
local ColorSkyBlue = LuaColor.New(0.7098039215686275, 1, 1, 1)
local ColorGray = LuaColor.New(0.7372549019607844, 0.7372549019607844, 0.7372549019607844, 1)
local ColorWhite = LuaColor.White()

function ChatFunctionView:Init()
  self.page = {}
  self:AddView(5)
  self:AddListenEvt(ChatRoomEvent.OnRedPacketSendViewEnter, self.OnRedPacketSendViewEnter)
  self:AddListenEvt(ChatRoomEvent.OnRedPacketSendViewExit, self.OnRedPacketSendViewExit)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateFunctionPage)
end

function ChatFunctionView:TryInit()
  if self.isInit then
    return
  end
  self.isInit = true
  self:FindObjs()
  self:AddEvts()
end

function ChatFunctionView:FindObjs()
  self.gameObject = self:FindGO("PopUpWindow")
  self.scrollBg = self:FindGO("ScrollBg"):GetComponent(UIDragScrollView)
  self.buttonGrid = self:FindComponent("ButtonRoot", UIGrid)
  self.toggle = {}
  self.toggleSprite = {}
  self.toggle[1] = self:FindGO("EmojiBtn"):GetComponent(UIToggle)
  self.toggle[2] = self:FindGO("ActionBtn"):GetComponent(UIToggle)
  self.toggle[3] = self:FindGO("TextEmojiBtn"):GetComponent(UIToggle)
  self.toggle[4] = self:FindGO("TBtn"):GetComponent(UIToggle)
  self.toggle[5] = self:FindGO("ItemBtn"):GetComponent(UIToggle)
  self.toggle[6] = self:FindGO("RedPacketBtn"):GetComponent(UIToggle)
end

function ChatFunctionView:AddEvts()
  local _EventAdd = EventDelegate.Add
  local toggle = self.toggle
  for i = 1, #toggle do
    _EventAdd(toggle[i].onChange, function()
      self:ClickBtn(i)
    end)
    local root = toggle[i].gameObject
    if i ~= 6 then
      local iconSprite = self:FindComponent("icon", GradientUISprite, root)
      if iconSprite then
        self.toggleSprite[i] = iconSprite
      end
    else
      self.redPacketIconSp = self:FindComponent("icon", UIMultiSprite, root)
    end
  end
  self.sendPhotoButton = self:FindGO("ImageBtn")
  self:AddClickEvent(self.sendPhotoButton, function()
    local index = self.pageIndex
    self.toggle[index].value = true
    self:ClickBtn(index)
    self:ClickSendPhoto()
  end)
  local closeButton = self:FindGO("CloseButton")
  self:AddClickEvent(closeButton, function()
    self:Hide()
  end)
end

function ChatFunctionView:InitShow()
  local index = 1
  self.pageIndex = index
  self:AddView(index)
end

function ChatFunctionView:AddView(index)
  if self.page[index] == nil then
    local config = PageConfig[index]
    if config ~= nil then
      self.page[index] = self:AddSubView(config.__cname, config)
    end
  end
end

function ChatFunctionView:ClickBtn(index)
  self:AddView(index)
  local page = self.page[index]
  if page == nil then
    return
  end
  if self.toggle[index].value then
    if page.TryInit ~= nil then
      page:TryInit()
    end
    local scrollView = page.contentScrollView
    if scrollView ~= nil then
      self.scrollBg.scrollView = scrollView
    end
    self.pageIndex = index
    local scale, colorTop, colorBottom
    for i = 1, #self.toggleSprite do
      scale = i == index and 1.1 or 1
      colorTop = i == index and ColorWhite or ColorGray
      colorBottom = i == index and ColorSkyBlue or ColorGray
      self.toggleSprite[i].transform.localScale = LuaGeometry.GetTempVector3(scale, scale, scale)
      self.toggleSprite[i].gradientTop = colorTop
      self.toggleSprite[i].gradientBottom = colorBottom
    end
    self.redPacketIconSp.CurrentState = index == 6 and 0 or 1
    self.redPacketIconSp.color = index == 6 and ColorUtil.NGUIWhite or LuaColor.TryParseHtmlToColor("#b8bddc")
  end
end

function ChatFunctionView:ClickSendPhoto()
  self:Hide()
  if self.container and self.container.ChooseSendPhoto then
    self.container:ChooseSendPhoto()
  end
end

function ChatFunctionView:ShowSelf(channel)
  self:TryInit()
  local isChatPhotoEnableInChannel = ChatRoomProxy.IsChatPhotoEnable(channel)
  local isSendPhotoUnlock = isChatPhotoEnableInChannel and FunctionUnLockFunc.Me():CheckCanOpen(6) and FunctionUnLockFunc.Me():CheckCanOpen(74)
  local isSendExpressionUnlock = not GameConfig.SystemForbid.ChatText and FunctionUnLockFunc.Me():CheckCanOpen(9)
  self.sendPhotoButton:SetActive(isSendPhotoUnlock and true or false)
  self:Show()
  local index = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.chatFunctionIndex
  if isSendExpressionUnlock then
    self.toggle[1].gameObject:SetActive(true)
    if index and index ~= 1 then
      self.toggle[index].gameObject:SetActive(true)
      if self.toggle[index].value then
        self:ClickBtn(index)
      end
      self.toggle[index].value = true
      self.toggle[1].value = false
    else
      self.toggle[1].value = true
    end
  else
    if index then
      self.toggle[index].gameObject:SetActive(true)
      if self.toggle[index].value then
        self:ClickBtn(index)
      end
      self.toggle[index].value = true
    else
      self.toggle[3].value = true
    end
    self.toggle[1].gameObject:SetActive(false)
  end
  local channel = ChatRoomProxy.Instance:GetChatRoomChannel()
  local isSendActionUnLoadk = isSendExpressionUnlock and channel ~= ChatChannelEnum.World and channel ~= ChatChannelEnum.Guild and channel ~= ChatChannelEnum.Team
  self.toggle[2].gameObject:SetActive(isSendActionUnLoadk)
  self.buttonGrid:Reposition()
end

function ChatFunctionView:OnRedPacketSendViewEnter(note)
  local closeScript = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  if closeScript then
    closeScript.enabled = false
  end
end

function ChatFunctionView:OnRedPacketSendViewExit(note)
  local closeScript = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  if closeScript then
    closeScript.enabled = true
  end
end

function ChatFunctionView:UpdateFunctionPage(note)
  if self.pageIndex == 6 then
    local page = self.page[self.pageIndex]
    if page and page.TryInit then
      page:TryInit()
    end
  end
end
