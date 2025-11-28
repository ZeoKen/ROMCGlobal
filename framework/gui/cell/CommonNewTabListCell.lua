CommonNewTabListCell = class("CommonNewTabListCell", CoreView)
local tabColorConfig = {
  [1] = {
    "NewUI7",
    "new_bag_btn_select",
    true
  },
  [2] = {
    "NewUI9",
    "anying_page_bg",
    false
  }
}

function CommonNewTabListCell:ctor(obj)
  CommonNewTabListCell.super.ctor(self, obj)
  self:Init()
end

function CommonNewTabListCell:Init()
  self.toggle = self:FindGO("Sprite"):GetComponent(UIToggle)
  if not self.toggle then
    self.toggle = self.gameObject:GetComponent(UIToggle)
  end
  self.longPress = self.gameObject:GetComponent(UILongPress)
  self.sp = self:FindComponent("Sprite", UISprite)
  self.checkmarkSp = self:FindComponent("Checkmark", UISprite)
  self.shadowSp = self:FindComponent("Shadow", UISprite)
  self.checkmardBgSp = self:FindComponent("CheckmarkBg", UISprite)
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function CommonNewTabListCell:SetData(data)
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  self:SetIndex(data.index)
  self:SetName(data.name)
  self:SetIcon(data.icon or data.iconName or data.iconname)
end

function CommonNewTabListCell:SetIndex(index)
  self.index = tonumber(index) or -1
end

function CommonNewTabListCell:SetName(name)
  if StringUtil.IsEmpty(name) then
    return
  end
  self.gameObject.name = tostring(name) or self.__cname
end

function CommonNewTabListCell:SetIcon(iconName, tabType)
  IconManager:SetUIIcon(iconName, self.sp)
  IconManager:SetUIIcon(iconName, self.checkmarkSp)
  local tabConfig = tabType and tabColorConfig[tabType] or nil
  if tabConfig then
    local spriteNameStr = tabConfig[2]
    local atlasStr = tabConfig[1]
    local showShadow = tabConfig[3]
    local atlas = RO.AtlasMap.GetAtlas(atlasStr)
    if atlas then
      self.checkmardBgSp.atlas = atlas
      self.checkmardBgSp.spriteName = spriteNameStr
    end
    if self.shadowSp then
      self.shadowSp.gameObject:SetActive(showShadow)
    end
  end
  self.sp:MakePixelPerfect()
  self.checkmarkSp:MakePixelPerfect()
  if self.shadowSp then
    IconManager:SetUIIcon(iconName, self.shadowSp)
    self.shadowSp:MakePixelPerfect()
  end
end
