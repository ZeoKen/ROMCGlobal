MountFashionToggleCell = class("MountFashionToggleCell", BaseCell)

function MountFashionToggleCell:Init()
  self:FindObjs()
end

function MountFashionToggleCell:FindObjs()
  self.icon = self:FindComponent("Icon", UISprite)
end

function MountFashionToggleCell:SetData(data)
  self.data = data
  local config = GameConfig.MountFashion.PartIcon[data.mountId]
  if config then
    self.icon.spriteName = config[data.category]
  end
  if data.mountId == 25229 and data.category == 1 then
    self:AddOrRemoveGuideId(self.gameObject, 535)
  end
end
