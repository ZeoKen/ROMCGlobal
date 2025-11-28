SkadaBossHeadCell = class("SkadaBossHeadCell", BaseCell)

function SkadaBossHeadCell:Init()
  self:FindObjs()
end

function SkadaBossHeadCell:FindObjs()
  self.natureIcon = self:FindComponent("natureIcon", UISprite)
  self.icon = self:FindComponent("Icon", UISprite)
  self.select = self:FindGO("Select")
  self:AddCellClickEvent()
end

function SkadaBossHeadCell:SetData(data)
  self.monsterId = data
  local config = Table_Monster[data]
  if config then
    IconManager:SetUIIcon(config.Nature, self.natureIcon)
    IconManager:SetFaceIcon(config.Icon, self.icon)
  end
end

function SkadaBossHeadCell:SetSelect(select)
  self.select:SetActive(select or false)
end
