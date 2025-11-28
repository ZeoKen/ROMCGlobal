autoImport("ChatChannelView")
autoImport("PrivateChatView")
autoImport("ChatZoneView")
autoImport("ChatFunctionView")
autoImport("ChatKeywordView")
ChatRoomPage = class("ChatRoomPage", ContainerView)
ChatRoomPage.ViewType = UIViewType.ChitchatLayer
ChatRoomEnum = {
  CHANNEL = "CHANNEL",
  PRIVATECHAT = "PRIVATECHAT",
  CHATZONE = "CHATZONE"
}
ChatRoomPage.TabName = {
  ChannelBtn = ZhString.Chat_channel,
  PrivateChatBtn = ZhString.Chat_privateChat,
  ChatZoneBtn = ZhString.Chat_chatZone
}
ChatRoomPage.rid = ResourcePathHelper.UICell("ChatRoomCombineCell")
local InputLimitMaxCount = 39
local Send = function(callbackParam)
  callbackParam.owner:ClicksendButton(callbackParam[1], callbackParam[2], callbackParam[3], callbackParam[4], callbackParam[5])
  ReusableTable.DestroyAndClearTable(callbackParam)
end

function ChatRoomPage:GetShowHideMode()
  return PanelShowHideMode.MoveOutAndMoveIn
end

function ChatRoomPage:OnShow()
  UIUtil.ResetAndUpdateAllAnchors(self.gameObject)
  self.gameObject:SetActive(true)
  self.anchorsHasResetByOnShow = true
  local view = self:GetViewByState()
  if view ~= nil and view.itemContent ~= nil then
    view.itemContent.table:Reposition()
  end
end

function ChatRoomPage:OnHide()
  self.gameObject:SetActive(false)
  self.anchorsHasResetByOnShow = nil
end

function ChatRoomPage:Init()
  if BranchMgr.IsSEA() or BranchMgr.IsNO() then
    InputLimitMaxCount = 60
  elseif AppBundleConfig.GetSDKLang() == "en" or AppBundleConfig.GetSDKLang() == "pt" then
    InputLimitMaxCount = 60
  end
  self:InitShow()
end

