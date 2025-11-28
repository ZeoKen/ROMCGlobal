autoImport("TeamPwsRewardCell")
TripleTeamPwsRewardCell = class("TripleTeamPwsRewardCell", TeamPwsRewardCell)

function TripleTeamPwsRewardCell:FindObjs()
  TripleTeamPwsRewardCell.super.FindObjs(self)
  self.iconDescLabel = self:FindComponent("iconDesc", UILabel)
end

function TripleTeamPwsRewardCell:SetData(data)
  self.data = data
  if data then
    self.labName.text = data.NameZh
    self.labDesc.text = data.Desc
    IconManager:SetUIIcon(data.Icon, self.sprLevel)
    self.sprLevel:MakePixelPerfect()
    self.iconDescLabel.text = data.IconDesc
    local datas = ReusableTable.CreateArray()
    for i = 1, #data.Rewards do
      local id = data.Rewards[i].itemid
      local num = data.Rewards[i].num
      local item = ItemData.new(nil, id)
      item.num = num
      datas[#datas + 1] = item
    end
    self.listRewards:ResetDatas(datas)
    ReusableTable.DestroyArray(datas)
    local cells = self.listRewards:GetCells()
    for k, v in pairs(cells) do
      v:SetMinDepth(15)
      v:ReScaleSelf(0.9)
    end
    local upPanel = UIUtil.GetComponentInParents(self.gameObject, UIPanel)
    if upPanel then
      local depth = upPanel.depth
      local panels = UIUtil.GetAllComponentsInChildren(self.gameObject, UIPanel, true)
      for i = 1, #panels do
        panels[i].depth = upPanel.depth + i
      end
    end
  end
end
