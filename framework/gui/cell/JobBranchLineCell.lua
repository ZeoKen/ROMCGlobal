autoImport("ProfessionIconCell")
JobBranchLineCell = class("JobBranchLineCell", BaseCell)

function JobBranchLineCell:Init()
  self.nodes = {}
  self:FindObjs()
end

function JobBranchLineCell:FindObjs()
  self.branchContainer = self:FindComponent("Container", UIWidget)
  for i = 1, 4 do
    self.nodes[i] = self:FindGO("Node" .. i)
  end
end

function JobBranchLineCell:SetData(data)
  local classId = data
  local index = 1
  while classId do
    local config = Table_Class[classId]
    if config then
      local iconCell = ProfessionIconCell.CreateNew(classId, self.nodes[index])
      iconCell:SetShowType(3)
      classId = config.AdvanceClass[1]
      index = index + 1
    end
  end
end

function JobBranchLineCell:SetBranchLineSelectState(isSelect)
  if isSelect then
    self.branchContainer.alpha = 1
  else
    self.branchContainer.alpha = 0.2
  end
end
