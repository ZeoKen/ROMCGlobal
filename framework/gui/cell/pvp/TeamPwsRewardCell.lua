autoImport("ItemData")
autoImport("ColliderItemCell")
TeamPwsRewardCell = class("TeamPwsRewardCell", BaseCell)

function TeamPwsRewardCell:Init()
  self:FindObjs()
end

function TeamPwsRewardCell:FindObjs()
  self.labName = self:FindComponent("labName", UILabel)
  self.labDesc = self:FindComponent("labDesc", UILabel)
  self.sprLevel = self:FindComponent("sprLevel", UISprite)
  self.objRewardsParent = self:FindGO("Rewards")
  self.listRewards = UIGridListCtrl.new(self:FindComponent("Rewards", UIGrid), ColliderItemCell, "ColliderItemCell")
  self.listRewards:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
end

function TeamPwsRewardCell:SetData(data)
  self.gameObject:SetActive(data and true or false)
  if not data then
    return
  end
  self.labName.text = data.NameZh
  self.labDesc.text = data.Desc
  IconManager:SetUIIcon(data.Icon, self.sprLevel)
  if not data.Items then
    return
  end
  local itemList = {}
  for i = 1, #data.Items do
    local item = ItemData.new(nil, data.Items[i])
    itemList[#itemList + 1] = item
  end
  self.listRewards:ResetDatas(itemList)
  local cells = self.listRewards:GetCells()
  for k, v in pairs(cells) do
    v:SetMinDepth(15)
    v:ReScaleSelf(0.7)
  end
  local upPanel = UIUtil.GetComponentInParents(self.gameObject, UIPanel)
  if upPanel then
    local depth = upPanel.depth
    local panels = UIUtil.GetAllComponentsInChildren(self.gameObject, UIPanel, true)
    for i = 1, #panels do
      panels[i].depth = panels[i].depth + upPanel.depth
    end
  end
end

function TeamPwsRewardCell:ClickItem(item)
  self:PassEvent(MouseEvent.MouseClick, item)
end
