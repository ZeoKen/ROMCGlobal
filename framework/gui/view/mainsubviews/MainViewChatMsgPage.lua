autoImport("MainViewChatGroup")
autoImport("ChatSimplifyView")
MainViewChatMsgPage = class("MainViewChatMsgPage", SubView)
local CharW = 22
local voiceTxt
local tempRot = LuaQuaternion()

function MainViewChatMsgPage:Init()
  self:InitPage()
  ServiceChatCmdProxy.Instance:CallGetVoiceIDChatCmd()
  ServiceChatCmdProxy.Instance:CallQueryGuildRedPacketChatCmd()
end

function MainViewChatMsgPage:OnEnter()
  MainViewChatMsgPage.super.OnEnter(self)
  if GameConfig.RedPacket.RedTip then
    self:RegisterRedTipCheckByIds({
      GameConfig.RedPacket.RedTip.Guild,
      GameConfig.RedPacket.RedTip.GVG
    }, self.worldMsgTweenSprite, self.worldMsgTweenSprite.depth + 1, {-10, -27})
  end
  ChatRoomProxy.Instance:CheckRedTip()
  TimeTickManager.Me():CreateTick(0, 300000, function()
    ChatRoomProxy.Instance:CheckChannelRedPackets()
  end, self)
end

function MainViewChatMsgPage:OnExit()
  self.speechRecognizer.handler = nil
  TimeTickManager.Me():ClearTick(self)
end

function MainViewChatMsgPage:OnShow()
  MainViewChatMsgPage.super.OnEnter(self)
  if self.chatSimplifyView.chatCtl then
    local cells = self.chatSimplifyView.chatCtl:GetCells()
    for i = 1, #cells do
      cells[i]:Refresh()
    end
  end
  self:StartStoryAudio()
end

function MainViewChatMsgPage:InitPage()
  self:FindObjs()
  self:AddEvts()
  self:MapListenEvt()
  self:InitShow()
end

function MainViewChatMsgPage:FindObjs()
  local Anchor_DownLeft = self:FindGO("Anchor_DownLeft")
  self.mainViewChat = self:LoadCellPfb("MainViewChat", "MainViewChat", Anchor_DownLeft)
  self.fadeBtnSp = self:FindGO("FadeBtn"):GetComponent(UISprite)
  self.worldMsgTween = self:FindGO("WorldMsg"):GetComponent(TweenHeight)
  self.fadeBtnTween = self.fadeBtnSp.gameObject:GetComponent(TweenPosition)
  self.chatGridTween = self:FindGO("ChatGrid"):GetComponent(TweenPosition)
  self.buttonGridTween = self:FindGO("ButtonGrid"):GetComponent(TweenPosition)
  self.worldMsgTweenSprite = self:FindGO("WorldMsg"):GetComponent(UISprite)
  self.fadeBtnTweenTrans = self.fadeBtnSp.transform
  self.chatGridTweenTrans = self:FindGO("ChatGrid").transform
  self.buttonGridTweenTrans = self:FindGO("ButtonGrid").transform
  self.ButtonGrid_UIGrid = self:FindGO("VoiceGrid"):GetComponent(UIGrid)
  self.worldMsgCollider = self.worldMsgTween.gameObject:GetComponent(BoxCollider)
  self.actPartTrans = self:FindGO("ACTPart").transform
  self.actPartBtn = self:FindGO("btnACT")
  self.cameraPartTrans = self:FindGO("CameraPart").transform
  self.voicePart = self:FindGO("VoicePart")
  self.voicePartTrans = self.voicePart.transform
  self.voiceGridObj = self:FindGO("VoiceGrid")
  self.voiceArrow = self:FindGO("Arrow")
  self.voicePartBG = self:FindGO("VoiceBg"):GetComponent(UISprite)
  self.voicePartBGTweenWidth = self:FindGO("VoiceBg"):GetComponent(TweenWidth)
  self.voiceArrowIcon = self.voiceArrow:GetComponent(UISprite)
  self.voiceArrowTweenPos = self.voiceArrow:GetComponent(TweenPosition)
  self.teamSpeech = self:FindGO("TeamSpeech"):GetComponent(UISprite)
  self.guildSpeech = self:FindGO("GuildSpeech"):GetComponent(UISprite)
  self.speechRecognizer = UIManagerProxy.Instance.speechRecognizer
  self.voiceArrowStatus = FunctionPlayerPrefs.Me():GetBool(LocalSaveProxy.SAVE_KEY.MainViewVoiceSettingHide)
  local needOpenVoiceSend = ApplicationInfo.NeedOpenVoiceSend()
  self:SetShowVoicePart(needOpenVoiceSend, needOpenVoiceSend)
  self.chatPrivately = self:FindGO("messageButton")
  self.chatPrivately:SetActive(false)
  self.storyAudioContainer = self:FindGO("StoryAudioContianer")
  self.storyAudioTween = self.storyAudioContainer:GetComponent(TweenPosition)
  self.audioBtn = self:FindGO("audioBtn", self.storyAudioContainer)
  self.textContainer = self:FindGO("TextContainer", self.storyAudioContainer):GetComponent(TweenWidth)
  self.textSP = self:FindGO("TextContainer", self.storyAudioContainer):GetComponent(UISprite)
  self.audioContent = self:FindGO("audioContent", self.storyAudioContainer):GetComponent(UILabel)
  self.contentEffect = self.audioContent.gameObject:GetComponent(TypewriterEffect)
  self.playing = self:FindGO("playing", self.storyAudioContainer)
  self.default = self:FindGO("default", self.storyAudioContainer)
  self.pause = self:FindGO("pause", self.storyAudioContainer)
  self.storyAudioContainer:SetActive(false)
