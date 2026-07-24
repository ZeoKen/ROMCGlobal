SnowCrownCostItemCell = class("SnowCrownCostItemCell", ItemCell)

function SnowCrownCostItemCell:Init()
  SnowCrownCostItemCell.super.Init(self)
  self.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.95, 0.95, 0.95)
  self.deductionMaterialSp = self:FindComponent("DeductionMaterialTip", UISprite)
end

function SnowCrownCostItemCell:SetData(data)
  SnowCrownCostItemCell.super.SetData(self, data)
  self:SetDeductionMaterial(data and data.deduction)
end

function SnowCrownCostItemCell:SetDeductionMaterial(matId)
  if self.deductionMaterialSp then
    if matId then
      self.deductionMaterialSp.gameObject:SetActive(true)
      local itemSData = Table_Item[matId]
      if not IconManager:SetItemIcon(itemSData and itemSData.Icon, self.deductionMaterialSp) then
        local _ = IconManager:SetItemIcon("item_45001", self.deductionMaterialSp)
      end
    else
      self.deductionMaterialSp.gameObject:SetActive(false)
    end
  end
end