function ChatRoomPage:FindObjs()
  helplog(" ChatRoomPage:FindObjs")
  self.ChatRoom = self:FindGO("ChatRoom")
  self.ChatChannel = self:FindGO("ChatChannelView")
  self.PrivateChat = self:FindGO("PrivateChatView")
  self.ChatZone = self:FindGO("ChatZoneView")
  self.fadeInOutRoot = self:FindGO("fadeInOutRoot", self.ChatRoom)
  self.fadeInOutSymbol = self:FindGO("fadeInOutSymbol", self.ChatRoom):GetComponent(UISprite)
  self.fadeCloseSymbol = self:FindGO("fadeCloseSymbol", self.ChatRoom)
  self.fadeInOutRootTp = self.fadeInOutRoot:GetComponent(TweenPosition)
  self.channelToggle = self:FindGO("ChannelBtn", self.ChatRoom):GetComponent(UIToggle)
  self.privateChatToggle = self:FindGO("PrivateChatBtn", self.ChatRoom):GetComponent(UIToggle)
  self.chatZoneToggle = self:FindGO("ChatZoneBtn", self.ChatRoom):GetComponent(UIToggle)
  self.channelLongPress = self.channelToggle:GetComponent(UILongPress)
  self.privateChatLongPress = self.privateChatToggle:GetComponent(UILongPress)
  self.chatZoneLongPress = self.chatZoneToggle:GetComponent(UILongPress)
  self.privateChatWridget = self.privateChatToggle:GetComponent(UIWidget)
  self.privateChatSp = self.privateChatToggle.gameObject:GetComponent(UISprite)
  self.channelBtnSp = self.channelToggle.gameObject:GetComponent(UISprite)
  self.channelBtnCheckmarkSp = self:FindComponent("Checkmark", UISprite, self.channelToggle.gameObject)
  self.channelLabel = self:FindGO("NameLabel", self.channelToggle.gameObject):GetComponent(UILabel)
  self.privateChatLabel = self:FindGO("NameLabel", self.privateChatToggle.gameObject):GetComponent(UILabel)
  self.chatZoneLabel = self:FindGO("NameLabel", self.chatZoneToggle.gameObject):GetComponent(UILabel)
  self.channelIcon = self:FindGO("Icon", self.channelToggle.gameObject):GetComponent(UISprite)
  self.privateChatIcon = self:FindGO("Icon", self.privateChatToggle.gameObject):GetComponent(UISprite)
  self.chatZoneIcon = self:FindGO("Icon", self.chatZoneToggle.gameObject):GetComponent(UISprite)
  self.canTalk = self:FindGO("CanTalk", self.ChatRoom)
  self.sendButton = self:FindGO("sendButton", self.canTalk)
  self.inputRoot = self:FindGO("InputRoot", self.canTalk)
  self.inputRoot.gameObject:SetActive(ApplicationInfo.NeedOpenVoiceSend())
  self.smiliesSprite = self:FindGO("smiliesSprite", self.canTalk)
  self.contentInput = self:FindGO("contentInput", self.canTalk):GetComponent(UIInput)
  self.contentInput.characterLimit = InputLimitMaxCount * 5
  if ApplicationInfo.IsRunOnWindowns() then
    self.contentInput.onReturnKey = 1
  end
  SkipTranslatingInput(self.contentInput)
  self.CantTalk = self:FindGO("CantTalk", self.ChatRoom)
  self.CantTalkLabel = self:FindGO("CantTalkLabel"):GetComponent(UILabel)
  self.CantTalkSprite = self:FindGO("CantTalkSprite"):GetComponent(UISprite)
  self.inputInsertContent = self.contentInput:GetComponent(UIInputInsertContent)
  self.ContentScrollBg = self:FindGO("ContentScrollBg", self.ChatRoom):GetComponent(UIDragScrollView)
  self.tweenParent = self:FindGO("TweenParent"):GetComponent(TweenPosition)
  self.emptyTip = self:FindGO("EmptyTip")
  if not MicrophoneManipulate.CanSpeech() then
    self.inputRoot:SetActive(false)
  end
  self:AddListenEvt(XDEUIEvent.ChatEmpty, self.HandleShowEmpty)
end

function ChatRoomPage:HandleShowEmpty(note)
  helplog("ChatRoomPage:HandleShowEmpty", note.body)
  if self.emptyTip ~= nil then
    self.emptyTip:SetActive(note.body)
  end
end

function ChatRoomPage:AddEvts()
  self:AddClickEvent(self.fadeInOutRoot, function(g)
    self:ClickfadeInOutRoot(g)
  end)
  self:AddClickEvent(self.channelToggle.gameObject, function(g)
    self:ClickChannelBtn(g)
  end)
  self:AddClickEvent(self.privateChatToggle.gameObject, function(g)
    self:ClickPrivateChatBtn(g)
  end)
  self:AddClickEvent(self.chatZoneToggle.gameObject, function(g)
    self:ClickChatZoneBtn(g)
  end)
  self:AddClickEvent(self.smiliesSprite, function(g)
    self:ClicksmiliesSprite(g)
  end)
  self:AddClickEvent(self.sendButton, function(g)
    self:SafeSend()
  end)
  self.tweenParent:SetOnFinished(function()
    if self.tweenParent.value == self.tweenParent.to then
      self.gameObject:SetActive(false)
      self.gameObject:SetActive(true)
      if self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.isSelected then
        self.contentInput.isSelected = true
        self.contentInput.cursorPosition = 0
      end
      if self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.chatFunctionIndex then
        if self.viewdata.viewdata.channel == ChatChannelEnum.Guild then
          if not GuildProxy.Instance:IHaveGuild() then
            MsgManager.ShowMsgByID(2620)
          else
            self:ClicksmiliesSprite()
          end
        elseif self.viewdata.viewdata.channel == ChatChannelEnum.Private then
          self:SwitchValue(ChatRoomEnum.PRIVATECHAT)
          self:ClicksmiliesSprite()
        else
          self:ClicksmiliesSprite()
        end
      end
    elseif self.tweenParent.value == self.tweenParent.from then
      self:CloseSelf()
    end
  end)
  local longPress = self.inputRoot:GetComponent(UILongPress)
  if longPress then
    function longPress.pressEvent(obj, state)
      GVoiceProxy.Instance:CompatibleWithAndroidVersionNineZero(function()
        if state then
          ChatRoomProxy.Instance:TryRecognizer()
        else
          self:sendNotification(ChatRoomEvent.StopRecognizer)
        end
      end)
    end
  end
  EventDelegate.Add(self.contentInput.onChange, function()
    local str = self.contentInput.value
    local length = StringUtil.Utf8len(str)
    if length > InputLimitMaxCount then
      self.contentInput.value = StringUtil.getTextByIndex(str, 1, InputLimitMaxCount)
      MsgManager.ShowMsgByID(28010)
    end
  end)
  EventDelegate.Add(self.contentInput.onSubmit, function()
    if StringUtil.IsEmpty(self.contentInput.value) then
      self:ClickfadeInOutRoot()
    else
      self:SafeSend()
    end
  end)
  local longPressEvent = function(obj, state)
    self:PassEvent(TipLongPressEvent.ChatRoomPage, {
      state,
      obj.gameObject
    })
  end
  self.channelLongPress.pressEvent = longPressEvent
  self.privateChatLongPress.pressEvent = longPressEvent
  self.chatZoneLongPress.pressEvent = longPressEvent
  self:AddEventListener(TipLongPressEvent.ChatRoomPage, self.HandleLongPress, self)
