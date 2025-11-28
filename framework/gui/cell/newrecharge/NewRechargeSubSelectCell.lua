local BaseCell = autoImport("BaseCell")
NewRechargeSubSelectCell = class("NewRechargeSubSelectCell", BaseCell)

function NewRechargeSubSelectCell:Init()
  self:FindObj()
  self:AddUIEvents()
end

function NewRechargeSubSelectCell:FindObj()
  self.icon = self:FindComponent("icon", UISprite)
  self.icon_m = self:FindComponent("icon/icon_mod", UISprite)
  self.iconHot = self:FindComponent("iconHot", UISprite)
  self.iconHot_m = self:FindComponent("iconHot/icon_mod", UISprite)
  self.selectGo = self:FindGO("select")
  self.name_s = self:FindComponent("name_select", UILabel)
  self.name_us = self:FindComponent("name_unselect", UILabel)
end

function NewRechargeSubSelectCell:AddUIEvents()
  self:AddClickEvent(self.gameObject, function(go)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function NewRechargeSubSelectCell:SetData(data)
  self.data = data
  local isHot = self:isHot()
  self.iconHot.gameObject:SetActive(isHot)
  self.icon.gameObject:SetActive(not isHot)
  if not isHot then
    self.icon.spriteName = self.data.Icon
    self.icon_m.spriteName = self.data.Icon
    local atlas7 = RO.AtlasMap.GetAtlas("NewUI7")
    if atlas7:GetSprite(self.data.Icon) then
      self.icon.atlas = atlas7
      self.icon_m.atlas = atlas7
    else
      local atlas9 = RO.AtlasMap.GetAtlas("NewUI9")
      if atlas9:GetSprite(self.data.Icon) then
        self.icon.atlas = atlas9
        self.icon_m.atlas = atlas9
        self.icon:MakePixelPerfect()
        self.icon_m:MakePixelPerfect()
      end
    end
  end
  self.name_s.text = self.data.Name
  self.name_us.text = self.data.Name
  self:SetSelect(false)
end

function NewRechargeSubSelectCell:isHot()
  return self.data.tab == GameConfig.NewRecharge.TabDef.Hot
end

function NewRechargeSubSelectCell:SetSelect(isTrue)
  self.selectGo:SetActive(isTrue)
  self.name_s.gameObject:SetActive(isTrue)
  self.name_us.gameObject:SetActive(not isTrue)
  if isTrue then
    self.icon.color = LuaGeometry.GetTempColor(0.5568627450980392, 0.42745098039215684, 0.2784313725490196, 1)
    self.iconHot.color = LuaGeometry.GetTempColor(0.5568627450980392, 0.42745098039215684, 0.2784313725490196, 1)
  else
    self.icon.color = LuaGeometry.GetTempColor(0.9921568627450981, 0.9490196078431372, 0.8196078431372549, 1)
    self.iconHot.color = LuaGeometry.GetTempColor(0.9921568627450981, 0.9490196078431372, 0.8196078431372549, 1)
  end
end
