ActivityDungeonInfo = class("ActivityDungeonInfo", SubView)
local title_key = {
  HeadwearRaid = "PvpTypeName_Headwear",
  TransferFight = "MainViewTransferFight_Title"
}
local toptip_helpid = {
  EvaRaid = 20006,
  HeadwearRaid = 3001,
  TransferFight = 35013,
  Kumamoto = 20006,
  MaidRaid = 35047,
  HeadWearActivity = 35099
}
local bottip_helpid = {
  EvaRaid = 20007,
  HeadwearRaid = 3002,
  TransferFight = 35014,
  Kumamoto = 20007,
  Slayers = 35020,
  MaidRaid = 35048,
  HeadWearActivity = 35100
}
local btn_label = {
  TransferFight = "MainViewTransferFight_BtnLabel"
}

function ActivityDungeonInfo:Init()
  self:FindObjs()
  self:InitUI()
end

function ActivityDungeonInfo:FindObjs()
  self.title = self:FindComponent("title", UILabel)
  self.toptip = self:FindComponent("descriptionTop", UILabel)
  self.bottip = self:FindComponent("descriptionBot", UILabel)
  self.desPic = self:FindComponent("desPic", UITexture)
  self.enterLabel = self:FindComponent("Label", UILabel, self:FindGO("Enter"))
  self.leftTimeLabel = self:FindComponent("leftTimeLabel", UILabel)
end

function ActivityDungeonInfo:InitUI()
  local raidType = self.container.raidType
  local raidConfig = self.container.raidConfig
  local raidTurnId = self.container.raidTurnId or 1
  if raidType and raidType == "Einherjar" then
    self.title.text = raidConfig.EnterInfo[raidTurnId].title or "EVA_Title"
    local rewardTimes = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_RAID_EINHERJAR_REWARD_DAY) or 0
    local totalRewardTimes = raidConfig.OpenInfo[raidTurnId].RewardMaxCount or 2
    self.toptip.text = ZhString.Einherjar_RewardsLeft .. totalRewardTimes - rewardTimes
    local helpid = raidConfig.EnterInfo[raidTurnId].helpid
    self:FillTextByHelpId(helpid, self.bottip)
    self.textureName = raidConfig.EnterInfo[raidTurnId].despic
    PictureManager.Instance:SetUI(self.textureName, self.desPic)
  else
    self.title.text = ZhString[title_key[raidType] or "EVA_Title"]
    self:FillTextByHelpId(toptip_helpid[raidType], self.toptip)
    self:FillTextByHelpId(bottip_helpid[raidType], self.bottip)
    self.textureName = self.container.raidConfig.despic
    PictureManager.Instance:SetUI(self.textureName, self.desPic)
  end
  if raidType and raidType == "Slayers" then
    self.toptip.text = string.format(ZhString.SlayersRaid_RewardFormat, MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_KUMAMOTO_HEAD_REWARD) or 0, raidConfig.DayRewardMaxCount)
  end
  if raidType and raidType == "HeadWearActivity" then
    local globalActType = ActivityCmd_pb.GACTIVITY_HEADWEARACTIVITYSCENE
    if FunctionActivity.Me():IsActivityRunning(globalActType) then
      local activityData = FunctionActivity.Me():GetActivityData(globalActType)
      local endTimeStamp = activityData and activityData.whole_endtime
      if endTimeStamp < ServerTime.CurServerTime() / 1000 then
        self.container:CloseSelf()
        return
      end
      self.endTime = endTimeStamp
      self.leftTimeLabel.gameObject:SetActive(true)
      local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(self.endTime)
      if leftDay and 0 < leftDay then
        self.leftTimeLabel.text = string.format(ZhString.ReturnActivityPanel_LeftTimeDay, leftDay, ZhString.ItemTip_DelRefreshTip_Day)
      else
        TimeTickManager.Me():ClearTick(self, 11)
        TimeTickManager.Me():CreateTick(0, 1000, self.RefreshActivityLeftTime, self, 11)
      end
    end
  end
  self.enterLabel.text = ZhString[btn_label[raidType] or "ActivityData_GoLabelText"]
end

function ActivityDungeonInfo:OnExit()
  if self.textureName then
    PictureManager.Instance:UnLoadUI(self.textureName, self.desPic)
  end
  self.super.OnExit(self)
end

function ActivityDungeonInfo:Show(target)
  ActivityDungeonInfo.super.Show(self, target)
end

function ActivityDungeonInfo:UpdateTimeTick()
  local time = self.endt
  if time == 0 then
    if self.timetick ~= nil then
      TimeTickManager.Me():ClearTick(self, 10)
      self.timetick = nil
      self.timelable.text = "00:00:00"
    end
    return
  end
  local deltaTime = ServerTime.ServerDeltaSecondTime(time * 1000)
  local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(deltaTime)
  if deltaTime <= 0 then
    if self.timetick ~= nil then
      TimeTickManager.Me():ClearTick(self, 10)
      self.timetick = nil
      self.timelable.text = "00:00:00"
    end
  elseif deltaTime < 86400 then
    self.timelable.text = string.format(ZhString.EVA_EndInHours, hour, min, sec)
  else
    self.timelable.text = string.format(ZhString.EVA_EndInDays, day)
  end
end

function ActivityDungeonInfo:RefreshActivityLeftTime()
  local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(self.endTime)
  self.leftTimeLabel.text = string.format(ZhString.ReturnActivityPanel_LeftTimeHourMin, leftHour, leftMin)
  if leftHour <= 0 and leftMin <= 0 and leftSec <= 0 then
    self.container:CloseSelf()
  end
end