end

function MainViewChatMsgPage:AddEvts()
  self:AddClickEvent(self.actPartBtn, function(go)
    self:sendNotification(MainViewEvent.EmojiBtnClick)
  end)
  self:AddClickEvent(self.chatPrivately, function(go)
    ChatRoomProxy.Instance:SetCurrentChatChannel(ChatChannelEnum.Private)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ChatRoomPage,
      force = false
    })
  end)
  self:AddClickEvent(self.worldMsgTween.gameObject, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ChatRoomPage,
      force = false
    })
  end)
  self:AddClickEvent(self.fadeBtnSp.gameObject, function(go)
    self:FadeTween()
  end)
  self.worldMsgTween:SetOnFinished(function()
    if self.worldMsgTween.value == self.worldMsgTween.to then
      self.worldMsgCollider.size = self.worldMsgCollider.size * self.scale
    end
    RedTipProxy.Instance:ReCalcUIRedPos(self.worldMsgTweenSprite)
  end)
  self:AddClickEvent(self.teamSpeech.gameObject, function()
    FunctionSecurity.Me():TryDoRealNameCentify()
  end)
  local teamSpeechLongPress = self.teamSpeech.gameObject:GetComponent(UILongPress)
  if teamSpeechLongPress then
    function teamSpeechLongPress.pressEvent(obj, state)
      GVoiceProxy.Instance:CompatibleWithAndroidVersionNineZero(function()
        self:TryTeamVoiceRecognizer(state)
      end)
    end
  end
  self:AddClickEvent(self.guildSpeech.gameObject, function()
    FunctionSecurity.Me():TryDoRealNameCentify()
  end)
  local guildSpeechLongPress = self.guildSpeech.gameObject:GetComponent(UILongPress)
  if guildSpeechLongPress then
    function guildSpeechLongPress.pressEvent(obj, state)
      GVoiceProxy.Instance:CompatibleWithAndroidVersionNineZero(function()
        self:TryGuildVoiceRecognizer(state)
      end)
    end
  end
  
  function self.speechRecognizer.handler(bytes, time, result)
    self:sendNotification(ChatRoomEvent.StopRecognizer)
    local voice = Slua.ToString(bytes)
    if result and 0 < #result then
      if AuguryProxy.Instance:GetInAugury() then
        ServiceSceneAuguryProxy.Instance:CallAuguryChat(result, Game.Myself.data.name)
      elseif self.curChannel then
        ServiceChatCmdProxy.Instance:CallChatCmd(self.curChannel, result, nil, bytes, time)
        self.curChannel = nil
      else
        local isInRange = Game.UILongPressManager:GetState()
        if isInRange then
          self:sendNotification(ChatRoomEvent.SendSpeech, {
            content = result,
            voice = bytes,
            voicetime = time
          })
        end
      end
    end
  end
  
  self.speechRecognizer:SetName(FunctionChatSpeech.Me().speechFileName)
  self.playingState = 0
  self:AddClickEvent(self.audioBtn, function(go)
    if self.playingState == 1 then
      self:PauseStoryAudio()
      self.playingState = 2
      self:ShowPauseAudioBtn()
    elseif self.playingState == 2 then
      self:ResumeStoryAudio()
      self.playingState = 1
      self:ShowPlayingAudioBtn()
    end
  end)
  self:AddClickEvent(self.voiceArrow, function()
    self.voiceArrowStatus = not self.voiceArrowStatus
    FunctionPlayerPrefs.Me():SetBool(LocalSaveProxy.SAVE_KEY.MainViewVoiceSettingHide, self.voiceArrowStatus)
    self:RefreshVoiceArrow()
  end)
