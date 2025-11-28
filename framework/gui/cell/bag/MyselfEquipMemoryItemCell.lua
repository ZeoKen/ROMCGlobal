autoImport("MyselfEquipItemCell")
MyselfEquipMemoryItemCell = class("MyselfEquipMemoryItemCell", MyselfEquipItemCell)

function MyselfEquipMemoryItemCell:ctor(obj, index, isfashion, viceEquip, fromSaveData)
  MyselfEquipMemoryItemCell.super.ctor(self, obj, index, isfashion, viceEquip, fromSaveData)
  self.targetSymbol = self:FindGO("Target")
  if self.gameObject:GetComponent(UIDragItem) == nil then
    self.gameObject:AddComponent(UIDragItem)
  end
  self.dragDrop = DragDropCell.new(self.gameObject:GetComponent(UIDragItem), 0.3)
  self.dragDrop:SetDragEnable(false)
  
  function self.dragDrop.dragDropComponent.OnReplace(data)
    if data then
      local itemData = data.itemdata
      if itemData then
        xdlog(itemData.id)
      end
      xdlog("选择放在指定位置", self.index)
      ServiceItemProxy.Instance:CallMemoryEmbedItemCmd(itemData.id, self.index)
    end
  end
  
  function self.dragDrop.onManualStartDrag()
    xdlog("开始拖拽")
  end
  
  function self.dragDrop.onManualEndDrag()
    xdlog("结束拖拽")
  end
end

function MyselfEquipMemoryItemCell:SetData(data)
  MyselfEquipMemoryItemCell.super.super.SetData(self, data)
  self:UpdateMyselfInfo(data)
  self.siteStrenthenLv.text = ""
  if self.siteStrenthenLv2 then
    self.siteStrenthenLv2.text = ""
  end
  self:_resetViceEquipBg()
  self.siteUnlockSp:SetActive(not self:IsEffective())
end

function MyselfEquipMemoryItemCell:IsEffective()
  if self.data then
    local roleEquip = BagProxy.Instance:GetEquipBySite(self.index)
    if not roleEquip then
      return false
    end
  end
  return true
end

function MyselfEquipMemoryItemCell:ShowTarget(bool)
  self.targetSymbol:SetActive(bool)
end
