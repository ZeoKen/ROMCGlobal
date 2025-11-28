local baseView = autoImport("BaseView")
autoImport("GVGResultViewItem")
GVGResultView = class("GVGResultView", BaseView)
GVGResultView.ViewType = UIViewType.NormalLayer

function GVGResultView:Init()
  self:GetGameObjects()
  self:InitView()
  self:addViewEventListener()
  self:AddListenEvt(GVGEvent.GVG_FinalFightShutDown, self.CloseSelf)
end

function GVGResultView:InitView()
  local rewardInfo = self.viewdata.rewardInfo
  table.sort(rewardInfo, function(left, right)
    return left.rank < right.rank
  end)
  for i = 1, #self.resultItems do
    self.resultItems[i].gameObject:SetActive(rewardInfo[i] ~= nil)
    if rewardInfo[i] then
      self.resultItems[i]:SetData(rewardInfo[i])
    end
  end
  self.rewardGrid:Reposition()
  local go = self:LoadPreferb_ByFullPath(ResourcePathHelper.EffectUI("GVGDroiyan_EUI"), self:FindGO("Bg"))
  go.transform.localPosition = LuaGeometry.GetTempVector3(0, 52.1, 0)
end

function GVGResultView:addViewEventListener()
  self:AddButtonEvent("CloseButton", function()
    ServiceNUserProxy.Instance:ReturnToHomeCity()
    self.viewCenter:SetActive(false)
  end)
  self:AddButtonEvent("Details", function()
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "GVGDetailView"
    })
  end)
end

function GVGResultView:GetGameObjects()
  self.resultItems = {}
  local resultItemGo1 = self:FindGO("GuildResultViewItem1", self.gameObject)
  self.resultItems[1] = GVGResultViewItem.new(resultItemGo1)
  local resultItemGo2 = self:FindGO("GuildResultViewItem2", self.gameObject)
  self.resultItems[2] = GVGResultViewItem.new(resultItemGo2)
  local resultItemGo3 = self:FindGO("GuildResultViewItem3", self.gameObject)
  self.resultItems[3] = GVGResultViewItem.new(resultItemGo3)
  local resultItemGo4 = self:FindGO("GuildResultViewItem4", self.gameObject)
  self.resultItems[4] = GVGResultViewItem.new(resultItemGo4)
  self.viewCenter = self:FindGO("ResultViewCenter")
  self.rewardGrid = self:FindComponent("Sec2Fourth", UIGrid)
end
