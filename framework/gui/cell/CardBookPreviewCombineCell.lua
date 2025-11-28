autoImport("PveDropItemCell")
CardBookPreviewCombineCell = class("CardBookPreviewCombineCell", BaseCell)
CardBookPreviewCombineCell.ClickArrow = "CardBookPreviewCombineCell_ClickArrow"
local tempV3 = LuaVector3()
local tempRot = LuaQuaternion()
local _defaultIcon = "item_45001"

function CardBookPreviewCombineCell:Init()
  self:FindObj()
  self:InitCell()
end

function CardBookPreviewCombineCell:FindObj()
  self.tabRoot = self:FindGO("TabRoot")
  self.equipRoot = self:FindGO("EquipRoot")
  self.equipGrid = self.equipRoot:GetComponent(UIGrid)
  self.name = self:FindComponent("Name", UILabel, self.tabRoot)
  self.arrowObj = self:FindGO("Arrow", self.tabRoot)
  self.tabClickObj = self:FindGO("Bg", self.tabRoot)
end

function CardBookPreviewCombineCell:InitCell()
  self.equipCtl = UIGridListCtrl.new(self.equipGrid, PveDropItemCell, "PveDropItemCell")
  self.equipCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChoosenCell, self)
  self.unfold = true
  self:AddClickEvent(self.tabClickObj, function(g)
    self:PassEvent(CardBookPreviewCombineCell.ClickArrow, self)
  end)
end

function CardBookPreviewCombineCell:OnCellDestroy()
  self.equipCtl:Destroy()
end

function CardBookPreviewCombineCell:ClickChoosenCell(cellctl)
  if cellctl and cellctl.data then
    self:PassEvent(MouseEvent.MouseClick, cellctl)
  end
end

function CardBookPreviewCombineCell:SetData(data)
  self.data = data
  if data.isTitle then
    self:Show(self.tabRoot)
    local n1 = GameConfig.Card.cardbook and GameConfig.Card.cardbook[data.class] or data.class
    local n2 = string.format(ZhString.CardBook_BookClassWeightPct, data.weight)
    self.name.text = n1 .. " " .. n2
    self:Hide(self.equipRoot)
    self:SetUnfold(self.data.unfold)
  else
    self:Hide(self.tabRoot)
    self:Show(self.equipRoot)
    self.equipCtl:ResetDatas(data.cards)
  end
end

function CardBookPreviewCombineCell:SetUnfold(unfold)
  if unfold ~= nil then
    self.unfold = unfold
  end
  tempV3[3] = self.unfold and 0 or 180
  LuaQuaternion.Better_SetEulerAngles(tempRot, tempV3)
  self.arrowObj.transform.localRotation = tempRot
end
