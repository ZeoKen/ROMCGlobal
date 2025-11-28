autoImport("BFSecretContentCell")
BFSecretHistoryPopup = class("BFSecretHistoryPopup", ContainerView)
BFSecretHistoryPopup.ViewType = UIViewType.NormalLayer
local pageMax = 2
local pageTitles = {
  ZhString.BFBuilding_SecretHistory_Type1,
  ZhString.BFBuilding_SecretHistory_Type2
}

function BFSecretHistoryPopup:Init()
  self:FindObjs()
end

function BFSecretHistoryPopup:FindObjs()
  self.title = self:FindComponent("Title", UILabel)
  self.container = self:FindComponent("rewardContainer", UITable)
  self.uilistctrl = UIGridListCtrl.new(self.container, BFSecretContentCell, "BFSecretContentCell")
  self:AddClickEvent(self:FindGO("left"), function()
    self:SwitchFlag(-1)
  end)
  self:AddClickEvent(self:FindGO("right"), function()
    self:SwitchFlag(1)
  end)
  self.notip = self:FindGO("NoneTip")
end

function BFSecretHistoryPopup:OnEnter()
  BFSecretHistoryPopup.super.OnEnter(self)
  self.pageFlag = 1
  self:UpdateView()
end

function BFSecretHistoryPopup:UpdateView()
  local his = BFBuildingProxy.Instance:SecretGetHistory()
  local datas = {}
  local idx = 0
  for i = 1, #his do
    local cfg = Table_ExploreSecret[his[i]]
    if cfg and cfg.Flag == self.pageFlag then
      idx = idx + 1
      datas[idx] = {
        id = idx,
        content = cfg.Desc
      }
    end
  end
  self.uilistctrl:ResetDatas(datas)
  self.uilistctrl:ResetPosition()
  self.notip:SetActive(#datas == 0)
  self.title.text = pageTitles[self.pageFlag]
end

function BFSecretHistoryPopup:SwitchFlag(delta)
  self.pageFlag = self.pageFlag + delta
  if self.pageFlag > 0 then
    self.pageFlag = (self.pageFlag - 1) % pageMax + 1
  else
    self.pageFlag = self.pageFlag % pageMax + pageMax
  end
  self:UpdateView()
end
