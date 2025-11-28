local baseCell = autoImport("BaseCell")
SocialityTagCatalogCell = class("SocialityTagCatalogCell", baseCell)

function SocialityTagCatalogCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function SocialityTagCatalogCell:FindObjs()
  self.toggle = self.gameObject:GetComponent(UIToggle)
  self.label = self:FindGO("Label"):GetComponent(UILabel)
end

function SocialityTagCatalogCell:SetData(data)
  self.id = data
  local tagNameList = GameConfig.PlayerTagGroup and GameConfig.PlayerTagGroup.TagName
  if tagNameList then
    self.label.text = tagNameList[self.id] or "???"
  end
end

function SocialityTagCatalogCell:SetChoose(bool)
  self.toggle.value = bool
  self.label.color = bool and LuaGeometry.GetTempVector4(0.11764705882352941, 0.4392156862745098, 0.7137254901960784, 1) or LuaGeometry.GetTempVector4(0.3803921568627451, 0.3803921568627451, 0.3803921568627451, 1)
end

function SocialityTagCatalogCell:SetCount(count)
  local appendStr = "%s(%s)"
  local tagNameList = GameConfig.PlayerTagGroup and GameConfig.PlayerTagGroup.TagName
  if tagNameList then
    if count == 0 then
      self.label.text = tagNameList[self.id]
    else
      self.label.text = string.format(appendStr, tagNameList[self.id], count)
    end
  end
end
