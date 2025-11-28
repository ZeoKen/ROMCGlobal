local BaseCell = autoImport("BaseCell")
DisneyHappyPointRewardCell = class("DisneyHappyPointRewardCell", BaseCell)

function DisneyHappyPointRewardCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function DisneyHappyPointRewardCell:FindObjs()
  self.itemCell = self:FindGO("ItemCell")
  self.itemCell_Widget = self.itemCell:GetComponent(UIWidget)
  self.itemIcon = self:FindGO("Icon", self.itemCell):GetComponent(UISprite)
  self.itemCount = self:FindGO("Count", self.itemCell):GetComponent(UILabel)
  self.itemHighLight = self:FindGO("HighLight", self.itemCell)
  self.processLabel = self:FindGO("ProcessLabel"):GetComponent(UILabel)
  self.finishSymbol = self:FindGO("Finish")
  self.processSlider = self:FindGO("Slider"):GetComponent(UISlider)
end

function DisneyHappyPointRewardCell:SetData(data)
  xdlog("奖励cell", data.lastProcess, data.process)
  self.data = data
  local curProcess = DisneyProxy.Instance.allServerHappyValue or 0
  local value
  if curProcess <= data.lastProcess then
    value = 0
  elseif curProcess >= data.process then
    value = 1
  else
    value = (curProcess - data.lastProcess) / (data.process - data.lastProcess)
  end
  self.processSlider.value = value
  self.processLabel.text = data.process
  if data.canGet and value == 1 then
    self.itemHighLight:SetActive(true)
    self.enableGetReward = true
  else
    self.itemHighLight:SetActive(false)
    self.enableGetReward = false
  end
  self.finishSymbol:SetActive(not data.canGet)
  local alpha = data.canGet and 1 or 0.4
  self.itemCell_Widget.alpha = alpha
  local itemId = data.itemId
  local itemData = Table_Item[itemId]
  if not itemData then
    redlog("Item表缺少配置", itemId)
    return
  end
  IconManager:SetItemIcon(itemData.Icon, self.itemIcon)
end
