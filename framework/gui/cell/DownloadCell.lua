local baseCell = autoImport("BaseCell")
DownloadCell = class("DownloadCell", baseCell)
autoImport("DownloadTip")
DownloadCell.ChangeToDownloadingUIEvent = "Download_ChangeToDownloadingUIEvent"
DownloadCell.ChangeToPauseUIEvent = "Download_ChangeToPauseUIEvent"
DownloadCell.ChangeToDoneRewardUIEvent = "Download_ChangeToDoneRewardUIEvent"
DownloadCell.FIRSTPAUSE_PREF = "DownloadCell_FIRSTPAUSE_PREF_"

function DownloadCell:Init()
  self:InitView()
  self:InitListener()
  self:AddEvt()
  self:InitData()
end

function DownloadCell:InitData()
  self.curProgress = 0
  self.state = nil
  self.totalSize = HotUpdateMgr.GetTotalSizeToDl()
  HotUpdateMgr.IsEnableUnzip(false, false)
  HotUpdateMgr.SetMaxThreadCountForDl(1, 10)
  HotUpdateMgr.SetDownloadHandler(self, self.DownloadHandler)
  self:SetProgress(HotUpdateMgr.GetDownloadProgress())
  local updateDone = HotUpdateMgr.IsUpdateDone()
  local state = HotUpdateMgr.GetHotUpdatState()
  if updateDone or HotUpdateState.Finished == state then
    self:ShowUpdateDoneUI()
  end
end

local WIFICHTOCELLULAR = "10"
local DISKFULL = "-5"

function DownloadCell:ChangeToDownloadingState()
  HotUpdateMgr.StartDownload()
  self:ChangeToDownloadingUI()
end

function DownloadCell:ChangeToDownloadPauseState()
  HotUpdateMgr.PauseDownload()
  self:ChangeToPauseUI()
end

function DownloadCell:ChangeToReDownloadState()
  HotUpdateMgr.ContinueDownload()
  self:ChangeToDownloadingUI()
end

function DownloadCell:ChangeToUnzipingState()
  HotUpdateMgr.StartUnzip()
  self:ChangeToUnzipingUI()
end

function DownloadCell:ChangeToDownloadingUI()
  self.state = "downUI"
  self.downloadBtn.spriteName = "main_datadown_btn_icon1"
  self.foreground.color = LuaColor(1, 0.9333333333333333, 0.4470588235294118)
  self.downloadBtn:MakePixelPerfect()
  self:Hide(self.background)
end

function DownloadCell:ChangeToUnzipingUI()
  self.state = "unzipUI"
  self.downloadBtn.spriteName = "main_datadown_btn_icon1"
  self.downloadBtn:MakePixelPerfect()
end

function DownloadCell:PlayPause()
  self:ChangeToPauseUI()
  local key = DownloadCell.FIRSTPAUSE_PREF .. tostring(CompatibilityVersion.appPreVersion)
  if not PlayerPrefs.HasKey(key) then
    FunctionTyrantdb.Instance:trackEvent("#PlayerFirPauseDnExt", nil)
    PlayerPrefs.SetInt(key, 1)
  end
end

function DownloadCell:ChangeToPauseUI()
  BuglyManager.GetInstance():Log("DownloadCell.ChangeToPauseUI")
  self.state = "pauseUI"
  self.downloadBtn.spriteName = "main_datadown_btn_icon2"
  local tip = ZhString.DownloadUI_CellPause
  self.loadingText.text = tip
  self.downloadBtn:MakePixelPerfect()
  self.foreground.color = LuaColor(1, 0.9333333333333333, 0.4470588235294118)
  self:Hide(self.background)
end

function DownloadCell:ChangeDiskFullState()
  BuglyManager.GetInstance():Log("DownloadCell.ChangeDiskFullState")
  self.state = "fullUI"
  local tip = ZhString.DownloadUI_DiskFULL
  self.loadingText.text = tip
  self.downloadBtn.spriteName = "main_datadown_btn_icon4"
  self.downloadBtn:MakePixelPerfect()
  self.background.spriteName = "main_datadown_icon_line03"
  self.foreground.color = LuaColor(1, 1, 1)
  self:Show(self.background)
end

function DownloadCell:ChangeToDoneRewardUI()
  self.state = "donerewrdUI"
  local tip = ZhString.DownloadUI_Rewarded
  self:ShowUpdateDoneBarUI(tip)
  BuglyManager.GetInstance():Log("DownloadCell.ChangeToDoneRewardUI")
end

function DownloadCell:ShowUpdateDoneUI(entry)
  BuglyManager.GetInstance():Log("DownloadCell.ShowUpdateDoneUI")
  self.state = "doneUI"
  local loginData = FunctionLogin.Me():getLoginData() or {}
  local rewarded = loginData.resourceReward
  if rewarded then
    local tip = ZhString.DownloadUI_Complete
    self:ShowUpdateDoneBarUI(tip)
  else
    local tip = ZhString.DownloadUI_Reward
    self:ShowUpdateDoneBarUI(tip)
  end
  self:ShowDownloadTip(true)
end

function DownloadCell:ShowUpdateDoneBarUI(tip)
  self.loadingBar.value = 1
  local loginData = FunctionLogin.Me():getLoginData() or {}
  local rewarded = loginData.resourceReward
  if rewarded then
    self.downloadBtn.spriteName = "main_datadown_btn_icon3"
    self:Hide(self.rewardTip)
  else
    self.downloadBtn.spriteName = "main_datadown_btn_icon5"
    self:Show(self.rewardTip)
  end
  self.loadingText.text = tip
  self.downloadBtn:MakePixelPerfect()
  self.background.spriteName = "main_datadown_icon_line02"
  self.foreground.color = LuaColor(1, 1, 1)
  self:Show(self.background)
