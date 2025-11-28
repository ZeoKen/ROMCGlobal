local baseCell = autoImport("BaseCell")
AdventureAppendTipCell = class("AdventureAppendTipCell", baseCell)

function AdventureAppendTipCell:Init()
  AdventureAppendTipCell.super.Init(self)
  self:FindObjs()
end

function AdventureAppendTipCell:FindObjs()
  self.bg = self:FindComponent("Bg", UISprite)
  self.descLab = self:FindComponent("Desc", UILabel)
  self.indexLab = self:FindComponent("Index", UILabel)
  self.completeGO = self:FindGO("Complete")
  self.normalGrid = self:FindGO("normalGrid"):GetComponent(UIGrid)
  self.rewardList = UIGridListCtrl.new(self.normalGrid, AdventureAppendRewardCell, "AdventureAppendRewardCell")
end

function AdventureAppendTipCell:SetData(data)
  self.data = data
  if data then
    self.rewardList:ResetDatas(data:getRewardItems())
    self.descLab.text = data:getProcessInfo()
    self.indexLab.text = data.index or ""
    self.completeGO:SetActive(data.finish and true or false)
    local bound = NGUIMath.CalculateRelativeWidgetBounds(self.normalGrid.transform, true)
    self.bg.height = bound.size.y + 72
  end
end
