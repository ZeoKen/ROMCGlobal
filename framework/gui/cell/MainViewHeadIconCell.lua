autoImport("HeadIconCell")
autoImport("Table_Head_Config")
autoImport("MainViewGMEPartVirtualCell")
MainViewHeadIconCell = class("MainViewHeadIconCell", HeadIconCell)
MainViewHeadIconCell.path = ResourcePathHelper.UICell("MainViewHeadIconCell")
MainViewHeadIconCell.partPath = "GUI/v1/cell/HeadIconCellParts/"
local tempV3 = LuaVector3()
local tempSB = LuaStringBuilder.CreateAsTable()
local offset = LuaVector2()
local ratio = LuaVector2()
ratio:Set(120, 80)
local strOff = "OFF"
local strON = "ON"

function MainViewHeadIconCell:CreateSelf(parent)
  if parent then
    self.gameObject = self:CreateObj(MainViewHeadIconCell.path, parent)
    self:FindObjs()
    self.m_micIsOpen = false
    self.m_speakerIsOpen = false
  end
end

function MainViewHeadIconCell:SetGME()
  if self.m_isInitGo ~= nil and self.m_isInitGo then
    return
  end
  self.GMEPart = self:FindGO("GMEPart")
  self.GMEPart:SetActive(false)
  self.GMESetting = self:FindGO("GMESetting")
  self.GMESetting:SetActive(false)
  self.GMEState1 = self:FindGO("state1", self.GMEPart)
  self.GMEState2 = self:FindGO("state2", self.GMEPart)
  self.GMEState3 = self:FindGO("state3", self.GMEPart)
  self.GMEMic = self:FindGO("Mic", self.GMESetting)
  self.GMESpeaker = self:FindGO("Speaker", self.GMESetting)
  self.GMEMicBg = self:FindGO("Toggle/bg", self.GMEMic):GetComponent(UISprite)
  self.GMEMicThumb = self:FindGO("Toggle/bg/thumb", self.GMEMic)
  self.GMEMicThumbLabel = self:FindComponent("Label", UILabel, self.GMEMicThumb)
  self.m_uiImgMicBan = self:FindGO("ban", self.GMEMic)
  self.GMESpeakerBg = self:FindGO("Toggle/bg", self.GMESpeaker):GetComponent(UISprite)
  self.GMESpeakerThumb = self:FindGO("Toggle/bg/thumb", self.GMESpeaker)
  self.GMESpeakerThumbLabel = self:FindComponent("Label", UILabel, self.GMESpeakerThumb)
  self.m_uiImgSpeakerBan = self:FindGO("ban", self.GMESpeaker)
  self.effectContainer = self:FindGO("effectContainer")
  if (self.data and self.data.isMyself == 1 or self.isMyself == 1) and (not MainViewGMEPartVirtualCell or not MainViewGMEPartVirtualCell.USE_NEW_GME_PART) then
    self.m_memberCount = 0
    self.m_onlineCount = 0
    self:AddGMEEvent()
    if self:isNotChina65Var() then
      self.GMEPart:SetActive(false)
    elseif TeamProxy.Instance:IHaveTeam() or TeamProxy.Instance:IHaveGroup() then
      if self.GMEPart.activeSelf == not GameConfig.SystemForbid.OpenVoice then
        return
      end
      self.GMEPart:SetActive(not GameConfig.SystemForbid.OpenVoice)
      self:onTeamUpdate()
      self:GMEUpdateSelf()
    end
  end
  self.m_isInitGo = true
end

function MainViewHeadIconCell.isNotChina65Var()
  return not BranchMgr.IsChina() and BackwardCompatibilityUtil.CompatibilityMode_V65
end

function MainViewHeadIconCell:CloseSelf()
  self:RemoveEvents()
  self.m_isInitGo = false
  self:removePauseTickTime()
  MainViewHeadIconCell.super.CloseSelf(self)
end