end

function ChatRoomPage:AddViewEvts()
  self:AddListenEvt(ChatRoomEvent.CancelCreateChatRoom, self.CancelCreateChatRoom)
  self:AddListenEvt(ChatRoomEvent.SendSpeech, self.SendSpeech)
  self:AddListenEvt(ServiceEvent.ChatCmdQueryItemData, self.RecvQueryItemData)
  self:AddListenEvt(ChatRoomEvent.StartVoice, self.StartVoice)
  self:AddListenEvt(ChatRoomEvent.StopVoice, self.StopVoice)
  self:AddListenEvt(ServiceEvent.ChatCmdChatRetCmd, self.RecvChatRetCmd)
  self:AddListenEvt(ChatRoomEvent.SystemMessage, self.RecvSystemMessage)
  self:AddListenEvt(ChatRoomEvent.KeywordEffect, self.RecvKeywordEffect)
  self:AddListenEvt(ServiceEvent.NUserBoothReqUserCmd, self.RecvBoothInfo)
  self:AddListenEvt(HotKeyEvent.Send, self.HandleSend)
  self:AddListenEvt(ChatRoomEvent.UpdatePrivateChatRed, self.UpdatePrivateChatRed)
  self:AddListenEvt(ChatRoomEvent.AutoSendMessageEvent, self.HandleAutoSendMsg, self)
  self:AddListenEvt(ChatRoomEvent.AutoSendKeywordEffect, self.HandleAutoKeywordEffect, self)
  self:AddListenEvt(HotKeyEvent.CloseChatRoom, self.HandleCloseChatRoom, self)
end

function ChatRoomPage:HandleSend(note)
  self:SafeSend()
end

function ChatRoomPage:InitShow()
  self.OutlineColor = {Default = "263E8C", Toggle = "000000"}
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self.channelLabel.text = ZhString.Chat_channel
  self.privateChatLabel.text = ZhString.Chat_privateChat
  self.chatZoneLabel.text = ZhString.Chat_chatZone
  local iconActive, nameLabelActive
  if not GameConfig.SystemForbid.TabNameTip then
    iconActive = true
    nameLabelActive = false
  else
    iconActive = false
    nameLabelActive = true
  end
  self.channelIcon.gameObject:SetActive(iconActive)
  self.privateChatIcon.gameObject:SetActive(iconActive)
  self.chatZoneIcon.gameObject:SetActive(iconActive)
  self.channelLabel.gameObject:SetActive(nameLabelActive)
  self.privateChatLabel.gameObject:SetActive(nameLabelActive)
  self.chatZoneLabel.gameObject:SetActive(nameLabelActive)
  self.chatChannelView = self:AddSubView("ChatChannelView", ChatChannelView)
  self.privateChatView = self:AddSubView("PrivateChatView", PrivateChatView)
  self.chatZoneView = self:AddSubView("ChatZoneView", ChatZoneView)
  self.chatFunctionView = self:AddSubView("ChatFunctionView", ChatFunctionView)
  self.chatKeywordView = self:AddSubView("ChatKeywordView", ChatKeywordView)
