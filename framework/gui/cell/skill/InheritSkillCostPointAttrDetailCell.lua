InheritSkillCostPointAttrDetailCell = class("InheritSkillCostPointAttrDetailCell", BaseCell)

function InheritSkillCostPointAttrDetailCell:Init()
  self:FindObjs()
end

function InheritSkillCostPointAttrDetailCell:FindObjs()
  self.nameLabel = self:FindComponent("Name", UILabel)
  self.curValueLabel = self:FindComponent("CurValue", UILabel)
  self.nextValueLabel = self:FindComponent("NextValue", UILabel)
end

function InheritSkillCostPointAttrDetailCell:SetData(data)
  self.data = data
  if data then
    self.nameLabel.text = data.name
    self.curValueLabel.text = data.curValue
    self.nextValueLabel.gameObject:SetActive(data.nextValue ~= nil)
    if data.nextValue then
      self.nextValueLabel.text = data.nextValue
    end
    local x, y, z = LuaGameObject.GetLocalPositionGO(self.curValueLabel.gameObject)
    x = data.nextValue and -59 or 48
    LuaGameObject.SetLocalPositionGO(self.curValueLabel.gameObject, x, y, z)
  end
end
