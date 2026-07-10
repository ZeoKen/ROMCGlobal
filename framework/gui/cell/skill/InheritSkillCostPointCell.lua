InheritSkillCostPointCell = class("InheritSkillCostPointCell", BaseCell)

function InheritSkillCostPointCell:Init()
  self:FindObjs()
end

function InheritSkillCostPointCell:FindObjs()
  self.leftSp = self:FindComponent("Left", UIMultiSprite)
  self.rightSp = self:FindComponent("Right", UIMultiSprite)
  self.effectContainer = self:FindGO("effectContainer")
end

function InheritSkillCostPointCell:SetData(data)
  self.data = data
  if data then
    self.leftSp.gameObject:SetActive(data.isLeftUnlock or data.isLeftLoad or false)
    self.rightSp.gameObject:SetActive(not data.isLock)
    self.leftSp.CurrentState = data.isLeftLoad and 1 or 0
    self.rightSp.CurrentState = data.isRightLoad and 2 or data.isRightUnlock and 1 or 0
  end
end

function InheritSkillCostPointCell:PlayEffect(path)
  self:PlayUIEffect(path, self.effectContainer, true, nil, nil, 1)
end
