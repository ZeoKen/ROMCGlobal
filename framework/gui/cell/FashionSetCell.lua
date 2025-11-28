local BaseCell = autoImport("BaseCell")
FashionSetCell = class("FashionSetCell", BaseCell)

function FashionSetCell:Init()
  FashionSetCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function FashionSetCell:FindObjs()
  self.label = self:FindGO("Label"):GetComponent(UILabel)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
end

function FashionSetCell:SetData(data)
end

function FashionSetCell:SetIndex(index)
  self.index = index
  self.label.text = index
end

function FashionSetCell:SetChoose(bool)
  self.chooseSymbol:SetActive(bool)
end
