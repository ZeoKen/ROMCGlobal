autoImport("TableUtil")
DownloadConfirmView = class("DownloadConfirmView", BaseView)
DownloadConfirmView.ViewType = UIViewType.PopUpLayer
autoImport("DownloadTipItemCell")
autoImport("GainWayTip")

function DownloadConfirmView:Init()
  self:InitView()
  self:InitListener()
  self:AddEvt()
  self:InitData()
  self:SetData(self.viewdata.errorCode)
end

function DownloadConfirmView:GetReward(t1, t2)
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

function DownloadConfirmView:InitData()
  self.curProgress = 0
  self.totalSize = HotUpdateMgr.GetTotalSizeToDl()
  self.loginData = FunctionLogin.Me():getLoginData() or {}
  local sdk = FunctionLogin.Me():getFunctionSdk()
  local plat = "1"
  if sdk then
    plat = sdk:GetPlat()
  end
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

function DownloadConfirmView:ClickItemCell(cell)
  local data = {
    funcConfig = _EmptyTable,
    itemdata = ItemData.new(),
    hideGetPath = false
  }
  data.itemdata:ResetData("Tip", cell.itemId)
  self:ShowItemTip(data, self.bgSp, NGUIUtil.AnchorSide.Left)
end

function DownloadConfirmView.ReadableSize(bytes)
  local state = HotUpdateMgr.GetHotUpdatState()
  local unit = 1024
  if bytes < unit then
    return bytes .. " B"
  end
  local exp = math.floor(math.log(bytes) / math.log(unit))
  return string.format("%.1f %s", bytes / math.pow(unit, exp), string.sub("KMGTPE", exp, exp))
end

local WIFICHTOCELLULAR = "10"
local DISKFULL = "-5"
local tempVector3 = LuaVector3.Zero()

function DownloadConfirmView:SetData(errorCode)
  local rewarded = self.loginData.resourceReward
  self.rightBtnLabel.text = ZhString.DownloadUI_ContinuteDn
  self.leftBtnLabel.text = ZhString.DownloadUI_Pause
  if WIFICHTOCELLULAR == errorCode then
    self.descText.text = ZhString.DownloadUI_DownloadTip_1
    self.rewardBtn:SetActive(false)
  elseif DISKFULL == errorCode then
    self.descText.text = ZhString.DownloadUI_DownloadTip_3
    self.rewardBtn:SetActive(true)
    self:Hide(self.leftBtn)
    self:Hide(self.rightBtn)
  else
    self:Show(self.leftBtn)
    self:Show(self.rightBtn)
    self:Hide(self.rewardBtn)
    self.rightBtnLabel.text = ZhString.DownloadUI_RetrieveRewardRebot
    self.leftBtnLabel.text = ZhString.DownloadUI_RetrieveReward
    if not rewarded then
      self.rewardBtnLabel.text = ZhString.DownloadUI_RetrieveReward
    end
    local text = ZhString.DownloadUI_DownloadTip_2
    self.descText.text = text
  end
  self:OptUIPosWithRewarded(rewarded, errorCode)
end

function DownloadConfirmView:ChangeToDownloadingState()
  HotUpdateMgr.StartDownload()
  self:ChangeToDownloadingUI()
end

function DownloadConfirmView:ChangeToDownloadPauseState()
  HotUpdateMgr.PauseDownload()
  self:ChangeToPauseUI()
end

function DownloadConfirmView:ChangeToDownloadingUI()
  EventManager.Me():PassEvent(DownloadCell.ChangeToDownloadingUIEvent)
end

function DownloadConfirmView:ChangeToPauseUI()
  EventManager.Me():PassEvent(DownloadCell.ChangeToPauseUIEvent)
end

function DownloadConfirmView:ChangeToDoneRewardUI()
  EventManager.Me():PassEvent(DownloadCell.ChangeToDoneRewardUIEvent)
end

