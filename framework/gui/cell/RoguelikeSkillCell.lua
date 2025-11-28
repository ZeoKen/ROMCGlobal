RoguelikeSkillCell = class("RoguelikeSkillCell", BaseCell)
RoguelikeSkillCell.Empty = "RoguelikeSkillCell_Empty"
local Offset = {0, 0}

function RoguelikeSkillCell:Init()
  self:FindObjs()
end

function RoguelikeSkillCell:FindObjs()
  self:AddClickEvent(self.gameObject, function()
    if self.data and self.data ~= RoguelikeSkillCell.Empty then
      TipManager.Instance:ShowRoguelikeSkillRemoveTip(self.data, self.widget, nil, Offset)
    end
  end)
  self.widget = self.gameObject:GetComponent(UIWidget)
  self.empty = self:FindGO("Empty")
  self.content = self:FindGO("Content")
  self.icon = self:FindComponent("Icon", UISprite)
  self.levelLabel = self:FindComponent("Level", UILabel)
  self.nameLabel = self:FindComponent("Name", UILabel)
  self:AddClickEvent(self.icon.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function RoguelikeSkillCell:SetData(data)
  self.data = data
  self.empty:SetActive(not data or data == RoguelikeSkillCell.Empty)
  self.content:SetActive(data ~= nil and data ~= RoguelikeSkillCell.Empty)
  if data and data ~= RoguelikeSkillCell.Empty then
    IconManager:SetSkillIcon(data:GetIcon(), self.icon)
    self.levelLabel.text = string.format("Lv.%d", data:GetLevel())
    self.nameLabel.text = data:GetName()
  end
end