end

function ChatRoomPage:InitUI()
  self.gameObject:SetActive(true)
  self:ShowFade(true)
  if self.viewdata.viewdata and self.viewdata.viewdata.key then
    if self.viewdata.viewdata.key == "ChatZone" then
      self:SwitchValue(ChatRoomEnum.CHATZONE)
      self:ShowFade(false)
    elseif self.viewdata.viewdata.key == "Channel" then
      self:SwitchValue(ChatRoomEnum.CHANNEL)
    end
  elseif ChatRoomProxy.Instance:GetChatRoomChannel() == ChatChannelEnum.Private then
    self:SwitchValue(ChatRoomEnum.PRIVATECHAT)
  elseif ChatZoomProxy.Instance:IsInChatZone() then
    self:SwitchValue(ChatRoomEnum.CHATZONE)
  else
    self:SwitchValue(ChatRoomEnum.CHANNEL)
  end
  self.lastTime = 0
  self.tweenParent:PlayForward()
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_PRIVATE_CHAT, self.privateChatSp, self.privateChatWridget.depth + 1, {-10, -27})
  if GameConfig.RedPacket.RedTip then
    self:RegisterRedTipCheckByIds({
      GameConfig.RedPacket.RedTip.Guild,
      GameConfig.RedPacket.RedTip.GVG
    }, self.channelBtnSp, self.channelBtnCheckmarkSp.depth + 1, {-10, -27})
  end
  self:UpdateChatZone()
end

function ChatRoomPage:SetVisible(canTalk)
  self.canTalk:SetActive(canTalk)
  self.CantTalk:SetActive(not canTalk)
  self.CantTalkLabel.text = ZhString.Chat_cantTalk
  self.CantTalkSprite.width = self.CantTalkLabel.printedSize.x + 60
end

function ChatRoomPage:OnEnter()
  ChatRoomPage.super.OnEnter(self)
  ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(true)
  self:CameraRotateToMe(false, CameraConfig.UI_Msg_ViewPort, CameraController.singletonInstance.targetRotationEuler)
  self:InitUI()
  if self.anchorsHasResetByOnShow then
    UIUtil.ResetAndUpdateAllAnchors(self.gameObject)
  end
end

function ChatRoomPage:OnExit()
  if ChatZoomProxy.Instance:IsInChatZone() then
    local data = ChatZoomProxy.Instance:CachedZoomInfo()
    ServiceChatRoomProxy.Instance:CallExitChatRoom(data.roomid, Game.Myself.data.id)
  end
  self:CameraReset()
  self.contentInput.isSelected = false
  self.ChatChannel:SetActive(true)
  self.PrivateChat:SetActive(true)
  ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(false)
  ChatRoomPage.super.OnExit(self)
end

function ChatRoomPage:ClickfadeInOutRoot(g)
  if ChatZoomProxy.Instance:IsInChatZone() then
    MsgManager.ConfirmMsgByID(810, function()
      self:FadeInOut()
    end, nil, nil)
  else
    self:FadeInOut()
  end
end

function ChatRoomPage:FadeInOut()
  GameFacade.Instance:sendNotification(ChatRoomEvent.ChangeChannel)
  self:CameraReset()
  self:ResetKeyword()
  self.tweenParent:PlayReverse()
end

function ChatRoomPage:ClickChannelBtn(g)
  self:SwitchView(ChatRoomEnum.CHANNEL)
end

function ChatRoomPage:ClickPrivateChatBtn(g)
  self:SwitchView(ChatRoomEnum.PRIVATECHAT)
end

function ChatRoomPage:ClickChatZoneBtn()
  if Game.MapManager:CheckForbiddenChatRoom() then
    MsgManager.ShowMsgByID(25311)
    return
  end
  local dressup = Game.Myself.data.userdata:Get(UDEnum.DRESSUP)
  if dressup ~= 0 then
    MsgManager.ShowMsgByID(25533)
    return
  end
  local isInGagTime, time = MyselfProxy.Instance:IsInGagTime()
  if isInGagTime then
    MsgManager.ShowMsgByID(92, math.floor(time / 60))
    return
  end
  FunctionSecurity.Me():TryDoRealNameCentify(function()
    self:SwitchView(ChatRoomEnum.CHATZONE)
  end)
