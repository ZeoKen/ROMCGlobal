autoImport("GuildAssembleRewardCell")
GuildAssembleRewardView = class("GuildAssembleRewardView", ContainerView)
GuildAssembleRewardView.ViewType = UIViewType.PopUpLayer
local timeFormat = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"

function GuildAssembleRewardView:Init()
  self.activityData = self.viewdata and self.viewdata.viewdata
  self:FindObjs()
  self:AddListenEvt(ServiceEvent.ActivityCmdGuildAssembleSyncCmd, self.RefreshPanel)
end

function GuildAssembleRewardView:FindObjs()
  self:AddButtonEvent("closeButton", function()
    self:CloseSelf()
  end)
  self:RegistShowGeneralHelpByHelpID(self.activityData.HelpID, self:FindGO("helpButton"))
  self.timeLabel = self:FindComponent("time", UILabel)
  local rewardGrid = self:FindComponent("Grid", UIGrid)
  self.rewardList = UIGridListCtrl.new(rewardGrid, GuildAssembleRewardCell, "GuildAssembleRewardCell")
  self.rewardList:AddEventListener(GuildEvent.GetAssembleReward, self.OnAssembleRewardReceive, self)
end

function GuildAssembleRewardView:OnEnter()
  self:RefreshPanel()
end

function GuildAssembleRewardView:OnExit()
end

function GuildAssembleRewardView:RefreshPanel()
  if self.activityData then
    local assembleId = self.activityData.AssembleId
    local config = GameConfig.Assemble and GameConfig.Assemble[assembleId]
    if config then
      local datas = ReusableTable.CreateArray()
      for i = 1, #config.Reward do
        local data = {}
        data.id = i
        data.Amount = config.Reward[i].Amount
        data.RewardId = config.Reward[i].RewardId
        datas[#datas + 1] = data
      end
      self.rewardList:ResetDatas(datas)
      ReusableTable.DestroyAndClearArray(datas)
    end
    local _, sm, sd, sh, smin = self.activityData.AppearTime:match(timeFormat)
    local _, em, ed, eh, emin = self.activityData.FinishTime:match(timeFormat)
    local timeStr = string.format(ZhString.CrowdfundingAct_ParticipateTime, sm, sd, sh, smin, em, ed, eh, emin)
    self.timeLabel.text = timeStr
  end
end

function GuildAssembleRewardView:OnAssembleRewardReceive(cellCtrl)
  if cellCtrl and cellCtrl.data then
    local id = cellCtrl.data.id
    ServiceActivityCmdProxy.Instance:CallGuildAssembleAwardCmd(id)
  end
end
