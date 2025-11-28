local ProgressColor = {
  Blue = LuaColor.New(0.11372549019607843, 0.8431372549019608, 1, 1),
  Gray = LuaColor.New(0.6588235294117647, 0.6588235294117647, 0.6588235294117647, 1)
}
autoImport("BigMapGvgInfoTipCell")
BigMapGvgInfoTip = class("BigMapGvgInfoTip", CoreView)

function BigMapGvgInfoTip:ctor(go)
  BigMapGvgInfoTip.super.ctor(self, go)
  self:Init()
end

function BigMapGvgInfoTip:Init()
  self:FindObjs()
end

function BigMapGvgInfoTip:FindObjs()
  self.scrollView = self:FindComponent("StrongholdsView", UIScrollView)
  self.scrollCtl = ListCtrl.new(self:FindComponent("Grid", UIGrid, self.scrollView.gameObject), BigMapGvgInfoTipCell, "MiniMap/BigMapGvgInfoTipCell")
end

function BigMapGvgInfoTip:OnShow()
  self:SetPanelDepthByParent(self.scrollView, 1)
  self:UpdateView()
  EventManager.Me():AddEventListener(GVGEvent.GVG_PointUpdate, self.UpdateView, self)
end

function BigMapGvgInfoTip:OnHide()
  EventManager.Me():RemoveEventListener(GVGEvent.GVG_PointUpdate, self.UpdateView, self)
end

function BigMapGvgInfoTip:UpdateView()
  local datas = GvgProxy.Instance:GetGvgStrongHoldDatas() or {}
  self.scrollCtl:ResetDatas(datas)
  self.scrollCtl:ResetPosition()
end
