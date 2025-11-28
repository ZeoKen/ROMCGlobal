local baseCell = autoImport("BaseCell")
AdventureIndicatorCell = class("AdventureIndicatorCell", baseCell)

function AdventureIndicatorCell:Init()
  AdventureIndicatorCell.super.Init(self)
  self:initView()
end

local tempColor = LuaColor.White()

function AdventureIndicatorCell:initView()
  self.bg = self.gameObject:GetComponent(UISprite)
end

function AdventureIndicatorCell:SetData(data)
  if data.cur then
    LuaColor.Better_Set(tempColor, 1, 0.6705882352941176, 0.23921568627450981, 1)
    self.bg.color = tempColor
  else
    LuaColor.Better_Set(tempColor, 1, 1, 1, 1)
    self.bg.color = tempColor
  end
end
