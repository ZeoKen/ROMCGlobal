autoImport("ServiceSceneUser3AutoProxy")
autoImport("SpyInfo")
ServiceSceneUser3Proxy = class("ServiceQueueEnterCmdProxy", ServiceSceneUser3AutoProxy)
ServiceSceneUser3Proxy.Instance = nil
ServiceSceneUser3Proxy.NAME = "ServiceSceneUser3Proxy"

function ServiceSceneUser3Proxy:ctor(proxyName)
  if ServiceSceneUser3Proxy.Instance == nil then
    self.proxyName = proxyName or ServiceSceneUser3Proxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSceneUser3Proxy.Instance = self
  end
end

function ServiceSceneUser3Proxy:RecvFirstDepositInfo(data)
  NoviceShopProxy.Instance:RecvFirstDepositInfo(data)
  self:Notify(ServiceEvent.SceneUser3FirstDepositInfo, data)
end

function ServiceSceneUser3Proxy:RecvFirstDepositReward(data)
  self:Notify(ServiceEvent.SceneUser3FirstDepositReward, data)
end

function ServiceSceneUser3Proxy:RecvAccumDepositInfo(data)
  AccumulativeShopProxy.Instance:RecvAccumDepositInfo(data)
  self:Notify(ServiceEvent.SceneUser3AccumDepositInfo, data)
end

function ServiceSceneUser3Proxy:RecvAccumDepositReward(data)
  AccumulativeShopProxy.Instance:RecvAccumDepositReward(data)
  self:Notify(ServiceEvent.SceneUser3AccumDepositReward, data)
end

function ServiceSceneUser3Proxy:RecvDailyDepositInfo(data)
  DailyDepositProxy.Instance:RecvDailyDepositInfo(data)
  self:Notify(ServiceEvent.SceneUser3DailyDepositInfo, data)
end

function ServiceSceneUser3Proxy:RecvBattleTimeCostSelectCmd(data)
  BattleTimeDataProxy.Instance:HandleRecvBattleTimeCostSelectCmd(data)
  self:Notify(ServiceEvent.SceneUser3BattleTimeCostSelectCmd, data)
end

function ServiceSceneUser3Proxy:RecvPlugInNotify(data)
  helplog("RecvPlugInNotify")
  if not BackwardCompatibilityUtil.CompatibilityMode_V68 then
    helplog("start spy detect")
    SpyInfo.SetSpyConfig(data.infos)
    local detectInterval = data.detectinterval * 1000
    if self.spyDetecter ~= nil then
      TimeTickManager.Me():ClearTick(self.spyDetecter)
    end
    self.spyDetecter = TimeTickManager.Me():CreateTick(0, detectInterval, function()
      SpyInfo.Detect()
    end, self)
  end
end

function ServiceSceneUser3Proxy:RecvHeroGrowthQuestInfo(data)
  HeroProfessionProxy.Instance:UpdateHeroQuests(data.profession, data.growth_quests, data)
  self:Notify(ServiceEvent.SceneUser3HeroGrowthQuestInfo, data)
end

function ServiceSceneUser3Proxy:RecvHeroStoryQuestInfo(data)
  HeroProfessionProxy.Instance:UpdateHeroStories(data)
  self:Notify(ServiceEvent.SceneUser3HeroStoryQuestInfo, data)
end

function ServiceSceneUser3Proxy:RecvHeroStoryQuestAccept(data)
  HeroProfessionProxy.Instance:HandleUnlockStoryResp(data)
  self:Notify(ServiceEvent.SceneUser3HeroStoryQuestAccept, data)
end

function ServiceSceneUser3AutoProxy:RecvHeroQuestReward(data)
  HeroProfessionProxy.Instance:HandleHeroQuestRewardResp(data)
  self:Notify(ServiceEvent.SceneUser3HeroQuestReward, data)
end

function ServiceSceneUser3Proxy:RecvHeroShowUserCmd(data)
  ProfessionProxy.Instance:UpdateRechargeHeroList(data)
  self:Notify(ServiceEvent.SceneUser3HeroShowUserCmd, data)
end

function ServiceSceneUser3Proxy:RecvQueryProfessionRecordSimpleData(data)
  MultiProfessionSaveProxy.Instance:RecvProfessionRecordSimpleData(data)
  self:Notify(ServiceEvent.SceneUser3QueryProfessionRecordSimpleData, data)
end

function ServiceSceneUser3Proxy:RecvBoliGoldGetReward(data)
  TreasuryRechargeProxy.Instance:RecvBoliGoldGetReward(data)
  self:Notify(ServiceEvent.SceneUser3BoliGoldGetReward, data)
end

