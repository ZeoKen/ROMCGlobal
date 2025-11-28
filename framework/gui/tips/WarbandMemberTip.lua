autoImport("BaseTip")
autoImport("WarbandMemberInfoCell")
WarbandMemberTip = class("WarbandMemberTip", BaseTip)

function WarbandMemberTip:Init()
  if WarbandMemberTip.ShowStaticPicture == nil then
    WarbandMemberTip.ShowStaticPicture = not BackwardCompatibilityUtil.CompatibilityMode_V54 or ApplicationInfo.IsIphone7P_or_Worse() or ApplicationInfo.IsIpad6_or_Worse()
  end
  self:AddButtonEvent("CloseBtn", function(go)
    TipsView.Me():HideCurrent()
  end)
  local grid = self:FindComponent("Grid", UIGrid)
  self.memberCtl = UIGridListCtrl.new(grid, WarbandMemberInfoCell, "WarbandMemberInfoCell")
end

function WarbandMemberTip:SetData(data)
  self.data = data
  self.memberCtl:ResetDatas(data or {})
end

function WarbandMemberTip:OnExit()
  self.memberCtl:RemoveAll()
  return WarbandMemberTip.super.OnExit(self)
end
