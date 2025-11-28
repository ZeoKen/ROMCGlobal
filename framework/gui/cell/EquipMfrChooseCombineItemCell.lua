autoImport("EquipMfrChooseItemCell")
EquipMfrChooseCombineItemCell = class("EquipMfrChooseCombineItemCell", BaseCell)
EquipMfrChooseCombineItemCell.ClickArrow = "EquipMfrChooseCombineItemCell_ClickArrow"
local tempV3 = LuaVector3()
local tempRot = LuaQuaternion()

function EquipMfrChooseCombineItemCell:Init()
  self:FindObj()
  self:InitCell()
end

function EquipMfrChooseCombineItemCell:FindObj()
  self.tabRoot = self:FindGO("TabRoot")
  self.equipRoot = self:FindGO("EquipRoot")
  self.equipBg = self:FindComponent("EquipBg", UISprite)
  self.equipGrid = self.equipRoot:GetComponent(UIGrid)
  self.name = self:FindComponent("Name", UILabel)
  self.arrowObj = self:FindGO("Arrow")
  self.tabClickObj = self:FindGO("Bg")
end

function EquipMfrChooseCombineItemCell:InitCell()
  self.equipCtl = UIGridListCtrl.new(self.equipGrid, EquipMfrChooseItemCell, "EquipComposeItemCell")
  self.equipCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChoosenCell, self)
  self:AddClickEvent(self.tabClickObj, function(g)
    local tab = self.data.tab
    local active = EquipMakeProxy.Instance:SetCategoryActive(tab)
    tempV3[3] = active and -90 or 90
    LuaQuaternion.Better_SetEulerAngles(tempRot, tempV3)
    self.arrowObj.transform.localRotation = tempRot
    self:PassEvent(EquipMfrChooseCombineItemCell.ClickArrow, tab)
  end)
end

function EquipMfrChooseCombineItemCell:ClickChoosenCell(cellctl)
  if cellctl and cellctl.data then
    self:PassEvent(MouseEvent.MouseClick, cellctl)
  end
end

function EquipMfrChooseCombineItemCell:SetData(data)
  if data then
    if data.isTab then
      self:Show(self.tabRoot)
      self:Hide(self.equipRoot)
      self.name.text = data.tabName
      self:Hide(self.equipBg)
    else
      self:Hide(self.tabRoot)
      self:Show(self.equipRoot)
      self:Show(self.equipBg)
      self.equipCtl:ResetDatas(data.equipList)
    end
  else
    self:Hide(self.tabRoot)
    self:Hide(self.equipRoot)
    self:Hide(self.equipBg)
  end
  self.data = data
end

function EquipMfrChooseCombineItemCell:GetCells()
  return self.equipCtl:GetCells()
end

function EquipMfrChooseCombineItemCell:SetChooseId(chooseId)
  local cells = self:GetCells()
  for j = 1, #cells do
    cells[j]:SetChoose(chooseId)
  end
end
