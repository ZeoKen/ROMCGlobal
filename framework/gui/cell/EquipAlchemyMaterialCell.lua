autoImport("BaseItemCell")
EquipAlchemyMaterialCell = class("EquipAlchemyMaterialCell", BaseItemCell)
EquipAlchemyMaterialEvent = {
  Remove = "EquipAlchemyMaterialEvent_Remove",
  LongPress = "EquipAlchemyMaterialEvent_LongPress"
}

function EquipAlchemyMaterialCell:Init()
  self.itemCell = self:LoadPreferb_ByFullPath(ResourcePathHelper.UICell("ItemCell"), self.gameObject)
  EquipAlchemyMaterialCell.super.Init(self)
  self.remove = self:FindGO("Remove")
  self:AddClickEvent(self.remove, function(go)
    self:PassEvent(EquipAlchemyMaterialEvent.Remove, self)
  end)
  self:AddClickEvent(self.gameObject, function(go)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  local longPress = self.gameObject:GetComponent(UILongPress)
  
  function longPress.pressEvent(obj, state)
    self:PassEvent(EquipAlchemyMaterialEvent.LongPress, {self, state})
  end
end

function EquipAlchemyMaterialCell:SetData(data)
  local flag = data ~= nil
  if data and data ~= 0 then
    self.itemData = self.itemData or ItemData.new()
    self.itemData:ResetData("AlchemyMat", data)
    EquipAlchemyMakeCell.super.SetData(self, self.itemData)
    self.data = data
    self:UpdateNum()
    if self.itemCell then
      self.itemCell.gameObject:SetActive(true)
    end
    self.remove:SetActive(true)
  else
    if self.itemCell then
      self.itemCell.gameObject:SetActive(false)
    end
    self.remove:SetActive(false)
  end
end

function EquipAlchemyMaterialCell:SetChooseReference(reference)
  self.chooseReference = reference
  self:UpdateNum()
end

function EquipAlchemyMaterialCell:UpdateNum()
  self:UpdateNumLabel(self.chooseReference and self.chooseReference[self.data] or "")
end
