InheritSkillCostPointCell = class("InheritSkillCostPointCell", BaseCell)

function InheritSkillCostPointCell:Init()
  self:FindObjs()
end

function InheritSkillCostPointCell:FindObjs()
  self.sp = self.gameObject:GetComponent(UIMultiSprite)
  self.effectContainer = self:FindGO("effectContainer")
end

function InheritSkillCostPointCell:SetData(data)
  self.data = data
  if data then
    self.sp.CurrentState = data
    self.sp:MakePixelPerfect()
  end
end

function InheritSkillCostPointCell:PlayEffect(path)
  self:PlayUIEffect(path, self.effectContainer, true, nil, nil, 1)
end