end

function MainViewChatMsgPage:TryTeamVoiceRecognizer(state)
  FunctionSecurity.Me():TryDoRealNameCentify(function()
    if state then
      if TeamProxy.Instance:IHaveTeam() then
        if BranchMgr.IsTW() then
          self.curChannel = ChatChannelEnum.TeamChatRoomProxy.Instance:TryRecognizer(function()
            self.isTeamSpeech = true
            self.curChannel = ChatChannelEnum.Team
          end)
        else
          local allow = ChatRoomProxy.Instance:TryRecognizer()
          if allow then
            self.isTeamSpeech = true
            self.curChannel = ChatChannelEnum.Team
          end
        end
      else
        MsgManager.ShowMsgByIDTable(332)
      end
    elseif self.isTeamSpeech then
      local isInRange = Game.UILongPressManager:GetState()
      if not isInRange then
        self.curChannel = nil
      end
      self.isTeamSpeech = false
      self:sendNotification(ChatRoomEvent.StopRecognizer)
    end
  end)
end

function MainViewChatMsgPage:TryGuildVoiceRecognizer(state)
  FunctionSecurity.Me():TryDoRealNameCentify(function()
    if state then
      if GuildProxy.Instance:IHaveGuild() then
        local allow = BranchMgr.IsTW() or ChatRoomProxy.Instance:TryRecognizer()
        if allow then
          self.isGuildSpeech = true
          self.curChannel = ChatChannelEnum.Guild
        end
      else
        MsgManager.ShowMsgByIDTable(2620)
      end
    elseif self.isGuildSpeech then
      local isInRange = Game.UILongPressManager:GetState()
      if not isInRange then
        self.curChannel = nil
      end
      self.isGuildSpeech = false
      self:sendNotification(ChatRoomEvent.StopRecognizer)
    end
  end)
end

function MainViewChatMsgPage:MapListenEvt()
  self:AddListenEvt(MainViewEvent.EmojiViewShow, self.HandleEmojiShowSync)
  self:AddListenEvt(MainViewEvent.HideMapForbidNode, self.OnHideMapForbidNode)
  self:AddListenEvt(MainViewEvent.ShowMapForbidNode, self.OnShowMapForbidNode)
  self:AddListenEvt(ServiceEvent.ChatCmdChatRetCmd, self.UpdateChatRoom)
  self:AddListenEvt(ChatRoomEvent.SystemMessage, self.UpdateChatRoom)
  self:AddListenEvt(ServiceEvent.ConnNetDelay, self.HandleConnNetDelay)
  self:AddListenEvt(ServiceUserProxy.RecvLogin, self.HandleRedTip)
  self:AddListenEvt(ServiceEvent.ChatCmdQueryVoiceUserCmd, self.RecvQueryVoice)
  self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.EnterTeam)
  self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.ExitTeam)
  self:AddListenEvt(ServiceEvent.GuildCmdEnterGuildGuildCmd, self.EnterGuild)
  self:AddListenEvt(ServiceEvent.GuildCmdExitGuildGuildCmd, self.ExitGuild)
  self:AddListenEvt(PVPEvent.PVP_PoringFightLaunch, self.HandlePoringFightBegin)
  self:AddListenEvt(PVPEvent.PVP_PoringFightShutdown, self.HandlePoringFightEnd)
  self:AddListenEvt(StoryAudioEvent.StoryAudioStart, self.StartStoryAudio)
  self:AddListenEvt(StoryAudioEvent.StoryAudioEnd, self.EndStoryAudio)
  self:AddListenEvt(ChatRoomEvent.HavePrivateChatMsg, self.HandlePritiveChat)
  self:AddListenEvt(MainViewEvent.HideMapForbidNode, self.OnHideMapForbidNode)
  self:AddListenEvt(MainViewEvent.ShowMapForbidNode, self.OnShowMapForbidNode)
  self:AddListenEvt(MainViewEvent.NewPlayerHide, self.HandleHideUIUserCmd)
  self:AddListenEvt(SetEvent.SetShowVoicePart, self.HandleSetShowVoicePart)
  self:AddListenEvt(PVPEvent.TeamTwelve_Launch, self.HandleTwelveLaunch)
  self:AddListenEvt(PVPEvent.TeamTwelve_ShutDown, self.HandleTwelveShutdown)
