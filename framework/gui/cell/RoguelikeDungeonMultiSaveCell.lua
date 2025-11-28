local _InsertArray = TableUtil.InsertArray
autoImport("RoguelikeDungeonSingleSaveCell")
autoImport("RoguelikeHeadIconCell")
RoguelikeDungeonMultiSaveCell = class("RoguelikeDungeonMultiSaveCell", RoguelikeDungeonSingleSaveCell)

function RoguelikeDungeonMultiSaveCell:Init()
  RoguelikeDungeonMultiSaveCell.super.Init(self)
  self.multiHeadParentObj = self:FindGO("MultiHead")
  self.multiHeadGrid = self:FindComponent("HeadGrid", UIGrid)
  self.headListCtrl = UIGridListCtrl.new(self.multiHeadGrid, RoguelikeHeadIconCell, "RoguelikeHeadIconCell")
  self.headListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnHeadCellClick, self)
end

function RoguelikeDungeonMultiSaveCell:SetData(data)
  RoguelikeDungeonMultiSaveCell.super.SetData(self, data)
  if not self.isAvailable then
    return
  end
  local headDatas = {}
  _InsertArray(headDatas, data.users)
  _InsertArray(headDatas, data.robots)
  self.headListCtrl:ResetDatas(headDatas)
  local cells = self.headListCtrl:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    cell:SetIndex(i)
    cell:SetScale(1)
    cell:SetMinDepth(3)
  end
end

function RoguelikeDungeonMultiSaveCell:SetShowGrid(isShow)
  RoguelikeDungeonMultiSaveCell.super.SetShowGrid(self, isShow)
  self.multiHeadParentObj:SetActive(isShow)
end

function RoguelikeDungeonMultiSaveCell:ClickHead(cell)
  self:PassEvent(RoguelikeEvent.ShowPlayerTip, {
    saveDataIndex = self.index,
    headIndex = cell.index,
    headCell = cell
  })
end

function RoguelikeDungeonMultiSaveCell:OnHeadCellClick(cell)
  self:ClickHead(cell)
end
