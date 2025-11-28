autoImport("WarbandSeasonRankCell")
WarbandSeasonRankPopUp = class("WarbandSeasonRankPopUp", ContainerView)
WarbandSeasonRankPopUp.ViewType = UIViewType.PopUpLayer
local warbandProxy

function WarbandSeasonRankPopUp:Init()
  warbandProxy = WarbandProxy.Instance
  self:InitUI()
end

function WarbandSeasonRankPopUp:InitUI()
  self.title = self:FindComponent("Title", UILabel)
  self.title.text = ZhString.Warband_RankTitle
  self.emptyTip = self:FindComponent("Empty", UILabel)
  self.emptyTip.text = ZhString.Warband_NoRank
  local container = self:FindGO("Wrap")
  local config = {
    wrapObj = container,
    pfbNum = 6,
    cellName = "WarbandSeasonRankCell",
    control = WarbandSeasonRankCell
  }
  self.rankList = WrapCellHelper.new(config)
  self:UpdateList()
end

local result = {}

function WarbandSeasonRankPopUp:UpdateList()
  result = warbandProxy:GetSessionRank()
  self.rankList:ResetDatas(result)
  self.emptyTip.gameObject:SetActive(#result == 0)
end

function WarbandSeasonRankPopUp:OnEnter()
  WarbandSeasonRankPopUp.super.OnEnter(self)
end