function ServiceSceneUser3Proxy:RecvBoliGoldInfo(data)
  TreasuryRechargeProxy.Instance:RecvBoliGoldInfoCmd(data)
  self:Notify(ServiceEvent.SceneUser3BoliGoldInfo, data)
end

function ServiceSceneUser3Proxy:RecvBoliGoldGetFreeReward(data)
  TreasuryRechargeProxy.Instance:RecvBoliGoldGetFreeReward(data)
  self:Notify(ServiceEvent.SceneUser3BoliGoldGetFreeReward, data)
end

function ServiceSceneUser3Proxy:RecvResourceCheckUserCmd(data)
  local versionPath = table.concat({
    ApplicationHelper.persistentDataPath,
    "/",
    ApplicationHelper.platformFolder,
    "/",
    RO.Config.ROPathConfig.VersionFileName
  })
  local config = RO.Config.BuildBundleConfig.CreateByFile(versionPath)
  local resVersion = config ~= nil and tostring(config.currentVersion) or "Unknown"
  local retData = {}
  local installVersion = "0"
  local ta = Resources.Load(RO.Config.ROPathConfig.TrimExtension(RO.Config.ROPathConfig.VersionFileName))
  if ta then
    local config = RO.Config.BuildBundleConfig.CreateByStr(ta.text)
    installVersion = config ~= nil and config.currentVersion or 0
  end
  local subs = FileDirectoryHandler.GetChildrenName(table.concat({
    ApplicationHelper.persistentDataPath,
    "/",
    ApplicationHelper.platformFolder
  }))
  local tb = {}
  for i = 1, #subs do
    tb[#tb + 1] = subs[i]
  end
  local ps = table.concat(tb, ";")
  local info = data.uploadinfo
  local url = info.path or ""
  for i = 1, #data.resources do
    local s = data.resources[i]
    local path = table.concat({
      ApplicationHelper.persistentDataPath,
      "/",
      ApplicationHelper.platformFolder,
      "/",
      s.resource
    })
    helplog("RecvResourceCheckUserCmd:[path]", s.resource)
    local exists = FileHelper.ExistFile(path)
    local server = {}
    local rePath
    if exists then
      local fileMD5 = MyMD5.HashFile(path)
      rePath = path
      server.checksum = fileMD5
    else
      path = table.concat({
        Application.streamingAssetsPath,
        "/",
        s.resource
      })
      rePath = "not in persistent!!!" .. path
      server.checksum = MyMD5.HashFile(path)
    end
    server.resource = rePath .. ";yun:" .. url .. ps
    server.platform = ApplicationHelper.platformFolder .. "@" .. SystemInfo.deviceModel
    server.version = resVersion .. "@" .. installVersion
    retData[#retData + 1] = server
  end
  local result = OverseaHostHelper:GenUpLoadSignObj2(info.useaws, info.params)
  local policy = self.GetValue(info.params, "policy")
  local authorization = self.GetValue(info.params, "authorization")
  local operatorName = "roxdcdn"
  HotUpdateMgr.UploadPatchFileToYun(url, policy, authorization, result.signObj)
  self:CallResourceCheckUserCmd(retData)
end

function ServiceSceneUser3Proxy.GetValue(array, key)
  for i = 1, #array do
    local s = array[i]
    if s.key == key then
      return s.value
    end
  end
end

function ServiceSceneUser3Proxy:RecvUpdateRecordSlotIndex(data)
  MultiProfessionSaveProxy.Instance:UpdateSlotIndexInfo(data)
  self:Notify(ServiceEvent.SceneUser3UpdateRecordSlotIndex, data)
end

function ServiceSceneUser3Proxy:RecvNoviceChargeSync(data)
  NoviceRechargeProxy.Instance:RecvNoviceChargeSyncCmd(data)
  self:Notify(ServiceEvent.SceneUser3NoviceChargeSync, data)
end

function ServiceSceneUser3Proxy:RecvNoviceChargeReward(data)
  NoviceRechargeProxy.Instance:RecvNoviceChargeReward(data)
  self:Notify(ServiceEvent.SceneUser3NoviceChargeReward, data)
end

function ServiceSceneUser3Proxy:RecvEquipPosEffectTime(data)
  MyselfProxy.Instance:SyncEquipPosEffectTime(data)
  self:Notify(ServiceEvent.SceneUser3EquipPosEffectTime, data)
end

function ServiceSceneUser3Proxy:RecvSyncInterferenceData(data)
  MyselfProxy.Instance:RecvSyncInterferenceData(data)
  self:Notify(ServiceEvent.SceneUser3SyncInterferenceData, data)
end

function ServiceSceneUser3Proxy:RecvAuthQueryUserCmd(data)
  AuthUserInfoProxy.Instance:RecvAuthUserInfo(data)
  self:Notify(ServiceEvent.SceneUser3AuthQueryUserCmd, data)
end

function ServiceSceneUser3Proxy:RecvBattleTimeOffUserCmd(data)
  BattleTimeDataProxy.Instance:RecvBattleTimeSwitch(data.off, data.cd)
  self:Notify(ServiceEvent.SceneUser3BattleTimeOffUserCmd, data)
end

function ServiceSceneUser3Proxy:RecvPlayTimeOffUserCmd(data)
  BattleTimeDataProxy.Instance:RecvPlayTimeSwitch(data.off)
  self:Notify(ServiceEvent.SceneUser3PlayTimeOffUserCmd, data)
end

function ServiceSceneUser3Proxy:RecvAuthUpdateUserCmd(data)
  AuthUserInfoProxy.Instance:UpdateAuthUserInfo(data)
  self:Notify(ServiceEvent.SceneUser3AuthUpdateUserCmd, data)
end

function ServiceSceneUser3Proxy:RecvQueryPrestigeCmd(data)
  xdlog("RecvQueryPrestigeCmd声望数据同步")
  VersionPrestigeProxy.Instance:RecvQueryPrestigeCmd(data)
  self:Notify(ServiceEvent.SceneUser3QueryPrestigeCmd, data)
end

function ServiceSceneUser3Proxy:RecvPrestigeRewardCmd(data)
  VersionPrestigeProxy.Instance:RecvPrestigeRewardCmd(data)
  self:Notify(ServiceEvent.SceneUser3PrestigeRewardCmd, data)
end

function ServiceSceneUser3Proxy:RecvPrestigeLevelUpNotifyCmd(data)
  xdlog("RecvPrestigeLevelUpNotifyCmd  声望等级提升同步")
  VersionPrestigeProxy.Instance:RecvPrestigeLevelUpNotifyCmd(data)
  self:Notify(ServiceEvent.SceneUser3PrestigeLevelUpNotifyCmd, data)
end

function ServiceSceneUser3Proxy:RecvSuperSignInUserCmd(data)
  ActivityIntegrationProxy.Instance:RecvSuperSignInUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3SuperSignInUserCmd, data)
end

function ServiceSceneUser3Proxy:RecvSuperSignInNtfUserCmd(data)
  ActivityIntegrationProxy.Instance:RecvSuperSignInNtfUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3SuperSignInNtfUserCmd, data)
