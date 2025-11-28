autoImport("ServiceLoginUserCmdAutoProxy")
autoImport("FunctionADBuiltInTyrantdb")
autoImport("UIModelRolesList")
autoImport("PersonalPhotoHelper")
autoImport("ScenicSpotPhotoHelperNew")
autoImport("UnionWallPhotoHelper")
autoImport("PersonalPhoto")
autoImport("ScenicSpotPhotoNew")
autoImport("UnionWallPhotoNew")
autoImport("AppStorePurchase")
autoImport("UnionLogo")
autoImport("MarryPhoto")
ServiceLoginUserCmdProxy = class("ServiceLoginUserCmdProxy", ServiceLoginUserCmdAutoProxy)
ServiceLoginUserCmdProxy.Instance = nil
ServiceLoginUserCmdProxy.NAME = "ServiceLoginUserCmdProxy"
ServiceLoginUserCmdProxy.saveID = "ProfessionSaveLoadView_saveID"
ServiceLoginUserCmdProxy.toswitchroleid = "ServiceLoginUserCmdProxy_toswitchroleid"

function ServiceLoginUserCmdProxy:ctor(proxyName)
  if ServiceLoginUserCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceLoginUserCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceLoginUserCmdProxy.Instance = self
  end
end

function ServiceLoginUserCmdProxy:RecvReqLoginParamUserCmd(data)
  FunctionLogin.Me():RecvReqLoginParamUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdReqLoginParamUserCmd, data)
end

function ServiceLoginUserCmdProxy:RecvHeartBeatUserCmd(data)
  ServiceConnProxy.Instance:RecvHeart()
  self:Notify(ServiceEvent.LoginUserCmdHeartBeatUserCmd, data)
end

function ServiceLoginUserCmdProxy:RecvLoginResultUserCmd(data)
  local ret = data.ret
  if ret == 0 then
    LogUtility.Info("<color=lime>登陆成功</color>")
    Buglylog("ServiceLoginUserCmdProxy:登录成功")
    self:CallServerTimeUserCmd()
    DiskFileHandler.Ins():EnterServer()
    FunctionChatIO.Me():CheckLocalFiles()
    DiskFileHandler.Ins():EnterBeautifulArea()
    DiskFileHandler.Ins():EnterUnionWallPhoto()
    DiskFileHandler.Ins():EnterPersonalPhoto()
    DiskFileHandler.Ins():EnterUnionLogo()
    DiskFileHandler.Ins():EnterMarryPhoto()
    UpYunNetIngFileTaskManager.Ins:Open()
    BeautifulAreaPhotoHandler.Ins():Initialize()
    BeautifulAreaPhotoNetIngManager.Ins():Initialize()
    PersonalPhotoHelper.Ins():Initialize()
    ScenicSpotPhotoHelperNew.Ins():Initialize()
    UnionWallPhotoHelper.Ins():Initialize()
    PersonalPhoto.Ins():Initialize()
    ScenicSpotPhotoNew.Ins():Initialize()
    UnionWallPhotoNew.Ins():Initialize()
    UnionLogo.Ins():Initialize()
    MarryPhoto.Ins():Initialize()
    FunctionActivity.Me():Reset()
    FunctionLocalActivity.Me():Reset()
    SealProxy.Instance:ResetSealData()
    SealProxy.Instance:ResetAcceptSealInfo()
    FunctionRepairSeal.Me():ResetRepairSeal()
    TeamProxy.Instance:ExitTeam(TeamProxy.ExitType.ClearData)
    if Game.Myself then
      Game.Myself:Client_ClearFollower()
    end
    AstrolabeProxy.Instance:ResetPlate()
    RedTipProxy.Instance:RemoveAll()
    PvpProxy.Instance:ClearBosses()
    local myZoneID = MyselfProxy.Instance:GetZoneId()
    if nil == myZoneID then
      PvpProxy.Instance:ClearMatchInfo()
    end
    BattlePassProxy.Instance:ResetStaticData()
    MultiProfessionSaveProxy.Instance:Clear()
    FunctionBuff.Me():ClearMyBuffs()
    ChatRoomProxy.Instance:ResetLastChatTime(ChatChannelEnum.World)
    ChatRoomProxy.Instance:ResetLastSameChatTimeText(ChatChannelEnum.World)
    ExchangeShopProxy.Instance:ClearData()
    FunctionTempItem.Me():ClearUseIntervalMap()
    GameFacade.Instance:sendNotification(ServiceUserProxy.RecvLogin)
    EventManager.Me():DispatchEvent(ServiceUserProxy.RecvLogin)
    ServiceUserProxy.Instance:PrepareToReloadDatas()
    local funcLogin = FunctionLogin.Me()
    if BranchMgr.IsChina() then
      funcLogin:SyncServerDID()
    end
    FunctionLogin.requestRandomTwServer()
    self.GetIP()
    self:StatDeviceInfo()
    FunctionServerForbidTable.Me():TryExecute()
    self:InitBuglyUserInfo()
    PhotoStandProxy.Fix_230322_DeleteAllAstcDownloadResult()
  else
    LogUtility.Info("<color=yellow>登陆失败</color>")
    Buglylog("ServiceLoginUserCmdProxy:登录失败")
  end
  self:InitRecognizer()
  self:Notify(ServiceEvent.LoginUserCmdLoginResultUserCmd, data)
