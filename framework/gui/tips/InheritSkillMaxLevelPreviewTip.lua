autoImport("BaseTip")
InheritSkillMaxLevelPreviewTip = class("InheritSkillMaxLevelPreviewTip", BaseTip)

function InheritSkillMaxLevelPreviewTip:Init()
  self:FindObjs()
end

function InheritSkillMaxLevelPreviewTip:FindObjs()
  self.levelLabel = self:FindComponent("Level", UILabel)
  self.descLabel = self:FindComponent("Desc", UILabel)
end

function InheritSkillMaxLevelPreviewTip:SetData(data)
  if data then
    self.levelLabel.text = string.format(ZhString.InheritSkill_MaxLevelPreview, data.maxLevel)
    self.descLabel.text = data.desc
  end
end