end

function ServiceSceneUser3Proxy:RecvQueryQuestSignInfoUserCmd(data)
  ActivityIntegrationProxy.Instance:RecvQueryQuestSignInfoUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3QueryQuestSignInfoUserCmd, data)
end

function ServiceSceneUser3Proxy:RecvQueryYearMemoryUserCmd(data)
  YearMemoryProxy.Instance:RecvQueryYearMemoryUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3QueryYearMemoryUserCmd, data)
end

function ServiceSceneUser3Proxy:RecvYearMemoryProcessUserCmd(data)
  YearMemoryProxy.Instance:RecvYearMemoryProcessUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3YearMemoryProcessUserCmd, data)
end

function ServiceSceneUser3Proxy:RecvActivityExchangeGiftsQueryUserCmd(data)
  redlog("RecvActivityExchangeGiftsQueryUserCmd")
  DonateProxy.Instance:HandleActivityExchangeGiftsQueryUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3ActivityExchangeGiftsQueryUserCmd, data)
end

function ServiceSceneUser3Proxy:RecvActivityExchangeGiftsRewardUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3ActivityExchangeGiftsRewardUserCmd, data)
end

function ServiceSceneUser3Proxy:RecvGvgExcellectQueryUserCmd(data)
  GvgProxy.Instance:RecvGvgExcellectQueryUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3GvgExcellectQueryUserCmd, data)
end

function ServiceSceneUser3Proxy:RecvGvgExcellectRewardUserCmd(data)
  GvgProxy.Instance:RecvGvgExcellectRewardUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3GvgExcellectRewardUserCmd, data)
end

function ServiceSceneUser3Proxy:RecvEffectInfoSyncUserCmd(data)
  PvpProxy.Instance:RecvEffectInfoSyncUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3EffectInfoSyncUserCmd, data)
end

function ServiceSceneUser3Proxy:RecvEffectInfoUpdateUserCmd(data)
  PvpProxy.Instance:RecvEffectInfoUpdateUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3EffectInfoUpdateUserCmd, data)
end

function ServiceSceneUser3Proxy:RecvEffectInfoUseUserCmd(data)
  PvpProxy.Instance:RecvEffectInfoUseUserCmd(data)
  self:Notify(ServiceEvent.SceneUser3EffectInfoUseUserCmd, data)
end
