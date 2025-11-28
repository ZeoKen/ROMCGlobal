autoImport("BaseCell")
PoemstoryLockCell = class("PoemstoryLockCell", BaseCell)

function PoemstoryLockCell:Init()
  self.storyname = self:FindGO("storyname"):GetComponent(UILabel)
  self.lockname = self:FindGO("lockname"):GetComponent(UILabel)
end

function PoemstoryLockCell:SetData(data)
  self.storyname.text = data.name
  self.lockname.text = data.QuestName
end
