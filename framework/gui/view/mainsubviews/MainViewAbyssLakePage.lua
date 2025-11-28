autoImport("AbyssBossHeadCell")
autoImport("AbyssRewardItemCell")
MainViewAbyssLakePage = class("MainViewAbyssLakePage", SubView)

function MainViewAbyssLakePage:Init()
  local tsfParent = self:FindGO("Anchor_Left").transform
  self:ReLoadPerferb("view/MainViewAbyssLakePage")
  self.trans:SetParent(tsfParent, false)
  self:FindObjs()
  self:AddViewEvents()
end

function MainViewAbyssLakePage:FindObjs()
  local mvpgrid = self:FindComponent("MVPGrid", UIGrid)
  self.mvpList = UIGridListCtrl.new(mvpgrid, AbyssBossHeadCell, "AbyssBossHeadCell")
  self.mvpList:AddEventListener(MouseEvent.MouseClick, self.OnClickMonster, self)
  local monsterGrid = self:FindComponent("MiniGrid", UIGrid)
  self.miniList = UIGridListCtrl.new(monsterGrid, AbyssBossHeadCell, "AbyssBossHeadCell")
  self.miniList:AddEventListener(MouseEvent.MouseClick, self.OnClickMonster, self)
  self.progress = self:FindComponent("Progress", UISlider)
  self.progressLabel = self:FindComponent("ProgressLabel", UILabel)
  self.mvpCountLabel = self:FindComponent("MVPCountLabel", UILabel)
  self.miniCountLabel = self:FindComponent("MiniCountLabel", UILabel)
  self.closecomp = self:FindComponent("RewardTip", CloseWhenClickOtherPlace)
  local rewardGrid = self:FindComponent("RewardGrid", UIGrid)
  self.rewardList = UIGridListCtrl.new(rewardGrid, AbyssRewardItemCell, "AbyssRewardItemCell")
  
  function self.closecomp.callBack(go)
    self:HideRewardTip()
  end
  
  self:AddClickEvent(self:FindGO("RewardBtn"), function()
    self:ShowRewardTip()
  end)
  local ProgressTitle = self:FindComponent("ProgressTitle", UILabel)
  local RewardTitle = self:FindComponent("MVPTitle", UILabel)
  local BossTitle = self:FindComponent("MiniTitle", UILabel)
  ProgressTitle.text = ZhString.AbyssBoss_Title
  RewardTitle.text = ZhString.AbyssBoss_Reward
  BossTitle.text = ZhString.AbyssBoss_BossTitle
  self:HideRewardTip()
end

function MainViewAbyssLakePage:HideRewardTip()
  self.closecomp.gameObject:SetActive(false)
end

function MainViewAbyssLakePage:ShowRewardTip()
  self.closecomp.gameObject:SetActive(true)
  local rewardData = AbyssLakeProxy.Instance:GetRewardData(GameConfig.AbyssBoss.ContributeReward)
  self.rewardList:ResetDatas(rewardData)
end

function MainViewAbyssLakePage:AddViewEvents()
  self:AddListenEvt(ServiceEvent.MapAbyssBossUpdateCmd, self.UpdateView)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.UpdateProgress)
end

function MainViewAbyssLakePage:OnShow(note)
  MainViewAbyssLakePage.super.OnShow(self, note)
  self:UpdateProgress()
end

function MainViewAbyssLakePage:UpdateProgress(note)
  local val = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_ABYSS_CONTRIBUTE) or 0
  local configMax = GameConfig.AbyssBoss.ContributeBound or 3000
  self.progressLabel.text = string.format("%d/%d", val, configMax)
  self.progress.value = val / configMax
  self.mvpCountLabel.text = string.format("%d/%d", MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_ABYSS_MVP) or 0, MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_ABYSS_MVP_BOUND) or 1)
  self.miniCountLabel.text = string.format("%d/%d", MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_ABYSS_MINI) or 0, MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_ABYSS_MINI_BOUND) or 1)
end

function MainViewAbyssLakePage:UpdateView(note)
  self:UpdateProgress()
  self:UpdateBosslist()
end

function MainViewAbyssLakePage:UpdateBosslist()
  local mvp = AbyssLakeProxy.Instance:GetMvpMonsters()
  self.mvpList:ResetDatas(mvp)
  local mini = AbyssLakeProxy.Instance:GetMiniMonsters()
  self.miniList:ResetDatas(mini)
end

function MainViewAbyssLakePage:OnClickMonster(cellctrl)
  if cellctrl then
    cellctrl:OnClick()
  end
end