end

function ChatRoomPage:ClicksmiliesSprite(g)
  self.chatFunctionView:ShowSelf(self:GetCurrentChannel())
end

function ChatRoomPage:SafeSend(...)
  local callbackParam = ReusableTable.CreateTable()
  callbackParam.owner = self
  for i = 1, select("#", ...) do
    callbackParam[i] = select(i, ...)
  end
  FunctionSecurity.Me():TryDoRealNameCentify(Send, callbackParam)
end

function ChatRoomPage:ClicksendButton(content, voice, voicetime, photo, expression)
  if content == nil then
    content = self.contentInput.value
  end
  if Game.ChatSystemManager:CheckChatContent(content) then
    self:_EndSend()
    return
  end
  if content and 0 < #content or photo or expression then
    local curChannel = self:GetCurrentChannel()
    if not ChatRoomProxy.Instance:CheckoutChatCooldown(curChannel) then
      MsgManager.ShowMsgByID(84)
      self.contentInput.value = ""
      return
    end
    local text = expression and expression.id or content
    if not ChatRoomProxy.Instance:CheckoutSameChatCooldown(curChannel, text) then
      MsgManager.ShowMsgByID(85)
      self.contentInput.value = ""
      return
    end
    if photo then
      if not ChatRoomProxy.Instance:CheckChatPhotoDailyTimes(curChannel) then
        MsgManager.ShowMsgByID(28008)
        return
      end
      if not ChatRoomProxy.Instance:CheckChatPhotoCoolDown(curChannel) then
        MsgManager.ShowMsgByID(28009)
        return
      end
    end
    if self.CurrentState == ChatRoomEnum.CHANNEL then
      self.chatChannelView:SendMessage(content, voice, voicetime, photo, expression)
    elseif self.CurrentState == ChatRoomEnum.PRIVATECHAT then
      self.privateChatView:SendMessage(content, voice, voicetime, photo, expression)
    elseif self.CurrentState == ChatRoomEnum.CHATZONE then
      self.chatZoneView:SendMessage(content, voice, voicetime, photo, expression)
    end
    self:_EndSend(photo, curChannel)
  else
    MsgManager.FloatMsgTableParam(nil, ZhString.Chat_send)
  end
end

function ChatRoomPage:_EndSend(photo, curChannel)
  self.lastTime = UnityRealtimeSinceStartup
  self.contentInput.value = ""
  ChatRoomProxy.Instance:ResetItemDataList()
  if photo then
    ChatRoomProxy.Instance:SetLastChatPhotoTime(curChannel)
  end
end

function ChatRoomPage:IsInTeam()
  local isIn = true
  if TeamProxy.Instance:IHaveTeam() then
    self:SetVisible(true)
  else
    self:SetVisible(false)
    self.CantTalkLabel.text = ZhString.Chat_notInParty
    self.CantTalkSprite.width = self.CantTalkLabel.printedSize.x + 60
    isIn = false
  end
  return isIn
end

function ChatRoomPage:IsInGuild()
  local isIn = true
  if GuildProxy.Instance:IHaveGuild() then
    self:SetVisible(true)
  else
    self:SetVisible(false)
    self.CantTalkLabel.text = ZhString.Chat_notInGuild
    self.CantTalkSprite.width = self.CantTalkLabel.printedSize.x + 60
    isIn = false
  end
  return isIn
end

function ChatRoomPage:IsInReserveRoom()
  local isIn = true
  if PvpCustomRoomProxy.Instance:GetCurrentRoomData() ~= nil then
    self:SetVisible(true)
  else
    self:SetVisible(false)
    self.CantTalkLabel.text = ZhString.Chat_notInReserveRoom
    self.CantTalkSprite.width = self.CantTalkLabel.printedSize.x + 60
    isIn = false
  end
  return isIn
end

function ChatRoomPage:SetContentInputValue(content)
  if content and 0 < #content then
    self.inputInsertContent:InsertContent(content)
  end
