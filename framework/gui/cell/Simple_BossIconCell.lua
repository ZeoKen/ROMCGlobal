local BaseCell = autoImport("BaseCell")
Simple_BossIconCell = class("Simple_BossIconCell", BaseCell)

function Simple_BossIconCell:Init()
  self.state = self:FindGO("state")
  self.icon = self:FindComponent("Icon", UISprite)
  self:AddCellClickEvent()
end

function Simple_BossIconCell:SetData(data)
  self.data = data
  if data then
    local monsterId = data.bossid
    local monsterData = Table_Monster[monsterId]
    local headIcon = monsterData and monsterData.Icon
    if headIcon then
      IconManager:SetFaceIcon(headIcon, self.icon)
    end
    self.state:SetActive(data.isAlive == false)
  end
end
