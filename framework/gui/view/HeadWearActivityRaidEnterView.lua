HeadWearActivityRaidEnterView = class("HeadWearActivityRaidEnterView", ContainerView)
HeadWearActivityRaidEnterView.ViewType = UIViewType.NormalLayer
autoImport("HeadWearActivityRaidRewardCell")

function HeadWearActivityRaidEnterView:Init()
  self:AddListenEvts()
  self:InitView()
  self:InitDatas()
  self:InitShow()
end

function HeadWearActivityRaidEnterView:OnEnter()
  HeadWearActivityRaidEnterView.super.OnEnter(self)
  self:CameraRotateToMe()
  BattleTimeDataProxy.QueryBattleTimelenUserCmd()
  ServiceRaidCmdProxy.Instance:CallQueryHeadwearActivityRewardRecordCmd(Game.Myself.data.id)
end

function HeadWearActivityRaidEnterView:OnExit()
  UIUtil.StopEightTypeMsg()
  self:CameraReset()
  TimeTickManager.Me():ClearTick(self)
  HeadWearActivityRaidEnterView.super.OnExit(self)
end

function HeadWearActivityRaidEnterView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.NUserBattleTimelenUserCmd, self.HandleBattleTimelen)
  self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.OnEnterTeam)
  self:AddListenEvt(ServiceEvent.RaidCmdQueryHeadwearActivityRewardRecordCmd, self.RecvRewardStatus)
end

function HeadWearActivityRaidEnterView:InitView()
  self.title = self:FindComponent("title", UILabel)
  self.toptip = self:FindComponent("descriptionTop", UILabel)
  self.bottip = self:FindComponent("descriptionBot", UILabel)
  self.middlePart = self:FindGO("middlePart")
  self.middleScrollView = self:FindGO("middleScrollView"):GetComponent(UIScrollView)
  self.middleGrid = self:FindGO("middleGrid"):GetComponent(UIGrid)
  self.middleGridCtrl = UIGridListCtrl.new(self.middleGrid, HeadWearActivityRaidRewardCell, "HeadWearActivityRaidRewardCell")
  self.middleGridCtrl:AddEventListener(UICellEvent.OnCellClicked, self.handleClickReward, self)
  self.enterLabel = self:FindComponent("Label", UILabel, self:FindGO("Enter"))
  self.leftTimeLabel = self:FindComponent("leftTimeLabel", UILabel)
  self.tipsContainer = self:FindGO("tipsContainer"):GetComponent(UIWidget)
  self:AddButtonEvent("Enter", function()
    ServiceLoginUserCmdProxy.Instance:CallServerTimeUserCmd()
    self:EnterRaid()
  end)
end

function HeadWearActivityRaidEnterView:InitDatas()
  self.raidConfig = GameConfig.HeadWearActivity
  self.rewardRecords = {}
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function HeadWearActivityRaidEnterView:InitShow()
  self.title.text = ZhString.EVA_Title
  self:FillTextByHelpId(35099, self.toptip)
  self:FillTextByHelpId(35100, self.bottip)
  local rewardFloor = self.raidConfig.reward
  local maxRewardCound = self.raidConfig.dayLimit or 1
  local rewardList = {}
  for k, v in pairs(rewardFloor) do
    local data = {
      floor = k,
      rewardID = v,
      max = maxRewardCound
    }
    table.insert(rewardList, data)
  end
  table.sort(rewardList, function(l, r)
    return l.floor < r.floor
  end)
  self.middleGridCtrl:ResetDatas(rewardList)
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

function HeadWearActivityRaidEnterView:EnterRaid()
  local entryLevel = self.raidConfig.Entrylevel
  if entryLevel > MyselfProxy.Instance:RoleLevel() then
    MsgManager.ShowMsgByID(7301, entryLevel)
    return
  end
  if TeamProxy.Instance:IHaveTeam() then
    local memberListExceptMe = TeamProxy.Instance.myTeam:GetMembersListExceptMe()
    for i = 1, #memberListExceptMe do
      if entryLevel > memberListExceptMe[i].baselv then
        MsgManager.ShowMsgByID(7305, entryLevel)
        return
      end
    end
  end
  self:Enter(FuBenCmd_pb.ERAIDTYPE_HEADWEARACTIVITY)
end

function HeadWearActivityRaidEnterView:Enter(pbRaidType)
  DungeonProxy.InviteTeamRaid(nil, pbRaidType, nil, function()
    self:CloseSelf()
  end)
end

function HeadWearActivityRaidEnterView:OnEnterTeam()
  local ins = DungeonProxy.Instance
  if ins.createSingleTeamRequested == nil then
    return
  end
  DungeonProxy.InviteTeamRaid(nil, ins.createSingleTeamRequested, nil, function()
    self:CloseSelf()
  end)
end

function HeadWearActivityRaidEnterView:HandleBattleTimelen(note)
  local data = note.body
  if not (data and data.timelen) or not data.totaltime then
    return
  end
  local leftTimeLen = data.totaltime - data.timelen
  self.remainingBattleTime = (data.musictime or 0) + (data.tutortime or 0) + (data.powertime or 0) + (leftTimeLen < 0 and 0 or leftTimeLen)
end

function HeadWearActivityRaidEnterView:RecvRewardStatus(note)
  local data = note.body
  local records = data.records
  if records and 0 < #records then
    for i = 1, #records do
      local single = records[i]
      self.rewardRecords[single.round] = single.rewardTimes
    end
  end
  local cells = self.middleGridCtrl:GetCells()
  for i = 1, #cells do
    local single = cells[i]
    if single.floor and self.rewardRecords[single.floor] then
      single:SetProcess(self.rewardRecords[single.floor])
    end
  end
end

function HeadWearActivityRaidEnterView:RefreshActivityLeftTime()
  local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(self.endTime)
  self.leftTimeLabel.text = string.format(ZhString.ReturnActivityPanel_LeftTimeHourMin, leftHour, leftMin)
  if leftHour <= 0 and leftMin <= 0 and leftSec <= 0 then
    self.container:CloseSelf()
  end
end

function HeadWearActivityRaidEnterView:handleClickReward(cellCtrl)
  if cellCtrl and cellCtrl.data then
    self.tipData.itemdata = cellCtrl.data
    self:ShowItemTip(self.tipData, self.tipsContainer, NGUIUtil.AnchorSide.Center, {0, 0})
  end
end