function MainViewHeadIconCell:AddGMEEvent()
  if self.m_isAddEvent ~= nil and self.m_isAddEvent then
    return
  end
  EventManager.Me():AddEventListener(GMEEvent.OnEnterRoom, self.GMEEnterRoom, self)
  EventManager.Me():AddEventListener(GMEEvent.OnExitRoom, self.GMEExitRoom, self)
  EventManager.Me():AddEventListener(GMEEvent.OnTeamUpdate, self.onTeamUpdate, self)
  EventManager.Me():AddEventListener(GMEEvent.OnSelfState, self.GMEUpdateSelf, self)
  EventManager.Me():AddEventListener(GMEEvent.OnMemberUpdateBackListInfo, self.updateTeamInfo, self)
  EventManager.Me():AddEventListener(GMEEvent.OnDisconnect, self.onDisconnect, self)
  EventManager.Me():AddEventListener(TeamEvent.MemberEnterTeam, self.onEnterTeam, self)
  EventManager.Me():AddEventListener(TeamEvent.MemberExitTeam, self.onExitTeam, self)
  EventManager.Me():AddEventListener(TeamEvent.MemberOffline, self.onMemberOffline, self)
  EventManager.Me():AddEventListener(TeamEvent.MemberOnline, self.onTeamUpdate, self)
  EventManager.Me():AddEventListener(TeamEvent.MemberEnterGroup, self.onEnterTeam)
  EventManager.Me():AddEventListener(TeamEvent.MemberExitGroup, self.onExitTeam)
  EventManager.Me():AddEventListener(TeamEvent.ExitGroup, self.onExitTeam)
  EventManager.Me():AddEventListener(ServiceEvent.SessionTeamMemberDataUpdate, self.onTeamUpdate, self)
  EventManager.Me():AddEventListener(ServiceEvent.SessionTeamQueryGroupTeamApplyListTeamCmd, self.onTeamUpdate, self)
  if ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer then
    EventManager.Me():AddEventListener(AppStateEvent.Focus, self.onIosPaused, self)
  elseif ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
    EventManager.Me():AddEventListener(AppStateEvent.Pause, self.onAndroidPaused, self)
  end
  EventManager.Me():AddEventListener(LoadSceneEvent.BeginLoadScene, self.onLoadScene, self)
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.onLoadSceneFinished, self)
  EventManager.Me():AddEventListener(AppStateEvent.BackToLogo, self.onBackToLogo, self)
  GmeVoiceProxy.Instance:Init()
  self:AddClickEvent(self.GMEPart.gameObject, function()
    if not GmeVoiceProxy.Instance:CanEnterRoom() then
      return
    end
    self:updateMicToggleState()
    self:updateSpeakerToggleState()
    self.GMESetting:SetActive(not self.GMESetting.activeSelf)
  end)
  self:AddClickEvent(self.GMEMicBg.gameObject, function()
    self:onClickMis()
  end)
  self:AddClickEvent(self.GMESpeakerBg.gameObject, function()
    self:onClickSpeaker()
  end)
  self.m_isAddEvent = true
  self.m_isRemoveEvent = false
end

function MainViewHeadIconCell:RemoveEvents()
  if self.m_isRemoveEvent ~= nil and self.m_isRemoveEvent then
    return
  end
  EventManager.Me():RemoveEventListener(GMEEvent.OnEnterRoom, self.GMEEnterRoom, self)
  EventManager.Me():RemoveEventListener(GMEEvent.OnExitRoom, self.GMEExitRoom, self)
  EventManager.Me():RemoveEventListener(GMEEvent.OnTeamUpdate, self.onTeamUpdate, self)
  EventManager.Me():RemoveEventListener(GMEEvent.OnSelfState, self.GMEUpdateSelf, self)
  EventManager.Me():RemoveEventListener(GMEEvent.OnMemberUpdateBackListInfo, self.updateTeamInfo, self)
  EventManager.Me():RemoveEventListener(GMEEvent.OnDisconnect, self.onDisconnect, self)
  EventManager.Me():RemoveEventListener(TeamEvent.MemberEnterTeam, self.onEnterTeam, self)
  EventManager.Me():RemoveEventListener(TeamEvent.MemberExitTeam, self.onExitTeam, self)
  EventManager.Me():RemoveEventListener(TeamEvent.MemberOffline, self.onMemberOffline, self)
  EventManager.Me():RemoveEventListener(TeamEvent.MemberOnline, self.onTeamUpdate, self)
  EventManager.Me():RemoveEventListener(TeamEvent.MemberEnterGroup, self.onEnterTeam)
  EventManager.Me():RemoveEventListener(TeamEvent.MemberExitGroup, self.onExitTeam)
  EventManager.Me():RemoveEventListener(TeamEvent.ExitGroup, self.onExitTeam)
  EventManager.Me():RemoveEventListener(ServiceEvent.SessionTeamMemberDataUpdate, self.onTeamUpdate, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.SessionTeamQueryGroupTeamApplyListTeamCmd, self.onTeamUpdate, self)
  if ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer then
    EventManager.Me():RemoveEventListener(AppStateEvent.Focus, self.onIosPaused, self)
  elseif ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
    EventManager.Me():RemoveEventListener(AppStateEvent.Pause, self.onAndroidPaused, self)
  end
  EventManager.Me():RemoveEventListener(LoadSceneEvent.BeginLoadScene, self.onLoadScene, self)
  EventManager.Me():RemoveEventListener(LoadSceneEvent.FinishLoadScene, self.onLoadSceneFinished, self)
  EventManager.Me():RemoveEventListener(AppStateEvent.BackToLogo, self.onBackToLogo, self)
  self.m_isAddEvent = false
  self.m_isRemoveEvent = true
