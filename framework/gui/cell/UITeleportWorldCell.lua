local baseCell = autoImport("BaseCell")
UITeleportWorldCell = class("UITeleportWorldCell", baseCell)

function UITeleportWorldCell:Init()
  self.labName = self:FindGO("Name"):GetComponent(UILabel)
  self.icon = self:FindGO("WorldIcon"):GetComponent(UITexture)
  self.worldIcon = self:FindGO("WorldIcon"):GetComponent(UISprite)
  self.iconNode = self:FindGO("IconNode"):GetComponent(UITexture)
  self:AddCellClickEvent()
end

function UITeleportWorldCell:SetData(data)
  self.data = data
  self.id = data.id
  self.labName.text = data.name
  self.worldIcon.spriteName = data.icon
  if AppBundleConfig.GetSDKLang() == "pt" then
    self.labName.text = self.labName.text:gsub("Área", ""):gsub(" ", "")
  end
end

function UITeleportWorldCell:SetChoose(bool)
  if bool then
    self.iconNode.color = LuaGeometry.GetTempVector4(1, 1, 1, 1)
  else
    self.iconNode.color = LuaGeometry.GetTempVector4(1, 1, 1, 0.5)
  end
end
