local baseCell = autoImport("BaseCell")
MainViewGMEPartVirtualCell = class("MainViewGMEPartVirtualCell", baseCell)
MainViewGMEPartVirtualCell.USE_NEW_GME_PART = true

function MainViewGMEPartVirtualCell:Init()
  self:FindObjs()
  self:SetGME()
end

function MainViewGMEPartVirtualCell:FindObjs()
  self.parentGrid = self.gameObject.transform.parent:GetComponent(UIGrid)
  self.gmeBtn = self:FindGO("GMEBtn")
  self.gmeLabel = self:FindGO("Label", self.gmeBtn):GetComponent(UILabel)
  self.gmeIcon_Ban = self:FindGO("Sp_Ban", self.gmeBtn)
  self.gmeIcon_Mic = self:FindGO("Sp_Mic", self.gmeBtn)
  self.gmeIcon_Ear = self:FindGO("Sp_Ear", self.gmeBtn)
  self.gmeForbid = self:FindGO("prohibit", self.gmeBtn)
  self.gmeTweenScale = self.gmeBtn:GetComponent(TweenScale)
  self.gmeGridObj = self:FindGO("GMEGrid")
  self.gmeGridTweenPos = self.gmeGridObj:GetComponent(TweenPosition)
  self.gmeGridTweenAlpha = self.gmeGridObj:GetComponent(TweenAlpha)
  self.gmeGridTweenPos:ResetToBeginning()
  self.gmeGridTweenAlpha:ResetToBeginning()
  self.gmeBtns = {}
  for i = 2, 3 do
    self.gmeBtns[i] = {}
    self.gmeBtns[i].obj = self:FindGO("Button" .. i, self.gmeGridObj)
    self.gmeBtns[i].forbid = self:FindGO("prohibit", self.gmeBtns[i].obj)
    self.gmeBtns[i].icon_Ban = self:FindGO("Sp_Ban", self.gmeBtns[i].obj)
    self.gmeBtns[i].icon_Mic = self:FindGO("Sp_Mic", self.gmeBtns[i].obj)
    self.gmeBtns[i].icon_Ear = self:FindGO("Sp_Ear", self.gmeBtns[i].obj)
    self.gmeBtns[i].label = self:FindGO("Label", self.gmeBtns[i].obj):GetComponent(UILabel)
  end
  self.gmeBG = self:FindGO("GMEBg"):GetComponent(UISprite)
  self.gmeBGTweenWidth = self:FindGO("GMEBg"):GetComponent(TweenWidth)
  self.gmeArrow = self:FindGO("GMEArrow")
  self.gmeArrowTweenPos = self.gmeArrow:GetComponent(TweenPosition)
  self.gmeArrowTweenPos:ResetToBeginning()
  self.gmeArrowIcon = self.gmeArrow:GetComponent(UISprite)
  self.gmeGridShow = false
  self.curGMEChoose = 0
  self:AddClickEvent(self.gmeBtn, function()
    if not GmeVoiceProxy.Instance:CanEnterRoom() and not self.gmeGridShow then
      return
    end
    self.gmeGridShow = not self.gmeGridShow
    self:RefreshGMEGrid()
  end)
  self:AddClickEvent(self.gmeArrow, function()
    if not GmeVoiceProxy.Instance:CanEnterRoom() and not self.gmeGridShow then
      return
    end
    self.gmeGridShow = not self.gmeGridShow
    self:RefreshGMEGrid()
  end)
  for i = 2, 3 do
    self:AddClickEvent(self.gmeBtns[i].obj, function()
      if not GmeVoiceProxy.Instance:CanEnterRoom() and not self.gmeGridShow then
        return
      end
      self.gmeGridShow = not self.gmeGridShow
      self:RefreshGMEGrid()
      local clickType = self.gmeBtns[i].gmeOpt
      self.curGMEChoose = clickType
      self:ClickGMEBtn(clickType)
    end)
  end
end