end

function MainViewHeadIconCell:onBackToLogo()
  GmeVoiceProxy.Instance:clearGmeData()
end

function MainViewHeadIconCell:onLoadScene()
  self.m_isChangeScene = true
end

function MainViewHeadIconCell:onLoadSceneFinished()
  self.m_isChangeScene = false
end

function MainViewHeadIconCell:onTeamUpdate(data)
  if GameConfig.SystemForbid.OpenVoice then
    return
  end
  if MainViewGMEPartVirtualCell and MainViewGMEPartVirtualCell.USE_NEW_GME_PART then
    return
  end
  if self.m_isChangeScene == true then
    return
  end
  local gme = GmeVoiceProxy.Instance
  self.m_memberCount = 0
  self.m_onlineCount = 0
  if TeamProxy.Instance:IHaveGroup() then
    local team = TeamProxy.Instance.uniteGroupTeam
    if team ~= nil then
      local list = team:GetMembersList()
      for _, v in pairs(list) do
        if v.cat == 0 and v.accid ~= 0 then
          self.m_memberCount = self.m_memberCount + 1
          if v.offline == 0 then
            self.m_onlineCount = self.m_onlineCount + 1
          end
        end
      end
    end
    team = TeamProxy.Instance.myTeam
    local list = team:GetMembersList()
    for _, v in pairs(list) do
      if v.cat == 0 and v.accid ~= 0 then
        self.m_memberCount = self.m_memberCount + 1
        if v.offline == 0 then
          self.m_onlineCount = self.m_onlineCount + 1
        end
      end
    end
    redlog("GME -> UPDATE GROUP MEMBER COUNT")
    gme:checkIsNeedChangeRoom(self.m_memberCount, self.m_onlineCount)
    if self:isNotChina65Var() then
      self.GMEPart:SetActive(false)
    else
      self.GMEPart:SetActive(true)
    end
  elseif TeamProxy.Instance:IHaveTeam() then
    local team = TeamProxy.Instance.myTeam
    local list = team:GetMembersList()
    for _, v in pairs(list) do
      if v.cat == 0 and v.accid ~= 0 then
        self.m_memberCount = self.m_memberCount + 1
        if v.offline == 0 then
          self.m_onlineCount = self.m_onlineCount + 1
        end
      end
    end
    gme:checkIsNeedChangeRoom(self.m_memberCount, self.m_onlineCount)
    redlog("GME -> UPDATE TEAM MEMBER COUNT")
    if self:isNotChina65Var() then
      self.GMEPart:SetActive(false)
    else
      self.GMEPart:SetActive(true)
    end
  else
    self.GMEPart:SetActive(false)
    self.GMESetting:SetActive(false)
  end
  self:GMEUpdateSelf()
  if gme:IsInRoom() then
    self:onCheckIsNeedExitRoom()
  end
end

function MainViewHeadIconCell:onClickMis()
  local gme = GmeVoiceProxy.Instance
  local code = gme:isCanUseGME(self.m_memberCount, self.m_onlineCount)
  if not gme:IsInRoom() and 0 ~= code then
    MsgManager.ShowMsgByID(42112)
    return
  end
  if not self.m_micIsOpen then
    if gme:isInitSuccess() then
      if gme:IsInRoom() then
        self.m_waitExitRoom = true
        gme:ExitRoom()
      else
        self.m_waitExitRoom = false
        gme:EnterRoom()
      end
    end
  else
    gme:ExitRoom()
    self.m_waitExitRoom = false
  end
end

function MainViewHeadIconCell:onClickSpeaker()
  for _, v in pairs(TeamProxy.Instance.myTeam:GetMembersList()) do
    if v.id == Game.Myself.data.id and v.mute ~= 0 then
      MsgManager.ShowMsgByID(42121)
      return
    end
  end
  if not self.m_micIsOpen then
    MsgManager.ShowMsgByID(42110)
    return
  end
  if ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android then
    if 0 ~= FunctionPermission.Me():RequestRecordAudioPermission() then
      MsgManager.ShowMsgByID(43109)
      self:GMEUpdateSelf()
      return
    end
  elseif ApplicationInfo.GetRunPlatform() == RuntimePlatform.IPhonePlayer and not ExternalInterfaces.isAudioMicrophoneValid_iOS() then
    MsgManager.ShowMsgByID(43109)
    self:GMEUpdateSelf()
    return
  end
  self.m_speakerIsOpen = not self.m_speakerIsOpen
  GmeVoiceProxy.Instance:SetMic(self.m_speakerIsOpen)
  self:updateSpeakerToggleState(self.m_speakerIsOpen)
  self:GMEUpdateSelf()
