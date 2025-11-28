autoImport("HeadWearRaidMonsterHeadCell")
local baseCell = autoImport("BaseCell")
HeadWearRaidMonsterInfoCombineCell = class("HeadWearRaidMonsterInfoCombineCell", baseCell)

function HeadWearRaidMonsterInfoCombineCell:Init()
  self.childNum = self.gameObject.transform.childCount
  self:FindObjs()
end

function HeadWearRaidMonsterInfoCombineCell:FindObjs()
  self.childrenObjs = {}
  local go
  for i = 1, self.childNum do
    go = self:FindChild("child" .. i)
    self.childrenObjs[i] = HeadWearRaidMonsterHeadCell.new(go)
  end
end

function HeadWearRaidMonsterInfoCombineCell:AddEventListener(eventType, handler, handlerOwner)
  for i = 1, #self.childrenObjs do
    self.childrenObjs[i]:AddEventListener(eventType, handler, handlerOwner)
  end
end

function HeadWearRaidMonsterInfoCombineCell:SetData(data)
  self.data = data
  self:UpdateInfo()
end

function HeadWearRaidMonsterInfoCombineCell:GetDataByChildIndex(index)
  if self.data == nil then
    return nil
  elseif index == 1 then
    return self.data.first
  elseif index == 2 then
    return self.data.second
  end
end

function HeadWearRaidMonsterInfoCombineCell:UpdateInfo()
  for i = 1, #self.childrenObjs do
    local cData = self:GetDataByChildIndex(i)
    local cell = self.childrenObjs[i]
    cell.gameObject:SetActive(cData ~= 0)
    cell:SetData(cData)
  end
end