end

function MainViewChatMsgPage:HandleTwelveLaunch()
  if not PvpObserveProxy.Instance:IsRunning() then
    return
  end
  self.maxHeight = #self.worldMsgTweenValue - 1
  self.tweenLevel = 1
  self.fadeBtnSp.flip = 0
  self:SetTweenTransPos()
  self.chatGridTween.gameObject:SetActive(false)
  self.chatSimplifyView:ShowDot(false)
end

function MainViewChatMsgPage:HandleTwelveShutdown()
  if not PvpObserveProxy.Instance:IsRunning() then
    return
  end
  self.maxHeight = #self.worldMsgTweenValue
  self.fadeBtnSp.flip = 0
end

function MainViewChatMsgPage:HandlePritiveChat(data)
  local body = data.body
  local state
  if body then
    if body == 1 then
      self:ShowPrivateChatBtnTwinkle()
    else
      self:NewShowPrivateChatBtn()
    end
  else
    local isclear = ChatRoomProxy.Instance:IsClearUnreadCount()
    if isclear then
      self.chatPrivately:SetActive(false)
    else
      self:NewShowPrivateChatBtn()
    end
  end
end

function MainViewChatMsgPage:NewShowPrivateChatBtn()
  self.chatPrivately:SetActive(true)
end

function MainViewChatMsgPage:ShowPrivateChatBtnTwinkle()
  self:PlayUIEffect(EffectMap.UI.Eff_friend_chat, self.chatPrivately, true)
end

function MainViewChatMsgPage:HandlePoringFightBegin(note)
  self.mainViewChat:SetActive(false)
  self.buttonGridTween.gameObject:SetActive(false)
end

function MainViewChatMsgPage:HandlePoringFightEnd(note)
  self.mainViewChat:SetActive(true)
  self.buttonGridTween.gameObject:SetActive(true)
end

function MainViewChatMsgPage:InitShow()
  self.scale = 0.8
  self.worldMsgTweenValue = {
    0,
    86,
    130,
    406
  }
  self.fadeBtnBgTweenValue = {
    Vector3(self.fadeBtnTween.from.x, 29, self.fadeBtnTween.from.z),
    Vector3(self.fadeBtnTween.from.x, 71, self.fadeBtnTween.from.z),
    Vector3(self.fadeBtnTween.from.x, 114, self.fadeBtnTween.from.z),
    Vector3(self.fadeBtnTween.from.x, 390, self.fadeBtnTween.from.z)
  }
  self.chatGridTweenValue = {
    Vector3(self.chatGridTween.from.x, 10, self.chatGridTween.from.z),
    Vector3(self.chatGridTween.from.x, 47, self.chatGridTween.from.z),
    Vector3(self.chatGridTween.from.x, 91, self.chatGridTween.from.z),
    Vector3(self.chatGridTween.from.x, 367, self.chatGridTween.from.z)
  }
  self.buttonGridTweenValue = {
    Vector3(self.buttonGridTween.from.x, 60, self.buttonGridTween.from.z),
    Vector3(self.buttonGridTween.from.x, 102, self.buttonGridTween.from.z),
    Vector3(self.buttonGridTween.from.x, 145, self.buttonGridTween.from.z),
    Vector3(self.buttonGridTween.from.x, 421, self.buttonGridTween.from.z)
  }
  self.storyAudioTweenValue = {
    Vector3(self.storyAudioTween.from.x, 202, self.storyAudioTween.from.z),
    Vector3(self.storyAudioTween.from.x, 246, self.storyAudioTween.from.z)
  }
  self.tweenLevel = LocalSaveProxy.Instance:GetMainViewChatTweenLevel()
  self.isTeamSpeech = false
  self.isGuildSpeech = false
  self.maxHeight = #self.worldMsgTweenValue
  local initParama = ReusableTable.CreateTable()
  initParama.gameObject = self.mainViewChat
  initParama.chatCellCtrl = MainViewChatGroup
  initParama.chatCellPfb = "MainViewChatGroup"
  self.chatSimplifyView = self:AddSubView("ChatSimplifyView", ChatSimplifyView, initParama)
  ReusableTable.DestroyAndClearTable(initParama)
  FunctionChatSpeech.Me():Reset(self.speechRecognizer.gameObject, function()
    self:sendNotification(ChatRoomEvent.StopVoice)
    FunctionChatSpeech.Me():SetCurrentVoiceId(nil)
    ChatRoomProxy.Instance:AutoSpeechFinish()
    FunctionBGMCmd.Me():EndSpeakVoice()
  end)
  if TeamProxy.Instance:IHaveTeam() then
    self:EnterTeam()
  else
    self:ExitTeam()
  end
  if GuildProxy.Instance:IHaveGuild() then
    self:EnterGuild()
  else
    self:ExitGuild()
  end
  local cells = self.chatSimplifyView.chatCtl:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    local channel = GameConfig.ChatRoom.MainView[i]
    if channel then
      cell:SetTweenLevel(self.tweenLevel)
    end
  end
  self:InitTween()
