CommonTabListCell = class("CommonTabListCell", CoreView)

function CommonTabListCell:ctor(obj)
  CommonTabListCell.super.ctor(self, obj)
  self:Init()
end

function CommonTabListCell:Init()
  self.toggle = self:FindGO("Tog"):GetComponent(UIToggle)
  if not self.toggle then
    self.toggle = self.gameObject:GetComponent(UIToggle)
  end
  self.longPress = self.gameObject:GetComponent(UILongPress)
  self.sp = self:FindComponent("Icon", UISprite)
  self.checkmarkSp = self:FindComponent("CheckmarkSp", UISprite)
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function CommonTabListCell:SetData(data)
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  self:SetIndex(data.index)
  self:SetName(data.name)
  self:SetIcon(data.icon or data.iconName or data.iconname)
end

function CommonTabListCell:SetIndex(index)
  self.index = tonumber(index) or -1
end

function CommonTabListCell:SetName(name)
  if StringUtil.IsEmpty(name) then
    return
  end
  self.gameObject.name = tostring(name) or self.__cname
end

function CommonTabListCell:SetIcon(iconName, tabType)
  IconManager:SetUIIcon(iconName, self.sp)
  IconManager:SetUIIcon(iconName, self.checkmarkSp)
  self.sp:MakePixelPerfect()
  self.checkmarkSp:MakePixelPerfect()
end
