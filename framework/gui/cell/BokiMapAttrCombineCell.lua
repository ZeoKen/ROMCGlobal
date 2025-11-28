autoImport("BokiMapAttrCell")
local baseCell = autoImport("BaseCell")
BokiMapAttrCombineCell = class("BokiMapAttrCombineCell", baseCell)
BokiMapAttrCombineCell.ClickTag = "BokiMapAttrCombineCell_ClickTag"

function BokiMapAttrCombineCell:Init()
  self.isActive = true
  self:FindObjs()
  self:AddEvents()
  self.attrCtl = UIGridListCtrl.new(self.gridCells, BokiMapAttrCell, "BokiMapAttrCell")
  self.attrCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChoosenPetCell, self)
end

function BokiMapAttrCombineCell:Reposition()
  self.gridCells:Reposition()
end

function BokiMapAttrCombineCell:FindObjs()
  self.objCellsRoot = self:FindGO("CellsRoot")
  self.gridCells = self.objCellsRoot:GetComponent(UIGrid)
  self.objTag = self:FindGO("Tag")
  self.labTagName = self:FindComponent("labTagName", UILabel, self.objTag)
  self.labTagName.text = ZhString.Boki_MapAttrTabName
  self.objBtnSwitchFold = self:FindGO("BtnSwitchFold", self.objTag)
  self.tsfBtnSwitchHoldArrow = self:FindGO("sprIconFold", self.objBtnSwitchFold).transform
end

function BokiMapAttrCombineCell:AddEvents()
  self:AddClickEvent(self.objBtnSwitchFold, function()
    self:OnClickBtnSwitchFold()
  end)
end

function BokiMapAttrCombineCell:SetData(data)
  self.data = data
  if not data then
    return
  end
  self.attrCtl:ResetDatas(data)
end

local tempVector3 = LuaVector3.Zero()
local tempRot = LuaQuaternion()

function BokiMapAttrCombineCell:OnClickBtnSwitchFold(btn)
  self.objCellsRoot:SetActive(not self.objCellsRoot.activeSelf)
  local rotation_z = self.objCellsRoot.activeSelf and 90 or -90
  tempVector3[3] = rotation_z
  LuaQuaternion.Better_SetEulerAngles(tempRot, tempVector3)
  self.objBtnSwitchFold.transform.localRotation = tempRot
  self:PassEvent(BokiMapAttrCombineCell.ClickTag, self)
end

function BokiMapAttrCombineCell:OnCellDestroy()
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