end

function MainViewChatMsgPage:HandleEmojiShowSync(note)
  self.isEmojiShow = note.body
end

function MainViewChatMsgPage:OnHideMapForbidNode()
  self.actPartTrans.gameObject:SetActive(false)
end

function MainViewChatMsgPage:OnShowMapForbidNode()
  self.actPartTrans.gameObject:SetActive(true)
end

function MainViewChatMsgPage:UpdateChatRoom(note)
  if note then
    local data = note.body
    if data and data:GetCellType() ~= ChatTypeEnum.SystemMessage and data:GetExpressionId() == 0 and ChatRoomProxy.Instance:IsPlayerSpeak(data:GetChannel()) then
      local playerid, str = data:GetId(), data:GetShowStr(true)
      if playerid and str then
        SceneUIManager.Instance:PlayerSpeak(playerid, AppendSpace2Str(str))
      end
    end
  end
end

function MainViewChatMsgPage:LoadCellPfb(cellPfb, cName, parent)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cellPfb))
  cellpfb.transform:SetParent(parent.transform, false)
  cellpfb.name = cName
  return cellpfb
end

function MainViewChatMsgPage:InitTween()
  local worldMsgSp = self.worldMsgTween.gameObject:GetComponent(UISprite)
  worldMsgSp.height = self.worldMsgTweenValue[self.tweenLevel]
  self.worldMsgCollider.size = LuaGeometry.GetTempVector3(self.worldMsgCollider.size.x * self.scale, self.worldMsgTweenValue[self.tweenLevel] * self.scale, self.worldMsgCollider.size.z * self.scale)
  self.worldMsgCollider.center = LuaGeometry.GetTempVector3(self.worldMsgCollider.center.x, self.worldMsgTweenValue[self.tweenLevel] / 2, self.worldMsgCollider.center.z)
  self.fadeBtnTweenTrans.localPosition = self.fadeBtnBgTweenValue[self.tweenLevel]
  if self.tweenLevel == self.maxHeight then
    self.fadeBtnSp.flip = 1
  else
    self.fadeBtnSp.flip = 0
  end
  self.isPlaying = false
  self.chatGridTween.transform.localPosition = self.chatGridTweenValue[self.tweenLevel]
  self.buttonGridTween.transform.localPosition = self.buttonGridTweenValue[self.tweenLevel]
  if self.storyAudioTweenValue[self.tweenLevel] and self.isPlaying then
    self.storyAudioContainer:SetActive(true)
    self.storyAudioContainer.transform.localPosition = self.storyAudioTweenValue[self.tweenLevel]
  else
    self.storyAudioContainer:SetActive(false)
  end
  self.chatGridTween.gameObject:SetActive(self.tweenLevel ~= 1)
  self.chatSimplifyView:ShowDot(self.tweenLevel ~= 1)
end

function MainViewChatMsgPage:FadeTween()
  self:SetTweenValue()
  self:ResetBtnGridPos()
  self.worldMsgTween:ResetToBeginning()
  self.fadeBtnTween:ResetToBeginning()
  self.chatGridTween:ResetToBeginning()
  self.buttonGridTween:ResetToBeginning()
  if self.storyAudioTweenValue[self.tweenLevel] and self.isPlaying then
    self.storyAudioContainer:SetActive(true)
    self.storyAudioTween:ResetToBeginning()
  else
    self.storyAudioContainer:SetActive(false)
  end
  self.worldMsgTween:PlayForward()
  self.fadeBtnTween:PlayForward()
  self.chatGridTween:PlayForward()
  self.buttonGridTween:PlayForward()
  if self.storyAudioTweenValue[self.tweenLevel] and self.isPlaying then
    self.storyAudioTween:PlayForward()
  end
  local cells = self.chatSimplifyView.chatCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetTweenLevel(self.tweenLevel)
  end
  if self.tweenLevel == self.maxHeight then
    self.fadeBtnSp.flip = 1
  else
    self.fadeBtnSp.flip = 0
  end
