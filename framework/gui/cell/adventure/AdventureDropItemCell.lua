autoImport("AdventureDropCell")
local BaseCell = autoImport("BaseCell")
AdventureDropItemCell = class("AdventureDropItemCell", BaseCell)

function AdventureDropItemCell:Init()
  self:initView()
end

function AdventureDropItemCell:initView()
  self.normalGrid = self:FindGO("normalGrid"):GetComponent(UIGrid)
  self.rewardList = UIGridListCtrl.new(self.normalGrid, AdventureDropCell, "AdventureMonsterDropCell")
  self.appendTarget = self:FindGO("appendTarget"):GetComponent(UILabel)
  self.appendTarget.text = ZhString.MonsterTip_DropTitle
  self.bg = self:FindComponent("bg", UISprite)
end

function AdventureDropItemCell:SetData(data)
  self.data = data
  self.rewardList:ResetDatas(data and data.itemDatas or {})
  local bound = NGUIMath.CalculateRelativeWidgetBounds(self.normalGrid.transform, true)
  local height = bound.size.y + 84
  self.bg.height = height
end
