AdventureAppendRewardPanel = class("AdventureAppendRewardPanel", ContainerView)
autoImport("AdventureAppendView")
AdventureAppendRewardPanel.ViewType = UIViewType.PopUpLayer

function AdventureAppendRewardPanel:Init()
  self:initView()
  self:initData()
  self:addViewEventListener()
end

function AdventureAppendRewardPanel:initData()
  self.appendView:SetData(self.viewdata.viewdata, true)
end

function AdventureAppendRewardPanel:initView()
  self.appendView = AdventureAppendView.new(self)
  self.appendView:SetRewardCellPrefab("AdventureAppendRewardLongCell")
  local rewardLabel = self:FindGO("rewardLabel"):GetComponent(UILabel)
  rewardLabel.text = ZhString.AdventureAppendRewardPanel_Reward
end

function AdventureAppendRewardPanel:addViewEventListener()
  self:AddButtonEvent("rewardBtn", function(obj)
    if self.appendView.data then
      ServiceSceneManualProxy.Instance:CallGetQuestReward(self.appendView.data.staticId)
      if self.appendView.data.appendName ~= nil then
        PetAdventureProxy.Instance:SetIllustratedRewardNameData(self.appendView.data.appendName)
      end
    end
    self:CloseSelf()
  end)
end
