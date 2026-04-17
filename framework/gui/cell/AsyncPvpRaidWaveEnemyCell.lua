autoImport("HeadIconCell")
AsyncPvpRaidWaveEnemyCell = class("AsyncPvpRaidWaveEnemyCell", BaseCell)

function AsyncPvpRaidWaveEnemyCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function AsyncPvpRaidWaveEnemyCell:FindObjs()
  self.headerContainer = self:FindGO("HeadContainer")
  self.careerBg = self:FindGO("CareerBg")
  self.profession = self:FindComponent("ProfessionIcon", UISprite)
  self.colorIcon = self:FindComponent("Color", UISprite)
  self.headIcon = HeadIconCell.new()
  self.headIcon:CreateSelf(self.headerContainer)
  self.headIcon:SetScale(0.8)
  self.headIcon:SetMinDepth(1)
  self.headIcon:DisableBoxCollider(false)
end

function AsyncPvpRaidWaveEnemyCell:SetData(data)
  self.data = data
  if data then
    local profession = data.profession
    local config = Table_Class[profession]
    if config then
      IconManager:SetNewProfessionIcon(config.icon, self.profession)
      local colorKey = "CareerIconBg" .. config.Type
      self.colorIcon.color = ProfessionProxy.Instance:SafeGetColorFromColorUtil(colorKey)
    end
    self.headIcon:SetData(data.iconData)
  end
end
