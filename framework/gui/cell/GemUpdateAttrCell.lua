local _SpriteName = {
  [1] = "rune_bg_startag_01",
  [2] = "rune_bg_startag_select"
}
local padding = 10
GemUpdateAttrCell = class("GemUpdateAttrCell", BaseCell)

function GemUpdateAttrCell:Init()
  self.descLab = self:FindComponent("Desc", UILabel)
  self.bg = self:FindComponent("Bg", UISprite)
  self.star = self:FindComponent("Star", UISprite)
  self:SetEvent(self.descLab.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function GemUpdateAttrCell:SetData(data)
  self.data = data
  if data.goldStarCount > 0 then
    if data.paramId == 0 then
      self.descLab.text = string.format("%s%s", data.desc, ZhString.GemUpdateAttr_GoldStarActive)
    else
      self.descLab.text = data.desc
    end
    self.star.spriteName = "rune_icon_startag"
  else
    self.descLab.text = data.desc
    self.star.spriteName = "rune_icon_startag_0"
  end
  self.bg.height = self.descLab.height + padding
  self:SetSelected(false)
end

function GemUpdateAttrCell:SetSelected(selected)
  self.selected = selected
  self.bg.spriteName = self.selected and _SpriteName[2] or _SpriteName[1]
end
