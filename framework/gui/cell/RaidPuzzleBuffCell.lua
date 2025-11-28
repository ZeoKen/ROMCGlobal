local BaseCell = autoImport("BaseCell")
RaidPuzzleBuffCell = class("RaidPuzzleBuffCell", BaseCell)

function RaidPuzzleBuffCell:Init()
  self:FindObjs()
end

function RaidPuzzleBuffCell:FindObjs()
  self.indexLabel = self:FindGO("Index"):GetComponent(UILabel)
  self.label = self:FindGO("Label"):GetComponent(UILabel)
end

function RaidPuzzleBuffCell:SetData(data)
  self.data = data
  local index = self.indexInList
  if index then
    self.indexLabel.text = index .. "."
  end
  local buffInfo = Table_RaidPuzzleBuff[data]
  if buffInfo then
    self.label.text = buffInfo.BuffName
  end
end