function MainViewGMEPartVirtualCell:SetGME()
  if self.m_isInitGo ~= nil and self.m_isInitGo then
    return
  end
  if not MainViewGMEPartVirtualCell.USE_NEW_GME_PART then
    self.m_isInitGo = true
    self:SetActive(false)
    return
  end
  self.m_memberCount = 0
  self.m_onlineCount = 0
  self:AddGMEEvent()
  if MainViewHeadIconCell.isNotChina65Var() or ApplicationInfo.IsRunOnWindowns() then
    self:SetActive(false)
  elseif TeamProxy.Instance:IHaveTeam() or TeamProxy.Instance:IHaveGroup() then
    self:SetActive(not GameConfig.SystemForbid.OpenVoice)
    self:onTeamUpdate()
    self:GMEUpdateSelf()
  else
    self:SetActive(false)
  end
  self.m_isInitGo = true
end

function MainViewGMEPartVirtualCell:OnDestroy()
  MainViewGMEPartVirtualCell.super.OnDestroy(self)
  self:RemoveGMEEvent()
end

function MainViewGMEPartVirtualCell:AddGMEEvent()
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
  self.m_isAddEvent = true
  self.m_isRemoveEvent = false
end

function MainViewGMEPartVirtualCell:RemoveGMEEvent()
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

function MainViewGMEPartVirtualCell:onBackToLogo()
  GmeVoiceProxy.Instance:clearGmeData()
end

function MainViewGMEPartVirtualCell:onLoadScene()
  self.m_isChangeScene = true
end

function MainViewGMEPartVirtualCell:onLoadSceneFinished()
  self.m_isChangeScene = false
end

function MainViewGMEPartVirtualCell:onTeamUpdate(data)
  if GameConfig.SystemForbid.OpenVoice then
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
    if MainViewHeadIconCell.isNotChina65Var() or ApplicationInfo.IsRunOnWindowns() then
      self:SetActive(false)
    else
      self:SetActive(true)
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
    if MainViewHeadIconCell.isNotChina65Var() or ApplicationInfo.IsRunOnWindowns() then
      self:SetActive(false)
    else
      self:SetActive(true)
    end
  else
    self:SetActive(false)
  end
  self:GMEUpdateSelf()
  if gme:IsInRoom() then
    self:onCheckIsNeedExitRoom()
  end
end

function MainViewGMEPartVirtualCell:onEnterTeam(value)
  if GameConfig.SystemForbid.OpenVoice then
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
    if MainViewHeadIconCell.isNotChina65Var() or ApplicationInfo.IsRunOnWindowns() then
      self:SetActive(false)
    else
      self:SetActive(true)
    end
    self:GMEUpdateSelf()
    redlog("GME -> UPDATE TEAM MEMBER COUNT")
    if GmeVoiceProxy.Instance:IsInRoom() then
      self:onCheckIsNeedExitRoom()
    end
  else
    self:SetActive(false)
    self:GMEUpdateSelf()
  end
end

function MainViewGMEPartVirtualCell:onExitTeam(value)
  if value ~= nil and value.data.isClient then
    redlog("GME -> client remove")
    return
  end
  self:isNeedExitRoom()
end

function MainViewGMEPartVirtualCell:onDisconnect()
  GmeVoiceProxy.Instance:ExitRoom()
  self:SetActive(false)
  self:GMEUpdateSelf()
  self:removePauseTickTime()
end

function MainViewGMEPartVirtualCell:onCheckIsNeedExitRoom()
  local code = GmeVoiceProxy.Instance:isCanUseGME(self.m_memberCount, self.m_onlineCount)
  redlog("GME -> CHECK IS NEED EXIT ROOM CODE = " .. code)
  if 1 == code then
    if GmeVoiceProxy.Instance:IsInRoom() then
      GmeVoiceProxy.Instance:ExitRoom()
    else
      self:SetActive(false)
      self:GMEUpdateSelf()
    end
  elseif 2 == code then
    GmeVoiceProxy.Instance:onDealyCheckExitRoom(self, self.isNeedExitRoom)
  else
    GmeVoiceProxy.Instance:removeExitRoomTickTime()
  end
