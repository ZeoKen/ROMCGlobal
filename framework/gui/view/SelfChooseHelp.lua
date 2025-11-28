autoImport("MultiGeneralHelp")
SelfChooseHelp = class("SelfChooseHelp", MultiGeneralHelp)

function SelfChooseHelp:InitTip()
  SelfChooseHelp.super.InitTip(self)
  self.cellGrid = self:FindComponent("CellGrid", UIGrid)
end

function SelfChooseHelp:SetData(datas)
  if not datas then
    return
  end
  self.datas = datas
  self.toggleCtrl:ResetDatas(datas)
end

function SelfChooseHelp:SetCellDatas(cellDatas, cellClass, cellPrefabName)
  if cellDatas and cellClass and cellPrefabName then
    self.cellListCtrl = UIGridListCtrl.new(self.cellGrid, cellClass, cellPrefabName)
    self.cellListCtrl:ResetDatas(cellDatas)
  end
end

function SelfChooseHelp:SetToggle(index)
  self.toggleIndex = index
  local cells = self.toggleCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:SetActive(self.toggleIndex == i)
  end
  if self.datas[index].Desc then
    self.cellGrid.gameObject:SetActive(false)
    self.content.gameObject:SetActive(true)
    self.contentLabel:SetText(self.datas[index].Desc)
  else
    self.cellGrid.gameObject:SetActive(true)
    self.content.gameObject:SetActive(false)
  end
  self.contentScrollView:ResetPosition()
end
