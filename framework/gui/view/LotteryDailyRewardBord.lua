autoImport("BagItemCell")
local pagePath = "GUI/v1/part/LotteryDailyRewardBord"
local _LotteryProxy
local _tempV3 = LuaVector3()
local _oneMin = "00:01"
local _cdTimeFormat = "%02d:%02d"
LotteryDailyRewardBord = class("LotteryDailyRewardBord", CoreView)

function LotteryDailyRewardBord:ctor(parent)
  if not parent then
    return
  end
  _LotteryProxy = LotteryProxy.Instance
  self:CreateSelf(parent)
end

function LotteryDailyRewardBord:CreateSelf(parent)
  self.gameObject = self:LoadPreferb_ByFullPath(pagePath, parent, true)
  self:InitBord()
end

function LotteryDailyRewardBord:InitBord()
  self:FindObjs()
end

function LotteryDailyRewardBord:FindObjs()
  self.rewardBtn = self:FindGO("DailyRewardBtn")
  self.rewardTimeLab = self:FindComponent("TimeLab", UILabel)
  self.rewardInfo = self:FindGO("DailyRewardInfo")
  self.dailyNextRewardRoot = self:FindGO("NextItemRoot", self.rewardInfo)
  local itemRoot = self:FindGO("ItemRoot", self.dailyNextRewardRoot)
  local nextItemObj = self:LoadPreferb("cell/BagItemCell", itemRoot)
  self.nextRewardCell = BagItemCell.new(nextItemObj)
  self:AddClickEvent(self.nextRewardCell.gameObject, function()
    self:OnClickRewardItem(self.nextRewardCell)
  end)
  self.dailyNextRewardFixedLab = self:FindComponent("Label", UILabel, self.dailyNextRewardRoot)
  self.dailyNextRewardFixedLab.text = ZhString.Lottery_Daily_NextReward
  self.dailyBestRewardRoot = self:FindGO("BestItemRoot", self.rewardInfo)
  itemRoot = self:FindGO("ItemRoot", self.dailyBestRewardRoot)
  local bestItemObj = self:LoadPreferb("cell/BagItemCell", itemRoot)
  self.bestRewardCell = BagItemCell.new(bestItemObj)
  self:AddClickEvent(self.bestRewardCell.gameObject, function()
    self:OnClickRewardItem(self.bestRewardCell)
  end)
  self.dailyBestRewardFixedLab = self:FindComponent("Label", UILabel, self.dailyBestRewardRoot)
  self:AddClickEvent(self.rewardBtn, function()
    if self.isRewarded then
      self:Show(self.rewardInfo)
    else
      ServiceItemProxy.Instance:CallLotteryDailyRewardGetItemCmd(self.actid, self.lotteryType, self.rewardDay)
      self:CheckActivityIsEnd()
    end
  end)
  self.redTipBg = self:FindComponent("DailyRewardRedTip", UISprite)
  self.uiEffect = self:PlayUIEffect(EffectMap.UI.DailyLottery, self.redTipBg.gameObject)
  self.rewardInfo:SetActive(false)
end

function LotteryDailyRewardBord:DestroyEff()
  if self.uiEffect and self.uiEffect:Alive() then
    self.uiEffect:Destroy()
  end
  self.uiEffect = nil
end

function LotteryDailyRewardBord:CheckActivityIsEnd()
  local nextRewardTime = ClientTimeUtil.GetNextDaily5ClockTime(1)
  local activityEndTime = _LotteryProxy:GetDailyRewardEndTime(self.actid)
  if activityEndTime <= math.floor(nextRewardTime) then
    MsgManager.ConfirmMsgByID(43250, function()
      self:Hide()
    end)
  end
end

function LotteryDailyRewardBord:OnClickRewardItem(rewardCell)
  if rewardCell and rewardCell ~= self.chooseReward then
    local data = rewardCell.data
    local stick = rewardCell.gameObject:GetComponent(UIWidget)
    if data then
      local callback = function()
        self:CancelChooseReward()
      end
      local sdata = {
        itemdata = data,
        funcConfig = {},
        callback = callback,
        ignoreBounds = {
          rewardCell.gameObject
        }
      }
      TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-250, 0})
    end
    self.chooseReward = rewardCell
  else
    self:CancelChooseReward()
  end
