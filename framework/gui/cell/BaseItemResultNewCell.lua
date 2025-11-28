autoImport("ItemNewCell")
autoImport("BaseItemResultCell")
BaseItemResultNewCell = class("BaseItemResultNewCell", ItemNewCell)
BaseItemResultNewCell.ItemCellName = "ItemNewCell"

function BaseItemResultNewCell:Init()
  BaseItemResultCell.Init(self)
end

function BaseItemResultNewCell:SetData(data)
  BaseItemResultCell.SetData(self, data)
end
