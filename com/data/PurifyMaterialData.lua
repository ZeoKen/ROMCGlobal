PurifyMaterialData = class("PurifyMaterialData")

function PurifyMaterialData:ctor(data)
  self:Init()
  self:SetData(data)
end

function PurifyMaterialData:Init()
  self.itemid = 0
  self.itemNum = 0
end

function PurifyMaterialData:SetData(data)
  self.itemid = data.itemid
  self.itemNum = data.num
end
