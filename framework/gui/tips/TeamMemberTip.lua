autoImport("BaseTip")
autoImport("TeamMemberTipCell")
TeamMemberTip = class("TeamMemberTip", BaseTip)

function TeamMemberTip:Init()
  if TeamMemberTip.ShowStaticPicture == nil then
    TeamMemberTip.ShowStaticPicture = not BackwardCompatibilityUtil.CompatibilityMode_V54 or ApplicationInfo.IsIphone7P_or_Worse() or ApplicationInfo.IsIpad6_or_Worse()
  end
  self:AddButtonEvent("CloseBtn", function(go)
    TipsView.Me():HideCurrent()
  end)
  local grid = self:FindComponent("Grid", UIGrid)
  self.memberCtl = UIGridListCtrl.new(grid, TeamMemberTipCell, "TeamMemberTipCell")
  self.teamNameLabel = self:FindComponent("TeamName", UILabel)
end

function TeamMemberTip:SetData(data)
  self.data = data
  if data then
    self.teamNameLabel.text = data.teamName or ""
  end
  self.memberCtl:ResetDatas(data and data.memberData or {})
end

function TeamMemberTip:OnExit()
  self.memberCtl:RemoveAll()
  return TeamMemberTip.super.OnExit(self)
end
