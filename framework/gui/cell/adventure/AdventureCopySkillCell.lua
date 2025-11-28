local BaseCell = autoImport("BaseCell")
AdventureCopySkillCell = class("AdventureCopySkillCell", BaseCell)

function AdventureCopySkillCell:Init()
  self:initView()
end

function AdventureCopySkillCell:initView()
  self.icon = self:FindComponent("Icon", UISprite)
  self.nameLabel = self:FindComponent("name", UILabel)
  self:AddClickEvent(self.icon.gameObject, function()
    TipManager.Instance:ShowSkillStickTip(self.data, self.icon, NGUIUtil.AnchorSide.Right, {200, 0})
  end)
end

function AdventureCopySkillCell:SetData(data)
  self.data = SkillItemData.new(data.id, nil, nil, nil, nil, nil, nil, nil, true)
  IconManager:SetSkillIcon(data.Icon, self.icon)
  self.nameLabel.text = data.NameZh
end
