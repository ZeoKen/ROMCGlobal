autoImport("BagItemCell")
autoImport("WarbandRewardRankCell")
WarbandRewardPopUp = class("WarbandRewardPopUp", ContainerView)
WarbandRewardPopUp.ViewType = UIViewType.PopUpLayer
local warbandProxy

function WarbandRewardPopUp:Init()
  warbandProxy = WarbandProxy.Instance
  self:InitUI()
  self:AddEvts()
end

function WarbandRewardPopUp:AddEvts()
  self:AddListenEvt(ServiceEvent.MatchCCmdTwelveWarbandQueryMatchCCmd, self.HandleQueryMember)
end

function WarbandRewardPopUp:HandleQueryMember()
  local mdata = warbandProxy.memberinfoData
  TipManager.Instance:ShowWarbandMemberTip(mdata)
end

function WarbandRewardPopUp:InitUI()
  local grid = self:FindComponent("Grid", UIGrid)
  self.itemRewardRank = self:FindComponent("ItemRewardRankLab", UILabel)
  self.noneTip = self:FindComponent("NoneTip", UILabel)
  self.noneTip.text = ZhString.Warband_Reward_Empty
  self.rewardCtl = UIGridListCtrl.new(grid, WarbandRewardRankCell, "WarbandRewardRankCell")
  local noItemReward_Grid = self:FindComponent("noItemReward_Grid", UIGrid)
  self.noItemRewardRank_Ctl = UIGridListCtrl.new(noItemReward_Grid, WarbandRewardRankCell, "WarbandRewardRankCell")
  local itemGrid = self:FindComponent("ItemRewardGrid", UIGrid)
  self.itemRewardCtl = UIGridListCtrl.new(itemGrid, BagItemCell, "BagItemCell")
  self.itemRewardCtl:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
  self:UpdateList()
end

function WarbandRewardPopUp:UpdateList()
  local data = warbandProxy:GetCurSeasonReward()
  local rankData = data and data.rankReward
  self.noneTip.gameObject:SetActive(not rankData or #rankData == 0)
  local itemData = data and data.itemReward or {}
  self.itemRewardCtl:ResetDatas(itemData)
  if not data.itemRewardRank then
    self:Hide(self.itemRewardRank)
    self:Show(self.noItemRewardRank_Ctl.layoutCtrl)
    self:Hide(self.rewardCtl.layoutCtrl)
    self.noItemRewardRank_Ctl:ResetDatas(rankData)
  else
    self:Hide(self.noItemRewardRank_Ctl.layoutCtrl)
    self:Show(self.rewardCtl.layoutCtrl)
    self.rewardCtl:ResetDatas(rankData)
    self:Show(self.itemRewardRank)
    self.itemRewardRank.text = string.format(ZhString.Warband_ItemRewardRank, data.itemRewardRank)
  end
end

function WarbandRewardPopUp:ClickItem(cellctl)
  local id = cellctl.data and cellctl.data.staticData and cellctl.data.staticData.id
  if not id then
    return
  end
  self:OpenVideoPreview(id)
end

function WarbandRewardPopUp:OpenVideoPreview(id)
  local url = GameConfig.TwelvePvpVideo and GameConfig.TwelvePvpVideo[id]
  if not url then
    redlog("杯赛奖励预览视频未配置 ID ： ", id)
    return
  end
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.VideoPreview,
    viewdata = {url = url}
  })
end
