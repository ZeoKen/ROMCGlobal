autoImport("BagCardCell")
EquipRecommendNewCardCell = class("EquipRecommendNewCardCell", BagCardCell)

function EquipRecommendNewCardCell:Init()
  EquipRecommendNewCardCell.super.Init(self)
  self:FindObjs()
  LuaGameObject.SetLocalScaleGO(self.gameObject, 0.9, 0.9, 1)
end

function EquipRecommendNewCardCell:FindObjs()
  self:AddCellClickEvent()
  self.widget = self.gameObject:GetComponent(UIWidget)
  self.frequencyLabel = self:FindComponent("frequency", UILabel)
end

function EquipRecommendNewCardCell:SetData(data)
  if data and data ~= BagItemEmptyType.Empty then
    EquipRecommendNewCardCell.super.SetData(self, data.itemData)
    if data.frequency > 0 then
      self.frequencyLabel.text = string.format("%d%%", data.frequency / 100)
    else
      self.frequencyLabel.text = ""
    end
  else
    EquipRecommendNewCardCell.super.SetData(self, data)
    self.frequencyLabel.text = ""
  end
end
