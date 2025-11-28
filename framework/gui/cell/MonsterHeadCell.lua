local BaseCell = autoImport("BaseCell")
MonsterHeadCell = class("MonsterHeadCell", BaseCell)

function MonsterHeadCell:Init()
  self:InitCell()
end

function MonsterHeadCell:InitCell()
  self.icon = self:FindComponent("HeadIcon", UISprite)
  self.symbol = self:FindComponent("Symbol", UISprite)
  self.nature = self:FindComponent("Nature", UISprite)
  self:AddCellClickEvent()
end

function MonsterHeadCell:SetData(data)
  self.data = data
  if data and type(data) == "table" then
    IconManager:SetFaceIcon(data.Icon, self.icon)
    if data.Type == "Monster" then
      self:Hide(self.symbol)
    else
      self:Show(self.symbol)
      if data.Type == "MVP" then
        self.symbol.spriteName = "ui_HP_1"
      elseif data.Type == "MINI" then
        self.symbol.spriteName = "ui_HP_2"
      end
    end
    if self.nature then
      if data.Nature and data.Nature ~= "" then
        self.nature.gameObject:SetActive(true)
        IconManager:SetUIIcon(data.Nature, self.nature)
      else
        self.nature.gameObject:SetActive(false)
      end
    end
  end
end