end

function ChatRoomPage:SetContent(content)
  if content then
    self.contentInput.value = content
  end
end

function ChatRoomPage:SetDefaultColor()
  if self.defaultResultC == nil then
    local hasC
    hasC, self.defaultResultC = ColorUtil.TryParseHexString(self.OutlineColor.Default)
  end
  if self.defaultResultC then
    self:SetColor(self.CurrentState, self.defaultResultC)
  end
end

function ChatRoomPage:SetToggleColor()
  if self.toggleResultC == nil then
    local hasC
    hasC, self.toggleResultC = ColorUtil.TryParseHexString(self.OutlineColor.Toggle)
  end
  if self.toggleResultC then
    self:SetColor(self.CurrentState, self.toggleResultC)
  end
end

function ChatRoomPage:SetColor(currentState, color)
  if currentState == ChatRoomEnum.CHANNEL then
    self.channelLabel.effectColor = color
  elseif currentState == ChatRoomEnum.PRIVATECHAT then
    self.privateChatLabel.effectColor = color
  elseif currentState == ChatRoomEnum.CHATZONE then
    self.chatZoneLabel.effectColor = color
  end
end

function ChatRoomPage:SetCurrentState(state)
  self:SetDefaultColor()
  self.LastState = self.CurrentState
  self.CurrentState = state
  self:SetToggleColor()
end

function ChatRoomPage:SwitchView(state)
  self.emptyTip:SetActive(false)
  local tabNameTipData, tabNameTipStick
  self:SetCurrentState(state)
  if state == ChatRoomEnum.CHANNEL then
    self.ChatChannel:SetActive(true)
    self.PrivateChat:SetActive(false)
    self.ChatZone:SetActive(false)
    self.ContentScrollBg.scrollView = self.chatChannelView.contentScrollView
    self.chatKeywordView:SetPanel(self.chatChannelView.ContentPanel)
    self.chatChannelView:ResetPositionInfo(true)
    self.chatChannelView:ResetTalk()
    tabNameTipData = ZhString.Chat_channel
    tabNameTipStick = self.channelToggle
    self:ChangeRedDepth(self.privateChatSp, self.privateChatWridget.depth + 10)
  elseif state == ChatRoomEnum.PRIVATECHAT then
    self.ChatChannel:SetActive(false)
    self.PrivateChat:SetActive(true)
    self.ChatZone:SetActive(false)
    self.ContentScrollBg.scrollView = self.privateChatView.ContentScrollView
    self.chatKeywordView:SetPanel(self.privateChatView.ContentPanel)
    self.privateChatView:UpdateChat()
    self.privateChatView:ResetTalk()
    self.privateChatView:ClearRedTip()
    tabNameTipData = ZhString.Chat_privateChat
    tabNameTipStick = self.privateChatToggle
  elseif state == ChatRoomEnum.CHATZONE then
    self.ChatChannel:SetActive(false)
    self.PrivateChat:SetActive(false)
    if not ChatZoomProxy.Instance:IsInChatZone() then
      self:sendNotification(UIEvent.ShowUI, {
        viewname = "CreateChatRoom"
      })
      self.ChatZone:SetActive(false)
      TipManager.Instance:CloseTabNameTip()
    else
      self.ChatZone:SetActive(true)
      self.chatZoneView:UpdateChat()
    end
    self.ContentScrollBg.scrollView = self.chatZoneView.ContentScrollView
    self.chatKeywordView:SetPanel(self.chatZoneView.ContentPanel)
    self.chatZoneView:ResetTalk()
    tabNameTipData = ZhString.Chat_chatZone
    tabNameTipStick = self.chatZoneToggle
    self:ChangeRedDepth(self.privateChatSp, self.privateChatWridget.depth + 10)
  end
  self:ResetKeyword()
end

function ChatRoomPage:ChangeRedDepth(ui, _depth)
  local redTip = RedTipProxy.Instance:GetRedTip(SceneTip_pb.EREDSYS_PRIVATE_CHAT)
  if redTip then
    redTip:ChangeRedDepth(ui, _depth)
  end
end