end

function MainViewHeadIconCell:updateSpeakerToggleState()
  if GmeVoiceProxy.Instance:isInitSuccess() and GmeVoiceProxy.Instance:IsInRoom() then
    local isOpen = GmeVoiceProxy.Instance:GetMic()
    if isOpen then
      self.GMESpeakerThumb.transform.localPosition = LuaGeometry.GetTempVector3(16, 0, 0)
      self.GMESpeakerThumbLabel.text = strON
      self.GMESpeakerBg.color = LuaColor(0.396078431372549, 0.6235294117647059, 1, 1)
    else
      self.GMESpeakerThumb.transform.localPosition = LuaGeometry.GetTempVector3(52, 0, 0)
      self.GMESpeakerThumbLabel.text = strOff
      self.GMESpeakerBg.color = LuaColor(1, 1, 1, 1)
    end
    self.m_uiImgSpeakerBan:SetActive(not isOpen)
  else
    self.GMESpeakerThumb.transform.localPosition = LuaGeometry.GetTempVector3(52, 0, 0)
    self.GMESpeakerThumbLabel.text = strOff
    self.GMESpeakerBg.color = LuaColor(1, 1, 1, 1)
    self.m_uiImgSpeakerBan:SetActive(false)
  end
end

function MainViewHeadIconCell:updateMicToggleState()
  if GmeVoiceProxy.Instance:isInitSuccess() and GmeVoiceProxy.Instance:IsInRoom() then
    local isOpen = GmeVoiceProxy.Instance:GetSpeaker()
    if isOpen then
      self.GMEMicThumb.transform.localPosition = LuaGeometry.GetTempVector3(16, 0, 0)
      self.GMEMicThumbLabel.text = strON
      self.GMEMicBg.color = LuaColor(0.396078431372549, 0.6235294117647059, 1, 1)
    else
      self.GMEMicThumb.transform.localPosition = LuaGeometry.GetTempVector3(52, 0, 0)
      self.GMEMicThumbLabel.text = strOff
      self.GMEMicBg.color = LuaColor(1, 1, 1, 1)
    end
    self.m_uiImgMicBan:SetActive(not isOpen)
  else
    self.GMEMicThumb.transform.localPosition = LuaGeometry.GetTempVector3(52, 0, 0)
    self.GMEMicThumbLabel.text = strOff
    self.GMEMicBg.color = LuaColor(1, 1, 1, 1)
    self.m_uiImgMicBan:SetActive(false)
  end
end

function MainViewHeadIconCell:onEnterTeam(value)
  if GameConfig.SystemForbid.OpenVoice then
    return
  end
  if MainViewGMEPartVirtualCell and MainViewGMEPartVirtualCell.USE_NEW_GME_PART then
    return
  end
  if self.m_isChangeScene == true then
    return
  end
  local groupId = TeamProxy.Instance.myTeam.groupid
  if TeamProxy.Instance:IHaveGroup() then
    redlog("GME ENTER TEAM | IS HAVE GROUP")
  elseif TeamProxy.Instance:IHaveTeam() then
    local team = TeamProxy.Instance.myTeam
    self.m_memberCount = 0
    self.m_onlineCount = 0
    local list = team:GetMembersList()
    for _, v in pairs(list) do
      if v.cat == 0 and v.accid ~= 0 then
        self.m_memberCount = self.m_memberCount + 1
        if v.offline == 0 then
          self.m_onlineCount = self.m_onlineCount + 1
        end
      end
    end
    GmeVoiceProxy.Instance:checkIsNeedChangeRoom(self.m_memberCount, self.m_onlineCount)
    if self:isNotChina65Var() then
      self.GMEPart:SetActive(false)
    else
      self.GMEPart:SetActive(true)
    end
    self:GMEUpdateSelf()
    redlog("GME -> UPDATE TEAM MEMBER COUNT")
    if GmeVoiceProxy.Instance:IsInRoom() then
      self:onCheckIsNeedExitRoom()
    end
  else
    self.GMEPart:SetActive(false)
    self.GMESetting:SetActive(false)
    self:GMEUpdateSelf()
  end
end

function MainViewHeadIconCell:onExitTeam(value)
  if self.data == nil then
    return
  end
  if value ~= nil and value.data.isClient then
    redlog("GME -> client remove")
    return
  end
  self:isNeedExitRoom()
end

function MainViewHeadIconCell:onDisconnect()
  GmeVoiceProxy.Instance:ExitRoom()
  self.GMEPart:SetActive(false)
  self.GMESetting:SetActive(false)
  self:GMEUpdateSelf()
  self:removePauseTickTime()
end

