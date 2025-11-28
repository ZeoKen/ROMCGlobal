autoImport("BagItemCell")
EquipRecommendNewEquipCell = class("EquipRecommendNewEquipCell", BagItemCell)

function EquipRecommendNewEquipCell:Init()
  EquipRecommendNewEquipCell.super.Init(self)
  self:FindObjs()
  LuaGameObject.SetLocalScaleGO(self.gameObject, 0.9, 0.9, 1)
end

function EquipRecommendNewEquipCell:FindObjs()
  self:AddCellClickEvent()
  self.widget = self.gameObject:GetComponent(UIWidget)
  self.frequencyLabel = self:FindComponent("frequency", UILabel)
end

function EquipRecommendNewEquipCell:SetData(data)
  if data and data ~= BagItemEmptyType.Empty then
    EquipRecommendNewEquipCell.super.SetData(self, data.itemData)
    self:SetInvalid(false)
    if data.frequency > 0 then
      self.frequencyLabel.text = string.format("%d%%", data.frequency / 100)
    else
      self.frequencyLabel.text = ""
    end
  else
    EquipRecommendNewEquipCell.super.SetData(self, data)
    self.frequencyLabel.text = ""
  end
end
