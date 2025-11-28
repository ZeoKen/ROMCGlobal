local BaseCell = autoImport("BaseCell")
PartnerAreaCell = class("PartnerAreaCell", BaseCell)

function PartnerAreaCell:Init()
  self:FindObjs()
end

function PartnerAreaCell:FindObjs()
  self.icon = self.gameObject:GetComponent(UISprite)
end

function PartnerAreaCell:SetData(data)
  self.data = data
  self.areaId = data
  local config = GameConfig.Manor.DispatchFeatureIcon
  if config and config[self.areaId] then
    IconManager:SetUIIcon(config[self.areaId], self.icon)
    self.icon.color = LuaGeometry.GetTempVector4(0.39215686274509803, 0.3843137254901961, 0.5411764705882353, 1)
    self.icon.width = 35
    self.icon.height = 35
    self.gameObject.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  end
end
