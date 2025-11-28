autoImport("ItemNewCell")
autoImport("EquipChooseCell")
EquipChooseCell_Simple = class("EquipChooseCell_Simple", EquipChooseCell)
EquipChooseCell_Simple.CellControl = ItemNewCell

function EquipChooseCell_Simple:Init()
  self.itemCell = self.CellControl.new(self.gameObject)
  self.nameLab = self.itemCell.nameLab
  self.equipEd = self:FindGO("EquipEd")
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.invalidItemTip = self:FindGO("InvalidItemTip")
  self.favoriteTip = self:FindGO("FavoriteTip")
  self.itemIcon = self:FindGO("Item")
  self.itemIconWidget = self.itemIcon:GetComponent(UIWidget)
  self:AddClickEvent(self.itemIcon, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.personalArtifactUniqueEffect = self:FindGO("PersonalArtifactUniqueEffect")
  local longPress = self.itemIcon:AddComponent(UILongPress)
  longPress.pressTime = 0.5
  
  function longPress.pressEvent(obj, isPress)
    if isPress then
      self:PassEvent(EquipChooseCellEvent.ClickItemIcon, self)
    end
  end
end

function EquipChooseCell_Simple:CheckValid()
  if self.data == nil then
    return
  end
  if self.checkFunc then
    local otherTip
    self.isValid, otherTip = self.checkFunc(self.checkFuncParam, self.data)
    if self.isValid then
      self:SetShowChooseButton(true)
    else
      self:SetShowChooseButton(false)
    end
    if self.invalidItemTip then
      self.invalidItemTip:SetActive(not self.isValid)
    end
  else
    self:SetShowChooseButton(true)
    if self.invalidItemTip then
      self.invalidItemTip:SetActive(false)
    end
  end
end

function EquipChooseCell_Simple:SetItemIconChooseId(id)
  self.itemChooseId = id
  self:UpdateItemIconChoose()
end

function EquipChooseCell_Simple:UpdateItemIconChoose()
  if not self.itemChooseSymbol then
    return
  end
  self.itemChooseSymbol:SetActive(self.itemChooseId ~= nil and self.data ~= nil and self.data.id == self.itemChooseId)
end
