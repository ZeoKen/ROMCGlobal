LotteryCoinInfo = class("LotteryCoinInfo", ContainerView)
LotteryCoinInfo.ViewType = UIViewType.PopUpLayer

function LotteryCoinInfo:Init()
  self.title = self:FindGO("Title"):GetComponent(UILabel)
  self.des = self:FindGO("Des"):GetComponent(UILabel)
  local TotalPrice = self:FindGO("TotalPrice", self:FindGO("TotalPriceBg")):GetComponent(UILabel)
  local TotalPrice1 = self:FindGO("TotalPrice", self:FindGO("TotalPriceBg1")):GetComponent(UILabel)
  local totalPriceTitle = self:FindGO("TotalPriceTitle", self:FindGO("TotalPriceBg")):GetComponent(UILabel)
  local totalPriceTitle1 = self:FindGO("TotalPriceTitle", self:FindGO("TotalPriceBg1")):GetComponent(UILabel)
  if BranchMgr.IsNOKR() then
    self.title.text = ZhString.SetViewServicePage_LotteryCoinInfo
    self.des.text = ZhString.SetViewServicePage_LotteryCoinInfo_Des
    totalPriceTitle.text = ZhString.SetViewServicePage_LotteryCoinInfo_Cost
    totalPriceTitle1.text = ZhString.SetViewServicePage_LotteryCoinInfo_Free
    TotalPrice.text = MyselfProxy.Instance:GetNokrDiamond() - MyselfProxy.Instance:GetNokrFreeDiamond()
    TotalPrice1.text = MyselfProxy.Instance:GetNokrFreeDiamond()
  else
    TotalPrice.text = MyselfProxy.Instance:GetLottery() - MyselfProxy.Instance:GetFreeLottery()
    TotalPrice1.text = MyselfProxy.Instance:GetFreeLottery()
  end
end

function LotteryCoinInfo:OnEnter()
  self.super.OnEnter(self)
end

function LotteryCoinInfo:OnExit()
end