end

function DownloadCell:ShowUnzipingUI(entry)
  self.state = "unzipingUI"
  local tip = ZhString.DownloadUI_Unziping
  self.loadingBar.value = entry.Progress
  self.loadingText.text = tip
  self.downloadBtn.spriteName = "main_datadown_btn_icon3"
  self.downloadBtn:MakePixelPerfect()
end

function DownloadCell:UnzipProgress(entry)
  if "downUI" ~= self.state then
    self:ChangeToDownloadingUI()
  end
  local progress = entry.Progress
  self.curProgress = progress
  self.loadingBar.value = progress
  local tip = ZhString.DownloadUI_Unziping
  self.loadingText.text = tip
end

function DownloadCell:DownloadProgress(entry)
  if "downUI" ~= self.state then
    self:ChangeToDownloadingUI()
  end
  local progress = entry.Progress
  local speed = entry.Speed
  self:SetProgress(progress, speed)
end

function DownloadCell:SetProgress(progress, speed)
  self.curProgress = progress
  self.loadingBar.value = progress
  self.loadingText.text = speed
end

function DownloadCell:InitView()
  self.gameObject.transform:SetAsFirstSibling()
  self.loadingBar = self:FindComponent("LoadingBar", UISlider)
  self.loadingText = self:FindComponent("LoadingText", UILabel)
  self.downloadBtn = self:FindComponent("DownloadBtn", UISprite)
  self.rewardTip = self:FindGO("RewardTip")
  self:Hide(self.rewardTip)
  self.cellBg = self:FindComponent("cellBg", UISprite)
  self.background = self:FindComponent("background", UISprite)
  self.foreground = self:FindComponent("foreground", UISprite)
end

function DownloadCell:SendGetRewards()
end

function DownloadCell:AddEvt()
  self:AddClickEvent(self.cellBg.gameObject, function(go)
    local updateDone = HotUpdateMgr.IsUpdateDone()
    local state = HotUpdateMgr.GetHotUpdatState()
    local confirmView
    if HotUpdateState.Finished == state or updateDone then
      confirmView = true
    end
    self:ShowDownloadTip(confirmView)
  end)
end

function DownloadCell:ReturnLogo()
  HotUpdateMgr.SetFullExtTag()
  FunctionNetError.Me():ErrorBackToLogo()
end

function DownloadCell:ShowDownloadFullTip()
  BuglyManager.GetInstance():Log("DownloadCell.ShowDownloadFullTip")
  MsgManager.ConfirmMsgByID(43305, function()
    self:ReturnLogo()
  end, function()
  end)
end

function DownloadCell:ShowRestartTip()
  BuglyManager.GetInstance():Log("DownloadCell.ShowRestartTip")
  MsgManager.ConfirmMsgByID(27000, function()
    ApplicationInfo.Quit()
  end)
end

function DownloadCell:ShowDownloadTip(confirmView, errorCode)
  BuglyManager.GetInstance():Log("DownloadCell.ShowDownloadTip")
  if confirmView then
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "DownloadConfirmView",
      errorCode = errorCode
    })
  else
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "DownloadTip"
    })
  end
end

function DownloadCell:btnClick()
  local state = HotUpdateMgr.GetHotUpdatState()
  if HotUpdateState.None == state then
    self:ChangeToDownloadingState()
  elseif HotUpdateState.DownloadPaused == state then
    self:ChangeToReDownloadState()
  elseif HotUpdateState.Downloading == state then
    self:ChangeToDownloadPauseState()
  elseif HotUpdateState.Unziping == state then
  elseif HotUpdateState.Finished == state then
    self:ShowRestartTip()
  elseif HotUpdateState.UnizpPause == state then
    self:ChangeToUnzipingState()
  end
end

function DownloadCell:InitListener()
  EventManager.Me():AddEventListener(DownloadCell.ChangeToDownloadingUIEvent, self.ChangeToDownloadingUI, self)
  EventManager.Me():AddEventListener(DownloadCell.ChangeToPauseUIEvent, self.PlayPause, self)
  EventManager.Me():AddEventListener(DownloadCell.ChangeToDoneRewardUIEvent, self.ChangeToDoneRewardUI, self)
end

function DownloadCell:ShowDownloadError(entry)
  self:ChangeToDownloadPauseState()
  local errorMsg = entry.ErrorMessage
  local sts = string.split(errorMsg, "|&$|")
  local errorTip = string.split(sts[1], "&:&")[2]
  local errorCode = string.split(sts[2], "&:&")[2]
  local responseCode = string.split(sts[3], "&:&")[2]
  if WIFICHTOCELLULAR == errorCode then
    self:ShowDownloadTip(true, errorCode)
  elseif DISKFULL == errorCode then
    self:ChangeDiskFullState()
    self:ShowDownloadTip(true, errorCode)
  end
  BuglyManager.GetInstance():Log("DownloadCell.ShowDownloadError:" .. errorMsg)
end

function DownloadCell:DownloadHandler(entry)
  local type = entry.EntryType
  if EntryType.DownloadFailure == type then
    self:ShowDownloadError(entry)
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
  GameFacade.Instance:sendNotification(DownloadTip.DownloadEvent, entry)
end

function DownloadCell:OnDestroy()
  DownloadCell.super.OnDestroy(self)
  EventManager.Me():RemoveEventListener(DownloadCell.ChangeToDownloadingUIEvent, self.ChangeToDownloadingUI, self)
  EventManager.Me():RemoveEventListener(DownloadCell.ChangeToPauseUIEvent, self.PlayPause, self)
  EventManager.Me():RemoveEventListener(DownloadCell.ChangeToDoneRewardUIEvent, self.ChangeToDoneRewardUI, self)
end