end

function ServiceLoginUserCmdProxy:InitRecognizer()
  ExternalInterfaces.InitRecognizer(FunctionChatSpeech.Me().recognizerFileName)
end

function ServiceLoginUserCmdProxy:InitBuglyUserInfo()
  local loginData = FunctionLogin.Me():getLoginData()
  local account = loginData ~= nil and loginData.accid or 0
  local server = FunctionLogin.Me():getCurServerData()
  local serverName = server ~= nil and server.name or "Unknown"
  local roleID = tostring(Game.Myself and Game.Myself.data.id or 0)
  BuglyManager.GetInstance():SetUserId(account .. "," .. roleID)
end

function ServiceLoginUserCmdProxy.GetIP()
  helplog("start ServiceLoginUserCmdProxy.GetIP")
  local c = coroutine.create(function()
    local funcLogin = FunctionLogin.Me()
    local address = "http://ifconfig.me/"
    local request = UnityEngine.Networking.UnityWebRequest.Get(address)
    request:SetRequestHeader("User-Agent", "curl/7.64.1")
    Yield(request:SendWebRequest())
    local content = request.downloadHandler.text
    helplog("end ServiceLoginUserCmdProxy.GetIP", content, request.error)
    ServiceLoginUserCmdProxy.Instance:CallClientInfoUserCmd(content, funcLogin.netDelay)
  end)
  coroutine.resume(c)
end

function ServiceLoginUserCmdProxy:RecvSnapShotUserCmd(data)
  local security = FunctionSecurity.Me()
  if security.verifySecuriySus and security.verifySecuriyCode then
    ServiceLoginUserCmdProxy.Instance:CallConfirmAuthorizeUserCmd(security.verifySecuriyCode)
  end
  MyselfProxy.Instance:SetUserRolesInfo(data)
  UIModelRolesList.Ins():SetRoleDeleteCDCompleteTime(data.deletecdtime)
  ServiceUserProxy.Instance:RecvRoleInfo(data)
  ServiceConnProxy.Instance:CheckHeartStatus()
  ServiceConnProxy.Instance:RecvHeart()
  self:CallServerTimeUserCmd()
  self:Notify(ServiceEvent.LoginUserCmdSnapShotUserCmd, data)
  local loginData = FunctionLogin.Me():getLoginData()
  local account = loginData ~= nil and loginData.accid or 0
  local uid = loginData ~= nil and loginData.uid or 0
  DiskFileHandler.Ins():SetUser(account)
  local server = FunctionLogin.Me():getCurServerData()
  local serverID = server ~= nil and server.serverid or 0
  DiskFileHandler.Ins():SetServer(serverID)
  local userAge = 99
  local userName = "wumingshi"
  if not BranchMgr.IsChina() and ISNoviceServerType then
    FunctionTyrantdb.Instance:SetUser(uid, E_TyrantdbUserType.Registered, E_TyrantdbUserSex.Unknown, userAge, userName)
  else
    FunctionTyrantdb.Instance:SetUser(account, E_TyrantdbUserType.Registered, E_TyrantdbUserSex.Unknown, userAge, userName)
  end
  local server = FunctionLogin.Me():getCurServerData()
  local serverName = server ~= nil and server.name or "Unknown"
  local sid = server ~= nil and server.serverid or "1"
  local linegroup = server ~= nil and server.linegroup or "1"
  local serverinfo = sid .. "&@" .. linegroup
  FunctionTyrantdb.Instance:SetServer(serverName)
  FunctionTyrantdb.Instance:onSwitchServerEvent(serverinfo)
  if (not BackwardCompatibilityUtil.CompatibilityMode_V60 or not BranchMgr.IsChina()) and data.firstcreatechar then
    FunctionTyrantdb.Instance:trackEvent("#FirstCreateRole", nil)
  end
