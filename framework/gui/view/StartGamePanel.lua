StartGamePanel = class("StartGamePanel", BaseView)
autoImport("NetPrefix")
autoImport("CSharpObjectForLogin")
autoImport("UIRoleSelect")
autoImport("LoginRoleSelector")
autoImport("MonthlyVIPTip")
StartGamePanel.ViewType = UIViewType.MainLayer
PlayerPrefsMYServer = "PlayerPrefsMYServer"
PlayerPrefsQuickAcc = "PlayerPrefsQuickAcc"
PlayerPrefsDefaultName = "PlayerPrefsDefaultName"
PlayerPrefsAgreement = "PlayerPrefsAgreement__"
PlayerPrefsDefaultSkipCG = "PlayerPrefsDefaultSkipCG"
StartGamePanel.BgTextureName = "login_bg_bottom"
StartGamePanel.BgTextureName_Novice = "login_bg_bottom_NoviceServer"
StartGamePanel.StartBtnTexName = "login2-0_btn_start"
StartGamePanel.StartBtnTexName_Novice = "login2-0_btn_start_NoviceServer"
StartGamePanel.BgVideoName = "denglutu.mp4"
StartGamePanel.BgVideoName_Novice = "denglutu_NoviceServer.mp4"
StartGamePanel.ShowNewInstallTipKey = "StartGamePanel.ShowNewInstallTipKey"
local selfIns
local closure = function(...)
  selfIns:CheckBoxChange()
end

function StartGamePanel:Init()
  Buglylog("StartGamePanel:Init")
  Game.PerformanceManager:SetOutline(1)
  FunctionPerformanceSetting.AdjustBigWorld()
  VideoPanel.DeleteUnuseVideo()
  self:initView()
  self:AddEvt()
  FunctionNetError.Me():DisConnect()
  self:MapSwitchHandler()
  selfIns = self
  self:checkNewInstall()
  Game.DestroyDebugRoot()
end

function StartGamePanel:checkNewInstall()
  local ta = Resources.Load(RO.Config.ROPathConfig.TrimExtension(RO.Config.ROPathConfig.VersionFileName))
  if not ta then
    return
  end
  local config = RO.Config.BuildBundleConfig.CreateByStr(ta.text)
  local currentVersion = config ~= nil and config.currentVersion or 0
  local key = string.format("RO_NewInstall_%s", currentVersion)
  if not PlayerPrefs.HasKey(key) then
    PlayerPrefs.SetInt(key, 1)
    PlayerPrefs.Save()
  end
end

function StartGamePanel:OnEnter()
  CurrentServerType = nil
  if not BranchMgr.IsNO() and not BranchMgr.IsNOTW() and not BranchMgr.IsNOEN() then
    ISNoviceServerType = false
  end
  if BranchMgr.IsJapan() then
    OverseaHostHelper:AFRenewTrack()
  end
  self:initData()
  self:InitShow()
  self:ChangeBtnStToNormal()
  self:updateAgreementPos()
  self:initAndroidKey()
  local SDKEnable = FunctionLogin.Me():getSdkEnable()
  if not SDKEnable then
    HotUpdateMgr.CheckShowDownloadTip()
  end
  if not BranchMgr.IsChina() then
    helplog("firebaseToken:", OverSeas_TW.OverSeasManager.GetInstance():GetFireBaseToken())
  end
  if not BackwardCompatibilityUtil.CompatibilityMode_V76 then
    FunctionSDK.AntiAddiction_Exit()
  end
  PictureManager.Instance:SetUI(self.startBtnTexName, self.startBtnTex)
  self.startBtnTex:MakePixelPerfect()
end

function StartGamePanel:initAndroidKey()
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback())
end

function StartGamePanel:initData()
  self:initAgreement()
  self:initLoginView()
  self:UpdateServerList()
  self:SetVersion()
  self:UpdateStartBtnName()
end

function StartGamePanel:initAgreement()
  local agreeStatus = PlayerPrefs.GetInt(PlayerPrefsAgreement, 0) == 2
  helplog("agreeStatus is ", agreeStatus)
  self.checkBox.value = agreeStatus
  if not agreeStatus and (not BackwardCompatibilityUtil.CompatibilityMode_V60 or not BranchMgr.IsChina()) then
    FunctionTyrantdb.Instance:trackEvent("#PrivacyAgreementStart", nil)
  end
end

function StartGamePanel:requestNewServerAnnouncement()
  FunctionLoginAnnounce.Me():tryShowNewServerAnnouncement()
end

local iOSAppUrl = "https://itunes.apple.com/cn/app/xian-jing-chuan-shuoro/id1071801856?l=zh&amp;ls=1&amp;mt=8"

function forceUpdate()
  MsgManager.ConfirmMsgByID(1039, function()
    Application.OpenURL(ApplicationHelper.ParseToUTF8URL(iOSAppUrl))
    ApplicationInfo.Quit()
  end)
end

function StartGamePanel:initLoginView()
  local runtimePlatform = ApplicationInfo.GetRunPlatform()
  if runtimePlatform == RuntimePlatform.IPhonePlayer and EnvChannel.IsReleaseBranch() and CompatibilityVersion.version == 45 then
    forceUpdate()
    return
  end
  local SDKEnable = FunctionLogin.Me():getSdkEnable()
  if SDKEnable then
    self:Hide(self.accInput.gameObject)
    local _, y, _ = LuaGameObject.GetLocalPosition(self.startBtn.transform)
    self.startBtn.transform.localPosition = LuaGeometry.GetTempVector3(0, y)
    self:Show(self.goPlatformEntrance)
    self:tryLogin()
  else
    self:Show(self.accInput.gameObject)
    if PlayerPrefs.HasKey(PlayerPrefsMYServer) then
      self.serverid = PlayerPrefs.GetInt(PlayerPrefsMYServer)
      self.serverData = Table_ServerList[self.serverid]
    end
    if self.serverid and not self.serverData then
      self.serverid = nil
    end
    self:Hide(self.goPlatformEntrance)
  end
  if GameConfig.ShieldMaskActivity and GameConfig.ShieldMaskActivity.ShieldMaskStartGameFixResource == 0 then
    self.FixResource:SetActive(true)
  else
    self.FixResource:SetActive(false)
  end
  if ApplicationInfo.IsRunOnWindowns() then
    self.quitBtn:SetActive(true)
  else
    self.quitBtn:SetActive(false)
  end
  self.buttonGrid:Reposition()
