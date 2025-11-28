AstralPrayProCell = class("AstralPrayProCell", BaseCell)

function AstralPrayProCell:Init()
  self:FindObjs()
end

function AstralPrayProCell:FindObjs()
  self.proIcon = self:FindComponent("Icon", UISprite)
  self.colorBg = self:FindComponent("ColorBg", UISprite)
  self.proNameLabel = self:FindComponent("ProName", UILabel)
end

function AstralPrayProCell:SetData(data)
  if data then
    local proList = ProfessionProxy.GetProfList(data)
    local proId = proList[1]
    if proId and proId % 10 == 1 then
      proId = proList[2]
    end
    if proId then
      local config = Table_Class[proId]
      local iconName = config and config.icon
      IconManager:SetProfessionIcon(iconName, self.proIcon)
      local type = config and config.Type or ""
      local colorKey = "CareerIconBg" .. type
      if ColorUtil[colorKey] then
        self.colorBg.color = ColorUtil[colorKey]
      end
      self.proNameLabel.text = config and config.NameZh or ""
    end
  end
end
