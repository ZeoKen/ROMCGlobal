autoImport("AstralLevelTargetCell")
AstralRewardPopUp = class("AstralRewardPopUp", ContainerView)
AstralRewardPopUp.ViewType = UIViewType.PopUpLayer

function AstralRewardPopUp:Init()
  self:InitData()
  self:FindObjs()
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncPvePassInfoFubenCmd, self.RefreshView)
end

function AstralRewardPopUp:InitData()
  self.rewardTargets = {}
  local curSeason = AstralProxy.Instance:GetSeason()
  local config = Table_AstralSeason[curSeason]
  if config then
    for num, rewardId in pairs(config.PassNumReward) do
      local data = {}
      data.targetNum = num
      data.reward = rewardId
      self.rewardTargets[#self.rewardTargets + 1] = data
    end
    table.sort(self.rewardTargets, function(l, r)
      return l.targetNum < r.targetNum
    end)
  end
end

function AstralRewardPopUp:FindObjs()
  self:AddCloseButtonEvent()
  local grid = self:FindComponent("Grid", UIGrid)
  self.targetListCtrl = UIGridListCtrl.new(grid, AstralLevelTargetCell, "AstralLevelTargetCell")
end

function AstralRewardPopUp:OnEnter()
  self:RefreshView()
end

function AstralRewardPopUp:RefreshView()
  self.targetListCtrl:ResetDatas(self.rewardTargets)
end
