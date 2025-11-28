UserEquipRecommendAttrCell = class("UserEquipRecommendAttrCell", BaseCell)

function UserEquipRecommendAttrCell:Init()
  self:FindObjs()
end

function UserEquipRecommendAttrCell:FindObjs()
  self.nameLabel = self:FindComponent("name", UILabel)
  self.valueLabel = self:FindComponent("value", UILabel)
end

function UserEquipRecommendAttrCell:SetData(data)
  if data then
    local prop = data.prop
    local value = data.value
    if prop and value then
      self.nameLabel.text = prop.propVO.displayName
      if prop.propVO.IsClientPercent then
        value = string.format("%s%%", value * 100)
      else
        value = math.floor(value)
      end
      self.valueLabel.text = value
    end
  end
end