function ChatRoomPage:UpdatePrivateChatRed()
  if self.CurrentState == ChatRoomEnum.CHANNEL then
    RedTipProxy.Instance:UpdateRedTip(SceneTip_pb.EREDSYS_PRIVATE_CHAT)
    self:ChangeRedDepth(self.privateChatSp, self.privateChatWridget.depth + 10)
  elseif self.CurrentState == ChatRoomEnum.CHATZONE then
    RedTipProxy.Instance:UpdateRedTip(SceneTip_pb.EREDSYS_PRIVATE_CHAT)
    self:ChangeRedDepth(self.privateChatSp, self.privateChatWridget.depth + 10)
  end
end

function ChatRoomPage:HandleAutoSendMsg(note)
  local text = note.body
  self.contentInput.value = text
  self:SafeSend()
end

function ChatRoomPage:HandleAutoKeywordEffect(note)
  local data = note.body
  self.chatKeywordView:AddKeywordEffect(data)
end

function ChatRoomPage:SwitchValue(state)
  if state == ChatRoomEnum.CHANNEL then
    self.channelToggle.value = true
  elseif state == ChatRoomEnum.PRIVATECHAT then
    self.privateChatToggle.value = true
  elseif state == ChatRoomEnum.CHATZONE then
    FunctionSecurity.Me():TryDoRealNameCentify(function()
      self.chatZoneToggle.value = true
      self:SwitchView(state)
    end)
    return
  end
  self:SwitchView(state)
end

local tipData = {}
local funkey = {
  "InviteMember",
  "SendMessage",
  "AddFriend",
  "ShowDetail",
  "AddBlacklist",
  "InviteEnterGuild",
  "Tutor_InviteBeTutor",
  "Tutor_InviteBeStudent",
  "EnterHomeRoom"
}

function ChatRoomPage:HandleClickHead(cellctl)
  local data = cellctl.data
  local id = data:GetId()
  if id == Game.Myself.data.id then
    return
  elseif data.roleType == ChatRoleEnum.Pet or data.roleType == ChatRoleEnum.Npc then
    return
  end
  local playerData = PlayerTipData.new()
  playerData:SetByChatMessageData(data)
  FunctionPlayerTip.Me():CloseTip()
  local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cellctl.headIcon.clickObj, NGUIUtil.AnchorSide.Right, {10, 60})
  tipData.playerData = playerData
  tipData.funckeys = funkey
  playerTip:SetData(tipData)
end

function ChatRoomPage:StartVoice(note)
  local voiceId = FunctionChatSpeech.Me():GetCurrentVoiceId()
  if voiceId then
    cell = self:HandleVoice(voiceId)
    if cell then
      cell:StartVoiceTween()
    end
  end
end

function ChatRoomPage:StopVoice(note)
  local voiceId = FunctionChatSpeech.Me():GetCurrentVoiceId()
  if voiceId then
    cell = self:HandleVoice(voiceId)
    if cell then
      cell:StopVoiceTween()
    end
  end
end

function ChatRoomPage:HandleVoice(voiceId)
  local cell
  if self.CurrentState == ChatRoomEnum.CHANNEL then
    cell = self:GetCellByVoiceId(self.chatChannelView.itemContent, voiceId)
  elseif self.CurrentState == ChatRoomEnum.PRIVATECHAT then
    cell = self:GetCellByVoiceId(self.privateChatView.itemContent, voiceId)
  elseif self.CurrentState == ChatRoomEnum.CHATZONE then
    cell = self:GetCellByVoiceId(self.chatZoneView.itemContent, voiceId)
  end
  return cell
end

function ChatRoomPage:GetCellByVoiceId(wrapScrollViewHelper, id)
  local cells = wrapScrollViewHelper:GetCells()
  if cells then
    for k, v in pairs(cells) do
      local cell = v:GetCurrentCell()
      if cell then
        local data = cell.data
        if data and data.GetVoiceid ~= nil then
          local voiceid = data:GetVoiceid()
          if voiceid and voiceid == id then
            return cell
          end
        end
      end
    end
  end
  return nil
end

function ChatRoomPage:CancelCreateChatRoom()
  if not ChatZoomProxy.Instance:IsInChatZone() then
    self:SwitchLastState()
  end
end