function MainViewHeadIconCell:onCheckIsNeedExitRoom()
  local code = GmeVoiceProxy.Instance:isCanUseGME(self.m_memberCount, self.m_onlineCount)
  redlog("GME -> CHECK IS NEED EXIT ROOM CODE = " .. code)
  if 1 == code then
    if GmeVoiceProxy.Instance:IsInRoom() then
      GmeVoiceProxy.Instance:ExitRoom()
    else
      self.GMEPart:SetActive(false)
      self.GMESetting:SetActive(false)
      self:GMEUpdateSelf()
    end
  elseif 2 == code then
    GmeVoiceProxy.Instance:onDealyCheckExitRoom(self, self.isNeedExitRoom)
  else
    GmeVoiceProxy.Instance:removeExitRoomTickTime()
  end
end

function MainViewHeadIconCell:isNeedExitRoom()
  self:onTeamUpdate()
  local code = GmeVoiceProxy.Instance:isCanUseGME(self.m_memberCount, self.m_onlineCount)
  redlog("GME -> RECHECK IS NEED EXIT ROOM CODE = " .. code)
  if code ~= 0 then
    if GmeVoiceProxy.Instance:IsInRoom() then
      GmeVoiceProxy.Instance:ExitRoom()
    else
      self.GMEPart:SetActive(false)
      self.GMESetting:SetActive(false)
      self:GMEUpdateSelf()
    end
  else
    GmeVoiceProxy.Instance:removeExitRoomTickTime()
  end
end

function MainViewHeadIconCell:onMemberOffline(value)
  if value ~= nil and value.data ~= nil and value.data.id ~= nil and GmeVoiceProxy.Instance:isInMyselfBanList(value.data.id) then
    GmeVoiceProxy.Instance:removeMyselfBanList(value.data.id)
  end
  self:onTeamUpdate()
end

function MainViewHeadIconCell:GMEUpdateSelf()
  self.GMEState1:SetActive(false)
  self.GMEState2:SetActive(false)
  self.GMEState3:SetActive(false)
  if self.m_micIsOpen then
    if self.m_speakerIsOpen then
      self.GMEState1:SetActive(true)
    else
      self.GMEState2:SetActive(true)
    end
  else
    self.GMEState3:SetActive(true)
  end
end

function MainViewHeadIconCell:GMEEnterRoom()
  redlog("GME -> enter GME room")
  self.m_micIsOpen = true
  self.m_speakerIsOpen = false
  self:updateMicToggleState()
  self:updateSpeakerToggleState()
  self:GMEUpdateSelf()
  FunctionBGMCmd.Me():SettingSetVolume(FunctionPerformanceSetting.Me():GetBGMSetting() * GameConfig.Volume_in_calling.volume_in_calling)
  AudioUtility.SetVolume(FunctionPerformanceSetting.Me().setting.soundVolume * GameConfig.Volume_in_calling.volume_in_calling)
  self:removePauseTickTime()
end

function MainViewHeadIconCell:GMEExitRoom()
  redlog("GME -> exit GME room")
  self.m_micIsOpen = false
  self.m_speakerIsOpen = false
  self:updateMicToggleState()
  self:updateSpeakerToggleState()
  FunctionBGMCmd.Me():SettingSetVolume(FunctionPerformanceSetting.Me():GetBGMSetting())
  AudioUtility.SetVolume(FunctionPerformanceSetting.Me().setting.soundVolume)
  self:GMEUpdateSelf()
  if not TeamProxy.Instance:IHaveTeam() and not TeamProxy.Instance:IHaveGroup() and self.GMEPart.activeSelf == true then
    self.GMEPart:SetActive(false)
  end
  if self.m_waitExitRoom then
    redlog("GME -> 在之前的语音房间退出来后，重新进入语音房间")
    GmeVoiceProxy.Instance:EnterRoom()
  else
    self.GMESetting:SetActive(false)
    GmeVoiceProxy.Instance:removeExitRoomTickTime()
    self:removePauseTickTime()
  end
end

function MainViewHeadIconCell:onQuit()
  redlog("GME -> onQuit")
  self.m_micIsOpen = false
  self.m_speakerIsOpen = false
  self:updateMicToggleState()
  self:updateSpeakerToggleState()
  self.GMESetting:SetActive(false)
  self:GMEUpdateSelf()
  FunctionBGMCmd.Me():SettingSetVolume(FunctionPerformanceSetting.Me():GetBGMSetting())
  AudioUtility.SetVolume(FunctionPerformanceSetting.Me().setting.soundVolume)
  self:removePauseTickTime()
end

function MainViewHeadIconCell:onPausedExitRoom()
  self.m_micIsOpen = false
  self.m_speakerIsOpen = false
  self:updateMicToggleState()
  self:updateSpeakerToggleState()
  self.GMESetting:SetActive(false)
  self:GMEUpdateSelf()
  FunctionBGMCmd.Me():SettingSetVolume(FunctionPerformanceSetting.Me():GetBGMSetting())
  AudioUtility.SetVolume(FunctionPerformanceSetting.Me().setting.soundVolume)
  GmeVoiceProxy.Instance:ExitRoom()
