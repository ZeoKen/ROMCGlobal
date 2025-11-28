local BaseCell = autoImport("BaseCell")
WildMvpDropCombineCell = class("WildMvpDropCombineCell", BaseCell)
autoImport("WildMvpDropCardCell")

function WildMvpDropCombineCell:Init()
  self.tagGO = self:FindGO("Tag")
  self.tagLabel = self:FindGO("Label", self.tagGO):GetComponent(UILabel)
  self.grid = self:FindGO("Grid"):GetComponent(UIGrid)
  self.cardCellCtrl = UIGridListCtrl.new(self.grid, WildMvpDropCardCell, "WildMvp/WildMvpDropCardCell")
  self.cardCellCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickCardCell, self)
end

function WildMvpDropCombineCell:SetData(data)
  self.data = data
  local groupid = data and data.groupid
  local cardList = data and data.cardList
  self.tagLabel.text = GameConfig.StormBoss and GameConfig.StormBoss.CardRewardGroupName and GameConfig.StormBoss.CardRewardGroupName[groupid] or "???"
  self.cardCellCtrl:ResetDatas(cardList)
end

function WildMvpDropCombineCell:handleClickCardCell(cell)
  self:PassEvent(MouseEvent.MouseClick, cell)
end
