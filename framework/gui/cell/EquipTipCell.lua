autoImport("ItemTipBaseCell")
autoImport("ItemNewCellForTips")
EquipTipCell = class("EquipTipCell", ItemTipBaseCell)

function EquipTipCell:Init()
  EquipTipCell.super.Init(self)
  self.cardUseBtn = self:FindGO("CardUseButton")
  self.cardUseBtn_Label = self:FindGO("Label", self.cardUseBtn):GetComponent(UILabel)
end

function EquipTipCell:InitItemCell(container)
  self:TryInitItemCell(container, "ItemNewCellForTips", ItemNewCellForTips)
end

function EquipTipCell:InitEvent()
  EquipTipCell.super.InitEvent(self)
  self:AddButtonEvent("CardUseButton", function(go)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function EquipTipCell:SetData(data)
  EquipTipCell.super.SetData(self, data)
  self.gameObject:SetActive(data ~= nil)
end

EquipTipCell_Memory = class("EquipTipCell_Memory", EquipTipCell)

function EquipTipCell_Memory:Init()
  EquipTipCell_Memory.super.Init(self)
  self.cardUseBtn_Label.text = ZhString.EquipMemory_Equip
end
