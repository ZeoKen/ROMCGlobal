local _SetLocalScaleObj = LuaGameObject.SetLocalScaleObj
GvgSymbol = class("GvgSymbol", CoreView)
GvgSymbol.Etype = {metal = 1, mvp = 2}

function GvgSymbol:ctor(obj)
  GvgSymbol.super.ctor(self, obj)
  self:FindObjs()
end

function GvgSymbol:FindObjs()
  self.icon = self.gameObject:GetComponent(UISprite)
  self.desc = self:FindComponent("Desc", UILabel)
end

function GvgSymbol:SetData(data)
  local symbol = data:GetParama("Symbol")
  local scale = data:GetParama("Scale") or 1
  self.icon.spriteName = symbol
  self.icon:MakePixelPerfect()
  self.gameObject.name = symbol
  if data.id == GvgSymbol.Etype.mvp then
    self:Show(self.desc)
    self.desc.text = ""
  else
    self:Hide(self.desc)
  end
  _SetLocalScaleObj(self.icon.gameObject, scale, scale, scale)
end
