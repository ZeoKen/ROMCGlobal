local BaseCell = autoImport("BaseCell")
EvidenceToolCell = class("EvidenceToolCell", BaseCell)

function EvidenceToolCell:Init()
  EvidenceToolCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function EvidenceToolCell:FindObjs()
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
end

function EvidenceToolCell:SetData(data)
  self.id = data
  local staticData = Table_Item[self.id]
  local icon = staticData and staticData.Icon or ""
  local setSuc = IconManager:SetItemIcon(icon, self.icon)
  if not setSuc then
    IconManager:SetItemIcon("item_45001", self.icon)
  end
end

function EvidenceToolCell:AddEvts()
  self:AddCellClickEvent()
  self:AddPressEvent(self.gameObject, function(go, isPress)
    self:OnPressCell(go, isPress)
  end)
  self:AddDragEvent(self.gameObject, function(go, delta)
    self:OnDragCell(go, delta)
  end)
end

function EvidenceToolCell:OnPressCell(go, isPress)
  self.isPress = isPress
  self:PassEvent(MouseEvent.MousePress, self)
end

function EvidenceToolCell:OnDragCell(go, delta)
  self.delta = delta
  self:PassEvent(DragDropEvent.OnDrag, self)
end
