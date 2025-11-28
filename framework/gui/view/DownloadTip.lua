autoImport("TableUtil")
autoImport("Table_Item")
DownloadTip = class("DownloadTip", BaseView)
DownloadTip.ViewType = UIViewType.PopUpLayer
autoImport("DownloadTipItemCell")
autoImport("GainWayTip")
DownloadTip.FIRSTPLAYGAME_PREF = "DownloadTip_FIRSTPLAYGAME_PREF_"
DownloadTip.FIRSTDNCOMPLETE_PREF = "DownloadTip_FIRSTDNCOMPLETE_PREF_"
DownloadTip.FIRSTDNWITH_PREF = "DownloadTip_FIRSTDNWITH_PREF_"
DownloadTip.DownloadEvent = "DownloadTip_DownloadEvent"

function DownloadTip:Init()
  self:InitView()
  self:InitListener()
  self:AddEvt()
  self:InitData()
  self:SetData(self.viewdata.errorCode)
end

function DownloadTip:GetReward(t1, t2)
  local t = {}
  for i = 1, #t1 do
    local s = t1[i]
    t[s[1]] = s[2]
  end
  for i = 1, #t2 do
    local s = t2[i]
    local n = s[2]
    if t[s[1]] then
      n = n + t[s[1]]
    end
    t[s[1]] = n
  end
  local r = {}
  for k, v in pairs(t) do
    if 0 < v then
      r[#r + 1] = {k, v}
    end
  end
  return r
end

function DownloadTip:InitData()
  self.curProgress = 0
  self.totalSize = HotUpdateMgr.GetTotalSizeToDl()
  self.loginData = FunctionLogin.Me():getLoginData() or {}
  local sdk = FunctionLogin.Me():getFunctionSdk()
  local plat = "1"
  if sdk then
    plat = sdk:GetPlat()
  end
  self.downloadSize.text = string.format(ZhString.DownloadUI_DownloadSize, self.ReadableSize(self.totalSize))
  self.noDnTip.text = ZhString.DownloadUI_NoDnTip
  self.rewardList = ListCtrl.new(self:FindComponent("RewardGrid", UIGrid), DownloadTipItemCell, "DownloadTipItemCell")
  self.rewardList:AddEventListener(MouseEvent.MouseClick, self.ClickItemCell, self)
  local rewrdItems = {}
  local rewardCf
  if plat == "3" then
    rewardCf = GameConfig.System.resource_download_reward_tf and GameConfig.System.resource_download_reward_tf or {
      {5516, 30},
      {6768, 30}
    }
  else
    rewardCf = GameConfig.System.resource_download_reward and GameConfig.System.resource_download_reward or {
      {5516, 30},
      {6768, 30}
    }
  end
  local active = self.loginData.activePlayer
  local rewardIDs = {
    {5516, 30},
    {6768, 30}
  }
  if 1 == active then
    rewardIDs = rewardCf.all_char_reward
  elseif 2 == active then
    local all = rewardCf.all_char_reward
    local un = rewardCf.unactive_char_reward
    rewardIDs = self:GetReward(all, un)
  elseif 3 == active then
    local all = rewardCf.all_char_reward
    local new = rewardCf.new_char_reward
    rewardIDs = self:GetReward(all, new)
  end
  for i = 1, #rewardIDs do
    local reward = rewardIDs[i]
    rewrdItems[i] = {}
    rewrdItems[i].itemid = reward[1]
    rewrdItems[i].num = reward[2]
  end
  self.rewardList:ResetDatas(rewrdItems)
  UIManagerProxy.Instance:NeedEnableAndroidKey(false)
end

function DownloadTip:ClickItemCell(cell)
end

function DownloadTip.ReadableSize(bytes)
  local state = HotUpdateMgr.GetHotUpdatState()
  local unit = 1024
  if bytes < unit then
    return bytes .. " B"
  end
  local exp = math.floor(math.log(bytes) / math.log(unit))
  return string.format("%.1f %s", bytes / math.pow(unit, exp), string.sub("KMGTPE", exp, exp))
end

local STARTGAME = "StartGamePanel"
local WIFICHTOCELLULAR = "10"
local DISKFULL = "-5"
local tempVector3 = LuaVector3.Zero()

function DownloadTip:SetData(errorCode)
  local iswifi = Application.internetReachability == NetworkReachability.ReachableViaLocalAreaNetwork
  local active = self.loginData.activePlayer
  local rewarded = self.loginData.resourceReward
  local state = HotUpdateMgr.GetHotUpdatState()
  local updateDone = HotUpdateMgr.IsUpdateDone()
  local curDownloadProgress = HotUpdateMgr.GetDownloadProgress()
  self:UpdateProgressBar(curDownloadProgress)
  if HotUpdateState.None == state then
    self.rightBtnLabel.text = ZhString.DownloadUI_DownloadWith
  elseif HotUpdateState.Downloading ~= state then
    self.rightBtnLabel.text = ZhString.DownloadUI_ContinuteDn
  else
    self.rightBtnLabel.text = ZhString.DownloadUI_DownloadWith
  end
  if HotUpdateState.Downloading == state or HotUpdateState.DownloadPaused == state then
    self.leftBtnLabel.text = ZhString.DownloadUI_Pause
  else
    self.leftBtnLabel.text = ZhString.DownloadUI_PlayGame
  end
  helplog("setdata:", errorCode, state, updateDone)
  self.rewardBtn:SetActive(false)
  local text = ZhString.DownloadUI_DownloadTip
  if not rewarded then
    text = text .. ZhString.DownloadUI_RewardTextLabel
  end
  self.descText.text = text
  if STARTGAME == errorCode then
    self:Hide(self.progressGo)
    self:Hide(self.closeButton)
  end
  self:OptUIPosWithRewarded(rewarded, errorCode)
end

function DownloadTip:ChangeToDownloadingState()
  HotUpdateMgr.StartDownload()
  self:ChangeToDownloadingUI()
end

function DownloadTip:ChangeToDownloadPauseState()
  HotUpdateMgr.PauseDownload()
  self:ChangeToPauseUI()
end

function DownloadTip:ChangeToDownloadingUI()
  EventManager.Me():PassEvent(DownloadCell.ChangeToDownloadingUIEvent)
end

function DownloadTip:ChangeToPauseUI()
  EventManager.Me():PassEvent(DownloadCell.ChangeToPauseUIEvent)
end

function DownloadTip:ChangeToDoneRewardUI()
  EventManager.Me():PassEvent(DownloadCell.ChangeToDoneRewardUIEvent)
end

function DownloadTip:InitView()
  self.progressBar = self:FindComponent("ProgressBar", UISlider)
  self.progressText = self:FindComponent("ProgressText", UILabel)
  self.downloadSize = self:FindComponent("DownloadSize", UILabel)
  self.title = self:FindComponent("Title", UILabel)
  self.title.text = ZhString.DownloadUI_Title
  self.bBg = self:FindComponent("BBg", UISprite)
  self.bg = self:FindGO("Bg")
  self.hot = self:FindGO("Hot")
  self.bgSp = self:FindComponent("Bg", UISprite)
  self.bg2Sp = self:FindComponent("bg2", UISprite)
  self.bg3Sp = self:FindComponent("bg3", UISprite)
  self.content = self:FindGO("Content")
  self.ct = self:FindGO("Ct")
  self.speedText = self:FindComponent("SpeedText", UILabel)
  self.rightBtn = self:FindGO("RightBtn")
  self.leftBtn = self:FindGO("LeftBtn")
  self.rewardBtn = self:FindGO("RewardBtn")
  self.reward = self:FindGO("Reward")
  self.btns = self:FindGO("Btns")
  self.progressGo = self:FindGO("Progress")
  self.leftBtnLabel = self:FindComponent("LeftBtnLabel", UILabel)
  self.rightBtnLabel = self:FindComponent("RightBtnLabel", UILabel)
  self.rewardBtnLabel = self:FindComponent("RewardBtnLabel", UILabel)
  self.noDnTip = self:FindComponent("NoDnTip", UILabel)
  self.rewardBtnLabel.text = ZhString.DownloadUI_IKnown
  self.descText = self:FindComponent("DescText", UILabel)
  local descTextClick = self:FindComponent("DescText", UILabelClickUrl)
  
  function descTextClick.callback(url)
    self:ShowDownloadFullTip()
  end
  
  self.closeButton = self:FindGO("CloseButton")
end

function DownloadTip:OptUIPosWithRewarded(rewarded, errorCode)
  local diff = self.descText.height - 140
  if rewarded then
    LuaVector3.Better_Set(tempVector3, 0, -64.5 - diff, 0)
    self.ct.transform.localPosition = tempVector3
    self.bg3Sp.height = 167 + diff
    self.bgSp.height = 434 + diff
    self.reward:SetActive(false)
  else
    self.reward:SetActive(true)
    LuaVector3.Better_Set(tempVector3, 0, -200 - diff, 0)
    self.ct.transform.localPosition = tempVector3
    LuaVector3.Better_Set(tempVector3, 0, -25.4 - diff, 0)
    self.reward.transform.localPosition = tempVector3
    self.bg3Sp.height = 300 + diff
    self.bgSp.height = 566 + diff
  end
end

function DownloadTip:LeftBtnClick()
  BuglyManager.GetInstance():Log("DownloadTip.PlayWithoutDownload")
  local wifi = Application.internetReachability == NetworkReachability.ReachableViaLocalAreaNetwork
  local state = HotUpdateMgr.GetHotUpdatState()
  if HotUpdateState.Downloading == state or HotUpdateState.DownloadPaused == state then
    self:ChangeToDownloadPauseState()
    self:CloseSelf()
  else
    self:CloseSelf()
    local key = DownloadTip.FIRSTPLAYGAME_PREF .. tostring(CompatibilityVersion.appPreVersion)
    if not PlayerPrefs.HasKey(key) then
      FunctionTyrantdb.Instance:trackEvent("#PlayerFirPlayGameDnExt", nil)
      PlayerPrefs.SetInt(key, 1)
    end
  end
end

function DownloadTip:RightBtnClick()
  BuglyManager.GetInstance():Log("DownloadTip.PlayWithDownload")
  self:ChangeToDownloadingState()
  self:CloseSelf()
  local key = DownloadTip.FIRSTDNWITH_PREF .. tostring(CompatibilityVersion.appPreVersion)
  if not PlayerPrefs.HasKey(key) then
    FunctionTyrantdb.Instance:trackEvent("#PlayerFirDnWithExt", nil)
    PlayerPrefs.SetInt(key, 1)
  end
end

function DownloadTip:SendGetRewards()
  ServiceSceneUser3Proxy.Instance:CallGetResourceRewardCmd()
end

function DownloadTip:RewardBtnClick()
  BuglyManager.GetInstance():Log("DownloadTip.Reward")
  if self.rewardBtnLabel.text == ZhString.DownloadUI_RetrieveReward then
    self:SendGetRewards()
    self.loginData.resourceReward = true
    self:ChangeToDoneRewardUI()
  end
  self:CloseSelf()
end

function DownloadTip:CloseSelf()
  helplog("DownloadTip CloseSelf")
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, self)
end