end

function MainViewGMEPartVirtualCell:isNeedExitRoom()
  self:onTeamUpdate()
  local code = GmeVoiceProxy.Instance:isCanUseGME(self.m_memberCount, self.m_onlineCount)
  redlog("GME -> RECHECK IS NEED EXIT ROOM CODE = " .. code)
  if code ~= 0 then
    if GmeVoiceProxy.Instance:IsInRoom() then
      GmeVoiceProxy.Instance:ExitRoom()
    else
      self:SetActive(false)
      self:GMEUpdateSelf()
    end
  else
    GmeVoiceProxy.Instance:removeExitRoomTickTime()
  end
end

function MainViewGMEPartVirtualCell:onMemberOffline(value)
  if value ~= nil and value.data ~= nil and value.data.id ~= nil and GmeVoiceProxy.Instance:isInMyselfBanList(value.data.id) then
    GmeVoiceProxy.Instance:removeMyselfBanList(value.data.id)
  end
  self:onTeamUpdate()
end

function MainViewGMEPartVirtualCell:GMEUpdateSelf()
  self:RefreshGMEChange()
end

function MainViewGMEPartVirtualCell:GMEEnterRoom()
  redlog("GME -> enter GME room")
  self.m_micIsOpen = true
  self.m_speakerIsOpen = false
  if self.m_waitOpenMic then
    if self:_CheckMicCond() then
      self:_SetMicOn()
    end
    self.m_waitOpenMic = false
  end
  self:updateMicToggleState()
  self:updateSpeakerToggleState()
  self:GMEUpdateSelf()
  FunctionBGMCmd.Me():SettingSetVolume(FunctionPerformanceSetting.Me():GetBGMSetting() * GameConfig.Volume_in_calling.volume_in_calling)
  AudioUtility.SetVolume(FunctionPerformanceSetting.Me().setting.soundVolume * GameConfig.Volume_in_calling.volume_in_calling)
  self:removePauseTickTime()
end

function MainViewGMEPartVirtualCell:GMEExitRoom()
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
    GmeVoiceProxy.Instance:removeExitRoomTickTime()
    self:removePauseTickTime()
  end
end

function MainViewGMEPartVirtualCell:onQuit()
  redlog("GME -> onQuit")
  self.m_micIsOpen = false
  self.m_speakerIsOpen = false
  self:updateMicToggleState()
  self:updateSpeakerToggleState()
  self:GMEUpdateSelf()
  FunctionBGMCmd.Me():SettingSetVolume(FunctionPerformanceSetting.Me():GetBGMSetting())
  AudioUtility.SetVolume(FunctionPerformanceSetting.Me().setting.soundVolume)
  self:removePauseTickTime()
end

function MainViewGMEPartVirtualCell:onPausedExitRoom()
  self.m_micIsOpen = false
  self.m_speakerIsOpen = false
  self:updateMicToggleState()
  self:updateSpeakerToggleState()
  self:GMEUpdateSelf()
  FunctionBGMCmd.Me():SettingSetVolume(FunctionPerformanceSetting.Me():GetBGMSetting())
  AudioUtility.SetVolume(FunctionPerformanceSetting.Me().setting.soundVolume)
  GmeVoiceProxy.Instance:ExitRoom()
end

function MainViewGMEPartVirtualCell:onIosPaused(value)
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

function MainViewGMEPartVirtualCell:onAndroidPaused(value)
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

function MainViewGMEPartVirtualCell:removePauseTickTime()
  if self.m_pauseTickTime ~= nil then
    TimeTickManager.Me():ClearTick(self, 88889)
    self.m_pauseTickTime = nil
  end
  self.m_onPauseCurTime = 0
end

