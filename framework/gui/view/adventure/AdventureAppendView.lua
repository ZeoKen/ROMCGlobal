AdventureAppendView = class("AdventureAppendView", SubView)
autoImport("AdventureAppendRewardCell")

function AdventureAppendView:Init()
  self:initView()
end

function AdventureAppendView:initView()
  local normalGrid = self:FindGO("normalGrid"):GetComponent(UIGrid)
  self.rewardList = UIGridListCtrl.new(normalGrid, AdventureAppendRewardCell, "AdventureAppendRewardCell")
  self.appendTarget = self:FindGO("appendTarget"):GetComponent(UILabel)
  self.appendTargetDes = self:FindGO("appendTargetDes"):GetComponent(UILabel)
  self.dotLine = self:FindGO("Sprite")
end

function AdventureAppendView:SetRewardCellPrefab(prefabName)
  local normalGrid = self:FindGO("normalGrid"):GetComponent(UIGrid)
  self.rewardList = UIGridListCtrl.new(normalGrid, AdventureAppendRewardCell, prefabName)
end

function AdventureAppendView:SetData(data, forceShowReward)
  self.data = data
  if self.data then
    if data:IsProcessOverflow() and not forceShowReward then
      self.appendTarget.text = ZhString.AdventureAppendRewardPanel_KillCount
      self.appendTargetDes.text = string.format(ZhString.AdventureAppendRewardPanel_TotalKillCount, data.process)
      self.rewardList:ResetDatas()
      self.dotLine:SetActive(false)
    else
      self.rewardList:ResetDatas(data:getRewardItems())
      self.appendTarget.text = ZhString.AdventureAppendRewardPanel_AppendTarget
      self.appendTargetDes.text = data:getProcessInfo()
      self.dotLine:SetActive(true)
    end
  end
end
