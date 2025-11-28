autoImport("BagItemCell")
EquipMemoryItemCell = class("EquipMemoryItemCell", BagItemCell)

function EquipMemoryItemCell:Init()
  EquipMemoryItemCell.super.Init(self)
  self:AddCellLongPressEvent()
end

function EquipMemoryItemCell:AddCellLongPressEvent()
  local longPress = self.gameObject:GetComponent(UILongPress)
  if not longPress then
    return
  end
  
  function longPress.pressEvent(obj, state)
    if state then
      self:PassEvent(MouseEvent.LongPress, self)
    end
  end
end

function EquipMemoryItemCell:SetData(data)
  EquipMemoryItemCell.super.SetData(self, data)
  self.gameObject:SetActive(self.data ~= nil)
end