end

function StartGamePanel:tryLogin()
  if FunctionLogin.Me():HasLoginSucess() then
    self:UpdateServerList()
    self:EnableLoginCollider()
  else
    TimeTickManager.Me():CreateOnceDelayTick(950, function(self)
      if BranchMgr.IsChina() and not self.checkBox.value then
        self:ShowBothAgreementAndPrivacy()
        self:EnableLoginCollider()
        return
      end
      FunctionLogin.Me():launchAndLoginSdk()
    end, self)
  end
end

function StartGamePanel:ShowZoneBTN()
  local transZoneBTN = self.zoneBtn.transform
  local localPos = transZoneBTN.localPosition
  localPos.y = -75.3
  transZoneBTN.localPosition = localPos
  self:Show(self.zoneBtn.gameObject)
end

function StartGamePanel:initView()
  self.bgTest1_alpha = self:FindComponent("BGTest1_alpha", UIWidget)
  self.bgTest2_fillAmount = self:FindComponent("BGTest2_fillAmount", UISprite)
  self.bgTest3_fillAmount = self:FindComponent("BGTest3_fillAmount", UITexture)
  self.bgTest4_sliderValue = self:FindComponent("BGTest4_sliderValue", UISlider)
  self.collider = self:FindComponent("Collider", UISprite)
  self.accInput = self:FindComponent("AccountInput", UIInput)
  self.containerGO = self:FindGO("Container")
  self.startBtn = self:FindGO("StartBtn")
  self.StartBtnCollider = self:FindComponent("StartBtnCollider", BoxCollider)
  self.startBtnTex = self:FindComponent("StartBtnTex", UITexture, self.startBtn)
  self.startBtnEffContainer = self:FindGO("StartBtnEff")
  self.startBtnEff2Container = self:FindGO("StartBtnEff2")
  self.zoneBtn = self:FindComponent("ZoneBtn", BoxCollider)
  self.clickTipCollider = self:FindComponent("clickTip", BoxCollider)
  self.serverLab = self:FindComponent("serviceLabel", UILabel)
  self.serverLab.text = ZhString.StartGamePanel_ChooseServerPrompt
  self.versionLabel = self:FindComponent("VersionLabel", UILabel)
  self.EnableStartBtn = true
  self.ErrorOrSusBack = false
  self.BlockRequest = false
  self.EnableStartBtnTwId = nil
  self.BlockRequestTwId = nil
  self.selectTipLabel = self:FindComponent("selectTipLabel", UILabel)
  self.selectTipLabel.text = ZhString.StartGamePanel_SelectTipLabel
  self.selectTipIcon = self:FindComponent("selectTipIcon", UISprite)
  local ServerConnectingLabel = self:FindComponent("ServerConnectingLabel", UILabel)
  ServerConnectingLabel.text = ZhString.Login_ConnectingServer
  self.ServerConnecting = self:FindGO("ServerConnecting")
  self.cancelConnBtn = self:FindGO("cancelConnBtn")
  local agreetmentMsg = self:FindComponent("agreetmentMsg", UILabel)
  agreetmentMsg.text = ZhString.StartGamePanel_AgreetmentMsg
  local agreetmentLabel = self:FindComponent("agreetmentLabel", UILabel)
  agreetmentLabel.text = ZhString.StartGamePanel_AgreetmentLabel
  local networkPrivacyLabel = self:FindComponent("networkPrivacyLabel", UILabel)
  networkPrivacyLabel.text = ZhString.StartGamePanel_networkPrivacyLabel
  self.buttonGrid = self:FindComponent("BtnGrid", UIGrid)
  self.goPlatformEntrance = self:FindGO("PlatformEntrance")
  local lbPlatformEntrance = self:FindComponent("Lb", UILabel, self.goPlatformEntrance)
  lbPlatformEntrance.gameObject:SetActive(false)
  lbPlatformEntrance.text = ZhString.StartGamePanel_PlatformEntrance
  self.FixResource = self:FindGO("FixResource")
  local lbFixResource = self:FindComponent("Lb", UILabel, self.FixResource)
  lbFixResource.gameObject:SetActive(false)
  lbFixResource.text = ZhString.StartGamePanel_FixResource
  self.quitBtn = self:FindGO("QuitBtn")
  local quitBtnLabel = self:FindComponent("Lb", UILabel, self.quitBtn)
  quitBtnLabel.gameObject:SetActive(false)
  quitBtnLabel.text = ZhString.StartGamePanel_Quit
  self.waitingView = self:FindGO("WaitingView")
  local WaitingLabel = self:FindComponent("WaitingLabel", UILabel)
  WaitingLabel.text = ZhString.StartGamePanel_WaitingLabel
  local WaitingViewSp = self:FindComponent("WaitingViewSp", UISprite)
  WaitingViewSp:UpdateAnchors()
  local WaitingContainer = self:FindGO("WaitingContainer")
  local bound = NGUIMath.CalculateRelativeWidgetBounds(WaitingContainer.transform, true)
  local sizeX = bound.size.x
  WaitingContainer.transform.localPosition = LuaGeometry.GetTempVector3(sizeX / 2, 0, 0)
  self:HideConnecting()
  self:Hide(self.cancelConnBtn)
  self.uiCamera = NGUIUtil:GetCameraByLayername("UI")
  self:PlayUIEffect(EffectMap.UI.StartGameBtnEff, self.startBtnEffContainer, false)
  self.checkBox = self:FindComponent("checkBox", UIToggle)
  self.CheckBoxCollider = self:FindComponent("checkBox", BoxCollider)
  self.AgreeLabel = self:FindComponent("AgreeLabel", UILabel)
  local copyrightLabel = self:FindComponent("copyrightLabel", UILabel)
  copyrightLabel.text = ZhString.StartGamePanel_CopyRightTips
  EventDelegate.Set(self.checkBox.onChange, closure)
  if not BranchMgr.IsChina() then
    local copyRightCt = self:FindGO("copyrightCt")
    if not BranchMgr.IsKorea() then
      copyRightCt:SetActive(false)
    end
    local checkBox = self:FindGO("checkBox")
    checkBox:SetActive(false)
    agreetmentLabel.gameObject:SetActive(false)
    networkPrivacyLabel.gameObject:SetActive(false)
    agreetmentMsg.gameObject:SetActive(false)
  end
  if FunctionLogin.Me():getSdkEnable() then
    self:DisenableCollider()
  end
  self.ageDetailBtn = self:FindGO("AgeDetailBtn")
  self.ageDetailBtn_Sprite = self.ageDetailBtn:GetComponent(UISprite)
  if not BranchMgr.IsChina() then
    self.ageDetailBtn:SetActive(false)
  end
  if BranchMgr.IsChina() then
    self.ageDetailBtn:SetActive(true)
    self.ageDetailBtn_Sprite.spriteName = "cadpa_12+"
    self.ageDetailBtn_Sprite:MakePixelPerfect()
    self.ageDetailBtn.transform.localScale = LuaGeometry.GetTempVector3(0.5, 0.5, 0.5)
  elseif BranchMgr.IsNOTW() then
    self.ageDetailBtn:SetActive(true)
    self.ageDetailBtn_Sprite.spriteName = "TW_12+"
    self.ageDetailBtn_Sprite:MakePixelPerfect()
    self.ageDetailBtn.transform.localScale = LuaGeometry.GetTempVector3(0.5, 0.5, 0.5)
  else
    self.ageDetailBtn:SetActive(false)
  end
