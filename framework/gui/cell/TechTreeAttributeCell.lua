autoImport("SevenRoyalFamilyTreeAttrCell")
TechTreeAttributeCell = class("TechTreeAttributeCell", SevenRoyalFamilyTreeAttrCell)
TechTreeAttributeCellState = {Map = 0, Personal = 1}
local bg2SpriteNameMap = {
  [0] = "tree_bg_yellow",
  [1] = "tree_bg_blue"
}
local amountEffectColorMap = {
  [0] = LuaColor.New(1.0, 0.7529411764705882, 0),
  [1] = LuaColor.New(0.28627450980392155, 0.7254901960784313, 1.0)
}

function TechTreeAttributeCell:Init()
  TechTreeAttributeCell.super.Init(self)
  self.bg2 = self:FindComponent("Bg2", UISprite)
end

function TechTreeAttributeCell:SetData(data)
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  local state, value = data.state, data.value
  if not state then
    LogUtility.Error("Cannot decide state of TechTreeAttributeCell!")
    return
  end
  self.amount.text = value == nil and "" or (0 < value and "+" or "") .. (data.isPercent and value * 100 .. "%" or value)
  self.label.text = self:SubDesc(data.desc)
  self.bg2.spriteName = bg2SpriteNameMap[state]
  self.amount.effectColor = amountEffectColorMap[state]
end

function TechTreeAttributeCell:SubDesc(desc)
  local index = StringUtil.LastIndexOf(desc, "+")
  if index then
    return string.sub(desc, 1, index - 1)
  else
    return desc
  end
end
