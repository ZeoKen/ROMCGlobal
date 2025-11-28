EquipMemoryAttrCombineCell = class("EquipMemoryAttrCombineCell", BaseCell)
autoImport("EquipMemoryAttrCell")

function EquipMemoryAttrCombineCell:Init()
  self.grid = self:FindGO("Grid"):GetComponent(UIGrid)
  self.attrCtrl = UIGridListCtrl.new(self.grid, EquipMemoryAttrCell, "EquipMemoryAttrCell")
  self.chooseSymbol = self:FindGO("ChooseSymbol"):GetComponent(UISprite)
  self.bgWidget = self.gameObject:GetComponent(UIWidget)
  self:AddCellClickEvent()
end

function EquipMemoryAttrCombineCell:SetData(data)
  self.data = data
  self.attrCtrl:ResetDatas(data)
  local count = data and #data or 0
  self.chooseSymbol.height = 37 * count
  self.bgWidget.height = 37 * count
end

function EquipMemoryAttrCombineCell:SetChoose(bool)
  self.chooseSymbol.gameObject:SetActive(bool)
end
