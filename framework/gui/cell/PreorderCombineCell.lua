autoImport("PreorderPreviewCell")
local baseCell = autoImport("BaseCell")
PreorderCombineCell = class("PreorderCombineCell", baseCell)

function PreorderCombineCell:Init()
  self.childNum = self.gameObject.transform.childCount
  self:FindObjs()
end

function PreorderCombineCell:FindObjs()
  self.childrenObjs = {}
  local go
  for i = 1, self.childNum do
    go = self:FindChild("child" .. i)
    self.childrenObjs[i] = PreorderPreviewCell.new(go)
  end
end

function PreorderCombineCell:AddEventListener(eventType, handler, handlerOwner)
  for i = 1, #self.childrenObjs do
    self.childrenObjs[i]:AddEventListener(eventType, handler, handlerOwner)
  end
end

function PreorderCombineCell:SetData(data)
  self.data = data
  self:UpdateInfo()
end

function PreorderCombineCell:GetDataByChildIndex(index)
  if self.data == nil then
    return nil
  else
    return self.data[index]
  end
end

function PreorderCombineCell:UpdateInfo()
  for i = 1, #self.childrenObjs do
    local cData = self:GetDataByChildIndex(i)
    local cell = self.childrenObjs[i]
    cell:SetData(cData)
    cell.gameObject:SetActive(cData ~= nil)
  end
end

function PreorderCombineCell:OnDestroy()
  for i = 1, #self.childrenObjs do
    local cell = self.childrenObjs[i]
    cell:OnDestroy()
  end
end
