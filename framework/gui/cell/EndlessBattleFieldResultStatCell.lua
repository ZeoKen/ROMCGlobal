EndlessBattleFieldResultStatCell = class("EndlessBattleFieldResultStatCell", BaseCell)
local DataEnum = {
  [1] = EndlessBattleFieldResultPopUp.SortType.Kill,
  [2] = EndlessBattleFieldResultPopUp.SortType.Death,
  [3] = EndlessBattleFieldResultPopUp.SortType.Help,
  [4] = EndlessBattleFieldResultPopUp.SortType.PvpDamage,
  [5] = EndlessBattleFieldResultPopUp.SortType.PveDamage,
  [6] = EndlessBattleFieldResultPopUp.SortType.Heal
}

function EndlessBattleFieldResultStatCell:Init()
  self:FindObjs()
end

function EndlessBattleFieldResultStatCell:FindObjs()
  self.grid = self:FindComponent("Grid", UIGrid)
  self.dataLabels = {}
  for i = 1, 6 do
    local dataLabel = self:FindComponent("Data" .. i, UILabel)
    self.dataLabels[i] = dataLabel
  end
  self.dragScrollView = self.gameObject:GetComponent(UIDragScrollView)
end

function EndlessBattleFieldResultStatCell:SetData(data)
  self.data = data
  if data then
    for i = 1, #self.dataLabels do
      local dataLabel = self.dataLabels[i]
      dataLabel.text = data[DataEnum[i]]
    end
  end
end
