FurnitureIconCell = class("FurnitureIconCell", BaseCell)

function FurnitureIconCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function FurnitureIconCell:FindObjs()
  self.sprFurnitureIcon = self.gameObject:GetComponent(UISprite)
  self.labFurnitureNum = self:FindComponent("labFurnitureNum", UILabel)
end

function FurnitureIconCell:SetData(data)
  local itemStaticData = data and Table_Item[data.item.id]
  self.data = data
  self.itemSData = itemStaticData
  local haveData = data ~= nil
  if self.isActive ~= haveData then
    self.gameObject:SetActive(haveData)
    self.isActive = haveData
  end
  if not haveData then
    return
  end
  local setSuc = IconManager:SetItemIcon(itemStaticData and itemStaticData.Icon, self.sprFurnitureIcon)
  self.gameObject:SetActive(setSuc == true)
  self.isActive = setSuc == true
  if setSuc then
    self.sprFurnitureIcon:MakePixelPerfect()
  end
  self.labFurnitureNum.text = data.num > 1 and "Ã—" .. data.num or ""
end
