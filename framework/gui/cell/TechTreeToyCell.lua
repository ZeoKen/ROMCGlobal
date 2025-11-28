TechTreeToyCell = class("TechTreeToyCell", CoreView)
local transparentColor = LuaColor.New(1, 1, 1, 0.4)

function TechTreeToyCell:ctor(obj)
  TechTreeToyCell.super.ctor(self, obj)
  self:Init()
end

function TechTreeToyCell:Init()
  local bg = self:FindComponent("Bg", UISprite)
  local iconBg = self:FindComponent("IconBg", UISprite)
  self.icon = self:FindComponent("Icon", UISprite)
  self.label = self:FindComponent("Label", UILabel)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.uiArray = {
    bg,
    iconBg,
    self.icon,
    self.label
  }
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self.data)
  end)
end

function TechTreeToyCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  local item = self.data.Output
  local itemSData = item and Table_Item[item]
  if not IconManager:SetItemIcon(itemSData and itemSData.Icon, self.icon) then
    IconManager:SetItemIcon("item_45001", self.icon)
  end
  self.label.text = itemSData and itemSData.NameZh .. ZhString.TechTree_ToyDrawingSuffix or ""
  self:UpdateUnlocked()
  self:UpdateChoose()
end

function TechTreeToyCell:SetChooseId(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function TechTreeToyCell:UpdateUnlocked()
  for _, ui in pairs(self.uiArray) do
    ui.color = TechTreeProxy.Instance:IsToyUnlocked(self.data and self.data.id) and ColorUtil.NGUIWhite or transparentColor
  end
end

function TechTreeToyCell:UpdateChoose()
  self.chooseSymbol:SetActive(self.chooseId and self.data and self.data.id == self.chooseId or false)
end