end

function StartGamePanel:InitBg()
  local serverState = self.serverData and self.serverData.servertype
  local isNovice = serverState == "novice"
  self.bgTexture = self:FindComponent("BgTexture", UITexture)
  if isNovice or BranchMgr.IsNO() or BranchMgr.IsNOTW() or BranchMgr.IsNOEN() then
    self.staticBGName = StartGamePanel.BgTextureName_Novice
  else
    self.staticBGName = StartGamePanel.BgTextureName
  end
  PictureManager.Instance:SetUI(self.staticBGName, self.bgTexture)
  self.bgTexture:MakePixelPerfect()
  PictureManager.ReFitManualHeight(self.bgTexture)
  if not VideoPanel.CheckLimit(true) then
    local videoPlayerGO = self:LoadPreferb("part/StartGameBgVideoPlayer", self.containerGO)
    self.bgVideoPlayer = videoPlayerGO and videoPlayerGO:GetComponent(VideoPlayerNGUI)
    self.videoBG = videoPlayerGO and videoPlayerGO:GetComponent(UITexture)
  else
    redlog("视频播放受限  使用静态背景替代")
  end
  if self.bgVideoPlayer then
    self.bgVideoPlayer.gameObject:SetActive(true)
    
    function self.bgVideoPlayer.onFirstFrameReady()
      local ratio = self.bgVideoPlayer.width / self.bgVideoPlayer.height
      self.bgVideoPlayer:SetTextureSize(720 * ratio, 720)
      TweenColor.Begin(self.videoBG.gameObject, 1, LuaGeometry.GetTempVector4(1, 1, 1, 1))
      local isPlayerExist = self.bgVideoPlayer.isPlayerExist
      local isPaused = self.bgVideoPlayer.isPaused
      local isFinished = self.bgVideoPlayer.isFinished
      local isPlaying = self.bgVideoPlayer.isPlaying
      self.bgVideoPlayer:Play()
      local videoBGActive = self.videoBG.gameObject.activeSelf
      local staticBGActive = self.bgTexture.gameObject.activeSelf
    end
    
    function self.bgVideoPlayer.onStarted()
    end
    
    function self.bgVideoPlayer.onError()
      self.videoBG = nil
      self.bgVideoPlayer:Close()
      self.bgVideoPlayer = nil
      self.bgTexture.alpha = 0
      self.bgTexture.gameObject:SetActive(true)
      TweenColor.Begin(self.bgTexture.gameObject, 1, LuaGeometry.GetTempVector4(1, 1, 1, 1))
    end
    
    self:TryPlayBgVideo(isNovice)
  end
end

function StartGamePanel:updateAgreementPos()
  local agreetmentCt = self:FindGO("labelCt")
  local x, y, z = LuaGameObject.GetLocalPosition(agreetmentCt.transform)
  agreetmentCt.transform.localPosition = LuaGeometry.GetTempVector3(0, y, z)
  if BranchMgr.IsJapan() then
    local staticCopyRight = self:FindGO("Copyright", agreetmentCt)
    if staticCopyRight then
      staticCopyRight.gameObject:SetActive(true)
    end
  end
end

function StartGamePanel:ShowAgreement()
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "AgreementPanel",
    content = 1
  })
end

function StartGamePanel:ShowPrivacyAgreement()
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "AgreementPanel",
    content = 2
  })
end

function StartGamePanel:ShowBothAgreementAndPrivacy()
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "NewAgreeMentPanel"
  })
end

function StartGamePanel:ShowAgeDetailInfo()
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "AgeDetailInfoPanel"
  })
end

function StartGamePanel:CheckBoxChange()
  local value = self.checkBox.value
  if value then
    self.AgreeLabel.text = ZhString.StartGamePanel_AgreeLabel
  else
    self.AgreeLabel.text = ZhString.StartGamePanel_DisAgreeLabel
  end
  PlayerPrefs.SetInt(PlayerPrefsAgreement, value and 2 or 0)
end

function StartGamePanel:SetVersion()
  local clientVersion = Application.version .. "@" .. tostring(CompatibilityVersion.version)
  local path = table.concat({
    ApplicationHelper.persistentDataPath,
    "/",
    ApplicationHelper.platformFolder,
    "/",
    RO.Config.ROPathConfig.VersionFileName
  })
  local config = RO.Config.BuildBundleConfig.CreateByFile(path)
  local resVersion = config ~= nil and tostring(config.currentVersion) or "Unknown"
  self.versionLabel.text = string.format(ZhString.StartGamePanel_Version, clientVersion, resVersion)
