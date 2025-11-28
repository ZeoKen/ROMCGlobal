local baseCell = autoImport("BaseCell")
ClassPreviewTreeCell = class("ClassPreviewTreeCell", baseCell)

function ClassPreviewTreeCell:Init()
  self.grid = self:FindGO("Grid"):GetComponent(UIGrid)
  self.gridCtrl = UIGridListCtrl.new(self.grid, ClassPreviewCell, "ClassPreviewCell")
  self.gridCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickCell, self)
end

function ClassPreviewTreeCell:SetData(data)
  self.data = data
  local startID = data
  local classList = {}
  for i = 1, 5 do
    if Table_Class[startID] and Table_Class[startID].IsOpen ~= 0 then
      table.insert(classList, startID)
      if Table_Class[startID].AdvanceClass and #Table_Class[startID].AdvanceClass == 1 then
        startID = Table_Class[startID].AdvanceClass[1]
      else
        break
      end
    else
      break
    end
  end
  self.gridCtrl:ResetDatas(classList)
  local cells = self.gridCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:SetLine(self.indexInList)
  end
end

function ClassPreviewTreeCell:handleClickCell(cellCtrl)
  self:PassEvent(MouseEvent.MouseClick, cellCtrl)
end

function ClassPreviewTreeCell:CreateJobIconUnderThisGameObj(jobid, gameobj)
  table.insert(self.professionCellTable, ClassPreviewCell.CreateNew(jobid, gameobj))
end

function ClassPreviewTreeCell:GetCells()
  local cells = self.gridCtrl:GetCells()
  return cells
end
