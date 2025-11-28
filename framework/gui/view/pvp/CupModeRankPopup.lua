autoImport("CupModeRankCell")
CupModeRankPopup = class("CupModeRankPopup", ContainerView)
CupModeRankPopup.ViewType = UIViewType.PopUpLayer

function CupModeRankPopup:Init()
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.proxy = viewdata and viewdata.proxy or CupMode6v6Proxy.Instance
  self:InitUI()
end

function CupModeRankPopup:InitUI()
  self.title = self:FindComponent("Title", UILabel)
  self.title.text = ZhString.Warband_RankTitle
  self.emptyTip = self:FindComponent("Empty", UILabel)
  self.emptyTip.text = ZhString.Warband_NoRank
  local container = self:FindGO("Wrap")
  local config = {
    wrapObj = container,
    pfbNum = 6,
    cellName = "WarbandSeasonRankCell",
    control = CupModeRankCell
  }
  self.rankList = WrapCellHelper.new(config)
  self:UpdateList()
end

local result = {}

function CupModeRankPopup:UpdateList()
  local result = self.proxy:GetSessionRank()
  self.rankList:ResetDatas(result)
  self.emptyTip.gameObject:SetActive(#result == 0)
end