function ChatRoomPage:SwitchLastState()
  local state = ChatRoomEnum.CHANNEL
  if self.LastState and self.LastState ~= ChatRoomEnum.CHATZONE then
    state = self.LastState
  end
  self:SwitchValue(state)
end

function ChatRoomPage:AddKeywordEffect(data)
  self.chatKeywordView:AddKeywordEffect(data)
end

function ChatRoomPage:ResetKeyword()
  self.chatKeywordView:Reset()
end

function ChatRoomPage:SendSpeech(note)
  local data = note.body
  self:ClicksendButton(data.content, data.voice, data.voicetime)
end

local itemTipData, tipOffset = {
  funcConfig = {}
}, {165, 0}

function ChatRoomPage:RecvQueryItemData(note)
  local itemData = note.body.data
  if itemData then
    local item = ItemData.new(itemData.base.guid, itemData.base.id)
    item:ParseFromServerData(itemData)
    item.equiped = 0
    itemTipData.itemdata = item
    TipManager.Instance:ShowItemFloatTip(itemTipData, self.fadeInOutSymbol, NGUIUtil.AnchorSide.Right, tipOffset)
  end
end

function ChatRoomPage:RecvChatRetCmd(note)
  self.chatChannelView:RecvChatRetUserCmd(note)
  self.privateChatView:HandleChatRetUserCmd(note)
  self.chatZoneView:OnReceiveChatMessage(note)
  local guid, channel, content = note.body[2], note.body[4], note.body[12]
  if note.body[32] == ChatRoomProxy.ExpressionType.Emoji then
    content = note.body[33]
  end
  ChatRoomProxy.Instance:SetLastChatTime(guid, channel)
  ChatRoomProxy.Instance:SetLastSameChatTimeText(guid, channel, content)
end

function ChatRoomPage:RecvSystemMessage(note)
  self:RecvChatRetCmd(note)
end

function ChatRoomPage:RecvKeywordEffect(note)
  self.chatChannelView:HandleKeywordEffect(note)
  self.privateChatView:HandleKeywordEffect(note)
  self.chatZoneView:HandleKeywordEffect(note)
end

function ChatRoomPage:RecvBoothInfo(note)
  local data = note.body
  if data then
    self:UpdateChatZone()
  end
end

function ChatRoomPage:ShowFade(isShowInOut)
  self.fadeInOutSymbol.gameObject:SetActive(isShowInOut)
  self.fadeCloseSymbol:SetActive(not isShowInOut)
end

function ChatRoomPage:GetViewByState(state)
  state = state or self.CurrentState
  if state == nil then
    return nil
  end
  if state == ChatRoomEnum.CHANNEL then
    return self.chatChannelView
  elseif state == ChatRoomEnum.PRIVATECHAT then
    return self.privateChatView
  elseif state == ChatRoomEnum.CHATZONE then
    return self.chatZoneView
  end
end

function ChatRoomPage:UpdateChatZone()
  self.chatZoneToggle.gameObject:SetActive(not Game.Myself:IsInBooth())
end

function ChatRoomPage:HandleLongPress(param)
  local isPressing, go = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, ChatRoomPage.TabName[go.name], false, go:GetComponent(UISprite))
end

function ChatRoomPage:ShowEmptyTip(show, state)
  if self.CurrentState == state then
    self.emptyTip:SetActive(show)
  end
end

function ChatRoomPage:ChooseSendPhoto()
  FunctionSecurity.Me():TryDoRealNameCentify(function()
    local viewdata = {
      ShowMode = PersonalPicturePanel.ShowMode.PickMode,
      callback = function(photo)
        self:ClicksendButton(nil, nil, nil, photo)
      end
    }
    PersonalPicturePanel.ViewType = UIViewType.NormalLayer
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PersonalPicturePanel,
      viewdata = viewdata
    })
  end)
end

function ChatRoomPage:GetCurrentChannel()
  if self.channelToggle.value then
    return self.chatChannelView.curChannel
  elseif self.privateChatToggle.value then
    return ChatChannelEnum.Private
  elseif self.chatZoneToggle.value then
    return ChatChannelEnum.Zone
  end
end

function ChatRoomPage:HandleCloseChatRoom()
  self:ClickfadeInOutRoot()
end
