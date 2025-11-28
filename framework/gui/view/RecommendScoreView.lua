RecommendScoreView = class("RecommendScoreView", ContainerView)
RecommendScoreView.ViewType = UIViewType.TipLayer
autoImport("RecommendScoreItemCell")

function RecommendScoreView:Init()
  if Game.MapManager:IsRaidMode(true) then
    helplog()
    UIManagerProxy.Instance:ActiveLayer(UIViewType.FloatLayer, false)
  end
  self:FindObjs()
  self:AddEvent()
  self:InitData()
end

function RecommendScoreView:FindObjs()
  self.contentLabel = self:FindComponent("ContentLabel", UILabel)
  self.giftLable = self:FindComponent("GiftLabel", UILabel)
  self.cancelLabel = self:FindComponent("CancelLabel", UILabel)
  self.confirmLabel = self:FindComponent("ConfirmLabel", UILabel)
  self.leftBut = self:FindGO("CancelBtn")
  self.rightBtn = self:FindGO("ConfirmBtn")
  self.closeBut = self:FindGO("CloseButton")
  self.listGroupItems = {}
  local itemcell
  for i = 1, 3 do
    itemcell = self:FindGO("giftItem" .. i)
    self.listGroupItems[i] = RecommendScoreItemCell.new(itemcell)
  end
  self.butnClick = false
end

function RecommendScoreView:InitData()
  self.menuId = self.viewdata.menuId
  for k, v in pairs(Table_Evaluation) do
    if v.MenuId and self:Is_include(self.menuId, v.MenuId) then
      self.data = v
      break
    end
  end
  if self.data then
    self.contentLabel.text = OverSea.LangManager.Instance():GetLangByKey(self.data.Describe)
    for i = 1, 3 do
      self.listGroupItems[i]:SetData(self.data.Reward[i])
    end
  else
    redlog("error Table_Evaluation have no menuId ", self.menuId)
  end
  if BranchMgr.IsJapan() then
    ServiceNUserAutoProxy:CallEvaluationReward(self.menuId)
  end
end

function RecommendScoreView:AddEvent()
  self:AddClickEvent(self.leftBut, function(go)
    self:LeftButClick()
  end)
  self:AddClickEvent(self.rightBtn, function(go)
    self:RightButClick()
  end)
  self:AddClickEvent(self.closeBut, function(go)
    self:CloseButClick()
  end)
  EventManager.Me():AddEventListener(AppStateEvent.Pause, self.OpenUrlPause, self)
end

function RecommendScoreView:LeftButClick()
  self.butnClick = true
  AppBundleConfig.JumpToAppTeasing()
end

function RecommendScoreView:RightButClick()
  self.butnClick = true
  AppBundleConfig.JumpToAppReview()
end

function RecommendScoreView:CloseButClick()
  EventManager.Me():RemoveEventListener(AppStateEvent.Pause, self.OpenUrlPause, self)
  self.butnClick = false
  if Game.MapManager:IsRaidMode(true) then
    UIManagerProxy.Instance:ActiveLayer(UIViewType.FloatLayer, true)
  end
  RecommendScoreView.super.CloseSelf(self)
end

function RecommendScoreView:OpenUrlPause(node)
  if node.data == false and self.butnClick == true then
    if not BranchMgr.IsJapan() then
      ServiceNUserAutoProxy:CallEvaluationReward(self.menuId)
    end
    self:CloseButClick()
  end
end

function RecommendScoreView:Is_include(value, tab)
  for k, v in pairs(tab) do
    if v == value then
      return true
    end
  end
  return false
end