function MainViewGMEPartVirtualCell:onPausedDelayExit()
  self.m_onPauseCurTime = self.m_onPauseCurTime + 0.033
  if self.m_onPauseCurTime < 10 then
    return
  end
  self.m_micIsOpen = false
  self.m_speakerIsOpen = false
  self:updateMicToggleState()
  self:updateSpeakerToggleState()
  self:GMEUpdateSelf()
  FunctionBGMCmd.Me():SettingSetVolume(FunctionPerformanceSetting.Me():GetBGMSetting())
  AudioUtility.SetVolume(FunctionPerformanceSetting.Me().setting.soundVolume)
  GmeVoiceProxy.Instance:ExitRoom()
  self:removePauseTickTime()
end

function MainViewGMEPartVirtualCell:updateTeamInfo(data)
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

function MainViewGMEPartVirtualCell:Opt_Ear()
  if not self:_CheckEarCond() then
    return
  end
  local gme = GmeVoiceProxy.Instance
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
    if not self:_CheckMicCond() then
      return
    end
    self:_SetMicOff()
  end
end

function MainViewGMEPartVirtualCell:Opt_Ear_Mic()
  if not self:_CheckEarCond() then
    return
  end
  local gme = GmeVoiceProxy.Instance
  if not self.m_micIsOpen then
    if gme:isInitSuccess() then
      if gme:IsInRoom() then
        self.m_waitExitRoom = true
        gme:ExitRoom()
      else
        self.m_waitExitRoom = false
        gme:EnterRoom()
      end
      self.m_waitOpenMic = true
    end
  elseif not self.m_waitOpenMic and self:_CheckMicCond() then
    self:_SetMicOn()
  end
end

function MainViewGMEPartVirtualCell:Opt_Ban()
  if not self:_CheckEarCond() then
    return
  end
  self:_SetEarOff()
end

function MainViewGMEPartVirtualCell:_CheckEarCond()
  local gme = GmeVoiceProxy.Instance
  local code = gme:isCanUseGME(self.m_memberCount, self.m_onlineCount)
  if not gme:IsInRoom() and 0 ~= code then
    MsgManager.ShowMsgByID(42112)
    return
  end
  return true
end

function MainViewGMEPartVirtualCell:_CheckMicCond()
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
  return true
end

function MainViewGMEPartVirtualCell:_SetEarOn()
  local gme = GmeVoiceProxy.Instance
  if not self.m_micIsOpen and gme:isInitSuccess() then
    if gme:IsInRoom() then
      self.m_waitExitRoom = true
      gme:ExitRoom()
    else
      self.m_waitExitRoom = false
      gme:EnterRoom()
    end
  end
end

function MainViewGMEPartVirtualCell:_SetEarOff()
  local gme = GmeVoiceProxy.Instance
  if self.m_micIsOpen then
    gme:ExitRoom()
    self.m_waitExitRoom = false
  end
end

function MainViewGMEPartVirtualCell:_SetMicOn()
  self.m_speakerIsOpen = true
  GmeVoiceProxy.Instance:SetMic(self.m_speakerIsOpen)
end

function MainViewGMEPartVirtualCell:_SetMicOff()
  self.m_speakerIsOpen = false
  GmeVoiceProxy.Instance:SetMic(self.m_speakerIsOpen)
end

function MainViewGMEPartVirtualCell:updateSpeakerToggleState()
end

function MainViewGMEPartVirtualCell:updateMicToggleState()
end

function MainViewGMEPartVirtualCell:SetActive(isActive)
  self.gameObject:SetActive(isActive)
  self.parentGrid:Reposition()
end

local GMEBtnStyles = {
  [1] = {
    ear = true,
    mic = true,
    ban = true,
    text = "",
    ear_py = 10
  },
  [2] = {
    ear = true,
    text = "",
    ear_py = 0
  },
  [3] = {
    ear = true,
    mic = true,
    text = "",
    ear_py = 10
  }
}
local tempRot = LuaQuaternion()