end

function MainViewHeadIconCell:onIosPaused(value)
  if not GmeVoiceProxy.Instance:IsInRoom() then
    return
  end
  if value and not value.data then
    redlog("GME -> APP PAUSED")
    self:onPausedExitRoom()
  else
    redlog("GME -> APP RESUME")
  end
end

function MainViewHeadIconCell:onAndroidPaused(value)
  if not GmeVoiceProxy.Instance:IsInRoom() then
    return
  end
  if value and value.data then
    redlog("GME -> APP PAUSED")
    self:onPausedExitRoom()
  else
    redlog("GME -> APP RESUME")
  end
end

function MainViewHeadIconCell:removePauseTickTime()
  if self.m_pauseTickTime ~= nil then
    TimeTickManager.Me():ClearTick(self, 88889)
    self.m_pauseTickTime = nil
  end
  self.m_onPauseCurTime = 0
end

function MainViewHeadIconCell:onPausedDelayExit()
  self.m_onPauseCurTime = self.m_onPauseCurTime + 0.033
  if self.m_onPauseCurTime < 10 then
    return
  end
  self.m_micIsOpen = false
  self.m_speakerIsOpen = false
  self:updateMicToggleState()
  self:updateSpeakerToggleState()
  self.GMESetting:SetActive(false)
  self:GMEUpdateSelf()
  FunctionBGMCmd.Me():SettingSetVolume(FunctionPerformanceSetting.Me():GetBGMSetting())
  AudioUtility.SetVolume(FunctionPerformanceSetting.Me().setting.soundVolume)
  GmeVoiceProxy.Instance:ExitRoom()
  self:removePauseTickTime()
end

function MainViewHeadIconCell:updateTeamInfo(data)
  if data == nil then
    return
  end
  if not TeamProxy.Instance:IsInMyTeam(data.id) then
    return
  end
  local gme = GmeVoiceProxy.Instance
  if data ~= nil and data.mute ~= 0 then
    gme:setIsBan(data.id, true)
    if GmeVoiceProxy.Instance:IsInRoom() and data.id == Game.Myself.data.id and self.m_speakerIsOpen then
      self.m_speakerIsOpen = false
      GmeVoiceProxy.Instance:SetMic(self.m_speakerIsOpen)
      self:updateSpeakerToggleState(self.m_speakerIsOpen)
      self:GMEUpdateSelf()
    end
  elseif not gme:isInMyselfBanList(data.id) then
    gme:setIsBan(data.id, false)
  end
end

function MainViewHeadIconCell:CreatePart(pname)
  return self:LoadPreferb_ByFullPath(MainViewHeadIconCell.partPath .. pname, self.gameObject)
end

local FrameBgMap = {
  [1] = "com_bg_head4",
  [2] = "com_bg_head_5"
}

function MainViewHeadIconCell:SetFrame(frameType, isMyself)
  if self.data and self.data.isMyself and self.data.isMyself ~= 0 then
    self.frameSp.spriteName = "new-main_bg_headframe_a"
    self.frameSp.depth = 55
    Game.HotKeyTipManager:RegisterHotKeyTip(33, self.frameSp, NGUIUtil.AnchorSide.TopLeft, {20, -16}, nil, 62)
    return
  end
  if isMyself and isMyself == 1 then
    self.frameSp.spriteName = "new-main_bg_headframe_a"
    self.frameSp.depth = 55
    Game.HotKeyTipManager:RegisterHotKeyTip(33, self.frameSp, NGUIUtil.AnchorSide.TopLeft, {20, -16}, nil, 62)
    return
  end
  self.frameSp.spriteName = "new-main_bg_headframe_04"
end

function MainViewHeadIconCell:SetSimpleIcon(icon, frameType, isMyself)
  self.isMyself = isMyself
  self:SetFrame(frameType, isMyself)
  self:SetEnabelEmojiFace(false)
  self:Hide(self.avatarPars)
  self:Show(self.simpleIcon.gameObject)
  if self.simpleIcon ~= nil and icon ~= nil then
    IconManager:SetFaceIcon(icon, self.simpleIcon)
    self.simpleIcon:SetMaskPath(UIMaskConfig.SimpleHeadMask)
    self.simpleIcon.OpenMask = true
    self.simpleIcon.OpenCompress = false
    self.simpleIcon.NeedOffset2 = false
    local texturePath = PictureManager.Config.Pic.UI .. "new-main_bg_headframe_simple"
    Game.AssetManager_UI:LoadAsset(texturePath, Texture, HeadIconCell.LoadTextureCallback, self.simpleIcon)
    self.simpleIcon.pivot = UIWidget.Pivot.Center
    self.simpleIcon.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
    self.simpleIcon.width = 120
    self.simpleIcon.height = 120
  end
  self:SetGME()
