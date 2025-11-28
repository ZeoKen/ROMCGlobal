SpeedUpTypeCell = class("SpeedUpTypeCell", BaseCell)
local spriteNames = {
  [1] = "item_300",
  [2] = "item_400",
  [3] = "item_5670"
}
local iconScale = {
  [3] = 0.8
}

function SpeedUpTypeCell:Init()
  self:FindObjs()
  self:SetSelectState(false)
end

function SpeedUpTypeCell:FindObjs()
  self.sp = self.gameObject:GetComponent(UISprite)
  self.select = self:FindGO("select")
  self.ratioLabel = self:FindComponent("ratio", UILabel)
  self:AddCellClickEvent()
end

function SpeedUpTypeCell:SetData(data)
  self.data = data
  local total = MyselfProxy.Instance:GetSpeedUpTotalRatioByType(data)
  self.ratioLabel.text = total .. "%"
  IconManager:SetItemIcon(spriteNames[data], self.sp)
  local scale = iconScale[data] or 1
  self.sp.width = math.floor(self.sp.width * scale + 0.5)
  self.sp.height = math.floor(self.sp.height * scale + 0.5)
end

function SpeedUpTypeCell:SetSelectState(state)
  self.select:SetActive(state)
end