end

function LotteryDailyRewardBord:CancelChooseReward()
  self.chooseReward = nil
  self:ShowItemTip()
end

function LotteryDailyRewardBord:UpdateByLotteryType(t)
  self.rewardInfo:SetActive(false)
  self.rewardDay, self.rewardTime = _LotteryProxy:TryGetDailyReward(t)
  if not self.rewardDay then
    self:Hide()
  else
    self.actid = _LotteryProxy:GetCurDailyLotteryActID()
    self.lotteryType = t
    self:Show()
    self:UpdateView()
  end
end

function LotteryDailyRewardBord:HandleSyncDailyItem()
  self:SetRewardDayTime()
  self:UpdateView()
end

function LotteryDailyRewardBord:SetRewardDayTime()
  self.rewardDay, self.rewardTime = _LotteryProxy:TryGetDailyReward(self.lotteryType)
  if self.rewardTime and self.rewardTime > 0 then
    local startDate = os.date("*t", self.rewardTime)
    if 0 <= startDate.hour and startDate.hour < 5 then
      self.reward5ClockTime = os.time({
        year = startDate.year,
        month = startDate.month,
        day = startDate.day,
        hour = 5
      }) - 86400
    else
      self.reward5ClockTime = os.time({
        year = startDate.year,
        month = startDate.month,
        day = startDate.day,
        hour = 5
      })
    end
  end
end

function LotteryDailyRewardBord:UpdateView()
  self:SetRewardDayTime()
  local today5clockTime = ClientTimeUtil.GetCurrentDaily5ClockTime()
  if self.rewardTime and self.rewardTime > 0 then
    self.isRewarded = today5clockTime <= self.reward5ClockTime
  else
    self.isRewarded = false
  end
  if self.isRewarded then
    local nextRewardTime = ClientTimeUtil.GetNextDaily5ClockTime(1)
    local activityEndTime = _LotteryProxy:GetDailyRewardEndTime(self.actid)
    if activityEndTime <= math.floor(nextRewardTime) then
      self:Hide()
      return
    end
  end
  self.redTipBg.gameObject:SetActive(not self.isRewarded)
  self.rewardTimeLab.gameObject:SetActive(self.isRewarded)
  if self.isRewarded then
    self:UpdateCD()
  end
  local betterDay = _LotteryProxy.betteryIntervalDay
  if not betterDay then
    self:Hide()
    return
  end
  local nextBestDayTime = ClientTimeUtil.GetNextDaily5ClockTime(betterDay)
  local activityEndTime = _LotteryProxy:GetDailyRewardEndTime(self.actid)
  if not nextBestDayTime or not activityEndTime then
    return
  end
  local nextItemData, bestItemData = _LotteryProxy:GetDailyRewardItemData()
  self.nextRewardCell:SetData(nextItemData)
  self.bestRewardCell:SetData(bestItemData)
  if nextBestDayTime > activityEndTime then
    self.dailyBestRewardRoot:SetActive(false)
    LuaVector3.Better_Set(_tempV3, 0, 160, 0)
  else
    self.dailyBestRewardRoot:SetActive(true)
    LuaVector3.Better_Set(_tempV3, -76, 160, 0)
  end
  self.dailyNextRewardRoot.transform.localPosition = _tempV3
  self.dailyBestRewardFixedLab.text = string.format(ZhString.Lottery_Daily_BetterReward, betterDay)
end

function LotteryDailyRewardBord:UpdateCD()
  local nextRewardTime = ClientTimeUtil.GetNextDaily5ClockTime(1)
  local curServerTime = ServerTime.CurServerTime() / 1000
  local leftTime = nextRewardTime - curServerTime
  if leftTime <= 0 then
    return
  end
  local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(leftTime)
  if hour < 1 and min < 1 then
    self.rewardTimeLab.text = _oneMin
  else
    self.rewardTimeLab.text = string.format(_cdTimeFormat, hour, min)
  end
end