end

function StartGamePanel:AddEvt()
  self:AddClickEvent(self.StartBtnCollider.gameObject, function(go)
    if self.startBtnTick then
      return
    end
    self.startBtnTick = TimeTickManager.Me():CreateTick(16, 16, function(self, deltaTime)
      if not self.startBtnEventDelay or self.startBtnEventDelay <= 0 then
        self.startBtnTick:Destroy()
        self.startBtnTick = nil
        self:OnClickStartGame()
        return
      end
      self.startBtnEventDelay = self.startBtnEventDelay - deltaTime
    end, self, 10000)
    self.startBtnEventDelay = 300
    self:PlayUIEffect(EffectMap.UI.StartGameClickEff, self.startBtnEff2Container, true, function(obj, args, assetEffect)
      local x, y = LuaGameObject.InverseTransformPointByVector3(self.startBtnEff2Container.transform, self.uiCamera:ScreenToWorldPoint(LuaGeometry.GetTempVector3(Input.mousePosition.x, Input.mousePosition.y)))
      assetEffect:ResetLocalPositionXYZ(x, y, 0)
      self.startBtnEventDelay = 750
    end)
  end, {hideClickSound = true})
  if not FunctionLogin.Me():getSdkEnable() then
    self:AddClickEvent(self.zoneBtn.gameObject, function(go)
      self:sendNotification(UIEvent.ShowUI, {
        viewname = "SelectServerPanel",
        index = self.serverid
      })
    end)
  end
  local privacyPolicy = GameConfig.PrivacyPolicy
  self:AddButtonEvent("agreetmentLabel", function()
    if privacyPolicy and privacyPolicy.XDservice then
      Application.OpenURL(privacyPolicy.XDservice)
    end
  end)
  self:AddButtonEvent("networkPrivacyLabel", function()
    if privacyPolicy and privacyPolicy.PrivacyProtect then
      Application.OpenURL(privacyPolicy.PrivacyProtect)
    end
  end)
  self:AddButtonEvent("cancelConnBtn", function(go)
    FunctionLogin.Me():stopTryReconnect()
  end)
  local popupHolderSp = self:FindComponent("SpHolder", UISprite)
  self:AddButtonEvent("clickTip", function(go)
    TipManager.Instance:ShowServerPopupList(popupHolderSp, NGUIUtil.AnchorSide.Bottom, {0, -80})
  end)
  self:AddClickEvent(self.goPlatformEntrance, function(go)
    if BranchMgr.IsKorea() and not FunctionLogin.Me():getSdkEnable() then
      self:ShowTXWYPlatform()
      return
    end
    if BranchMgr.IsChina() and not self.checkBox.value then
      self:ShowBothAgreementAndPrivacy()
      return
    end
    local isLogined = FunctionLogin.Me():isLogined()
    if isLogined and not self.BlockRequest then
      local runtimePlatform = ApplicationInfo.GetRunPlatform()
      helplog("sdk type : " .. tostring(FunctionLogin.Me():getSdkType()))
      local sdk_type = FunctionLogin.Me():getSdkType()
      if sdk_type == FunctionSDK.E_SDKType.TXWY or sdk_type == FunctionSDK.E_SDKType.TDSG then
        self:ShowTXWYPlatform()
        return
      end
      if runtimePlatform == RuntimePlatform.Android then
        LogUtility.Info("android StartGamePanel:FunctionSDK()  OpenUserCenter")
        FunctionSDK.Instance:EnterPlatform()
        return
      end
      if Application.platform == RuntimePlatform.WindowsPlayer or Application.platform == RuntimePlatform.WindowsEditor then
        FunctionSDK.Instance:Logout(nil, nil)
        FunctionLogin.Me():ClearLoginData()
      elseif not BranchMgr.IsKorea() then
        FunctionSDK.Instance:EnterPlatform()
      end
    elseif not self.BlockRequest then
      self:StartLogin()
      FunctionLogin.Me():startGameLogin(self.serverData)
    end
  end)
  self:AddClickEvent(self.FixResource, function(go)
    MsgManager.ConfirmMsgByID(33501, function()
      self:DeleteVersionFile()
      FunctionNetError.Me():ErrorBackToLogo()
    end)
  end)
  self:AddClickEvent(self.quitBtn, function()
    if ApplicationInfo.IsRunOnWindowns() then
      MsgManager.ConfirmMsgByID(43480, function()
        Application.Quit()
      end)
    end
  end)
  self:AddClickEvent(self.ageDetailBtn, function()
    self:ShowAgeDetailInfo()
  end)
end

function StartGamePanel:OnClickStartGame()
  if BranchMgr.IsChina() then
    if self.checkBox.value then
      self:CallServer()
    else
      self:ShowBothAgreementAndPrivacy()
    end
  else
    local isGuest = FunctionLogin.Me():get_IsTmp() == 1
    if isGuest and GameConfig.bindingGuest == 1 then
      UIUtil.PopUpConfirmView(nil, ZhString.StartGamePanel_JPGuestMsg, ZhString.StartGamePanel_JPGuestBtn, nil, function()
        if BranchMgr.IsTW() then
          OverSeas_TW.OverSeasManager.GetInstance():SignOut()
          FunctionLogin.Me():ClearLoginData()
        else
          FunctionSDK.Instance:EnterPlatform()
        end
      end, nil, nil, false, false)
      return
    end
    self:CallServer()
  end
  ServiceLoginUserCmdProxy.Instance:RecordStartGameEvent()
end

function StartGamePanel:ShowTXWYPlatform()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TXWYPlatPanel
  })
end

function StartGamePanel:CallServer(acc)
  if acc then
    self.accInput.value = acc
  else
    acc = self.accInput.value
  end
  if acc then
    self.accInput:SaveValue()
  end
  local SDKEnable = FunctionLogin.Me():getSdkEnable()
  if not SDKEnable then
    self:StartLocalGameLogin(acc)
  else
    self:StartSdkLogin()
  end
end

