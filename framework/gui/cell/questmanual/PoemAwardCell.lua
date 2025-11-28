local baseCell = autoImport("BaseCell")
PoemAwardCell = class("PoemAwardCell", baseCell)

function PoemAwardCell:Init()
  self:initView()
end

function PoemAwardCell:initView()
  self.awardIcon = self:FindComponent("awardIcon", UISprite)
  self.awardName = self:FindComponent("awardName", UILabel)
end

function PoemAwardCell:SetData(data)
  self.data = data
  local itemStaticData = Table_Item[data.id]
  IconManager:SetItemIcon(itemStaticData.Icon, self.awardIcon)
  if data.id == 300 or data.id == 400 then
    self.awardIcon.height = 31
    self.awardIcon.width = 31
  else
    self.awardIcon.height = 26
    self.awardIcon.width = 26
  end
  self.awardName.text = itemStaticData.NameZh .. " x " .. data.num
end