function MainViewGMEPartVirtualCell:ClickGMEBtn(type)
  if type == 1 then
    self:Opt_Ban()
  elseif type == 2 then
    self:Opt_Ear()
  else
    self:Opt_Ear_Mic()
  end
  self:RefreshGMEChange()
  self.gmeTweenScale:ResetToBeginning()
  self.gmeTweenScale:PlayForward()
end

function MainViewGMEPartVirtualCell:RefreshGMEGrid()
  if self.gmeGridShow then
    self.gmeGridTweenPos:PlayForward()
    self.gmeGridTweenAlpha:PlayForward()
    self.gmeBGTweenWidth:PlayForward()
    self.gmeArrowTweenPos:PlayForward()
    LuaQuaternion.Better_SetEulerAngles(tempRot, LuaGeometry.GetTempVector3(0, 0, 90))
    self.gmeArrowIcon.transform.localRotation = tempRot
  else
    self.gmeGridTweenPos:PlayReverse()
    self.gmeGridTweenAlpha:PlayReverse()
    self.gmeBGTweenWidth:PlayReverse()
    self.gmeArrowTweenPos:PlayReverse()
    LuaQuaternion.Better_SetEulerAngles(tempRot, LuaGeometry.GetTempVector3(0, 0, -90))
    self.gmeArrowIcon.transform.localRotation = tempRot
  end
end

function MainViewGMEPartVirtualCell:RefreshGMEChange()
  local gmeEnable = GmeVoiceProxy.Instance:isInitSuccess() and GmeVoiceProxy.Instance:IsInRoom()
  local gmeMicOpen = GmeVoiceProxy.Instance:GetMic()
  local gmeSpeakerOpen = GmeVoiceProxy.Instance:GetSpeaker()
  local curGmeOption = 1
  if gmeEnable then
    if gmeMicOpen and gmeSpeakerOpen then
      curGmeOption = 3
    elseif not gmeMicOpen and gmeSpeakerOpen then
      curGmeOption = 2
    end
  end
  self.gmeOptions = {}
  for i = 1, 3 do
    if curGmeOption ~= i then
      table.insert(self.gmeOptions, i)
    end
  end
  local _Btn, _BtnStyle, gmeOpt, isUnlock
  for i = 1, #self.gmeOptions do
    gmeOpt = self.gmeOptions[i]
    _Btn = self.gmeBtns[i + 1]
    _Btn.gmeOpt = gmeOpt
    _BtnStyle = GMEBtnStyles[gmeOpt]
    _Btn.label.text = _BtnStyle.text
    _Btn.icon_Ban:SetActive(_BtnStyle.ban == true)
    _Btn.icon_Mic:SetActive(_BtnStyle.mic == true)
    _Btn.icon_Ear:SetActive(_BtnStyle.ear == true)
    _Btn.icon_Ear.transform.localPosition = LuaGeometry.GetTempVector3(0, _BtnStyle.ear_py, 0)
    isUnlock = self:IsGMEOptionUnlock(gmeOpt)
    _Btn.forbid:SetActive(false)
  end
  local curCameraBtnStyle = GMEBtnStyles[curGmeOption]
  self.gmeLabel.text = curCameraBtnStyle.text
  self.gmeIcon_Ban:SetActive(curCameraBtnStyle.ban == true)
  self.gmeIcon_Mic:SetActive(curCameraBtnStyle.mic == true)
  self.gmeIcon_Ear:SetActive(curCameraBtnStyle.ear == true)
  self.gmeIcon_Ear.transform.localPosition = LuaGeometry.GetTempVector3(0, curCameraBtnStyle.ear_py, 0)
  self.curGMEChoose = 0
end

function MainViewGMEPartVirtualCell:IsGMEOptionUnlock(type)
  if type == 1 then
    return true
  else
    local gmeEnable = GmeVoiceProxy.Instance:isInitSuccess() and GmeVoiceProxy.Instance:IsInRoom()
    return gmeEnable
  end
end
