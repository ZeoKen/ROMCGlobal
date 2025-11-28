local BaseCell = autoImport("BaseCell")
RaidPuzzleInfoCell = class("RaidPuzzleInfoCell", BaseCell)

function RaidPuzzleInfoCell:Init()
  self:FindObjs()
end

function RaidPuzzleInfoCell:FindObjs()
  self.indexLabel = self:FindGO("Index"):GetComponent(UILabel)
  self.label = self:FindGO("Label"):GetComponent(UILabel)
end

function RaidPuzzleInfoCell:SetData(data)
  self.data = data
  local index = self.indexInList
  if index then
    self.indexLabel.text = index .. "."
  end
  self.label.text = data
end
