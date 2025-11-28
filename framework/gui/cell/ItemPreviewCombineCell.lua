autoImport("PveDropItemCell")
ItemPreviewCombineCell = class("ItemPreviewCombineCell", BaseCell)
ItemPreviewCombineCell.ClickArrow = "ItemPreviewCombineCell_ClickArrow"
local tempV3 = LuaVector3()
local tempRot = LuaQuaternion()

function ItemPreviewCombineCell:Init()
  self:FindObj()
  self:InitCell()
end

function ItemPreviewCombineCell:FindObj()
  self.tabRoot = self:FindGO("TabRoot")
  self.equipRoot = self:FindGO("EquipRoot")
  self.equipBg = self:FindGO("EquipBg")
  self.equipGrid = self.equipRoot:GetComponent(UIGrid)
  self.name = self:FindComponent("Name", UILabel)
  self.arrowObj = self:FindGO("Arrow")
  self.tabClickObj = self:FindGO("Bg")
  self.tabClickObjSp = self.tabClickObj:GetComponent(UISprite)
  self.equipRootRect = self.equipRoot:GetComponent(UIWidget)
  self.go_DeductionMaterial = self:FindGO("DeductionMaterial")
  self.dm_A_iconSp = self:FindComponent("A_Icon", UISprite)
  self.dm_A_numLb = self:FindComponent("A_Num", UILabel)
  self.dm_B_iconSp = self:FindComponent("B_Icon", UISprite)
  self.dm_B_numLb = self:FindComponent("B_Num", UILabel)
end

function ItemPreviewCombineCell:InitCell()
  self.equipCtl = UIGridListCtrl.new(self.equipGrid, PveDropItemCell, "PveDropItemCell")
  self.equipCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChoosenCell, self)
  self.unfold = true
  self:AddClickEvent(self.tabClickObj, function(g)
    self:SetUnfold(not self.unfold)
    self:PassEvent(ItemPreviewCombineCell.ClickArrow, self)
  end)
end

function ItemPreviewCombineCell:ClickChoosenCell(cellctl)
  if cellctl and cellctl.data then
    self:PassEvent(MouseEvent.MouseClick, cellctl)
  end
end

function ItemPreviewCombineCell:SetData(data)
  self.go_DeductionMaterial:SetActive(data.type == "DeductionMaterial")
  self.arrowObj:SetActive(data.type ~= "DeductionMaterial")
  if data.type == "DeductionMaterial" then
    self:SetData_DeductionMaterial(data)
  elseif data.type == "OpenCardBook" then
    self:SetData_OpenCardBook(data)
  end
  self.data = data
  self:UpdateAnchors()
end

function ItemPreviewCombineCell:UpdateAnchors()
  self.equipRootRect:UpdateAnchors()
  self.tabClickObjSp:UpdateAnchors()
end

function ItemPreviewCombineCell:SetData_DeductionMaterial(data)
  self.name.width = 182
  local itemSData = Table_Item[data.Cost]
  local _ = IconManager:SetItemIcon(itemSData.Icon, self.dm_A_iconSp) or IconManager:SetItemIcon("item_45001", self.dm_A_iconSp)
  self.dm_A_numLb.text = data.CostNum
  itemSData = Table_Item[data.RepTarget]
  _ = IconManager:SetItemIcon(itemSData.Icon, self.dm_B_iconSp) or IconManager:SetItemIcon("item_45001", self.dm_B_iconSp)
  self.dm_B_numLb.text = data.TargetNum
  self.name.text = string.format("[c][2d2c47]%s[-][/c]", Table_DeductionMaterial[data.id].MvpInfo)
  self.equipCtl:ResetDatas(data.Targets)
end

function ItemPreviewCombineCell:SetData_OpenCardBook(data)
  self.name.width = 306
  local n1 = GameConfig.Card.cardbook and GameConfig.Card.cardbook[data.class] or data.class
  local n2 = string.format(ZhString.CardBook_BookClassWeightPct, data.weight)
  self.name.text = n1 .. " " .. n2
  self.equipCtl:ResetDatas(data.cards)
end

function ItemPreviewCombineCell:GetCells()
  return self.equipCtl:GetCells()
end

function ItemPreviewCombineCell:SetUnfold(unfold)
  if unfold ~= nil then
    self.unfold = unfold
  end
  tempV3[3] = self.unfold and 0 or 180
  LuaQuaternion.Better_SetEulerAngles(tempRot, tempV3)
  self.arrowObj.transform.localRotation = tempRot
  if self.unfold then
    self:Show(self.equipRoot)
    self:Show(self.equipBg)
  else
    self:Hide(self.equipRoot)
    self:Hide(self.equipBg)
  end
end