end

function MainViewHeadIconCell:SetIconLoaclPosXYZ()
  if self.avatarPars ~= nil then
    self.avatarPars.transform.localPosition = tempV3
    self.iconSet_dirty = false
  end
  self.simpleIcon.transform.localPosition = tempV3
end

function MainViewHeadIconCell:SetBody(bodyID)
  if self.bodyID == bodyID then
    return
  end
  if bodyID ~= nil then
    local oriBody = Table_Body[self.bodyID]
    local body = Table_Body[bodyID]
    self.bodyID = bodyID
    if body then
      local bodyStr = body.AvatarBody
      if bodyStr == nil or bodyStr == "" then
        bodyStr = "Body_" .. body.Texture
      end
      local texturePath = PictureManager.Config.Pic.UI .. "new-main_bg_headframe_mask"
      Game.AssetManager_UI:LoadAsset(texturePath, Texture, HeadIconCell.LoadTextureCallback, self.body)
      self:SetSpriteName(self.body, bodyStr)
      self.body:SetMaskPath(UIMaskConfig.CombineHeadMask)
      self:CalOffset(self.body)
      if self.body.gameObject.activeSelf == true then
        self.body.gameObject:SetActive(false)
        self.body.gameObject:SetActive(true)
      end
    else
    end
    if (oriBody and oriBody.AvatarBranch or 0) ~= (body and body.AvatarBranch or 0) then
      return true
    end
  else
  end
  return true
end

function MainViewHeadIconCell:SetHair(hairID)
  if self.hairStyleID == hairID then
    return
  end
  if hairID ~= nil then
    self.hairStyleID = hairID
    local hair = Table_HairStyle[hairID]
    if hair then
      self:Show(self.hairback.gameObject)
      self:Show(self.hairfront.gameObject)
      if hair.HairBack then
        self:SetSpriteName(self.hairback, hair.HairBack)
      else
        errorLog(string.format("HeadIconCell SetHair : %s HairBack = nil", tostring(hairID)))
      end
      if hair.HairFront then
        self:SetSpriteName(self.hairfront, hair.HairFront)
      else
        errorLog(string.format("HeadIconCell SetHair : %s HairFront = nil", tostring(hairID)))
      end
      self:Cal(self.hairback, hair.HairBack, UIMaskConfig.CombineHeadMask)
      self:Cal(self.hairfront, hair.HairFront, UIMaskConfig.CombineHeadMask)
    else
      self:Hide(self.hairback.gameObject)
      self:Hide(self.hairfront.gameObject)
    end
  else
  end
end

function MainViewHeadIconCell:SetHeadAccessory(headAccessory, isDoram)
  if self.headID == headAccessory and isDoram == self.isDoram then
    return
  end
  self.headID = headAccessory
  if headAccessory and headAccessory ~= 0 then
    local assesories = Table_Assesories[headAccessory]
    if assesories then
      self:Show(self.headAccessoryback.gameObject)
      self:Show(self.headAccessoryfront.gameObject)
      if assesories.Back then
        local isSet = false
        if isDoram then
          local strAppend = "_d"
          if not IconManager:SetHeadAccessoryBackIcon(assesories.Back .. strAppend, self.headAccessoryback) then
            isSet = IconManager:SetHeadAccessoryBackIcon(assesories.Back, self.headAccessoryback)
          else
            isSet = true
          end
        else
          isSet = IconManager:SetHeadAccessoryBackIcon(assesories.Back, self.headAccessoryback)
        end
        self.headAccessoryback.gameObject:SetActive(isSet)
        self:MakePixelPerfect(self.headAccessoryback)
      end
      if assesories.Front then
        local isSet = false
        if isDoram then
          local strAppend = "_d"
          if not IconManager:SetHeadAccessoryFrontIcon(assesories.Front .. strAppend, self.headAccessoryfront) then
            isSet = IconManager:SetHeadAccessoryFrontIcon(assesories.Front, self.headAccessoryfront)
          else
            isSet = true
          end
        else
          isSet = IconManager:SetHeadAccessoryFrontIcon(assesories.Front, self.headAccessoryfront)
        end
        self.headAccessoryfront.gameObject:SetActive(isSet)
        self:MakePixelPerfect(self.headAccessoryfront)
      end
      self:Cal(self.headAccessoryback, assesories.Back, UIMaskConfig.AccMask2)
      self:Cal(self.headAccessoryfront, assesories.Front, UIMaskConfig.AccMask, true)
      return
    end
  end
  self:Hide(self.headAccessoryback.gameObject)
  self:Hide(self.headAccessoryfront.gameObject)