end

function ServiceLoginUserCmdProxy:RecvServerTimeUserCmd(data)
  ServerTime.InitTime(data.time, data.timeZone)
  LocalSaveProxy.Instance:InitDontShowAgain()
  LocalSaveProxy.Instance:InitBannerDontShowAgain()
  self:Notify(ServiceEvent.NUserServerTime, data)
end

function ServiceLoginUserCmdProxy:RecvConfirmAuthorizeUserCmd(data)
  FunctionSecurity.Me():RecvAuthorizeInfo(data)
  self:Notify(ServiceEvent.LoginUserCmdConfirmAuthorizeUserCmd, data)
end

function ServiceLoginUserCmdProxy:RecvSafeDeviceUserCmd(data)
  Game.isSecurityDevice = data.safe
  self:Notify(ServiceEvent.LoginUserCmdSafeDeviceUserCmd, data)
end

function ServiceLoginUserCmdProxy:CallRealAuthorizeUserCmd(authoriz_state, authorized)
  helplog("Call-->RealAuthorizeUserCmd", authoriz_state)
  ServiceLoginUserCmdProxy.super.CallRealAuthorizeUserCmd(self, authoriz_state, authorized)
end

function ServiceLoginUserCmdProxy:RecvRealAuthorizeUserCmd(data)
  helplog("Recv-->RealAuthorizeUserCmd", data.authorized)
  FunctionLogin.Me():set_realName_Centified(data.authorized)
  self:Notify(ServiceEvent.LoginUserCmdRealAuthorizeUserCmd, data)
end

function ServiceLoginUserCmdAutoProxy:RecvQueryAfkStatUserCmd(data)
  AfkProxy.Instance:SyncAfkStatus(data)
  self:Notify(ServiceEvent.LoginUserCmdQueryAfkStatUserCmd, data)
end

function ServiceLoginUserCmdProxy:RecvKickCharUserCmd(data)
  FunctionLogin.Me():RecvKickCharUserCmd(data)
  self:Notify(ServiceEvent.LoginUserCmdKickCharUserCmd, data)
end

function ServiceLoginUserCmdProxy:CallOfflineDetectPosEvent(eventid)
  local posX, posY, posZ = LuaGameObject.GetMousePosition()
  self:CallOfflineDetectUserCmd(eventid, posX * 10000, posY * 10000)
end

function ServiceLoginUserCmdProxy:RecordStartGameEvent()
  local posX, posY, posZ = LuaGameObject.GetMousePosition()
  self.record_time = ServerTime.ServerTime
  self.record_StartGamePosX = posX * 10000
  self.record_StartGamePosY = posY * 10000
end

function ServiceLoginUserCmdProxy:OfflineDetect_SendLoginEvents()
  if not self.record_StartGamePosX then
    return
  end
  self:CallOfflineDetectUserCmd(202, self.record_time, self.record_StartGamePosX, self.record_StartGamePosY)
  self.record_time = nil
  self.record_StartGamePosX = nil
  self.record_StartGamePosY = nil
  self:CallOfflineDetectUserCmd(203, ApplicationInfo.IsEmulator() and 1 or 0)
  self:CallOfflineDetectUserCmd(204, Screen.width, Screen.height)
end

function ServiceLoginUserCmdProxy:StatDeviceInfo()
  local key = "devicestats_0"
  if PlayerPrefs.HasKey(key) then
    return
  end
  local stats = ApplicationInfo.GetDeviceStats()
  if ServiceLoginUserCmdProxy.Instance.CallDeviceInfoUserCmd then
    ServiceLoginUserCmdProxy.Instance:CallDeviceInfoUserCmd(stats[1].name, stats)
    PlayerPrefs.SetInt(key, 1)
    PlayerPrefs.Save()
  end
end

function ServiceLoginUserCmdProxy:RecvPingUserCmd(data)
  FunctionLogin.Me():RecvPingNetDelay()
  self:Notify(ServiceEvent.LoginUserCmdPingUserCmd, data)
end