end

function MainViewChatMsgPage:ResetBtnGridPos()
  if self.tweenLevel == 1 then
    TimeTickManager.Me():CreateOnceDelayTick(200, function()
      self.chatGridTween.gameObject:SetActive(false)
      self.chatSimplifyView:ShowDot(false)
    end, self, 1000)
  elseif self.tweenLevel == 2 then
    self.chatGridTween.gameObject:SetActive(true)
    self.chatSimplifyView:ShowDot(true)
  end
end

function MainViewChatMsgPage:InitBtnGridPos(isBottom)
  if isBottom then
    if self.isShowVoicePart then
      self.voicePartTrans.localPosition = LuaGeometry.GetTempVector3(btnGridPosArr[1])
      self.actPartTrans.localPosition = LuaGeometry.GetTempVector3(btnGridPosArr[2])
    else
      self.cameraPartTrans.localPosition = LuaGeometry.GetTempVector3(btnGridPosArr[1])
      self.actPartTrans.localPosition = LuaGeometry.GetTempVector3(btnGridPosArr[2])
    end
  elseif self.isShowVoicePart then
    self.voicePartTrans.localPosition = LuaGeometry.GetTempVector3(btnGridPosArr[2])
    self.actPartTrans.localPosition = LuaGeometry.GetTempVector3(btnGridPosArr[1])
  else
    self.cameraPartTrans.localPosition = LuaGeometry.GetTempVector3(btnGridPosArr[2])
    self.actPartTrans.localPosition = LuaGeometry.GetTempVector3(btnGridPosArr[1])
  end
end

function MainViewChatMsgPage:SetTweenTransPos()
  self.worldMsgTweenSprite.height = self.worldMsgTweenValue[self.tweenLevel]
  self.fadeBtnTweenTrans.localPosition = self.fadeBtnBgTweenValue[self.tweenLevel]
  self.chatGridTweenTrans.localPosition = self.chatGridTweenValue[self.tweenLevel]
  self.buttonGridTweenTrans.localPosition = self.buttonGridTweenValue[self.tweenLevel]
end

function MainViewChatMsgPage:SetTweenValue()
  if self.worldMsgTweenValue[self.tweenLevel] then
    local nextLevel = self.tweenLevel < self.maxHeight and self.tweenLevel + 1 or 1
    self.worldMsgTween.from = self.worldMsgTweenValue[self.tweenLevel]
    self.worldMsgTween.to = self.worldMsgTweenValue[nextLevel]
    self.fadeBtnTween.from = self.fadeBtnBgTweenValue[self.tweenLevel]
    self.fadeBtnTween.to = self.fadeBtnBgTweenValue[nextLevel]
    self.chatGridTween.from = self.chatGridTweenValue[self.tweenLevel]
    self.chatGridTween.to = self.chatGridTweenValue[nextLevel]
    self.buttonGridTween.from = self.buttonGridTweenValue[self.tweenLevel]
    self.buttonGridTween.to = self.buttonGridTweenValue[nextLevel]
    if self.storyAudioTweenValue[nextLevel] then
      if self.tweenLevel == self.maxHeight then
        self.storyAudioTween.from = self.storyAudioTweenValue[2]
      else
        self.storyAudioTween.from = self.storyAudioTweenValue[self.tweenLevel]
      end
      self.storyAudioTween.to = self.storyAudioTweenValue[nextLevel]
    end
    self.tweenLevel = nextLevel
    LocalSaveProxy.Instance:SetMainViewChatTweenLevel(self.tweenLevel)
  end
end

function MainViewChatMsgPage:HandleConnNetDelay()
  if ChatZoomProxy.Instance:IsInChatZone() then
    ServiceChatRoomProxy.Instance:RecvExitChatRoom()
  end
end

function MainViewChatMsgPage:HandleRedTip()
  ChatRoomProxy.Instance:CheckRedTip()
end

function MainViewChatMsgPage:RecvQueryVoice(note)
  local data = note.body
  printOrange("RecvQueryVoice")
  if data and data.path then
    FunctionChatSpeech.Me():PlayAudioByPath(data.path, data.voiceid)
  end
end