function StartGamePanel:StartLocalGameLogin(acc)
  if not self.serverData then
    self:ErrorMsg(ZhString.StartGamePanel_ChooseServerPrompt)
    return
  end
  PlayerPrefs.SetInt(PlayerPrefsMYServer, self.serverid or 0)
  if acc and acc ~= "" then
    if string.sub(acc, 1, 1) == "-" then
      acc = string.sub(acc, 2, -1)
    end
    if tonumber(acc) > 100 then
      PlayerPrefs.SetString(PlayerPrefsDefaultName, acc)
      self:StartLogin()
      self:ChangeBtnStToClicked()
      FunctionLogin.Me():setCurServerData(self.serverData)
      FunctionLogin.Me():startGameLogin(self.serverData, acc)
    else
      self:ErrorMsg(ZhString.StartGamePanel_InputErrorPrompt)
    end
  else
    self:ErrorMsg(ZhString.StartGamePanel_InputPrompt)
  end
end

function StartGamePanel:StartSdkLogin()
  local serverDatas = FunctionLogin.Me():getServerDatas()
  local isLogined = FunctionLogin.Me():isLogined()
  if serverDatas and isLogined and not self.serverData then
    self:ErrorMsg(ZhString.StartGamePanel_ChooseServerPrompt)
  elseif not self.BlockRequest then
    self:StartLogin()
    self:ChangeBtnStToClicked()
    FunctionLogin.Me():startGameLogin(self.serverData)
  end
  if self.serverData then
    local sid = self.serverData.sid or 1
    PlayerPrefs.SetInt(PlayerPrefsMYServer, tonumber(sid))
  end
end

function StartGamePanel:ErrorMsg(msg)
  MsgManager.FloatMsgTableParam(nil, msg)
end

function StartGamePanel:StartReconnect()
  self:Show(self.ServerConnecting)
end

function StartGamePanel:StopReconnect()
  self:HideConnecting()
end

function StartGamePanel:HideConnecting()
  self:Hide(self.ServerConnecting)
end

function StartGamePanel:GetQuickAcc()
  local quickacc = 0
  if PlayerPrefs.HasKey(PlayerPrefsQuickAcc) then
    quickacc = PlayerPrefs.GetInt(PlayerPrefsQuickAcc)
  end
  if not quickacc or quickacc < 100 then
    quickacc = Game.GameObjectUtil:ToHashCode(SystemInfo.deviceUniqueIdentifier)
    quickacc = math.abs(quickacc)
    while quickacc < 100 do
      quickacc = quickacc + 100
    end
    PlayerPrefs.SetInt(PlayerPrefsQuickAcc, quickacc)
  end
  return string.sub("-" .. quickacc, 1, 10)
end

function StartGamePanel:InitShow()
  self:UpdateServerShow()
  self:InitBg()
end

function StartGamePanel:UpdateServerShow()
  if self.serverData then
    self.serverLab.text = self.serverData.name
    local spriteName = FunctionLogin.GetStateIcon(self.serverData.state)
    if spriteName ~= "" then
      self.selectTipIcon.gameObject:SetActive(true)
      self.selectTipIcon.spriteName = spriteName
      self.selectTipIcon:MakePixelPerfect()
    else
      self.selectTipIcon.gameObject:SetActive(false)
    end
  else
    self.serverLab.text = ZhString.StartGamePanel_NoChooseServer
    self.selectTipIcon.gameObject:SetActive(false)
  end
end

function StartGamePanel:MapSwitchHandler()
  self:AddListenEvt(ServiceEvent.ChooseServer, self.HandlerSelectServer)
  self:AddListenEvt(ServiceEvent.UserRecvRoleInfo, self.HandlerRecvRoleInfo)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.EnterInGameEvt)
  self:AddListenEvt(LoadScene.LoadSceneLoaded, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.Error, self.HandlerSError)
  self:AddListenEvt(NewLoginEvent.LoginFailure, self.HandlerSError)
  self:AddListenEvt(NewLoginEvent.StartLogin, self.StartLogin)
  self:AddListenEvt(NewLoginEvent.UpdateServerList, self.UpdateServerList)
  self:AddListenEvt(NewLoginEvent.StartSdkLogin, self.StartLogin)
  self:AddListenEvt(NewLoginEvent.EndSdkLogin, self.EndSdkLogin)
  self:AddListenEvt(NewLoginEvent.ReqLoginUserCmd, self.HandlerReqLoginUserCmd)
  self:AddListenEvt(ServiceEvent.ErrorUserCmdMaintainUserCmd, self.HandlerSError)
  self:AddListenEvt(NewLoginEvent.StartReconnect, self.StartReconnect)
  self:AddListenEvt(NewLoginEvent.StopReconnect, self.StopReconnect)
  self:AddListenEvt(EventFromLogin.ShowAnnouncement, self.OnReceiveShowAnnouncement)
  self:AddListenEvt(NewLoginEvent.StopShowWaitingView, self.StopShowWaitingView)
  self:AddListenEvt(NewLoginEvent.StartShowWaitingView, self.StartShowWaitingView)
  self:AddListenEvt(ServiceEvent.LoginUserCmdLoginResultUserCmd, self.LoginUserCmdLoginResultUserCmd)
  self:AddListenEvt(ServiceEvent.Error, self.HandleRecvError)
  self:AddListenEvt(NewLoginEvent.LogoutEvent, self.LogoutHandle)
  self:AddListenEvt(NewLoginEvent.LaunchFailure, self.HandlerSError)
  self:AddListenEvt(NewLoginEvent.SDKLoginFailure, self.HandlerSError)
  self:AddListenEvt(NewLoginEvent.ConfirmAgreement, self.HandleSwitchCheckBox)
  EventManager.Me():AddEventListener(NewLoginEvent.DisableLoginCollider, self.DisableLoginCollider, self)
  EventManager.Me():AddEventListener(NewLoginEvent.EnableLoginCollider, self.EnableLoginCollider, self)
  EventManager.Me():AddEventListener(NewLoginEvent.TrafficCheckFinish, self.TrafficCheckFinish, self)
end

function StartGamePanel:LogoutHandle(note)
  self:tryEnableStartBtn()
  if self.checkBox then
    self.checkBox.value = false
  end
end

function StartGamePanel:TrafficCheckFinish(note)
  self:StartSdkLogin()
end