end

function MainViewHeadIconCell:SetFaceAccessory(faceAccessory, isDoram)
  if self.faceID == faceAccessory and isDoram == self.isDoram then
    return
  end
  self.faceID = faceAccessory
  if faceAccessory and faceAccessory ~= 0 then
    local assesories = Table_Assesories[faceAccessory]
    if assesories then
      self:Show(self.faceAccessory.gameObject)
      if assesories.Front then
        local isSet = false
        if isDoram then
          local strAppend = "_d"
          if not IconManager:SetHeadFaceMouthIcon(assesories.Front .. strAppend, self.faceAccessory) then
            isSet = IconManager:SetHeadFaceMouthIcon(assesories.Front, self.faceAccessory)
          else
            isSet = true
          end
        else
          isSet = IconManager:SetHeadFaceMouthIcon(assesories.Front, self.faceAccessory)
        end
        self.faceAccessory.gameObject:SetActive(isSet)
        self:MakePixelPerfect(self.faceAccessory)
      end
      self:Cal(self.faceAccessory, assesories.Front, UIMaskConfig.FaceMouth)
      self.faceAccessory.transform.localPosition = LuaGeometry.GetTempVector3(self.offsetX, self.faceAccessory.transform.localPosition.y, 0)
      return
    end
  end
  self:Hide(self.faceAccessory.gameObject)
end

function MainViewHeadIconCell:SetMouthAccessory(mouthAccessory, isDoram)
  if self.mouthID == mouthAccessory and isDoram == self.isDoram then
    return
  end
  self.mouthID = mouthAccessory
  if mouthAccessory and mouthAccessory ~= 0 then
    local assesories = Table_Assesories[mouthAccessory]
    if assesories then
      self:Show(self.mouthAccessory.gameObject)
      if assesories.Front then
        local isSet = false
        if isDoram then
          local strAppend = "_d"
          if not IconManager:SetHeadFaceMouthIcon(assesories.Front .. strAppend, self.mouthAccessory) then
            isSet = IconManager:SetHeadFaceMouthIcon(assesories.Front, self.mouthAccessory)
          else
            isSet = true
          end
        else
          isSet = IconManager:SetHeadFaceMouthIcon(assesories.Front, self.mouthAccessory)
        end
        self.mouthAccessory.gameObject:SetActive(isSet)
        self:MakePixelPerfect(self.mouthAccessory)
      end
      self:Cal(self.mouthAccessory, assesories.Front, UIMaskConfig.FaceMouth)
      return
    end
  end
  self:Hide(self.mouthAccessory.gameObject)
end

function MainViewHeadIconCell:Cal(sprt, name, maskName, depthChange)
  local msprite = sprt:GetAtlasSprite()
  if msprite == nil then
    return
  end
  local texturePath = PictureManager.Config.Pic.UI .. "new-main_bg_headframe_mask"
  Game.AssetManager_UI:LoadAsset(texturePath, Texture, HeadIconCell.LoadTextureCallback, sprt)
  sprt:SetMaskPath(maskName)
  sprt.OpenMask = true
  sprt.OpenCompress = false
  sprt.NeedOffset2 = true
  local left = msprite.paddingLeft
  local bottom = msprite.paddingBottom
  local x = 1.0 * left / msprite.width
  local y = 1.0 * bottom / msprite.height
  local w = msprite.width / 120.0
  local h = msprite.height / 114.0
  sprt:SetOffsetParams(x, y, w, h)
  sprt.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
end

function MainViewHeadIconCell:IsPet(ispet)
  self.isPet = ispet
end

function MainViewHeadIconCell:CalOffset(sprt, rate)
  local msprite = sprt:GetAtlasSprite()
  if msprite == nil then
    return
  end
  local left = msprite.paddingLeft
  local bottom = msprite.paddingBottom
  local x = 1.0 * left / msprite.width
  local y = 1.0 * bottom / msprite.height
  local w = msprite.width / 116.0
  local h = msprite.height / 116.0
  sprt:SetOffsetParams(x, y, w, h)
  sprt.OpenMask = true
  sprt.OpenCompress = false
  sprt.NeedOffset2 = true
end

function MainViewHeadIconCell:SetPortraitFrame(id)
end

function MainViewHeadIconCell:ShowEffect()
  if self.targetEffect then
    self:ClearEffect()
  elseif not self.hideEffect then
    self.targetEffect = self:PlayUIEffect(EffectMap.UI.SkillTargetPointTip, self.effectContainer)
  end
end

function MainViewHeadIconCell:ClearEffect()
  if self.targetEffect then
    self.targetEffect:Destroy()
    self.targetEffect = nil
  end
end