function MainViewChatMsgPage:EnterTeam()
  if TeamProxy.Instance:IHaveTeam() then
    self:SetShowVoicePart(nil, ApplicationInfo.NeedOpenVoiceSend() and GuildProxy.Instance:IHaveGuild())
  end
  self:SetShowVoicePart(not BranchMgr.IsTW() and MicrophoneManipulate.CanSpeech())
  if self.ButtonGrid_UIGrid then
    self.ButtonGrid_UIGrid.repositionNow = true
  end
end

function MainViewChatMsgPage:ExitTeam()
  if not TeamProxy.Instance:IHaveTeam() then
    self:SetShowVoicePart(false)
  end
  if self.ButtonGrid_UIGrid then
    self.ButtonGrid_UIGrid.repositionNow = true
  end
end

function MainViewChatMsgPage:EnterGuild()
  local needOpenVoiceSend = ApplicationInfo.NeedOpenVoiceSend()
  self:SetShowVoicePart(needOpenVoiceSend, needOpenVoiceSend)
  if self.ButtonGrid_UIGrid then
    self.ButtonGrid_UIGrid.repositionNow = true
  end
end

function MainViewChatMsgPage:ExitGuild()
  self:SetShowVoicePart(nil, false)
  if self.ButtonGrid_UIGrid then
    self.ButtonGrid_UIGrid.repositionNow = true
  end
end

function MainViewChatMsgPage:HideStoryAudio(b)
  self.storyAudioContainer:SetActive(not b)
end

function MainViewChatMsgPage:ShowAudioContext(context)
  if context and 0 < #context then
    self.contentEffect:Finish()
    self.audioContent.gameObject:SetActive(true)
    self.audioContent.text = context
    self.contentEffect:ResetToBeginning()
    local charSize = StringUtil.getTextLen(context)
    if self.hidelt then
      self.hidelt:Destroy()
    end
    local labelW = charSize * CharW
    self.textContainer.duration = charSize / 2
    self.textContainer.from = 0
    self.textContainer.to = labelW + 30
    self.textContainer:ResetToBeginning()
    self.textContainer:PlayForward()
    self.textContainer:SetOnFinished(function()
      if self.textContainer.to == 0 then
        local audiodata = PlotAudioProxy.Instance:GetCurrentAudioData()
        if audiodata then
          audiodata:SetDisplay(true)
        end
        self.textContainer.gameObject:SetActive(false)
      end
    end)
    self.hidelt = TimeTickManager.Me():CreateOnceDelayTick(charSize * 2000, function(owner, deltaTime)
      self:Hide()
    end, self)
  end
end

function MainViewChatMsgPage:TweenAudioContext()
  self.bgTw = self.bgTp.gameObject:GetComponent(TweenWidth)
end

function MainViewChatMsgPage:Hide()
  self.hidelt = nil
  self.textContainer.duration = 0.5
  self.textContainer.from = self.textSP.width
  self.textContainer.to = 0
  self.textContainer:ResetToBeginning()
  self.textContainer:PlayForward()
  self.audioContent.gameObject:SetActive(false)
end

function MainViewChatMsgPage:ShowDefaultAudioBtn()
  self.playing:SetActive(false)
  self.default:SetActive(true)
  self.pause:SetActive(false)
end

function MainViewChatMsgPage:ShowPlayingAudioBtn()
  self.playing:SetActive(true)
  self.default:SetActive(false)
  self.pause:SetActive(false)
end

function MainViewChatMsgPage:ShowPauseAudioBtn()
  self.playing:SetActive(false)
  self.default:SetActive(false)
  self.pause:SetActive(true)
end

