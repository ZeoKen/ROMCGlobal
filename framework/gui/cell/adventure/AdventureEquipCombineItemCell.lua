local baseCell = autoImport("BaseCell")
AdventureEquipCombineItemCell = class("AdventureEquipCombineItemCell", baseCell)
autoImport("AdventrueItemCell")
autoImport("BagItemCell")
autoImport("AdventrueResearchItemCell")
local vecArrowFoldPos = LuaVector3(1.5, 1, 0)
local vecArrowOpenEuler = LuaVector3(0, 0, -90)

function AdventureEquipCombineItemCell:Init()
  self.isActive = true
  self:FindObjs()
  self:AddEvents()
  self:InitCells(5, "AdventrueResearchItemCell", AdventrueResearchItemCell)
end

function AdventureEquipCombineItemCell:InitCells(childNum, cellName, control)
  if not self.childCells then
    self.childCells = {}
  else
    TableUtility.ArrayClear(self.childCells)
  end
  local rid = ResourcePathHelper.UICell(cellName)
  for i = 1, childNum do
    local go = Game.AssetManager_UI:CreateAsset(rid, self.objCellsRoot)
    go.name = cellName .. i
    table.insert(self.childCells, control.new(go))
  end
  self:Reposition()
end

function AdventureEquipCombineItemCell:Reposition()
  self.gridCells:Reposition()
end

function AdventureEquipCombineItemCell:AddEventListener(eventType, handler, handlerOwner)
  self.super.AddEventListener(self, eventType, handler, handlerOwner)
  for k, v in pairs(self.childCells) do
    v:AddEventListener(eventType, handler, handlerOwner)
  end
end

function AdventureEquipCombineItemCell:FindObjs()
  self.objCellsRoot = self:FindGO("CellsRoot")
  self.gridCells = self.objCellsRoot:GetComponent(UIGrid)
  self.objTag = self:FindGO("Tag")
  self.labTagName = self:FindComponent("labTagName", UILabel, self.objTag)
  self.objBtnSwitchFold = self:FindGO("BtnSwitchFold", self.objTag)
  self.tsfBtnSwitchHoldArrow = self:FindGO("sprIconFold", self.objBtnSwitchFold).transform
end

function AdventureEquipCombineItemCell:GetCells()
  return self.childCells
end

function AdventureEquipCombineItemCell:AddEvents()
  self:AddClickEvent(self.objBtnSwitchFold, function()
    self:OnClickBtnSwitchFold()
  end)
end

function AdventureEquipCombineItemCell:SetData(data)
  local haveData = data ~= nil
  self.data = data
  if self.isActive ~= haveData then
    self.gameObject:SetActive(haveData)
    self.isActive = haveData
  end
  if not haveData then
    return
  end
  if self.isTag ~= data.isTag then
    self.isTag = data.isTag
    self.objCellsRoot:SetActive(not data.isTag)
    self.objTag:SetActive(data.isTag == true)
  end
  if data.isTag then
    self.id = data.id
    self.tsfBtnSwitchHoldArrow.localPosition = data.isOpen and LuaGeometry.Const_V3_zero or vecArrowFoldPos
    self.tsfBtnSwitchHoldArrow.localEulerAngles = data.isOpen and vecArrowOpenEuler or LuaGeometry.Const_V3_zero
    self:ReloadTagData()
  elseif self.childCells then
    for i = 1, #self.childCells do
      self.childCells[i]:SetData(self.data[i])
    end
  end
end

function AdventureEquipCombineItemCell:ReloadTagData()
  if not self.isTag or not self.isActive then
    return
  end
  if self.data and self.data.name then
    self.labTagName.text = self.data.name
  end
end

function AdventureEquipCombineItemCell:OnClickBtnSwitchFold(btn)
  if self.isTag then
    self:PassEvent(AdventureTagItemList.ClickFoldTag, self)
  end
end

function AdventureEquipCombineItemCell:OnCellDestroy()
  local cells = self:GetCells()
  if cells then
    for _, cell in pairs(cells) do
      if cell.OnCellDestroy and type(cell.OnCellDestroy) == "function" then
        cell:OnCellDestroy()
      end
      TableUtility.TableClear(cell)
    end
  end
end
