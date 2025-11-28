autoImport("ItemNewCell")
autoImport("BaseItemCell")
BaseItemNewCell = class("BaseItemNewCell", ItemNewCell)

function BaseItemNewCell:Init()
  BaseItemCell.Init(self)
end

function BaseItemNewCell:SetData(data)
  BaseItemCell.SetData(self, data)
end

function BaseItemNewCell:GetCD()
  return BaseItemCell.GetCD(self)
end

function BaseItemNewCell:GetMaxCD()
  return BaseItemCell.GetMaxCD(self)
end

function BaseItemNewCell:RefreshCD(f)
  return BaseItemCell.RefreshCD(self, f)
end

function BaseItemNewCell:ClearCD()
  return BaseItemCell.ClearCD(self)
end
