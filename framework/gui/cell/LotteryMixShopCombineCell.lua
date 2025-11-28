autoImport("LotteryMixShopItemCell")
local baseCell = autoImport("BaseCell")
LotteryMixShopCombineCell = class("LotteryMixShopCombineCell", baseCell)

function LotteryMixShopCombineCell:Init()
  self.childNum = self.gameObject.transform.childCount
  self:FindObjs()
end

function LotteryMixShopCombineCell:FindObjs()
  self.childrenObjs = {}
  local go
  for i = 1, self.childNum do
    go = self:FindChild("child" .. i)
    self.childrenObjs[i] = LotteryMixShopItemCell.new(go)
  end
end

function LotteryMixShopCombineCell:AddEventListener(eventType, handler, handlerOwner)
  for i = 1, #self.childrenObjs do
    self.childrenObjs[i]:AddEventListener(eventType, handler, handlerOwner)
  end
end

function LotteryMixShopCombineCell:SetData(data)
  self.data = data
  self:UpdateInfo()
end

function LotteryMixShopCombineCell:GetDataByChildIndex(index)
  if self.data == nil then
    return nil
  else
    return self.data[index]
  end
end

function LotteryMixShopCombineCell:UpdateInfo()
  for i = 1, #self.childrenObjs do
    local cData = self:GetDataByChildIndex(i)
    local cell = self.childrenObjs[i]
    cell:SetData(cData)
    cell.gameObject:SetActive(cData ~= nil)
  end
end
