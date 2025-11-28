PlayerRefluxItemCell = class("PlayerRefluxItemCell", BaseCell)

function PlayerRefluxItemCell:Init()
  self:FindOBJ()
end

function PlayerRefluxItemCell:FindOBJ()
  self.countLable = self:FindComponent("countLable", UILabel)
  self.icon_Sprite = self:FindComponent("Icon_Sprite", UISprite)
  self.selectToggle = self:FindGO("selectToggle")
  self.selectToggle:SetActive(false)
  self.bgBtn = self:FindGO("ItemBg")
  self:AddClickEvent(self.bgBtn, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function PlayerRefluxItemCell:SetData(_data)
  self.data = _data
  local itemConfig = self.data.Item
  if itemConfig then
    local itemId = itemConfig[1]
    local itemData = ItemData.new("PlayerRefluxItemCell", itemId)
    if itemData and itemData.staticData.Icon then
      IconManager:SetItemIcon(itemData.staticData.Icon, self.icon_Sprite)
    end
    self.data.itemData = itemData
    local num = itemConfig[2]
    self.countLable.text = num
  end
  if self.data.isGetReward then
    self.selectToggle:SetActive(true)
  else
    self.selectToggle:SetActive(false)
  end
end

function PlayerRefluxItemCell:RefeshCell(isGet)
  self.selectToggle:SetActive(isGet)
end