function StartGamePanel:DisableLoginCollider(note)
  self:DisenableCollider()
end

function StartGamePanel:EnableLoginCollider(note)
  self:EnableCollider()
end

function StartGamePanel:HandleRecvError(note)
  if self.cancelLoginTipId then
    self.cancelLoginTipId:Destroy()
    self.cancelLoginTipId = nil
    self:EnableCollider()
    self:ChangeBtnStToNormal()
  end
end

function StartGamePanel:StartShowWaitingView(note)
  self:Show(self.waitingView)
end

function StartGamePanel:StopShowWaitingView(note)
  self:Hide(self.waitingView)
end

function StartGamePanel:HandlerReqLoginUserCmd(note)
  local overtime = 5000
  if not BranchMgr.IsChina() then
    overtime = 15000
  end
  self.cancelLoginTipId = TimeTickManager.Me():CreateOnceDelayTick(overtime, function(owner, deltaTime)
    if BranchMgr.IsSEA() or BranchMgr.IsNA() then
    else
      FunctionNetError.Me():ShowErrorById(15)
    end
    self:HandlerSError()
  end, self)
end

function StartGamePanel:UpdateServerList(note)
  local SDKEnable = FunctionLogin.Me():getSdkEnable()
  if SDKEnable then
    local serverDatas = FunctionLogin.Me():getServerDatas()
    if serverDatas and 0 < #serverDatas then
      self.serverData = FunctionLogin.Me():getDefaultServerData()
      if self.serverData.sid ~= nil then
        PlayerPrefs.SetInt(PlayerPrefsMYServer, tonumber(self.serverData.sid))
      end
      if 1 < #serverDatas then
        self:Show(self.clickTipCollider.gameObject)
      else
        self:Hide(self.clickTipCollider.gameObject)
      end
    end
    self:UpdateServerShow()
    local serverState = self.serverData and self.serverData.servertype
    local isNovice = serverState == "novice"
    self:SwitchLoginBg(isNovice)
  else
    self:Hide(self.selectTipLabel.gameObject)
    self:Hide(self.clickTipCollider.gameObject)
  end
  self.startBtnTexName = isNovice and StartGamePanel.StartBtnTexName_Novice or StartGamePanel.StartBtnTexName
  if AppBundleConfig.GetSDKLang() ~= "cn" then
    if BranchMgr.IsSEA() or BranchMgr.IsJapan() then
      self.startBtnTexName = self.startBtnTexName .. "_en"
    else
      self.startBtnTexName = self.startBtnTexName .. "_" .. AppBundleConfig.GetSDKLang()
    end
  end
end

function StartGamePanel:StartBlockRequest()
  if self.BlockRequestTwId then
    self.BlockRequestTwId:Destroy()
    self.BlockRequestTwId = nil
  end
  self.BlockRequest = true
  self.BlockRequestTwId = TimeTickManager.Me():CreateOnceDelayTick(3000, function(owner, deltaTime)
    self.BlockRequest = false
    self.BlockRequestTwId = nil
  end, self)
end

function StartGamePanel:tryEnableStartBtn()
  self:EnableCollider()
  self:ChangeBtnStToNormal()
end

function StartGamePanel:StartLogin(note)
  LogUtility.Info("StartGamePanel:StartLogin")
  self.ErrorOrSusBack = false
  self:DisenableCollider()
  self:StartBlockRequest()
end

function StartGamePanel:DisenableCollider()
  LogUtility.Info("StartGamePanel:DisenableCollider")
  if self.StartBtnCollider then
    self.StartBtnCollider.enabled = false
    self.clickTipCollider.enabled = false
    self.CheckBoxCollider.enabled = false
  end
end

function StartGamePanel:EnableCollider()
  LogUtility.Info("StartGamePanel:EnableCollider")
  self.StartBtnCollider.enabled = true
  self.clickTipCollider.enabled = true
  self.CheckBoxCollider.enabled = true
end

function StartGamePanel:HandlerSError(note)
  LogUtility.Info("StartGamePanel:HandlerSError")
  Buglylog("StartGamePanel:HandlerSError")
  self.ErrorOrSusBack = true
  self:tryEnableStartBtn()
end

function StartGamePanel:EndSdkLogin(note)
  LogUtility.Info("StartGamePanel:EndSdkLogin")
  Buglylog("StartGamePanel:EndSdkLogin")
  self.ErrorOrSusBack = true
  self:tryEnableStartBtn()
  self:requestNewServerAnnouncement()
  self:RefreshAgreeStatus()
  HotUpdateMgr.CheckShowDownloadTip()
  local uid = "22222"
  local SDKEnable = FunctionLogin.Me():getSdkEnable()
  if not SDKEnable then
    local allRoles = ServiceUserProxy.Instance:GetAllRoleInfos()
    local roleInfo = allRoles[1] or {id = "11111111"}
    uid = roleInfo.id
  else
    local loginData = FunctionLogin.Me():getLoginData()
    if loginData then
      uid = loginData.uid or "000000000"
    end
  end
  if not BackwardCompatibilityUtil.CompatibilityMode_V76 then
    FunctionSDK.AntiAddiction_StartUp(uid, true)
  end
end

function StartGamePanel:RefreshAgreeStatus()
  local agreeStatus = FunctionLogin.Me():getAgreeStatus() or false
  if not agreeStatus then
    PlayerPrefs.DeleteKey(PlayerPrefsAgreement)
    PlayerPrefs.Save()
  end
end

function StartGamePanel:ChangeBtnStToNormal()
  LogUtility.Info("StartGamePanel:ChangeBtnStToNormal")
  if self.anim then
    self.anim:Play("GameStart_1", -1, 0)
  end
end

function StartGamePanel:ChangeBtnStToClicked()
  LogUtility.Info("StartGamePanel:ChangeBtnStToClicked")
  if self.anim then
    self.anim:Play("GameStart_2", -1, 0)
  end
end

