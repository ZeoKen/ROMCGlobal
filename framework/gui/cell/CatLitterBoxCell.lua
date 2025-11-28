CatLitterBoxCell = class("CatLitterBoxCell", ItemCell)

function CatLitterBoxCell:Init()
  self.itemContainer = self:FindGO("ItemContainer")
  local obj = self:LoadPreferb("cell/ItemCell", self.itemContainer)
  obj.transform.localPosition = Vector3.zero
  CatLitterBoxCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function CatLitterBoxCell:FindObjs()
end

function CatLitterBoxCell:AddEvts()
  self:AddClickEvent(self.itemContainer, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function CatLitterBoxCell:SetData(data)
  self.data = data
  if data then
    local itemData = ItemData.new("CatLitterBox", data.id)
    if data.refinelv and itemData:IsEquip() then
      itemData.equipInfo:SetRefine(data.refinelv)
    end
    CatLitterBoxCell.super.SetData(self, itemData)
  end
end
