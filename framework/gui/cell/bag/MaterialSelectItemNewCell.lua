autoImport("BagItemNewCell")
autoImport("MaterialSelectItemCell")
MaterialSelectItemNewCell = class("MaterialSelectItemNewCell", BagItemNewCell)

function MaterialSelectItemNewCell:Init()
  MaterialSelectItemNewCell.super.Init(self)
  self:InitCell()
end

function MaterialSelectItemNewCell:InitCell()
  MaterialSelectItemCell.InitCell(self)
end

function MaterialSelectItemNewCell:SetData(data)
  MaterialSelectItemNewCell.super.SetData(self, data)
  self:_SetData(data)
end

function MaterialSelectItemNewCell:_SetData(data)
  MaterialSelectItemCell._SetData(self, data)
end

function MaterialSelectItemNewCell:SetSelectReference(reference)
  MaterialSelectItemCell.SetSelectReference(self, reference)
end

function MaterialSelectItemNewCell:UpdateSelect()
  MaterialSelectItemCell.UpdateSelect(self)
end

function MaterialSelectItemNewCell:UpdateSelectedCount()
  MaterialSelectItemCell.UpdateSelectedCount(self)
end

function MaterialSelectItemNewCell:TrySetShowDeselect(isShow)
  MaterialSelectItemCell.TrySetShowDeselect(self, isShow)
end

function MaterialSelectItemNewCell:UnShowInvalid()
  if self.invalid then
    self.invalid:SetActive(false)
  end
  self.invalid = nil
end
