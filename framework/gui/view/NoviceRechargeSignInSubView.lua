NoviceRechargeSignInSubView = class("NoviceRechargeSignInSubView", SubView)
local viewPath = ResourcePathHelper.UIView("NoviceRechargeSignInSubView")
autoImport("NoviceRechargeSignInCell")

function NoviceRechargeSignInSubView:Init()
  if self.inited then
    return
  end
  self:FindObjs()
  self:AddViewEvts()
  self:AddMapEvts()
  self:InitDatas()
  self.inited = true
end

function NoviceRechargeSignInSubView:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container, true)
  obj.name = "NoviceRechargeSignInSubView"
end

function NoviceRechargeSignInSubView:FindObjs()
  self:LoadSubView()
  self.gameObject = self:FindGO("NoviceRechargeSignInSubView")
  self.tipLabel = self:FindGO("TipsLabel"):GetComponent(UILabel)
  self.tipLabel.text = ZhString.NoviceRecharge_Tips
  self.scrollView = self:FindGO("ScrollView"):GetComponent(UIScrollView)
  self.grid = self:FindGO("Grid"):GetComponent(UIGrid)
  self.rechargeListCtrl = UIGridListCtrl.new(self.grid, NoviceRechargeSignInCell, "NoviceRechargeSignInCell")
  self.rechargeListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickReceive, self)
end

function NoviceRechargeSignInSubView:AddViewEvts()
end

function NoviceRechargeSignInSubView:AddMapEvts()
  self:AddListenEvt(ServiceEvent.SceneUser3NoviceChargeReward, self.RefreshPage)
end

function NoviceRechargeSignInSubView:InitDatas()
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function NoviceRechargeSignInSubView:RefreshPage()
  local activityID = NoviceRechargeProxy.Instance.activityID
  local activityConfig = Table_NoviceCharge and Table_NoviceCharge[activityID]
  if not activityConfig then
    return
  end
  local endTime = NoviceRechargeProxy.Instance:GetEndDate()
  local rewardList = activityConfig.Reward
  self.rechargeListCtrl:ResetDatas(rewardList)
  self.container:TimeLeftCountDown(endTime)
  if self.gameObject.activeSelf then
    self.container:TimeLeftCountDown(endTime)
  end
end

function NoviceRechargeSignInSubView:HandleClickReceive(cellCtrl)
  local index = cellCtrl.indexInList
  xdlog("todo  申请领奖", index)
  ServiceSceneUser3Proxy.Instance:CallNoviceChargeReward(index)
end