function MainViewChatMsgPage:StartStoryAudio()
  local audiodata = PlotAudioProxy.Instance:GetCurrentAudioData()
  if not audiodata then
    self.storyAudioContainer:SetActive(false)
    self:ShowDefaultAudioBtn()
    return
  end
  if FunctionPlotCmd:IsPlayTypeEqualTo(FunctionPlotCmd.AudioSort.PlotAudio) then
    self.storyAudioContainer:SetActive(false)
    return
  end
  self.storyAudioContainer:SetActive(true)
  self.isPlaying = true
  local playstatus = audiodata:GetPlayStatus()
  if playstatus == PlotAudioData.AudioStatus.Playing then
    self:ShowPlayingAudioBtn()
    self.playingState = 1
  else
    self.playingState = 2
    self:ShowPauseAudioBtn()
  end
  if audiodata:CheckDisplay() then
    return
  end
  if not audiodata:CheckHideText() then
    voiceTxt = audiodata:GetAudioText()
  else
    voiceTxt = ""
  end
  self.textContainer.gameObject:SetActive(voiceTxt and 0 < #voiceTxt or false)
  self:ShowAudioContext(voiceTxt)
end

function MainViewChatMsgPage:EndStoryAudio()
  self.playingState = 0
  self.isPlaying = false
  self:ShowDefaultAudioBtn()
  self.textContainer.gameObject:SetActive(false)
  self.contentEffect:Finish()
  self.storyAudioContainer:SetActive(false)
end

function MainViewChatMsgPage:PauseStoryAudio()
  local playType = PlotAudioProxy.Instance:GetCurrentPlayType()
  if playType == PlotAudioData.AudioType.PlotAudio then
    PlotAudioProxy.Instance:PauseCurrentPlotAudio()
  elseif playType == PlotAudioData.AudioType.StoryAudio then
    PlotAudioProxy.Instance.needCenterOn = true
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.QuestManualView
    })
  end
end

function MainViewChatMsgPage:ResumeStoryAudio()
  local playType = PlotAudioProxy.Instance:GetCurrentPlayType()
  if playType == PlotAudioData.AudioType.PlotAudio then
    PlotAudioProxy.Instance:ResumeCurrentPlotAudio()
  elseif playType == PlotAudioData.AudioType.StoryAudio then
    PlotAudioProxy.Instance.needCenterOn = true
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.QuestManualView
    })
  end
end

function MainViewChatMsgPage:OnHideMapForbidNode()
  self.mainViewChat:SetActive(false)
end

function MainViewChatMsgPage:OnShowMapForbidNode()
  self.mainViewChat:SetActive(true)
end

function MainViewChatMsgPage:HandleHideUIUserCmd(note)
  local data = note.body
  local on = data.open
  if on == 1 then
    if TableUtility.ArrayFindIndex(data.id, 4) > 0 then
      self.mainViewChat:SetActive(false)
    end
  else
    self.mainViewChat:SetActive(true)
  end
end

function MainViewChatMsgPage:HandleSetShowVoicePart()
  self:SetShowVoicePart()
end

function MainViewChatMsgPage:SetShowVoicePart(isTeamSpeechShow, isGuildSpeechShow)
  local nowTeamShowing, nowGuildShowing = self.teamSpeech.gameObject.activeSelf, self.guildSpeech.gameObject.activeSelf
  if isTeamSpeechShow ~= nil then
    nowTeamShowing = isTeamSpeechShow and true or false
    self.teamSpeech.gameObject:SetActive(nowTeamShowing)
  end
  if isGuildSpeechShow ~= nil then
    nowGuildShowing = isGuildSpeechShow and true or false
    self.guildSpeech.gameObject:SetActive(nowGuildShowing)
  end
  self.isShowVoicePart = nowTeamShowing or nowGuildShowing
  if not FunctionPerformanceSetting.Me():GetVoicePartShowing() then
    helplog("VoicePartShowing of current setting is false. The whole voice part will be hidden.")
    self.isShowVoicePart = false
  end
  self.voicePart:SetActive(self.isShowVoicePart)
  self:RefreshVoiceArrow()
end

function MainViewChatMsgPage:RefreshVoiceArrow()
  if not (not self.teamSpeech.gameObject.activeSelf or self.guildSpeech.gameObject.activeSelf) or not self.teamSpeech.gameObject.activeSelf and self.guildSpeech.gameObject.activeSelf then
    self.voiceArrow:SetActive(false)
    self.voiceGridObj:SetActive(true)
    self.voicePartBG.width = 60
    self.guildSpeech.alpha = 1
    return
  end
  self.voiceArrow:SetActive(true)
  if self.voiceArrowStatus then
    self.voiceArrowTweenPos:PlayForward()
    LuaQuaternion.Better_SetEulerAngles(tempRot, LuaGeometry.GetTempVector3(0, 0, 90))
    self.voiceArrowIcon.transform.localRotation = tempRot
    self.guildSpeech.alpha = 1
    self.voicePartBGTweenWidth:PlayForward()
  else
    self.voiceArrowTweenPos:PlayReverse()
    LuaQuaternion.Better_SetEulerAngles(tempRot, LuaGeometry.GetTempVector3(0, 0, -90))
    self.voiceArrowIcon.transform.localRotation = tempRot
    self.guildSpeech.alpha = 0
    self.voicePartBGTweenWidth:PlayReverse()
  end
end
