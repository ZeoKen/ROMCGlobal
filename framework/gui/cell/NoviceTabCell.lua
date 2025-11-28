local BaseCell = autoImport("BaseCell")
NoviceTabCell = class("NoviceTabCell", BaseCell)

function NoviceTabCell:Init()
  self:FindObj()
  self:AddUIEvents()
end

function NoviceTabCell:FindObj()
  self.icon = self:FindComponent("icon", UISprite)
  self.icon_m = self:FindComponent("icon/icon_mod", UISprite)
  self.iconHot = self:FindComponent("iconHot", UISprite)
  self.iconHot_m = self:FindComponent("iconHot/icon_mod", UISprite)
  self.selectGo = self:FindGO("select")
  self.name_s = self:FindComponent("name_select", UILabel)
  self.name_us = self:FindComponent("name_unselect", UILabel)
end

function NoviceTabCell:AddUIEvents()
  self:AddClickEvent(self.gameObject, function(go)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function NoviceTabCell:SetData(data)
  self.data = data
  local nameConfig = GameConfig.NoviceActivity.TabName
  local name = nameConfig and nameConfig[data.index]
  self.name_s.text = name or "???"
  self.name_us.text = name or "???"
  self:SetSelect(false)
end

function NoviceTabCell:SetSelect(isTrue)
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