function StartGamePanel:HandlerSelectServer(note)
  if note ~= nil then
    self.serverData = note.body
    self.serverid = self.serverData.sid
    if not self.serverid then
      self.serverid = self.serverData.id
    end
    if FunctionLogin.Me():getSdkEnable() and self.serverid ~= nil then
      helplog("HandlerSelectServer ==> ", self.serverid)
      PlayerPrefs.SetInt(PlayerPrefsMYServer, tonumber(self.serverid))
    end
    self:UpdateServerShow()
    local serverType = self.serverData.servertype
    self:SwitchLoginBg(serverType == "novice")
  end
end

function StartGamePanel:EnterInGameEvt(note)
  if note ~= nil then
    local root = GameObject.Find("Root")
    if root then
      self:Hide(root)
    end
  else
  end
end

function StartGamePanel:HandlerRecvRoleInfo(note)
  self:HideConnecting()
  self:SwitchToSelectScene()
  if not BackwardCompatibilityUtil.CompatibilityMode_V76 then
    FunctionSDK.AntiAddiction_EnterGame()
  end
end

function StartGamePanel:createNewRole()
  if self.createRoleMode then
    local data = ServiceUserProxy.Instance:GetNewRoleInfo()
    if data then
      self.reciveData = data
      if self.reciveData.id ~= nil and self.reciveData.id ~= 0 then
        ServiceUserProxy.Instance:CallSelect(self.reciveData.id)
        return true
      end
    end
  else
    local allRoles = ServiceUserProxy.Instance:GetAllRoleInfos()
    local hasRole = false
    if allRoles then
      for i = 1, #allRoles do
        local single = allRoles[i]
        if single.isopen == 0 and single.id ~= 0 then
          hasRole = true
        end
      end
    end
    if not hasRole then
      self.createRoleMode = true
      local defaultName = self.accInput.value
      local codeUTF8 = LuaUtils.StrToUtf8(defaultName)
      FunctionLogin.Me():createRole(codeUTF8, 2, 11, 12, 2, 0, 1)
      return true
    else
      ServiceUserProxy.Instance:CallSelect(allRoles[1].id)
      return true
    end
  end
  return false
end

function StartGamePanel:SwitchToSelectScene()
  LeanTween.alphaNGUI(self.collider, 0, 1, 1):setOnComplete(function()
    CSharpObjectForLogin.Ins():Initialize(function()
      if not OverseaHostHelper:hasRole() then
        if GameConfig.CreateRole and GameConfig.CreateRole.UseNewVersion == true then
          GameConfig.CreateRole.UseNewVersion = 1
        end
        if GameConfig.CreateRole and GameConfig.CreateRole.UseNewVersion and GameConfig.CreateRole.UseNewVersion > 0 then
          LoginRoleSelector.Ins():GoToNewCreateRole(1, function()
            self:CloseSelf()
          end)
        else
          LoginRoleSelector.Ins():GoToCreateRole(1)
          self:CloseSelf()
        end
      else
        LoginRoleSelector.Ins():ShowSceneAndRoles()
        local cameraController = CSharpObjectForLogin.Ins():GetCameraController()
        cameraController:GoToSelectRole()
        UIRoleSelect.Ins():Open()
        self:CloseSelf()
      end
      MonthlyVIPTip.Ins():ReadyForLoginExpirationTip()
    end)
  end)
  if not BranchMgr.IsChina() then
    return
  end
  local objs = Resources.FindObjectsOfTypeAll(SocialShare)
  if objs and 0 < #objs then
    objs[1].gameObject:SetActive(true)
  end
  local socialShareConfig = AppBundleConfig.GetSocialShareInfo()
  if socialShareConfig ~= nil then
    SocialShare.Instance:Initialize(socialShareConfig.SINA_WEIBO_APP_KEY, socialShareConfig.SINA_WEIBO_APP_SECRET, socialShareConfig.QQ_APP_ID, socialShareConfig.QQ_APP_KEY, socialShareConfig.WECHAT_APP_ID, socialShareConfig.WECHAT_APP_SECRET)
  end
  SocialShare.AndroidWxShareFenZi = 128
  HotUpdateMgr.EnterSelectScene()
end

function StartGamePanel:SwitchToCreateScene()
  LeanTween.alphaNGUI(self.collider, 0, 1, 1):setOnComplete(function()
    FunctionPreload.Me():PreloadMakeRole()
    ResourceManager.Instance:SAsyncLoadScene("CharacterSelect", function()
      SceneUtil.SyncLoad("CharacterSelect")
      TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
        FunctionPreload.Me():ClearMakeRole()
        ResourceManager.Instance:SUnLoadScene("CharacterSelect", false)
      end, self)
      self:CloseSelf()
      self:sendNotification(UIEvent.ShowUI, {
        viewname = "CreateRoleViewV2"
      })
    end)
  end)
end

local reusableTable = {}

function StartGamePanel:InitializeAnnouncement()
  if self.announcement == nil then
    self.announcement = FloatingPanel.Instance:ShowMaintenanceMsg(ZhString.ServiceErrorUserCmdProxy_Maintain, "", "", ZhString.ServiceErrorUserCmdProxy_Confirm, "")
  end
end

function StartGamePanel:OnReceiveShowAnnouncement(message)
  if message and message.body then
    self:ShowAnnouncement(message.body.msg, message.body.tip, message.body.picURL)
  end
end

function StartGamePanel:ShowAnnouncement(msg, tip, pic_url)
  reusableTable[1] = ZhString.ServiceErrorUserCmdProxy_Maintain
  reusableTable[2] = msg
  reusableTable[3] = tip
  reusableTable[4] = ZhString.ServiceErrorUserCmdProxy_Confirm
  reusableTable[5] = pic_url
  self.announcement:SetData(reusableTable)
  TableUtility.TableClear(reusableTable)
  local transAnnouncement = self.announcement.gameObject.transform
  local pos = transAnnouncement.localPosition
  pos.y = 0
  transAnnouncement.localPosition = pos
end

function StartGamePanel:HideAnnouncement()
  if self.announcement ~= nil then
    local transAnnouncement = self.announcement.gameObject.transform
    local pos = transAnnouncement.localPosition
    pos.y = 2560
    transAnnouncement.localPosition = pos
  end
end

