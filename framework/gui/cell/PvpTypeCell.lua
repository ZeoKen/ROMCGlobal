local baseCell = autoImport("BaseCell")
PvpTypeCell = class("PvpTypeCell", baseCell)

function PvpTypeCell:Init()
  self:FindObj()
  self:AddCellClickEvent()
end

function PvpTypeCell:FindObjs()
end

function PvpTypeCell:SetData(data)
end
