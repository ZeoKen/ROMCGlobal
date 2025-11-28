autoImport("LotteryMixItemCell")
local baseCell = autoImport("BaseCell")
LotteryMixCombineCell = class("LotteryMixCombineCell", baseCell)

function LotteryMixCombineCell:Init()
  self.childNum = self.gameObject.transform.childCount
  self:FindObjs()
end

function LotteryMixCombineCell:FindObjs()
  self.childrenObjs = {}
  local go
  for i = 1, self.childNum do
    go = self:FindChild("child" .. i)
    self.childrenObjs[i] = LotteryMixItemCell.new(go)
  end
end

function LotteryMixCombineCell:AddEventListener(eventType, handler, handlerOwner)
  for i = 1, #self.childrenObjs do
    self.childrenObjs[i]:AddEventListener(eventType, handler, handlerOwner)
  end
end

function LotteryMixCombineCell:SetData(data)
  self.data = data
  self:UpdateInfo()
end

function LotteryMixCombineCell:GetDataByChildIndex(index)
  if self.data == nil then
    return nil
  else
    return self.data[index]
  end
end

function LotteryMixCombineCell:UpdateInfo()
  for i = 1, #self.childrenObjs do
    local cData = self:GetDataByChildIndex(i)
    local cell = self.childrenObjs[i]
    cell:SetData(cData)
    cell.gameObject:SetActive(cData ~= nil)
  end
end
