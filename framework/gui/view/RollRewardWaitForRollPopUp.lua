RollRewardWaitForRollPopUp = class("RollRewardWaitForRollPopUp", BaseView)
RollRewardWaitForRollPopUp.ViewType = UIViewType.Lv4PopUpLayer

function RollRewardWaitForRollPopUp:Init()
  self.contentLabel = self:FindComponent("ContentLabel", UILabel)
  local forceBtn = self:FindGO("ForceBtn")
  forceBtn:SetActive(TeamProxy.Instance:CheckIHaveLeaderAuthority())
  self:AddClickEvent(forceBtn, function()
    ServiceTeamGroupRaidProxy.Instance:CallEnterNextRaidGroupCmd()
    self:CloseSelf()
  end)
  self.time = GameConfig.RollRaid.roll_duringtime
  TimeTickManager.Me():CreateTick(0, 500, self.UpdateLabel, self)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(TeamEvent.ExitTeam, self.CloseSelf)
end

function RollRewardWaitForRollPopUp:UpdateLabel(interval)
  self.time = self.time - interval / 1000
  if self.time < 0 then
    self:CloseSelf()
  else
    self.contentLabel.text = string.format(ZhString.RollReward_WaitForRollPopUp, math.floor(self.time))
  end
end

function RollRewardWaitForRollPopUp:OnExit()
  TimeTickManager.Me():ClearTick(self)
  RollRewardWaitForRollPopUp.super.OnExit(self)
end
