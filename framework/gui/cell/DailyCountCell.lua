local baseCell = autoImport("BaseCell")
DailyCountCell = class("DailyCountCell", baseCell)
local normal = Color(1, 1, 1, 1)
local grey = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)

function DailyCountCell:Init()
  self:initView()
end

function DailyCountCell:initView()
  self.sprite = self.gameObject:GetComponent(UISprite)
  IconManager:SetItemIcon("item_500551", self.sprite)
end

function DailyCountCell:SetData(data)
  self.sprite.color = normal
  self.index = data.id
  self.active = data.active
  self:SetActive(self.active)
end

function DailyCountCell:SetActive(b)
  if b then
    self.sprite.color = normal
  else
    self.sprite.color = grey
  end
end
