local baseCell = autoImport("BaseCell")
SkillTipItemCostCell = class("SkillTipItemCostCell", baseCell)

function SkillTipItemCostCell:Init()
  self:FindObjs()
end

function SkillTipItemCostCell:FindObjs()
  self.sprIcon = self:FindComponent("Icon", UISprite)
  self.labNum = self:FindComponent("labNum", UILabel)
end

function SkillTipItemCostCell:SetData(data)
  self.data = data
  self.id = data and data.id
  local isActive = self.data ~= nil
  if self.isActive ~= isActive then
    self.isActive = isActive
    self.gameObject:SetActive(isActive)
  end
  if not isActive then
    return
  end
  local itemSData = Table_Item[self.id]
  if not itemSData or not IconManager:SetItemIcon(itemSData.Icon, self.sprIcon) then
    IconManager:SetItemIcon("item_45001", self.sprIcon)
  end
  self.labNum.text = self.data.count
  self.currentItemNum = HappyShopProxy.Instance:GetItemNum(self.id)
  self:ResetUsableItemNum(self.currentItemNum)
end

function SkillTipItemCostCell:ResetUsableItemNum(num)
  if self.data and num < self.data.count then
    self.labNum.color = LuaGeometry.GetTempColor(1, 0, 0, 1)
  else
    self.labNum.color = LuaGeometry.GetTempColor(0, 0, 0, 1)
  end
end
