local baseCell = autoImport("BaseCell")
ClassPreviewCombineCell = class("ClassPreviewCombineCell", baseCell)
autoImport("ClassPreviewTreeCell")

function ClassPreviewCombineCell:Init()
  self.topClassNode = self:FindGO("TopClassNode")
  self.centerLine = self:FindGO("CenterLine")
  self.leftLine = self:FindGO("LeftLine")
  self.rightLine = self:FindGO("RightLine")
  self.classTreeGrid = self:FindGO("ClassTreeGrid"):GetComponent(UIGrid)
  self.treeGridCtrl = UIGridListCtrl.new(self.classTreeGrid, ClassPreviewTreeCell, "ClassPreviewTreeCell")
  self.treeGridCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickChild, self)
end

function ClassPreviewCombineCell:SetData(data)
  xdlog("Classid", data)
  self.originid = data
  self.professionCellTable = {}
  local classData = Table_Class[self.originid]
  if not self.mainClassCell then
    self.mainClassCell = ClassPreviewCell.CreateNew(self.originid, self.topClassNode)
    self.mainClassCell:ActiveLine(false)
    self.mainClassCell:AddEventListener(MouseEvent.MouseClick, self.handleClickChild, self)
  else
    self.mainClassCell:SetData(self.originid)
  end
  self.centerLine:SetActive(true)
  self.professionCellTable[self.originid] = self.mainClassCell
  local depth = ProfessionProxy.GetJobDepth(self.originid)
  local advanceClass = classData and classData.AdvanceClass
  if advanceClass then
    local advClass = {}
    if depth == 1 then
      for i = 1, #advanceClass do
        if Table_Class[advanceClass[i]] then
          TableUtility.ArrayPushBack(advClass, advanceClass[i])
        end
      end
    else
      TableUtility.ArrayPushBack(advClass, advanceClass[1])
    end
    if #advClass == 3 and TableUtility.ArrayFindIndex(ProfessionProxy.MultiSexJob1st, data) > 0 then
      advClass = self:GetRightUpgradeTableForMultiSexJob(data)
    end
    self.treeGridCtrl:ResetDatas(advClass)
    local cells = self.treeGridCtrl:GetCells()
    for i = 1, #cells do
      local innerCells = cells[i]:GetCells()
      for j = 1, #innerCells do
        self.professionCellTable[innerCells[j].data] = innerCells[j]
      end
    end
    local hideLine = #advClass == 1 and true or false
    self.leftLine:SetActive(not hideLine)
    self.rightLine:SetActive(not hideLine)
  end
end

function ClassPreviewCombineCell:handleClickChild(cellCtrl)
  xdlog("ClassPreviewCombineCell  handleClickChild")
  self:PassEvent(MouseEvent.MouseClick, cellCtrl)
end

function ClassPreviewCombineCell:CreateJobIconUnderThisGameObj(jobid, gameobj)
  table.insert(self.professionCellTable, ClassPreviewCell.CreateNew(jobid, gameobj))
end

function ClassPreviewCombineCell:GetRightUpgradeTableForMultiSexJob(prof1st)
  local rightTable = {}
  for k, v in pairs(Table_Class[prof1st].AdvanceClass) do
    if Table_Class[v] and Table_Class[v].gender ~= nil and Table_Class[v].gender ~= ProfessionProxy.Instance:GetCurSex() then
    else
      table.insert(rightTable, v)
    end
  end
  return rightTable
end

function ClassPreviewCombineCell:GetCells()
  return self.professionCellTable
end

function ClassPreviewCombineCell:OnCellDestroy()
  self.mainClassCell = nil
  self.professionCellTable = nil
end
