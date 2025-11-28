CouponCodeView = class("CouponCodeView", ContainerView)
CouponCodeView.ViewType = UIViewType.PopUpLayer

function CouponCodeView:Init()
  self.data = self.viewdata.viewdata
  self:FindObjs()
  self:AddEvts()
  self:InitView()
end

function CouponCodeView:FindObjs()
  self.couponLabel = self:FindComponent("CouponLabel", UILabel)
  self.copyBtn = self:FindGO("CopyBtn")
  self.tipLabel = self:FindComponent("TipLabel", UILabel)
  self.exitBtn = self:FindGO("ExitBtn")
end

function CouponCodeView:InitView()
  self.code = tostring(self.data.CodeData.code)
  local length = StringUtil.Utf8len(self.code)
  local str = tostring(self.code)
  self.couponLabel.text = str
  self.tipLabel.text = string.format(ZhString.CouponCodeView_TipsLabel, length)
end

function CouponCodeView:AddEvts()
  self:AddClickEvent(self.copyBtn, function()
    MsgManager.ShowMsgByID(40580)
    local result = ApplicationInfo.CopyToSystemClipboard(self.code)
  end)
  self:AddClickEvent(self.exitBtn, function()
    self:CloseSelf()
  end)
end
