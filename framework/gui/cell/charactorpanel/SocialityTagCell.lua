local baseCell = autoImport("BaseCell")
SocialityTagCell = class("SocialityTagCell", baseCell)

function SocialityTagCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function SocialityTagCell:FindObjs()
  self.togBG = self:FindGO("Bg"):GetComponent(UISprite)
  self.toggle = self.gameObject:GetComponent(UIToggle)
  self.tagLabel = self:FindGO("TagLabel"):GetComponent(UILabel)
  self.boxCollider = self.gameObject:GetComponent(BoxCollider)
end

function SocialityTagCell:SetData(data)
  self.id = data
  self.tagLabel.text = Table_PlayerTag and Table_PlayerTag[self.id].Name
  self.groupid = Table_PlayerTag and Table_PlayerTag[self.id].Group
end

function SocialityTagCell:SetChoose(bool)
  self.toggle.value = bool
end

function SocialityTagCell:SetStatus(enable)
  self.togBG.alpha = enable and 1 or 0.4
  self.tagLabel.color = enable and LuaColor.Black() or LuaGeometry.GetTempVector4(0.38823529411764707, 0.38823529411764707, 0.38823529411764707, 1)
  self.boxCollider.enabled = enable
end