function DownloadTip:AddEvt()
  self:AddCloseButtonEvent()
  self:AddClickEvent(self.leftBtn, function(go)
    self:LeftBtnClick()
  end)
  self:AddClickEvent(self.rightBtn, function(go)
    self:RightBtnClick()
  end)
  self:AddClickEvent(self.rewardBtn, function(go)
    self:RewardBtnClick()
  end)
end

function DownloadTip:AddCloseButtonEvent()
  self:AddButtonEvent("CloseButton", function(go)
    self:CloseSelf()
  end)
end

function DownloadTip:ReturnLogo()
  HotUpdateMgr.SetFullExtTag()
  FunctionNetError.Me():ErrorBackToLogo()
  local key = DownloadTip.FIRSTDNCOMPLETE_PREF .. tostring(CompatibilityVersion.appPreVersion)
  if not PlayerPrefs.HasKey(key) then
    FunctionTyrantdb.Instance:trackEvent("#PlayerFirDnCompleteExt", nil)
    PlayerPrefs.SetInt(key, 1)
  end
end

function DownloadTip:ShowDownloadFullTip()
  MsgManager.ConfirmMsgByID(43305, function()
    self:ReturnLogo()
  end, function()
  end)
end

function DownloadTip:InitListener()
  self:AddListenEvt(LoadScene.LoadSceneLoaded, self.CloseSelf)
  self:AddListenEvt(DownloadTip.DownloadEvent, self.DownloadHandler)
