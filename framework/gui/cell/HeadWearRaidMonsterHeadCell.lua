local BaseCell = autoImport("BaseCell")
HeadWearRaidMonsterHeadCell = class("HeadWearRaidMonsterHeadCell", BaseCell)

function HeadWearRaidMonsterHeadCell:Init()
  self:InitCell()
end

function HeadWearRaidMonsterHeadCell:InitCell()
  self.icon = self:FindComponent("HeadIcon", UISprite)
  self.symbol = self:FindComponent("Symbol", UISprite)
end

function HeadWearRaidMonsterHeadCell:SetData(data)
  self.data = data
  if Table_Monster[self.data] then
    local StaticData = Table_Monster[self.data]
    IconManager:SetFaceIcon(StaticData.Icon, self.icon)
    if StaticData.Type == "Monster" then
      self:Hide(self.symbol)
    else
      self:Show(self.symbol)
      if StaticData.Type == "MVP" then
        self.symbol.spriteName = "ui_HP_1"
      elseif StaticData.Type == "MINI" then
        self.symbol.spriteName = "ui_HP_2"
      end
    end
  end
end