function DownloadConfirmView:InitView()
  self.title = self:FindComponent("Title", UILabel)
  self.title.text = ZhString.DownloadUI_Title
  self.bBg = self:FindComponent("BBg", UISprite)
  self.bg = self:FindGO("Bg")
  self.hot = self:FindGO("Hot")
  self.bgSp = self:FindComponent("Bg", UISprite)
  self.bg2Sp = self:FindComponent("bg2", UISprite)
  self.bg3Sp = self:FindComponent("bg3", UISprite)
  self.content = self:FindGO("Content")
  self.rightBtn = self:FindGO("RightBtn")
  self.leftBtn = self:FindGO("LeftBtn")
  self.rewardBtn = self:FindGO("RewardBtn")
  self.reward = self:FindGO("Reward")
  self.btns = self:FindGO("Btns")
  self.leftBtnLabel = self:FindComponent("LeftBtnLabel", UILabel)
  self.rightBtnLabel = self:FindComponent("RightBtnLabel", UILabel)
  self.rewardBtnLabel = self:FindComponent("RewardBtnLabel", UILabel)
  self.rewardBtnLabel.text = ZhString.DownloadUI_IKnown
  self.descText = self:FindComponent("DescText", UILabel)
  self.descText.text = ZhString.DownloadUI_DownloadConfirmView
  self.closeButton = self:FindGO("CloseButton")
end

function DownloadConfirmView:OptUIPosWithRewarded(rewarded, errorCode)
  local diff = self.descText.height - 106
  if not errorCode and not rewarded then
    self.reward:SetActive(true)
    self.bg3Sp.height = 292 + diff
    self.bgSp.height = 474 + diff
    LuaVector3.Better_Set(tempVector3, 0, 152 - diff, 0)
    self.descText.transform.localPosition = tempVector3
    LuaVector3.Better_Set(tempVector3, 0, -184 - diff, 0)
    self.btns.transform.localPosition = tempVector3
    LuaVector3.Better_Set(tempVector3, 0, -33 - diff, 0)
    self.reward.transform.localPosition = tempVector3
  else
    self.reward:SetActive(false)
    LuaVector3.Better_Set(tempVector3, 0, 89, 0)
    self.descText.transform.localPosition = tempVector3
  end
end

function DownloadConfirmView:LeftBtnClick()
  if self.leftBtnLabel.text == ZhString.DownloadUI_RetrieveReward then
    self:RewardBtnClick()
  else
    local wifi = Application.internetReachability == NetworkReachability.ReachableViaLocalAreaNetwork
    local state = HotUpdateMgr.GetHotUpdatState()
    if HotUpdateState.Downloading == state or HotUpdateState.DownloadPaused == state then
      self:ChangeToDownloadPauseState()
      self:CloseSelf()
    else
      self:CloseSelf()
    end
  end
end

function DownloadConfirmView:RightBtnClick()
  if self.rightBtnLabel.text == ZhString.DownloadUI_RetrieveRewardRebot then
    MsgManager.ConfirmMsgByID(1028, function()
      TimeTickManager.Me():CreateTick(3000, 1000, function()
        FunctionNetError.Me():ErrorBackToLogo()
      end, self, 1)
      self:RewardBtnClick(true)
    end, function()
    end)
  else
    self:ChangeToDownloadingState()
    self:CloseSelf()
  end
end

function DownloadConfirmView:SendGetRewards()
  ServiceSceneUser3Proxy.Instance:CallGetResourceRewardCmd()
end

function DownloadConfirmView:RewardBtnClick(noclose)
  if self.rewardBtnLabel.text == ZhString.DownloadUI_RetrieveReward then
    self:SendGetRewards()
    self.loginData.resourceReward = true
    self:ChangeToDoneRewardUI()
  end
  if not noclose then
    self:CloseSelf()
  end
end

function DownloadConfirmView:CloseSelf()
  helplog("DownloadConfirmView CloseSelf")
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, self)
end

function DownloadConfirmView:AddEvt()
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

function DownloadConfirmView:AddCloseButtonEvent()
  self:AddButtonEvent("CloseButton", function(go)
    self:CloseSelf()
  end)
end

function DownloadConfirmView:InitListener()
  self:AddListenEvt(LoadScene.LoadSceneLoaded, self.CloseSelf)
end

function DownloadConfirmView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  self.rewardList:ResetDatas({})
  DownloadConfirmView.super.OnExit(self)
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback())
  return true
end
