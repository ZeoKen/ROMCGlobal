EndlessBattleFieldResultTitleCell = class("EndlessBattleFieldResultTitleCell", BaseCell)
local ArrowStr = {
  [EndlessBattleFieldResultPopUp.SortOrder.Ascend] = "↑",
  [EndlessBattleFieldResultPopUp.SortOrder.Descend] = "↓"
}

function EndlessBattleFieldResultTitleCell:Init()
  self:FindObjs()
end

function EndlessBattleFieldResultTitleCell:FindObjs()
  self:AddCellClickEvent()
  self.arrowLabel = self:FindComponent("Arrow", UILabel)
end

function EndlessBattleFieldResultTitleCell:SetData(data)
  self.type = data
end

function EndlessBattleFieldResultTitleCell:SwitchSortOrder(order)
  self.arrowLabel.gameObject:SetActive(order ~= nil)
  if order then
    self.arrowLabel.text = ArrowStr[order]
  end
end