end

function DownloadTip:UnzipProgress(entry)
  local progress = entry.Progress
  local tip = tostring(math.floor(progress * 100)) .. "%"
  self.progressBar.value = progress
  self.progressText.text = tip
  self.speedText.text = speed
end

function DownloadTip:DownloadProgress(entry)
  local progress = entry.Progress
  local speed = entry.Speed
  self.speedText.text = speed
  self:UpdateProgressBar(progress)
end

function DownloadTip:UpdateProgressBar(progress)
  local tip = tostring(math.floor(progress * 100)) .. "%"
  self.progressBar.value = progress
  self.progressText.text = tip
end

function DownloadTip:ShowUpdateDoneUI(entry)
  local tip = ZhString.DownloadUI_Complete
  self.progressBar.value = 1
  self.progressText.text = tip
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
    viewname = "DownloadConfirmView"
  })
end

function DownloadTip:ShowUnzipingUI(entry)
  local tip = ZhString.DownloadUI_Unziping
  self.progressBar.value = entry.Progress
  self.progressText.text = tip
end

function DownloadTip:DownloadHandler(event)
  local entry = event.body
  local type = entry.EntryType
  if EntryType.DownloadFailure == type then
  elseif EntryType.DownloadProgress == type then
    self:DownloadProgress(entry)
  elseif EntryType.DownloadComplete == type then
  elseif EntryType.DownloadDone == type then
    self:ShowUpdateDoneUI(entry)
  elseif EntryType.UnzipFailure == type then
  elseif EntryType.UnzipProgress == type then
    self:UnzipProgress(entry)
  elseif EntryType.UnzipComplete == type then
  elseif EntryType.UnzipDone == type then
    self:ShowUpdateDoneUI(entry)
  elseif EntryType.SwitchUnzipUI == type then
    self:ShowUnzipingUI(entry)
  end
end

function DownloadTip:OnEnter()
  DownloadTip.super.OnEnter(self)
end

function DownloadTip:OnExit()
  self.rewardList:ResetDatas({})
  DownloadTip.super.OnExit(self)
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback())
  return true
end
