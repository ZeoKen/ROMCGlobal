autoImport("GVGMoraleTipCell")
GVGMoraleTip = class("GVGMoraleTip", CoreView)

function GVGMoraleTip:ctor(go)
  GVGMoraleTip.super.ctor(self, go)
  self:Init()
end

function GVGMoraleTip:Init()
  self:_InitView()
end

function GVGMoraleTip:_InitView()
  self.titleLab = self:FindComponent("TitleLab", UILabel)
  self.titleLab.text = ZhString.GvgBuilding_MoraleTitle
  self.titleLeftLab = self:FindComponent("TitleLeftLab", UILabel)
  self.titleLeftLab.text = ZhString.GvgBuilding_MoraleLeftTitle
  local grid = self:FindGO("Grid"):GetComponent(UIGrid)
  self.moraleCtl = UIGridListCtrl.new(grid, GVGMoraleTipCell, "GVGMoraleTipCell")
end

function GVGMoraleTip:UpdateTip()
  local data = GvgProxy.Instance:GetViewTop6Morales()
  self.moraleCtl:ResetDatas(data)
end

function GVGMoraleTip:OnShow()
  self:UpdateTip()
  EventManager.Me():AddEventListener(ServiceEvent.FuBenCmdGvgMoraleUpdateFubenCmd, self.UpdateTip, self)
end

function GVGMoraleTip:OnHide()
  EventManager.Me():RemoveEventListener(ServiceEvent.FuBenCmdGvgMoraleUpdateFubenCmd, self.UpdateTip, self)
end