function StartGamePanel:OnExit()
  Buglylog("StartGamePanel:OnExit")
  self:ClearBg()
  PictureManager.Instance:UnLoadUI(self.startBtnTexName, self.startBtnTex)
  StartGamePanel.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  EventManager.Me():RemoveEventListener(NewLoginEvent.DisableLoginCollider, self.DisableLoginCollider, self)
  EventManager.Me():RemoveEventListener(NewLoginEvent.EnableLoginCollider, self.EnableLoginCollider, self)
  EventManager.Me():RemoveEventListener(NewLoginEvent.TrafficCheckFinish, self.TrafficCheckFinish, self)
  selfIns = nil
end

function StartGamePanel:ClearBg()
  PictureManager.Instance:UnLoadUI(self.staticBGName, self.bgTexture)
  if self.bgVideoPlayer then
    self.bgVideoPlayer:Close()
  end
end

function StartGamePanel:DeleteVersionFile()
  local path = table.concat({
    ApplicationHelper.persistentDataPath,
    "/",
    ApplicationHelper.platformFolder,
    "/",
    RO.Config.ROPathConfig.VersionFileName
  })
  Debug.Log("DeleteVersionFile")
  Debug.Log(path)
  ROFileUtils.FileDelete(path)
  path = table.concat({
    ApplicationHelper.persistentDataPath,
    "/",
    ApplicationHelper.platformFolder,
    "/",
    "LocalApp_Versions.xml"
  })
  Debug.Log(path)
  ROFileUtils.FileDelete(path)
end

function StartGamePanel:LoginUserCmdLoginResultUserCmd()
  ServiceGMProxy.Instance:Call("god")
  ServiceGMProxy.Instance:Call("killer")
  ServiceGMProxy.Instance:Call("setattr attrtype=221 attrvalue=4")
  ServiceGMProxy.Instance:Call("addmoney type=131 num=200000")
  ServiceGMProxy.Instance:Call("menu id=0")
  self:CloseSelf()
end

function StartGamePanel:HandleSwitchCheckBox()
  self.checkBox.value = true
  PlayerPrefs.SetInt(PlayerPrefsAgreement, 2)
  self:CallServer()
  if not BackwardCompatibilityUtil.CompatibilityMode_V60 or not BranchMgr.IsChina() then
    FunctionTyrantdb.Instance:trackEvent("#PrivacyAgreementOK", nil)
  end
end

function StartGamePanel:TryPlayBgVideo(isNoviceServer)
  self.serverState = isNoviceServer and 2 or 1
  local path
  if isNoviceServer then
    path = VideoPanel.VideoPath .. StartGamePanel.BgVideoName_Novice
  else
    path = VideoPanel.VideoPath .. StartGamePanel.BgVideoName
  end
  if not FileHelper.ExistFile(path) then
    if isNoviceServer then
      path = Application.streamingAssetsPath .. "/Videos/" .. StartGamePanel.BgVideoName_Novice
    else
      path = Application.streamingAssetsPath .. "/Videos/" .. StartGamePanel.BgVideoName
    end
  end
  if self.bgVideoPlayer then
    self.bgVideoPlayer:OpenVideo(path, true)
  end
end

function StartGamePanel:SwitchLoginBg(isNoviceServer)
  local targetState = isNoviceServer and 2 or 1
  if self.serverState == targetState then
    return
  end
  if self.videoBG and self.bgVideoPlayer then
    self.bgTexture.gameObject:SetActive(false)
    PictureManager.Instance:UnLoadUI(self.staticBGName, self.bgTexture)
    TweenColor.Begin(self.bgTexture.gameObject, 1, LuaGeometry.GetTempVector4(0, 0, 0, 1))
    TweenColor.Begin(self.videoBG.gameObject, 1, LuaGeometry.GetTempVector4(0, 0, 0, 1)):SetOnFinished(function()
      local path
      if self.serverState == targetState then
        return
      end
      self:TryPlayBgVideo(isNoviceServer)
      PictureManager.Instance:UnLoadUI(self.startBtnTexName, self.startBtnTex)
      self:UpdateStartBtnName()
      PictureManager.Instance:SetUI(self.startBtnTexName, self.startBtnTex)
      self.startBtnTex:MakePixelPerfect()
      if isNoviceServer then
        self.staticBGName = StartGamePanel.BgTextureName_Novice
      else
        self.staticBGName = StartGamePanel.BgTextureName
      end
      PictureManager.Instance:SetUI(self.staticBGName, self.bgTexture)
    end)
  else
    xdlog("静态背景样式 -> 切换")
    if self.bgTexture then
      TweenColor.Begin(self.bgTexture.gameObject, 1, LuaGeometry.GetTempVector4(0, 0, 0, 1)):SetOnFinished(function()
        if self.serverState == targetState then
          return
        end
        self.serverState = isNoviceServer and 2 or 1
        PictureManager.Instance:UnLoadUI(self.startBtnTexName, self.startBtnTex)
        self:UpdateStartBtnName()
        PictureManager.Instance:SetUI(self.startBtnTexName, self.startBtnTex)
        self.startBtnTex:MakePixelPerfect()
        if isNoviceServer then
          self.staticBGName = StartGamePanel.BgTextureName_Novice
        else
          self.staticBGName = StartGamePanel.BgTextureName
        end
        PictureManager.Instance:SetUI(self.staticBGName, self.bgTexture)
        self.bgTexture.gameObject:SetActive(true)
        TweenColor.Begin(self.bgTexture.gameObject, 1, LuaGeometry.GetTempVector4(1, 1, 1, 1))
        xdlog("静态背景切换结束 -> 渐出")
      end)
    end
  end
end

function StartGamePanel:UpdateStartBtnName()
  local serverState = self.serverData and self.serverData.servertype
  local isNovice = serverState == "novice"
  self.startBtnTexName = isNovice and StartGamePanel.StartBtnTexName_Novice or StartGamePanel.StartBtnTexName
  if AppBundleConfig.GetSDKLang() ~= "cn" then
    if BranchMgr.IsSEA() or BranchMgr.IsJapan() then
      self.startBtnTexName = self.startBtnTexName .. "_en"
    else
      self.startBtnTexName = self.startBtnTexName .. "_" .. AppBundleConfig.GetSDKLang()
    end
  end
end
