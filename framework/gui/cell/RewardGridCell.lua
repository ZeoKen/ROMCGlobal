local BaseCell = autoImport("BaseCell")
RewardGridCell = class("RewardGridCell", BaseCell)

function RewardGridCell:Init()
  self:FindObjs()
end

function RewardGridCell:FindObjs()
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.count = self:FindGO("Num"):GetComponent(UILabel)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self:AddCellClickEvent()
  self.finishSymbol = self:FindGO("FinishSymbol")
end

function RewardGridCell:SetData(data)
  self.data = data
  local staticData = self.data.itemData.staticData
  if staticData then
    IconManager:SetItemIcon(staticData.Icon, self.icon)
  end
  local num = ""
  if self.data.num then
    num = self.data.num
  end
  self.count.text = num
end

function RewardGridCell:SetFinishStatus(bool)
  if self.finishSymbol then
    self.finishSymbol:SetActive(bool)
  end
  self.icon.alpha = bool and 0.5 or 1
end

function RewardGridCell:SetChooseStatus(bool)
  self.chooseSymbol:SetActive(bool)
end
